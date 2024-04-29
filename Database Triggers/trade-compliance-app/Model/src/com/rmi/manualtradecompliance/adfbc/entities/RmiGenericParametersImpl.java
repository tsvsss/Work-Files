package com.rmi.manualtradecompliance.adfbc.entities;

import java.math.BigDecimal;

import java.sql.Timestamp;

import oracle.adf.share.ADFContext;

import oracle.jbo.AttributeList;
import oracle.jbo.Key;
import oracle.jbo.server.AttributeDefImpl;
import oracle.jbo.server.EntityDefImpl;
import oracle.jbo.server.EntityImpl;
// ---------------------------------------------------------------------
// ---    File generated by Oracle ADF Business Components Design Time.
// ---    Fri Jun 18 15:58:53 IST 2021
// ---    Custom code may be added to this class.
// ---    Warning: Do not modify method signatures of generated methods.
// ---------------------------------------------------------------------
public class RmiGenericParametersImpl extends EntityImpl {
    /**
     * AttributesEnum: generated enum for identifying attributes and accessors. DO NOT MODIFY.
     */
    public enum AttributesEnum {
        Id {
            public Object get(RmiGenericParametersImpl obj) {
                return obj.getId();
            }

            public void put(RmiGenericParametersImpl obj, Object value) {
                obj.setId((String) value);
            }
        }
        ,
        OptionKey {
            public Object get(RmiGenericParametersImpl obj) {
                return obj.getOptionKey();
            }

            public void put(RmiGenericParametersImpl obj, Object value) {
                obj.setOptionKey((String) value);
            }
        }
        ,
        OptionValue {
            public Object get(RmiGenericParametersImpl obj) {
                return obj.getOptionValue();
            }

            public void put(RmiGenericParametersImpl obj, Object value) {
                obj.setOptionValue((String) value);
            }
        }
        ,
        Description {
            public Object get(RmiGenericParametersImpl obj) {
                return obj.getDescription();
            }

            public void put(RmiGenericParametersImpl obj, Object value) {
                obj.setDescription((String) value);
            }
        }
        ,
        CreatedBy {
            public Object get(RmiGenericParametersImpl obj) {
                return obj.getCreatedBy();
            }

            public void put(RmiGenericParametersImpl obj, Object value) {
                obj.setCreatedBy((BigDecimal) value);
            }
        }
        ,
        CreationDate {
            public Object get(RmiGenericParametersImpl obj) {
                return obj.getCreationDate();
            }

            public void put(RmiGenericParametersImpl obj, Object value) {
                obj.setCreationDate((Timestamp) value);
            }
        }
        ,
        Enabled {
            public Object get(RmiGenericParametersImpl obj) {
                return obj.getEnabled();
            }

            public void put(RmiGenericParametersImpl obj, Object value) {
                obj.setEnabled((String) value);
            }
        }
        ;
        static AttributesEnum[] vals = null;
        ;
        private static final int firstIndex = 0;

        public abstract Object get(RmiGenericParametersImpl object);

        public abstract void put(RmiGenericParametersImpl object, Object value);

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
    public static final int OPTIONKEY = AttributesEnum.OptionKey.index();
    public static final int OPTIONVALUE = AttributesEnum.OptionValue.index();
    public static final int DESCRIPTION = AttributesEnum.Description.index();
    public static final int CREATEDBY = AttributesEnum.CreatedBy.index();
    public static final int CREATIONDATE = AttributesEnum.CreationDate.index();
    public static final int ENABLED = AttributesEnum.Enabled.index();

    /**
     * This is the default constructor (do not remove).
     */
    public RmiGenericParametersImpl() {
    }

    /**
     * @return the definition object for this instance class.
     */
    public static synchronized EntityDefImpl getDefinitionObject() {
        return EntityDefImpl.findDefObject("com.rmi.manualtradecompliance.adfbc.entities.RmiGenericParameters");
    }


    /**
     * Gets the attribute value for Id, using the alias name Id.
     * @return the value of Id
     */
    public String getId() {
        return (String) getAttributeInternal(ID);
    }

    /**
     * Sets <code>value</code> as the attribute value for Id.
     * @param value value to set the Id
     */
    public void setId(String value) {
        setAttributeInternal(ID, value);
    }

    /**
     * Gets the attribute value for OptionKey, using the alias name OptionKey.
     * @return the value of OptionKey
     */
    public String getOptionKey() {
        return (String) getAttributeInternal(OPTIONKEY);
    }

    /**
     * Sets <code>value</code> as the attribute value for OptionKey.
     * @param value value to set the OptionKey
     */
    public void setOptionKey(String value) {
        setAttributeInternal(OPTIONKEY, value);
    }

    /**
     * Gets the attribute value for OptionValue, using the alias name OptionValue.
     * @return the value of OptionValue
     */
    public String getOptionValue() {
        return (String) getAttributeInternal(OPTIONVALUE);
    }

    /**
     * Sets <code>value</code> as the attribute value for OptionValue.
     * @param value value to set the OptionValue
     */
    public void setOptionValue(String value) {
        setAttributeInternal(OPTIONVALUE, value);
    }

    /**
     * Gets the attribute value for Description, using the alias name Description.
     * @return the value of Description
     */
    public String getDescription() {
        return (String) getAttributeInternal(DESCRIPTION);
    }

    /**
     * Sets <code>value</code> as the attribute value for Description.
     * @param value value to set the Description
     */
    public void setDescription(String value) {
        setAttributeInternal(DESCRIPTION, value);
    }

    /**
     * Gets the attribute value for CreatedBy, using the alias name CreatedBy.
     * @return the value of CreatedBy
     */
    public BigDecimal getCreatedBy() {
        return (BigDecimal) getAttributeInternal(CREATEDBY);
    }

    /**
     * Sets <code>value</code> as the attribute value for CreatedBy.
     * @param value value to set the CreatedBy
     */
    public void setCreatedBy(BigDecimal value) {
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
     * Gets the attribute value for Enabled, using the alias name Enabled.
     * @return the value of Enabled
     */
    public String getEnabled() {
        return (String) getAttributeInternal(ENABLED);
    }

    /**
     * Sets <code>value</code> as the attribute value for Enabled.
     * @param value value to set the Enabled
     */
    public void setEnabled(String value) {
        setAttributeInternal(ENABLED, value);
    }

    /**
     * getAttrInvokeAccessor: generated method. Do not modify.
     * @param index the index identifying the attribute
     * @param attrDef the attribute

     * @return the attribute value
     * @throws Exception
     */
    protected Object getAttrInvokeAccessor(int index, AttributeDefImpl attrDef) throws Exception {
        if ((index >= AttributesEnum.firstIndex()) && (index < AttributesEnum.count())) {
            return AttributesEnum.staticValues()[index - AttributesEnum.firstIndex()].get(this);
        }
        return super.getAttrInvokeAccessor(index, attrDef);
    }

    /**
     * setAttrInvokeAccessor: generated method. Do not modify.
     * @param index the index identifying the attribute
     * @param value the value to assign to the attribute
     * @param attrDef the attribute

     * @throws Exception
     */
    protected void setAttrInvokeAccessor(int index, Object value, AttributeDefImpl attrDef) throws Exception {
        if ((index >= AttributesEnum.firstIndex()) && (index < AttributesEnum.count())) {
            AttributesEnum.staticValues()[index - AttributesEnum.firstIndex()].put(this, value);
            return;
        }
        super.setAttrInvokeAccessor(index, value, attrDef);
    }


    /**
     * @param optionKey key constituent

     * @return a Key object based on given key constituents.
     */
    public static Key createPrimaryKey(String optionKey) {
        return new Key(new Object[] { optionKey });
    }

    /**
     * Add attribute defaulting logic in this method.
     * @param attributeList list of attribute names/values to initialize the row
     */
    protected void create(AttributeList attributeList) {
        super.create(attributeList);
        
        try {
            Integer userId = (Integer) ADFContext.getCurrent().getSessionScope().get("UserId");
            Timestamp time = new Timestamp(System.currentTimeMillis());

            if (userId != null) {
                this.setCreatedBy(new BigDecimal(userId));
            }
            this.setCreationDate(time);
        } catch (Exception e) {
            // TODO: Add catch code
            e.printStackTrace();
        }
    }
}

