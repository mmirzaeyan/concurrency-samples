package org.cocurrency.service.impl;

import java.io.Serializable;
import java.util.Date;
import java.util.List;
import java.util.Set;

import org.cocurrency.config.utility.SecurityUtility;
import org.cocurrency.dao.IGenericRepository;
import org.cocurrency.model.BaseEntity;
import org.cocurrency.service.IGenericService;
import org.hibernate.LockMode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public abstract class GenericService<T extends BaseEntity, PK extends Serializable> implements IGenericService<T, PK> {

	@Autowired
	protected abstract IGenericRepository<T, PK> getGenericRepo();

	@Override
	public List<T> getAll() {
		return getGenericRepo().getAll();
	}


	@Override
	public T loadByEntityId(PK entityId) {
		return getGenericRepo().loadByEntityId(entityId);
	}
	
	@Override
	public T loadByEntityId(PK entityId,LockMode lockMode) {
		return getGenericRepo().loadByEntityId(entityId,lockMode);
	}

	@Override
	public T single(String where) {
		return null;
	}

	@Override
	@Transactional
	public void add(T entity) {
		entity.setIp(SecurityUtility.getRequestedIp());
		entity.setCreatedDate(new Date());
		entity.setUpdatedDate(new Date());
		getGenericRepo().add(entity);
	}

	@Override
	public void refresh(T entity) {
		getGenericRepo().refresh(entity);
	}

	@Override
	@Transactional
	public void add(Set<T> entities) {
		getGenericRepo().add(entities);
	}

	@Override
	@Transactional
	public boolean delete(Set<PK> entities) {
		getGenericRepo().delete(entities);
		return true;
	}

	@Override
	@Transactional
	public boolean delete(T entity) {
		getGenericRepo().delete(entity);
		return true;
	}

	@Override
	@Transactional
	public boolean deleteByEntityId(PK entityId) {
		getGenericRepo().deleteByEntityId(entityId);
		return true;
	}

	@Override
	@Transactional
	public void update(T entity) {
		entity.setIp(SecurityUtility.getRequestedIp());
		entity.setCreatedDate(new Date());
		entity.setUpdatedDate(new Date());
		getGenericRepo().update(entity);
	}

	@Override
	public int count() {
		return getGenericRepo().count();
	}

	@Override
	@Transactional
	public PK save(T entity) {
		entity.setIp(SecurityUtility.getRequestedIp());
		entity.setCreatedDate(new Date());
		entity.setUpdatedDate(new Date());
		if (entity.getId() == null) {
			getGenericRepo().add(entity);
		} else if (entity.getId() instanceof Integer) {
			if ((Integer) entity.getId() > 0)
				getGenericRepo().update(entity);
			else
				getGenericRepo().add(entity);
		} else if (entity.getId() instanceof Long) {
			if ((Long) entity.getId() > 0)
				getGenericRepo().update(entity);
			else
				getGenericRepo().add(entity);
		}
		return (PK) entity.getId();
	}

	@Override
	@Transactional
	public boolean save(Set<T> entities) {
		for (T t : entities) {
			save(t);
		}
		return true;
	}

	@Override
	@Transactional
	public boolean save(List<T> entities) {
		for (T t : entities) {
			save(t);
		}
		return true;
	}

}
