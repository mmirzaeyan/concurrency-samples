package org.cocurrency.config;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.cocurrency.model.User;
import org.cocurrency.service.IUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

@Component
public class CustomAuthenticationSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {
	
	@Autowired
	private IUserService userService;
	
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws ServletException, IOException {
		
		User user = (User) authentication.getPrincipal();
		String url = "/View/frontEnd/homePage/Index.jsp";
		
		
		request.getSession().setAttribute("login", true);
		request.getSession().setAttribute("user", user);
		setDefaultTargetUrl(url);
		super.onAuthenticationSuccess(request, response, authentication);
	}

}
