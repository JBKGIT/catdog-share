<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat, java.util.Date"%>
<%@ page import="javabeans.CommentEntity"%>

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("application/json");

if (session != null) {
	session.invalidate(); // 세션 무효화
}
response.sendRedirect("community.jsp"); // 로그인 페이지로 리다이렉트
%>