package chinh.utils;

public class CEncrypt 
{
   static final String key = "Encrypt"; // The key for 'encrypting' and 'decrypting'.

   private static String encryptString(String str)
   {
      StringBuffer sb = new StringBuffer (str);

      int lenStr = str.length();
      int lenKey = key.length();
	   
      //
      // For each character in our string, encrypt it...
      for ( int i = 0, j = 0; i < lenStr; i++, j++ ) 
      {
         if ( j >= lenKey ) j = 0;  // Wrap 'round to beginning of key string.

         //
         // XOR the chars together. Must cast back to char to avoid compile error. 
         //
         sb.setCharAt(i, (char)(str.charAt(i) ^ key.charAt(j))); 
      }

      return sb.toString();
   }
   
   private static String decryptString(String str)
   {
      //
      // To 'decrypt' the string, simply apply the same technique.
      return encryptString(str);
   }
   
   
   public static void main(String[] args) 
   {
      String s1 = "adminsanchikaro";

      String s2 = encryptString(s1);

      String s3 = decryptString(s2);

      System.out.println(s1);

      System.out.println(s2);

      System.out.println(s3);
   }
}