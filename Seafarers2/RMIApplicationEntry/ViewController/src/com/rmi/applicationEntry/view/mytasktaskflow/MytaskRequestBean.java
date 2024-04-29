package com.rmi.applicationEntry.view.mytasktaskflow;

import javax.faces.event.ActionEvent;

import oracle.adf.model.BindingContext;
import oracle.adf.share.ADFContext;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

public class MytaskRequestBean {
    public MytaskRequestBean() {
        OperationBinding ob=getBindings().getOperationBinding("onLoadMytask");
        ob.execute();
//        System.out.println("hello--in the request scope");
    }
String ot = "Refresh";
    public BindingContainer getBindings(){
            return BindingContext.getCurrent().getCurrentBindingsEntry();
        }
    public void setOt(String ot) {
        this.ot = ot;
    }

    public String getOt() {
        return ot;
    }

    public void testingBean(ActionEvent actionEvent) {
        // Add event code here...
    }
}
