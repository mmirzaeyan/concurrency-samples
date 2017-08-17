package org.cocurrency.config;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class WelcomePageServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void init() {
	}

	public void destroy() {
	}

	public void doGet(HttpServletRequest paramHttpServletRequest, HttpServletResponse paramHttpServletResponse) throws IOException {

	}

	public void doPost(HttpServletRequest paramHttpServletRequest, HttpServletResponse paramHttpServletResponse) throws IOException {
		doGet(paramHttpServletRequest, paramHttpServletResponse);
	}
}