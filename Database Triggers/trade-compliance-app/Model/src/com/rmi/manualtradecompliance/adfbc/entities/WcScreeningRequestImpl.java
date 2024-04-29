package com.rmi.manualtradecompliance.adfbc.entities;

import com.rmi.manualtradecompliance.adfbc.entities.common.Xmltype;

import com.rmi.manualtradecompliance.adfbc.extensions.CustomEntity;

import java.math.BigDecimal;

import java.sql.Timestamp;

import oracle.adf.share.ADFContext;

import oracle.jbo.AttributeList;
import oracle.jbo.Key;
import oracle.jbo.server.EntityDefImpl;
import oracle.jbo.server.EntityImpl;
import oracle.jbo.server.TransactionEvent;
// ---------------------------------------------------------------------
// ---    File generated by Oracle ADF Business Components Design Time.
// ---    Mon Feb 11 13:15:00 IST 2019
// ---    Custom code may be added to this class.
// ---    Warning: Do not modify method signatures of generated methods.
// ---------------------------------------------------------------------
public class WcScreeningRequestImpl extends CustomEntity {
    /**
     * AttributesEnum: generated enum for identifying attributes and accessors. DO NOT MODIFY.
     */
    public enum AttributesEnum {
        WcScreeningRequestId,
        Status,
        NameScreened,
        DateOfBirth,
        Sex,
        NameIdentifier,
        PassportNumber,
        XmlResponse,
        EntityType,
        PassportIssuingCountryCode,
        StatusUpdatedBy,
        StatusDate,
        Notes,
        OfacListEdocId,
        CreatedBy,
        CreationDate,
        LastUpdatedBy,
        LastUpdateDate,
        LastUpdateLogin,
        OfacListIsEntyOnList,
        CorpResidenceCountryCode,
        CitizenshipCountryCode,
        AliasWcScreeningRequestId,
        SentToLegalDate,
        ResidenceCountryCode,
        NotifyUserUponApproval,
        CityName,
        WcCityListId,
        TypeId,
        ImoNumber,
        SentToLegalBy,
        RequiresLegalApproval;
        private static AttributesEnum[] vals = null;
        private static final int firstIndex = 0;

        public int index() {
            return WcScreeningRequestImpl.AttributesEnum.firstIndex() + ordinal();
        }

        public static final int firstIndex() {
            return firstIndex;
        }

        public static int count() {
            return WcScreeningRequestImpl.AttributesEnum.firstIndex() +
                   WcScreeningRequestImpl.AttributesEnum.staticValues().length;
        }

        public static final AttributesEnum[] staticValues() {
            if (vals == null) {
                vals = WcScreeningRequestImpl.AttributesEnum.values();
            }
            return vals;
        }
    }


    public static final int WCSCREENINGREQUESTID = AttributesEnum.WcScreeningRequestId.index();
    public static final int STATUS = AttributesEnum.Status.index();
    public static final int NAMESCREENED = AttributesEnum.NameScreened.index();
    public static final int DATEOFBIRTH = AttributesEnum.DateOfBirth.index();
    public static final int SEX = AttributesEnum.Sex.index();
    public static final int NAMEIDENTIFIER = AttributesEnum.NameIdentifier.index();
    public static final int PASSPORTNUMBER = AttributesEnum.PassportNumber.index();
    public static final int XMLRESPONSE = AttributesEnum.XmlResponse.index();
    public static final int ENTITYTYPE = AttributesEnum.EntityType.index();
    public static final int PASSPORTISSUINGCOUNTRYCODE = AttributesEnum.PassportIssuingCountryCode.index();
    public static final int STATUSUPDATEDBY = AttributesEnum.StatusUpdatedBy.index();
    public static final int STATUSDATE = AttributesEnum.StatusDate.index();
    public static final int NOTES = AttributesEnum.Notes.index();
    public static final int OFACLISTEDOCID = AttributesEnum.OfacListEdocId.index();
    public static final int CREATEDBY = AttributesEnum.CreatedBy.index();
    public static final int CREATIONDATE = AttributesEnum.CreationDate.index();
    public static final int LASTUPDATEDBY = AttributesEnum.LastUpdatedBy.index();
    public static final int LASTUPDATEDATE = AttributesEnum.LastUpdateDate.index();
    public static final int LASTUPDATELOGIN = AttributesEnum.LastUpdateLogin.index();
    public static final int OFACLISTISENTYONLIST = AttributesEnum.OfacListIsEntyOnList.index();
    public static final int CORPRESIDENCECOUNTRYCODE = AttributesEnum.CorpResidenceCountryCode.index();
    public static final int CITIZENSHIPCOUNTRYCODE = AttributesEnum.CitizenshipCountryCode.index();
    public static final int ALIASWCSCREENINGREQUESTID = AttributesEnum.AliasWcScreeningRequestId.index();
    public static final int SENTTOLEGALDATE = AttributesEnum.SentToLegalDate.index();
    public static final int RESIDENCECOUNTRYCODE = AttributesEnum.ResidenceCountryCode.index();
    public static final int NOTIFYUSERUPONAPPROVAL = AttributesEnum.NotifyUserUponApproval.index();
    public static final int CITYNAME = AttributesEnum.CityName.index();
    public static final int WCCITYLISTID = AttributesEnum.WcCityListId.index();
    public static final int TYPEID = AttributesEnum.TypeId.index();
    public static final int IMONUMBER = AttributesEnum.ImoNumber.index();
    public static final int SENTTOLEGALBY = AttributesEnum.SentToLegalBy.index();
    public static final int REQUIRESLEGALAPPROVAL = AttributesEnum.RequiresLegalApproval.index();

    /**
     * This is the default constructor (do not remove).
     */
    public WcScreeningRequestImpl() {
    }

    /**
     * @return the definition object for this instance class.
     */
    public static synchronized EntityDefImpl getDefinitionObject() {
        return EntityDefImpl.findDefObject("com.rmi.manualtradecompliance.adfbc.entities.WcScreeningRequest");
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
     * Gets the attribute value for NameScreened, using the alias name NameScreened.
     * @return the value of NameScreened
     */
    public String getNameScreened() {
        return (String) getAttributeInternal(NAMESCREENED);
    }

    /**
     * Sets <code>value</code> as the attribute value for NameScreened.
     * @param value value to set the NameScreened
     */
    public void setNameScreened(String value) {
        setAttributeInternal(NAMESCREENED, value);
    }

    /**
     * Gets the attribute value for DateOfBirth, using the alias name DateOfBirth.
     * @return the value of DateOfBirth
     */
    public Timestamp getDateOfBirth() {
        return (Timestamp) getAttributeInternal(DATEOFBIRTH);
    }

    /**
     * Sets <code>value</code> as the attribute value for DateOfBirth.
     * @param value value to set the DateOfBirth
     */
    public void setDateOfBirth(Timestamp value) {
        setAttributeInternal(DATEOFBIRTH, value);
    }

    /**
     * Gets the attribute value for Sex, using the alias name Sex.
     * @return the value of Sex
     */
    public String getSex() {
        return (String) getAttributeInternal(SEX);
    }

    /**
     * Sets <code>value</code> as the attribute value for Sex.
     * @param value value to set the Sex
     */
    public void setSex(String value) {
        setAttributeInternal(SEX, value);
    }

    /**
     * Gets the attribute value for NameIdentifier, using the alias name NameIdentifier.
     * @return the value of NameIdentifier
     */
    public String getNameIdentifier() {
        return (String) getAttributeInternal(NAMEIDENTIFIER);
    }

    /**
     * Sets <code>value</code> as the attribute value for NameIdentifier.
     * @param value value to set the NameIdentifier
     */
    public void setNameIdentifier(String value) {
        setAttributeInternal(NAMEIDENTIFIER, value);
    }

    /**
     * Gets the attribute value for PassportNumber, using the alias name PassportNumber.
     * @return the value of PassportNumber
     */
    public String getPassportNumber() {
        return (String) getAttributeInternal(PASSPORTNUMBER);
    }

    /**
     * Sets <code>value</code> as the attribute value for PassportNumber.
     * @param value value to set the PassportNumber
     */
    public void setPassportNumber(String value) {
        setAttributeInternal(PASSPORTNUMBER, value);
    }

    /**
     * Gets the attribute value for XmlResponse, using the alias name XmlResponse.
     * @return the value of XmlResponse
     */
    public Xmltype getXmlResponse() {
        return (Xmltype) getAttributeInternal(XMLRESPONSE);
    }

    /**
     * Sets <code>value</code> as the attribute value for XmlResponse.
     * @param value value to set the XmlResponse
     */
    public void setXmlResponse(Xmltype value) {
        setAttributeInternal(XMLRESPONSE, value);
    }

    /**
     * Gets the attribute value for EntityType, using the alias name EntityType.
     * @return the value of EntityType
     */
    public String getEntityType() {
        return (String) getAttributeInternal(ENTITYTYPE);
    }

    /**
     * Sets <code>value</code> as the attribute value for EntityType.
     * @param value value to set the EntityType
     */
    public void setEntityType(String value) {
        setAttributeInternal(ENTITYTYPE, value);
    }

    /**
     * Gets the attribute value for PassportIssuingCountryCode, using the alias name PassportIssuingCountryCode.
     * @return the value of PassportIssuingCountryCode
     */
    public String getPassportIssuingCountryCode() {
        return (String) getAttributeInternal(PASSPORTISSUINGCOUNTRYCODE);
    }

    /**
     * Sets <code>value</code> as the attribute value for PassportIssuingCountryCode.
     * @param value value to set the PassportIssuingCountryCode
     */
    public void setPassportIssuingCountryCode(String value) {
        setAttributeInternal(PASSPORTISSUINGCOUNTRYCODE, value);
    }

    /**
     * Gets the attribute value for StatusUpdatedBy, using the alias name StatusUpdatedBy.
     * @return the value of StatusUpdatedBy
     */
    public BigDecimal getStatusUpdatedBy() {
        return (BigDecimal) getAttributeInternal(STATUSUPDATEDBY);
    }

    /**
     * Sets <code>value</code> as the attribute value for StatusUpdatedBy.
     * @param value value to set the StatusUpdatedBy
     */
    public void setStatusUpdatedBy(BigDecimal value) {
        setAttributeInternal(STATUSUPDATEDBY, value);
    }

    /**
     * Gets the attribute value for StatusDate, using the alias name StatusDate.
     * @return the value of StatusDate
     */
    public Timestamp getStatusDate() {
        return (Timestamp) getAttributeInternal(STATUSDATE);
    }

    /**
     * Sets <code>value</code> as the attribute value for StatusDate.
     * @param value value to set the StatusDate
     */
    public void setStatusDate(Timestamp value) {
        setAttributeInternal(STATUSDATE, value);
    }

    /**
     * Gets the attribute value for Notes, using the alias name Notes.
     * @return the value of Notes
     */
    public String getNotes() {
        return (String) getAttributeInternal(NOTES);
    }

    /**
     * Sets <code>value</code> as the attribute value for Notes.
     * @param value value to set the Notes
     */
    public void setNotes(String value) {
        setAttributeInternal(NOTES, value);
    }

    /**
     * Gets the attribute value for OfacListEdocId, using the alias name OfacListEdocId.
     * @return the value of OfacListEdocId
     */
    public Integer getOfacListEdocId() {
        return (Integer) getAttributeInternal(OFACLISTEDOCID);
    }

    /**
     * Sets <code>value</code> as the attribute value for OfacListEdocId.
     * @param value value to set the OfacListEdocId
     */
    public void setOfacListEdocId(Integer value) {
        setAttributeInternal(OFACLISTEDOCID, value);
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
     * Gets the attribute value for OfacListIsEntyOnList, using the alias name OfacListIsEntyOnList.
     * @return the value of OfacListIsEntyOnList
     */
    public String getOfacListIsEntyOnList() {
        return (String) getAttributeInternal(OFACLISTISENTYONLIST);
    }

    /**
     * Sets <code>value</code> as the attribute value for OfacListIsEntyOnList.
     * @param value value to set the OfacListIsEntyOnList
     */
    public void setOfacListIsEntyOnList(String value) {
        setAttributeInternal(OFACLISTISENTYONLIST, value);
    }

    /**
     * Gets the attribute value for CorpResidenceCountryCode, using the alias name CorpResidenceCountryCode.
     * @return the value of CorpResidenceCountryCode
     */
    public String getCorpResidenceCountryCode() {
        return (String) getAttributeInternal(CORPRESIDENCECOUNTRYCODE);
    }

    /**
     * Sets <code>value</code> as the attribute value for CorpResidenceCountryCode.
     * @param value value to set the CorpResidenceCountryCode
     */
    public void setCorpResidenceCountryCode(String value) {
        setAttributeInternal(CORPRESIDENCECOUNTRYCODE, value);
    }

    /**
     * Gets the attribute value for CitizenshipCountryCode, using the alias name CitizenshipCountryCode.
     * @return the value of CitizenshipCountryCode
     */
    public String getCitizenshipCountryCode() {
        return (String) getAttributeInternal(CITIZENSHIPCOUNTRYCODE);
    }

    /**
     * Sets <code>value</code> as the attribute value for CitizenshipCountryCode.
     * @param value value to set the CitizenshipCountryCode
     */
    public void setCitizenshipCountryCode(String value) {
        setAttributeInternal(CITIZENSHIPCOUNTRYCODE, value);
    }

    /**
     * Gets the attribute value for AliasWcScreeningRequestId, using the alias name AliasWcScreeningRequestId.
     * @return the value of AliasWcScreeningRequestId
     */
    public BigDecimal getAliasWcScreeningRequestId() {
        return (BigDecimal) getAttributeInternal(ALIASWCSCREENINGREQUESTID);
    }

    /**
     * Sets <code>value</code> as the attribute value for AliasWcScreeningRequestId.
     * @param value value to set the AliasWcScreeningRequestId
     */
    public void setAliasWcScreeningRequestId(BigDecimal value) {
        setAttributeInternal(ALIASWCSCREENINGREQUESTID, value);
    }

    /**
     * Gets the attribute value for SentToLegalDate, using the alias name SentToLegalDate.
     * @return the value of SentToLegalDate
     */
    public Timestamp getSentToLegalDate() {
        return (Timestamp) getAttributeInternal(SENTTOLEGALDATE);
    }

    /**
     * Sets <code>value</code> as the attribute value for SentToLegalDate.
     * @param value value to set the SentToLegalDate
     */
    public void setSentToLegalDate(Timestamp value) {
        setAttributeInternal(SENTTOLEGALDATE, value);
    }

    /**
     * Gets the attribute value for ResidenceCountryCode, using the alias name ResidenceCountryCode.
     * @return the value of ResidenceCountryCode
     */
    public String getResidenceCountryCode() {
        return (String) getAttributeInternal(RESIDENCECOUNTRYCODE);
    }

    /**
     * Sets <code>value</code> as the attribute value for ResidenceCountryCode.
     * @param value value to set the ResidenceCountryCode
     */
    public void setResidenceCountryCode(String value) {
        setAttributeInternal(RESIDENCECOUNTRYCODE, value);
    }

    /**
     * Gets the attribute value for NotifyUserUponApproval, using the alias name NotifyUserUponApproval.
     * @return the value of NotifyUserUponApproval
     */
    public String getNotifyUserUponApproval() {
        return (String) getAttributeInternal(NOTIFYUSERUPONAPPROVAL);
    }

    /**
     * Sets <code>value</code> as the attribute value for NotifyUserUponApproval.
     * @param value value to set the NotifyUserUponApproval
     */
    public void setNotifyUserUponApproval(String value) {
        setAttributeInternal(NOTIFYUSERUPONAPPROVAL, value);
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
     * Gets the attribute value for TypeId, using the alias name TypeId.
     * @return the value of TypeId
     */
    public Integer getTypeId() {
        return (Integer) getAttributeInternal(TYPEID);
    }

    /**
     * Sets <code>value</code> as the attribute value for TypeId.
     * @param value value to set the TypeId
     */
    public void setTypeId(Integer value) {
        setAttributeInternal(TYPEID, value);
    }

    /**
     * Gets the attribute value for ImoNumber, using the alias name ImoNumber.
     * @return the value of ImoNumber
     */
    public BigDecimal getImoNumber() {
        return (BigDecimal) getAttributeInternal(IMONUMBER);
    }

    /**
     * Sets <code>value</code> as the attribute value for ImoNumber.
     * @param value value to set the ImoNumber
     */
    public void setImoNumber(BigDecimal value) {
        setAttributeInternal(IMONUMBER, value);
    }

    /**
     * Gets the attribute value for SentToLegalBy, using the alias name SentToLegalBy.
     * @return the value of SentToLegalBy
     */
    public BigDecimal getSentToLegalBy() {
        return (BigDecimal) getAttributeInternal(SENTTOLEGALBY);
    }

    /**
     * Sets <code>value</code> as the attribute value for SentToLegalBy.
     * @param value value to set the SentToLegalBy
     */
    public void setSentToLegalBy(BigDecimal value) {
        setAttributeInternal(SENTTOLEGALBY, value);
    }

    /**
     * Gets the attribute value for RequiresLegalApproval, using the alias name RequiresLegalApproval.
     * @return the value of RequiresLegalApproval
     */
    public String getRequiresLegalApproval() {
        return (String) getAttributeInternal(REQUIRESLEGALAPPROVAL);
    }

    /**
     * Sets <code>value</code> as the attribute value for RequiresLegalApproval.
     * @param value value to set the RequiresLegalApproval
     */
    public void setRequiresLegalApproval(String value) {
        setAttributeInternal(REQUIRESLEGALAPPROVAL, value);
    }


    /**
     * @param wcScreeningRequestId key constituent

     * @return a Key object based on given key constituents.
     */
    public static Key createPrimaryKey(BigDecimal wcScreeningRequestId) {
        return new Key(new Object[] { wcScreeningRequestId });
    }

    /**
     * Add attribute defaulting logic in this method.
     * @param attributeList list of attribute names/values to initialize the row
     */
    protected void create(AttributeList attributeList)
    {
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

