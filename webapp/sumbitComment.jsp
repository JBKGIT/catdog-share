<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.text.SimpleDateFormat, java.util.Date"%>
<%@ page import="javabeans.CommentEntity"%>

<jsp:useBean id="commentdb" class="javabeans.CommentDatabase"
	scope="request" />
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("application/json");

SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String currentTime = formatter.format(new Date());

String parentId = request.getParameter("parentId");
String userName = request.getParameter("userName");
String userPw = request.getParameter("userPw");
String comment = request.getParameter("comment");

String commentId = commentdb.addComment(parentId, userName, userPw, comment, currentTime);
System.out.println("결과: " + commentId);
if (commentId != null) {
	// 성공 응답
	response.getWriter().write("{\"status\":\"success\",\"commentId\":\"" + commentId + "\", \"userName\":\"" + userName
	+ "\", \"comment\":\"" + comment + "\",  \"currentTime\":\"" + currentTime + "\"}");
} else {
	// 실패 응답
	response.getWriter().write("{\"status\":\"error\", \"message\":\"Failed to insert data.\"}");
}
%>