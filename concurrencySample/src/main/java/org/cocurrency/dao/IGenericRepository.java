package org.cocurrency.dao;

import java.io.Serializable;
import java.util.List;
import java.util.Set;

import org.hibernate.LockMode;

/**
 * @author M.Mirzaeyan
 */
public interface IGenericRepository<T, PK extends Serializable>{
	public List<T> getAll();

	public <U> List<U> getAllWithCount(String hql, Long count);


	public T loadByEntityId(PK entityId);
	
	public T loadByEntityId(PK entityId,LockMode lockMode);

	public void refresh(T entity);

	public void add(T entity);

	public void add(Set<T> entities);

	public void delete(Set<PK> entities);

	public void delete(T entity);

	public void deleteByEntityId(PK entityId);

	public void update(T entity);

	public int count();


}
