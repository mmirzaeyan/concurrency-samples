package org.cocurrency.web;

import org.cocurrency.model.User;
import org.cocurrency.service.IUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private IUserService iUserService;


    @RequestMapping(value = "/save", method = RequestMethod.POST)
    @ResponseBody
    public Long save(@RequestBody User user) {
        return iUserService.save(user);
    }


    @RequestMapping(value = "/load/{id}", method = RequestMethod.GET)
    @ResponseBody
    public User load(@PathVariable long id) {
        return iUserService.loadByEntityId(id);
    }


    @RequestMapping(value = "/delete/{id}", method = RequestMethod.DELETE)
    @ResponseBody
    public Boolean delete(@PathVariable Long id) {
        return iUserService.deleteByEntityId(id);
    }

}
