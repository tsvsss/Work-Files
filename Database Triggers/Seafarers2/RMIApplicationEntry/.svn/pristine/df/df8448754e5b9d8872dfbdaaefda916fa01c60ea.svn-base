package com.rmi.applicationEntry.adfbc.extensions;

import oracle.jbo.server.EntityImpl;



import java.math.BigDecimal;

import java.sql.Timestamp;

import oracle.jbo.domain.Date;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;

import oracle.adf.share.ADFContext;

import oracle.jbo.AttributeList;
import oracle.jbo.server.EntityImpl;


import oracle.jbo.server.TransactionEvent;


public class CustomEntity extends EntityImpl {

    public Integer CreatedBy;
    public Date CreationDate;
    public BigDecimal LastUpdateLogin;
    public BigDecimal LastUpdatedBy;
    public Date LastUpdateDate;

    public CustomEntity() {
        super();
    }

    public void setCreatedBy(Integer CreatedBy) {
        this.CreatedBy = CreatedBy;
    }

    public Integer getCreatedBy() {
        return CreatedBy;
    }

    public void setCreationDate(Date CreationDate) {
        this.CreationDate = CreationDate;
    }

    public Date getCreationDate() {
        return CreationDate;
    }

    public void setLastUpdateLogin(BigDecimal LastUpdateLogin) {
        this.LastUpdateLogin = LastUpdateLogin;
    }

    public BigDecimal getLastUpdateLogin() {
        return LastUpdateLogin;
    }

    public void setLastUpdatedBy(BigDecimal LastUpdatedBy) {
        this.LastUpdatedBy = LastUpdatedBy;
    }

    public BigDecimal getLastUpdatedBy() {
        return LastUpdatedBy;
    }

    public void setLastUpdateDate(Date LastUpdateDate) {
        this.LastUpdateDate = LastUpdateDate;
    }

    public Date getLastUpdateDate() {
        return LastUpdateDate;
    }


    /**
     * Add attribute defaulting logic in this method.
     * @param attributeList list of attribute names/values to initialize the row
     */
    protected void create(AttributeList attributeList) {
        try {
            super.create(attributeList);
            //AppModuleImpl am = new AppModuleImpl();
            //BigDecimal userId = am.getUserId();
            //BigDecimal sessionId = am.getSessionId();
            //        SequenceImpl s = new SequenceImpl("INV_STOWAWAY_STOW_ID_S", getDBTransaction());
            //
            //        System.out.println("Sequence Number is :::::::::::::::::::: "+ s.getSequenceNumber());
            //
            //      oracle.jbo.domain.Number num=s.getSequenceNumber();

            Integer userId =
                ((ADFContext.getCurrent().getSessionScope().get("UserId") != null) ?
                 Integer.parseInt(ADFContext.getCurrent().getSessionScope().get("UserId").toString()) : 2);

         

            //System.out.println("userId create :: "+userId);

            Timestamp t = new Timestamp(System.currentTimeMillis());
            oracle.jbo.domain.Date date = new oracle.jbo.domain.Date(oracle.jbo.domain.Date.getCurrentDate());
            this.setCreatedBy(userId);
            this.setCreationDate(date);
            this.setLastUpdatedBy(new BigDecimal(userId));
            this.setLastUpdateDate(date);
        } catch (NumberFormatException nfe) {
            nfe.printStackTrace();
            addFormattedFacesErrorMessage("System encountered an exception while creating data." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
        }   
    }

    public static void addFormattedFacesErrorMessage(String header, String detail,
                                                 javax.faces.application.FacesMessage.Severity severity) 
    {
        StringBuilder saveMsg = new StringBuilder("<html><body><b><span style='color:");
        
        if(severity != null)
        {
            if(severity.toString().equalsIgnoreCase("INFO 0"))
                saveMsg.append("#000000'>");
            else if(severity.toString().equalsIgnoreCase("WARN 1"))
                saveMsg.append("#000000'>");
            else if(severity.toString().equalsIgnoreCase("ERROR 2"))
                saveMsg.append("#000000'>");
            else
                saveMsg.append("#000000'>");
        }
        else
            saveMsg.append("#000000'>");
        
        saveMsg.append(header);
        saveMsg.append("</span></b>");
        saveMsg.append("</br><b>");
    //        saveMsg.append(detail);
        saveMsg.append("</b></body></html>");
        FacesMessage msg = new FacesMessage(saveMsg.toString());
        msg.setSeverity(severity);
        FacesContext.getCurrentInstance().addMessage(null, msg);
    }


    /**
     * Custom DML update/insert/delete logic here.
     * @param operation the operation type
     * @param e the transaction event
     */
    protected void doDML(int operation, TransactionEvent e) {
        try {
            if (operation !=
                DML_DELETE) {
                //AppModuleImpl am = new oracle.apps.xlgl.model.AppModuleImpl();
                //BigDecimal userId = am.getUserId();
                //BigDecimal sessionId = am.getSessionId();
                Integer userId =
       ((ADFContext.getCurrent().getSessionScope().get("UserId") != null) ?
        Integer.parseInt(ADFContext.getCurrent().getSessionScope().get("UserId").toString()) : 3);

               

//                System.out.println("userId doDML :: " + userId);

                Timestamp t = new Timestamp(System.currentTimeMillis());
                oracle.jbo.domain.Date date = new oracle.jbo.domain.Date(oracle.jbo.domain.Date.getCurrentDate());

//                System.out.println(t+"----");
                
                this.setLastUpdatedBy(new BigDecimal(userId));
                this.setLastUpdateDate(date);
            }
            super.doDML(operation, e);
        } catch (Exception nfe) {
            addFormattedFacesErrorMessage("System encountered an exception while updating data." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            nfe.printStackTrace();
        }
    }

}

