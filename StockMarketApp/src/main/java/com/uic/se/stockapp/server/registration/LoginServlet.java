package com.uic.se.stockapp.server.registration;

import java.io.IOException;
import java.math.BigDecimal;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.uic.se.stockapp.dbcon.DatabaseCon;
import com.uic.se.stockapp.dbcon.DatabaseConstants;

import yahoofinance.Stock;
import yahoofinance.YahooFinance;

public class LoginServlet extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		RequestDispatcher dispatcher;
		System.out.println("Inside Login Servlet");
		if (DatabaseCon.save(DatabaseConstants.LOGIN, getServletContext(), req.getParameter("username_login"),
				req.getParameter("password_login"))) {
			dispatcher = req.getRequestDispatcher("dashboard.jsp");
			dispatcher.forward(req, resp);

		} else {
			dispatcher = req.getRequestDispatcher("index.jsp");
			req.setAttribute("LOGIN STATUS", "FAILED");
			dispatcher.include(req, resp);
		}

	}
}
