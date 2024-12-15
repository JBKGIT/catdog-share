<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<%@ page import="com.fasterxml.jackson.databind.ObjectMapper"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="javabeans.RequestedFoodEntity"%>

<jsp:useBean id="requestedfooddb"
	class="javabeans.RequestedFoodDatabase" scope="page" />


<%
request.setCharacterEncoding("UTF-8");
response.setContentType("application/json");

String offset = request.getParameter("offset");
String orderType = request.getParameter("orderType");

ArrayList<RequestedFoodEntity> postList = null;

class ResponseWrapper {
	public String status;
	public int pageNum;
	public ArrayList<RequestedFoodEntity> postList;

	public ResponseWrapper(String status, int pageNum, ArrayList<RequestedFoodEntity> postList) {
		this.status = status;
		this.pageNum = pageNum;
		this.postList = postList;
	}
}
if (Integer.parseInt(offset) >= 0) {
	postList = requestedfooddb.getRequestedFoodArray(Integer.parseInt(offset), orderType);
}
// Jackson: com.fasterxml.jackson.core:jackson-databind 아님 Gson: com.google.code.gson:gson로 변환해서 보내기.
if (postList == null) {
	response.getWriter().write("{\"status\":\"error\", \"message\":\"Failed to update comment data.\"}");
	return;
}
ObjectMapper objectMapper = new ObjectMapper();
ResponseWrapper responseWrapper = new ResponseWrapper("success", Integer.parseInt(offset), postList);
String jsonResponse = objectMapper.writeValueAsString(responseWrapper);
response.getWriter().write(jsonResponse);
%>


