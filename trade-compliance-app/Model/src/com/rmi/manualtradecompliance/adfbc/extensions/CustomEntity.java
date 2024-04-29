package com.rmi.manualtradecompliance.adfbc.extensions;

import com.rmi.manualtradecompliance.adfbc.utils.AdfUtils;

import java.math.BigDecimal;

import java.sql.Timestamp;

import javax.faces.application.FacesMessage;

import oracle.adf.share.ADFContext;



import oracle.jbo.AttributeList;
import oracle.jbo.server.EntityImpl;


import oracle.jbo.server.TransactionEvent;


public class CustomEntity extends EntityImpl {

    public BigDecimal CreatedBy;
    public Timestamp CreationDate;
    public BigDecimal LastUpdateLogin;
    public BigDecimal LastUpdatedBy;
    public Timestamp LastUpdateDate;

    public CustomEntity() {
        super();
    }

    public void setCreatedBy(BigDecimal CreatedBy) {
        this.CreatedBy = CreatedBy;
    }

    public BigDecimal getCreatedBy() {
        return CreatedBy;
    }

    public void setCreationDate(Timestamp CreationDate) {
        this.CreationDate = CreationDate;
    }

    public Timestamp getCreationDate() {
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

    public void setLastUpdateDate(Timestamp LastUpdateDate) {
        this.LastUpdateDate = LastUpdateDate;
    }

    public Timestamp getLastUpdateDate() {
        return LastUpdateDate;
    }


    /**
     * Add attribute defaulting logic in this method.
     * @param attributeList list of attribute names/values to initialize the row
     */
    protected void create(AttributeList attributeList) {
        super.create(attributeList);
        try 
        {
            BigDecimal userId =
                ((ADFContext.getCurrent().getSessionScope().get("UserId") != null) ?
                 new BigDecimal(ADFContext.getCurrent().getSessionScope().get("UserId").toString()) :
                 new BigDecimal(2));
            BigDecimal sessionId = new BigDecimal(((Integer)ADFContext.getCurrent().getSessionScope().get("SessionId")).toString());

            if (sessionId == null) {
                sessionId = new BigDecimal(600000);
            }
            Timestamp t = new Timestamp(System.currentTimeMillis());
            this.setCreatedBy(userId);
            this.setCreationDate(t);
            this.setLastUpdateLogin(sessionId);
            this.setLastUpdatedBy(userId);
            this.setLastUpdateDate(t);
        } catch (Exception e) {
            e.printStackTrace();
                AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while adding data." +
                                                       "Please contact your System Administrator.", "",
                                                       FacesMessage.SEVERITY_ERROR);
        }       
    }

    /**
     * Custom DML update/insert/delete logic here.
     * @param operation the operation type
     * @param e the transaction event
     */
    protected void doDML(int operation, TransactionEvent e) {
        try 
        {
            if (operation != DML_DELETE) {
                BigDecimal userId =
                    ((ADFContext.getCurrent().getSessionScope().get("UserId") != null) ?
                     new BigDecimal(ADFContext.getCurrent().getSessionScope().get("UserId").toString()) :
                     new BigDecimal(3));
                BigDecimal sessionId = new BigDecimal(((Integer)ADFContext.getCurrent().getSessionScope().get("SessionId")).toString());

                if (sessionId == null) {
                    sessionId = new BigDecimal(600000);
                }
                Timestamp t = new Timestamp(System.currentTimeMillis());
                this.setLastUpdateLogin(sessionId);
                this.setLastUpdatedBy(userId);
                this.setLastUpdateDate(t);
            }
            super.doDML(operation, e);
        } catch (Exception e1) {
            e1.printStackTrace();
                AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while inserting data." +
                                                       "Please contact your System Administrator.", "",
                                                       FacesMessage.SEVERITY_ERROR);
        }
    }

}

