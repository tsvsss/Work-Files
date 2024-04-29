package com.rmi.tradecompapproval.adfbc.views.readonly;

import com.rmi.tradecompapproval.adfbc.utils.AdfUtils;

import java.math.BigDecimal;
import java.math.BigInteger;

import java.sql.Timestamp;

import javax.faces.application.FacesMessage;

import oracle.jbo.RowSet;
import oracle.jbo.server.ViewRowImpl;
// ---------------------------------------------------------------------
// ---    File generated by Oracle ADF Business Components Design Time.
// ---    Wed Dec 05 11:38:54 IST 2018
// ---    Custom code may be added to this class.
// ---    Warning: Do not modify method signatures of generated methods.
// ---------------------------------------------------------------------
public class OcVerificationOrdersViewRowImpl extends ViewRowImpl {
    /**
     * AttributesEnum: generated enum for identifying attributes and accessors. DO NOT MODIFY.
     */
    public enum AttributesEnum {
        SeafarerName,
        OrderNumber,
        GradeCode,
        CountryName,
        EndorsementNumber,
        EndorsementIssueDate,
        VerificationReqd,
        EndorsementExpirationDate,
        SeafarerId,
        HeaderId,
        GradeId,
        DocumentId,
        EndorsementCountry,
        Verified,
        VerificationEdocId,
        VerificationMethod,
        VerificationUrl,
        VerificationEmail,
        VerificationUsername,
        CreatedBy,
        BirthDate,
        VerificationPassword,
        TransLoginPassword,
        TransCertVerification,
        TransCancelCert,
        CertVerificationStatusLOV1,
        CancelDocVerificationLOV1;
        private static AttributesEnum[] vals = null;
        private static final int firstIndex = 0;

        public int index() {
            return OcVerificationOrdersViewRowImpl.AttributesEnum.firstIndex() + ordinal();
        }

        public static final int firstIndex() {
            return firstIndex;
        }

        public static int count() {
            return OcVerificationOrdersViewRowImpl.AttributesEnum.firstIndex() +
                   OcVerificationOrdersViewRowImpl.AttributesEnum.staticValues().length;
        }

        public static final AttributesEnum[] staticValues() {
            if (vals == null) {
                vals = OcVerificationOrdersViewRowImpl.AttributesEnum.values();
            }
            return vals;
        }
    }


    public static final int SEAFARERNAME = AttributesEnum.SeafarerName.index();
    public static final int ORDERNUMBER = AttributesEnum.OrderNumber.index();
    public static final int GRADECODE = AttributesEnum.GradeCode.index();
    public static final int COUNTRYNAME = AttributesEnum.CountryName.index();
    public static final int ENDORSEMENTNUMBER = AttributesEnum.EndorsementNumber.index();
    public static final int ENDORSEMENTISSUEDATE = AttributesEnum.EndorsementIssueDate.index();
    public static final int VERIFICATIONREQD = AttributesEnum.VerificationReqd.index();
    public static final int ENDORSEMENTEXPIRATIONDATE = AttributesEnum.EndorsementExpirationDate.index();
    public static final int SEAFARERID = AttributesEnum.SeafarerId.index();
    public static final int HEADERID = AttributesEnum.HeaderId.index();
    public static final int GRADEID = AttributesEnum.GradeId.index();
    public static final int DOCUMENTID = AttributesEnum.DocumentId.index();
    public static final int ENDORSEMENTCOUNTRY = AttributesEnum.EndorsementCountry.index();
    public static final int VERIFIED = AttributesEnum.Verified.index();
    public static final int VERIFICATIONEDOCID = AttributesEnum.VerificationEdocId.index();
    public static final int VERIFICATIONMETHOD = AttributesEnum.VerificationMethod.index();
    public static final int VERIFICATIONURL = AttributesEnum.VerificationUrl.index();
    public static final int VERIFICATIONEMAIL = AttributesEnum.VerificationEmail.index();
    public static final int VERIFICATIONUSERNAME = AttributesEnum.VerificationUsername.index();
    public static final int CREATEDBY = AttributesEnum.CreatedBy.index();
    public static final int BIRTHDATE = AttributesEnum.BirthDate.index();
    public static final int VERIFICATIONPASSWORD = AttributesEnum.VerificationPassword.index();
    public static final int TRANSLOGINPASSWORD = AttributesEnum.TransLoginPassword.index();
    public static final int TRANSCERTVERIFICATION = AttributesEnum.TransCertVerification.index();
    public static final int TRANSCANCELCERT = AttributesEnum.TransCancelCert.index();
    public static final int CERTVERIFICATIONSTATUSLOV1 = AttributesEnum.CertVerificationStatusLOV1.index();
    public static final int CANCELDOCVERIFICATIONLOV1 = AttributesEnum.CancelDocVerificationLOV1.index();

    /**
     * This is the default constructor (do not remove).
     */
    public OcVerificationOrdersViewRowImpl() {
    }


    /**
     * Gets the attribute value for the calculated attribute SeafarerName.
     * @return the SeafarerName
     */
    public String getSeafarerName() {
        return (String) getAttributeInternal(SEAFARERNAME);
    }

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute SeafarerName.
     * @param value value to set the  SeafarerName
     */
    public void setSeafarerName(String value) {
        setAttributeInternal(SEAFARERNAME, value);
    }

    /**
     * Gets the attribute value for the calculated attribute OrderNumber.
     * @return the OrderNumber
     */
    public BigDecimal getOrderNumber() {
        return (BigDecimal) getAttributeInternal(ORDERNUMBER);
    }

    /**
     * Gets the attribute value for the calculated attribute GradeCode.
     * @return the GradeCode
     */
    public String getGradeCode() {
        return (String) getAttributeInternal(GRADECODE);
    }

    /**
     * Gets the attribute value for the calculated attribute CountryName.
     * @return the CountryName
     */
    public String getCountryName() {
        return (String) getAttributeInternal(COUNTRYNAME);
    }

    /**
     * Gets the attribute value for the calculated attribute EndorsementNumber.
     * @return the EndorsementNumber
     */
    public String getEndorsementNumber() {
        return (String) getAttributeInternal(ENDORSEMENTNUMBER);
    }

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute EndorsementNumber.
     * @param value value to set the  EndorsementNumber
     */
    public void setEndorsementNumber(String value) {
        setAttributeInternal(ENDORSEMENTNUMBER, value);
    }

    /**
     * Gets the attribute value for the calculated attribute EndorsementIssueDate.
     * @return the EndorsementIssueDate
     */
    public Timestamp getEndorsementIssueDate() {
        return (Timestamp) getAttributeInternal(ENDORSEMENTISSUEDATE);
    }

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute EndorsementIssueDate.
     * @param value value to set the  EndorsementIssueDate
     */
    public void setEndorsementIssueDate(Timestamp value) {
        setAttributeInternal(ENDORSEMENTISSUEDATE, value);
    }

    /**
     * Gets the attribute value for the calculated attribute VerificationReqd.
     * @return the VerificationReqd
     */
    public String getVerificationReqd() {
        return (String) getAttributeInternal(VERIFICATIONREQD);
    }

    /**
     * Gets the attribute value for the calculated attribute EndorsementExpirationDate.
     * @return the EndorsementExpirationDate
     */
    public Timestamp getEndorsementExpirationDate() {
        return (Timestamp) getAttributeInternal(ENDORSEMENTEXPIRATIONDATE);
    }

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute EndorsementExpirationDate.
     * @param value value to set the  EndorsementExpirationDate
     */
    public void setEndorsementExpirationDate(Timestamp value) {
        setAttributeInternal(ENDORSEMENTEXPIRATIONDATE, value);
    }

    /**
     * Gets the attribute value for the calculated attribute SeafarerId.
     * @return the SeafarerId
     */
    public Integer getSeafarerId() {
        return (Integer) getAttributeInternal(SEAFARERID);
    }

    /**
     * Gets the attribute value for the calculated attribute HeaderId.
     * @return the HeaderId
     */
    public BigDecimal getHeaderId() {
        return (BigDecimal) getAttributeInternal(HEADERID);
    }

    /**
     * Gets the attribute value for the calculated attribute GradeId.
     * @return the GradeId
     */
    public Integer getGradeId() {
        return (Integer) getAttributeInternal(GRADEID);
    }

    /**
     * Gets the attribute value for the calculated attribute DocumentId.
     * @return the DocumentId
     */
    public Integer getDocumentId() {
        return (Integer) getAttributeInternal(DOCUMENTID);
    }

    /**
     * Gets the attribute value for the calculated attribute EndorsementCountry.
     * @return the EndorsementCountry
     */
    public String getEndorsementCountry() {
        return (String) getAttributeInternal(ENDORSEMENTCOUNTRY);
    }

    /**
     * Gets the attribute value for the calculated attribute Verified.
     * @return the Verified
     */
    public String getVerified() {
        return (String) getAttributeInternal(VERIFIED);
    }

    /**
     * Gets the attribute value for the calculated attribute VerificationEdocId.
     * @return the VerificationEdocId
     */
    public BigDecimal getVerificationEdocId() {
        return (BigDecimal) getAttributeInternal(VERIFICATIONEDOCID);
    }

    /**
     * Gets the attribute value for the calculated attribute VerificationMethod.
     * @return the VerificationMethod
     */
    public String getVerificationMethod() {
        return (String) getAttributeInternal(VERIFICATIONMETHOD);
    }

    /**
     * Gets the attribute value for the calculated attribute VerificationUrl.
     * @return the VerificationUrl
     */
    public String getVerificationUrl() {
        return (String) getAttributeInternal(VERIFICATIONURL);
    }

    /**
     * Gets the attribute value for the calculated attribute VerificationEmail.
     * @return the VerificationEmail
     */
    public String getVerificationEmail() {
        return (String) getAttributeInternal(VERIFICATIONEMAIL);
    }

    /**
     * Gets the attribute value for the calculated attribute VerificationUsername.
     * @return the VerificationUsername
     */
    public String getVerificationUsername() {
        return (String) getAttributeInternal(VERIFICATIONUSERNAME);
    }

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute VerificationUsername.
     * @param value value to set the  VerificationUsername
     */
    public void setVerificationUsername(String value) {
        setAttributeInternal(VERIFICATIONUSERNAME, value);
    }

    /**
     * Gets the attribute value for the calculated attribute CreatedBy.
     * @return the CreatedBy
     */
    public Integer getCreatedBy() {
        return (Integer) getAttributeInternal(CREATEDBY);
    }

    /**
     * Gets the attribute value for the calculated attribute BirthDate.
     * @return the BirthDate
     */
    public Timestamp getBirthDate() {
        return (Timestamp) getAttributeInternal(BIRTHDATE);
    }

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute BirthDate.
     * @param value value to set the  BirthDate
     */
    public void setBirthDate(Timestamp value) {
        setAttributeInternal(BIRTHDATE, value);
    }

    /**
     * Gets the attribute value for the calculated attribute VerificationPassword.
     * @return the VerificationPassword
     */
    public String getVerificationPassword() {
        return (String) getAttributeInternal(VERIFICATIONPASSWORD);
    }

    /**
     * Gets the attribute value for the calculated attribute TransLoginPassword.
     * @return the TransLoginPassword
     */
    public String getTransLoginPassword() 
    {
        return getVerificationPassword();
    }

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute TransLoginPassword.
     * @param value value to set the  TransLoginPassword
     */
    public void setTransLoginPassword(String value) {
        setAttributeInternal(TRANSLOGINPASSWORD, value);
    }

    /**
     * Gets the attribute value for the calculated attribute TransCertVerification.
     * @return the TransCertVerification
     */
    public String getTransCertVerification() 
    {
        try 
        {
            if (getAttributeInternal(TRANSCERTVERIFICATION) != null)
                return (String) getAttributeInternal(TRANSCERTVERIFICATION);
            else
                return "P";
        } catch (Exception e) {
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching data." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
        return (String) getAttributeInternal(TRANSCERTVERIFICATION);
    }

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute TransCertVerification.
     * @param value value to set the  TransCertVerification
     */
    public void setTransCertVerification(String value) {
        setAttributeInternal(TRANSCERTVERIFICATION, value);
    }


    /**
     * Gets the attribute value for the calculated attribute TransCancelCert.
     * @return the TransCancelCert
     */
    public String getTransCancelCert() 
    {
        try 
        {
            if (getAttributeInternal(TRANSCANCELCERT) != null)
                return (String) getAttributeInternal(TRANSCANCELCERT);
            else
                return "C";
        } catch (Exception e) {
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching data." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
        return (String) getAttributeInternal(TRANSCANCELCERT);
    }

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute TransCancelCert.
     * @param value value to set the  TransCancelCert
     */
    public void setTransCancelCert(String value) {
        setAttributeInternal(TRANSCANCELCERT, value);
    }

    /**
     * Gets the view accessor <code>RowSet</code> CertVerificationStatusLOV1.
     */
    public RowSet getCertVerificationStatusLOV1() {
        return (RowSet) getAttributeInternal(CERTVERIFICATIONSTATUSLOV1);
    }

    /**
     * Gets the view accessor <code>RowSet</code> CancelDocVerificationLOV1.
     */
    public RowSet getCancelDocVerificationLOV1() {
        return (RowSet) getAttributeInternal(CANCELDOCVERIFICATIONLOV1);
    }
}
