<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat, java.util.Date"%>
<%@ page import="javabeans.PostEntity"%>

<jsp:useBean id="postdb" class="javabeans.PostDatabase" scope="page" />
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html; charset=UTF-8");

SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String currentTime = formatter.format(new Date());

String postName = request.getParameter("postName");
String userName = request.getParameter("userName");
String userPw = request.getParameter("userPw");
String postContent = request.getParameter("postContent");

// addPost(String userName, String userPw, String postName, String postContent, String currnetTime)
String postId = postdb.addPost(userName, userPw, postName, postContent, currentTime);

if (postId != null) {
	// 성공 응답
	response.sendRedirect("community.jsp");
} else {
	// 실패 응답
	out.println("<script>");
	out.println("alert('글 작성에 실패했습니다. 다시 시도해주세요.');");
	out.println("history.back();"); // 이전 페이지로 이동
	out.println("</script>");
}
%>