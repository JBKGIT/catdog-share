package javabeans;

import java.sql.*;
import java.util.ArrayList;
import java.util.UUID;

import javax.sql.*;
import javax.naming.*;

public class PostDatabase {

	// DBCP
	private Context ctx = null;
	// student스키마에 접근.
	private DataSource ds = null;
	private Connection conn = null;
	private PreparedStatement stmt = null;
	private ResultSet result = null;

	public PostDatabase() {

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

	public ArrayList<PostEntity> getPostArray(int offset, int minLikes) {
		connect();
		ArrayList<PostEntity> list = new ArrayList<>();

		try {
			// student스키마 안에 있는 student_info 테이블에 접근.
			String sql = "SELECT post_id, user_name, post_name, post_content, create_date, like_cnt, dislike_cnt, views FROM posts WHERE like_cnt >= ? ORDER BY create_date DESC LIMIT ?, 10";
			stmt = conn.prepareStatement(sql);
			// 파라미터 바인딩
			stmt.setInt(1, minLikes);
			stmt.setInt(2, offset);
			// SQL 실행
			result = stmt.executeQuery();
			// List<comment>
			// String postId, String userName, String postName, String postContent, String
			// createDate, int likeCnt, int disLikeCnt, int views
			while (result.next()) {
				PostEntity post = new PostEntity(result.getString(1), result.getString(2), result.getString(3),
						result.getString(4), result.getString(5), result.getInt(6), result.getInt(7), result.getInt(8));
				list.add(post);
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

	public ArrayList<PostEntity> getPostArrayByKeyword(int offset, String keyword, String searchType, int minLikes) {
		connect();
		ArrayList<PostEntity> list = new ArrayList<>();

		try {
			String sql = "";
			if (searchType.equals("title")) {
				sql = "SELECT post_id, user_name, post_name, post_content, create_date, like_cnt, dislike_cnt, views FROM posts WHERE post_name LIKE ? AND like_cnt >= ? ORDER BY create_date DESC LIMIT ?, 10";
			} else if (searchType.equals("content")) {
				sql = "SELECT post_id, user_name, post_name, post_content, create_date, like_cnt, dislike_cnt, views FROM posts WHERE post_content LIKE ? AND like_cnt >= ? ORDER BY create_date DESC LIMIT ?, 10";
			} else if (searchType.equals("user")) {
				sql = "SELECT post_id, user_name, post_name, post_content, create_date, like_cnt, dislike_cnt, views FROM posts WHERE user_name LIKE ? AND like_cnt >= ? ORDER BY create_date DESC LIMIT ?, 10";
			} else {
				return list;
			}
			stmt = conn.prepareStatement(sql);
			// 파라미터 바인딩
			stmt.setString(1, "%" + keyword + "%"); // LIKE 검색을 위한 패턴
			stmt.setInt(2, minLikes);
			stmt.setInt(3, offset);
			// SQL 실행
			result = stmt.executeQuery();
			while (result.next()) {
				PostEntity post = new PostEntity(result.getString(1), result.getString(2), result.getString(3),
						result.getString(4), result.getString(5), result.getInt(6), result.getInt(7), result.getInt(8));
				list.add(post);
			}
			disconnect();
			stmt.close();
			result.close();

			return list;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			disconnect();

			return list;
		}
	}

	public ArrayList<PostEntity> getPostArrayByLikes(int offset, String keyword, String searchType, int minLikes) {
		connect();
		ArrayList<PostEntity> list = new ArrayList<>();

		try {
			String sql = "";
			if (searchType.equals("title")) {
				sql = "SELECT post_id, user_name, post_name, post_content, create_date, like_cnt, dislike_cnt, views FROM posts WHERE post_name LIKE ? AND like_cnt >= ? ORDER BY create_date DESC LIMIT ?, 10";
			} else if (searchType.equals("content")) {
				sql = "SELECT post_id, user_name, post_name, post_content, create_date, like_cnt, dislike_cnt, views FROM posts WHERE post_content LIKE ? AND like_cnt >= ? ORDER BY create_date DESC LIMIT ?, 10";
			} else if (searchType.equals("user")) {
				sql = "SELECT post_id, user_name, post_name, post_content, create_date, like_cnt, dislike_cnt, views FROM posts WHERE user_name LIKE ? AND like_cnt >= ? ORDER BY create_date DESC LIMIT ?, 10";
			} else {
				return list;
			}
			stmt = conn.prepareStatement(sql);
			// 파라미터 바인딩
			stmt.setString(1, "%" + keyword + "%"); // LIKE 검색을 위한 패턴
			stmt.setInt(2, minLikes);
			stmt.setInt(3, offset);
			// SQL 실행
			result = stmt.executeQuery();
			while (result.next()) {
				PostEntity post = new PostEntity(result.getString(1), result.getString(2), result.getString(3),
						result.getString(4), result.getString(5), result.getInt(6), result.getInt(7), result.getInt(8));
				list.add(post);
			}
			disconnect();
			stmt.close();
			result.close();

			return list;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			disconnect();

			return list;
		}
	}

	public String addPost(String userName, String userPw, String postName, String postContent, String currnetTime) {
		connect();
		boolean success = false;

		try {
			UUID uuid = UUID.randomUUID();
			String sql = "INSERT INTO posts(post_id, user_name, user_pw, post_name, post_content, create_date) VALUES (?, ?, ?, ?, ?, ?)";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, uuid.toString());
			stmt.setString(2, userName);
			stmt.setString(3, userPw);
			stmt.setString(4, postName);
			stmt.setString(5, postContent);
			stmt.setString(6, currnetTime);
			int rowsAffected = stmt.executeUpdate();
			String postId = null;
			if (rowsAffected > 0) {
				// 성공 응답
				success = true;
				// 생성된 Primary Key 가져오기
				postId = uuid.toString();
				disconnect();
				stmt.close();
				return postId;
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
		return null;
	}

	public PostEntity getPost(String PostId) {
		connect();

		// student스키마 안에 있는 student_info 테이블에 접근.
		String sql = "SELECT post_id, user_name, post_name, post_content, create_date, views, like_cnt, dislike_cnt FROM posts WHERE post_id = ?";
		try {
			stmt = conn.prepareStatement(sql);
			// 파라미터 바인딩
			stmt.setString(1, PostId);

			// SQL 실행
			result = stmt.executeQuery();
			String postId = "", userName = "", postName = "", postContent = "", createDate = "";
			int views = -1, likeCnt = -1, disLikeCnt = -1;
			String foodName = "";
			if (result.next()) {
				postId = result.getString(1);
				userName = result.getString(2);
				postName = result.getString(3);
				postContent = result.getString(4);
				createDate = result.getString(5);
				views = result.getInt(6);
				likeCnt = result.getInt(7);
				disLikeCnt = result.getInt(8);
				disconnect();
				stmt.close();
				result.close();
				return new PostEntity(postId, userName, postName, postContent, createDate, likeCnt, disLikeCnt, views);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	public boolean setVote(String parentId, String voteType) {
		connect();
		String sql = null;
		if (voteType.equals("like")) {
			sql = "UPDATE posts SET like_cnt = like_cnt + 1 WHERE post_id = ?";
		} else if (voteType.equals("dislike")) {
			sql = "UPDATE posts SET dislike_cnt = dislike_cnt + 1 WHERE post_id = ?";
		} else {
			return false;
		}
		try {
			stmt = conn.prepareStatement(sql);
			// 파라미터 바인딩
			stmt.setString(1, parentId);

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

	public int getVote(String postId, String voteType) {
		connect();
		String sql = null;
		if (voteType.equals("like")) {
			sql = "SELECT like_cnt FROM posts WHERE post_id = ?";
		} else if (voteType.equals("dislike")) {
			sql = "SELECT dislike_cnt FROM posts WHERE post_id = ?";
		} else {
			return -1;
		}
		try {
			stmt = conn.prepareStatement(sql);
			// 파라미터 바인딩
			stmt.setString(1, postId);

			// SQL 실행
			result = stmt.executeQuery();
			if (result.next()) {
				int cnt = result.getInt(1);
				disconnect();
				stmt.close();
				result.close();
				return cnt;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return -1;
	}

	public boolean existsRows(String id) {
		connect();
		boolean isExists = false;
		String sql = "SELECT * FROM posts WHERE post_id = ?";
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

	public int updateViews(String id) {
		connect();
		int views = -1;
		String sql = "UPDATE posts SET views = views + 1 WHERE post_id = ?";
		try {
			stmt = conn.prepareStatement(sql);
			// 파라미터 바인딩
			stmt.setString(1, id);

			// SQL 실행
			int rowsAffected = stmt.executeUpdate();

			if (rowsAffected != 0) {
				sql = "SELECT views FROM posts WHERE post_id = ?";
				try {
					stmt = conn.prepareStatement(sql);
					// 파라미터 바인딩
					stmt.setString(1, id);

					// SQL 실행
					result = stmt.executeQuery();
					if (result.next()) {
						views = result.getInt(1);
					}
				} catch (SQLException e) {
					e.printStackTrace();
				}
			} else {
				return -1;
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
		return views;
	}

	public boolean deletePost(String postId, String userPw, boolean isAdmin) {
		boolean success = false;
		connect();
		String sql1 = "";
		if (isAdmin == false) {
			sql1 = "DELETE FROM posts WHERE post_id = ? AND user_pw = ?";
		} else {
			sql1 = "DELETE FROM posts WHERE post_id = ?";
		}
		String sql2 = "DELETE FROM comments WHERE parent_id = ?";

		try (PreparedStatement stmt1 = conn.prepareStatement(sql1);
				PreparedStatement stmt2 = conn.prepareStatement(sql2);) {

			// 트랜잭션 시작
			conn.setAutoCommit(false);

			// 게시글 삭제
			stmt1.setString(1, postId);
			if (isAdmin == false) {
				stmt1.setString(2, userPw);
			}
			int rowsAffected1 = stmt1.executeUpdate();

			if (rowsAffected1 > 0) {
				// 댓글 삭제
				stmt2.setString(1, postId);
				stmt2.executeUpdate(); // 댓글이 없더라도 에러가 나지 않음

				// 트랜잭션 커밋
				conn.commit();
				success = true;
			} else {
				conn.rollback(); // 게시글 삭제 실패 시 롤백
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return success;
	}
}
