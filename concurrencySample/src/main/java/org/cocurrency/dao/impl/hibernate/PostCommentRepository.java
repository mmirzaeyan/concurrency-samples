package org.cocurrency.dao.impl.hibernate;

import org.cocurrency.dao.IPostCommentRepository;
import org.cocurrency.model.PostComment;
import org.springframework.stereotype.Repository;

@Repository
public class PostCommentRepository extends GenericRepository<PostComment, Long> implements IPostCommentRepository{

	@Override
	protected Class<PostComment> getDomainClass() {
		return PostComment.class;
	}

	
}
