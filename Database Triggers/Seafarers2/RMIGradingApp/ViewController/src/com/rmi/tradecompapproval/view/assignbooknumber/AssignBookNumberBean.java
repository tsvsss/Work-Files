package com.rmi.tradecompapproval.view.assignbooknumber;

import com.rmi.manualtradecompliance.adfbc.utils.LogUtils;
import com.rmi.manualtradecompliance.utils.ADFUtils;
import com.rmi.manualtradecompliance.utils.JSFUtils;
import com.rmi.tradecompapproval.utils.IriAdfUtils;
import com.rmi.tradecompapproval.utils.IriJsfUtils;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;

import javax.faces.event.ValueChangeEvent;

import oracle.adf.controller.ControllerContext;
import oracle.adf.controller.ViewPortContext;

import oracle.adf.view.rich.component.rich.RichPopup;
import oracle.adf.view.rich.component.rich.input.RichSelectBooleanCheckbox;
import oracle.adf.view.rich.component.rich.nav.RichButton;
import oracle.adf.view.rich.context.AdfFacesContext;
import oracle.adf.view.rich.event.DialogEvent;

import oracle.adf.view.rich.event.PopupFetchEvent;

import oracle.adf.view.rich.render.ClientEvent;

import oracle.binding.OperationBinding;

import org.apache.myfaces.trinidad.render.ExtendedRenderKitService;
import org.apache.myfaces.trinidad.util.Service;

public class AssignBookNumberBean {

    private RichPopup cnfrmSendToShippingPopupBind;
    private RichButton viewRequestButtonBind;
    private RichPopup printRequestSetPopupBind;
    private RichSelectBooleanCheckbox selectAllCheckBoxBind;

    public AssignBookNumberBean() {
    }

    public void filterProcessBookFromBean()
    {
        try 
        {
            OperationBinding fltrProcBkOp = IriAdfUtils.findOperation("filterProcessBook");
            fltrProcBkOp.execute();
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while porcessing Book Number. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }          
    }

    public void assignBookAL(ActionEvent actionEvent) 
    {
        try
        {
             OperationBinding validatePrintOp = IriAdfUtils.findOperation("validateOrderPrint");
             validatePrintOp.execute();

//             if (validatePrintOp.getResult() != null && validatePrintOp.getResult().toString().equals("Y")) 
             if (true) 
             {
                  OperationBinding assignBkOp = IriAdfUtils.findOperation("assignBookNumbers");
                  assignBkOp.execute();

                  if (assignBkOp.getErrors().isEmpty() &&
                      (assignBkOp.getResult() != null && assignBkOp.getResult().equals("Y"))) {
                      OperationBinding saveOp = IriAdfUtils.findOperation("Commit");
                      saveOp.execute();
                      
                      if(selectAllCheckBoxBind != null)
                      {
                          selectAllCheckBoxBind.resetValue();
                          AdfFacesContext.getCurrentInstance().addPartialTarget(selectAllCheckBoxBind);
                      }

                      IriJsfUtils.addFormattedFacesErrorMessage("Books Assigned Successfully !", "",
                                                                FacesMessage.SEVERITY_INFO);
                  }
                  else if (assignBkOp.getResult() != null && assignBkOp.getResult().equals("NS")) {
                      
                      IriJsfUtils.addFormattedFacesErrorMessage("Please select atleast 1 Book to assign Book Number.", 
                                                                "", FacesMessage.SEVERITY_ERROR);
                  }
                  else if (assignBkOp.getResult() != null && assignBkOp.getResult().equals("D")) {
                      
                      IriJsfUtils.addFormattedFacesErrorMessage("Entered Book Number is aleady assigned. Please try a different number.", 
                                                                "", FacesMessage.SEVERITY_ERROR);
                  } else {
                      System.out.println("inside else :: "+assignBkOp.getResult());
                      IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception during assigning Book Number(s). " +
                                                                  " Please contact your System Administrator." , 
                                                                "", FacesMessage.SEVERITY_ERROR);
                  }
             } else {
                 IriJsfUtils.addFormattedFacesErrorMessage("Selected Order is on Hold. Please release Hold and try again.",
                                                           "",
                                                           FacesMessage.SEVERITY_ERROR);
             }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception during assigning Book Number(s). " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void updateBookAL(ActionEvent actionEvent)
    {
        try 
        {
            OperationBinding updateBkOp = IriAdfUtils.findOperation("updateBookNumbers");
            updateBkOp.execute();

            if (updateBkOp.getErrors().isEmpty() &&
                (updateBkOp.getResult() != null && updateBkOp.getResult().equals("Y"))) {
                OperationBinding saveOp = IriAdfUtils.findOperation("Commit");
                saveOp.execute();

                IriJsfUtils.addFormattedFacesErrorMessage("Books Updated Successfully !", "",
                                                          FacesMessage.SEVERITY_INFO);
            } else {
                IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception during updating Book Number(s). " +
                                                            " Please contact your System Administrator." , 
                                                          "", FacesMessage.SEVERITY_ERROR);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception during updating Book Number(s). " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }
    
    public void exceptionHandler()
    {
        //System.out.println("inside AssignBookNumberTF exceptionHandler");
        ControllerContext ctx = ControllerContext.getInstance();
        ViewPortContext viewprt = ctx.getCurrentViewPort();

        if (viewprt.isExceptionPresent())
        {
            Exception exc = viewprt.getExceptionData();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while performing this task."+
                                                        " Please contact your System Administrator.", exc.getMessage(), FacesMessage.SEVERITY_ERROR);
        }
    }

    public String printOrderAction()
    {
        try 
        {
            OperationBinding printOdrOp = IriAdfUtils.findOperation("printOrder");
            printOdrOp.execute();
            
            if (printOdrOp.getErrors().isEmpty()) {
                if (printOdrOp.getResult() != null && printOdrOp.getResult().toString().length() > 1) {                     
                    
                     IriJsfUtils.addFormattedFacesErrorMessage(printOdrOp.getResult().toString(), "", FacesMessage.SEVERITY_INFO);
                }
            } else {
                IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while printing this order. " +
                                                            " Please contact your System Administrator." , 
                                                          "", FacesMessage.SEVERITY_ERROR);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while printing this order. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        
        return null;
    }

    public void sendToShippingCnfDL(DialogEvent dialogEvent)
    {
        try 
        {
            String outcome = ((dialogEvent.getOutcome() != null) ? dialogEvent.getOutcome().toString() : "N");

            if (outcome.equalsIgnoreCase("ok") || outcome.equalsIgnoreCase("yes")) 
            {
                OperationBinding chkSendToShippingOp = IriAdfUtils.findOperation("checkSendToShipping");
                chkSendToShippingOp.execute();
                
                if(chkSendToShippingOp.getResult() != null && 
                   (chkSendToShippingOp.getResult().toString().equalsIgnoreCase("Y")
                    ||chkSendToShippingOp.getResult().toString().equalsIgnoreCase("ALL")))
                {
                    OperationBinding sendShipOp = IriAdfUtils.findOperation("sendToShipping");
                    sendShipOp.getParamsMap().put("retVal", chkSendToShippingOp.getResult().toString());
                    sendShipOp.execute();
                    
                    System.out.println("sendShipOp.getErrors() :: "+sendShipOp.getErrors());

                    if (sendShipOp.getErrors().isEmpty()) {
                        if (sendShipOp.getResult() != null && sendShipOp.getResult().toString().equalsIgnoreCase("y")) {
                            IriJsfUtils.showPopup(cnfrmSendToShippingPopupBind, true);
                        }
                    } else {
                        System.out.println("inside else condition");
                        IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating batch status. " +
                                                                    " Please contact your System Administrator." , 
                                                                  "", FacesMessage.SEVERITY_ERROR);
                    }
                }
                else
                {
                    IriJsfUtils.addFormattedFacesErrorMessage("Please Assign Book Number first !",
                                                              "",
                                                              FacesMessage.SEVERITY_ERROR);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating batch status. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void setCnfrmSendToShippingPopupBind(RichPopup cnfrmSendToShippingPopupBind) {
        this.cnfrmSendToShippingPopupBind = cnfrmSendToShippingPopupBind;
    }

    public RichPopup getCnfrmSendToShippingPopupBind() {
        return cnfrmSendToShippingPopupBind;
    }

    public void printRequestSetsDL(DialogEvent dialogEvent)
    {
        try 
        {
            OperationBinding printOdrOp = IriAdfUtils.findOperation("printOrder");
            printOdrOp.execute();

            if (printOdrOp.getErrors().isEmpty()) {
                if (printOdrOp.getResult() != null && printOdrOp.getResult().toString().length() > 1) {
                    IriJsfUtils.addFormattedFacesErrorMessage(printOdrOp.getResult().toString(), "", FacesMessage.SEVERITY_INFO);
                    AdfFacesContext.getCurrentInstance().addPartialTarget(viewRequestButtonBind);
                }
            } else {
                IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while printing this order. " +
                                                            " Please contact your System Administrator." , 
                                                          "", FacesMessage.SEVERITY_ERROR);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while printing this order. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void setViewRequestButtonBind(RichButton viewRequestButtonBind) {
        this.viewRequestButtonBind = viewRequestButtonBind;
    }

    public RichButton getViewRequestButtonBind() {
        return viewRequestButtonBind;
    }

    public String actionResetOrderPrintStatus()
    {
        try
        {
           OperationBinding resetOrderPrintStatusOp = IriAdfUtils.findOperation("resetAssignBookOrderPrintStatus");
            resetOrderPrintStatusOp.getParamsMap().put("resetFor", null);
            resetOrderPrintStatusOp.execute();

            if (resetOrderPrintStatusOp.getResult() != null && resetOrderPrintStatusOp.getResult().toString().equals("Y")) 
            {
                OperationBinding commitOp = IriAdfUtils.findOperation("Commit");
                commitOp.execute();
                
                IriJsfUtils.addFormattedFacesErrorMessage("Order Print Status Successfully reset !", "",
                                                          FacesMessage.SEVERITY_INFO);
            } else {
                IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while resetting order print status. " +
                                                            " Please contact your System Administrator." ,
                                                          "",
                                                          FacesMessage.SEVERITY_ERROR);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while resetting order print status. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        
        return null;
    }

    public String actionResetOrderLinePrintStatus()
    {
        try
        {
           OperationBinding resetOrderPrintStatusOp = IriAdfUtils.findOperation("resetAssignBookOrderPrintStatus");
            resetOrderPrintStatusOp.getParamsMap().put("resetFor", "L");
            resetOrderPrintStatusOp.execute();

            if (resetOrderPrintStatusOp.getResult() != null && resetOrderPrintStatusOp.getResult().toString().equals("Y")) 
            {
                OperationBinding commitOp = IriAdfUtils.findOperation("Commit");
                commitOp.execute();
                
                IriJsfUtils.addFormattedFacesErrorMessage("Order Line Print Status Successfully reset !", "",
                                                          FacesMessage.SEVERITY_INFO);
            } else {
                IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while resetting order line print status. " +
                                                            " Please contact your System Administrator." ,
                                                          "",
                                                          FacesMessage.SEVERITY_ERROR);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while resetting order print status. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        
        return null;
    }

    public void setPrintRequestSetPopupBind(RichPopup printRequestSetPopupBind) {
        this.printRequestSetPopupBind = printRequestSetPopupBind;
    }

    public RichPopup getPrintRequestSetPopupBind() {
        return printRequestSetPopupBind;
    }

    public String validatePrintAction()
    {
        try
        {
           OperationBinding validatePrintOp = IriAdfUtils.findOperation("validateOrderPrint");
            validatePrintOp.execute();

//            if (validatePrintOp.getResult() != null && validatePrintOp.getResult().toString().equals("Y"))
            if (true) 
            {
                IriJsfUtils.showPopup(printRequestSetPopupBind, true);
            } else {
                IriJsfUtils.addFormattedFacesErrorMessage("Selected Order is on Hold. Please release Hold and try again.",
                                                          "",
                                                          FacesMessage.SEVERITY_ERROR);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while validating print order. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        
        return null;
    }

    public void searchAbnHoldDetailsPopupFetchListener(PopupFetchEvent popupFetchEvent)
    {
        try 
        {
            OperationBinding odrHoldDtlsOp = IriAdfUtils.findOperation("fetchAbnOrderHoldDetails");
            odrHoldDtlsOp.execute();
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching order hold details." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public void updateBatchNotesVCL(ValueChangeEvent valueChangeEvent)
    {
        if(valueChangeEvent.getNewValue() != null && valueChangeEvent.getNewValue() != valueChangeEvent.getOldValue())
        {            
            OperationBinding updNotesOp = IriAdfUtils.findOperation("updateBatchNotesAssignBook");
            updNotesOp.getParamsMap().put("batchNotes", valueChangeEvent.getNewValue());
            updNotesOp.execute();
            
            OperationBinding saveOp = IriAdfUtils.findOperation("Commit");
            saveOp.execute();
            
            IriJsfUtils.addFormattedFacesErrorMessage("Notes Updated Successfully !", null, FacesMessage.SEVERITY_INFO);
        }
    }
        
    public void selectAllCheckRows(ClientEvent clientEvent) {
        // Add event code here...
        Object value = clientEvent.getParameters().get("checkBoxValue");
        System.out.println("selectAllCheckRows value:"+value);
        if(value != null) {
            try 
            {
                    String selectBook = null;
                    
                    if ("true".equals(value)) 
                        selectBook = "Y";
                    else if ("false".equals(value)) 
                        selectBook = "N";
                    
                        
                    if(selectBook != null)
                    {
                        OperationBinding selectBookOp = ADFUtils.findOperation("selectMultipleBooks");
                        selectBookOp.getParamsMap().put("selectBook", selectBook);
                        selectBookOp.execute();
                    }
                
            } catch (Exception e) {
                JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while selecting books." +
                                                       "Please contact your System Administrator.", "",
                                                       FacesMessage.SEVERITY_ERROR);
                e.printStackTrace();
            }
        }
    }

    public void setSelectAllCheckBoxBind(RichSelectBooleanCheckbox selectAllCheckBoxBind) {
        this.selectAllCheckBoxBind = selectAllCheckBoxBind;
    }

    public RichSelectBooleanCheckbox getSelectAllCheckBoxBind() {
        return selectAllCheckBoxBind;
    }
}
