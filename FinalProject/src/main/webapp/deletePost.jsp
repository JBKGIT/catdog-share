<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="javabeans.CommentEntity"%>

<jsp:useBean id="commentdb" class="javabeans.CommentDatabase"
	scope="page" />
<jsp:useBean id="postdb" class="javabeans.PostDatabase" scope="page" />
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("application/json");

boolean isLoggedIn = false;
if (session != null && session.getAttribute("isLoggedIn") != null) {
	isLoggedIn = (boolean) session.getAttribute("isLoggedIn");
}

String postId = request.getParameter("postId");
String userPw = request.getParameter("userPw");
boolean isAdmin = false;
boolean success = false;
if (isLoggedIn == true && userPw == null) {
	isAdmin = true;
}
success = postdb.deletePost(postId, userPw, isAdmin);
if (success) {
	// 성공 응답
	response.getWriter().write("{\"status\":\"success\", \"message\":\"Post deleted successfully.\"}");
} else {
	// 실패 응답
	response.getWriter().write("{\"status\":\"error\", \"message\":\"Failed to delete data.\"}");
}
%>