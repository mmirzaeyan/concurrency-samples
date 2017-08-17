package org.cocurrency.service;

import org.cocurrency.model.PostComment;

public interface IPostCommentService extends IGenericService< PostComment,Long>{
	
	public Long saveToShowIncreamentTheVersion() ;
	
	public void updatePostCommentWithWaitReadCommitted();
	
	public void updatePostReadCommitted();

}
