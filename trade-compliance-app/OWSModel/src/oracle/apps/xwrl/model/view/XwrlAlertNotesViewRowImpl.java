package oracle.apps.xwrl.model.view;

import java.math.BigDecimal;

import java.sql.Timestamp;

import oracle.apps.xwrl.model.entity.XwrlAlertNotesImpl;

import oracle.jbo.Row;
import oracle.jbo.RowSet;
import oracle.jbo.server.ViewRowImpl;
// ---------------------------------------------------------------------
// ---    File generated by Oracle ADF Business Components Design Time.
// ---    Sun Oct 27 14:09:46 EDT 2019
// ---    Custom code may be added to this class.
// ---    Warning: Do not modify method signatures of generated methods.
// ---------------------------------------------------------------------
public class XwrlAlertNotesViewRowImpl extends ViewRowImpl {


    public static final int ENTITY_XWRLALERTNOTES = 0;

    /**
     * AttributesEnum: generated enum for identifying attributes and accessors. DO NOT MODIFY.
     */
    public enum AttributesEnum {
        Id,
        RequestId,
        AlertId,
        XrefAlertId,
        LineNumber,
        Note,
        LastUpdateDate,
        LastUpdatedBy,
        CreationDate,
        CreatedBy,
        LastUpdateLogin,
        Lastupdatedbyattr,
        Createdbyattr,
        FndUsersAllLov1;
        static AttributesEnum[] vals = null;
        ;
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


    public static final int ID = AttributesEnum.Id.index();
    public static final int REQUESTID = AttributesEnum.RequestId.index();
    public static final int ALERTID = AttributesEnum.AlertId.index();
    public static final int XREFALERTID = AttributesEnum.XrefAlertId.index();
    public static final int LINENUMBER = AttributesEnum.LineNumber.index();
    public static final int NOTE = AttributesEnum.Note.index();
    public static final int LASTUPDATEDATE = AttributesEnum.LastUpdateDate.index();
    public static final int LASTUPDATEDBY = AttributesEnum.LastUpdatedBy.index();
    public static final int CREATIONDATE = AttributesEnum.CreationDate.index();
    public static final int CREATEDBY = AttributesEnum.CreatedBy.index();
    public static final int LASTUPDATELOGIN = AttributesEnum.LastUpdateLogin.index();
    public static final int LASTUPDATEDBYATTR = AttributesEnum.Lastupdatedbyattr.index();
    public static final int CREATEDBYATTR = AttributesEnum.Createdbyattr.index();
    public static final int FNDUSERSALLLOV1 = AttributesEnum.FndUsersAllLov1.index();

    /**
     * This is the default constructor (do not remove).
     */
    public XwrlAlertNotesViewRowImpl() {
    }

    /**
     * Gets XwrlAlertNotes entity object.
     * @return the XwrlAlertNotes
     */
    public XwrlAlertNotesImpl getXwrlAlertNotes() {
        return (XwrlAlertNotesImpl) getEntity(ENTITY_XWRLALERTNOTES);
    }

    /**
     * Gets the attribute value for ID using the alias name Id.
     * @return the ID
     */
    public BigDecimal getId() {
        return (BigDecimal) getAttributeInternal(ID);
    }

    /**
     * Sets <code>value</code> as attribute value for ID using the alias name Id.
     * @param value value to set the ID
     */
    public void setId(BigDecimal value) {
        setAttributeInternal(ID, value);
    }

    /**
     * Gets the attribute value for REQUEST_ID using the alias name RequestId.
     * @return the REQUEST_ID
     */
    public BigDecimal getRequestId() {
        return (BigDecimal) getAttributeInternal(REQUESTID);
    }

    /**
     * Sets <code>value</code> as attribute value for REQUEST_ID using the alias name RequestId.
     * @param value value to set the REQUEST_ID
     */
    public void setRequestId(BigDecimal value) {
        setAttributeInternal(REQUESTID, value);
    }

    /**
     * Gets the attribute value for ALERT_ID using the alias name AlertId.
     * @return the ALERT_ID
     */
    public String getAlertId() {
        return (String) getAttributeInternal(ALERTID);
    }

    /**
     * Sets <code>value</code> as attribute value for ALERT_ID using the alias name AlertId.
     * @param value value to set the ALERT_ID
     */
    public void setAlertId(String value) {
        setAttributeInternal(ALERTID, value);
    }
    
    /**
     * Gets the attribute value for XrefAlertId using the alias name XrefAlertId.
     * @return the XrefAlertId
     */
    public String getXrefAlertId() {
        return (String) getAttributeInternal(XREFALERTID);
    }

    /**
     * Sets <code>value</code> as attribute value for ALERT_ID using the alias name XrefAlertId.
     * @param value value to set the XrefAlertId
     */
    public void setXrefAlertId(String value) {
        setAttributeInternal(XREFALERTID, value);
    }

    /**
     * Gets the attribute value for LINE_NUMBER using the alias name LineNumber.
     * @return the LINE_NUMBER
     */
    public BigDecimal getLineNumber() {
        return (BigDecimal) getAttributeInternal(LINENUMBER);
    }

    /**
     * Sets <code>value</code> as attribute value for LINE_NUMBER using the alias name LineNumber.
     * @param value value to set the LINE_NUMBER
     */
    public void setLineNumber(BigDecimal value) {
        setAttributeInternal(LINENUMBER, value);
    }

    /**
     * Gets the attribute value for NOTE using the alias name Note.
     * @return the NOTE
     */
    public String getNote() {
        return (String) getAttributeInternal(NOTE);
    }

    /**
     * Sets <code>value</code> as attribute value for NOTE using the alias name Note.
     * @param value value to set the NOTE
     */
    public void setNote(String value) {
        setAttributeInternal(NOTE, value);
    }

    /**
     * Gets the attribute value for LAST_UPDATE_DATE using the alias name LastUpdateDate.
     * @return the LAST_UPDATE_DATE
     */
    public Timestamp getLastUpdateDate() {
        return (Timestamp) getAttributeInternal(LASTUPDATEDATE);
    }

    /**
     * Sets <code>value</code> as attribute value for LAST_UPDATE_DATE using the alias name LastUpdateDate.
     * @param value value to set the LAST_UPDATE_DATE
     */
    public void setLastUpdateDate(Timestamp value) {
        setAttributeInternal(LASTUPDATEDATE, value);
    }

    /**
     * Gets the attribute value for LAST_UPDATED_BY using the alias name LastUpdatedBy.
     * @return the LAST_UPDATED_BY
     */
    public Long getLastUpdatedBy() {
        return (Long) getAttributeInternal(LASTUPDATEDBY);
    }

    /**
     * Sets <code>value</code> as attribute value for LAST_UPDATED_BY using the alias name LastUpdatedBy.
     * @param value value to set the LAST_UPDATED_BY
     */
    public void setLastUpdatedBy(Long value) {
        setAttributeInternal(LASTUPDATEDBY, value);
    }

    /**
     * Gets the attribute value for CREATION_DATE using the alias name CreationDate.
     * @return the CREATION_DATE
     */
    public Timestamp getCreationDate() {
        return (Timestamp) getAttributeInternal(CREATIONDATE);
    }

    /**
     * Sets <code>value</code> as attribute value for CREATION_DATE using the alias name CreationDate.
     * @param value value to set the CREATION_DATE
     */
    public void setCreationDate(Timestamp value) {
        setAttributeInternal(CREATIONDATE, value);
    }

    /**
     * Gets the attribute value for CREATED_BY using the alias name CreatedBy.
     * @return the CREATED_BY
     */
    public Long getCreatedBy() {
        return (Long) getAttributeInternal(CREATEDBY);
    }

    /**
     * Sets <code>value</code> as attribute value for CREATED_BY using the alias name CreatedBy.
     * @param value value to set the CREATED_BY
     */
    public void setCreatedBy(Long value) {
        setAttributeInternal(CREATEDBY, value);
    }

    /**
     * Gets the attribute value for LAST_UPDATE_LOGIN using the alias name LastUpdateLogin.
     * @return the LAST_UPDATE_LOGIN
     */
    public Long getLastUpdateLogin() {
        return (Long) getAttributeInternal(LASTUPDATELOGIN);
    }

    /**
     * Sets <code>value</code> as attribute value for LAST_UPDATE_LOGIN using the alias name LastUpdateLogin.
     * @param value value to set the LAST_UPDATE_LOGIN
     */
    public void setLastUpdateLogin(Long value) {
        setAttributeInternal(LASTUPDATELOGIN, value);
    }

    

    /**
     * Gets the attribute value for the calculated attribute Lastupdatedbyattr.
     * @return the Lastupdatedbyattr
     */
    public String getLastupdatedbyattr() {
        return (String) getAttributeInternal(LASTUPDATEDBYATTR);
    }

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute Lastupdatedbyattr.
     * @param value value to set the  Lastupdatedbyattr
     */
    public void setLastupdatedbyattr(String value) {
        setAttributeInternal(LASTUPDATEDBYATTR, value);
    }

    /**
     * Gets the attribute value for the calculated attribute Createdbyattr.
     * @return the Createdbyattr
     */
    public String getCreatedbyattr() {
        return (String) getAttributeInternal(CREATEDBYATTR);
    }


    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute Createdbyattr.
     * @param value value to set the  Createdbyattr
     */
    public void setCreatedbyattr(String value) {
        setAttributeInternal(CREATEDBYATTR, value);
    }

    /**
     * Gets the view accessor <code>RowSet</code> FndUsersAllLov1.
     */
    public RowSet getFndUsersAllLov1() {
        return (RowSet) getAttributeInternal(FNDUSERSALLLOV1);
    }
    
    /*
    public String getCreatedByAttr() {
        //return (String) getAttributeInternal(CREATEDBYATTR);
        Long key = (Long) getAttributeInternal(CREATEDBY);
        //LOGGER.finest("Key: " + key);
        String value = null;

        if (key != null) {
            Row[] rows;
            rows = this.getFndUsersAllLov1().getFilteredRows("UserId", key);
            if (rows.length > 0) {
                value = (String) rows[0].getAttribute("Description");
            }
        }
        
        //LOGGER.finest("Value: " + value);
        
        return value;
    }

    
    public void setCreatedByAttr(String value) {
        setAttributeInternal(CREATEDBYATTR, value);
    }

    public String getLastUpdatedByAttr() {
        //return (String) getAttributeInternal(LASTUPDATEDBYATTR);
        Long key = (Long) getAttributeInternal(LASTUPDATEDBY);
        //LOGGER.finest("Key: " + key);
        String value = null;

        if (key != null) {
            Row[] rows;
            rows = this.getFndUsersAllLov1().getFilteredRows("UserId", key);
            if (rows.length > 0) {
                value = (String) rows[0].getAttribute("Description");
            }
        }
        
        //LOGGER.finest("Value: " + value);
        
        return value;
    }

    
    public void setLastUpdatedByAttr(String value) {
        setAttributeInternal(LASTUPDATEDBYATTR, value);
    }
    
    */
}
