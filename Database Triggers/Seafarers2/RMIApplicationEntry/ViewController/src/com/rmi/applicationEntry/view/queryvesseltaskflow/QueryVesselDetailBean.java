package com.rmi.applicationEntry.view.queryvesseltaskflow;

import javax.faces.event.ActionEvent;

import oracle.adf.model.BindingContext;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

public class QueryVesselDetailBean {
    public QueryVesselDetailBean() {
    }
    public BindingContainer getBindings() {
        return BindingContext.getCurrent().getCurrentBindingsEntry();
    }
    public void searchVessel(ActionEvent actionEvent) {
        OperationBinding ob = getBindings().getOperationBinding("searchVesselSearch");
        ob.execute();    }

    public void clearSearch(ActionEvent actionEvent) {
        OperationBinding ob = getBindings().getOperationBinding("clearVesselSearch");
        ob.execute();    }
}
