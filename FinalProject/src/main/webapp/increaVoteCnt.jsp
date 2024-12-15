<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="javabeans.CommentEntity"%>
<%@ page import="javabeans.FoodEntity"%>

<jsp:useBean id="commentdb" class="javabeans.CommentDatabase"
	scope="page" />
<jsp:useBean id="fooddb" class="javabeans.FoodDatabase" scope="page" />
<jsp:useBean id="postdb" class="javabeans.PostDatabase" scope="page" />
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("application/json");

String voteType = request.getParameter("voteType");
String parentId = request.getParameter("parentId");
int updatedVoteCnt = -1;

boolean isVoted = false;
Cookie[] cookies = request.getCookies();

if (cookies != null) {
	for (Cookie cookie : cookies) {
		if (cookie.getName().equals("vote_" + parentId)) {
	isVoted = true;
	break;
		}
	}
}
if (!isVoted) {

	// 쿠키 생성
	Cookie voteCookie = new Cookie("vote_" + parentId, "true");
	voteCookie.setMaxAge(24 * 60 * 60); // 24시간 유지
	response.addCookie(voteCookie);

	if (fooddb.existsRows(parentId)) {
		fooddb.setVote(parentId, voteType);
		updatedVoteCnt = fooddb.getVote(parentId, voteType);
	} else if (commentdb.existsRows(parentId)) {
		commentdb.setVote(parentId, voteType);
		updatedVoteCnt = commentdb.getVote(parentId, voteType);
	} else if (postdb.existsRows(parentId)) {
		postdb.setVote(parentId, voteType);
		updatedVoteCnt = postdb.getVote(parentId, voteType);
	} else {
		response.getWriter().write("{\"status\":\"error\", \"message\":\"Failed to update vote data.\"}");
		return;
	}
	response.getWriter().write("{\"status\":\"success\",\"parentId\":\"" + parentId + "\", \"voteType\":\"" + voteType
	+ "\", \"updatedVoteCnt\":\"" + updatedVoteCnt + "\"}");
} else {
	response.getWriter().write("{\"status\":\"fail\", \"message\":\"Failed to update vote data.\"}");
}
%>