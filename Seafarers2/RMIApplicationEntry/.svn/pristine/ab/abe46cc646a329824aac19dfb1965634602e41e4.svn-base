package com.rmi.applicationEntry.view.servlets;

import com.rmi.applicationEntry.view.utils.ADFUtils;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.faces.application.FacesMessage;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.sql.DataSource;

import oracle.adf.model.BindingContext;
import oracle.adf.model.DataControlFrame;
import oracle.adf.share.ADFContext;

import oracle.jbo.Row;
import oracle.jbo.ViewObject;

public class PreviewDocumentServlet extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=UTF-8";

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            OutputStream os = null;
            InputStream inputStream = null;
            Connection conn = null;
            Context ctx = null;
            HttpSession session = ((HttpServletRequest) request).getSession();

                   try 
                   {
                       String path = null; //(request.getParameter("path"));
                       String edocId = (String) request.getParameter("path");
                       String userId = null;
                       String contentType = "N";

                       System.out.println("edocId in servlet :: " + edocId);
                       if(session != null)
                           System.out.println("UserId in servlet :: " + session.getAttribute("UserId"));
//                       printTmpLogs("edocId in servlet :: " + edocId);

                       if (edocId != null && edocId.trim().length() > 0) 
                       {
                           if(edocId.trim().equalsIgnoreCase("-1"))
                           {
                                  if(session.getAttribute("userid") != null)
                                  {
                                   response.setContentType("application/pdf");
                                   contentType = "Y";
                                  path = (String) session.getAttribute("userid");
                                  }
                                System.out.println(path+"---cra path");  
                           }
                           else if(edocId.trim().equalsIgnoreCase("-2"))
                           {
//                               HttpSession session = ((HttpServletRequest) request).getSession();
                               if(session.getAttribute("userid") != null)
                               {                               
                                   response.setContentType("application/postscript");
                                   contentType = "Y";
                                   path = (String) session.getAttribute("userid");
                               }
                                System.out.println("output file :: "+path);  
                           }
                           else if(edocId.trim().equalsIgnoreCase("-3"))
                           {
//                               HttpSession session = ((HttpServletRequest) request).getSession();
                               if(session.getAttribute("userid") != null)
                               {
//                                   response.setContentType("text/html");
                                   response.setContentType("text/plain");
                                   response.setCharacterEncoding("UTF-8");
                                   contentType = "Y";
                                   path = (String) session.getAttribute("userid");
                               }
                                System.out.println("log file :: "+path); 
                           }
                           else
                           {
                               
//                               ctx = new InitialContext();
//                               DataSource ds = (DataSource) ctx.lookup("jdbc/apps_ds_seaf");
//                               conn = ds.getConnection();
//                               
//                               PreparedStatement filePathPs =
//                                   conn.prepareStatement("select iri_edocs_pkg.get_edoc_file_name("+Integer.parseInt(edocId)+") path from dual");
//                               
//                               ResultSet filePathRs = filePathPs.executeQuery();
//                               
//                               while (filePathRs.next()) {
//                                   path = filePathRs.getString(1);
//                               }
                               
//                                    HttpSession session = request.getSession();
                                    String dcFrameName = (String) session.getAttribute("DC_FRAME_NAME");
                                    BindingContext bctx = BindingContext.getCurrent();
                                    DataControlFrame dcframe = bctx.findDataControlFrame(dcFrameName);
                //                    DataControl dc = dcframe.findDataControl("RMITradeCompApprovalAppModuleDataControl");
                                    
                                    System.out.println("dcFrameName in servlet :: "+dcFrameName);                
                                    System.out.println("bctx in servlet :: "+bctx);                
                                    System.out.println("dcframe in servlet :: "+dcframe);
                                    
                                    if(dcframe != null)
                                    {
                                        ViewObject edocsVo =
                                            dcframe.findDataControl("RMIApplicationEntryAppModuleDataControl").getApplicationModule().findViewObject("GetDocumentLinkView");
                                        edocsVo.setNamedWhereClauseParam("pEdocId", Integer.parseInt(edocId));
                                        edocsVo.executeQuery();
                
                                        if (edocsVo.getRowCount() > 0) {
                                            Row row = edocsVo.first();
                                            path = row.getAttribute("DocPath").toString();
                                        }
                                        //
                                        //                        RMITradeCompApprovalAppModuleImpl am = (RMITradeCompApprovalAppModuleImpl) dc.getDataProvider();
                                        //                        if(am != null)
                                        //                        {
                                        //
                                        //                        }
                                    }                         
                           }
                           
                           System.out.println("path in servlet :: "+path);
//                           printTmpLogs("path in servlet :: "+path);
                           
                           if(path != null && path.trim().length() > 0)
                           {
                               if(contentType.equalsIgnoreCase("N"))
                               {
                                   if(path.toUpperCase().endsWith(".JPG") || path.toUpperCase().endsWith(".JPEG"))
                                       response.setContentType("image/gif");
                                   else
                                       response.setContentType("application/pdf");                        
                               }
                               
                               os = response.getOutputStream();
                               
                               os = response.getOutputStream();

                               File outputFile = new File(path);
                               inputStream = new FileInputStream(outputFile);
//                               BufferedInputStream in = new BufferedInputStream(inputStream);
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
}
