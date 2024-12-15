<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="javabeans.PostEntity"%>
<%@ page import="java.util.ArrayList"%>

<jsp:useBean id="postdb" class="javabeans.PostDatabase" scope="page" />
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="./resource/community.css">
<meta charset=UTF-8">
<title>Insert title here</title>
</head>
<%
ArrayList<PostEntity> posts = new ArrayList<PostEntity>();

int postPageOffset = 0;
String searchKeyword = "";
String searchType = "";

if (request.getParameter("searchKeyword") != null) {
	searchKeyword = request.getParameter("searchKeyword");
}
if (request.getParameter("searchType") != null) {
	searchType = request.getParameter("searchType");
}

if (searchKeyword.equals("") || searchType.equals("")) {
	posts = postdb.getPostArray(postPageOffset, 0);
} else {
	posts = postdb.getPostArrayByKeyword(postPageOffset, searchKeyword, searchType, 0);
}

boolean isLoggedIn = false;
if (session != null && session.getAttribute("isLoggedIn") != null) {
	isLoggedIn = (boolean) session.getAttribute("isLoggedIn");
}

%>

<body>
	<jsp:include page="/include/nav.jsp"></jsp:include>
	<div id="current_post_page_number" data-post-page="<%=postPageOffset%>"
		style="display: none"></div>
	<div id="search_keyword" data-keyword="<%=searchKeyword%>"
		style="display: none"></div>
	<div id="saerch_type" data-searchtype="<%=searchType%>"
		style="display: none"></div>
	<section>
		<ul>
			<li><a href="createPost.jsp">글쓰기</a></li>
			<li><a href="community.jsp">일반글</a></li>
			<li><a href="popularPostsPage.jsp">인기글</a></li>
		</ul>
	</section>
	<ul class="post_container">
		<%
		for (PostEntity post : posts) {
		%>
		<li data-id="<%= post.getPostId() %>"><a href="postDetail.jsp?postId=<%=post.getPostId()%>">작성자:
				<%=post.getUserName()%>, 제목: <%=post.getPostName()%>, 조회수: <%=post.getViews()%>,
				좋아요: <%=post.getLikeCnt()%>, 싫어요: <%=post.getDisLikeCnt()%>, 작성일시: <%=post.getCreateDate()%>
		</a>
		<% if(isLoggedIn) { %>
		<button class="post_delete_btn">X</button>
		<% } %>
		</li>
		<%
		}
		%>
	</ul>
	<ul class="comment_page_btn">
		<li class="back_comment_page_btn comment_page_btn"><<</li>
		<li class="front_comment_page_btn comment_page_btn">>></li>
	</ul>
	<form method="GET" action="community.jsp">
		<select name="searchType" class="search_type">
			<option value="title" SELECTED>제목별</option>
			<option value="content">내용별</option>
			<option value="user">작성자별</option>
		</select> <label><input type="text" name="searchKeyword" /></label> <input
			type="text" style="display: none" value=0 />
		<button type="submit">검색</button>
	</form>
</body>
<script>
document.querySelectorAll(".comment_page_btn").forEach((item) => {
	item.addEventListener("click", (e) => {
		const currentPageNum = parseInt(document.querySelector("#current_post_page_number").dataset.postPage);
		const searchKeyword = document.querySelector("#search_keyword").dataset.keyword;
		const searchType = document.querySelector("#saerch_type").dataset.searchtype;
		const target = e.currentTarget;
		
		if(currentPageNum - 10 < 0) {
			return;
		}
		if (target.classList.contains("back_comment_page_btn")) {
			movePostPage(currentPageNum - 10, searchKeyword, searchType);
        } else if (target.classList.contains("front_comment_page_btn")) {
        	movePostPage(currentPageNum + 10, searchKeyword, searchType);
        }
		
	});
});
document.querySelector(".post_container").addEventListener("click", function(e) {
	const deleteBtn = e.target;
	if(deleteBtn.classList.contains("post_delete_btn")) {
		const postId = deleteBtn.parentNode.dataset.id;
		detetePostByAdmin(postId);
	}
})
let request = null;
//댓글등록 버튼 누르면. post로 ajax요청보냄.
function createRequest() {
	try {
		request = new XMLHttpRequest();
	} catch (failed) {
		request = null;
	}
	if (request == null)
		alert('Error creating request object!');
}
function detetePostByAdmin(postId) {
	createRequest();
	// ajax로 get요청을 보낼 시, 쿼리 스트링으로 정보 전달.
	let url = "deletePost.jsp?";
	let qry = "postId=" + encodeURIComponent(postId);
	request.open("POST", url, true);
	request.onreadystatechange = redirectCommunity;
	request.setRequestHeader("Content-type",
			"application/x-www-form-urlencoded");
	request.send(qry)
}
function deletePost(postId, userPw) {
	createRequest();
	// ajax로 get요청을 보낼 시, 쿼리 스트링으로 정보 전달.
	let url = "deletePost.jsp?";
	let qry = "userPw=" + encodeURIComponent(userPw) + "&postId=" + encodeURIComponent(postId);
	request.open("POST", url, true);
	request.onreadystatechange = redirectCommunity;
	request.setRequestHeader("Content-type",
			"application/x-www-form-urlencoded");
	request.send(qry)
}
function movePostPage(offset, searchKeyword, searchType) {
	createRequest();
	// ajax로 get요청을 보낼 시, 쿼리 스트링으로 정보 전달.
	let url = "movePostPage.jsp?";
	let qry = "offset=" + encodeURIComponent(offset)
	+ "&searchKeyword=" + encodeURIComponent(searchKeyword)
	+ "&searchType=" + encodeURIComponent(searchType);
	request.open("POST", url, true);
	request.onreadystatechange = updateMovePost;
	request.setRequestHeader("Content-type",
			"application/x-www-form-urlencoded");
	request.send(qry)
}
function updateMovePost() {
	// 요청에 성공 시, 진행.
	if (request.readyState == 4 && request.status == 200) {
		const response = JSON.parse(request.responseText);
		if (response.status === "success") {
			const postList = response.postList; 
			const pageNum = response.pageNum;
			if(postList == null || postList.length == 0) {
				return;
			}
			
			let postContainer = document.querySelector(".post_container");
			postContainer.innerHTML = "";
			
			postList.forEach((post) => {
				let htmlString = "<li><a href='postDetail.jsp?postId=" +
						post.postId + "'>작성자: " + post.userName + ", 제목: " + post.postName + ", 조회수: " + post.views + ", 좋아요: " + 
						post.likeCnt + ", 싫어요: " + post.disLikeCnt + ", 작성일시: " + post.createDate + "</a></li>"; 
				postContainer.insertAdjacentHTML("beforeend", htmlString);
			
			})
        	document.querySelector("#current_post_page_number").dataset.postPage = pageNum;
		} else {
			console.error(response.message); // 오류 메시지 출력
		}
	}
}
function redirectCommunity() {
	if (request.readyState == 4 && request.status == 200) {
		const response = JSON.parse(request.responseText);
		if (response.status === "error") {
			alert('삭제에 실패했습니다. 다시 시도해주세요.');
		} else {
			alert('삭제에 성공했습니다.');
			window.location.href = "community.jsp";
		}
	}
}
</script>
</html>