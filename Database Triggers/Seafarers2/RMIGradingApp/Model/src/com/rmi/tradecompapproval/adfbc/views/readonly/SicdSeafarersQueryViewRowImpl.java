package com.rmi.tradecompapproval.adfbc.views.readonly;

import java.math.BigDecimal;
import java.math.BigInteger;

import java.sql.Timestamp;

import oracle.jbo.server.ViewRowImpl;
// ---------------------------------------------------------------------
// ---    File generated by Oracle ADF Business Components Design Time.
// ---    Thu Dec 27 15:30:39 IST 2018
// ---    Custom code may be added to this class.
// ---    Warning: Do not modify method signatures of generated methods.
// ---------------------------------------------------------------------
public class SicdSeafarersQueryViewRowImpl extends ViewRowImpl {
    /**
     * AttributesEnum: generated enum for identifying attributes and accessors. DO NOT MODIFY.
     */
    public enum AttributesEnum {
        SeafarerId,
        LastName,
        FirstName,
        MiddleInitial,
        BirthDate,
        BirthPlace,
        Nationality,
        Status,
        HeightFt,
        HeightIn,
        WeightLb,
        HairColor,
        EyeColor,
        Gender,
        DistinguishingMarks,
        Notes,
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
        DataVerifiedDate,
        DataVerifiedBy,
        TransUseSelected,
        TransPhotoLink;
        private static AttributesEnum[] vals = null;
        private static final int firstIndex = 0;

        public int index() {
            return com.rmi.tradecompapproval.adfbc.views.readonly.SicdSeafarersQueryViewRowImpl.AttributesEnum.firstIndex() + ordinal();
        }

        public static final int firstIndex() {
            return firstIndex;
        }

        public static int count() {
            return com.rmi.tradecompapproval.adfbc.views.readonly.SicdSeafarersQueryViewRowImpl.AttributesEnum.firstIndex() +
                   com.rmi.tradecompapproval.adfbc.views.readonly.SicdSeafarersQueryViewRowImpl.AttributesEnum.staticValues().length;
        }

        public static final AttributesEnum[] staticValues() {
            if (vals == null) {
                vals =
                    com.rmi.tradecompapproval.adfbc.views.readonly.SicdSeafarersQueryViewRowImpl.AttributesEnum.values();
            }
            return vals;
        }
    }

    public static final int SEAFARERID = AttributesEnum.SeafarerId.index();
    public static final int LASTNAME = AttributesEnum.LastName.index();
    public static final int FIRSTNAME = AttributesEnum.FirstName.index();
    public static final int MIDDLEINITIAL = AttributesEnum.MiddleInitial.index();
    public static final int BIRTHDATE = AttributesEnum.BirthDate.index();
    public static final int BIRTHPLACE = AttributesEnum.BirthPlace.index();
    public static final int NATIONALITY = AttributesEnum.Nationality.index();
    public static final int STATUS = AttributesEnum.Status.index();
    public static final int HEIGHTFT = AttributesEnum.HeightFt.index();
    public static final int HEIGHTIN = AttributesEnum.HeightIn.index();
    public static final int WEIGHTLB = AttributesEnum.WeightLb.index();
    public static final int HAIRCOLOR = AttributesEnum.HairColor.index();
    public static final int EYECOLOR = AttributesEnum.EyeColor.index();
    public static final int GENDER = AttributesEnum.Gender.index();
    public static final int DISTINGUISHINGMARKS = AttributesEnum.DistinguishingMarks.index();
    public static final int NOTES = AttributesEnum.Notes.index();
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
    public static final int DATAVERIFIEDDATE = AttributesEnum.DataVerifiedDate.index();
    public static final int DATAVERIFIEDBY = AttributesEnum.DataVerifiedBy.index();
    public static final int TRANSUSESELECTED = AttributesEnum.TransUseSelected.index();
    public static final int TRANSPHOTOLINK = AttributesEnum.TransPhotoLink.index();

    /**
     * This is the default constructor (do not remove).
     */
    public SicdSeafarersQueryViewRowImpl() {
    }

    /**
     * Gets the attribute value for the calculated attribute SeafarerId.
     * @return the SeafarerId
     */
    public Integer getSeafarerId() {
        return (Integer) getAttributeInternal(SEAFARERID);
    }

    /**
     * Gets the attribute value for the calculated attribute LastName.
     * @return the LastName
     */
    public String getLastName() {
        return (String) getAttributeInternal(LASTNAME);
    }

    /**
     * Gets the attribute value for the calculated attribute FirstName.
     * @return the FirstName
     */
    public String getFirstName() {
        return (String) getAttributeInternal(FIRSTNAME);
    }

    /**
     * Gets the attribute value for the calculated attribute MiddleInitial.
     * @return the MiddleInitial
     */
    public String getMiddleInitial() {
        return (String) getAttributeInternal(MIDDLEINITIAL);
    }

    /**
     * Gets the attribute value for the calculated attribute BirthDate.
     * @return the BirthDate
     */
    public Timestamp getBirthDate() {
        return (Timestamp) getAttributeInternal(BIRTHDATE);
    }

    /**
     * Gets the attribute value for the calculated attribute BirthPlace.
     * @return the BirthPlace
     */
    public String getBirthPlace() {
        return (String) getAttributeInternal(BIRTHPLACE);
    }

    /**
     * Gets the attribute value for the calculated attribute Nationality.
     * @return the Nationality
     */
    public String getNationality() {
        return (String) getAttributeInternal(NATIONALITY);
    }

    /**
     * Gets the attribute value for the calculated attribute Status.
     * @return the Status
     */
    public String getStatus() {
        return (String) getAttributeInternal(STATUS);
    }

    /**
     * Gets the attribute value for the calculated attribute HeightFt.
     * @return the HeightFt
     */
    public Integer getHeightFt() {
        return (Integer) getAttributeInternal(HEIGHTFT);
    }

    /**
     * Gets the attribute value for the calculated attribute HeightIn.
     * @return the HeightIn
     */
    public Integer getHeightIn() {
        return (Integer) getAttributeInternal(HEIGHTIN);
    }

    /**
     * Gets the attribute value for the calculated attribute WeightLb.
     * @return the WeightLb
     */
    public Integer getWeightLb() {
        return (Integer) getAttributeInternal(WEIGHTLB);
    }

    /**
     * Gets the attribute value for the calculated attribute HairColor.
     * @return the HairColor
     */
    public String getHairColor() {
        return (String) getAttributeInternal(HAIRCOLOR);
    }

    /**
     * Gets the attribute value for the calculated attribute EyeColor.
     * @return the EyeColor
     */
    public String getEyeColor() {
        return (String) getAttributeInternal(EYECOLOR);
    }

    /**
     * Gets the attribute value for the calculated attribute Gender.
     * @return the Gender
     */
    public String getGender() {
        return (String) getAttributeInternal(GENDER);
    }

    /**
     * Gets the attribute value for the calculated attribute DistinguishingMarks.
     * @return the DistinguishingMarks
     */
    public String getDistinguishingMarks() {
        return (String) getAttributeInternal(DISTINGUISHINGMARKS);
    }

    /**
     * Gets the attribute value for the calculated attribute Notes.
     * @return the Notes
     */
    public String getNotes() {
        return (String) getAttributeInternal(NOTES);
    }

    /**
     * Gets the attribute value for the calculated attribute CreatedBy.
     * @return the CreatedBy
     */
    public Long getCreatedBy() {
        return (Long) getAttributeInternal(CREATEDBY);
    }

    /**
     * Gets the attribute value for the calculated attribute CreationDate.
     * @return the CreationDate
     */
    public Timestamp getCreationDate() {
        return (Timestamp) getAttributeInternal(CREATIONDATE);
    }

    /**
     * Gets the attribute value for the calculated attribute LastUpdatedBy.
     * @return the LastUpdatedBy
     */
    public Long getLastUpdatedBy() {
        return (Long) getAttributeInternal(LASTUPDATEDBY);
    }

    /**
     * Gets the attribute value for the calculated attribute LastUpdateDate.
     * @return the LastUpdateDate
     */
    public Timestamp getLastUpdateDate() {
        return (Timestamp) getAttributeInternal(LASTUPDATEDATE);
    }

    /**
     * Gets the attribute value for the calculated attribute LastUpdateLogin.
     * @return the LastUpdateLogin
     */
    public Long getLastUpdateLogin() {
        return (Long) getAttributeInternal(LASTUPDATELOGIN);
    }

    /**
     * Gets the attribute value for the calculated attribute AttributeCategory.
     * @return the AttributeCategory
     */
    public String getAttributeCategory() {
        return (String) getAttributeInternal(ATTRIBUTECATEGORY);
    }

    /**
     * Gets the attribute value for the calculated attribute Attribute1.
     * @return the Attribute1
     */
    public String getAttribute1() {
        return (String) getAttributeInternal(ATTRIBUTE1);
    }

    /**
     * Gets the attribute value for the calculated attribute Attribute2.
     * @return the Attribute2
     */
    public String getAttribute2() {
        return (String) getAttributeInternal(ATTRIBUTE2);
    }

    /**
     * Gets the attribute value for the calculated attribute Attribute3.
     * @return the Attribute3
     */
    public String getAttribute3() {
        return (String) getAttributeInternal(ATTRIBUTE3);
    }

    /**
     * Gets the attribute value for the calculated attribute Attribute4.
     * @return the Attribute4
     */
    public String getAttribute4() {
        return (String) getAttributeInternal(ATTRIBUTE4);
    }

    /**
     * Gets the attribute value for the calculated attribute Attribute5.
     * @return the Attribute5
     */
    public String getAttribute5() {
        return (String) getAttributeInternal(ATTRIBUTE5);
    }

    /**
     * Gets the attribute value for the calculated attribute Attribute6.
     * @return the Attribute6
     */
    public String getAttribute6() {
        return (String) getAttributeInternal(ATTRIBUTE6);
    }

    /**
     * Gets the attribute value for the calculated attribute Attribute7.
     * @return the Attribute7
     */
    public String getAttribute7() {
        return (String) getAttributeInternal(ATTRIBUTE7);
    }

    /**
     * Gets the attribute value for the calculated attribute Attribute8.
     * @return the Attribute8
     */
    public String getAttribute8() {
        return (String) getAttributeInternal(ATTRIBUTE8);
    }

    /**
     * Gets the attribute value for the calculated attribute Attribute9.
     * @return the Attribute9
     */
    public String getAttribute9() {
        return (String) getAttributeInternal(ATTRIBUTE9);
    }

    /**
     * Gets the attribute value for the calculated attribute Attribute10.
     * @return the Attribute10
     */
    public String getAttribute10() {
        return (String) getAttributeInternal(ATTRIBUTE10);
    }

    /**
     * Gets the attribute value for the calculated attribute Attribute11.
     * @return the Attribute11
     */
    public String getAttribute11() {
        return (String) getAttributeInternal(ATTRIBUTE11);
    }

    /**
     * Gets the attribute value for the calculated attribute Attribute12.
     * @return the Attribute12
     */
    public String getAttribute12() {
        return (String) getAttributeInternal(ATTRIBUTE12);
    }

    /**
     * Gets the attribute value for the calculated attribute Attribute13.
     * @return the Attribute13
     */
    public String getAttribute13() {
        return (String) getAttributeInternal(ATTRIBUTE13);
    }

    /**
     * Gets the attribute value for the calculated attribute Attribute14.
     * @return the Attribute14
     */
    public String getAttribute14() {
        return (String) getAttributeInternal(ATTRIBUTE14);
    }

    /**
     * Gets the attribute value for the calculated attribute Attribute15.
     * @return the Attribute15
     */
    public String getAttribute15() {
        return (String) getAttributeInternal(ATTRIBUTE15);
    }

    /**
     * Gets the attribute value for the calculated attribute DataVerifiedDate.
     * @return the DataVerifiedDate
     */
    public Timestamp getDataVerifiedDate() {
        return (Timestamp) getAttributeInternal(DATAVERIFIEDDATE);
    }

    /**
     * Gets the attribute value for the calculated attribute DataVerifiedBy.
     * @return the DataVerifiedBy
     */
    public BigDecimal getDataVerifiedBy() {
        return (BigDecimal) getAttributeInternal(DATAVERIFIEDBY);
    }

    /**
     * Gets the attribute value for the calculated attribute TransUseSelected.
     * @return the TransUseSelected
     */
    public String getTransUseSelected() {
        return (String) getAttributeInternal(TRANSUSESELECTED);
    }

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute TransUseSelected.
     * @param value value to set the  TransUseSelected
     */
    public void setTransUseSelected(String value) 
    {
        setAttributeInternal(TRANSUSESELECTED, value);
    }

    /**
     * Gets the attribute value for the calculated attribute TransPhotoLink.
     * @return the TransPhotoLink
     */
    public String getTransPhotoLink() {
        return (String) getAttributeInternal(TRANSPHOTOLINK);
    }

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute TransPhotoLink.
     * @param value value to set the  TransPhotoLink
     */
    public void setTransPhotoLink(String value) {
        setAttributeInternal(TRANSPHOTOLINK, value);
    }
}
