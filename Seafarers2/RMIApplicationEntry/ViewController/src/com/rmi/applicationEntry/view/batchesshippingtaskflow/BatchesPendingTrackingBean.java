package com.rmi.applicationEntry.view.batchesshippingtaskflow;

import com.rmi.applicationEntry.view.utils.ADFUtils;

import javax.faces.application.FacesMessage;
import javax.faces.event.ActionEvent;

import oracle.adf.model.BindingContext;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

public class BatchesPendingTrackingBean {
    public BatchesPendingTrackingBean() {
    }
    public BindingContainer getBindings(){
            return BindingContext.getCurrent().getCurrentBindingsEntry();
        }
    public void assignButton(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("assignTaskToUserClosed");
            String res =  ob.execute().toString();
              if(res.equalsIgnoreCase("repeat"))
              {
                      ADFUtils.addFormattedFacesErrorMessage("This batch has been already assigned." , 
                      "", FacesMessage.SEVERITY_ERROR); 
                  }
        } catch (Exception e) {
//            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while assigning batch." +
//            " Please contact your System Administrator." , 
//            "", FacesMessage.SEVERITY_ERROR);
                    e.printStackTrace();
        }    }
}