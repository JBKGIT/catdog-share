<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.util.ArrayList"%>
<%@ page import="javabeans.CommentEntity, javabeans.PostEntity"%>

<jsp:useBean id="commentdb" class="javabeans.CommentDatabase"
	scope="page" />
<jsp:useBean id="postdb" class="javabeans.PostDatabase" scope="page" />
<%
request.setCharacterEncoding("UTF-8");

String postId = request.getParameter("postId");
int commentPage = 0;

String orderType = "mostRecent"; // earliestFirst, mostLike 
if (request.getParameter("orderType") != null) {
	orderType = request.getParameter("orderType");
}

ArrayList<CommentEntity> commentList = commentdb.getCommentArray(postId, commentPage, orderType);
PostEntity post = postdb.getPost(postId);

boolean isViewed = false;
Cookie[] cookies = request.getCookies();

if (cookies != null) {
	for (Cookie cookie : cookies) {
		if (cookie.getName().equals("viewed_" + post.getPostId())) {
	isViewed = true;
	break;
		}
	}
}
if (!isViewed) {
	// 조회수 증가 처리
	postdb.updateViews(post.getPostId());

	// 쿠키 생성
	Cookie viewCookie = new Cookie("viewed_" + post.getPostId(), "true");
	viewCookie.setMaxAge(24 * 60 * 60); // 1시간 유지
	response.addCookie(viewCookie);
}
boolean isLoggedIn = false;
if (session != null && session.getAttribute("isLoggedIn") != null) {
	isLoggedIn = (boolean) session.getAttribute("isLoggedIn");
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
label {
	display: block;
}
</style>
<link rel="stylesheet" href="./resource/main.css">
<link rel="stylesheet" href="./resource/postDetail.css">
</head>
<body>
	<div id="post_id_info" data-post-id="<%=postId%>" style="display: none"></div>
	<div id="current_comment_page_number"
		data-comment-page="<%=commentPage%>" style="display: none"></div>
	<div id="comment_order_type" data-order-type="<%=orderType%>"
		style="display: none"></div>
	<jsp:include page="/include/nav.jsp"></jsp:include>
	<h1><%=post.getPostName()%></h1>
	<section class="post_content_container" data-id="<%=post.getPostId()%>">
		<p>
			작성자:
			<%=post.getUserName()%>
			조회수:
			<%=post.getViews()%></p>
		<button type="button" class="show_delete_btn">X</button>
		<span class="delete_container" style="display: none"> <label><input
				type="password" class="delete_pw" /></label>
			<button type="button" class="delete_btn">삭제</button>
		</span>
		<p><%=post.getPostContent()%></p>

		<button class="vote_btn like">
			추천(<%=post.getLikeCnt()%>)
		</button>
		<button class="vote_btn dislike">
			비추천(<%=post.getDisLikeCnt()%>)
		</button>
	</section>


	<form method="POST" action="sumbitComment.jsp" class="comment_form">
		<label>닉네임: <input type="text" class="user_name" /></label> <label>비밀번호:
			<input type="password" class="user_pw" />
		</label> <label>댓글: <textarea name="comment" rows="4" cols="50"
				class="comment" placeholder="Write your comment here..."></textarea></label>
		<button type="submit">등록</button>
	</form>

	<select class="order_type" name="orderType">
		<option value="mostRecent" SELECTED>최신순</option>
		<option value="earliestFirst">오래된순</option>
		<option value="mostLike">추천순</option>
	</select>
	<ul class="comment_container">
		<%
		for (int i = 0; i < commentList.size(); i++) {
		%>
		<li class="comment" data-id="<%=commentList.get(i).getCommentId()%>">
			<%=commentList.get(i).getUserName()%>: <%=commentList.get(i).getCommentContent()%>
			<%=commentList.get(i).getCreateDate()%>
			<button class="vote_btn like">
				추천(<%=commentList.get(i).getLikeCnt()%>)
			</button>
			<button class="vote_btn dislike">
				비추천(<%=commentList.get(i).getDisLikeCnt()%>)
			</button>
			<button type="button" class="show_delete_btn">X</button> <span
			class="delete_container" style="display: none"> <label><input
					type="password" class="delete_pw" /></label>
				<button type="button" class="delete_btn">삭제</button>
		</span>
		<% if (isLoggedIn) { %>
		<button class="admin_delete_btn">adminX</button>
		<% } %>
		</li>
		<%
		}
		%>
	</ul>
	<ul class="comment_page_btn" data-parentId="<%=postId%>">
		<li class="back_comment_page_btn comment_page_btn"><<</li>
		<li class="front_comment_page_btn comment_page_btn">>></li>
	</ul>
</body>
<script>
document.querySelector(".comment_form").addEventListener("submit",function(event) {
	event.preventDefault(); // 기본 폼 제출을 막음

	const userName = document.querySelector(".user_name").value;
	const userPw = document.querySelector(".user_pw").value;
	const comment = document.querySelector(".comment").value;
	const parentId = document.querySelector("#post_id_info").dataset.postId;
	
	document.querySelector(".user_name").value = "";
	document.querySelector(".user_pw").value = "";
	document.querySelector(".comment").value = "";
	
	if(userName == '' || userPw == '' || comment == '') {
		return;
	}
	saveComment(parentId, userName, userPw, comment);
}); // 한 번만 실행되도록 설정
document.querySelector(".order_type").addEventListener("change", function(event) {
    document.querySelector("#comment_order_type").dataset.orderType = event.target.value;
    document.querySelector("#current_comment_page_number").dataset.commentPage = 0;
    const parentId = document.querySelector("#post_id_info").dataset.postId;
    
    moveCommentPage(0, parentId, event.target.value);
});
document.querySelector(".post_content_container").addEventListener("click", showDeleteComment);
document.querySelector(".post_content_container").addEventListener("click", deletePostPorc);
// 여기에 쿠키 확인하는거 넣으면 될듯.
document.querySelector(".comment_container").addEventListener("click", voteProesss);
document.querySelector(".comment_container").addEventListener("click", showDeleteComment);
document.querySelector(".comment_container").addEventListener("click", adminDeleteComment);
document.querySelector(".comment_container").addEventListener("click", deleteCommentPorc);
document.querySelector(".post_content_container").addEventListener("click", voteProesss);
function voteProesss(e) {
    const targetBtn = e.target;
    // 클릭한 요소가 .vote_btn인지 확인
    if (targetBtn.classList.contains("vote_btn")) {
        const parentId = targetBtn.parentNode.dataset.id;
        const parentType = targetBtn.parentNode.classList; 

        let voteType = null;
        if (targetBtn.classList.contains("like")) {
            voteType = "like";
        } else if (targetBtn.classList.contains("dislike")) {
            voteType = "dislike";
        }

        if (voteType) {
            increamentVoteCnt(voteType, parentId); // 클릭한 버튼에 따라 처리
        }
    }
}
document.querySelectorAll(".comment_page_btn").forEach((item) => {
		item.addEventListener("click", (e) => {
		const currentPageNum = parseInt(document.querySelector("#current_comment_page_number").dataset.commentPage);
		const orderType = document.querySelector("#comment_order_type").dataset.orderType;
		const target = e.currentTarget;
		const parentId = target.parentNode.dataset.parentid;
		if(currentPageNum - 5 < 0) return;
		if (target.classList.contains("back_comment_page_btn")) {
			// 여기서도 뭐 ajax하면 될듯.
			moveCommentPage(currentPageNum - 5, parentId, orderType);
		} else if (target.classList.contains("front_comment_page_btn")) {
			moveCommentPage(currentPageNum + 5, parentId, orderType);
		}
	});
});
function adminDeleteComment(e) {
	const deleteBtn = e.target;
	if(deleteBtn.classList.contains("admin_delete_btn")) {
		const commentId = deleteBtn.parentNode.dataset.id;
		deleteCommentByAdmin(commentId);
	}
}
function showDeleteComment(e) {
	const targetBtn = e.target;
	if(targetBtn.classList.contains("show_delete_btn")) {
        const deleteContainer = targetBtn.nextElementSibling; // 형제 요소 선택
        if (deleteContainer) {
            // 현재 display 상태에 따라 토글
            deleteContainer.style.display = deleteContainer.style.display === "none" ? "inline" : "none";
        }
	}
}
function deleteCommentPorc(e) {
	const targetBtn = e.target;
	if(targetBtn.classList.contains("delete_btn")) {
	      // 현재 클릭한 버튼의 부모 요소 안에서 .delete_pw 찾기
        const deleteContainer = targetBtn.closest(".delete_container");
        if (deleteContainer) {
            const passwordInput = deleteContainer.querySelector(".delete_pw");
            const userPw = passwordInput.value; // 입력된 비밀번호 값 가져오기


            // 비밀번호가 비어 있으면 알림
            if (!userPw.trim()) {
                alert("비밀번호를 입력해주세요!");
                return;
            }

            // 이후의 삭제 로직 처리
			const commentElement = targetBtn.closest("li.comment"); // 가장 가까운 li.comment 찾기
        	const commentId = commentElement.dataset.id; // data-id 값 가져오기
        	deleteComment(commentId, userPw);
        }
	}
}
function deletePostPorc(e) {
	const targetBtn = e.target;
	if(targetBtn.classList.contains("delete_btn")) {
	      // 현재 클릭한 버튼의 부모 요소 안에서 .delete_pw 찾기
        const deleteContainer = targetBtn.closest(".delete_container");
        if (deleteContainer) {
            const passwordInput = deleteContainer.querySelector(".delete_pw");
            const userPw = passwordInput.value; // 입력된 비밀번호 값 가져오기
            // 비밀번호가 비어 있으면 알림
            if (!userPw.trim()) {
                alert("비밀번호를 입력해주세요!");
                return;
            }
            // 이후의 삭제 로직 처리
        	const postId = document.querySelector("#post_id_info").dataset.postId;
        	deletePost(postId, userPw);
        }
	}
}
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
function saveComment(parentId, userName, userPw, comment) {
	createRequest();
	// ajax로 get요청을 보낼 시, 쿼리 스트링으로 정보 전달.
	let url = "sumbitComment.jsp?";
	let qry = "userName=" + encodeURIComponent(userName) + "&userPw="
		+ encodeURIComponent(userPw) + "&comment="
		+ encodeURIComponent(comment) + "&parentId="
		+ encodeURIComponent(parentId);
	request.open("POST", url, true);
	request.onreadystatechange = updateComment;
	request.setRequestHeader("Content-type",
		"application/x-www-form-urlencoded");
	request.send(qry)
}
function deleteCommentByAdmin(commentId) {
	createRequest();
	// ajax로 get요청을 보낼 시, 쿼리 스트링으로 정보 전달.
	let url = "deleteComment.jsp?";
	let qry = "commentId=" + encodeURIComponent(commentId);
	request.open("POST", url, true);
	request.onreadystatechange = updateComment;
	request.setRequestHeader("Content-type",
			"application/x-www-form-urlencoded");
	request.send(qry)
}
function deleteComment(commentId, userPw) {
	createRequest();
	// ajax로 get요청을 보낼 시, 쿼리 스트링으로 정보 전달.
	let url = "deleteComment.jsp?";
	let qry = "userPw=" + encodeURIComponent(userPw) + "&commentId=" + encodeURIComponent(commentId);
	request.open("POST", url, true);
	request.onreadystatechange = updateComment;
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
function increamentVoteCnt(voteType, parentId) {
	createRequest();
	if(voteType === null) return;
	
	let url = "increaVoteCnt.jsp?";
	let qry = "voteType=" + encodeURIComponent(voteType) + "&parentId=" + encodeURIComponent(parentId);
	request.open("POST", url, true);
	request.onreadystatechange = updateVote;
	request.setRequestHeader("Content-type",
		"application/x-www-form-urlencoded");
	request.send(qry)
}

function moveCommentPage(offset, parentId, orderType) {
	createRequest();
	// ajax로 get요청을 보낼 시, 쿼리 스트링으로 정보 전달.
	let url = "moveCommentPage.jsp?";
	let qry = "offset=" + encodeURIComponent(offset) + "&parentId=" + encodeURIComponent(parentId) + "&orderType=" + encodeURIComponent(orderType);
	request.open("POST", url, true);
	request.onreadystatechange = updateMoveComment;
	request.setRequestHeader("Content-type",
		"application/x-www-form-urlencoded");
	request.send(qry)
}


function updateComment() {
	// 요청에 성공 시, 진행.
	if (request.readyState == 4 && request.status == 200) {
		const response = JSON.parse(request.responseText);
		if (response.status === "success") {
			const orderType = document.querySelector("#comment_order_type").dataset.orderType;
			const commentId = response.commentId;
			const userName = response.userName; // 서버에서 보낸 사용자 이름
			const comment = response.comment; // 서버에서 보낸 댓글 내용
			const currentTime = response.currentTime; // 서버에서 보낸 댓글 내용
		
			let commentContainer = document
					.querySelector(".comment_container");
			let htmlString = '<li class="comment" data-id="'  + commentId + '">'
			+ userName
			+ ": "
			+ comment
			+ " "
			+ currentTime
			+ "<button class='vote_btn like'>추천(0)</button><button class='vote_btn dislike'>비추천(0)</button>" +
			"<button type='button' class='show_delete_btn'>X</button> <span " + 
	        "class='delete_container' style='display: none'> <label><input " +
			"type='password' class='delete_pw' /></label>" +
			"<button type='button' class='delete_btn'>삭제</button>" +
			"</span>" +
			"</li>";
			let childCount = commentContainer.childElementCount;
			
			if(orderType === "mostRecent") {
				if(childCount >= 5) {
					commentContainer.removeChild(commentContainer.lastElementChild);
				}
				commentContainer.insertAdjacentHTML("afterbegin", htmlString);
			} else if(orderType === "earliestFirst" || orderType === "mostLike") {
				if(childCount < 5) {
					commentContainer.insertAdjacentHTML("beforeend", htmlString);
				}
			}
		}else if(response.status === "delete") {
			const commentId = response.commentId;
			const commentContainer = document.querySelector(".comment_container");
		    const commentElement = commentContainer.querySelector('li[data-id="' + commentId + '"]');
		    if (commentElement) {
		        commentElement.remove();
		    }
		}else {
			console.error(response.message); // 오류 메시지 출력
		}
	}
}
// 여기엔 쿠키 삽입
function updateVote() {
	// 요청에 성공 시, 진행.
	if (request.readyState == 4 && request.status == 200) {
		const response = JSON.parse(request.responseText);
		if (response.status === "success") {
			const parentId = response.parentId;
			const voteType = response.voteType; 
			const updatedVoteCnt = response.updatedVoteCnt;
			
			const option = "[data-id=" + '"' + parentId + '"' + "]"
			let entity = document.querySelector(option);
		
			if (voteType === 'like') {
			    // 자식 태그 중 'like_cnt' 클래스를 가진 요소 찾기
			    const likeBtn = entity.querySelector(".like");
			    likeBtn.textContent = "추천(" + updatedVoteCnt + ")";
			} else if (voteType === 'dislike') {
			    // 자식 태그 중 'dislike_cnt' 클래스를 가진 요소 찾기
			    const dislikeBtn = entity.querySelector(".dislike");
			    dislikeBtn.textContent = "비추천(" + updatedVoteCnt + ")";
			} else {
			    console.error(response.message); // 오류 메시지 출력
			}
		} else {
			console.error(response.message); // 오류 메시지 출력
		}
	}
}

function updateMoveComment() {
	// 요청에 성공 시, 진행.
	if (request.readyState == 4 && request.status == 200) {
		const response = JSON.parse(request.responseText);
		if (response.status === "success") {
			const parentId = response.parentId;
			const commentList = response.commentList; 
			const pageNum = response.pageNum;
			if(commentList == null || commentList.length == 0) {
				return;
			}
			
			let commentContainer = document.querySelector(".comment_container");
			commentContainer.innerHTML = "";
			commentList.forEach((comment) => {
				let htmlString = "<li class='comment' data-id='" + comment.commentId + "'>" +
				comment.userName + ": " + comment.commentContent + 
				comment.createDate + 
				"<button class='vote_btn like'>" +
					"추천(" + comment.likeCnt + ")" +
				"</button>" +
				"<button class='vote_btn dislike'>" +
					"비추천(" + comment.disLikeCnt + ")" +
				"</button>" +
				"<button type='button' class='show_delete_btn'>X</button> <span " + 
		        "class='delete_container' style='display: none'> <label><input " +
				"type='password' class='delete_pw' /></label>" +
				"<button type='button' class='delete_btn'>삭제</button>" +
				"</span>" +
				"</li>";
				commentContainer.insertAdjacentHTML("beforeend", htmlString);
			
			})
			document.querySelector("#current_comment_page_number").dataset.commentPage = pageNum;
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