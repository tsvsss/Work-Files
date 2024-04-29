package oracle.apps.xwrl.beans.servlet;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import oracle.adf.share.logging.ADFLogger;

import org.apache.commons.exec.OS;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.SystemUtils;

public class ShowImageServlet extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=UTF-8";
    private static ADFLogger LOGGER = ADFLogger.createADFLogger(ShowImageServlet.class);
    private String filePath;

    public void init(ServletConfig config) throws ServletException {
        LOGGER.finest("init");
        super.init(config);
        //OS.isFamilyWindows() Note: this stopped working 10/16/2019
        //SystemUtils.IS_OS_WINDOWS
        if (SystemUtils.IS_OS_WINDOWS) {
            filePath = getServletContext().getInitParameter("oracle.apps.xwrl.FILE_UPLOAD_WIN");
        } else {
            filePath = getServletContext().getInitParameter("oracle.apps.xwrl.FILE_UPLOAD_LINUX");
        }
        LOGGER.finest("filePath: " + filePath);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        LOGGER.finest("doGet");
        String fileName = "";
        fileName = request.getParameter("fileName");
        LOGGER.finest("fileName: " + fileName);        
        
        String storagePath = FilenameUtils.getFullPathNoEndSeparator(fileName);
        LOGGER.finest("storagePath: " + storagePath);
        String fileDir = FilenameUtils.getFullPath(fileName);
        LOGGER.finest("fileDir: " + fileDir);
        String fileBase = FilenameUtils.getBaseName(fileName);
        LOGGER.finest("fileBase: " + fileBase);
        String fileExt = FilenameUtils.getExtension(fileName);
        LOGGER.finest("fileExt: " + fileExt);
        
        File file = new File(fileName);
        InputStream inputStream = new FileInputStream(file);
        OutputStream outputStream = response.getOutputStream();
        
        try {
            BufferedInputStream in = new BufferedInputStream(inputStream);
            int bytesRead;
            byte[] buffer = new byte[102404];
            while ((bytesRead = in.read(buffer, 0, 10240)) != -1) {
                LOGGER.finest("bytesRead: " + bytesRead);
                outputStream.write(buffer, 0, bytesRead);
            }            
        } catch (FileNotFoundException fnfe) {
            // TODO: Add catch code
            fnfe.printStackTrace();
        } catch (IOException ioe) {
            // TODO: Add catch code
            ioe.printStackTrace();
        } finally {
            inputStream.close();
            outputStream.close();
        }    
        
    }    
    
}
