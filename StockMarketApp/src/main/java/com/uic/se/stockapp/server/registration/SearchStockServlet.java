package com.uic.se.stockapp.server.registration;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SearchStockServlet extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String companyName = req.getParameter("stock");
		req.setAttribute("SEARCH", companyName);
		RequestDispatcher dispatcher = req.getRequestDispatcher("buystock.jsp");
		dispatcher.include(req, resp);
	}
}
