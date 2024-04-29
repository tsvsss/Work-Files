package com.rmi.manualtradecompliance.adfbc.views;

import com.rmi.manualtradecompliance.adfbc.services.RMIManualTradeComplianceAppModuleImpl;
import com.rmi.manualtradecompliance.adfbc.entities.WcScreeningRequestImpl;
import com.rmi.manualtradecompliance.adfbc.entities.common.Xmltype;

import com.rmi.manualtradecompliance.adfbc.utils.AdfUtils;

import java.math.BigDecimal;

import java.sql.Timestamp;

import javax.faces.application.FacesMessage;

import oracle.jbo.Row;
import oracle.jbo.RowIterator;
import oracle.jbo.RowSet;
import oracle.jbo.server.ViewObjectImpl;
import oracle.jbo.server.ViewRowImpl;

import org.apache.myfaces.trinidad.context.RequestContext;
// ---------------------------------------------------------------------
// ---    File generated by Oracle ADF Business Components Design Time.
// ---    Wed Feb 13 13:36:10 IST 2019
// ---    Custom code may be added to this class.
// ---    Warning: Do not modify method signatures of generated methods.
// ---------------------------------------------------------------------
public class WcScreeningRequestViewRowImpl extends ViewRowImpl {


    public static final int ENTITY_WCSCREENINGREQUESTEO = 0;

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
        RequiresLegalApproval,
        StatusUpdatedByName,
        TransResidenceCntry,
        TransIdIssuingCntry,
        TransPermanentAddres,
        TransCityName,
        TransOnlineConsentStartDate,
        TransOnlineConsentEndDate,
        TransUploadedConsentStartDate,
        TransUploadedConsentEndDate,
        TransUploadedConsentEdocId,
        TransOnlineConfirmationNumber,
        WcRequestDocumentsVO,
        YesNoLov1,
        StatusLOV1,
        FndUsers1,
        LovCountriesVO1,
        LovIdTypeVO1,
        LovCityNameVO1,
        LovIsOfacEntityOnListView1,
        LovYesNoView1;
        static AttributesEnum[] vals = null;
        ;
        private static final int firstIndex = 0;

        public int index() {
            return WcScreeningRequestViewRowImpl.AttributesEnum.firstIndex() + ordinal();
        }

        public static final int firstIndex() {
            return firstIndex;
        }

        public static int count() {
            return WcScreeningRequestViewRowImpl.AttributesEnum.firstIndex() +
                   WcScreeningRequestViewRowImpl.AttributesEnum.staticValues().length;
        }

        public static final AttributesEnum[] staticValues() {
            if (vals == null) {
                vals = WcScreeningRequestViewRowImpl.AttributesEnum.values();
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
    public static final int STATUSUPDATEDBYNAME = AttributesEnum.StatusUpdatedByName.index();
    public static final int TRANSRESIDENCECNTRY = AttributesEnum.TransResidenceCntry.index();
    public static final int TRANSIDISSUINGCNTRY = AttributesEnum.TransIdIssuingCntry.index();
    public static final int TRANSPERMANENTADDRES = AttributesEnum.TransPermanentAddres.index();
    public static final int TRANSCITYNAME = AttributesEnum.TransCityName.index();
    public static final int TRANSONLINECONSENTSTARTDATE = AttributesEnum.TransOnlineConsentStartDate.index();
    public static final int TRANSONLINECONSENTENDDATE = AttributesEnum.TransOnlineConsentEndDate.index();
    public static final int TRANSUPLOADEDCONSENTSTARTDATE = AttributesEnum.TransUploadedConsentStartDate.index();
    public static final int TRANSUPLOADEDCONSENTENDDATE = AttributesEnum.TransUploadedConsentEndDate.index();
    public static final int TRANSUPLOADEDCONSENTEDOCID = AttributesEnum.TransUploadedConsentEdocId.index();
    public static final int TRANSONLINECONFIRMATIONNUMBER = AttributesEnum.TransOnlineConfirmationNumber.index();
    public static final int WCREQUESTDOCUMENTSVO = AttributesEnum.WcRequestDocumentsVO.index();
    public static final int YESNOLOV1 = AttributesEnum.YesNoLov1.index();
    public static final int STATUSLOV1 = AttributesEnum.StatusLOV1.index();
    public static final int FNDUSERS1 = AttributesEnum.FndUsers1.index();
    public static final int LOVCOUNTRIESVO1 = AttributesEnum.LovCountriesVO1.index();
    public static final int LOVIDTYPEVO1 = AttributesEnum.LovIdTypeVO1.index();
    public static final int LOVCITYNAMEVO1 = AttributesEnum.LovCityNameVO1.index();
    public static final int LOVISOFACENTITYONLISTVIEW1 = AttributesEnum.LovIsOfacEntityOnListView1.index();
    public static final int LOVYESNOVIEW1 = AttributesEnum.LovYesNoView1.index();

    /**
     * This is the default constructor (do not remove).
     */
    public WcScreeningRequestViewRowImpl() {
    }

    /**
     * Gets WcScreeningRequestEO entity object.
     * @return the WcScreeningRequestEO
     */
    public WcScreeningRequestImpl getWcScreeningRequestEO() {
        return (WcScreeningRequestImpl) getEntity(ENTITY_WCSCREENINGREQUESTEO);
    }

    /**
     * Gets the attribute value for WC_SCREENING_REQUEST_ID using the alias name WcScreeningRequestId.
     * @return the WC_SCREENING_REQUEST_ID
     */
    public BigDecimal getWcScreeningRequestId() {
        return (BigDecimal) getAttributeInternal(WCSCREENINGREQUESTID);
    }

    /**
     * Sets <code>value</code> as attribute value for WC_SCREENING_REQUEST_ID using the alias name WcScreeningRequestId.
     * @param value value to set the WC_SCREENING_REQUEST_ID
     */
    public void setWcScreeningRequestId(BigDecimal value) {
        setAttributeInternal(WCSCREENINGREQUESTID, value);
    }

    /**
     * Gets the attribute value for STATUS using the alias name Status.
     * @return the STATUS
     */
    public String getStatus() {
        return (String) getAttributeInternal(STATUS);
    }

    /**
     * Sets <code>value</code> as attribute value for STATUS using the alias name Status.
     * @param value value to set the STATUS
     */
    public void setStatus(String value) 
    {
        setAttributeInternal(STATUS, value);
    }

    /**
     * Gets the attribute value for NAME_SCREENED using the alias name NameScreened.
     * @return the NAME_SCREENED
     */
    public String getNameScreened() {
        return (String) getAttributeInternal(NAMESCREENED);
    }

    /**
     * Sets <code>value</code> as attribute value for NAME_SCREENED using the alias name NameScreened.
     * @param value value to set the NAME_SCREENED
     */
    public void setNameScreened(String value) {
        setAttributeInternal(NAMESCREENED, value);
    }

    /**
     * Gets the attribute value for DATE_OF_BIRTH using the alias name DateOfBirth.
     * @return the DATE_OF_BIRTH
     */
    public Timestamp getDateOfBirth() {
        return (Timestamp) getAttributeInternal(DATEOFBIRTH);
    }

    /**
     * Sets <code>value</code> as attribute value for DATE_OF_BIRTH using the alias name DateOfBirth.
     * @param value value to set the DATE_OF_BIRTH
     */
    public void setDateOfBirth(Timestamp value) {
        setAttributeInternal(DATEOFBIRTH, value);
    }

    /**
     * Gets the attribute value for SEX using the alias name Sex.
     * @return the SEX
     */
    public String getSex()
    {
        try 
        {
            if (getAttributeInternal(SEX) != null)
                return ((String) getAttributeInternal(SEX)).toUpperCase();
        } catch (Exception e) {
            e.printStackTrace();
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching data." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
       return (String) getAttributeInternal(SEX);
    }

    /**
     * Sets <code>value</code> as attribute value for SEX using the alias name Sex.
     * @param value value to set the SEX
     */
    public void setSex(String value) {
        setAttributeInternal(SEX, value);
    }

    /**
     * Gets the attribute value for NAME_IDENTIFIER using the alias name NameIdentifier.
     * @return the NAME_IDENTIFIER
     */
    public String getNameIdentifier() {
        return (String) getAttributeInternal(NAMEIDENTIFIER);
    }

    /**
     * Sets <code>value</code> as attribute value for NAME_IDENTIFIER using the alias name NameIdentifier.
     * @param value value to set the NAME_IDENTIFIER
     */
    public void setNameIdentifier(String value) {
        setAttributeInternal(NAMEIDENTIFIER, value);
    }

    /**
     * Gets the attribute value for PASSPORT_NUMBER using the alias name PassportNumber.
     * @return the PASSPORT_NUMBER
     */
    public String getPassportNumber() {
        return (String) getAttributeInternal(PASSPORTNUMBER);
    }

    /**
     * Sets <code>value</code> as attribute value for PASSPORT_NUMBER using the alias name PassportNumber.
     * @param value value to set the PASSPORT_NUMBER
     */
    public void setPassportNumber(String value) {
        setAttributeInternal(PASSPORTNUMBER, value);
    }

    /**
     * Gets the attribute value for XML_RESPONSE using the alias name XmlResponse.
     * @return the XML_RESPONSE
     */
    public Xmltype getXmlResponse() {
        return (Xmltype) getAttributeInternal(XMLRESPONSE);
    }

    /**
     * Sets <code>value</code> as attribute value for XML_RESPONSE using the alias name XmlResponse.
     * @param value value to set the XML_RESPONSE
     */
    public void setXmlResponse(Xmltype value) {
        setAttributeInternal(XMLRESPONSE, value);
    }

    /**
     * Gets the attribute value for ENTITY_TYPE using the alias name EntityType.
     * @return the ENTITY_TYPE
     */
    public String getEntityType() {
        return (String) getAttributeInternal(ENTITYTYPE);
    }

    /**
     * Sets <code>value</code> as attribute value for ENTITY_TYPE using the alias name EntityType.
     * @param value value to set the ENTITY_TYPE
     */
    public void setEntityType(String value) {
        setAttributeInternal(ENTITYTYPE, value);
    }

    /**
     * Gets the attribute value for PASSPORT_ISSUING_COUNTRY_CODE using the alias name PassportIssuingCountryCode.
     * @return the PASSPORT_ISSUING_COUNTRY_CODE
     */
    public String getPassportIssuingCountryCode() {
        return (String) getAttributeInternal(PASSPORTISSUINGCOUNTRYCODE);
    }

    /**
     * Sets <code>value</code> as attribute value for PASSPORT_ISSUING_COUNTRY_CODE using the alias name PassportIssuingCountryCode.
     * @param value value to set the PASSPORT_ISSUING_COUNTRY_CODE
     */
    public void setPassportIssuingCountryCode(String value) {
        setAttributeInternal(PASSPORTISSUINGCOUNTRYCODE, value);
    }

    /**
     * Gets the attribute value for STATUS_UPDATED_BY using the alias name StatusUpdatedBy.
     * @return the STATUS_UPDATED_BY
     */
    public BigDecimal getStatusUpdatedBy() {
        return (BigDecimal) getAttributeInternal(STATUSUPDATEDBY);
    }

    /**
     * Sets <code>value</code> as attribute value for STATUS_UPDATED_BY using the alias name StatusUpdatedBy.
     * @param value value to set the STATUS_UPDATED_BY
     */
    public void setStatusUpdatedBy(BigDecimal value) {
        setAttributeInternal(STATUSUPDATEDBY, value);
    }

    /**
     * Gets the attribute value for STATUS_DATE using the alias name StatusDate.
     * @return the STATUS_DATE
     */
    public Timestamp getStatusDate() {
        return (Timestamp) getAttributeInternal(STATUSDATE);
    }

    /**
     * Sets <code>value</code> as attribute value for STATUS_DATE using the alias name StatusDate.
     * @param value value to set the STATUS_DATE
     */
    public void setStatusDate(Timestamp value) {
        setAttributeInternal(STATUSDATE, value);
    }

    /**
     * Gets the attribute value for NOTES using the alias name Notes.
     * @return the NOTES
     */
    public String getNotes() {
        return (String) getAttributeInternal(NOTES);
    }

    /**
     * Sets <code>value</code> as attribute value for NOTES using the alias name Notes.
     * @param value value to set the NOTES
     */
    public void setNotes(String value) {
        setAttributeInternal(NOTES, value);
    }

    /**
     * Gets the attribute value for OFAC_LIST_EDOC_ID using the alias name OfacListEdocId.
     * @return the OFAC_LIST_EDOC_ID
     */
    public Integer getOfacListEdocId() {
        return (Integer) getAttributeInternal(OFACLISTEDOCID);
    }

    /**
     * Sets <code>value</code> as attribute value for OFAC_LIST_EDOC_ID using the alias name OfacListEdocId.
     * @param value value to set the OFAC_LIST_EDOC_ID
     */
    public void setOfacListEdocId(Integer value) {
        setAttributeInternal(OFACLISTEDOCID, value);
    }

    /**
     * Gets the attribute value for CREATED_BY using the alias name CreatedBy.
     * @return the CREATED_BY
     */
    public BigDecimal getCreatedBy() {
        return (BigDecimal) getAttributeInternal(CREATEDBY);
    }

    /**
     * Sets <code>value</code> as attribute value for CREATED_BY using the alias name CreatedBy.
     * @param value value to set the CREATED_BY
     */
    public void setCreatedBy(BigDecimal value) {
        setAttributeInternal(CREATEDBY, value);
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
     * Gets the attribute value for LAST_UPDATED_BY using the alias name LastUpdatedBy.
     * @return the LAST_UPDATED_BY
     */
    public BigDecimal getLastUpdatedBy() {
        return (BigDecimal) getAttributeInternal(LASTUPDATEDBY);
    }

    /**
     * Sets <code>value</code> as attribute value for LAST_UPDATED_BY using the alias name LastUpdatedBy.
     * @param value value to set the LAST_UPDATED_BY
     */
    public void setLastUpdatedBy(BigDecimal value) {
        setAttributeInternal(LASTUPDATEDBY, value);
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
     * Gets the attribute value for LAST_UPDATE_LOGIN using the alias name LastUpdateLogin.
     * @return the LAST_UPDATE_LOGIN
     */
    public BigDecimal getLastUpdateLogin() {
        return (BigDecimal) getAttributeInternal(LASTUPDATELOGIN);
    }

    /**
     * Sets <code>value</code> as attribute value for LAST_UPDATE_LOGIN using the alias name LastUpdateLogin.
     * @param value value to set the LAST_UPDATE_LOGIN
     */
    public void setLastUpdateLogin(BigDecimal value) {
        setAttributeInternal(LASTUPDATELOGIN, value);
    }

    /**
     * Gets the attribute value for OFAC_LIST_IS_ENTY_ON_LIST using the alias name OfacListIsEntyOnList.
     * @return the OFAC_LIST_IS_ENTY_ON_LIST
     */
    public String getOfacListIsEntyOnList() {
        return (String) getAttributeInternal(OFACLISTISENTYONLIST);
    }

    /**
     * Sets <code>value</code> as attribute value for OFAC_LIST_IS_ENTY_ON_LIST using the alias name OfacListIsEntyOnList.
     * @param value value to set the OFAC_LIST_IS_ENTY_ON_LIST
     */
    public void setOfacListIsEntyOnList(String value) {
        setAttributeInternal(OFACLISTISENTYONLIST, value);
    }

    /**
     * Gets the attribute value for CORP_RESIDENCE_COUNTRY_CODE using the alias name CorpResidenceCountryCode.
     * @return the CORP_RESIDENCE_COUNTRY_CODE
     */
    public String getCorpResidenceCountryCode() {
        return (String) getAttributeInternal(CORPRESIDENCECOUNTRYCODE);
    }

    /**
     * Sets <code>value</code> as attribute value for CORP_RESIDENCE_COUNTRY_CODE using the alias name CorpResidenceCountryCode.
     * @param value value to set the CORP_RESIDENCE_COUNTRY_CODE
     */
    public void setCorpResidenceCountryCode(String value) {
        setAttributeInternal(CORPRESIDENCECOUNTRYCODE, value);
    }

    /**
     * Gets the attribute value for CITIZENSHIP_COUNTRY_CODE using the alias name CitizenshipCountryCode.
     * @return the CITIZENSHIP_COUNTRY_CODE
     */
    public String getCitizenshipCountryCode() {
        return (String) getAttributeInternal(CITIZENSHIPCOUNTRYCODE);
    }

    /**
     * Sets <code>value</code> as attribute value for CITIZENSHIP_COUNTRY_CODE using the alias name CitizenshipCountryCode.
     * @param value value to set the CITIZENSHIP_COUNTRY_CODE
     */
    public void setCitizenshipCountryCode(String value) {
        setAttributeInternal(CITIZENSHIPCOUNTRYCODE, value);
    }

    /**
     * Gets the attribute value for ALIAS_WC_SCREENING_REQUEST_ID using the alias name AliasWcScreeningRequestId.
     * @return the ALIAS_WC_SCREENING_REQUEST_ID
     */
    public BigDecimal getAliasWcScreeningRequestId() {
        return (BigDecimal) getAttributeInternal(ALIASWCSCREENINGREQUESTID);
    }

    /**
     * Sets <code>value</code> as attribute value for ALIAS_WC_SCREENING_REQUEST_ID using the alias name AliasWcScreeningRequestId.
     * @param value value to set the ALIAS_WC_SCREENING_REQUEST_ID
     */
    public void setAliasWcScreeningRequestId(BigDecimal value) {
        setAttributeInternal(ALIASWCSCREENINGREQUESTID, value);
    }

    /**
     * Gets the attribute value for SENT_TO_LEGAL_DATE using the alias name SentToLegalDate.
     * @return the SENT_TO_LEGAL_DATE
     */
    public Timestamp getSentToLegalDate() {
        return (Timestamp) getAttributeInternal(SENTTOLEGALDATE);
    }

    /**
     * Sets <code>value</code> as attribute value for SENT_TO_LEGAL_DATE using the alias name SentToLegalDate.
     * @param value value to set the SENT_TO_LEGAL_DATE
     */
    public void setSentToLegalDate(Timestamp value) {
        setAttributeInternal(SENTTOLEGALDATE, value);
    }

    /**
     * Gets the attribute value for RESIDENCE_COUNTRY_CODE using the alias name ResidenceCountryCode.
     * @return the RESIDENCE_COUNTRY_CODE
     */
    public String getResidenceCountryCode() {
        return (String) getAttributeInternal(RESIDENCECOUNTRYCODE);
    }

    /**
     * Sets <code>value</code> as attribute value for RESIDENCE_COUNTRY_CODE using the alias name ResidenceCountryCode.
     * @param value value to set the RESIDENCE_COUNTRY_CODE
     */
    public void setResidenceCountryCode(String value) {
        setAttributeInternal(RESIDENCECOUNTRYCODE, value);
    }

    /**
     * Gets the attribute value for NOTIFY_USER_UPON_APPROVAL using the alias name NotifyUserUponApproval.
     * @return the NOTIFY_USER_UPON_APPROVAL
     */
    public String getNotifyUserUponApproval() {
        return (String) getAttributeInternal(NOTIFYUSERUPONAPPROVAL);
    }

    /**
     * Sets <code>value</code> as attribute value for NOTIFY_USER_UPON_APPROVAL using the alias name NotifyUserUponApproval.
     * @param value value to set the NOTIFY_USER_UPON_APPROVAL
     */
    public void setNotifyUserUponApproval(String value) {
        setAttributeInternal(NOTIFYUSERUPONAPPROVAL, value);
    }

    /**
     * Gets the attribute value for CITY_NAME using the alias name CityName.
     * @return the CITY_NAME
     */
    public String getCityName() {
        return (String) getAttributeInternal(CITYNAME);
    }

    /**
     * Sets <code>value</code> as attribute value for CITY_NAME using the alias name CityName.
     * @param value value to set the CITY_NAME
     */
    public void setCityName(String value) {
        setAttributeInternal(CITYNAME, value);
    }

    /**
     * Gets the attribute value for WC_CITY_LIST_ID using the alias name WcCityListId.
     * @return the WC_CITY_LIST_ID
     */
    public BigDecimal getWcCityListId() {
        return (BigDecimal) getAttributeInternal(WCCITYLISTID);
    }

    /**
     * Sets <code>value</code> as attribute value for WC_CITY_LIST_ID using the alias name WcCityListId.
     * @param value value to set the WC_CITY_LIST_ID
     */
    public void setWcCityListId(BigDecimal value) {
        setAttributeInternal(WCCITYLISTID, value);
    }

    /**
     * Gets the attribute value for TYPE_ID using the alias name TypeId.
     * @return the TYPE_ID
     */
    public Integer getTypeId() {
        return (Integer) getAttributeInternal(TYPEID);
    }

    /**
     * Sets <code>value</code> as attribute value for TYPE_ID using the alias name TypeId.
     * @param value value to set the TYPE_ID
     */
    public void setTypeId(Integer value) {
        setAttributeInternal(TYPEID, value);
    }

    /**
     * Gets the attribute value for IMO_NUMBER using the alias name ImoNumber.
     * @return the IMO_NUMBER
     */
    public BigDecimal getImoNumber() {
        return (BigDecimal) getAttributeInternal(IMONUMBER);
    }

    /**
     * Sets <code>value</code> as attribute value for IMO_NUMBER using the alias name ImoNumber.
     * @param value value to set the IMO_NUMBER
     */
    public void setImoNumber(BigDecimal value) {
        setAttributeInternal(IMONUMBER, value);
    }

    /**
     * Gets the attribute value for SENT_TO_LEGAL_BY using the alias name SentToLegalBy.
     * @return the SENT_TO_LEGAL_BY
     */
    public BigDecimal getSentToLegalBy() {
        return (BigDecimal) getAttributeInternal(SENTTOLEGALBY);
    }

    /**
     * Sets <code>value</code> as attribute value for SENT_TO_LEGAL_BY using the alias name SentToLegalBy.
     * @param value value to set the SENT_TO_LEGAL_BY
     */
    public void setSentToLegalBy(BigDecimal value) {
        setAttributeInternal(SENTTOLEGALBY, value);
    }

    /**
     * Gets the attribute value for REQUIRES_LEGAL_APPROVAL using the alias name RequiresLegalApproval.
     * @return the REQUIRES_LEGAL_APPROVAL
     */
    public String getRequiresLegalApproval() {
        return (String) getAttributeInternal(REQUIRESLEGALAPPROVAL);
    }

    /**
     * Sets <code>value</code> as attribute value for REQUIRES_LEGAL_APPROVAL using the alias name RequiresLegalApproval.
     * @param value value to set the REQUIRES_LEGAL_APPROVAL
     */
    public void setRequiresLegalApproval(String value) {
        setAttributeInternal(REQUIRESLEGALAPPROVAL, value);
    }

    /**
     * Gets the attribute value for the calculated attribute StatusUpdatedByName.
     * @return the StatusUpdatedByName
     */
    public String getStatusUpdatedByName() {
        return (String) getAttributeInternal(STATUSUPDATEDBYNAME);
    }

    /**
     * Gets the attribute value for the calculated attribute TransResidenceCntry.
     * @return the TransResidenceCntry
     */
    public String getTransResidenceCntry()
    {
        try 
        {
            if (getAttributeInternal(TRANSRESIDENCECNTRY) == null && getResidenceCountryCode() != null) {
                ViewObjectImpl cntryVo = getAm().getLovCountriesView1();
                Row[] frRows = cntryVo.getFilteredRows("CountryCode", getResidenceCountryCode());

                if (frRows.length > 0 && frRows[0].getAttribute("CountryName") != null) {
                    return (String) frRows[0].getAttribute("CountryName");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching data." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
        return (String) getAttributeInternal(TRANSRESIDENCECNTRY);
    }

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute TransResidenceCntry.
     * @param value value to set the  TransResidenceCntry
     */
    public void setTransResidenceCntry(String value)
    {
        try 
        {
            setAttributeInternal(CITYNAME, null);
            setAttributeInternal(TRANSCITYNAME, null);
        } catch (Exception e) {
            e.printStackTrace();
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating data." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
        setAttributeInternal(TRANSRESIDENCECNTRY, value);
    }

    /**
     * Gets the attribute value for the calculated attribute TransIdIssuingCntry.
     * @return the TransIdIssuingCntry
     */
    public String getTransIdIssuingCntry() {
        return (String) getAttributeInternal(TRANSIDISSUINGCNTRY);
    }

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute TransIdIssuingCntry.
     * @param value value to set the  TransIdIssuingCntry
     */
    public void setTransIdIssuingCntry(String value) {
        setAttributeInternal(TRANSIDISSUINGCNTRY, value);
    }

    /**
     * Gets the attribute value for the calculated attribute TransPermanentAddres.
     * @return the TransPermanentAddres
     */
    public String getTransPermanentAddres()
    {
        try 
        {
            if (getAttributeInternal(TRANSPERMANENTADDRES) == null) {
                Object sourceIdObject = RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_ID");
                Object esiBatchIdObject =
                    RequestContext.getCurrentInstance().getPageFlowScope().get("P_ESI_BATCH_ID_TC");

                if (sourceIdObject != null && esiBatchIdObject != null) {
                    Integer sourceId = Integer.parseInt(sourceIdObject.toString());
                    Integer esiBatchId = Integer.parseInt(esiBatchIdObject.toString());

                    ViewObjectImpl sfrrVo = getAm().getRmiSeafarerIfaceView1();
                    sfrrVo.setNamedWhereClauseParam("pSeafarerId", (sourceId != null) ? sourceId : -1);
                    sfrrVo.setNamedWhereClauseParam("pEsiBatchId", esiBatchId);
                    sfrrVo.executeQuery();

                    Row[] sfrrRow = sfrrVo.getAllRowsInRange();

                    if (sfrrRow.length > 0) {
                        return (String) sfrrRow[0].getAttribute("PermanentAddress");
                    }
                }
            }
        } catch (Exception nfe) {
            nfe.printStackTrace();
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching data." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }        
        return (String) getAttributeInternal(TRANSPERMANENTADDRES);
    }

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute TransPermanentAddres.
     * @param value value to set the  TransPermanentAddres
     */
    public void setTransPermanentAddres(String value) {
        setAttributeInternal(TRANSPERMANENTADDRES, value);
    }

    /**
     * Gets the attribute value for the calculated attribute TransCityName.
     * @return the TransCityName
     */
    public String getTransCityName()
    {
        try 
        {
            if (getAttributeInternal(TRANSCITYNAME) == null &&
                (this.getResidenceCountryCode() != null && this.getCityName() != null)) {
                ViewObjectImpl cityVo = getAm().getLovCityNameView1();
                cityVo.setNamedWhereClauseParam("pCountryCode", getResidenceCountryCode());
                cityVo.executeQuery();

                Row[] cityRows = cityVo.getFilteredRows("CityName", this.getCityName());

                if (cityRows.length > 0 && cityRows[0].getAttribute("CityName") != null)
                    return (String) cityRows[0].getAttribute("CityName");
            }
        } catch (Exception e) {
            e.printStackTrace();
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching data." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }        
        return (String) getAttributeInternal(TRANSCITYNAME);
    }

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute TransCityName.
     * @param value value to set the  TransCityName
     */
    public void setTransCityName(String value) {
        setAttributeInternal(TRANSCITYNAME, value);
    }

    /**
     * Gets the attribute value for the calculated attribute TransOnlineConsentStartDate.
     * @return the TransOnlineConsentStartDate
     */
    public Timestamp getTransOnlineConsentStartDate() {
        return (Timestamp) getAttributeInternal(TRANSONLINECONSENTSTARTDATE);
    }

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute TransOnlineConsentStartDate.
     * @param value value to set the  TransOnlineConsentStartDate
     */
    public void setTransOnlineConsentStartDate(Timestamp value) {
        setAttributeInternal(TRANSONLINECONSENTSTARTDATE, value);
    }

    /**
     * Gets the attribute value for the calculated attribute TransOnlineConsentEndDate.
     * @return the TransOnlineConsentEndDate
     */
    public Timestamp getTransOnlineConsentEndDate() {
        return (Timestamp) getAttributeInternal(TRANSONLINECONSENTENDDATE);
    }

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute TransOnlineConsentEndDate.
     * @param value value to set the  TransOnlineConsentEndDate
     */
    public void setTransOnlineConsentEndDate(Timestamp value) {
        setAttributeInternal(TRANSONLINECONSENTENDDATE, value);
    }

    /**
     * Gets the attribute value for the calculated attribute TransUploadedConsentStartDate.
     * @return the TransUploadedConsentStartDate
     */
    public Timestamp getTransUploadedConsentStartDate() {
        return (Timestamp) getAttributeInternal(TRANSUPLOADEDCONSENTSTARTDATE);
    }

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute TransUploadedConsentStartDate.
     * @param value value to set the  TransUploadedConsentStartDate
     */
    public void setTransUploadedConsentStartDate(Timestamp value) {
        setAttributeInternal(TRANSUPLOADEDCONSENTSTARTDATE, value);
    }

    /**
     * Gets the attribute value for the calculated attribute TransUploadedConsentEndDate.
     * @return the TransUploadedConsentEndDate
     */
    public Timestamp getTransUploadedConsentEndDate() {
        return (Timestamp) getAttributeInternal(TRANSUPLOADEDCONSENTENDDATE);
    }

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute TransUploadedConsentEndDate.
     * @param value value to set the  TransUploadedConsentEndDate
     */
    public void setTransUploadedConsentEndDate(Timestamp value) {
        setAttributeInternal(TRANSUPLOADEDCONSENTENDDATE, value);
    }

    /**
     * Gets the attribute value for the calculated attribute TransUploadedConsentEdocId.
     * @return the TransUploadedConsentEdocId
     */
    public Integer getTransUploadedConsentEdocId() {
        return (Integer) getAttributeInternal(TRANSUPLOADEDCONSENTEDOCID);
    }

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute TransUploadedConsentEdocId.
     * @param value value to set the  TransUploadedConsentEdocId
     */
    public void setTransUploadedConsentEdocId(Integer value) {
        setAttributeInternal(TRANSUPLOADEDCONSENTEDOCID, value);
    }

    /**
     * Gets the attribute value for the calculated attribute TransOnlineConsentNumber.
     * @return the TransOnlineConsentNumber
     */
    public String getTransOnlineConfirmationNumber() {
        return (String) getAttributeInternal(TRANSONLINECONFIRMATIONNUMBER);
    }

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute TransOnlineConsentNumber.
     * @param value value to set the  TransOnlineConsentNumber
     */
    public void setTransOnlineConfirmationNumber(String value) {
        setAttributeInternal(TRANSONLINECONFIRMATIONNUMBER, value);
    }


    /**
     * Gets the associated <code>RowIterator</code> using master-detail link WcRequestDocumentsVO.
     */
    public RowIterator getWcRequestDocumentsVO() {
        return (RowIterator) getAttributeInternal(WCREQUESTDOCUMENTSVO);
    }


    /**
     * Gets the view accessor <code>RowSet</code> YesNoLov1.
     */
    public RowSet getYesNoLov1() {
        return (RowSet) getAttributeInternal(YESNOLOV1);
    }

    /**
     * Gets the view accessor <code>RowSet</code> StatusLOV1.
     */
    public RowSet getStatusLOV1() {
        return (RowSet) getAttributeInternal(STATUSLOV1);
    }

    /**
     * Gets the view accessor <code>RowSet</code> FndUsers1.
     */
    public RowSet getFndUsers1() {
        return (RowSet) getAttributeInternal(FNDUSERS1);
    }

    /**
     * Gets the view accessor <code>RowSet</code> LovCountriesVO1.
     */
    public RowSet getLovCountriesVO1() {
        return (RowSet) getAttributeInternal(LOVCOUNTRIESVO1);
    }

    /**
     * Gets the view accessor <code>RowSet</code> LovIdTypeVO1.
     */
    public RowSet getLovIdTypeVO1() {
        return (RowSet) getAttributeInternal(LOVIDTYPEVO1);
    }

    /**
     * Gets the view accessor <code>RowSet</code> LovCityNameVO1.
     */
    public RowSet getLovCityNameVO1() {
        return (RowSet) getAttributeInternal(LOVCITYNAMEVO1);
    }

    /**
     * Gets the view accessor <code>RowSet</code> LovIsOfacEntityOnListView1.
     */
    public RowSet getLovIsOfacEntityOnListView1() {
        return (RowSet) getAttributeInternal(LOVISOFACENTITYONLISTVIEW1);
    }

    /**
     * Gets the view accessor <code>RowSet</code> LovYesNoView1.
     */
    public RowSet getLovYesNoView1() {
        return (RowSet) getAttributeInternal(LOVYESNOVIEW1);
    }

    public RMIManualTradeComplianceAppModuleImpl getAm()
    {
        return (RMIManualTradeComplianceAppModuleImpl) this.getApplicationModule();
    }
}

