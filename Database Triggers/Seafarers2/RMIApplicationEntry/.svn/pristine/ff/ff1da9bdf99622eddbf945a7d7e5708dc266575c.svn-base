package com.rmi.applicationEntry.view.batchesTaskFlows;

import javax.faces.event.ActionEvent;

import oracle.adf.model.BindingContext;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

public class DeficientOrdersBean {
    public DeficientOrdersBean() {
    }

    public void assignBatch(ActionEvent actionEvent) {
        OperationBinding ob = getBindings().getOperationBinding("assignDeficientOrder");
        ob.execute();
    }
    public BindingContainer getBindings(){
            return BindingContext.getCurrent().getCurrentBindingsEntry();
        }

    public void refreshButton(ActionEvent actionEvent) {
        OperationBinding ob = getBindings().getOperationBinding("onloadDeficientOrder");
        ob.execute();    }
}
