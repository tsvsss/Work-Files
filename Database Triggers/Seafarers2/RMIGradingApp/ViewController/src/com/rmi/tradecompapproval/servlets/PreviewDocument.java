package com.rmi.tradecompapproval.servlets;

import com.rmi.tradecompapproval.adfbc.services.RMITradeCompApprovalAppModuleImpl;

import java.io.IOException;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import javax.sql.DataSource;

import oracle.adf.model.BindingContext;
import oracle.adf.model.DataControlFrame;

import oracle.binding.DataControl;

import oracle.jbo.Row;
import oracle.jbo.ViewObject;
import oracle.jbo.server.ViewObjectImpl;

@WebServlet(name = "PreviewDocument", urlPatterns = { "/previewdocument" })
public class PreviewDocument extends HttpServlet {
private static final String CONTENT_TYPE = "text/html; charset=UTF-8";

public void init(ServletConfig config) throws ServletException {
super.init(config);
}
    
    /**
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
        OutputStream os = null;
        FileInputStream inputStream = null;
        Connection conn = null;
        Context ctx = null;

        try 
        {
            String path = null;
            String edocId = (String) request.getParameter("path");
            String userId = null;
            String mimeType = null;

            System.out.println("edocId in servlet :: " + edocId);
            printTmpLogs("edocId in servlet :: " + edocId);

            if (edocId != null && edocId.trim().length() > 0) 
            {
                if(edocId.trim().equalsIgnoreCase("-1"))
                {
                    userId = (String) request.getParameter("id");
                    
                    System.out.println("userId in servlet :: "+userId);
                    printTmpLogs("userId in servlet :: "+userId);
                    
                    response.setContentType("application/pdf");
                    
                    if(userId != null)
//                        path = "/irid/oracle_files/DEV/seaf_doc/rebuild_temp/mergedfile_"+userId+".pdf";
                        path = "/iridr/oracle_files/DR/seaf_doc/rebuild_temp/mergedfile_"+userId+".pdf";
//                        path = "/irip/oracle_files/PROD/seaf_doc/rebuild_temp/mergedfile_"+userId+".pdf";
                }
                else
                {
//                    DataSource ds = (DataSource) ctx.lookup("jdbc/apps_ds_seaf");
//                    conn = ds.getConnection();
//                    
//                    PreparedStatement filePathPs =
//                        conn.prepareStatement("select iri_edocs_pkg.get_edoc_file_name("+Integer.parseInt(edocId)+") path from dual");
//                    
//                    ResultSet filePathRs = filePathPs.executeQuery();
//                    
//                    while (filePathRs.next()) {
//                        path = filePathRs.getString(1);
//                    }
                    HttpSession session = request.getSession();
                    String dcFrameName = (String) session.getAttribute("DC_FRAME_NAME");
                    BindingContext bctx = BindingContext.getCurrent();
                    DataControlFrame dcframe = bctx.findDataControlFrame(dcFrameName);
//                    DataControl dc = dcframe.findDataControl("RMITradeCompApprovalAppModuleDataControl");
                    
                    System.out.println("dcFrameName in servlet :: "+dcFrameName);                
                    System.out.println("bctx in servlet :: "+bctx);                
                    System.out.println("dcframe in servlet :: "+dcframe);
                    
                    if(dcframe != null)
                    {
                       if(dcframe.findDataControl("RMITradeCompApprovalAppModuleDataControl") != null 
                          && dcframe.findDataControl("RMITradeCompApprovalAppModuleDataControl").getApplicationModule() != null)
                       {
                           ViewObject edocsVo =
                               dcframe.findDataControl("RMITradeCompApprovalAppModuleDataControl").getApplicationModule().findViewObject("GetDocumentLinkView1");
                           edocsVo.setNamedWhereClauseParam("pEdocId", Integer.parseInt(edocId));
                           edocsVo.executeQuery();

                           if (edocsVo.getRowCount() > 0) {
                               Row row = edocsVo.first();
                               path = row.getAttribute("DocPath").toString();
                           }
                       }
                    }
                }
                
                System.out.println("path in servlet :: "+path);
                printTmpLogs("path in servlet :: "+path);
                
                if(path != null && path.trim().length() > 0)
                {
                    if(path.toUpperCase().endsWith(".JPG") || path.toUpperCase().endsWith(".JPEG"))
                        response.setContentType("image/gif");
                    else
                        response.setContentType("application/pdf");                        
                    
                    os = response.getOutputStream();

                    File outputFile = new File(path);
                    inputStream = new FileInputStream(outputFile);
//                    BufferedInputStream in = new BufferedInputStream(inputStream);
                    int b;
                    byte[] buffer = new byte[20480];
                    while ((b = inputStream.read(buffer)) != -1) {
                        os.write(buffer, 0, b);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            //            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while previewing document." +
            //                                             " Please contact your System Administrator." ,
            //                                             "", FacesMessage.SEVERITY_ERROR);
        } finally {
            if (os != null) {
                os.flush();
                os.close();
            }
            if (inputStream != null) {
                inputStream.close();
            }
            try {
                if (conn != null) {
                    conn.close();
                }
                if (ctx != null) {
                    ctx.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }


    /**
     * Method inserts given logs into TMP_SEAFARER_LOGS table.
     * @param logDesc pass log description which you want to print.
     * @return String returns "Y"
     **/
    public void printTmpLogs(Object logDesc)
    {
//        Connection con = null;
//        CallableStatement st = null;
//        Context ctx = null;
//                
//        try 
//        {
//            if(logDesc != null)
//            {
//                try {
//                    ctx = new InitialContext();
//                    DataSource ds = (DataSource) ctx.lookup("jdbc/apps_ds_seaf");
//                    con = ds.getConnection();
//                    st = con.prepareCall("call RMI_SICD_PUB.tmp_logs(?)");
//                    st.setObject(1,logDesc.toString());
//                    st.execute();
//                } catch (Exception e) {
//                    e.printStackTrace();
//                }
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }finally {
//            
//            try {
//                if (st != null) {
//                    st.close();
//                }
//                if (con != null) {
//                    con.close();
//                }
//                if (ctx != null) {
//                    ctx.close();
//                }
//            } catch (Exception e) {
//                e.printStackTrace();
//            }
//        }
    }

}