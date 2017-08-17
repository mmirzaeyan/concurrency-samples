package org.cocurrency.dao;

import org.cocurrency.model.User;

public interface IUserRepository extends IGenericRepository<User, Long>{

	public User getUserByUsername(String username);
	
}
