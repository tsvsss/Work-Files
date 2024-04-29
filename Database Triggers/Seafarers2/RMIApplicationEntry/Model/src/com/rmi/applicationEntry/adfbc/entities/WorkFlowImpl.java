package com.rmi.applicationEntry.adfbc.entities;

import com.rmi.applicationEntry.adfbc.extensions.CustomEntity;

import java.math.BigDecimal;

import java.sql.Timestamp;

import oracle.jbo.AttributeList;
import oracle.jbo.Key;
import oracle.jbo.domain.Date;
import oracle.jbo.server.EntityDefImpl;
import oracle.jbo.server.EntityImpl;
import oracle.jbo.server.TransactionEvent;
// ---------------------------------------------------------------------
// ---    File generated by Oracle ADF Business Components Design Time.
// ---    Mon Jul 08 16:32:27 IST 2019
// ---    Custom code may be added to this class.
// ---    Warning: Do not modify method signatures of generated methods.
// ---------------------------------------------------------------------
public class WorkFlowImpl extends CustomEntity {
    /**
     * AttributesEnum: generated enum for identifying attributes and accessors. DO NOT MODIFY.
     */
    public enum AttributesEnum {
        EsiWfId,
        EsiBatchId,
        BatchStatus,
        AssignedTo,
        AssignedFor,
        LastUpdatedRow,
        CreatedBy,
        CreationDate,
        LastUpdatedBy,
        LastUpdateDate,
        LastUpdateLogin;
        private static AttributesEnum[] vals = null;
        private static final int firstIndex = 0;

        public int index() {
            return AttributesEnum.firstIndex() + ordinal();
        }

        public static final int firstIndex() {
            return firstIndex;
        }

        public static int count() {
            return AttributesEnum.firstIndex() + AttributesEnum.staticValues().length;
        }

        public static final AttributesEnum[] staticValues() {
            if (vals == null) {
                vals = AttributesEnum.values();
            }
            return vals;
        }
    }


    public static final int ESIWFID = AttributesEnum.EsiWfId.index();
    public static final int ESIBATCHID = AttributesEnum.EsiBatchId.index();
    public static final int BATCHSTATUS = AttributesEnum.BatchStatus.index();
    public static final int ASSIGNEDTO = AttributesEnum.AssignedTo.index();
    public static final int ASSIGNEDFOR = AttributesEnum.AssignedFor.index();
    public static final int LASTUPDATEDROW = AttributesEnum.LastUpdatedRow.index();
    public static final int CREATEDBY = AttributesEnum.CreatedBy.index();
    public static final int CREATIONDATE = AttributesEnum.CreationDate.index();
    public static final int LASTUPDATEDBY = AttributesEnum.LastUpdatedBy.index();
    public static final int LASTUPDATEDATE = AttributesEnum.LastUpdateDate.index();
    public static final int LASTUPDATELOGIN = AttributesEnum.LastUpdateLogin.index();

    /**
     * This is the default constructor (do not remove).
     */
    public WorkFlowImpl() {
    }

    /**
     * @return the definition object for this instance class.
     */
    public static synchronized EntityDefImpl getDefinitionObject() {
        return EntityDefImpl.findDefObject("com.rmi.applicationEntry.adfbc.entities.WorkFlow");
    }


    /**
     * Gets the attribute value for EsiWfId, using the alias name EsiWfId.
     * @return the value of EsiWfId
     */
    public Integer getEsiWfId() {
        return (Integer) getAttributeInternal(ESIWFID);
    }

    /**
     * Sets <code>value</code> as the attribute value for EsiWfId.
     * @param value value to set the EsiWfId
     */
    public void setEsiWfId(Integer value) {
        setAttributeInternal(ESIWFID, value);
    }

    /**
     * Gets the attribute value for EsiBatchId, using the alias name EsiBatchId.
     * @return the value of EsiBatchId
     */
    public Integer getEsiBatchId() {
        return (Integer) getAttributeInternal(ESIBATCHID);
    }

    /**
     * Sets <code>value</code> as the attribute value for EsiBatchId.
     * @param value value to set the EsiBatchId
     */
    public void setEsiBatchId(Integer value) {
        setAttributeInternal(ESIBATCHID, value);
    }

    /**
     * Gets the attribute value for BatchStatus, using the alias name BatchStatus.
     * @return the value of BatchStatus
     */
    public String getBatchStatus() {
        return (String) getAttributeInternal(BATCHSTATUS);
    }

    /**
     * Sets <code>value</code> as the attribute value for BatchStatus.
     * @param value value to set the BatchStatus
     */
    public void setBatchStatus(String value) {
        setAttributeInternal(BATCHSTATUS, value);
    }

    /**
     * Gets the attribute value for AssignedTo, using the alias name AssignedTo.
     * @return the value of AssignedTo
     */
    public Integer getAssignedTo() {
        return (Integer) getAttributeInternal(ASSIGNEDTO);
    }

    /**
     * Sets <code>value</code> as the attribute value for AssignedTo.
     * @param value value to set the AssignedTo
     */
    public void setAssignedTo(Integer value) {
        setAttributeInternal(ASSIGNEDTO, value);
    }

    /**
     * Gets the attribute value for AssignedFor, using the alias name AssignedFor.
     * @return the value of AssignedFor
     */
    public String getAssignedFor() {
        return (String) getAttributeInternal(ASSIGNEDFOR);
    }

    /**
     * Sets <code>value</code> as the attribute value for AssignedFor.
     * @param value value to set the AssignedFor
     */
    public void setAssignedFor(String value) {
        setAttributeInternal(ASSIGNEDFOR, value);
    }

    /**
     * Gets the attribute value for LastUpdatedRow, using the alias name LastUpdatedRow.
     * @return the value of LastUpdatedRow
     */
    public String getLastUpdatedRow() {
        return (String) getAttributeInternal(LASTUPDATEDROW);
    }

    /**
     * Sets <code>value</code> as the attribute value for LastUpdatedRow.
     * @param value value to set the LastUpdatedRow
     */
    public void setLastUpdatedRow(String value) {
        setAttributeInternal(LASTUPDATEDROW, value);
    }

    /**
     * Gets the attribute value for CreatedBy, using the alias name CreatedBy.
     * @return the value of CreatedBy
     */
    public Integer getCreatedBy() {
        return (Integer) getAttributeInternal(CREATEDBY);
    }

    /**
     * Sets <code>value</code> as the attribute value for CreatedBy.
     * @param value value to set the CreatedBy
     */
    public void setCreatedBy(Integer value) {
        setAttributeInternal(CREATEDBY, value);
    }

    /**
     * Gets the attribute value for CreationDate, using the alias name CreationDate.
     * @return the value of CreationDate
     */
    public Date getCreationDate() {
        return (Date) getAttributeInternal(CREATIONDATE);
    }

    /**
     * Sets <code>value</code> as the attribute value for CreationDate.
     * @param value value to set the CreationDate
     */
    public void setCreationDate(Date value) {
        setAttributeInternal(CREATIONDATE, value);
    }

    /**
     * Gets the attribute value for LastUpdatedBy, using the alias name LastUpdatedBy.
     * @return the value of LastUpdatedBy
     */
    public BigDecimal getLastUpdatedBy() {
        return (BigDecimal) getAttributeInternal(LASTUPDATEDBY);
    }

    /**
     * Sets <code>value</code> as the attribute value for LastUpdatedBy.
     * @param value value to set the LastUpdatedBy
     */
    public void setLastUpdatedBy(BigDecimal value) {
        setAttributeInternal(LASTUPDATEDBY, value);
    }

    /**
     * Gets the attribute value for LastUpdateDate, using the alias name LastUpdateDate.
     * @return the value of LastUpdateDate
     */
    public Date getLastUpdateDate() {
        return (Date) getAttributeInternal(LASTUPDATEDATE);
    }

    /**
     * Sets <code>value</code> as the attribute value for LastUpdateDate.
     * @param value value to set the LastUpdateDate
     */
    public void setLastUpdateDate(Date value) {
        setAttributeInternal(LASTUPDATEDATE, value);
    }

    /**
     * Gets the attribute value for LastUpdateLogin, using the alias name LastUpdateLogin.
     * @return the value of LastUpdateLogin
     */
    public BigDecimal getLastUpdateLogin() {
        return (BigDecimal) getAttributeInternal(LASTUPDATELOGIN);
    }

    /**
     * Sets <code>value</code> as the attribute value for LastUpdateLogin.
     * @param value value to set the LastUpdateLogin
     */
    public void setLastUpdateLogin(BigDecimal value) {
        setAttributeInternal(LASTUPDATELOGIN, value);
    }


    /**
     * @param esiWfId key constituent

     * @return a Key object based on given key constituents.
     */
    public static Key createPrimaryKey(Integer esiWfId) {
        return new Key(new Object[] { esiWfId });
    }

    /**
     * Add attribute defaulting logic in this method.
     * @param attributeList list of attribute names/values to initialize the row
     */
    protected void create(AttributeList attributeList) {
        super.create(attributeList);
    }

    /**
     * Add locking logic here.
     */
    public void lock() {
//        super.lock();
    }

    /**
     * Custom DML update/insert/delete logic here.
     * @param operation the operation type
     * @param e the transaction event
     */
    protected void doDML(int operation, TransactionEvent e) {
        super.doDML(operation, e);
    }
}

