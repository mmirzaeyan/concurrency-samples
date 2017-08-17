package org.cocurrency.model;

public class PostComment extends BaseEntity<Long>{
	
	private Post post;
    private String review;

    
	public Post getPost() {
		return post;
	}

	public void setPost(Post post) {
		this.post = post;
	}

	public String getReview() {
		return review;
	}

	public void setReview(String review) {
		this.review = review;
	}

}
