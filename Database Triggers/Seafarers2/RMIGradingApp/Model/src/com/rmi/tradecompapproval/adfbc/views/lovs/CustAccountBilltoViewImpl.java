package com.rmi.tradecompapproval.adfbc.views.lovs;

import java.util.List;

import oracle.jbo.ViewCriteria;
import oracle.jbo.ViewCriteriaItem;
import oracle.jbo.ViewCriteriaRow;
import oracle.jbo.server.ViewObjectImpl;
// ---------------------------------------------------------------------
// ---    File generated by Oracle ADF Business Components Design Time.
// ---    Wed May 13 16:23:16 IST 2020
// ---    Custom code may be added to this class.
// ---    Warning: Do not modify method signatures of generated methods.
// ---------------------------------------------------------------------
public class CustAccountBilltoViewImpl extends ViewObjectImpl {
    /**
     * This is the default constructor (do not remove).
     */
    public CustAccountBilltoViewImpl() {
    }

    /**
     * Returns the variable value for pPartyName.
     * @return variable value for pPartyName
     */
    public String getpPartyName() {
        return (String) ensureVariableManager().getVariableValue("pPartyName");
    }

    /**
     * Sets <code>value</code> for variable pPartyName.
     * @param value value to bind as pPartyName
     */
    public void setpPartyName(String value) {
        ensureVariableManager().setVariableValue("pPartyName", value);
    }

    /**
     * Returns the bind variable value for pCustAccId.
     * @return bind variable value for pCustAccId
     */
    public Integer getpCustAccId() {
        return (Integer) getNamedWhereClauseParam("pCustAccId");
    }

    /**
     * Sets <code>value</code> for bind variable pCustAccId.
     * @param value value to bind as pCustAccId
     */
    public void setpCustAccId(Integer value) {
        setNamedWhereClauseParam("pCustAccId", value);
    }
    
    @Override
    public void applyViewCriteria(ViewCriteria viewCriteria, boolean b)
    {
        super.applyViewCriteria(supressStartsWithClauseForLov(viewCriteria), b);
    }
    
    public ViewCriteria supressStartsWithClauseForLov(ViewCriteria vc) 
    {        
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
}
