<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="javabeans.CommentEntity"%>

<jsp:useBean id="commentdb" class="javabeans.CommentDatabase"
	scope="page" />
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("application/json");

String commentId = request.getParameter("commentId");
String userPw = request.getParameter("userPw");

boolean isLoggedIn = false;
if (session != null && session.getAttribute("isLoggedIn") != null) {
	isLoggedIn = (boolean) session.getAttribute("isLoggedIn");
}

boolean isAdmin = false;
boolean success = false;
if (isLoggedIn == true && userPw == null) {
	isAdmin = true;
}
success = commentdb.deleteComment(commentId, userPw, isAdmin);
if (success == true) {
	// 성공 응답
	response.getWriter().write("{\"status\":\"delete\", \"commentId\":\"" + commentId + "\"}");
} else {
	// 실패 응답
	response.getWriter().write("{\"status\":\"error\", \"message\":\"Failed to delete data.\"}");
}
%>