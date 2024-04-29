package oracle.apps.xwrl.model.entity;

import java.math.BigDecimal;

import java.sql.SQLException;
import java.sql.Timestamp;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;

import oracle.adf.share.ADFContext;

import oracle.jbo.Key;
import oracle.jbo.RowIterator;
import oracle.jbo.server.EntityDefImpl;
import oracle.jbo.server.EntityImpl;
import oracle.jbo.server.TransactionEvent;
// ---------------------------------------------------------------------
// ---    File generated by Oracle ADF Business Components Design Time.
// ---    Fri Nov 15 15:24:24 EST 2019
// ---    Custom code may be added to this class.
// ---    Warning: Do not modify method signatures of generated methods.
// ---------------------------------------------------------------------
public class XwrlRequestsImpl extends EntityImpl {
    
   
    /**
     * AttributesEnum: generated enum for identifying attributes and accessors. DO NOT MODIFY.
     */
    public enum AttributesEnum {
        Id,
        ResubmitId,
        SourceTable,
        SourceId,
        WcScreeningRequestId,
        Server,
        Path,
        JobId,
        Matches,
        Status,
        ErrorCode,
        ErrorMessage,
        LastUpdateDate,
        LastUpdatedBy,
        CreationDate,
        CreatedBy,
        LastUpdateLogin,
        CaseId,
        NameScreened,
        DateOfBirth,
        ImoNumber,
        VesselIndicator,
        Department,
        Office,
        Priority,
        RiskLevel,
        DocumentType,
        ClosedDate,
        AssignedTo,
        CountryOfResidence,
        CityOfResidence,
        SubdivisionCityOfResidence,
        CaseState,
        CaseStatus,
        CaseWorkflow,
        RejectionReason,
        BatchId,
        CountryOfAddress,
        CountryOfNationality,
        CountryOfBirth,
        CountryOfRegistration,
        CountryOfOperation,
        CityOfResidenceId,
        RejectionReasonOthr,
      //  VersionId,
        DepartmentExt,
        SentToLegalBy,
        SentToLegalDate,
        AddressConfirmationDate,
        Gender,
        PassportNumber,
        XwrlRequestEntityColumns,
        XwrlRequestIndColumns,
        XwrlRequestRows,
        XwrlResponseEntityColumns,
        XwrlResponseIndColumns,
        XwrlResponseRows,
        XwrlAlertNotes,
        XwrlCaseNotes1,
        XwrlCaseDocuments1,
        XwrlCaseNotes,
        XwrlCaseDocuments;
        static AttributesEnum[] vals = null;
        //   WrkflowStatusLegalNtfd,
        //  WrkflowStatusLegalNtfdDt,
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


    //public static final int WRKFLOWSTATUSLEGALNTFD = AttributesEnum.WrkflowStatusLegalNtfd.index();
    //public static final int WRKFLOWSTATUSLEGALNTFDDT = AttributesEnum.WrkflowStatusLegalNtfdDt.index();


    public static final int ID = AttributesEnum.Id.index();
    public static final int RESUBMITID = AttributesEnum.ResubmitId.index();
    public static final int SOURCETABLE = AttributesEnum.SourceTable.index();
    public static final int SOURCEID = AttributesEnum.SourceId.index();
    public static final int WCSCREENINGREQUESTID = AttributesEnum.WcScreeningRequestId.index();
    public static final int SERVER = AttributesEnum.Server.index();
    public static final int PATH = AttributesEnum.Path.index();
    public static final int JOBID = AttributesEnum.JobId.index();
    public static final int MATCHES = AttributesEnum.Matches.index();
    public static final int STATUS = AttributesEnum.Status.index();
    public static final int ERRORCODE = AttributesEnum.ErrorCode.index();
    public static final int ERRORMESSAGE = AttributesEnum.ErrorMessage.index();
    public static final int LASTUPDATEDATE = AttributesEnum.LastUpdateDate.index();
    public static final int LASTUPDATEDBY = AttributesEnum.LastUpdatedBy.index();
    public static final int CREATIONDATE = AttributesEnum.CreationDate.index();
    public static final int CREATEDBY = AttributesEnum.CreatedBy.index();
    public static final int LASTUPDATELOGIN = AttributesEnum.LastUpdateLogin.index();
    public static final int CASEID = AttributesEnum.CaseId.index();
    public static final int NAMESCREENED = AttributesEnum.NameScreened.index();
    public static final int DATEOFBIRTH = AttributesEnum.DateOfBirth.index();
    public static final int IMONUMBER = AttributesEnum.ImoNumber.index();
    public static final int VESSELINDICATOR = AttributesEnum.VesselIndicator.index();
    public static final int DEPARTMENT = AttributesEnum.Department.index();
    public static final int OFFICE = AttributesEnum.Office.index();
    public static final int PRIORITY = AttributesEnum.Priority.index();
    public static final int RISKLEVEL = AttributesEnum.RiskLevel.index();
    public static final int DOCUMENTTYPE = AttributesEnum.DocumentType.index();
    public static final int CLOSEDDATE = AttributesEnum.ClosedDate.index();
    public static final int ASSIGNEDTO = AttributesEnum.AssignedTo.index();
    public static final int COUNTRYOFRESIDENCE = AttributesEnum.CountryOfResidence.index();
    public static final int CITYOFRESIDENCE = AttributesEnum.CityOfResidence.index();
    public static final int SUBDIVISIONCITYOFRESIDENCE = AttributesEnum.SubdivisionCityOfResidence.index();
    public static final int CASESTATE = AttributesEnum.CaseState.index();
    public static final int CASESTATUS = AttributesEnum.CaseStatus.index();
    public static final int CASEWORKFLOW = AttributesEnum.CaseWorkflow.index();
    public static final int REJECTIONREASON = AttributesEnum.RejectionReason.index();
    public static final int BATCHID = AttributesEnum.BatchId.index();
    public static final int COUNTRYOFADDRESS = AttributesEnum.CountryOfAddress.index();
    public static final int COUNTRYOFNATIONALITY = AttributesEnum.CountryOfNationality.index();
    public static final int COUNTRYOFBIRTH = AttributesEnum.CountryOfBirth.index();
    public static final int COUNTRYOFREGISTRATION = AttributesEnum.CountryOfRegistration.index();
    public static final int COUNTRYOFOPERATION = AttributesEnum.CountryOfOperation.index();
    public static final int CITYOFRESIDENCEID = AttributesEnum.CityOfResidenceId.index();
    public static final int REJECTIONREASONOTHR = AttributesEnum.RejectionReasonOthr.index();
   // public static final int VERSIONID = AttributesEnum.VersionId.index();
    public static final int DEPARTMENTEXT = AttributesEnum.DepartmentExt.index();
    public static final int SENTTOLEGALBY = AttributesEnum.SentToLegalBy.index();
    public static final int SENTTOLEGALDATE = AttributesEnum.SentToLegalDate.index();
    public static final int ADDRESSCONFIRMATIONDATE = AttributesEnum.AddressConfirmationDate.index();
    public static final int GENDER = AttributesEnum.Gender.index();
    public static final int PASSPORTNUMBER = AttributesEnum.PassportNumber.index();
    public static final int XWRLREQUESTENTITYCOLUMNS = AttributesEnum.XwrlRequestEntityColumns.index();
    public static final int XWRLREQUESTINDCOLUMNS = AttributesEnum.XwrlRequestIndColumns.index();
    public static final int XWRLREQUESTROWS = AttributesEnum.XwrlRequestRows.index();
    public static final int XWRLRESPONSEENTITYCOLUMNS = AttributesEnum.XwrlResponseEntityColumns.index();
    public static final int XWRLRESPONSEINDCOLUMNS = AttributesEnum.XwrlResponseIndColumns.index();
    public static final int XWRLRESPONSEROWS = AttributesEnum.XwrlResponseRows.index();
    public static final int XWRLALERTNOTES = AttributesEnum.XwrlAlertNotes.index();
    public static final int XWRLCASENOTES1 = AttributesEnum.XwrlCaseNotes1.index();
    public static final int XWRLCASEDOCUMENTS1 = AttributesEnum.XwrlCaseDocuments1.index();
    public static final int XWRLCASENOTES = AttributesEnum.XwrlCaseNotes.index();
    public static final int XWRLCASEDOCUMENTS = AttributesEnum.XwrlCaseDocuments.index();

    /**
     * This is the default constructor (do not remove).
     */
    public XwrlRequestsImpl() {
    }

    /**
     * @return the definition object for this instance class.
     */
    public static synchronized EntityDefImpl getDefinitionObject() {
        return EntityDefImpl.findDefObject("oracle.apps.xwrl.model.entity.XwrlRequests");
    }


    /**
     * Gets the attribute value for Id, using the alias name Id.
     * @return the value of Id
     */
    public BigDecimal getId() {
        return (BigDecimal) getAttributeInternal(ID);
    }

    /**
     * Sets <code>value</code> as the attribute value for Id.
     * @param value value to set the Id
     */
    public void setId(BigDecimal value) {
        setAttributeInternal(ID, value);
    }

    /**
     * Gets the attribute value for ResubmitId, using the alias name ResubmitId.
     * @return the value of ResubmitId
     */
    public BigDecimal getResubmitId() {
        return (BigDecimal) getAttributeInternal(RESUBMITID);
    }

    /**
     * Sets <code>value</code> as the attribute value for ResubmitId.
     * @param value value to set the ResubmitId
     */
    public void setResubmitId(BigDecimal value) {
        setAttributeInternal(RESUBMITID, value);
    }

    /**
     * Gets the attribute value for SourceTable, using the alias name SourceTable.
     * @return the value of SourceTable
     */
    public String getSourceTable() {
        return (String) getAttributeInternal(SOURCETABLE);
    }

    /**
     * Sets <code>value</code> as the attribute value for SourceTable.
     * @param value value to set the SourceTable
     */
    public void setSourceTable(String value) {
        setAttributeInternal(SOURCETABLE, value);
    }

    /**
     * Gets the attribute value for SourceId, using the alias name SourceId.
     * @return the value of SourceId
     */
    public BigDecimal getSourceId() {
        return (BigDecimal) getAttributeInternal(SOURCEID);
    }

    /**
     * Sets <code>value</code> as the attribute value for SourceId.
     * @param value value to set the SourceId
     */
    public void setSourceId(BigDecimal value) {
        setAttributeInternal(SOURCEID, value);
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
     * Gets the attribute value for Server, using the alias name Server.
     * @return the value of Server
     */
    public String getServer() {
        return (String) getAttributeInternal(SERVER);
    }

    /**
     * Sets <code>value</code> as the attribute value for Server.
     * @param value value to set the Server
     */
    public void setServer(String value) {
        setAttributeInternal(SERVER, value);
    }

    /**
     * Gets the attribute value for Path, using the alias name Path.
     * @return the value of Path
     */
    public String getPath() {
        return (String) getAttributeInternal(PATH);
    }

    /**
     * Sets <code>value</code> as the attribute value for Path.
     * @param value value to set the Path
     */
    public void setPath(String value) {
        setAttributeInternal(PATH, value);
    }

    /**
     * Gets the attribute value for JobId, using the alias name JobId.
     * @return the value of JobId
     */
    public String getJobId() {
        return (String) getAttributeInternal(JOBID);
    }

    /**
     * Sets <code>value</code> as the attribute value for JobId.
     * @param value value to set the JobId
     */
    public void setJobId(String value) {
        setAttributeInternal(JOBID, value);
    }

    /**
     * Gets the attribute value for Matches, using the alias name Matches.
     * @return the value of Matches
     */
    public BigDecimal getMatches() {
        return (BigDecimal) getAttributeInternal(MATCHES);
    }

    /**
     * Sets <code>value</code> as the attribute value for Matches.
     * @param value value to set the Matches
     */
    public void setMatches(BigDecimal value) {
        setAttributeInternal(MATCHES, value);
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
     * Gets the attribute value for ErrorCode, using the alias name ErrorCode.
     * @return the value of ErrorCode
     */
    public String getErrorCode() {
        return (String) getAttributeInternal(ERRORCODE);
    }

    /**
     * Sets <code>value</code> as the attribute value for ErrorCode.
     * @param value value to set the ErrorCode
     */
    public void setErrorCode(String value) {
        setAttributeInternal(ERRORCODE, value);
    }

    /**
     * Gets the attribute value for ErrorMessage, using the alias name ErrorMessage.
     * @return the value of ErrorMessage
     */
    public String getErrorMessage() {
        return (String) getAttributeInternal(ERRORMESSAGE);
    }

    /**
     * Sets <code>value</code> as the attribute value for ErrorMessage.
     * @param value value to set the ErrorMessage
     */
    public void setErrorMessage(String value) {
        setAttributeInternal(ERRORMESSAGE, value);
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
     * Gets the attribute value for CaseId, using the alias name CaseId.
     * @return the value of CaseId
     */
    public String getCaseId() {
        return (String) getAttributeInternal(CASEID);
    }

    /**
     * Sets <code>value</code> as the attribute value for CaseId.
     * @param value value to set the CaseId
     */
    public void setCaseId(String value) {
        setAttributeInternal(CASEID, value);
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
    public String getDateOfBirth() {
        return (String) getAttributeInternal(DATEOFBIRTH);
    }

    /**
     * Sets <code>value</code> as the attribute value for DateOfBirth.
     * @param value value to set the DateOfBirth
     */
    public void setDateOfBirth(String value) {
        setAttributeInternal(DATEOFBIRTH, value);
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
     * Gets the attribute value for VesselIndicator, using the alias name VesselIndicator.
     * @return the value of VesselIndicator
     */
    public String getVesselIndicator() {
        return (String) getAttributeInternal(VESSELINDICATOR);
    }

    /**
     * Sets <code>value</code> as the attribute value for VesselIndicator.
     * @param value value to set the VesselIndicator
     */
    public void setVesselIndicator(String value) {
        setAttributeInternal(VESSELINDICATOR, value);
    }

    /**
     * Gets the attribute value for Department, using the alias name Department.
     * @return the value of Department
     */
    public String getDepartment() {
        return (String) getAttributeInternal(DEPARTMENT);
    }

    /**
     * Sets <code>value</code> as the attribute value for Department.
     * @param value value to set the Department
     */
    public void setDepartment(String value) {
        setAttributeInternal(DEPARTMENT, value);
    }

    /**
     * Gets the attribute value for Office, using the alias name Office.
     * @return the value of Office
     */
    public String getOffice() {
        return (String) getAttributeInternal(OFFICE);
    }

    /**
     * Sets <code>value</code> as the attribute value for Office.
     * @param value value to set the Office
     */
    public void setOffice(String value) {
        setAttributeInternal(OFFICE, value);
    }

    /**
     * Gets the attribute value for Priority, using the alias name Priority.
     * @return the value of Priority
     */
    public String getPriority() {
        return (String) getAttributeInternal(PRIORITY);
    }

    /**
     * Sets <code>value</code> as the attribute value for Priority.
     * @param value value to set the Priority
     */
    public void setPriority(String value) {
        setAttributeInternal(PRIORITY, value);
    }

    /**
     * Gets the attribute value for RiskLevel, using the alias name RiskLevel.
     * @return the value of RiskLevel
     */
    public String getRiskLevel() {
        return (String) getAttributeInternal(RISKLEVEL);
    }

    /**
     * Sets <code>value</code> as the attribute value for RiskLevel.
     * @param value value to set the RiskLevel
     */
    public void setRiskLevel(String value) {
        setAttributeInternal(RISKLEVEL, value);
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
     * Gets the attribute value for ClosedDate, using the alias name ClosedDate.
     * @return the value of ClosedDate
     */
    public Timestamp getClosedDate() {
        return (Timestamp) getAttributeInternal(CLOSEDDATE);
    }

    /**
     * Sets <code>value</code> as the attribute value for ClosedDate.
     * @param value value to set the ClosedDate
     */
    public void setClosedDate(Timestamp value) {
        setAttributeInternal(CLOSEDDATE, value);
    }

    /**
     * Gets the attribute value for AssignedTo, using the alias name AssignedTo.
     * @return the value of AssignedTo
     */
    public Long getAssignedTo() {
        return (Long) getAttributeInternal(ASSIGNEDTO);
    }

    /**
     * Sets <code>value</code> as the attribute value for AssignedTo.
     * @param value value to set the AssignedTo
     */
    public void setAssignedTo(Long value) {
        setAttributeInternal(ASSIGNEDTO, value);
    }

    /**
     * Gets the attribute value for CountryOfResidence, using the alias name CountryOfResidence.
     * @return the value of CountryOfResidence
     */
    public String getCountryOfResidence() {
        return (String) getAttributeInternal(COUNTRYOFRESIDENCE);
    }

    /**
     * Sets <code>value</code> as the attribute value for CountryOfResidence.
     * @param value value to set the CountryOfResidence
     */
    public void setCountryOfResidence(String value) {
        setAttributeInternal(COUNTRYOFRESIDENCE, value);
    }

    /**
     * Gets the attribute value for CityOfResidence, using the alias name CityOfResidence.
     * @return the value of CityOfResidence
     */
    public String getCityOfResidence() {
        return (String) getAttributeInternal(CITYOFRESIDENCE);
    }

    /**
     * Sets <code>value</code> as the attribute value for CityOfResidence.
     * @param value value to set the CityOfResidence
     */
    public void setCityOfResidence(String value) {
        setAttributeInternal(CITYOFRESIDENCE, value);
    }

    /**
     * Gets the attribute value for SubdivisionCityOfResidence, using the alias name SubdivisionCityOfResidence.
     * @return the value of SubdivisionCityOfResidence
     */
    public String getSubdivisionCityOfResidence() {
        return (String) getAttributeInternal(SUBDIVISIONCITYOFRESIDENCE);
    }

    /**
     * Sets <code>value</code> as the attribute value for SubdivisionCityOfResidence.
     * @param value value to set the SubdivisionCityOfResidence
     */
    public void setSubdivisionCityOfResidence(String value) {
        setAttributeInternal(SUBDIVISIONCITYOFRESIDENCE, value);
    }

    /**
     * Gets the attribute value for CaseState, using the alias name CaseState.
     * @return the value of CaseState
     */
    public String getCaseState() {
        return (String) getAttributeInternal(CASESTATE);
    }

    /**
     * Sets <code>value</code> as the attribute value for CaseState.
     * @param value value to set the CaseState
     */
    public void setCaseState(String value) {
        setAttributeInternal(CASESTATE, value);
    }

    /**
     * Gets the attribute value for CaseStatus, using the alias name CaseStatus.
     * @return the value of CaseStatus
     */
    public String getCaseStatus() {
        return (String) getAttributeInternal(CASESTATUS);
    }

    /**
     * Sets <code>value</code> as the attribute value for CaseStatus.
     * @param value value to set the CaseStatus
     */
    public void setCaseStatus(String value) {
        setAttributeInternal(CASESTATUS, value);
    }

    /**
     * Gets the attribute value for CaseWorkflow, using the alias name CaseWorkflow.
     * @return the value of CaseWorkflow
     */
    public String getCaseWorkflow() {
        return (String) getAttributeInternal(CASEWORKFLOW);
    }

    /**
     * Sets <code>value</code> as the attribute value for CaseWorkflow.
     * @param value value to set the CaseWorkflow
     */
    public void setCaseWorkflow(String value) {
        setAttributeInternal(CASEWORKFLOW, value);
    }

    /**
     * Gets the attribute value for RejectionReason, using the alias name RejectionReason.
     * @return the value of RejectionReason
     */
    public String getRejectionReason() {
        return (String) getAttributeInternal(REJECTIONREASON);
    }

    /**
     * Sets <code>value</code> as the attribute value for RejectionReason.
     * @param value value to set the RejectionReason
     */
    public void setRejectionReason(String value) {
        setAttributeInternal(REJECTIONREASON, value);
    }

    /**
     * Gets the attribute value for BatchId, using the alias name BatchId.
     * @return the value of BatchId
     */
    public BigDecimal getBatchId() {
        return (BigDecimal) getAttributeInternal(BATCHID);
    }

    /**
     * Sets <code>value</code> as the attribute value for BatchId.
     * @param value value to set the BatchId
     */
    public void setBatchId(BigDecimal value) {
        setAttributeInternal(BATCHID, value);
    }

    /**
     * Gets the attribute value for CountryOfAddress, using the alias name CountryOfAddress.
     * @return the value of CountryOfAddress
     */
    public String getCountryOfAddress() {
        return (String) getAttributeInternal(COUNTRYOFADDRESS);
    }

    /**
     * Sets <code>value</code> as the attribute value for CountryOfAddress.
     * @param value value to set the CountryOfAddress
     */
    public void setCountryOfAddress(String value) {
        setAttributeInternal(COUNTRYOFADDRESS, value);
    }

    /**
     * Gets the attribute value for CountryOfNationality, using the alias name CountryOfNationality.
     * @return the value of CountryOfNationality
     */
    public String getCountryOfNationality() {
        return (String) getAttributeInternal(COUNTRYOFNATIONALITY);
    }

    /**
     * Sets <code>value</code> as the attribute value for CountryOfNationality.
     * @param value value to set the CountryOfNationality
     */
    public void setCountryOfNationality(String value) {
        setAttributeInternal(COUNTRYOFNATIONALITY, value);
    }

    /**
     * Gets the attribute value for CountryOfBirth, using the alias name CountryOfBirth.
     * @return the value of CountryOfBirth
     */
    public String getCountryOfBirth() {
        return (String) getAttributeInternal(COUNTRYOFBIRTH);
    }

    /**
     * Sets <code>value</code> as the attribute value for CountryOfBirth.
     * @param value value to set the CountryOfBirth
     */
    public void setCountryOfBirth(String value) {
        setAttributeInternal(COUNTRYOFBIRTH, value);
    }

    /**
     * Gets the attribute value for CountryOfRegistration, using the alias name CountryOfRegistration.
     * @return the value of CountryOfRegistration
     */
    public String getCountryOfRegistration() {
        return (String) getAttributeInternal(COUNTRYOFREGISTRATION);
    }

    /**
     * Sets <code>value</code> as the attribute value for CountryOfRegistration.
     * @param value value to set the CountryOfRegistration
     */
    public void setCountryOfRegistration(String value) {
        setAttributeInternal(COUNTRYOFREGISTRATION, value);
    }

    /**
     * Gets the attribute value for CountryOfOperation, using the alias name CountryOfOperation.
     * @return the value of CountryOfOperation
     */
    public String getCountryOfOperation() {
        return (String) getAttributeInternal(COUNTRYOFOPERATION);
    }

    /**
     * Sets <code>value</code> as the attribute value for CountryOfOperation.
     * @param value value to set the CountryOfOperation
     */
    public void setCountryOfOperation(String value) {
        setAttributeInternal(COUNTRYOFOPERATION, value);
    }

    /**
     * Gets the attribute value for CityOfResidenceId, using the alias name CityOfResidenceId.
     * @return the value of CityOfResidenceId
     */
    public BigDecimal getCityOfResidenceId() {
        return (BigDecimal) getAttributeInternal(CITYOFRESIDENCEID);
    }

    /**
     * Sets <code>value</code> as the attribute value for CityOfResidenceId.
     * @param value value to set the CityOfResidenceId
     */
    public void setCityOfResidenceId(BigDecimal value) {
        setAttributeInternal(CITYOFRESIDENCEID, value);
    }

    /**
     * Gets the attribute value for RejectionReasonOthr, using the alias name RejectionReasonOthr.
     * @return the value of RejectionReasonOthr
     */
    public String getRejectionReasonOthr() {
        return (String) getAttributeInternal(REJECTIONREASONOTHR);
    }

    /**
     * Sets <code>value</code> as the attribute value for RejectionReasonOthr.
     * @param value value to set the RejectionReasonOthr
     */
    public void setRejectionReasonOthr(String value) {
        setAttributeInternal(REJECTIONREASONOTHR, value);
    }

    /**
     * Gets the attribute value for VersionId, using the alias name VersionId.
     * @return the value of VersionId
     */
   /* public Long getVersionId() {
        return (Long) getAttributeInternal(VERSIONID);
    } */


    /**
     * Gets the attribute value for DepartmentExt, using the alias name DepartmentExt.
     * @return the value of DepartmentExt
     */
    public String getDepartmentExt() {
        return (String) getAttributeInternal(DEPARTMENTEXT);
    }

    /**
     * Sets <code>value</code> as the attribute value for DepartmentExt.
     * @param value value to set the DepartmentExt
     */
    public void setDepartmentExt(String value) {
        setAttributeInternal(DEPARTMENTEXT, value);
    }

    /**
     * Gets the attribute value for SentToLegalBy, using the alias name SentToLegalBy.
     * @return the value of SentToLegalBy
     */
    public Long getSentToLegalBy() {
        return (Long) getAttributeInternal(SENTTOLEGALBY);
    }

    /**
     * Sets <code>value</code> as the attribute value for SentToLegalBy.
     * @param value value to set the SentToLegalBy
     */
    public void setSentToLegalBy(Long value) {
        setAttributeInternal(SENTTOLEGALBY, value);
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
     * Gets the attribute value for AddressConfirmationDate, using the alias name AddressConfirmationDate.
     * @return the value of AddressConfirmationDate
     */
    public Timestamp getAddressConfirmationDate() {
        return (Timestamp) getAttributeInternal(ADDRESSCONFIRMATIONDATE);
    }

    /**
     * Sets <code>value</code> as the attribute value for AddressConfirmationDate.
     * @param value value to set the AddressConfirmationDate
     */
    public void setAddressConfirmationDate(Timestamp value) {
        setAttributeInternal(ADDRESSCONFIRMATIONDATE, value);
    }
    
    /*
       public String getWrkflowStatusLegalNtfd() {
           return (String) getAttributeInternal(WRKFLOWSTATUSLEGALNTFD);
       }

       
       public void setWrkflowStatusLegalNtfd(String value) {
           setAttributeInternal(WRKFLOWSTATUSLEGALNTFD, value);
       }

       
       public Timestamp getWrkflowStatusLegalNtfdDt() {
           return (Timestamp) getAttributeInternal(WRKFLOWSTATUSLEGALNTFDDT);
       }

      
       public void setWrkflowStatusLegalNtfdDt(Timestamp value) {
           setAttributeInternal(WRKFLOWSTATUSLEGALNTFDDT, value);
       }
	   
	   */

    /**
     * Gets the attribute value for Gender, using the alias name Gender.
     * @return the value of Gender
     */
    public String getGender() {
        return (String) getAttributeInternal(GENDER);
    }

    /**
     * Sets <code>value</code> as the attribute value for Gender.
     * @param value value to set the Gender
     */
    public void setGender(String value) {
        setAttributeInternal(GENDER, value);
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
     * @return the associated entity oracle.jbo.RowIterator.
     */
    public RowIterator getXwrlRequestEntityColumns() {
        return (RowIterator) getAttributeInternal(XWRLREQUESTENTITYCOLUMNS);
    }

    /**
     * @return the associated entity oracle.jbo.RowIterator.
     */
    public RowIterator getXwrlRequestIndColumns() {
        return (RowIterator) getAttributeInternal(XWRLREQUESTINDCOLUMNS);
    }

    /**
     * @return the associated entity oracle.jbo.RowIterator.
     */
    public RowIterator getXwrlRequestRows() {
        return (RowIterator) getAttributeInternal(XWRLREQUESTROWS);
    }

    /**
     * @return the associated entity oracle.jbo.RowIterator.
     */
    public RowIterator getXwrlResponseEntityColumns() {
        return (RowIterator) getAttributeInternal(XWRLRESPONSEENTITYCOLUMNS);
    }

    /**
     * @return the associated entity oracle.jbo.RowIterator.
     */
    public RowIterator getXwrlResponseIndColumns() {
        return (RowIterator) getAttributeInternal(XWRLRESPONSEINDCOLUMNS);
    }

    /**
     * @return the associated entity oracle.jbo.RowIterator.
     */
    public RowIterator getXwrlResponseRows() {
        return (RowIterator) getAttributeInternal(XWRLRESPONSEROWS);
    }

    /**
     * @return the associated entity oracle.jbo.RowIterator.
     */
    public RowIterator getXwrlAlertNotes() {
        return (RowIterator) getAttributeInternal(XWRLALERTNOTES);
    }

    /**
     * @return the associated entity oracle.jbo.RowIterator.
     */
    public RowIterator getXwrlCaseNotes1() {
        return (RowIterator) getAttributeInternal(XWRLCASENOTES1);
    }

    /**
     * @return the associated entity oracle.jbo.RowIterator.
     */
    public RowIterator getXwrlCaseDocuments1() {
        return (RowIterator) getAttributeInternal(XWRLCASEDOCUMENTS1);
    }

    /**
     * @return the associated entity oracle.jbo.RowIterator.
     */
    public RowIterator getXwrlCaseNotes() {
        return (RowIterator) getAttributeInternal(XWRLCASENOTES);
    }

    /**
     * @return the associated entity oracle.jbo.RowIterator.
     */
    public RowIterator getXwrlCaseDocuments() {
        return (RowIterator) getAttributeInternal(XWRLCASEDOCUMENTS);
    }


    /**
     * @param id key constituent

     * @return a Key object based on given key constituents.
     */
    public static Key createPrimaryKey(BigDecimal id) {
        return new Key(new Object[] { id });
    }

    protected void doDML(int operation, TransactionEvent e) {
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
            System.out.println("XWRLRequestsImpl userId:"+userId);
        }
        try{
            super.doDML(operation, e);
        }catch(Exception se){
            se.printStackTrace();
            
            if(se.getCause() != null && !"".equals(se.getCause())) {
                String error = se.getCause().getLocalizedMessage().split("\n")[0];
                String msg = "";
                if(error.contains(": Error: "))
                    msg = error.substring(("ORA-"+": Error: ").length()+5,error.length());
                else
                    msg = error.substring(("ORA-").length()+5,error.length());
                
                FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_ERROR, msg, null);
                FacesContext.getCurrentInstance().addMessage(null, message);
            }
            return;
        }
    }


  /*  @Override
    public boolean isAttributeUpdateable(int i) {
        // TODO Implement this method
        
        if(this.isLocked()==false) 
        {
            return false;
        }
        
        return super.isAttributeUpdateable(i);
    }*/
    
    /**
     * @return the definition object for this instance class.
     */
  /*  public static synchronized EntityDefImpl getDefinitionObject() {
        if (mDefinitionObject == null) {
            mDefinitionObject = EntityDefImpl.findDefObject("oracle.apps.xwrl.model.entity.XwrlRequests");
        }
        return mDefinitionObject;
    }
    
    */


    /*
    * customizing locking management:
    * When optimistic locking executes, the exception "Another User Changed the Row" is thrown.
    * In this case, we execute locking again, ignoring the exception
    */
    /*@Override
    public void lock() {
      try {
        super.lock();
      } catch (oracle.jbo.RowInconsistentException e) {
          super.lock();
      }
    } */
}

