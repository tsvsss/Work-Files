package com.rmi.applicationEntry.view.batchesvaltaskflow;

import com.rmi.applicationEntry.view.utils.ADFUtils;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;

import oracle.adf.model.BindingContext;

import oracle.adf.share.ADFContext;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

public class BatchesEvalBean {
    public BatchesEvalBean() {
    }
    public BindingContainer getBindings(){
            return BindingContext.getCurrent().getCurrentBindingsEntry();
        }
   
    public void assignEvalButton(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("assignTaskToUserEval");
            String res =  ob.execute().toString();
              if(res.equalsIgnoreCase("repeat"))
              {
                      ADFUtils.addFormattedFacesErrorMessage("This batch has been already assigned." , 
                      "", FacesMessage.SEVERITY_ERROR); 
                  }
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while assigning batch." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
    }

    public void assignButtonOnCraTab(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("assignTaskToUserEvalCra");
            String res =  ob.execute().toString();
              if(res.equalsIgnoreCase("repeat"))
              {
                      ADFUtils.addFormattedFacesErrorMessage("This batch has been already assigned." , 
                      "", FacesMessage.SEVERITY_ERROR); 
                  }        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while assigning batch." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
    }

    public void AssignButtonResubmitted(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("assignTaskToUserEvalRejected");
            String res =  ob.execute().toString();
              if(res.equalsIgnoreCase("repeat"))
              {
                      ADFUtils.addFormattedFacesErrorMessage("This batch has been already assigned." , 
                      "", FacesMessage.SEVERITY_ERROR); 
                  }        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while assigning batch." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
                    e.printStackTrace();
        }
    }

    public String actionRefreshOrdersToGrade()
    {
        try 
        {
            OperationBinding refreshOrdersOp = getBindings().getOperationBinding("onLoadBatchPendingEVAL");
            refreshOrdersOp.getParamsMap().put("user_id", ADFContext.getCurrent().getSessionScope().get("UserId"));
            refreshOrdersOp.execute();
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while refreshing queue." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }
}
