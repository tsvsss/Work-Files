package com.rmi.manualtradecompliance.view.vetting;

import com.rmi.manualtradecompliance.utils.ADFUtils;
import com.rmi.manualtradecompliance.utils.JSFUtils;

import javax.faces.application.FacesMessage;
import javax.faces.event.PhaseEvent;

import oracle.adf.share.ADFContext;

import oracle.binding.OperationBinding;

import org.apache.myfaces.trinidad.context.RequestContext;

public class CustomManagedBeanOws {
    public CustomManagedBeanOws() {
    }

    public void tcOwsPageBeforePhaseListener(PhaseEvent phaseEvent) 
    {       
        try
        {
            OperationBinding batchIdOp = ADFUtils.findOperation("getBatchIdOws");
            batchIdOp.execute();
         
            if(batchIdOp.getErrors().isEmpty() && batchIdOp.getResult()!= null)
            {   
                ADFContext.getCurrent().getPageFlowScope().put("P_BATCH_ID_OWS", batchIdOp.getResult());
                ADFContext.getCurrent().getSessionScope().put("UserId", 
                                                              Integer.parseInt(ADFContext.getCurrent().getSessionScope().get("UserId").toString()));
            }
            else
            {
                JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching Batch ID." +
                                                       "Please contact your System Administrator.", "",
                                                       FacesMessage.SEVERITY_ERROR);
            }
        }catch(Exception e){
            e.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching Batch ID." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }
}
