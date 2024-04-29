package com.rmi.manualtradecompliance.view.tradecompliance;


import com.rmi.manualtradecompliance.pojo.OFACSearchMatches;
import com.rmi.manualtradecompliance.pojo.QueryReferences;
import com.rmi.manualtradecompliance.utils.ADFUtils;
import com.rmi.manualtradecompliance.utils.IRIUtils;
import com.rmi.manualtradecompliance.utils.JSFUtils;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Struct;

import java.util.ArrayList;
import java.util.List;

import javax.el.ELContext;
import javax.el.ExpressionFactory;
import javax.el.MethodExpression;
import javax.el.ValueExpression;

import javax.faces.application.FacesMessage;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;

import javax.servlet.http.HttpServletResponse;

import oracle.adf.controller.ControllerContext;
import oracle.adf.controller.ViewPortContext;
import oracle.adf.model.binding.DCIteratorBinding;
import oracle.adf.view.rich.component.rich.RichPopup;
import oracle.adf.view.rich.component.rich.input.RichInputFile;
import oracle.adf.view.rich.component.rich.input.RichInputText;
import oracle.adf.view.rich.component.rich.output.RichInlineFrame;
import oracle.adf.view.rich.event.DialogEvent;
import oracle.adf.view.rich.event.PopupFetchEvent;
import oracle.adf.view.rich.util.FacesMessageUtils;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

import oracle.jbo.Row;
import oracle.jbo.ViewObject;

import oracle.sql.Datum;

import org.apache.myfaces.trinidad.context.RequestContext;
import org.apache.myfaces.trinidad.event.SelectionEvent;

public class TradeComplaince {
    private RichInputText screenedName;
    private RichInputText ofacListEdocId;
    private RichInputText wcScreeningRequestId;
    private RichPopup detailPopUp;
    public String inlineFrameSource;
    private String mergedFile;
    private Boolean downloadMode = false;
    ArrayList<QueryReferences> crossReferences = new ArrayList();
    ArrayList<QueryReferences> crossReferences2 = new ArrayList();
    private RichInlineFrame inlineFrameBinding;
    private RichPopup supportingDocPreviewPopup;
    String consentDocLink, consentDocFileName;
    String uploadConsentDocVisible = "Y";
    String viewConsentButtonVisible = "Y";
    private RichInputFile consentUploadInputFileBind;

    public void setConsentDocFileName(String consentDocFileName) {
        this.consentDocFileName = consentDocFileName;
    }

    public String getConsentDocFileName() {
        return consentDocFileName;
    }

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
        return consentDocLink;
    }

    public void setInlineFrameSource(String inlineFrameSource) {
        this.inlineFrameSource = inlineFrameSource;
    }

    public String getInlineFrameSource() {
        return inlineFrameSource;
    }

    public void setCrossReferences2(ArrayList<QueryReferences> crossReferences2) {
        this.crossReferences2 = crossReferences2;
    }

    public ArrayList<QueryReferences> getCrossReferences2() {
        return crossReferences2;
    }
    ArrayList<OFACSearchMatches> ofacMatches = new ArrayList();


    public TradeComplaince() {
    }

    public void setOfacMatches(ArrayList<OFACSearchMatches> ofacMatches) {
        this.ofacMatches = ofacMatches;
    }

    public ArrayList<OFACSearchMatches> getOfacMatches() {
        fetchOFACSDNMatches();
        return ofacMatches;
    }
    public String ofacEdocUrl;

    public void setOfacEdocUrl(String ofacEdocUrl) {
        this.ofacEdocUrl = ofacEdocUrl;
    }

    public String getOfacEdocUrl() {
      String url=  getOFACDocLink();
        return url;
    }

    public void setCrossReferences(ArrayList<QueryReferences> crossReferences) {
        this.crossReferences = crossReferences;
    }

    public ArrayList<QueryReferences> getCrossReferences() {
        fetchCrossReferences();
        return crossReferences2;
    }
    
    public void synchronize(ActionEvent actionEvent) {
        // Add event code here...
        try {
            String screeningReqId = wcScreeningRequestId.getValue().toString();
            int wc_screening_request_id = Integer.parseInt(screeningReqId);
            OperationBinding syncOp = ADFUtils.findOperation("synchronize");
            syncOp.getParamsMap().put("wc_screening_request_id", wc_screening_request_id);
            syncOp.execute();
        } catch (Exception exp) {
            exp.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while synchronizing data." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }
    
    public void getEdocCategoryId(ActionEvent actionEvent) {
        // Add event code here...
        try{
            int edocId=0;
            OperationBinding edocOp = ADFUtils.findOperation("getEdocCategoryId");
            edocOp.getParamsMap().put("edocId", edocId);
            edocOp.execute();
        }catch(Exception exp){
            exp.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching file." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }
    
    public String getEdocFullURL(ActionEvent actionEvent) {
        // Add event code here...
        try
        {
            int edocId=0;
            OperationBinding edocOp = ADFUtils.findOperation("getEdocFullURL");
            edocOp.getParamsMap().put("edocId", edocId);
            edocOp.execute();
            String fullUrl = ((edocOp.getResult() != null) ? edocOp.getResult().toString() : "");
           return  fullUrl;
        }catch(Exception exp){
            exp.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching file." +
                                                 "Please contact your System Administrator." , 
                                                 "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }
    
    public void syncAlias(ActionEvent actionEvent) {
        // Add event code here...
        try{
            String screeningReqId=wcScreeningRequestId.getValue().toString();
             int wc_screening_request_id=Integer.parseInt(screeningReqId);
                OperationBinding syncOp = ADFUtils.findOperation("syncAlias");
                syncOp.getParamsMap().put("wc_screening_request_id", wc_screening_request_id);
                syncOp.execute();
            }catch(Exception exp){
                exp.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while synchronizing aliases." +
                                                 "Please contact your System Administrator." , 
                                                 "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void fetchCrossReferences() {
        
        try 
        {
            String screeningReqId = wcScreeningRequestId.getValue().toString();
            int wc_screening_request_id = Integer.parseInt(screeningReqId);
            OperationBinding crOp = ADFUtils.findOperation("getCrossReeferences");
            crOp.getParamsMap().put("wc_screening_request_id", wc_screening_request_id);
            crOp.execute();
            Datum[] returnedInfo = ((crOp.getResult()!= null) ? ((Datum[]) crOp.getResult()) : null);
            for (int i = 0; i < returnedInfo.length; i++) {
                Struct os = (Struct) returnedInfo[i];
                try {
                    Object[] a = os.getAttributes();
                    String a1 = "-";
                    String b = "-";
                    String c = "-";
                    String d = "-";
                    String e = "-";
                    String f = "-";
                    String g = "-";

                    if (a[0] != null) {
                        a1 = a[0].toString();
                    }
                    if (a[1] != null) {
                        b = a[1].toString();
                    }
                    if (a[2] != null) {
                        c = a[2].toString();
                    }
                    if (a[3] != null) {
                        d = a[3].toString();
                    }
                    if (a[4] != null) {
                        e = a[4].toString();
                    }
                    if (a[5] != null) {
                        f = a[5].toString();
                    }
                    if (a[6] != null) {
                        g = a[6].toString();
                    }
                    crossReferences2.add(new QueryReferences(a1, b, c, d, e, f, g));
                } catch (SQLException e) {
                    e.printStackTrace();
                    JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching Vettings." +
                                                           "Please contact your System Administrator.", "",
                                                           FacesMessage.SEVERITY_ERROR);
                }
            }
        } catch (Exception nfe) {
            nfe.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching Vettings." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }
    
    public void fetchOFACSDNMatches() {
        // Add event code here...
        try 
        {
            String scName = (String) screenedName.getValue();
            String searchName = scName;
            String entityType = RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TYPE").toString();
            OperationBinding osdnOp = ADFUtils.findOperation("getOFACSDNMatches");
            osdnOp.getParamsMap().put("search_name", searchName);
            osdnOp.getParamsMap().put("entity_type", entityType);
            osdnOp.execute();
            Datum[] arr = ((osdnOp.getResult()!= null) ? ((Datum[]) osdnOp.getResult()) : null);
            for (int i = 0; i < arr.length; i++) {
                Struct os = (Struct) arr[i];
                try {
                    if (os != null) {
                        Object[] a = os.getAttributes();
                        ofacMatches.add(new OFACSearchMatches(a[0].toString(), a[1].toString(), a[2].toString(),
                                                              a[3].toString()));
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching matches." +
                                                           "Please contact your System Administrator.", "",
                                                           FacesMessage.SEVERITY_ERROR);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching matches." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }
    
    public String getOFACDocLink() 
    {        
        try 
        {
            DCIteratorBinding iter = ADFUtils.findIterator("WcScreeningRequestVO1Iterator");
            ViewObject wcScreenVo = iter.getViewObject();
            Row wcScreenRow = wcScreenVo.getCurrentRow();

            if (wcScreenRow != null && wcScreenRow.getAttribute("OfacListEdocId") != null) {
                String ofacListEdocId_S =
                    (ofacListEdocId != null && ofacListEdocId.getValue() != null) ?
                    ofacListEdocId.getValue().toString() :
                    ((wcScreenRow.getAttribute("OfacListEdocId") != null) ?
                     wcScreenRow.getAttribute("OfacListEdocId").toString() : "");
                int ofacListEdocId = Integer.parseInt(ofacListEdocId_S);
                OperationBinding osdnOp = ADFUtils.findOperation("getOFACDocLink");
                osdnOp.getParamsMap().put("ofac_list_edoc_id", ofacListEdocId);
                osdnOp.getParamsMap().put("iriHTMLUrlType", "VSSLADMIN");
                osdnOp.execute();
                return ((osdnOp.getResult()!= null) ? osdnOp.getResult().toString() : "");
            }
        } catch (Exception nfe) {
            nfe.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching file." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
        
       return null;
    }

    public void setScreenedName(RichInputText screenedName) {
        this.screenedName = screenedName;
    }

    public RichInputText getScreenedName() {
        return screenedName;
    }

    public void setOfacListEdocId(RichInputText ofacListEdocId) {
        this.ofacListEdocId = ofacListEdocId;
    }

    public RichInputText getOfacListEdocId() {
        return ofacListEdocId;
    }

    public void setWcScreeningRequestId(RichInputText wcScreeningRequestId) {
        this.wcScreeningRequestId = wcScreeningRequestId;
    }

    public RichInputText getWcScreeningRequestId() {
        return wcScreeningRequestId;
    }

    public void saveActionListner(ActionEvent actionEvent) 
    {        
        try
        {
            BindingContainer bindings = (BindingContainer) ADFUtils.getBindingContainer();

            oracle.binding.OperationBinding ops = ADFUtils.findOperation("Commit");
            ops.execute();

            DCIteratorBinding iter = ADFUtils.findIterator("WcScreeningRequestVO1Iterator");
            ViewObject vo = iter.getViewObject();
            vo.executeQuery();
            List<Object> errors = ops.getErrors();
            if (errors.isEmpty()) {
                oracle.binding.OperationBinding opExecuteVo = ADFUtils.findOperation("executeAllViewObjects");
                opExecuteVo.execute();

                fetchDetails();

                FacesContext fctx = FacesContext.getCurrentInstance();
                String msgType = null;
                FacesMessage msg = null;

                msgType = null;
                msg = FacesMessageUtils.getConfirmationMessage(new FacesMessage("Information Saved Successfully"));
                fctx.addMessage(null, msg);
            } else {
                FacesContext fctx = FacesContext.getCurrentInstance();
                ops = (OperationBinding) bindings.get("Rollback");
                ops.execute();
                String msgType = null;
                FacesMessage msg = null;

                msgType = null;
                msg =
                    FacesMessageUtils.getConfirmationMessage(new FacesMessage("There was an error storing the information !! " +
                                                                              errors));
                fctx.addMessage(null, msg);
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching file." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void setDetailPopUp(RichPopup detailPopUp) {
        this.detailPopUp = detailPopUp;
    }

    public RichPopup getDetailPopUp() {
        return detailPopUp;
    }
    
    public void fetchDetails()
    {  
        
        try 
        {
            OperationBinding displayOp = ADFUtils.findOperation("fetchMatchesDisplayData");
            displayOp.execute();
        } catch (Exception e) {
            e.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching matches." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void detailPopupFetchListner(PopupFetchEvent popupFetchEvent) {
        // Add event code here...
        fetchDetails();
    }
    
    public static Object evaluateEL(String el) {
        try{
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ELContext elContext = facesContext.getELContext();
            ExpressionFactory expressionFactory = facesContext.getApplication().getExpressionFactory();
            ValueExpression exp = expressionFactory.createValueExpression(elContext, el, Object.class);
    
            return exp.getValue(elContext);
            }catch(Exception exp){
            exp.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching file." +
                                                 "Please contact your System Administrator." , 
                                                 "", FacesMessage.SEVERITY_ERROR);
                        return null;
            }
    }

    /**
     * Programmatic invocation of a method that an EL evaluates to.
     * The method must not take any parameters.
     *
     * @param el EL of the method to invoke
     * @return Object that the method returns
     */
    public static Object invokeEL(String el) {
        return invokeEL(el, new Class[0], new Object[0]);
    }

    /**
     * Programmatic invocation of a method that an EL evaluates to.
     *
     * @param el EL of the method to invoke
     * @param paramTypes Array of Class defining the types of the parameters
     * @param params Array of Object defining the values of the parametrs
     * @return Object that the method returns
     */
    public static Object invokeEL(String el, Class[] paramTypes, Object[] params) {
        FacesContext facesContext = FacesContext.getCurrentInstance();
        ELContext elContext = facesContext.getELContext();
        ExpressionFactory expressionFactory = facesContext.getApplication().getExpressionFactory();
        MethodExpression exp = expressionFactory.createMethodExpression(elContext, el, Object.class, paramTypes);

        return exp.invoke(elContext, params);
    }

    public void tcDtlTableSelectionListener(SelectionEvent selectionEvent) 
    {
        try 
        {
            invokeEL("#{bindings.WcContentEOView1.collectionModel.makeCurrent}", new Class[] { SelectionEvent.class }, new Object[] {
                     selectionEvent });
            Row selectedRow = (Row) evaluateEL("#{bindings.Employees1Iterator.currentRow}");
            fetchDetails();
        } catch (Exception e) {
            e.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching matches." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void matchesPopupFetchListener(PopupFetchEvent popupFetchEvent) {
        if(popupFetchEvent != null)
        {
            fetchDetails();    
        }
    }
    
    public void exceptionHandler()
    {
        //System.out.println("inside TradeComplainceTF exceptionHandler");
        ControllerContext ctx = ControllerContext.getInstance();
        ViewPortContext viewprt = ctx.getCurrentViewPort();

        if (viewprt.isExceptionPresent())
        {
            Exception exc = viewprt.getExceptionData();
            JSFUtils.addFormattedFacesErrorMessage("There has been exception while performing this task. ", exc.getMessage(), FacesMessage.SEVERITY_ERROR);
        }
    }

    public void supportingDocPreviewPopupFL(PopupFetchEvent popupFetchEvent) 
    {
        try 
        {
            Integer sourceId =
                Integer.parseInt(RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_ID").toString());

            OperationBinding supportDocOp = ADFUtils.findOperation("genMergedSupportingDocs");
            supportDocOp.getParamsMap().put("seafarerId", sourceId);
            supportDocOp.execute();

            if (supportDocOp.getResult() != null && supportDocOp.getResult().toString().length() > 0) {
                setMergedFile(supportDocOp.getResult().toString());
                setInlineFrameSource(supportDocOp.getResult().toString());
            }
        } catch (Exception nfe) {
            nfe.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching file." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void setMergedFile(String mergedFile) {
        this.mergedFile = mergedFile;
    }

    public String getMergedFile()
    {
        if(this.mergedFile == null)
        {    
            try{            
                Integer seafarerId = Integer.parseInt(RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_ID").toString());
            
                OperationBinding supportDocOp = ADFUtils.findOperation("getMergedFileName");
                supportDocOp.getParamsMap().put("seafarerId", seafarerId);
                supportDocOp.execute();
                
                if(supportDocOp.getResult() != null && supportDocOp.getResult().toString().length() > 0)
                {
                    this.mergedFile = supportDocOp.getResult().toString();
                }
            }catch(Exception exp){
                exp.printStackTrace();
                JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching file." +
                                                 "Please contact your System Administrator." , 
                                                 "", FacesMessage.SEVERITY_ERROR);
            }
        }
             
        return this.mergedFile;
    }

    public void setInlineFrameBinding(RichInlineFrame inlineFrameBinding) {
        this.inlineFrameBinding = inlineFrameBinding;
    }

    public RichInlineFrame getInlineFrameBinding() {
        return inlineFrameBinding;
    }

    public void setSupportingDocPreviewPopup(RichPopup supportingDocPreviewPopup) {
        this.supportingDocPreviewPopup = supportingDocPreviewPopup;
    }

    public RichPopup getSupportingDocPreviewPopup() {
        return supportingDocPreviewPopup;
    }

    public void supportingDocsFileDownloadListener(FacesContext facesContext, OutputStream outputStream) throws IOException
    {
        try 
        {
            Integer seafarerId =
                Integer.parseInt(RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_ID").toString());

            OperationBinding supportDocOp = ADFUtils.findOperation("genMergedSupportingDocs");
            supportDocOp.getParamsMap().put("seafarerId", seafarerId);
            supportDocOp.execute();

            if (supportDocOp.getResult() != null && supportDocOp.getResult().toString().length() > 0) {
                File filed = new File(supportDocOp.getResult().toString());
                FileInputStream fis;
                byte[] b;
                try {
                    fis = new FileInputStream(filed);

                    int n;
                    while ((n = fis.available()) > 0) {
                        b = new byte[n];
                        int result = fis.read(b);
                        outputStream.write(b, 0, b.length);
                        if (result == -1)
                            break;
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                    JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching file." +
                                                           "Please contact your System Administrator.", "",
                                                           FacesMessage.SEVERITY_ERROR);
                } finally {
                    outputStream.flush();
                    this.downloadMode = false;
                }
            }
        } catch (Exception nfe) {
            nfe.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching file." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void setDownloadMode(Boolean downloadMode) {
        this.downloadMode = downloadMode;
    }

    public Boolean getDownloadMode() {
        return downloadMode;
    }

    public String supportDocsAction() 
    {
        try{
            JSFUtils.addFormattedFacesErrorMessage("Preparing file for download","please wait..",FacesMessage.SEVERITY_INFO);
            Integer seafarerId = Integer.parseInt(RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_ID").toString());
            
            OperationBinding supportDocOp = ADFUtils.findOperation("genMergedSupportingDocs");
            supportDocOp.getParamsMap().put("seafarerId", seafarerId);
            supportDocOp.execute();
            
            if(supportDocOp.getResult() != null && supportDocOp.getResult().toString().length() > 0)
            {
                return supportDocOp.getResult().toString();
            }
        }catch(Exception exp){
            exp.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching associated documents." +
                                                 "Please contact your System Administrator." , 
                                                 "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }


    public void dataPrivacyConsentPopupFetchListener(PopupFetchEvent popupFetchEvent)
    {
        try 
        {   
            OperationBinding fltrCnsntDtlOp = ADFUtils.findOperation("filterConsentDetails");
            fltrCnsntDtlOp.execute();
            setConsentDocLink(null);
            setConsentDocFileName(null);
            setViewConsentButtonVisible("N");

            if (fltrCnsntDtlOp.getResult() != null && !"".equals(fltrCnsntDtlOp.getResult())) {
                String ret = fltrCnsntDtlOp.getResult().toString();
                System.out.println("dataPrivacyConsentPopupFetchListener::ret:"+ret);
                if (ret != "Online" && ret != null && !"null".equals(ret) && !"0".equals(ret)) {
                    String[] col = ret.split("---");
                    Integer edoc_id = Integer.parseInt(col[0]);
                    setConsentDocFileName(col[1]);
                    
                    List params = new ArrayList();
                    params.add(edoc_id.intValue());
                    ResultSet rs = new IRIUtils().getPlSqlFunctionData("select disk_path, file_name from iri_edocs where id=?", params);
                    if(rs.next()) {
                        
                        setConsentDocLink(rs.getString("disk_path"));
                        setConsentDocFileName(rs.getString("file_name"));
                        System.out.println("consentDoc Link:"+getConsentDocLink());
                        System.out.println("consentDoc fileName:"+getConsentDocFileName());
                        setUploadConsentDocVisible("Y");
                        setViewConsentButtonVisible("Y");
                    }
                }
                if (ret == "null") {
                    setUploadConsentDocVisible("Y");
                    setViewConsentButtonVisible("N");
                }
            }
        } catch (Exception nfe) {
            nfe.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching consent details." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void setConsentUploadInputFileBind(RichInputFile consentUploadInputFileBind) {
        this.consentUploadInputFileBind = consentUploadInputFileBind;
    }

    public RichInputFile getConsentUploadInputFileBind() {
        return consentUploadInputFileBind;
    }

    public void addAssocDocAL(ActionEvent actionEvent)
    {
        try 
        {
            OperationBinding addAssocDocOp = ADFUtils.findOperation("AddAssocDoc");
            addAssocDocOp.execute();
        } catch (Exception e) {
            e.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading document." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void deleteAssocDocAL(ActionEvent actionEvent)
    {
        try 
        {
            OperationBinding delAssocDocOp = ADFUtils.findOperation("DeleteAssocDoc");
            delAssocDocOp.execute();
        } catch (Exception e) {
            e.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while deleting document." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }

//    public void assocDocUploadVCL(ValueChangeEvent valueChangeEvent)
//    {
//        try
//        {
//            RichInputFile inputFileComponent = (RichInputFile) valueChangeEvent.getComponent();
//            UploadedFile file = (UploadedFile) valueChangeEvent.getNewValue();
//            
//            if (valueChangeEvent.getNewValue() != null)
//            {
//                if (!file.getFilename().endsWith("pdf") && !file.getFilename().endsWith("PDF"))
//                {
//                    inputFileComponent.resetValue();
//                    inputFileComponent.setValid(false);
//                    JSFUtils.addFormattedFacesErrorMessage("Only PDF files are allowed.", "", FacesMessage.SEVERITY_ERROR);
//                }
//                else
//                {
//                    String fileName = file.getFilename();
//                    OperationBinding ob = ADFUtils.findOperation("uploadDocument");
//                    ob.getParamsMap().put("param1", "WORLD_CHECK");
//                    ob.getParamsMap().put("param2", "SUPPORT");
//                    ob.getParamsMap().put("param3", "Vetting");
//                    ob.getParamsMap().put("fileName", fileName);
//                    String path = ob.execute().toString();
//                    if (path != null && path.length() > 0){ 
//                        String[] col = path.split("---");
//                        //consentEdocId = col[0];
//                        
//                        IRIUtils.uploadFile(file, col[1]);                        
//                    }
//                }
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading file." +
//                                             "Please contact your System Administrator." , 
//                                             "", FacesMessage.SEVERITY_ERROR);
//        }
//    }

    public void associatedDocumentsDL(DialogEvent dialogEvent)
    {
        try {
            String outcome = ((dialogEvent.getOutcome() != null) ? dialogEvent.getOutcome().toString() : "N");

            if (outcome.equalsIgnoreCase("ok") || outcome.equalsIgnoreCase("save")) {
                OperationBinding saveOp = ADFUtils.findOperation("Commit");
                saveOp.execute();

                if (saveOp.getErrors().isEmpty()) {
                    ADFUtils.findIterator("WcRequestDocumentsVO1Iterator").executeQuery();
                } else {
                    JSFUtils.addFormattedFacesErrorMessage("There has been some error calling Commit method :: ",
                                                           saveOp.getErrors().toString(), FacesMessage.SEVERITY_ERROR);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while saving data." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }
    
    public void consentDownloadListener(FacesContext facesContext, OutputStream outputStream) {
        // Add event code here...
        new IRIUtils().downloadFile(getConsentDocLink(), outputStream);
    }

    public void legacyConsentDownloadListener(FacesContext facesContext, OutputStream outputStream) {
        // Add event code here...
        //T20211207.0025 - Legacy Vettings - Error Message
        Row row = ADFUtils.findIterator("WcRequestDocumentsVO1Iterator").getCurrentRow();
        String diskPath = row.getAttribute("DiskPath").toString();
        Object fileName = row.getAttribute("FileName");
        
        ExternalContext extContext = facesContext.getExternalContext();
        HttpServletResponse response = (HttpServletResponse)extContext.getResponse();
        response.setHeader("Content-Disposition", "attachment;filename=\"" + fileName + "\"");
        new IRIUtils().downloadFile(diskPath, outputStream);

    }
}
