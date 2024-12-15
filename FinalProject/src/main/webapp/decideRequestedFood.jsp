<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="javabeans.RequestedFoodEntity"%>
<%@ page import="javabeans.FoodEntity"%>

<jsp:useBean id="requestedfooddb"
	class="javabeans.RequestedFoodDatabase" scope="page" />
<jsp:useBean id="fooddb" class="javabeans.FoodDatabase" scope="page" />
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("application/json");

String decideType = request.getParameter("decideType");
String parentId = request.getParameter("parentId");
boolean addFoodSuccess = false;
if (requestedfooddb.existsRows(parentId)) {
	RequestedFoodEntity requestedFood = requestedfooddb.getRequestedFood(parentId);
	boolean success = requestedfooddb.deleteRequestedFood(parentId);
	if (success == true && decideType.equals("add")) {
		addFoodSuccess = fooddb.addFood(requestedFood.getRequestedFoodId(), requestedFood.getRequestedFoodName());
	} else if (success == true && decideType.equals("remove")) {
		response.getWriter().write("{\"status\":\"success\", \"parentId\":\"" + parentId + "\"}");
		return;
	}
	if (addFoodSuccess) {
		response.getWriter().write("{\"status\":\"success\", \"parentId\":\"" + parentId + "\"}");
	}
} else {
	response.getWriter().write("{\"status\":\"error\", \"message\":\"Failed to decide data.\"}");
	return;
}
%>