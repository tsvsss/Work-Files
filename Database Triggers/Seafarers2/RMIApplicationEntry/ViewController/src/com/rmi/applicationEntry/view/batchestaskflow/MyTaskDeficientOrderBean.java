package com.rmi.applicationEntry.view.batchestaskflow;

import com.rmi.applicationEntry.view.utils.ADFUtils;

import javax.faces.application.FacesMessage;
import javax.faces.event.ActionEvent;

import oracle.adf.model.BindingContext;

import oracle.adf.view.rich.event.DialogEvent;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

import org.apache.myfaces.trinidad.event.DisclosureEvent;

public class MyTaskDeficientOrderBean {
    public MyTaskDeficientOrderBean() {
    }

    public void returnBatch(ActionEvent actionEvent) {
        OperationBinding ob = getBindings().getOperationBinding("returnBatchMyTaskDeficient");
        ob.execute();    }
    public BindingContainer getBindings(){
            return BindingContext.getCurrent().getCurrentBindingsEntry();
        }

    public String editBatch() {
        // Add event code here...
        return "editBatch";
    }

    public void returnConfirmDialogListener(DialogEvent dialogEvent) {
        try {
            if (dialogEvent.getOutcome() == DialogEvent.Outcome.yes) {
                //            System.out.println("in the yes ---");
                OperationBinding ob = getBindings().getOperationBinding("returnBatchMyTaskDeficient");
                ob.execute();
            } else {
                // write your custom code for cancel event
            }
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while returning batch." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
    }

    public void testingButton(DisclosureEvent disclosureEvent) {
        // Add event code here...
    }

    public void refreshButton(ActionEvent actionEvent) {
        OperationBinding ob = getBindings().getOperationBinding("onloadMyTaskDeficientOrder");
        ob.execute();    }
}
