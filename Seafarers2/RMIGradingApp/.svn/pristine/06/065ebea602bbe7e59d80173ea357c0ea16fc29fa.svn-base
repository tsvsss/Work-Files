package com.rmi.tradecompapproval.adfbc.extensions;

import com.rmi.tradecompapproval.adfbc.utils.AdfUtils;

import java.sql.Timestamp;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;

import oracle.adf.share.ADFContext;

import oracle.jbo.AttributeList;
import oracle.jbo.server.EntityImpl;
import oracle.jbo.server.TransactionEvent;

public class CustomEntity extends EntityImpl {

    public Integer CreatedBy;
    public Timestamp CreationDate;
    public Integer LastUpdateLogin;
    public Integer LastUpdatedBy;
    public Timestamp LastUpdateDate;

    public CustomEntity() {
        super();
    }

    public void setCreatedBy(Integer CreatedBy) {
        this.CreatedBy = CreatedBy;
    }

    public Integer getCreatedBy() {
        return CreatedBy;
    }

    public void setCreationDate(Timestamp CreationDate) {
        this.CreationDate = CreationDate;
    }

    public Timestamp getCreationDate() {
        return CreationDate;
    }

    public void setLastUpdateLogin(Integer LastUpdateLogin) {
        this.LastUpdateLogin = LastUpdateLogin;
    }

    public Integer getLastUpdateLogin() {
        return LastUpdateLogin;
    }

    public void setLastUpdatedBy(Integer LastUpdatedBy) {
        this.LastUpdatedBy = LastUpdatedBy;
    }

    public Integer getLastUpdatedBy() {
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
    protected void create(AttributeList attributeList) 
    {
        try 
        {
            super.create(attributeList);
            Integer userId =
                ((ADFContext.getCurrent().getSessionScope().get("UserId") != null) ?
                 Integer.parseInt(ADFContext.getCurrent().getSessionScope().get("UserId").toString()) :
                 new Integer(2));
            Integer sessionId = (Integer) ADFContext.getCurrent().getSessionScope().get("SessionId");

            if (sessionId == null) {
                sessionId = new Integer(600000);
            }

            Timestamp t = new Timestamp(System.currentTimeMillis());
            this.setCreatedBy(userId);
            this.setCreationDate(t);
            this.setLastUpdateLogin(sessionId);
            this.setLastUpdatedBy(userId);
            this.setLastUpdateDate(t);
        } catch (Exception e) {
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating history columns." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
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
                Integer userId =
                    ((ADFContext.getCurrent().getSessionScope().get("UserId") != null) ?
                     Integer.parseInt(ADFContext.getCurrent().getSessionScope().get("UserId").toString()) :
                     new Integer(3));
                Integer sessionId = (Integer) ADFContext.getCurrent().getSessionScope().get("SessionId");

                if (sessionId == null) {
                    sessionId = new Integer(600000);
                }

                Timestamp t = new Timestamp(System.currentTimeMillis());
                this.setLastUpdateLogin(sessionId);
                this.setLastUpdatedBy(userId);
                this.setLastUpdateDate(t);
            }
        } catch (Exception exc) {
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating history columns." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);  
        }
        finally
        {
            super.doDML(operation, e);
        }
    }
}

