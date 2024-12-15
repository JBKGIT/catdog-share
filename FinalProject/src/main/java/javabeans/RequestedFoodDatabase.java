package javabeans;

import java.sql.*;
import java.util.ArrayList;
import java.util.UUID;

import javax.sql.*;
import javax.naming.*;

public class RequestedFoodDatabase {

	// DBCP
	private Context ctx = null;
	// student스키마에 접근.
	private DataSource ds = null;
	private Connection conn = null;
	private PreparedStatement stmt = null;
	private ResultSet result = null;

	public RequestedFoodDatabase() {

		try {
			ctx = new InitialContext();
			ds = (DataSource) ctx.lookup("java:comp/env/jdbc/webdb");
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	void connect() {
		try {
			conn = ds.getConnection();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	void disconnect() {
		try {
			conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public RequestedFoodEntity getRequestedFood(String id) {
		connect();

		String sql = "SELECT requested_food_id, food_name FROM requested_foods WHERE requested_food_id = ?";
		try {
			stmt = conn.prepareStatement(sql);
			// 파라미터 바인딩
			stmt.setString(1, id);

			// SQL 실행
			result = stmt.executeQuery();
			String foodId = "", foodName = "";
			if (result.next()) {
				foodId = result.getString(1);
				foodName = result.getString(2);

				disconnect();
				stmt.close();
				result.close();
				return new RequestedFoodEntity(foodId, foodName, 0, "");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	public ArrayList<RequestedFoodEntity> getRequestedFoodArray(int offset, String orderType) {
		connect();
		ArrayList<RequestedFoodEntity> list = new ArrayList<>();

		try {
			String sql = "";
			if(orderType.equals("mostRecent")) {
				sql = "SELECT * FROM requested_foods ORDER BY requested_date DESC LIMIT ?, 15";
			} else if(orderType.equals("earliestFirst")) {
				sql = "SELECT * FROM requested_foods ORDER BY requested_date ASC LIMIT ?, 15";
			} else if(orderType.equals("mostLike")) {
				sql = "SELECT * FROM requested_foods ORDER BY requested_cnt DESC LIMIT ?, 15";
			} else {
				return list;
			}
			stmt = conn.prepareStatement(sql);
			// 파라미터 바인딩
			stmt.setInt(1, offset);
			// SQL 실행
			result = stmt.executeQuery();
			// List<comment>
			while (result.next()) {
				RequestedFoodEntity food = new RequestedFoodEntity(result.getString(1), result.getString(2),
						result.getInt(3), result.getString(4));
				list.add(food);
			}
			disconnect();
			stmt.close();
			result.close();

			return list;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			disconnect();

			return null;
		}
	}

	public boolean addRequestedFood(String foodName, String currnetTime) {
		connect();
		boolean success = false;

		try {
			UUID uuid = UUID.randomUUID();
			String sql = "INSERT INTO requested_foods(requested_food_id, food_name, requested_date) VALUES (?, ?, ?)";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, uuid.toString());
			stmt.setString(2, foodName);
			stmt.setString(3, currnetTime);

			int rowsAffected = stmt.executeUpdate();
			if (rowsAffected > 0) {
				// 성공 응답
				success = true;
				disconnect();
				stmt.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		try {
			disconnect();
			stmt.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return success;
	}

	public boolean deleteRequestedFood(String id) {
		connect();
		boolean success = false;

		try {

			String sql = "DELETE FROM requested_foods WHERE requested_food_id = ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, id);
			int rowsAffected = stmt.executeUpdate();
			if (rowsAffected > 0) {
				// 성공 응답
				success = true;
				disconnect();
				stmt.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		try {
			disconnect();
			stmt.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return success;
	}

	public boolean existsRows(String id) {
		connect();
		boolean isExists = false;
		String sql = "SELECT * FROM requested_foods WHERE requested_food_id = ?";
		try {
			stmt = conn.prepareStatement(sql);
			// 파라미터 바인딩
			stmt.setString(1, id);

			// SQL 실행
			result = stmt.executeQuery();
			if (result.next()) {
				isExists = true;
			} else {
				isExists = false;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		disconnect();
		try {
			result.close();
			stmt.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return isExists;
	}

	public boolean existsRowsByFoodName(String foodName) {
		connect();
		boolean isExists = false;
		String sql = "SELECT * FROM requested_foods WHERE food_name = ?";
		try {
			stmt = conn.prepareStatement(sql);
			// 파라미터 바인딩
			stmt.setString(1, foodName);

			// SQL 실행
			result = stmt.executeQuery();
			if (result.next()) {
				isExists = true;
			} else {
				isExists = false;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		disconnect();
		try {
			result.close();
			stmt.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return isExists;
	}
	
	public boolean setRequestCnt(String foodName) {
		connect();
		String sql = "UPDATE requested_foods SET requested_cnt = requested_cnt + 1 WHERE food_name = ?";
		try {
			stmt = conn.prepareStatement(sql);
			// 파라미터 바인딩
			stmt.setString(1, foodName);

			// SQL 실행
			int rowsAffected = stmt.executeUpdate();

			disconnect();
			stmt.close();
			if (rowsAffected != 0) {
				return true;
			} else {
				return false;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
}
