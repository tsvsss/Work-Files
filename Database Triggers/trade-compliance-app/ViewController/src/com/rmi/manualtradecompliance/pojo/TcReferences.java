package com.rmi.manualtradecompliance.pojo;

import com.rmi.manualtradecompliance.adfbc.services.RMIManualTradeComplianceAppModuleImpl;
import com.rmi.manualtradecompliance.utils.ADFUtils;
import com.rmi.manualtradecompliance.utils.JSFUtils;

import javax.faces.application.FacesMessage;

import oracle.jbo.ApplicationModule;
import oracle.jbo.Row;
import oracle.jbo.server.ViewObjectImpl;

public class TcReferences {

    private String entityType;
    private String alias;
    private String consent;
    private String status;
    private String nameScreened;
    private String expDate;
    private String statusDate;
    private String statusUpdatedBy;
    private String startDate;
    private String endDate;
    private Integer masterId;
    private Integer seafarerId;
    private Integer aliasId;
    private Integer xrefId;
    private Integer xwrlRequestId;
    private String tcExcluded;
    
    public TcReferences(String entityType, String nameScreened, String startDate, 
                        String endDate, Integer masterId, Integer seafarerId, String alias,
                        Integer aliasId, Integer xrefId, Integer xwrlRequestId, String tcExcluded) {
        this.entityType = entityType;
        this.nameScreened = nameScreened;
        this.startDate = startDate;
        this.endDate = endDate;
        this.masterId = masterId;
        this.seafarerId = seafarerId;
        this.alias = alias;
        this.aliasId = aliasId;
        this.xrefId = xrefId;
        this.xwrlRequestId = xwrlRequestId;
        this.tcExcluded = tcExcluded;
    }

    public void setTcExcluded(String tcExcluded) {
        this.tcExcluded = tcExcluded;
    }

    public String getTcExcluded() {
        return tcExcluded;
    }

    public void setAliasId(Integer aliasId) {
        this.aliasId = aliasId;
    }

    public Integer getAliasId() {
        if(aliasId == -1)
            return null;
        
        return aliasId;
    }

    public void setXrefId(Integer xrefId) {
        this.xrefId = xrefId;
    }

    public Integer getXrefId() {
        if(xrefId == -1)
            return null;
        
        return xrefId;
    }

    public void setXwrlRequestId(Integer xwrlRequestId) {
        this.xwrlRequestId = xwrlRequestId;
    }

    public Integer getXwrlRequestId() {
        if(xwrlRequestId == -1)
            return null;
        
        return xwrlRequestId;
    }

    public void setSeafarerId(Integer seafarerId) {
        this.seafarerId = seafarerId;
    }

    public Integer getSeafarerId() {        
        return seafarerId;
    }

    public void setMasterId(Integer masterId) {
        this.masterId = masterId;
    }

    public Integer getMasterId() {
        return masterId;
    }

    public void setEntityType(String entityType) {
        this.entityType = entityType;
    }

    public String getEntityType() {
        return entityType;
    }

    public void setAlias(String alias) {
        this.alias = alias;
    }

    public String getAlias() {
        return alias;
    }

    public void setConsent(String consent) {
        this.consent = consent;
    }

    public String getConsent() 
    {        
        try 
        {
                ViewObjectImpl tcRefOwsVo = getAm().getTcReferencesDetailsOwsView1();
                tcRefOwsVo.setNamedWhereClauseParam("pMasterId", getMasterId());
                tcRefOwsVo.setNamedWhereClauseParam("pNameScreened", getNameScreened());
                tcRefOwsVo.setNamedWhereClauseParam("pSeafarerId", getSeafarerId());
                tcRefOwsVo.setNamedWhereClauseParam("pAliasId", getAliasId());
                tcRefOwsVo.setNamedWhereClauseParam("pXrefId", getXrefId());
                tcRefOwsVo.setNamedWhereClauseParam("pXwrlRequestId", getXwrlRequestId());
                tcRefOwsVo.executeQuery();
                
                Row[] crRows = tcRefOwsVo.getAllRowsInRange();

                if (crRows.length > 0 && crRows[0].getAttribute("ConsentReceived") != null)
                {
                    if(crRows[0].getAttribute("ExpirationDate") != null)
                        setExpDate(crRows[0].getAttribute("ExpirationDate").toString());
                    if(crRows[0].getAttribute("TcStatus") != null)
                        setStatus(crRows[0].getAttribute("TcStatus").toString());
                    if(crRows[0].getAttribute("TcStatusDate") != null)
                        setStatusDate(crRows[0].getAttribute("TcStatusDate").toString());
                    if(crRows[0].getAttribute("TcStatusUpdatedBy") != null)
                        setStatusUpdatedBy(crRows[0].getAttribute("TcStatusUpdatedBy").toString());
                    
                    return (String) crRows[0].getAttribute("ConsentReceived");
                } else
                    return "N";
        } catch (Exception e) {
            e.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching TC References details." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
             
        return consent;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStatus() {
        return status;
    }

    public void setNameScreened(String nameScreened) {
        this.nameScreened = nameScreened;
    }

    public String getNameScreened() {
        return nameScreened;
    }

    public void setExpDate(String expDate) {
        this.expDate = expDate;
    }

    public String getExpDate() {
        return expDate;
    }

    public void setStatusDate(String statusDate) {
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

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getStartDate() {
        return startDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public String getEndDate() {
        return endDate;
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
