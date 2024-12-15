package javabeans;

import java.util.Date;
import java.text.SimpleDateFormat;

public class CommentEntity {
	
    private String commentId;
	private String parentId;
	private String userName;
//	private String userPw;
	private String commentContent;
	private String createDate;
	private int likeCnt;
	private int disLikeCnt;
	
	public CommentEntity() {}
	
	public CommentEntity(String commentId, String parentId, String userName, String commentContent, String createDate, int likeCnt, int disLikeCnt) {
	    this.commentId = commentId;
	    this.parentId = parentId;
	    this.userName = userName;
	    this.commentContent = commentContent;
	    this.createDate = createDate;
	    this.likeCnt = likeCnt;
	    this.disLikeCnt = disLikeCnt;
	}
	
	public String getCommentId() {
		return commentId;
	}
	public void setCommentId(String commentId) {
		this.commentId = commentId;
	}
	public String getParentId() {
		return parentId;
	}
	public void setPostId(String parentId) {
		this.parentId = parentId;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
//	public String getUserPw() {
//		return userPw;
//	}
//	public void setUserPw(String userPw) {
//		this.userPw = userPw;
//	}
	public String getCommentContent() {
		return commentContent;
	}
	public void setCommentContent(String commentContent) {
		this.commentContent = commentContent;
	}
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate() {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String currentDate = formatter.format(new Date());
		this.createDate = currentDate;
	}
	public int getLikeCnt() {
		return likeCnt;
	}
	public void setLikeCnt(int likeCnt) {
		this.likeCnt = likeCnt;
	}
	public int getDisLikeCnt() {
		return disLikeCnt;
	}
	public void setDisLikeCnt(int disLikeCnt) {
		this.disLikeCnt = disLikeCnt;
	}
	
	
	
}
