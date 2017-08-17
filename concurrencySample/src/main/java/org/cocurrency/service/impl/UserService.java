package org.cocurrency.service.impl;

import org.cocurrency.config.PBEWithMD5AndDES;
import org.cocurrency.dao.IGenericRepository;
import org.cocurrency.dao.IUserRepository;
import org.cocurrency.model.User;
import org.cocurrency.service.IUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author mohammad
 */
@Service
public class UserService extends GenericService<User, Long> implements IUserService {

    @Autowired(required = true)
    private IUserRepository iUserRepository;


    @Override
    protected IGenericRepository<User, Long> getGenericRepo() {
        return iUserRepository;
    }

    @Override
    public User loadByUsername(String username) {
        return iUserRepository.getUserByUsername(username);
    }


    @Transactional
    @Override
    public Long save(User entity) {
        entity.setPassWord(PBEWithMD5AndDES.SHA(entity.getPassWord()));
        return super.save(entity);
    }

}
