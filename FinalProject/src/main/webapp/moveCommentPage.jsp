<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<%@ page import="com.fasterxml.jackson.databind.ObjectMapper"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="javabeans.CommentEntity"%>

<jsp:useBean id="commentdb" class="javabeans.CommentDatabase"
	scope="page" />


<%
request.setCharacterEncoding("UTF-8");
response.setContentType("application/json");

String offset = request.getParameter("offset");
String parentId = request.getParameter("parentId");
String orderType = request.getParameter("orderType");
ArrayList<CommentEntity> commentList = null;

class ResponseWrapper {
	public String status;
	public String parentId;
	public int pageNum;
	public ArrayList<CommentEntity> commentList;

	public ResponseWrapper(String status, String parentId, int pageNum, ArrayList<CommentEntity> commentList) {
		this.status = status;
		this.parentId = parentId;
		this.pageNum = pageNum;
		this.commentList = commentList;
	}
}


if (commentdb.existsRowsByParent(parentId)) {
	if (Integer.parseInt(offset) < 0) {
		response.getWriter().write("{\"status\":\"error\", \"message\":\"Failed to update comment data.\"}");
		return;
	}
	commentList = commentdb.getCommentArray(parentId, Integer.parseInt(offset), orderType);
	// Jackson: com.fasterxml.jackson.core:jackson-databind 아님 Gson: com.google.code.gson:gson로 변환해서 보내기.

	ObjectMapper objectMapper = new ObjectMapper();
	ResponseWrapper responseWrapper = new ResponseWrapper("success", parentId, Integer.parseInt(offset), commentList);
	String jsonResponse = objectMapper.writeValueAsString(responseWrapper);
	response.getWriter().write(jsonResponse);
} else {
	response.getWriter().write("{\"status\":\"error\", \"message\":\"Failed to update comment data.\"}");
}
%>


