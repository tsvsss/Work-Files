package com.rmi.tradecompapproval.adfbc.views;

import java.util.List;

import oracle.jbo.ViewCriteria;
import oracle.jbo.ViewCriteriaItem;
import oracle.jbo.ViewCriteriaRow;
import oracle.jbo.server.ViewObjectImpl;
// ---------------------------------------------------------------------
// ---    File generated by Oracle ADF Business Components Design Time.
// ---    Wed May 13 12:09:04 IST 2020
// ---    Custom code may be added to this class.
// ---    Warning: Do not modify method signatures of generated methods.
// ---------------------------------------------------------------------
public class RmiBatchViewImpl extends ViewObjectImpl {
    /**
     * This is the default constructor (do not remove).
     */
    public RmiBatchViewImpl() {
    }

    /**
     * Returns the variable value for pEsiBatchId.
     * @return variable value for pEsiBatchId
     */
    public Integer getpEsiBatchId() {
        return (Integer) ensureVariableManager().getVariableValue("pEsiBatchId");
    }

    /**
     * Sets <code>value</code> for variable pEsiBatchId.
     * @param value value to bind as pEsiBatchId
     */
    public void setpEsiBatchId(Integer value) {
        ensureVariableManager().setVariableValue("pEsiBatchId", value);
    }
   
    @Override
    public void applyViewCriteria(ViewCriteria viewCriteria, boolean b)
    {
        super.applyViewCriteria(supressStartsWithClauseForLov(viewCriteria), b);
    }
    
    public ViewCriteria supressStartsWithClauseForLov(ViewCriteria vc) 
    {
        System.out.println("vc.getName() :: "+vc.getName());
        
        if (vc != null && vc.getName().contains("__lov__filterlist__vcr__")) {
            //��� System.out.println( "� Inside " + vc.getName());
            ViewCriteriaRow currentRow = (ViewCriteriaRow) vc.getCurrentRow();
            if (currentRow != null) {
                //������ System.out.println(" Current row "+currentRow );
                List criteriaItems = currentRow.getCriteriaItems();
                for (int i = 0; i < criteriaItems.size(); i++) {
                    ViewCriteriaItem object = (ViewCriteriaItem) criteriaItems.get(i);
                    if (object != null) {
                        //�������� System.out.println("Operator is : "+object.getOperator());
                        if ("STARTSWITH".equals(object.getOperator())) {
                            object.setOperator("CONTAINS");
                        }
                    }
                }
            }
        }
        return vc;
    }

    /**
     * Returns the variable value for pBatchName.
     * @return variable value for pBatchName
     */
    public String getpBatchName() {
        return (String) ensureVariableManager().getVariableValue("pBatchName");
    }

    /**
     * Sets <code>value</code> for variable pBatchName.
     * @param value value to bind as pBatchName
     */
    public void setpBatchName(String value) {
        ensureVariableManager().setVariableValue("pBatchName", value);
    }
}
