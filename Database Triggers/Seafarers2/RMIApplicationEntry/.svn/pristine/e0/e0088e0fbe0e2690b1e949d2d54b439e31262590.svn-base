
package com.rmi.applicationEntry.view.batchcreateedittaskflow;

import com.rmi.applicationEntry.view.utils.ADFUtils;

import java.awt.Graphics;
import java.awt.image.BufferedImage;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import java.io.OutputStream;

import java.sql.SQLException;

import java.text.DateFormat;

import java.text.ParseException;
import java.text.SimpleDateFormat;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;

import java.util.Random;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.faces.application.FacesMessage;
import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;

import javax.faces.event.ValueChangeEvent;

import javax.faces.validator.ValidatorException;

import javax.imageio.ImageIO;


import javax.servlet.http.HttpSession;

import oracle.adf.controller.ControllerContext;
import oracle.adf.controller.ViewPortContext;
import oracle.adf.controller.binding.BindingUtils;
import oracle.adf.model.BindingContext;


import oracle.adf.model.binding.DCBindingContainer;
import oracle.adf.model.binding.DCDataControl;
import oracle.adf.model.binding.DCIteratorBinding;
import oracle.adf.share.ADFContext;
import oracle.adf.view.rich.component.rich.RichPopup;

import oracle.adf.view.rich.component.rich.data.RichTable;
import oracle.adf.view.rich.component.rich.input.RichInputDate;
import oracle.adf.view.rich.component.rich.input.RichInputFile;
import oracle.adf.view.rich.component.rich.input.RichInputListOfValues;
import oracle.adf.view.rich.component.rich.input.RichInputText;
import oracle.adf.view.rich.component.rich.input.RichSelectManyChoice;
import oracle.adf.view.rich.component.rich.input.RichSelectOneRadio;

import oracle.adf.view.rich.component.rich.layout.RichPanelBox;
import oracle.adf.view.rich.component.rich.layout.RichPanelFormLayout;

import oracle.adf.view.rich.component.rich.layout.RichPanelGroupLayout;
import oracle.adf.view.rich.component.rich.layout.RichPanelTabbed;
import oracle.adf.view.rich.component.rich.layout.RichShowDetailItem;
import oracle.adf.view.rich.component.rich.nav.RichButton;
import oracle.adf.view.rich.component.rich.nav.RichLink;
import oracle.adf.view.rich.component.rich.output.RichInlineFrame;
import oracle.adf.view.rich.component.rich.output.RichOutputText;

import oracle.adf.view.rich.component.rich.output.RichPanelCollection;
import oracle.adf.view.rich.context.AdfFacesContext;

import oracle.adf.view.rich.event.DialogEvent;
import oracle.adf.view.rich.event.PopupCanceledEvent;
import oracle.adf.view.rich.event.PopupFetchEvent;

import oracle.adf.view.rich.event.QueryEvent;
import oracle.adf.view.rich.model.FilterableQueryDescriptor;
import oracle.adf.view.rich.render.ClientEvent;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

import oracle.jbo.Row;
import oracle.jbo.ViewObject;

import oracle.jbo.domain.Date;

import oracle.jbo.uicli.binding.JUCtrlListBinding;

import org.apache.myfaces.trinidad.component.UIXEditableValue;
import org.apache.myfaces.trinidad.event.DisclosureEvent;
import org.apache.myfaces.trinidad.model.UploadedFile;
import org.apache.myfaces.trinidad.render.ExtendedRenderKitService;
import org.apache.myfaces.trinidad.util.Service;

import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class BatchCreateEditBean {
    private RichPopup searchSeafarerPopup;
    String documentName = "fin";
    String name;
    Date birthdate;
    Integer seafaId;
    List mulipleEmails = new ArrayList(50);
    List invoiceAgentEmails = new ArrayList(50);
    private RichInputText agentEmailIdInputTextBind;
    private RichSelectManyChoice agentEmailIdManyChoiceBind;
    private RichPopup resubmitConfirmPopup;
    private RichPopup documentHistoryDocsIfacePopup;
    String uploadicon;
    private RichButton useSelectedSeafarerbuttonBind;
    private RichPopup validationnMessagePopup;
    String messageValidate;
    private RichPopup messageValidatePopup;
    private RichTable quickPickOcTableBind;
    private RichTable quickPickSqcTableBind;
    String iFrameNull = null;
    private RichInputText officialNumberBinding;
    private RichInputText imoNumberBinding;
    private RichInputText vesselPkBinding;
    private RichPopup consentConfirmPopupBind;
    private RichPopup deficiencyPopup;
    private RichInputText consentAckNumberBind;
    private RichSelectManyChoice invoiceAgentEmailIdManyChoiceBind;
    private RichTable sqcTableBind;
    private RichTable ocTableBind;
    private RichPopup pressIfNoConfirmationPopupBind;
    private RichPopup pressifConfirmationPopupBind;
    private RichInputText invoiceAgentEmailIdInputTextBind;
    private RichInputDate consentOnlineDate;
    private RichInputText tranInvoiceAgentTextBoxBind;
    private RichPopup unsavedWarningPopupBind;
    private RichPopup unsavedWarningPopupBindBatchPage;

    public void setIFrameNull(String iFrameNull) {
        this.iFrameNull = iFrameNull;
    }

    public String getIFrameNull() {
        return iFrameNull;
    }


    public void setMessageValidate(String messageValidate) {
        this.messageValidate = messageValidate;
    }

    public String getMessageValidate() {
        return messageValidate;
    }

    public void setUploadicon(String uploadicon) {
        this.uploadicon = uploadicon;
    }

    public String getUploadicon() {
        return "#{resource['images:reddot.png']}";
    }

    public void setMulipleEmails(List mulipleEmails) {
        this.mulipleEmails = mulipleEmails;
    }

    public List getMulipleEmails() {
        try {
            OperationBinding ob = getBindings().getOperationBinding("getemaillist");
            Object obj = ob.execute();
            if (obj != null) {
                String mail = obj.toString();
                //              System.out.println(mail+"----mail in bean");
                String[] ret = mail.split(",");
                for (int i = 0; i < ret.length; i++) {
                    //                   System.out.println("ret["+i+"] ::"+ret[i]);
                    Integer inte = Integer.parseInt(ret[i].toString());
                    //                   System.out.println("inte :: "+inte);
                    mulipleEmails.add(inte);
                }
            }
            System.out.println("multipleEmail.size :: " + mulipleEmails.size());
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching mail list." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
        return mulipleEmails;
    }

    public void setInvoiceAgentEmails(List invoiceAgentEmails) {
        this.invoiceAgentEmails = invoiceAgentEmails;
    }

    public List getInvoiceAgentEmails() {
        try {
            OperationBinding ob = getBindings().getOperationBinding("getInvoiceAgentEmailList");
            Object obj = ob.execute();
            if (obj != null) {
                String mail = obj.toString();
                String[] ret = mail.split(",");
                for (int i = 0; i < ret.length; i++) {
                    System.out.println(ret[i]);
                    Integer inte = Integer.parseInt(ret[i].toString());

                    if (invoiceAgentEmails != null)
                        invoiceAgentEmails.add(inte);
                    //NORDIC HAMBURG SHIPMANAGEMENT GMBH & CO. KG
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching invoice agent mail list." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
        return invoiceAgentEmails;
    }

    public void setSeafaId(Integer seafaId) {
        this.seafaId = seafaId;
    }

    public Integer getSeafaId() {
        return seafaId;
    }
    private RichTable searchSeafarerFormBinding;
    private RichPanelCollection panelCollectionBinding;
    private RichShowDetailItem basicInformationtabBind;
    private RichInputFile photoInputFileBind;
    private RichInputFile identityDocFileBind;
    private RichInputFile physicalFileBind;
    private RichInputFile seaserviceFileBind;
    private RichInputFile attestationFileBind;
    private RichInputFile affidavitFileBind;
    private RichInputFile securityFileBind;
    private RichInputFile seaserviceFileEnteredBind;
    private RichInputFile additionalDocumentsBind;

    public void setAdditionalDocumentsBind(RichInputFile additionalDocumentsBind) {
        this.additionalDocumentsBind = additionalDocumentsBind;
    }

    public RichInputFile getAdditionalDocumentsBind() {
        return additionalDocumentsBind;
    }
    private RichPopup docRequestedCOCScanPopup;
    private RichPopup sqcCocScanPopUp;
    private RichPopup sqcSupportDocScanPopUp;
    private RichButton supportingDoumentViewLink;
    private RichButton cocViewLink;
    private RichButton sqcCocViewLink;
    private RichButton sqcSupportDocViewLink;
    private RichPopup gradeOcPopup;
    private RichPopup gradeSqcPopup;
    String consentDocLink;
    private RichInputFile consentUploadDocumentBind;
    private RichButton viewConsentButtonBind;
    String uploadConsentDocVisible;
    String viewConsentButtonVisible;
    private RichPopup consentPopupBind;
    private RichInputDate ocDateOfExpirationBind;
    private RichInputDate sqcDateOfExpBnding;
    private RichPanelFormLayout addressFieldForm;
    private RichInputText batchNameBind;
    private RichPopup resubmitPopupBind;
    private RichPopup listPopupBind;
    private RichShowDetailItem uploadDocumentTabBind;
    private RichShowDetailItem ocTabBind;
    private RichShowDetailItem sqcTabBind;
    private RichPanelGroupLayout panelGroupLayoutBind;
    private RichPanelBox panelBoxBind;
    private RichPanelFormLayout panelFormLayoutBind;
    private RichPanelTabbed panelTabBind;
    private RichInputListOfValues trancityBind;
    private RichInputText residenceCode;
    private RichPopup messagePopup;
    private RichPopup internalAgentCoonfirmationPopup;
    private RichInputFile internalSupportingFileBind;
    private RichPopup documentHistoryPopup;

    public void setUploadConsentDocVisible(String uploadConsentDocVisible) {
        this.uploadConsentDocVisible = uploadConsentDocVisible;
    }

    public String getUploadConsentDocVisible() {
        return uploadConsentDocVisible;
    }

    public void setViewConsentButtonVisible(String viewConsentButtonVisible) {
        this.viewConsentButtonVisible = viewConsentButtonVisible;
    }

    public String getViewConsentButtonVisible() {
        return viewConsentButtonVisible;
    }

    public void setConsentDocLink(String consentDocLink) {
        this.consentDocLink = consentDocLink;
    }

    public String getConsentDocLink() {
        OperationBinding ob = getBindings().getOperationBinding("getlink");
        ob.getParamsMap().put("code", "0025");
        String path = null;
        Object obj = ob.execute();
        if (obj != null) {
            path = obj != null ? obj.toString() : "";
        }
        return path;
    }

    public void setBirthdate(Date birthdate) {
        this.birthdate = birthdate;
    }

    public Date getBirthdate() {
        return birthdate;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
    private RichSelectOneRadio selectDocumentRadio;
    private RichPanelFormLayout seafarerSearchResultForm;
    private RichOutputText recordNotFoundOT;
    private RichPopup uploadDocumentPopup;
    String photoLink;
    String additionalDocumentLink;
    String uploadConsentFieldsDisable;

    public void setUploadConsentFieldsDisable(String uploadConsentFieldsDisable) {
        this.uploadConsentFieldsDisable = uploadConsentFieldsDisable;
    }

    public String getUploadConsentFieldsDisable() {
        return uploadConsentFieldsDisable;
    }

    public void setAdditionalDocumentLink(String additionalDocumentLink) {
        this.additionalDocumentLink = additionalDocumentLink;
    }

    public String getAdditionalDocumentLink() {
        OperationBinding ob = getBindings().getOperationBinding("getlink");
        ob.getParamsMap().put("code", "0033");
        String path = null;
        Object obj = ob.execute();
        if (obj != null) {
            path = obj.toString();
        }
        return path;
    }
    String identityLink;
    String callLinkMethod = "false";
    String ocCocLink;
    String validationMessage = null;
    private RichPopup validationMessagePopup;
    private List<String> message = new ArrayList();
    private RichPopup sendToInternalPopup;
    private RichPopup submitMessagePopup;
    private RichInlineFrame inlineFrameBinding;
    private String inlineFrameSource = null;
    String supportingDocuments;
    private RichPopup scanPopup;

    public void setSupportingDocuments(String supportingDocuments) {
        this.supportingDocuments = supportingDocuments;
    }

    public String getSupportingDocuments() {
        OperationBinding ob = getBindings().getOperationBinding("getlink");
        ob.getParamsMap().put("code", "0031");
        String path = null;
        Object obj = ob.execute();
        if (obj != null) {
            path = obj.toString();
        }
        return path;
    }


    public void setInlineFrameSource(String inlineFrameSource) {
        this.inlineFrameSource = inlineFrameSource;
    }

    public String getInlineFrameSource() {
        return inlineFrameSource;
        //        return "D:\\Test.pdf";
    }


    public void setMessage(List<String> message) {
        this.message = message;
    }

    public List<String> getMessage() {
        return message;
    }

    public void setValidationMessage(String validationMessage) {
        this.validationMessage = validationMessage;
    }

    public String getValidationMessage() {
        return validationMessage;
    }

    public void setOcCocLink(String ocCocLink) {
        this.ocCocLink = ocCocLink;
    }

    public String getOcCocLink() {
        OperationBinding ob = getBindings().getOperationBinding("getlinkforOC");
        String path = null;
        Object obj = ob.execute();
        if (obj != null) {
            path = obj.toString();
        }
        return path;
    }

    public void setCallLinkMethod(String callLinkMethod) {
        this.callLinkMethod = callLinkMethod;
    }

    public String getCallLinkMethod() {
        return callLinkMethod;
    }

    public void setIdentityLink(String identityLink) {
        this.identityLink = identityLink;
    }

    public String getIdentityLink() {
        OperationBinding ob = getBindings().getOperationBinding("getlink");
        ob.getParamsMap().put("code", "0003");
        String path = null;
        Object obj = ob.execute();
        if (obj != null) {
            path = obj.toString();
        }
        return path;
    }


    public void setMedicalLink(String medicalLink) {
        this.medicalLink = medicalLink;
    }

    public String getMedicalLink() {
        OperationBinding ob = getBindings().getOperationBinding("getlink");
        ob.getParamsMap().put("code", "0004");
        String path = null;
        Object obj = ob.execute();
        if (obj != null) {
            path = obj.toString();
        }
        return path;
    }


    public void setSeaserviceLink(String seaserviceLink) {
        this.seaserviceLink = seaserviceLink;
    }

    public String getSeaserviceLink() {
        OperationBinding ob = getBindings().getOperationBinding("getlink");
        ob.getParamsMap().put("code", "0008");
        String path = null;
        Object obj = ob.execute();
        if (obj != null) {
            path = obj.toString();
        }
        return path;
    }


    public void setAttestaionLink(String attestaionLink) {
        this.attestaionLink = attestaionLink;
    }

    public String getAttestaionLink() {
        OperationBinding ob = getBindings().getOperationBinding("getlink");
        ob.getParamsMap().put("code", "0001");
        String path = null;
        Object obj = ob.execute();
        if (obj != null) {
            path = obj.toString();
        }
        return path;
    }


    public void setAffidavitLink(String affidavitLink) {
        this.affidavitLink = affidavitLink;
    }

    public String getAffidavitLink() {
        OperationBinding ob = getBindings().getOperationBinding("getlink");
        ob.getParamsMap().put("code", "0009");
        String path = null;
        Object obj = ob.execute();
        if (obj != null) {
            path = obj.toString();
        }
        return path;

    }


    public void setSecurityLink(String securityLink) {
        this.securityLink = securityLink;
    }

    public String getSecurityLink() {
        OperationBinding ob = getBindings().getOperationBinding("getlink");
        ob.getParamsMap().put("code", "0016");
        String path = null;
        Object obj = ob.execute();
        if (obj != null) {
            path = obj.toString();
        }
        return path;

    }
    String medicalLink;
    String seaserviceLink;
    String attestaionLink;
    String affidavitLink;
    String securityLink;
    String supportingFileLink;

    public void setSupportingFileLink(String supportingFileLink) {
        this.supportingFileLink = supportingFileLink;
    }

    public String getSupportingFileLink() {
        OperationBinding ob = getBindings().getOperationBinding("getlink");
        ob.getParamsMap().put("code", "002");
        String path = null;
        Object obj = ob.execute();
        if (obj != null) {
            path = obj.toString();
        }
        //        System.out.println("-----path------------------"+path);
        return path;
    }

    public void setPhotoLink(String photoLink) {
        this.photoLink = photoLink;
    }

    public String getPhotoLink() {
        OperationBinding ob = getBindings().getOperationBinding("getlink");
        ob.getParamsMap().put("code", "0002");
        String path = null;
        Object obj = ob.execute();
        if (obj != null) {
            path = obj.toString();
        }
        return path;
    }


    public void setDocumentName(String documentName) {
        this.documentName = documentName;
    }

    public String getDocumentName() {
        return documentName;
    }

    public void setDocumentId(Integer documentId) {
        this.documentId = documentId;
    }

    public Integer getDocumentId() {
        return documentId;
    }
    Integer documentId = null;

    public BatchCreateEditBean() {
        setDataCcontrolFrameToSession();
    }
    
    public void setDataCcontrolFrameToSession() {
        String dcFrameName =
            BindingContext.getCurrent().getCurrentDataControlFrame();
        System.out.println("Frame name: " + dcFrameName);

        FacesContext ctx = FacesContext.getCurrentInstance();
        HttpSession session =
            (HttpSession)ctx.getExternalContext().getSession(false);
        session.setAttribute("DC_FRAME_NAME", dcFrameName);
    }


    public BindingContainer getBindings() {
        return BindingContext.getCurrent().getCurrentBindingsEntry();
    }

    public String backButtonAction() 
    {        
        if(isTransactionDirty())
        {
            System.out.println("isTransactionDirty in batch jsff :: "+isTransactionDirty());
            showPopup(unsavedWarningPopupBindBatchPage, true);
            return null;
        }        
        
        return "back";
    }
    // saving batch
    public void saveButtonActionListener(ActionEvent actionEvent) {

        try {
            String uType = AdfFacesContext.getCurrentInstance().getPageFlowScope().get("user_type").toString();
            String testEmail = null;
            String invoiceEmailId = null;

            if (uType.equalsIgnoreCase("Internal") && agentEmailIdManyChoiceBind.isVisible()) {
                String email = null;

                Iterator ite = mulipleEmails.iterator();
                while (ite.hasNext()) {
                    Integer id = Integer.parseInt(ite.next().toString());
                    OperationBinding ob2 = getBindings().getOperationBinding("getEmailByContactId");
                    ob2.getParamsMap().put("p_contact_id", id);
                    String ret = ob2.execute().toString();
                    if (email == null) {
                        email = ret;
                    } else {
                        email = email.concat(",").concat(ret);
                        //                    email = email.concat(str[i].to);
                    }
                }

                testEmail = email;
            }

            if (invoiceAgentEmailIdManyChoiceBind != null && invoiceAgentEmailIdManyChoiceBind.isVisible()) {
                String email = null;
                if(invoiceAgentEmails != null)
                {
                Iterator ite = invoiceAgentEmails.iterator();
                while (ite.hasNext()) {
                    Integer id = Integer.parseInt(ite.next().toString());
                    OperationBinding ob2 = getBindings().getOperationBinding("getEmailByContactId");
                    ob2.getParamsMap().put("p_contact_id", id);
                    String ret = ob2.execute().toString();
                    if (email == null) {
                        email = ret;
                    } else {
                        email = email.concat(",").concat(ret);
                        System.out.println("email :: " + email);
                    }
                }
                invoiceEmailId = email;
            }
            }

            if (uType.equalsIgnoreCase("Internal") && agentEmailIdInputTextBind.isVisible()) {
                String email = null;
                if (agentEmailIdInputTextBind.getValue() != null) {
                    email = agentEmailIdInputTextBind.getValue().toString();
                }
                testEmail = email;
            }
            System.out.println(tranInvoiceAgentTextBoxBind.isVisible()+"-----");
            if(tranInvoiceAgentTextBoxBind.isVisible())
            {
                    String email = null;
                    
                    OperationBinding mailId = getBindings().getOperationBinding("getInvoiceAgentEmailID");
                    Object obj = mailId.execute();   
                    
                    if(obj != null)
                    {
                     email = obj.toString();   
                        }
                    
//                    System.out.println(tranInvoiceAgentTextBoxBind.getValue()+"------11");
//                    if (tranInvoiceAgentTextBoxBind.getValue() != null) {
//                        email = tranInvoiceAgentTextBoxBind.getValue().toString();
//                    }
                    invoiceEmailId = email; 
                
                }

            if (uType.equalsIgnoreCase("Internal") && testEmail == null) {
                ADFUtils.addFormattedFacesErrorMessage("Please add Agent Email ID.", "", FacesMessage.SEVERITY_ERROR);
                return;
            }
System.out.println(invoiceEmailId+"------invoice");
            if (invoiceEmailId == null) {
                ADFUtils.addFormattedFacesErrorMessage("Please select Invoice Agent Email ID.", "",
                                                       FacesMessage.SEVERITY_ERROR);
                return;
            }

            OperationBinding ob = getBindings().getOperationBinding("checkValidationBeforeSave");
            String res = ob.execute().toString();
            if (res.equalsIgnoreCase("false")) {
                FacesMessage Message = new FacesMessage("Please enter all the mandatory fields.");
                Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                FacesContext fc = FacesContext.getCurrentInstance();
                fc.addMessage(getAddressFieldForm().getClientId(), Message);
            } else if (res.equalsIgnoreCase("repeat")) {
                BindingContext context = BindingUtils.getBindingContext();
                DCBindingContainer bindings = (DCBindingContainer) context.getCurrentBindingsEntry();
                DCIteratorBinding iterator;
                iterator = (DCIteratorBinding) bindings.findIteratorBinding("BatchesVOIterator");
                ViewObject batchVO = iterator.getViewObject();
                Row currentRow = batchVO.getCurrentRow();
                System.out.println(currentRow.getAttribute("BatchStatus") + "-----");
                if (currentRow.getAttribute("BatchStatus") != null) {
                    if (!currentRow.getAttribute("BatchStatus").toString().equalsIgnoreCase("Pending_upload_document") &&
                        !currentRow.getAttribute("BatchStatus").toString().equalsIgnoreCase("Submitted") &&
                        !currentRow.getAttribute("BatchStatus").toString().equalsIgnoreCase("Resubmitted")) {
                        System.out.println("---if true--");

                        currentRow.setAttribute("BatchStatus", "Pending");
                    }
                } else {
                    currentRow.setAttribute("BatchStatus", "Pending");
                    System.out.println("---else true--");
                }

                if (uType.equalsIgnoreCase("Internal") && agentEmailIdManyChoiceBind.isVisible()) {
                    String email = null;

                    Iterator ite = mulipleEmails.iterator();
                    while (ite.hasNext()) {
                        Integer id = Integer.parseInt(ite.next().toString());
                        OperationBinding ob2 = getBindings().getOperationBinding("getEmailByContactId");
                        ob2.getParamsMap().put("p_contact_id", id);
                        String ret = ob2.execute().toString();
                        if (email == null) {

                            email = ret;
                        } else {

                            email = email.concat(",").concat(ret);
                            //                    email = email.concat(str[i].to);
                        }
                    }

                    if (email != null) {
                        OperationBinding ob2 = getBindings().getOperationBinding("update_email_id");
                        ob2.getParamsMap().put("email", email);
                        ob2.execute();
                    }
                }

                if (invoiceAgentEmailIdManyChoiceBind != null && invoiceAgentEmailIdManyChoiceBind.isVisible()) {
                    String email = null;
                    Iterator ite = invoiceAgentEmails.iterator();
                    while (ite.hasNext()) {
                        Integer id = Integer.parseInt(ite.next().toString());
                        OperationBinding ob2 = getBindings().getOperationBinding("getEmailByContactId");
                        ob2.getParamsMap().put("p_contact_id", id);
                        String ret = ob2.execute().toString();
                        if (email == null) {
                            email = ret;
                        } else {
                            email = email.concat(",").concat(ret);
                        }
                    }

                    if (email != null) {
                        OperationBinding updateInvoiceEmailOp =
                            getBindings().getOperationBinding("updateInvoiceEmails");
                        updateInvoiceEmailOp.getParamsMap().put("email", email);
                        updateInvoiceEmailOp.execute();
                    }
                }
                if(tranInvoiceAgentTextBoxBind.isVisible())
                {
                    String email = null;
//                   if(tranInvoiceAgentTextBoxBind.getValue() != null)
//                   {
//                           OperationBinding updatetran =
//                               getBindings().getOperationBinding("updateInvoiceEmailFromTran");
//                           updatetran.getParamsMap().put("emailid", tranInvoiceAgentTextBoxBind.getValue().toString());
//                           updatetran.execute();  
//                       
//                       }
                    
                                        OperationBinding mailId = getBindings().getOperationBinding("getInvoiceAgentEmailID");
                    Object obj = mailId.execute();   
                    
                    if(obj != null)
                    {
                     email = obj.toString();   
                        }
                   
                                                   OperationBinding updatetran =
                                                       getBindings().getOperationBinding("updateInvoiceEmailFromTran");
                                                   updatetran.getParamsMap().put("emailid", email);
                                                   updatetran.execute();
                    
                    }

                OperationBinding ob1 = getBindings().getOperationBinding("Commit");
                ob1.execute();
                FacesMessage Message =
                    new FacesMessage("Record saved successfully! The Purchase Order Number entered already exists. Incase you need to change, re-enter the Purchase Order Number and save.");
                Message.setSeverity(FacesMessage.SEVERITY_INFO);

                FacesContext fc = FacesContext.getCurrentInstance();

                fc.addMessage(null, Message);
                
                OperationBinding processOrder =  getBindings().getOperationBinding("callProcessOrderHeader");
                processOrder.execute();
                

            } else {

                BindingContext context = BindingUtils.getBindingContext();
                DCBindingContainer bindings = (DCBindingContainer) context.getCurrentBindingsEntry();
                DCIteratorBinding iterator;
                iterator = (DCIteratorBinding) bindings.findIteratorBinding("BatchesVOIterator");
                ViewObject batchVO = iterator.getViewObject();
                Row currentRow = batchVO.getCurrentRow();
                //       System.out.println(currentRow.getAttribute("BatchStatus")+"------batchStatus");
                if (currentRow.getAttribute("BatchStatus") != null) {
                    if (!currentRow.getAttribute("BatchStatus").toString().equalsIgnoreCase("Pending_upload_document") &&
                        !currentRow.getAttribute("BatchStatus").toString().equalsIgnoreCase("Submitted") &&
                        !currentRow.getAttribute("BatchStatus").toString().equalsIgnoreCase("Resubmitted")) {
                        System.out.println("---if true--");

                        currentRow.setAttribute("BatchStatus", "Pending");
                    }
                } else {
                    currentRow.setAttribute("BatchStatus", "Pending");
                    System.out.println("---else true--");
                }

                if (uType.equalsIgnoreCase("Internal") && agentEmailIdManyChoiceBind.isVisible()) {
                    String email = null;

                    Iterator ite = mulipleEmails.iterator();
                    while (ite.hasNext()) {
                        Integer id = Integer.parseInt(ite.next().toString());
                        OperationBinding ob2 = getBindings().getOperationBinding("getEmailByContactId");
                        ob2.getParamsMap().put("p_contact_id", id);
                        String ret = ob2.execute().toString();
                        if (email == null) {

                            email = ret;
                        } else {

                            email = email.concat(",").concat(ret);
                            //                    email = email.concat(str[i].to);
                        }
                    }

                    if (email != null) {
                        OperationBinding ob2 = getBindings().getOperationBinding("update_email_id");
                        ob2.getParamsMap().put("email", email);
                        ob2.execute();
                    }
                }

                if (invoiceAgentEmailIdManyChoiceBind != null && invoiceAgentEmailIdManyChoiceBind.isVisible()) {
                    String email = null;
                    Iterator ite = invoiceAgentEmails.iterator();
                    while (ite.hasNext()) {
                        Integer id = Integer.parseInt(ite.next().toString());
                        OperationBinding ob2 = getBindings().getOperationBinding("getEmailByContactId");
                        ob2.getParamsMap().put("p_contact_id", id);
                        String ret = ob2.execute().toString();
                        if (email == null) {
                            email = ret;
                        } else {
                            email = email.concat(",").concat(ret);
                        }
                    }

                    if (email != null) {
                        OperationBinding updateInvoiceEmailOp =
                            getBindings().getOperationBinding("updateInvoiceEmails");
                        updateInvoiceEmailOp.getParamsMap().put("email", email);
                        updateInvoiceEmailOp.execute();
                    }
                }
                if(tranInvoiceAgentTextBoxBind.isVisible())
                {
//                   if(tranInvoiceAgentTextBoxBind.getValue() != null)
//                   {
//                           OperationBinding updatetran =
//                               getBindings().getOperationBinding("updateInvoiceEmailFromTran");
//                           updatetran.getParamsMap().put("emailid", tranInvoiceAgentTextBoxBind.getValue().toString());
//                           updatetran.execute();  
//                       
//                       }
                    
                                       String email = null;
//                   if(tranInvoiceAgentTextBoxBind.getValue() != null)
//                   {
//                           OperationBinding updatetran =
//                               getBindings().getOperationBinding("updateInvoiceEmailFromTran");
//                           updatetran.getParamsMap().put("emailid", tranInvoiceAgentTextBoxBind.getValue().toString());
//                           updatetran.execute();  
//                       
//                       }
                    
                                        OperationBinding mailId = getBindings().getOperationBinding("getInvoiceAgentEmailID");
                    Object obj = mailId.execute();   
                    
                    if(obj != null)
                    {
                     email = obj.toString();   
                        }
                   
                                                   OperationBinding updatetran =
                                                       getBindings().getOperationBinding("updateInvoiceEmailFromTran");
                                                   updatetran.getParamsMap().put("emailid", email);
                                                   updatetran.execute(); 
                   
                   
                    
                    }
                OperationBinding ob1 = getBindings().getOperationBinding("Commit");
                ob1.execute();
                FacesMessage Message = new FacesMessage("Record saved successfully!");
                Message.setSeverity(FacesMessage.SEVERITY_INFO);

                FacesContext fc = FacesContext.getCurrentInstance();

                fc.addMessage(null, Message);
                OperationBinding processOrder =  getBindings().getOperationBinding("callProcessOrderHeader");
                processOrder.execute();
            }
            
       if(uType.equalsIgnoreCase("External"))
       {
           
               OperationBinding craAddress =  getBindings().getOperationBinding("addCraForExternalBatch");
               craAddress.execute();   
           }
            
            
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while saving batch." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            //            e.printStackTrace();
        }
    }

    public void searchSeafarerButton(ActionEvent actionEvent) {
        OperationBinding names = getBindings().getOperationBinding("checkNames");
        String check = names.execute().toString();
        if(check.equalsIgnoreCase("null"))
        {
            
        
        setDocumentName("fin");
        setDocumentId(null);
        setName(null);
        setBirthdate(null);
        setSeafaId(null);
        showPopup(searchSeafarerPopup, true);
        }
        else
        {
           showPopup(pressifConfirmationPopupBind, true); 
            
            }
    }

    public void setSearchSeafarerPopup(RichPopup searchSeafarerPopup) {
        this.searchSeafarerPopup = searchSeafarerPopup;
    }

    public RichPopup getSearchSeafarerPopup() {
        return searchSeafarerPopup;
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

    public void cancelSeafarerPopupButton(ActionEvent actionEvent) {

        try {
            OperationBinding ob = getBindings().getOperationBinding("setSeafarer");
            ob.execute();

            selectDocumentRadio.resetValue();
            selectDocumentRadio.setValue("fin");
            searchSeafarerFormBinding.setVisible(false);
            panelCollectionBinding.setVisible(false);
            useSelectedSeafarerbuttonBind.setDisabled(true);
            recordNotFoundOT.setVisible(false);
            searchSeafarerPopup.hide();
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while creating a seafarer." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();
        }
    }

    public void setSelectDocumentRadio(RichSelectOneRadio selectDocumentRadio) {
        this.selectDocumentRadio = selectDocumentRadio;
    }

    public RichSelectOneRadio getSelectDocumentRadio() {
        return selectDocumentRadio;
    }

    public void searchButton(ActionEvent actionEvent) {
        try {
            String docType = getDocumentName();
            Integer docId = getDocumentId();
            Integer rowCount = null;
            //        System.out.println(docType+"---------------"+docId);
            //        System.out.println(getName()+"----"+getBirthdate());
            String uType = AdfFacesContext.getCurrentInstance().getPageFlowScope().get("user_type").toString();
            if (uType.equalsIgnoreCase("Internal")) {
                docType = "LN";
                OperationBinding ob = getBindings().getOperationBinding("searchSeafarer");
                ob.getParamsMap().put("documentId", docId);
                ob.getParamsMap().put("documentType", docType);
                ob.getParamsMap().put("name", getName());
                ob.getParamsMap().put("birth_date", getBirthdate());
                ob.getParamsMap().put("seafarer_id", getSeafaId());
                rowCount = Integer.parseInt(ob.execute().toString());

            } else {
                if (docType.equalsIgnoreCase("fin")) {
                    docType = null;
                }
                OperationBinding ob = getBindings().getOperationBinding("searchSeafarer");
                ob.getParamsMap().put("documentId", docId);
                ob.getParamsMap().put("documentType", docType);
                ob.getParamsMap().put("name", getName());
                ob.getParamsMap().put("birth_date", getBirthdate());
                ob.getParamsMap().put("seafarer_id", getSeafaId());
                rowCount = Integer.parseInt(ob.execute().toString());
            }
            if (rowCount > 0) {
                //         seafarerSearchResultForm.setVisible(true);
                searchSeafarerFormBinding.setVisible(true);
                recordNotFoundOT.setVisible(false);
                panelCollectionBinding.setVisible(true);
                useSelectedSeafarerbuttonBind.setDisabled(false);
            } else {
                //           System.out.println("--------inelse");
                recordNotFoundOT.setVisible(true);
                searchSeafarerFormBinding.setVisible(false);
                panelCollectionBinding.setVisible(false);
                useSelectedSeafarerbuttonBind.setDisabled(true);
            }
        } catch (Exception nfe) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while searching seafarer." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        nfe.printStackTrace();
        }
    }

    public void setSeafarerSearchResultForm(RichPanelFormLayout seafarerSearchResultForm) {
        this.seafarerSearchResultForm = seafarerSearchResultForm;
    }

    public RichPanelFormLayout getSeafarerSearchResultForm() {
        return seafarerSearchResultForm;
    }

    public void setRecordNotFoundOT(RichOutputText recordNotFoundOT) {
        this.recordNotFoundOT = recordNotFoundOT;
    }

    public RichOutputText getRecordNotFoundOT() {
        return recordNotFoundOT;
    }

    public void useSelectedSeafarerButton(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("validateBeforeCopySeafarerValues");
            String res = null;
            Object obj = ob.execute();
            if (obj != null) {
                res = obj.toString();
            }
            if (res.equalsIgnoreCase("error")) {
                FacesMessage Message =
                    new FacesMessage("Please note, that an Application for this Seafarer cannot be made at this time. Please contact the Administrator directly at seafarers@register-iri.com");
                Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                FacesContext fc = FacesContext.getCurrentInstance();
                fc.addMessage(null, Message);
            } else if (res.equalsIgnoreCase("duplicate")) {
                FacesMessage Message = new FacesMessage("This seafarer has already been selected in this batch.");
                Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                FacesContext fc = FacesContext.getCurrentInstance();
                fc.addMessage(null, Message);
            } else {
                ob = getBindings().getOperationBinding("copySeafarerValues");
                ob.execute();
                selectDocumentRadio.resetValue();
                selectDocumentRadio.setValue("fin");
                searchSeafarerFormBinding.setVisible(false);
                panelCollectionBinding.setVisible(false);
                recordNotFoundOT.setVisible(false);
                searchSeafarerPopup.hide();
                useSelectedSeafarerbuttonBind.setDisabled(true);
            }
        } catch (Exception nfe) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching data of selected seafarer." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        nfe.printStackTrace();
        }
    }

    public void imoNumberValueChangeListener(ValueChangeEvent valueChangeEvent) {
        try {
            Integer imo = null;
            if (valueChangeEvent.getNewValue() != null) {

                String str = valueChangeEvent.getNewValue().toString();
                imo = Integer.parseInt(str);


            }
            OperationBinding ob = getBindings().getOperationBinding("imoValueChange");
            ob.getParamsMap().put("imo", imo);
            ob.execute();
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while submitting imo number value." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();
        }

    }

    public void setUploadDocumentPopup(RichPopup uploadDocumentPopup) {
        this.uploadDocumentPopup = uploadDocumentPopup;
    }

    public RichPopup getUploadDocumentPopup() {
        return uploadDocumentPopup;
    }

    public void uploadDocumentActionListener(ActionEvent actionEvent) {
        showPopup(uploadDocumentPopup, true);
    }

    public void uploadPhotoValueChangeListener(ValueChangeEvent valueChangeEvent) {
        try {
            String rejected =
                AdfFacesContext.getCurrentInstance().getPageFlowScope().get("param_rejected_tab").toString();

            UploadedFile file = (UploadedFile) valueChangeEvent.getNewValue();
            RichInputFile inputFileComponent = (RichInputFile) valueChangeEvent.getComponent();
            //            ((UIXEditableValue)valueChangeEvent.getComponent()).resetValue();
            if (valueChangeEvent.getNewValue() != null) {
                if (!file.getFilename().endsWith("jpg") && !file.getFilename().endsWith("jpeg") &&
                    !file.getFilename().endsWith("JPEG") && !file.getFilename().endsWith("JPG")) {
                    inputFileComponent.resetValue();
                    inputFileComponent.setValid(false);
                    FacesMessage Message = new FacesMessage("Only jpg/jpeg files are allowed.");
                    Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);
                } else {
                    File inputFile = uploadedFileToFile(file);
                    BufferedImage image = ImageIO.read(inputFile);
                    int width = image.getWidth();
                    int height = image.getHeight();

                    System.out.println("width : " + width);
                    System.out.println("height : " + height);

                    //                if(width < 130 || width > 170 || height < 130 || height >170)
                    if ((width < 98 || width > 130) || (height < 120 || height > 170)) {
                        inputFileComponent.resetValue();
                        inputFileComponent.setValid(false);
                        //                        FacesMessage Message =
                        //                            new FacesMessage("Photo size is not valid (it should be between 45*35 mm and 32*26 mm).");
                        FacesMessage Message =
                            new FacesMessage("Photo size is not valid. Photo should be between 35*45 mm and 26*32 mm OR between 130*170 pixels and 98*120 pixels.");
                        Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                        FacesContext fc = FacesContext.getCurrentInstance();
                        fc.addMessage(null, Message);
                    } else {
                        InputStream in = file.getInputStream();
                        String fileName = file.getFilename();

                        //            System.out.println(fileName+"-------fileName");
                        OperationBinding ob = getBindings().getOperationBinding("uploadDocument");
                        ob.getParamsMap().put("param1", "SICD");
                        ob.getParamsMap().put("param2", "0002");
                        ob.getParamsMap().put("param3", "Application");
                        ob.getParamsMap().put("fileName", fileName);
                        ob.getParamsMap().put("rejected", rejected);
                        //                String path = (ob.execute() != null) ? ob.execute().toString() : null;
                        Object object = ob.execute();
                        String path = null;
                        if (object != null) {
                            path = object.toString();
                        }
 //                       ADFUtils.uploadFile(in, path);
                        if (path != null)
                            ADFUtils.uploadFile(file, path);
//                        ADFUtils.uploadFile(file, "D:\\"+file.getFilename());
//setInlineFrameSource(null);
                    }
                }
            }
            setInlineFrameSource(getPhotoLink());
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading document." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
    }

    public void submitButton(ActionEvent actionEvent) {
        try {
            OperationBinding validationOnBackButton = getBindings().getOperationBinding("validationOnBackButton");
            String manda = validationOnBackButton.execute().toString(); 
            if(manda.equalsIgnoreCase("success"))
            {
            
            OperationBinding val = getBindings().getOperationBinding("checkValidationBeforeSave");
            String valres = val.execute().toString();
            if (!valres.equalsIgnoreCase("false")) {
                OperationBinding valgrade = getBindings().getOperationBinding("validateOcSQCGrade");
                String valgrdres = valgrade.execute().toString();
                if (valgrdres.equalsIgnoreCase("validated")) {
                    OperationBinding ob = getBindings().getOperationBinding("validateSeafarer");
                    String res = ob.execute().toString();
                    //            System.out.println(res+"---res");
                    if (res.equalsIgnoreCase("Success")) {
                        ob = getBindings().getOperationBinding("updateIssueType");
                        ob.execute();
                        ob = getBindings().getOperationBinding("createOrder");
                        String result = ob.execute().toString();
                        if (result.equalsIgnoreCase("success")) {
                            showPopup(submitMessagePopup, true);
                        } else {
                            ADFUtils.addFormattedFacesErrorMessage(result +
                                                                   " Please contact your System Administrator.", "",
                                                                   FacesMessage.SEVERITY_ERROR);
                        }


                    } else if (res.equalsIgnoreCase("false")) {
                        FacesMessage Message = new FacesMessage("Please add at least one seafarer.");
                        Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                        FacesContext fc = FacesContext.getCurrentInstance();
                        fc.addMessage(null, Message);
                    } else {
                        OperationBinding ob1 = getBindings().getOperationBinding("addValidationMessage");
                        ob1.getParamsMap().put("message", res);
                        ob1.execute();

                        showPopup(messageValidatePopup, true);
                    }
                } else {
                    FacesMessage Message = new FacesMessage(valgrdres);
                    Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);
                }
            } else {
                FacesMessage Message = new FacesMessage("Please enter all the mandatory fields.");
                Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                FacesContext fc = FacesContext.getCurrentInstance();
                fc.addMessage(null, Message);
            }
            }
            else
            {
             ADFUtils.addFormattedFacesErrorMessage("Please enter all the mandatory details for all the seafarers." +
                                                           "", "",
                                                           FacesMessage.SEVERITY_ERROR);    
                }
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while submitting batch." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();

        }
    }

    public static void addFormattedFacesErrorMessage(String header, String detail,
                                                     javax.faces.application.FacesMessage.Severity severity) {
        StringBuilder saveMsg = new StringBuilder("<html><body><b><span style='color:");

        if (severity != null) {
            if (severity.toString().equalsIgnoreCase("INFO 0"))
                saveMsg.append("#000000'>");
            else if (severity.toString().equalsIgnoreCase("WARN 1"))
                saveMsg.append("#000000'>");
            else if (severity.toString().equalsIgnoreCase("ERROR 2"))
                saveMsg.append("#000000'>");
            else
                saveMsg.append("#000000'>");
        } else
            saveMsg.append("#000000'>");

        saveMsg.append(header);
        saveMsg.append("</span></b>");
        saveMsg.append("</br><b>");
        //        saveMsg.append(detail);
        saveMsg.append("</b></body></html>");
        FacesMessage msg = new FacesMessage(saveMsg.toString());
        msg.setSeverity(severity);
        FacesContext.getCurrentInstance().addMessage(null, msg);
    }

    public void sendToOperatorButton(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("assignTaskToOperator");
            ob.execute();

            FacesMessage Message = new FacesMessage("Batch has been successfully submitted to the Operator.");
            Message.setSeverity(FacesMessage.SEVERITY_INFO);
            FacesContext fc = FacesContext.getCurrentInstance();
            fc.addMessage(null, Message);
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while submitting batch." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();
        }
    }

    public void initMethod() {
        try {
            String user = ADFContext.getCurrent().getSessionScope().get("param_user_id").toString();
            //           System.out.println("--------1--------user-----"+user);
            OperationBinding ob = getBindings().getOperationBinding("userHasOperator");
            ob.getParamsMap().put("user_id", user);

            String ret = ob.execute().toString();


            //            System.out.println("ret-------------"+ret);
            AdfFacesContext.getCurrentInstance().getPageFlowScope().put("master", ret);
            ob = getBindings().getOperationBinding("getUserTypeForApplicationSource");
            ob.getParamsMap().put("user_id", user);
            String user_type = ob.execute().toString();
            //        System.out.println(user_type +"----------------user_type");
            AdfFacesContext.getCurrentInstance().getPageFlowScope().put("user_type", user_type);
        } catch (Exception e) {
            //            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading page." +
            //            " Please contact your System Administrator." ,
            //            "", FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();

        }
    }

    public void identityDocValueChangeListener(ValueChangeEvent valueChangeEvent) {
        try {
            String rejected =
                AdfFacesContext.getCurrentInstance().getPageFlowScope().get("param_rejected_tab").toString();

            RichInputFile inputFileComponent = (RichInputFile) valueChangeEvent.getComponent();
            UploadedFile file = (UploadedFile) valueChangeEvent.getNewValue();
            if (valueChangeEvent.getNewValue() != null) {
                if (!file.getFilename().endsWith("pdf") && !file.getFilename().endsWith("PDF")) {
                    inputFileComponent.resetValue();
                    inputFileComponent.setValid(false);
                    FacesMessage Message = new FacesMessage("Only PDF files are allowed.");
                    Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);


                } else {
                    //                showPopup(messagePopup, true);
                    InputStream in = file.getInputStream();
                    String fileName = file.getFilename();
                    //            System.out.println(fileName+"-------fileName");
                    OperationBinding ob = getBindings().getOperationBinding("uploadDocument");
                    ob.getParamsMap().put("param1", "SICD");
                    ob.getParamsMap().put("param2", "0003");
                    ob.getParamsMap().put("param3", "Application");
                    ob.getParamsMap().put("fileName", fileName);
                    ob.getParamsMap().put("rejected", rejected);
                    Object object = ob.execute();
                    String path = null;
                    if (object != null) {
                        path = object.toString();
                    }
                    //            ADFUtils.uploadFile(in, path);
                    if (path != null)
                        ADFUtils.uploadFile(file, path);
                    //                messagePopup.hide();
                }
            }
            setInlineFrameSource(getIdentityLink());
        } catch (IOException e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while upload document." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                            e.printStackTrace();
        }

    }

    public void setDisclosedFirstTab(RichShowDetailItem tabBind) {
        try {
            RichPanelTabbed richPanelTabbed = getPanelTabBind();
            //            System.out.println("setDisclosedFirstTab");
            for (UIComponent child : richPanelTabbed.getChildren()) {
                RichShowDetailItem sdi = (RichShowDetailItem) child;
                if (sdi.getClientId().equals(tabBind.getClientId())) {
                    sdi.setDisclosed(true);
                } else {
                    sdi.setDisclosed(false);
                }
            }
            AdfFacesContext.getCurrentInstance().addPartialTarget(panelTabBind);
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while processing." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();

        }
    }

    public void medicalExamValueChangeListener(ValueChangeEvent valueChangeEvent) {
        try {
            String rejected =
                AdfFacesContext.getCurrentInstance().getPageFlowScope().get("param_rejected_tab").toString();

            RichInputFile inputFileComponent = (RichInputFile) valueChangeEvent.getComponent();
            UploadedFile file = (UploadedFile) valueChangeEvent.getNewValue();
            if (valueChangeEvent.getNewValue() != null) {
                if (!file.getFilename().endsWith("pdf") && !file.getFilename().endsWith("PDF")) {
                    inputFileComponent.resetValue();
                    inputFileComponent.setValid(false);
                    FacesMessage Message = new FacesMessage("Only PDF files are allowed.");
                    Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);


                } else {
                    InputStream in = file.getInputStream();
                    String fileName = file.getFilename();
                    //            System.out.println(fileName+"-------fileName");
                    OperationBinding ob = getBindings().getOperationBinding("uploadDocument");
                    ob.getParamsMap().put("param1", "SICD");
                    ob.getParamsMap().put("param2", "0004");
                    ob.getParamsMap().put("param3", "Application");
                    ob.getParamsMap().put("fileName", fileName);
                    ob.getParamsMap().put("rejected", rejected);
                    Object object = ob.execute();
                    String path = null;
                    if (object != null) {
                        path = object.toString();
                    }
                    //            ADFUtils.uploadFile(in, path);
                    if (path != null)
                        ADFUtils.uploadFile(file, path);
                }
            }
            setInlineFrameSource(getMedicalLink());
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading document." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }

    }

    public void seaServiceEntredValueChangeListener(ValueChangeEvent valueChangeEvent) {
        try {
            String rejected =
                AdfFacesContext.getCurrentInstance().getPageFlowScope().get("param_rejected_tab").toString();

            RichInputFile inputFileComponent = (RichInputFile) valueChangeEvent.getComponent();
            UploadedFile file = (UploadedFile) valueChangeEvent.getNewValue();
            if (valueChangeEvent.getNewValue() != null) {
                if (!file.getFilename().endsWith("pdf") && !file.getFilename().endsWith("PDF")) {
                    inputFileComponent.resetValue();
                    inputFileComponent.setValid(false);
                    FacesMessage Message = new FacesMessage("Only PDF files are allowed.");
                    Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);


                } else {
                    InputStream in = file.getInputStream();
                    String fileName = file.getFilename();
                    //            System.out.println(fileName+"-------fileName");
                    OperationBinding ob = getBindings().getOperationBinding("uploadDocument");
                    ob.getParamsMap().put("param1", "SICD");
                    ob.getParamsMap().put("param2", "0008");
                    ob.getParamsMap().put("param3", "Application");
                    ob.getParamsMap().put("fileName", fileName);
                    ob.getParamsMap().put("rejected", rejected);
                    Object object = ob.execute();
                    String path = null;
                    if (object != null) {
                        path = object.toString();
                    }
                    //            ADFUtils.uploadFile(in, path);
                    if (path != null)
                        ADFUtils.uploadFile(file, path);
                }
            }
            setInlineFrameSource(getSeaserviceLink());
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading document." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                            e.printStackTrace();
        }

    }

    public void seaServiceTranscriptValueChangeListener(ValueChangeEvent valueChangeEvent) {
        try {
            String rejected =
                AdfFacesContext.getCurrentInstance().getPageFlowScope().get("param_rejected_tab").toString();

            RichInputFile inputFileComponent = (RichInputFile) valueChangeEvent.getComponent();
            UploadedFile file = (UploadedFile) valueChangeEvent.getNewValue();
            if (valueChangeEvent.getNewValue() != null) {
                if (!file.getFilename().endsWith("pdf") && !file.getFilename().endsWith("PDF")) {
                    inputFileComponent.resetValue();
                    inputFileComponent.setValid(false);
                    FacesMessage Message = new FacesMessage("Only PDF files are allowed.");
                    Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);


                } else {
                    InputStream in = file.getInputStream();
                    String fileName = file.getFilename();
                    //            System.out.println(fileName+"-------fileName");
                    OperationBinding ob = getBindings().getOperationBinding("uploadDocument");
                    ob.getParamsMap().put("param1", "SICD");
                    ob.getParamsMap().put("param2", "0008");
                    ob.getParamsMap().put("param3", "Application");
                    ob.getParamsMap().put("fileName", fileName);
                    ob.getParamsMap().put("rejected", rejected);
                    Object object = ob.execute();
                    String path = null;
                    if (object != null) {
                        path = object.toString();
                    }
                    //            ADFUtils.uploadFile(in, path);
                    if (path != null)
                        ADFUtils.uploadFile(file, path);
                }
            }
            setInlineFrameSource(getSeaserviceLink());
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading document." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                            e.printStackTrace();
        }

    }

    public void attestationValueChangeLIstener(ValueChangeEvent valueChangeEvent) {
        try {
            String rejected =
                AdfFacesContext.getCurrentInstance().getPageFlowScope().get("param_rejected_tab").toString();

            RichInputFile inputFileComponent = (RichInputFile) valueChangeEvent.getComponent();
            UploadedFile file = (UploadedFile) valueChangeEvent.getNewValue();
            if (valueChangeEvent.getNewValue() != null) {
                if (!file.getFilename().endsWith("pdf") && !file.getFilename().endsWith("PDF")) {
                    inputFileComponent.resetValue();
                    inputFileComponent.setValid(false);
                    FacesMessage Message = new FacesMessage("Only PDF files are allowed.");
                    Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);


                } else {
                    InputStream in = file.getInputStream();
                    String fileName = file.getFilename();
                    //            System.out.println(fileName+"-------fileName");
                    OperationBinding ob = getBindings().getOperationBinding("uploadDocument");
                    ob.getParamsMap().put("param1", "SICD");
                    ob.getParamsMap().put("param2", "0001");
                    ob.getParamsMap().put("param3", "Application");
                    ob.getParamsMap().put("fileName", fileName);
                    ob.getParamsMap().put("rejected", rejected);
                    Object object = ob.execute();
                    String path = null;
                    if (object != null) {
                        path = object.toString();
                    }
                    //            ADFUtils.uploadFile(in, path);
                    if (path != null)
                        ADFUtils.uploadFile(file, path);
                    //            ADFUtils.uploadFile(file, "D:\\"+file.getFilename());
                }
            }
            setInlineFrameSource(getAttestaionLink());
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading document." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                            e.printStackTrace();
        }

    }

    public void affidavitValueChangeListener(ValueChangeEvent valueChangeEvent) {
        try {
            String rejected =
                AdfFacesContext.getCurrentInstance().getPageFlowScope().get("param_rejected_tab").toString();

            RichInputFile inputFileComponent = (RichInputFile) valueChangeEvent.getComponent();
            UploadedFile file = (UploadedFile) valueChangeEvent.getNewValue();
            if (valueChangeEvent.getNewValue() != null) {
                if (!file.getFilename().endsWith("pdf") && !file.getFilename().endsWith("PDF")) {
                    inputFileComponent.resetValue();
                    inputFileComponent.setValid(false);
                    FacesMessage Message = new FacesMessage("Only PDF files are allowed.");
                    Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);


                } else {
                    InputStream in = file.getInputStream();
                    String fileName = file.getFilename();
                    //            System.out.println(fileName+"-------fileName");
                    OperationBinding ob = getBindings().getOperationBinding("uploadDocument");
                    ob.getParamsMap().put("param1", "SICD");
                    ob.getParamsMap().put("param2", "0009");
                    ob.getParamsMap().put("param3", "Application");
                    ob.getParamsMap().put("fileName", fileName);
                    ob.getParamsMap().put("rejected", rejected);
                    Object object = ob.execute();
                    String path = null;
                    if (object != null) {
                        path = object.toString();
                    } //            ADFUtils.uploadFile(in, path);
                    if (path != null)
                        ADFUtils.uploadFile(file, path);
                }
            }
            setInlineFrameSource(getAffidavitLink());
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading document." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                            e.printStackTrace();
        }

    }

    public void securityAwarenessValueChangeListener(ValueChangeEvent valueChangeEvent) {
        try {
            String rejected =
                AdfFacesContext.getCurrentInstance().getPageFlowScope().get("param_rejected_tab").toString();

            RichInputFile inputFileComponent = (RichInputFile) valueChangeEvent.getComponent();
            UploadedFile file = (UploadedFile) valueChangeEvent.getNewValue();
            if (valueChangeEvent.getNewValue() != null) {
                if (!file.getFilename().endsWith("pdf") && !file.getFilename().endsWith("PDF")) {
                    inputFileComponent.resetValue();
                    inputFileComponent.setValid(false);
                    FacesMessage Message = new FacesMessage("Only PDF files are allowed.");
                    Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);


                } else {
                    InputStream in = file.getInputStream();
                    String fileName = file.getFilename();
                    //            System.out.println(fileName+"-------fileName");
                    OperationBinding ob = getBindings().getOperationBinding("uploadDocument");
                    ob.getParamsMap().put("param1", "SICD");
                    ob.getParamsMap().put("param2", "0016");
                    ob.getParamsMap().put("param3", "Application");
                    ob.getParamsMap().put("fileName", fileName);
                    ob.getParamsMap().put("rejected", rejected);
                    Object object = ob.execute();
                    String path = null;
                    if (object != null) {
                        path = object.toString();
                    } //            ADFUtils.uploadFile(in, path);
                    if (path != null)
                        ADFUtils.uploadFile(file, path);
                }
            }
            setInlineFrameSource(getSecurityLink());
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading document." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                            e.printStackTrace();
        }

    }


    public void uploadDocumentPopupFetchListener(PopupFetchEvent popupFetchEvent) {
        setCallLinkMethod("true");
    }

    public void saveSeafarerButton(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("existsSeafarer");
            String res = ob.execute().toString();
            if (res.equalsIgnoreCase("sucess")) {
                try {
                    ob = getBindings().getOperationBinding("Commit");
                    ob.execute();

                    Object currentEsiBatchId = ADFContext.getCurrent().getPageFlowScope().get("CURRENT_ESI_BATCH_ID");
                    System.out.println("CURRENT_ESI_BATCH_ID in ApplicationEntry.BatchCreateEditBean after Save :: "+ currentEsiBatchId);
                    
//                    BindingContext context = BindingUtils.getBindingContext();
//                    DCBindingContainer bindings = (DCBindingContainer) context.getCurrentBindingsEntry();
//                    DCIteratorBinding iterator;
//                    iterator = (DCIteratorBinding) bindings.findIteratorBinding("SeafarerVOIterator");
//                    iterator.executeQuery();
//
//                    currentEsiBatchId = ADFContext.getCurrent().getPageFlowScope().get("CURRENT_ESI_BATCH_ID");
//                    System.out.println("CURRENT_ESI_BATCH_ID in ApplicationEntry.BatchCreateEditBean after execute query :: "+ currentEsiBatchId);
//                    
//                    if(iterator.getCurrentRow() != null) 
//                        System.out.println("seafarer currentRow EsiBatchId :: "+iterator.getCurrentRow().getAttribute("EsiBatchId"));
                    
                    FacesMessage Message = new FacesMessage("Record saved successfully!");
                    Message.setSeverity(FacesMessage.SEVERITY_INFO);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);
                } catch (Exception e) {
                    ob = getBindings().getOperationBinding("Commit");
                    ob.execute();
                    FacesMessage Message = new FacesMessage("Record saved successfully!");
                    Message.setSeverity(FacesMessage.SEVERITY_INFO);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);
                    e.printStackTrace();
                }
            }  else if (res.equalsIgnoreCase("permanent")) {
                OperationBinding msgob = getBindings().getOperationBinding("seafarerValidationMessage");
                String message = msgob.execute().toString();

                FacesMessage Message = new FacesMessage(message);
                Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                FacesContext fc = FacesContext.getCurrentInstance();
                fc.addMessage(null, Message);
            }
            else if (res.equalsIgnoreCase("error")) {
                            FacesMessage Message = new FacesMessage("Seafarer's book should be 'New' as this is a new seafarer.");
                            Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                            FacesContext fc = FacesContext.getCurrentInstance();
                            fc.addMessage(null, Message);
                        }
            else if(res.equalsIgnoreCase("ocgrade"))
            {
                    FacesMessage Message = new FacesMessage("Please select grade for all the OC lines.");
                    Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);   
                
                }
            else if(res.equalsIgnoreCase("sqcgrade"))
            {
                    FacesMessage Message = new FacesMessage("Please select grade for all the SQC lines.");
                    Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);  
                
                }
            else {
                FacesMessage Message = new FacesMessage("City is mandatory for Russia and Ukraine.");
                Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                FacesContext fc = FacesContext.getCurrentInstance();
                fc.addMessage(null, Message);

            }
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while saving seafarer." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }

    }

    public String cancelSeafarerButton() {
        try 
        {
            
//            OperationBinding deleteSingleSeafarer = getBindings().getOperationBinding("deleteSingleSeafarer");
//            deleteSingleSeafarer.execute();
            
            OperationBinding validate = getBindings().getOperationBinding("validationOnBackButton");
            String res = validate.execute().toString();
            if(res.equalsIgnoreCase("success"))
            {
            
            setDisclosedFirstTab(basicInformationtabBind);
//                OperationBinding commit = getBindings().getOperationBinding("Commit");
//                commit.execute();
//            OperationBinding ob = getBindings().getOperationBinding("cancelSeafarer");
//            ob.execute();
            
                if(isTransactionDirty())
                {
                    System.out.println("isTransactionDirty :: "+isTransactionDirty());
                    showPopup(unsavedWarningPopupBind, true);
                    return null;
                }
                Object esiBatchId = AdfFacesContext.getCurrentInstance().getPageFlowScope().get("CURRENT_ESI_BATCH_ID");
                
                if(esiBatchId != null)
                {
                    OperationBinding filterBatch = getBindings().getOperationBinding("editBatch");
                    filterBatch.getParamsMap().put("batchId", Integer.parseInt(esiBatchId.toString()));
                    filterBatch.execute();
                }
            return "back";
            }
            else if(res.equalsIgnoreCase("ocsqcgrade"))
            {
                    ADFUtils.addFormattedFacesErrorMessage("Please select grade for all the OC and SQC lines." +
                                                           "", "",
                                                           FacesMessage.SEVERITY_ERROR);        
                }
            else
            {
                    ADFUtils.addFormattedFacesErrorMessage("Please enter all the mandatory details for all the seafarers. Residence city is also mandatory for Russia And Ukraine" +
                                                           "", "",
                                                           FacesMessage.SEVERITY_ERROR);    
                
                }
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while processing." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();
        }
        return null;
    }

    public void validateSeafarerButton(ActionEvent actionEvent) {


        try {
            OperationBinding mandSeafarer = getBindings().getOperationBinding("validationOnBackButton");
            String manda = mandSeafarer.execute().toString(); 
            if(manda.equalsIgnoreCase("success"))
            {
            
            OperationBinding val = getBindings().getOperationBinding("checkValidationBeforeSave");
            String valres = val.execute().toString();
            if (!valres.equalsIgnoreCase("false")) {
                OperationBinding valgrade = getBindings().getOperationBinding("validateOcSQCGrade");
                String valgrdres = valgrade.execute().toString();
                if (valgrdres.equalsIgnoreCase("validated")) {
                    OperationBinding ob = getBindings().getOperationBinding("validateSeafarer");
                    String res = ob.execute().toString();
                    if (res.equalsIgnoreCase("Success")) {
                        FacesMessage Message = new FacesMessage("Validated successfully. Ready for submission.");
                        Message.setSeverity(FacesMessage.SEVERITY_INFO);
                        FacesContext fc = FacesContext.getCurrentInstance();
                        fc.addMessage(null, Message);
                    } else if (res.equalsIgnoreCase("false")) {

                        FacesMessage Message = new FacesMessage("Please add at least one seafarer.");
                        Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                        FacesContext fc = FacesContext.getCurrentInstance();
                        fc.addMessage(null, Message);
                    }


                    else {

                        OperationBinding ob1 = getBindings().getOperationBinding("addValidationMessage");
                        ob1.getParamsMap().put("message", res);
                        ob1.execute();

                        showPopup(messageValidatePopup, true);

                    }
                } else {
                    FacesMessage Message = new FacesMessage(valgrdres);
                    Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);
                }
            } else {
                FacesMessage Message = new FacesMessage("Please enter all the mandatory fields.");
                Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                FacesContext fc = FacesContext.getCurrentInstance();
                fc.addMessage(null, Message);
                  }
            }
            else
            {
                    FacesMessage Message = new FacesMessage("Please enter all the mandatory fields of all the seafaferes.");
                    Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);
                
                }
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while validating seafarer." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();
        }

    }

    public void OCCocValueChangeListener(ValueChangeEvent valueChangeEvent) {
        try {
            String rejected =
                AdfFacesContext.getCurrentInstance().getPageFlowScope().get("param_rejected_tab").toString();

            RichInputFile inputFileComponent = (RichInputFile) valueChangeEvent.getComponent();
            UploadedFile file = (UploadedFile) valueChangeEvent.getNewValue();
            if (valueChangeEvent.getNewValue() != null) {
                if (!file.getFilename().endsWith("pdf") && !file.getFilename().endsWith("PDF")) {
                    inputFileComponent.resetValue();
                    inputFileComponent.setValid(false);
                    FacesMessage Message = new FacesMessage("Only PDF files are allowed.");
                    Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);


                } else {
                    InputStream in = file.getInputStream();
                    String fileName = file.getFilename();
                    //            System.out.println(fileName+"-------fileName");
                    OperationBinding ob = getBindings().getOperationBinding("uploadDocument");
                    ob.getParamsMap().put("param1", "SICD");
                    ob.getParamsMap().put("param2", "0005");
                    ob.getParamsMap().put("param3", "Application");
                    ob.getParamsMap().put("fileName", fileName);
                    ob.getParamsMap().put("rejected", rejected);
                    Object object = ob.execute();
                    String path = null;
                    if (object != null) {
                        path = object.toString();
                    } //            ADFUtils.uploadFile(in, path);
                    if (path != null)
                        ADFUtils.uploadFile(file, path);
                }
            }
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading document." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                            e.printStackTrace();
        }
    }

    public void sqcCocValueChangeListener(ValueChangeEvent valueChangeEvent) {
        try {
            String rejected =
                AdfFacesContext.getCurrentInstance().getPageFlowScope().get("param_rejected_tab").toString();

            RichInputFile inputFileComponent = (RichInputFile) valueChangeEvent.getComponent();
            UploadedFile file = (UploadedFile) valueChangeEvent.getNewValue();
            if (valueChangeEvent.getNewValue() != null) {
                if (!file.getFilename().endsWith("pdf") && !file.getFilename().endsWith("PDF")) {
                    inputFileComponent.resetValue();
                    inputFileComponent.setValid(false);
                    FacesMessage Message = new FacesMessage("Only PDF files are allowed.");
                    Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);


                } else {
                    InputStream in = file.getInputStream();
                    String fileName = file.getFilename();
                    //            System.out.println(fileName+"-------fileName");
                    OperationBinding ob = getBindings().getOperationBinding("uploadDocument");
                    ob.getParamsMap().put("param1", "SICD");
                    ob.getParamsMap().put("param2", "0006");
                    ob.getParamsMap().put("param3", "Application");
                    ob.getParamsMap().put("fileName", fileName);
                    ob.getParamsMap().put("rejected", rejected);
                    Object object = ob.execute();
                    String path = null;
                    if (object != null) {
                        path = object.toString();
                    } //            ADFUtils.uploadFile(in, path);
                    if (path != null)
                        ADFUtils.uploadFile(file, path);
                }
            }
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading document." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                            e.printStackTrace();
        }
    }

    public void sqcSupportDocValueChangeLIstener(ValueChangeEvent valueChangeEvent) {
        try {
            String rejected =
                AdfFacesContext.getCurrentInstance().getPageFlowScope().get("param_rejected_tab").toString();

            RichInputFile inputFileComponent = (RichInputFile) valueChangeEvent.getComponent();
            UploadedFile file = (UploadedFile) valueChangeEvent.getNewValue();
            if (valueChangeEvent.getNewValue() != null) {
                if (!file.getFilename().endsWith("pdf") && !file.getFilename().endsWith("PDF")) {
                    inputFileComponent.resetValue();
                    inputFileComponent.setValid(false);
                    FacesMessage Message = new FacesMessage("Only PDF files are allowed.");
                    Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);


                } else {
                    InputStream in = file.getInputStream();
                    String fileName = file.getFilename();
                    //            System.out.println(fileName+"-------fileName");
                    OperationBinding ob = getBindings().getOperationBinding("uploadDocument");
                    ob.getParamsMap().put("param1", "SICD");
                    ob.getParamsMap().put("param2", "0011");
                    ob.getParamsMap().put("param3", "Application");
                    ob.getParamsMap().put("fileName", fileName);
                    ob.getParamsMap().put("rejected", rejected);
                    Object object = ob.execute();
                    String path = null;
                    if (object != null) {
                        path = object.toString();
                    } //            ADFUtils.uploadFile(in, path);
                    if (path != null)
                        ADFUtils.uploadFile(file, path);
                }
            }
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading document." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                            e.printStackTrace();
        }
    }


    public void setValidationMessagePopup(RichPopup validationMessagePopup) {
        this.validationMessagePopup = validationMessagePopup;
    }

    public RichPopup getValidationMessagePopup() {
        return validationMessagePopup;
    }

    public void sendToInternal2Button(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("send_to_internal2");
            ob.execute();
            showPopup(sendToInternalPopup, true);
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while processing." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();
        }
        //        FacesMessage Message = new FacesMessage("Batch will be sent to ‘Orders Pending Upload’ Queue for Internal Agent – II to scan/upload the required documents.");
        //            Message.setSeverity(FacesMessage.SEVERITY_INFO);
        //            FacesContext fc = FacesContext.getCurrentInstance();
        //            fc.addMessage(null, Message);
    }

    public void setSendToInternalPopup(RichPopup sendToInternalPopup) {
        this.sendToInternalPopup = sendToInternalPopup;
    }

    public RichPopup getSendToInternalPopup() {
        return sendToInternalPopup;
    }

    public String assignedTinternalokButton() {
        // Add event code here...
        return null;
    }

    public void orderingAgentValueChangeListener(ValueChangeEvent valueChangeEvent) {
        try {
            String email = null;
            if (valueChangeEvent.getNewValue() != null) {
                email = valueChangeEvent.getNewValue().toString();
            }
            System.out.println("----in the valuechangelistener");
            OperationBinding ob = getBindings().getOperationBinding("update_email_id");
            ob.getParamsMap().put("email", email);
            ob.execute();
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while updating agent email id." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();
        }

    }

    public void setSubmitMessagePopup(RichPopup submitMessagePopup) {
        this.submitMessagePopup = submitMessagePopup;
    }

    public RichPopup getSubmitMessagePopup() {
        return submitMessagePopup;
    }

    public void setInlineFrameBinding(RichInlineFrame inlineFrameBinding) {
        this.inlineFrameBinding = inlineFrameBinding;
    }

    public RichInlineFrame getInlineFrameBinding() {
        return inlineFrameBinding;
    }

    public void scanAction(ActionEvent actionEvent) {
        // Add event code here...

        //                    System.out.println("==========lkdhfjfjlsfajfjldkhfl============");
        try {
            ADFContext adfCtx = ADFContext.getCurrent();
            ExtendedRenderKitService service =
                (ExtendedRenderKitService) Service.getRenderKitService(FacesContext.getCurrentInstance(),
                                                                       ExtendedRenderKitService.class);
            service.addScript(FacesContext.getCurrentInstance(), "AcquireImage()");
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while scanning document." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();
        }

        //AdfFacesContext.getCurrentInstance().addPartialTarget(panelFormLayout);
        //       grossTonnageInputText.setValue(pageFlowScope.get("grossTons").toString());
        //         netTonnageInputText.setValue(pageFlowScope.get("netTones").toString());
        //         vesselAgeInYearsInputText.setValue(pageFlowScope.get("vesselage").toString());
    }

    public String scanPopupCloseAction() {
        // Add event code here...
        //        System.out.println("==========scanPopupCloseAction============");
        //  File file = new File("A:\\1.pdf");
        String pdfname = ADFContext.getCurrent().getSessionScope().get("pdfname").toString();
        File file = new File("/irid/oracle_files/DEV/" + pdfname + ".pdf");
        try {
            if (file.exists()) {

                // InputStream in = file.getInputStream();
                InputStream in = new FileInputStream(file);
                //    String fileName = file.getFilename();
                String fileName = pdfname + ".pdf";
                //            System.out.println(fileName+"-------fileName");
                OperationBinding ob = getBindings().getOperationBinding("uploadDocument");
                ob.getParamsMap().put("param1", "SICD");
                ob.getParamsMap().put("param2", "0031");
                ob.getParamsMap().put("param3", "Application");
                ob.getParamsMap().put("fileName", fileName);
                Object object = ob.execute();
                String path = null;
                if (object != null) {
                    path = object.toString();
                }
                //            System.out.println("==========path============"+path);
                ADFUtils.uploadFile(in, path);
                getScanPopup().hide();
                AdfFacesContext.getCurrentInstance().addPartialTarget(supportingDoumentViewLink);
                //                FacesContext fctx = FacesContext.getCurrentInstance();
                //                fctx.addMessage("",
                //                                new FacesMessage(FacesMessage.SEVERITY_INFO,
                //                                                 "Document has been successfully saved to E-Docs",
                //                                                 "Document has been successfully saved to E-Docs"));
                //  file.delete();
            }

            else {
                //                    FacesContext fctx = FacesContext.getCurrentInstance();
                //                             String msgType = "Error";
                //                             FacesMessage msg=new FacesMessage(FacesMessage.SEVERITY_ERROR, msgType,
                //                                                             "PDF not found. Please generate pdf by clicking on Create Merged PDF after Scaning the documents.");
                //                            fctx.addMessage(msgType, msg);
                RichPopup popup = getScanPopup();
                popup.hide();
            }
            //            RichPopup popup =  getScanPopup();
            //            popup.hide();


        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while scanning document." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                            e.printStackTrace();
        } finally {
        }
        return "success";
    }

    public void setScanPopup(RichPopup scanPopup) {
        this.scanPopup = scanPopup;
    }

    public RichPopup getScanPopup() {
        return scanPopup;
    }

    public void setSearchSeafarerFormBinding(RichTable searchSeafarerFormBinding) {
        this.searchSeafarerFormBinding = searchSeafarerFormBinding;
    }

    public RichTable getSearchSeafarerFormBinding() {
        return searchSeafarerFormBinding;
    }

    public void setPanelCollectionBinding(RichPanelCollection panelCollectionBinding) {
        this.panelCollectionBinding = panelCollectionBinding;
    }

    public RichPanelCollection getPanelCollectionBinding() {
        return panelCollectionBinding;
    }

    public void setBasicInformationtabBind(RichShowDetailItem basicInformationtabBind) {
        this.basicInformationtabBind = basicInformationtabBind;
    }

    public RichShowDetailItem getBasicInformationtabBind() {
        return basicInformationtabBind;
    }

    public void addNewSeafarerButton(ActionEvent actionEvent) {
        try {
            OperationBinding ob1 = getBindings().getOperationBinding("getAllRowStateSeafarer");
            String res = ob1.execute().toString();
            if (res.equalsIgnoreCase("true")) {
                OperationBinding ob = getBindings().getOperationBinding("CreateInsert");
                ob.execute();
                basicInformationtabBind.setDisclosed(true);
                AdfFacesContext.getCurrentInstance().addPartialTarget(basicInformationtabBind);
                photoInputFileBind.setValue(null);
                identityDocFileBind.setValue(null);
                physicalFileBind.setValue(null);
                seaserviceFileBind.setValue(null);
                attestationFileBind.setValue(null);
                affidavitFileBind.setValue(null);
                securityFileBind.setValue(null);
                internalSupportingFileBind.setValue(null);
                //        seaserviceFileEnteredBind.setValue(null);
                AdfFacesContext.getCurrentInstance().addPartialTarget(photoInputFileBind);
                AdfFacesContext.getCurrentInstance().addPartialTarget(identityDocFileBind);
                AdfFacesContext.getCurrentInstance().addPartialTarget(physicalFileBind);
                AdfFacesContext.getCurrentInstance().addPartialTarget(seaserviceFileBind);
                AdfFacesContext.getCurrentInstance().addPartialTarget(attestationFileBind);
                AdfFacesContext.getCurrentInstance().addPartialTarget(affidavitFileBind);
                AdfFacesContext.getCurrentInstance().addPartialTarget(securityFileBind);
                AdfFacesContext.getCurrentInstance().addPartialTarget(internalSupportingFileBind);
            } else {
                ADFUtils.addFormattedFacesErrorMessage("Please save all the details for the seafarer before adding a new seafarer in the batch.",
                                                       "", FacesMessage.SEVERITY_ERROR);

            }
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while creating new seafarer." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();
        }
        //        AdfFacesContext.getCurrentInstance().addPartialTarget(seaserviceFileEnteredBind);


    }

    public void setPhotoInputFileBind(RichInputFile photoInputFileBind) {
        this.photoInputFileBind = photoInputFileBind;
    }

    public RichInputFile getPhotoInputFileBind() {
        return photoInputFileBind;
    }

    public void setIdentityDocFileBind(RichInputFile identityDocFileBind) {
        this.identityDocFileBind = identityDocFileBind;
    }

    public RichInputFile getIdentityDocFileBind() {
        return identityDocFileBind;
    }

    public void setPhysicalFileBind(RichInputFile physicalFileBind) {
        this.physicalFileBind = physicalFileBind;
    }

    public RichInputFile getPhysicalFileBind() {
        return physicalFileBind;
    }

    public void setSeaserviceFileBind(RichInputFile seaserviceFileBind) {
        this.seaserviceFileBind = seaserviceFileBind;
    }

    public RichInputFile getSeaserviceFileBind() {
        return seaserviceFileBind;
    }

    public void setAttestationFileBind(RichInputFile attestationFileBind) {
        this.attestationFileBind = attestationFileBind;
    }

    public RichInputFile getAttestationFileBind() {
        return attestationFileBind;
    }

    public void setAffidavitFileBind(RichInputFile affidavitFileBind) {
        this.affidavitFileBind = affidavitFileBind;
    }

    public RichInputFile getAffidavitFileBind() {
        return affidavitFileBind;
    }

    public void setSecurityFileBind(RichInputFile securityFileBind) {
        this.securityFileBind = securityFileBind;
    }

    public RichInputFile getSecurityFileBind() {
        return securityFileBind;
    }

    public void setSeaserviceFileEnteredBind(RichInputFile seaserviceFileEnteredBind) {
        this.seaserviceFileEnteredBind = seaserviceFileEnteredBind;
    }

    public RichInputFile getSeaserviceFileEnteredBind() {
        return seaserviceFileEnteredBind;
    }

    public void setDocRequestedCOCScanPopup(RichPopup docRequestedCOCScanPopup) {
        this.docRequestedCOCScanPopup = docRequestedCOCScanPopup;
    }

    public RichPopup getDocRequestedCOCScanPopup() {
        return docRequestedCOCScanPopup;
    }

    public String docRequestedCOCScanAction() {
        // Add event code here...
        //        System.out.println("==========scanPopupCloseAction============");
        //  File file = new File("A:\\1.pdf");
        String pdfname = ADFContext.getCurrent().getSessionScope().get("pdfname").toString();
        File file = new File("/irid/oracle_files/DEV/" + pdfname + ".pdf");
        try {
            if (file.exists()) {

                // InputStream in = file.getInputStream();
                InputStream in = new FileInputStream(file);
                //    String fileName = file.getFilename();
                String fileName = pdfname + ".pdf";
                //            System.out.println(fileName+"-------fileName");
                OperationBinding ob = getBindings().getOperationBinding("uploadDocument");
                ob.getParamsMap().put("param1", "SICD");
                ob.getParamsMap().put("param2", "0005");
                ob.getParamsMap().put("param3", "Application");
                ob.getParamsMap().put("fileName", fileName);
                //  String path =  ob.execute().toString();
                Object obj = ob.execute();
                String path = null;
                if (obj != null) {
                    path = obj.toString();
                }
                //            System.out.println("==========path============"+path);
                ADFUtils.uploadFile(in, path);
                FacesContext fctx = FacesContext.getCurrentInstance();
                fctx.addMessage("",
                                new FacesMessage(FacesMessage.SEVERITY_INFO,
                                                 "Document has been successfully saved to E-Docs",
                                                 "Document has been successfully saved to E-Docs"));
                //   file.delete();
            }

            else {
                FacesContext fctx = FacesContext.getCurrentInstance();
                String msgType = "Error";
                FacesMessage msg =
                    new FacesMessage(FacesMessage.SEVERITY_ERROR, msgType,
                                     "PDF not found. Please generate pdf by clicking on Create Merged PDF after Scaning the documents.");
                fctx.addMessage(msgType, msg);
            }
            //            RichPopup popup =  getScanPopup();
            //            popup.hide();


        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading document." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                            e.printStackTrace();
        } finally {
        }
        return "success";
    }

    public void setSqcCocScanPopUp(RichPopup sqcCocScanPopUp) {
        this.sqcCocScanPopUp = sqcCocScanPopUp;
    }

    public RichPopup getSqcCocScanPopUp() {
        return sqcCocScanPopUp;
    }

    public void setSqcSupportDocScanPopUp(RichPopup sqcSupportDocScanPopUp) {
        this.sqcSupportDocScanPopUp = sqcSupportDocScanPopUp;
    }

    public RichPopup getSqcSupportDocScanPopUp() {
        return sqcSupportDocScanPopUp;
    }

    public String sqcSupportDocScanAction() {
        // Add event code here...
        //        System.out.println("==========scanPopupCloseAction============");
        //  File file = new File("A:\\1.pdf");
        String pdfname = ADFContext.getCurrent().getSessionScope().get("pdfname").toString();
        File file = new File("/irid/oracle_files/DEV/" + pdfname + ".pdf");
        try {
            if (file.exists()) {

                // InputStream in = file.getInputStream();
                InputStream in = new FileInputStream(file);
                //    String fileName = file.getFilename();
                String fileName = pdfname + ".pdf";
                //            System.out.println(fileName+"-------fileName");
                OperationBinding ob = getBindings().getOperationBinding("uploadDocument");
                ob.getParamsMap().put("param1", "SICD");
                ob.getParamsMap().put("param2", "0011");
                ob.getParamsMap().put("param3", "Application");
                ob.getParamsMap().put("fileName", fileName);
               // String path = ob.execute().toString();
               Object obj = ob.execute();
                String path = null;
                                    if(obj != null)
                                    {
                                     path = obj.toString();
                                    } 
                //            System.out.println("==========path============"+path);
                ADFUtils.uploadFile(in, path);
                FacesContext fctx = FacesContext.getCurrentInstance();
                fctx.addMessage("",
                                new FacesMessage(FacesMessage.SEVERITY_INFO,
                                                 "Document has been successfully saved to E-Docs",
                                                 "Document has been successfully saved to E-Docs"));
                // file.delete();
            }

            else {
                FacesContext fctx = FacesContext.getCurrentInstance();
                String msgType = "Error";
                FacesMessage msg =
                    new FacesMessage(FacesMessage.SEVERITY_ERROR, msgType,
                                     "PDF not found. Please generate pdf by clicking on Create Merged PDF after Scaning the documents.");
                fctx.addMessage(msgType, msg);
            }
            //            RichPopup popup =  getScanPopup();
            //            popup.hide();


        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading document." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                            e.printStackTrace();
        } finally {
        }
        return "success";
    }

    public String sqcCocScanAction() {
        // Add event code here...
        //        System.out.println("==========scanPopupCloseAction============");
        //  File file = new File("A:\\1.pdf");
        //              File file = new File("/irid/oracle_files/DEV/1.pdf");
        String pdfname = ADFContext.getCurrent().getSessionScope().get("pdfname").toString();
        File file = new File("/irid/oracle_files/DEV/" + pdfname + ".pdf");

        try {
            if (file.exists()) {

                // InputStream in = file.getInputStream();
                InputStream in = new FileInputStream(file);
                //    String fileName = file.getFilename();
                String fileName = pdfname + ".pdf";
                //            System.out.println(fileName+"-------fileName");
                OperationBinding ob = getBindings().getOperationBinding("uploadDocument");
                ob.getParamsMap().put("param1", "SICD");
                ob.getParamsMap().put("param2", "0006");
                ob.getParamsMap().put("param3", "Application");
                ob.getParamsMap().put("fileName", fileName);
               // String path = ob.execute().toString();
               Object obj = ob.execute();
                                   String path = null;
                                   if(obj != null)
                                   {
                                    path = obj.toString();
                                   }
                //            System.out.println("==========path============"+path);
                ADFUtils.uploadFile(in, path);
                FacesContext fctx = FacesContext.getCurrentInstance();
                fctx.addMessage("",
                                new FacesMessage(FacesMessage.SEVERITY_INFO,
                                                 "Document has been successfully saved to E-Docs",
                                                 "Document has been successfully saved to E-Docs"));
                //                return null;
                //  file.delete();
            }

            else {
                FacesContext fctx = FacesContext.getCurrentInstance();
                String msgType = "Error";
                FacesMessage msg =
                    new FacesMessage(FacesMessage.SEVERITY_ERROR, msgType,
                                     "PDF not found. Please generate pdf by clicking on Create Merged PDF after Scaning the documents.");
                fctx.addMessage(msgType, msg);
            }
            //            RichPopup popup =  getScanPopup();
            //            popup.hide();


        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading document." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                            e.printStackTrace();
        }

        finally {
        }
        return "success";
    }
    private String scanURL = null;

    public void setScanURL(String scanURL) {
        this.scanURL = scanURL;
    }

    public String getScanURL() {
        return scanURL;
    }

    public void popupFetchListner(PopupFetchEvent popupFetchEvent) {
        // Add event code here...
        try {
            Random random = new Random();
            int n = 10000000 + random.nextInt(90000000);
            //        System.out.println("inside popup fetchlistner-------"+n);
            String pdfname = Integer.toString(n);
            ADFContext.getCurrent().getSessionScope().put("pdfname", pdfname);

            setScanURL("http://iri025.coresys.com:7003/Scanning/ScanPage.html?pdfname=" + n);
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while processing." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();
        }
    }


    public void docRequestedCOCScanPopupClose(ActionEvent actionEvent) {
        // Add event code here...
        getDocRequestedCOCScanPopup().hide();
        AdfFacesContext.getCurrentInstance().addPartialTarget(cocViewLink);
    }

    public void sqcCocScanPopUpScanClose(ActionEvent actionEvent) {
        // Add event code here...
        getSqcCocScanPopUp().hide();
        AdfFacesContext.getCurrentInstance().addPartialTarget(sqcCocViewLink);
    }

    public void sqcSupportDocScanPopUpClose(ActionEvent actionEvent) {
        // Add event code here...
        getSqcSupportDocScanPopUp().hide();
        AdfFacesContext.getCurrentInstance().addPartialTarget(sqcSupportDocViewLink);
    }

    public void scanPopupScanClose(ActionEvent actionEvent) {
        // Add event code here...
        getScanPopup().hide();
        AdfFacesContext.getCurrentInstance().addPartialTarget(supportingDoumentViewLink);
    }

    public void setSupportingDoumentViewLink(RichButton supportingDoumentViewLink) {
        this.supportingDoumentViewLink = supportingDoumentViewLink;
    }

    public RichButton getSupportingDoumentViewLink() {
        return supportingDoumentViewLink;
    }

    public void setCocViewLink(RichButton cocViewLink) {
        this.cocViewLink = cocViewLink;
    }

    public RichButton getCocViewLink() {
        return cocViewLink;
    }

    public void setSqcCocViewLink(RichButton sqcCocViewLink) {
        this.sqcCocViewLink = sqcCocViewLink;
    }

    public RichButton getSqcCocViewLink() {
        return sqcCocViewLink;
    }

    public void setSqcSupportDocViewLink(RichButton sqcSupportDocViewLink) {
        this.sqcSupportDocViewLink = sqcSupportDocViewLink;
    }

    public RichButton getSqcSupportDocViewLink() {
        return sqcSupportDocViewLink;
    }

    public void photoEdocIdHideLinkActionListner(ActionEvent actionEvent) {
        // Add event code here...
        photoInputFileBind.setVisible(true);
        AdfFacesContext.getCurrentInstance().addPartialTarget(photoInputFileBind);
    }

    public void identityDocEdocIdHideActionListner(ActionEvent actionEvent) {
        // Add event code here...
        identityDocFileBind.setVisible(true);
        AdfFacesContext.getCurrentInstance().addPartialTarget(identityDocFileBind);
    }

    public void physicalEdocIdHideActionListner(ActionEvent actionEvent) {
        // Add event code here...
        physicalFileBind.setVisible(true);
        AdfFacesContext.getCurrentInstance().addPartialTarget(physicalFileBind);
    }

    public void seaserviceTranscriptHideActionListner(ActionEvent actionEvent) {
        // Add event code here...
        //        seaserviceFileEnteredBind.setVisible(true);
        //        AdfFacesContext.getCurrentInstance().addPartialTarget(seaserviceFileEnteredBind);
    }

    public void SeaserviceTranscriptEdocIdActionListner2(ActionEvent actionEvent) {
        // Add event code here...
        seaserviceFileBind.setVisible(true);
        AdfFacesContext.getCurrentInstance().addPartialTarget(seaserviceFileBind);
    }

    public void applicationEdocIdHideActionListner(ActionEvent actionEvent) {
        // Add event code here...
        attestationFileBind.setVisible(true);
        AdfFacesContext.getCurrentInstance().addPartialTarget(attestationFileBind);
    }

    public void satEdocIdHideActionListner(ActionEvent actionEvent) {
        // Add event code here...
        securityFileBind.setVisible(true);
        AdfFacesContext.getCurrentInstance().addPartialTarget(securityFileBind);
    }

    public void affidavitEdocIdHideActionListner(ActionEvent actionEvent) {
        // Add event code here...
        affidavitFileBind.setVisible(true);
        AdfFacesContext.getCurrentInstance().addPartialTarget(affidavitFileBind);

    }

    public void deleteOcRow(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("Delete1");
            ob.execute();
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while deleting row." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();
        }
    }

    public void deleteSqcRow(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("Delete");
            ob.execute();
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while deleting row." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();
        }
    }

    public void setGradeOcPopup(RichPopup gradeOcPopup) {
        this.gradeOcPopup = gradeOcPopup;
    }

    public RichPopup getGradeOcPopup() {
        return gradeOcPopup;
    }

    public void useOnGradeOCButton(ActionEvent actionEvent) {
        try {
            //            System.out.println("--------usegradeoc");
            OperationBinding ob = getBindings().getOperationBinding("usegradeOc");
            ob.execute();
            FilterableQueryDescriptor queryDescriptor =
                (FilterableQueryDescriptor) getQuickPickOcTableBind().getFilterModel();
            if (queryDescriptor != null && queryDescriptor.getFilterCriteria() != null) {
                queryDescriptor.getFilterCriteria().clear();
                getQuickPickOcTableBind().queueEvent(new QueryEvent(getQuickPickOcTableBind(), queryDescriptor));
            }
            gradeOcPopup.hide();
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching data." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();
        }
    }

    public void cancelOnGradeOcButton(ActionEvent actionEvent) {
        try {
            FilterableQueryDescriptor queryDescriptor =
                (FilterableQueryDescriptor) getQuickPickOcTableBind().getFilterModel();
            if (queryDescriptor != null && queryDescriptor.getFilterCriteria() != null) {
                queryDescriptor.getFilterCriteria().clear();
                getQuickPickOcTableBind().queueEvent(new QueryEvent(getQuickPickOcTableBind(), queryDescriptor));
            }
            gradeOcPopup.hide();
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading data." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
    }

    public void setGradeSqcPopup(RichPopup gradeSqcPopup) {
        this.gradeSqcPopup = gradeSqcPopup;
    }

    public RichPopup getGradeSqcPopup() {
        return gradeSqcPopup;
    }

    public void useGradeSqcButton(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("usegradeSqcc");
            ob.execute();
            FilterableQueryDescriptor queryDescriptor =
                (FilterableQueryDescriptor) getQuickPickSqcTableBind().getFilterModel();
            if (queryDescriptor != null && queryDescriptor.getFilterCriteria() != null) {
                queryDescriptor.getFilterCriteria().clear();
                getQuickPickSqcTableBind().queueEvent(new QueryEvent(getQuickPickSqcTableBind(), queryDescriptor));
            }
            gradeSqcPopup.hide();
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching data." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();
        }
    }

    public void cancelGradeSqcButton(ActionEvent actionEvent) {
        FilterableQueryDescriptor queryDescriptor =
            (FilterableQueryDescriptor) getQuickPickSqcTableBind().getFilterModel();
        if (queryDescriptor != null && queryDescriptor.getFilterCriteria() != null) {
            queryDescriptor.getFilterCriteria().clear();
            getQuickPickSqcTableBind().queueEvent(new QueryEvent(getQuickPickSqcTableBind(), queryDescriptor));
        }
        gradeSqcPopup.hide();
    }

    public void batchNameValidator(FacesContext facesContext, UIComponent uIComponent, Object object) {
        Pattern pattern = Pattern.compile("[a-zA-Z0-9-/.,_!*“”\\s]+$");
        if(object != null)
        {
        String str = object.toString();
        String ERROR_MESSAGE = "Only alphanumeric and below symbols are allowed  - / . , _ ! * “ ”.";
        Matcher matcher = pattern.matcher(str);
        if (matcher.matches()) {
            //                   System.out.println("string '"+str + "' is alphanumeric");
        } else {
            throw new ValidatorException(new FacesMessage(FacesMessage.SEVERITY_ERROR, ERROR_MESSAGE, null));
        }
        }

    }

    public void consentPopupFetchListener(PopupFetchEvent popupFetchEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("findConsent");
            String ret = ob.execute().toString();
            if (ret != "Online" && ret != "null") {
//                Integer edoc_id = Integer.parseInt(ret);
                //    System.out.println("-----in-----");
                //                ob = getBindings().getOperationBinding("getLinkForConsent");
                //                ob.getParamsMap().put("edoc_id", edoc_id);
                //                String path = ob.execute().toString();
                //                setConsentDocLink(path);
                //             consentUploadDocumentBind.setVisible(false);
                //             viewConsentButtonBind.setVisible(true);
                setUploadConsentDocVisible("Y");
                String uType = AdfFacesContext.getCurrentInstance().getPageFlowScope().get("user_type").toString();
                if (uType.equalsIgnoreCase("Internal")) {
                    setViewConsentButtonVisible("Y");
                } else {
                    setViewConsentButtonVisible("Y");
                }
            }
            if (ret == "null") {
                setUploadConsentDocVisible("Y");
                setViewConsentButtonVisible("N");
            } else {
            }
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching consent data." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();
        }
    }

    public void setConsentUploadDocumentBind(RichInputFile consentUploadDocumentBind) {
        this.consentUploadDocumentBind = consentUploadDocumentBind;
    }

    public RichInputFile getConsentUploadDocumentBind() {
        return consentUploadDocumentBind;
    }

    public void setViewConsentButtonBind(RichButton viewConsentButtonBind) {
        this.viewConsentButtonBind = viewConsentButtonBind;
    }

    public RichButton getViewConsentButtonBind() {
        return viewConsentButtonBind;
    }

    public void uploadConsentValueChangeListener(ValueChangeEvent valueChangeEvent) {
        try {
            String rejected =
                AdfFacesContext.getCurrentInstance().getPageFlowScope().get("param_rejected_tab").toString();

            RichInputFile inputFileComponent = (RichInputFile) valueChangeEvent.getComponent();
            UploadedFile file = (UploadedFile) valueChangeEvent.getNewValue();
            if (valueChangeEvent.getNewValue() != null) {
                if (!file.getFilename().endsWith("pdf") && !file.getFilename().endsWith("PDF")) {
                    inputFileComponent.resetValue();
                    inputFileComponent.setValid(false);
                    FacesMessage Message = new FacesMessage("Only PDF files are allowed.");
                    Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);


                } else {
                    InputStream in = file.getInputStream();
                    String fileName = file.getFilename();
                    //            System.out.println(fileName+"-------fileName");
                    OperationBinding ob = getBindings().getOperationBinding("uploadDocument");
                    ob.getParamsMap().put("param1", "SICD");
                    ob.getParamsMap().put("param2", "0025");
                    ob.getParamsMap().put("param3", "Consent");
                    ob.getParamsMap().put("fileName", fileName);
                    ob.getParamsMap().put("rejected", rejected);
                    Object object = ob.execute();
                    String path = null;
                    if (object != null) {
                        path = object.toString();
                    } //            ADFUtils.uploadFile(in, path);
                    if (path != null)
                        ADFUtils.uploadFile(file, path);
//                    ADFUtils.uploadFile(file, "E:\\"+file.getFilename());
                    //            OperationBinding dates=getBindings().getOperationBinding("setConsentStartEndDate");
                    //          dates.execute();


                }
            }
        } catch (IOException e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading document." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                            e.printStackTrace();
        }
    }

    public void saveButtonOnConsentpopup(ActionEvent actionEvent) {
        try {
            System.out.println(consentUploadDocumentBind.getValue() + "----");
            OperationBinding valstart = getBindings().getOperationBinding("validateConsentDataBeforeSave");
            String valstartres = valstart.execute().toString();
            String mess = null;


            if ((valstartres.equalsIgnoreCase("mandatory") || consentUploadDocumentBind.getValue() == null) &&
                consentOnlineDate.getValue() == null) {
                if (valstartres.equalsIgnoreCase("mandatory")) {
                    mess = "Please enter consent start date.";
                }
                if (consentUploadDocumentBind.getValue() == null) {
                    if (mess == null) {
                        mess = "Please select a document.";
                    } else {
                        mess = "Please select a document and enter consent start date.";
                    }
                }
                FacesMessage Message = new FacesMessage(mess);
                Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                FacesContext fc = FacesContext.getCurrentInstance();
                fc.addMessage(getAddressFieldForm().getClientId(), Message);

            } else {


                OperationBinding ob = getBindings().getOperationBinding("add_consent");
                ob.execute();

                consentUploadDocumentBind.resetValue();
                consentUploadDocumentBind.setValid(false);
                //            System.out.println("----cancel");
                consentPopupBind.hide();
            }
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while saving consent data." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
    }

    public void setConsentPopupBind(RichPopup consentPopupBind) {
        this.consentPopupBind = consentPopupBind;
    }

    public RichPopup getConsentPopupBind() {
        return consentPopupBind;
    }

    public void uploadDocumentTabDisclosureListener(DisclosureEvent disclosureEvent) {
        try {
            setInlineFrameSource(null);
           
            
            
            OperationBinding ob = getBindings().getOperationBinding("setUploadConsent");
            ob.execute();
            ControllerContext controllerContext = ControllerContext.getInstance();
            ViewPortContext currentRootViewPort = null;
            if (controllerContext != null) {
                currentRootViewPort = controllerContext.getCurrentRootViewPort();
            }
            boolean isDataDirty = false;
            if (currentRootViewPort != null) {
                isDataDirty = currentRootViewPort.isDataDirty();
            }
            if (true == isDataDirty) {
                OperationBinding ob1 = getBindings().getOperationBinding("Commit");
                ob1.execute();
            }
          

        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while processing." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();
        }
        //       System.out.println("-----1-------2---");
    }

    public void resubmitButton(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("resubmit");
            ob.execute();

            //        FacesMessage Message = new FacesMessage("Batch has been successfully Re-Submitted.");
            //            Message.setSeverity(FacesMessage.SEVERITY_INFO);
            //            FacesContext fc = FacesContext.getCurrentInstance();
            //            fc.addMessage(null, Message);
            showPopup(resubmitPopupBind, true);
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while submitting batch." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();
        }
    }

    public void uploadedConsentStartDateValueChangeListener(ValueChangeEvent valueChangeEvent) {
        try {
            if (valueChangeEvent.getNewValue() != null) {
                Date date1 = (Date) valueChangeEvent.getNewValue();
                //        System.out.println(date1+"--------date1--Bean");
                OperationBinding ob = getBindings().getOperationBinding("setConsentExpDate");
                ob.getParamsMap().put("startDate", date1);
                ob.execute();
            }
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while updating data." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
    }

    public void deleteSeafarerDialogListener(DialogEvent dialogEvent) {
        try {
            if (dialogEvent.getOutcome() == DialogEvent.Outcome.ok) {
                OperationBinding ob = getBindings().getOperationBinding("deleteCurrentSeafarer");
                ob.execute();
                basicInformationtabBind.setDisclosed(true);
                AdfFacesContext.getCurrentInstance().addPartialTarget(basicInformationtabBind);
            } else {
                // write your custom code for cancel event
            }
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while deleting seafarer." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();
        }
    }

    public void addOcButton(ActionEvent actionEvent) {

        try {
            OperationBinding ob = getBindings().getOperationBinding("addocLine");
            ob.execute();
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while adding line." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();
        }
    }

    public void addSqcButton(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("addsqcLine");
            ob.execute();
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while adding line." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();
        }
    }

    public void ocDateOfIssueValueChangeListener(ValueChangeEvent valueChangeEvent) {

        try {
            if (valueChangeEvent.getNewValue() != null) {
                oracle.jbo.domain.Date issueDate = (oracle.jbo.domain.Date) valueChangeEvent.getNewValue();
                OperationBinding ob = getBindings().getOperationBinding("getNewDate");
                ob.getParamsMap().put("issueDate", issueDate);
                oracle.jbo.domain.Date exp_date = (oracle.jbo.domain.Date) ob.execute();

                ocDateOfExpirationBind.setValue(exp_date);

            }
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while updating date." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();
        }

    }

    public void setOcDateOfExpirationBind(RichInputDate ocDateOfExpirationBind) {
        this.ocDateOfExpirationBind = ocDateOfExpirationBind;
    }

    public RichInputDate getOcDateOfExpirationBind() {
        return ocDateOfExpirationBind;
    }

    public void sqcIssueDateValueChangeListener(ValueChangeEvent valueChangeEvent) {
        try {
            if(valueChangeEvent.getNewValue() != null)
            {
            oracle.jbo.domain.Date issueDate = (oracle.jbo.domain.Date) valueChangeEvent.getNewValue();
            OperationBinding ob = getBindings().getOperationBinding("getNewDate");
            ob.getParamsMap().put("issueDate", issueDate);
            Object object = ob.execute();
            oracle.jbo.domain.Date exp_date = null;
            if(object != null)
            {
               exp_date = (oracle.jbo.domain.Date)object; 
                }
                
            OperationBinding val = getBindings().getOperationBinding("changeDocExpDateChargable");
            val.execute();

            sqcDateOfExpBnding.setValue(exp_date);
            }
        } catch (Exception e) {
//            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while updating date." +
//                                                   " Please contact your System Administrator.", "",
//                                                   FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();
        }
    }

    public void setSqcDateOfExpBnding(RichInputDate sqcDateOfExpBnding) {
        this.sqcDateOfExpBnding = sqcDateOfExpBnding;
    }

    public RichInputDate getSqcDateOfExpBnding() {
        return sqcDateOfExpBnding;
    }

    public void setAddressFieldForm(RichPanelFormLayout addressFieldForm) {
        this.addressFieldForm = addressFieldForm;
    }

    public RichPanelFormLayout getAddressFieldForm() {
        return addressFieldForm;
    }

    public void setBatchNameBind(RichInputText batchNameBind) {
        this.batchNameBind = batchNameBind;
    }

    public RichInputText getBatchNameBind() {
        return batchNameBind;
    }

    public void setResubmitPopupBind(RichPopup resubmitPopupBind) {
        this.resubmitPopupBind = resubmitPopupBind;
    }

    public RichPopup getResubmitPopupBind() {
        return resubmitPopupBind;
    }

    public String okButtonOnResubmitButton() {
        return null;
    }


    public void dateOfBirthValidator(FacesContext facesContext, UIComponent uIComponent, Object object) {
        java.util.Date utDate = null;
        java.util.Date date1 = null;
        try {
            Date date = (Date) object;
            //       System.out.println(date+"--------11");
            java.sql.Date sqldate = date.dateValue();
            utDate = new java.util.Date(sqldate.getTime());
            Calendar cal = Calendar.getInstance();
            //        System.out.println("current date: " + getDate(cal));
            //        java.util.Date endDate = getDate(cal);
            cal.add(Calendar.YEAR, -16);
            //        System.out.println("current date: " + getDate(cal));
            //System.out.println(utDate+"-----22");


            date1 = new SimpleDateFormat("dd/MM/yyyy").parse(getDate(cal));
            //    System.out.println(date1+"-----date1");
            //        System.out.println(utDate.after(date1)+"----res");


        }

        catch (Exception e) {
            e.printStackTrace();
        }
        if (utDate != null && date1 != null) {
            if (utDate.after(date1)) {
                throw new ValidatorException(new FacesMessage(FacesMessage.SEVERITY_ERROR,
                                                              "Seafarer's age can not be less than 16.", null));


            }
        }
    }

    public static String getDate(Calendar cal) {
        return "" + cal.get(Calendar.DATE) + "/" + (cal.get(Calendar.MONTH) + 1) + "/" + cal.get(Calendar.YEAR);
    }

    public void ocCOCExpValidator(FacesContext facesContext, UIComponent uIComponent, Object object) {
        //        try {
        //        } catch (ValidatorException ve) {
        //            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while validating dates." +
        //            " Please contact your System Administrator." ,
        //            "", FacesMessage.SEVERITY_ERROR);
        //        }
        String UserType = "";
        OperationBinding uType = getBindings().getOperationBinding("getUserType");
        Object type = uType.execute();
        if(type!= null)
        {
        UserType = type.toString();
        }
        Date expdate = (Date) object;
        //        System.out.println(expdate+"----1--expdate");
        OperationBinding ob = getBindings().getOperationBinding("checkDateValidate");
        ob.getParamsMap().put("endDate", expdate);
        String res = ob.execute().toString();
        if (res.equalsIgnoreCase("true")) {
            throw new ValidatorException(new FacesMessage(FacesMessage.SEVERITY_ERROR,
                                                          "Expiration date can not be less than issue date.", null));
        }
        //     System.out.println(expdate+"----expdate");
        
        
        java.util.Date utDate = null;
        java.util.Date date1 = null;
        if(UserType.equalsIgnoreCase("External"))
        {
        if (expdate != null) {
            java.sql.Date sqldate = expdate.dateValue();
            utDate = new java.util.Date(sqldate.getTime());
            Calendar cal = Calendar.getInstance();
            //        System.out.println("current date: " + getDate(cal));
            try {
                date1 = new SimpleDateFormat("dd/MM/yyyy").parse(getDate(cal));
            } catch (Exception e) {
                          e.printStackTrace();
            }
            if (utDate.before(date1)) {
                throw new ValidatorException(new FacesMessage(FacesMessage.SEVERITY_ERROR,
                                                              "Expiration date can not be less than current date.",
                                                              null));


            }

        }
        }

    }


    public void sqcCocExpDateValidator(FacesContext facesContext, UIComponent uIComponent, Object object) {
        //        try {
        //        } catch (ValidatorException ve) {
        //            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while validating dates." +
        //            " Please contact your System Administrator." ,
        //            "", FacesMessage.SEVERITY_ERROR);
        //        }
        Date expdate = (Date) object;
        OperationBinding ob = getBindings().getOperationBinding("checkDateValidateSqc");
        ob.getParamsMap().put("endDate", expdate);
        String res = ob.execute().toString();
        if (res.equalsIgnoreCase("true")) {
            throw new ValidatorException(new FacesMessage(FacesMessage.SEVERITY_ERROR,
                                                          "Expiration date can not be less than issue date.", null));
        }
        //        System.out.println(expdate+"----expdate");
        
        String UserType = "";
        OperationBinding uType = getBindings().getOperationBinding("getUserType");
        Object type = uType.execute();
        if(type!= null)
        {
        UserType = type.toString();
        }
        java.util.Date utDate = null;
        java.util.Date date1 = null;
        if(UserType.equalsIgnoreCase("External"))
        {
        if (expdate != null) {
            java.sql.Date sqldate = expdate.dateValue();
            utDate = new java.util.Date(sqldate.getTime());
            Calendar cal = Calendar.getInstance();
            //           System.out.println("current date: " + getDate(cal));
            try {
                date1 = new SimpleDateFormat("dd/MM/yyyy").parse(getDate(cal));
            } catch (Exception e) {
                             e.printStackTrace();
            }
            if (utDate.before(date1)) {
                throw new ValidatorException(new FacesMessage(FacesMessage.SEVERITY_ERROR,
                                                              "Expiration date can not be less than current date.",
                                                              null));


            }

        }
        }

    }

    public void listTableDblClickListner(ClientEvent clientEvent) {
        basicInformationtabBind.setDisclosed(true);
        AdfFacesContext.getCurrentInstance().addPartialTarget(panelTabBind);

        listPopupBind.hide();

    }

    public void setListPopupBind(RichPopup listPopupBind) {
        this.listPopupBind = listPopupBind;
    }

    public RichPopup getListPopupBind() {
        return listPopupBind;
    }

    public void setUploadDocumentTabBind(RichShowDetailItem uploadDocumentTabBind) {
        this.uploadDocumentTabBind = uploadDocumentTabBind;
    }

    public RichShowDetailItem getUploadDocumentTabBind() {
        return uploadDocumentTabBind;
    }

    public void setOcTabBind(RichShowDetailItem ocTabBind) {
        this.ocTabBind = ocTabBind;
    }

    public RichShowDetailItem getOcTabBind() {
        return ocTabBind;
    }

    public void setSqcTabBind(RichShowDetailItem sqcTabBind) {
        this.sqcTabBind = sqcTabBind;
    }

    public RichShowDetailItem getSqcTabBind() {
        return sqcTabBind;
    }

    public void setPanelGroupLayoutBind(RichPanelGroupLayout panelGroupLayoutBind) {
        this.panelGroupLayoutBind = panelGroupLayoutBind;
    }

    public RichPanelGroupLayout getPanelGroupLayoutBind() {
        return panelGroupLayoutBind;
    }

    public void setPanelBoxBind(RichPanelBox panelBoxBind) {
        this.panelBoxBind = panelBoxBind;
    }

    public RichPanelBox getPanelBoxBind() {
        return panelBoxBind;
    }

    public void setPanelFormLayoutBind(RichPanelFormLayout panelFormLayoutBind) {
        this.panelFormLayoutBind = panelFormLayoutBind;
    }

    public RichPanelFormLayout getPanelFormLayoutBind() {
        return panelFormLayoutBind;
    }

    public void viewButtonOnList(ActionEvent actionEvent) {
        basicInformationtabBind.setDisclosed(true);
        AdfFacesContext.getCurrentInstance().addPartialTarget(panelTabBind);

        listPopupBind.hide();

    }

    public void setPanelTabBind(RichPanelTabbed panelTabBind) {
        this.panelTabBind = panelTabBind;
    }

    public RichPanelTabbed getPanelTabBind() {
        return panelTabBind;
    }

    public void residenceCountryValueChangeListener(ValueChangeEvent valueChangeEvent) {
        try {
            //            System.out.println("---value change listener");
            trancityBind.setValue(null);
            //            residenceCode.setValue(null);
            OperationBinding ob = getBindings().getOperationBinding("resetCity");
            ob.execute();
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while updating country." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();
        }
    }

    public void setTrancityBind(RichInputListOfValues trancityBind) {
        this.trancityBind = trancityBind;
    }

    public RichInputListOfValues getTrancityBind() {
        return trancityBind;
    }

    public void setResidenceCode(RichInputText residenceCode) {
        this.residenceCode = residenceCode;
    }

    public RichInputText getResidenceCode() {
        return residenceCode;
    }

    public void billtocustidValueChangeListener(ValueChangeEvent valueChangeEvent) {
        //        System.out.println(valueChangeEvent.getNewValue()+"------");
    }

    public void deliverToCustAccIdValueChangeListener(ValueChangeEvent valueChangeEvent) {
        //        System.out.println(valueChangeEvent.getNewValue()+"------");
    }

    public void shipToCustAccIdValueChangeListener(ValueChangeEvent valueChangeEvent) {
        //        System.out.println(valueChangeEvent.getNewValue()+"------");
    }

    public void billToLovValueChangeListener(ValueChangeEvent valueChangeEvent) {
        try {
            String str = valueChangeEvent.getNewValue().toString();
            System.out.println(str + "----");
            OperationBinding ob = getBindings().getOperationBinding("filterInvoiceAgentEmailId");
            ob.getParamsMap().put("partyName", str);
            ob.execute();
            AdfFacesContext.getCurrentInstance().addPartialTarget(invoiceAgentEmailIdManyChoiceBind);
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching invoice email ID." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }

    public void deliverToLovValueChangeListener(ValueChangeEvent valueChangeEvent) {
        try {
            valueChangeEvent.getComponent().processUpdates(FacesContext.getCurrentInstance());

            String str = valueChangeEvent.getNewValue().toString();
            OperationBinding ob = getBindings().getOperationBinding("filterOrderingAgentEmailId");
            ob.getParamsMap().put("partyName", str);
            ob.execute();
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading data." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }

    public void shipToLovValueChangeListener(ValueChangeEvent valueChangeEvent) {
        //        System.out.println(valueChangeEvent.getNewValue()+"------");
    }

    public void setMessagePopup(RichPopup messagePopup) {
        this.messagePopup = messagePopup;
    }

    public RichPopup getMessagePopup() {
        return messagePopup;
    }

    public void setInternalAgentCoonfirmationPopup(RichPopup internalAgentCoonfirmationPopup) {
        this.internalAgentCoonfirmationPopup = internalAgentCoonfirmationPopup;
    }

    public RichPopup getInternalAgentCoonfirmationPopup() {
        return internalAgentCoonfirmationPopup;
    }

    public void internalAgentConfirmDialogListener(DialogEvent dialogEvent) {
        try {
            if (dialogEvent.getOutcome() == DialogEvent.Outcome.yes) {


                OperationBinding ob = getBindings().getOperationBinding("send_to_internal2");
                ob.execute();
                showPopup(sendToInternalPopup, true);

            } else {
                // write your custom code for cancel event
            }
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while submitting batch." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            //            e.printStackTrace();
        }
    }

    public void fromClickListner(ClientEvent clientEvent) {
        //       System.out.println("hello---hello");
        FacesMessage Message =
            new FacesMessage("Please click on 'Press If Seafarer has/had RMI credentials' before entering any other information.");
        Message.setSeverity(FacesMessage.SEVERITY_INFO);
        FacesContext fc = FacesContext.getCurrentInstance();
        fc.addMessage(getAddressFieldForm().getClientId(), Message);

    }

    public void placeOfBirthValidator(FacesContext facesContext, UIComponent uIComponent, Object object) {
        //        try {
        //        } catch (ValidatorException ve) {
        //            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while validating data." +
        //            " Please contact your System Administrator." ,
        //            "", FacesMessage.SEVERITY_ERROR);
        //        }
        Pattern pattern = Pattern.compile("\\D*");
        String str = object.toString();
        String ERROR_MESSAGE = "Numeric entry is not allowed in Place of Birth feild.";
        Matcher matcher = pattern.matcher(str);
        if (matcher.matches()) {
            //                   System.out.println("string '"+str + "' is alphanumeric");
        } else {
            throw new ValidatorException(new FacesMessage(FacesMessage.SEVERITY_ERROR, ERROR_MESSAGE, null));

        }
    }

    public void basicInfoTabDisclosureListener(DisclosureEvent disclosureEvent) {
        try {
            ControllerContext controllerContext = ControllerContext.getInstance();
            ViewPortContext currentRootViewPort = null;
            if (controllerContext != null) {
                currentRootViewPort = controllerContext.getCurrentRootViewPort();
            }
            boolean isDataDirty = false;
            if (currentRootViewPort != null) {
                isDataDirty = currentRootViewPort.isDataDirty();
            }
            if (true == isDataDirty) {
                OperationBinding ob1 = getBindings().getOperationBinding("Commit");
                ob1.execute();
            }
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading data." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }

    public void ocTabDisclosureListener(DisclosureEvent disclosureEvent) {
        try {
            ControllerContext controllerContext = ControllerContext.getInstance();
            ViewPortContext currentRootViewPort = null;
            if (controllerContext != null) {
                currentRootViewPort = controllerContext.getCurrentRootViewPort();
            }
            boolean isDataDirty = false;
            if (currentRootViewPort != null) {
                isDataDirty = currentRootViewPort.isDataDirty();
            }
            if (true == isDataDirty) {
                OperationBinding ob1 = getBindings().getOperationBinding("Commit");
                ob1.execute();
            }
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading data." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }

    public void sqcTabDisclosureListener(DisclosureEvent disclosureEvent) {
        try {
            ControllerContext controllerContext = ControllerContext.getInstance();
            ViewPortContext currentRootViewPort = null;
            if (controllerContext != null) {
                currentRootViewPort = controllerContext.getCurrentRootViewPort();
            }
            boolean isDataDirty = false;
            if (currentRootViewPort != null) {
                isDataDirty = currentRootViewPort.isDataDirty();
            }
            if (true == isDataDirty) {
                OperationBinding ob1 = getBindings().getOperationBinding("Commit");
                ob1.execute();
            }
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading data." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }

    public void pressIfNotButtonActionListener(ActionEvent actionEvent) {
                                                                             
        OperationBinding names = getBindings().getOperationBinding("checkNames");
       String check = names.execute().toString();   
       
       if(check.equalsIgnoreCase("null"))
       {
       
        OperationBinding ob = getBindings().getOperationBinding("setSeafarer");
        ob.execute();
    }
       else
       {
               showPopup(pressIfNoConfirmationPopupBind, true);  
           }
    }

    public void imoTypeValueChangeListener(ValueChangeEvent valueChangeEvent) {
        // Add event code here...
    }

    public void officialNumberValueChangeListener(ValueChangeEvent valueChangeEvent) {
        try {
            Integer off = null;
            if (valueChangeEvent.getNewValue() != null) {

                String str = valueChangeEvent.getNewValue().toString();
                off = Integer.parseInt(str);


            }
            OperationBinding ob = getBindings().getOperationBinding("offValueChange");
            ob.getParamsMap().put("off", off);
            ob.execute();
        } catch (NumberFormatException nfe) {
            nfe.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading data." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }

    public String resubmitConfirmationDialogListener(DialogEvent dialogEvent) {
        try {
            if (dialogEvent.getOutcome() == DialogEvent.Outcome.yes) {
                OperationBinding ob = getBindings().getOperationBinding("resubmit");
                ob.execute();

                FacesMessage Message = new FacesMessage("Batch has been successfully Resubmitted.");
                Message.setSeverity(FacesMessage.SEVERITY_INFO);
                FacesContext fc = FacesContext.getCurrentInstance();
                fc.addMessage(null, Message);

                //            showPopup(resubmitPopupBind, true);

                OperationBinding ob1 = getBindings().getOperationBinding("searchBatch");
                ob1.execute();
                return "back";


            }
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while submitting batch." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();
        }
        return null;
    }

    public void InternalSupportingFileValueChangeListener(ValueChangeEvent valueChangeEvent) {
        try {
            String rejected =
                AdfFacesContext.getCurrentInstance().getPageFlowScope().get("param_rejected_tab").toString();

            RichInputFile inputFileComponent = (RichInputFile) valueChangeEvent.getComponent();
            UploadedFile file = (UploadedFile) valueChangeEvent.getNewValue();
            if (valueChangeEvent.getNewValue() != null) {
                if (!file.getFilename().endsWith("pdf") && !file.getFilename().endsWith("PDF")) {
                    inputFileComponent.resetValue();
                    inputFileComponent.setValid(false);
                    FacesMessage Message = new FacesMessage("Only PDF files are allowed.");
                    Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);


                } else {
                    //                showPopup(messagePopup, true);
                    InputStream in = file.getInputStream();
                    String fileName = file.getFilename();
                    //            System.out.println(fileName+"-------fileName");
                    OperationBinding ob = getBindings().getOperationBinding("uploadDocument");
                    ob.getParamsMap().put("param1", "SICD");
                    ob.getParamsMap().put("param2", "0031");
                    ob.getParamsMap().put("param3", "Application");
                    ob.getParamsMap().put("fileName", fileName);
                    ob.getParamsMap().put("rejected", rejected);
                    Object object = ob.execute();
                    String path = null;
                    if (object != null) {
                        path = object.toString();
                    } //            ADFUtils.uploadFile(in, path);
                    if (path != null)
                        ADFUtils.uploadFile(file, path);
                    //                messagePopup.hide();

                    //        supportingDoumentViewLink.setVisible(true);
                    //        AdfFacesContext.getCurrentInstance().addPartialTarget(supportingDoumentViewLink);
                }
            }
            setInlineFrameSource(getSupportingDocuments());
        } catch (IOException e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while upload document." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                            e.printStackTrace();
        }
    }

    public void setInternalSupportingFileBind(RichInputFile internalSupportingFileBind) {
        this.internalSupportingFileBind = internalSupportingFileBind;
    }

    public RichInputFile getInternalSupportingFileBind() {
        return internalSupportingFileBind;
    }

    public void setDocumentHistoryPopup(RichPopup documentHistoryPopup) {
        this.documentHistoryPopup = documentHistoryPopup;
    }

    public RichPopup getDocumentHistoryPopup() {
        return documentHistoryPopup;
    }

    public void photoHistoryLink(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("filterDocumentHistoryDetails");
            ob.getParamsMap().put("p_doc_code", "0002");
            ob.execute();
            showPopup(documentHistoryPopup, true);
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading popup." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }

    public void attestationHistoryLink(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("filterDocumentHistoryDetails");
            ob.getParamsMap().put("p_doc_code", "0001");
            ob.execute();
            showPopup(documentHistoryPopup, true);
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading popup." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }

    public void identityDocHistoryLink(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("filterDocumentHistoryDetails");
            ob.getParamsMap().put("p_doc_code", "0003");
            ob.execute();
            showPopup(documentHistoryPopup, true);
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading popup." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }

    public void medicalHistoryLink(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("filterDocumentHistoryDetails");
            ob.getParamsMap().put("p_doc_code", "0004");
            ob.execute();
            showPopup(documentHistoryPopup, true);
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading popup." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }

    public void seaserviceHistoryLink(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("filterDocumentHistoryDetails");
            ob.getParamsMap().put("p_doc_code", "0008");
            ob.execute();
            showPopup(documentHistoryPopup, true);
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading popup." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }

    public void securityHistoryLink(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("filterDocumentHistoryDetails");
            ob.getParamsMap().put("p_doc_code", "0016");
            ob.execute();
            showPopup(documentHistoryPopup, true);
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading popup." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }

    public void internalDocHistoryLink(ActionEvent actionEvent) {
        OperationBinding ob = getBindings().getOperationBinding("filterDocumentHistoryDetails");
        ob.getParamsMap().put("p_doc_code", "0031");
        ob.execute();
        showPopup(documentHistoryPopup, true);
    }

    public void affidavitHistoryLink(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("filterDocumentHistoryDetails");
            ob.getParamsMap().put("p_doc_code", "0009");
            ob.execute();
            showPopup(documentHistoryPopup, true);
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading popup." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }

    public void multipleChoiceValueChangeListener(ValueChangeEvent valueChangeEvent) {
        //       System.out.println(valueChangeEvent.getNewValue().toString()+"------");
    }

    public void searchSeafarerDetailsFetchListener(PopupFetchEvent popupFetchEvent) {
        OperationBinding ob = getBindings().getOperationBinding("filterSearchSeafarerDetails");
        ob.execute();
    }

    public void setAgentEmailIdInputTextBind(RichInputText agentEmailIdInputTextBind) {
        this.agentEmailIdInputTextBind = agentEmailIdInputTextBind;
    }

    public RichInputText getAgentEmailIdInputTextBind() {
        return agentEmailIdInputTextBind;
    }

    public void setAgentEmailIdManyChoiceBind(RichSelectManyChoice agentEmailIdManyChoiceBind) {
        this.agentEmailIdManyChoiceBind = agentEmailIdManyChoiceBind;
    }

    public RichSelectManyChoice getAgentEmailIdManyChoiceBind() {
        return agentEmailIdManyChoiceBind;
    }

    public void consentPopupCanceledListener(PopupCanceledEvent popupCanceledEvent) {
        consentUploadDocumentBind.resetValue();
        consentUploadDocumentBind.setValid(false);
        //        System.out.println("----cancel");
    }

    public void additionalDocumentsValueChangeListener(ValueChangeEvent valueChangeEvent) {
        try {
            String rejected =
                AdfFacesContext.getCurrentInstance().getPageFlowScope().get("param_rejected_tab").toString();

            RichInputFile inputFileComponent = (RichInputFile) valueChangeEvent.getComponent();
            UploadedFile file = (UploadedFile) valueChangeEvent.getNewValue();
            if (valueChangeEvent.getNewValue() != null) {
                if (!file.getFilename().endsWith("pdf") && !file.getFilename().endsWith("PDF")) {
                    inputFileComponent.resetValue();
                    inputFileComponent.setValid(false);
                    FacesMessage Message = new FacesMessage("Only PDF files are allowed.");
                    Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);


                } else {
                    //                showPopup(messagePopup, true);
                    InputStream in = file.getInputStream();
                    String fileName = file.getFilename();
                    //            System.out.println(fileName+"-------fileName");
                    OperationBinding ob = getBindings().getOperationBinding("uploadDocument");
                    ob.getParamsMap().put("param1", "SICD");
                    ob.getParamsMap().put("param2", "0033");
                    ob.getParamsMap().put("param3", "Application");
                    ob.getParamsMap().put("fileName", fileName);
                    ob.getParamsMap().put("rejected", rejected);
                    Object object = ob.execute();
                    String path = null;
                    if (object != null) {
                        path = object.toString();
                    } //            ADFUtils.uploadFile(in, path);
                    if (path != null)
                        ADFUtils.uploadFile(file, path);
                    //                messagePopup.hide();

                    //        supportingDoumentViewLink.setVisible(true);
                    //        AdfFacesContext.getCurrentInstance().addPartialTarget(supportingDoumentViewLink);
                }
            }
            setInlineFrameSource(getAdditionalDocumentLink());
        } catch (IOException e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while upload document." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            //                e.printStackTrace();
        }
    }

    public void yesButtonOnConfirmationPopup(ActionEvent actionEvent) {
        try {
            OperationBinding check = getBindings().getOperationBinding("checkForResubmit");
           String res = check.execute().toString();
            if(res.equalsIgnoreCase("ok"))
            {
            
            OperationBinding ob = getBindings().getOperationBinding("resubmit");
            ob.execute();


            //            showPopup(resubmitPopupBind, true);

            OperationBinding ob1 = getBindings().getOperationBinding("searchBatch");
            ob1.execute();

            FacesMessage Message = new FacesMessage("Batch has been successfully Resubmitted.");
            Message.setSeverity(FacesMessage.SEVERITY_INFO);
            FacesContext fc = FacesContext.getCurrentInstance();
            fc.addMessage(null, Message);
            }
            else
            {
                    FacesMessage Message = new FacesMessage("Please upload documents requested for correction of deficiency before resubmitting the application.");
                    Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);    
                
                }
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while submitting batch." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }

    public void noButtonOnResubmitConfirmation(ActionEvent actionEvent) {
        resubmitConfirmPopup.hide();
    }

    public void setResubmitConfirmPopup(RichPopup resubmitConfirmPopup) {
        this.resubmitConfirmPopup = resubmitConfirmPopup;
    }

    public RichPopup getResubmitConfirmPopup() {
        return resubmitConfirmPopup;
    }

    public void ocHistoryLink(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("filterDocumentHistoryDocsIfaceDetails");
            ob.getParamsMap().put("p_doc_code", "0005");
            ob.execute();
            showPopup(documentHistoryDocsIfacePopup, true);
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading popup." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }

    public void sqcCocHistoryLink(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("filterDocumentHistoryDocsIfaceDetails");
            ob.getParamsMap().put("p_doc_code", "0006");
            ob.execute();
            showPopup(documentHistoryDocsIfacePopup, true);
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading popup." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }

    public void sqcSupportHistoryLink(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("filterDocumentHistoryDocsIfaceDetails");
            ob.getParamsMap().put("p_doc_code", "0011");
            ob.execute();
            showPopup(documentHistoryDocsIfacePopup, true);
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading popup." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }

    public void setDocumentHistoryDocsIfacePopup(RichPopup documentHistoryDocsIfacePopup) {
        this.documentHistoryDocsIfacePopup = documentHistoryDocsIfacePopup;
    }

    public RichPopup getDocumentHistoryDocsIfacePopup() {
        return documentHistoryDocsIfacePopup;
    }

    public void purchaseOrderNumberVCL(ValueChangeEvent valueChangeEvent) {
        try {
            if (valueChangeEvent.getNewValue() != null) {
                String newValue = valueChangeEvent.getNewValue().toString();
                OperationBinding ob = getBindings().getOperationBinding("purchaseNumberCheck");
                ob.getParamsMap().put("purchaseOrderNumber", newValue);
                String res = ob.execute().toString();
                if (res.equalsIgnoreCase("repeat")) {

                    FacesMessage Message = new FacesMessage("Batch already exists with this purchase order number.");
                    Message.setSeverity(FacesMessage.SEVERITY_WARN);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);
                }


            }
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while validating data." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }

    public void setUseSelectedSeafarerbuttonBind(RichButton useSelectedSeafarerbuttonBind) {
        this.useSelectedSeafarerbuttonBind = useSelectedSeafarerbuttonBind;
    }

    public RichButton getUseSelectedSeafarerbuttonBind() {
        return useSelectedSeafarerbuttonBind;
    }

    public void previousSeafarer(ActionEvent actionEvent) {
        OperationBinding ob = getBindings().getOperationBinding("Previous");
        ob.execute();
        basicInformationtabBind.setDisclosed(true);
        AdfFacesContext.getCurrentInstance().addPartialTarget(basicInformationtabBind);
    }

    public void nextSeaferer(ActionEvent actionEvent) {
        OperationBinding ob = getBindings().getOperationBinding("Next");
        ob.execute();
        basicInformationtabBind.setDisclosed(true);
        AdfFacesContext.getCurrentInstance().addPartialTarget(basicInformationtabBind);
    }

    public void setValidationnMessagePopup(RichPopup validationnMessagePopup) {
        this.validationnMessagePopup = validationnMessagePopup;
    }

    public RichPopup getValidationnMessagePopup() {
        return validationnMessagePopup;
    }

    public void setMessageValidatePopup(RichPopup messageValidatePopup) {
        this.messageValidatePopup = messageValidatePopup;
    }

    public RichPopup getMessageValidatePopup() {
        return messageValidatePopup;
    }

    public void setQuickPickOcTableBind(RichTable quickPickOcTableBind) {
        this.quickPickOcTableBind = quickPickOcTableBind;
    }

    public RichTable getQuickPickOcTableBind() {
        return quickPickOcTableBind;
    }

    public void setQuickPickSqcTableBind(RichTable quickPickSqcTableBind) {
        this.quickPickSqcTableBind = quickPickSqcTableBind;
    }

    public RichTable getQuickPickSqcTableBind() {
        return quickPickSqcTableBind;
    }

    public void ocIssueDateValidator(FacesContext facesContext, UIComponent uIComponent, Object object) {
        //        try {
        //
        //        } catch (ValidatorException ve) {
        //            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while validating data." +
        //            " Please contact your System Administrator." ,
        //            "", FacesMessage.SEVERITY_ERROR);
        //        }
        if (object != null) {
            long millis = System.currentTimeMillis();
            java.util.Date date1 = null;
            java.util.Date date2 = null;
            java.sql.Date date = new java.sql.Date(millis);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            try {
                date1 = sdf.parse(object.toString());
                date2 = sdf.parse(date.toString());
            } catch (ParseException pce) {
                pce.printStackTrace();
                ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while validating issue date." +
                                                       " Please contact your System Administrator.", "",
                                                       FacesMessage.SEVERITY_ERROR);
            }
            int countfnd = date1.compareTo(date2);
            //                System.out.println(countfnd);
            if (countfnd > 0) {
                throw new ValidatorException(new FacesMessage(FacesMessage.SEVERITY_ERROR,
                                                              "Issue date can not be greater than current date.",
                                                              null));


            }
        }

    }

    public void sqcIssueDateValidator(FacesContext facesContext, UIComponent uIComponent, Object object) {
        //        try {
        //        } catch (ValidatorException ve) {
        //            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while validating data." +
        //            " Please contact your System Administrator." ,
        //            "", FacesMessage.SEVERITY_ERROR);
        //        }
        if (object != null) {
            long millis = System.currentTimeMillis();
            java.util.Date date1 = null;
            java.util.Date date2 = null;
            java.sql.Date date = new java.sql.Date(millis);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            try {
                date1 = sdf.parse(object.toString());
                date2 = sdf.parse(date.toString());
            } catch (ParseException pce) {
                pce.printStackTrace();
                ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while validating issue date." +
                                                       " Please contact your System Administrator.", "",
                                                       FacesMessage.SEVERITY_ERROR);
            }
            int countfnd = date1.compareTo(date2);
            //                System.out.println(countfnd);
            if (countfnd > 0) {
                throw new ValidatorException(new FacesMessage(FacesMessage.SEVERITY_ERROR,
                                                              "Issue date can not be greater than current date.",
                                                              null));


            }
        }
    }

    public File uploadedFileToFile(UploadedFile uf) {
        InputStream inputStream = null;
        OutputStream outputStream = null;
        System.setProperty("file.encoding", "UTF-8");
        File newFile = new File(uf.getFilename());
        try {
            inputStream = uf.getInputStream();
            outputStream = new FileOutputStream(newFile);
            int read = 0;
            byte[] bytes = new byte[10240];
            while ((read = inputStream.read(bytes)) != -1) {
                outputStream.write(bytes, 0, read);
            }
        } catch (IOException e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading document." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
        return newFile;
    }

    public void vesselDetailPopupFetchListener(PopupFetchEvent popupFetchEvent) {
        OperationBinding ob = getBindings().getOperationBinding("filterVesselDetail");
        ob.execute();
    }

    public void sendToInternalAgentButton(ActionEvent actionEvent) {
        try {
            OperationBinding ob1 = getBindings().getOperationBinding("checkSeafarerValidate");
            String res = (String) ob1.execute();
            if (res.equalsIgnoreCase("true")) {
                showPopup(internalAgentCoonfirmationPopup, true);
            } else {
                ADFUtils.addFormattedFacesErrorMessage("Please add at least one seafarer.", "",
                                                       FacesMessage.SEVERITY_ERROR);
            }
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while submitting batch." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }

    public void consentStartDateValidator(FacesContext facesContext, UIComponent uIComponent, Object object) {

        if (object != null) {
            long millis = System.currentTimeMillis();
            java.util.Date date1 = null;
            java.util.Date date2 = null;
            java.sql.Date date = new java.sql.Date(millis);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            try {
                date1 = sdf.parse(object.toString());
                date2 = sdf.parse(date.toString());
            } catch (ParseException pce) {
                pce.printStackTrace();
                ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while validating issue date." +
                                                       " Please contact your System Administrator.", "",
                                                       FacesMessage.SEVERITY_ERROR);
            }
            int countfnd = date1.compareTo(date2);
            System.out.println(countfnd);
            if (countfnd > 0) {
                throw new ValidatorException(new FacesMessage(FacesMessage.SEVERITY_ERROR,
                                                              "Issue date can not be greater than current date.",
                                                              null));


            }
        }


    }

    public void vesselNameInternalValueChangeListener(ValueChangeEvent valueChangeEvent) {
        AdfFacesContext.getCurrentInstance().addPartialTarget(officialNumberBinding);
        AdfFacesContext.getCurrentInstance().addPartialTarget(imoNumberBinding);
        AdfFacesContext.getCurrentInstance().addPartialTarget(vesselPkBinding);
    }

    public void setOfficialNumberBinding(RichInputText officialNumberBinding) {
        this.officialNumberBinding = officialNumberBinding;
    }

    public RichInputText getOfficialNumberBinding() {
        return officialNumberBinding;
    }

    public void setImoNumberBinding(RichInputText imoNumberBinding) {
        this.imoNumberBinding = imoNumberBinding;
    }

    public RichInputText getImoNumberBinding() {
        return imoNumberBinding;
    }

    public void setVesselPkBinding(RichInputText vesselPkBinding) {
        this.vesselPkBinding = vesselPkBinding;
    }

    public RichInputText getVesselPkBinding() {
        return vesselPkBinding;
    }

    public void addConsentConfirmDialogListener(DialogEvent dialogEvent) {
        if (dialogEvent.getOutcome() == DialogEvent.Outcome.yes) {
            showPopup(consentPopupBind, true);
        }
    }

    public void setConsentConfirmPopupBind(RichPopup consentConfirmPopupBind) {
        this.consentConfirmPopupBind = consentConfirmPopupBind;
    }

    public RichPopup getConsentConfirmPopupBind() {
        return consentConfirmPopupBind;
    }

    public void safarerNameValidator(FacesContext facesContext, UIComponent uIComponent, Object object) {
        if (object != null) {
            if (!object.toString().equalsIgnoreCase("") && !object.toString().equalsIgnoreCase(" ")) {
                Pattern pattern = Pattern.compile("[a-zA-Z0-9-.,'\\s]+$");
                String str = object.toString();
                String ERROR_MESSAGE = "Only alphanumeric and below symbols are allowed  - . , '.";
                Matcher matcher = pattern.matcher(str);
                if (matcher.matches()) {
                    //                   System.out.println("string '"+str + "' is alphanumeric");
                } else {
                    throw new ValidatorException(new FacesMessage(FacesMessage.SEVERITY_ERROR, ERROR_MESSAGE, null));
                }
            }
        }
    }

    public void lastNameValidator(FacesContext facesContext, UIComponent uIComponent, Object object) {
        if (object != null) {
            if (!object.toString().equalsIgnoreCase("") && !object.toString().equalsIgnoreCase(" ")) {
                Pattern pattern = Pattern.compile("[a-zA-Z0-9-.,/'\\s]+$");
                String str = object.toString();
                String ERROR_MESSAGE = "Only alphanumeric and below symbols are allowed  - . , ' /.";
                Matcher matcher = pattern.matcher(str);
                if (matcher.matches()) {
                    //                   System.out.println("string '"+str + "' is alphanumeric");
                } else {
                    throw new ValidatorException(new FacesMessage(FacesMessage.SEVERITY_ERROR, ERROR_MESSAGE, null));
                }
            }
        }

    }

    public void uploadConsentButton(ActionEvent actionEvent) {
        setUploadConsentFieldsDisable("N");

        OperationBinding val = getBindings().getOperationBinding("validateConsentExpDate");
        String res = val.execute().toString();
        System.out.println(res + "----res");
        if (res.equalsIgnoreCase("high")) {
            showPopup(consentConfirmPopupBind, true);
        } else {
            showPopup(consentPopupBind, true);
        }
    }

    public void viewConsentbutton(ActionEvent actionEvent) {
        setUploadConsentFieldsDisable("Y");
        showPopup(consentPopupBind, true);

    }

    public void defcicienciesButton(ActionEvent actionEvent) {
        
        try {
            OperationBinding val = getBindings().getOperationBinding("deficiency_details");
            val.execute();
        }catch (NullPointerException ne) {
            // TODO: Add catch code
            ne.printStackTrace();
        } 
        catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception." +
            " Please contact your System Administrator." ,
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
        showPopup(deficiencyPopup, true);
    }

    public void setDeficiencyPopup(RichPopup deficiencyPopup) {
        this.deficiencyPopup = deficiencyPopup;
    }

    public RichPopup getDeficiencyPopup() {
        return deficiencyPopup;
    }

    public void ackowldgementValueChangeListener(ValueChangeEvent valueChangeEvent) {
        String ackno = valueChangeEvent.getNewValue().toString();
        
        OperationBinding validate = getBindings().getOperationBinding("ackNumberValidate");
        validate.getParamsMap().put("ackNo", ackno);

         String res = validate.execute().toString();
        if(res.equalsIgnoreCase("validated"))
        {
        OperationBinding val = getBindings().getOperationBinding("ackNumberValueChangeListener");
        val.getParamsMap().put("ackNo", ackno);

        val.execute();
    }
        else
        {
                ADFUtils.addFormattedFacesErrorMessage("Please enter a valid acknowledgement number." +
                "" ,
                "", FacesMessage.SEVERITY_ERROR);
                
                
            
            }
    }

    public void setConsentAckNumberBind(RichInputText consentAckNumberBind) {
        this.consentAckNumberBind = consentAckNumberBind;
    }

    public RichInputText getConsentAckNumberBind() {
        return consentAckNumberBind;
    }

    public void setInvoiceAgentEmailIdManyChoiceBind(RichSelectManyChoice invoiceAgentEmailIdManyChoiceBind) {
        this.invoiceAgentEmailIdManyChoiceBind = invoiceAgentEmailIdManyChoiceBind;
    }

    public RichSelectManyChoice getInvoiceAgentEmailIdManyChoiceBind() {
        return invoiceAgentEmailIdManyChoiceBind;
    }

    public void gradeCodeValueChangeListener(ValueChangeEvent valueChangeEvent) {
valueChangeEvent.getComponent().processUpdates(FacesContext.getCurrentInstance());
    OperationBinding val = getBindings().getOperationBinding("gradeIdValueChangeListener");
    val.execute();
    AdfFacesContext.getCurrentInstance().addPartialTarget(panelTabBind); AdfFacesContext.getCurrentInstance().addPartialTarget(sqcTableBind);
}

    public void setSqcTableBind(RichTable sqcTableBind) {
        this.sqcTableBind = sqcTableBind;
    }

    public RichTable getSqcTableBind() {
        return sqcTableBind;
    }

    public void certificateValueChangeListener(ValueChangeEvent valueChangeEvent) {
            valueChangeEvent.getComponent().processUpdates(FacesContext.getCurrentInstance());

        OperationBinding val = getBindings().getOperationBinding("changeDocChargable");
        val.execute();    }

    public void issuingCountryValueChangeListener(ValueChangeEvent valueChangeEvent) {
//        OperationBinding val = getBindings().getOperationBinding("changeDocChargable");
//        val.execute();   
}

    public void expDateValueChangeListener(ValueChangeEvent valueChangeEvent) {
            valueChangeEvent.getComponent().processUpdates(FacesContext.getCurrentInstance());

        OperationBinding val = getBindings().getOperationBinding("changeDocExpDateChargable");
        val.execute();    }

    public void gradeCodeOcValueChangeListener(ValueChangeEvent valueChangeEvent) {
        valueChangeEvent.getComponent().processUpdates(FacesContext.getCurrentInstance());
            OperationBinding val = getBindings().getOperationBinding("gradeIdOcValueChangeListener");
            val.execute();
            AdfFacesContext.getCurrentInstance().addPartialTarget(panelTabBind); AdfFacesContext.getCurrentInstance().addPartialTarget(ocTableBind);    }

    public void setOcTableBind(RichTable ocTableBind) {
        this.ocTableBind = ocTableBind;
    }

    public RichTable getOcTableBind() {
        return ocTableBind;
    }

    public void pressifnoconfirmationdialogListener(DialogEvent dialogEvent) {
        if(dialogEvent.getOutcome().toString().equalsIgnoreCase("ok"))
        {
        OperationBinding ob = getBindings().getOperationBinding("setSeafarer");
        ob.execute();
        }}

    public void setPressIfNoConfirmationPopupBind(RichPopup pressIfNoConfirmationPopupBind) {
        this.pressIfNoConfirmationPopupBind = pressIfNoConfirmationPopupBind;
    }

    public RichPopup getPressIfNoConfirmationPopupBind() {
        return pressIfNoConfirmationPopupBind;
    }

    public void setPressifConfirmationPopupBind(RichPopup pressifConfirmationPopupBind) {
        this.pressifConfirmationPopupBind = pressifConfirmationPopupBind;
    }

    public RichPopup getPressifConfirmationPopupBind() {
        return pressifConfirmationPopupBind;
    }

    public void pressifConfirmationPopupDialogListener(DialogEvent dialogEvent) {
if(dialogEvent.getOutcome().toString().equalsIgnoreCase("ok"))
{
        setDocumentName("fin");
        setDocumentId(null);
        setName(null);
        setBirthdate(null);
        setSeafaId(null);
        showPopup(searchSeafarerPopup, true);  
    
    }}

    public void bookValueChangeListener(ValueChangeEvent valueChangeEvent) {
        try
        {
        System.out.println("bookIssueTypeVCL called :: " + valueChangeEvent.getNewValue());



        if (valueChangeEvent.getNewValue() != null) {
        OperationBinding updateIssueType = getBindings().getOperationBinding("updateIssueTypeManually");
        updateIssueType.getParamsMap().put("updateFor", "Book");
        updateIssueType.execute();
        }
        } catch (Exception e) {
        e.printStackTrace();
        ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while updating Book Issue Type." +
        " Please contact your System Administrator." ,
        "", FacesMessage.SEVERITY_ERROR);
        }    }

    public void idCardValueChangeListener(ValueChangeEvent valueChangeEvent) {
        try
        {
        System.out.println("idcardIssueTypeVCL called :: " + valueChangeEvent.getNewValue());



        if (valueChangeEvent.getNewValue() != null) {
        OperationBinding updateIssueType = getBindings().getOperationBinding("updateIssueTypeManually");
        updateIssueType.getParamsMap().put("updateFor", "IDCard");
        updateIssueType.execute();
        }
        } catch (Exception e) {
        e.printStackTrace();
        ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while updating ID Card Issue Type." +
        " Please contact your System Administrator." ,
        "", FacesMessage.SEVERITY_ERROR);
        }    }

    public void setInvoiceAgentEmailIdInputTextBind(RichInputText invoiceAgentEmailIdInputTextBind) {
        this.invoiceAgentEmailIdInputTextBind = invoiceAgentEmailIdInputTextBind;
    }

    public RichInputText getInvoiceAgentEmailIdInputTextBind() {
        return invoiceAgentEmailIdInputTextBind;
    }

    public void setConsentOnlineDate(RichInputDate consentOnlineDate) {
        this.consentOnlineDate = consentOnlineDate;
    }

    public RichInputDate getConsentOnlineDate() {
        return consentOnlineDate;
    }

    public void setTranInvoiceAgentTextBoxBind(RichInputText tranInvoiceAgentTextBoxBind) {
        this.tranInvoiceAgentTextBoxBind = tranInvoiceAgentTextBoxBind;
    }

    public RichInputText getTranInvoiceAgentTextBoxBind() {
        return tranInvoiceAgentTextBoxBind;
    }
    
    private boolean isTransactionDirty() 
    {
        BindingContext context = BindingContext.getCurrent();
        DCBindingContainer binding = (DCBindingContainer) context.getCurrentBindingsEntry();
        DCDataControl dc = binding.getDataControl();

        return dc.isTransactionDirty() || dc.isTransactionModified();
    }

    public void unsavedWarningPopupDL(DialogEvent dialogEvent)
    {
        if(dialogEvent.getOutcome() != null && 
           (dialogEvent.getOutcome().toString().equalsIgnoreCase("Yes") 
            || dialogEvent.getOutcome().toString().equalsIgnoreCase("Ok")))
        {
            OperationBinding rollbackOb = getBindings().getOperationBinding("Rollback");
            rollbackOb.execute();
        }
    }

    public void setUnsavedWarningPopupBind(RichPopup unsavedWarningPopupBind) {
        this.unsavedWarningPopupBind = unsavedWarningPopupBind;
    }

    public RichPopup getUnsavedWarningPopupBind() {
        return unsavedWarningPopupBind;
    }

    public String unsavedWarningYesAction() 
    {
        OperationBinding del = getBindings().getOperationBinding("deleteSingleSeafarer");
        del.execute();
        
        OperationBinding rollbackOb = getBindings().getOperationBinding("Rollback");
        rollbackOb.execute();
        
        Object esiBatchId = AdfFacesContext.getCurrentInstance().getPageFlowScope().get("CURRENT_ESI_BATCH_ID");
        
        if(esiBatchId != null)
        {
            OperationBinding filterBatch = getBindings().getOperationBinding("editBatch");
            filterBatch.getParamsMap().put("batchId", Integer.parseInt(esiBatchId.toString()));
            filterBatch.execute();
        }
        
        unsavedWarningPopupBind.hide();
        return "back";
    }

    public String unsavedWarningNoAction()
    {
        unsavedWarningPopupBind.hide();
        return null;
    }
    
    public String unsavedWarningYesActionBatchPage() 
    {
        
        
        OperationBinding rollbackOb = getBindings().getOperationBinding("Rollback");
        rollbackOb.execute();
        
        OperationBinding ob = getBindings().getOperationBinding("refreshBatchIfaceView");
        ob.execute();
        
        unsavedWarningPopupBindBatchPage.hide();
        return "back";
    }

    public String unsavedWarningNoActionBatchPage()
    {
        unsavedWarningPopupBindBatchPage.hide();
        return null;
    }

    public void setUnsavedWarningPopupBindBatchPage(RichPopup unsavedWarningPopupBindBatchPage) {
        this.unsavedWarningPopupBindBatchPage = unsavedWarningPopupBindBatchPage;
    }

    public RichPopup getUnsavedWarningPopupBindBatchPage() {
        return unsavedWarningPopupBindBatchPage;
    }
    
    public void batchTaskflowInitializer()
    {
        try 
        {
            System.out.println("CURRENT_ESI_BATCH_ID in batchTaskflowInitializer :: " +
                               AdfFacesContext.getCurrentInstance().getPageFlowScope().get("CURRENT_ESI_BATCH_ID"));
            
            OperationBinding ob = ADFUtils.findOperation("batchCurrentRow");
            ob.execute();
        } catch (Exception e) {
        }
    }
    
    public void batchTaskflowFinalizer()
    {
        try 
        {
            System.out.println("CURRENT_ESI_BATCH_ID in batchTaskflowFinalizer :: " +
                               AdfFacesContext.getCurrentInstance().getPageFlowScope().get("CURRENT_ESI_BATCH_ID"));
//            BindingContext context = BindingUtils.getBindingContext();
//            DCBindingContainer bindings = (DCBindingContainer) context.getCurrentBindingsEntry();
//            DCIteratorBinding iterator = (DCIteratorBinding) bindings.findIteratorBinding("BatchesVOIterator");
//            ViewObject seafarerVO = iterator.getViewObject();
//            Row currentRow = (seafarerVO.getCurrentRow() != null) ? seafarerVO.getCurrentRow() : seafarerVO.first();
//            if (currentRow.getAttribute("EsiBatchId") != null)
//                System.out.println("currentRow EsiBatchId :: " + currentRow.getAttribute("EsiBatchId"));
                        
            OperationBinding ob = ADFUtils.findOperation("batchCurrentRow");
            ob.execute();
        } catch (Exception e) {
        }
    }
    
    public void batchTaskflowExceptionHandler()
    {
        try
        {
           System.out.println("CURRENT_ESI_BATCH_ID in batchTaskflowExceptionHandler :: " +
                               AdfFacesContext.getCurrentInstance().getPageFlowScope().get("CURRENT_ESI_BATCH_ID"));   
                        
            OperationBinding ob = ADFUtils.findOperation("batchCurrentRow");
            ob.execute();
        } catch (Exception e) {
        }
    }

    public void expeditedValueChangeListener(ValueChangeEvent valueChangeEvent) {
        try 
               {
                   if (valueChangeEvent.getNewValue() != null)
                       ADFContext.getCurrent().getPageFlowScope().put("P_EXPEDITED_SRC", "Y");
               } catch (Exception e) {
                   e.printStackTrace();
                   ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while selecting Expedited." +
                                                    " Please contact your System Administrator." , 
                                                    "", FacesMessage.SEVERITY_ERROR); 
               }    }
}
