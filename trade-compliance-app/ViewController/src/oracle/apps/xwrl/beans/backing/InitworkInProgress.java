package oracle.apps.xwrl.beans.backing;

import com.rmi.manualtradecompliance.utils.ADFUtils;
import com.rmi.manualtradecompliance.utils.JSFUtils;

import java.util.List;
import java.util.Map;

import oracle.adf.share.ADFContext;
import oracle.adf.view.rich.component.rich.data.RichTable;
import oracle.adf.view.rich.event.QueryEvent;
import oracle.adf.view.rich.model.AttributeCriterion;
import oracle.adf.view.rich.model.AttributeDescriptor.Operator;
import oracle.adf.view.rich.model.ConjunctionCriterion;
import oracle.adf.view.rich.model.Criterion;
import oracle.adf.view.rich.model.FilterableQueryDescriptor;

import oracle.adfinternal.view.faces.model.binding.FacesCtrlSearchBinding;

import oracle.apps.xwrl.model.am.AppModuleImpl;


public class InitworkInProgress {
    public InitworkInProgress() {
        super();
    }
    
    public void intialise() 
    {
        AppModuleImpl am = null;
        try {
              ADFContext.getCurrent().getPageFlowScope().put("pUserId", ADFContext.getCurrent().getSessionScope().get("UserId"));
            am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
            am.getWipDepartmentNames1().executeQuery();
           am.getWipPendingTcOptions1().executeQuery();
            System.out.println("Init WIP class");
       } catch (Exception e) {
            // TODO: Add catch code
            e.printStackTrace();
        }
    }
    
    
    private transient RichTable table;
    private boolean initialQuery = true;

    private Map<String, Object> defaultFilterCriteria;
    private String queryBindingName ="XwrlResponseIndColumnsView1";
    
    public FilterableQueryDescriptor getCustomQueryDescriptor()
    {
        String bindingEl = "#{bindings." + queryBindingName + "}";

        FacesCtrlSearchBinding sbinding = (FacesCtrlSearchBinding)JSFUtils.resolveExpression(bindingEl);
                FilterableQueryDescriptor fqd = (FilterableQueryDescriptor) sbinding.getQueryDescriptor();

                if (fqd != null && fqd.getFilterConjunctionCriterion() != null && 
                    isInitialQuery()) {
                    ConjunctionCriterion cc = fqd.getFilterConjunctionCriterion();
                    List<Criterion> lc = cc.getCriterionList();
                    for (Criterion c : lc) 
                    {
                        if (c instanceof AttributeCriterion) 
                        {
                            AttributeCriterion ac = (AttributeCriterion) c;
                            Operator operator = ac.getOperator();
                           
                        }
                    }
                    setInitialQuery(false);
                    RichTable tbl = getTable();
                    QueryEvent queryEvent = new QueryEvent(tbl, fqd);
                    sbinding.processQuery(queryEvent);
                }

        return fqd;
    }
    
    public void setTable(RichTable table) {
           this.table = table;
       }

       public RichTable getTable() {
           return table;
       }
    
    public void setInitialQuery(boolean initialQuery) {
           this.initialQuery = initialQuery;
       }

       public boolean isInitialQuery() {
           return initialQuery;
       }
}
