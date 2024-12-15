<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="./resource/createPost.css">
</head>
<body>
<body class ="container">
	<jsp:include page="/include/nav.jsp"></jsp:include>
		<form method="POST" action="submitPost.jsp" class="post_form">
			<label>제목: <input type="text" class="post_name"
				name="postName" /></label> <label>작성자: <input type="text"
				class="user_name" name="userName" />
			</label> <label>비밀번호: <input type="password" class="user_pw"
				name="userPw" /></label> <label>내용: <textarea name="postContent"
					rows="4" cols="50" class="post_content"
					placeholder="Write your comment here..."></textarea>
			</label>
			<button type="submit">등록</button>
		</form>
	</body>
</html>