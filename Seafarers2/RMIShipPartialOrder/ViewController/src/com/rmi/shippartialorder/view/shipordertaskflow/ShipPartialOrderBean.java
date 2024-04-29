package com.rmi.shippartialorder.view.shipordertaskflow;

import com.rmi.shippartialorder.view.utils.IriAdfUtils;

import com.rmi.shippartialorder.view.utils.IriJsfUtils;

import java.math.BigDecimal;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;

import javax.faces.event.ValueChangeEvent;

import oracle.adf.model.BindingContext;
import oracle.adf.view.rich.component.rich.RichPopup;
import oracle.adf.view.rich.component.rich.input.RichInputText;

import oracle.adf.view.rich.event.DialogEvent;

import oracle.binding.BindingContainer;

import oracle.binding.OperationBinding;

import org.apache.myfaces.trinidad.render.ExtendedRenderKitService;
import org.apache.myfaces.trinidad.util.Service;

public class ShipPartialOrderBean {
    private RichInputText bindOrderNum;
    private RichInputText trackingNum;
    private BigDecimal hdrID;
    private String exp_msg;
    private RichPopup popUpBind;
    private String order_sts;
    private String order_hld;
    private String trackFlag="N";
    private String prc_indicator;
    private RichPopup progrssPopupBiind;
    private RichPopup trackingPopup;
    private RichPopup errorPopup;

    public void setPrc_indicator(String prc_indicator) {
        this.prc_indicator = prc_indicator;
    }

    public String getPrc_indicator() {
        return prc_indicator;
    }


    public void setHdrID(BigDecimal hdrID) {
        this.hdrID = hdrID;
    }

    public BigDecimal getHdrID() {
        return hdrID;
    }
    public BindingContainer getBindings(){
            return BindingContext.getCurrent().getCurrentBindingsEntry();
        }
    public void setExp_msg(String exp_msg) {
        this.exp_msg = exp_msg;
    }

    public String getExp_msg() {
        return exp_msg;
    }

    public void setErr_msg(String err_msg) {
        this.err_msg = err_msg;
    }

    public String getErr_msg() {
        return err_msg;
    }

    public void setPrsc_indicator(String prsc_indicator) {
        this.prsc_indicator = prsc_indicator;
    }

    public String getPrsc_indicator() {
        return prsc_indicator;
    }

    public void setOrder_num(BigDecimal order_num) {
        this.order_num = order_num;
    }

    public BigDecimal getOrder_num() {
        return order_num;
    }
    private String err_msg;
    private String prsc_indicator;
    private BigDecimal order_num;

    public ShipPartialOrderBean() {
    }

    public void setBindOrderNum(RichInputText bindOrderNum) {
        this.bindOrderNum = bindOrderNum;
    }

    public RichInputText getBindOrderNum() {
        return bindOrderNum;
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
                IriAdfUtils.addFormattedFacesErrorMessage("System encountered an exception while processing." +
                "Please contact your System Administrator." , 
                "", FacesMessage.SEVERITY_ERROR);
                e.printStackTrace();
            }
        }
    


    

//    public ViewObject getViewObjects(String iterName) {
//        DCBindingContainer bindings = (DCBindingContainer) BindingContext.getCurrent().getCurrentBindingsEntry();
//
//        DCIteratorBinding roleIter = bindings.findIteratorBinding(iterName);
//
//        ViewObject vo = roleIter.getViewObject();
//        return vo;
//    }

   

    public void setTrackingNum(RichInputText trackingNum) {
        this.trackingNum = trackingNum;
    }

    public RichInputText getTrackingNum() {
        return trackingNum;
    }

    public void shipOrderActionListener(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("shipButton");
            String res = ob.execute().toString();
            System.out.println("ob.execute().toString() : "+ob.execute().toString());
            if (res.equalsIgnoreCase("0")) {
                FacesMessage Message = new FacesMessage("Documents shipped successfully.");
                Message.setSeverity(FacesMessage.SEVERITY_INFO);
                FacesContext fc = FacesContext.getCurrentInstance();
                fc.addMessage(null, Message);

            } else if (res.equalsIgnoreCase("2") || res.equalsIgnoreCase("1")) {
                OperationBinding ob2 = getBindings().getOperationBinding("filterErrorTable");
                ob2.execute();

                FacesMessage Message = new FacesMessage("Shipping encountered some errors.");
                Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                FacesContext fc = FacesContext.getCurrentInstance();
                fc.addMessage(null, Message);

                showPopup(errorPopup, true);
            }  else if (res.equalsIgnoreCase("selected")) {
                FacesMessage Message = new FacesMessage("Please select atleast one line to Ship.");
                Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                FacesContext fc = FacesContext.getCurrentInstance();
                fc.addMessage(null, Message);
            } else if (res.equalsIgnoreCase("tracking")) {
                showPopup(trackingPopup, true);
            } else {
                FacesMessage Message = new FacesMessage(res);
                Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                FacesContext fc = FacesContext.getCurrentInstance();
                fc.addMessage(null, Message);
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriAdfUtils.addFormattedFacesErrorMessage("System encountered an exception while shipping." +
            "Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
        }
        // Add event code here...
//        ViewObject shipVO = this.getViewObjects("SicdOrders2VwEOView1Iterator");
//        ViewObject shipPartialVO = this.getViewObjects("SicdShipPartialVwEOView1Iterator");
//        hdrID = (BigDecimal) shipVO.getCurrentRow().getAttribute("HeaderId");
//        order_sts = (String) shipVO.getCurrentRow().getAttribute("OrderStatus");
//        order_hld = (String) shipVO.getCurrentRow().getAttribute("OrderHold");
//        
//       System.out.println(this.trackFlag+" **************");
//            if (this.hdrID == null) {
//                this.exp_msg = "Please query an order to ship";
//                this.showMessege(this.exp_msg, FacesMessage.SEVERITY_WARN);
//                this.trackFlag="D";
//                System.out.println(exp_msg+" ------------- "+trackFlag);
//            }else{
//            if (!this.order_sts.equals("BOOKED")) {
//                this.exp_msg = "Order " + this.order_num + " must be in Booked status.";
//                this.showMessege(this.exp_msg, FacesMessage.SEVERITY_WARN);
//                this.trackFlag="D";
//                System.out.println(exp_msg+" ------------- "+trackFlag);
//            }
//            if (this.order_hld != null) {
//                this.exp_msg = "Order " + this.order_num + " is on credit hold.";
//                this.showMessege(this.exp_msg, FacesMessage.SEVERITY_WARN);
//                this.trackFlag="D";
//                System.out.println(exp_msg+" ------------- "+trackFlag);
//            }  
//            }
//            
//        if (trackFlag.equals("N")) {
//            System.out.println(trackingNum.getValue()+"^^^^^^^^^^^");
//            if(trackingNum.getValue() == null){
//            exp_msg = "No tracking number. Do you want to continue?";
//            RichPopup.PopupHints hints = new RichPopup.PopupHints();
//            this.getPopUpBind().show(hints);
//                System.out.println(exp_msg+" ------------- "+trackFlag);
//            }
//            }      
//
//        System.out.println(this.trackFlag+" **************DD");
    }

//    public void showMessege(String msg, Object d) {
//        FacesMessage Message = new FacesMessage(msg);
//        Message.setSeverity((FacesMessage.Severity) d);
//        FacesContext fc = FacesContext.getCurrentInstance();
//         
//        fc.addMessage(null, Message);
//    }

    public void setPopUpBind(RichPopup popUpBind) {
        this.popUpBind = popUpBind;
    }

    public RichPopup getPopUpBind() {
        return popUpBind;
    }

//    public void shipYesNoDL(DialogEvent dialogEvent) {
//        // Add event code here...
//        if(dialogEvent.getOutcome() == DialogEvent.Outcome.no){
//            this.exp_msg = "Shipping process has been cancelled.";
//            this.showMessege(exp_msg, FacesMessage.SEVERITY_INFO);
//            this.trackingNum.setValue(null);
//            }
//        if(dialogEvent.getOutcome() == DialogEvent.Outcome.yes ){
//            System.out.println("YES ..... go");
//            this.prc_indicator = "Starting Order: "+this.order_num;
//                RichPopup.PopupHints hints = new RichPopup.PopupHints();
//                this.getProgrssPopupBiind().show(hints);
//            }
//    }

    public void setProgrssPopupBiind(RichPopup progrssPopupBiind) {
        this.progrssPopupBiind = progrssPopupBiind;
    }

    public RichPopup getProgrssPopupBiind() {
        return progrssPopupBiind;
    }

    public void trackingConfirmationDialogListener(DialogEvent dialogEvent) {
        try {
//            System.out.println("---11--");
            if (dialogEvent.getOutcome() == DialogEvent.Outcome.yes) {
//                System.out.println("====22==");
                OperationBinding ob = getBindings().getOperationBinding("shipwithouttracking");
                String res = ob.execute().toString();
//                System.out.println("===3===");
                
                System.out.println("ob.execute().toString() :: "+ob.execute().toString());
                
                if (res.equalsIgnoreCase("0")) {
                    //                    System.out.println();
                    FacesMessage Message = new FacesMessage("Documents shipped successfully.");
                    Message.setSeverity(FacesMessage.SEVERITY_INFO);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);

                } else if (res.equalsIgnoreCase("2")) {
                    OperationBinding ob2 = getBindings().getOperationBinding("filterErrorTable");
                    ob2.execute();

                    FacesMessage Message = new FacesMessage("Shipping encountered some errors.");
                    Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);

                    showPopup(errorPopup, true);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriAdfUtils.addFormattedFacesErrorMessage("System encountered an exception while processing." +
            "Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void setTrackingPopup(RichPopup trackingPopup) {
        this.trackingPopup = trackingPopup;
    }

    public RichPopup getTrackingPopup() {
        return trackingPopup;
    }

    public void refreshButton(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("filterShipOrderByNumber");
            ob.execute();
        } catch (Exception e) {
            IriAdfUtils.addFormattedFacesErrorMessage("System encountered an exception while refreshing." +
            "Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
        // Add event code here...
    }

    public void setErrorPopup(RichPopup errorPopup) {
        this.errorPopup = errorPopup;
    }

    public RichPopup getErrorPopup() {
        return errorPopup;
    }

    public void updateButton(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("updateTrackingNumber");
            String res = ob.execute().toString();
                System.out.println("res : "+res);
            if (res.equalsIgnoreCase("0")) {
                FacesMessage Message = new FacesMessage("Tracking Number process completed.");
                Message.setSeverity(FacesMessage.SEVERITY_INFO);
                FacesContext fc = FacesContext.getCurrentInstance();
                fc.addMessage(null, Message);
            } else if (res.equalsIgnoreCase("1") || res.equalsIgnoreCase("2") || res.equalsIgnoreCase("3")) {
                FacesMessage Message = new FacesMessage("Tracking Number process encountered some errors.");
                Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                FacesContext fc = FacesContext.getCurrentInstance();
                fc.addMessage(null, Message);
            } else if (res.equalsIgnoreCase("track")) {
                FacesMessage Message = new FacesMessage("Please enter Tracking Number.");
                Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                FacesContext fc = FacesContext.getCurrentInstance();
                fc.addMessage(null, Message);
            } else if (res.equalsIgnoreCase("credithold")) {
                FacesMessage Message = new FacesMessage("Order is on credit hold.");
                Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                FacesContext fc = FacesContext.getCurrentInstance();
                fc.addMessage(null, Message);
            } else if (res.equalsIgnoreCase("method")) {
                FacesMessage Message = new FacesMessage("Please select Shipping Method.");
                Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                FacesContext fc = FacesContext.getCurrentInstance();
                fc.addMessage(null, Message);
            } else if (res.equalsIgnoreCase("description")) {
                FacesMessage Message = new FacesMessage("Please enter Description.");
                Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                FacesContext fc = FacesContext.getCurrentInstance();
                fc.addMessage(null, Message);
            } else if (res.equalsIgnoreCase("selected")) {
                FacesMessage Message = new FacesMessage("Please select atleast one line to update Tracking Number.");
                Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                FacesContext fc = FacesContext.getCurrentInstance();
                fc.addMessage(null, Message);
            } else {
                FacesMessage Message = new FacesMessage(res);
                Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                FacesContext fc = FacesContext.getCurrentInstance();
                fc.addMessage(null, Message);
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriAdfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating." +
            "Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void shipLineCheckValueChangeListener(ValueChangeEvent valueChangeEvent) {
System.out.println(valueChangeEvent.getNewValue()+"---------");
String check = valueChangeEvent.getNewValue().toString();
        OperationBinding ob = getBindings().getOperationBinding("checkValueChange");
        ob.getParamsMap().put("check", check);
        ob.execute();

    }

    public void saveButton(ActionEvent actionEvent) 
    {

        try {
            OperationBinding procOdrOp = IriAdfUtils.findOperation("Commit");
            procOdrOp.execute();

            if (procOdrOp.getErrors().isEmpty()) {
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
                                                      "Please contact your System Administrator.", "",
                                                      FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }

    }

    public void addtionalOrderDialogListener(DialogEvent dialogEvent) {
        String outcome = ((dialogEvent.getOutcome() != null) ? dialogEvent.getOutcome().toString() : "N");

        if (outcome.equalsIgnoreCase("ok") || outcome.equalsIgnoreCase("save"))
        {
            OperationBinding saveOp = IriAdfUtils.findOperation("Commit");
            saveOp.execute();
            
            IriJsfUtils.addFormattedFacesErrorMessage("Notes Updated Successfully !", null, FacesMessage.SEVERITY_INFO);
        }    }
}
