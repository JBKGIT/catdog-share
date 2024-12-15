package javabeans;

public class RequestedFoodEntity {
	private String requestedFoodId;
	private String requestedFoodName;
	private int requestedCnt;
	private String requestedDate;
	
	public RequestedFoodEntity(String requestedFoodId, String requestedFoodName, int requestedCnt, String requestedDate) {
		this.requestedFoodId = requestedFoodId;
		this.requestedFoodName = requestedFoodName;
		this.requestedCnt = requestedCnt;
		this.requestedDate = requestedDate;
	}

	public String getRequestedFoodId() {
		return requestedFoodId;
	}

	public void setRequestedFoodId(String requestedFoodId) {
		this.requestedFoodId = requestedFoodId;
	}

	public String getRequestedFoodName() {
		return requestedFoodName;
	}

	public void setRequestedFoodName(String requestedFoodName) {
		this.requestedFoodName = requestedFoodName;
	}

	public int getRequestedCnt() {
		return requestedCnt;
	}

	public void setRequestedCnt(int requestedCnt) {
		this.requestedCnt = requestedCnt;
	}

	public String getRequestedDate() {
		return requestedDate;
	}

	public void setRequestedDate(String requestedDate) {
		this.requestedDate = requestedDate;
	}
}
