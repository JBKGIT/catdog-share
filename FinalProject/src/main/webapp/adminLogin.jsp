<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<%
boolean isLoggedIn = false;
if (session != null && session.getAttribute("isLoggedIn") != null) {
	isLoggedIn = (boolean) session.getAttribute("isLoggedIn");
}
%>
<body>
	<jsp:include page="/include/nav.jsp"></jsp:include>
	<%
	if (isLoggedIn) {
	%>
	<p>이미 로그인 하셨습니다.</p>
	<%
	} else {
	%>
	<form method="POST" action="submitLogin.jsp" class="login_form">
		<label>아이디: <input type="text" class="user_id" name="userId" /></label>
		<label>비밀번호: <input type="password" class="user_pw"
			name="userPw" /></label>
		<button type="submit">로그인</button>
	</form>
	<%
	}
	%>
</body>
</html>