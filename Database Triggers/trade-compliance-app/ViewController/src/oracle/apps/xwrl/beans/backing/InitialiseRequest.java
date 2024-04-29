package oracle.apps.xwrl.beans.backing;

import com.rmi.manualtradecompliance.utils.ADFUtils;
import com.rmi.manualtradecompliance.utils.IRIUtils;

import com.rmi.manualtradecompliance.utils.JSFUtils;

import java.io.IOException;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;

import oracle.adf.controller.AdfcIllegalArgumentException;
import oracle.adf.controller.ControllerContext;
import oracle.adf.share.ADFContext;

import oracle.adf.share.logging.ADFLogger;

import oracle.apps.xwrl.beans.session.UserRespAndSessionInfo;

import oracle.apps.xwrl.model.am.AppModuleImpl;

import oracle.jbo.Row;

public class InitialiseRequest
{
    private static ADFLogger LOGGER = ADFLogger.createADFLogger(InitialiseRequest.class);
  public InitialiseRequest()
  {
    super();
  }
  IRIUtils utils = new IRIUtils();
  public void onload() 
      {
           AppModuleImpl am = null;
           String reqType = "";
           Map map = null;
           Map sessionMap = null;
          Integer userId = 0;
          String errmsg = "";
          String requestId = "";
          String readMode = "";
          int reqId= 0;
          String status = "";
          ControllerContext controllerCtx = null;
          String superUsr = "";
          String corporateReviewer = "";
        
          try 
          {
              am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
              
              FacesContext fctx = FacesContext.getCurrentInstance();
              ExternalContext ectx = fctx.getExternalContext();
              Map m = ectx.getRequestParameterMap();
              map =  ADFContext.getCurrent().getPageFlowScope();
              sessionMap =  ADFContext.getCurrent().getSessionScope();

              map.put("requestId", m.get("requestId"));
              map.put("psourceTable", m.get("sourceTable"));
              map.put("psourceId", m.get("sourceId"));
              
              LOGGER.finest("requestId in taskflow initialiser:: " + m.get("requestId"));
              LOGGER.finest("requestType in taskflow initialiser:: " + m.get("requestType"));
            try 
            {
                UserRespAndSessionInfo userRespAndSessionInfo = (UserRespAndSessionInfo) JSFUtils.getManagedBeanValue("sessionScope.UserRespAndSessionInfo");
                
                if(userRespAndSessionInfo!=null)
                {
                  superUsr  = userRespAndSessionInfo.getIsSuperUserOnly();
                    corporateReviewer = userRespAndSessionInfo.getIsCorporateReviewer();
                    readMode  = userRespAndSessionInfo.getIsReadOnly();
                }
                
                userId = (Integer) ADFContext.getCurrent().getSessionScope().get("UserId");
                HashMap lckmap = am.owsRequestlock(userId, Integer.parseInt(m.get("requestId").toString()));


                status = utils.nullStrToSpc(lckmap.get("status"));
                errmsg = utils.nullStrToSpc(lckmap.get("errMsg"));


                if ("RECORD LOCKED".equalsIgnoreCase(errmsg) && ("N".equals(superUsr) && "Y".equals(readMode))) 
                {
                    try 
                    {
                            //-- T20221108.0024 - TC Role Based Access Control
                        if ("N".equals(corporateReviewer)) {
                            controllerCtx = ControllerContext.getInstance();
                            String activityURL = controllerCtx.getGlobalViewActivityURL("Error");
                            ectx.redirect(activityURL);    
                        }                        

                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            } catch (AdfcIllegalArgumentException aiae) {
                // TODO: Add catch code
                aiae.printStackTrace();
            } catch (NumberFormatException nfe) {
                // TODO: Add catch code
                nfe.printStackTrace();
            }
            
            // check if the record is locked --  end
            reqType = am.executeRequestView(utils.nullStrToSpc(m.get("requestId")));
            
            if(!"".equals(m.get("requestId")) && m.get("requestId")!=null)
            {
               map.put("requestType", reqType);
            }else
            {
              map.put("requestType", m.get("requestType"));
              
              am.getCaseRestrictedCityLOV1().ensureVariableManager().setVariableValue("varCountryCode","tst");
              am.getCaseRestrictedCityLOV1().executeQuery();
              
              LOGGER.finest("count::"+ am.getCaseRestrictedCityLOV1().getEstimatedRowCount());
            }
              
                LOGGER.finest("Ind cols count::"+ am.getXwrlResponseIndColumnsView1().getEstimatedRangePageCount());
                LOGGER.finest("Ent cols count::"+ am.getXwrlResponseEntityColumnsView1().getEstimatedRangePageCount());
                 
            //  calIndRecordStateCount();
            
            LOGGER.finest("requestType in taskflow initialiser:: " + map.get("requestId"));
            LOGGER.finest("requestType in taskflow initialiser:: " + map.get("requestType"));
              LOGGER.finest("sourceTable in taskflow initialiser:: " + sessionMap.get("sourceTable"));
              LOGGER.finest("sourceId in taskflow initialiser:: " + sessionMap.get("sourceId"));
            
           

              
          } catch (Exception e) {
              // TODO: Add catch code
              e.printStackTrace();
          }
          
      }
  
 
}
