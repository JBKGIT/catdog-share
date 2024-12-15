<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat, java.util.Date"%>

<jsp:useBean id="fooddb" class="javabeans.FoodDatabase" scope="page" />
<jsp:useBean id="requestedfooddb" class="javabeans.RequestedFoodDatabase" scope="page" />
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html; charset=UTF-8");


String requestFoodName = request.getParameter("requestFoodName");

SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String currentTime = formatter.format(new Date());

boolean isExists = requestedfooddb.existsRowsByFoodName(requestFoodName);
System.out.println(isExists);
if (isExists) {
	requestedfooddb.setRequestCnt(requestFoodName);
} else {
	boolean success = requestedfooddb.addRequestedFood(requestFoodName, currentTime);
	if(success == false) {
		out.println("<script>");
		out.println("alert('등록요청에 실패했습니다. 다시 시도해주세요.');");
		out.println("history.back();"); // 이전 페이지로 이동
		out.println("</script>");
		return;
	}
}
response.sendRedirect("main.jsp");
%>