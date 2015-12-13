package com.uic.se.stockapp.server.registration;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.uic.se.stockapp.dbcon.DatabaseCon;
import com.uic.se.stockapp.dbcon.DatabaseConstants;

public class WatchListServlet extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		System.out.println("Inside Login Servlet");
		DatabaseCon.saveToWatchList((Integer) getServletContext().getAttribute("USER_ID"), req.getParameter("stock"));
		RequestDispatcher dispatcher = req.getRequestDispatcher("watchlist.jsp");
		dispatcher.include(req, resp);

	}
}
