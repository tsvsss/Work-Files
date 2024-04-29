package com.rmi.tradecompapproval.view.editseafarerdocs;

import com.rmi.tradecompapproval.utils.IriAdfUtils;
import com.rmi.tradecompapproval.utils.IriJsfUtils;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.faces.event.PhaseEvent;

import oracle.adf.share.ADFContext;

import oracle.binding.OperationBinding;

public class CustomManagedBean {
    public CustomManagedBean() {
    }

    public void beforePageLoads(PhaseEvent phaseEvent)
    {
        try
        {
           Object seafarerId =
                FacesContext.getCurrentInstance().getExternalContext().getRequestParameterMap().get("seafarerId");
//            System.out.println("seafarerId ::" + seafarerId);

            if (seafarerId != null) {
                String[] params = seafarerId.toString().split(",");
                ADFContext.getCurrent().getSessionScope().put("batchId", Integer.parseInt(params[1]));
                OperationBinding fltrVldtSfrrOp = IriAdfUtils.findOperation("filterValidateSeafarerVoOnLoad");
                fltrVldtSfrrOp.getParamsMap().put("seafarerId", Integer.parseInt(params[0]));
                fltrVldtSfrrOp.execute();

                if (!fltrVldtSfrrOp.getErrors().isEmpty()) {
                    IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while opening Edit Documents. " +
                                                                " Please contact your System Administrator." , 
                                                              "", FacesMessage.SEVERITY_ERROR);
                }
            }
        } catch (Exception nfe) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while opening Edit Documents. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }
}
