package chinh.utils;

import java.io.*;
import java.util.*;
import java.security.*;
import java.security.spec.InvalidKeySpecException;

import javax.crypto.*;
import javax.crypto.spec.*;
import org.apache.commons.codec.binary.Base64;

/**
 * Class which provides methods for encrypting and decrypting
 * strings using a DES encryption algorithm.
 * Strings can be encrypted and then are returned translated
 * into a Base64 Ascii String.
 *
 * @author  Tim Archer 11/11/03
 * @version $Revision: 1.2 $
 */
public class CryptString {

    private Cipher encryptCipher = null;
    private Cipher decryptCipher = null;
    private SecretKey secretKey=null;
    /**
     * Construct a new object which can be utilized to encrypt
     * and decrypt strings using the specified key
     * with a DES encryption algorithm.
     *
     * @param key The secret key used in the crypto operations.
     * @throws Exception If an error occurs.
     *
     */
    
    public CryptString(SecretKey key) throws Exception {
        encryptCipher = Cipher.getInstance("DES");
        decryptCipher = Cipher.getInstance("DES");
        encryptCipher.init(Cipher.ENCRYPT_MODE, key);
        decryptCipher.init(Cipher.DECRYPT_MODE, key);
    }    

    public CryptString() {
		super();
        String password = "adminbusto";
        try {
        	DESKeySpec key = new DESKeySpec(password.getBytes());
            SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
            secretKey=keyFactory.generateSecret(key);
            encryptCipher = Cipher.getInstance("DES");
            decryptCipher = Cipher.getInstance("DES");
            encryptCipher.init(Cipher.ENCRYPT_MODE, (Key) secretKey);
            decryptCipher.init(Cipher.DECRYPT_MODE, (Key) secretKey);
		} catch (InvalidKeyException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (NoSuchPaddingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvalidKeySpecException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        try {
			SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	/**
     * Encrypt a string using DES encryption, and return the encrypted
     * string as a base64 encoded string.
     * @param unencryptedString The string to encrypt.
     * @return String The DES encrypted and base 64 encoded string.
     * @throws Exception If an error occurs.
     */
    public String encryptBase64 (String unencryptedString) throws Exception {
        // Encode the string into bytes using utf-8
        byte[] unencryptedByteArray = unencryptedString.getBytes("UTF8");

        // Encrypt
        byte[] encryptedBytes = encryptCipher.doFinal(unencryptedByteArray);

        // Encode bytes to base64 to get a string
        byte [] encodedBytes = Base64.encodeBase64(encryptedBytes);

        return new String(encodedBytes);
    }

    /**
     * Decrypt a base64 encoded, DES encrypted string and return
     * the unencrypted string.
     * @param encryptedString The base64 encoded string to decrypt.
     * @return String The decrypted string.
     * @throws Exception If an error occurs.
     */
    public String decryptBase64 (String encryptedString) throws Exception {
        // Encode bytes to base64 to get a string
        byte [] decodedBytes = Base64.decodeBase64(encryptedString.getBytes());

        // Decrypt
        byte[] unencryptedByteArray = decryptCipher.doFinal(decodedBytes);

        // Decode using utf-8
        return new String(unencryptedByteArray, "UTF8");
    }    

    /**
     * Main unit test method.
     * @param args Command line arguments.
     *
     */
    public static void main(String args[]) {
        try {
            //Generate the secret key
            String password = "secretpassword";
            DESKeySpec key = new DESKeySpec(password.getBytes());
            SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");

            //Instantiate the encrypter/decrypter
            CryptString crypt = new CryptString(keyFactory.generateSecret(key));
//            String unencryptedString = "123456789";
//            String encryptedString = crypt.encryptBase64(unencryptedString);
//            System.out.println("Encrypted String:"+encryptedString);

            //Decrypt the string
//            unencryptedString = crypt.decryptBase64(encryptedString);
//            System.out.println("UnEncrypted String:"+unencryptedString);
            
            CryptString crypt2=new CryptString();
            String pass="123456789";
            String encryptedString2=crypt2.encryptBase64(pass);
            System.out.println("Encrypted String:"+encryptedString2);
            String unencryptedString2=crypt2.decryptBase64("C9o5TsnOPJHWkWjp9FE5mA==");
            System.out.println("UnEncrypted String:"+unencryptedString2);

        } catch (Exception e) {
            System.err.println("Error:"+e.toString());
        }
    }
}
