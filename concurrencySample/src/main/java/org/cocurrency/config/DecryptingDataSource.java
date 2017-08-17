package org.cocurrency.config;

import java.sql.Connection;
import java.sql.SQLException;


public class DecryptingDataSource extends org.springframework.jdbc.datasource.DriverManagerDataSource  {
	
	private String  username;
	private String  password;
	
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public Connection getConnection() throws SQLException {
		String pass=PBEWithMD5AndDES.decrypt(password);
		return getConnection(username, pass);
	}
}
