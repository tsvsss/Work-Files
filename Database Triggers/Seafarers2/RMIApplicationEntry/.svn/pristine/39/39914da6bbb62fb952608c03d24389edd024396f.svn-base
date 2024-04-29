package com.rmi.applicationEntry.view.mytasktaskflow;

import com.rmi.applicationEntry.view.utils.ADFUtils;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;

import oracle.adf.controller.binding.BindingUtils;
import oracle.adf.model.BindingContext;
import oracle.adf.model.binding.DCBindingContainer;
import oracle.adf.model.binding.DCIteratorBinding;
import oracle.adf.share.ADFContext;
import oracle.adf.view.rich.component.rich.RichPopup;
import oracle.adf.view.rich.component.rich.input.RichInputText;
import oracle.adf.view.rich.context.AdfFacesContext;
import oracle.adf.view.rich.event.DialogEvent;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

import oracle.jbo.Row;
import oracle.jbo.RowSetIterator;
import oracle.jbo.ViewObject;

import org.apache.myfaces.trinidad.render.ExtendedRenderKitService;
import org.apache.myfaces.trinidad.util.Service;

public class MyTasksBean {

    private RichPopup reasonOfReturnPopup;
    private RichInputText reasonOfReturnTextBind;
    String reasonText;

    public void setReasonText(String reasonText) {
        this.reasonText = reasonText;
    }
  
    public String getReasonText() {
        return reasonText;
    }

    public MyTasksBean() {
//System.out.println("hello in mytask pageflow");
    }
    private void showPopup(RichPopup pop, boolean visible) {
            try {
                FacesContext context = FacesContext.getCurrentInstance();
                if (context != null && pop != null) {
                    String popupId = pop.getClientId(context);
                    if (popupId != null) {
                        StringBuilder script = new StringBuilder();
                        script.append("var popup = AdfPage.PAGE.findComponent('").append(popupId).append("'); ");
                        if (visible) {
                            script.append("if (!popup.isPopupVisible()) { ").append("popup.show();}");
                        } else {
                            script.append("if (popup.isPopupVisible()) { ").append("popup.hide();}");
                        }
                        ExtendedRenderKitService erks =
                            Service.getService(context.getRenderKit(), ExtendedRenderKitService.class);
                        erks.addScript(context, script.toString());
                    }
                }
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }

    public void returnBatchButton(ActionEvent actionEvent) {
        // Add event code here...
    }
    public BindingContainer getBindings(){
            return BindingContext.getCurrent().getCurrentBindingsEntry();
        }
    public void confirmationPopupDialogListener(DialogEvent dialogEvent) {
        try {
            if (dialogEvent.getOutcome() == DialogEvent.Outcome.yes) {
                //            System.out.println("in the yes ---");
                OperationBinding ob = getBindings().getOperationBinding("returnTaskToAdmin");
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

   public void iniTaskFlow()
   {
           try {
            BindingContext context = BindingUtils.getBindingContext();
            DCBindingContainer bindings = (DCBindingContainer) context.getCurrentBindingsEntry();
            DCIteratorBinding iterator;
            iterator = (DCIteratorBinding) bindings.findIteratorBinding("GetOperatorFlagVOIterator");
            ViewObject VO = iterator.getViewObject();
            Row currRow = VO.first();
            String flag = "N";
            if (currRow.getAttribute("OperatorFlag") != null) {
                flag = currRow.getAttribute("OperatorFlag").toString();

            }
            if (flag.equalsIgnoreCase("Y")) {

                AdfFacesContext.getCurrentInstance().getPageFlowScope().put("usertype", "operator");

            }
        } catch (Exception e) {
//            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading data." +
//            " Please contact your System Administrator." , 
//            "", FacesMessage.SEVERITY_ERROR);
               e.printStackTrace();
        }
       
       
       
       
       }

    public void returnBatchToAgent(DialogEvent dialogEvent) {
        try {
            if (dialogEvent.getOutcome() == DialogEvent.Outcome.ok) {
                showPopup(reasonOfReturnPopup, true);
                setReasonText(null);
            } else {
            }
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading data." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void submitBatchToAdmin(ActionEvent actionEvent) {
        OperationBinding ob=getBindings().getOperationBinding("submitBatchToAdmin");
        ob.execute();
    }

    public void returnOfReasonDialogListener(DialogEvent dialogEvent) {
        try {
            if (dialogEvent.getOutcome() == DialogEvent.Outcome.ok) {
                OperationBinding ob = getBindings().getOperationBinding("sendMailToAgent");
                ob.getParamsMap().put("text", getReasonText());
                ob.execute();

                ob = getBindings().getOperationBinding("returnBatchToAgent");
                ob.execute();
            } else {
            }
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while returning batch." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
    }

    public void setReasonOfReturnPopup(RichPopup reasonOfReturnPopup) {
        this.reasonOfReturnPopup = reasonOfReturnPopup;
    }

    public RichPopup getReasonOfReturnPopup() {
        return reasonOfReturnPopup;
    }

    public void setReasonOfReturnTextBind(RichInputText reasonOfReturnTextBind) {
        this.reasonOfReturnTextBind = reasonOfReturnTextBind;
    }

    public RichInputText getReasonOfReturnTextBind() {
        return reasonOfReturnTextBind;
    }

    public void acceptBatchByOperator(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("acceptBatchByOperator");
            ob.execute();
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while accepting batch." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
    }
    public String getcolorScheme()
    {
       return "color:'Red';";
        }
    public void initiatetaskFlow()
    {
//    System.out.println("intializer--------");    
        
        }


    public void refreshQueue(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("onLoadMytask");
            ob.execute();
        } catch (Exception e) {
//            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading page." +
//            " Please contact your System Administrator." , 
//            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
    }

    public void returnBatchLegal(ActionEvent actionEvent) {
        // Add event code here...
        try {
            OperationBinding ob = getBindings().getOperationBinding("returnTaskToAdminLegal");
            ob.execute();
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading data." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
        }
        
    }

    public void filterCra(ActionEvent actionEvent) {
        OperationBinding ob = getBindings().getOperationBinding("filterOnMyTask");
        ob.getParamsMap().put("p_filter", "cra");
        ob.execute();    }

    public void filterExpedited(ActionEvent actionEvent) {
        OperationBinding ob = getBindings().getOperationBinding("filterOnMyTask");
        ob.getParamsMap().put("p_filter", "expedited");
        ob.execute();    }

    public void filterResubmit(ActionEvent actionEvent) {
        OperationBinding ob = getBindings().getOperationBinding("filterOnMyTask");
        ob.getParamsMap().put("p_filter", "resubmit");
        ob.execute();    }

    public void filterAll(ActionEvent actionEvent) {
        OperationBinding ob = getBindings().getOperationBinding("filterOnMyTask");
        ob.getParamsMap().put("p_filter", "all");
        ob.execute();    }
}
