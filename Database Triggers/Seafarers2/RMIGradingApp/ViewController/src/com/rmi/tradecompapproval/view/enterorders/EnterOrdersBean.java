package com.rmi.tradecompapproval.view.enterorders;

import com.rmi.tradecompapproval.adfbc.utils.AdfUtils;
import com.rmi.tradecompapproval.utils.IriAdfUtils;

import com.rmi.tradecompapproval.utils.IriJsfUtils;

import javax.faces.application.FacesMessage;
import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;

import javax.faces.event.ValueChangeEvent;

import javax.faces.validator.ValidatorException;

import oracle.adf.controller.ControllerContext;
import oracle.adf.controller.ViewPortContext;

import oracle.adf.share.ADFContext;
import oracle.adf.view.rich.component.rich.RichMenu;
import oracle.adf.view.rich.component.rich.RichPopup;
import oracle.adf.view.rich.component.rich.data.RichTable;
import oracle.adf.view.rich.component.rich.input.RichInputText;
import oracle.adf.view.rich.component.rich.nav.RichButton;
import oracle.adf.view.rich.component.rich.nav.RichLink;
import oracle.adf.view.rich.context.AdfFacesContext;
import oracle.adf.view.rich.event.DialogEvent;

import oracle.adf.view.rich.event.PopupCanceledEvent;
import oracle.adf.view.rich.event.PopupFetchEvent;

import oracle.adf.view.rich.render.ClientEvent;

import oracle.binding.OperationBinding;

import oracle.jbo.domain.Number;


public class EnterOrdersBean 
{
    private RichPopup findOrderSearchResultsPopup;
    private RichPopup findOrderPopup;
    private RichTable orderLinesTableBinding;
    private RichPopup releaseLineHoldPopup;
    private RichPopup applyLineHoldPopup;
    private RichPopup cancelLineCommentsPopupBind;
    private RichInputText cancelLineCommentBind;
    private String notesUpdated = "N";
    private RichLink additionalOrderInfoLinkBind;
    private RichButton editDocumentsButtonBind;
    private RichMenu actionsMenuBind;

    public EnterOrdersBean() {
    }

    public void searchOrderActionListener(ActionEvent actionEvent) 
    {
        try
        {
           OperationBinding fltrChkOp = IriAdfUtils.findOperation("filterValuesCheck");
            fltrChkOp.execute();

            if (fltrChkOp.getResult() != null && fltrChkOp.getResult().toString().equals("Y")) {
                OperationBinding searchOrderOp = IriAdfUtils.findOperation("searchOrder");
                searchOrderOp.execute();
            } else {
                IriJsfUtils.addFormattedFacesErrorMessage("Please enter value to search !", null,
                                                          FacesMessage.SEVERITY_ERROR);
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching order details. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void resetSearchOrderActionListener(ActionEvent actionEvent) 
    {
        try 
        {
            OperationBinding filterOrderOp = IriAdfUtils.findOperation("resetOrderFilter");
            filterOrderOp.execute();
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while resetting form. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void releaseHoldActionListener(ActionEvent actionEvent) {
        // Add event code here...
    }
    
    public void exceptionHandler()
    {
        //System.out.println("inside EnterOrdersTF exceptionHandler");
        ControllerContext ctx = ControllerContext.getInstance();
        ViewPortContext viewprt = ctx.getCurrentViewPort();

        if (viewprt.isExceptionPresent())
        {
            Exception exc = viewprt.getExceptionData();
            IriJsfUtils.addFormattedFacesErrorMessage("There has been exception while performing this task. ", exc.getMessage(), FacesMessage.SEVERITY_ERROR);
        }
    }

    public void saveAL(ActionEvent actionEvent) 
    {
        try
        {
           OperationBinding saveOp = IriAdfUtils.findOperation("Commit");
            saveOp.execute();
            
            IriJsfUtils.addFormattedFacesErrorMessage("Record Saved Successfully !", null, FacesMessage.SEVERITY_INFO);
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while saving changes." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void cancelAL(ActionEvent actionEvent) 
    {
        try
        {
           OperationBinding cancelOp = IriAdfUtils.findOperation("Rollback");
            cancelOp.execute();
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception on rollback." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void addItemLineAL(ActionEvent actionEvent) 
    {
        try
        {
           OperationBinding addItemLinesOp = IriAdfUtils.findOperation("AddEnterOrderLines");
            addItemLinesOp.execute();
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while adding new order line. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void deleteItemLineAL(ActionEvent actionEvent) 
    {
        try
        {
           OperationBinding delItemLinesOp = IriAdfUtils.findOperation("DeleteEnterOrderLines");
            delItemLinesOp.execute();
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while deleting order line. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void releaseOrderHoldDL(DialogEvent dialogEvent)
    {
        try
        {
            String outcome = ((dialogEvent.getOutcome() != null) ? dialogEvent.getOutcome().toString() : "N");

            if (outcome.equalsIgnoreCase("ok") || outcome.equalsIgnoreCase("release"))
            {
                OperationBinding releaseOdrHoldOp = IriAdfUtils.findOperation("releaseOrderHold");
                releaseOdrHoldOp.execute();

                if (releaseOdrHoldOp.getErrors().isEmpty())
                {
                    IriJsfUtils.addFormattedFacesErrorMessage("Order Released Successfully !", "", FacesMessage.SEVERITY_INFO);
                }
                else {
                    IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while releasing hold from order." +
                                                                " Please contact your System Administrator." , 
                                                              "", FacesMessage.SEVERITY_ERROR);
                }
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while releasing hold from order." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void shipChargesValidator(FacesContext facesContext, UIComponent uIComponent, Object object) 
    {
            if (object != null) {
                Number price = (Number) object;

                if (price.compareTo(new Number(0)) < 0) {
                    throw new ValidatorException(new FacesMessage(FacesMessage.SEVERITY_WARN,
                                                                  "Value cannot be less than 0 !", null));
                }

                if (!IriJsfUtils.isPrecisionValid(37, 4, price)) {
                    throw new ValidatorException(new FacesMessage(FacesMessage.SEVERITY_WARN,
                                                                  "Precision should not be greater than (37,4) !",
                                                                  null));
                }
            }
    }

    public void updateLineItemDL(DialogEvent dialogEvent) 
    {
        try
        {
            String outcome = ((dialogEvent.getOutcome() != null) ? dialogEvent.getOutcome().toString() : "N");

            if (outcome.equalsIgnoreCase("ok") || outcome.equalsIgnoreCase("save")) {
                OperationBinding updLnItmOp = IriAdfUtils.findOperation("updateLineItem");
                updLnItmOp.execute();
                
                System.out.println("updLnItmOp.getResult() :: "+updLnItmOp.getResult());
                
                if(updLnItmOp.getErrors().isEmpty())
                {
                    if((updLnItmOp.getResult() != null && updLnItmOp.getResult().toString().trim().length() < 2))
                        IriJsfUtils.addFormattedFacesErrorMessage("Record updated Successfully !", null, FacesMessage.SEVERITY_INFO);
                    else
                        IriJsfUtils.addFormattedFacesErrorMessage(updLnItmOp.getResult().toString().trim(), null, FacesMessage.SEVERITY_WARN);
                    
//                     OperationBinding saveOp = IriAdfUtils.findOperation("Commit");
//                     saveOp.execute();
                 
                }else{
                    AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating line details." +
                                                         " Please contact your System Administrator.", 
                                                         "", FacesMessage.SEVERITY_ERROR);
                }                
            }
        } catch (Exception e) {
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating line details." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }    

    public void printOrderRequestSetDL(DialogEvent dialogEvent)
    {
        try 
        {
            OperationBinding printOdrOp = IriAdfUtils.findOperation("printSearchOrder");
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
    }

    public String actionResetOrderPrintStatus()
    {
        try
        {
           OperationBinding resetOrderPrintStatusOp = IriAdfUtils.findOperation("resetOrderPrintStatus");
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
           OperationBinding resetOrderPrintStatusOp = IriAdfUtils.findOperation("resetOrderPrintStatus");
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

    public void releaseHoldPopupFetchListener(PopupFetchEvent popupFetchEvent)
    {
        try {
            OperationBinding filterOrderHoldsOp = IriAdfUtils.findOperation("filterOrderHeaderHolds");
            filterOrderHoldsOp.execute();
        } catch (Exception e) {
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching hold details." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void clearFindFormActionListener(ActionEvent actionEvent) {
        // Add event code here...
    }

    public void findOrderActionListener(ActionEvent actionEvent)
    {
        try
        {
           OperationBinding findOrdersOp = IriAdfUtils.findOperation("findOrdersWithParams");
            findOrdersOp.execute();

            if (findOrdersOp.getResult() != null && findOrdersOp.getResult().toString().equals("Y")) 
            {
                findOrderPopup.hide();
                IriJsfUtils.showPopup(findOrderSearchResultsPopup, true);
            } else {
                IriJsfUtils.addFormattedFacesErrorMessage("No Orders found." ,
                                                          "",
                                                          FacesMessage.SEVERITY_ERROR);
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while filtering orders. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void selectOrderDL(DialogEvent dialogEvent)
    {
        try
        {
           OperationBinding findOrdersOp = IriAdfUtils.findOperation("filterSelectedOrder");
            findOrdersOp.execute();
            findOrderPopup.hide();
            AdfFacesContext.getCurrentInstance().addPartialTarget(orderLinesTableBinding);
            AdfFacesContext.getCurrentInstance().addPartialTarget(additionalOrderInfoLinkBind);
            AdfFacesContext.getCurrentInstance().addPartialTarget(editDocumentsButtonBind);
            AdfFacesContext.getCurrentInstance().addPartialTarget(actionsMenuBind);
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while viewing order. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void setFindOrderSearchResultsPopup(RichPopup findOrderSearchResultsPopup) {
        this.findOrderSearchResultsPopup = findOrderSearchResultsPopup;
    }

    public RichPopup getFindOrderSearchResultsPopup() {
        return findOrderSearchResultsPopup;
    }

    public void setFindOrderPopup(RichPopup findOrderPopup) {
        this.findOrderPopup = findOrderPopup;
    }

    public RichPopup getFindOrderPopup() {
        return findOrderPopup;
    }

    public void findOrderTableDblClickListner(ClientEvent clientEvent)
    {
        try
        {
            OperationBinding findOrdersOp = IriAdfUtils.findOperation("filterSelectedOrder");
            findOrdersOp.execute();
            findOrderPopup.hide();
            findOrderSearchResultsPopup.hide();
            AdfFacesContext.getCurrentInstance().addPartialTarget(orderLinesTableBinding);
            AdfFacesContext.getCurrentInstance().addPartialTarget(additionalOrderInfoLinkBind);
            AdfFacesContext.getCurrentInstance().addPartialTarget(editDocumentsButtonBind);
            AdfFacesContext.getCurrentInstance().addPartialTarget(actionsMenuBind);
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while viewing order. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void findOrderSearchResultPopupCancelListener(PopupCanceledEvent popupCanceledEvent)
    {
        if(popupCanceledEvent != null)
        {
            findOrderSearchResultsPopup.hide();
            IriJsfUtils.showPopup(findOrderPopup, true);
        }
    }

    public void setOrderLinesTableBinding(RichTable orderLinesTableBinding) {
        this.orderLinesTableBinding = orderLinesTableBinding;
    }

    public RichTable getOrderLinesTableBinding() {
        return orderLinesTableBinding;
    }


    public void applyHoldDialogListener(DialogEvent dialogEvent) 
    {
        if (dialogEvent.getOutcome().toString().equalsIgnoreCase("ok")) 
        {
            OperationBinding applyHoldOb = IriAdfUtils.findOperation("applyHold");
            applyHoldOb.execute();

            IriJsfUtils.addFormattedFacesErrorMessage("Hold Applied Successfully !", "",
                                                      FacesMessage.SEVERITY_INFO);
        }
    }

    public void applyHoldPopupfetchListener(PopupFetchEvent popupFetchEvent) 
    {
        try {
            OperationBinding ob = IriAdfUtils.findOperation("refreshApplyHold");
            ob.execute();
        } catch (Exception e) {
            // TODO: Add catch code
            e.printStackTrace();
        }  
    }

    public void applyLineHoldDialogListener(DialogEvent dialogEvent)
    {
        String outcome = ((dialogEvent.getOutcome() != null) ? dialogEvent.getOutcome().toString() : "N");

        if (outcome.equalsIgnoreCase("ok") || outcome.equalsIgnoreCase("yes"))
        {            
            OperationBinding applyLineHoldOb = IriAdfUtils.findOperation("applyLineHold");
            applyLineHoldOb.execute();
            
            if (applyLineHoldOb.getErrors().isEmpty())
            {
                IriJsfUtils.addFormattedFacesErrorMessage("Hold Applied Successfully !", "", FacesMessage.SEVERITY_INFO);
            }
            else {
                IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while releasing hold from order line." +
                                                            " Please contact your System Administrator." , 
                                                          "", FacesMessage.SEVERITY_ERROR);
            }
        }
    }

    public void releaseLineHoldDialogListener(DialogEvent dialogEvent)
    {
        try
        {
            String outcome = ((dialogEvent.getOutcome() != null) ? dialogEvent.getOutcome().toString() : "N");

            if (outcome.equalsIgnoreCase("ok") || outcome.equalsIgnoreCase("yes"))
            {
                OperationBinding releaseLineHoldOp = IriAdfUtils.findOperation("releaseLineHold");
                releaseLineHoldOp.execute();
                
                if (releaseLineHoldOp.getErrors().isEmpty())
                {
                    IriJsfUtils.addFormattedFacesErrorMessage("Line Hold Released Successfully !", "", FacesMessage.SEVERITY_INFO);
                }
                else {
                    IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while releasing hold from order line." +
                                                                " Please contact your System Administrator." , 
                                                              "", FacesMessage.SEVERITY_ERROR);
                }
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while releasing hold from order line." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void setReleaseLineHoldPopup(RichPopup releaseLineHoldPopup) {
        this.releaseLineHoldPopup = releaseLineHoldPopup;
    }

    public RichPopup getReleaseLineHoldPopup() {
        return releaseLineHoldPopup;
    }

    public void setApplyLineHoldPopup(RichPopup applyLineHoldPopup) {
        this.applyLineHoldPopup = applyLineHoldPopup;
    }

    public RichPopup getApplyLineHoldPopup() {
        return applyLineHoldPopup;
    }

    public void printLineHoldVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
            System.out.println("valueChangeEvent.getNewValue() :: " + valueChangeEvent.getNewValue());
            System.out.println("valueChangeEvent.getOldValue() :: " + valueChangeEvent.getOldValue());

            if (valueChangeEvent.getNewValue() != null && valueChangeEvent.getOldValue() != null) {
                if ((valueChangeEvent.getNewValue().toString().equalsIgnoreCase("Y") ||
                     valueChangeEvent.getNewValue().toString().equalsIgnoreCase("true")) &&
                    (valueChangeEvent.getOldValue().toString().equalsIgnoreCase("N") ||
                     valueChangeEvent.getOldValue().toString().equalsIgnoreCase("false")))
                    IriJsfUtils.showPopup(applyLineHoldPopup, true);
                else if ((valueChangeEvent.getNewValue().toString().equalsIgnoreCase("N") ||
                          valueChangeEvent.getNewValue().toString().equalsIgnoreCase("false")) &&
                         (valueChangeEvent.getOldValue().toString().equalsIgnoreCase("Y") ||
                          valueChangeEvent.getOldValue().toString().equalsIgnoreCase("true")))
                    IriJsfUtils.showPopup(releaseLineHoldPopup, true);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating Order line Hold." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public String actionRefreshSearchOrder()
    {
        try
        {
           OperationBinding ob = IriAdfUtils.findOperation("refreshSearchOrder");
            ob.execute();
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while refreshing Order." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }

    public void searchOrderHoldDetailsPopupFetchListener(PopupFetchEvent popupFetchEvent)
    {
        try 
        {
            OperationBinding odrHoldDtlsOp = IriAdfUtils.findOperation("fetchSearchOrderHoldDetails");
            odrHoldDtlsOp.execute();
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching order hold details." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public void cancelConfirmPopupDialogListener(DialogEvent dialogEvent) {
        String outcome = ((dialogEvent.getOutcome() != null) ? dialogEvent.getOutcome().toString() : "N");

        if (outcome.equalsIgnoreCase("ok") || outcome.equalsIgnoreCase("yes"))
        {  
            IriJsfUtils.showPopup(cancelLineCommentsPopupBind, true);
        }
        
        }

    public void setCancelLineCommentsPopupBind(RichPopup cancelLineCommentsPopupBind) {
        this.cancelLineCommentsPopupBind = cancelLineCommentsPopupBind;
    }

    public RichPopup getCancelLineCommentsPopupBind() {
        return cancelLineCommentsPopupBind;
    }

    public void setCancelLineCommentBind(RichInputText cancelLineCommentBind) {
        this.cancelLineCommentBind = cancelLineCommentBind;
    }

    public RichInputText getCancelLineCommentBind() {
        return cancelLineCommentBind;
    }

    public void CancelLineDialogListener(DialogEvent dialogEvent) {
        String outcome = ((dialogEvent.getOutcome() != null) ? dialogEvent.getOutcome().toString() : "N");

        if (outcome.equalsIgnoreCase("ok") || outcome.equalsIgnoreCase("yes"))
        {  
            String reason = cancelLineCommentBind.getValue().toString();
            OperationBinding cancelLineOp = IriAdfUtils.findOperation("cancelLineOnSearchOrder");
            cancelLineOp.getParamsMap().put("reason", reason);
            String res =cancelLineOp.execute().toString();
            
            if(res.equalsIgnoreCase("S"))
            {
                    IriJsfUtils.addFormattedFacesErrorMessage("The line has been cancelled !", "", FacesMessage.SEVERITY_INFO);
       
                }
            else
            {
                    IriJsfUtils.addFormattedFacesErrorMessage(res, 
                                                     "", FacesMessage.SEVERITY_ERROR);     
                }
        }
    }

    public void updateBatchNotesVCL(ValueChangeEvent valueChangeEvent)
    {
        if(valueChangeEvent.getNewValue() != null && valueChangeEvent.getNewValue() != valueChangeEvent.getOldValue())
        {            
            OperationBinding updNotesOp = IriAdfUtils.findOperation("updateBatchNotes");
            updNotesOp.getParamsMap().put("batchNotes", valueChangeEvent.getNewValue());
            updNotesOp.execute();            
        }
    }

    public void setNotesUpdated(String notesUpdated) {
        this.notesUpdated = notesUpdated;
    }

    public String getNotesUpdated() {
        return notesUpdated;
    }

    public void updateNotesDialogListener(DialogEvent dialogEvent)
    {
        String outcome = ((dialogEvent.getOutcome() != null) ? dialogEvent.getOutcome().toString() : "N");

        if (outcome.equalsIgnoreCase("ok") || outcome.equalsIgnoreCase("save"))
        {
            OperationBinding saveOp = IriAdfUtils.findOperation("Commit");
            saveOp.execute();
            
            IriJsfUtils.addFormattedFacesErrorMessage("Notes Updated Successfully !", null, FacesMessage.SEVERITY_INFO);
        }
    }

    public void setAdditionalOrderInfoLinkBind(RichLink additionalOrderInfoLinkBind) {
        this.additionalOrderInfoLinkBind = additionalOrderInfoLinkBind;
    }

    public RichLink getAdditionalOrderInfoLinkBind() {
        return additionalOrderInfoLinkBind;
    }

    public void setEditDocumentsButtonBind(RichButton editDocumentsButtonBind) {
        this.editDocumentsButtonBind = editDocumentsButtonBind;
    }

    public RichButton getEditDocumentsButtonBind() {
        return editDocumentsButtonBind;
    }

    public void setActionsMenuBind(RichMenu actionsMenuBind) {
        this.actionsMenuBind = actionsMenuBind;
    }

    public RichMenu getActionsMenuBind() {
        return actionsMenuBind;
    }

    public void itemQtyValidator(FacesContext facesContext, UIComponent uIComponent, Object object) 
    {
        if (object != null) {
            Integer qty = (Integer) object;

            if (qty < 0) {
                throw new ValidatorException(new FacesMessage(FacesMessage.SEVERITY_WARN,
                                                              "Value cannot be less than 0 !", null));
            }

            if (qty.toString().length()> 5) {
                throw new ValidatorException(new FacesMessage(FacesMessage.SEVERITY_WARN,
                                                              "Precision should not be greater than 5 !",
                                                              null));
            }
        }
    }
}
