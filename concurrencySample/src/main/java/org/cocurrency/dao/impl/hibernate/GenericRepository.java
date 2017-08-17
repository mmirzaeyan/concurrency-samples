package org.cocurrency.dao.impl.hibernate;


import java.io.Serializable;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;
import org.cocurrency.dao.IGenericRepository;
import org.cocurrency.model.BaseEntity;
import org.hibernate.Criteria;
import org.hibernate.LockMode;
import org.hibernate.LockOptions;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 * @author mohammad
 *
 */
@Repository
public abstract class GenericRepository<T extends BaseEntity,PK extends Serializable>  implements IGenericRepository<T,PK> {

	protected Class<T> domainClass = getDomainClass();

	protected abstract Class<T> getDomainClass();

	protected  final Logger logger = Logger.getLogger(getDomainClass());


	@Autowired
	private SessionFactory sessionFactory;

	public Session getSession() {
        try {
            return sessionFactory.getCurrentSession();
        } catch (Exception e) {
            System.out.println(e.getMessage().toString());
        }
        return sessionFactory.openSession();
    }

	@Override
	public List<T> getAll() {
		Session session =getSession();
		Criteria criteria=session.createCriteria(domainClass.getName());
		return criteria.list();
	}



	@Override
	public T loadByEntityId(PK entityId) {
		Session session = getSession();
		return  (T) session.get(domainClass.getName(), entityId);
	}
	
	@Override
	public T loadByEntityId(PK entityId,LockMode lockMode) {
		Session session = getSession();
		return  (T) session.get(domainClass.getName(), entityId,new LockOptions(lockMode));
	}

	@Override
	public void refresh(T entity) {
		Session session = getSession();
		session.refresh(entity);
	}
	@Override
	public void add(T entity) {
		Session session = getSession();
		session.save(entity);
	}

	@Override
	public void add(Set<T> entities) {
		Session session = getSession();
		for (T t : entities) {
			session.saveOrUpdate(t);
		}
	}

	@Override
	public void delete(Set<PK> entities) {
		for (PK pk : entities) {
			deleteByEntityId(pk);
		}
	}

	@Override
	public void delete(T entity) {
		Session session = getSession();
		session.delete(entity);
	}

	@Override
	public void deleteByEntityId(PK entityId) {
		Session session = getSession();
		T obj=(T) session.load(domainClass, entityId);
		session.delete(obj);
	}

	@Override
	public void update(T entity) {
		Session session = getSession();
		entity=(T)session.merge(entity);
		session.update(entity);
	}

	@Override
	public int count() {
		Session session = getSession();
		Query countQuery = session.createQuery("select count(*) from " + domainClass.getName());
		return ((Long)countQuery.uniqueResult()).intValue();
	}


	@Override
	public <U> List<U> getAllWithCount(String hql,Long count){
		Session session = getSession();


		Query query = session.createQuery(hql);
		if(count!=-1l)
			query.setMaxResults(count.intValue());
		return query.list();
	}

}
