package org.cocurrency.dao.impl.hibernate;

import org.cocurrency.dao.IPostRepository;
import org.cocurrency.model.Post;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.stereotype.Repository;

@Repository
public class PostRepository extends GenericRepository<Post, Long> implements IPostRepository{

	@Override
	protected Class<Post> getDomainClass() {
		return Post.class;
	}
	
	
    @Override
    public Long getCountPost() {
        Session session = getSession();
        Query query = session.createQuery("select count(*) from " + domainClass.getName() + " e");
        return (Long) query.uniqueResult();
    }

}
