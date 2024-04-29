package oracle.apps.xwrl.beans.servlet;

import java.io.File;
import java.io.IOException;
import java.io.Serializable;

import java.util.Enumeration;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import oracle.adf.share.ADFContext;
import oracle.adf.share.logging.ADFLogger;

import oracle.apps.xwrl.beans.utils.UploadedFiles;

import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;


public class UploadServlet extends HttpServlet implements Serializable {
    private static final String CONTENT_TYPE = "text/html; charset=UTF-8";
    private static ADFLogger LOGGER = ADFLogger.createADFLogger(UploadServlet.class);
    private boolean isMultipart;
    private String filePath;
    private String licensePath;
    private int maxFileSize = 25 * 1024 * 1024;
    private int maxMemSize = 4 * 1024 * 1024;
    private File file;
    List fileItems;

    /*  Not Used 

    public void init(ServletConfig config) throws ServletException {
        LOGGER.finest("UPLOADSERVLET - init");
        super.init(config);
        //OS.isFamilyWindows() Note: this stopped working 10/16/2019
        //SystemUtils.IS_OS_WINDOWS
        if (SystemUtils.IS_OS_WINDOWS) {
            filePath = getServletContext().getInitParameter("oracle.apps.xwrl.FILE_UPLOAD_WIN");
            licensePath = getServletContext().getInitParameter("GROUPDOCS_VIEWER_LICENSE_WIN");
        } else {
            filePath = getServletContext().getInitParameter("oracle.apps.xwrl.FILE_UPLOAD_LINUX");
            licensePath = getServletContext().getInitParameter("GROUPDOCS_VIEWER_LICENSE_LINUX");
        }
        LOGGER.finest("filePath: " + filePath);
    }

    */

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        LOGGER.finest("UPLOADSERVLET -doPost");
        /*
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<html>");
        out.println("<head><title>UploadServlet</title></head>");
        out.println("<body>");
        out.println("<p>The servlet has received a POST. This is the reply.</p>");
        out.println("</body></html>");
        out.close();
        */
        
        // Initialize Parameters
        // Note: pageFlowId is passed to Servlet through Javascript 
        // iriMain.js - Declare global var
        // Upload.jsf - Set global var
        // iriDropzone.js - Send global var to servlet        
        String pageFlowId = null;
        List fileItems = null;
        
        // Get Parameter from URL
        Enumeration<String> parameterNames = request.getParameterNames();
        while (parameterNames.hasMoreElements()) {
            String paramName = parameterNames.nextElement();
            LOGGER.finest("paramName: " + paramName);
            LOGGER.finest("paramName length: " + paramName.length());

            String[] paramValues = request.getParameterValues(paramName);
            for (int i = 0; i < paramValues.length; i++) {
                String paramValue = paramValues[i];
                LOGGER.finest("paramValue: " + paramValue);;              
                if (paramName.trim().equals("pageFlowId")){
                    pageFlowId = paramValue;
                } 
            }
        };
        LOGGER.fine("pageFlowId: " + pageFlowId);
        
        /*
        try {
            var0 = request.getParameter("param0");
        } catch (Exception e) {
            e.printStackTrace();
        }
         */

        // Process Servlet for File Items to return to UploadBacking bean
        try {            
            DiskFileItemFactory factory = new DiskFileItemFactory();
            factory.setSizeThreshold(maxMemSize);
            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setFileSizeMax(maxFileSize); //maximum allowed size of a single uploaded file
            fileItems = upload.parseRequest(request);
            
            UploadedFiles uFiles = (UploadedFiles) request.getSession().getAttribute("UploadedFilesBean");
            if(uFiles == null) {
                uFiles = new UploadedFiles();
                request.getSession().setAttribute("UploadedFilesBean", uFiles);
            }
            
            uFiles.setFilesList(fileItems);
        } catch (FileUploadException e) {
            e.printStackTrace();
        }

        // Return File Items in Session Scope uniquely identified with pageFlowId
        ADFContext adfCtx = ADFContext.getCurrent();
        Map<String, Object> map = adfCtx.getSessionScope();
        map.put(pageFlowId + ".fileItems", fileItems);
        System.out.println("fileItems in session: " + fileItems);

    }

    /* Not Used in Application

    // PRIVATE 
    public void saveAsImage(String fileName, String imageFormat, InputStream inputStream) {
        LOGGER.finest("UPLOADSERVLET - saveAsImage");
        LOGGER.finest("fileName: " + fileName);
        LOGGER.finest("imageFormat: " + imageFormat);

        try {
            File file = new File(fileName + "." + imageFormat);
            ImageIO.write(ImageIO.read(inputStream), imageFormat, file);
        } catch (IOException exp) {
            System.out.println("\"saveAsImage: " + exp.getMessage());
            exp.printStackTrace();
        }

    }

    private void showPageScopeMap(Map pageFlowMap) {
        LOGGER.finest("UPLOADSERVLET - showPageScopeMap");
        ADFContext adfCtx = ADFContext.getCurrent();
        Map<String, Object> map = pageFlowMap;
        for (String key : map.keySet()) {
            LOGGER.finest("key: " + key);
            LOGGER.finest("value: " + map.get(key));
        }
    }

    private void showRequestScopeMap() {
        LOGGER.finest("UPLOADSERVLET - showRequestScopeMap");
        ADFContext adfCtx = ADFContext.getCurrent();
        Map<String, Object> map = adfCtx.getRequestScope();
        for (String key : map.keySet()) {
            LOGGER.finest("key: " + key);
            LOGGER.finest("value: " + map.get(key));
        }
        JSFUtils.setManagedBeanValue("requestScope.UploadRequest.scopeMap", map);
    }

    */

}

