package org.cocurrency.service.impl;


import org.cocurrency.dao.IGenericRepository;
import org.cocurrency.dao.IPostRepository;
import org.cocurrency.model.Post;
import org.cocurrency.service.IPostService;
import org.hibernate.LockMode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContextException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PostService extends GenericService<Post, Long> implements IPostService{

	@Autowired
	private IPostRepository iPostRepository;
	
	@Override
	protected IGenericRepository<Post, Long> getGenericRepo() {
		return iPostRepository;
	}
	
	
	@Transactional
	@Override
	public void savePostWithDelay() {
		Post entity=new Post();
		entity.setTitle("Some Awesome Newsssss");
		super.save(entity);
		try {
			Thread.sleep(15000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		throw new ApplicationContextException("exception");
		
	}
	
	@Transactional(isolation=Isolation.READ_UNCOMMITTED)
	@Override
	public Long toSeeReadUncommited() {
		Long countPost=iPostRepository.getCountPost();
		System.out.println(countPost);
		return countPost;
	}
	
	
	@Transactional(isolation=Isolation.READ_COMMITTED)
	@Override
	public void updatePostWithWaitReadCommitted(){
		Post entity=loadByEntityId(1L);
		entity.setTitle("ACID");
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
		Post entity=loadByEntityId(1L);
		entity.setTitle("Isolation");
		super.save(entity);
	
	}
	
	@Transactional(isolation=Isolation.READ_COMMITTED) 
	@Override
	public void updatePostReadCommittedAndRollback(){
		Post entity=loadByEntityId(1L);
		entity.setTitle("BASE");
		super.save(entity);
		try {
			Thread.sleep(15000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		throw new ApplicationContextException("exception");
	
	}
	
	@Transactional(isolation=Isolation.SERIALIZABLE)
	@Override
	public void updatePostWithWaitSerializable(){
		Post entity=loadByEntityId(1L);
		entity.setTitle("ACID-Serializable");
		super.save(entity);
		try {
			Thread.sleep(15000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	@Transactional(isolation=Isolation.SERIALIZABLE) 
	@Override
	public void updatePostSerializable(){
		Post entity=loadByEntityId(1L);
		entity.setTitle("Isolation-Serializable");
		super.save(entity);
	
	}
	
	@Transactional(isolation=Isolation.READ_COMMITTED) 
	@Override
	public void updatePostDatabselockWithWait(){
		Post entity=loadByEntityId(1L,LockMode.UPGRADE_NOWAIT);
		entity.setTitle("Acid-upgradenowait");
		try {
			Thread.sleep(15000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		super.save(entity);
	
	}
	
	
	@Transactional(isolation=Isolation.READ_COMMITTED) 
	@Override
	public void updatePostDatabselock(){
		Post entity=loadByEntityId(1L,LockMode.UPGRADE_NOWAIT);
		entity.setTitle("Isolation-upgradenowait");
		
		super.save(entity);
	
	}
	
	
	
	
	
}
