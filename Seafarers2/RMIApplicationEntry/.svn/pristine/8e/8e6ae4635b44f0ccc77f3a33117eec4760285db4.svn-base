package com.rmi.applicationEntry.view.batchestaskflow;

import com.rmi.applicationEntry.view.utils.ADFUtils;


import java.util.Map;

import javax.faces.application.FacesMessage;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;

import javax.servlet.http.HttpServletRequest;

import oracle.adf.controller.binding.BindingUtils;
import oracle.adf.model.BindingContext;
import oracle.adf.model.binding.DCBindingContainer;
import oracle.adf.model.binding.DCIteratorBinding;
import oracle.adf.share.ADFContext;
import oracle.adf.view.rich.component.rich.RichPopup;
import oracle.adf.view.rich.component.rich.layout.RichShowDetailItem;
import oracle.adf.view.rich.context.AdfFacesContext;

import oracle.adf.view.rich.event.DialogEvent;

import oracle.adf.view.rich.event.PopupCanceledEvent;
import oracle.adf.view.rich.event.PopupFetchEvent;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

import oracle.jbo.Row;
import oracle.jbo.RowSetIterator;

import oracle.jbo.ViewObject;
import oracle.jbo.domain.Date;

import org.apache.myfaces.trinidad.event.DisclosureEvent;
import org.apache.myfaces.trinidad.render.ExtendedRenderKitService;
import org.apache.myfaces.trinidad.util.Service;

public class BatchesBean {
    private RichPopup deleteMessagePopup;
    private RichPopup confirmationPopup;
    public Date fromDate;
    public String status;
    public String BatchName;
    String photoLink;
    String identityLink;
    String medicalLink;
    String seaserviceLink;
    String attestaionLink;
    String affidavitLink;
    String supportLink;
    String consentLink;
    String additionalDocLink;
    private RichPopup searchInvoicePopup;
    private RichPopup batchDetailOnWorkOrderLink;
    private RichShowDetailItem accountStatusTabBind;

    public void setAdditionalDocLink(String additionalDocLink) {
        this.additionalDocLink = additionalDocLink;
    }

    public String getAdditionalDocLink() {
        return additionalDocLink;
    }
    private RichPopup batchDetailPopup;

    public void setConsentLink(String consentLink) {
        this.consentLink = consentLink;
    }

    public String getConsentLink() {
        return consentLink;
    }

    public void setSupportLink(String supportLink) {
        this.supportLink = supportLink;
    }

    public String getSupportLink() {
        return supportLink;
    }

    public void setSupportLinkVisible(String supportLinkVisible) {
        this.supportLinkVisible = supportLinkVisible;
    }

    public String getSupportLinkVisible() {
        return supportLinkVisible;
    }
    String supportLinkVisible;
    String identityLinkVisible;
    String medicalLinkVisible;
    String seaserviceLinkVisible;

    public void setIdentityLinkVisible(String identityLinkVisible) {
        this.identityLinkVisible = identityLinkVisible;
    }

    public String getIdentityLinkVisible() {
        return identityLinkVisible;
    }

    public void setMedicalLinkVisible(String medicalLinkVisible) {
        this.medicalLinkVisible = medicalLinkVisible;
    }

    public String getMedicalLinkVisible() {
        return medicalLinkVisible;
    }

    public void setSeaserviceLinkVisible(String seaserviceLinkVisible) {
        this.seaserviceLinkVisible = seaserviceLinkVisible;
    }

    public String getSeaserviceLinkVisible() {
        return seaserviceLinkVisible;
    }

    public void setAttestaionLinkVisible(String attestaionLinkVisible) {
        this.attestaionLinkVisible = attestaionLinkVisible;
    }

    public String getAttestaionLinkVisible() {
        return attestaionLinkVisible;
    }

    public void setAffidavitLinkVisible(String affidavitLinkVisible) {
        this.affidavitLinkVisible = affidavitLinkVisible;
    }

    public String getAffidavitLinkVisible() {
        return affidavitLinkVisible;
    }
    String attestaionLinkVisible;
    String affidavitLinkVisible;
    String batch_name;

    public void setBatch_name(String batch_name) {
        this.batch_name = batch_name;
    }

    public String getBatch_name() {
        return batch_name;
    }

    public void setPhotoLink(String photoLink) {
        this.photoLink = photoLink;
    }

    public String getPhotoLink() {
        return photoLink;
    }

    public void setIdentityLink(String identityLink) {
        this.identityLink = identityLink;
    }

    public String getIdentityLink() {
        return identityLink;
    }

    public void setMedicalLink(String medicalLink) {
        this.medicalLink = medicalLink;
    }

    public String getMedicalLink() {
        return medicalLink;
    }

    public void setSeaserviceLink(String seaserviceLink) {
        this.seaserviceLink = seaserviceLink;
    }

    public String getSeaserviceLink() {
        return seaserviceLink;
    }

    public void setAttestaionLink(String attestaionLink) {
        this.attestaionLink = attestaionLink;
    }

    public String getAttestaionLink() {
        return attestaionLink;
    }

    public void setAffidavitLink(String affidavitLink) {
        this.affidavitLink = affidavitLink;
    }

    public String getAffidavitLink() {
        return affidavitLink;
    }

    public void setSecurityLink(String securityLink) {
        this.securityLink = securityLink;
    }

    public String getSecurityLink() {
        return securityLink;
    }
    String securityLink;
    String securityLinkVisible;

    public void setSecurityLinkVisible(String securityLinkVisible) {
        this.securityLinkVisible = securityLinkVisible;
    }

    public String getSecurityLinkVisible() {
        return securityLinkVisible;
    }

    public void setBatchName(String BatchName) {
        this.BatchName = BatchName;
    }

    public String getBatchName() {
        return BatchName;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStatus() {
        return status;
    }

    public void setFromDate(Date fromDate) {
        this.fromDate = fromDate;
    }

    public Date getFromDate() {
        return fromDate;
    }

    public void setToDate(Date toDate) {
        this.toDate = toDate;
    }

    public Date getToDate() {
        return toDate;
    }
    public Date toDate;
    
    public BatchesBean() {
    }
    
    public String createNewBatchAction() {
        try {
            AdfFacesContext adfFacesContext = AdfFacesContext.getCurrentInstance();
            Map pageFlowScope = adfFacesContext.getPageFlowScope();
            pageFlowScope.put("batchMode", "create");
            pageFlowScope.put("batchReject", "no");
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while creating batch." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
        return "batchCreateEdit";
    }

    public BindingContainer getBindings(){
            return BindingContext.getCurrent().getCurrentBindingsEntry();
        }
    public void deleteBatchesActionListener(ActionEvent actionEvent) {
        try {
            BindingContext context = BindingUtils.getBindingContext();
            DCBindingContainer bindings = (DCBindingContainer) context.getCurrentBindingsEntry();
            DCIteratorBinding iterator;
            iterator = (DCIteratorBinding) bindings.findIteratorBinding("PendingBatchesROIterator");
            ViewObject batVO = iterator.getViewObject();
            Row r = batVO.getCurrentRow();
            String batch = r.getAttribute("BatchName").toString();
            setBatch_name(batch);
            showPopup(confirmationPopup, true);
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while deleting batch." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
    }

    public String editButtonAction() {
        try {
            BindingContext context = BindingUtils.getBindingContext();
            DCBindingContainer bindings = (DCBindingContainer) context.getCurrentBindingsEntry();
            DCIteratorBinding iterator;
            iterator = (DCIteratorBinding) bindings.findIteratorBinding("PendingBatchesROIterator");
            ViewObject PendingBatchVO = iterator.getViewObject();
            Row currRow = PendingBatchVO.getCurrentRow();
            Integer batchId = Integer.parseInt(currRow.getAttribute("EsiBatchId").toString());


            AdfFacesContext adfFacesContext = AdfFacesContext.getCurrentInstance();
            Map pageFlowScope = adfFacesContext.getPageFlowScope();
            pageFlowScope.put("batchMode", "edit");
            pageFlowScope.put("batchNumber", batchId);
            pageFlowScope.put("batchReject", "no");
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while editing batch." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
        return "batchCreateEdit";
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

    public void setDeleteMessagePopup(RichPopup deleteMessagePopup) {
        this.deleteMessagePopup = deleteMessagePopup;
    }

    public RichPopup getDeleteMessagePopup() {
        return deleteMessagePopup;
    }

    public void deleteMessageDialogListener(DialogEvent dialogEvent) {
        try {
            if (dialogEvent.getOutcome() == DialogEvent.Outcome.ok) {
                OperationBinding ob = getBindings().getOperationBinding("refreshBatchesVo");
                ob.execute();
            } else {
                // write your custom code for cancel event
            }
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while deleting batch." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
    }

    public void refreshButtonActionListener(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("refreshBatchesVo");
            ob.execute();
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while refreshing batches." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
    }

    public void confirmationDialogListener(DialogEvent dialogEvent) {
        try {
            if (dialogEvent.getOutcome() == DialogEvent.Outcome.ok) {
                BindingContext context = BindingUtils.getBindingContext();
                DCBindingContainer bindings = (DCBindingContainer) context.getCurrentBindingsEntry();
                DCIteratorBinding iterator;
                iterator = (DCIteratorBinding) bindings.findIteratorBinding("PendingBatchesROIterator");
                ViewObject batVO = iterator.getViewObject();
                Row r = batVO.getCurrentRow();
                Integer batchId = Integer.parseInt(r.getAttribute("EsiBatchId").toString());
                String batch = r.getAttribute("BatchName").toString();
                setBatch_name(batch);
                OperationBinding ob = getBindings().getOperationBinding("deleteBatch");
                ob.getParamsMap().put("batchId", batchId);
                String output = ob.execute().toString();
                //                          System.out.println(output+"-----");
                showPopup(deleteMessagePopup, true);

            } else {
            }

        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while deleting batch." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }

            } 


    public void setConfirmationPopup(RichPopup confirmationPopup) {
        this.confirmationPopup = confirmationPopup;
    }

    public RichPopup getConfirmationPopup() {
        return confirmationPopup;
    }

    public String searchButtonDashboard() {
        OperationBinding ob=getBindings().getOperationBinding("searchBatch");
        ob.execute();
        return null;
    }

    public void mailButton(ActionEvent actionEvent) {
        OperationBinding ob=getBindings().getOperationBinding("sendmail");
        ob.execute();
    }


    

    public void documentPopupFetchListener(PopupFetchEvent popupFetchEvent) {
//        System.out.println("-------in the fetch listener");
        try {
            OperationBinding ob1 = getBindings().getOperationBinding("getUsertypeForBatchesPage");
            String user_type = ob1.execute().toString();
            OperationBinding ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0002");
            String path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setPhotoLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0003");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setIdentityLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0004");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setMedicalLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0008");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setSeaserviceLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0001");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setAttestaionLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0009");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setAffidavitLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0016");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setSecurityLink(path);

            ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0031");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setSupportLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0025");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setConsentLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0033");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setAdditionalDocLink(path);

            if (user_type.equalsIgnoreCase("External")) {
                setIdentityLinkVisible("Y");
                setMedicalLinkVisible("Y");
                setAffidavitLinkVisible("Y");
                setAttestaionLinkVisible("Y");
                setSeaserviceLinkVisible("Y");
                setSecurityLinkVisible("Y");
                setSupportLinkVisible("N");
            } else {
                setIdentityLinkVisible("N");
                setMedicalLinkVisible("N");
                setAffidavitLinkVisible("N");
                setAttestaionLinkVisible("N");
                setSeaserviceLinkVisible("N");
                setSecurityLinkVisible("N");
                setSupportLinkVisible("Y");
            }
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching data." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
    }
    
    public void initMethod()
    {
        try {
            String user = ADFContext.getCurrent().getSessionScope().get("param_user_id").toString();
            //           System.out.println("--------1--------user-----"+user);

            OperationBinding ob = getBindings().getOperationBinding("getUserType");
            ob.getParamsMap().put("user_id", user);
            String user_type = ob.execute().toString();
            //        System.out.println(user_type +"----------------user_type");
            AdfFacesContext.getCurrentInstance().getPageFlowScope().put("user_type_batch", user_type);
        } catch (Exception e) {
//            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading page." +
//            " Please contact your System Administrator." , 
//            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
        }

    public String editRejectedButton() {
        try {
            BindingContext context = BindingUtils.getBindingContext();
            DCBindingContainer bindings = (DCBindingContainer) context.getCurrentBindingsEntry();
            DCIteratorBinding iterator;
            iterator = (DCIteratorBinding) bindings.findIteratorBinding("BatchesRejectedROIterator");
            ViewObject PendingBatchVO = iterator.getViewObject();
            Row currRow = PendingBatchVO.getCurrentRow();
            Integer batchId = Integer.parseInt(currRow.getAttribute("EsiBatchId").toString());


            AdfFacesContext adfFacesContext = AdfFacesContext.getCurrentInstance();
            Map pageFlowScope = adfFacesContext.getPageFlowScope();
            pageFlowScope.put("batchMode", "edit");
            pageFlowScope.put("batchNumber", batchId);
            pageFlowScope.put("batchReject", "yes");
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while processing." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
        return "batchCreateEdit";
    }

    public void emailInvoiceButton(ActionEvent actionEvent) {
        try 
        {
            OperationBinding ob = getBindings().getOperationBinding("email_invoice");
            ob.execute();
            
            FacesMessage Message = new FacesMessage("Email sent successfully.");
            Message.setSeverity(FacesMessage.SEVERITY_INFO);
            FacesContext fc = FacesContext.getCurrentInstance();
            fc.addMessage(null, Message);
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while sending invoice." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
                    e.printStackTrace();
        }
    }
   
    public void workOrderlinkOnAccountStatusTab(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("filterSubmittedbatchesForPopup");
            ob.execute();

            showPopup(batchDetailPopup, true);
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading data." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void setBatchDetailPopup(RichPopup batchDetailPopup) {
        this.batchDetailPopup = batchDetailPopup;
    }

    public RichPopup getBatchDetailPopup() {
        return batchDetailPopup;
    }

    public void subittedBatchTabDisclosureListener(DisclosureEvent disclosureEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("resetSubmittedBatches");
            ob.execute();
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading data." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
        }

    public void batchDetailPopupCancelListener(PopupCanceledEvent popupCanceledEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("resetSubmittedBatches");
            ob.execute();
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading data." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }  
        }
    

    public String searchInvoiceAction() 
    {
        try 
        {
            OperationBinding vldtSearchInvoiceOp = getBindings().getOperationBinding("validateSearchInvoice");
            vldtSearchInvoiceOp.execute();

            if (vldtSearchInvoiceOp.getResult() != null &&
                vldtSearchInvoiceOp.getResult().toString().equalsIgnoreCase("Y")) {
                OperationBinding searchInvoiceOp = getBindings().getOperationBinding("searchInvoice");
                searchInvoiceOp.execute();
                searchInvoicePopup.hide();
            } else
                ADFUtils.addFormattedFacesErrorMessage("Please enter at least 1 search parameter.", "",
                                                       FacesMessage.SEVERITY_WARN);
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while Searching Invoice." +
                                          " Please contact your System Administrator.", "", FacesMessage.SEVERITY_ERROR);
        }
        
        return null;
    }

    public String cancelInvoiceAction() {
        searchInvoicePopup.hide();
        return null;
    }

    public void setSearchInvoicePopup(RichPopup searchInvoicePopup) {
        this.searchInvoicePopup = searchInvoicePopup;
    }

    public RichPopup getSearchInvoicePopup() {
        return searchInvoicePopup;
    }

    public void accountStatusTabDisclosureListener(DisclosureEvent disclosureEvent)
    {
//        System.out.println("in the disclosure listener-----");
//        System.out.println(accountStatusTabBind.isDisclosed()+"-----11");
        
        if(accountStatusTabBind.isDisclosed())
        {
        Object userType = AdfFacesContext.getCurrentInstance().getPageFlowScope().get("user_type_batch");
        
        if(userType!= null && userType.toString().equalsIgnoreCase("Internal"))
        {
            OperationBinding accountStatusRowsOp = getBindings().getOperationBinding("getAccountStatusFilteredRows");
            accountStatusRowsOp.execute();

            if(accountStatusRowsOp.getResult() != null && Integer.parseInt(accountStatusRowsOp.getResult().toString()) == 0)
                showPopup(searchInvoicePopup, true);
        }
    }
    }

    public void viewInvoiceButton(ActionEvent actionEvent)
    {        
        try 
        {
            OperationBinding viewInvoiceOp = getBindings().getOperationBinding("viewInvoice");
            viewInvoiceOp.execute();
            
            if(viewInvoiceOp.getResult() != null)
            {
                System.out.println("outputDocument :: "+viewInvoiceOp.getResult().toString());
                previewDocument(viewInvoiceOp.getResult().toString());
//                previewDocument("E:/"+"Test.pdf");
            }
            
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while viewing invoice." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
    }
    

    public String getApplicationUrl()
    {
        FacesContext facesCtx = FacesContext.getCurrentInstance();
        ExternalContext ectx = facesCtx.getExternalContext();
        HttpServletRequest req = (HttpServletRequest) ectx.getRequest();
        String url = req.getRequestURL().toString();
        return url.substring(0, url.length() - req.getRequestURI().length()) + req.getContextPath();
    }

    public void previewDocument(String outputDocument)
    {
        if(outputDocument != null)
        {
            try 
            {
            //            http://iri025.coresys.com:7007/RMILoginApp1/seaf/previewdocumentservlet?path=
            StringBuffer sb = new StringBuffer();
            sb.append("var winPop = true;");
            //                    sb.append("winPop = window.open(\"" +
            //                              ge/faces/Statusboard?BatchId=" "); ");
            //            sb.append("winPop = window.open(\""+getApplicationUrl()+"/seaf/previewdocumentservlet?path=D:\\Testin.req);");
            
            
//                ADFContext.getCurrent().getSessionScope().put("ServletGlobalParam", outputDocument);  
                FacesContext context = FacesContext.getCurrentInstance();
                       context.getExternalContext().getSessionMap().put("userid", outputDocument);
                    
                            sb.append("winPop = window.open(\"" +
                            getApplicationUrl()+"/seaf/previewdocumentservlet?path=" + "-1" +
                            "\", \"_blank\"); ");
            ExtendedRenderKitService erks =
                Service.getRenderKitService(FacesContext.getCurrentInstance(), ExtendedRenderKitService.class);
            StringBuilder script = new StringBuilder();
            script.append(sb.toString());
            erks.addScript(FacesContext.getCurrentInstance(), script.toString());
            } catch (Exception e) {
                e.printStackTrace();
                ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while previewing document." +
                                                       " Please contact your System Administrator.", "",
                                                       FacesMessage.SEVERITY_ERROR);
            }
        }
    }

    public void accountDocumentPopupFetchListener(PopupFetchEvent popupFetchEvent) {
        try {
            OperationBinding ob1 = getBindings().getOperationBinding("getUsertypeForBatchesAccountPage");
            String user_type = ob1.execute().toString();
            OperationBinding ob = getBindings().getOperationBinding("getlinkforBatchesAccountpage");
            ob.getParamsMap().put("code", "0002");
            String path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setPhotoLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchesAccountpage");
            ob.getParamsMap().put("code", "0003");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setIdentityLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchesAccountpage");
            ob.getParamsMap().put("code", "0004");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setMedicalLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchesAccountpage");
            ob.getParamsMap().put("code", "0008");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setSeaserviceLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchesAccountpage");
            ob.getParamsMap().put("code", "0001");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setAttestaionLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchesAccountpage");
            ob.getParamsMap().put("code", "0009");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setAffidavitLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchesAccountpage");
            ob.getParamsMap().put("code", "0016");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setSecurityLink(path);

            ob = getBindings().getOperationBinding("getlinkforBatchesAccountpage");
            ob.getParamsMap().put("code", "0031");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setSupportLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchesAccountpage");
            ob.getParamsMap().put("code", "0025");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setConsentLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchesAccountpage");
            ob.getParamsMap().put("code", "0033");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setAdditionalDocLink(path);

            if (user_type.equalsIgnoreCase("External")) {
                setIdentityLinkVisible("Y");
                setMedicalLinkVisible("Y");
                setAffidavitLinkVisible("Y");
                setAttestaionLinkVisible("Y");
                setSeaserviceLinkVisible("Y");
                setSecurityLinkVisible("Y");
                setSupportLinkVisible("N");
            } else {
                setIdentityLinkVisible("N");
                setMedicalLinkVisible("N");
                setAffidavitLinkVisible("N");
                setAttestaionLinkVisible("N");
                setSeaserviceLinkVisible("N");
                setSecurityLinkVisible("N");
                setSupportLinkVisible("Y");
            }
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching data." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
                    e.printStackTrace();
        }    }

    public void workOrderLinkAction(ActionEvent actionEvent) {
        
showPopup(batchDetailOnWorkOrderLink, true); 
}

    public void setBatchDetailOnWorkOrderLink(RichPopup batchDetailOnWorkOrderLink) {
        this.batchDetailOnWorkOrderLink = batchDetailOnWorkOrderLink;
    }

    public RichPopup getBatchDetailOnWorkOrderLink() {
        return batchDetailOnWorkOrderLink;
    }

    public void testButton(ActionEvent actionEvent) {
showPopup(batchDetailOnWorkOrderLink, true);     }

    public void orderLinkAccount(ActionEvent actionEvent) {
showPopup(batchDetailPopup, true);     }

    public void orderHoldDetailsPopupFetchListener(PopupFetchEvent popupFetchEvent) {
        OperationBinding ob = getBindings().getOperationBinding("filterOrderHold");
            ob.execute();    }

    public void setAccountStatusTabBind(RichShowDetailItem accountStatusTabBind) {
        this.accountStatusTabBind = accountStatusTabBind;
    }

    public RichShowDetailItem getAccountStatusTabBind() {
        return accountStatusTabBind;
    }
}
