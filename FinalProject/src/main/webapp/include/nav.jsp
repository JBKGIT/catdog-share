<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="./resource/main.css">
</head>
<%
boolean isLoggedIn = false;
if (session != null && session.getAttribute("isLoggedIn") != null) {
	isLoggedIn = (boolean) session.getAttribute("isLoggedIn");
}
%>
<body>
	<nav>
		<ul class="nav">
			<li><a href="main.jsp">홈</a></li>
			<li><a href="community.jsp">커뮤니티</a></li>
			<%
			if (isLoggedIn) {
			%>
			<li><a href="adminPage.jsp">관리페이지</a></li>
			<li><a href="logout.jsp">로그아웃</a></li>
			<%
			}
			%>
		</ul>
	</nav>
</body>
</html>