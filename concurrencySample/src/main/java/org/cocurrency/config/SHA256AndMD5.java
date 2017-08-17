package org.codePlus.framework.common.core.encryption;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class SHA256AndMD5 {     
	public static String getSHA256(String input) {        
		try {           
				MessageDigest md = MessageDigest.getInstance("SHA-256");          
				byte[] messageDigest = md.digest(input.getBytes());          
				BigInteger number = new BigInteger(1, messageDigest);           
				String hashtext = number.toString(16);            
				// Now we need to zero pad it if you actually want the full 32 chars.    
				while (hashtext.length() < 32) {                 
					hashtext = "0" + hashtext;            
 					} 
				return hashtext;         }        
				catch (NoSuchAlgorithmException e) {            
					throw new RuntimeException(e);        
				}    
	}       
	
	public static void main(String[] args) throws NoSuchAlgorithmException {         
		System.out.println(getSHA256("admin"));     
		
	} 
	
}

