package com.rmi.applicationEntry.view.batchestaskflow;

import oracle.adf.model.BindingContext;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

import org.apache.myfaces.trinidad.event.DisclosureEvent;

public class MyTaskDeficientRequestBean {
    public MyTaskDeficientRequestBean() {
        OperationBinding ob=getBindings().getOperationBinding("onloadMyTaskDeficientOrder");
        ob.execute();
        System.out.println(ot+"-----ottt");
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

    public void testingButton(DisclosureEvent disclosureEvent) {
        // Add event code here...
    }
}
