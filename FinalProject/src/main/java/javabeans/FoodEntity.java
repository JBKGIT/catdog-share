package javabeans;

public class FoodEntity {
	private String foodId;
	private String foodName;
	private int likeCnt;
	private int disLikeCnt;
	private int views;
	
	public FoodEntity() {}
	
	public FoodEntity(String foodId, String foodName, int likeCnt, int disLikeCnt, int views) {
		this.foodId = foodId;
		this.foodName = foodName;
		this.likeCnt = likeCnt;
		this.disLikeCnt = disLikeCnt;
		this.views = views;
	}

	public int getViews() {
		return views;
	}

	public void setViews(int views) {
		this.views = views;
	}

	public String getFoodId() {
		return foodId;
	}

	public void setFoodId(String foodId) {
		this.foodId = foodId;
	}	

	public String getFoodName() {
		return foodName;
	}

	public void setFoodName(String foodName) {
		this.foodName = foodName;
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
