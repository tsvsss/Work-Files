package com.rmi.applicationEntry.view.batchestaskflow;

import oracle.adf.model.BindingContext;

import oracle.adf.view.rich.component.rich.layout.RichShowDetailItem;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

public class BatchesBackingBean {
    private RichShowDetailItem accountStatusTab;

    public BatchesBackingBean() {
        
        OperationBinding ob=getBindings().getOperationBinding("searchBatch");
        ob.execute();
//        System.out.println("hello--in the backing scope");
    }
    String tab_name = "Refresh";

    public void setTab_name(String tab_name) {
        this.tab_name = tab_name;
    }

    public String getTab_name() {
        return tab_name;
    }
    public BindingContainer getBindings(){
            return BindingContext.getCurrent().getCurrentBindingsEntry();
        }

    public void setAccountStatusTab(RichShowDetailItem accountStatusTab) {
        this.accountStatusTab = accountStatusTab;
    }

    public RichShowDetailItem getAccountStatusTab() {
        return accountStatusTab;
    }
}
