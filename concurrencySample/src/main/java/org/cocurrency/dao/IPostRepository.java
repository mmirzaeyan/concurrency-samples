package org.cocurrency.dao;

import org.cocurrency.model.Post;

public interface IPostRepository extends IGenericRepository<Post, Long>{
	
	 public Long getCountPost() ;

}
