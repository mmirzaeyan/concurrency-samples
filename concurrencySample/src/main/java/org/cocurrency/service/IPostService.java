package org.cocurrency.service;

import org.cocurrency.model.Post;

public interface IPostService extends IGenericService<Post,Long>{
	
	
	public void savePostWithDelay();
	
	public Long toSeeReadUncommited() ;
	
	public void updatePostWithWaitReadCommitted();
	
	public void updatePostReadCommitted();
	
	public void updatePostReadCommittedAndRollback();
	
	public void updatePostWithWaitSerializable();
	
	public void updatePostSerializable();
	
	public void updatePostDatabselockWithWait();
	
	public void updatePostDatabselock();
	
	

}
