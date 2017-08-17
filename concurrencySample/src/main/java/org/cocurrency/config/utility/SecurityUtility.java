package org.cocurrency.config.utility;

import javax.annotation.Resource;

import org.cocurrency.model.User;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.session.SessionRegistryImpl;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

/**
 * @author mohammad
 *
 */
public class SecurityUtility {

	@Resource(name = "sessionRegistry")
	private SessionRegistryImpl sessionRegistry;


	public static String getRequestedIp() {
		return ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest().getRemoteHost();
	}
	
	public static User getAuthenticatedUser() {
		try {
			return (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		} catch (Exception ex) {
			return null;
		}
	}

	public User getAuthenticatedUser(Integer userId) {
		for (Object username : sessionRegistry.getAllPrincipals()) {
			User temp = (User) username;
			if (temp.getId().equals(userId))
				return temp;
		}
		return null;
	}


}
