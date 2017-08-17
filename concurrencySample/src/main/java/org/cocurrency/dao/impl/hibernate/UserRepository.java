
package org.cocurrency.dao.impl.hibernate;

import org.cocurrency.dao.IUserRepository;
import org.cocurrency.model.User;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.stereotype.Repository;

/**
 * @author mohammad
 */
@Repository
public class UserRepository extends GenericRepository<User, Long> implements IUserRepository {

    @Override
    protected Class<User> getDomainClass() {
        return User.class;
    }

    @Override
    public User getUserByUsername(String username) {
        Session session = getSession();
        Query query = session.createQuery("from " + domainClass.getName() + " e where e.userName=:username");
        query.setParameter("username", username);
        return (User) query.uniqueResult();
    }



}
