package com.rmi.login.adfbc.utils;

import java.io.IOException;

import javax.faces.application.FacesMessage;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

public class RmiPasswordEncryptorModel {
    
    public RmiPasswordEncryptorModel() {
        super();
    }
    
    /**
     * Method encrypts password passed as parameter.
     * @param password pass String which is to be encrypted
     * @return String returns encrypted password
     */
    public static String Encrypt(String password)
    {
        try 
        {
            if (password != null) 
            {
                String encryptedPassword = null;
                encryptedPassword = new BASE64Encoder().encode(password.getBytes());
                return encryptedPassword;
            }
        } catch (Exception e) {
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while Encrypting password. Please contact your System Administrator. !",
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        
        return null;
    }
    
    /**
     * Method decrypts password passed as parameter.
     * @param password pass encrypted String which is to be decrypted
     * @return String returns decrypted password
     */
    public static String Decrypt(String password)
    {
        try 
        {
            if (password != null) 
            {
                byte[] decryptedPassword = null;
                decryptedPassword = new BASE64Decoder().decodeBuffer(password);
                return (new String(decryptedPassword));
            }
        } catch (IOException ioe) {
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while Decrypting password. Please contact your System Administrator. !",
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        
        return null;
    }
}
