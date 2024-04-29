package com.rmi.applicationEntry.adfbc.entities;

import com.rmi.applicationEntry.adfbc.extensions.CustomEntity;

import java.math.BigDecimal;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;

import oracle.jbo.AttributeList;
import oracle.jbo.Key;
import oracle.jbo.server.EntityDefImpl;
import oracle.jbo.server.EntityImpl;
import oracle.jbo.server.SequenceImpl;
import oracle.jbo.server.TransactionEvent;
// ---------------------------------------------------------------------
// ---    File generated by Oracle ADF Business Components Design Time.
// ---    Mon Jan 21 22:33:54 IST 2019
// ---    Custom code may be added to this class.
// ---    Warning: Do not modify method signatures of generated methods.
// ---------------------------------------------------------------------
public class IRIEdocsHeaderImpl extends EntityImpl {
    /**
     * AttributesEnum: generated enum for identifying attributes and accessors. DO NOT MODIFY.
     */
    public enum AttributesEnum {
        IeHeaderId,
        OutputFilename,
        FileId,
        SourceTable,
        SourceColumn,
        SourceId;
        private static AttributesEnum[] vals = null;
        private static final int firstIndex = 0;

        public int index() {
            return IRIEdocsHeaderImpl.AttributesEnum.firstIndex() + ordinal();
        }

        public static final int firstIndex() {
            return firstIndex;
        }

        public static int count() {
            return IRIEdocsHeaderImpl.AttributesEnum.firstIndex() +
                   IRIEdocsHeaderImpl.AttributesEnum.staticValues().length;
        }

        public static final AttributesEnum[] staticValues() {
            if (vals == null) {
                vals = IRIEdocsHeaderImpl.AttributesEnum.values();
            }
            return vals;
        }
    }
    public static final int IEHEADERID = AttributesEnum.IeHeaderId.index();
    public static final int OUTPUTFILENAME = AttributesEnum.OutputFilename.index();
    public static final int FILEID = AttributesEnum.FileId.index();
    public static final int SOURCETABLE = AttributesEnum.SourceTable.index();
    public static final int SOURCECOLUMN = AttributesEnum.SourceColumn.index();
    public static final int SOURCEID = AttributesEnum.SourceId.index();

    /**
     * This is the default constructor (do not remove).
     */
    public IRIEdocsHeaderImpl() {
    }

    /**
     * Gets the attribute value for IeHeaderId, using the alias name IeHeaderId.
     * @return the value of IeHeaderId
     */
    public Integer getIeHeaderId() {
        return (Integer) getAttributeInternal(IEHEADERID);
    }

    /**
     * Sets <code>value</code> as the attribute value for IeHeaderId.
     * @param value value to set the IeHeaderId
     */
    public void setIeHeaderId(Integer value) {
        setAttributeInternal(IEHEADERID, value);
    }

    /**
     * Gets the attribute value for OutputFilename, using the alias name OutputFilename.
     * @return the value of OutputFilename
     */
    public String getOutputFilename() {
        return (String) getAttributeInternal(OUTPUTFILENAME);
    }

    /**
     * Sets <code>value</code> as the attribute value for OutputFilename.
     * @param value value to set the OutputFilename
     */
    public void setOutputFilename(String value) {
        setAttributeInternal(OUTPUTFILENAME, value);
    }

    /**
     * Gets the attribute value for FileId, using the alias name FileId.
     * @return the value of FileId
     */
    public BigDecimal getFileId() {
        return (BigDecimal) getAttributeInternal(FILEID);
    }

    /**
     * Sets <code>value</code> as the attribute value for FileId.
     * @param value value to set the FileId
     */
    public void setFileId(BigDecimal value) {
        setAttributeInternal(FILEID, value);
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
     * Gets the attribute value for SourceColumn, using the alias name SourceColumn.
     * @return the value of SourceColumn
     */
    public String getSourceColumn() {
        return (String) getAttributeInternal(SOURCECOLUMN);
    }

    /**
     * Sets <code>value</code> as the attribute value for SourceColumn.
     * @param value value to set the SourceColumn
     */
    public void setSourceColumn(String value) {
        setAttributeInternal(SOURCECOLUMN, value);
    }

    /**
     * Gets the attribute value for SourceId, using the alias name SourceId.
     * @return the value of SourceId
     */
    public Integer getSourceId() {
        return (Integer) getAttributeInternal(SOURCEID);
    }

    /**
     * Sets <code>value</code> as the attribute value for SourceId.
     * @param value value to set the SourceId
     */
    public void setSourceId(Integer value) {
        setAttributeInternal(SOURCEID, value);
    }

    /**
     * @param ieHeaderId key constituent

     * @return a Key object based on given key constituents.
     */
    public static Key createPrimaryKey(Integer ieHeaderId) {
        return new Key(new Object[] { ieHeaderId });
    }

    /**
     * @return the definition object for this instance class.
     */
    public static synchronized EntityDefImpl getDefinitionObject() {
        return EntityDefImpl.findDefObject("com.rmi.applicationEntry.adfbc.entities.IRIEdocsHeader");
    }

    /**
     * Add attribute defaulting logic in this method.
     * @param attributeList list of attribute names/values to initialize the row
     */
    protected void create(AttributeList attributeList) {
        try {
            SequenceImpl s = new SequenceImpl("id_header_id_seq", getDBTransaction());
            Integer no = Integer.parseInt(s.getSequenceNumber().toString());
            setIeHeaderId(no);
            super.create(attributeList);
        } catch (Exception e) {
            addFormattedFacesErrorMessage("System encountered an exception while uploading document." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
        }
    }
    public static void addFormattedFacesErrorMessage(String header, String detail,
                                                 javax.faces.application.FacesMessage.Severity severity) 
    {
        StringBuilder saveMsg = new StringBuilder("<html><body><b><span style='color:");
        
        if(severity != null)
        {
            if(severity.toString().equalsIgnoreCase("INFO 0"))
                saveMsg.append("#000000'>");
            else if(severity.toString().equalsIgnoreCase("WARN 1"))
                saveMsg.append("#000000'>");
            else if(severity.toString().equalsIgnoreCase("ERROR 2"))
                saveMsg.append("#000000'>");
            else
                saveMsg.append("#000000'>");
        }
        else
            saveMsg.append("#000000'>");
        
        saveMsg.append(header);
        saveMsg.append("</span></b>");
        saveMsg.append("</br><b>");
    //        saveMsg.append(detail);
        saveMsg.append("</b></body></html>");
        FacesMessage msg = new FacesMessage(saveMsg.toString());
        msg.setSeverity(severity);
        FacesContext.getCurrentInstance().addMessage(null, msg);
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
    protected void doDML(int operation, TransactionEvent e) {
        super.doDML(operation, e);
    }
}

