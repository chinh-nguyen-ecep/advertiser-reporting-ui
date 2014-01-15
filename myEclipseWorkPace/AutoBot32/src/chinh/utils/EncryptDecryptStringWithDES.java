package chinh.utils;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;

import com.sun.mail.util.BASE64DecoderStream;
import com.sun.mail.util.BASE64EncoderStream;

public class EncryptDecryptStringWithDES {

	private Cipher ecipher;
	private Cipher dcipher;
	private SecretKey key;

	public EncryptDecryptStringWithDES() {
		super();
		try {
		// generate secret key using DES algorithm
		try {
			key = readKeyFromFile("myKey");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		ecipher = Cipher.getInstance("DES");
		dcipher = Cipher.getInstance("DES");

		// initialize the ciphers with the given key

	  ecipher.init(Cipher.ENCRYPT_MODE, key);
	
	  dcipher.init(Cipher.DECRYPT_MODE, key);
		}
		catch (NoSuchAlgorithmException e) {
			System.out.println("No Such Algorithm:" + e.getMessage());
		}
		catch (NoSuchPaddingException e) {
			System.out.println("No Such Padding:" + e.getMessage());
		}
		catch (InvalidKeyException e) {
			System.out.println("Invalid Key:" + e.getMessage());
		}
	}

	public static void main(String[] args) {
		EncryptDecryptStringWithDES a=new EncryptDecryptStringWithDES();
		String pass="asd123fg";
		String code=a.encrypt(pass);
		System.out.println(code);
		
		System.out.println(a.decrypt(code));
		
		//write key
//		try {
//			a.generateKey("myKey");
//		} catch (NoSuchAlgorithmException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}

	}
	public void generateKey(String file) throws NoSuchAlgorithmException, IOException{
		SecretKey key=KeyGenerator.getInstance("DES").generateKey();
		FileOutputStream fileOutputStream=new FileOutputStream(file);
		ObjectOutputStream oout = new ObjectOutputStream(fileOutputStream);
		try {
		  oout.writeObject(key);
		} finally {
			fileOutputStream.close();
		  oout.close();
		}		
	}
	public SecretKey readKeyFromFile(String file) throws IOException, ClassNotFoundException{
		SecretKey result=null;
		FileInputStream fileInputStream=new FileInputStream(file);
		ObjectInputStream oin = new ObjectInputStream(fileInputStream);
		try {
			result = (SecretKey) oin.readObject();
		} finally {
		  oin.close();
		  fileInputStream.close();
		}
		return result;
	} 

	public String encrypt(String str) {

	  try {
	
	  	// encode the string into a sequence of bytes using the named charset
	
	  	// storing the result into a new byte array. 
	
	  	byte[] utf8 = str.getBytes("UTF8");
		
		byte[] enc = ecipher.doFinal(utf8);
		
		// encode to base64
		
		enc = BASE64EncoderStream.encode(enc);
		
		return new String(enc);
		
		  }
		
		  catch (Exception e) {
		
		  	e.printStackTrace();
		
		  }
		
		  return null;
		
		    }
		
			public String decrypt(String str) {
		
		  try {
		
		  	// decode with base64 to get bytes
		
			byte[] dec = BASE64DecoderStream.decode(str.getBytes());
			
			byte[] utf8 = dcipher.doFinal(dec);
			
			// create new string based on the specified charset
			
			return new String(utf8, "UTF8");
		
		  }
		
		  catch (Exception e) {
		
		  	e.printStackTrace();
		
		  }
		
		  return null;

    }

}
