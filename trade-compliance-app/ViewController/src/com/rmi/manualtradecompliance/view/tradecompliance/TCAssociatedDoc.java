package com.rmi.manualtradecompliance.view.tradecompliance;

import com.rmi.manualtradecompliance.utils.ADFUtils;
import com.rmi.manualtradecompliance.utils.JSFUtils;

import javax.faces.application.FacesMessage;
import javax.faces.event.ActionEvent;

import oracle.adf.controller.ControllerContext;
import oracle.adf.controller.ViewPortContext;
import oracle.adf.view.rich.component.rich.RichPopup;
import oracle.adf.view.rich.component.rich.nav.RichButton;
import oracle.adf.view.rich.component.rich.output.RichInlineFrame;

import oracle.binding.OperationBinding;

public class TCAssociatedDoc {
    private RichButton physicalExaminationButton;

    public int edocid;
    private RichPopup associatedDocPopup;
    private RichInlineFrame inlineFrame;
    RichPopup.PopupHints hints = new RichPopup.PopupHints();

    public String popupHeader;

    public void setPopupHeader(String popupHeader) {
        this.popupHeader = popupHeader;
    }

    public String getPopupHeader() {
        return popupHeader;
    }

    public void setEdocid(int edocid) {
        this.edocid = edocid;
    }

    public int getEdocid() {
        return edocid;
    }


    public TCAssociatedDoc() {
    }

    private String assciatedDocURL;

    public void setAssciatedDocURL(String assciatedDocURL) {
        this.assciatedDocURL = assciatedDocURL;
    }

    public String getAssciatedDocURL() {

        assciatedDocURL = getEdocFullURL();
        return assciatedDocURL;
    }

    public void setPhysicalExaminationButton(RichButton physicalExaminationButton) {

        this.physicalExaminationButton = physicalExaminationButton;
    }

    public RichButton getPhysicalExaminationButton() {
        return physicalExaminationButton;
    }


    public String getEdocFullURL() {
         try 
         {
            OperationBinding edocOp = ADFUtils.findOperation("getEdocFullURL");
             edocOp.getParamsMap().put("edocId", getEdocid());
             edocOp.execute();
             String fullUrl = ((edocOp.getResult()!= null) ?  edocOp.getResult().toString() : "");
            return fullUrl;
        } catch (Exception exp) {
            exp.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching file." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }

    public void physicalExaminationDocActionListner(ActionEvent actionEvent) {
        // Add event code here...
        try {
            setPopupHeader("Physical Examination Doc");
            this.getAssociatedDocPopup().show(hints);
        } catch (Exception exp) {
            exp.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching document." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void identityDocumentActionListner(ActionEvent actionEvent) {
        // Add event code here...
        try {
            setPopupHeader("Identity Document");
            this.getAssociatedDocPopup().show(hints);
        } catch (Exception exp) {
            exp.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching document." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void securityAwarenessDocActionListner(ActionEvent actionEvent) {
        // Add event code here...
        try {
            setPopupHeader("Security Awareness Doc");
            this.getAssociatedDocPopup().show(hints);
        } catch (Exception exp) {
            exp.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching document." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void seaServiceDocActionListner(ActionEvent actionEvent) {
        // Add event code here...
        try {
            setPopupHeader("Sea Service Doc");
            this.getAssociatedDocPopup().show(hints);
        } catch (Exception exp) {
            exp.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching document." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void attestationDocActionListner(ActionEvent actionEvent) {
        // Add event code here...
        try {
            setPopupHeader("Attestation Doc");
            this.getAssociatedDocPopup().show(hints);
        } catch (Exception exp) {
            exp.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching document." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void affidavitDocActionListner(ActionEvent actionEvent) {
        // Add event code here...
        try {
            setPopupHeader("Affidavit Doc");
            this.getAssociatedDocPopup().show(hints);
        } catch (Exception exp) {
            exp.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching document." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void photoIdActionListner(ActionEvent actionEvent) {
        // Add event code here...
        try {
            setPopupHeader("Photo Id Doc");
            this.getAssociatedDocPopup().show(hints);
        } catch (Exception exp) {
            exp.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching document." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void setAssociatedDocPopup(RichPopup associatedDocPopup) {
        this.associatedDocPopup = associatedDocPopup;
    }

    public RichPopup getAssociatedDocPopup() {
        return associatedDocPopup;
    }

    public void setInlineFrame(RichInlineFrame inlineFrame) {
        this.inlineFrame = inlineFrame;
    }

    public RichInlineFrame getInlineFrame() {
        return inlineFrame;
    }

    public void exceptionHandler() {
        //           System.out.println("inside loginuserTF exceptionHandler");
        ControllerContext ctx = ControllerContext.getInstance();
        ViewPortContext viewprt = ctx.getCurrentViewPort();

        if (viewprt.isExceptionPresent()) {
            Exception exc = viewprt.getExceptionData();
            JSFUtils.addFormattedFacesErrorMessage("There has been exception while performing this task. ",
                                                   exc.getMessage(), FacesMessage.SEVERITY_ERROR);
        }
    }
}
