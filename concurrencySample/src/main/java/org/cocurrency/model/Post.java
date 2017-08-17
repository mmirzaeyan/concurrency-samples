package org.cocurrency.model;

public class Post extends BaseEntity<Long>{
	
	private String title;

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}	
	
	
}
