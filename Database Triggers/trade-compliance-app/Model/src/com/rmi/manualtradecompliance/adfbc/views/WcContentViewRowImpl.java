package com.rmi.manualtradecompliance.adfbc.views;

import com.rmi.manualtradecompliance.adfbc.entities.WcContentImpl;
import com.rmi.manualtradecompliance.adfbc.entities.common.Xmltype3;

import com.rmi.manualtradecompliance.adfbc.utils.AdfUtils;

import java.math.BigDecimal;

import java.sql.Timestamp;

import javax.faces.application.FacesMessage;

import oracle.jbo.RowSet;
import oracle.jbo.server.ViewRowImpl;
// ---------------------------------------------------------------------
// ---    File generated by Oracle ADF Business Components Design Time.
// ---    Fri Feb 15 13:34:35 IST 2019
// ---    Custom code may be added to this class.
// ---    Warning: Do not modify method signatures of generated methods.
// ---------------------------------------------------------------------
public class WcContentViewRowImpl extends ViewRowImpl {


    public static final int ENTITY_WCCONTENTEO = 0;

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
        WcContentNotes,
        UserClearable,
        WcScreeningRequestId,
        NmName,
        NmDobAge,
        NmSex,
        NmDead,
        NmVisual,
        NmFatherName,
        NmImoNumber,
        NmCnnm,
        MatchstatusOrderBy,
        LOVMatchesStatusVO1;
        static AttributesEnum[] vals = null;
        ;
        private static final int firstIndex = 0;

        public int index() {
            return WcContentViewRowImpl.AttributesEnum.firstIndex() + ordinal();
        }

        public static final int firstIndex() {
            return firstIndex;
        }

        public static int count() {
            return WcContentViewRowImpl.AttributesEnum.firstIndex() +
                   WcContentViewRowImpl.AttributesEnum.staticValues().length;
        }

        public static final AttributesEnum[] staticValues() {
            if (vals == null) {
                vals = WcContentViewRowImpl.AttributesEnum.values();
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
    public static final int WCCONTENTNOTES = AttributesEnum.WcContentNotes.index();
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
    public static final int MATCHSTATUSORDERBY = AttributesEnum.MatchstatusOrderBy.index();
    public static final int LOVMATCHESSTATUSVO1 = AttributesEnum.LOVMatchesStatusVO1.index();

    /**
     * This is the default constructor (do not remove).
     */
    public WcContentViewRowImpl() {
    }

    /**
     * Gets WcContentEO entity object.
     * @return the WcContentEO
     */
    public WcContentImpl getWcContentEO() {
        return (WcContentImpl) getEntity(ENTITY_WCCONTENTEO);
    }

    /**
     * Gets the attribute value for WC_CONTENT_ID using the alias name WcContentId.
     * @return the WC_CONTENT_ID
     */
    public BigDecimal getWcContentId() {
        return (BigDecimal) getAttributeInternal(WCCONTENTID);
    }

    /**
     * Sets <code>value</code> as attribute value for WC_CONTENT_ID using the alias name WcContentId.
     * @param value value to set the WC_CONTENT_ID
     */
    public void setWcContentId(BigDecimal value) {
        setAttributeInternal(WCCONTENTID, value);
    }

    /**
     * Gets the attribute value for WC_MATCHES_ID using the alias name WcMatchesId.
     * @return the WC_MATCHES_ID
     */
    public BigDecimal getWcMatchesId() {
        return (BigDecimal) getAttributeInternal(WCMATCHESID);
    }

    /**
     * Sets <code>value</code> as attribute value for WC_MATCHES_ID using the alias name WcMatchesId.
     * @param value value to set the WC_MATCHES_ID
     */
    public void setWcMatchesId(BigDecimal value) {
        setAttributeInternal(WCMATCHESID, value);
    }

    /**
     * Gets the attribute value for XML_RESPONSE using the alias name XmlResponse.
     * @return the XML_RESPONSE
     */
    public Xmltype3 getXmlResponse() {
        return (Xmltype3) getAttributeInternal(XMLRESPONSE);
    }

    /**
     * Sets <code>value</code> as attribute value for XML_RESPONSE using the alias name XmlResponse.
     * @param value value to set the XML_RESPONSE
     */
    public void setXmlResponse(Xmltype3 value) {
        setAttributeInternal(XMLRESPONSE, value);
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
     * Gets the attribute value for MATCHENTITYIDENTIFIER using the alias name Matchentityidentifier.
     * @return the MATCHENTITYIDENTIFIER
     */
    public String getMatchentityidentifier() {
        return (String) getAttributeInternal(MATCHENTITYIDENTIFIER);
    }

    /**
     * Sets <code>value</code> as attribute value for MATCHENTITYIDENTIFIER using the alias name Matchentityidentifier.
     * @param value value to set the MATCHENTITYIDENTIFIER
     */
    public void setMatchentityidentifier(String value) {
        setAttributeInternal(MATCHENTITYIDENTIFIER, value);
    }

    /**
     * Gets the attribute value for MATCHIDENTIFIER using the alias name Matchidentifier.
     * @return the MATCHIDENTIFIER
     */
    public String getMatchidentifier() {
        return (String) getAttributeInternal(MATCHIDENTIFIER);
    }

    /**
     * Sets <code>value</code> as attribute value for MATCHIDENTIFIER using the alias name Matchidentifier.
     * @param value value to set the MATCHIDENTIFIER
     */
    public void setMatchidentifier(String value) {
        setAttributeInternal(MATCHIDENTIFIER, value);
    }

    /**
     * Gets the attribute value for MATCHSCORE using the alias name Matchscore.
     * @return the MATCHSCORE
     */
    public BigDecimal getMatchscore() {
        return (BigDecimal) getAttributeInternal(MATCHSCORE);
    }

    /**
     * Sets <code>value</code> as attribute value for MATCHSCORE using the alias name Matchscore.
     * @param value value to set the MATCHSCORE
     */
    public void setMatchscore(BigDecimal value) {
        setAttributeInternal(MATCHSCORE, value);
    }

    /**
     * Gets the attribute value for MATCHSTATUS using the alias name Matchstatus.
     * @return the MATCHSTATUS
     */
    public String getMatchstatus() 
    {
        try 
        {
            if (getAttributeInternal(MATCHSTATUS) != null) {
                return (String) getAttributeInternal(MATCHSTATUS);
            } else
                return "INITIAL";
        } catch (Exception e) {
            e.printStackTrace();
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching data." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
        return (String) getAttributeInternal(MATCHSTATUS);
    }

    /**
     * Sets <code>value</code> as attribute value for MATCHSTATUS using the alias name Matchstatus.
     * @param value value to set the MATCHSTATUS
     */
    public void setMatchstatus(String value) 
    {
        setAttributeInternal(MATCHSTATUS, value);
    }

    /**
     * Gets the attribute value for MATCHTYPE using the alias name Matchtype.
     * @return the MATCHTYPE
     */
    public String getMatchtype() {
        return (String) getAttributeInternal(MATCHTYPE);
    }

    /**
     * Sets <code>value</code> as attribute value for MATCHTYPE using the alias name Matchtype.
     * @param value value to set the MATCHTYPE
     */
    public void setMatchtype(String value) {
        setAttributeInternal(MATCHTYPE, value);
    }

    /**
     * Gets the attribute value for SURNAME using the alias name Surname.
     * @return the SURNAME
     */
    public String getSurname() {
        return (String) getAttributeInternal(SURNAME);
    }

    /**
     * Sets <code>value</code> as attribute value for SURNAME using the alias name Surname.
     * @param value value to set the SURNAME
     */
    public void setSurname(String value) {
        setAttributeInternal(SURNAME, value);
    }

    /**
     * Gets the attribute value for GIVEN_NAME using the alias name GivenName.
     * @return the GIVEN_NAME
     */
    public String getGivenName() {
        return (String) getAttributeInternal(GIVENNAME);
    }

    /**
     * Sets <code>value</code> as attribute value for GIVEN_NAME using the alias name GivenName.
     * @param value value to set the GIVEN_NAME
     */
    public void setGivenName(String value) {
        setAttributeInternal(GIVENNAME, value);
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
     * Gets the attribute value for DATE_OF_DEATH using the alias name DateOfDeath.
     * @return the DATE_OF_DEATH
     */
    public Timestamp getDateOfDeath() {
        return (Timestamp) getAttributeInternal(DATEOFDEATH);
    }

    /**
     * Sets <code>value</code> as attribute value for DATE_OF_DEATH using the alias name DateOfDeath.
     * @param value value to set the DATE_OF_DEATH
     */
    public void setDateOfDeath(Timestamp value) {
        setAttributeInternal(DATEOFDEATH, value);
    }

    /**
     * Gets the attribute value for SEX using the alias name Sex.
     * @return the SEX
     */
    public String getSex() {
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
    public void setStatus(String value) {
        setAttributeInternal(STATUS, value);
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
     * Gets the attribute value for NOTES using the alias name Notes.
     * @return the NOTES
     */
    public String getWcContentNotes() {
        return (String) getAttributeInternal(WCCONTENTNOTES);
    }

    /**
     * Sets <code>value</code> as attribute value for NOTES using the alias name Notes.
     * @param value value to set the NOTES
     */
    public void setWcContentNotes(String value) 
    {
        setAttributeInternal(WCCONTENTNOTES, value);
    }

    /**
     * Gets the attribute value for USER_CLEARABLE using the alias name UserClearable.
     * @return the USER_CLEARABLE
     */
    public String getUserClearable() {
        return (String) getAttributeInternal(USERCLEARABLE);
    }

    /**
     * Sets <code>value</code> as attribute value for USER_CLEARABLE using the alias name UserClearable.
     * @param value value to set the USER_CLEARABLE
     */
    public void setUserClearable(String value) {
        setAttributeInternal(USERCLEARABLE, value);
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
     * Gets the attribute value for NM_NAME using the alias name NmName.
     * @return the NM_NAME
     */
    public String getNmName() {
        return (String) getAttributeInternal(NMNAME);
    }

    /**
     * Sets <code>value</code> as attribute value for NM_NAME using the alias name NmName.
     * @param value value to set the NM_NAME
     */
    public void setNmName(String value) 
    {
        try 
        {
            if (value != null && (value.equalsIgnoreCase("y") || value.equalsIgnoreCase("true"))) {
                String note =
                    (getAttributeInternal(WCCONTENTNOTES) != null ? getAttributeInternal(WCCONTENTNOTES).toString() :
                     "");

                String wcNote = note + ", Name not a match";
                setWcContentNotes(wcNote);
            }
        } catch (Exception e) {
            e.printStackTrace();
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating data." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
        setAttributeInternal(NMNAME, value);
    }

    /**
     * Gets the attribute value for NM_DOB_AGE using the alias name NmDobAge.
     * @return the NM_DOB_AGE
     */
    public String getNmDobAge() {
        return (String) getAttributeInternal(NMDOBAGE);
    }

    /**
     * Sets <code>value</code> as attribute value for NM_DOB_AGE using the alias name NmDobAge.
     * @param value value to set the NM_DOB_AGE
     */
    public void setNmDobAge(String value) 
    {        
        try 
        {
            if (value != null && (value.equalsIgnoreCase("y") || value.equalsIgnoreCase("true"))) {
                String note =
                    (getAttributeInternal(WCCONTENTNOTES) != null ? getAttributeInternal(WCCONTENTNOTES).toString() :
                     "");

                String wcNote = note + ", DOB/Age not a match";
                setWcContentNotes(wcNote);
            }
        } catch (Exception e) {
            e.printStackTrace();
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating data." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
        setAttributeInternal(NMDOBAGE, value);
    }

    /**
     * Gets the attribute value for NM_SEX using the alias name NmSex.
     * @return the NM_SEX
     */
    public String getNmSex() {
        return (String) getAttributeInternal(NMSEX);
    }

    /**
     * Sets <code>value</code> as attribute value for NM_SEX using the alias name NmSex.
     * @param value value to set the NM_SEX
     */
    public void setNmSex(String value) 
    {     
        try 
        {
            if (value != null && (value.equalsIgnoreCase("y") || value.equalsIgnoreCase("true"))) {
                String note =
                    (getAttributeInternal(WCCONTENTNOTES) != null ? getAttributeInternal(WCCONTENTNOTES).toString() :
                     "");

                String wcNote = note + ", Sex not a match";
                setWcContentNotes(wcNote);
            }
        } catch (Exception e) {
            e.printStackTrace();
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating data." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
        setAttributeInternal(NMSEX, value);
    }

    /**
     * Gets the attribute value for NM_DEAD using the alias name NmDead.
     * @return the NM_DEAD
     */
    public String getNmDead() {
        return (String) getAttributeInternal(NMDEAD);
    }

    /**
     * Sets <code>value</code> as attribute value for NM_DEAD using the alias name NmDead.
     * @param value value to set the NM_DEAD
     */
    public void setNmDead(String value) 
    {       
        try 
        {
            if (value != null && (value.equalsIgnoreCase("y") || value.equalsIgnoreCase("true"))) {
                String note =
                    (getAttributeInternal(WCCONTENTNOTES) != null ? getAttributeInternal(WCCONTENTNOTES).toString() :
                     "");

                String wcNote = note + ", Deceased not a match";
                setWcContentNotes(wcNote);
            }
        } catch (Exception e) {
            e.printStackTrace();
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating data." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
        setAttributeInternal(NMDEAD, value);
    }

    /**
     * Gets the attribute value for NM_VISUAL using the alias name NmVisual.
     * @return the NM_VISUAL
     */
    public String getNmVisual() {
        return (String) getAttributeInternal(NMVISUAL);
    }

    /**
     * Sets <code>value</code> as attribute value for NM_VISUAL using the alias name NmVisual.
     * @param value value to set the NM_VISUAL
     */
    public void setNmVisual(String value) 
    {    
        try 
        {
            if (value != null && (value.equalsIgnoreCase("y") || value.equalsIgnoreCase("true"))) {
                String note =
                    (getAttributeInternal(WCCONTENTNOTES) != null ? getAttributeInternal(WCCONTENTNOTES).toString() :
                     "");

                String wcNote = note + ", Visual ID not a match";
                setWcContentNotes(wcNote);
            }
        } catch (Exception e) {
            e.printStackTrace();
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating data." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
        setAttributeInternal(NMVISUAL, value);
    }

    /**
     * Gets the attribute value for NM_FATHER_NAME using the alias name NmFatherName.
     * @return the NM_FATHER_NAME
     */
    public String getNmFatherName() {
        return (String) getAttributeInternal(NMFATHERNAME);
    }

    /**
     * Sets <code>value</code> as attribute value for NM_FATHER_NAME using the alias name NmFatherName.
     * @param value value to set the NM_FATHER_NAME
     */
    public void setNmFatherName(String value) 
    {   
        try 
        {
            if (value != null && (value.equalsIgnoreCase("y") || value.equalsIgnoreCase("true"))) {
                String note =
                    (getAttributeInternal(WCCONTENTNOTES) != null ? getAttributeInternal(WCCONTENTNOTES).toString() :
                     "");

                String wcNote = note + ", Father's Name not a match";
                setWcContentNotes(wcNote);
            }
        } catch (Exception e) {
            e.printStackTrace();
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating data." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
        setAttributeInternal(NMFATHERNAME, value);
    }

    /**
     * Gets the attribute value for NM_IMO_NUMBER using the alias name NmImoNumber.
     * @return the NM_IMO_NUMBER
     */
    public String getNmImoNumber() {
        return (String) getAttributeInternal(NMIMONUMBER);
    }

    /**
     * Sets <code>value</code> as attribute value for NM_IMO_NUMBER using the alias name NmImoNumber.
     * @param value value to set the NM_IMO_NUMBER
     */
    public void setNmImoNumber(String value) 
    {
        try 
        {
            if (value != null && (value.equalsIgnoreCase("y") || value.equalsIgnoreCase("true"))) {
                String note =
                    (getAttributeInternal(WCCONTENTNOTES) != null ? getAttributeInternal(WCCONTENTNOTES).toString() :
                     "");

                String wcNote = note + ", Imo Number not a match";
                setWcContentNotes(wcNote);
            }
        } catch (Exception e) {
            e.printStackTrace();
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating data." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
        setAttributeInternal(NMIMONUMBER, value);
    }

    /**
     * Gets the attribute value for NM_CNNM using the alias name NmCnnm.
     * @return the NM_CNNM
     */
    public String getNmCnnm() {
        return (String) getAttributeInternal(NMCNNM);
    }

    /**
     * Sets <code>value</code> as attribute value for NM_CNNM using the alias name NmCnnm.
     * @param value value to set the NM_CNNM
     */
    public void setNmCnnm(String value) 
    {
        try 
        {
            if (value != null && (value.equalsIgnoreCase("y") || value.equalsIgnoreCase("true"))) {
                String note =
                    (getAttributeInternal(WCCONTENTNOTES) != null ? getAttributeInternal(WCCONTENTNOTES).toString() :
                     "");

                String wcNote = note + ", Chineese Name not a match";
                setWcContentNotes(wcNote);
            }
        } catch (Exception e) {
            e.printStackTrace();
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating data." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
        setAttributeInternal(NMCNNM, value);
    }

    /**
     * Gets the attribute value for MATCHSTATUSORDERBY using the alias name MatchstatusOrderBy.
     * @return the NM_CNNM
     */
    public String getMatchstatusOrderBy() {
        return (String) getAttributeInternal(MATCHSTATUSORDERBY);
    }

    /**
     * Gets the view accessor <code>RowSet</code> LOVMatchesStatusVO1.
     */
    public RowSet getLOVMatchesStatusVO1() {
        return (RowSet) getAttributeInternal(LOVMATCHESSTATUSVO1);
    }
}

