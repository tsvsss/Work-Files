package oracle.apps.xwrl.model.entity;

import java.math.BigDecimal;

import java.sql.Timestamp;

import oracle.adf.share.ADFContext;

import oracle.jbo.AttributeList;
import oracle.jbo.Key;
import oracle.jbo.server.EntityDefImpl;
import oracle.jbo.server.EntityImpl;
import oracle.jbo.server.SequenceImpl;
import oracle.jbo.server.TransactionEvent;
// ---------------------------------------------------------------------
// ---    File generated by Oracle ADF Business Components Design Time.
// ---    Mon Sep 30 14:15:56 EDT 2019
// ---    Custom code may be added to this class.
// ---    Warning: Do not modify method signatures of generated methods.
// ---------------------------------------------------------------------
public class WcCityListImpl extends EntityImpl {
    /**
     * AttributesEnum: generated enum for identifying attributes and accessors. DO NOT MODIFY.
     */
    public enum AttributesEnum {
        WcCityListId,
        CityName,
        Subdivision,
        CountryCode,
        Status,
        SortOrder,
        CreatedBy,
        CreationDate,
        LastUpdatedBy,
        LastUpdateDate,
        LastUpdateLogin,
        InternalUseOnly;
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


    public static final int WCCITYLISTID = AttributesEnum.WcCityListId.index();
    public static final int CITYNAME = AttributesEnum.CityName.index();
    public static final int SUBDIVISION = AttributesEnum.Subdivision.index();
    public static final int COUNTRYCODE = AttributesEnum.CountryCode.index();
    public static final int STATUS = AttributesEnum.Status.index();
    public static final int SORTORDER = AttributesEnum.SortOrder.index();
    public static final int CREATEDBY = AttributesEnum.CreatedBy.index();
    public static final int CREATIONDATE = AttributesEnum.CreationDate.index();
    public static final int LASTUPDATEDBY = AttributesEnum.LastUpdatedBy.index();
    public static final int LASTUPDATEDATE = AttributesEnum.LastUpdateDate.index();
    public static final int LASTUPDATELOGIN = AttributesEnum.LastUpdateLogin.index();
    public static final int INTERNALUSEONLY = AttributesEnum.InternalUseOnly.index();

    /**
     * This is the default constructor (do not remove).
     */
    public WcCityListImpl() {
    }

    /**
     * @return the definition object for this instance class.
     */
    public static synchronized EntityDefImpl getDefinitionObject() {
        return EntityDefImpl.findDefObject("oracle.apps.xwrl.model.entity.WcCityList");
    }


    /**
     * Gets the attribute value for WcCityListId, using the alias name WcCityListId.
     * @return the value of WcCityListId
     */
    public BigDecimal getWcCityListId() {
        return (BigDecimal) getAttributeInternal(WCCITYLISTID);
    }

    /**
     * Sets <code>value</code> as the attribute value for WcCityListId.
     * @param value value to set the WcCityListId
     */
    public void setWcCityListId(BigDecimal value) {
        setAttributeInternal(WCCITYLISTID, value);
    }

    /**
     * Gets the attribute value for CityName, using the alias name CityName.
     * @return the value of CityName
     */
    public String getCityName() {
        return (String) getAttributeInternal(CITYNAME);
    }

    /**
     * Sets <code>value</code> as the attribute value for CityName.
     * @param value value to set the CityName
     */
    public void setCityName(String value) {
        setAttributeInternal(CITYNAME, value);
    }

    /**
     * Gets the attribute value for Subdivision, using the alias name Subdivision.
     * @return the value of Subdivision
     */
    public String getSubdivision() {
        return (String) getAttributeInternal(SUBDIVISION);
    }

    /**
     * Sets <code>value</code> as the attribute value for Subdivision.
     * @param value value to set the Subdivision
     */
    public void setSubdivision(String value) {
        setAttributeInternal(SUBDIVISION, value);
    }

    /**
     * Gets the attribute value for CountryCode, using the alias name CountryCode.
     * @return the value of CountryCode
     */
    public String getCountryCode() {
        return (String) getAttributeInternal(COUNTRYCODE);
    }

    /**
     * Sets <code>value</code> as the attribute value for CountryCode.
     * @param value value to set the CountryCode
     */
    public void setCountryCode(String value) {
        setAttributeInternal(COUNTRYCODE, value);
    }

    /**
     * Gets the attribute value for Status, using the alias name Status.
     * @return the value of Status
     */
    public String getStatus() {
        return (String) getAttributeInternal(STATUS);
    }

    /**
     * Sets <code>value</code> as the attribute value for Status.
     * @param value value to set the Status
     */
    public void setStatus(String value) {
        setAttributeInternal(STATUS, value);
    }

    /**
     * Gets the attribute value for SortOrder, using the alias name SortOrder.
     * @return the value of SortOrder
     */
    public BigDecimal getSortOrder() {
        return (BigDecimal) getAttributeInternal(SORTORDER);
    }

    /**
     * Sets <code>value</code> as the attribute value for SortOrder.
     * @param value value to set the SortOrder
     */
    public void setSortOrder(BigDecimal value) {
        setAttributeInternal(SORTORDER, value);
    }

    /**
     * Gets the attribute value for CreatedBy, using the alias name CreatedBy.
     * @return the value of CreatedBy
     */
    public Long getCreatedBy() {
        return (Long) getAttributeInternal(CREATEDBY);
    }

    /**
     * Sets <code>value</code> as the attribute value for CreatedBy.
     * @param value value to set the CreatedBy
     */
    public void setCreatedBy(Long value) {
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
    public Long getLastUpdatedBy() {
        return (Long) getAttributeInternal(LASTUPDATEDBY);
    }

    /**
     * Sets <code>value</code> as the attribute value for LastUpdatedBy.
     * @param value value to set the LastUpdatedBy
     */
    public void setLastUpdatedBy(Long value) {
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
    public Long getLastUpdateLogin() {
        return (Long) getAttributeInternal(LASTUPDATELOGIN);
    }

    /**
     * Sets <code>value</code> as the attribute value for LastUpdateLogin.
     * @param value value to set the LastUpdateLogin
     */
    public void setLastUpdateLogin(Long value) {
        setAttributeInternal(LASTUPDATELOGIN, value);
    }

    /**
     * Gets the attribute value for InternalUseOnly, using the alias name InternalUseOnly.
     * @return the value of InternalUseOnly
     */
    public String getInternalUseOnly() {
        return (String) getAttributeInternal(INTERNALUSEONLY);
    }

    /**
     * Sets <code>value</code> as the attribute value for InternalUseOnly.
     * @param value value to set the InternalUseOnly
     */
    public void setInternalUseOnly(String value) {
        setAttributeInternal(INTERNALUSEONLY, value);
    }


    /**
     * @param wcCityListId key constituent

     * @return a Key object based on given key constituents.
     */
    public static Key createPrimaryKey(BigDecimal wcCityListId) {
        return new Key(new Object[] { wcCityListId });
    }

    /**
     * Add attribute defaulting logic in this method.
     * @param attributeList list of attribute names/values to initialize the row
     */
    protected void create(AttributeList attributeList) 
    {
        super.create(attributeList);
        
        BigDecimal id = null;
        id = nextVal("VSSL.WC_CITY_LIST_ID_SEQ").bigDecimalValue();
        this.setWcCityListId(id);
        
        Integer userId = (Integer) ADFContext.getCurrent().getSessionScope().get("UserId");
        Integer sessionId = (Integer) ADFContext.getCurrent().getSessionScope().get("SessionId");
        Timestamp time = new Timestamp(System.currentTimeMillis());

        if (userId != null) {
            this.setCreatedBy(Long.valueOf(userId));
            this.setLastUpdatedBy(Long.valueOf(userId));
        }

        if (sessionId != null) {
            this.setLastUpdateLogin(Long.valueOf(sessionId));
        }

        this.setCreationDate(time);
        this.setLastUpdateDate(time);
    }
    
    protected oracle.jbo.domain.Number nextVal(String sequenceName) {
        SequenceImpl s = new SequenceImpl(sequenceName, getDBTransaction());
        return s.getSequenceNumber();
    }

    /**
     * Add locking logic here.
     */
    public void lock() {
        super.lock();
    }

    /**
     * Custom DML update/insert/delete logic here.
     * @param operation the operation type
     * @param e the transaction event
     */
    protected void doDML(int operation, TransactionEvent e) 
    {
        if (operation == DML_UPDATE) {
            Integer userId = (Integer) ADFContext.getCurrent().getSessionScope().get("UserId");
            Integer sessionId = (Integer) ADFContext.getCurrent().getSessionScope().get("SessionId");
            Timestamp time = new Timestamp(System.currentTimeMillis());

            if (userId != null) {                
                this.setLastUpdatedBy(Long.valueOf(userId));
            }

            if (sessionId != null) {
                this.setLastUpdateLogin(Long.valueOf(sessionId));
            }

            this.setLastUpdateDate(time);            
        }
        super.doDML(operation, e);
    }
}

