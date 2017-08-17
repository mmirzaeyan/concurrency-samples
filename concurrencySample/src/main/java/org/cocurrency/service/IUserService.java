package org.cocurrency.service;

import org.cocurrency.model.User;

public interface IUserService extends IGenericService<User, Long>{

	public User loadByUsername(String username) ;
	
}
