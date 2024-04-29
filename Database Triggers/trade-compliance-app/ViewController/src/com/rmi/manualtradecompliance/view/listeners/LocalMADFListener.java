package com.rmi.manualtradecompliance.view.listeners;

import com.rmi.manualtradecompliance.utils.IRIUtils;

import com.rmi.manualtradecompliance.utils.JSFUtils;

import oracle.adf.controller.v2.lifecycle.Lifecycle;
import oracle.adf.controller.v2.lifecycle.PagePhaseEvent;
import oracle.adf.controller.v2.lifecycle.PagePhaseListener;
import oracle.adf.share.ADFContext;
import oracle.adf.share.logging.ADFLogger;

import oracle.apps.xwrl.beans.session.UserRespAndSessionInfo;

import oracle.jbo.server.ViewObjectImpl;

public class LocalMADFListener implements PagePhaseListener{
    private static ADFLogger LOGGER = ADFLogger.createADFLogger(LocalMADFListener.class);
    public LocalMADFListener() {
        super();
    }
    
    @Override
    public void afterPhase(PagePhaseEvent pagePhaseEvent) {
        // TODO Implement this method
        LOGGER.finest("afterPhase");
    }

    @Override
    public void beforePhase(PagePhaseEvent pagePhaseEvent) {
        LOGGER.finest("beforePhase");

        if (pagePhaseEvent.getPhaseId() == Lifecycle.INIT_CONTEXT_ID) {

           

            try {
                LOGGER.finest("UserRespAndSessionInfo");
                UserRespAndSessionInfo userRespAndSessionInfo =
                    (UserRespAndSessionInfo) JSFUtils.getManagedBeanValue("sessionScope.UserRespAndSessionInfo");

                if (userRespAndSessionInfo == null) {
                    System.out.println("userRespAndSessionInfo is null");
                    userRespAndSessionInfo = new UserRespAndSessionInfo();
                }

//                userRespAndSessionInfo.setUserName("VTONDAPU");
//                userRespAndSessionInfo.setUserId(7388);
                
//                userRespAndSessionInfo.setUserName("BGUGGILAM");
//                userRespAndSessionInfo.setUserId(12208);
                
//                userRespAndSessionInfo.setUserName("TMORNINGSTAR");
//                userRespAndSessionInfo.setUserId(10216);
                
                userRespAndSessionInfo.setUserName("TSUAZO");
                userRespAndSessionInfo.setUserId(1156);
                
                userRespAndSessionInfo.setSessionId(1234567890);
                userRespAndSessionInfo.setDbName("IRIDEV");
                userRespAndSessionInfo.setResponsibilityName("OWS Application - Local");
                userRespAndSessionInfo.setIsReadOnly("Y");
                userRespAndSessionInfo.setIsAdminOnly("N");
                userRespAndSessionInfo.setIsSuperUserOnly("N");
                userRespAndSessionInfo.setIsCorporateReviewer("Y");
                userRespAndSessionInfo.setIsRecordLockUser("Y");
                
                userRespAndSessionInfo.setIsGenericAdminOnly("Y");
                userRespAndSessionInfo.setPageTitle("Trade Compliance");

                ADFContext.getCurrent().getSessionScope().put("UserId", userRespAndSessionInfo.getUserId());
                ADFContext.getCurrent().getSessionScope().put("UserName", userRespAndSessionInfo.getUserName());
                ADFContext.getCurrent().getSessionScope().put("SessionId", userRespAndSessionInfo.getSessionId());
                
                
                
                new IRIUtils().initVersionAYear();
                JSFUtils.setManagedBeanValue("sessionScope.UserRespAndSessionInfo", userRespAndSessionInfo);

            } catch (Exception e) {
                e.printStackTrace();
                //log.severe("Error in beforePhase of CustomPageListener: "+ utils.returnStackTrace(e));
                LOGGER.finest("error: " + e);
            }
        }        

    }
    
    public String nullStrToSpc(Object obj) {
        String spcStr = "";

        if (obj == null) {
            return spcStr;
        } else {
            return obj.toString();
        }
    }
}
