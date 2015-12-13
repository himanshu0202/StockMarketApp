package com.uic.se.stockapp.server.registration;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.uic.se.stockapp.dbcon.DatabaseCon;
import com.uic.se.stockapp.dbcon.DatabaseConstants;

public class UpdateProfileServlet extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		RequestDispatcher rd = null;
		String gender;
		if (req.getParameter("gender").equalsIgnoreCase("Male")) {
			gender = "Male";
		} else {
			gender = "Female";
		}

		if (getServletContext().getAttribute("USER_ID") == null) {
			if (!DatabaseCon.emailExists(getServletContext(), req.getParameter("email"))) {
				DatabaseCon.save(DatabaseConstants.REGISTER, getServletContext(),
						req.getParameter("name").replaceAll("\\s", "").toLowerCase(), req.getParameter("email"),
						DatabaseConstants.EMPTY_STRING);
				DatabaseCon.emailExists(getServletContext(), req.getParameter("email"));
				rd = req.getRequestDispatcher("UserProfile.jsp");
				rd.include(req, resp);
			} else {
				rd = req.getRequestDispatcher("dashboard.jsp");
				rd.forward(req, resp);
			}
		} else {
			DatabaseCon.updateUserProfile((Integer) getServletContext().getAttribute("USER_ID"),
					req.getParameter("name"), req.getParameter("email"), req.getParameter("occupation"), gender,
					req.getParameter("industry"), req.getParameter("dob"), req.getParameter("income"),
					req.getParameter("country"), req.getParameter("password"));
			rd = req.getRequestDispatcher("UserProfile.jsp");
			rd.include(req, resp);
		}

	}
}
