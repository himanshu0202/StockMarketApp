package com.uic.se.stockapp.dbcon;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletContext;

import com.uic.se.stockapp.entity.User;

public class DatabaseCon implements DatabaseConstants {

	public static Connection con;
	public static ServletContext contxt;

	private static Connection getConnection() {
		Connection con = null;
		try {
			Class.forName(DRIVER_NAME);
			con = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
		} catch (Exception e) {

		}
		return con;
	}

	public static boolean save(String context, ServletContext ctx, String... args) {
		contxt=ctx;
		con = getConnection();
		boolean flag = false;
		String query = EMPTY_STRING;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		if (REGISTER.equalsIgnoreCase(context)) {
			query = "insert into user (id, username, email, password,currency) values (null,?,?,?,?)";
			try {
				pstmt = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
				pstmt.setString(1, args[0]);
				pstmt.setString(2, args[1]);
				pstmt.setString(3, args[2]);
				pstmt.setString(4, "20000");
			} catch (SQLException e) {
				return false;
			}

		} else if (LOGIN.equalsIgnoreCase(context)) {
			query = "select * from user";
			try {
				pstmt = con.prepareStatement(query);
			} catch (SQLException e) {
				return false;
			}
		}
		if (!query.isEmpty() && pstmt != null) {
			try {
				if (LOGIN.equalsIgnoreCase(context)) {
					pstmt.executeQuery();
					rs = pstmt.getResultSet();
					while (rs.next()) {
						if (rs.getString("username").equalsIgnoreCase(args[0])
								&& rs.getString("password").equalsIgnoreCase(args[1])) {
							ctx.setAttribute("USER_ID", rs.getInt("id"));
							ctx.setAttribute("CURRENCY", rs.getInt("currency"));
							flag = true;
							break;
						} else {
							flag = false;
						}
					}
				} else {
					pstmt.executeUpdate();
					flag = true;
				}

				con.close();
				pstmt.close();
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException e) {
				return false;
			}
		}

		return flag;
	}

	public static void saveToWatchList(int userId, String stockCode) {
		con = getConnection();
		String query = EMPTY_STRING;
		PreparedStatement pstmt = null;
		query = "insert into user_watchlist (user, stock_code) values (?,?)";
		try {
			pstmt = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
			pstmt.setInt(1, userId);
			pstmt.setString(2, stockCode);
			pstmt.executeUpdate();
		} catch (SQLException e) {
		}

	}

	public static List<String> getStockCodesFromUserID(int userId) {
		con = getConnection();
		String query = "select stock_code from user_stocks where user_id=" + userId;
		List<String> listOfStocks = new ArrayList<String>();
		PreparedStatement pstmt;
		ResultSet rs;
		try {
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				listOfStocks.add(rs.getString("stock_code"));
			}
			con.close();
			pstmt.close();
			rs.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return listOfStocks;
	}

	public static int getQuantityByUserIdAndStockId(int userId, String stockCode) {
		con = getConnection();
		String query = "select quantity from user_stocks where user_id=" + userId + " AND stock_code='" + stockCode
				+ "'";
		PreparedStatement pstmt;
		int quantity = 0;
		try {
			pstmt = con.prepareStatement(query);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				quantity = rs.getInt("quantity");
			}
			con.close();
			pstmt.close();
			rs.close();

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return quantity;
	}

	public static int getInvPriceByUserIdAndStockId(int userId, String stockCode) {
		con = getConnection();
		String query = "select price_purchased from user_stocks where user_id=" + userId + " AND stock_code='"
				+ stockCode + "'";
		PreparedStatement pstmt;
		int invPrice = 0;
		try {
			pstmt = con.prepareStatement(query);
			ResultSet rs = pstmt.executeQuery();
			while (rs.next()) {
				invPrice = rs.getInt("price_purchased");
			}
			con.close();
			pstmt.close();
			rs.close();

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return invPrice;
	}

	public static List<String> retrieveWatchlistStocks(int userId) {
		con = getConnection();
		String query = "select stock_code from user_watchlist where user=" + userId;
		List<String> listOfStocks = new ArrayList<String>();
		PreparedStatement pstmt;
		ResultSet rs;
		try {
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				listOfStocks.add(rs.getString("stock_code"));
			}
			con.close();
			pstmt.close();
			rs.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return listOfStocks;
	}

	public static void updateUserProfile(int userId, String... args) {

		con = getConnection();
		String query = EMPTY_STRING;
		PreparedStatement pstmt = null;
		query = "update user set Name=?, email=?, Gender=?, DOB=?, Country=?, Occupation=?, Industry=?, Income=?, password=? where id="
				+ userId;

		try {
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, args[0]);
			pstmt.setString(2, args[1]);
			pstmt.setString(3, args[3]);
			pstmt.setString(4, args[5]);
			pstmt.setString(5, args[7]);
			pstmt.setString(6, args[2]);
			pstmt.setString(7, args[4]);
			pstmt.setString(8, args[6]);
			pstmt.setString(9, args[8]);
			pstmt.executeUpdate();
			con.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("Lagi");
		}

	}

	public static boolean sellStocks(int userId, String stockCode, int quantity) {
		con = getConnection();
		PreparedStatement pstmt = null;
		String query = "update user_stocks set quantity=? where user_id=" + userId + " and stock_code='" + stockCode
				+ "'";
		try {
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, quantity);
			int count=pstmt.executeUpdate();
			con.close();
			pstmt.close();
			if(count>0){
				return true;
			}
		} catch (SQLException e) {
			System.out.println("Lagi");
		}
		
		return false;

	}
	
	public static boolean buy(int userId, String stockCode, int quantity, int pricePurchased) {
		con = getConnection();
		PreparedStatement pstmt = null;
		String query = "insert into user_stocks (user_id, stock_code, quantity, price_purchased) values (?,?,?,?)";
		try {
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, userId);
			pstmt.setString(2, stockCode);
			pstmt.setInt(3, quantity);
			pstmt.setInt(4, pricePurchased);
			int count=pstmt.executeUpdate();
			con.close();
			pstmt.close();
			if(count>0){
				return true;
			}
		} catch (SQLException e) {
			System.out.println("Lagi");
		}
		
		return false;

	}


	public static ResultSet retrieveUserProfile(int userId) {
		System.out.println(userId);
		ResultSet rs = null;
		con = getConnection();
		String query = "select * from user where id=" + userId;
		PreparedStatement pstmt;
		try {
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
		} catch (SQLException e) {
			System.out.println("Exception" + userId);
		}
		return rs;
	}

	public static User retrieveUser(int userId) {
		System.out.println("In USER" + userId);
		User user = null;
		ResultSet rs = null;
		con = getConnection();
		String query = "select * from user where id=" + userId;
		PreparedStatement pstmt;
		try {
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			rs.next();
			user = new User(rs.getString("username"), rs.getString("password"), rs.getString("email"),
					rs.getString("Gender"), rs.getString("DOB"), rs.getString("Name"), rs.getString("Industry"),
					rs.getString("Occupation"), rs.getString("Country"), rs.getString("Income"),rs.getString("currency"));
		} catch (SQLException e) {
			System.out.println("Exception" + userId);
		}
		return user;
	}

	public static int retrieveUserStockQuantity(int userId, String stockCode) {
		ResultSet rs = null;
		int quantity = 0;
		con = getConnection();
		String query = "select quantity from user_stocks where user_id=" + userId + " and stock_code='" + stockCode
				+ "'";
		PreparedStatement pstmt;
		try {
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			rs.next();
			quantity = rs.getInt("quantity");
		} catch (SQLException e) {
			System.out.println(e);
		}
		return quantity;
	}

	public static boolean emailExists(ServletContext context, String email) {
		contxt=context;
		ResultSet rs = null;
		con = getConnection();
		String query = "select * from user";
		PreparedStatement pstmt;
		try {
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (rs.getString("email").equalsIgnoreCase(email)) {
					context.setAttribute("USER_ID", rs.getInt("id"));
					context.setAttribute("CURRENCY", rs.getInt("currency"));
					return true;
				}
			}
		} catch (Exception e) {

		}
		return false;
	}
	
	public static boolean updateCurrency(int userId, int currency){

		con = getConnection();
		String query = EMPTY_STRING;
		PreparedStatement pstmt = null;
		query = "update user set currency=? where id="
				+ userId;

		try {
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, new Integer(currency).toString());
			int count=pstmt.executeUpdate();
			if(count>0){
				contxt.setAttribute("CURRENCY", currency);
				return true;
			}
			con.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("Lagi");
		}
        
		return false;
	
	}

}
