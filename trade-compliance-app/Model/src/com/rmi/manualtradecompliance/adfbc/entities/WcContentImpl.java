package com.rmi.manualtradecompliance.adfbc.entities;

import com.rmi.manualtradecompliance.adfbc.entities.common.Xmltype3;

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
// ---    Mon Feb 11 13:14:20 IST 2019
// ---    Custom code may be added to this class.
// ---    Warning: Do not modify method signatures of generated methods.
// ---------------------------------------------------------------------
public class WcContentImpl extends CustomEntity {
    /**
     * AttributesEnum: generated enum for identifying attributes and accessors. DO NOT MODIFY.
     */
    public enum AttributesEnum {
        WcContentId,
        WcMatchesId,
        XmlResponse,
        CreatedBy,
        CreationDate,
        LastUpdatedBy,
        LastUpdateDate,
        LastUpdateLogin,
        Matchentityidentifier,
        Matchidentifier,
        Matchscore,
        Matchstatus,
        Matchtype,
        Surname,
        GivenName,
        DateOfBirth,
        DateOfDeath,
        Sex,
        Status,
        PassportNumber,
        Notes,
        UserClearable,
        WcScreeningRequestId,
        NmName,
        NmDobAge,
        NmSex,
        NmDead,
        NmVisual,
        NmFatherName,
        NmImoNumber,
        NmCnnm;
        private static AttributesEnum[] vals = null;
        private static final int firstIndex = 0;

        public int index() {
            return WcContentImpl.AttributesEnum.firstIndex() + ordinal();
        }

        public static final int firstIndex() {
            return firstIndex;
        }

        public static int count() {
            return WcContentImpl.AttributesEnum.firstIndex() + WcContentImpl.AttributesEnum.staticValues().length;
        }

        public static final AttributesEnum[] staticValues() {
            if (vals == null) {
                vals = WcContentImpl.AttributesEnum.values();
            }
            return vals;
        }
    }
    public static final int WCCONTENTID = AttributesEnum.WcContentId.index();
    public static final int WCMATCHESID = AttributesEnum.WcMatchesId.index();
    public static final int XMLRESPONSE = AttributesEnum.XmlResponse.index();
    public static final int CREATEDBY = AttributesEnum.CreatedBy.index();
    public static final int CREATIONDATE = AttributesEnum.CreationDate.index();
    public static final int LASTUPDATEDBY = AttributesEnum.LastUpdatedBy.index();
    public static final int LASTUPDATEDATE = AttributesEnum.LastUpdateDate.index();
    public static final int LASTUPDATELOGIN = AttributesEnum.LastUpdateLogin.index();
    public static final int MATCHENTITYIDENTIFIER = AttributesEnum.Matchentityidentifier.index();
    public static final int MATCHIDENTIFIER = AttributesEnum.Matchidentifier.index();
    public static final int MATCHSCORE = AttributesEnum.Matchscore.index();
    public static final int MATCHSTATUS = AttributesEnum.Matchstatus.index();
    public static final int MATCHTYPE = AttributesEnum.Matchtype.index();
    public static final int SURNAME = AttributesEnum.Surname.index();
    public static final int GIVENNAME = AttributesEnum.GivenName.index();
    public static final int DATEOFBIRTH = AttributesEnum.DateOfBirth.index();
    public static final int DATEOFDEATH = AttributesEnum.DateOfDeath.index();
    public static final int SEX = AttributesEnum.Sex.index();
    public static final int STATUS = AttributesEnum.Status.index();
    public static final int PASSPORTNUMBER = AttributesEnum.PassportNumber.index();
    public static final int NOTES = AttributesEnum.Notes.index();
    public static final int USERCLEARABLE = AttributesEnum.UserClearable.index();
    public static final int WCSCREENINGREQUESTID = AttributesEnum.WcScreeningRequestId.index();
    public static final int NMNAME = AttributesEnum.NmName.index();
    public static final int NMDOBAGE = AttributesEnum.NmDobAge.index();
    public static final int NMSEX = AttributesEnum.NmSex.index();
    public static final int NMDEAD = AttributesEnum.NmDead.index();
    public static final int NMVISUAL = AttributesEnum.NmVisual.index();
    public static final int NMFATHERNAME = AttributesEnum.NmFatherName.index();
    public static final int NMIMONUMBER = AttributesEnum.NmImoNumber.index();
    public static final int NMCNNM = AttributesEnum.NmCnnm.index();

    /**
     * This is the default constructor (do not remove).
     */
    public WcContentImpl() {
    }

    /**
     * Gets the attribute value for WcContentId, using the alias name WcContentId.
     * @return the value of WcContentId
     */
    public BigDecimal getWcContentId() {
        return (BigDecimal) getAttributeInternal(WCCONTENTID);
    }

    /**
     * Sets <code>value</code> as the attribute value for WcContentId.
     * @param value value to set the WcContentId
     */
    public void setWcContentId(BigDecimal value) {
        setAttributeInternal(WCCONTENTID, value);
    }

    /**
     * Gets the attribute value for WcMatchesId, using the alias name WcMatchesId.
     * @return the value of WcMatchesId
     */
    public BigDecimal getWcMatchesId() {
        return (BigDecimal) getAttributeInternal(WCMATCHESID);
    }

    /**
     * Sets <code>value</code> as the attribute value for WcMatchesId.
     * @param value value to set the WcMatchesId
     */
    public void setWcMatchesId(BigDecimal value) {
        setAttributeInternal(WCMATCHESID, value);
    }

    /**
     * Gets the attribute value for XmlResponse, using the alias name XmlResponse.
     * @return the value of XmlResponse
     */
    public Xmltype3 getXmlResponse() {
        return (Xmltype3) getAttributeInternal(XMLRESPONSE);
    }

    /**
     * Sets <code>value</code> as the attribute value for XmlResponse.
     * @param value value to set the XmlResponse
     */
    public void setXmlResponse(Xmltype3 value) {
        setAttributeInternal(XMLRESPONSE, value);
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
     * Gets the attribute value for Matchentityidentifier, using the alias name Matchentityidentifier.
     * @return the value of Matchentityidentifier
     */
    public String getMatchentityidentifier() {
        return (String) getAttributeInternal(MATCHENTITYIDENTIFIER);
    }

    /**
     * Sets <code>value</code> as the attribute value for Matchentityidentifier.
     * @param value value to set the Matchentityidentifier
     */
    public void setMatchentityidentifier(String value) {
        setAttributeInternal(MATCHENTITYIDENTIFIER, value);
    }

    /**
     * Gets the attribute value for Matchidentifier, using the alias name Matchidentifier.
     * @return the value of Matchidentifier
     */
    public String getMatchidentifier() {
        return (String) getAttributeInternal(MATCHIDENTIFIER);
    }

    /**
     * Sets <code>value</code> as the attribute value for Matchidentifier.
     * @param value value to set the Matchidentifier
     */
    public void setMatchidentifier(String value) {
        setAttributeInternal(MATCHIDENTIFIER, value);
    }

    /**
     * Gets the attribute value for Matchscore, using the alias name Matchscore.
     * @return the value of Matchscore
     */
    public BigDecimal getMatchscore() {
        return (BigDecimal) getAttributeInternal(MATCHSCORE);
    }

    /**
     * Sets <code>value</code> as the attribute value for Matchscore.
     * @param value value to set the Matchscore
     */
    public void setMatchscore(BigDecimal value) {
        setAttributeInternal(MATCHSCORE, value);
    }

    /**
     * Gets the attribute value for Matchstatus, using the alias name Matchstatus.
     * @return the value of Matchstatus
     */
    public String getMatchstatus() {
        return (String) getAttributeInternal(MATCHSTATUS);
    }

    /**
     * Sets <code>value</code> as the attribute value for Matchstatus.
     * @param value value to set the Matchstatus
     */
    public void setMatchstatus(String value) {
        setAttributeInternal(MATCHSTATUS, value);
    }

    /**
     * Gets the attribute value for Matchtype, using the alias name Matchtype.
     * @return the value of Matchtype
     */
    public String getMatchtype() {
        return (String) getAttributeInternal(MATCHTYPE);
    }

    /**
     * Sets <code>value</code> as the attribute value for Matchtype.
     * @param value value to set the Matchtype
     */
    public void setMatchtype(String value) {
        setAttributeInternal(MATCHTYPE, value);
    }

    /**
     * Gets the attribute value for Surname, using the alias name Surname.
     * @return the value of Surname
     */
    public String getSurname() {
        return (String) getAttributeInternal(SURNAME);
    }

    /**
     * Sets <code>value</code> as the attribute value for Surname.
     * @param value value to set the Surname
     */
    public void setSurname(String value) {
        setAttributeInternal(SURNAME, value);
    }

    /**
     * Gets the attribute value for GivenName, using the alias name GivenName.
     * @return the value of GivenName
     */
    public String getGivenName() {
        return (String) getAttributeInternal(GIVENNAME);
    }

    /**
     * Sets <code>value</code> as the attribute value for GivenName.
     * @param value value to set the GivenName
     */
    public void setGivenName(String value) {
        setAttributeInternal(GIVENNAME, value);
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
     * Gets the attribute value for DateOfDeath, using the alias name DateOfDeath.
     * @return the value of DateOfDeath
     */
    public Timestamp getDateOfDeath() {
        return (Timestamp) getAttributeInternal(DATEOFDEATH);
    }

    /**
     * Sets <code>value</code> as the attribute value for DateOfDeath.
     * @param value value to set the DateOfDeath
     */
    public void setDateOfDeath(Timestamp value) {
        setAttributeInternal(DATEOFDEATH, value);
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
     * Gets the attribute value for UserClearable, using the alias name UserClearable.
     * @return the value of UserClearable
     */
    public String getUserClearable() {
        return (String) getAttributeInternal(USERCLEARABLE);
    }

    /**
     * Sets <code>value</code> as the attribute value for UserClearable.
     * @param value value to set the UserClearable
     */
    public void setUserClearable(String value) {
        setAttributeInternal(USERCLEARABLE, value);
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
     * Gets the attribute value for NmName, using the alias name NmName.
     * @return the value of NmName
     */
    public String getNmName() {
        return (String) getAttributeInternal(NMNAME);
    }

    /**
     * Sets <code>value</code> as the attribute value for NmName.
     * @param value value to set the NmName
     */
    public void setNmName(String value) {
        setAttributeInternal(NMNAME, value);
    }

    /**
     * Gets the attribute value for NmDobAge, using the alias name NmDobAge.
     * @return the value of NmDobAge
     */
    public String getNmDobAge() {
        return (String) getAttributeInternal(NMDOBAGE);
    }

    /**
     * Sets <code>value</code> as the attribute value for NmDobAge.
     * @param value value to set the NmDobAge
     */
    public void setNmDobAge(String value) {
        setAttributeInternal(NMDOBAGE, value);
    }

    /**
     * Gets the attribute value for NmSex, using the alias name NmSex.
     * @return the value of NmSex
     */
    public String getNmSex() {
        return (String) getAttributeInternal(NMSEX);
    }

    /**
     * Sets <code>value</code> as the attribute value for NmSex.
     * @param value value to set the NmSex
     */
    public void setNmSex(String value) {
        setAttributeInternal(NMSEX, value);
    }

    /**
     * Gets the attribute value for NmDead, using the alias name NmDead.
     * @return the value of NmDead
     */
    public String getNmDead() {
        return (String) getAttributeInternal(NMDEAD);
    }

    /**
     * Sets <code>value</code> as the attribute value for NmDead.
     * @param value value to set the NmDead
     */
    public void setNmDead(String value) {
        setAttributeInternal(NMDEAD, value);
    }

    /**
     * Gets the attribute value for NmVisual, using the alias name NmVisual.
     * @return the value of NmVisual
     */
    public String getNmVisual() {
        return (String) getAttributeInternal(NMVISUAL);
    }

    /**
     * Sets <code>value</code> as the attribute value for NmVisual.
     * @param value value to set the NmVisual
     */
    public void setNmVisual(String value) {
        setAttributeInternal(NMVISUAL, value);
    }

    /**
     * Gets the attribute value for NmFatherName, using the alias name NmFatherName.
     * @return the value of NmFatherName
     */
    public String getNmFatherName() {
        return (String) getAttributeInternal(NMFATHERNAME);
    }

    /**
     * Sets <code>value</code> as the attribute value for NmFatherName.
     * @param value value to set the NmFatherName
     */
    public void setNmFatherName(String value) {
        setAttributeInternal(NMFATHERNAME, value);
    }

    /**
     * Gets the attribute value for NmImoNumber, using the alias name NmImoNumber.
     * @return the value of NmImoNumber
     */
    public String getNmImoNumber() {
        return (String) getAttributeInternal(NMIMONUMBER);
    }

    /**
     * Sets <code>value</code> as the attribute value for NmImoNumber.
     * @param value value to set the NmImoNumber
     */
    public void setNmImoNumber(String value) {
        setAttributeInternal(NMIMONUMBER, value);
    }

    /**
     * Gets the attribute value for NmCnnm, using the alias name NmCnnm.
     * @return the value of NmCnnm
     */
    public String getNmCnnm() {
        return (String) getAttributeInternal(NMCNNM);
    }

    /**
     * Sets <code>value</code> as the attribute value for NmCnnm.
     * @param value value to set the NmCnnm
     */
    public void setNmCnnm(String value) {
        setAttributeInternal(NMCNNM, value);
    }

    /**
     * @param wcContentId key constituent

     * @return a Key object based on given key constituents.
     */
    public static Key createPrimaryKey(BigDecimal wcContentId) {
        return new Key(new Object[] { wcContentId });
    }

    /**
     * @return the definition object for this instance class.
     */
    public static synchronized EntityDefImpl getDefinitionObject() {
        return EntityDefImpl.findDefObject("com.rmi.manualtradecompliance.adfbc.entities.WcContent");
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
