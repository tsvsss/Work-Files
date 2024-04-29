package com.rmi.tradecompapproval.adfbc.views;

import com.rmi.tradecompapproval.adfbc.services.RMITradeCompApprovalAppModuleImpl;
import com.rmi.tradecompapproval.adfbc.entities.SicdRolesImpl;

import com.rmi.tradecompapproval.adfbc.utils.AdfUtils;

import java.math.BigDecimal;

import java.sql.Timestamp;

import javax.faces.application.FacesMessage;

import oracle.jbo.Row;
import oracle.jbo.RowSet;
import oracle.jbo.server.ViewObjectImpl;
import oracle.jbo.server.ViewRowImpl;
// ---------------------------------------------------------------------
// ---    File generated by Oracle ADF Business Components Design Time.
// ---    Fri Nov 30 16:47:55 IST 2018
// ---    Custom code may be added to this class.
// ---    Warning: Do not modify method signatures of generated methods.
// ---------------------------------------------------------------------
public class SqcDetailsCapacitiesViewRowImpl extends ViewRowImpl {


    public static final int ENTITY_SICDROLESEO = 0;

    /**
     * AttributesEnum: generated enum for identifying attributes and accessors. DO NOT MODIFY.
     */
    public enum AttributesEnum {
        Attribute1,
        Attribute10,
        Attribute11,
        Attribute12,
        Attribute13,
        Attribute14,
        Attribute15,
        Attribute2,
        Attribute3,
        Attribute4,
        Attribute5,
        Attribute6,
        Attribute7,
        Attribute8,
        Attribute9,
        AttributeCategory,
        CreatedBy,
        CreationDate,
        DocumentId,
        LastUpdateDate,
        LastUpdateLogin,
        LastUpdatedBy,
        Limitations,
        PositionId,
        RoleId,
        TransSqcCapacities,
        TransSqcLimitations,
        OcDetailsLimitationsLOV1,
        SqcDetailsCapacitiesLovView1;
        static AttributesEnum[] vals = null;
        ;
        private static final int firstIndex = 0;

        public int index() {
            return SqcDetailsCapacitiesViewRowImpl.AttributesEnum.firstIndex() + ordinal();
        }

        public static final int firstIndex() {
            return firstIndex;
        }

        public static int count() {
            return SqcDetailsCapacitiesViewRowImpl.AttributesEnum.firstIndex() +
                   SqcDetailsCapacitiesViewRowImpl.AttributesEnum.staticValues().length;
        }

        public static final AttributesEnum[] staticValues() {
            if (vals == null) {
                vals = SqcDetailsCapacitiesViewRowImpl.AttributesEnum.values();
            }
            return vals;
        }
    }


    public static final int ATTRIBUTE1 = AttributesEnum.Attribute1.index();
    public static final int ATTRIBUTE10 = AttributesEnum.Attribute10.index();
    public static final int ATTRIBUTE11 = AttributesEnum.Attribute11.index();
    public static final int ATTRIBUTE12 = AttributesEnum.Attribute12.index();
    public static final int ATTRIBUTE13 = AttributesEnum.Attribute13.index();
    public static final int ATTRIBUTE14 = AttributesEnum.Attribute14.index();
    public static final int ATTRIBUTE15 = AttributesEnum.Attribute15.index();
    public static final int ATTRIBUTE2 = AttributesEnum.Attribute2.index();
    public static final int ATTRIBUTE3 = AttributesEnum.Attribute3.index();
    public static final int ATTRIBUTE4 = AttributesEnum.Attribute4.index();
    public static final int ATTRIBUTE5 = AttributesEnum.Attribute5.index();
    public static final int ATTRIBUTE6 = AttributesEnum.Attribute6.index();
    public static final int ATTRIBUTE7 = AttributesEnum.Attribute7.index();
    public static final int ATTRIBUTE8 = AttributesEnum.Attribute8.index();
    public static final int ATTRIBUTE9 = AttributesEnum.Attribute9.index();
    public static final int ATTRIBUTECATEGORY = AttributesEnum.AttributeCategory.index();
    public static final int CREATEDBY = AttributesEnum.CreatedBy.index();
    public static final int CREATIONDATE = AttributesEnum.CreationDate.index();
    public static final int DOCUMENTID = AttributesEnum.DocumentId.index();
    public static final int LASTUPDATEDATE = AttributesEnum.LastUpdateDate.index();
    public static final int LASTUPDATELOGIN = AttributesEnum.LastUpdateLogin.index();
    public static final int LASTUPDATEDBY = AttributesEnum.LastUpdatedBy.index();
    public static final int LIMITATIONS = AttributesEnum.Limitations.index();
    public static final int POSITIONID = AttributesEnum.PositionId.index();
    public static final int ROLEID = AttributesEnum.RoleId.index();
    public static final int TRANSSQCCAPACITIES = AttributesEnum.TransSqcCapacities.index();
    public static final int TRANSSQCLIMITATIONS = AttributesEnum.TransSqcLimitations.index();
    public static final int OCDETAILSLIMITATIONSLOV1 = AttributesEnum.OcDetailsLimitationsLOV1.index();
    public static final int SQCDETAILSCAPACITIESLOVVIEW1 = AttributesEnum.SqcDetailsCapacitiesLovView1.index();

    /**
     * This is the default constructor (do not remove).
     */
    public SqcDetailsCapacitiesViewRowImpl() {
    }

    /**
     * Gets SicdRolesEO entity object.
     * @return the SicdRolesEO
     */
    public SicdRolesImpl getSicdRolesEO() {
        return (SicdRolesImpl) getEntity(ENTITY_SICDROLESEO);
    }

    /**
     * Gets the attribute value for ATTRIBUTE1 using the alias name Attribute1.
     * @return the ATTRIBUTE1
     */
    public String getAttribute1() {
        return (String) getAttributeInternal(ATTRIBUTE1);
    }

    /**
     * Sets <code>value</code> as attribute value for ATTRIBUTE1 using the alias name Attribute1.
     * @param value value to set the ATTRIBUTE1
     */
    public void setAttribute1(String value) {
        setAttributeInternal(ATTRIBUTE1, value);
    }

    /**
     * Gets the attribute value for ATTRIBUTE10 using the alias name Attribute10.
     * @return the ATTRIBUTE10
     */
    public String getAttribute10() {
        return (String) getAttributeInternal(ATTRIBUTE10);
    }

    /**
     * Sets <code>value</code> as attribute value for ATTRIBUTE10 using the alias name Attribute10.
     * @param value value to set the ATTRIBUTE10
     */
    public void setAttribute10(String value) {
        setAttributeInternal(ATTRIBUTE10, value);
    }

    /**
     * Gets the attribute value for ATTRIBUTE11 using the alias name Attribute11.
     * @return the ATTRIBUTE11
     */
    public String getAttribute11() {
        return (String) getAttributeInternal(ATTRIBUTE11);
    }

    /**
     * Sets <code>value</code> as attribute value for ATTRIBUTE11 using the alias name Attribute11.
     * @param value value to set the ATTRIBUTE11
     */
    public void setAttribute11(String value) {
        setAttributeInternal(ATTRIBUTE11, value);
    }

    /**
     * Gets the attribute value for ATTRIBUTE12 using the alias name Attribute12.
     * @return the ATTRIBUTE12
     */
    public String getAttribute12() {
        return (String) getAttributeInternal(ATTRIBUTE12);
    }

    /**
     * Sets <code>value</code> as attribute value for ATTRIBUTE12 using the alias name Attribute12.
     * @param value value to set the ATTRIBUTE12
     */
    public void setAttribute12(String value) {
        setAttributeInternal(ATTRIBUTE12, value);
    }

    /**
     * Gets the attribute value for ATTRIBUTE13 using the alias name Attribute13.
     * @return the ATTRIBUTE13
     */
    public String getAttribute13() {
        return (String) getAttributeInternal(ATTRIBUTE13);
    }

    /**
     * Sets <code>value</code> as attribute value for ATTRIBUTE13 using the alias name Attribute13.
     * @param value value to set the ATTRIBUTE13
     */
    public void setAttribute13(String value) {
        setAttributeInternal(ATTRIBUTE13, value);
    }

    /**
     * Gets the attribute value for ATTRIBUTE14 using the alias name Attribute14.
     * @return the ATTRIBUTE14
     */
    public String getAttribute14() {
        return (String) getAttributeInternal(ATTRIBUTE14);
    }

    /**
     * Sets <code>value</code> as attribute value for ATTRIBUTE14 using the alias name Attribute14.
     * @param value value to set the ATTRIBUTE14
     */
    public void setAttribute14(String value) {
        setAttributeInternal(ATTRIBUTE14, value);
    }

    /**
     * Gets the attribute value for ATTRIBUTE15 using the alias name Attribute15.
     * @return the ATTRIBUTE15
     */
    public String getAttribute15() {
        return (String) getAttributeInternal(ATTRIBUTE15);
    }

    /**
     * Sets <code>value</code> as attribute value for ATTRIBUTE15 using the alias name Attribute15.
     * @param value value to set the ATTRIBUTE15
     */
    public void setAttribute15(String value) {
        setAttributeInternal(ATTRIBUTE15, value);
    }

    /**
     * Gets the attribute value for ATTRIBUTE2 using the alias name Attribute2.
     * @return the ATTRIBUTE2
     */
    public String getAttribute2() {
        return (String) getAttributeInternal(ATTRIBUTE2);
    }

    /**
     * Sets <code>value</code> as attribute value for ATTRIBUTE2 using the alias name Attribute2.
     * @param value value to set the ATTRIBUTE2
     */
    public void setAttribute2(String value) {
        setAttributeInternal(ATTRIBUTE2, value);
    }

    /**
     * Gets the attribute value for ATTRIBUTE3 using the alias name Attribute3.
     * @return the ATTRIBUTE3
     */
    public String getAttribute3() {
        return (String) getAttributeInternal(ATTRIBUTE3);
    }

    /**
     * Sets <code>value</code> as attribute value for ATTRIBUTE3 using the alias name Attribute3.
     * @param value value to set the ATTRIBUTE3
     */
    public void setAttribute3(String value) {
        setAttributeInternal(ATTRIBUTE3, value);
    }

    /**
     * Gets the attribute value for ATTRIBUTE4 using the alias name Attribute4.
     * @return the ATTRIBUTE4
     */
    public String getAttribute4() {
        return (String) getAttributeInternal(ATTRIBUTE4);
    }

    /**
     * Sets <code>value</code> as attribute value for ATTRIBUTE4 using the alias name Attribute4.
     * @param value value to set the ATTRIBUTE4
     */
    public void setAttribute4(String value) {
        setAttributeInternal(ATTRIBUTE4, value);
    }

    /**
     * Gets the attribute value for ATTRIBUTE5 using the alias name Attribute5.
     * @return the ATTRIBUTE5
     */
    public String getAttribute5() {
        return (String) getAttributeInternal(ATTRIBUTE5);
    }

    /**
     * Sets <code>value</code> as attribute value for ATTRIBUTE5 using the alias name Attribute5.
     * @param value value to set the ATTRIBUTE5
     */
    public void setAttribute5(String value) {
        setAttributeInternal(ATTRIBUTE5, value);
    }

    /**
     * Gets the attribute value for ATTRIBUTE6 using the alias name Attribute6.
     * @return the ATTRIBUTE6
     */
    public String getAttribute6() {
        return (String) getAttributeInternal(ATTRIBUTE6);
    }

    /**
     * Sets <code>value</code> as attribute value for ATTRIBUTE6 using the alias name Attribute6.
     * @param value value to set the ATTRIBUTE6
     */
    public void setAttribute6(String value) {
        setAttributeInternal(ATTRIBUTE6, value);
    }

    /**
     * Gets the attribute value for ATTRIBUTE7 using the alias name Attribute7.
     * @return the ATTRIBUTE7
     */
    public String getAttribute7() {
        return (String) getAttributeInternal(ATTRIBUTE7);
    }

    /**
     * Sets <code>value</code> as attribute value for ATTRIBUTE7 using the alias name Attribute7.
     * @param value value to set the ATTRIBUTE7
     */
    public void setAttribute7(String value) {
        setAttributeInternal(ATTRIBUTE7, value);
    }

    /**
     * Gets the attribute value for ATTRIBUTE8 using the alias name Attribute8.
     * @return the ATTRIBUTE8
     */
    public String getAttribute8() {
        return (String) getAttributeInternal(ATTRIBUTE8);
    }

    /**
     * Sets <code>value</code> as attribute value for ATTRIBUTE8 using the alias name Attribute8.
     * @param value value to set the ATTRIBUTE8
     */
    public void setAttribute8(String value) {
        setAttributeInternal(ATTRIBUTE8, value);
    }

    /**
     * Gets the attribute value for ATTRIBUTE9 using the alias name Attribute9.
     * @return the ATTRIBUTE9
     */
    public String getAttribute9() {
        return (String) getAttributeInternal(ATTRIBUTE9);
    }

    /**
     * Sets <code>value</code> as attribute value for ATTRIBUTE9 using the alias name Attribute9.
     * @param value value to set the ATTRIBUTE9
     */
    public void setAttribute9(String value) {
        setAttributeInternal(ATTRIBUTE9, value);
    }

    /**
     * Gets the attribute value for ATTRIBUTE_CATEGORY using the alias name AttributeCategory.
     * @return the ATTRIBUTE_CATEGORY
     */
    public String getAttributeCategory() {
        return (String) getAttributeInternal(ATTRIBUTECATEGORY);
    }

    /**
     * Sets <code>value</code> as attribute value for ATTRIBUTE_CATEGORY using the alias name AttributeCategory.
     * @param value value to set the ATTRIBUTE_CATEGORY
     */
    public void setAttributeCategory(String value) {
        setAttributeInternal(ATTRIBUTECATEGORY, value);
    }

    /**
     * Gets the attribute value for CREATED_BY using the alias name CreatedBy.
     * @return the CREATED_BY
     */
    public Integer getCreatedBy() {
        return (Integer) getAttributeInternal(CREATEDBY);
    }

    /**
     * Sets <code>value</code> as attribute value for CREATED_BY using the alias name CreatedBy.
     * @param value value to set the CREATED_BY
     */
    public void setCreatedBy(Integer value) {
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
     * Gets the attribute value for DOCUMENT_ID using the alias name DocumentId.
     * @return the DOCUMENT_ID
     */
    public BigDecimal getDocumentId() {
        return (BigDecimal) getAttributeInternal(DOCUMENTID);
    }

    /**
     * Sets <code>value</code> as attribute value for DOCUMENT_ID using the alias name DocumentId.
     * @param value value to set the DOCUMENT_ID
     */
    public void setDocumentId(BigDecimal value) {
        setAttributeInternal(DOCUMENTID, value);
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
    public Integer getLastUpdateLogin() {
        return (Integer) getAttributeInternal(LASTUPDATELOGIN);
    }

    /**
     * Sets <code>value</code> as attribute value for LAST_UPDATE_LOGIN using the alias name LastUpdateLogin.
     * @param value value to set the LAST_UPDATE_LOGIN
     */
    public void setLastUpdateLogin(Integer value) {
        setAttributeInternal(LASTUPDATELOGIN, value);
    }

    /**
     * Gets the attribute value for LAST_UPDATED_BY using the alias name LastUpdatedBy.
     * @return the LAST_UPDATED_BY
     */
    public Integer getLastUpdatedBy() {
        return (Integer) getAttributeInternal(LASTUPDATEDBY);
    }

    /**
     * Sets <code>value</code> as attribute value for LAST_UPDATED_BY using the alias name LastUpdatedBy.
     * @param value value to set the LAST_UPDATED_BY
     */
    public void setLastUpdatedBy(Integer value) {
        setAttributeInternal(LASTUPDATEDBY, value);
    }

    /**
     * Gets the attribute value for LIMITATIONS using the alias name Limitations.
     * @return the LIMITATIONS
     */
    public String getLimitations() {
        return (String) getAttributeInternal(LIMITATIONS);
    }

    /**
     * Sets <code>value</code> as attribute value for LIMITATIONS using the alias name Limitations.
     * @param value value to set the LIMITATIONS
     */
    public void setLimitations(String value) {
        setAttributeInternal(LIMITATIONS, value);
    }

    /**
     * Gets the attribute value for POSITION_ID using the alias name PositionId.
     * @return the POSITION_ID
     */
    public BigDecimal getPositionId() {
        return (BigDecimal) getAttributeInternal(POSITIONID);
    }

    /**
     * Sets <code>value</code> as attribute value for POSITION_ID using the alias name PositionId.
     * @param value value to set the POSITION_ID
     */
    public void setPositionId(BigDecimal value) {
        setAttributeInternal(POSITIONID, value);
    }

    /**
     * Gets the attribute value for ROLE_ID using the alias name RoleId.
     * @return the ROLE_ID
     */
    public Integer getRoleId() {
        return (Integer) getAttributeInternal(ROLEID);
    }

    /**
     * Sets <code>value</code> as attribute value for ROLE_ID using the alias name RoleId.
     * @param value value to set the ROLE_ID
     */
    public void setRoleId(Integer value) {
        setAttributeInternal(ROLEID, value);
    }

    /**
     * Gets the attribute value for the calculated attribute TransSqcCapacities.
     * @return the TransSqcCapacities
     */
    public String getTransSqcCapacities()
    {
        try 
        {
            if (getAttributeInternal(TRANSSQCCAPACITIES) == null && getPositionId() != null) {
                ViewObjectImpl capVo = getAm().getSqcDetailsCapacitiesLovView1();

                Row[] frRows = capVo.getFilteredRows("PositionId", getPositionId());

                if (frRows.length > 0 && frRows[0].getAttribute("LCpctCapacityName") != null) {
                    return (String) frRows[0].getAttribute("LCpctCapacityName");
                }
            }
        } catch (Exception e) {
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching data." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        return (String) getAttributeInternal(TRANSSQCCAPACITIES);
    }

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute TransSqcCapacities.
     * @param value value to set the  TransSqcCapacities
     */
    public void setTransSqcCapacities(String value) {
        setAttributeInternal(TRANSSQCCAPACITIES, value);
    }

    /**
     * Gets the attribute value for the calculated attribute TransSqcLimitations.
     * @return the TransSqcLimitations
     */
    public String getTransSqcLimitations() 
    {
        try 
        {
            if (getAttributeInternal(TRANSSQCLIMITATIONS) == null && getLimitations() != null) {
                return getLimitations();
            }
        } catch (Exception e) {
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching data." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        return (String) getAttributeInternal(TRANSSQCLIMITATIONS);
    }

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute TransSqcLimitations.
     * @param value value to set the  TransSqcLimitations
     */
    public void setTransSqcLimitations(String value) {
        setAttributeInternal(TRANSSQCLIMITATIONS, value);
    }

    /**
     * Gets the view accessor <code>RowSet</code> OcDetailsLimitationsLOV1.
     */
    public RowSet getOcDetailsLimitationsLOV1() {
        return (RowSet) getAttributeInternal(OCDETAILSLIMITATIONSLOV1);
    }

    /**
     * Gets the view accessor <code>RowSet</code> SqcDetailsCapacitiesLovView1.
     */
    public RowSet getSqcDetailsCapacitiesLovView1() {
        return (RowSet) getAttributeInternal(SQCDETAILSCAPACITIESLOVVIEW1);
    }

    public RMITradeCompApprovalAppModuleImpl getAm()
    {
        return (RMITradeCompApprovalAppModuleImpl) this.getApplicationModule();
    }
}

