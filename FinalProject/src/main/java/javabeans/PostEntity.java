package javabeans;

public class PostEntity {
    private String postId;
    private String userName;
    private String postName;	 
    private String postContent;
    private String createDate;
	private int likeCnt;
	private int disLikeCnt;
	private int views;
	
	public PostEntity(String postId, String userName, String postName, String postContent, String createDate,  int likeCnt, int disLikeCnt, int views) {
	    this.postId = postId;
	    this.userName = userName;
	    this.postName = postName;
	    this.postContent = postContent;
	    this.createDate = createDate;
	    this.likeCnt = likeCnt;
	    this.disLikeCnt = disLikeCnt;
	    this.views = views;
	}

	public String getPostId() {
		return postId;
	}

	public void setPostId(String postId) {
		this.postId = postId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getPostName() {
		return postName;
	}

	public void setPostName(String postName) {
		this.postName = postName;
	}

	public String getPostContent() {
		return postContent;
	}

	public void setPostContent(String postContent) {
		this.postContent = postContent;
	}

	public String getCreateDate() {
		return createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
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

	public int getViews() {
		return views;
	}

	public void setViews(int views) {
		this.views = views;
	}
	
	
}
