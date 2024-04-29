package com.rmi.tradecompapproval.view.viewbatchseafarer;

import com.rmi.tradecompapproval.utils.IriAdfUtils;

import com.rmi.tradecompapproval.utils.IriJsfUtils;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;

import javax.faces.event.ValueChangeEvent;

import javax.servlet.http.HttpSession;

import oracle.adf.model.BindingContext;

import oracle.adf.share.ADFContext;
import oracle.adf.view.rich.component.rich.RichPopup;
import oracle.adf.view.rich.component.rich.input.RichInputText;

import oracle.adf.view.rich.event.DialogEvent;

import oracle.adf.view.rich.event.PopupFetchEvent;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;


public class BatchDetail {
   
    private RichInputText tradecompstatus;
    private RichInputText tradecompdate;
    private RichPopup sentToEvalPopup;
    private RichPopup sentToCancel;
    private RichPopup sentToAssignBookPopupBind;
    private RichPopup cnfrmSentToAssignBookPopupBind;
    private RichPopup sentToQaPopupBind;
    private RichPopup cnfSendToQaPopupBind;
    private RichPopup cnfSendToEvalPopupBind;
    private RichPopup sentToTcProcessorPopupBind;
    private RichPopup cnfSendToTcPopupBind;

    public BatchDetail() {
    }

    public String viewbatch(ActionEvent actionEvent)
    {
        fetchTcDetails();
        return null;   
    }
    
    public BindingContainer getBindings() {
        return BindingContext.getCurrent().getCurrentBindingsEntry();
    }

    public String sendtoEvaluator(ActionEvent actionEvent) {
        try 
        {
            FacesContext fctx = FacesContext.getCurrentInstance();
            OperationBinding ob = getBindings().getOperationBinding("processTC");
            ob.execute();
            fctx.addMessage("",
                            new FacesMessage(FacesMessage.SEVERITY_INFO,
                                             "Application submitted Sucessfully to Evaluator",
                                             "Application submitted Sucessfully to Evaluator"));
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while sending to Evaluator. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    return "backtotask";
        }

    public void sendtoQA(ActionEvent actionEvent) {
                            
        try 
        {
            FacesContext fctx = FacesContext.getCurrentInstance();
            OperationBinding ob = getBindings().getOperationBinding("processEVAL");
            ob.execute();
            FacesMessage msg =
                new FacesMessage(FacesMessage.SEVERITY_INFO, "Application submitted Sucessfully to QA.",
                                 "Application submitted Sucessfully to QA.");
            fctx.addMessage(null, msg);
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while sending to QA Processor. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }

    }

    public String testservice(ActionEvent actionEvent) {

        return null;
    
    }

    public void setTradecompstatus(RichInputText tradecompstatus) {
        this.tradecompstatus = tradecompstatus;
    }

    public RichInputText getTradecompstatus() {
        return tradecompstatus;
    }

    public void setTradecompdate(RichInputText tradecompdate) {
        this.tradecompdate = tradecompdate;
    }

    public RichInputText getTradecompdate() {
        return tradecompdate;
    }
    
    public void sendToEvaluator(ActionEvent actionEvent) {
        try 
        {
            OperationBinding ob = getBindings().getOperationBinding("sentToEval");
            ob.execute();
            IriJsfUtils.showPopup(sentToEvalPopup, true);
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while sending to Evaluator. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void setSentToEvalPopup(RichPopup sentToEvalPopup) {
        this.sentToEvalPopup = sentToEvalPopup;
    }

    public RichPopup getSentToEvalPopup() {
        return sentToEvalPopup;
    }

    public void cancelbatch(ActionEvent actionEvent) {
        try 
        {
            OperationBinding ob = getBindings().getOperationBinding("cancelbatch");
            ob.execute();

            IriJsfUtils.addFormattedFacesErrorMessage("Batch Canceled Successfully !", "",
                                                      FacesMessage.SEVERITY_INFO);
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while cancelling this batch. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
       // showPopup(sentToCancel, true);
    }

    public void setSentToCancel(RichPopup sentToCancel) {
        this.sentToCancel = sentToCancel;
    }

    public RichPopup getSentToCancel() {
        return sentToCancel;
    }

    public void cancelTask(ActionEvent actionEvent) {
        IriJsfUtils.showPopup(sentToCancel, false);
    }

    public void cancelpopup(ActionEvent actionEvent) {
        IriJsfUtils.showPopup(sentToCancel, true);
    }

    public void fetchTcDetails()
    {
        try 
        {
            String tradestatus = null;
            String tradedate = null;
            OperationBinding filterSfrrOp = IriAdfUtils.findOperation("filterBatchSeafarersDetails");
            filterSfrrOp.execute();
            OperationBinding ob = getBindings().getOperationBinding("callProcedure");
            String tc = (String) ob.execute();
            String[] arrSplit = tc.split(",");
            for (int i = 0; i < arrSplit.length; i++) {
                System.out.println(arrSplit[i]);
            }
            if (arrSplit.length > 0) {
                try {
                    tradestatus = arrSplit[0];
                } catch (ArrayIndexOutOfBoundsException e) {
                }
                try {
                    tradedate = arrSplit[1];
                } catch (ArrayIndexOutOfBoundsException e) {
                }
                tradecompstatus.setVisible(true);
                tradecompdate.setVisible(true);
                tradecompstatus.setValue(tradestatus);
                tradecompdate.setValue(tradedate);
            } else {
                tradecompstatus.setVisible(true);
                tradecompdate.setVisible(true);
                tradestatus = arrSplit[0];
                tradecompstatus.setValue("Not Available");
                tradecompdate.setValue("Not Available");
            }
        } catch (Exception e) {
//            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching TC details. " +
//                                                        " Please contact your System Administrator." , 
//                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void sendToEvalCnfDL(DialogEvent dialogEvent) 
    {        
        try 
        {
            String outcome = ((dialogEvent.getOutcome() != null) ? dialogEvent.getOutcome().toString() : "N");

            if (outcome.equalsIgnoreCase("ok") || outcome.equalsIgnoreCase("yes")) {
                OperationBinding chkSendToEvalOp = IriAdfUtils.findOperation("checkSendToEval");
                chkSendToEvalOp.execute();
                
                String[] retVal;
                String seafarerName = "";
                retVal = chkSendToEvalOp.getResult().toString().split("#");

                if (chkSendToEvalOp.getErrors().isEmpty()) {
                    if (retVal[0] != null && 
                        (retVal[0].equalsIgnoreCase("y") || (retVal[0].equalsIgnoreCase("all")))) 
                    {
                        OperationBinding sendToEvalOp = getBindings().getOperationBinding("sentToEval");
//                        sendToEvalOp.getParamsMap().put("retVal", "All");
                        sendToEvalOp.getParamsMap().put("retVal", retVal[0]);
                        sendToEvalOp.execute();

                        if (sendToEvalOp.getErrors().isEmpty()) {
                            IriJsfUtils.showPopup(sentToEvalPopup, true);
                        } else {
                            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while sending to Evaluator.",
                                                                      " Please contact your System Administrator.",
                                                                      FacesMessage.SEVERITY_ERROR);
                        }
                    } 
                    else if(retVal[0] != null && (retVal[0].equalsIgnoreCase("v")))
                    {
                        cnfSendToEvalPopupBind.hide();
                        IriJsfUtils.addFormattedFacesErrorMessage("All Seafarers in the batch must be Validated before sending it to Evaluator.", 
                                                                  "",
                                                                  FacesMessage.SEVERITY_ERROR);                        
                    }
                    else {
                        if (retVal[1] != null)
                            seafarerName = retVal[1];
                        cnfSendToEvalPopupBind.hide();
//                        IriJsfUtils.addFormattedFacesErrorMessage("Please send Acknowledgement of below Application before sending this batch to Evaluator :: </br>" +
//                                                                  seafarerName, seafarerName,
//                                                                  FacesMessage.SEVERITY_ERROR);
                        IriJsfUtils.addFormattedFacesErrorMessage("No eligible Application found to be sent to Evaluator.", 
                                                                  "",
                                                                  FacesMessage.SEVERITY_ERROR);
                        IriJsfUtils.addFormattedFacesErrorMessage("Either TC Status should be Approved/Provisional" 
                                                                  +" or Acknowledgement Status should be OC Only, for atleast 1 application.", 
                                                                  "",
                                                                  FacesMessage.SEVERITY_ERROR);
                    }
                } else {
                    IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while sending to Evaluator.",
                                                              " Please contact your System Administrator.",
                                                              FacesMessage.SEVERITY_ERROR);
                }
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while sending to Evaluator. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void setSentToAssignBookPopupBind(RichPopup sentToAssignBookPopupBind) {
        this.sentToAssignBookPopupBind = sentToAssignBookPopupBind;
    }

    public RichPopup getSentToAssignBookPopupBind() {
        return sentToAssignBookPopupBind;
    }

    public void setCnfrmSentToAssignBookPopupBind(RichPopup cnfrmSentToAssignBookPopupBind) {
        this.cnfrmSentToAssignBookPopupBind = cnfrmSentToAssignBookPopupBind;
    }

    public RichPopup getCnfrmSentToAssignBookPopupBind() {
        return cnfrmSentToAssignBookPopupBind;
    }

    public void sendToAssignBkNumCfDL(DialogEvent dialogEvent)
    {
        try 
        {
            String outcome = ((dialogEvent.getOutcome() != null) ? dialogEvent.getOutcome().toString() : "N");

            if (outcome.equalsIgnoreCase("ok") || outcome.equalsIgnoreCase("yes")) {
                OperationBinding chkSendToAbnOp = IriAdfUtils.findOperation("checkSendToAssignBook");
                chkSendToAbnOp.execute();

                System.out.println("chkSendToAbnOp.getResult() :: "+chkSendToAbnOp.getResult());

                if (chkSendToAbnOp.getErrors().isEmpty()) {
                    if (chkSendToAbnOp.getResult() != null && (chkSendToAbnOp.getResult().toString().equalsIgnoreCase("Y") 
                           || chkSendToAbnOp.getResult().toString().equalsIgnoreCase("all"))) {
                        OperationBinding sendAsgnBkrOp = IriAdfUtils.findOperation("sendToAssignBookNumber");
                        sendAsgnBkrOp.getParamsMap().put("retVal", chkSendToAbnOp.getResult().toString());
                        sendAsgnBkrOp.execute();

                        System.out.println("sendAsgnBkrOp.getResult() :: "+sendAsgnBkrOp.getResult());

                        if (sendAsgnBkrOp.getErrors().isEmpty()) {
                            if (sendAsgnBkrOp.getResult() != null &&
                                sendAsgnBkrOp.getResult().toString().equalsIgnoreCase("y")) {
                                IriJsfUtils.showPopup(sentToAssignBookPopupBind, true);
                            }
                        } else {
                            System.out.println("sendAsgnBkrOp.getErrors() :: "+sendAsgnBkrOp.getErrors());
                            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while sending this batch to Processor - II.",
                                                                      " Please contact your System Administrator.",
                                                                      FacesMessage.SEVERITY_ERROR);
                        }
                    } else {
                        cnfrmSentToAssignBookPopupBind.hide();
                        IriJsfUtils.addFormattedFacesErrorMessage("Please Verify atleast 1 Application before sending this batch to Processor - II.",
                                                                  "", FacesMessage.SEVERITY_ERROR);
                    }
                } else {
                    System.out.println("chkSendToAbnOp.getErrors() :: "+chkSendToAbnOp.getErrors());
                    IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while sending this batch to Processor - II.",
                                                              " Please contact your System Administrator.",
                                                              FacesMessage.SEVERITY_ERROR);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while sending to Assign Book Number. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void sendToQaCnfDL(DialogEvent dialogEvent)
    {
        try 
        {
            String outcome = ((dialogEvent.getOutcome() != null) ? dialogEvent.getOutcome().toString() : "N");

            if (outcome.equalsIgnoreCase("ok") || outcome.equalsIgnoreCase("yes")) {
                OperationBinding chkSendToQaOp = IriAdfUtils.findOperation("checkSendToMtc");
                chkSendToQaOp.execute();
 
                    String[] retVal;
                    String seafarerName = "";
                    retVal = chkSendToQaOp.getResult().toString().split("#");

                    if (chkSendToQaOp.getErrors().isEmpty()) 
                    {
                        if (retVal[0] != null && (retVal[0].equalsIgnoreCase("y") || (retVal[0].equalsIgnoreCase("all"))))
                        {
                            OperationBinding sendQaOp = IriAdfUtils.findOperation("processEVAL");
                            sendQaOp.getParamsMap().put("retVal", retVal[0]);
//                            sendQaOp.getParamsMap().put("retVal", "All");
                            sendQaOp.execute();
    
                            if (sendQaOp.getErrors().isEmpty()) {
                                IriJsfUtils.showPopup(sentToQaPopupBind, true);
                            } else {
                                IriJsfUtils.addFormattedFacesErrorMessage("There has been an error calling sendToQa method : ",
                                                                          sendQaOp.getErrors().toString(),
                                                                          FacesMessage.SEVERITY_ERROR);
                            }
                        } 
                        else if(retVal[0] != null && (retVal[0].equalsIgnoreCase("CRA")))
                        {
                            cnfSendToQaPopupBind.hide();
                            IriJsfUtils.addFormattedFacesErrorMessage("Please process CRA for any of the Applications in the batch.", 
                                                                      "",
                                                                      FacesMessage.SEVERITY_ERROR);
                        }
                        else {
                            if (retVal[1] != null)
                                seafarerName = retVal[1];
                            cnfSendToQaPopupBind.hide();
                            IriJsfUtils.addFormattedFacesErrorMessage("Please Approve Trade Compliance and Applications before sending this batch to QA.</br>" +
                                                                      seafarerName, seafarerName,
                                                                      FacesMessage.SEVERITY_ERROR);
                        }
                    } else {
                        IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while sending to QA Processor. " +
                                                                    " Please contact your System Administrator.",
                                                                  "",
                                                                  FacesMessage.SEVERITY_ERROR);
                    }
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while sending to QA Processor. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void setSentToQaPopupBind(RichPopup sentToQaPopupBind) {
        this.sentToQaPopupBind = sentToQaPopupBind;
    }

    public RichPopup getSentToQaPopupBind() {
        return sentToQaPopupBind;
    }

    public void setCnfSendToQaPopupBind(RichPopup cnfSendToQaPopupBind) {
        this.cnfSendToQaPopupBind = cnfSendToQaPopupBind;
    }

    public RichPopup getCnfSendToQaPopupBind() {
        return cnfSendToQaPopupBind;
    }

    public void setCnfSendToEvalPopupBind(RichPopup cnfSendToEvalPopupBind) {
        this.cnfSendToEvalPopupBind = cnfSendToEvalPopupBind;
    }

    public RichPopup getCnfSendToEvalPopupBind() {
        return cnfSendToEvalPopupBind;
    }

    public void sendToTcProcessorDL(DialogEvent dialogEvent)
    {
        try 
        {
            String outcome = ((dialogEvent.getOutcome() != null) ? dialogEvent.getOutcome().toString() : "N");

            if (outcome.equalsIgnoreCase("ok") || outcome.equalsIgnoreCase("yes")) {
                OperationBinding chkSendToTc = IriAdfUtils.findOperation("checkSendToQa");
                chkSendToTc.execute();
                
                if (chkSendToTc.getErrors().isEmpty()) {
                    if (chkSendToTc.getResult() != null && (chkSendToTc.getResult().toString().equalsIgnoreCase("Y") 
                         || chkSendToTc.getResult().toString().equalsIgnoreCase("all"))) {
                        OperationBinding sendTcOp = IriAdfUtils.findOperation("sentToTcProcessor");
//                        sendTcOp.getParamsMap().put("retVal", "All");
                        sendTcOp.getParamsMap().put("retVal", chkSendToTc.getResult().toString());
                        sendTcOp.execute();

                        if (sendTcOp.getErrors().isEmpty()) {
                            IriJsfUtils.showPopup(sentToTcProcessorPopupBind, true);
                        } else {
                            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while sending to Trade Compliance Processor. " +
                                                                        " Please contact your System Administrator.",
                                                                      "",
                                                                      FacesMessage.SEVERITY_ERROR);
                        }
                    } else {
                        cnfSendToTcPopupBind.hide();
                        IriJsfUtils.addFormattedFacesErrorMessage("Please Approve atleast 1 Application before sending this batch to Trade Compliance Processor.",
                                                                  "", FacesMessage.SEVERITY_ERROR);
                    }
                } else {
                    IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while sending to Trade Compliance Processor. " +
                                                                " Please contact your System Administrator.",
                                                              "",
                                                              FacesMessage.SEVERITY_ERROR);
                }
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while sending to Trade Compliance Processor. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void setSentToTcProcessorPopupBind(RichPopup sentToTcProcessorPopupBind) {
        this.sentToTcProcessorPopupBind = sentToTcProcessorPopupBind;
    }

    public RichPopup getSentToTcProcessorPopupBind() {
        return sentToTcProcessorPopupBind;
    }

    public void setCnfSendToTcPopupBind(RichPopup cnfSendToTcPopupBind) {
        this.cnfSendToTcPopupBind = cnfSendToTcPopupBind;
    }

    public RichPopup getCnfSendToTcPopupBind() {
        return cnfSendToTcPopupBind;
    }

    public String actionSaveBatch()
    {        
        try 
        {
            OperationBinding procOdrOp = IriAdfUtils.findOperation("Commit");
            procOdrOp.execute();

            if (procOdrOp.getErrors().isEmpty()) 
            {
                    IriJsfUtils.addFormattedFacesErrorMessage("Changes Saved Successfully !", "",
                                                              FacesMessage.SEVERITY_INFO);
                     OperationBinding processOdrOp = IriAdfUtils.findOperation("callProcessOrderHeader");
                            processOdrOp.execute();  
            } else {
                IriJsfUtils.addFormattedFacesErrorMessage("There has been an error calling Process Order method : " +
                                                          procOdrOp.getErrors(), "", FacesMessage.SEVERITY_ERROR);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while processing order." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
             
        return null;
    }

    public void orderHoldDetailsPopupFetchListener(PopupFetchEvent popupFetchEvent)
    {
        try 
        {
            OperationBinding odrHoldDtlsOp = IriAdfUtils.findOperation("fetchOrderHoldDetails");
            odrHoldDtlsOp.execute();
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching order hold details." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public void expeditedCheckBoxVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null)
                ADFContext.getCurrent().getPageFlowScope().put("P_EXPEDITED_SRC", "Y");
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while selecting Expedited." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }
}