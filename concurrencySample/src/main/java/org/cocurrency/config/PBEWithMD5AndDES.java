package org.cocurrency.config;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.Security;
import java.security.spec.InvalidKeySpecException;
import java.util.Set;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.PBEParameterSpec;

import org.apache.commons.codec.binary.Base64;

public class PBEWithMD5AndDES {
	
	
	private static final char[] PASSWORD = "jalalhoseyniinbaharan".toCharArray();     
	private static final byte[] SALT = { (byte) 0xdd, (byte) 0xee, (byte) 0x30, (byte) 0x82, (byte) 0xce, (byte) 0x22, (byte) 0x10, (byte) 0xdd,     };
	private static final String encrypteAlgorithm="PBEWITHSHA1ANDDESEDE";
	
	public static String encrypt(String property) throws GeneralSecurityException {        
		SecretKeyFactory keyFactory = SecretKeyFactory.getInstance(encrypteAlgorithm);         
		SecretKey key = keyFactory.generateSecret(new PBEKeySpec(PASSWORD));         
		Cipher pbeCipher = Cipher.getInstance(encrypteAlgorithm);         
		pbeCipher.init(Cipher.ENCRYPT_MODE, key, new PBEParameterSpec(SALT, 20));         
		return base64Encode(pbeCipher.doFinal(property.getBytes()));     
	}
	
	public static String base64Encode(byte[] bytes) {        
		// NB: This class is internal, and you probably should use another impl         
		//return new BASE64Encoder().encode(bytes);  
		return new Base64().encodeToString(bytes);
	}  
	
	public static String decrypt(String property) {
		SecretKeyFactory keyFactory=null;
		String retValue=null;
		try {
			keyFactory = SecretKeyFactory.getInstance(encrypteAlgorithm);
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}       
		SecretKey key=null;
		try {
			key = keyFactory.generateSecret(new PBEKeySpec(PASSWORD));
		} catch (InvalidKeySpecException e) {
			e.printStackTrace();
		}        
		Cipher pbeCipher=null;
		try {
			pbeCipher = Cipher.getInstance(encrypteAlgorithm);
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		} catch (NoSuchPaddingException e) {
			e.printStackTrace();
		}      
		try {
			pbeCipher.init(Cipher.DECRYPT_MODE, key, new PBEParameterSpec(SALT, 20));
		} catch (InvalidKeyException e) {
			e.printStackTrace();
		} catch (InvalidAlgorithmParameterException e) {
			e.printStackTrace();
		}   
		try {
			 retValue= new String(pbeCipher.doFinal(base64Decode(property)));
		} catch (IllegalBlockSizeException e) {
			e.printStackTrace();
		} catch (BadPaddingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}   
	 return retValue;
	}     
	public static byte[] base64Decode(String property) throws IOException {        
		// NB: This class is internal, and you probably should use another impl     
		//return new BASE64Decoder().decodeBuffer(property);    
		return new Base64().decodeBase64(property);
	} 

	public static String SHA(String password){
        MessageDigest md = null;
		try {
			md = MessageDigest.getInstance("sha");
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
        md.update(password.getBytes());
 
        byte byteData[] = md.digest();
        System.out.println("aaaaaa------>"+ base64Encode(byteData));
        
        //convert the byte to hex format method 1
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < byteData.length; i++) {
         sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
        }
 
        System.out.println("Hex format : " + sb.toString());
 
        //convert the byte to hex format method 2
        StringBuffer hexString = new StringBuffer();
    	for (int i=0;i<byteData.length;i++) {
    		String hex=Integer.toHexString(0xff & byteData[i]);
   	     	if(hex.length()==1) hexString.append('0');
   	     	hexString.append(hex);
    	}
    	System.out.println("Hex format : " + hexString.toString());
    	return hexString.toString();
	}

	public static void main(String[] args) throws Exception {   
		 try {
	            Set<String> algorithms = Security.getAlgorithms("Cipher");
	            for(String algorithm: algorithms) {
	                int max;
	                max = Cipher.getMaxAllowedKeyLength(algorithm);
	                System.out.printf("%-22s: %dbit%n", algorithm, max);
	            }
	        } catch (NoSuchAlgorithmException e) {
	            e.printStackTrace();
	        }

			String originalPassword = "postgres";         
			System.out.println("Original password: " + originalPassword);        
			String encryptedPassword = encrypt(originalPassword);         
			System.out.println("Encrypted password: " + encryptedPassword);      
			String decryptedPassword = decrypt("c2805d6fad56ca9493938598db1538ae15f686fe");         
			System.out.println("Decrypted password: " + decryptedPassword);
			
			String hashPassword = SHA("p@ssw0rd");         
			System.out.println("SHA:" + hashPassword);
 
		}      
}
