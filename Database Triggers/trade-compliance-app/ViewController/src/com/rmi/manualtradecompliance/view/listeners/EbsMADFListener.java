package com.rmi.manualtradecompliance.view.listeners;

import com.rmi.manualtradecompliance.adfbc.services.RMIManualTradeComplianceAppModuleImpl;
import com.rmi.manualtradecompliance.utils.ADFUtils;
import com.rmi.manualtradecompliance.utils.IRIUtils;
import com.rmi.manualtradecompliance.utils.JSFUtils;

import java.sql.SQLException;

import java.util.HashMap;

import java.util.Map;

import javax.faces.context.FacesContext;

import javax.servlet.http.HttpSession;

import oracle.adf.controller.v2.lifecycle.Lifecycle;
import oracle.adf.controller.v2.lifecycle.PagePhaseEvent;
import oracle.adf.controller.v2.lifecycle.PagePhaseListener;
import oracle.adf.model.BindingContext;
import oracle.adf.model.binding.DCBindingContainer;
import oracle.adf.model.binding.DCDataControl;
import oracle.adf.share.ADFContext;
import oracle.adf.share.logging.ADFLogger;

import oracle.apps.fnd.ext.common.AppsRequestWrapper;
import oracle.apps.fnd.ext.common.CookieStatus;
import oracle.apps.xwrl.beans.session.UserRespAndSessionInfo;


public class EbsMADFListener implements PagePhaseListener{
    private static ADFLogger LOGGER = ADFLogger.createADFLogger(EbsMADFListener.class);
    public EbsMADFListener() {
        super();
    }
    
    public String nullStrToSpc(Object obj) {
        String spcStr = "";

        if (obj == null) {
            return spcStr;
        } else {
            return obj.toString();
        }
    }

    AppsRequestWrapper wrappedRequest = null;
    CookieStatus icxCookieStatus = null;

    public void beforePhase(PagePhaseEvent pagePhaseEvent) {
        LOGGER.finest("beforePhase");
        BindingContext bctx = null;
        DCBindingContainer dcBindingContainer = null;
        DCDataControl dc = null;
        RMIManualTradeComplianceAppModuleImpl am = null;
        RMIManualTradeComplianceAppModuleImpl amImpl = null;
        HashMap hm = null;

        FacesContext ctx = null;
        HttpSession session = null;

        if (pagePhaseEvent.getPhaseId() == Lifecycle.INIT_CONTEXT_ID) 
        {

           

     try
      {
        bctx = BindingContext.getCurrent();
          new IRIUtils().initVersionAYear();
         if(bctx!=null)
         {
            dcBindingContainer = (DCBindingContainer) bctx.getCurrentBindingsEntry();
            System.out.println("dcBindingContainer==" + dcBindingContainer);
    
           if(dcBindingContainer!=null)
           {
              dc = dcBindingContainer.findDataControl("RMIManualTradeComplianceAppModuleDataControl");
              System.out.println("DataControl==" + dc);
      
              if (dc == null)
              {
                amImpl = (RMIManualTradeComplianceAppModuleImpl) ADFUtils.getApplicationModuleForDataControl("RMIManualTradeComplianceAppModuleDataControl");
                if(amImpl != null)
                    hm = amImpl.userSessionValidation();
              }
      
              else
              {
                am = (RMIManualTradeComplianceAppModuleImpl) dc.getDataProvider();
                if(am != null)
                    hm = am.userSessionValidation();
              }
           }
         }
      }
      catch (Exception e)
      {
        // TODO: Add catch code
        e.printStackTrace();
        System.out.println("error in first try of before phase: " + e);
      }

           

            try {
                
              ctx = FacesContext.getCurrentInstance();
              session = (HttpSession) ctx.getExternalContext().getSession(false);

              if (am == null) {
                  amImpl = (RMIManualTradeComplianceAppModuleImpl) ADFUtils.getApplicationModuleForDataControl("RMIManualTradeComplianceAppModuleDataControl");
                  if(amImpl != null)
                    hm = amImpl.userSessionValidation();
              }
                
                LOGGER.finest("UserRespAndSessionInfo");
                UserRespAndSessionInfo userRespAndSessionInfo =
                    (UserRespAndSessionInfo) JSFUtils.getManagedBeanValue("sessionScope.UserRespAndSessionInfo");

                if (userRespAndSessionInfo == null) {
                    System.out.println("userRespAndSessionInfo is null");
                    userRespAndSessionInfo = new UserRespAndSessionInfo();
                    // TSUAZO - Uncomment to run on local IWS                    
                    //ADFContext.getCurrent().getSessionScope().put("UserId",1156);
                    //ADFContext.getCurrent().getSessionScope().put("SessionId",7777777);
                    
                }
                if(hm != null){
                    userRespAndSessionInfo.setUserName(nullStrToSpc(hm.get("UserName")));
                    if(hm.get("UserId") != null && !"".equals(hm.get("UserId")))
                        userRespAndSessionInfo.setUserId(Integer.parseInt(nullStrToSpc(hm.get("UserId"))));
                    if(hm.get("SessionId") != null && !"".equals(hm.get("SessionId")))
                        userRespAndSessionInfo.setSessionId(Integer.parseInt(nullStrToSpc(hm.get("SessionId"))));
                    if(hm.get("ResponsibilityId") != null && !"".equals(hm.get("ResponsibilityId")))
                        userRespAndSessionInfo.setResponsibilityId(Integer.parseInt(nullStrToSpc(hm.get("ResponsibilityId"))));
                    userRespAndSessionInfo.setDbName(nullStrToSpc(hm.get("DbName")));
                    userRespAndSessionInfo.setHome(nullStrToSpc(hm.get("Home")));
                    userRespAndSessionInfo.setIsReadOnly(nullStrToSpc(hm.get("isReadOnly")));
                    userRespAndSessionInfo.setIsAdminOnly(nullStrToSpc(hm.get("isAdminMode")));
                    userRespAndSessionInfo.setIsGenericAdminOnly(nullStrToSpc(hm.get("isGenericAdminMode")));
                    userRespAndSessionInfo.setIsSuperUserOnly(nullStrToSpc(hm.get("isSuperUserOnly")));
                    userRespAndSessionInfo.setIsCorporateReviewer(nullStrToSpc(hm.get("isCorporateReviewer")));  //  T20221108.0024 - TC Role Based Access Control
                    userRespAndSessionInfo.setIsRecordLockUser(nullStrToSpc(hm.get("isRecordLockUser")));
                    userRespAndSessionInfo.setResponsibilityName(nullStrToSpc(hm.get("ResponsibilityName")));
                }
                Map sessionMap = ADFContext.getCurrent().getSessionScope();
                userRespAndSessionInfo.setPageTitle("Trade Compliance");

                sessionMap.put("UserId", userRespAndSessionInfo.getUserId());
                sessionMap.put("UserName", userRespAndSessionInfo.getUserName());
                sessionMap.put("SessionId", userRespAndSessionInfo.getSessionId());
                
                if("Y".equals(userRespAndSessionInfo.getIsReadOnly()) || "Y".equals(userRespAndSessionInfo.getIsSuperUserOnly()))
                    sessionMap.put("regionOWSRendered",true);
                else
                    sessionMap.put("regionOWSRendered",false);
                
                sessionMap.put("pFacesServlet","faces");
                JSFUtils.setManagedBeanValue("sessionScope.UserRespAndSessionInfo", userRespAndSessionInfo);

            } catch (Exception e) {
                //log.severe("Error in beforePhase of CustomPageListener: "+ utils.returnStackTrace(e));
                e.printStackTrace();
                System.out.println("error in second try of before phase: " + e);
                
            }
        }

    }

    public void afterPhase(PagePhaseEvent pagePhaseEvent) {

        LOGGER.finest("afterPhase");
        if (!ADFContext.getCurrent().isDesignTime()) {
            if (pagePhaseEvent.getPhaseId() == Lifecycle.PREPARE_RENDER_ID) {
                if (wrappedRequest != null && wrappedRequest.getConnection() != null) {
                    //System.out.println("[afterPhase] Close Connection");
                    try {
                        if (!wrappedRequest.getConnection().isClosed())
                            wrappedRequest.getConnection().close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                        // log.severe("Error in afterPhase of CustomPageListener: "+utils.returnStackTrace(e));

                    }
                    //System.out.println("[afterPhase] Connection Closed");
                }

            }
        }
    }
}
