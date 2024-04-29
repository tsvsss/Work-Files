package com.rmi.tradecompapproval.adfbc.views.lovs;

import oracle.jbo.server.ViewRowImpl;
// ---------------------------------------------------------------------
// ---    File generated by Oracle ADF Business Components Design Time.
// ---    Thu May 07 14:02:50 IST 2020
// ---    Custom code may be added to this class.
// ---    Warning: Do not modify method signatures of generated methods.
// ---------------------------------------------------------------------
public class MultipleHoldReasonsViewRowImpl extends ViewRowImpl {
    /**
     * AttributesEnum: generated enum for identifying attributes and accessors. DO NOT MODIFY.
     */
    public enum AttributesEnum {
        SlNo,
        Code,
        DisplayValue,
        Description,
        TransSelectReason;
        private static AttributesEnum[] vals = null;
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


    public static final int SLNO = AttributesEnum.SlNo.index();
    public static final int CODE = AttributesEnum.Code.index();
    public static final int DISPLAYVALUE = AttributesEnum.DisplayValue.index();
    public static final int DESCRIPTION = AttributesEnum.Description.index();
    public static final int TRANSSELECTREASON = AttributesEnum.TransSelectReason.index();

    /**
     * This is the default constructor (do not remove).
     */
    public MultipleHoldReasonsViewRowImpl() {
    }

    /**
     * Gets the attribute value for the calculated attribute SlNo.
     * @return the SlNo
     */
    public Integer getSlNo() {
        return (Integer) getAttributeInternal(SLNO);
    }

    /**
     * Gets the attribute value for the calculated attribute Code.
     * @return the Code
     */
    public Integer getCode() {
        return (Integer) getAttributeInternal(CODE);
    }

    /**
     * Gets the attribute value for the calculated attribute DisplayValue.
     * @return the DisplayValue
     */
    public String getDisplayValue() {
        return (String) getAttributeInternal(DISPLAYVALUE);
    }

    /**
     * Gets the attribute value for the calculated attribute Description.
     * @return the Description
     */
    public String getDescription() {
        return (String) getAttributeInternal(DESCRIPTION);
    }

    /**
     * Gets the attribute value for the calculated attribute TransSelectReason.
     * @return the TransSelectReason
     */
    public String getTransSelectReason() {
        return (String) getAttributeInternal(TRANSSELECTREASON);
    }

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute TransSelectReason.
     * @param value value to set the  TransSelectReason
     */
    public void setTransSelectReason(String value) {
        setAttributeInternal(TRANSSELECTREASON, value);
    }
}

