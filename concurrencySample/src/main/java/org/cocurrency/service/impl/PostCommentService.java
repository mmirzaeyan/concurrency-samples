package org.cocurrency.service.impl;

import org.cocurrency.dao.IGenericRepository;
import org.cocurrency.dao.IPostCommentRepository;
import org.cocurrency.model.Post;
import org.cocurrency.model.PostComment;
import org.cocurrency.service.IPostCommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PostCommentService extends GenericService<PostComment, Long> implements IPostCommentService{

	
	@Autowired
	private IPostCommentRepository	iPostCommentRepository;
	
	@Override
	protected IGenericRepository<PostComment, Long> getGenericRepo() {
		return iPostCommentRepository;
	}
	
	@Transactional(isolation=Isolation.READ_COMMITTED)
	@Override
	public Long saveToShowIncreamentTheVersion() {
		PostComment entity=loadByEntityId(1L);
		return super.save(entity);
	}
	
	
	@Transactional(isolation=Isolation.READ_COMMITTED)
	@Override
	public void updatePostCommentWithWaitReadCommitted(){
		PostComment entity=loadByEntityId(1L);
		entity.setReview("ACID");
		super.save(entity);
		try {
			Thread.sleep(15000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	
	@Transactional(isolation=Isolation.READ_COMMITTED) 
	@Override
	public void updatePostReadCommitted(){
		PostComment entity=loadByEntityId(1L);
		entity.setReview("Isolation");
		super.save(entity);
	}

}
