package org.cocurrency.model;

import java.io.Serializable;
import java.util.Date;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlTransient;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 * @author mohammad
 *
 */
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler","createdBy","updatedBy"})
@XmlAccessorType(XmlAccessType.FIELD)
public class BaseEntity<T> implements Serializable{
private static final long serialVersionUID = 4295229462159851305L;
	
	private T id;
	
	private Date createdDate=new Date();
	private Date updatedDate=new Date();
	private String ip="127.0.0.1";
	private Integer	version=Integer.valueOf(0);
	
	
	public T getId() {
		return id;
	}
	public void setId(T id) {
		this.id = id;
	}
	public Date getCreatedDate() {
		return createdDate;
	}
	public void setCreatedDate(Date createdDate) {
		this.createdDate = createdDate;
	}
	public Date getUpdatedDate() {
		return updatedDate;
	}
	public void setUpdatedDate(Date updatedDate) {
		this.updatedDate = updatedDate;
	}
	public String getIp() {
		return ip;
	}
	public void setIp(String ip) {
		this.ip = ip;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	public Integer getVersion() {
		return version;
	}
	public void setVersion(Integer version) {
		this.version = version;
	}
	
}
