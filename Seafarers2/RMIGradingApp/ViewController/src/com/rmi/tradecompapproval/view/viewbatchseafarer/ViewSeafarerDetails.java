package com.rmi.tradecompapproval.view.viewbatchseafarer;

import com.rmi.tradecompapproval.utils.IriAdfUtils;

import com.rmi.tradecompapproval.utils.IriJsfUtils;

import com.lowagie.text.Document;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfImportedPage;
import com.lowagie.text.pdf.PdfReader;
import com.lowagie.text.pdf.PdfWriter;

//import com.rmi.manualtradecompliance.utils.JSFUtils;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import java.net.MalformedURLException;
import java.net.URL;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.faces.application.FacesMessage;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;

import javax.faces.event.ValueChangeEvent;

import javax.servlet.http.HttpServletRequest;

import javax.servlet.http.HttpSession;

import oracle.adf.controller.ControllerContext;
import oracle.adf.controller.ViewPortContext;
import oracle.adf.model.BindingContext;
import oracle.adf.model.binding.DCIteratorBinding;
import oracle.adf.share.ADFContext;
import oracle.adf.view.rich.component.rich.RichPopup;
import oracle.adf.view.rich.component.rich.data.RichTable;
import oracle.adf.view.rich.component.rich.input.RichInputText;
import oracle.adf.view.rich.component.rich.layout.RichPanelTabbed;
import oracle.adf.view.rich.component.rich.layout.RichShowDetailItem;

import oracle.adf.view.rich.event.DialogEvent;
import oracle.adf.view.rich.event.PopupFetchEvent;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

import oracle.jbo.Row;
import oracle.jbo.Key;

import oracle.adf.view.rich.component.rich.layout.RichPanelBox;
import oracle.adf.view.rich.component.rich.layout.RichPanelFormLayout;
import oracle.adf.view.rich.component.rich.nav.RichButton;
import oracle.adf.view.rich.context.AdfFacesContext;
import oracle.adf.view.rich.render.ClientEvent;
import oracle.adf.view.rich.util.ResetUtils;

import oracle.jbo.RowSetIterator;

import org.apache.myfaces.trinidad.event.DisclosureEvent;
import org.apache.myfaces.trinidad.model.UploadedFile;
import org.apache.myfaces.trinidad.render.ExtendedRenderKitService;
import org.apache.myfaces.trinidad.util.Service;

public class ViewSeafarerDetails {

    private RichInputText firstname;
    private String photoLink;
    private RichInputText photouploaded;
    private RichInputText identitydoc;
    private RichInputText medicalphysicaledoc;
    private RichInputText serviceTrans;
    private RichInputText applicationedoc;
    private RichInputText affidavit;
    private RichInputText securitysatedoc;
    private String photoLink_test;
    private String offlineLink_test;
    private RichInputText consentdoc;
    private RichPanelBox photobind;
    private RichPanelBox documentbind;
    private RichPopup photobindpopup;
    private RichInputText photoValue;
    private RichInputText seaservicevalue;
    private RichPopup seaservicebindpopup;
    private RichPopup identitydocbindpopup;
    private RichInputText identitydocvalue;
    private RichPopup medicalbindpopup;
    private RichInputText medicalvalue;
    private RichPopup attestationbindpopup;
    private RichInputText attestationvalue;
    private RichPopup affbindpopup;
    private RichInputText affvalue;
    private RichPopup securitybindpopup;
    private RichInputText securityvalue;
    private RichPopup conGrdStatusbindpopup;
    private RichInputText conGrdvalue;
    private RichInputText seafarergradingsts;
    private RichInputText tcstatus;
    private RichInputText tcdate;
    private RichInputText internaledoc;
    private RichPanelBox offlinebind;
    private String internaldocument;
    private String batchName;
    private String woNumber;
    private RichPopup approveSeafarerBindPopup;
    private RichPopup holdSeafarerBindPopup;
    private RichPopup processOrderErrorsPopupBind;
    private RichPopup sqcGradeCommentbindpopup;
    private RichPopup ocGradeCommentbindpopup;
    private RichPopup bookGradeCommentbindpopup;
    private RichPopup historyPopupBinding;
    private RichPopup seafarerListPopupBind;
    private RichPanelTabbed panelTabBind;
    private RichShowDetailItem basicInfoTabBind;
    private RichInputText seafarerGrdStatus;
    private RichPopup verificationCommentsPopup;
    private RichPopup verificationCommentsOcPopup;
    private RichPopup verificationCommentsSqcPopup;
    private RichPopup verificationCommentsInfoPopup;
    private RichPopup verifySeafarerDataPopup;
    private RichPopup deficientAckQaPopup;
    private RichPopup deficientAckTcPopup;
    private RichPopup rejectCraPopup;
    private RichPopup vefificationCommentsBookPopup;
    private RichTable ocDocTable;
    private RichButton rejectCraButton;
    private RichPopup selectMultipleReasonPopup;
    private RichInputText ocHoldReasonInput;
    private RichInputText bookHoldReasonInput;
    private RichInputText sqcHoldReasonInput;
    private RichPanelFormLayout basicInfoForm;    
    public UploadedFile cocOc;    
    public UploadedFile cocSqc;
    private RichPopup approveAllDocsCertsPopupBind;
    private RichPopup verifyAllDocsCertsPopupBind;
    private RichPopup verifyAllDocsPopupBind;
    private RichPopup idcardGradeCommentPopup;
    private RichInputText idcardHoldReasonInput;
    private RichPopup verificationCommentsIdCardPopup;
    private RichPopup updateSeafarerIdPopup;


    public ViewSeafarerDetails() 
    {
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

    public void setCocOc(UploadedFile cocOc) {
        this.cocOc = cocOc;
    }

    public UploadedFile getCocOc() {
        return cocOc;
    }

    public void setCocSqc(UploadedFile cocSqc) {
        this.cocSqc = cocSqc;
    }

    public UploadedFile getCocSqc() {
        return cocSqc;
    }

    public BindingContainer getBindings() {
        return BindingContext.getCurrent().getCurrentBindingsEntry();
    }
    
    public void setPhotoLink_test(String photoLink_test) {
            this.photoLink_test = photoLink_test;
        }

        public String getPhotoLink_test() {
            return photoLink_test;
        }

    public void setBatchName(String batchName) {
        this.batchName = batchName;
    }

    public String getBatchName()
    {
        try
        {
           if (this.batchName == null) {
                OperationBinding batchNmOp = IriAdfUtils.findOperation("getCurrentBatchName");
                batchNmOp.execute();

                if (batchNmOp.getResult() != null && batchNmOp.getResult().toString().length() > 0) {
                    return batchNmOp.getResult().toString();
                }
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching batch name. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        
        return batchName;
    }

    public void setWoNumber(String woNumber) {
        this.woNumber = woNumber;
    }

    public String getWoNumber()
    {
        try 
        {
            if (this.woNumber == null) {
                OperationBinding woOp = IriAdfUtils.findOperation("getCurrentWoNumber");
                woOp.execute();

                if (woOp.getResult() != null && woOp.getResult().toString().length() > 0) {
                    return woOp.getResult().toString();
                }
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching Work Order number. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        
        return woNumber;
    }

    public Integer getUserId() 
    {
        try 
        {
            Object usrId = ADFContext.getCurrent().getSessionScope().get("UserId");
            return (Integer.parseInt(usrId != null ? usrId.toString() : "-1"));
            
        } catch (Exception nfe) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching user Id." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
        return -1;
    }

    public String approveSeafarer(ActionEvent actionEvent) 
    {
        try 
        {
            FacesContext fctx = FacesContext.getCurrentInstance();
            OperationBinding vldtSfrOp =
                IriAdfUtils.findOperation("approveSeafarerByEval");
            String str = vldtSfrOp.execute().toString();
            if (str.equalsIgnoreCase("Y")) {
                FacesMessage msg =
                    new FacesMessage(FacesMessage.SEVERITY_INFO,
                                     "Application has been approved.",
                                     "Application has been approved.");
                fctx.addMessage(null, msg);
                return null;
            }

            if (str.equalsIgnoreCase("C")) {
                FacesMessage msg =
                    new FacesMessage(FacesMessage.SEVERITY_INFO,
                                     "Certificates are pending for Verification !",
                                     "Certificates are pending for Verification !");
                fctx.addMessage(null, msg);

                return null;
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while approving seafarer." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);  
        }
            
       return null;
    }

        public void setPhotobind(RichPanelBox photobind) {
            this.photobind = photobind;
        }

        public RichPanelBox getPhotobind() {
            return photobind;
        }

        public void setDocumentbind(RichPanelBox documentbind) {
            this.documentbind = documentbind;
        }

        public RichPanelBox getDocumentbind() {
            return documentbind;
        }
    

    public void viewDocument(ActionEvent actionEvent)
    {
        try
        {
            photobind.setVisible(false);
            documentbind.setVisible(false);
            offlinebind.setVisible(false);
            DCIteratorBinding WBIter = null;
            WBIter = IriAdfUtils.findIterator("GetDocumentLinkRO1Iterator");
            WBIter.getViewObject().setWhereClause(null);
            WBIter.getViewObject().setNamedWhereClauseParam("pEdocId",
                                                            photouploaded.getValue());
            WBIter.executeQuery();
            if (WBIter.getEstimatedRowCount() > 0) {
                Row row = WBIter.getCurrentRow();
                System.out.println("Photo DocPath :: "+row.getAttribute("EdocId"));
//                setPhotoLink_test(row.getAttribute("DocPath").toString());
//                photobind.setVisible(true);
                setPhotoLink(row.getAttribute("EdocId").toString());
                documentbind.setVisible(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while viewing document." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);  
        }
    }

    public String supportingDocument(ActionEvent actionEvent) throws IOException 
    {
        try
        {
            photobind.setVisible(false);
            documentbind.setVisible(false);
            offlinebind.setVisible(false);
            
            try 
            {
                OperationBinding dataPrvcyCnstOp = IriAdfUtils.findOperation("genMergedAllSupportingDocs");
                dataPrvcyCnstOp.execute();
                System.out.println("dataPrvcyCnstOp.getResult() :: "+dataPrvcyCnstOp.getResult());
                if (dataPrvcyCnstOp.getResult() != null && dataPrvcyCnstOp.getResult().toString().length() > 0) 
                {
                    documentbind.setVisible(true);
//                    setPhotoLink(dataPrvcyCnstOp.getResult().toString());
                    setPhotoLink("-1&id="+getUserId());
                }
            } catch (Exception e) {
                e.printStackTrace();
                IriJsfUtils.addFormattedFacesErrorMessage(e.getMessage() , 
                                                          "", FacesMessage.SEVERITY_ERROR);
//                IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while generating supporting documents." +
//                                                            " Please contact your System Administrator." , 
//                                                          "", FacesMessage.SEVERITY_ERROR);
            }
        }catch(Exception e)
        {
            e.printStackTrace();
                IriJsfUtils.addFormattedFacesErrorMessage(e.getMessage() , 
                                                          "", FacesMessage.SEVERITY_ERROR);
//            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while viewing document." +
//                                             " Please contact your System Administrator." , 
//                                             "", FacesMessage.SEVERITY_ERROR);  
        }           
      return null;
    }

    public void mergePdfFiles(List<InputStream> inputPdfList,
            OutputStream outputStream) throws Exception{
    
        try 
        {
            //Create document and pdfReader objects.
            Document document = new Document();
            List<PdfReader> readers = new ArrayList<PdfReader>();
            int totalPages = 0;

            //Create pdf Iterator object using inputPdfList.
            Iterator<InputStream> pdfIterator = inputPdfList.iterator();

            // Create reader list for the input pdf files.
            while (pdfIterator.hasNext()) {
                InputStream pdf = pdfIterator.next();
                PdfReader pdfReader = new PdfReader(pdf);
                readers.add(pdfReader);
                totalPages = totalPages + pdfReader.getNumberOfPages();

                //System.out.println("total pages count="+pdfReader.getNumberOfPages());
            }

            // Create writer for the outputStream
            PdfWriter writer = PdfWriter.getInstance(document, outputStream);

            //Open document.
            document.open();

            //Contain the pdf data.
            PdfContentByte pageContentByte = writer.getDirectContent();

            PdfImportedPage pdfImportedPage;
            int currentPdfReaderPage = 1;
            Iterator<PdfReader> iteratorPDFReader = readers.iterator();

            // Iterate and process the reader list.
            while (iteratorPDFReader.hasNext()) {
                PdfReader pdfReader = iteratorPDFReader.next();
                //Create page and add content.
                while (currentPdfReaderPage <= pdfReader.getNumberOfPages()) {
                    document.newPage();
                    pdfImportedPage = writer.getImportedPage(pdfReader, currentPdfReaderPage);
                    pageContentByte.addTemplate(pdfImportedPage, 0, 0);
                    currentPdfReaderPage++;
                }
                currentPdfReaderPage = 1;
            }

            //Close document and outputStream.
            outputStream.flush();
            //           List<Integer> allPages = new ArrayList<>(totalPages);
            //           allPages.remove(1);
            document.close();
            outputStream.close();
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while merging pdf." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);  
        }
    }
    
    
    public void setPhotoLink(String photoLink) {
        this.photoLink = photoLink;
    }

    public String getPhotoLink() {
        return photoLink;
    }

    public void setFirstname(RichInputText firstname) {
        this.firstname = firstname;
    }

    public RichInputText getFirstname() {
        return firstname;
    }

    public void setPhotouploaded(RichInputText photouploaded) {
        this.photouploaded = photouploaded;
    }

    public RichInputText getPhotouploaded() {
        return photouploaded;
    }

    public void setIdentitydoc(RichInputText identitydoc) {
        this.identitydoc = identitydoc;
    }

    public RichInputText getIdentitydoc() {
        return identitydoc;
    }

    public void setMedicalphysicaledoc(RichInputText medicalphysicaledoc) {
        this.medicalphysicaledoc = medicalphysicaledoc;
    }

    public RichInputText getMedicalphysicaledoc() {
        return medicalphysicaledoc;
    }

    public void setServiceTrans(RichInputText serviceTrans) {
        this.serviceTrans = serviceTrans;
    }

    public RichInputText getServiceTrans() {
        return serviceTrans;
    }

    public void setApplicationedoc(RichInputText applicationedoc) {
        this.applicationedoc = applicationedoc;
    }

    public RichInputText getApplicationedoc() {
        return applicationedoc;
    }

    public void setAffidavit(RichInputText affidavit) {
        this.affidavit = affidavit;
    }

    public RichInputText getAffidavit() {
        return affidavit;
    }

    public void setSecuritysatedoc(RichInputText securitysatedoc) {
        this.securitysatedoc = securitysatedoc;
    }

    public RichInputText getSecuritysatedoc() {
        return securitysatedoc;
    }

    public void setSeafarerGrdStatus(RichInputText seafarerGrdStatus) {
        this.seafarerGrdStatus = seafarerGrdStatus;
    }

    public RichInputText getSeafarerGrdStatus() {
        return seafarerGrdStatus;
    }

    public String actionValidateSeafarer() 
    {
        try 
        {
            ADFContext.getCurrent().getPageFlowScope().put("P_CALLED_FROM_TF","VS");
            ADFContext.getCurrent().getPageFlowScope().put("P_UPDATE_SEAFARER", null);
            
            OperationBinding vldtSfrOp = IriAdfUtils.findOperation("validateSeafarerFromProc");
            vldtSfrOp.execute();

            String result = (String) vldtSfrOp.getResult();
            System.out.println("result :: "+result);

            if (result != null && result.trim().length() > 0) {
                if (result.trim().equalsIgnoreCase("Y")) {
                    OperationBinding fltrSfrOp = IriAdfUtils.findOperation("filterValidateSeafarerVO");
                    fltrSfrOp.execute();

                    return "validateSeafarer";
                } else {
                    OperationBinding fltrSfrOp = IriAdfUtils.findOperation("filterSearchSeafarerVO");
                    fltrSfrOp.execute();

                    return "searchSeafarer";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while validating seafarer." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);  
        }
    
        return null;
    }

    public void photoVCL(ValueChangeEvent vcl) 
    {
        try 
        {
            String newValue = vcl.getNewValue().toString();
            
            System.out.println("newValue : "+newValue);
            
            if (newValue.equalsIgnoreCase("Hold")) {
                photoValue.setValue(null);
                setPhotoValue(null);
                RichPopup.PopupHints hints = new RichPopup.PopupHints();
                getPhotobindpopup().show(hints);
            }
//            else if (newValue.equalsIgnoreCase("Approve")) {
//                photoValue.setValue(null);
//                setPhotoValue(null);
//                getPhotobindpopup().hide();
//                IriJsfUtils.showPopup(approveAllDocsCertsPopupBind, true);
//            }
            else {
                photoValue.setValue(null);
                setPhotoValue(null);
                getPhotobindpopup().hide();
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while viewing photo." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);  
        }
    }

    public void setPhotobindpopup(RichPopup photobindpopup) {
        this.photobindpopup = photobindpopup;
    }

    public RichPopup getPhotobindpopup() {
        return photobindpopup;
    }

    public void setPhotoValue(RichInputText photoValue) {
        this.photoValue = photoValue;
    }

    public RichInputText getPhotoValue() {
        return photoValue;
    }

    public void setSeaservicevalue(RichInputText seaservicevalue) {
        this.seaservicevalue = seaservicevalue;
    }

    public RichInputText getSeaservicevalue() {
        return seaservicevalue;
    }

    public void seaServiceVCL(ValueChangeEvent vcl)
    {
        try 
        {
            String newValue = vcl.getNewValue().toString();
            if (newValue.equalsIgnoreCase("Hold")) {
                seaservicevalue.setValue(null);
                setSeaservicevalue(null);
                RichPopup.PopupHints hints = new RichPopup.PopupHints();
                getSeaservicebindpopup().show(hints);
            } else {
                seaservicevalue.setValue(null);
                setSeaservicevalue(null);
                getSeaservicebindpopup().hide();
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading sea service document." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);  
        }
    }

    public void setSeaservicebindpopup(RichPopup seaservicebindpopup) {
        this.seaservicebindpopup = seaservicebindpopup;
    }

    public RichPopup getSeaservicebindpopup() {
        return seaservicebindpopup;
    }

    public void setIdentitydocbindpopup(RichPopup identitydocbindpopup) {
        this.identitydocbindpopup = identitydocbindpopup;
    }

    public RichPopup getIdentitydocbindpopup() {
        return identitydocbindpopup;
    }

    public void setIdentitydocvalue(RichInputText identitydocvalue) {
        this.identitydocvalue = identitydocvalue;
    }

    public RichInputText getIdentitydocvalue() {
        return identitydocvalue;
    }

    public void identityDocVCL(ValueChangeEvent vcl)
    {
        try 
        {
            String newValue = vcl.getNewValue().toString();
            if (newValue.equalsIgnoreCase("Hold")) {
                identitydocvalue.setValue(null);
                setIdentitydocvalue(null);
                RichPopup.PopupHints hints = new RichPopup.PopupHints();
                getIdentitydocbindpopup().show(hints);
            } else {
                identitydocvalue.setValue(null);
                setIdentitydocvalue(null);
                getIdentitydocbindpopup().hide();
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading Identity document." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);  
        }
    }

    public void setMedicalbindpopup(RichPopup medicalbindpopup) {
        this.medicalbindpopup = medicalbindpopup;
    }

    public RichPopup getMedicalbindpopup() {
        return medicalbindpopup;
    }

    public void setMedicalvalue(RichInputText medicalvalue) {
        this.medicalvalue = medicalvalue;
    }

    public RichInputText getMedicalvalue() {
        return medicalvalue;
    }

    public void medicalVCL(ValueChangeEvent vcl) 
    {
        try 
        {
            String newValue = vcl.getNewValue().toString();
            if (newValue.equalsIgnoreCase("Hold")) {
                medicalvalue.setValue(null);
                setMedicalvalue(null);
                RichPopup.PopupHints hints = new RichPopup.PopupHints();
                getMedicalbindpopup().show(hints);
            } else {
                medicalvalue.setValue(null);
                setMedicalvalue(null);
                getMedicalbindpopup().hide();
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading medical document." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);  
        }
    }

    public void attestationVCL(ValueChangeEvent vcl) 
    {
        try
        {
            String newValue = vcl.getNewValue().toString();
            if (newValue.equalsIgnoreCase("Hold")) {
                attestationvalue.setValue(null);
                setAttestationvalue(null);
                RichPopup.PopupHints hints = new RichPopup.PopupHints();
                getAttestationbindpopup().show(hints);
            } else {
                attestationvalue.setValue(null);
                setAttestationvalue(null);
                getAttestationbindpopup().hide();
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading attestation document." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);  
        }
    }

    public void setAttestationbindpopup(RichPopup attestationbindpopup) {
        this.attestationbindpopup = attestationbindpopup;
    }

    public RichPopup getAttestationbindpopup() {
        return attestationbindpopup;
    }

    public void setAttestationvalue(RichInputText attestationvalue) {
        this.attestationvalue = attestationvalue;
    }

    public RichInputText getAttestationvalue() {
        return attestationvalue;
    }

    public void setAffbindpopup(RichPopup affbindpopup) {
        this.affbindpopup = affbindpopup;
    }

    public RichPopup getAffbindpopup() {
        return affbindpopup;
    }

    public void setAffvalue(RichInputText affvalue) {
        this.affvalue = affvalue;
    }

    public RichInputText getAffvalue() {
        return affvalue;
    }

    public void affdVCL(ValueChangeEvent vcl) 
    {
        try 
        {
            String newValue = vcl.getNewValue().toString();
            if (newValue.equalsIgnoreCase("Hold")) {
                affvalue.setValue(null);
                setAffvalue(null);
                RichPopup.PopupHints hints = new RichPopup.PopupHints();
                getAffbindpopup().show(hints);
            } else {
                affvalue.setValue(null);
                setAffvalue(null);
                getAffbindpopup().hide();
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading affidavit document." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);  
        }
    }

    public void securityVCL(ValueChangeEvent vcl) 
    {
        try 
        {
            String newValue = vcl.getNewValue().toString();
            if (newValue.equalsIgnoreCase("Hold")) {
                securityvalue.setValue(null);
                setSecurityvalue(null);
                RichPopup.PopupHints hints = new RichPopup.PopupHints();
                getSecuritybindpopup().show(hints);
            } else {
                securityvalue.setValue(null);
                setSecurityvalue(null);
                getSecuritybindpopup().hide();
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading security document." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);  
        }
    }

    public void setSecuritybindpopup(RichPopup securitybindpopup) {
        this.securitybindpopup = securitybindpopup;
    }

    public RichPopup getSecuritybindpopup() {
        return securitybindpopup;
    }

    public void setSecurityvalue(RichInputText securityvalue) {
        this.securityvalue = securityvalue;
    }

    public RichInputText getSecurityvalue() {
        return securityvalue;
    }

    public void rejectSeafarer(ActionEvent actionEvent) 
    {
        try 
        {
            OperationBinding statusOp = IriAdfUtils.findOperation("validateHoldSeafarer");
            statusOp.execute();

            if (statusOp.getResult() != null && !(statusOp.getResult().toString().equalsIgnoreCase("y"))) {
                FacesContext fctx = FacesContext.getCurrentInstance();
                OperationBinding vldtSfrOp = IriAdfUtils.findOperation("approveSeafarer");
                vldtSfrOp.execute();
                OperationBinding vldtSfrOp2 = IriAdfUtils.findOperation("sendmail");
                vldtSfrOp2.execute();
                FacesMessage msg =
                    new FacesMessage(FacesMessage.SEVERITY_INFO, "Hold applied successfully !",
                                     "Hold applied successfully !");
                fctx.addMessage(null, msg);
            } else {
                IriJsfUtils.addFormattedFacesErrorMessage("Please mark atleast 1 document as Hold.", "",
                                                          FacesMessage.SEVERITY_ERROR);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception on Hold Application." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);  
        }
    }

    public void craApprove(ValueChangeEvent vcl)
    {
       
    }

    public String approveCRAs(ActionEvent actionEvent)
    {
        try 
        {
            OperationBinding defValuesOp = IriAdfUtils.findOperation("approveCRA");
            defValuesOp.getParamsMap().put("docid", "-1");
            defValuesOp.getParamsMap().put("esiID", "-1");
            defValuesOp.execute();

            FacesContext fctx = FacesContext.getCurrentInstance();
            fctx.addMessage("", new FacesMessage(FacesMessage.FACES_MESSAGES, "CRA Approved Successfully"));
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while approving CRA." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);  
        }
        return "returnbatchscr";
    }

    public void setConGrdStatusbindpopup(RichPopup conGrdStatusbindpopup) {
        this.conGrdStatusbindpopup = conGrdStatusbindpopup;
    }

    public RichPopup getConGrdStatusbindpopup() {
        return conGrdStatusbindpopup;
    }

    public void setConGrdvalue(RichInputText conGrdvalue) {
        this.conGrdvalue = conGrdvalue;
    }

    public RichInputText getConGrdvalue() {
        return conGrdvalue;
    }

    public void ConGrdVCL(ValueChangeEvent vcl) 
    {
        try 
        {
            String newValue = vcl.getNewValue().toString();
            if (newValue.equalsIgnoreCase("Hold")) {
                conGrdvalue.setValue(null);
                setConGrdvalue(null);
                RichPopup.PopupHints hints = new RichPopup.PopupHints();
                getConGrdStatusbindpopup().show(hints);
            } else {
                conGrdvalue.setValue(null);
                setConGrdvalue(null);
                getConGrdStatusbindpopup().hide();
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading document." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);  
        }
    }

    public void setSeafarergradingsts(RichInputText seafarergradingsts) {
        this.seafarergradingsts = seafarergradingsts;
    }

    public RichInputText getSeafarergradingsts() {
        return seafarergradingsts;
    }


    public void setTcstatus(RichInputText tcstatus) {
        this.tcstatus = tcstatus;
    }

    public RichInputText getTcstatus() {
        return tcstatus;
    }

    public void setTcdate(RichInputText tcdate) {
        this.tcdate = tcdate;
    }

    public RichInputText getTcdate() {
        return tcdate;
    }

    public void setInternaledoc(RichInputText internaledoc) {
        this.internaledoc = internaledoc;
    }

    public RichInputText getInternaledoc() {
        return internaledoc;
    }

    public String offlineDocument(ActionEvent actionEvent) {
       
        try 
        {
            String consentdocPath1 = null;
            String offlinedocpath1 = null;
            photobind.setVisible(false);
            documentbind.setVisible(false);
            offlinebind.setVisible(false);
            List<InputStream> inputPdfList1 = null;
            inputPdfList1 = new ArrayList<InputStream>();
            DCIteratorBinding WBIter = null;
            WBIter = IriAdfUtils.findIterator("GetDocumentLinkRO1Iterator");
            WBIter.getViewObject().setWhereClause(null);
            WBIter.getViewObject().setNamedWhereClauseParam("pEdocId", internaledoc.getValue());
            WBIter.executeQuery();
            if (internaledoc.getValue() != null && consentdoc.getValue() == null) {
                if (WBIter.getEstimatedRowCount() > 0) {
                    Row row = WBIter.getCurrentRow();
                    offlinedocpath1 = row.getAttribute("EdocId").toString();
                    setOfflineLink_test(row.getAttribute("EdocId").toString());
                    offlinebind.setVisible(true);
                }
                return null;
            }
            if (internaledoc.getValue() != null && consentdoc.getValue() != null) {
                if (WBIter.getEstimatedRowCount() > 0) {
                    Row row = WBIter.getCurrentRow();
                    offlinedocpath1 = row.getAttribute("EdocId").toString();
                }

                WBIter.getViewObject().setWhereClause(null);
                WBIter.getViewObject().setNamedWhereClauseParam("pEdocId", consentdoc.getValue());
                WBIter.executeQuery();
                if (WBIter.getEstimatedRowCount() > 0) {
                    Row row = WBIter.getCurrentRow();
                    consentdocPath1 = row.getAttribute("EdocId").toString();
                }

                try {
                    if (consentdoc.getValue() != null) {
//                        try {
//                            inputPdfList1.add(new URL(null,offlinedocpath1,new sun.net.www.protocol.https.Handler()).openStream());
//                        } catch (Exception e) {
//                            System.out.println("inside offlinedocpath1 exception :: "+e.getMessage());
//                        }
//                        try {
//                            inputPdfList1.add(new URL(null,consentdocPath1,new sun.net.www.protocol.https.Handler()).openStream());
//                        } catch (Exception e) {
//                            System.out.println("inside consentdocPath1 exception :: "+e.getMessage());
//                        }
                    }
                    
                    System.out.println("offlinedocpath1 :: "+offlinedocpath1);                    
//                    System.out.println("consentdocPath1 :: "+consentdocPath1);
                    
//                    String folderPath = "D://WIP";
//                    String folderPath = "/tmp/IRI_SEAFARER_REBUILD/";
//                    File folder = new File(folderPath);
//                    boolean folderExists = folder.exists();
//
//                    if (!folderExists)
//                    {
////                        createDocumentPreviewFolderWithPerms(folderPath);
//                        OperationBinding createDocPreviewFolder = IriAdfUtils.findOperation("createDocumentPreviewFolderWithPerms");
//                        createDocPreviewFolder.getParamsMap().put("folderPath", folderPath);
//                        createDocPreviewFolder.execute();
//                    }
//
//                    OutputStream outputStream1 =
//                        new FileOutputStream(folderPath+"/mergedfile_" + getUserId() + ".pdf");
//                    mergePdfFiles(inputPdfList1, outputStream1);
//                    setPhotoLink(folderPath+"/mergedfile_" + getUserId() + ".pdf");
                    documentbind.setVisible(true);
                    setPhotoLink(offlinedocpath1);
//                } catch (MalformedURLException e) {
//                    e.printStackTrace();
//                        IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while merging pdf." +
//                                                                  " Please contact your System Administrator." , 
//                                                                  "", FacesMessage.SEVERITY_ERROR);
//                                    
                    } catch (Exception e) {
                    e.printStackTrace();
                        IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while generating document." +
                                                         " Please contact your System Administrator." , 
                                                         "", FacesMessage.SEVERITY_ERROR); 
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while viewing document." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }

        return null;
    }

    public void setOfflinebind(RichPanelBox offlinebind) {
        this.offlinebind = offlinebind;
    }

    public RichPanelBox getOfflinebind() {
        return offlinebind;
    }

    public void setOfflineLink_test(String offlineLink_test) {
        this.offlineLink_test = offlineLink_test;
    }

    public String getOfflineLink_test() {
        return offlineLink_test;
    }
    public void setConsentdoc(RichInputText consentdoc) {
        this.consentdoc = consentdoc;
    }

    public RichInputText getConsentdoc() {
        return consentdoc;
    }

    public String offlinecocDoc(ActionEvent actionEvent) 
    {
        try 
        {
            String offlinedocpath1 = null;
            DCIteratorBinding WBIter = null;
            setInternaldocument(null);
            WBIter = IriAdfUtils.findIterator("GetDocumentLinkRO1Iterator");
            WBIter.getViewObject().setWhereClause(null);
            WBIter.getViewObject().setNamedWhereClauseParam("pEdocId", internaledoc.getValue());
            WBIter.executeQuery();
            if (WBIter.getEstimatedRowCount() > 0) {
                Row row = WBIter.getCurrentRow();
                offlinedocpath1 = row.getAttribute("EdocId").toString();
                setInternaldocument(offlinedocpath1);
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while viewing document." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        return internaldocument; 
    }

    public void refreshTcDetails(ActionEvent actionEvent) 
    {
        try 
        {
            String iteratorName = "viewSeafarerVO1Iterator";
            Key rowKey = null;
            rowKey = getCurrentRowKey(iteratorName);
            OperationBinding refreshOp = IriAdfUtils.findOperation("refreshViews");
            refreshOp.execute();
            setCurrentRowKey(iteratorName, rowKey);
//            basicInfoTabBind.setDisclosed(true); 
//            AdfFacesContext.getCurrentInstance().addPartialTarget(basicInfoTabBind);
//            if(basicInfoForm != null)
//                AdfFacesContext.getCurrentInstance().addPartialTarget(basicInfoForm);
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while refreshing data." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        } 
    }
    
    public void fetchTcDetails()
    {
        try 
        {
//            String tradestatus = null;
//            String tradedate = null;
//            OperationBinding ob = getBindings().getOperationBinding("callProcedure");
//            String tc = (String) ob.execute();
//            String[] arrSplit = tc.split(",");
//            if (arrSplit.length > 1) {
//                tradestatus = arrSplit[0];
//                tradedate = arrSplit[1];
//                tcstatus.setValue(tradestatus);
//                tcdate.setValue(tradedate);
//            } else {
//                tradestatus = arrSplit[0];
//                tcstatus.setValue("Not Available");
//                tcdate.setValue("Not Available");
//            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching TC status." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public void setInternaldocument(String internaldocument) {
        this.internaldocument = internaldocument;
    }

    public String getInternaldocument() {
        return internaldocument;
    }
    
    public void exceptionHandler()
    {
        //System.out.println("inside ViewBatchTF exceptionHandler");
        ControllerContext ctx = ControllerContext.getInstance();
        ViewPortContext viewprt = ctx.getCurrentViewPort();

        if (viewprt.isExceptionPresent())
        {
            Exception exc = viewprt.getExceptionData();
            IriJsfUtils.addFormattedFacesErrorMessage("There has been exception while performing this task. ", exc.getMessage(), FacesMessage.SEVERITY_ERROR);
        }
    }

    public void sentOcForVerificationAL(ActionEvent actionEvent) 
    {
        try 
        {
            OperationBinding sndOcVrfctnOp = IriAdfUtils.findOperation("sendOcForVerification");
            sndOcVrfctnOp.execute();

            if (sndOcVrfctnOp.getResult() != null && sndOcVrfctnOp.getResult().toString().equalsIgnoreCase("Y")) {
                IriJsfUtils.addFormattedFacesErrorMessage("Document successfully sent for Verification.", "",
                                                          FacesMessage.SEVERITY_INFO);
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while sending this document for verification." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }        
    }

    public void sendOcForVerificationDL(DialogEvent dialogEvent) 
    {
        try 
        {
            if (dialogEvent.getOutcome() != null &&
                (dialogEvent.getOutcome().toString().equalsIgnoreCase("yes") ||
                 (dialogEvent.getOutcome().toString().equalsIgnoreCase("ok")))) {
                OperationBinding sndOcVrfctnOp = IriAdfUtils.findOperation("sendOcForVerification");
                sndOcVrfctnOp.execute();

                if (sndOcVrfctnOp.getResult() != null && sndOcVrfctnOp.getResult().toString().equalsIgnoreCase("Y")) {
                    OperationBinding saveOp = IriAdfUtils.findOperation("Commit");
                    saveOp.execute();

                    IriJsfUtils.addFormattedFacesErrorMessage("Certificate successfully sent for Verification.", "",
                                                              FacesMessage.SEVERITY_INFO);
                }
                else if (sndOcVrfctnOp.getResult() != null && sndOcVrfctnOp.getResult().toString().equalsIgnoreCase("e")) {
                                    IriJsfUtils.showPopup(processOrderErrorsPopupBind, true);
                                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while viewing document." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public void addOcLine(ActionEvent actionEvent) {
        try 
        {
            OperationBinding addOcLineOp = IriAdfUtils.findOperation("addOcLine");
            addOcLineOp.execute();
            ADFContext.getCurrent().getPageFlowScope().put("VIEW_COC_UPLOAD","Y");
            System.out.println("VIEW_COC_UPLOAD :: "+ADFContext.getCurrent().getPageFlowScope().get("VIEW_COC_UPLOAD"));
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while adding new line." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public void saveTest(ActionEvent actionEvent) {
        try
        {
            OperationBinding saveOcLineOp = IriAdfUtils.findOperation("saveocline");
            saveOcLineOp.execute();
            ADFContext.getCurrent().getPageFlowScope().put("VIEW_COC_UPLOAD","N");
            System.out.println("VIEW_COC_UPLOAD :: "+ADFContext.getCurrent().getPageFlowScope().get("VIEW_COC_UPLOAD"));
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while saving lines." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public String actionApproveSeafarer() 
    {
        try 
        {
            OperationBinding statusOp = IriAdfUtils.findOperation("validateApproveSeafarer");
            statusOp.execute();

            if (statusOp.getResult() != null && statusOp.getResult().toString().equalsIgnoreCase("y")) {
                FacesContext fctx = FacesContext.getCurrentInstance();
                try {
                    OperationBinding vldtSfrOp = IriAdfUtils.findOperation("approveSeafarerByEval");
                    String str = vldtSfrOp.execute().toString();

                    if (str.equalsIgnoreCase("Y")) {
                        FacesMessage msg =
                            new FacesMessage(FacesMessage.SEVERITY_INFO, "Application has been approved.",
                                             "Application has been approved.");
                        fctx.addMessage(null, msg);
                        return null;
                    }

                    if (str.equalsIgnoreCase("C")) {
                        FacesMessage msg =
                            new FacesMessage(FacesMessage.SEVERITY_INFO, "Certificates are pending for Verification !",
                                             "Certificates are pending for Verification !");
                        fctx.addMessage(null, msg);
                        return null;
                    }
                } catch (Exception e) {
                    IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while approving seafarer." +
                                                              " Please contact your System Administrator.", "",
                                                              FacesMessage.SEVERITY_ERROR);
                }
            } else {
                IriJsfUtils.addFormattedFacesErrorMessage("Please Approve below document first :: </br>" +
                                                          statusOp.getResult().toString(), "",
                                                          FacesMessage.SEVERITY_ERROR);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while approving seafarer." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        
        return null;
    }

    public void holdSeafarerDL(DialogEvent dialogEvent) 
    {        
        try 
        {
            String iteratorName = "viewSeafarerVO1Iterator";
            Key rowKey = null;
            holdSeafarerBindPopup.hide();

            if (dialogEvent.getOutcome() != null &&
                (dialogEvent.getOutcome().toString().equalsIgnoreCase("yes") ||
                 (dialogEvent.getOutcome().toString().equalsIgnoreCase("ok")))) {
                OperationBinding statusOp = IriAdfUtils.findOperation("validateHoldSeafarer");
                statusOp.execute();
                
                System.out.println("validateHoldSeafarer :: "+statusOp.getResult());
                
                if (statusOp.getResult() != null && !(statusOp.getResult().toString().equalsIgnoreCase("y"))) {
                    FacesContext fctx = FacesContext.getCurrentInstance();
                    
                    rowKey = getCurrentRowKey(iteratorName);
                    OperationBinding vldtSfrOp = IriAdfUtils.findOperation("approveSeafarer");
                    vldtSfrOp.execute();
                    setCurrentRowKey(iteratorName, rowKey);
                    
                    AdfFacesContext.getCurrentInstance().addPartialTarget(seafarerGrdStatus);
                    AdfFacesContext.getCurrentInstance().addPartialTarget(panelTabBind);
                    FacesMessage msg =
                        new FacesMessage(FacesMessage.SEVERITY_INFO, "Hold applied successfully !",
                                         "Hold applied successfully !");
                    fctx.addMessage(null, msg);
                } else {
                    IriJsfUtils.addFormattedFacesErrorMessage("Please mark atleast 1 document as Hold.", "",
                                                              FacesMessage.SEVERITY_ERROR);
                }
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception on Hold Application." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public Row getCurrentRow(String iteratorName)
    {
        if(iteratorName != null)
        {
            BindingContainer bindings = getBindings();
            DCIteratorBinding parentIter = (DCIteratorBinding) bindings.get(iteratorName);
            Row row = parentIter.getCurrentRow();
            
            if(row != null)
                return row;
        }
        return null;
    }     

    public Key getCurrentRowKey(String iteratorName)
    {
        try 
        {
            if (iteratorName != null) {
                BindingContainer bindings = getBindings();
                DCIteratorBinding parentIter = (DCIteratorBinding) bindings.get(iteratorName);
                Key rowKey = parentIter.getCurrentRow().getKey();
                parentIter.setCurrentRowWithKey(rowKey.toStringFormat(true));

                if (rowKey != null)
                    return rowKey;
            }
        } catch (Exception e) {
            System.out.println("inside getCurrentRowKey message");
        }
        return null;
    }    

    public void setCurrentRowKey(String iteratorName, Key rowKey)
    {
        try 
        {
            if (iteratorName != null && rowKey != null) {
                BindingContainer bindings = getBindings();
                DCIteratorBinding parentIter = (DCIteratorBinding) bindings.get(iteratorName);
                parentIter.setCurrentRowWithKey(rowKey.toStringFormat(true));
            }
        } catch (Exception e) {
            System.out.println("inside setCurrentRowKey message");
        }
    }

    public void approveSeafarerDL(DialogEvent dialogEvent)
    {        
        try 
        {
            String iteratorName = "viewSeafarerVO1Iterator";
            Key rowKey = null;
            approveSeafarerBindPopup.hide();

            if (dialogEvent.getOutcome() != null &&
                (dialogEvent.getOutcome().toString().equalsIgnoreCase("yes") ||
                 (dialogEvent.getOutcome().toString().equalsIgnoreCase("ok")))) {
                OperationBinding statusOp = IriAdfUtils.findOperation("validateApproveSeafarer");
                statusOp.execute();

                if (statusOp.getResult() != null && statusOp.getResult().toString().equalsIgnoreCase("y")) {
                    FacesContext fctx = FacesContext.getCurrentInstance();
                    try {                 
                            rowKey = getCurrentRowKey(iteratorName);
                            OperationBinding vldtSfrOp = IriAdfUtils.findOperation("approveSeafarerByEval");
                            vldtSfrOp.execute();
                            String str = (vldtSfrOp.getResult() != null) ? vldtSfrOp.getResult().toString() : "";
                            System.out.println("str :: "+str);
                            setCurrentRowKey(iteratorName, rowKey);
                        AdfFacesContext.getCurrentInstance().addPartialTarget(seafarerGrdStatus);
                        if (str.equalsIgnoreCase("Y")) {
                            FacesMessage msg =
                                new FacesMessage(FacesMessage.SEVERITY_INFO, "Application has been approved.",
                                                 "Application has been approved.");
                            fctx.addMessage(null, msg);
                            //            return "backtaskflw";
                        }

                        if (str.equalsIgnoreCase("CRA")) {
                            FacesMessage msg =
                                new FacesMessage(FacesMessage.SEVERITY_WARN, "Please Approve CRA first then try again !",
                                                 "");
                            fctx.addMessage(null, msg);
                            //            return "backtaskflw";
                        }

                        if (str.equalsIgnoreCase("CONSENT")) {
                            FacesMessage msg =
                                new FacesMessage(FacesMessage.SEVERITY_ERROR, "Application cannot be approved, as the Consent expiry date is less than 90 days.",
                                                 "");
                            fctx.addMessage(null, msg);
                            //            return "backtaskflw";
                        }
                        
                        if (str.equalsIgnoreCase("C")) {
                            FacesMessage msg =
                                new FacesMessage(FacesMessage.SEVERITY_INFO,
                                                 "Certificates are pending for Verification !",
                                                 "Certificates are pending for Verification !");
                            fctx.addMessage(null, msg);
                        }
                        
                        if(str.equalsIgnoreCase("PO")) {

                            IriJsfUtils.showPopup(processOrderErrorsPopupBind, true);
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while approving seafarer." +
                                                                  " Please contact your System Administrator.", "",
                                                                  FacesMessage.SEVERITY_ERROR);
                    }
                } else {
                    IriJsfUtils.addFormattedFacesErrorMessage("Please Approve below document first :: </br>" +
                                                              statusOp.getResult().toString(), "",
                                                              FacesMessage.SEVERITY_ERROR);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while approving seafarer." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public void setApproveSeafarerBindPopup(RichPopup approveSeafarerBindPopup) {
        this.approveSeafarerBindPopup = approveSeafarerBindPopup;
    }

    public RichPopup getApproveSeafarerBindPopup() {
        return approveSeafarerBindPopup;
    }

    public void setHoldSeafarerBindPopup(RichPopup holdSeafarerBindPopup) {
        this.holdSeafarerBindPopup = holdSeafarerBindPopup;
    }

    public RichPopup getHoldSeafarerBindPopup() {
        return holdSeafarerBindPopup;
    }

    public String actionSave() 
    {
        try 
        {
//            OperationBinding updateSeafarerInfoOp = IriAdfUtils.findOperation("updateSeafarerBasicInfo");
//            updateSeafarerInfoOp.execute();

            System.out.println("path :: "+ADFContext.getCurrent().getSessionScope().get("path"));

            Object roleName = AdfFacesContext.getCurrentInstance().getPageFlowScope().get("Role_Name");
            
            if (roleName != null && roleName.toString().equalsIgnoreCase("EVALUATOR")) 
            {
                OperationBinding updateAppStatusOp = IriAdfUtils.findOperation("updateApplicationStatus");
                updateAppStatusOp.execute();
            }
            if (roleName != null && roleName.toString().equalsIgnoreCase("QA PROCESSOR"))
            {
                OperationBinding updateAppStatusOp = IriAdfUtils.findOperation("updateVerificationStatus");
                updateAppStatusOp.execute();
            }
            
            OperationBinding saveOp = IriAdfUtils.findOperation("Commit");
            saveOp.execute();

            if (saveOp.getErrors().isEmpty()) {
                IriJsfUtils.addFormattedFacesErrorMessage("Record Saved Successfully !", "",
                                                          FacesMessage.SEVERITY_INFO);
            } else {
                System.out.println("inside else :: "+saveOp.getErrors());
                IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception on save." +
                                                 " Please contact your System Administrator." , 
                                                 "", FacesMessage.SEVERITY_ERROR); 
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception on save." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        return null;
    }

    public String approveOrderAction() 
    {        
        try 
        {
            OperationBinding validateApprvOdrOp = IriAdfUtils.findOperation("validateApproveOrder");
            validateApprvOdrOp.execute();

            if (validateApprvOdrOp.getErrors().isEmpty()) {
                if (validateApprvOdrOp.getResult() != null &&
                    validateApprvOdrOp.getResult().toString().equalsIgnoreCase("y")) {
                    OperationBinding approveOdrOp = IriAdfUtils.findOperation("approveOrder");
                    approveOdrOp.execute();

                    if (approveOdrOp.getErrors().isEmpty()) {
                        if (approveOdrOp.getResult() != null &&
                            approveOdrOp.getResult().toString().equalsIgnoreCase("y")) {
                            OperationBinding saveOp = IriAdfUtils.findOperation("Commit");
                            saveOp.execute();

                            //                        IriJsfUtils.addFormattedFacesErrorMessage("Record Saved Successfully !", "", FacesMessage.SEVERITY_INFO);
                        }
                    } else {
                        IriJsfUtils.addFormattedFacesErrorMessage("There has been an error calling Approve Order method : " +
                                                                  approveOdrOp.getErrors(), "",
                                                                  FacesMessage.SEVERITY_ERROR);
                    }
                } else {
                    IriJsfUtils.addFormattedFacesErrorMessage("Please Verify below document first :: </br>" +
                                                              validateApprvOdrOp.getResult().toString(), "",
                                                              FacesMessage.SEVERITY_INFO);
                }
            } else {
                IriJsfUtils.addFormattedFacesErrorMessage("There has been an error calling Validate Approve Order method : " +
                                                          validateApprvOdrOp.getErrors(), "",
                                                          FacesMessage.SEVERITY_ERROR);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while approving order." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        return null;
    }

    public String actionProcessOrder()
    {
        try 
        {
            String iteratorName = "viewSeafarerVO1Iterator";
//            Key rowKey = null;
//            rowKey = getCurrentRowKey(iteratorName);
            Row seafarerRow = getCurrentRow(iteratorName);
            
            if(seafarerRow != null && seafarerRow.getAttribute("SeafarerId") != null)
                ADFContext.getCurrent().getPageFlowScope().put("P_PROCESS_ORDER_SEAFARER_ID",seafarerRow.getAttribute("SeafarerId"));
            
            System.out.println("P_PROCESS_ORDER_SEAFARER_ID in bean :: "+ADFContext.getCurrent().getPageFlowScope().get("P_PROCESS_ORDER_SEAFARER_ID"));
            
            OperationBinding procOdrOp = IriAdfUtils.findOperation("processOrder");
            procOdrOp.execute();

            if (procOdrOp.getErrors().isEmpty())
            {
                if (procOdrOp.getResult() != null && procOdrOp.getResult().toString().equalsIgnoreCase("y")) {
//                    OperationBinding saveOp = IriAdfUtils.findOperation("Commit");
//                    saveOp.execute();

//                    setCurrentRowKey(iteratorName, rowKey);
//                    
//                    AdfFacesContext.getCurrentInstance().addPartialTarget(seafarerGrdStatus);
//                    AdfFacesContext.getCurrentInstance().addPartialTarget(panelTabBind);
                    
                    IriJsfUtils.addFormattedFacesErrorMessage("Order Processed Successfully !", "",
                                                              FacesMessage.SEVERITY_INFO);
                } else if (procOdrOp.getResult() != null && procOdrOp.getResult().toString().equalsIgnoreCase("e")) {
                    IriJsfUtils.showPopup(processOrderErrorsPopupBind, true);
                } else {
                    System.out.println("procOdrOp.getResult() :: "+procOdrOp.getResult());
                    IriJsfUtils.addFormattedFacesErrorMessage("There has been an error Processing Order : " +
                                                              procOdrOp.getErrors(), "", FacesMessage.SEVERITY_ERROR);
                }
            } else {
                IriJsfUtils.addFormattedFacesErrorMessage("There has been an error calling Process Order method : " +
                                                          procOdrOp.getErrors(), "", FacesMessage.SEVERITY_ERROR);
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while processing order." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        
        ADFContext.getCurrent().getPageFlowScope().put("P_PROCESS_ORDER_SEAFARER_ID",null);
        
        System.out.println("P_PROCESS_ORDER_SEAFARER_ID before return in bean :: "+ADFContext.getCurrent().getPageFlowScope().get("P_PROCESS_ORDER_SEAFARER_ID"));
        
        return null;
    }

    public void setProcessOrderErrorsPopupBind(RichPopup processOrderErrorsPopupBind) {
        this.processOrderErrorsPopupBind = processOrderErrorsPopupBind;
    }

    public RichPopup getProcessOrderErrorsPopupBind() {
        return processOrderErrorsPopupBind;
    }

    public void sqcGradeStatusVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null &&
                (valueChangeEvent.getNewValue().toString().equalsIgnoreCase("Hold")
                  || valueChangeEvent.getNewValue().toString().equalsIgnoreCase("Cancel"))) {
                IriJsfUtils.showPopup(sqcGradeCommentbindpopup, true);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating Grading status." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public void ocGradeStatusVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null &&
                (valueChangeEvent.getNewValue().toString().equalsIgnoreCase("Hold")
                  || valueChangeEvent.getNewValue().toString().equalsIgnoreCase("Cancel"))) {
                IriJsfUtils.showPopup(ocGradeCommentbindpopup, true);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating Grading status." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public void setSqcGradeCommentbindpopup(RichPopup sqcGradeCommentbindpopup) {
        this.sqcGradeCommentbindpopup = sqcGradeCommentbindpopup;
    }

    public RichPopup getSqcGradeCommentbindpopup() {
        return sqcGradeCommentbindpopup;
    }

    public void setOcGradeCommentbindpopup(RichPopup ocGradeCommentbindpopup) {
        this.ocGradeCommentbindpopup = ocGradeCommentbindpopup;
    }

    public RichPopup getOcGradeCommentbindpopup() {
        return ocGradeCommentbindpopup;
    }

    public void docsHistoryPopupFetchListener(PopupFetchEvent popupFetchEvent) {
        // Add event code here...
    }

    public String actionPhotoHistory() 
    {
        try 
        {
            OperationBinding docHistOp = IriAdfUtils.findOperation("filterDocumentsHistory");
            docHistOp.getParamsMap().put("docCode", "0002");
            docHistOp.execute();
            IriJsfUtils.showPopup(historyPopupBinding, true);
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching Document upload history." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        return null;
    }

    public String actionDocumentsHistory()
    {
        try 
        {
            OperationBinding docHistOp = IriAdfUtils.findOperation("filterDocumentsHistory");
            docHistOp.getParamsMap().put("docCode", null);
            docHistOp.execute();
            IriJsfUtils.showPopup(historyPopupBinding, true);
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching Document upload history." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        return null;
    }

    public void setHistoryPopupBinding(RichPopup historyPopupBinding) {
        this.historyPopupBinding = historyPopupBinding;
    }

    public RichPopup getHistoryPopupBinding() {
        return historyPopupBinding;
    }

    public void seafarerBookDialogListener(DialogEvent dialogEvent)
    {
        try 
        {
            if (dialogEvent.getOutcome() != null &&
                (dialogEvent.getOutcome().toString().equalsIgnoreCase("yes") ||
                 (dialogEvent.getOutcome().toString().equalsIgnoreCase("ok")))) 
            {
                OperationBinding saveOp = IriAdfUtils.findOperation("Commit");
                saveOp.execute();

                IriJsfUtils.addFormattedFacesErrorMessage("Changes Saved Successfully.", "",
                                                              FacesMessage.SEVERITY_INFO);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while saving changes." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }


    public String nextSeafarerAction()
    {
        try 
        {
            OperationBinding nextOp = IriAdfUtils.findOperation("Next");
            nextOp.execute();
            fetchTcDetails();
//            checkSeafarerStatus(); 
//            AdfFacesContext.getCurrentInstance().addPartialTarget(panelTabBind);
            basicInfoTabBind.setDisclosed(true); 
            AdfFacesContext.getCurrentInstance().addPartialTarget(basicInfoTabBind);
            if(basicInfoForm != null)
                AdfFacesContext.getCurrentInstance().addPartialTarget(basicInfoForm);
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching next Seafarer." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        
        return null;
    }

    public void nextSeafarerActionListener(ActionEvent actionEvent)
    {
        try 
        {
            OperationBinding nextOp = IriAdfUtils.findOperation("Next");
            nextOp.execute();
            fetchTcDetails();
            checkSeafarerStatus();
    //            AdfFacesContext.getCurrentInstance().addPartialTarget(panelTabBind);
            basicInfoTabBind.setDisclosed(true); 
            AdfFacesContext.getCurrentInstance().addPartialTarget(basicInfoTabBind);
            if(basicInfoForm != null)
                AdfFacesContext.getCurrentInstance().addPartialTarget(basicInfoForm);
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching next Seafarer." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }
    
    public void previousSeafarerActionListener(ActionEvent actionEvent)
    {
        try 
        {
            OperationBinding prvsOp = IriAdfUtils.findOperation("Previous");
            prvsOp.execute();
            fetchTcDetails();
            checkSeafarerStatus();
//            AdfFacesContext.getCurrentInstance().addPartialTarget(panelTabBind);
            basicInfoTabBind.setDisclosed(true);
            AdfFacesContext.getCurrentInstance().addPartialTarget(basicInfoTabBind);
            if(basicInfoForm != null)
                AdfFacesContext.getCurrentInstance().addPartialTarget(basicInfoForm);
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching previous Seafarer." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public void viewDataPrivacyConsentAL(ActionEvent actionEvent)
    {
        try 
        {
            photobind.setVisible(false);
            documentbind.setVisible(false);
            offlinebind.setVisible(false);
            
            OperationBinding dataPrvcyCnstOp = IriAdfUtils.findOperation("genDataPrivacyConsent");
            dataPrvcyCnstOp.execute();
//            System.out.println("dataPrvcyCnstOp.getResult() :: "+dataPrvcyCnstOp.getResult());
            if (dataPrvcyCnstOp.getResult() != null && dataPrvcyCnstOp.getResult().toString().length() > 0) 
            {
                documentbind.setVisible(true);
                setPhotoLink(dataPrvcyCnstOp.getResult().toString());
//                IriJsfUtils.addFormattedFacesErrorMessage("Data Privacy Consent Document URL :: " +
//                                                            dataPrvcyCnstOp.getResult().toString() , 
//                                                          "", FacesMessage.SEVERITY_INFO);
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while generating supporting documents." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void setSeafarerListPopupBind(RichPopup seafarerListPopupBind) {
        this.seafarerListPopupBind = seafarerListPopupBind;
    }

    public RichPopup getSeafarerListPopupBind() {
        return seafarerListPopupBind;
    }
    
    public void listTableDblClickListner(ClientEvent clientEvent) {
        try 
        {
//            ResetUtils.reset(basicInfoForm);
            seafarerListPopupBind.hide();
            fetchTcDetails();
            checkSeafarerStatus();
            basicInfoTabBind.setDisclosed(true);
            AdfFacesContext.getCurrentInstance().addPartialTarget(panelTabBind);
            AdfFacesContext.getCurrentInstance().addPartialTarget(basicInfoTabBind);
            if (basicInfoForm != null)
                AdfFacesContext.getCurrentInstance().addPartialTarget(basicInfoForm);
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while selecting application." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }    
    }

    public void setPanelTabBind(RichPanelTabbed panelTabBind) {
        this.panelTabBind = panelTabBind;
    }

    public RichPanelTabbed getPanelTabBind() {
        return panelTabBind;
    }

    public void setBasicInfoTabBind(RichShowDetailItem basicInfoTabBind) {
        this.basicInfoTabBind = basicInfoTabBind;
    }

    public RichShowDetailItem getBasicInfoTabBind() {
        return basicInfoTabBind;
    }
    
    public void checkSeafarerStatus()
    {
        try 
        {            
            OperationBinding sfrrStatusOp = IriAdfUtils.findOperation("isSeafarerDisabled");
            sfrrStatusOp.execute();

            if (sfrrStatusOp.getErrors().isEmpty() && basicInfoTabBind != null) {
                if (sfrrStatusOp.getResult() != null && sfrrStatusOp.getResult().toString().equalsIgnoreCase("y")) {
                    basicInfoTabBind.setDisclosed(true);
                }
            } else {
                IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching Seafarer status." +
                                                          " Please contact your System Administrator.", "",
                                                          FacesMessage.SEVERITY_ERROR);
            }
            
            AdfFacesContext.getCurrentInstance().addPartialTarget(panelTabBind);
            AdfFacesContext.getCurrentInstance().addPartialTarget(basicInfoTabBind);
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching Seafarer status." +
                                                      " Please contact your System Administrator.",
                                                      "", FacesMessage.SEVERITY_ERROR);
        }       
    }

    public void viewAdditionalDocsAL(ActionEvent actionEvent)
    {
        try 
        {
            photobind.setVisible(false);
            documentbind.setVisible(false);
            offlinebind.setVisible(false);
            
            OperationBinding additionalDocsOp = IriAdfUtils.findOperation("genAdditionalDocs");
            additionalDocsOp.execute();
            
            if (additionalDocsOp.getResult() != null && additionalDocsOp.getResult().toString().length() > 0) 
            {
                documentbind.setVisible(true);
                setPhotoLink(additionalDocsOp.getResult().toString());
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while generating additional documents." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void deficientDocumentNotificationAL(ActionEvent actionEvent)
    {
    }

    public void deficientAckTcDL(DialogEvent dialogEvent)
    {
        try 
        {
            String iteratorName = "viewSeafarerVO1Iterator";
            Key rowKey = null;  
            deficientAckTcPopup.hide();

            if (dialogEvent.getOutcome() != null &&
                (dialogEvent.getOutcome().toString().equalsIgnoreCase("yes") ||
                 (dialogEvent.getOutcome().toString().equalsIgnoreCase("ok"))))
            {
                OperationBinding validateOp = IriAdfUtils.findOperation("validateSeafarersDeficientDocument");
                validateOp.execute();
                
                OperationBinding validateLegalOp = IriAdfUtils.findOperation("validateSeafarerLegalReview");
                validateLegalOp.execute();
                
                System.out.println("validateOp.getResult() :: "+validateOp.getResult());
                
                if ((validateOp.getResult() != null && validateOp.getResult().toString().equalsIgnoreCase("y")))
                //                && (validateLegalOp.getResult() != null && validateLegalOp.getResult().toString().equalsIgnoreCase("y")))
                {
                    OperationBinding validateLegalNotesOp = IriAdfUtils.findOperation("validateLegalNotes");
                    validateLegalNotesOp.execute();
                    
                    System.out.println("validateLegalNotesOp.getResult() :: "+validateLegalNotesOp.getResult());
                    
                    if(validateLegalNotesOp.getResult() != null && validateLegalNotesOp.getResult().toString().equalsIgnoreCase("y"))
                    {
                        rowKey = getCurrentRowKey(iteratorName);
                        OperationBinding defDocNotifOp = IriAdfUtils.findOperation("sendDeficientDocumentNotification");
                        defDocNotifOp.execute();
                        setCurrentRowKey(iteratorName, rowKey);
                        
                        System.out.println("defDocNotifOp.getResult() :: "+defDocNotifOp.getResult());

                        if (defDocNotifOp.getResult() != null && defDocNotifOp.getResult().toString().equalsIgnoreCase("y")) {
                            OperationBinding saveOp = IriAdfUtils.findOperation("Commit");
                            saveOp.execute();
                            checkSeafarerStatus();
                            IriJsfUtils.addFormattedFacesErrorMessage("Deficiency Letter notification has been successfully sent.",
                                                                      "", FacesMessage.SEVERITY_INFO);
                        } else {
                            System.out.println("defDocNotifOp.getResult() :: "+defDocNotifOp.getResult());
                            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while sendingemail notification." +
                                                                      " Please contact your System Administrator.", "",
                                                                      FacesMessage.SEVERITY_ERROR);
                        }    
                    } else {
                            IriJsfUtils.addFormattedFacesErrorMessage("Please add Notes before sending Deficient notification.", 
                                                                      "",
                                                                      FacesMessage.SEVERITY_ERROR);
                        }                 
                } else {
                    IriJsfUtils.addFormattedFacesErrorMessage("Cannot send Deficiency Letter, as selected Application and Trade Compliance are either Approved or Pending for Legal Review.",
                                                              "",
                                                              FacesMessage.SEVERITY_ERROR);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while sending email notification." +
                                                      " Please contact your System Administrator.",
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }
    
    public void saveTcNotesDL(DialogEvent dialogEvent) 
    {
        try 
        {
            if (dialogEvent.getOutcome() != null &&
                (dialogEvent.getOutcome().toString().equalsIgnoreCase("yes") ||
                 (dialogEvent.getOutcome().toString().equalsIgnoreCase("ok"))))
            {                
                OperationBinding saveOp = IriAdfUtils.findOperation("Commit");
                saveOp.execute();

                IriJsfUtils.addFormattedFacesErrorMessage("Notes Saved Successfully.", "",
                                                          FacesMessage.SEVERITY_INFO);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while adding notes." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public void setVerificationCommentsPopup(RichPopup verificationCommentsPopup) {
        this.verificationCommentsPopup = verificationCommentsPopup;
    }

    public RichPopup getVerificationCommentsPopup() {
        return verificationCommentsPopup;
    }
    
    public String actionPhotoVerificationComments()
    {
        try 
        {
            ADFContext.getCurrent().getPageFlowScope().put("P_VERIFIED_COMMENT", "Photo");
            IriJsfUtils.showPopup(verificationCommentsPopup, true);
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching comments." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        return null;
    }

    public String actionIdentityVerificationComment()
    {
        try 
        {
            ADFContext.getCurrent().getPageFlowScope().put("P_VERIFIED_COMMENT", "Identity");
            IriJsfUtils.showPopup(verificationCommentsPopup, true);
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching comments." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        return null;
    }

    public String actionPhysicalVerificationComment() 
    {
        try 
        {
            ADFContext.getCurrent().getPageFlowScope().put("P_VERIFIED_COMMENT", "Physical");
            IriJsfUtils.showPopup(verificationCommentsPopup, true);
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching comments." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        return null;
    }

    public String actionSeaserviceVerificationComment()
    {
        try 
        {
            ADFContext.getCurrent().getPageFlowScope().put("P_VERIFIED_COMMENT", "Seaservice");
            IriJsfUtils.showPopup(verificationCommentsPopup, true);
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching comments." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        return null;
    }

    public String actionApplicationVerificationComment()
    {
        try 
        {
            ADFContext.getCurrent().getPageFlowScope().put("P_VERIFIED_COMMENT", "Application");
            IriJsfUtils.showPopup(verificationCommentsPopup, true);
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching comments." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        return null;
    }

    public String actionAffidavitVerificationComment()
    {
        try 
        {
            ADFContext.getCurrent().getPageFlowScope().put("P_VERIFIED_COMMENT", "Affidavit");
            IriJsfUtils.showPopup(verificationCommentsPopup, true);
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching comments." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        return null;
    }

    public String actionSatVerificationComment()
    {
        try 
        {
            ADFContext.getCurrent().getPageFlowScope().put("P_VERIFIED_COMMENT", "Security");
            IriJsfUtils.showPopup(verificationCommentsPopup, true);
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching comments." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        return null;
    }

    public String actionConsentVerificationComment()
    {
        try 
        {
            ADFContext.getCurrent().getPageFlowScope().put("P_VERIFIED_COMMENT", "Consent");
            IriJsfUtils.showPopup(verificationCommentsPopup, true);
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching comments." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        return null;
    }

    public void photoVerificationCommentVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null 
                && (valueChangeEvent.getNewValue().toString().equalsIgnoreCase("No")
                    || valueChangeEvent.getNewValue().toString().equalsIgnoreCase("1")
                    || valueChangeEvent.getNewValue().toString().equalsIgnoreCase("3"))) 
            {   
                ADFContext.getCurrent().getPageFlowScope().put("P_VERIFIED_COMMENT", "Photo");
                IriJsfUtils.showPopup(verificationCommentsPopup, true);
            }
//            else if (valueChangeEvent.getNewValue() != null 
//                     && valueChangeEvent.getNewValue().toString().equalsIgnoreCase("Yes")) {
//                IriJsfUtils.showPopup(verifyAllDocsPopupBind, true);
//            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching comments." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }        
    }

    public void identityVerificationCommentVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null 
                && (valueChangeEvent.getNewValue().toString().equalsIgnoreCase("No")
                    || valueChangeEvent.getNewValue().toString().equalsIgnoreCase("1")
                    || valueChangeEvent.getNewValue().toString().equalsIgnoreCase("3"))) 
            {
                ADFContext.getCurrent().getPageFlowScope().put("P_VERIFIED_COMMENT", "Identity");
                IriJsfUtils.showPopup(verificationCommentsPopup, true);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching comments." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }   
    }

    public void medicalVerificationCommentVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null 
                && (valueChangeEvent.getNewValue().toString().equalsIgnoreCase("No")
                    || valueChangeEvent.getNewValue().toString().equalsIgnoreCase("1")
                    || valueChangeEvent.getNewValue().toString().equalsIgnoreCase("3"))) 
            {
                ADFContext.getCurrent().getPageFlowScope().put("P_VERIFIED_COMMENT", "Physical");
                IriJsfUtils.showPopup(verificationCommentsPopup, true);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching comments." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }   
    }

    public void seaserviceVerificationCommentVCL(ValueChangeEvent valueChangeEvent) 
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null 
                && (valueChangeEvent.getNewValue().toString().equalsIgnoreCase("No")
                    || valueChangeEvent.getNewValue().toString().equalsIgnoreCase("1")
                    || valueChangeEvent.getNewValue().toString().equalsIgnoreCase("3"))) 
            {
                ADFContext.getCurrent().getPageFlowScope().put("P_VERIFIED_COMMENT", "Seaservice");
                IriJsfUtils.showPopup(verificationCommentsPopup, true);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching comments." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }   
    }

    public void applicationVerificationCommentVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null 
                && (valueChangeEvent.getNewValue().toString().equalsIgnoreCase("No")
                    || valueChangeEvent.getNewValue().toString().equalsIgnoreCase("1")
                    || valueChangeEvent.getNewValue().toString().equalsIgnoreCase("3"))) 
            {
                ADFContext.getCurrent().getPageFlowScope().put("P_VERIFIED_COMMENT", "Application");
                IriJsfUtils.showPopup(verificationCommentsPopup, true);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching comments." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }   
    }

    public void affidavitVerificationCommentVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null 
                && (valueChangeEvent.getNewValue().toString().equalsIgnoreCase("No")
                    || valueChangeEvent.getNewValue().toString().equalsIgnoreCase("1")
                    || valueChangeEvent.getNewValue().toString().equalsIgnoreCase("3"))) 
            {
                ADFContext.getCurrent().getPageFlowScope().put("P_VERIFIED_COMMENT", "Affidavit");
                IriJsfUtils.showPopup(verificationCommentsPopup, true);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching comments." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }   
    }

    public void satVerificationCommentVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null 
                && (valueChangeEvent.getNewValue().toString().equalsIgnoreCase("No")
                    || valueChangeEvent.getNewValue().toString().equalsIgnoreCase("1")
                    || valueChangeEvent.getNewValue().toString().equalsIgnoreCase("3"))) 
            {
                ADFContext.getCurrent().getPageFlowScope().put("P_VERIFIED_COMMENT", "Security");
                IriJsfUtils.showPopup(verificationCommentsPopup, true);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching comments." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }   
    }

    public void consentVerificationCommentVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null 
                && (valueChangeEvent.getNewValue().toString().equalsIgnoreCase("No")
                    || valueChangeEvent.getNewValue().toString().equalsIgnoreCase("1")
                    || valueChangeEvent.getNewValue().toString().equalsIgnoreCase("3"))) 
            {
                ADFContext.getCurrent().getPageFlowScope().put("P_VERIFIED_COMMENT", "Consent");
                IriJsfUtils.showPopup(verificationCommentsPopup, true);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching comments." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }   
    }

    public void setVerificationCommentsOcPopup(RichPopup verificationCommentsOcPopup) {
        this.verificationCommentsOcPopup = verificationCommentsOcPopup;
    }

    public RichPopup getVerificationCommentsOcPopup() {
        return verificationCommentsOcPopup;
    }

    public void setVerificationCommentsSqcPopup(RichPopup verificationCommentsSqcPopup) {
        this.verificationCommentsSqcPopup = verificationCommentsSqcPopup;
    }

    public RichPopup getVerificationCommentsSqcPopup() {
        return verificationCommentsSqcPopup;
    }

    public void setVerificationCommentsInfoPopup(RichPopup verificationCommentsInfoPopup) {
        this.verificationCommentsInfoPopup = verificationCommentsInfoPopup;
    }

    public RichPopup getVerificationCommentsInfoPopup() {
        return verificationCommentsInfoPopup;
    }

    public void infoVerificationCommentVCL(ValueChangeEvent valueChangeEvent) 
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null 
                && (valueChangeEvent.getNewValue().toString().equalsIgnoreCase("No")
                    || valueChangeEvent.getNewValue().toString().equalsIgnoreCase("1")
                    || valueChangeEvent.getNewValue().toString().equalsIgnoreCase("3"))) 
            {
                IriJsfUtils.showPopup(verificationCommentsInfoPopup, true);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching comments." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }   
    }

    public void ocVerificationCommentVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {            
            if (valueChangeEvent.getNewValue() != null && 
                (valueChangeEvent.getNewValue().toString().equalsIgnoreCase("No") 
                    || valueChangeEvent.getNewValue().toString().equalsIgnoreCase("1")
                    || valueChangeEvent.getNewValue().toString().equalsIgnoreCase("3"))) 
            {
                IriJsfUtils.showPopup(verificationCommentsOcPopup, true);
                AdfFacesContext.getCurrentInstance().addPartialTarget(verificationCommentsOcPopup);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching comments." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }   
    }

    public void sqcVerificationCommentVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null && 
                (valueChangeEvent.getNewValue().toString().equalsIgnoreCase("No") 
                    || valueChangeEvent.getNewValue().toString().equalsIgnoreCase("1")
                    || valueChangeEvent.getNewValue().toString().equalsIgnoreCase("3"))) 
            {
                IriJsfUtils.showPopup(verificationCommentsSqcPopup, true);
                AdfFacesContext.getCurrentInstance().addPartialTarget(verificationCommentsSqcPopup);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching comments." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }   
    }

    public void deficientNotificationQaAL(ActionEvent actionEvent)
    {}

    public String actionVerifySeafarerData()
    {
        return null;
    }

    public void verifySeafarerDataDL(DialogEvent dialogEvent)
    {     
            try 
            {
                String iteratorName = "viewSeafarerVO1Iterator";
                Key rowKey = null;
                verifySeafarerDataPopup.hide();

                if (dialogEvent.getOutcome() != null &&
                    (dialogEvent.getOutcome().toString().equalsIgnoreCase("yes") ||
                     (dialogEvent.getOutcome().toString().equalsIgnoreCase("ok")))) {
                    OperationBinding statusOp = IriAdfUtils.findOperation("validateVerifySeafarerData");
                    statusOp.execute();

                    if (statusOp.getResult() != null && statusOp.getResult().toString().equalsIgnoreCase("y")) {
                        FacesContext fctx = FacesContext.getCurrentInstance();
                        try {                 
                                rowKey = getCurrentRowKey(iteratorName);
                                OperationBinding vrfySfrOp = IriAdfUtils.findOperation("verifySeafarerData");
                                String str = vrfySfrOp.execute().toString();  
                                setCurrentRowKey(iteratorName, rowKey);
                            
                            if (str != null && str.equalsIgnoreCase("Y")) 
                            {
                                AdfFacesContext.getCurrentInstance().addPartialTarget(seafarerGrdStatus);
                                FacesMessage msg =
                                    new FacesMessage(FacesMessage.SEVERITY_INFO, "Seafarer Data has been Verified.",
                                                     "Seafarer Data has been Verified.");
                                fctx.addMessage(null, msg);
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while verifying seafarer." +
                                                                      " Please contact your System Administrator.", "",
                                                                      FacesMessage.SEVERITY_ERROR);
                        }
                    } else {
                        IriJsfUtils.addFormattedFacesErrorMessage("Please Verify below document first :: </br>" +
                                                                  statusOp.getResult().toString(), "",
                                                                  FacesMessage.SEVERITY_ERROR);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while verifying seafarer." +
                                                 " Please contact your System Administrator." , 
                                                 "", FacesMessage.SEVERITY_ERROR); 
            }
    }

    public void deficientAckQaDL(DialogEvent dialogEvent)
    {
        try 
        {
            String iteratorName = "viewSeafarerVO1Iterator";
            Key rowKey = null;
            deficientAckQaPopup.hide();

            if (dialogEvent.getOutcome() != null &&
                (dialogEvent.getOutcome().toString().equalsIgnoreCase("yes") ||
                 (dialogEvent.getOutcome().toString().equalsIgnoreCase("ok"))))
            {
                OperationBinding statusOp = IriAdfUtils.findOperation("validateUnverifySeafarerData");
                statusOp.execute();
                
                System.out.println("statusOp validateUnverifySeafarerData :: "+statusOp.getResult());
    
                if (statusOp.getResult() != null && !(statusOp.getResult().toString().equalsIgnoreCase("y"))) 
                {
                    rowKey = getCurrentRowKey(iteratorName);
                    OperationBinding defDocNotifOp = IriAdfUtils.findOperation("sendDeficientDocumentNotificationQa");
                    defDocNotifOp.execute();
                    setCurrentRowKey(iteratorName, rowKey);
                    
                    if (defDocNotifOp.getResult() != null && defDocNotifOp.getResult().toString().equalsIgnoreCase("y")) {
                        OperationBinding saveOp = IriAdfUtils.findOperation("Commit");
                        saveOp.execute();
                        checkSeafarerStatus();
                        IriJsfUtils.addFormattedFacesErrorMessage("Deficiency Letter has been successfully sent.",
                                                                  "", FacesMessage.SEVERITY_INFO);
                    } else {
                        System.out.println("defDocNotifOp.getResult() :: "+defDocNotifOp.getResult());
                        IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while sending email notification." +
                                                                  " Please contact your System Administrator.", "",
                                                                  FacesMessage.SEVERITY_ERROR);
                    }
                } else {
                    IriJsfUtils.addFormattedFacesErrorMessage("Cannot send Deficiency Letter, no Data seems Unverified.", "",
                                                              FacesMessage.SEVERITY_ERROR);
                }
          }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while sending email notification." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }
    
    public void setVerifySeafarerDataPopup(RichPopup verifySeafarerDataPopup) {
        this.verifySeafarerDataPopup = verifySeafarerDataPopup;
    }

    public RichPopup getVerifySeafarerDataPopup() {
        return verifySeafarerDataPopup;
    }

    public void setDeficientAckQaPopup(RichPopup deficientAckQaPopup) {
        this.deficientAckQaPopup = deficientAckQaPopup;
    }

    public RichPopup getDeficientAckQaPopup() {
        return deficientAckQaPopup;
    }

    public void setDeficientAckTcPopup(RichPopup deficientAckTcPopup) {
        this.deficientAckTcPopup = deficientAckTcPopup;
    }

    public RichPopup getDeficientAckTcPopup() {
        return deficientAckTcPopup;
    }

    public void bookVerificationCommentVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null && valueChangeEvent.getNewValue().toString().equalsIgnoreCase("No"))
            {
                IriJsfUtils.showPopup(vefificationCommentsBookPopup, true);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching comments." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }   
    }

    public void setVefificationCommentsBookPopup(RichPopup vefificationCommentsBookPopup) {
        this.vefificationCommentsBookPopup = vefificationCommentsBookPopup;
    }

    public RichPopup getVefificationCommentsBookPopup() {
        return vefificationCommentsBookPopup;
    }

    public void rejectCraDL(DialogEvent dialogEvent)
    {
        try 
        {
            rejectCraPopup.hide();

            if (dialogEvent.getOutcome() != null &&
                (dialogEvent.getOutcome().toString().equalsIgnoreCase("yes") ||
                 (dialogEvent.getOutcome().toString().equalsIgnoreCase("ok"))))
            {            
                OperationBinding rejectCraOp = IriAdfUtils.findOperation("rejectCra");
                rejectCraOp.execute();
                
                AdfFacesContext.getCurrentInstance().addPartialTarget(ocDocTable);                
                AdfFacesContext.getCurrentInstance().addPartialTarget(rejectCraButton);
    
                IriJsfUtils.addFormattedFacesErrorMessage("CRA has been Rejected Successfully !",
                                                         "" , 
                                                         FacesMessage.SEVERITY_INFO);  
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while rejecting this CRA document." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public void setRejectCraPopup(RichPopup rejectCraPopup) {
        this.rejectCraPopup = rejectCraPopup;
    }

    public RichPopup getRejectCraPopup() {
        return rejectCraPopup;
    }

    public void setOcDocTable(RichTable ocDocTable) {
        this.ocDocTable = ocDocTable;
    }

    public RichTable getOcDocTable() {
        return ocDocTable;
    }

    public void setRejectCraButton(RichButton rejectCraButton) {
        this.rejectCraButton = rejectCraButton;
    }

    public RichButton getRejectCraButton() {
        return rejectCraButton;
    }

    public void setSelectMultipleReasonPopup(RichPopup selectMultipleReasonPopup) {
        this.selectMultipleReasonPopup = selectMultipleReasonPopup;
    }

    public RichPopup getSelectMultipleReasonPopup() {
        return selectMultipleReasonPopup;
    }

    public void photoMultipleHoldReasonsVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null && valueChangeEvent.getNewValue().toString().equalsIgnoreCase("26 - Multiple Reasons")) 
            {
                OperationBinding resetSelectedReasonOp = IriAdfUtils.findOperation("resetSelectedReasons");
                resetSelectedReasonOp.execute();
                ADFContext.getCurrent().getPageFlowScope().put("P_HOLD_COMMENT", "Photo");
                IriJsfUtils.showPopup(selectMultipleReasonPopup, true);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching hold reasons." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }        
    }

    public void identityMultipleHoldReasonsVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null && valueChangeEvent.getNewValue().toString().equalsIgnoreCase("26 - Multiple Reasons")) 
            {
                OperationBinding resetSelectedReasonOp = IriAdfUtils.findOperation("resetSelectedReasons");
                resetSelectedReasonOp.execute();
                ADFContext.getCurrent().getPageFlowScope().put("P_HOLD_COMMENT", "Identity");
                IriJsfUtils.showPopup(selectMultipleReasonPopup, true);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching hold reasons." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }        
    }

    public void physicalMultipleHoldReasonsVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null && valueChangeEvent.getNewValue().toString().equalsIgnoreCase("26 - Multiple Reasons")) 
            {
                OperationBinding resetSelectedReasonOp = IriAdfUtils.findOperation("resetSelectedReasons");
                resetSelectedReasonOp.execute();
                ADFContext.getCurrent().getPageFlowScope().put("P_HOLD_COMMENT", "Physical");
                IriJsfUtils.showPopup(selectMultipleReasonPopup, true);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching hold reasons." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }        
    }

    public void seaserviceMultipleHoldReasonsVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null && valueChangeEvent.getNewValue().toString().equalsIgnoreCase("26 - Multiple Reasons")) 
            {
                OperationBinding resetSelectedReasonOp = IriAdfUtils.findOperation("resetSelectedReasons");
                resetSelectedReasonOp.execute();
                ADFContext.getCurrent().getPageFlowScope().put("P_HOLD_COMMENT", "Seaservice");
                IriJsfUtils.showPopup(selectMultipleReasonPopup, true);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching hold reasons." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }        
    }

    public void applicationMultipleHoldReasonsVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null && valueChangeEvent.getNewValue().toString().equalsIgnoreCase("26 - Multiple Reasons")) 
            {
                OperationBinding resetSelectedReasonOp = IriAdfUtils.findOperation("resetSelectedReasons");
                resetSelectedReasonOp.execute();
                ADFContext.getCurrent().getPageFlowScope().put("P_HOLD_COMMENT", "Application");
                IriJsfUtils.showPopup(selectMultipleReasonPopup, true);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching hold reasons." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }        
    }

    public void affidavitMultipleHoldReasonsVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null && valueChangeEvent.getNewValue().toString().equalsIgnoreCase("26 - Multiple Reasons")) 
            {
                OperationBinding resetSelectedReasonOp = IriAdfUtils.findOperation("resetSelectedReasons");
                resetSelectedReasonOp.execute();
                ADFContext.getCurrent().getPageFlowScope().put("P_HOLD_COMMENT", "Affidavit");
                IriJsfUtils.showPopup(selectMultipleReasonPopup, true);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching hold reasons." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }        
    }

    public void securityMultipleHoldReasonsVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null && valueChangeEvent.getNewValue().toString().equalsIgnoreCase("26 - Multiple Reasons")) 
            {
                OperationBinding resetSelectedReasonOp = IriAdfUtils.findOperation("resetSelectedReasons");
                resetSelectedReasonOp.execute();
                ADFContext.getCurrent().getPageFlowScope().put("P_HOLD_COMMENT", "Security");
                IriJsfUtils.showPopup(selectMultipleReasonPopup, true);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching hold reasons." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }        
    }

    public void consentMultipleHoldReasonsVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null && valueChangeEvent.getNewValue().toString().equalsIgnoreCase("26 - Multiple Reasons")) 
            {
                OperationBinding resetSelectedReasonOp = IriAdfUtils.findOperation("resetSelectedReasons");
                resetSelectedReasonOp.execute();
                ADFContext.getCurrent().getPageFlowScope().put("P_HOLD_COMMENT", "Consent");
                IriJsfUtils.showPopup(selectMultipleReasonPopup, true);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching hold reasons." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }        
    }

    public void bookMultipleHoldReasonsVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null && valueChangeEvent.getNewValue().toString().equalsIgnoreCase("26 - Multiple Reasons")) 
            {
                OperationBinding resetSelectedReasonOp = IriAdfUtils.findOperation("resetSelectedReasons");
                resetSelectedReasonOp.execute();
                ADFContext.getCurrent().getPageFlowScope().put("P_HOLD_COMMENT", "Book");
                IriJsfUtils.showPopup(selectMultipleReasonPopup, true);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching hold reasons." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }        
    }

    public void ocMultipleHoldReasonsVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null && valueChangeEvent.getNewValue().toString().equalsIgnoreCase("26 - Multiple Reasons")) 
            {
                OperationBinding resetSelectedReasonOp = IriAdfUtils.findOperation("resetSelectedReasons");
                resetSelectedReasonOp.execute();
                ADFContext.getCurrent().getPageFlowScope().put("P_HOLD_COMMENT", "Oc");
                IriJsfUtils.showPopup(selectMultipleReasonPopup, true);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching hold reasons." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }        
    }

    public void sqcMultipleHoldReasonsVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null && valueChangeEvent.getNewValue().toString().equalsIgnoreCase("26 - Multiple Reasons")) 
            {
                OperationBinding resetSelectedReasonOp = IriAdfUtils.findOperation("resetSelectedReasons");
                resetSelectedReasonOp.execute();
                ADFContext.getCurrent().getPageFlowScope().put("P_HOLD_COMMENT", "Sqc");
                IriJsfUtils.showPopup(selectMultipleReasonPopup, true);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching hold reasons." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }
    
    public void selectMultipleHoldReasonsDL(DialogEvent dialogEvent)
    {
        try 
        {
            selectMultipleReasonPopup.hide();

            Object copyFor = ADFContext.getCurrent().getPageFlowScope().get("P_HOLD_COMMENT");
                
            if(copyFor != null)
            {
                if (dialogEvent.getOutcome() != null &&
                    (dialogEvent.getOutcome().toString().equalsIgnoreCase("yes") ||
                     (dialogEvent.getOutcome().toString().equalsIgnoreCase("ok")) ||
                     (dialogEvent.getOutcome().toString().equalsIgnoreCase("select"))))
                {
                    OperationBinding copySelectedReasonsOp = IriAdfUtils.findOperation("copySelectedReasons");
                    copySelectedReasonsOp.getParamsMap().put("copyFor", copyFor);
                    copySelectedReasonsOp.execute();
                }
                
//                AdfFacesContext.getCurrentInstance().addPartialTarget(panelTabBind);
                
                if (copyFor.toString().equalsIgnoreCase("photo")) {
                    IriJsfUtils.showPopup(photobindpopup, true);
                    AdfFacesContext.getCurrentInstance().addPartialTarget(photoValue);
                }
                else if (copyFor.toString().equalsIgnoreCase("identity")) {
                    IriJsfUtils.showPopup(identitydocbindpopup, true);
                    AdfFacesContext.getCurrentInstance().addPartialTarget(identitydocvalue);
                }
                else if (copyFor.toString().equalsIgnoreCase("physical")) {
                    IriJsfUtils.showPopup(medicalbindpopup, true);
                    AdfFacesContext.getCurrentInstance().addPartialTarget(medicalvalue);
                }
                else if (copyFor.toString().equalsIgnoreCase("seaservice")) {
                    IriJsfUtils.showPopup(medicalbindpopup, true);
                    AdfFacesContext.getCurrentInstance().addPartialTarget(seaservicevalue);
                }
                else if (copyFor.toString().equalsIgnoreCase("application")) {
                    IriJsfUtils.showPopup(attestationbindpopup, true);
                    AdfFacesContext.getCurrentInstance().addPartialTarget(attestationvalue);
                }
                else if (copyFor.toString().equalsIgnoreCase("affidavit")) {
                    IriJsfUtils.showPopup(affbindpopup, true);
                    AdfFacesContext.getCurrentInstance().addPartialTarget(affvalue);
                }
                else if (copyFor.toString().equalsIgnoreCase("security")) {
                    IriJsfUtils.showPopup(securitybindpopup, true);
                    AdfFacesContext.getCurrentInstance().addPartialTarget(securityvalue);
                }
                else if (copyFor.toString().equalsIgnoreCase("consent")) {
                    IriJsfUtils.showPopup(conGrdStatusbindpopup, true);
                    AdfFacesContext.getCurrentInstance().addPartialTarget(conGrdvalue);
                }
                else if (copyFor.toString().equalsIgnoreCase("book")) {
                    IriJsfUtils.showPopup(bookGradeCommentbindpopup, true);
                    AdfFacesContext.getCurrentInstance().addPartialTarget(bookHoldReasonInput);
                }
                else if (copyFor.toString().equalsIgnoreCase("oc")) {
                    IriJsfUtils.showPopup(ocGradeCommentbindpopup, true);
                    AdfFacesContext.getCurrentInstance().addPartialTarget(ocHoldReasonInput);
                }
                else if (copyFor.toString().equalsIgnoreCase("sqc")) {
                    IriJsfUtils.showPopup(sqcGradeCommentbindpopup, true);
                    AdfFacesContext.getCurrentInstance().addPartialTarget(panelTabBind);
                    AdfFacesContext.getCurrentInstance().addPartialTarget(sqcHoldReasonInput);
                }
                else if (copyFor.toString().equalsIgnoreCase("idcard")) {
                    IriJsfUtils.showPopup(idcardGradeCommentPopup, true);
                    AdfFacesContext.getCurrentInstance().addPartialTarget(idcardHoldReasonInput);
                }
                else
                {}
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while selecting hold reasons." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public String actionSelectMultipleReasonPhoto() 
    {
        try 
        {
            OperationBinding resetSelectedReasonOp = IriAdfUtils.findOperation("resetSelectedReasons");
            resetSelectedReasonOp.execute();
            ADFContext.getCurrent().getPageFlowScope().put("P_HOLD_COMMENT", "Photo");
            IriJsfUtils.showPopup(selectMultipleReasonPopup, true);
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching hold reasons." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        
        return null;
    }

    public String actionSelectMultipleReasonIdentity() 
    {
        try 
        {
            OperationBinding resetSelectedReasonOp = IriAdfUtils.findOperation("resetSelectedReasons");
            resetSelectedReasonOp.execute();
            ADFContext.getCurrent().getPageFlowScope().put("P_HOLD_COMMENT", "Identity");
            IriJsfUtils.showPopup(selectMultipleReasonPopup, true);
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching hold reasons." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        
        return null;
    }

    public String actionSelectMultipleReasonPhysical() 
    {
        try 
        {
            OperationBinding resetSelectedReasonOp = IriAdfUtils.findOperation("resetSelectedReasons");
            resetSelectedReasonOp.execute();
            ADFContext.getCurrent().getPageFlowScope().put("P_HOLD_COMMENT", "Physical");
            IriJsfUtils.showPopup(selectMultipleReasonPopup, true);
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching hold reasons." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        
        return null;
    }

    public String actionSelectMultipleReasonSeaservice() 
    {
        try 
        {
            OperationBinding resetSelectedReasonOp = IriAdfUtils.findOperation("resetSelectedReasons");
            resetSelectedReasonOp.execute();
            ADFContext.getCurrent().getPageFlowScope().put("P_HOLD_COMMENT", "Seaservice");
            IriJsfUtils.showPopup(selectMultipleReasonPopup, true);
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching hold reasons." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        
        return null;
    }

    public String actionSelectMultipleReasonApplication() 
    {
        try 
        {
            OperationBinding resetSelectedReasonOp = IriAdfUtils.findOperation("resetSelectedReasons");
            resetSelectedReasonOp.execute();
            ADFContext.getCurrent().getPageFlowScope().put("P_HOLD_COMMENT", "Application");
            IriJsfUtils.showPopup(selectMultipleReasonPopup, true);
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching hold reasons." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        
        return null;
    }

    public String actionSelectMultipleReasonAffidavit() 
    {
        try 
        {
            OperationBinding resetSelectedReasonOp = IriAdfUtils.findOperation("resetSelectedReasons");
            resetSelectedReasonOp.execute();
            ADFContext.getCurrent().getPageFlowScope().put("P_HOLD_COMMENT", "Affidavit");
            IriJsfUtils.showPopup(selectMultipleReasonPopup, true);
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching hold reasons." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        
        return null;
    }

    public String actionSelectMultipleReasonSecurity() 
    {
        try 
        {
            OperationBinding resetSelectedReasonOp = IriAdfUtils.findOperation("resetSelectedReasons");
            resetSelectedReasonOp.execute();
            ADFContext.getCurrent().getPageFlowScope().put("P_HOLD_COMMENT", "Security");
            IriJsfUtils.showPopup(selectMultipleReasonPopup, true);
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching hold reasons." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        
        return null;
    }

    public String actionSelectMultipleReasonConsent() 
    {
        try 
        {
            OperationBinding resetSelectedReasonOp = IriAdfUtils.findOperation("resetSelectedReasons");
            resetSelectedReasonOp.execute();
            ADFContext.getCurrent().getPageFlowScope().put("P_HOLD_COMMENT", "Consent");
            IriJsfUtils.showPopup(selectMultipleReasonPopup, true);
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching hold reasons." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        
        return null;
    }

    public String actionSelectMultipleReasonBook() 
    {
        try 
        {
            OperationBinding resetSelectedReasonOp = IriAdfUtils.findOperation("resetSelectedReasons");
            resetSelectedReasonOp.execute();
            ADFContext.getCurrent().getPageFlowScope().put("P_HOLD_COMMENT", "Book");
            IriJsfUtils.showPopup(selectMultipleReasonPopup, true);
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching hold reasons." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        
        return null;
    }

    public String actionSelectMultipleReasonOc() 
    {
        try 
        {
            OperationBinding resetSelectedReasonOp = IriAdfUtils.findOperation("resetSelectedReasons");
            resetSelectedReasonOp.execute();
            ADFContext.getCurrent().getPageFlowScope().put("P_HOLD_COMMENT", "Oc");
            IriJsfUtils.showPopup(selectMultipleReasonPopup, true);
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching hold reasons." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        
        return null;
    }

    public String actionSelectMultipleReasonSqc() 
    {
        try 
        {
            OperationBinding resetSelectedReasonOp = IriAdfUtils.findOperation("resetSelectedReasons");
            resetSelectedReasonOp.execute();
            ADFContext.getCurrent().getPageFlowScope().put("P_HOLD_COMMENT", "Sqc");
            IriJsfUtils.showPopup(selectMultipleReasonPopup, true);
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching hold reasons." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        
        return null;
    }
    
    public void setOcHoldReasonInput(RichInputText ocHoldReasonInput) {
        this.ocHoldReasonInput = ocHoldReasonInput;
    }

    public RichInputText getOcHoldReasonInput() {
        return ocHoldReasonInput;
    }

    public void setBookHoldReasonInput(RichInputText bookHoldReasonInput) {
        this.bookHoldReasonInput = bookHoldReasonInput;
    }

    public RichInputText getBookHoldReasonInput() {
        return bookHoldReasonInput;
    }

    public void setSqcHoldReasonInput(RichInputText sqcHoldReasonInput) {
        this.sqcHoldReasonInput = sqcHoldReasonInput;
    }

    public RichInputText getSqcHoldReasonInput() {
        return sqcHoldReasonInput;
    }

    public void setBookGradeCommentbindpopup(RichPopup bookGradeCommentbindpopup) {
        this.bookGradeCommentbindpopup = bookGradeCommentbindpopup;
    }

    public RichPopup getBookGradeCommentbindpopup() {
        return bookGradeCommentbindpopup;
    }

    public void deleteOCLine(ActionEvent actionEvent) {
        try 
        {
            OperationBinding deleteOcOp = IriAdfUtils.findOperation("DeleteOc");
            deleteOcOp.execute();
            OperationBinding commitOcOp = IriAdfUtils.findOperation("Commit");
            commitOcOp.execute();

            IriJsfUtils.addFormattedFacesErrorMessage("Selected line deleted successfully !", "",
                                                      FacesMessage.SEVERITY_INFO);
        } catch (Exception e) {
                IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while deleting OC line." +
                                                 " Please contact your System Administrator." , 
                                                 "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void vesselImoNumberVCL(ValueChangeEvent valueChangeEvent) {
        try {
            Integer imo = null;
            if (valueChangeEvent.getNewValue() != null) {

                String str = valueChangeEvent.getNewValue().toString();
                imo = Integer.parseInt(str);
            }
            OperationBinding ob = getBindings().getOperationBinding("imoValueChange");
            ob.getParamsMap().put("imo", imo);
            ob.execute();

            OperationBinding updateBasicInfo = IriAdfUtils.findOperation("updateBasicInfo");
            updateBasicInfo.getParamsMap().put("updatedValue", imo);
            updateBasicInfo.execute();
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while submitting imo number value." +
                                                      " Please contact your System Administrator.", "",
                                                      FacesMessage.SEVERITY_ERROR);
        }
    }

    public void vesselOfficialNumberVCL(ValueChangeEvent valueChangeEvent) {
        try {
            Integer off = null;
            if (valueChangeEvent.getNewValue() != null) {

                String str = valueChangeEvent.getNewValue().toString();
                off = Integer.parseInt(str);
            }
            OperationBinding ob = getBindings().getOperationBinding("offValueChange");
            ob.getParamsMap().put("off", off);
            ob.execute();

            OperationBinding updateBasicInfo = IriAdfUtils.findOperation("updateBasicInfo");
            updateBasicInfo.getParamsMap().put("updatedValue", off);
            updateBasicInfo.execute();
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while submitting official number value." +
                                                      " Please contact your System Administrator.", "",
                                                      FacesMessage.SEVERITY_ERROR);
        }
    }

    public String actionSendAcknowledgement()
    {
        try 
        {
            OperationBinding validateAckOp = IriAdfUtils.findOperation("validateSendAcknowledgement");
            validateAckOp.execute();

//            if ((validateAckOp.getResult() != null && validateAckOp.getResult().toString().equalsIgnoreCase("y")))
            if (true)
            {
                OperationBinding sendAckOp = IriAdfUtils.findOperation("sendAcknowledgement");
                sendAckOp.execute();

                    IriJsfUtils.addFormattedFacesErrorMessage("Application Acknowledgement Sent Successfully !", "",
                                                              FacesMessage.SEVERITY_INFO);
            } else {
                IriJsfUtils.addFormattedFacesErrorMessage("Either the Application or Trade Compliance is not Approved.",
                                                          "", FacesMessage.SEVERITY_ERROR);
            }
        } catch (Exception e) {
                IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while sending acknowledgement." +
                                                 " Please contact your System Administrator." , 
                                                 "", FacesMessage.SEVERITY_ERROR);
        }
        
        return null;
    }

    public void acknowledgementConfirmationDialogListener(DialogEvent dialogEvent) {
        if (dialogEvent.getOutcome() != null &&
            (dialogEvent.getOutcome().toString().equalsIgnoreCase("yes") ||
             (dialogEvent.getOutcome().toString().equalsIgnoreCase("ok")))) {
            
                 try 
                 {
                     OperationBinding validateAckOp = IriAdfUtils.findOperation("validateSendAcknowledgement");
                     validateAckOp.execute();

                     if ((validateAckOp.getResult() != null && validateAckOp.getResult().toString().equalsIgnoreCase("y"))) 
                     {
                         OperationBinding sendAckOp = IriAdfUtils.findOperation("sendAcknowledgement");
                         sendAckOp.execute();

                             IriJsfUtils.addFormattedFacesErrorMessage("Application Acknowledgement Sent Successfully !", "",
                                                                       FacesMessage.SEVERITY_INFO);
                     } else {
                         IriJsfUtils.addFormattedFacesErrorMessage("Either the Application or Trade Compliance is not Approved.",
                                                                   "", FacesMessage.SEVERITY_ERROR);
                     }
                 } catch (Exception e) {
                         IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while sending acknowledgement." +
                                                          " Please contact your System Administrator." , 
                                                          "", FacesMessage.SEVERITY_ERROR);
                 }
             }
    }


    public void setBasicInfoForm(RichPanelFormLayout basicInfoForm) {
        this.basicInfoForm = basicInfoForm;
    }

    public RichPanelFormLayout getBasicInfoForm() {
        return basicInfoForm;
    }

    public void addSqcLine(ActionEvent actionEvent) {
        try 
        {
//            OperationBinding addSqcLineOp = IriAdfUtils.findOperation("addSqcLine");
//            addSqcLineOp.execute();

            BindingContainer bindings = BindingContext.getCurrent().getCurrentBindingsEntry();
            DCIteratorBinding dciter = (DCIteratorBinding) bindings.get("viewSeafarerDocsSqcVO1Iterator");
            RowSetIterator rsi = dciter.getRowSetIterator();
            Row lastRow = rsi.last();
            int lastRowIndex = rsi.getRangeIndexOf(lastRow);
            Row newRow = rsi.createRow();
            newRow.setAttribute("CreatedBy", getUserId());
            newRow.setAttribute("AddedByRole", "EVALUATOR");
            newRow.setAttribute("GradeType", "SQC");
            newRow.setAttribute("GradingStatus3", "Pending");
            newRow.setAttribute("TransDisableDeleteSqcLine", "Y");
            newRow.setAttribute("LineProcessedSqc", "N");
            newRow.setNewRowState(Row.STATUS_INITIALIZED);
            rsi.insertRowAtRangeIndex(lastRowIndex + 1, newRow);
            rsi.setCurrentRow(newRow);
            
            ADFContext.getCurrent().getPageFlowScope().put("VIEW_COC_UPLOAD","Y");
            System.out.println("VIEW_COC_UPLOAD :: "+ADFContext.getCurrent().getPageFlowScope().get("VIEW_COC_UPLOAD"));
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while adding new line." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public void saveSqcLine(ActionEvent actionEvent) {
        try
        {
            OperationBinding saveSqcLineOp = IriAdfUtils.findOperation("saveSqcLine");
            saveSqcLineOp.execute();

            ADFContext.getCurrent().getPageFlowScope().put("VIEW_COC_UPLOAD","N");
            System.out.println("VIEW_COC_UPLOAD :: "+ADFContext.getCurrent().getPageFlowScope().get("VIEW_COC_UPLOAD"));
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while saving lines." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public void deleteSqcLine(ActionEvent actionEvent) {
        try 
        {
            OperationBinding deleteSqcOp = IriAdfUtils.findOperation("DeleteSqc");
            deleteSqcOp.execute();
            OperationBinding commitOp = IriAdfUtils.findOperation("Commit");
            commitOp.execute();

            IriJsfUtils.addFormattedFacesErrorMessage("Selected line deleted successfully !", "",
                                                      FacesMessage.SEVERITY_INFO);
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while deleting SQC line." +
                                                 " Please contact your System Administrator." , 
                                                 "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void uploadCocOcDocumentVCL(ValueChangeEvent valueChangeEvent) 
    {
        if (valueChangeEvent.getNewValue() != null) 
        {
            try {
                UploadedFile fileVal = (UploadedFile) valueChangeEvent.getNewValue();
                OperationBinding ob = IriAdfUtils.findOperation("uploadRmiCocDocument");
                ob.getParamsMap().put("param1", "SICD");
                ob.getParamsMap().put("param2", "0005");
                ob.getParamsMap().put("param3", "Application");
                ob.getParamsMap().put("fileName", fileVal.getFilename());
                ob.getParamsMap().put("docType", "OC");
                ob.execute();

                if (ob.getResult() != null) {
//                    IriJsfUtils.uploadFile(fileVal, "D:\\"+fileVal.getFilename());
                    IriJsfUtils.uploadFile(fileVal, ob.getResult().toString());
                }
            } catch (Exception e) {
                e.printStackTrace();
                IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading COC document." +
                                                            " Please contact your System Administrator." , 
                                                          "", FacesMessage.SEVERITY_ERROR);
            }
        }
    }

    public void uploadCocSqcDocumentVCL(ValueChangeEvent valueChangeEvent) 
    {
        if (valueChangeEvent.getNewValue() != null) 
        {
            try {
                UploadedFile fileVal = (UploadedFile) valueChangeEvent.getNewValue();
                OperationBinding ob = IriAdfUtils.findOperation("uploadRmiCocDocument");
                ob.getParamsMap().put("param1", "SICD");
                ob.getParamsMap().put("param2", "0006");
                ob.getParamsMap().put("param3", "Application");
                ob.getParamsMap().put("fileName", fileVal.getFilename());
                ob.getParamsMap().put("docType", "SQC");
                ob.execute();

                if (ob.getResult() != null) {
                    IriJsfUtils.uploadFile(fileVal, ob.getResult().toString());
//                    ResetUtils.reset(valueChangeEvent.getComponent());
                }
            } catch (Exception e) {
                e.printStackTrace();
                IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading COC document." +
                                                            " Please contact your System Administrator." , 
                                                          "", FacesMessage.SEVERITY_ERROR);
            }
        }
    }

    public void uploadedDocsDisclosureListener(DisclosureEvent disclosureEvent) 
    {
        try 
        {
            if (documentbind != null) {
                documentbind.setVisible(false);
                AdfFacesContext.getCurrentInstance().addPartialTarget(documentbind);
            }
            
            if(offlinebind != null)
            {
                offlinebind.setVisible(false);
                AdfFacesContext.getCurrentInstance().addPartialTarget(offlinebind);
            }
            
            if(photobind != null)
            {
                photobind.setVisible(false);
                AdfFacesContext.getCurrentInstance().addPartialTarget(photobind);
            }
            
        } catch (Exception e) {
                e.printStackTrace();
                IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while opening uploading documents." +
                                                            " Please contact your System Administrator." , 
                                                          "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void approveAllDocsCertsDL(DialogEvent dialogEvent)
    {        
        try 
        {
            String iteratorName = "viewSeafarerVO1Iterator";
            Key rowKey = null;

            if (dialogEvent.getOutcome() != null &&
                (dialogEvent.getOutcome().toString().equalsIgnoreCase("yes") ||
                 (dialogEvent.getOutcome().toString().equalsIgnoreCase("ok")))) 
            {
                rowKey = getCurrentRowKey(iteratorName);
//                OperationBinding approveAllDocsCertsOp = IriAdfUtils.findOperation("approveAllDocsCerts");
//                approveAllDocsCertsOp.execute();
                setCurrentRowKey(iteratorName, rowKey);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while Approving all Documents, Book and Certificates." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public void setApproveAllDocsCertsPopupBind(RichPopup approveAllDocsCertsPopupBind) {
        this.approveAllDocsCertsPopupBind = approveAllDocsCertsPopupBind;
    }

    public RichPopup getApproveAllDocsCertsPopupBind() {
        return approveAllDocsCertsPopupBind;
    }

    public void setVerifyAllDocsCertsPopupBind(RichPopup verifyAllDocsCertsPopupBind) {
        this.verifyAllDocsCertsPopupBind = verifyAllDocsCertsPopupBind;
    }

    public RichPopup getVerifyAllDocsCertsPopupBind() {
        return verifyAllDocsCertsPopupBind;
    }

    public void setVerifyAllDocsPopupBind(RichPopup verifyAllDocsPopupBind) {
        this.verifyAllDocsPopupBind = verifyAllDocsPopupBind;
    }

    public RichPopup getVerifyAllDocsPopupBind() {
        return verifyAllDocsPopupBind;
    }

    public void verifyAllDocsCertsDL(DialogEvent dialogEvent)
    {        
        try 
        {
            String iteratorName = "viewSeafarerVO1Iterator";
            Key rowKey = null;

            if (dialogEvent.getOutcome() != null &&
                (dialogEvent.getOutcome().toString().equalsIgnoreCase("yes") ||
                 (dialogEvent.getOutcome().toString().equalsIgnoreCase("ok")))) 
            {
                rowKey = getCurrentRowKey(iteratorName);
//                OperationBinding verifyAllDocsCertsOp = IriAdfUtils.findOperation("verifyAllDocsCerts");
//                verifyAllDocsCertsOp.execute();
                setCurrentRowKey(iteratorName, rowKey);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while Verifying all Documents, Book and Certificates." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public void approveVerifyAllDocsVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null) {
                String iteratorName = "viewSeafarerVO1Iterator";
                Key rowKey = null;

                Object roleName = AdfFacesContext.getCurrentInstance().getPageFlowScope().get("Role_Name");
                rowKey = getCurrentRowKey(iteratorName);

                System.out.println("valueChangeEvent.getNewValue() :: " + valueChangeEvent.getNewValue());
                System.out.println("roleName :: " + roleName);

                if (roleName != null && roleName.toString().equalsIgnoreCase("EVALUATOR")) {
                    OperationBinding approveAllDocsCertsOp = IriAdfUtils.findOperation("approveAllDocsCerts");
                    approveAllDocsCertsOp.getParamsMap().put("value", valueChangeEvent.getNewValue().toString());
                    approveAllDocsCertsOp.execute();
                }
                if (roleName != null && roleName.toString().equalsIgnoreCase("QA PROCESSOR")) {
                    OperationBinding verifyAllDocsCertsOp = IriAdfUtils.findOperation("verifyAllDocsCerts");
                    verifyAllDocsCertsOp.getParamsMap().put("value", valueChangeEvent.getNewValue().toString());
                    verifyAllDocsCertsOp.execute();
                }

                setCurrentRowKey(iteratorName, rowKey);
            }
        } catch (Exception e) {
            e.printStackTrace();
//            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while Approving all Documents, Book and Certificates." +
//                                             " Please contact your System Administrator." , 
//                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public String getApplicationUrl()
    {
        FacesContext facesCtx = FacesContext.getCurrentInstance();
        ExternalContext ectx = facesCtx.getExternalContext();
        HttpServletRequest req = (HttpServletRequest) ectx.getRequest();
        String url = req.getRequestURL().toString();
        return (url.substring(0, url.length() - req.getRequestURI().length()) + req.getContextPath());
    }

    public void openGenericTc()
    {
        try 
        {            
            StringBuffer sb = new StringBuffer();
            sb.append("var winPop = true;");
            sb.append("winPop = window.open(\"" +
                      getApplicationUrl()+"/seaf/GenericTC" +
                      "\", \"_blank\"); ");
            ExtendedRenderKitService erks =
                Service.getRenderKitService(FacesContext.getCurrentInstance(), ExtendedRenderKitService.class);
            StringBuilder script = new StringBuilder();
            script.append(sb.toString());
            erks.addScript(FacesContext.getCurrentInstance(), script.toString());
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while opening TC." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }

    public String actionOpenGenericTcGrading()
    {
        try
        {
            OperationBinding openGenericTcOp = IriAdfUtils.findOperation("setGenericTcParameters");
            openGenericTcOp.getParamsMap().put("calledFrom", "Grading");
            openGenericTcOp.execute();
            
            openGenericTc();
            
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while opening TC. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }

    public void idcardVerificationCommentVCL(ValueChangeEvent valueChangeEvent) {
        // Add event code here...
    }

    public void setIdcardGradeCommentPopup(RichPopup idcardGradeCommentPopup) {
        this.idcardGradeCommentPopup = idcardGradeCommentPopup;
    }

    public RichPopup getIdcardGradeCommentPopup() {
        return idcardGradeCommentPopup;
    }

    public void idcardMultipleHoldReasonVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null && valueChangeEvent.getNewValue().toString().equalsIgnoreCase("26 - Multiple Reasons")) 
            {
                OperationBinding resetSelectedReasonOp = IriAdfUtils.findOperation("resetSelectedReasons");
                resetSelectedReasonOp.execute();
                ADFContext.getCurrent().getPageFlowScope().put("P_HOLD_COMMENT", "IdCard");
                IriJsfUtils.showPopup(selectMultipleReasonPopup, true);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching hold reasons." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public String actionSelectMultipleReasonIdcard() {
        // Add event code here...
        return null;
    }

    public void setIdcardHoldReasonInput(RichInputText idcardHoldReasonInput) {
        this.idcardHoldReasonInput = idcardHoldReasonInput;
    }

    public RichInputText getIdcardHoldReasonInput() {
        return idcardHoldReasonInput;
    }

    public void setVerificationCommentsIdCardPopup(RichPopup verificationCommentsIdCardPopup) {
        this.verificationCommentsIdCardPopup = verificationCommentsIdCardPopup;
    }

    public RichPopup getVerificationCommentsIdCardPopup() {
        return verificationCommentsIdCardPopup;
    }

    public String actionCreateNewBook()
    {
        try
        {
//            OperationBinding createNewBookLine = IriAdfUtils.findOperation("createNewBookLine");
//            createNewBookLine.execute();
//            
////            System.out.println("createNewBookLine :: "+createNewBookLine.getResult());
//            
//            if(createNewBookLine.getResult() != null && createNewBookLine.getResult().toString().contains("0"))
//            {
//                IriJsfUtils.addFormattedFacesErrorMessage("New Book Created Successfully." , 
//                                                          "", FacesMessage.SEVERITY_INFO);
//            }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while Creating new book " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }

    public void createNewBookDL(DialogEvent dialogEvent)
    {
        try 
        {
            if (dialogEvent.getOutcome() != null &&
                (dialogEvent.getOutcome().toString().equalsIgnoreCase("yes") ||
                 (dialogEvent.getOutcome().toString().equalsIgnoreCase("ok")))) 
            {
                OperationBinding createNewBookLine = IriAdfUtils.findOperation("createNewBookLine");
                createNewBookLine.execute();
                
                //            System.out.println("createNewBookLine :: "+createNewBookLine.getResult());
                
                if(createNewBookLine.getResult() != null && createNewBookLine.getResult().toString().contains("0"))
                {
                    IriJsfUtils.addFormattedFacesErrorMessage("New Book Created Successfully." , 
                                                              "", FacesMessage.SEVERITY_INFO);
                }
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while Creating new book." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public void bookIssueTypeVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
           System.out.println("bookIssueTypeVCL called :: " + valueChangeEvent.getNewValue());

            if (valueChangeEvent.getNewValue() != null) {
                OperationBinding updateIssueType = IriAdfUtils.findOperation("updateIssueTypeManually");
                updateIssueType.getParamsMap().put("updateFor", "Book");
                updateIssueType.execute();
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating Book Issue Type." +
                                                     " Please contact your System Administrator." , 
                                                     "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public void idcardIssueTypeVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
           System.out.println("idcardIssueTypeVCL called :: " + valueChangeEvent.getNewValue());

            if (valueChangeEvent.getNewValue() != null) {
                OperationBinding updateIssueType = IriAdfUtils.findOperation("updateIssueTypeManually");
                updateIssueType.getParamsMap().put("updateFor", "IDCard");
                updateIssueType.execute();
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating ID Card Issue Type." +
                                                     " Please contact your System Administrator." , 
                                                     "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public void sqcIssueTypeVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
           System.out.println("sqcIssueTypeVCL called :: " + valueChangeEvent.getNewValue());

            if (valueChangeEvent.getNewValue() != null) {
                OperationBinding updateIssueType = IriAdfUtils.findOperation("updateIssueTypeManually");
                updateIssueType.getParamsMap().put("updateFor", "SQC");
                updateIssueType.execute();
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating SQC Issue Type." +
                                                     " Please contact your System Administrator." , 
                                                     "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public void ocIssueTypeVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
           System.out.println("ocIssueTypeVCL called :: " + valueChangeEvent.getNewValue());

            if (valueChangeEvent.getNewValue() != null) {
                OperationBinding updateIssueType = IriAdfUtils.findOperation("updateIssueTypeManually");
                updateIssueType.getParamsMap().put("updateFor", "OC");
                updateIssueType.execute();
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating OC Issue Type." +
                                                     " Please contact your System Administrator." , 
                                                     "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public void updateSeafarerIdDL(DialogEvent dialogEvent)
    {
//        try 
//        {
//            String iteratorName = "viewSeafarerVO1Iterator";
//            Key rowKey = null;
////            updateSeafarerIdPopup.hide();
//
//            if (dialogEvent.getOutcome() != null &&
//                (dialogEvent.getOutcome().toString().equalsIgnoreCase("update") ||
//                 (dialogEvent.getOutcome().toString().equalsIgnoreCase("ok"))))
//            {
//                rowKey = getCurrentRowKey(iteratorName);
//                OperationBinding updateSeafarerIdOp = IriAdfUtils.findOperation("updateSeafarerId");
//                updateSeafarerIdOp.execute();
//                setCurrentRowKey(iteratorName, rowKey);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while sending email notification." +
//                                             " Please contact your System Administrator." , 
//                                             "", FacesMessage.SEVERITY_ERROR); 
//        }
    }

    public void setUpdateSeafarerIdPopup(RichPopup updateSeafarerIdPopup) {
        this.updateSeafarerIdPopup = updateSeafarerIdPopup;
    }

    public RichPopup getUpdateSeafarerIdPopup() {
        return updateSeafarerIdPopup;
    }

    public String actionUpdateSeafarerId()
    {
        try 
        {
            String iteratorName = "viewSeafarerVO1Iterator";
            Key rowKey = null;
            updateSeafarerIdPopup.hide();

            rowKey = getCurrentRowKey(iteratorName);
            OperationBinding updateSeafarerIdOp = IriAdfUtils.findOperation("updateSeafarerId");
            updateSeafarerIdOp.execute();
            setCurrentRowKey(iteratorName, rowKey);
            
            System.out.println("updateSeafarerIdOp.getResult() :: "+updateSeafarerIdOp.getResult());
            
            if(updateSeafarerIdOp.getResult() != null && updateSeafarerIdOp.getResult().toString().equalsIgnoreCase("searchSeafarer"))
                return updateSeafarerIdOp.getResult().toString();
            
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while sending email notification." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
        return null;
    }

    public String actionCancelUpdateSeafarerId() {
        updateSeafarerIdPopup.hide();
        return null;
    }

    public void seafarerBackAL(ActionEvent actionEvent) 
    {
//        basicInfoTabBind.setDisclosed(true);
//        AdfFacesContext.getCurrentInstance().addPartialTarget(basicInfoTabBind);
    }

    public void basicInfoVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
           System.out.println("basicInfoVCL called :: " + valueChangeEvent.getNewValue());

            if (valueChangeEvent.getNewValue() != null) {
                OperationBinding updateBasicInfo = IriAdfUtils.findOperation("updateBasicInfo");
                updateBasicInfo.getParamsMap().put("updatedValue", valueChangeEvent.getNewValue());
                updateBasicInfo.execute();
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating Seafarer Basic Information." +
                                                     " Please contact your System Administrator." , 
                                                     "", FacesMessage.SEVERITY_ERROR); 
        }
    }
}