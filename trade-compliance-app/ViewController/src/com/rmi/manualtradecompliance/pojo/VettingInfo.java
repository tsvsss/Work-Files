package com.rmi.manualtradecompliance.pojo;

import com.rmi.manualtradecompliance.adfbc.services.RMIManualTradeComplianceAppModuleImpl;
import com.rmi.manualtradecompliance.utils.ADFUtils;
import com.rmi.manualtradecompliance.utils.JSFUtils;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import java.util.Date;
import java.util.logging.Logger;

import javax.faces.application.FacesMessage;

import oracle.jbo.ApplicationModule;
import oracle.jbo.Row;
import oracle.jbo.server.ViewObjectImpl;

public class VettingInfo {    
    private String entityType;
    private String status;
    private String ofacList;
    private String statusDate;
    private String statusUpdatedBy;
    private String screeningID;

    public VettingInfo() {
        super();
    }
    
    public VettingInfo(String screeningID,String nameScreened, String entityType, String status,String ofacList,String statusDate,String statusUpdatedBy) {
        this.screeningID = screeningID;
        this.nameScreened = nameScreened;
        this.entityType = entityType;
        this.status = status;
        this.ofacList = ofacList;
        setStatusDate(statusDate);
        this.statusUpdatedBy = statusUpdatedBy;
    }
    private String nameScreened;
    private String consentRcvd;

    public void setConsentRcvd(String consentRcvd) {
        this.consentRcvd = consentRcvd;
    }

    public String getConsentRcvd() 
    {
        try 
        {
            if (this.consentRcvd != null)
                return consentRcvd;
            else {
                ViewObjectImpl crVo = getAm().getConsentReceivedView();
                crVo.setNamedWhereClauseParam("pWcScreenReqId", getScreeningID());
                crVo.executeQuery();
                Row[] crRows = crVo.getAllRowsInRange();

                if (crRows.length > 0 && crRows[0].getAttribute("ConsentReceived") != null) {
                    return (String) crRows[0].getAttribute("ConsentReceived");
                } else
                    return "N";
            }
        } catch (Exception e) {
            e.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching batch details." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
        
        return consentRcvd;
    }

    public void setNameScreened(String nameScreened) {
        this.nameScreened = nameScreened;
    }

    public String getNameScreened() {
        return nameScreened;
    }

    public void setEntityType(String entityType) {
        this.entityType = entityType;
    }

    public String getEntityType() {
        return entityType;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStatus() {
        return status;
    }

    public void setOfacList(String ofacList) {
        this.ofacList = ofacList;
    }

    public String getOfacList() {
        return ofacList;
    }

    public void setStatusDate(String statusDate) 
    {   
        this.statusDate = statusDate;
    }

    public String getStatusDate() {
        return statusDate;
    }

    public void setStatusUpdatedBy(String statusUpdatedBy) {
        this.statusUpdatedBy = statusUpdatedBy;
    }

    public String getStatusUpdatedBy() {
        return statusUpdatedBy;
    }

    public void setScreeningID(String screeningID) {
        this.screeningID = screeningID;
    }

    public String getScreeningID() {
        return screeningID;
    }
    
    public RMIManualTradeComplianceAppModuleImpl getAm()
    {
        return (RMIManualTradeComplianceAppModuleImpl) ADFUtils.getApplicationModuleForDataControl("RMIManualTradeComplianceAppModuleDataControl");
    }
    /**
     * Get application module for an application module data control by name.
     * @param name application module data control name
     * @return ApplicationModule
     */
    public static ApplicationModule getApplicationModuleForDataControl(String name) {
        return (ApplicationModule) JSFUtils.resolveExpression("#{data." + name + ".dataProvider}");
    }
}
