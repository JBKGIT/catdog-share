<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat, java.util.Date"%>
<%@ page import="javabeans.CommentEntity"%>

<jsp:useBean id="userdb" class="javabeans.UserDatabase" scope="page" />
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("application/json");

String userId = request.getParameter("userId");
String userPw = request.getParameter("userPw");

boolean isExists = userdb.existsUser(userId, userPw);
if (isExists) {
	// 성공 응답
	session.setAttribute("userId", userId); // 사용자 ID 저장
	session.setAttribute("isLoggedIn", true); // 로그인 상태 저장
	session.setMaxInactiveInterval(24 * 60 * 60); // 24시간
	 response.sendRedirect("community.jsp"); // 로그인 성공 후 페이지로 이동
} else {
	// 실패 응답
    response.getWriter().write("{\"status\": \"fail\", \"message\": \"아이디 또는 비밀번호가 잘못되었습니다.\"}");
}
%>