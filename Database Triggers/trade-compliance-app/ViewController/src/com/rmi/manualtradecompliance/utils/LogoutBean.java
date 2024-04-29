package com.rmi.manualtradecompliance.utils;

import com.rmi.manualtradecompliance.adfbc.services.RMIManualTradeComplianceAppModuleImpl;

import java.io.IOException;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import javax.faces.context.FacesContext;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import oracle.adf.share.ADFContext;
import oracle.adf.share.logging.ADFLogger;

import oracle.apps.fnd.ext.common.AppsRequestWrapper;
import oracle.apps.fnd.ext.common.EBiz;


public class LogoutBean {
    public LogoutBean() {
    }
    
    public static final ADFLogger log = ADFLogger.createADFLogger(LogoutBean.class);

    public void homeActionListener() {
        redirect("OA.jsp?OAFunc=OAHOMEPAGE","Home");
    }
    
    public void logoutActionListener() {        
        redirect("OALogout.jsp?menu=Y","Logout");
    }

    private void redirect(String location, String action)
    {
      RMIManualTradeComplianceAppModuleImpl amImpl = null;
        FacesContext fctx = null;
        HttpServletRequest request = null;
        HttpServletResponse response = null;
        Statement datasource = null;      
        Connection connection = null;
        ServletContext servContext = null;
        String applServerID = "";
        EBiz instance = null;
        AppsRequestWrapper wrappedRequest = null;
        String agent = null;
        
        try 
        {
            amImpl = (RMIManualTradeComplianceAppModuleImpl) ADFUtils.getApplicationModuleForDataControl("RMIManualTradeComplianceAppModuleDataControl");
            fctx = FacesContext.getCurrentInstance();
            request = (HttpServletRequest)fctx.getExternalContext().getRequest();
            response = (HttpServletResponse)fctx.getExternalContext().getResponse();
            datasource = amImpl.getDBTransaction().createStatement(0);  
            
            connection = datasource.getConnection();
            servContext = (ServletContext)ADFContext.getCurrent().getEnvironment().getContext();
            applServerID = servContext.getInitParameter("APPL_SERVER_ID_SECURE");
            instance = new EBiz(connection, applServerID);
            //Note: EBS and WL domain needs to be the same (iri.int) othersize session will return null
            wrappedRequest = new AppsRequestWrapper(request, response, connection, instance);
            agent = wrappedRequest.getEbizInstance().getAppsServletAgent();  
            
            try 
            {                
                if (action.equals("Logout"))
                {
                    request.getSession().invalidate();                       
                }
                connection.close();
                response.sendRedirect(agent + location);   
                fctx.responseComplete();
            } catch (IOException e) {
                e.printStackTrace();
                log.severe("IOException while navigating to home or logout:: "+e);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            log.severe("SQLException while navigating to home or logout:: "+e);
        } catch (AppsRequestWrapper.WrapperException e) {
            e.printStackTrace();
            log.severe("AppsRequestWrapperexception while navigating to home or logout:: "+e);
        }
    }
}
