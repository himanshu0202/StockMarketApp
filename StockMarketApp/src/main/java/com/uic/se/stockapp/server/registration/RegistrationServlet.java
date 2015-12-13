package com.uic.se.stockapp.server.registration;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.uic.se.stockapp.dbcon.DatabaseCon;
import com.uic.se.stockapp.dbcon.DatabaseConstants;

public class RegistrationServlet extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		final RequestDispatcher dispatcher = req.getRequestDispatcher("index.jsp");
		if (DatabaseCon.save(DatabaseConstants.REGISTER,getServletContext(), req.getParameter("username_reg"),
				req.getParameter("email_reg"), req.getParameter("password_reg"))) {
			req.setAttribute("REG STATUS", "SUCCESS");
			dispatcher.include(req, resp);
		} else {
			req.setAttribute("REG STATUS", "FAILED");
			dispatcher.include(req, resp);
		}

	}
}

