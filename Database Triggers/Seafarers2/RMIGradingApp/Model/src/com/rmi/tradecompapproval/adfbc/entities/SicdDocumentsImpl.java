package com.rmi.tradecompapproval.adfbc.entities;

import com.rmi.tradecompapproval.adfbc.extensions.CustomEntity;
import com.rmi.tradecompapproval.adfbc.services.RMITradeCompApprovalAppModuleImpl;

import java.math.BigDecimal;

import java.sql.Timestamp;

import oracle.adf.share.ADFContext;

import oracle.jbo.AttributeList;
import oracle.jbo.Key;
import oracle.jbo.domain.DBSequence;
import oracle.jbo.server.EntityDefImpl;
import oracle.jbo.server.EntityImpl;
import oracle.jbo.server.TransactionEvent;

import org.apache.myfaces.trinidad.context.RequestContext;
// ---------------------------------------------------------------------
// ---    File generated by Oracle ADF Business Components Design Time.
// ---    Wed Nov 28 12:08:53 IST 2018
// ---    Custom code may be added to this class.
// ---    Warning: Do not modify method signatures of generated methods.
// ---------------------------------------------------------------------
public class SicdDocumentsImpl extends CustomEntity {
    /**
     * AttributesEnum: generated enum for identifying attributes and accessors. DO NOT MODIFY.
     */
    public enum AttributesEnum {
        DocumentId,
        SeafarerId,
        SignatureId,
        HeaderId,
        LineId,
        GradeId,
        DocumentPreviousId,
        DocumentBookId,
        DocumentType,
        IssueType,
        IssueDate,
        ExpirationDate,
        Status,
        CertificateNumber,
        BookNumber,
        BookType,
        SqcNumber,
        EndorsementNumber,
        EndorsementCountry,
        EndorsementIssueDate,
        EndorsementExpirationDate,
        ExamNumber,
        ExamYear,
        CreatedBy,
        CreationDate,
        LastUpdatedBy,
        LastUpdateDate,
        LastUpdateLogin,
        AttributeCategory,
        Attribute1,
        Attribute2,
        Attribute3,
        Attribute4,
        Attribute5,
        Attribute6,
        Attribute7,
        Attribute8,
        Attribute9,
        Attribute10,
        Attribute11,
        Attribute12,
        Attribute13,
        Attribute14,
        Attribute15,
        CertificateType,
        VerifiedBy,
        VerifiedDate,
        VerificationEdocId,
        VerificationRequestDate,
        VerificationBy,
        Verified,
        DataVerifiedDate,
        DataVerifiedBy,
        EsdiId,
        GradingStatus;
        private static AttributesEnum[] vals = null;
        private static final int firstIndex = 0;

        public int index() {
            return SicdDocumentsImpl.AttributesEnum.firstIndex() + ordinal();
        }

        public static final int firstIndex() {
            return firstIndex;
        }

        public static int count() {
            return SicdDocumentsImpl.AttributesEnum.firstIndex() +
                   SicdDocumentsImpl.AttributesEnum.staticValues().length;
        }

        public static final AttributesEnum[] staticValues() {
            if (vals == null) {
                vals = SicdDocumentsImpl.AttributesEnum.values();
            }
            return vals;
        }
    }


    public static final int DOCUMENTID = AttributesEnum.DocumentId.index();
    public static final int SEAFARERID = AttributesEnum.SeafarerId.index();
    public static final int SIGNATUREID = AttributesEnum.SignatureId.index();
    public static final int HEADERID = AttributesEnum.HeaderId.index();
    public static final int LINEID = AttributesEnum.LineId.index();
    public static final int GRADEID = AttributesEnum.GradeId.index();
    public static final int DOCUMENTPREVIOUSID = AttributesEnum.DocumentPreviousId.index();
    public static final int DOCUMENTBOOKID = AttributesEnum.DocumentBookId.index();
    public static final int DOCUMENTTYPE = AttributesEnum.DocumentType.index();
    public static final int ISSUETYPE = AttributesEnum.IssueType.index();
    public static final int ISSUEDATE = AttributesEnum.IssueDate.index();
    public static final int EXPIRATIONDATE = AttributesEnum.ExpirationDate.index();
    public static final int STATUS = AttributesEnum.Status.index();
    public static final int CERTIFICATENUMBER = AttributesEnum.CertificateNumber.index();
    public static final int BOOKNUMBER = AttributesEnum.BookNumber.index();
    public static final int BOOKTYPE = AttributesEnum.BookType.index();
    public static final int SQCNUMBER = AttributesEnum.SqcNumber.index();
    public static final int ENDORSEMENTNUMBER = AttributesEnum.EndorsementNumber.index();
    public static final int ENDORSEMENTCOUNTRY = AttributesEnum.EndorsementCountry.index();
    public static final int ENDORSEMENTISSUEDATE = AttributesEnum.EndorsementIssueDate.index();
    public static final int ENDORSEMENTEXPIRATIONDATE = AttributesEnum.EndorsementExpirationDate.index();
    public static final int EXAMNUMBER = AttributesEnum.ExamNumber.index();
    public static final int EXAMYEAR = AttributesEnum.ExamYear.index();
    public static final int CREATEDBY = AttributesEnum.CreatedBy.index();
    public static final int CREATIONDATE = AttributesEnum.CreationDate.index();
    public static final int LASTUPDATEDBY = AttributesEnum.LastUpdatedBy.index();
    public static final int LASTUPDATEDATE = AttributesEnum.LastUpdateDate.index();
    public static final int LASTUPDATELOGIN = AttributesEnum.LastUpdateLogin.index();
    public static final int ATTRIBUTECATEGORY = AttributesEnum.AttributeCategory.index();
    public static final int ATTRIBUTE1 = AttributesEnum.Attribute1.index();
    public static final int ATTRIBUTE2 = AttributesEnum.Attribute2.index();
    public static final int ATTRIBUTE3 = AttributesEnum.Attribute3.index();
    public static final int ATTRIBUTE4 = AttributesEnum.Attribute4.index();
    public static final int ATTRIBUTE5 = AttributesEnum.Attribute5.index();
    public static final int ATTRIBUTE6 = AttributesEnum.Attribute6.index();
    public static final int ATTRIBUTE7 = AttributesEnum.Attribute7.index();
    public static final int ATTRIBUTE8 = AttributesEnum.Attribute8.index();
    public static final int ATTRIBUTE9 = AttributesEnum.Attribute9.index();
    public static final int ATTRIBUTE10 = AttributesEnum.Attribute10.index();
    public static final int ATTRIBUTE11 = AttributesEnum.Attribute11.index();
    public static final int ATTRIBUTE12 = AttributesEnum.Attribute12.index();
    public static final int ATTRIBUTE13 = AttributesEnum.Attribute13.index();
    public static final int ATTRIBUTE14 = AttributesEnum.Attribute14.index();
    public static final int ATTRIBUTE15 = AttributesEnum.Attribute15.index();
    public static final int CERTIFICATETYPE = AttributesEnum.CertificateType.index();
    public static final int VERIFIEDBY = AttributesEnum.VerifiedBy.index();
    public static final int VERIFIEDDATE = AttributesEnum.VerifiedDate.index();
    public static final int VERIFICATIONEDOCID = AttributesEnum.VerificationEdocId.index();
    public static final int VERIFICATIONREQUESTDATE = AttributesEnum.VerificationRequestDate.index();
    public static final int VERIFICATIONBY = AttributesEnum.VerificationBy.index();
    public static final int VERIFIED = AttributesEnum.Verified.index();
    public static final int DATAVERIFIEDDATE = AttributesEnum.DataVerifiedDate.index();
    public static final int DATAVERIFIEDBY = AttributesEnum.DataVerifiedBy.index();
    public static final int ESDIID = AttributesEnum.EsdiId.index();
    public static final int GRADINGSTATUS = AttributesEnum.GradingStatus.index();

    /**
     * This is the default constructor (do not remove).
     */
    public SicdDocumentsImpl() {
    }

    /**
     * @return the definition object for this instance class.
     */
    public static synchronized EntityDefImpl getDefinitionObject() {
        return EntityDefImpl.findDefObject("com.rmi.tradecompapproval.adfbc.entities.SicdDocuments");
    }


    /**
     * Gets the attribute value for DocumentId, using the alias name DocumentId.
     * @return the value of DocumentId
     */
    public BigDecimal getDocumentId() {
        return (BigDecimal) getAttributeInternal(DOCUMENTID);
    }

    /**
     * Sets <code>value</code> as the attribute value for DocumentId.
     * @param value value to set the DocumentId
     */
    public void setDocumentId(BigDecimal value) {
        setAttributeInternal(DOCUMENTID, value);
    }

    /**
     * Gets the attribute value for SeafarerId, using the alias name SeafarerId.
     * @return the value of SeafarerId
     */
    public BigDecimal getSeafarerId() {
        return (BigDecimal) getAttributeInternal(SEAFARERID);
    }

    /**
     * Sets <code>value</code> as the attribute value for SeafarerId.
     * @param value value to set the SeafarerId
     */
    public void setSeafarerId(BigDecimal value) {
        setAttributeInternal(SEAFARERID, value);
    }

    /**
     * Gets the attribute value for SignatureId, using the alias name SignatureId.
     * @return the value of SignatureId
     */
    public BigDecimal getSignatureId() {
        return (BigDecimal) getAttributeInternal(SIGNATUREID);
    }

    /**
     * Sets <code>value</code> as the attribute value for SignatureId.
     * @param value value to set the SignatureId
     */
    public void setSignatureId(BigDecimal value) {
        setAttributeInternal(SIGNATUREID, value);
    }

    /**
     * Gets the attribute value for HeaderId, using the alias name HeaderId.
     * @return the value of HeaderId
     */
    public BigDecimal getHeaderId() {
        return (BigDecimal) getAttributeInternal(HEADERID);
    }

    /**
     * Sets <code>value</code> as the attribute value for HeaderId.
     * @param value value to set the HeaderId
     */
    public void setHeaderId(BigDecimal value) {
        setAttributeInternal(HEADERID, value);
    }

    /**
     * Gets the attribute value for LineId, using the alias name LineId.
     * @return the value of LineId
     */
    public BigDecimal getLineId() {
        return (BigDecimal) getAttributeInternal(LINEID);
    }

    /**
     * Sets <code>value</code> as the attribute value for LineId.
     * @param value value to set the LineId
     */
    public void setLineId(BigDecimal value) {
        setAttributeInternal(LINEID, value);
    }

    /**
     * Gets the attribute value for GradeId, using the alias name GradeId.
     * @return the value of GradeId
     */
    public Integer getGradeId() {
        return (Integer) getAttributeInternal(GRADEID);
    }

    /**
     * Sets <code>value</code> as the attribute value for GradeId.
     * @param value value to set the GradeId
     */
    public void setGradeId(Integer value) {
        setAttributeInternal(GRADEID, value);
    }

    /**
     * Gets the attribute value for DocumentPreviousId, using the alias name DocumentPreviousId.
     * @return the value of DocumentPreviousId
     */
    public BigDecimal getDocumentPreviousId() {
        return (BigDecimal) getAttributeInternal(DOCUMENTPREVIOUSID);
    }

    /**
     * Sets <code>value</code> as the attribute value for DocumentPreviousId.
     * @param value value to set the DocumentPreviousId
     */
    public void setDocumentPreviousId(BigDecimal value) {
        setAttributeInternal(DOCUMENTPREVIOUSID, value);
    }

    /**
     * Gets the attribute value for DocumentBookId, using the alias name DocumentBookId.
     * @return the value of DocumentBookId
     */
    public BigDecimal getDocumentBookId() {
        return (BigDecimal) getAttributeInternal(DOCUMENTBOOKID);
    }

    /**
     * Sets <code>value</code> as the attribute value for DocumentBookId.
     * @param value value to set the DocumentBookId
     */
    public void setDocumentBookId(BigDecimal value) {
        setAttributeInternal(DOCUMENTBOOKID, value);
    }

    /**
     * Gets the attribute value for DocumentType, using the alias name DocumentType.
     * @return the value of DocumentType
     */
    public String getDocumentType() {
        return (String) getAttributeInternal(DOCUMENTTYPE);
    }

    /**
     * Sets <code>value</code> as the attribute value for DocumentType.
     * @param value value to set the DocumentType
     */
    public void setDocumentType(String value) {
        setAttributeInternal(DOCUMENTTYPE, value);
    }

    /**
     * Gets the attribute value for IssueType, using the alias name IssueType.
     * @return the value of IssueType
     */
    public String getIssueType() {
        return (String) getAttributeInternal(ISSUETYPE);
    }

    /**
     * Sets <code>value</code> as the attribute value for IssueType.
     * @param value value to set the IssueType
     */
    public void setIssueType(String value) {
        setAttributeInternal(ISSUETYPE, value);
    }

    /**
     * Gets the attribute value for IssueDate, using the alias name IssueDate.
     * @return the value of IssueDate
     */
    public Timestamp getIssueDate() {
        return (Timestamp) getAttributeInternal(ISSUEDATE);
    }

    /**
     * Sets <code>value</code> as the attribute value for IssueDate.
     * @param value value to set the IssueDate
     */
    public void setIssueDate(Timestamp value) {
        setAttributeInternal(ISSUEDATE, value);
    }

    /**
     * Gets the attribute value for ExpirationDate, using the alias name ExpirationDate.
     * @return the value of ExpirationDate
     */
    public Timestamp getExpirationDate() {
        return (Timestamp) getAttributeInternal(EXPIRATIONDATE);
    }

    /**
     * Sets <code>value</code> as the attribute value for ExpirationDate.
     * @param value value to set the ExpirationDate
     */
    public void setExpirationDate(Timestamp value) {
        setAttributeInternal(EXPIRATIONDATE, value);
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
     * Gets the attribute value for CertificateNumber, using the alias name CertificateNumber.
     * @return the value of CertificateNumber
     */
    public BigDecimal getCertificateNumber() {
        return (BigDecimal) getAttributeInternal(CERTIFICATENUMBER);
    }

    /**
     * Sets <code>value</code> as the attribute value for CertificateNumber.
     * @param value value to set the CertificateNumber
     */
    public void setCertificateNumber(BigDecimal value) {
        setAttributeInternal(CERTIFICATENUMBER, value);
    }

    /**
     * Gets the attribute value for BookNumber, using the alias name BookNumber.
     * @return the value of BookNumber
     */
    public BigDecimal getBookNumber() {
        return (BigDecimal) getAttributeInternal(BOOKNUMBER);
    }

    /**
     * Sets <code>value</code> as the attribute value for BookNumber.
     * @param value value to set the BookNumber
     */
    public void setBookNumber(BigDecimal value) {
        setAttributeInternal(BOOKNUMBER, value);
    }

    /**
     * Gets the attribute value for BookType, using the alias name BookType.
     * @return the value of BookType
     */
    public String getBookType() {
        return (String) getAttributeInternal(BOOKTYPE);
    }

    /**
     * Sets <code>value</code> as the attribute value for BookType.
     * @param value value to set the BookType
     */
    public void setBookType(String value) {
        setAttributeInternal(BOOKTYPE, value);
    }

    /**
     * Gets the attribute value for SqcNumber, using the alias name SqcNumber.
     * @return the value of SqcNumber
     */
    public BigDecimal getSqcNumber() {
        return (BigDecimal) getAttributeInternal(SQCNUMBER);
    }

    /**
     * Sets <code>value</code> as the attribute value for SqcNumber.
     * @param value value to set the SqcNumber
     */
    public void setSqcNumber(BigDecimal value) {
        setAttributeInternal(SQCNUMBER, value);
    }

    /**
     * Gets the attribute value for EndorsementNumber, using the alias name EndorsementNumber.
     * @return the value of EndorsementNumber
     */
    public String getEndorsementNumber() {
        return (String) getAttributeInternal(ENDORSEMENTNUMBER);
    }

    /**
     * Sets <code>value</code> as the attribute value for EndorsementNumber.
     * @param value value to set the EndorsementNumber
     */
    public void setEndorsementNumber(String value) {
        setAttributeInternal(ENDORSEMENTNUMBER, value);
    }

    /**
     * Gets the attribute value for EndorsementCountry, using the alias name EndorsementCountry.
     * @return the value of EndorsementCountry
     */
    public String getEndorsementCountry() {
        return (String) getAttributeInternal(ENDORSEMENTCOUNTRY);
    }

    /**
     * Sets <code>value</code> as the attribute value for EndorsementCountry.
     * @param value value to set the EndorsementCountry
     */
    public void setEndorsementCountry(String value) {
        setAttributeInternal(ENDORSEMENTCOUNTRY, value);
    }

    /**
     * Gets the attribute value for EndorsementIssueDate, using the alias name EndorsementIssueDate.
     * @return the value of EndorsementIssueDate
     */
    public Timestamp getEndorsementIssueDate() {
        return (Timestamp) getAttributeInternal(ENDORSEMENTISSUEDATE);
    }

    /**
     * Sets <code>value</code> as the attribute value for EndorsementIssueDate.
     * @param value value to set the EndorsementIssueDate
     */
    public void setEndorsementIssueDate(Timestamp value) {
        setAttributeInternal(ENDORSEMENTISSUEDATE, value);
    }

    /**
     * Gets the attribute value for EndorsementExpirationDate, using the alias name EndorsementExpirationDate.
     * @return the value of EndorsementExpirationDate
     */
    public Timestamp getEndorsementExpirationDate() {
        return (Timestamp) getAttributeInternal(ENDORSEMENTEXPIRATIONDATE);
    }

    /**
     * Sets <code>value</code> as the attribute value for EndorsementExpirationDate.
     * @param value value to set the EndorsementExpirationDate
     */
    public void setEndorsementExpirationDate(Timestamp value) {
        setAttributeInternal(ENDORSEMENTEXPIRATIONDATE, value);
    }

    /**
     * Gets the attribute value for ExamNumber, using the alias name ExamNumber.
     * @return the value of ExamNumber
     */
    public String getExamNumber() {
        return (String) getAttributeInternal(EXAMNUMBER);
    }

    /**
     * Sets <code>value</code> as the attribute value for ExamNumber.
     * @param value value to set the ExamNumber
     */
    public void setExamNumber(String value) {
        setAttributeInternal(EXAMNUMBER, value);
    }

    /**
     * Gets the attribute value for ExamYear, using the alias name ExamYear.
     * @return the value of ExamYear
     */
    public BigDecimal getExamYear() {
        return (BigDecimal) getAttributeInternal(EXAMYEAR);
    }

    /**
     * Sets <code>value</code> as the attribute value for ExamYear.
     * @param value value to set the ExamYear
     */
    public void setExamYear(BigDecimal value) {
        setAttributeInternal(EXAMYEAR, value);
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
    public Integer getLastUpdatedBy() {
        return (Integer) getAttributeInternal(LASTUPDATEDBY);
    }

    /**
     * Sets <code>value</code> as the attribute value for LastUpdatedBy.
     * @param value value to set the LastUpdatedBy
     */
    public void setLastUpdatedBy(Integer value) {
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
    public Integer getLastUpdateLogin() {
        return (Integer) getAttributeInternal(LASTUPDATELOGIN);
    }

    /**
     * Sets <code>value</code> as the attribute value for LastUpdateLogin.
     * @param value value to set the LastUpdateLogin
     */
    public void setLastUpdateLogin(Integer value) {
        setAttributeInternal(LASTUPDATELOGIN, value);
    }

    /**
     * Gets the attribute value for AttributeCategory, using the alias name AttributeCategory.
     * @return the value of AttributeCategory
     */
    public String getAttributeCategory() {
        return (String) getAttributeInternal(ATTRIBUTECATEGORY);
    }

    /**
     * Sets <code>value</code> as the attribute value for AttributeCategory.
     * @param value value to set the AttributeCategory
     */
    public void setAttributeCategory(String value) {
        setAttributeInternal(ATTRIBUTECATEGORY, value);
    }

    /**
     * Gets the attribute value for Attribute1, using the alias name Attribute1.
     * @return the value of Attribute1
     */
    public String getAttribute1() {
        return (String) getAttributeInternal(ATTRIBUTE1);
    }

    /**
     * Sets <code>value</code> as the attribute value for Attribute1.
     * @param value value to set the Attribute1
     */
    public void setAttribute1(String value) {
        setAttributeInternal(ATTRIBUTE1, value);
    }

    /**
     * Gets the attribute value for Attribute2, using the alias name Attribute2.
     * @return the value of Attribute2
     */
    public String getAttribute2() {
        return (String) getAttributeInternal(ATTRIBUTE2);
    }

    /**
     * Sets <code>value</code> as the attribute value for Attribute2.
     * @param value value to set the Attribute2
     */
    public void setAttribute2(String value) {
        setAttributeInternal(ATTRIBUTE2, value);
    }

    /**
     * Gets the attribute value for Attribute3, using the alias name Attribute3.
     * @return the value of Attribute3
     */
    public String getAttribute3() {
        return (String) getAttributeInternal(ATTRIBUTE3);
    }

    /**
     * Sets <code>value</code> as the attribute value for Attribute3.
     * @param value value to set the Attribute3
     */
    public void setAttribute3(String value) {
        setAttributeInternal(ATTRIBUTE3, value);
    }

    /**
     * Gets the attribute value for Attribute4, using the alias name Attribute4.
     * @return the value of Attribute4
     */
    public String getAttribute4() {
        return (String) getAttributeInternal(ATTRIBUTE4);
    }

    /**
     * Sets <code>value</code> as the attribute value for Attribute4.
     * @param value value to set the Attribute4
     */
    public void setAttribute4(String value) {
        setAttributeInternal(ATTRIBUTE4, value);
    }

    /**
     * Gets the attribute value for Attribute5, using the alias name Attribute5.
     * @return the value of Attribute5
     */
    public String getAttribute5() {
        return (String) getAttributeInternal(ATTRIBUTE5);
    }

    /**
     * Sets <code>value</code> as the attribute value for Attribute5.
     * @param value value to set the Attribute5
     */
    public void setAttribute5(String value) {
        setAttributeInternal(ATTRIBUTE5, value);
    }

    /**
     * Gets the attribute value for Attribute6, using the alias name Attribute6.
     * @return the value of Attribute6
     */
    public String getAttribute6() {
        return (String) getAttributeInternal(ATTRIBUTE6);
    }

    /**
     * Sets <code>value</code> as the attribute value for Attribute6.
     * @param value value to set the Attribute6
     */
    public void setAttribute6(String value) {
        setAttributeInternal(ATTRIBUTE6, value);
    }

    /**
     * Gets the attribute value for Attribute7, using the alias name Attribute7.
     * @return the value of Attribute7
     */
    public String getAttribute7() {
        return (String) getAttributeInternal(ATTRIBUTE7);
    }

    /**
     * Sets <code>value</code> as the attribute value for Attribute7.
     * @param value value to set the Attribute7
     */
    public void setAttribute7(String value) {
        setAttributeInternal(ATTRIBUTE7, value);
    }

    /**
     * Gets the attribute value for Attribute8, using the alias name Attribute8.
     * @return the value of Attribute8
     */
    public String getAttribute8() {
        return (String) getAttributeInternal(ATTRIBUTE8);
    }

    /**
     * Sets <code>value</code> as the attribute value for Attribute8.
     * @param value value to set the Attribute8
     */
    public void setAttribute8(String value) {
        setAttributeInternal(ATTRIBUTE8, value);
    }

    /**
     * Gets the attribute value for Attribute9, using the alias name Attribute9.
     * @return the value of Attribute9
     */
    public String getAttribute9() {
        return (String) getAttributeInternal(ATTRIBUTE9);
    }

    /**
     * Sets <code>value</code> as the attribute value for Attribute9.
     * @param value value to set the Attribute9
     */
    public void setAttribute9(String value) {
        setAttributeInternal(ATTRIBUTE9, value);
    }

    /**
     * Gets the attribute value for Attribute10, using the alias name Attribute10.
     * @return the value of Attribute10
     */
    public String getAttribute10() {
        return (String) getAttributeInternal(ATTRIBUTE10);
    }

    /**
     * Sets <code>value</code> as the attribute value for Attribute10.
     * @param value value to set the Attribute10
     */
    public void setAttribute10(String value) {
        setAttributeInternal(ATTRIBUTE10, value);
    }

    /**
     * Gets the attribute value for Attribute11, using the alias name Attribute11.
     * @return the value of Attribute11
     */
    public String getAttribute11() {
        return (String) getAttributeInternal(ATTRIBUTE11);
    }

    /**
     * Sets <code>value</code> as the attribute value for Attribute11.
     * @param value value to set the Attribute11
     */
    public void setAttribute11(String value) {
        setAttributeInternal(ATTRIBUTE11, value);
    }

    /**
     * Gets the attribute value for Attribute12, using the alias name Attribute12.
     * @return the value of Attribute12
     */
    public String getAttribute12() {
        return (String) getAttributeInternal(ATTRIBUTE12);
    }

    /**
     * Sets <code>value</code> as the attribute value for Attribute12.
     * @param value value to set the Attribute12
     */
    public void setAttribute12(String value) {
        setAttributeInternal(ATTRIBUTE12, value);
    }

    /**
     * Gets the attribute value for Attribute13, using the alias name Attribute13.
     * @return the value of Attribute13
     */
    public String getAttribute13() {
        return (String) getAttributeInternal(ATTRIBUTE13);
    }

    /**
     * Sets <code>value</code> as the attribute value for Attribute13.
     * @param value value to set the Attribute13
     */
    public void setAttribute13(String value) {
        setAttributeInternal(ATTRIBUTE13, value);
    }

    /**
     * Gets the attribute value for Attribute14, using the alias name Attribute14.
     * @return the value of Attribute14
     */
    public String getAttribute14() {
        return (String) getAttributeInternal(ATTRIBUTE14);
    }

    /**
     * Sets <code>value</code> as the attribute value for Attribute14.
     * @param value value to set the Attribute14
     */
    public void setAttribute14(String value) {
        setAttributeInternal(ATTRIBUTE14, value);
    }

    /**
     * Gets the attribute value for Attribute15, using the alias name Attribute15.
     * @return the value of Attribute15
     */
    public String getAttribute15() {
        return (String) getAttributeInternal(ATTRIBUTE15);
    }

    /**
     * Sets <code>value</code> as the attribute value for Attribute15.
     * @param value value to set the Attribute15
     */
    public void setAttribute15(String value) {
        setAttributeInternal(ATTRIBUTE15, value);
    }

    /**
     * Gets the attribute value for CertificateType, using the alias name CertificateType.
     * @return the value of CertificateType
     */
    public String getCertificateType() {
        return (String) getAttributeInternal(CERTIFICATETYPE);
    }

    /**
     * Sets <code>value</code> as the attribute value for CertificateType.
     * @param value value to set the CertificateType
     */
    public void setCertificateType(String value) {
        setAttributeInternal(CERTIFICATETYPE, value);
    }

    /**
     * Gets the attribute value for VerifiedBy, using the alias name VerifiedBy.
     * @return the value of VerifiedBy
     */
    public BigDecimal getVerifiedBy() {
        return (BigDecimal) getAttributeInternal(VERIFIEDBY);
    }

    /**
     * Sets <code>value</code> as the attribute value for VerifiedBy.
     * @param value value to set the VerifiedBy
     */
    public void setVerifiedBy(BigDecimal value) {
        setAttributeInternal(VERIFIEDBY, value);
    }

    /**
     * Gets the attribute value for VerifiedDate, using the alias name VerifiedDate.
     * @return the value of VerifiedDate
     */
    public Timestamp getVerifiedDate() {
        return (Timestamp) getAttributeInternal(VERIFIEDDATE);
    }

    /**
     * Sets <code>value</code> as the attribute value for VerifiedDate.
     * @param value value to set the VerifiedDate
     */
    public void setVerifiedDate(Timestamp value) {
        setAttributeInternal(VERIFIEDDATE, value);
    }

    /**
     * Gets the attribute value for VerificationEdocId, using the alias name VerificationEdocId.
     * @return the value of VerificationEdocId
     */
    public BigDecimal getVerificationEdocId() {
        return (BigDecimal) getAttributeInternal(VERIFICATIONEDOCID);
    }

    /**
     * Sets <code>value</code> as the attribute value for VerificationEdocId.
     * @param value value to set the VerificationEdocId
     */
    public void setVerificationEdocId(BigDecimal value) {
        setAttributeInternal(VERIFICATIONEDOCID, value);
    }

    /**
     * Gets the attribute value for VerificationRequestDate, using the alias name VerificationRequestDate.
     * @return the value of VerificationRequestDate
     */
    public Timestamp getVerificationRequestDate() {
        return (Timestamp) getAttributeInternal(VERIFICATIONREQUESTDATE);
    }

    /**
     * Sets <code>value</code> as the attribute value for VerificationRequestDate.
     * @param value value to set the VerificationRequestDate
     */
    public void setVerificationRequestDate(Timestamp value) {
        setAttributeInternal(VERIFICATIONREQUESTDATE, value);
    }

    /**
     * Gets the attribute value for VerificationBy, using the alias name VerificationBy.
     * @return the value of VerificationBy
     */
    public BigDecimal getVerificationBy() {
        return (BigDecimal) getAttributeInternal(VERIFICATIONBY);
    }

    /**
     * Sets <code>value</code> as the attribute value for VerificationBy.
     * @param value value to set the VerificationBy
     */
    public void setVerificationBy(BigDecimal value) {
        setAttributeInternal(VERIFICATIONBY, value);
    }

    /**
     * Gets the attribute value for Verified, using the alias name Verified.
     * @return the value of Verified
     */
    public String getVerified() {
        return (String) getAttributeInternal(VERIFIED);
    }

    /**
     * Sets <code>value</code> as the attribute value for Verified.
     * @param value value to set the Verified
     */
    public void setVerified(String value) {
        setAttributeInternal(VERIFIED, value);
    }

    /**
     * Gets the attribute value for DataVerifiedDate, using the alias name DataVerifiedDate.
     * @return the value of DataVerifiedDate
     */
    public Timestamp getDataVerifiedDate() {
        return (Timestamp) getAttributeInternal(DATAVERIFIEDDATE);
    }

    /**
     * Sets <code>value</code> as the attribute value for DataVerifiedDate.
     * @param value value to set the DataVerifiedDate
     */
    public void setDataVerifiedDate(Timestamp value) {
        setAttributeInternal(DATAVERIFIEDDATE, value);
    }

    /**
     * Gets the attribute value for DataVerifiedBy, using the alias name DataVerifiedBy.
     * @return the value of DataVerifiedBy
     */
    public BigDecimal getDataVerifiedBy() {
        return (BigDecimal) getAttributeInternal(DATAVERIFIEDBY);
    }

    /**
     * Sets <code>value</code> as the attribute value for DataVerifiedBy.
     * @param value value to set the DataVerifiedBy
     */
    public void setDataVerifiedBy(BigDecimal value) {
        setAttributeInternal(DATAVERIFIEDBY, value);
    }

    /**
     * Gets the attribute value for EsdiId, using the alias name EsdiId.
     * @return the value of EsdiId
     */
    public BigDecimal getEsdiId() {
        return (BigDecimal) getAttributeInternal(ESDIID);
    }

    /**
     * Sets <code>value</code> as the attribute value for EsdiId.
     * @param value value to set the EsdiId
     */
    public void setEsdiId(BigDecimal value) {
        setAttributeInternal(ESDIID, value);
    }

    /**
     * Gets the attribute value for GradingStatus, using the alias name GradingStatus.
     * @return the value of GradingStatus
     */
    public String getGradingStatus() {
        return (String) getAttributeInternal(GRADINGSTATUS);
    }

    /**
     * Sets <code>value</code> as the attribute value for GradingStatus.
     * @param value value to set the GradingStatus
     */
    public void setGradingStatus(String value) {
        setAttributeInternal(GRADINGSTATUS, value);
    }


    /**
     * @param documentId key constituent

     * @return a Key object based on given key constituents.
     */
    public static Key createPrimaryKey(BigDecimal documentId) {
        return new Key(new Object[] { documentId });
    }

    /**
     * Add attribute defaulting logic in this method.
     * @param attributeList list of attribute names/values to initialize the row
     */
    protected void create(AttributeList attributeList) 
    {       
        setDocumentId(new BigDecimal(-1));
        setSignatureId(new BigDecimal(2));
        setIssueType("New");
        setIssueDate(new Timestamp(System.currentTimeMillis()));
        setStatus("Active");
        setAttribute3("Y");
        super.create(attributeList);
    }

    /**
     * Add entity remove logic in this method.
     */
    public void remove() {
        super.remove();
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
    protected void doDML(int operation, TransactionEvent e) 
    {
        super.doDML(operation, e);
    }  
}
