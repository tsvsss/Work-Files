package com.rmi.manualtradecompliance.adfbc.entities;

import com.rmi.manualtradecompliance.adfbc.extensions.CustomEntity;

import java.math.BigDecimal;

import java.sql.Timestamp;

import oracle.jbo.AttributeList;
import oracle.jbo.Key;
import oracle.jbo.server.EntityDefImpl;
import oracle.jbo.server.EntityImpl;
import oracle.jbo.server.TransactionEvent;
// ---------------------------------------------------------------------
// ---    File generated by Oracle ADF Business Components Design Time.
// ---    Wed Jun 12 18:05:47 IST 2019
// ---    Custom code may be added to this class.
// ---    Warning: Do not modify method signatures of generated methods.
// ---------------------------------------------------------------------
public class WcRequestDocumentsImpl extends CustomEntity {
    /**
     * AttributesEnum: generated enum for identifying attributes and accessors. DO NOT MODIFY.
     */
    public enum AttributesEnum {
        WcRequestDocumentsId,
        EdocsId,
        DocDescription,
        CreatedBy,
        CreationDate,
        LastUpdatedBy,
        LastUpdateDate,
        LastUpdateLogin,
        WcScreeningRequestId;
        private static AttributesEnum[] vals = null;
        private static final int firstIndex = 0;

        public int index() {
            return WcRequestDocumentsImpl.AttributesEnum.firstIndex() + ordinal();
        }

        public static final int firstIndex() {
            return firstIndex;
        }

        public static int count() {
            return WcRequestDocumentsImpl.AttributesEnum.firstIndex() +
                   WcRequestDocumentsImpl.AttributesEnum.staticValues().length;
        }

        public static final AttributesEnum[] staticValues() {
            if (vals == null) {
                vals = WcRequestDocumentsImpl.AttributesEnum.values();
            }
            return vals;
        }
    }


    public static final int WCREQUESTDOCUMENTSID = AttributesEnum.WcRequestDocumentsId.index();
    public static final int EDOCSID = AttributesEnum.EdocsId.index();
    public static final int DOCDESCRIPTION = AttributesEnum.DocDescription.index();
    public static final int CREATEDBY = AttributesEnum.CreatedBy.index();
    public static final int CREATIONDATE = AttributesEnum.CreationDate.index();
    public static final int LASTUPDATEDBY = AttributesEnum.LastUpdatedBy.index();
    public static final int LASTUPDATEDATE = AttributesEnum.LastUpdateDate.index();
    public static final int LASTUPDATELOGIN = AttributesEnum.LastUpdateLogin.index();
    public static final int WCSCREENINGREQUESTID = AttributesEnum.WcScreeningRequestId.index();

    /**
     * This is the default constructor (do not remove).
     */
    public WcRequestDocumentsImpl() {
    }

    /**
     * @return the definition object for this instance class.
     */
    public static synchronized EntityDefImpl getDefinitionObject() {
        return EntityDefImpl.findDefObject("com.rmi.manualtradecompliance.adfbc.entities.WcRequestDocuments");
    }


    /**
     * Gets the attribute value for WcRequestDocumentsId, using the alias name WcRequestDocumentsId.
     * @return the value of WcRequestDocumentsId
     */
    public Integer getWcRequestDocumentsId() {
        return (Integer) getAttributeInternal(WCREQUESTDOCUMENTSID);
    }

    /**
     * Sets <code>value</code> as the attribute value for WcRequestDocumentsId.
     * @param value value to set the WcRequestDocumentsId
     */
    public void setWcRequestDocumentsId(Integer value) {
        setAttributeInternal(WCREQUESTDOCUMENTSID, value);
    }

    /**
     * Gets the attribute value for EdocsId, using the alias name EdocsId.
     * @return the value of EdocsId
     */
    public Integer getEdocsId() {
        return (Integer) getAttributeInternal(EDOCSID);
    }

    /**
     * Sets <code>value</code> as the attribute value for EdocsId.
     * @param value value to set the EdocsId
     */
    public void setEdocsId(Integer value) {
        setAttributeInternal(EDOCSID, value);
    }

    /**
     * Gets the attribute value for DocDescription, using the alias name DocDescription.
     * @return the value of DocDescription
     */
    public String getDocDescription() {
        return (String) getAttributeInternal(DOCDESCRIPTION);
    }

    /**
     * Sets <code>value</code> as the attribute value for DocDescription.
     * @param value value to set the DocDescription
     */
    public void setDocDescription(String value) {
        setAttributeInternal(DOCDESCRIPTION, value);
    }

    /**
     * Gets the attribute value for CreatedBy, using the alias name CreatedBy.
     * @return the value of CreatedBy
     */
    public BigDecimal getCreatedBy() {
        return (BigDecimal) getAttributeInternal(CREATEDBY);
    }

    /**
     * Sets <code>value</code> as the attribute value for CreatedBy.
     * @param value value to set the CreatedBy
     */
    public void setCreatedBy(BigDecimal value) {
        setAttributeInternal(CREATEDBY, value);
    }

    /**
     * Gets the attribute value for CreationDate, using the alias name CreationDate.
     * @return the value of CreationDate
     */
    public Timestamp getCreationDate() {
        return (Timestamp) getAttributeInternal(CREATIONDATE);
    }

    /**
     * Sets <code>value</code> as the attribute value for CreationDate.
     * @param value value to set the CreationDate
     */
    public void setCreationDate(Timestamp value) {
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
    public Timestamp getLastUpdateDate() {
        return (Timestamp) getAttributeInternal(LASTUPDATEDATE);
    }

    /**
     * Sets <code>value</code> as the attribute value for LastUpdateDate.
     * @param value value to set the LastUpdateDate
     */
    public void setLastUpdateDate(Timestamp value) {
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
     * Gets the attribute value for WcScreeningRequestId, using the alias name WcScreeningRequestId.
     * @return the value of WcScreeningRequestId
     */
    public BigDecimal getWcScreeningRequestId() {
        return (BigDecimal) getAttributeInternal(WCSCREENINGREQUESTID);
    }

    /**
     * Sets <code>value</code> as the attribute value for WcScreeningRequestId.
     * @param value value to set the WcScreeningRequestId
     */
    public void setWcScreeningRequestId(BigDecimal value) {
        setAttributeInternal(WCSCREENINGREQUESTID, value);
    }


    /**
     * @param wcRequestDocumentsId key constituent

     * @return a Key object based on given key constituents.
     */
    public static Key createPrimaryKey(Integer wcRequestDocumentsId) {
        return new Key(new Object[] { wcRequestDocumentsId });
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
