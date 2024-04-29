package com.rmi.applicationEntry.view.batchesmtctaskflow;

import com.rmi.applicationEntry.view.utils.ADFUtils;

import javax.faces.application.FacesMessage;
import javax.faces.event.ActionEvent;

import oracle.adf.model.BindingContext;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

public class BatchesMtcBean {
    public BatchesMtcBean() {
    }

    public void assignToUser(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("assignTaskToUserMTC");
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
    public BindingContainer getBindings(){
            return BindingContext.getCurrent().getCurrentBindingsEntry();
        }

    public void assignRejectedButton(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("assignTaskToUserMTCRejected");
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

    public void assignLegalToUser(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("assignTaskToUserMTCLegal");
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
}
