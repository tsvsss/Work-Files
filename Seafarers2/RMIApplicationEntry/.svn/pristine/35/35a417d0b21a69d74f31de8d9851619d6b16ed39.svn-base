package com.rmi.applicationEntry.view.utils;

import com.rmi.tradecompapproval.utils.IriJsfUtils;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import java.io.OutputStream;

import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;

import oracle.adf.model.binding.DCBindingContainer;

import oracle.binding.BindingContainer;

import oracle.binding.OperationBinding;

import org.apache.commons.io.IOUtils;
import org.apache.myfaces.trinidad.model.UploadedFile;

public class ADFUtils {
    public static int uploadFile(InputStream is,String path) throws MalformedURLException, IOException {
//        System.out.println(path+"------path");
      int responseCode = 0;
      HttpURLConnection connection;
      OutputStream outputStream;
      if(is != null && (path != null && !"".equals(path)))
      {
      URL url =
        new URL("http://dev-ebs.register-iri.com/OA_HTML/FileUploadService.jsp?path="+path);
//          new URL("http://localhost:7101/RMIApplicationEntry-ViewController-context-root/faces/FileUploadService.jsp?path="+path);

      connection = (HttpURLConnection)url.openConnection();
//      System.out.println(connection+"--------connection");
      connection.setRequestMethod("POST");
      connection.setRequestProperty("Content-Type", "multipart/form-data;");
      connection.setUseCaches(false);
      connection.setDoInput(true);
      connection.setDoOutput(true);
      outputStream = connection.getOutputStream();
      IOUtils.copy(is, outputStream);

      responseCode = connection.getResponseCode();
      System.out.println("RESPONSE CODE---------->>>>"+responseCode);
      }
      return responseCode;
    }

    /**Method to upload file to actual path on Server*/
    public static String uploadFile(UploadedFile file, String path) {

        UploadedFile uploadedFile = file;

        if (uploadedFile != null && (path != null && path.trim().length() > 0)) {
            System.out.println("path :: " + path);
            InputStream inputStream = null;
            try {
                FileOutputStream out = new FileOutputStream(path);
                inputStream = uploadedFile.getInputStream();
                byte[] buffer = new byte[10240];
                int bytesRead = 0;
                while ((bytesRead = inputStream.read(buffer, 0, 10240)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
                out.flush();
                out.close();
            } catch (Exception e) {
                // handle exception
                e.printStackTrace();
            } finally {
                try {
                    inputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return path;
    }
    
    public static void addFormattedFacesErrorMessage(String header, String detail,
                                                   javax.faces.application.FacesMessage.Severity severity) 
      {
          StringBuilder saveMsg = new StringBuilder("<html><body><b><span style='color:");
          
          if(severity != null)
          {
              if(severity.toString().equalsIgnoreCase("INFO 0"))
                  saveMsg.append("#000000'>");
              else if(severity.toString().equalsIgnoreCase("WARN 1"))
                  saveMsg.append("#000000'>");
              else if(severity.toString().equalsIgnoreCase("ERROR 2"))
                  saveMsg.append("#000000'>");
              else
                  saveMsg.append("#000000'>");
          }
          else
              saveMsg.append("#000000'>");
          
          saveMsg.append(header);
          saveMsg.append("</span></b>");
          saveMsg.append("</br><b>");
      //        saveMsg.append(detail);
          saveMsg.append("</b></body></html>");
          FacesMessage msg = new FacesMessage(saveMsg.toString());
          msg.setSeverity(severity);
          FacesContext.getCurrentInstance().addMessage(null, msg);
      }

    /**
     * Find an operation binding in the current binding container by name.
     *
     * @param name operation binding name
     * @return operation binding
     */
    public static OperationBinding findOperation(String name) {
        OperationBinding op = getDCBindingContainer().getOperationBinding(name);
        if (op == null) {
            throw new RuntimeException("Operation '" + name + "' not found");
        }
        return op;
    }
    
    /**
     * Return the current page's binding container.
     * @return the current page's binding container
     */
    public static BindingContainer getBindingContainer() {
        return (BindingContainer) IriJsfUtils.resolveExpression("#{bindings}");
    }

    /**
     * Return the Binding Container as a DCBindingContainer.
     * @return current binding container as a DCBindingContainer
     */
    public static DCBindingContainer getDCBindingContainer() {
        return (DCBindingContainer) getBindingContainer();
    }
}
