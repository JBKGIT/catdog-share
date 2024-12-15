package javabeans;

import java.sql.*;
import java.util.ArrayList;
import javax.sql.*;
import javax.naming.*;

public class UserDatabase {

	// DBCP
	private Context ctx = null;
	// student스키마에 접근.
	private DataSource ds = null;
	private Connection conn = null;
	private PreparedStatement stmt = null;
	private ResultSet result = null;

	public UserDatabase() {

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

	public boolean existsUser(String userId, String userPw) {
		connect();
		boolean isExists = false;
		// student스키마 안에 있는 student_info 테이블에 접근.
		String sql = "SELECT * FROM users WHERE user_id = ? AND user_pw = ?";
		try {
			stmt = conn.prepareStatement(sql);
			// 파라미터 바인딩
			stmt.setString(1, userId);
			stmt.setString(2, userPw);
			// SQL 실행
			result = stmt.executeQuery();
			if (result.next()) {
				isExists = true;

				disconnect();
				stmt.close();
				result.close();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return isExists;
	}
}
