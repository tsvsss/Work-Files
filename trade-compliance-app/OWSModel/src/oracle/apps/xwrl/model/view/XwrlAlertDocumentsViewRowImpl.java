package oracle.apps.xwrl.model.view;

import java.math.BigDecimal;

import java.sql.Timestamp;

import oracle.apps.xwrl.model.entity.XwrlAlertDocumentsImpl;

import oracle.jbo.Row;
import oracle.jbo.RowSet;
import oracle.jbo.server.ViewRowImpl;
// ---------------------------------------------------------------------
// ---    File generated by Oracle ADF Business Components Design Time.
// ---    Sun Oct 27 14:07:01 EDT 2019
// ---    Custom code may be added to this class.
// ---    Warning: Do not modify method signatures of generated methods.
// ---------------------------------------------------------------------
public class XwrlAlertDocumentsViewRowImpl extends ViewRowImpl {


    public static final int ENTITY_XWRLALERTDOCUMENTS = 0;

    /**
     * AttributesEnum: generated enum for identifying attributes and accessors. DO NOT MODIFY.
     */
    public enum AttributesEnum {
        Id,
        RequestId,
        AlertId,
        EdocId,
        DocumentFile,
        DocumentName,
        DocumentCategory,
        DocumentType,
        FileName,
        FilePath,
        ContentType,
        ImageFile,
        ImageName,
        ImagePath,
        UrlPath,
        Comment,
        LastUpdateDate,
        LastUpdatedBy,
        CreationDate,
        CreatedBy,
        LastUpdateLogin,
        CreatedByAttr,
        LastUpdatedByAttr,
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
    public static final int EDOCID = AttributesEnum.EdocId.index();
    public static final int DOCUMENTFILE = AttributesEnum.DocumentFile.index();
    public static final int DOCUMENTNAME = AttributesEnum.DocumentName.index();
    public static final int DOCUMENTCATEGORY = AttributesEnum.DocumentCategory.index();
    public static final int DOCUMENTTYPE = AttributesEnum.DocumentType.index();
    public static final int FILENAME = AttributesEnum.FileName.index();
    public static final int FILEPATH = AttributesEnum.FilePath.index();
    public static final int CONTENTTYPE = AttributesEnum.ContentType.index();
    public static final int IMAGEFILE = AttributesEnum.ImageFile.index();
    public static final int IMAGENAME = AttributesEnum.ImageName.index();
    public static final int IMAGEPATH = AttributesEnum.ImagePath.index();
    public static final int URLPATH = AttributesEnum.UrlPath.index();
    public static final int COMMENT = AttributesEnum.Comment.index();
    public static final int LASTUPDATEDATE = AttributesEnum.LastUpdateDate.index();
    public static final int LASTUPDATEDBY = AttributesEnum.LastUpdatedBy.index();
    public static final int CREATIONDATE = AttributesEnum.CreationDate.index();
    public static final int CREATEDBY = AttributesEnum.CreatedBy.index();
    public static final int LASTUPDATELOGIN = AttributesEnum.LastUpdateLogin.index();
    public static final int CREATEDBYATTR = AttributesEnum.CreatedByAttr.index();
    public static final int LASTUPDATEDBYATTR = AttributesEnum.LastUpdatedByAttr.index();
    public static final int FNDUSERSALLLOV1 = AttributesEnum.FndUsersAllLov1.index();

    /**
     * This is the default constructor (do not remove).
     */
    public XwrlAlertDocumentsViewRowImpl() {
    }

    /**
     * Gets XwrlAlertDocuments entity object.
     * @return the XwrlAlertDocuments
     */
    public XwrlAlertDocumentsImpl getXwrlAlertDocuments() {
        return (XwrlAlertDocumentsImpl) getEntity(ENTITY_XWRLALERTDOCUMENTS);
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
     * Gets the attribute value for EDOC_ID using the alias name EdocId.
     * @return the EDOC_ID
     */
    public BigDecimal getEdocId() {
        return (BigDecimal) getAttributeInternal(EDOCID);
    }

    /**
     * Sets <code>value</code> as attribute value for EDOC_ID using the alias name EdocId.
     * @param value value to set the EDOC_ID
     */
    public void setEdocId(BigDecimal value) {
        setAttributeInternal(EDOCID, value);
    }

    /**
     * Gets the attribute value for DOCUMENT_FILE using the alias name DocumentFile.
     * @return the DOCUMENT_FILE
     */
    public String getDocumentFile() {
        return (String) getAttributeInternal(DOCUMENTFILE);
    }

    /**
     * Sets <code>value</code> as attribute value for DOCUMENT_FILE using the alias name DocumentFile.
     * @param value value to set the DOCUMENT_FILE
     */
    public void setDocumentFile(String value) {
        setAttributeInternal(DOCUMENTFILE, value);
    }

    /**
     * Gets the attribute value for DOCUMENT_NAME using the alias name DocumentName.
     * @return the DOCUMENT_NAME
     */
    public String getDocumentName() {
        return (String) getAttributeInternal(DOCUMENTNAME);
    }

    /**
     * Sets <code>value</code> as attribute value for DOCUMENT_NAME using the alias name DocumentName.
     * @param value value to set the DOCUMENT_NAME
     */
    public void setDocumentName(String value) {
        setAttributeInternal(DOCUMENTNAME, value);
    }

    /**
     * Gets the attribute value for DOCUMENT_CATEGORY using the alias name DocumentCategory.
     * @return the DOCUMENT_CATEGORY
     */
    public String getDocumentCategory() {
        return (String) getAttributeInternal(DOCUMENTCATEGORY);
    }

    /**
     * Sets <code>value</code> as attribute value for DOCUMENT_CATEGORY using the alias name DocumentCategory.
     * @param value value to set the DOCUMENT_CATEGORY
     */
    public void setDocumentCategory(String value) {
        setAttributeInternal(DOCUMENTCATEGORY, value);
    }

    /**
     * Gets the attribute value for DOCUMENT_TYPE using the alias name DocumentType.
     * @return the DOCUMENT_TYPE
     */
    public String getDocumentType() {
        return (String) getAttributeInternal(DOCUMENTTYPE);
    }

    /**
     * Sets <code>value</code> as attribute value for DOCUMENT_TYPE using the alias name DocumentType.
     * @param value value to set the DOCUMENT_TYPE
     */
    public void setDocumentType(String value) {
        setAttributeInternal(DOCUMENTTYPE, value);
    }

    /**
     * Gets the attribute value for FILE_NAME using the alias name FileName.
     * @return the FILE_NAME
     */
    public String getFileName() {
        return (String) getAttributeInternal(FILENAME);
    }

    /**
     * Sets <code>value</code> as attribute value for FILE_NAME using the alias name FileName.
     * @param value value to set the FILE_NAME
     */
    public void setFileName(String value) {
        setAttributeInternal(FILENAME, value);
    }

    /**
     * Gets the attribute value for FILE_PATH using the alias name FilePath.
     * @return the FILE_PATH
     */
    public String getFilePath() {
        return (String) getAttributeInternal(FILEPATH);
    }

    /**
     * Sets <code>value</code> as attribute value for FILE_PATH using the alias name FilePath.
     * @param value value to set the FILE_PATH
     */
    public void setFilePath(String value) {
        setAttributeInternal(FILEPATH, value);
    }

    /**
     * Gets the attribute value for CONTENT_TYPE using the alias name ContentType.
     * @return the CONTENT_TYPE
     */
    public String getContentType() {
        return (String) getAttributeInternal(CONTENTTYPE);
    }

    /**
     * Sets <code>value</code> as attribute value for CONTENT_TYPE using the alias name ContentType.
     * @param value value to set the CONTENT_TYPE
     */
    public void setContentType(String value) {
        setAttributeInternal(CONTENTTYPE, value);
    }

    /**
     * Gets the attribute value for IMAGE_FILE using the alias name ImageFile.
     * @return the IMAGE_FILE
     */
    public String getImageFile() {
        return (String) getAttributeInternal(IMAGEFILE);
    }

    /**
     * Sets <code>value</code> as attribute value for IMAGE_FILE using the alias name ImageFile.
     * @param value value to set the IMAGE_FILE
     */
    public void setImageFile(String value) {
        setAttributeInternal(IMAGEFILE, value);
    }

    /**
     * Gets the attribute value for IMAGE_NAME using the alias name ImageName.
     * @return the IMAGE_NAME
     */
    public String getImageName() {
        return (String) getAttributeInternal(IMAGENAME);
    }

    /**
     * Sets <code>value</code> as attribute value for IMAGE_NAME using the alias name ImageName.
     * @param value value to set the IMAGE_NAME
     */
    public void setImageName(String value) {
        setAttributeInternal(IMAGENAME, value);
    }

    /**
     * Gets the attribute value for IMAGE_PATH using the alias name ImagePath.
     * @return the IMAGE_PATH
     */
    public String getImagePath() {
        return (String) getAttributeInternal(IMAGEPATH);
    }

    /**
     * Sets <code>value</code> as attribute value for IMAGE_PATH using the alias name ImagePath.
     * @param value value to set the IMAGE_PATH
     */
    public void setImagePath(String value) {
        setAttributeInternal(IMAGEPATH, value);
    }

    /**
     * Gets the attribute value for URL_PATH using the alias name UrlPath.
     * @return the URL_PATH
     */
    public String getUrlPath() {
        return (String) getAttributeInternal(URLPATH);
    }

    /**
     * Sets <code>value</code> as attribute value for URL_PATH using the alias name UrlPath.
     * @param value value to set the URL_PATH
     */
    public void setUrlPath(String value) {
        setAttributeInternal(URLPATH, value);
    }

    /**
     * Gets the attribute value for "COMMENT" using the alias name Comment.
     * @return the "COMMENT"
     */
    public String getComment() {
        return (String) getAttributeInternal(COMMENT);
    }

    /**
     * Sets <code>value</code> as attribute value for "COMMENT" using the alias name Comment.
     * @param value value to set the "COMMENT"
     */
    public void setComment(String value) {
        setAttributeInternal(COMMENT, value);
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
     * Gets the attribute value for the calculated attribute CreatedByAttr.
     * @return the CreatedByAttr
     
    public String getCreatedByAttr() {
        return (String) getAttributeInternal(CREATEDBYATTR);
    }
*/
    /**
     * Gets the attribute value for the calculated attribute LastUpdatedByAttr.
     * @return the LastUpdatedByAttr
     
    public String getLastUpdatedByAttr() {
        return (String) getAttributeInternal(LASTUPDATEDBYATTR);
    }
*/
    /**
     * Gets the view accessor <code>RowSet</code> FndUsersAllLov1.
     */
    public RowSet getFndUsersAllLov1() {
        return (RowSet) getAttributeInternal(FNDUSERSALLLOV1);
    }
    

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute CreatedByAttr.
     * @param value value to set the  CreatedByAttr
     */
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

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute CreatedByAttr.
     * @param value value to set the  CreatedByAttr
     */
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

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute LastUpdatedByAttr.
     * @param value value to set the  LastUpdatedByAttr
     */
    public void setLastUpdatedByAttr(String value) {
        setAttributeInternal(LASTUPDATEDBYATTR, value);
    }
}
