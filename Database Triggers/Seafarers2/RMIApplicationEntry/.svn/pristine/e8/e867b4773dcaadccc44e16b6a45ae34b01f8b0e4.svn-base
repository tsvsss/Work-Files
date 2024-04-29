package com.rmi.applicationEntry.view.batchestctaskflow;

import com.rmi.applicationEntry.view.utils.ADFUtils;

import javax.faces.application.FacesMessage;
import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;

import oracle.adf.model.BindingContext;

import oracle.adf.share.ADFContext;
import oracle.adf.view.rich.component.rich.input.RichInputText;

import oracle.adf.view.rich.component.rich.layout.RichPanelTabbed;

import oracle.adf.view.rich.component.rich.layout.RichShowDetailItem;

import oracle.adf.view.rich.context.AdfFacesContext;

import oracle.adf.view.rich.event.DialogEvent;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

import org.apache.myfaces.trinidad.event.DisclosureEvent;

public class BatchesTCBean {
    private RichInputText seafarerIdBinding;
    private RichInputText seafarerNameBinding;
    private RichPanelTabbed tabbedBind;
    private RichShowDetailItem tab1Bind;
    private RichShowDetailItem tab4Bind;
    private String currentTab="t1";

    public void setCurrentTab(String currentTab) {
        this.currentTab = currentTab;
    }
   
    public String getCurrentTab() {
        return currentTab;
    }

    public BatchesTCBean() {
        
    }
    public BindingContainer getBindings(){
            return BindingContext.getCurrent().getCurrentBindingsEntry();
        }
    public void assignSingleButton(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("assignTaskToUser");
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

    public void assignButtonCra(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("assignTaskToUserCraRequested");
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

    public void assignTaskExpedited(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("assignTaskToUserExpedited");
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

    public void ordersToGradeDisclosureListener(DisclosureEvent disclosureEvent) {
//        System.out.println("-----hello---");
        try {
            OperationBinding ob = getBindings().getOperationBinding("onLoadBatchPendingTC");
            ob.execute();
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while assigning batch." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
        
    }

    public void craDisclosureListener(DisclosureEvent disclosureEvent) {
        OperationBinding ob = getBindings().getOperationBinding("onLoadBatchPendingTC");
        ob.execute();
    }

    public void expeditedDisclosureListener(DisclosureEvent disclosureEvent) {
        OperationBinding ob = getBindings().getOperationBinding("onLoadBatchPendingTC");
        ob.execute();
    }

    public void sendAckManual(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("sendAcknowledgement");
            ob.execute();
            FacesMessage Message = new FacesMessage("Acknowledgement Sent Successfully.");
            Message.setSeverity(FacesMessage.SEVERITY_INFO);
            FacesContext fc = FacesContext.getCurrentInstance();
            fc.addMessage(null, Message);
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while sending acknowledgement." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
        
    }

    public void setSeafarerIdBinding(RichInputText seafarerIdBinding) {
        this.seafarerIdBinding = seafarerIdBinding;
    }

    public RichInputText getSeafarerIdBinding() {
        return seafarerIdBinding;
    }

    public void setSeafarerNameBinding(RichInputText seafarerNameBinding) {
        this.seafarerNameBinding = seafarerNameBinding;
    }

    public RichInputText getSeafarerNameBinding() {
        return seafarerNameBinding;
    }

    public void findButtonActionListener(ActionEvent actionEvent) {
//        System.out.println(seafarerIdBinding.getValue()+"---------111");
//        System.out.println(seafarerNameBinding.getValue()+"---------111");
        try {
            Integer esi_id = null;
            String sea_name = null;
            if (seafarerIdBinding.getValue() != null) {
                esi_id = Integer.parseInt(seafarerIdBinding.getValue().toString());

            }
            if (seafarerNameBinding.getValue() != null) {
                sea_name = seafarerNameBinding.getValue().toString();

            }
            OperationBinding ob = getBindings().getOperationBinding("find_seafarer");
            ob.getParamsMap().put("esi_id", esi_id);
            ob.getParamsMap().put("sea_name", sea_name);
            ob.execute();
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while searching seafarer." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
        
    }

    public void findSeafarerDisclosureListener(DisclosureEvent disclosureEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("findSeafarerReset");
            ob.execute();
            seafarerIdBinding.setValue(null);
            seafarerNameBinding.setValue(null);
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while processing." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }

    }

    public void assignResubmittedBatches(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("assignTaskReSubmitted");
            ob.execute();
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while assigning batch." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
    }

    public void setTabbedBind(RichPanelTabbed tabbedBind) {
        this.tabbedBind = tabbedBind;
    }

    public RichPanelTabbed getTabbedBind() {
        return tabbedBind;
    }

    public void setTab1Bind(RichShowDetailItem tab1Bind) {
        this.tab1Bind = tab1Bind;
    }

    public RichShowDetailItem getTab1Bind() {
        return tab1Bind;
    }

    public void setTab4Bind(RichShowDetailItem tab4Bind) {
        this.tab4Bind = tab4Bind;
    }

    public RichShowDetailItem getTab4Bind() {
        return tab4Bind;
    }
    
    public void setDisclosedFirstTab(RichShowDetailItem tabBind) {
        try {
            RichPanelTabbed richPanelTabbed = getTabbedBind();
//            System.out.println("setDisclosedFirstTab");
            for (UIComponent child : richPanelTabbed.getChildren()) {
                RichShowDetailItem sdi = (RichShowDetailItem) child;
                if (sdi.getClientId().equals(tabBind.getClientId())) {
                    sdi.setDisclosed(true);
                } else {
                    sdi.setDisclosed(false);
                }
            }
            AdfFacesContext.getCurrentInstance().addPartialTarget(tabbedBind);
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while processing." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
    }

    public void viewButtonActionListener(ActionEvent actionEvent) {
        if(this.currentTab.equals("t4")){
//            System.out.println("Tab4AL.........");
                setDisclosedFirstTab(this.tab4Bind);
            }
    }

    public void sendAckConfirmationDL(DialogEvent dialogEvent)
    {
        try 
        {
            if((dialogEvent.getOutcome() != null) &&
               (dialogEvent.getOutcome().toString().equalsIgnoreCase("yes")
                || dialogEvent.getOutcome().toString().equalsIgnoreCase("ok")))
            {
                OperationBinding ob = getBindings().getOperationBinding("sendAcknowledgement");
                ob.execute();
                FacesMessage Message = new FacesMessage("Acknowledgement Sent Successfully.");
                Message.setSeverity(FacesMessage.SEVERITY_INFO);
                FacesContext fc = FacesContext.getCurrentInstance();
                fc.addMessage(null, Message);
            }
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while sending acknowledgement." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
                    e.printStackTrace();
        }
    }

    public String actionRefreshOrdersToGrade()
    {
        try 
        {
            OperationBinding refreshOrdersOp = getBindings().getOperationBinding("onLoadBatchPendingTC");
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
