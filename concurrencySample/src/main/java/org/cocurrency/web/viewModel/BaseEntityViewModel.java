package org.codePlus.framework.web.viewModel;

import java.io.Serializable;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public abstract class BaseEntityViewModel<T> implements Serializable  {
	
	private static final long serialVersionUID = 4295229462159851306L;

	private T id;
	
	private String ip="127.0.0.1";
	private Integer version=Integer.valueOf(0);
	private Date createdDate;
	
	
	public Date getCreatedDate() {
		return createdDate;
	}
	@JsonProperty
	public void setCreatedDate(Date createdDate) {
		this.createdDate = createdDate;
	}
	public BaseEntityViewModel() {
		super();
	}
	public BaseEntityViewModel(T id) {
		super();
		this.id = id;
	}
	public T getId() {
		return id;
	}
	public void setId(T id) {
		this.id = id;
	}
	
	@JsonIgnore
	public String getIp() {
		return ip;
	}
	@JsonProperty
	public void setIp(String ip) {
		this.ip = ip;
	}
	public Integer getVersion() {
		return version;
	}
	public void setVersion(Integer version) {
		this.version = version;
	}
	
	
	
}
