<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Can Dogs Eat It?</title>
</head>
<body>
	<jsp:include page="/include/nav.jsp"></jsp:include>

	<form class="search_form" method="GET" action="searchResult.jsp">
		<input type="text" name="searchValue" class="search_value" />
		<button tyep="submit" class="saerch_button">검색</button>
	</form>
</body>

<script>
	document.querySelector(".search_form")
			.addEventListener(
					"submit",
					function(event) {
						const inputField = document
								.querySelector(".search_value").value.trim();
						if (inputField === "") {
							// 입력값이 비어있으면 동작하지 않음
							event.preventDefault(); // 기본 폼 제출 동작 방지
						}
					});
</script>
</html>