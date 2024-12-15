<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="javabeans.RequestedFoodEntity"%>
<%@ page import="java.util.ArrayList"%>

<jsp:useBean id="requestedfooddb"
	class="javabeans.RequestedFoodDatabase" scope="page" />
<!DOCTYPE html>
<html>
<head>
<meta charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="./resource/createPost.css">
<link rel="stylesheet" href="./resource/community.css">
<style>
.post_container li {
	border: 1px solid black;
}
</style>
</head>
<%
int postPageOffset = 0;

String orderType = "mostRecent"; // earliestFirst, mostLike 
if (request.getParameter("orderType") != null) {
	orderType = request.getParameter("orderType");
}
ArrayList<RequestedFoodEntity> posts = requestedfooddb.getRequestedFoodArray(postPageOffset, orderType);
%>

<body>
<body class ="container">
	<jsp:include page="/include/nav.jsp"></jsp:include>
	<div id="current_post_page_number" data-post-page="<%=postPageOffset%>"
		style="display: none"></div>
	<div id="request_order_type" data-order-type="<%=orderType%>"
		style="display: none"></div>
	<select class="order_type" name="orderType">
		<option value="mostRecent" SELECTED>최신순</option>
		<option value="earliestFirst">오래된순</option>
		<option value="mostLike">요청순</option>
	</select>
	<ul class="post_container">
		<%
		for (RequestedFoodEntity post : posts) {
		%>
		<li data-id="<%=post.getRequestedFoodId()%>">요청음식: <%=post.getRequestedFoodName()%>,
			요청횟수: <%=post.getRequestedCnt()%>, 최초요청일: <%=post.getRequestedDate()%>
			<button class="add_food">등록</button>
			<button class="remove_food">거부</button></li>
		<%
		}
		%>
	</ul>
	<ul class="comment_page_btn">
		<li class="back_comment_page_btn comment_page_btn"><<</li>
		<li class="front_comment_page_btn comment_page_btn">>></li>
	</ul>
</body>
<script>
document.querySelectorAll(".comment_page_btn").forEach((item) => {
	item.addEventListener("click", (e) => {
		const currentPageNum = parseInt(document.querySelector("#current_post_page_number").dataset.postPage);
		const orderType = document.querySelector("#request_order_type").dataset.orderType;
		const target = e.currentTarget;
		if(currentPageNum - 10 < 0) return;
		if (target.classList.contains("back_comment_page_btn")) {
			movePostPage(currentPageNum - 10, orderType);
        } else if (target.classList.contains("front_comment_page_btn")) {
        	movePostPage(currentPageNum + 10, orderType);
        }
	});
});

document.querySelector(".order_type").addEventListener("change", function(event) {
    document.querySelector("#request_order_type").dataset.orderType = event.target.value;
    document.querySelector("#current_post_page_number").dataset.commentPage = 0;
    movePostPage(0, event.target.value);
});

document.querySelector(".post_container").addEventListener("click", decideFood);
let request = null;
function createRequest() {
	try {
		request = new XMLHttpRequest();
	} catch (failed) {
		request = null;
	}
	if (request == null)
		alert('Error creating request object!');
}
function decideFood(e) {
	const targetBtn = e.target;
    const parentId = targetBtn.parentNode.dataset.id;
	let decideType = null;
	if(targetBtn.classList.contains("add_food")) {
		decideType = "add";
	} else if(targetBtn.classList.contains("remove_food")) {
		decideType = "remove";
	}
    if (decideType) {
        decideRequestedFood(decideType, parentId); // 클릭한 버튼에 따라 처리
    }
}
function decideRequestedFood(decideType, parentId) {
	createRequest();
	if(decideType === null) return;
	
	let url = "decideRequestedFood.jsp?";
	let qry = "decideType=" + encodeURIComponent(decideType) + "&parentId=" + encodeURIComponent(parentId);
	request.open("POST", url, true);
	request.onreadystatechange = updatePage;
	request.setRequestHeader("Content-type",
		"application/x-www-form-urlencoded");
	request.send(qry)
}
function updatePage() {
	if (request.readyState == 4 && request.status == 200) {
		const response = JSON.parse(request.responseText);
		if (response.status === "success") {
			const parentId = response.parentId;
			const postContainer = document.querySelector(".post_container");
		    const postElement = postContainer.querySelector('li[data-id="' + parentId + '"]');
		    if (postElement) {
		    	postElement.remove();
		    }
		}
	}
}
function movePostPage(offset, orderType) {
	createRequest();
	// ajax로 get요청을 보낼 시, 쿼리 스트링으로 정보 전달.
	let url = "moveRequstPage.jsp?";
	let qry = "offset=" + encodeURIComponent(offset) + "&orderType=" + encodeURIComponent(orderType);
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
				let htmlString = "<li data-id=" + post.requestedFoodId + "> 요청음식: " + post.requestedFoodName + ", 요청횟수: " + post.requestedCnt + ", 최초요청일: " + post.requestedDate + "<button class='add_food'>등록</button> <button class='remove_food'>거부</button></li>";
				postContainer.insertAdjacentHTML("beforeend", htmlString);
			
			})
        	document.querySelector("#current_post_page_number").dataset.postPage = pageNum;
		} else {
			console.error(response.message); // 오류 메시지 출력
		}
	}
}
</script>
</html>