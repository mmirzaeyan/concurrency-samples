package org.cocurrency.config;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.web.util.UrlPathHelper;

public class WelcomePageFilter extends OncePerRequestFilter {

	@Override
	protected void doFilterInternal(HttpServletRequest paramHttpServletRequest, HttpServletResponse paramHttpServletResponse, FilterChain paramFilterChain)
			throws ServletException, IOException {
		String path = new UrlPathHelper().getPathWithinApplication(paramHttpServletRequest);
		String contextPath = new UrlPathHelper().getOriginatingContextPath(paramHttpServletRequest);
		if (path.equals("/")) {
			paramHttpServletResponse.sendRedirect(contextPath+"/Index.jsp");
		} else {
			paramFilterChain.doFilter(paramHttpServletRequest, paramHttpServletResponse);
		}
	}

}