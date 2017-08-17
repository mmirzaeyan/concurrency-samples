package org.cocurrency.web;

import org.cocurrency.service.IPostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/post")
public class PostController {

	@Autowired
	private IPostService iPostService;

	@RequestMapping(value = "/savePostWithDelay", method = RequestMethod.POST)
	@ResponseBody
	public void savePostWithDelay() {
		iPostService.savePostWithDelay();
	}
	
	@RequestMapping(value = "/toSeeReadUncommited", method = RequestMethod.GET)
	@ResponseBody
	public void toSeeReadUncommited() {
		iPostService.toSeeReadUncommited();
	}
	
	@RequestMapping(value = "/updatePostWithWait", method = RequestMethod.POST)
	@ResponseBody
	public void updatePostWithWait() {
		iPostService.updatePostWithWaitReadCommitted();
	}
	
	
	@RequestMapping(value = "/updatePost", method = RequestMethod.POST)
	@ResponseBody
	public void updatePost() {
		iPostService.updatePostReadCommitted();
	}
	
	@RequestMapping(value = "/updatePostAndRollback", method = RequestMethod.POST)
	@ResponseBody
	public void updatePostAndRollback() {
		iPostService.updatePostReadCommittedAndRollback();
	}
	
	@RequestMapping(value = "/updatePostWithWaitSerializable", method = RequestMethod.POST)
	@ResponseBody
	public void updatePostWithWaitSerializable() {
		iPostService.updatePostWithWaitSerializable();
	}
	
	@RequestMapping(value = "/updatePostSerializable", method = RequestMethod.POST)
	@ResponseBody
	public void updatePostSerializable() {
		iPostService.updatePostSerializable();
	}
	
	@RequestMapping(value = "/updatePostDatabselockWithWait", method = RequestMethod.POST)
	@ResponseBody
	public void updatePostDatabselockWithWait() {
		iPostService.updatePostDatabselockWithWait();
	}
	
	@RequestMapping(value = "/updatePostDatabselock", method = RequestMethod.POST)
	@ResponseBody
	public void updatePostDatabselock() {
		iPostService.updatePostDatabselock();
	}
	

}
