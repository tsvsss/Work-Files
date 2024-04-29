package com.rmi.tradecompapproval.view.seafarerdataverification;

import com.rmi.tradecompapproval.utils.IriAdfUtils;
import com.rmi.tradecompapproval.utils.IriJsfUtils;

import javax.faces.application.FacesMessage;
import javax.faces.event.ValueChangeEvent;

import oracle.binding.OperationBinding;

import org.apache.myfaces.trinidad.context.RequestContext;

public class SeafarerDataVerificationBean 
{
    public SeafarerDataVerificationBean()
    {
        RequestContext.getCurrentInstance().getPageFlowScope().put("P_VIEW_QA", "N");
    }

    public void viewOrdersVCL(ValueChangeEvent valueChangeEvent) 
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null) {
                OperationBinding fltrOdrOp = IriAdfUtils.findOperation("filterOrdersVerification");
                fltrOdrOp.getParamsMap().put("filterType", valueChangeEvent.getNewValue().toString());
                fltrOdrOp.execute();
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching orders pending verification." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public String viewWorkOrderAction() 
    {
        try 
        {
            RequestContext.getCurrentInstance().getPageFlowScope().put("P_VIEW_QA", "Y");

            OperationBinding fltrSfrrOp = IriAdfUtils.findOperation("filterSeafarersDetails");
            fltrSfrrOp.execute();
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching order details." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }

        return "viewSeafarerDetails";
    }
}
