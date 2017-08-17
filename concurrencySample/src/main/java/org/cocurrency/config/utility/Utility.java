package org.cocurrency.config.utility;

import java.util.ResourceBundle;

import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

public class Utility {
	
	private static ResourceBundle appconfigResource = ResourceBundle.getBundle("appconfig");
	
	public static String applicationPath;

	public static String getRealApplicationPath() {
		if (applicationPath != null)
			return applicationPath;

		ServletRequestAttributes requestAttributes = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
		applicationPath = requestAttributes.getRequest().getSession().getServletContext().getRealPath("");
		return applicationPath;
	}


	

}
