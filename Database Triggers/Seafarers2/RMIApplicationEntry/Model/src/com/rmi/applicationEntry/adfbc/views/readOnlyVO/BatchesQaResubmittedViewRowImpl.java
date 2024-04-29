package com.rmi.applicationEntry.adfbc.views.readOnlyVO;

import java.math.BigDecimal;

import oracle.jbo.domain.Date;
import oracle.jbo.server.ViewRowImpl;
// ---------------------------------------------------------------------
// ---    File generated by Oracle ADF Business Components Design Time.
// ---    Wed May 06 17:58:24 IST 2020
// ---    Custom code may be added to this class.
// ---    Warning: Do not modify method signatures of generated methods.
// ---------------------------------------------------------------------
public class BatchesQaResubmittedViewRowImpl extends ViewRowImpl {
    /**
     * AttributesEnum: generated enum for identifying attributes and accessors. DO NOT MODIFY.
     */
    public enum AttributesEnum {
        EsiBatchId,
        BatchStatus,
        BatchDate,
        BatchName,
        NoOfSeafarer,
        Region,
        RegionId,
        WorkOrderNo,
        OrderType,
        ExpeditedProcessing,
        CraCount,
        CraSentCount,
        tranFinalCra;
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
    public static final int ESIBATCHID = AttributesEnum.EsiBatchId.index();
    public static final int BATCHSTATUS = AttributesEnum.BatchStatus.index();
    public static final int BATCHDATE = AttributesEnum.BatchDate.index();
    public static final int BATCHNAME = AttributesEnum.BatchName.index();
    public static final int NOOFSEAFARER = AttributesEnum.NoOfSeafarer.index();
    public static final int REGION = AttributesEnum.Region.index();
    public static final int REGIONID = AttributesEnum.RegionId.index();
    public static final int WORKORDERNO = AttributesEnum.WorkOrderNo.index();
    public static final int ORDERTYPE = AttributesEnum.OrderType.index();
    public static final int EXPEDITEDPROCESSING = AttributesEnum.ExpeditedProcessing.index();
    public static final int CRACOUNT = AttributesEnum.CraCount.index();
    public static final int CRASENTCOUNT = AttributesEnum.CraSentCount.index();
    public static final int TRANFINALCRA = AttributesEnum.tranFinalCra.index();

    /**
     * This is the default constructor (do not remove).
     */
    public BatchesQaResubmittedViewRowImpl() {
    }

    /**
     * Gets the attribute value for the calculated attribute EsiBatchId.
     * @return the EsiBatchId
     */
    public Integer getEsiBatchId() {
        return (Integer) getAttributeInternal(ESIBATCHID);
    }

    /**
     * Gets the attribute value for the calculated attribute BatchStatus.
     * @return the BatchStatus
     */
    public String getBatchStatus() {
        return (String) getAttributeInternal(BATCHSTATUS);
    }

    /**
     * Gets the attribute value for the calculated attribute BatchDate.
     * @return the BatchDate
     */
    public Date getBatchDate() {
        return (Date) getAttributeInternal(BATCHDATE);
    }

    /**
     * Gets the attribute value for the calculated attribute BatchName.
     * @return the BatchName
     */
    public String getBatchName() {
        return (String) getAttributeInternal(BATCHNAME);
    }

    /**
     * Gets the attribute value for the calculated attribute NoOfSeafarer.
     * @return the NoOfSeafarer
     */
    public Integer getNoOfSeafarer() {
        return (Integer) getAttributeInternal(NOOFSEAFARER);
    }

    /**
     * Gets the attribute value for the calculated attribute Region.
     * @return the Region
     */
    public String getRegion() {
        return (String) getAttributeInternal(REGION);
    }

    /**
     * Gets the attribute value for the calculated attribute RegionId.
     * @return the RegionId
     */
    public BigDecimal getRegionId() {
        return (BigDecimal) getAttributeInternal(REGIONID);
    }

    /**
     * Gets the attribute value for the calculated attribute WorkOrderNo.
     * @return the WorkOrderNo
     */
    public Integer getWorkOrderNo() {
        return (Integer) getAttributeInternal(WORKORDERNO);
    }

    /**
     * Gets the attribute value for the calculated attribute OrderType.
     * @return the OrderType
     */
    public String getOrderType() {
        return (String) getAttributeInternal(ORDERTYPE);
    }

    /**
     * Gets the attribute value for the calculated attribute ExpeditedProcessing.
     * @return the ExpeditedProcessing
     */
    public String getExpeditedProcessing() {
        return (String) getAttributeInternal(EXPEDITEDPROCESSING);
    }

    /**
     * Gets the attribute value for the calculated attribute CraCount.
     * @return the CraCount
     */
    public Integer getCraCount() {
        return (Integer) getAttributeInternal(CRACOUNT);
    }

    /**
     * Gets the attribute value for the calculated attribute CraSentCount.
     * @return the CraSentCount
     */
    public Integer getCraSentCount() {
        return (Integer) getAttributeInternal(CRASENTCOUNT);
    }

    /**
     * Gets the attribute value for the calculated attribute tranFinalCra.
     * @return the tranFinalCra
     */
    public Integer gettranFinalCra() {
        Integer fcount = 0;
        Integer crasentcount = getCraSentCount();
        Integer craCount = getCraCount();
        if(crasentcount  == 0)
        {
            if(craCount > 0)
            {
               fcount = 1; 
                }
            else
            {
              fcount = 0;  
                }
            }
        else
        {
         fcount = -1;   
            }
        return fcount;
    }

    /**
     * Sets <code>value</code> as the attribute value for the calculated attribute tranFinalCra.
     * @param value value to set the  tranFinalCra
     */
    public void settranFinalCra(Integer value) {
        setAttributeInternal(TRANFINALCRA, value);
    }
}

