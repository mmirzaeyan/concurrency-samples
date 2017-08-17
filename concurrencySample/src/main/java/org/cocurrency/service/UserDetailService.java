package org.cocurrency.service;

import java.util.HashSet;
import java.util.Set;

import org.cocurrency.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;

@Component
public class UserDetailService implements UserDetailsService {

	@Autowired(required=true)
	private IUserService userService;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		User userEntity = userService.loadByUsername(username);
		
		if (userEntity == null)
			throw new UsernameNotFoundException("user not found");
		Set<GrantedAuthority> grant = new HashSet<GrantedAuthority>();
		if (userEntity!=null && userEntity.isAdmin()){
			grant.add(new SimpleGrantedAuthority("ROLE_USER"));
			grant.add(new SimpleGrantedAuthority("ROLE_ADMIN"));
			userEntity.setAuthorities(grant);
		}
		else{
			grant.add(new SimpleGrantedAuthority("ROLE_USER"));
			userEntity.setAuthorities(grant);
		}
		
		return userEntity;
	}
}
