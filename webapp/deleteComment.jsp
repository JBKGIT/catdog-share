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

boolean success = commentdb.deleteComment(commentId, userPw);
System.out.println("결과: " + commentId);
if (success == true) {
	// 성공 응답
	response.getWriter().write("{\"status\":\"delete\", \"commentId\":\"" + commentId + "\"}");
} else {
	// 실패 응답
	response.getWriter().write("{\"status\":\"error\", \"message\":\"Failed to delete data.\"}");
}
%>