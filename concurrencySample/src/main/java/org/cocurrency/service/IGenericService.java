package org.cocurrency.service;

import java.io.Serializable;
import java.util.List;
import java.util.Set;

import org.hibernate.LockMode;

public interface IGenericService<T,PK extends Serializable> {
	
	public List<T> getAll();
	

	public T loadByEntityId(PK entityId);
	
	public T loadByEntityId(PK entityId,LockMode lockMode);
	
	public void refresh(T entity);
	
	public T single(String where);
	
	public void add(T entity);
	
	public void add(Set<T> entities);
	
	public boolean delete(T entity);
	
	public boolean delete(Set<PK> entity);
	
	public boolean deleteByEntityId(PK entityId);
	
	public void update(T entity);
	
	public PK save(T entity);
	
	public boolean save(Set<T> entity);
	
	public boolean save(List<T> entities);
	
	public int count();

}
