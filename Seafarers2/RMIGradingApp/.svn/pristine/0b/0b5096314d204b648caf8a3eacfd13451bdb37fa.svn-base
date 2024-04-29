package com.rmi.tradecompapproval.view.viewbatchseafarer;


import com.rmi.tradecompapproval.utils.IriAdfUtils;
import com.rmi.tradecompapproval.utils.IriJsfUtils;

import javax.faces.application.FacesMessage;
import javax.faces.event.ActionEvent;

import oracle.adf.controller.ControllerContext;
import oracle.adf.controller.ViewPortContext;
import oracle.adf.model.BindingContext;
import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

public class ViewBatch {
    public ViewBatch() {
    }
    public String test( ActionEvent actionEvent) {
        try 
        {
            OperationBinding ob = getBindings().getOperationBinding("editBatch");
            ob.execute();
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching batch details." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }
    public BindingContainer getBindings() {
        return BindingContext.getCurrent().getCurrentBindingsEntry();
    }

    public void testing(ActionEvent actionEvent) {
        try 
        {
            OperationBinding ob = getBindings().getOperationBinding("editBatch2");
            ob.execute();
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching batch details." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }
    
    public void exceptionHandler()
    {
        //System.out.println("inside ViewBatchTF exceptionHandler");
        ControllerContext ctx = ControllerContext.getInstance();
        ViewPortContext viewprt = ctx.getCurrentViewPort();

        if (viewprt.isExceptionPresent())
        {
            Exception exc = viewprt.getExceptionData();
            IriJsfUtils.addFormattedFacesErrorMessage("There has been exception while performing this task. ", exc.getMessage(), FacesMessage.SEVERITY_ERROR);
        }
    }
}
