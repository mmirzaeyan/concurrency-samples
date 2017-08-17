package org.cocurrency.web;

import org.cocurrency.service.IPostCommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/postComment")
public class PostCommentController {
	
	@Autowired
	private IPostCommentService	iPostCommentService;
	
	
	@RequestMapping(value = "/saveToShowIncreamentTheVersion", method = RequestMethod.POST)
	@ResponseBody
	public void saveToShowIncreamentTheVersion() {
		iPostCommentService.saveToShowIncreamentTheVersion();
	}
	
	
	@RequestMapping(value = "/updatePostCommentWithWaitReadCommitted", method = RequestMethod.POST)
	@ResponseBody
	public void updatePostCommentWithWaitReadCommitted() {
		iPostCommentService.updatePostCommentWithWaitReadCommitted();
	}
	
	
	@RequestMapping(value = "/updatePostReadCommitted", method = RequestMethod.POST)
	@ResponseBody
	public void updatePostReadCommitted() {
		iPostCommentService.updatePostReadCommitted();
	}
	
	
	
	
	
	

}
