package com.rmi.applicationEntry.view.mastermytasktaskflow;

import com.rmi.applicationEntry.view.utils.ADFUtils;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;

import oracle.adf.model.BindingContext;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

public class MasterMyTaskBean {
    public MasterMyTaskBean() {
    }
    public BindingContainer getBindings(){
            return BindingContext.getCurrent().getCurrentBindingsEntry();
        }
   
    public void searchButton(ActionEvent actionEvent) {
        try {
            System.out.println("searchButton method");
            OperationBinding ob = getBindings().getOperationBinding("searchMasterMyTask");
            ob.execute();
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while searching data." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
    }

    public void returnBatchButton(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("returnMasterTaskToAdmin");
            ob.execute();
            FacesMessage Message = new FacesMessage("The batch has been returned to the main queue.");
            Message.setSeverity(FacesMessage.SEVERITY_INFO);
            
            FacesContext fc = FacesContext.getCurrentInstance();
            
            fc.addMessage(null, Message); 
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while returning batch." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
    }
}
