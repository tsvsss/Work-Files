package com.rmi.manualtradecompliance.view.vetting;

import com.rmi.manualtradecompliance.adfbc.services.RMIManualTradeComplianceAppModuleImpl;
import com.rmi.manualtradecompliance.adfbc.utils.AdfUtils;
import com.rmi.manualtradecompliance.adfbc.utils.LogUtils;
import com.rmi.manualtradecompliance.adfbc.views.lovs.LovVettingsNameScreenedViewImpl;
import com.rmi.manualtradecompliance.pojo.VettingInfo;
import com.rmi.manualtradecompliance.utils.ADFUtils;
import com.rmi.manualtradecompliance.utils.IRIUtils;
import com.rmi.manualtradecompliance.utils.JSFUtils;

import com.rmi.manualtradecompliance.view.listeners.EbsMADFListener;

import java.io.InputStream;
import java.io.OutputStream;
import java.io.Serializable;

import java.math.BigDecimal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Struct;

import java.sql.Timestamp;

import java.sql.Types;

import java.text.ParseException;
import java.text.SimpleDateFormat;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import java.util.concurrent.TimeUnit;

import javax.faces.application.FacesMessage;
import javax.faces.component.UIComponent;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.faces.event.ValueChangeEvent;
import javax.faces.model.SelectItem;
import javax.faces.validator.ValidatorException;

import javax.servlet.http.HttpServletRequest;

import oracle.adf.controller.ControllerContext;
import oracle.adf.controller.ViewPortContext;
import oracle.adf.model.AttributeBinding;
import oracle.adf.model.BindingContext;
import oracle.adf.share.ADFContext;
import oracle.adf.share.logging.ADFLogger;
import oracle.adf.view.rich.component.rich.RichPopup;
import oracle.adf.view.rich.component.rich.data.RichColumn;
import oracle.adf.view.rich.component.rich.data.RichTable;
import oracle.adf.view.rich.component.rich.input.RichInputFile;
import oracle.adf.view.rich.component.rich.input.RichInputListOfValues;
import oracle.adf.view.rich.component.rich.input.RichInputText;
import oracle.adf.view.rich.context.AdfFacesContext;
import oracle.adf.view.rich.event.DialogEvent;
import oracle.adf.view.rich.event.PopupCanceledEvent;
import oracle.adf.view.rich.event.PopupFetchEvent;
import oracle.adf.view.rich.render.ClientEvent;
import oracle.adf.view.rich.util.ResetUtils;

import oracle.apps.xwrl.beans.session.UserRespAndSessionInfo;

import oracle.apps.xwrl.model.am.AppModuleImpl;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

import oracle.jbo.Row;
import oracle.jbo.RowSetIterator;
import oracle.jbo.ViewCriteria;
import oracle.jbo.ViewObject;
import oracle.jbo.uicli.binding.JUCtrlHierNodeBinding;

import oracle.sql.Datum;

import org.apache.myfaces.trinidad.context.RequestContext;
import org.apache.myfaces.trinidad.event.ReturnEvent;
import org.apache.myfaces.trinidad.model.UploadedFile;
import org.apache.myfaces.trinidad.render.ExtendedRenderKitService;
import org.apache.myfaces.trinidad.util.Service;

public class Vetting implements Serializable {
    @SuppressWarnings("compatibility:8232930928240264359")
    private static final long serialVersionUID = 1L;
    private RichPopup createVettingPopup;
    private RichTable tcReferencesTableBind;
    private List<VettingInfo> seafarerVettingList = new ArrayList<>();
    private List<SelectItem> advFilterList = new ArrayList<>();
    private List<SelectItem> columnsOrderList = new ArrayList<>();
    private Map<String, Integer> columnsOrderVisibleMap= new HashMap<>();
    private static ADFLogger LOGGER = ADFLogger.createADFLogger(Vetting.class);

    public void setColumnsOrderVisibleMap(Map<String, Integer> columnsOrderVisibleMap) {
        this.columnsOrderVisibleMap = columnsOrderVisibleMap;
    }

    public Map<String, Integer> getColumnsOrderVisibleMap() {
        return columnsOrderVisibleMap;
    }

    public void setColumnsOrderList(List<SelectItem> columnsOrderList) {
        this.columnsOrderList = columnsOrderList;
    }

    public List<SelectItem> getColumnsOrderList() {
        return columnsOrderList;
    }
    
    private void prepareColumnsOrderList() {
        columnsOrderList.clear();
        ViewObject vo = ADFUtils.findIterator("RmiGenericColumnsOrderView1Iterator").getViewObject();
        vo.applyViewCriteria(null);
        vo.executeQuery();
        String dOrderId=null, dOrderName=null, dOrder=null;
        while(vo.hasNext()) {
            Row row = vo.next();
            columnsOrderList.add(new SelectItem(row.getAttribute("Id").toString(),row.getAttribute("OrderName").toString()));
            
            if("Y".equals(row.getAttribute("IsDefault"))) {
                dOrderId = row.getAttribute("Id").toString();
                dOrderName = row.getAttribute("OrderName").toString();
                dOrder = row.getAttribute("ColumnsOrder").toString();
            }
        }
        
        if(dOrderId != null) {
            selectedOrderId = dOrderId;
            selectedOrderName = dOrderName;
            isOrderDefault = true;
            prepareReOrderMap(dOrder);
        } else {
            isOrderDefault = false;
            prepareReOrderMap();
        }
    }

    //T20220309.0027 - FW: before and after column rearranging for Filing Agent TC
    private String selectedAdvFilter = "CONTAINS";
    //T20220323.0025 - Issue with vettings being automatically check mark... (IRI)
    List<String> runTcSummaryList = new ArrayList<String>();
    private RichPopup runTCSummaryPopup;

    public void setColumnsOrderName(String columnsOrderName) {
        this.columnsOrderName = columnsOrderName;
    }

    public String getColumnsOrderName() {
        return columnsOrderName;
    }
    private String columnsOrderName;
    private String selectedOrderName;
    private String selectedOrderId;
    private boolean isOrderDefault;

    public void setIsOrderDefault(boolean isOrderDefault) {
        this.isOrderDefault = isOrderDefault;
    }

    public boolean isIsOrderDefault() {
        return isOrderDefault;
    }

    public void setSelectedOrderName(String selectedOrderName) {
        this.selectedOrderName = selectedOrderName;
    }

    public String getSelectedOrderName() {
        return selectedOrderName;
    }

    public void setSelectedOrderId(String selectedOrderId) {
        this.selectedOrderId = selectedOrderId;
    }

    public String getSelectedOrderId() {
        return selectedOrderId;
    }

    public void setSelectedAdvFilter(String selectedAdvFilter) {
        this.selectedAdvFilter = selectedAdvFilter;
    }

    public String getSelectedAdvFilter() {
        return selectedAdvFilter;
    }

    public void setAdvFilterList(List<SelectItem> advFilterList) {
        this.advFilterList = advFilterList;
    }

    public List<SelectItem> getAdvFilterList() {
        return advFilterList;
    }


    //T20211215.0029 - Create Vetting Popup changes
    private boolean isVettingInfoValid=true;

    public void setIsVettingInfoValid(boolean isVettingInfoValid) {
        this.isVettingInfoValid = isVettingInfoValid;
    }

    public boolean isIsVettingInfoValid() {
        return isVettingInfoValid;
    }

    private String consentDocLink, consentDocFileName, onlineConsentDocLink,onlineConsentDocFileName;

    public void setOnlineConsentDocFileName(String onlineConsentDocFileName) {
        this.onlineConsentDocFileName = onlineConsentDocFileName;
    }

    public String getOnlineConsentDocFileName() {
        return onlineConsentDocFileName;
    }

    public void setViewOnlineConsentButtonVisible(String viewOnlineConsentButtonVisible) {
        this.viewOnlineConsentButtonVisible = viewOnlineConsentButtonVisible;
    }

    public String getViewOnlineConsentButtonVisible() {
        return viewOnlineConsentButtonVisible;
    }

    public void setOnlineConsentDocLink(String onlineConsentDocLink) {
        this.onlineConsentDocLink = onlineConsentDocLink;
    }

    public String getOnlineConsentDocLink() {
        return onlineConsentDocLink;
    }
    private String uploadConsentDocVisible = "Y";
    private String viewOnlineConsentButtonVisible = "Y";

   
    private String viewConsentButtonVisible = "Y";
    private RichPopup dataPrivacyConsentPopup;
    
    private RichPopup updateCityCountryPopup;
    private RichPopup runTcConfirmationPopupBinding;
    private IRIUtils iriUtils = new IRIUtils();
    private String consentEdocId;
    
    //T20201117.0028 - Single Name Vettings
    private Date affidavitStartDate;
    private Date affidavitEndDate;
    private String affidavitDiskPath = null;
    private String affidavitFileName = null;
    private InputStream affidavitUploadedFile;
    private String affidavitUploadedFileName;
    private String affidavitAction = "UPDATE";
    
    private List<SelectItem> sortList =  new ArrayList<SelectItem>();
    private String sortByColumnName = "none", sortByType = "asc";
    
    private String searchNameScreened;
    private String searchBatchId;
    private String searchEndDate = "is null";
    private String searchStatus = "All";
    
    private String filterClauseData = " end_date is null";
    private String filterConjection = "and";
    private String nameScreenedSearchStr, nameScreenedAliasSearchStr;
    
    private InputStream uploadedFileStream;
    private String selectedFileName;
    private boolean hasRequestId;
    private String oneSrchResltMsg;
    
    private boolean PRVFT;
    private String affidavitReceived=null;

    public void setPRVFT(boolean PRVFT) {
        this.PRVFT = PRVFT;
    }

    public boolean isPRVFT() {
        return PRVFT;
    }

    public void setOneSrchResltMsg(String oneSrchResltMsg) {
        this.oneSrchResltMsg = oneSrchResltMsg;
    }

    public String getOneSrchResltMsg() {
        return oneSrchResltMsg;
    }

    private String showMsg;
    
    private Map<String,Boolean> uiConfigMap = new HashMap<String,Boolean>();
    private Map<String,Integer> reOrderMap = new HashMap<String,Integer>();

    public void setShowMsg(String showMsg) {
        this.showMsg = showMsg;
    }

    public String getShowMsg() {
        return showMsg;
    }

    public void setSelectedFileName(String selectedFileName) {
        this.selectedFileName = selectedFileName;
    }

    public String getSelectedFileName() {
        return selectedFileName;
    }

    public void setUploadedFileStream(InputStream uploadedFileStream) {
        this.uploadedFileStream = uploadedFileStream;
    }

    public InputStream getUploadedFileStream() {
        return uploadedFileStream;
    }

    public void setNameScreenedAliasSearchStr(String nameScreenedAliasSearchStr) {
        this.nameScreenedAliasSearchStr = nameScreenedAliasSearchStr;
    }

    public String getNameScreenedAliasSearchStr() {
        return nameScreenedAliasSearchStr;
    }

    public void setNameScreenedSearchStr(String nameScreenedSearchStr) {
        this.nameScreenedSearchStr = nameScreenedSearchStr;
    }

    public String getNameScreenedSearchStr() {
        return nameScreenedSearchStr;
    }

    public void setFilterConjection(String filterConjection) {
        this.filterConjection = filterConjection;
    }

    public String getFilterConjection() {
        return filterConjection;
    }

    public void setSearchNameScreened(String searchNameScreened) {
        this.searchNameScreened = searchNameScreened;
    }

    public String getSearchNameScreened() {
        return searchNameScreened;
    }

    public void setSearchBatchId(String searchBatchId) {
        this.searchBatchId = searchBatchId;
    }

    public String getSearchBatchId() {
        return searchBatchId;
    }

    public void setSearchEndDate(String searchEndDate) {
        this.searchEndDate = searchEndDate;
    }

    public String getSearchEndDate() {
        return searchEndDate;
    }

    public void setSearchStatus(String searchStatus) {
        this.searchStatus = searchStatus;
    }

    public String getSearchStatus() {
        return searchStatus;
    }

    public void setReOrderMap(Map<String, Integer> reOrderMap) {
        this.reOrderMap = reOrderMap;
    }

    public Map<String, Integer> getReOrderMap() {
        return reOrderMap;
    }

    public void setSortByType(String sortByType) {
        this.sortByType = sortByType;
    }

    public String getSortByType() {
        return sortByType;
    }

    public void setSortByColumnName(String sortByColumnName) {
        this.sortByColumnName = sortByColumnName;
    }

    public String getSortByColumnName() {
        return sortByColumnName;
    }

    public void setSortList(List<SelectItem> sortList) {
        this.sortList = sortList;
    }

    public List<SelectItem> getSortList() {
        return sortList;
    }
    
    private Integer runCount = 0;

    public Vetting() 
    {
        Object sourceId = RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_ID");
        if(sourceId == null || "".equals(sourceId))
            iriUtils.displayWarningMessage("General Trade Compliance Mode");
        fetchVettingInfo();
        prepareAdvFilterList();
        prepareColumnsOrderList();
        
    }
    
    private void prepareAdvFilterList() {
        advFilterList.clear();
        String lables[] = {"Starts with", "Ends with", "Equals", "Does not equal", "Contains", "Does not contain"};
        String values[] = {"STARTS_WITH", "ENDS_WITH", "EQUALS", "DOES_NOT_EQUAL", "CONTAINS", "DOES_NO_CONTAIN"};
        advFilterList.add(new SelectItem("-","-"));
        for(int i=0; i<lables.length;i++)
            advFilterList.add(new SelectItem(values[i], lables[i]));
    }

    public void setAffidavitStartDate(Date affidavitStartDate) {
        this.affidavitStartDate = affidavitStartDate;
    }

    public Date getAffidavitStartDate() {
        return affidavitStartDate;
    }

    public void setAffidavitEndDate(Date affidavitEndDate) {
        this.affidavitEndDate = affidavitEndDate;
    }

    public Date getAffidavitEndDate() {
        return affidavitEndDate;
    }

    public void setAffidavitFileName(String affidavitFileName) {
        this.affidavitFileName = affidavitFileName;
    }

    public String getAffidavitFileName() {
        return affidavitFileName;
    }

    public void setConsentDocFileName(String consentDocFileName) {
        this.consentDocFileName = consentDocFileName;
    }

    public String getConsentDocFileName() {
        return consentDocFileName;
    }

    public void setSeafarerVettingList(List<VettingInfo> seafarerVettingList) {
        this.seafarerVettingList = seafarerVettingList;
    }

    public List<VettingInfo> getSeafarerVettingList() {
      
        return seafarerVettingList;
    }

    public void fetchVettingInfo()
    {
        try 
        {
            if(ADFContext.getCurrent().getSessionScope().get("UserId") == null || "".equals(ADFContext.getCurrent().getSessionScope().get("UserId")))
                return;
            ADFContext.getCurrent().getSessionScope().put("UserId", Integer.parseInt(ADFContext.getCurrent().getSessionScope().get("UserId").toString()));
            ADFContext.getCurrent().getSessionScope().put("SessionId", (Integer) ADFContext.getCurrent().getSessionScope().get("SessionId"));
            
            if(RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_ID") == null || "".equals(RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_ID")))
                initializeRequestParams();
            
            if(RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_ID") == null)
                return;
            
            String pSourceId = RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_ID").toString();
            // tsuazo 08/21/2023
            //String pSourceTable = (String) RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TABLE");
            String pSourceTable = RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TABLE").toString();

            System.out.println("Vetting sourceId:"+pSourceId);
            System.out.println("Vetting userId:"+ADFContext.getCurrent().getSessionScope().get("UserId"));
            if (pSourceId != null) 
            {
                String p_source_table = pSourceTable;
                String p_source_column = RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TABLE_COLUMN").toString();
                int p_source_id =
                    Integer.parseInt(pSourceId);
                
                setRequestParameters();
                
                Datum[] returnedInfo = getAm().queryCrossReference(p_source_table, p_source_column, p_source_id);
                seafarerVettingList.clear();
                
                if(returnedInfo == null)
                    return;

                for (int i = 0; i < returnedInfo.length; i++) {
                    Struct os = (Struct) returnedInfo[i];
                    try {
                        Object[] a = os.getAttributes();
                                                
                        seafarerVettingList.add(new VettingInfo(((a[0] != null) ? a[0].toString() : "-"),
                                                                ((a[2] != null) ? a[2].toString() : "-"),
                                                                ((a[7] != null) ? a[7].toString() : "-"),
                                                                ((a[1] != null) ? a[1].toString() : "-"),
                                                                ((a[15] != null) ? a[15].toString() : "-"),
                                                                ((a[12] != null) ? a[12].toString() : "-"),
                                                                ((a[18] != null) ? a[18].toString() : "-")));
                    } catch (Exception e) {
                        JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching Legacy Vettings Info Loop." +
                                                         "Please contact your System Administrator." , 
                                                         "", FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();
                        logGenericTC(LogUtils.ERROR, "System encountered an exception while fetching Legacy Vettings Info Loop.", "Please contact your System Administrator.", "Vetting","fetchVettingInfo",e);
                    }
                }
            }
        } catch (Exception e) {
                JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching Legacy Vettings Info." +
                                                 "Please contact your System Administrator." , 
                                                 "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while fetching Legacy Vettings Info.", "Please contact your System Administrator.", "Vetting","fetchVettingInfo", e);
        }
    }
    
    private void initializeRequestParams() {
        try{
            FacesContext fctx = FacesContext.getCurrentInstance();
            ExternalContext ectx = fctx.getExternalContext();
            Map m = ectx.getRequestParameterMap();
            Map pMap =  ADFContext.getCurrent().getPageFlowScope();
            
            if(pMap.get("P_SOURCE_ID") == null)
               pMap.put("P_SOURCE_ID",m.get("sourceId"));
            
            if(pMap.get("P_SOURCE_TABLE") == null)
               pMap.put("P_SOURCE_TABLE",m.get("sourceTable"));
            
            if(pMap.get("P_SOURCE_TABLE_COLUMN") == null)
               pMap.put("P_SOURCE_TABLE_COLUMN",m.get("sourceTableColumn"));
            
            if(pMap.get("P_SOURCE_TYPE") == null)
                pMap.put("P_SOURCE_TYPE",m.get("sourceType"));
            
            System.out.println("seafarerId:"+pMap.get("P_SOURCE_ID"));
            System.out.println("sourceTable:"+pMap.get("P_SOURCE_TABLE"));
        }catch(Exception e){
            e.printStackTrace();
            logGenericTC(LogUtils.ERROR, "Error while reading the request parameters", "Please contact your System Administrator.", "Vetting","initializeRequestParams", e);
        }
    }
    
    private void setRequestParameters(){
        try {
            String entityType = "";
            List params=new ArrayList();
            params.add(RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TABLE").toString());
    
            ResultSet data =
                iriUtils.getPlSqlFunctionData("select option_value from RMI_GENERIC_PARAMETERS where option_key=? and id='ENTITY_TYPE' and enabled='Y'",
                                              params);
            if(data.next()){
                entityType = data.getString("option_value");
                RequestContext.getCurrentInstance().getPageFlowScope().put("ENTITY_TYPE",
                                                                               entityType);
                params=new ArrayList();
                params.add(entityType+"_CATEGORY");
                ResultSet data1 =
                    iriUtils.getPlSqlFunctionData("select option_value from RMI_GENERIC_PARAMETERS where option_key=? and id='DPC' and enabled='Y'",
                                                  params);
                if(data1.next()){
                    RequestContext.getCurrentInstance().getPageFlowScope().put("DPC_CATEGORY",
                                                                                   data1.getString("option_value"));
                }
                
            }
            data.close();
            sortList.clear();
            params.clear();
            data =
                iriUtils.getPlSqlFunctionData("select option_key,option_value from RMI_GENERIC_PARAMETERS where  id='SORT_BY' and enabled='Y' order by option_value",params);
            while(data.next()) {
                sortList.add(new SelectItem(data.getString("option_key"),data.getString("option_value")));
            }
            data.close();
            params.clear();
            uiConfigMap.clear();
            data =
                iriUtils.getPlSqlFunctionData("select option_key,option_value from RMI_GENERIC_PARAMETERS where  id='UI_CONFIG' and enabled='Y'",params);
            while(data.next()) {
                uiConfigMap.put(data.getString("option_key"),"Yes".equals(data.getString("option_value")));
            }
            data.close();
            prepareReOrderMap();
        } catch (SQLException e) {
            e.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while preparing additional parameters", "Please contact your System Administrator.", "Vetting","setRequestParameters", e);
        }
    }

    public void setUiConfigMap(Map<String, Boolean> uiConfigMap) {
        this.uiConfigMap = uiConfigMap;
    }

    public Map<String, Boolean> getUiConfigMap() {
        return uiConfigMap;
    }

    public void actionListnerViewButton(ActionEvent actionEvent) 
    {
        try{
            String screeningId = actionEvent.getComponent().getAttributes().get("screeningId").toString();

            ADFContext.getCurrent().getSessionScope().put("wcScreeningRequestId", screeningId);

        }catch(Exception exp){
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching data." +
                                                 "Please contact your System Administrator." , 
                                                 "", FacesMessage.SEVERITY_ERROR);
             exp.printStackTrace();
             logGenericTC(LogUtils.ERROR, "System encountered an exception while fetching data.", 
                                   "Please contact your System Administrator.", "Vetting","actionListnerViewButton", exp);
         }
    }

    public void viewTcReturnListener(ReturnEvent returnEvent) 
    {
        fetchVettingInfo();
    }

    public void refreshActionListener(ActionEvent actionEvent) 
    {
        prepareColumnsOrderList();
        fetchVettingInfo();
        fetchTcReferencesOws();
    }

    public BindingContainer getBindings() {
        return BindingContext.getCurrent().getCurrentBindingsEntry();
    }
    
    public void exceptionHandler()
    {
        //System.out.println("inside vettingTF exceptionHandler");
        ControllerContext ctx = ControllerContext.getInstance();
        ViewPortContext viewprt = ctx.getCurrentViewPort();

        if (viewprt.isExceptionPresent())
        {
            Exception exc = viewprt.getExceptionData();
            JSFUtils.addFormattedFacesErrorMessage("There has been exception while performing this task. ", exc.getMessage(), FacesMessage.SEVERITY_ERROR);
            exc.printStackTrace();
            logGenericTC(LogUtils.ERROR, "There has been exception while performing this task.", 
                                               exc.getMessage(), "Vetting","exceptionHandler", exc);
        }
    }

    public void setCreateVettingPopup(RichPopup createVettingPopup) {
        this.createVettingPopup = createVettingPopup;
    }

    public RichPopup getCreateVettingPopup() {
        return createVettingPopup;
    }

    public void existingVettingMatchesPopupCL(PopupCanceledEvent popupCanceledEvent) 
    {
        JSFUtils.showPopup(createVettingPopup, true);
    }

    public String createNewVettingAction() 
    {
        
        LovVettingsNameScreenedViewImpl vo =
            (LovVettingsNameScreenedViewImpl) ADFUtils.findIterator("LovVettingsNameScreenedView1Iterator").getViewObject();
        vo.removeViewCriteria("LovVettingsNameScreenedSearch");
        vo.removeViewCriteria("LovVettingsNameScreenedViewCriteria");
        vo.removeViewCriteria("LovVettingsNameScreenedViewCriteria1");
        vo.setWhereClause(null);
        vo.executeEmptyRowSet();
        System.out.println("Vetting nameScreenContainVCL");
        
        try 
        {
            isVettingInfoValid = true;
                
            Row currentTCRow = ADFUtils.findIterator("TcReferencesView1Iterator").getViewObject().getCurrentRow();
            if(currentTCRow != null) {
                if(!iriUtils.nullStrToSpc(currentTCRow.getAttribute("NameScreened")).contains(" ") && "Yes".equals(currentTCRow.getAttribute("AffidavitFlag"))) {
                    JSFUtils.addFormattedFacesErrorMessage("Vetting was entered and confirmed as a single name vetting.  In order to create an additional name for this vetting, " +
                        "please contact trade compliance at IRI-Trade@Register-iri.com.", "",
                                                           FacesMessage.SEVERITY_ERROR);
                    return null;
                    
                }
            }
            
            if(createVettingPopup != null)
                ResetUtils.reset(createVettingPopup);
            ADFContext.getCurrent().getPageFlowScope().put("P_FORM_CALLED", "vetting");
            resetToNewRow();
            
            JSFUtils.showPopup(createVettingPopup, true);
            
        } catch (Exception e) {
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while creating new vetting." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while creating new vetting.", 
                                               "Please contact your System Administrator.", "Vetting","createNewVettingAction", e);
        }
        return null;
    }
    
    private ViewObject resetToNewRow() {
        ViewObject dualVO = ADFUtils.findIterator("DualCreateVettingVO1Iterator").getViewObject();
        dualVO.clearCache();
        dualVO.executeQuery();
        
        Row row = dualVO.first();
        row.setAttribute("TransOperationType", "C");
        
        if("ENTITY".equals(RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TYPE")))
        {
            if("VSSL_VESSELS".equals(RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TABLE")))
                row.setAttribute("TransEntityType", "VESSEL");
            else
            row.setAttribute("TransEntityType", "INDIVIDUAL");                  //row.setAttribute("TransEntityType", "ORGANISATION");
        }
        else
            row.setAttribute("TransEntityType", "INDIVIDUAL");
        
        return dualVO;
    }

    public String createNewVettingPopupAction() 
    {
        try{
            OperationBinding cnvOp = ADFUtils.findOperation("createNewVetting");
            cnvOp.execute();

            System.out.println("cnvOp.getResult() :: "+cnvOp.getResult());
            
            if(cnvOp.getResult()!= null && cnvOp.getResult().toString().equalsIgnoreCase("y"))
            {
                createVettingPopup.hide();
                //T20220323.0025 - Issue with vettings being automatically check mark... (IRI)
                saveVettingCheckBoxSelections();
                fetchTcReferencesOws();
                AdfFacesContext.getCurrentInstance().addPartialTarget(tcReferencesTableBind);
                JSFUtils.addFormattedFacesErrorMessage("Vetting created/updated successfully !", 
                                                       null, FacesMessage.SEVERITY_INFO);
            }
            else if(!"E".equals(cnvOp.getResult()))
            {
                System.out.println("cnvOp.getErrors :: "+cnvOp.getErrors());
                System.out.println("cnvOp.getErrors :: "+cnvOp.getResult());
                
                JSFUtils.addFormattedFacesErrorMessage(cnvOp.getResult() +
                                                       "", "",
                                                       FacesMessage.SEVERITY_ERROR);
            }
        }catch(Exception e){
            e.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while creating new vetting." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while creating new vetting.", 
                                               "Please contact your System Administrator.", "Vetting","createNewVettingPopupAction", e);
        }
        return null;
    }
    
    public RMIManualTradeComplianceAppModuleImpl getAm()
    {
        return (RMIManualTradeComplianceAppModuleImpl) ADFUtils.getApplicationModuleForDataControl("RMIManualTradeComplianceAppModuleDataControl");
    }

    public String actionRunTc()
    {
        
        LOGGER.finest("actionRunTc");
        RowSetIterator rsi = null;
        try
        {
            affidavitReceived = null;
            boolean hasRecords = false;
            boolean isExpired = true;
            String name=null;
            int singleNameCnt=0;
            ViewObject vo = ADFUtils.findIterator("TcReferencesView1Iterator").getViewObject();
            int spaceCnt=0;
            rsi = vo.createRowSetIterator(null);
            long millis = System.currentTimeMillis();            
            long seconds = TimeUnit.MILLISECONDS.toSeconds(millis);
            java.sql.Timestamp  sysdate = new java.sql.Timestamp (TimeUnit.SECONDS.toMillis(seconds));
            java.sql.Timestamp  expdate = null;
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            
            fetchTcReferencesOws();
            
            while(rsi.hasNext()) {
                Row row = rsi.next();                
                if(row != null) {
                    
                    LOGGER.finest("Check Expiration");
                    LOGGER.finest("Status: "+row.getAttribute("Status"));
                    LOGGER.finest("CaseStatus: "+row.getAttribute("CaseStatus"));
                    
                    if("Y".equals(row.getAttribute("TcExcluded"))){
                        hasRecords = true;
                        
                        if("Approved".equals(row.getAttribute("Status"))  && row.getAttribute("ExpDate") != null) {
                            
                            expdate = (Timestamp) row.getAttribute("ExpDate");
                            LOGGER.finest("expdate: "+expdate);
                            LOGGER.finest("sysdate: "+sysdate);
                            LOGGER.finest("isExpired");
                            
                            if (sysdate.before(expdate)) {
                                isExpired = false;    
                            }
                            
                        }                        
    
                        LOGGER.finest("isExpired: "+isExpired);

                        if("Open".equals(row.getAttribute("CaseStatus"))){
                            name = row.getAttribute("NameScreened").toString();
                        }
                        if(!"".equals(iriUtils.nullStrToSpc(row.getAttribute("NameScreened"))) &&
                                             iriUtils.nullStrToSpc(row.getAttribute("NameScreened")).contains(" ")) {
                            spaceCnt++;
                        }else {
                            singleNameCnt++;
                            if(affidavitReceived == null || "".equals(affidavitReceived))
                                affidavitReceived = ("Yes".equals(iriUtils.nullStrToSpc(row.getAttribute("AffidavitFlag"))))? "Y" : null;
                        }
                    }
                }
            }

            if(!isExpired){
                //JSFUtils.addFormattedFacesErrorMessage("The Approved vetting is not Expired" +
                // T20230207.0027 change language
                JSFUtils.addFormattedFacesErrorMessage("One of the records selected is still within the approved timeframe.  Please deselect." +
                                                       "", "",
                                                       FacesMessage.SEVERITY_ERROR);            
            } else if(!hasRecords){
                JSFUtils.addFormattedFacesErrorMessage("Please select checkbox for processing record" +
                                                       "", "",
                                                       FacesMessage.SEVERITY_ERROR);
            } else if(((singleNameCnt > 0 && spaceCnt > 0) || singleNameCnt > 1) && "Y".equals(affidavitReceived)) {
                JSFUtils.addFormattedFacesErrorMessage("Could not process single name record(s) with selected combination. Please select only single name record to proceed" +
                                                       "", "",
                                                       FacesMessage.SEVERITY_ERROR);
            } else if (name != null) {
                ADFContext.getCurrent().getViewScope().put("P_NAME_SCREENED", name);
                JSFUtils.showPopup(runTcConfirmationPopupBinding, true);
            }
            else {
                /*T20220323.0025 - Issue with vettings being automatically check mark... (IRI)
                 * Commented the below code and moved to seperate method
                OperationBinding runTcOp = ADFUtils.findOperation("callRunTc");
                runTcOp.getParamsMap().put("affidavitFlag", affidavitReceived);
                runTcOp.getParamsMap().put("documentType", (PRVFT)? "PRVFT" : null);
                Object msg = runTcOp.execute();     
                
                validateRunTCResponse(msg);
                
                fetchTcReferencesOws();
                */
                //T20220323.0025 - Issue with vettings being automatically check mark... (IRI)
                if(("AR_CUSTOMERS".equals(RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TABLE"))) || ("CORP_MAIN".equals(RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TABLE")))){
                    JSFUtils.showPopup(runTCSummaryPopup, true);
                }else{
                    this.callRunTc();
                }
            }
            
        } catch (Exception exp){
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while running TC." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            exp.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while running TC.", 
                                               "Please contact your System Administrator.", "Vetting","actionRunTc", exp);
        } finally {
            if(rsi!=null) {
                rsi.closeRowSetIterator();
            }
        }
        
        return null;
    }
    
    private void validateRunTCResponse(Object returnMsg) {
        String cols[] = returnMsg.toString().split("-");
        if("S".equals(cols[0])){
            showMsg = cols[1];
            
            RichPopup popup = (RichPopup) JSFUtils.findComponentInRoot("msgPopup"); 
            popup.show(new RichPopup.PopupHints());
            
        } else {
            AdfUtils.addFormattedFacesErrorMessage(cols[1] +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            logGenericTC(LogUtils.VALIDATION_ERROR, cols[1], 
                                                           "Please contact your System Administrator.", "Vetting","actionRunTc", null);
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

    public void openOwsApp()
    {
        try 
        {            
            StringBuffer sb = new StringBuffer();
            sb.append("var winPop = true;");
            sb.append("winPop = window.open(\"" +
                      getApplicationUrl()+"/"+ADFContext.getCurrent().getSessionScope().get("pFacesServlet")+"/Statusboard?BatchId=" + getTCReferenceAttribute("BatchId") + "&Status=" + getTCReferenceAttribute("CaseStatus") +
                      "\", \"_blank\"); ");
            ExtendedRenderKitService erks =
                Service.getRenderKitService(FacesContext.getCurrentInstance(), ExtendedRenderKitService.class);
            StringBuilder script = new StringBuilder();
            script.append(sb.toString());
            erks.addScript(FacesContext.getCurrentInstance(), script.toString());
        } catch (Exception e) {
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while running TC." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while running TC.", 
                                               "Please contact your System Administrator.", "Vetting","openOwsApp", e);
        }
    }
    
    public void fetchTcReferencesOws()
    {
        try 
        {
            ResetUtils.reset(tcReferencesTableBind);
                ADFContext.getCurrent().getSessionScope().put("UserId", Integer.parseInt(ADFContext.getCurrent().getSessionScope().get("UserId").toString()));
                ADFContext.getCurrent().getSessionScope().put("SessionId", (Integer) ADFContext.getCurrent().getSessionScope().get("SessionId"));

                getAm().initializeViewContextAGetData(filterClauseData,sortByColumnName );

            AdfFacesContext.getCurrentInstance().addPartialTarget(tcReferencesTableBind);
        } catch (Exception nfe) {
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching TC references." +
                                                 "Please contact your System Administrator." , 
                                                 "", FacesMessage.SEVERITY_ERROR);
            nfe.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while fetching TC references.", 
                                               "Please contact your System Administrator.", "Vetting","fetchTcReferencesOws", nfe);
        }
    }

    public void setTcReferencesTableBind(RichTable tcReferencesTableBind) {
        this.tcReferencesTableBind = tcReferencesTableBind;
    }

    public RichTable getTcReferencesTableBind() {
        return tcReferencesTableBind;
    }

    public void viewStatusPopupFetchListener(PopupFetchEvent popupFetchEvent) 
    {
        try
        {
            ResetUtils.reset(popupFetchEvent.getComponent());
            if(getTCReferenceAttribute("RequestId") == null || "".equals(getTCReferenceAttribute("RequestId")))
                hasRequestId = false;
            else 
                hasRequestId = true;
            
            //Full History
            fullHistoryLogic();
            
        }catch(Exception exp){
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching Status." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            exp.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while fetching Status.", 
                                               "Please contact your System Administrator.", "Vetting","viewStatusPopupFetchListener", exp);
        }
    }
    
    private void fullHistoryLogic() {
        ViewObject vwStatusVo = ADFUtils.findIterator("ViewHistoryOwsView1Iterator").getViewObject();
        vwStatusVo.setWhereClause(null);
        vwStatusVo.applyViewCriteria(null);
        //Full History
        vwStatusVo.setWhereClause(" MASTER_ID = "+getTCReferenceAttribute("MasterId")
                                  + " and nvl(ALIAS_ID,-99) = nvl("+getTCReferenceAttribute("AliasId")+",-99)"
                                  + " and nvl(XREF_ID,-99) = nvl("+getTCReferenceAttribute("XrefId")+",-99)");
        

        vwStatusVo.executeQuery();
    }

    public void setHasRequestId(boolean hasRequestId) {
        this.hasRequestId = hasRequestId;
    }

    public boolean isHasRequestId() {
        return hasRequestId;
    }

    public void viewHistoryTransactionOnlyValueChangeListener(ValueChangeEvent valueChangeEvent) {
        // Add event code here...
        ViewObject vwStatusVo = ADFUtils.findIterator("ViewHistoryOwsView1Iterator").getViewObject();
        
        if(Boolean.parseBoolean(valueChangeEvent.getNewValue().toString()) && valueChangeEvent.getNewValue() != null) {
            //Transaction History
            ViewCriteria vc = vwStatusVo.getViewCriteriaManager().getViewCriteria("ViewHistoryOwsViewCriteriaById");
            vwStatusVo.setWhereClause(null);
            vwStatusVo.applyViewCriteria(null);
            vc.ensureVariableManager().setVariableValue("p_request_id", getTCReferenceAttribute("RequestId"));
            vwStatusVo.applyViewCriteria(vc);
            vwStatusVo.executeQuery();
        } else {
            //Full History
            fullHistoryLogic();
        }
    }

    public String createAliasAction()
    {
        try{
            //T20220323.0033 - TC - says given name already exists for "nataly ko... (IRI) :: start
            Row currRow = ADFUtils.findIterator("DualCreateVettingVO1Iterator").getViewObject().getCurrentRow();
            String nameScreened = null;
            if(currRow != null)
                // tsuazo 08/21/2023
                //nameScreened = (String) currRow.getAttribute("TransNameScreenedUpdatable");
                nameScreened = currRow.getAttribute("TransNameScreenedUpdatable").toString();

            if(nameScreened == null){
                iriUtils.displayErrorMessage("Please enter Name Screened");
                return null;
            }
                
            ViewObject vo = ADFUtils.findIterator("AliasNameDuplicateCheckView1Iterator").getViewObject();
            vo.setNamedWhereClauseParam("pfullname", nameScreened);
            vo.setNamedWhereClauseParam("p_primary_master_id", getTCReferenceAttribute("PrimaryMasterId"));
            vo.executeQuery();
            Row row = vo.first();

            Integer count = 0;
            if (row != null)
                count = (Integer) row.getAttribute("NameCount");
            count = count == null ? 0 : count;
            System.out.println("count:" + count);
            if (count > 0) {
                iriUtils.displayErrorMessage("Given name already exists.");
                return null;
            }
            //T20220323.0033 - TC - says given name already exists for "nataly ko... (IRI) :: end
            
            OperationBinding cavOp = ADFUtils.findOperation("createAliasVetting");
            cavOp.execute();
            
            if(cavOp.getResult()!= null && cavOp.getResult().toString().equalsIgnoreCase("Y"))
            {
                createVettingPopup.hide();
                //T20220323.0025 - Issue with vettings being automatically check mark... (IRI)
                saveVettingCheckBoxSelections();
                fetchTcReferencesOws();
                AdfFacesContext.getCurrentInstance().addPartialTarget(tcReferencesTableBind);
                JSFUtils.addFormattedFacesErrorMessage("Alias created/updated successfully !", 
                                                       null, FacesMessage.SEVERITY_INFO);
            }
            else if(!"E".equals(cavOp.getResult()))
            {
                System.out.println("cavOp.getErrors() :: "+cavOp.getErrors());
                System.out.println("cavOp.getErrors() :: "+cavOp.getResult());
                JSFUtils.addFormattedFacesErrorMessage(cavOp.getResult() +
                                                       "", "",
                                                       FacesMessage.SEVERITY_ERROR);
            }
        }catch(Exception e){
            e.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while creating alias vetting." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            logGenericTC(LogUtils.ERROR, "System encountered an exception while creating alias vetting.", 
                                               "Please contact your System Administrator.", "Vetting","createAliasAction", e);
        }
        return null;
    }

    public String createAliasVettingAction()
    {
        RowSetIterator aliasRsi = null;
     
        LovVettingsNameScreenedViewImpl vo =
            (LovVettingsNameScreenedViewImpl) ADFUtils.findIterator("LovVettingsNameScreenedView1Iterator").getViewObject();
        vo.removeViewCriteria("LovVettingsNameScreenedSearch");
        vo.removeViewCriteria("LovVettingsNameScreenedViewCriteria");
        vo.removeViewCriteria("LovVettingsNameScreenedViewCriteria1");
        vo.setWhereClause(null);
        vo.executeEmptyRowSet();
        System.out.println("Vetting nameScreenContainVCL");
        
        try 
        {
            
            if(createVettingPopup != null)
                ResetUtils.reset(createVettingPopup);
                isVettingInfoValid = false;
            
            ADFContext.getCurrent().getPageFlowScope().put("P_FORM_CALLED", "alias");
            ViewObject dualVO = ADFUtils.findIterator("DualCreateVettingVO1Iterator").getViewObject();
            dualVO.clearCache();
            dualVO.executeQuery();
            
            Row currentRow = dualVO.first();
            
            System.out.println("createAlias TransNameScreened::"+ iriUtils.nullStrToSpc(currentRow.getAttribute("TransNameScreened")));
            System.out.println("createAlias TransAliasNameScreened::"+ iriUtils.nullStrToSpc(currentRow.getAttribute("TransAliasNameScreened")));
            System.out.println("createAlias TransNameScreenedUpdatable::"+ iriUtils.nullStrToSpc(currentRow.getAttribute("TransNameScreenedUpdatable")));
            
            Row  tcRow = ADFUtils.findIterator("TcReferencesView1Iterator").getViewObject().getCurrentRow();
            
            System.out.println("PrimaryMasterId: "+tcRow.getAttribute("PrimaryMasterId"));
            Integer masterId = (Integer) tcRow.getAttribute("PrimaryMasterId");
            
            boolean isNew = false;
            if(tcRow != null) {
                if(!iriUtils.nullStrToSpc(tcRow.getAttribute("NameScreened")).contains(" ") && "Yes".equals(tcRow.getAttribute("AffidavitFlag"))) {
                    JSFUtils.addFormattedFacesErrorMessage("Vetting was entered and confirmed as a single name vetting.  In order to create an additional name for this vetting, " +
                        "please contact trade compliance at IRI-Trade@Register-iri.com.", "",
                                                           FacesMessage.SEVERITY_ERROR);
                    return null;
                    
                }
                if(!"Alias".equals(tcRow.getAttribute("Alias"))){
                    //T20220119.0004 - TC 2.0 Party Master Cleanup
                    ViewObject lovVettingVO = ADFUtils.findIterator("LovVettingsNameScreenedView1Iterator").getViewObject();
			
		   // T20220629.0029 - CREATE ALIAS SLOWNESS --Commented below 2 lines of code as per Tony's Analysis of the issue
                   // lovVettingVO.applyViewCriteria(null);
                   // lovVettingVO.executeQuery();
		
                   // T20230607.0033  FA TC - Alias for Organization locking into Individual
                    /*	
                    ViewCriteria vc = lovVettingVO.getViewCriteriaManager().getViewCriteria("LovVettingsNameScreenedSearch");
                    lovVettingVO.setNamedWhereClauseParam("pFullName", iriUtils.nullStrToSpc(tcRow.getAttribute("NameScreened")));
                    lovVettingVO.setNamedWhereClauseParam("pIdentifier", tcRow.getAttribute("Identifier"));                    
                    lovVettingVO.setNamedWhereClauseParam("pEntityType", iriUtils.nullStrToSpc(tcRow.getAttribute("EntityType")));
                    lovVettingVO.setNamedWhereClauseParam("pSourceId", tcRow.getAttribute("SourceId"));
                    lovVettingVO.setNamedWhereClauseParam("pSourceTable", tcRow.getAttribute("SourceTable"));
                    System.out.println("LOV Query: "+lovVettingVO.getQuery());
                    System.out.println("LOV Query Rows: "+lovVettingVO.getEstimatedRowCount());
                    lovVettingVO.applyViewCriteria(vc);
                    lovVettingVO.executeQuery();
                    
                    System.out.println("NameScreened:"+iriUtils.nullStrToSpc(tcRow.getAttribute("NameScreened")));
                    System.out.println("Identifier:"+tcRow.getAttribute("Identifier"));
                    */
                    
                    // T20230607.0033	FA TC - Alias for Organization locking into Individual
                    // Updated LOV to return attributes from Master instead of Alias
                    // However, needed to create a new View Criteria for this part of the code
                    System.out.println("masterId: "+masterId);                    
                    ViewCriteria vc = lovVettingVO.getViewCriteriaManager().getViewCriteria("LovVettingsNameScreenedViewCriteria1");
                    vc.ensureVariableManager().setVariableValue("pMasterId", masterId);                    
                    lovVettingVO.applyViewCriteria(vc);                                                            
                    System.out.println("LOV Query: "+lovVettingVO.getQuery());
                    System.out.println("LOV Query Rows: "+lovVettingVO.getEstimatedRowCount());
                    lovVettingVO.executeQuery();
                    
                        
                    aliasRsi = lovVettingVO.createRowSetIterator(null);
                    
                        if(aliasRsi.hasNext()){
                            System.out.println("inside if");
                            Row row = aliasRsi.next();
                            
                            currentRow.setAttribute("TransDateOfBirth", row.getAttribute("Dob"));
                            currentRow.setAttribute("TransCityId", row.getAttribute("CityOfResidenceId"));
                            currentRow.setAttribute("TransCtznshpCntryCode", row.getAttribute("CitizenshipCountryCode"));
                            currentRow.setAttribute("TransIdType", row.getAttribute("IdType"));
                            currentRow.setAttribute("TransIdNumber", row.getAttribute("PassportNumber"));
                            currentRow.setAttribute("TransGender", row.getAttribute("Sex"));
                            currentRow.setAttribute("TransPassIssuCntryCode", row.getAttribute("PassportIssuingCountryCode"));
                            currentRow.setAttribute("TransResdnceCntryCode", row.getAttribute("CountryOfResidenceCode"));
                            currentRow.setAttribute("TransEntityType", row.getAttribute("EntityType"));
                            currentRow.setAttribute("TransId", row.getAttribute("Id"));
                            //currentRow.setAttribute("TransSeafarerId", row.getAttribute("Identifier"));
                            currentRow.setAttribute("TransResdnceCntryName", row.getAttribute("CountryOfResidenceName"));
                            currentRow.setAttribute("TransLegacyVettingFlag", row.getAttribute("LegacyVettingFlag"));
                            currentRow.setAttribute("TransIMONumber",row.getAttribute("ImoNumber"));
                            currentRow.setAttribute("TransOperationType", "C");
                            currentRow.setAttribute("TransCityName", row.getAttribute("CityName"));
                        }else {
                            isNew = true;
                            System.out.println("else 1");
                        }
                } else {
                    isNew = true;
                    System.out.println("else 2");
                }
            } else {
                isNew = true;
                System.out.println("else 3");
            }
            System.out.println("isNew:"+isNew);
            if(isNew) {
                currentRow.setAttribute("TransOperationType", "C");
                if("ENTITY".equals(RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TYPE"))){
                    if("VSSL_VESSELS".equals(RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TABLE")))
                        currentRow.setAttribute("TransEntityType", "VESSEL");
                    else
                        currentRow.setAttribute("TransEntityType", "INDIVIDUAL");
                }
                else
                    currentRow.setAttribute("TransEntityType", "INDIVIDUAL");
            }
            JSFUtils.showPopup(createVettingPopup, true);
            
        } catch (Exception e) {
            e.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while creating new alias vetting." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            logGenericTC(LogUtils.ERROR, "System encountered an exception while creating new alias vetting.", 
                                               "Please contact your System Administrator.", "Vetting","createAliasVettingAction", e);
        }finally {
            try {
                            if(aliasRsi != null) {
                                aliasRsi.closeRowSetIterator(); 
                            }
                       } catch (Exception e) {
                            // TODO: Add catch code
                            e.printStackTrace();
                        }
        }
        return null;
    }
    
    private Object getTCReferenceAttribute(String attrName) 
    {
        Object aliasId = null;
        
        try
        {
            JUCtrlHierNodeBinding ju = (JUCtrlHierNodeBinding) tcReferencesTableBind.getSelectedRowData();
            
            if(ju != null)
            {                
                Row row = ju.getRow();                
                return  row.getAttribute(attrName);
            }   
        }catch(Exception exp){
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching " +attrName+
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
             exp.printStackTrace();
             logGenericTC(LogUtils.ERROR, "System encountered an exception while fetching "+attrName, 
                                                "Please contact your System Administrator.", "Vetting","getTCReferenceAttribute", exp);
         }
        
        return aliasId;
    }
    
    public void dataPrivacyConsentPopupFetchListener(PopupFetchEvent popupFetchEvent)
    {
        try 
        {
            resetPopup("dataPrivacyConsent");
            ViewObject vo = ADFUtils.findIterator("DualCreateVettingVO1Iterator").getViewObject();
            vo.executeQuery();
            
            consentEdocId = null;
            OperationBinding fltrCnsntDtlOp = ADFUtils.findOperation("filterConsentDetailsVetting");
            fltrCnsntDtlOp.getParamsMap().put("masterId", getTCReferenceAttribute("MasterId"));
            fltrCnsntDtlOp.execute();
            setConsentDocLink(null);
            setConsentDocFileName(null);
            setViewConsentButtonVisible("N");
            if (fltrCnsntDtlOp.getResult() != null) {
                String ret = fltrCnsntDtlOp.getResult().toString();

                if (ret != "Online" && ret != "null") {
                    Integer edoc_id = Integer.parseInt(ret);
                    consentEdocId = edoc_id.toString();
                    List params = new ArrayList();
                    params.add(edoc_id.intValue());
                    ResultSet rs = iriUtils.getPlSqlFunctionData("select disk_path, file_name from iri_edocs where id=?", params);
                    if(rs.next()) {
                        
                        setConsentDocLink(rs.getString("disk_path"));
                        setConsentDocFileName(rs.getString("file_name"));

                        setUploadConsentDocVisible("Y");
                        setViewConsentButtonVisible("Y");
                    }
                    rs.close();
                }
                if (ret == "null") {
                    setUploadConsentDocVisible("Y");
                    setViewConsentButtonVisible("N");
                }
            }
            
            Row row = vo.getCurrentRow();
            if(row == null)
                row = vo.first();
            if(row != null) {
                loadOnlineConsentById(row.getAttribute("TransOnlineUploadedConsentEdocId"));
            }
        } catch (Exception nfe) {
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching consent details." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
            nfe.printStackTrace();
            logGenericTC(LogUtils.ERROR, "SSystem encountered an exception while fetching consent details.", 
                                               "Please contact your System Administrator.", "Vetting","dataPrivacyConsentPopupFetchListener", nfe);
        }
    }

    //T20211118.0028 - TC 2.0 - Online Consent
    private void loadOnlineConsentById(Object consentId) {
        try {
            setViewOnlineConsentButtonVisible("N");
            setOnlineConsentDocLink(null);
            setOnlineConsentDocFileName(null);
            
            List params = new ArrayList();
            params.add(consentId);
            ResultSet rs = iriUtils.getPlSqlFunctionData("select disk_path, file_name from iri_edocs where id=?", params);
            if(rs.next()) {
                
                setOnlineConsentDocLink(rs.getString("disk_path"));
                setOnlineConsentDocFileName(rs.getString("file_name"));
        
                setViewOnlineConsentButtonVisible("Y");
            }
            rs.close();
        } catch(Exception e) {
            e.printStackTrace();
        }
    }
    
    public void consentUploadFileVCL(ValueChangeEvent valueChangeEvent)
    {
        try
        {
            RichInputFile inputFileComponent = (RichInputFile) valueChangeEvent.getComponent();
            UploadedFile file = (UploadedFile) valueChangeEvent.getNewValue();
            
            if (valueChangeEvent.getNewValue() != null)
            {
                if (!file.getFilename().endsWith("pdf") && !file.getFilename().endsWith("PDF") && !file.getFilename().toLowerCase().endsWith("jpeg") && !file.getFilename().toLowerCase().endsWith("jpg") )
                {
                    inputFileComponent.resetValue();
                    inputFileComponent.setValid(false);
                    JSFUtils.addFormattedFacesErrorMessage("Please upload pdf or jpeg or jpg file", "", FacesMessage.SEVERITY_ERROR);
                }
                else
                {   
                    Row row = ADFUtils.findIterator("DualCreateVettingVO1Iterator").getCurrentRow();
                    
                    if(row.getAttribute("TransConsentEntityType") == null || "".equals(row.getAttribute("TransConsentEntityType"))){
                        inputFileComponent.resetValue();
                        JSFUtils.addFormattedFacesErrorMessage("Please select Entity Type." +
                                                         "" , 
                                                         "", FacesMessage.SEVERITY_ERROR);
                    }else{
                        uploadedFileStream = file.getInputStream();
                        selectedFileName = file.getFilename();
                    }
                }
            }
        } catch (Exception e) {
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading consent." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while uploading consent.", 
                                               "Please contact your System Administrator.", "Vetting","consentUploadFileVCL", e);
        }
    }
    
    public void dataPrivacyConsentDL(DialogEvent dialogEvent)
    {
        try 
        {
            String outcome = ((dialogEvent.getOutcome() != null) ? dialogEvent.getOutcome().toString() : "N");
            System.out.println("dataPrivacyConsentDL:consentEdocId:"+consentEdocId);
            if (outcome.equalsIgnoreCase("ok") || outcome.equalsIgnoreCase("save")) {
                
                Row row = ADFUtils.findIterator("DualCreateVettingVO1Iterator").getCurrentRow();
                
                //T20230427.0021 - TC - FA - online DPCF codes (IRI)
                
                if(row.getAttribute("TransOnlineConfirmationNumberVerify") == null && row.getAttribute("TransOnlineConfirmationNumber") != null) {
                    OperationBinding ob = ADFUtils.findOperation("updateOnlineConsent");
                    Map map = ob.getParamsMap();
                    map.put("sourceId",getTCReferenceAttribute("SourceId"));
                    map.put("consentId", row.getAttribute("TransOnlineConfirmationNumber"));
                    map.put("masterId",getTCReferenceAttribute("MasterId"));
                    map.put("aliasId",getTCReferenceAttribute("AliasId"));
                    map.put("xrefId",getTCReferenceAttribute("XrefId"));
                    String st=(String)ob.execute();
                    row.setAttribute("TransSourceId",getTCReferenceAttribute("SourceId"));
                    if("S".equals(st)) {
                        JSFUtils.addFormattedFacesErrorMessage("Online consent successfully updated !",
                                                               "",
                                                               FacesMessage.SEVERITY_INFO);
                    }
                    
                } else {
                    if(row.getAttribute("TransConsentEntityType") == null || "".equals(row.getAttribute("TransConsentEntityType")))
                                        JSFUtils.addFormattedFacesErrorMessage("Please select Entity Type." +
                                                                     "" , 
                                                                     "", FacesMessage.SEVERITY_ERROR);
                    else if(row.getAttribute("TransUploadedConsentStartDate") == null || "".equals(row.getAttribute("TransUploadedConsentStartDate")))
                        JSFUtils.addFormattedFacesErrorMessage("Please enter Consent Start Date." +
                                                         "" , 
                                                         "", FacesMessage.SEVERITY_ERROR);
                    else if(row.getAttribute("TransUploadedConsentEndDate") == null || "".equals(row.getAttribute("TransUploadedConsentEndDate")))
                        JSFUtils.addFormattedFacesErrorMessage("Please enter Consent End Date." +
                                                     "" , 
                                                     "", FacesMessage.SEVERITY_ERROR);
                    else {
                        
                        String entityName = row.getAttribute("TransConsentEntityType").toString();
                        System.out.println("uploadFileStream:"+uploadedFileStream);
                        if(uploadedFileStream != null) {
                            OperationBinding ob = ADFUtils.findOperation("uploadDocument");
                            ob.getParamsMap().put("entityName", entityName);
                            ob.getParamsMap().put("fileName", selectedFileName);
                            String path = ob.execute().toString();
                            
                            // T20221005.0018 - TC - FA - DPCF not in OWS but is in Oracle                            
                            
                            if (path != null && path.length() > 0){ 
                                String[] col = path.split("---");
                                consentEdocId = col[0];
                                
                                System.out.println("Vetting Upload Path :"+col[1]);
                                
                                IRIUtils.uploadFile(uploadedFileStream, col[1]);
                            }
                        }
                            
                            System.out.println("consentEdocId:"+consentEdocId);
                        
                            OperationBinding crtCnsntOp = ADFUtils.findOperation("createConsentVetting");
                            crtCnsntOp.getParamsMap().put("masterId", getTCReferenceAttribute("MasterId"));
                            crtCnsntOp.getParamsMap().put("aliasId", getTCReferenceAttribute("AliasId"));
                            crtCnsntOp.getParamsMap().put("xrefId", getTCReferenceAttribute("XrefId"));
                            crtCnsntOp.getParamsMap().put("consentEdocId", consentEdocId);
                            crtCnsntOp.execute();
                                                    
                            
                            if (crtCnsntOp.getErrors().isEmpty()) {
                                dataPrivacyConsentPopup.hide();
                                OperationBinding saveOp = ADFUtils.findOperation("Commit");
                                saveOp.execute();
                                JSFUtils.addFormattedFacesErrorMessage("Consent successfully updated !",
                                                                       "",
                                                                       FacesMessage.SEVERITY_INFO);
                            } else {
                                JSFUtils.addFormattedFacesErrorMessage("There has been some error calling createConsentVetting method :: ",
                                                                       crtCnsntOp.getErrors().toString(),
                                                                       FacesMessage.SEVERITY_ERROR);
                                logGenericTC(LogUtils.VALIDATION_ERROR, "There has been some error calling createConsentVetting method :: "+ crtCnsntOp.getErrors().toString(), 
                                                                   "Please contact your System Administrator.", "Vetting","dataPrivacyConsentDL", null);
                            }
                            uploadedFileStream = null;
                            selectedFileName = null;
                        
                    }
                }
            }
        } catch (Exception e) {
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while adding consent." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while adding consent.", 
                                               "Please contact your System Administrator.", "Vetting","dataPrivacyConsentDL", e);
            uploadedFileStream = null;
            selectedFileName = null;
        }
    }

    public void setConsentDocLink(String consentDocLink) {
        this.consentDocLink = consentDocLink;
    }

    public String getConsentDocLink() {
        return consentDocLink;
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

    public void setDataPrivacyConsentPopup(RichPopup dataPrivacyConsentPopup) {
        this.dataPrivacyConsentPopup = dataPrivacyConsentPopup;
    }

    public RichPopup getDataPrivacyConsentPopup() {
        return dataPrivacyConsentPopup;
    }

    public void crossReferencesPopupFetchListener(PopupFetchEvent popupFetchEvent)
    {
        try
        {
            ViewObject vwCrossRefVo = ADFUtils.findIterator("CrossReferencesOwsView1Iterator").getViewObject();
            vwCrossRefVo.setNamedWhereClauseParam("pSourceId", getTCReferenceAttribute("SourceId"));
            vwCrossRefVo.executeQuery();
        }catch(Exception exp){
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching Cross References." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            exp.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while fetching Cross References.", 
                                               "Please contact your System Administrator.", "Vetting","crossReferencesPopupFetchListener", exp);
        }
    }
    /* Commented the below method and created new method selectAllVettingsVCL instead
     * T20220322.0004 - TC 2.0 - Select All Issue (IRI)
    public void selectAllCheckRows(ClientEvent clientEvent) {
        // Add event code here...
        Object value = clientEvent.getParameters().get("checkBoxValue");
        System.out.println("selectAllCheckRows value:"+value);
        if(value != null) {
            try 
            {
                    String tcExcluded = null;
                    
                    if ("true".equals(value)) 
                        tcExcluded = "Y";
                    else if ("false".equals(value)) 
                        tcExcluded = "N";
                    
                        
                    if(tcExcluded != null)
                    {
                        OperationBinding updateMasterOp = ADFUtils.findOperation("selectMultipleVettings");
                        updateMasterOp.getParamsMap().put("tcExcluded", tcExcluded);
                        updateMasterOp.execute();
                    }
                
            } catch (Exception e) {
                JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while selecting vettings." +
                                                       "Please contact your System Administrator.", "",
                                                       FacesMessage.SEVERITY_ERROR);
                e.printStackTrace();
                LogUtils.logGenericTC(getAm(),LogUtils.ERROR, "System encountered an exception while selecting vettings.", 
                                                   "Please contact your System Administrator.", "Vetting","selectAllCheckRows", e);
            }
        }
    } */

    public void caseNotesPopupFetchListener(PopupFetchEvent popupFetchEvent)
    {
        try
        {
            ViewObject caseNotesVo = ADFUtils.findIterator("CaseNotesView1Iterator").getViewObject();
            caseNotesVo.setNamedWhereClauseParam("pMasterId", getTCReferenceAttribute("MasterId"));
            caseNotesVo.setNamedWhereClauseParam("pAliasId", getTCReferenceAttribute("AliasId"));
            caseNotesVo.setNamedWhereClauseParam("pXrefId", getTCReferenceAttribute("XrefId"));
            caseNotesVo.executeQuery();
        }catch(Exception exp){
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching Case Notes." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            exp.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while fetching Case Notes.", 
                                               "Please contact your System Administrator.", "Vetting","caseNotesPopupFetchListener", exp);
        }
    }

    public void caseDocumentsPopupFetchListener(PopupFetchEvent popupFetchEvent)
    {
        try
        {
            ViewObject caseDocumentsVo = ADFUtils.findIterator("CaseDocumentsView1Iterator").getViewObject();
            caseDocumentsVo.setNamedWhereClauseParam("pMasterId", getTCReferenceAttribute("MasterId"));
            caseDocumentsVo.setNamedWhereClauseParam("pAliasId", getTCReferenceAttribute("AliasId"));
            caseDocumentsVo.setNamedWhereClauseParam("pXrefId", getTCReferenceAttribute("XrefId"));
            caseDocumentsVo.executeQuery();
        }catch(Exception exp){
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching Case Documents." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            exp.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while fetching Case Documents.", 
                                               "Please contact your System Administrator.", "Vetting","caseDocumentsPopupFetchListener", exp);
        }
    }

    public String actionUpdateCityCountry()
    {
        try
        {
            System.out.println("::::actionUpdateCityCountry::::");
            OperationBinding updCcOp = ADFUtils.findOperation("updateCountryCity");
            updCcOp.getParamsMap().put("masterId", getTCReferenceAttribute("MasterId"));
            updCcOp.getParamsMap().put("aliasId", getTCReferenceAttribute("AliasId"));
            updCcOp.getParamsMap().put("xrefId", getTCReferenceAttribute("XrefId"));
            updCcOp.execute();
            System.out.println("Result:"+updCcOp.getResult());
            if (updCcOp.getResult() != null && updCcOp.getResult().toString().equalsIgnoreCase("Y"))
            {
                //T20220323.0025 - Issue with vettings being automatically check mark... (IRI)
                saveVettingCheckBoxSelections();
                fetchTcReferencesOws();
                AdfFacesContext.getCurrentInstance().addPartialTarget(tcReferencesTableBind);
                JSFUtils.addFormattedFacesErrorMessage("City/Country updated successfully !", null,
                                                       FacesMessage.SEVERITY_INFO);
            } 
            else
            {
                JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while updating City/Country." +
                                                       "Please contact your System Administrator.", "",
                                                       FacesMessage.SEVERITY_ERROR);
            }
        }catch(Exception exp){
            exp.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while updating City/Country." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            logGenericTC(LogUtils.ERROR, "System encountered an exception while updating City/Country.", 
                                               "Please contact your System Administrator.", "Vetting","actionUpdateCityCountry", exp);
            
        }
        return null;
    }

    public void updateCityCountryDL(DialogEvent dialogEvent)
    {
        try
        {
            if(dialogEvent.getOutcome() != null && (dialogEvent.getOutcome().toString().equalsIgnoreCase("Update")
                || dialogEvent.getOutcome().toString().equalsIgnoreCase("Ok")))
            {
                OperationBinding updCcOp = ADFUtils.findOperation("updateCountryCity");
                updCcOp.getParamsMap().put("masterId", getTCReferenceAttribute("MasterId"));
                updCcOp.getParamsMap().put("aliasId", getTCReferenceAttribute("AliasId"));
                updCcOp.getParamsMap().put("xrefId", getTCReferenceAttribute("XrefId"));
                updCcOp.execute();
                
                if(updCcOp.getResult()!= null && updCcOp.getResult().toString().equalsIgnoreCase("Y"))
                {
                    updateCityCountryPopup.hide();
                    //T20220323.0025 - Issue with vettings being automatically check mark... (IRI)
                    saveVettingCheckBoxSelections();
                    fetchTcReferencesOws();
                    AdfFacesContext.getCurrentInstance().addPartialTarget(tcReferencesTableBind);
                    JSFUtils.addFormattedFacesErrorMessage("Country/City updated successfully !", 
                                                           null, FacesMessage.SEVERITY_INFO);
                }
                else
                {
                    JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while updating Country/City." +
                                                           "Please contact your System Administrator.", "",
                                                           FacesMessage.SEVERITY_ERROR);
                    logGenericTC(LogUtils.VALIDATION_ERROR, "System encountered an exception while updating Country/City.", 
                                                       "Please contact your System Administrator.", "Vetting","updateCityCountryDL", null);
                }
            }
        }catch(Exception exp){
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while updating Country/City." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            exp.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while updating Country/City.", 
                                               "Please contact your System Administrator.", "Vetting","updateCityCountryDL", exp);
        }
    }

    public void setUpdateCityCountryPopup(RichPopup updateCityCountryPopup) {
        this.updateCityCountryPopup = updateCityCountryPopup;
    }

    public RichPopup getUpdateCityCountryPopup() {
        return updateCityCountryPopup;
    }


    public void consentStartDateValidator(FacesContext facesContext, UIComponent uIComponent, Object object)
    {
        long millis = System.currentTimeMillis();
        java.util.Date date1 = null;
        java.util.Date date2 = null;
        java.sql.Date date = new java.sql.Date(millis);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        try {
            date1 = sdf.parse(object.toString());
            date2 = sdf.parse(date.toString());
        } catch (ParseException pce) {
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while validating Consent start date." +
                                                      "Please contact your System Administrator.", "",
                                                      FacesMessage.SEVERITY_ERROR);
            pce.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while validating Consent start date.", 
                                               "Please contact your System Administrator.", "Vetting","consentStartDateValidator", pce);
        }
        int countfnd = date1.compareTo(date2);
        
        if (countfnd > 0) {
            logGenericTC(LogUtils.VALIDATION_ERROR, "Consent start date can not be greater than current date.", 
                                               "Please contact your System Administrator.", "Vetting","consentStartDateValidator", null);
            throw new ValidatorException(new FacesMessage(FacesMessage.SEVERITY_ERROR,
                                                          "Consent start date can not be greater than current date.", null));
        }
    }


    public String actionOpenStatusBoard() {
        if(getTCReferenceAttribute("BatchId") == null || "".equals(getTCReferenceAttribute("BatchId"))){
            JSFUtils.addFormattedFacesErrorMessage("Click 'Run TC' to generate BatchId." +
                                                   "Then click 'Statusboard'", "",
                                                   FacesMessage.SEVERITY_ERROR);
            logGenericTC(LogUtils.VALIDATION_ERROR, "Click 'Run TC' to generate BatchId.", 
                                               "Please contact your System Administrator.", "Vetting","actionOpenStatusBoard", null);
        }else
            openOwsApp();
        return null;
    }

    public void runTcDialogListener(DialogEvent dialogEvent)
    {
        try
        {            
            if(dialogEvent.getOutcome() != null && dialogEvent.getOutcome().toString().equalsIgnoreCase("Yes"))
            {
                System.out.println("dialogEvent.getOutcome() :: "+dialogEvent.getOutcome());
                /*T20220323.0025 - Issue with vettings being automatically check mark... (IRI)
                 *Commented the below code and moved to seperate method
                OperationBinding runTcOp = ADFUtils.findOperation("callRunTc");
                runTcOp.getParamsMap().put("affidavitFlag", affidavitReceived);
                runTcOp.getParamsMap().put("documentType", (PRVFT)? "PRVFT" : null);
                Object msg = runTcOp.execute();
                validateRunTCResponse(msg);
                */
                //T20220323.0025 - Issue with vettings being automatically check mark... (IRI)
                if(("AR_CUSTOMERS".equals(RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TABLE"))) || ("CORP_MAIN".equals(RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TABLE")))){
                    JSFUtils.showPopup(runTCSummaryPopup, true);
                }else{
                    this.callRunTc();
                }
            }
        }catch(Exception exp){
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while running TC." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            exp.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while running TC.", 
                                               "Please contact your System Administrator.", "Vetting","runTcDialogListener", exp);
        }
    }

    public void setRunTcConfirmationPopupBinding(RichPopup runTcConfirmationPopupBinding) {
        this.runTcConfirmationPopupBinding = runTcConfirmationPopupBinding;
    }

    public RichPopup getRunTcConfirmationPopupBinding() {
        return runTcConfirmationPopupBinding;
    }

    public void caseDocDownloadListener(FacesContext facesContext, OutputStream outputStream) {
        // Add event code here...
        String diskPath = ADFUtils.findIterator("CaseDocumentsView1Iterator").getCurrentRow().getAttribute("DiskPath").toString();
        System.out.println("caseDocDownloadListener:diskPath:"+diskPath);
        iriUtils.downloadFile(diskPath, outputStream);

    }
    
    public void consentDownloadListener(FacesContext facesContext, OutputStream outputStream) {
        // Add event code here...
        iriUtils.downloadFile(getConsentDocLink(), outputStream);
    }
    
    public void onlineConsentDownloadListener(FacesContext facesContext, OutputStream outputStream) {
        // Add event code here...
        iriUtils.downloadFile(getOnlineConsentDocLink(), outputStream);
    }
    
    //T20220207.0054 - TC 2.0 - TC Name Check Validation
    private int hasRecordInOFACORBlockedList(Object name) {
        //T20211215.0029 - Create Vetting Popup changes    
        int ch = 0;
        if(name != null) {
            ViewObject vo = ADFUtils.findIterator("GetIsOfacABlockedFlagsView1Iterator").getViewObject();
            vo.setNamedWhereClauseParam("textName", name);
            vo.executeQuery();
            if(vo.hasNext()) {
                System.out.println("inside ofac or block");
                Row row = vo.next();
                if("Y".equals(row.getAttribute("IsOfac")))
                    ch = 1;
                else if("Y".equals(row.getAttribute("IsBlocked")))
                    ch = 2;
            }
        }
        
        AdfFacesContext.getCurrentInstance().addPartialTarget(JSFUtils.findComponentInRoot("pgl13"));
        AdfFacesContext.getCurrentInstance().addPartialTarget(JSFUtils.findComponentInRoot("pgl2"));
       
        UserRespAndSessionInfo userRespAndSessionInfo = (UserRespAndSessionInfo) JSFUtils.getManagedBeanValue("sessionScope.UserRespAndSessionInfo");
        if(ch == 1) {
            if(userRespAndSessionInfo != null) {
                if("Y".equals(userRespAndSessionInfo.getIsSuperUserOnly())){
                    iriUtils.displayWarningMessage("Given Name is in OFAC list.");
                    return 0;
                } else {
                    iriUtils.displayErrorMessage("Given Name is in OFAC list.");
                    return 1;
                }
            }else {
                iriUtils.displayErrorMessage("Given Name is in OFAC list.");
                return 1;
            }
        } else if(ch == 2) {
            if(userRespAndSessionInfo != null) {
                if("Y".equals(userRespAndSessionInfo.getIsSuperUserOnly())){
                    iriUtils.displayWarningMessage("Given Name is in Blocked list.");
                    return 0;
                } else {
                    iriUtils.displayErrorMessage("Given Name is in Blocked list.");
                    return 1;
                }
            }else {
                iriUtils.displayErrorMessage("Given Name is in Blocked list.");
                return 1;
            }
        }
        return ch;
    }
    
    
    private boolean hasName(String name) {
        ViewObject vo = ADFUtils.findIterator("LovVettingsNameScreenedRestrictedView1Iterator").getViewObject();
        vo.setNamedWhereClauseParam("pFullName", null);
        ViewCriteria vc = vo.getViewCriteriaManager().getViewCriteria("LovVettingsNameScreenedWithOutPrimaryViewCriteria");
        vo.applyViewCriteria(null);
        vo.executeQuery();
        vo.setNamedWhereClauseParam("pFullName", name);
        vo.applyViewCriteria(vc);
        vo.executeQuery();
        boolean flag=false;
        while(vo.hasNext()) {
            Row row = vo.next();
            System.out.println("fullname:"+row.getAttribute("FullName"));
            if(name.trim().equalsIgnoreCase(row.getAttribute("FullName").toString().trim())) {
                flag = true;
                break;
            }
        }
        System.out.println("flag:"+flag);
        return flag;
    }
    
    public void oneSave() 
            {
            // Add event code here...
           
                    Row masterRow = ADFUtils.findIterator("TcReferencesView1Iterator").getCurrentRow();
                    Row row = ADFUtils.findIterator("LovVettingsNameScreenedView1Iterator").getViewObject().getCurrentRow();
                    if(row != null) 
                    {
                        //isVettingInfoValid = false;
                        ViewObject dualVO = ADFUtils.findIterator("DualCreateVettingVO1Iterator").getViewObject();
                        Row currentRow = dualVO.first();
                        //T20211119.0065 - RE: TSAKOS SHIPPING AND TRADING S A    
                        currentRow.setAttribute("TransNameScreened", row.getAttribute("FullName"));
                        currentRow.setAttribute("TransDateOfBirth", row.getAttribute("Dob"));
                        currentRow.setAttribute("TransCityId", row.getAttribute("CityOfResidenceId"));
                        currentRow.setAttribute("TransCtznshpCntryCode", row.getAttribute("CitizenshipCountryCode"));
                        currentRow.setAttribute("TransIdType", row.getAttribute("IdType"));
                        currentRow.setAttribute("TransIdNumber", row.getAttribute("PassportNumber"));
                        currentRow.setAttribute("TransGender", row.getAttribute("Sex"));
                        currentRow.setAttribute("TransPassIssuCntryCode", row.getAttribute("PassportIssuingCountryCode"));
                        currentRow.setAttribute("TransResdnceCntryCode", row.getAttribute("CountryOfResidenceCode"));
                        currentRow.setAttribute("TransEntityType", row.getAttribute("EntityType"));
                        currentRow.setAttribute("TransNameScreenedUpdatable", row.getAttribute("FullName"));
                        currentRow.setAttribute("TransResdnceCntryName", row.getAttribute("CountryOfResidenceName"));
                        
                        currentRow.setAttribute("TransIMONumber",row.getAttribute("ImoNumber"));
                        currentRow.setAttribute("TransRelationshipType",row.getAttribute("RelationshipType"));
                        currentRow.setAttribute("TransCityName", row.getAttribute("CityName"));
                        
                        currentRow.setAttribute("TransLegacyVettingFlag", row.getAttribute("LegacyVettingFlag"));
                        currentRow.setAttribute("TransEastAsianOriginName", row.getAttribute("EastAsianOriginName"));
                        currentRow.setAttribute("TransOperationType", "C");
                        currentRow.setAttribute("TransId", row.getAttribute("Id"));
                        
                        //T20211208.0024 - Duplication for create vetting in DEV                    
                        //T20220123.0015 - Need assistance with vessel vetting for Star Ranger
                        currentRow.setAttribute("TransSourceTableColumn", RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TABLE_COLUMN"));
                        currentRow.setAttribute("TransSourceTable", RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TABLE"));
                        currentRow.setAttribute("TransSourceId", RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_ID"));

                        //T20211215.0029 - Create Vetting Popup changes
                        //isVettingInfoValid = false;    
                        AdfFacesContext.getCurrentInstance().addPartialTarget(JSFUtils.findComponentInRoot("pgl13"));
                        AdfFacesContext.getCurrentInstance().addPartialTarget(JSFUtils.findComponentInRoot("pgl2"));
                        
                        RichPopup onschpup = (RichPopup) JSFUtils.findComponentInRoot("onschpup");
                        onschpup.hide();
                    }
            
        }
            
        public void oneClose()
        {
            try {
                RichPopup onschpup = (RichPopup) JSFUtils.findComponentInRoot("onschpup");
                onschpup.hide();
        
                ViewObject vo = ADFUtils.findIterator("DualCreateVettingVO1Iterator").getViewObject();
                Row row = vo.getCurrentRow();
                if(row == null) 
                    row = vo.first();
                Object nameScreened = row.getAttribute("TransNameScreenedUpdatable");
                resetToNewRow();
                row = ADFUtils.findIterator("DualCreateVettingVO1Iterator").getViewObject().getCurrentRow();
                if(row == null) 
                    row = vo.first();
                row.setAttribute("TransNameScreenedUpdatable", nameScreened);
                //T20220123.0015 - Need assistance with vessel vetting for Star Ranger (IRI)
                row.setAttribute("TransOperationType", "C");
                //T20211208.0024 - Duplication for create vetting in DEV
                row.setAttribute("TransSourceTableColumn", RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TABLE_COLUMN"));
                row.setAttribute("TransSourceTable", RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TABLE"));
                row.setAttribute("TransSourceId", RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_ID"));

                        
                if(createVettingPopup != null)
                    ResetUtils.reset(createVettingPopup);
                
                //T20211215.0029 - Create Vetting Popup changes        
                //isVettingInfoValid = false;
                AdfFacesContext.getCurrentInstance().addPartialTarget(JSFUtils.findComponentInRoot("pgl13"));
                AdfFacesContext.getCurrentInstance().addPartialTarget(JSFUtils.findComponentInRoot("pgl2"));
    } catch (Exception e) {
        // TODO: Add catch code
        e.printStackTrace();
    }
        }
            
        public void noSave() 
        {
            RichPopup nschpup = (RichPopup) JSFUtils.findComponentInRoot("nschpup");
            nschpup.hide();  
            
            //T20211208.0024 - Duplication for create vetting in DEV
            ViewObject vo = ADFUtils.findIterator("DualCreateVettingVO1Iterator").getViewObject();
            Row currentRow = vo.getCurrentRow();
            if(currentRow == null) 
                currentRow = vo.first();
            
            if(currentRow != null) {
                //T20220123.0015 - Need assistance with vessel vetting for Star Ranger (IRI)
                currentRow.setAttribute("TransOperationType", "C");
                currentRow.setAttribute("TransSourceTableColumn", RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TABLE_COLUMN"));
                currentRow.setAttribute("TransSourceTable", RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TABLE"));
                currentRow.setAttribute("TransSourceId", RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_ID"));

            }
            
            //T20211215.0029 - Create Vetting Popup changes
            //isVettingInfoValid = false;
            AdfFacesContext.getCurrentInstance().addPartialTarget(JSFUtils.findComponentInRoot("pgl13"));
            AdfFacesContext.getCurrentInstance().addPartialTarget(JSFUtils.findComponentInRoot("pgl2"));
        
        }
            
            public void noclose()
            {
        try {
            RichPopup nschpup = (RichPopup) JSFUtils.findComponentInRoot("nschpup");
            nschpup.hide();
           
            resetToNewRow();
            
            if(createVettingPopup != null)
                ResetUtils.reset(createVettingPopup);
            
            //T20211215.0029 - Create Vetting Popup changes
            isVettingInfoValid = true;
            AdfFacesContext.getCurrentInstance().addPartialTarget(JSFUtils.findComponentInRoot("pgl13"));
            AdfFacesContext.getCurrentInstance().addPartialTarget(JSFUtils.findComponentInRoot("pgl2"));
            
        } catch (Exception e) {
            // TODO: Add catch code
            e.printStackTrace();
        }
            }
    
    public void nameScreenedCustomSearchActionListener(ActionEvent actionEvent) {
        // Add event code here...
        
        System.out.println("Vetting nameScreenedCustomSearchActionListener");
        
        RichInputText txt = (RichInputText) JSFUtils.findComponentInRoot("it3"); 
        
        if (txt.getValue() != null) {
            nameScreenedSearchStr = (String) txt.getValue();
        }

        if(nameScreenedSearchStr == null || "".equals(nameScreenedSearchStr))
            
        {
            System.out.println("Vetting nameScreenedCustomSearchActionListener");
            
            LovVettingsNameScreenedViewImpl lvo =
                (LovVettingsNameScreenedViewImpl) ADFUtils.findIterator("LovVettingsNameScreenedView1Iterator").getViewObject();        
            ViewCriteria vc = lvo.getViewCriteriaManager().getViewCriteria("LovVettingsNameScreenedViewCriteria");            
            lvo.executeEmptyRowSet();
            RichTable tab = (RichTable) JSFUtils.findComponentInRoot("t4");             
            AdfFacesContext.getCurrentInstance().addPartialTarget(tab);
            
            return;
        }
        
        // T20220412.0031  vetting creation error (IRI)
        // TSUAZO -- Need to fix nameScreenedSearchStr containing apostrophe in the value
        
        // tsuazo 08/21/22023
        //RMIManualTradeComplianceAppModuleImpl amImpl = (RMIManualTradeComplianceAppModuleImpl) ADFUtils.getApplicationModuleForDataControl("RMIManualTradeComplianceAppModuleDataControl");
        AppModuleImpl amImpl = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
        Statement datasource = amImpl.getDBTransaction().createStatement(0);
        
        String sqlQuery = "SELECT TRIM(XWRL_UTILS.CLEANSE_NAME(UPPER(?))) clean_name FROM DUAL";
        String cleanName = null;
        
        
        try {
            Connection connection = datasource.getConnection();
            PreparedStatement statement = connection.prepareStatement(sqlQuery);
            statement.setString(1, nameScreenedSearchStr);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                cleanName = resultSet.getString("clean_name");
            }
            
            //resultSet.close();
            //statement.close();
            //connection.close();
            
            System.out.println("nameScreenContainVCL ParameterValue:"+cleanName);
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        
        //T20220218.0020 - FW: "Advanced" Search function
        StringBuilder sql = new StringBuilder();
        //sql.append("XWRL_UTILS.CLEANSE_NAME(UPPER(Full_name)) ");        
        sql.append("Full_name ");        
        switch(selectedAdvFilter) {
        case "STARTS_WITH":
            sql.append(" LIKE ");
            sql.append(" UPPER('");
            sql.append(cleanName);
            sql.append("') || '%'");
            break;
        case "ENDS_WITH":
            sql.append(" LIKE ");
            sql.append("'%' || UPPER('");
            sql.append(cleanName);
            sql.append("')");
            break;
        case "EQUALS":
            sql.append(" = ");
            sql.append(" UPPER('");
            sql.append(cleanName);
            sql.append("')");
            break;
        case "DOES_NOT_EQUAL":
            sql.append(" <> ");
            sql.append(" UPPER('");
            sql.append(cleanName);
            sql.append("')");
            break;
            case "CONTAINS":
                sql.append(" LIKE ");        
                //sql.append(" '%' || REPLACE(XWRL_UTILS.CLEANSE_NAME(UPPER('");
                //sql.append(cleanName);
                //sql.append("')),' ','%') || '%'");
                //T20220412.0031  vetting creation error (IRI)
                sql.append("'%");
                sql.append(cleanName);
                sql.append("%'");
                break;
            case "DOES_NO_CONTAIN":
                sql.append(" NOT LIKE ");
                //sql.append(" '%' || REPLACE(XWRL_UTILS.CLEANSE_NAME(UPPER('");
                //sql.append(cleanName);
                //sql.append("')),' ','%') || '%'");
                //T20220412.0031  vetting creation error (IRI)
                sql.append("'%");
                sql.append(cleanName);
                sql.append("%'");
                break;
        }
        
        LovVettingsNameScreenedViewImpl vo =
                    (LovVettingsNameScreenedViewImpl) ADFUtils.findIterator("LovVettingsNameScreenedView1Iterator").getViewObject();
        ViewCriteria vc = vo.getViewCriteriaManager().getViewCriteria("LovVettingsNameScreenedViewCriteria");
        vo.applyViewCriteria(vc);                                                            
        vc.ensureVariableManager().setVariableValue("pFullName", cleanName);   
                
        if("-".equals(selectedAdvFilter))
            vo.setWhereClause(null);
        else
            vo.setWhereClause(sql.toString());
        
        vo.executeQuery();      
        
    }
    
    public void nameScreenedTxtSearchDialogListener(DialogEvent dialogEvent) {
            // Add event code here...
            String outcome = ((dialogEvent.getOutcome() != null) ? dialogEvent.getOutcome().toString() : "N");
            System.out.println("nameScreenedTxtSearchDialogListener:"+outcome);
            if (outcome.equalsIgnoreCase("ok") || outcome.equalsIgnoreCase("save")) {
                
                Row row = ADFUtils.findIterator("LovVettingsNameScreenedView1Iterator").getViewObject().getCurrentRow();
                System.out.println("Row dialog listener:"+row);
                if(row != null) {
                    
                    
                    //T20220207.0054 - TC 2.0 - TC Name Check Validation
                    int ch = hasRecordInOFACORBlockedList(row.getAttribute("FullName"));
                    if(ch == 0)
                        isVettingInfoValid = false;
                    else {
                        isVettingInfoValid = true;
                        return;
                    }
                    
                    if(hasName(iriUtils.nullStrToSpc(row.getAttribute("FullName")))) {
                        isVettingInfoValid = true;
                        AdfFacesContext.getCurrentInstance().addPartialTarget(JSFUtils.findComponentInRoot("pgl13"));
                        AdfFacesContext.getCurrentInstance().addPartialTarget(JSFUtils.findComponentInRoot("pgl2"));
                        iriUtils.displayErrorMessage("Name already exists in association with this record.");
                    } else {
                        ViewObject dualVO = ADFUtils.findIterator("DualCreateVettingVO1Iterator").getViewObject();
                        Row currentRow = dualVO.first();
                        //T20211119.0065 - RE: TSAKOS SHIPPING AND TRADING S A                
                        currentRow.setAttribute("TransNameScreened", row.getAttribute("FullName"));
                        currentRow.setAttribute("TransDateOfBirth", row.getAttribute("Dob"));
                        currentRow.setAttribute("TransCityId", row.getAttribute("CityOfResidenceId"));
                        currentRow.setAttribute("TransCtznshpCntryCode", row.getAttribute("CitizenshipCountryCode"));
                        currentRow.setAttribute("TransIdType", row.getAttribute("IdType"));
                        currentRow.setAttribute("TransIdNumber", row.getAttribute("PassportNumber"));
                        currentRow.setAttribute("TransGender", row.getAttribute("Sex"));
                        currentRow.setAttribute("TransPassIssuCntryCode", row.getAttribute("PassportIssuingCountryCode"));
                        currentRow.setAttribute("TransResdnceCntryCode", row.getAttribute("CountryOfResidenceCode"));
                        currentRow.setAttribute("TransEntityType", row.getAttribute("EntityType"));
                        currentRow.setAttribute("TransNameScreenedUpdatable", row.getAttribute("FullName"));
                        currentRow.setAttribute("TransResdnceCntryName", row.getAttribute("CountryOfResidenceName"));
                        
                        currentRow.setAttribute("TransIMONumber",row.getAttribute("ImoNumber"));
                        currentRow.setAttribute("TransRelationshipType",row.getAttribute("RelationshipType"));
                        currentRow.setAttribute("TransCityName", row.getAttribute("CityName"));
                        
                        currentRow.setAttribute("TransLegacyVettingFlag", row.getAttribute("LegacyVettingFlag"));
                        currentRow.setAttribute("TransEastAsianOriginName", row.getAttribute("EastAsianOriginName"));
                        currentRow.setAttribute("TransOperationType", "C");
                        currentRow.setAttribute("TransId", row.getAttribute("Id"));
                        
                        //T20211208.0024 - Duplication for create vetting in DEV
                     
                        //T20220123.0015 - Need assistance with vessel vetting for Star Ranger
                        currentRow.setAttribute("TransSourceTableColumn", RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TABLE_COLUMN"));
                        currentRow.setAttribute("TransSourceTable", RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TABLE"));
                        currentRow.setAttribute("TransSourceId", RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_ID"));
    
                        
                        
                        //T20211215.0029 - Create Vetting Popup changes
                        //isVettingInfoValid = false;
                        AdfFacesContext.getCurrentInstance().addPartialTarget(JSFUtils.findComponentInRoot("pgl13"));
                        AdfFacesContext.getCurrentInstance().addPartialTarget(JSFUtils.findComponentInRoot("pgl2"));
                    }
                }
            } else  {
                //T20220123.0015 - Need assistance with vessel vetting for Star Ranger
                System.out.println("dialog cancel");
                ViewObject dualVO = ADFUtils.findIterator("DualCreateVettingVO1Iterator").getViewObject();
                Row currentRow = dualVO.first();
                if(currentRow != null) {
                    currentRow.setAttribute("TransOperationType", "C");
                    currentRow.setAttribute("TransSourceTableColumn", RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TABLE_COLUMN"));
                    currentRow.setAttribute("TransSourceTable", RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TABLE"));
                    currentRow.setAttribute("TransSourceId", RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_ID"));
                }

            }
            
            nameScreenedSearchStr = null;
            RichInputText txtFld = (RichInputText) JSFUtils.findComponentInRoot("it3");
            txtFld.setValue(null);
            Map pMap =  ADFContext.getCurrent().getPageFlowScope();
            pMap.put("nameScreenedSearchStr",null);
        }
    /*T20220323.0033 - TC - says given name already exists for "nataly ko... (IRI)
     * Commented the below method and moved the validation to Save button
    public void nameScreenedAliasTextVCL(ValueChangeEvent valueChangeEvent) {
        // Add event code here...
        RichPopup popup = (RichPopup) JSFUtils.findComponentInRoot("nameScreenedAliasTxtSearchPopup");            
        ResetUtils.reset(popup);
        if(valueChangeEvent.getNewValue() != null && !"".equals(valueChangeEvent.getNewValue())) {
            
            //T20220207.0054 - TC 2.0 - TC Name Check Validation
            int ch = hasRecordInOFACORBlockedList(valueChangeEvent.getNewValue());
                if(ch == 0)
                    isVettingInfoValid = false;
                else {
                    isVettingInfoValid = true;
                    return;
                }
            /*T20220323.0033 - TC - says given name already exists for "nataly ko... (IRI)
             * Commented the below lines and created new VO to validate based on Primary Master Id column
            ViewObject vo = ADFUtils.findIterator("LovAliasNameScreenedView1Iterator").getViewObject();
            ViewCriteria vc = vo.getViewCriteriaManager().getViewCriteria("LovAliasNameScreenedViewCriteria");
            vo.applyViewCriteria(null);
            vo.executeQuery();
            vo.setNamedWhereClauseParam("pFullName", valueChangeEvent.getNewValue());
            vo.setNamedWhereClauseParam("pMasterId", getTCReferenceAttribute("MasterId"));
            vo.applyViewCriteria(vc);
            vo.executeQuery();

            int count = vo.getRowCount();*/
            //T20220323.0033 - TC - says given name already exists for "nataly ko... (IRI)
            /*ViewObject vo = ADFUtils.findIterator("AliasNameDuplicateCheckView1Iterator").getViewObject();
            vo.setNamedWhereClauseParam("pfullname", valueChangeEvent.getNewValue());
            vo.setNamedWhereClauseParam("p_primary_master_id", getTCReferenceAttribute("PrimaryMasterId"));
            vo.executeQuery();
            Row row = vo.first();
            
            Integer count = 0;
            if(row != null)
                count = (Integer) row.getAttribute("NameCount");
            count = count == null ? 0 : count;
            System.out.println("count:"+count);
            if(count > 0) {
                iriUtils.displayErrorMessage("Given name already exists.");
                isVettingInfoValid = true;
            }else
                isVettingInfoValid = false;
                AdfFacesContext.getCurrentInstance().addPartialTarget(JSFUtils.findComponentInRoot("pgl13"));
                AdfFacesContext.getCurrentInstance().addPartialTarget(JSFUtils.findComponentInRoot("pgl2"));
        }
    }*/

    public void nameScreenedAliasCustomSearchActionListener(ActionEvent actionEvent) {
        // Add event code here...
        ViewObject vo = ADFUtils.findIterator("LovAliasNameScreenedView1Iterator").getViewObject();
        ViewCriteria vc = vo.getViewCriteriaManager().getViewCriteria("LovAliasNameScreenedViewCriteria");
        vo.applyViewCriteria(null);
        vo.executeQuery();
        vo.setNamedWhereClauseParam("pFullName", nameScreenedAliasSearchStr);
        vo.applyViewCriteria(vc);
        vo.executeQuery();
    }
    
    public void nameScreenedAliasTxtSearchDialogListener(DialogEvent dialogEvent) {
        // Add event code here...
        String outcome = ((dialogEvent.getOutcome() != null) ? dialogEvent.getOutcome().toString() : "N");
        System.out.println("nameScreenedAliasTxtSearchDialogListener:"+outcome);
        if (outcome.equalsIgnoreCase("ok") || outcome.equalsIgnoreCase("save")) {
            Row row = ADFUtils.findIterator("LovAliasNameScreenedView1Iterator").getViewObject().getCurrentRow();
            if(row != null) {
                ViewObject dualVO = ADFUtils.findIterator("DualCreateVettingVO1Iterator").getViewObject();
                Row currentRow = dualVO.first();
                updateDualVettingRecord(currentRow, row, true, false);
                AdfFacesContext.getCurrentInstance().addPartialTarget(JSFUtils.findComponentInRoot("pgl20"));
            }
        }
        
    }
    
    //T20201117.0028 - Single Name Vettings
    public void affidavitDownloadListener(FacesContext facesContext, OutputStream outputStream) {
        // Add event code here...
        iriUtils.downloadFile(affidavitDiskPath, outputStream);
    }
    
    //T20201117.0028 - Single Name Vettings
    public void singleNameVettingActionListener(ActionEvent actionEvent) {
        // Add event code here...
        try{
            String nameScreened = getTCReferenceAttribute("NameScreened").toString();
            if(nameScreened.contains(" ")) {
                JSFUtils.addFormattedFacesErrorMessage("Affidavit Not uploaded. Please upload for single name vetting.",
                                                       "",
                                                       FacesMessage.SEVERITY_ERROR);

            }else {
                RichPopup popup = (RichPopup) JSFUtils.findComponentInRoot("p2");
                popup.show(new RichPopup.PopupHints()); 
            }
            if("Yes".equals(getTCReferenceAttribute("AffidavitFlag"))) {
                fetchAffidavitDetails();
            } else {
                affidavitDiskPath = null;
                affidavitFileName = null;
                affidavitStartDate = null;
                affidavitEndDate = null;
                affidavitAction = "NEW";
            }
        }catch(Exception e){
            e.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while doing single name vetting.", 
                                               "Please contact your System Administrator.", "Vetting","singleNameVettingActionListener", e);
        }
    }
    
    //T20201117.0028 - Single Name Vettings
    private void fetchAffidavitDetails() {
        try {
            List params = new ArrayList();
            params.add(RequestContext.getCurrentInstance().getPageFlowScope().get("DPC_CATEGORY"));
            params.add(RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_ID"));
            ResultSet rs= iriUtils.getPlSqlFunctionData("SELECT disk_path,file_name,affidavit_start_date,affidavit_end_date FROM SICD_AFFIDAVIT_STG" + 
            "            WHERE category_id = ( SELECT category_id" + 
            "                                                        FROM IRI_EDOCS_CATEGORIES" + 
            "                                                        WHERE 1=1" + 
            "                                                        AND category      = ?" + 
            "                                                        AND document_code = 'AFFDVT'" + 
            "                                                        AND document_type = 'Public Documents') "+ 
            "            AND identifier    = ?" + 
            "            AND SYSDATE BETWEEN  AFFIDAVIT_START_DATE AND NVL(AFFIDAVIT_END_DATE,SYSDATE+1)", params);
            
            if(rs.next()) {
                affidavitDiskPath = rs.getString("disk_path");
                affidavitFileName = rs.getString("file_name");
                affidavitStartDate = rs.getDate("affidavit_start_date");
                affidavitEndDate = rs.getDate("affidavit_end_date");
                affidavitAction= "UPDATE";
            } else {
                affidavitDiskPath = null;
                affidavitFileName = null;
                affidavitStartDate = null;
                affidavitEndDate = null;
                affidavitAction = "NEW";
                
            }
            rs.close();
        } catch(Exception e) {
            e.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while fetching affidavit details.", 
                                               "Please contact your System Administrator.", "Vetting","fetchAffidavitDetails", e);
        }
    }
    
    //T20201117.0028 - Single Name Vettings
    public void saveAffidavitDailogListener(DialogEvent dialogEvent) {
        // Add event code here...
        try{
            String outcome = ((dialogEvent.getOutcome() != null) ? dialogEvent.getOutcome().toString() : "N");
            if (outcome.equalsIgnoreCase("ok") || outcome.equalsIgnoreCase("save")) {
                String fileName="";
                if(affidavitUploadedFile == null && "NEW".equals(affidavitAction)){
                    JSFUtils.addFormattedFacesErrorMessage("Please upload file",
                                                           "",
                                                           FacesMessage.SEVERITY_INFO);
                } else {   
                        if("NEW".equals(affidavitAction))
                            fileName = affidavitUploadedFileName;
                        SimpleDateFormat format = new SimpleDateFormat("dd-MMM-yyyy");
                        OperationBinding ob = ADFUtils.findOperation("uploadAffidavit");
                        ob.getParamsMap().put("fileName", fileName);
                        ob.getParamsMap().put("category", RequestContext.getCurrentInstance().getPageFlowScope().get("DPC_CATEGORY"));
                        ob.getParamsMap().put("action", affidavitAction);
                        ob.getParamsMap().put("startDate", (affidavitStartDate == null || "".equals(affidavitStartDate))? "" : format.format(affidavitStartDate));
                        ob.getParamsMap().put("endDate", (affidavitEndDate == null || "".equals(affidavitEndDate))? "" : format.format(affidavitEndDate));
                        Object result = ob.execute();
                        System.out.println("saveAffidavitDailogListener Path:"+result);
                        if (result != null && !"".equals(result) && "NEW".equals(affidavitAction)){ 
                            String[] col = result.toString().split("---");
                            affidavitFileName = col[0];
                            affidavitDiskPath = col[1];
                            
                            IRIUtils.uploadFile(affidavitUploadedFile, col[1]);   
                        }
                        fetchAffidavitDetails();
                        System.out.println("affidavitDiskPath:"+affidavitDiskPath);
                    JSFUtils.addFormattedFacesErrorMessage("Data saved successfully.",
                                                           "",
                                                           FacesMessage.SEVERITY_INFO);
                    resetPopup("p2");  
                    
                }
                
                
            } 
        }catch(Exception e) {
            e.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("There has been some error while saving the affidavit details",
                                                   "Please contact your System Administrator.",
                                                   FacesMessage.SEVERITY_ERROR);
                logGenericTC(LogUtils.ERROR, "There has been some error while saving the affidavit details", 
                                                   "Please contact your System Administrator.", "Vetting","saveAffidavitDailogListener", e);
        }
    }


    //T20201117.0028 - Single Name Vettings
    public void uploadAffidavitValueChangeListener(ValueChangeEvent valueChangeEvent) {
        // Add event code here...
        try {
            if (valueChangeEvent.getNewValue() != null)
            {
            RichInputFile inputFileComponent = (RichInputFile) valueChangeEvent.getComponent();
            UploadedFile uFile = (UploadedFile) valueChangeEvent.getNewValue();
            
                if (!uFile.getFilename().endsWith("pdf") && !uFile.getFilename().endsWith("PDF"))
                {
                    inputFileComponent.resetValue();
                    inputFileComponent.setValid(false);
                    JSFUtils.addFormattedFacesErrorMessage("Only PDF files are allowed.", "", FacesMessage.SEVERITY_ERROR);
                    affidavitUploadedFile = null;
                    affidavitUploadedFileName = null;
                }else {
                    affidavitAction= "NEW";
                    affidavitUploadedFile = uFile.getInputStream();
                    affidavitUploadedFileName = uFile.getFilename();
                }
            }
        }catch(Exception e){
            e.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while upload changes.", 
                                               "Please contact your System Administrator.", "Vetting","uploadAffidavitValueChangeListener", e);
        }
            
    
    } 
    private void resetPopup(String popupId){
        RichPopup popup = (RichPopup) JSFUtils.findComponentInRoot(popupId);
        ResetUtils.reset(popup); 
    }

    public void refreshLegacyVettingActionListener(ActionEvent actionEvent) {
        // Add event code here...
        fetchVettingInfo();
    }

    public void sortByValueChangeListener(ValueChangeEvent valueChangeEvent) {
        // Add event code here...
        System.out.println("valueChangeEvent.getNewValue():"+valueChangeEvent.getNewValue());
        if(valueChangeEvent.getNewValue() != null && !"none".equals(valueChangeEvent.getNewValue()))
            getAm().initializeViewContextAGetData(filterClauseData,valueChangeEvent.getNewValue() + " " + sortByType);
        else
            getAm().initializeViewContextAGetData(filterClauseData,"none");
        
        AdfFacesContext.getCurrentInstance().addPartialTarget(tcReferencesTableBind);
    }

    public void sortByTypeValueChangeListener(ValueChangeEvent valueChangeEvent) {
        // Add event code here...
        if(valueChangeEvent.getNewValue() != null && !"none".equals(sortByColumnName)){
            getAm().initializeViewContextAGetData(filterClauseData,sortByColumnName +" " + valueChangeEvent.getNewValue());
            AdfFacesContext.getCurrentInstance().addPartialTarget(tcReferencesTableBind);
        }
    }

    public void nameScreenedActionListener(ActionEvent actionEvent) {
        // Add event code here...    
        RowSetIterator masterRsi = null;
        RowSetIterator aliasRsi = null;
        
        try 
        {
            if(createVettingPopup != null)
                ResetUtils.reset(createVettingPopup);          
                isVettingInfoValid = false;
            
            if("Alias".equals(getTCReferenceAttribute("Alias"))) {
                
                ADFContext.getCurrent().getPageFlowScope().put("P_FORM_CALLED", "alias");
                ViewObject dualVO = ADFUtils.findIterator("DualCreateVettingVO1Iterator").getViewObject();
                dualVO.clearCache();
                dualVO.executeQuery();
                
                Row currentRow = dualVO.first();          
                currentRow.setAttribute("TransOperationType", "U");
                //T20220406.0030 - Trade Compliance : Slowness while opening TC Detai... (IRI)
                /*
                ViewObject lovVettingVO = ADFUtils.findIterator("LovAliasNameScreenedView1Iterator").getViewObject();               
                
                lovVettingVO.applyViewCriteria(null);
                lovVettingVO.executeQuery();
                ViewCriteria vc = lovVettingVO.getViewCriteriaManager().getViewCriteria("LovAliasNameScreenedSearch");
                lovVettingVO.setNamedWhereClauseParam("pFullName", getTCReferenceAttribute("NameScreened"));
                lovVettingVO.setNamedWhereClauseParam("pIdentifier", getTCReferenceAttribute("Identifier"));
                lovVettingVO.setNamedWhereClauseParam("pSourceId", getTCReferenceAttribute("SourceId"));
                
                lovVettingVO.setNamedWhereClauseParam("pEntityType", getTCReferenceAttribute("EntityType"));
                lovVettingVO.setNamedWhereClauseParam("pSourceTable", getTCReferenceAttribute("SourceTable"));
                lovVettingVO.applyViewCriteria(vc);
                lovVettingVO.executeQuery();
                
                System.out.println("lovVettingVO query for alias::"+lovVettingVO.getQuery());*/
                //T20220406.0030 - Trade Compliance : Slowness while opening TC Detai... (IRI)
                ViewObject lovVettingVO = ADFUtils.findIterator("LovAliasNameScreenedUpdateView1Iterator").getViewObject();
                lovVettingVO.setNamedWhereClauseParam("pId",getTCReferenceAttribute("AliasId"));
                lovVettingVO.executeQuery();
                
                System.out.println("pFullName without trim:"+getTCReferenceAttribute("NameScreened"));
                System.out.println("pFullName: "+ getTCReferenceAttribute("NameScreened"));
                System.out.println("pIdentifier: "+ getTCReferenceAttribute("Identifier"));
                System.out.println("pSourceId: "+getTCReferenceAttribute("SourceId"));
                System.out.println("pEntityType: "+ getTCReferenceAttribute("EntityType"));
                System.out.println("pSourceTable: "+getTCReferenceAttribute("SourceTable"));
                System.out.println("pAliasId: "+ getTCReferenceAttribute("AliasId"));
                System.out.println("row count:"+lovVettingVO.getRowCount());
                aliasRsi = lovVettingVO.createRowSetIterator(null);
                
                if(aliasRsi.hasNext())
                {
                    Row row = aliasRsi.next();
                    updateDualVettingRecord(currentRow, row, false, false);
                    
                    Integer aliasId = null, masterId = null, xrefId = null;

                    if (getTCReferenceAttribute("AliasId") != null)
                        aliasId = (Integer) getTCReferenceAttribute("AliasId");
                    if (getTCReferenceAttribute("MasterId") != null)
                        masterId = (Integer) getTCReferenceAttribute("MasterId");
                    if (getTCReferenceAttribute("XrefId") != null)
                        xrefId = (Integer) getTCReferenceAttribute("XrefId");

                    List params = new ArrayList();
                    if (masterId != null)
                        params.add(masterId.intValue());
                    else
                        params.add(null);

                    if (aliasId != null)
                        params.add(aliasId.intValue());
                    else
                        params.add(null);

                    if (xrefId != null)
                        params.add(xrefId.intValue());
                    else
                        params.add(null);
                    ResultSet data =
                        iriUtils.getPlSqlFunctionData("select LEGACY_VETTING_FLAG from xwrl_party_master where id=rmi_ows_common_util.get_master_id(?,?,?)",
                                                      params);
                    if(data.next()){
                        currentRow.setAttribute("TransLegacyVettingFlag", data.getString("LEGACY_VETTING_FLAG"));
                    }
                    data.close();
                }

            } else {
                ADFContext.getCurrent().getPageFlowScope().put("P_FORM_CALLED", "vetting");
                ViewObject dualVO = ADFUtils.findIterator("DualCreateVettingVO1Iterator").getViewObject();
                dualVO.clearCache();
                dualVO.executeQuery();
                Row currentRow = dualVO.first();
                currentRow.setAttribute("TransOperationType", "U");
                //T20220406.0030 - Trade Compliance : Slowness while opening TC Detai... (IRI)
                /*
                ViewObject lovVettingVO = ADFUtils.findIterator("LovVettingsNameScreenedView1Iterator").getViewObject();
                lovVettingVO.applyViewCriteria(null);
                lovVettingVO.executeQuery();
                ViewCriteria vc = lovVettingVO.getViewCriteriaManager().getViewCriteria("LovVettingsNameScreenedSearch");
                lovVettingVO.setNamedWhereClauseParam("pFullName", iriUtils.nullStrToSpc(getTCReferenceAttribute("NameScreened")).trim());
                lovVettingVO.setNamedWhereClauseParam("pIdentifier", getTCReferenceAttribute("Identifier"));
                lovVettingVO.setNamedWhereClauseParam("pSourceId", getTCReferenceAttribute("SourceId"));
                
                lovVettingVO.setNamedWhereClauseParam("pEntityType", getTCReferenceAttribute("EntityType"));
                lovVettingVO.setNamedWhereClauseParam("pSourceTable", getTCReferenceAttribute("SourceTable"));
                lovVettingVO.applyViewCriteria(vc);
                lovVettingVO.executeQuery();
                
                System.out.println("Vetting Query ::"+ lovVettingVO.getQuery());*/
                //T20220406.0030 - Trade Compliance : Slowness while opening TC Detai... (IRI)
                ViewObject lovVettingVO = ADFUtils.findIterator("LovVettingsNameScreenedUpdateView1Iterator").getViewObject();
                lovVettingVO.setNamedWhereClauseParam("pId",getTCReferenceAttribute("PrimaryMasterId"));
                lovVettingVO.executeQuery();
                
                System.out.println("pFullName: "+ iriUtils.nullStrToSpc(getTCReferenceAttribute("NameScreened")).trim());
                System.out.println("pIdentifier: "+ getTCReferenceAttribute("Identifier"));
                System.out.println("pSourceId: "+getTCReferenceAttribute("SourceId"));
                System.out.println("pEntityType: "+ getTCReferenceAttribute("EntityType"));
                System.out.println("pSourceTable: "+getTCReferenceAttribute("SourceTable"));
                System.out.println("pPrimaryMasterId: "+ getTCReferenceAttribute("PrimaryMasterId"));
                System.out.println("row count:"+lovVettingVO.getRowCount());
                masterRsi = lovVettingVO.createRowSetIterator(null);
                
                if(masterRsi.hasNext()){
                    Row row = masterRsi.next();
                    updateDualVettingRecord(currentRow, row, false, true);
                }
            }
            JSFUtils.showPopup(createVettingPopup, true);
        } catch (Exception e) {
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while creating new vetting." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while creating new vetting.", 
                                               "Please contact your System Administrator.", "Vetting","handleNameScreenedDoubleClick", e);
        }finally {
            try {
                if(aliasRsi != null) {
                    aliasRsi.closeRowSetIterator(); 
                }
           } catch (Exception e) {
                // TODO: Add catch code
                e.printStackTrace();
            }
            
            try {
                if(masterRsi != null) {
                    masterRsi.closeRowSetIterator(); 
                }
            } catch (Exception e) {
                // TODO: Add catch code
                e.printStackTrace();
            }
        }
    }
    
    private void updateDualVettingRecord(Row currentRow, Row row, boolean isNew, boolean isMaster) {
        currentRow.setAttribute("TransNameScreened", row.getAttribute("FullName"));
        currentRow.setAttribute("TransDateOfBirth", row.getAttribute("Dob"));
        currentRow.setAttribute("TransCityId", row.getAttribute("CityOfResidenceId"));
        currentRow.setAttribute("TransCtznshpCntryCode", row.getAttribute("CitizenshipCountryCode"));
        currentRow.setAttribute("TransIdType", row.getAttribute("IdType"));
        currentRow.setAttribute("TransIdNumber", row.getAttribute("PassportNumber"));
        currentRow.setAttribute("TransGender", row.getAttribute("Sex"));
        currentRow.setAttribute("TransPassIssuCntryCode", row.getAttribute("PassportIssuingCountryCode"));
        currentRow.setAttribute("TransResdnceCntryCode", row.getAttribute("CountryOfResidenceCode"));
        currentRow.setAttribute("TransEntityType", row.getAttribute("EntityType"));
        currentRow.setAttribute("TransNameScreenedUpdatable", row.getAttribute("FullName"));
        currentRow.setAttribute("TransResdnceCntryName", row.getAttribute("CountryOfResidenceName"));
        
        currentRow.setAttribute("TransIMONumber",row.getAttribute("ImoNumber"));
        currentRow.setAttribute("TransRelationshipType",row.getAttribute("RelationshipType"));
        currentRow.setAttribute("TransCityName", row.getAttribute("CityName"));
        
        if(isMaster) {
            currentRow.setAttribute("TransLegacyVettingFlag", row.getAttribute("LegacyVettingFlag"));
            currentRow.setAttribute("TransEastAsianOriginName", row.getAttribute("EastAsianOriginName"));
			//T20220420.0027 - TC - Update Vetting (IRI)
            if(!isNew){
                currentRow.setAttribute("TransPassIssuCntryCode1", row.getAttribute("PassportIssuingCountryCode1"));
                currentRow.setAttribute("TransCtznshpCntryCode1", row.getAttribute("CitizenshipCountryCode1"));
            }
        }
        if(isNew) {
            currentRow.setAttribute("TransOperationType", "C");
            currentRow.setAttribute("TransId", null);
            currentRow.setAttribute("TransSeafarerId",null);
        } else {
            currentRow.setAttribute("TransOperationType", "U");
            currentRow.setAttribute("TransId", row.getAttribute("Id"));
            currentRow.setAttribute("TransSeafarerId", row.getAttribute("Identifier"));
            currentRow.setAttribute("TransSourceTableColumn", row.getAttribute("SourceTableColumn"));
            currentRow.setAttribute("TransSourceTable", row.getAttribute("SourceTable"));
            currentRow.setAttribute("TransSourceId", row.getAttribute("SourceId"));
        }
    }

    public void searchActionListener(ActionEvent actionEvent) {
        // Add event code here...
        ResetUtils.reset(tcReferencesTableBind);
        filterClauseData = "";
//        System.out.println("searchNameScreened:"+searchNameScreened);
//        System.out.println("searchBatchId:"+searchBatchId);
//        System.out.println("searchEndDate:"+searchEndDate);
//        System.out.println("searchStatus:"+searchStatus);
        List<String> list = new ArrayList<>();
        if(searchNameScreened != null) {
            list.add(" lower(full_name) like lower('%"+searchNameScreened +"%')");
        }
        if(searchBatchId != null) {
            list.add(" batch_id = "+searchBatchId);
        }
        if(searchEndDate != null && !"All".equals(searchEndDate)) {
            list.add(" end_date "+searchEndDate);
        }
        if(searchStatus != null && !"All".equals(searchStatus)) {
            list.add(" case_workflow = '"+searchStatus +"'");
        }
        System.out.println("searchStatus:"+searchStatus);
        for(int i=0;i<list.size();i++) {
            filterClauseData += list.get(i);
            if(i != list.size() -1)
                filterClauseData += " " + filterConjection + " ";
        }
        
        if("none".equals(sortByColumnName))
            getAm().initializeViewContextAGetData(filterClauseData,"none");
        else
            getAm().initializeViewContextAGetData(filterClauseData,sortByColumnName +" " + sortByType);
        AdfFacesContext.getCurrentInstance().addPartialTarget(tcReferencesTableBind);
    }

    public void resetActionListener(ActionEvent actionEvent) {
        // Add event code here...
        ResetUtils.reset(tcReferencesTableBind);
        filterClauseData = " end_date is null";
        searchNameScreened = null;
        searchBatchId = null;
        searchEndDate = "is null";
        searchStatus = "All";
        filterConjection="and";
        
        if("none".equals(sortByColumnName))
            getAm().initializeViewContextAGetData(filterClauseData,null);
        else
            getAm().initializeViewContextAGetData(filterClauseData,sortByColumnName);
        AdfFacesContext.getCurrentInstance().addPartialTarget(tcReferencesTableBind);
    }

    public void residenceCountryValueChangeListener(ValueChangeEvent valueChangeEvent) {
        // Add event code here...
        UIComponent c = valueChangeEvent.getComponent();
        c.processUpdates(FacesContext.getCurrentInstance());
        
        try{
            OperationBinding updateCC = ADFUtils.findOperation("updateCountryCity1");
            Map m = updateCC.getParamsMap();
            m.put("type", "Country");
            m.put("country", iriUtils.nullStrToSpc(JSFUtils.resolveExpression("#{row.bindings.ResidenceCountryCode.inputValue}")));
            m.put("city", null);
           updateCC.execute();
            
        } catch(Exception e) {
            e.printStackTrace();
        }
        
    }

    public void cityValueChangeListener(ValueChangeEvent valueChangeEvent) {
        // Add event code here...
        UIComponent c = valueChangeEvent.getComponent();
        c.processUpdates(FacesContext.getCurrentInstance());
        System.out.println("id:"+JSFUtils.resolveExpression("#{row.bindings.ResidenceCityId.inputValue}"));
        OperationBinding updateCC = ADFUtils.findOperation("updateCountryCity1");
        Map m = updateCC.getParamsMap();
        m.put("type", "City");
        m.put("country", null);
        m.put("city", iriUtils.nullStrToSpc(JSFUtils.resolveExpression("#{row.bindings.ResidenceCityId.inputValue}")));
        updateCC.execute();
    }

    public void showMsgDialogListener(DialogEvent dialogEvent) {
        // Add event code here...
        fetchTcReferencesOws();
    }

    public void updateEndDateValueChangeListener(ValueChangeEvent valueChangeEvent) {
        // Add event code here...
        try{ 
            SimpleDateFormat format = new SimpleDateFormat("dd-MMM-yyyy");
            Map<String, Object> att = valueChangeEvent.getComponent().getAttributes();
            OperationBinding updateED = ADFUtils.findOperation("updateEndDate");
            Map m = updateED.getParamsMap();
            if(valueChangeEvent.getNewValue() == null)
                m.put("endDate",null);
            else{
                m.put("endDate", format.parse(valueChangeEvent.getNewValue().toString()));
            }
            m.put("masterId", att.get("masterId"));
            m.put("aliasId", att.get("aliasId"));
            m.put("xrefId",att.get("xrefId"));
            //T20220123.0015 - Need assistance with vessel vetting for Star Ranger
            m.put("cursor",att.get("cursor"));
            Object result = updateED.execute();
            if(!"S".equals(result)) {
                ResetUtils.reset(valueChangeEvent.getComponent());
                iriUtils.displayErrorMessage(result.toString());
            }
        } catch(Exception e){
            e.printStackTrace();
        }
    }

    public void cancelVettingActionListener(ActionEvent actionEvent) {
        // Add event code here...
        try {
                Row row = ADFUtils.findIterator("DualCreateVettingVO1Iterator").getViewObject().getCurrentRow();
                Object nameScreened = row.getAttribute("TransNameScreenedUpdatable");
                resetToNewRow();
                row = ADFUtils.findIterator("DualCreateVettingVO1Iterator").getViewObject().getCurrentRow();
                row.setAttribute("TransNameScreenedUpdatable", nameScreened);

                if (createVettingPopup != null)
                    ResetUtils.reset(createVettingPopup);
                // Add event code here...
                createVettingPopup.hide();
            } catch (Exception e) {
                // TODO: Add catch code
                e.printStackTrace();
        }
    }

    //T20211118.0028 - TC 2.0 - Online Consent
    public void onlineConsentAckNumberVCL(ValueChangeEvent valueChangeEvent) {
        // Add event code here...
        System.out.println("DPC valueChangeEvent:"+valueChangeEvent.getNewValue());
        Row dualRow = ADFUtils.findIterator("DualCreateVettingVO1Iterator").getViewObject().getCurrentRow();
        
        //T20230427.0021 - TC - FA - online DPCF codes (IRI)        
        if (valueChangeEvent.getOldValue() != null) {        
            if (!valueChangeEvent.getOldValue().equals(valueChangeEvent.getNewValue())) {
                dualRow.setAttribute("TransOnlineConfirmationNumberVerify",null);
                dualRow.setAttribute("TransOnlineConfirmationNumber",valueChangeEvent.getNewValue());    
            }        
        }
        
        if(dualRow.getAttribute("TransOnlineConfirmationNumberVerify") == null) {
            //System.out.println("dates are null");
            if(valueChangeEvent.getNewValue() != null) {
                
                ViewObject vo = ADFUtils.findIterator("GetConsentDetailsByConfNumberView1Iterator").getViewObject();
                vo.setNamedWhereClauseParam("p_conf_number", valueChangeEvent.getNewValue());
                vo.executeQuery();
                if(vo.hasNext()) {
                    System.out.println("has values");
                    Row row = vo.next();                   
                    
                    System.out.println("ConsentDate: "+row.getAttribute("ConsentDate"));
                    System.out.println("ConsentExpireDate: "+row.getAttribute("ConsentExpireDate"));
                    System.out.println("EdocId: "+row.getAttribute("EdocId"));
                        
                    dualRow.setAttribute("TransOnlineConsentStartDate", row.getAttribute("ConsentDate"));                    
                    dualRow.setAttribute("TransOnlineConsentEndDate", row.getAttribute("ConsentExpireDate"));
                    dualRow.setAttribute("TransOnlineUploadedConsentEdocId", row.getAttribute("EdocId"));
                    
                    loadOnlineConsentById(dualRow.getAttribute("TransOnlineUploadedConsentEdocId"));
                    
                    AdfFacesContext.getCurrentInstance().addPartialTarget(JSFUtils.findComponentInRoot("pfl6"));
                } else {
                    ResetUtils.reset(valueChangeEvent.getComponent());
                }
            }
        }
    }

    public void namescreenedTxtSearchPopupCancelListener(PopupCanceledEvent popupCanceledEvent) {
        // Add event code here...
        System.out.println("namescreenedTxtSearchPopupCancelListener");
        Row row = ADFUtils.findIterator("DualCreateVettingVO1Iterator").getViewObject().getCurrentRow();
        if(row != null) {
            if(hasName(iriUtils.nullStrToSpc(row.getAttribute("TransNameScreenedUpdatable")))) {
                isVettingInfoValid = true;
            }else {
                isVettingInfoValid = false;
        }
        } 
        
        nameScreenedSearchStr = null;
        RichInputText txtFld = (RichInputText) JSFUtils.findComponentInRoot("it3");
        txtFld.setValue(null);
        Map pMap =  ADFContext.getCurrent().getPageFlowScope();
        pMap.put("nameScreenedSearchStr",null);
        AdfFacesContext.getCurrentInstance().addPartialTarget(JSFUtils.findComponentInRoot("pgl2"));
    }
    
    private void logGenericTC(String type, String title, String message, String className,String methodName, Exception e) {
        OperationBinding logGenericTCOP = ADFUtils.findOperation("logGenericTC");
        if(logGenericTCOP != null) {
            Map map = logGenericTCOP.getParamsMap();
            map.put("type",type);
            map.put("title",title);
            map.put("message",message);
            map.put("className",className);
            map.put("methodName",methodName);
            map.put("detailedMessage",LogUtils.returnStackTrace(e));
            logGenericTCOP.execute();
        }
    }

    //T20220309.0027 - FW: before and after column rearranging for Filing Agent TC
    public void saveColumnsOrderActionListener(ActionEvent actionEvent) {
        // Add event code here...
        try{
            RichPopup popup = (RichPopup) JSFUtils.findComponentInRoot("columnsOrderSavePopup");
            int seq = 0;    
            ViewObject vo = ADFUtils.findIterator("RmiGenericColumnsOrderView1Iterator").getViewObject();        
            
            ViewCriteria vc = vo.getViewCriteriaManager().getViewCriteria("RmiGenericColumnsOrderViewCriteriaByUserId");
            vo.applyViewCriteria(vc);
            vo.executeQuery();
            seq = vo.getRowCount() + 1;
            System.out.println("seq:"+seq);
            if (seq > 1) {
                vc = vo.getViewCriteriaManager().getViewCriteria("RmiGenericColumnsOrderViewCriteriaByUserIdNameCheck");
                //vo.setNamedWhereClauseParam("p_userid", Long.valueOf(userId));
                vo.setNamedWhereClauseParam("p_ordername", columnsOrderName);
                vo.applyViewCriteria(vc);
                vo.executeQuery();
                System.out.println("coun:"+vo.getRowCount());
                if(vo.getRowCount() > 0) {
                    iriUtils.displayErrorMessage("Column Order Name already exists.");
                    return;
                }
                
            }
            
            System.out.println("isDefault:"+isOrderDefault);
            if(isOrderDefault) {
                vo.applyViewCriteria(null);
                vo.executeQuery();
                vc = vo.getViewCriteriaManager().getViewCriteria("RmiGenericColumnsOrderViewCriteriaByIsDefault");
                vo.applyViewCriteria(vc);
                vo.executeQuery();
                for(int i=0;i<vo.getRowCount();i++) {
                    Row next = vo.getRowAtRangeIndex(i);
                    System.out.println("set to N");
                    next.setAttribute("IsDefault", "N");
                
                }
            }
            
            Row row = vo.createRow();
            
            String orderStr="";
            List<UIComponent> children = this.tcReferencesTableBind.getChildren();
           for (UIComponent comp : children) {
               // check if the child is a column
               if (comp instanceof RichColumn) {
                   RichColumn col = (RichColumn) comp;
                   // if hte display index is greater 0 set it to -1
                   orderStr += col.getShortDesc() +"-"+ col.getDisplayIndex()+ "-"+getBooleanMatchingFlag(col.isRendered())+"-"+getBooleanMatchingFlag(col.isVisible())+",";
                  
               }
           }
            System.out.println(orderStr);
            row.setAttribute("ColumnsOrder", orderStr);
            row.setAttribute("OrderName", columnsOrderName);
            if(isOrderDefault) {
                row.setAttribute("IsDefault", "Y");
                selectedOrderName = columnsOrderName;
                selectedOrderId =((BigDecimal) row.getAttribute("Id")).toBigInteger().toString();
                System.out.println("selectedOrderId:"+selectedOrderId);
            } else {
                row.setAttribute("IsDefault", "N");
            }
            vo.insertRow(row);
            ADFUtils.findOperation("Commit").execute();
            if(isOrderDefault)
                iriUtils.displaySuccessMessage(columnsOrderName+" created and set as default.");
            else
                iriUtils.displaySuccessMessage(columnsOrderName+" created.");
            popup.hide();
            AdfFacesContext.getCurrentInstance().addPartialTarget(JSFUtils.findComponentInRoot("t15"));
            prepareColumnsOrderList();
        }catch(Exception e){
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while saving the order." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while saving the order.", 
                                               "Please contact your System Administrator.", "Vetting","saveColumnsOrderActionListener", e);
        }
    }
    
    private int getBooleanMatchingFlag(boolean value) {
        return (value)? 1:0;
    }

    public void selectColumnsOrderValueChangeListener(ValueChangeEvent valueChangeEvent) {
        // Add event code here...
        try{
            selectOrder(valueChangeEvent.getNewValue());
        }catch(Exception e){
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while selecting order." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while selecting order.", 
                                               "Please contact your System Administrator.", "Vetting","selectColumnsOrderValueChangeListener", e);
        }
    }
    
    private void selectOrder(Object id) {
        try{
            if(id != null) {
                ViewObject vo = ADFUtils.findIterator("RmiGenericColumnsOrderView1Iterator").getViewObject();
                
                ViewCriteria vc = vo.getViewCriteriaManager().getViewCriteria("RmiGenericColumnsOrderViewCriteriaById");
                vo.setNamedWhereClauseParam("p_id", new BigDecimal(id.toString()));
                vo.applyViewCriteria(vc);
                vo.executeQuery();
                System.out.println("cnt:"+vo.getRowCount());
                Row row = vo.first();
                
                selectedOrderId = id.toString();
                selectedOrderName =  row.getAttribute("OrderName").toString();
                String order = row.getAttribute("ColumnsOrder").toString();
                System.out.println("order:"+order);
                if(row.getAttribute("IsDefault") == null || "".equals(row.getAttribute("IsDefault")))
                    isOrderDefault = false;
                else 
                    isOrderDefault = "Y".equals(row.getAttribute("IsDefault"));
                               
                prepareReOrderMap(order);
                System.out.println("selectedOrderId:"+selectedOrderId);
                System.out.println("isOrderDefault:"+isOrderDefault);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    private void prepareReOrderMap(String order) {
        try{
            reOrderMap.clear();
            columnsOrderVisibleMap.clear();
            for(String keySet:order.split(",")) {
                String[] itemSet = keySet.split("-");
    
                reOrderMap.put(itemSet[0], Integer.parseInt(itemSet[1]));
                columnsOrderVisibleMap.put(itemSet[0],Integer.parseInt(itemSet[3]));
            }
            System.out.println("columnsOrderVisibleMap:"+columnsOrderVisibleMap);
            
            if(tcReferencesTableBind != null) {
                List<UIComponent> children = tcReferencesTableBind.getChildren();
                for( UIComponent comp:children) {
                    RichColumn col = (RichColumn) comp;

                    // tsuazo Added by Prem.  The method is overloaded for OSSD usage.
                    // prepareReOrderMap() is called from the EBS side.
                    Integer idx = reOrderMap.get(col.getShortDesc());
                    if (idx != null) {                    
                        col.setDisplayIndex(reOrderMap.get(col.getShortDesc()));
                        col.setVisible(true);
                    }                     
                }
            }
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    private void prepareReOrderMap() {
        
        LOGGER.finest(("prepareReOrderMap"));
        
        try{
            reOrderMap.clear();
            List params = new ArrayList();
            ResultSet data =
                iriUtils.getPlSqlFunctionData("select option_key,option_value from RMI_GENERIC_PARAMETERS where id = 'UI_TABLE_COLUMNS_ORDER' and enabled='Y' order by to_number(option_value)",params);
            int order = 1;
            while(data.next()) {
                reOrderMap.put(data.getString("option_key"),order++);
                columnsOrderVisibleMap.put(data.getString("option_key"),1);
            }
            data.close();
         
            if(tcReferencesTableBind != null) {
                List<UIComponent> children = tcReferencesTableBind.getChildren();
                for( UIComponent comp:children) {
                    
                    RichColumn col = (RichColumn) comp;
                    
                    LOGGER.finest("col: "+col.getId());
                    LOGGER.finest("col Short Desc: "+col.getShortDesc());
                    LOGGER.finest("Display Index: "+reOrderMap.get(col.getShortDesc()));
                    
                    Integer idx = reOrderMap.get(col.getShortDesc());
                    if (idx != null) {                    
                        col.setDisplayIndex(reOrderMap.get(col.getShortDesc()));
                        col.setVisible(true);
                    }
                }
            }
        }catch(Exception e) {
            e.printStackTrace();
        }
    }

    public void setDefaultColumnsOrderActionListener(ActionEvent actionEvent) {
        // Add event code here...
        try{
            if(selectedOrderId == null || "".equals(selectedOrderId)) {
                iriUtils.displayErrorMessage("Please select order to set Default.");
            } else {
                ViewObject vo = ADFUtils.findIterator("RmiGenericColumnsOrderView1Iterator").getViewObject();
                ViewCriteria vc = vo.getViewCriteriaManager().getViewCriteria("RmiGenericColumnsOrderViewCriteriaByIsDefault");
                vo.applyViewCriteria(vc);
                vo.executeQuery();
                while(vo.hasNext()) {
                    Row next = vo.next();
                    next.setAttribute("IsDefault", "N");
                }
                
                ADFUtils.findOperation("Commit").execute();
                
                vc = vo.getViewCriteriaManager().getViewCriteria("RmiGenericColumnsOrderViewCriteriaById");
                vo.setNamedWhereClauseParam("p_id", new BigDecimal(selectedOrderId));
                vo.applyViewCriteria(vc);
                vo.executeQuery();
                String name=null;
                while(vo.hasNext()) {
                    Row next = vo.next();
                    next.setAttribute("IsDefault", "Y");
                    name = next.getAttribute("OrderName").toString();
                }
                
                iriUtils.displaySuccessMessage(name+" set as default.");
                ADFUtils.findOperation("Commit").execute();
                prepareColumnsOrderList();
            }
        }catch(Exception e){
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while selected order set to default." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while selected order set to default.", 
                                               "Please contact your System Administrator.", "Vetting","setDefaultColumnsOrderActionListener", e);
        }
    }

    public void deleteColumnsOrderActionListener(ActionEvent actionEvent) {
        // Add event code here...
        try {
            if(selectedOrderId == null || "".equals(selectedOrderId)) {
                iriUtils.displayErrorMessage("Please select order to remove.");
            } else {
                ViewObject vo = ADFUtils.findIterator("RmiGenericColumnsOrderView1Iterator").getViewObject();
                ViewCriteria vc = vo.getViewCriteriaManager().getViewCriteria("RmiGenericColumnsOrderViewCriteriaById");
                vo.setNamedWhereClauseParam("p_id", new BigDecimal(selectedOrderId));
                vo.applyViewCriteria(vc);
                vo.executeQuery();
                if(vo.hasNext()) {
                    Row row = vo.next();
                    row.setAttribute("IsDeleted","Y");
                    String name = row.getAttribute("OrderName").toString();
                    ADFUtils.findOperation("Commit").execute();
                    iriUtils.displaySuccessMessage(name+" deleted successfully.");
                    prepareColumnsOrderList();
                }
            }
        }catch(Exception e){
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while deleting the selected order." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while deleting the selected order.", 
                                               "Please contact your System Administrator.", "Vetting","deleteColumnsOrderActionListener", e);

        }
    }
    
    public void columnsOrderSavePopupFetchListener(PopupFetchEvent popupFetchEvent) {
            // Add event code here...
            columnsOrderName=null;
            isOrderDefault=false;
            ResetUtils.reset(JSFUtils.findComponentInRoot("columnsOrderSavePopup"));
        }
    
    public void resetColumnsOrderActionListener(ActionEvent actionEvent) {
            // Add event code here...
            selectedOrderId = null;
            selectedOrderName = null;
            columnsOrderName=null;
            isOrderDefault = false;
            prepareReOrderMap();
    }

    public void cancelColumnsOrderActionListener(ActionEvent actionEvent) {
        // Add event code here...
        RichPopup savePopup = (RichPopup) JSFUtils.findComponentInRoot("columnsOrderSavePopup");
        ResetUtils.reset(savePopup);
        savePopup.cancel();
    }
	
	/**
     * T20220322.0004 - TC 2.0 - Select All Issue (IRI)
     * @param valueChangeEvent
     */
    public void selectAllVettingsVCL(ValueChangeEvent valueChangeEvent) {
        System.out.println("Start selectAllVettingsVCL");
        try{
        valueChangeEvent.getComponent().processUpdates(FacesContext.getCurrentInstance()); //T20220323.0025 - Issue with vettings being automatically check mark... (IRI)
        Boolean isSelected = (Boolean) valueChangeEvent.getNewValue();
        isSelected = isSelected == null ? false : isSelected;
        System.out.println("isSelected: " + isSelected);
        ViewObject tcRefVO = ADFUtils.findIterator("TcReferencesView1Iterator").getViewObject();
        RowSetIterator rsi = tcRefVO.createRowSetIterator(null);
        System.out.println("TcReferencesView row count: "+rsi.getRowCount());
        Row row = null;
        while (rsi.hasNext()) {
            row = rsi.next();
            if (isSelected) {
                row.setAttribute("SelectRow", true); //T20220323.0025 - Issue with vettings being automatically check mark... (IRI)
                row.setAttribute("TcExcluded", "Y");
            } else {
                row.setAttribute("SelectRow", false); //T20220323.0025 - Issue with vettings being automatically check mark... (IRI)
                row.setAttribute("TcExcluded", "N");
            }
        }
        rsi.closeRowSetIterator();
        AdfFacesContext.getCurrentInstance().addPartialTarget(tcReferencesTableBind);
        }catch(Exception e){
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while performing Select All." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while performing Select All.", 
                                               "Please contact your System Administrator.", "Vetting","selectAllVettingsVCL",e);
        }
        System.out.println("End selectAllVettingsVCL");
    }

    //T20220323.0025 - Issue with vettings being automatically check mark... (IRI)
    public void saveVettingCheckBoxSelections(){
        System.out.println("Start saveVettingCheckBoxSelections");
        try{            
            OperationBinding saveChkBxOp = ADFUtils.findOperation("saveVettingCheckBoxSelections");
            saveChkBxOp.execute();
        }catch(Exception e){
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while saving." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while saving.", 
                                               "Please contact your System Administrator.", "Vetting","saveVettingCheckBoxSelections", e);
        }
        System.out.println("End saveVettingCheckBoxSelections");
    }
    //T20220323.0025 - Issue with vettings being automatically check mark... (IRI)
    public void runTcSummaryPopupFetchLis(PopupFetchEvent popupFetchEvent) {
        System.out.println("Start runTcSummaryPopupFetchLis");
        try{
            runTcSummaryList.clear();
            ViewObject vo = ADFUtils.findIterator("TcReferencesView1Iterator").getViewObject();
            Row[] selectedRows = vo.getFilteredRows("SelectRow", true);
            System.out.println("selectedRows: "+selectedRows.length);
            /*RowSetIterator rsi = null;
            rsi = vo.createRowSetIterator(null);
            System.out.println("VO count: "+rsi.getRowCount());
            while(rsi.hasNext()) {
                System.out.println("Inside while");
                Row row = rsi.next();                
                if(row != null) {
                    if("Y".equals(row.getAttribute("TcExcluded"))){
                        runTcSummaryList.add((String)row.getAttribute("NameScreened"));
                    }
                }
            }*/
            for(Row row : selectedRows){
                System.out.println("Inside for");
                runTcSummaryList.add((String)row.getAttribute("NameScreened"));
            }
            System.out.println("runTcSummaryList: "+runTcSummaryList);
            //rsi.closeRowSetIterator();
        }catch(Exception e){
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while displaying summary popup." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while displaying summary popup.", 
                                               "Please contact your System Administrator.", "Vetting","runTcSummaryPopupFetchLis", e);
        }
        System.out.println("End runTcSummaryPopupFetchLis");
    }


    public void setRunTcSummaryList(List<String> runTcSummaryList) {
        this.runTcSummaryList = runTcSummaryList;
    }

    public List<String> getRunTcSummaryList() {
        return runTcSummaryList;
    }
    //T20220323.0025 - Issue with vettings being automatically check mark... (IRI)
    public String runTCPopupClose() {
        runTcSummaryList.clear();
        ResetUtils.reset(runTCSummaryPopup);
        this.getRunTCSummaryPopup().hide();
        return null;
    }

    public void setRunTCSummaryPopup(RichPopup runTCSummaryPopup) {
        this.runTCSummaryPopup = runTCSummaryPopup;
    }

    public RichPopup getRunTCSummaryPopup() {
        return runTCSummaryPopup;
    }
    //T20220323.0025 - Issue with vettings being automatically check mark... (IRI)
    public void selectRowCheckBoxVCL(ValueChangeEvent valueChangeEvent) {
        LOGGER.finest("Start selectRowCheckBoxVCL");
        try {
            valueChangeEvent.getComponent().processUpdates(FacesContext.getCurrentInstance());
            Boolean isSelected = (Boolean) valueChangeEvent.getNewValue();
            
            UIComponent c = valueChangeEvent.getComponent();
            c.processUpdates(FacesContext.getCurrentInstance());
                        
            isSelected = isSelected == null ? false : isSelected;
            
            ViewObject tcRefVO = ADFUtils.findIterator("TcReferencesView1Iterator").getViewObject();

            Row row = null;
            row = tcRefVO.getCurrentRow();
            
            LOGGER.finest("Id::"+row.getAttribute("Id"));
            LOGGER.finest("MasterId::"+row.getAttribute("MasterId"));
            LOGGER.finest("AliasId::"+row.getAttribute("AliasId"));
            LOGGER.finest("XrefId::"+row.getAttribute("XrefId"));
            LOGGER.finest("NameScreened::"+row.getAttribute("NameScreened"));
            LOGGER.finest("TcExcluded::"+row.getAttribute("TcExcluded"));
            LOGGER.finest("isSelected::"+isSelected);                        
            
            if (isSelected) {
                LOGGER.finest("TcExcluded N::"+isSelected);
                row.setAttribute("TcExcluded", "N");                
            } else {
                LOGGER.finest("TcExcluded Y::"+isSelected);
                row.setAttribute("TcExcluded", "Y");
            }
            
            
            LOGGER.finest("Start DB Transaction");
            RMIManualTradeComplianceAppModuleImpl am = getAm();

            AdfUtils.callDbFunction(am, Types.VARCHAR,
                                                 "RMI_GENERIC_TC.update_master_individual(?,?,?,?)", new Object[] {
                                                 row.getAttribute("MasterId"), row.getAttribute("AliasId"),
                                                 row.getAttribute("XrefId"), row.getAttribute("TcExcluded")
            },"System encountered an exception while saving.");

            am.getDBTransaction().commit();
            
//            fetchTcReferencesOws();
            
//            tcRefVO.setCurrentRow(row);        
            
            AdfFacesContext.getCurrentInstance().addPartialTarget(tcReferencesTableBind);

            LOGGER.finest("Id::"+row.getAttribute("Id"));
            LOGGER.finest("MasterId::"+row.getAttribute("MasterId"));
            LOGGER.finest("AliasId::"+row.getAttribute("AliasId"));
            LOGGER.finest("XrefId::"+row.getAttribute("XrefId"));
            LOGGER.finest("NameScreened::"+row.getAttribute("NameScreened"));
            LOGGER.finest("TcExcluded::"+row.getAttribute("TcExcluded"));
            LOGGER.finest("isSelected::"+isSelected);                       
            
            LOGGER.finest("End DB Transaction");


        } catch (Exception e) {
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while performing Select." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while performing Select.",
                         "Please contact your System Administrator.", "Vetting", "selectRowCheckBoxVCL", e);
        }
        LOGGER.finest("End selectRowCheckBoxVCL");
    }
    //T20220323.0025 - Issue with vettings being automatically check mark... (IRI)
    public String callRunTc(){
        System.out.println("Start callRunTc");        
        try {            
            
            
            runTcSummaryList.clear();
            ResetUtils.reset(runTCSummaryPopup);
            this.getRunTCSummaryPopup().hide();
            
            OperationBinding runTcOp = ADFUtils.findOperation("callRunTc");
            runTcOp.getParamsMap().put("affidavitFlag", affidavitReceived);
            
            FacesContext fctx = FacesContext.getCurrentInstance();
            ExternalContext ectx = fctx.getExternalContext();
            Map m = ectx.getRequestParameterMap();
            Map pMap =  ADFContext.getCurrent().getPageFlowScope();
            
            // tsuazo 08/21/2023
            //String docType = (String) pMap.get("ProvisionalDocumentType");
            String docType= null;
            if(pMap.get("ProvisionalDocumentType") != null)
            {
           docType = pMap.get("ProvisionalDocumentType").toString();
            }
            
            System.out.println("callRunTc docType:"+docType);
            
            runTcOp.getParamsMap().put("documentType", (PRVFT) ? "PRVFT" : null);
            // T20230330.0026 - LONO - TC Department (IRI)
            if (!PRVFT) {
                pMap.put("ProvisionalDocumentType",null);
            }
            Object msg = runTcOp.execute();

            validateRunTCResponse(msg);

            fetchTcReferencesOws();
            
            
        } catch (Exception e) {
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while performing Run TC." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while performing Run TC.",
                         "Please contact your System Administrator.", "Vetting", "callRunTc", e);
        }
        System.out.println("End callRunTc");
        return null;
    }
    //T20220323.0025 - Issue with vettings being automatically check mark... (IRI)
    public String selectAllCheckBoxAction() {
        System.out.println("Start selectAllCheckBoxAction");
        try {
            
            fetchTcReferencesOws();
            
            ViewObject tcRefVO = ADFUtils.findIterator("TcReferencesView1Iterator").getViewObject();
            RowSetIterator rsi = tcRefVO.createRowSetIterator(null);
            System.out.println("TcReferencesView row count: " + rsi.getRowCount());
            Row row = null;
            while (rsi.hasNext()) {
                row = rsi.next();
                if (row != null) {
                    row.setAttribute("SelectRow", true);
                    row.setAttribute("TcExcluded", "N");
                    
                    RMIManualTradeComplianceAppModuleImpl am = getAm();

                    AdfUtils.callDbFunction(am, Types.VARCHAR,
                                                         "RMI_GENERIC_TC.update_master_individual(?,?,?,?)", new Object[] {
                                                         row.getAttribute("MasterId"), row.getAttribute("AliasId"),
                                                         row.getAttribute("XrefId"), row.getAttribute("TcExcluded")
                    },"System encountered an exception while saving.");
                }
                
                
            }
            rsi.closeRowSetIterator();
            
            fetchTcReferencesOws();
            
            AdfFacesContext.getCurrentInstance().addPartialTarget(tcReferencesTableBind);
        } catch (Exception e) {
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while performing Select All." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while performing Select All.",
                         "Please contact your System Administrator.", "Vetting", "selectAllCheckBoxAction", e);
        }
        System.out.println("End selectAllCheckBoxAction");
        return null;
    }
    //T20220323.0025 - Issue with vettings being automatically check mark... (IRI)
    public String deselectAllCheckBoxAction() {
        System.out.println("Start deselectAllCheckBoxAction");
        try {
            
            fetchTcReferencesOws();
            
            ViewObject tcRefVO = ADFUtils.findIterator("TcReferencesView1Iterator").getViewObject();
            RowSetIterator rsi = tcRefVO.createRowSetIterator(null);
            System.out.println("TcReferencesView row count: " + rsi.getRowCount());
            Row row = null;
            while (rsi.hasNext()) {
                row = rsi.next();
                if (row != null) {
                    row.setAttribute("SelectRow", false);
                    row.setAttribute("TcExcluded", "Y");
                    
                    RMIManualTradeComplianceAppModuleImpl am = getAm();

                    AdfUtils.callDbFunction(am, Types.VARCHAR,
                                                         "RMI_GENERIC_TC.update_master_individual(?,?,?,?)", new Object[] {
                                                         row.getAttribute("MasterId"), row.getAttribute("AliasId"),
                                                         row.getAttribute("XrefId"), row.getAttribute("TcExcluded")
                    },"System encountered an exception while saving.");
                }
            }
            rsi.closeRowSetIterator();
            
            fetchTcReferencesOws();
            
            AdfFacesContext.getCurrentInstance().addPartialTarget(tcReferencesTableBind);
            
        } catch (Exception e) {
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while performing Deselect All." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
            logGenericTC(LogUtils.ERROR, "System encountered an exception while performing Deselect All.",
                         "Please contact your System Administrator.", "Vetting", "deselectAllCheckBoxAction", e);
        }
        System.out.println("End deselectAllCheckBoxAction");
        return null;
    }

    public void selectProvisionalVCL(ValueChangeEvent valueChangeEvent) {
        // Add event code here...
        
        System.out.println("selectProvisionalVCL");
        
        valueChangeEvent.getComponent().processUpdates(FacesContext.getCurrentInstance());
        setPRVFT( (Boolean) valueChangeEvent.getNewValue() );
        
        FacesContext fctx = FacesContext.getCurrentInstance();
        ExternalContext ectx = fctx.getExternalContext();
        Map m = ectx.getRequestParameterMap();
        Map pMap =  ADFContext.getCurrent().getPageFlowScope();
        Map sessionMap = ADFContext.getCurrent().getSessionScope();
        
        System.out.println("PRVFT: "+PRVFT);
        System.out.println("P_SOURCE_TABLE:"+pMap.get("P_SOURCE_TABLE"));
        
        // T20230330.0026 - LONO - TC Department (IRI)
        if (PRVFT) {
        
            /* Provisional Check */
            // tsuazo 08/21/2020
            //String sourceTable = (String) pMap.get("P_SOURCE_TABLE");
            String sourceTable = pMap.get("P_SOURCE_TABLE").toString();
            String docType = null;
            
            if (sourceTable != null) {
                Integer lInstr = sourceTable.indexOf('_');
                String lSourceTab = sourceTable.substring(0,lInstr);
                
                System.out.println("lInstr:"+lInstr);
                System.out.println("lSourceTab:"+lSourceTab);

                List<String> list = Arrays.asList("SICD");
                boolean isExists = list.contains(lSourceTab);
                
                
                if (isExists) {
                    
                    // tsuazo 08/21/2020
                    //Integer sourceId = Integer.valueOf((String) pMap.get("P_SOURCE_ID"));
                    Integer sourceId = Integer.valueOf(pMap.get("P_SOURCE_ID").toString());
                    
                    // tsuazo 08/21/22023
                    //RMIManualTradeComplianceAppModuleImpl amImpl = (RMIManualTradeComplianceAppModuleImpl) ADFUtils.getApplicationModuleForDataControl("RMIManualTradeComplianceAppModuleDataControl");
                    AppModuleImpl amImpl = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");                    Statement datasource = amImpl.getDBTransaction().createStatement(0);
                    
                    String sqlQuery = "SELECT RMI_SICD_PUB_EXT.get_seafarer_doc_type(?) doc_type FROM DUAL";
                    
                    try {
                        Connection connection = datasource.getConnection();
                        PreparedStatement statement = connection.prepareStatement(sqlQuery);
                        statement.setInt(1, sourceId);
                        ResultSet resultSet = statement.executeQuery();
                        System.out.println("nameScreenContainVCL resultSet:"+resultSet);
                        if (resultSet.next()) {
                            docType = resultSet.getString("doc_type");
                        }
                        
                        //resultSet.close();
                        //statement.close();
                        //connection.close();
                        
                        
                        
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }   
                    
                    System.out.println("nameScreenContainVCL onLoad docType: "+docType);
                    
                }
            }

            // T20230601.0005 - Eligible for TC Provisional Approval
            //String sourceTab = (String) m.get("sourceTable");
            // tsuazo 08/21/2020
            //String sourceTab = (String) pMap.get("P_SOURCE_TABLE");
            String sourceTab = pMap.get("P_SOURCE_TABLE").toString();
            
            if (sourceTab != null) {
                Integer lInstr = sourceTab.indexOf('_');
                String lSourceTab = sourceTab.substring(0,lInstr);                
                System.out.println("lInstr:"+lInstr);
                System.out.println("lSourceTab:"+lSourceTab);
                
                // T20230330.0026 - LONO - TC Department (IRI)
                List<String> list = Arrays.asList("SICD","NRMI","LONO");
                boolean isExists = list.contains(lSourceTab);
                if (isExists) {
                    pMap.put("Provisional","Y");
                    
                    if (lSourceTab.equals("SICD")) {
                        
                        // pMap.put("ProvisionalDocumentType","PRVFT");
                        
                        if (docType != null) {
                            pMap.put("Provisional","Y");
                            pMap.put("ProvisionalDocumentType",docType);                             
                        } else {
                            pMap.put("Provisional","N");
                            pMap.put("ProvisionalDocumentType",null); 
                        }
                        
                        
                        
                    } else if (lSourceTab.equals("NRMI")) {
                        pMap.put("ProvisionalDocumentType","NRMI");
                    } else if (lSourceTab.equals("LONO")) {
                        pMap.put("ProvisionalDocumentType","LONO");     
                    }
                    
                } else {
                    pMap.put("Provisional","N");
                    pMap.put("ProvisionalDocumentType",null);   
                }
                
            }            
            
            System.out.println("Provisional:"+pMap.get("Provisional"));
            System.out.println("ProvisionalDocumentType:"+pMap.get("ProvisionalDocumentType"));
            
            /* End Provisional Check */
        }
        
    }
    

    public void nameScreenContainVCL(ValueChangeEvent valueChangeEvent) {
        // T20220412.0031  vetting creation error (IRI)
        
        System.out.println("nameScreenContainVCL");
        
        valueChangeEvent.getComponent().processUpdates(FacesContext.getCurrentInstance());
        
        String nameScreenedSearchStr = valueChangeEvent.getNewValue().toString();
        
        if(nameScreenedSearchStr == null || "".equals(nameScreenedSearchStr))
            
        {
            System.out.println("Vetting nameScreenContainVCL");
            
            LovVettingsNameScreenedViewImpl lvo =
                (LovVettingsNameScreenedViewImpl) ADFUtils.findIterator("LovVettingsNameScreenedView1Iterator").getViewObject();        
            ViewCriteria vc = lvo.getViewCriteriaManager().getViewCriteria("LovVettingsNameScreenedViewCriteria");            
            lvo.executeEmptyRowSet();
            RichTable tab = (RichTable) JSFUtils.findComponentInRoot("t4");             
            AdfFacesContext.getCurrentInstance().addPartialTarget(tab);
            
            return;
        }
        
        // T20220412.0031  vetting creation error (IRI)
        // TSUAZO -- Need to fix nameScreenedSearchStr containing apostrophe in the value
        
        // tsuazo 08/21/22023
        //RMIManualTradeComplianceAppModuleImpl amImpl = (RMIManualTradeComplianceAppModuleImpl) ADFUtils.getApplicationModuleForDataControl("RMIManualTradeComplianceAppModuleDataControl");
        AppModuleImpl amImpl = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");        Statement datasource = amImpl.getDBTransaction().createStatement(0);
        
        String sqlQuery = "SELECT TRIM(XWRL_UTILS.CLEANSE_NAME(UPPER(?))) clean_name FROM DUAL";
        String cleanName = null;
        
        
        try {
            Connection connection = datasource.getConnection();
            PreparedStatement statement = connection.prepareStatement(sqlQuery);
            statement.setString(1, nameScreenedSearchStr);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                cleanName = resultSet.getString("clean_name");
            }
            
            //resultSet.close();
            //statement.close();
            //connection.close();
            
            System.out.println("nameScreenContainVCL ParameterValue:"+cleanName);
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        
        //T20220218.0020 - FW: "Advanced" Search function
        StringBuilder sql = new StringBuilder();
        //sql.append("XWRL_UTILS.CLEANSE_NAME(UPPER(Full_name)) ");        
        sql.append("Full_name ");        
        switch(selectedAdvFilter) {
        case "STARTS_WITH":
            sql.append(" LIKE ");
            sql.append(" UPPER('");
            sql.append(cleanName);
            sql.append("') || '%'");
            break;
        case "ENDS_WITH":
            sql.append(" LIKE ");
            sql.append("'%' || UPPER('");
            sql.append(cleanName);
            sql.append("')");
            break;
        case "EQUALS":
            sql.append(" = ");
            sql.append(" UPPER('");
            sql.append(cleanName);
            sql.append("')");
            break;
        case "DOES_NOT_EQUAL":
            sql.append(" <> ");
            sql.append(" UPPER('");
            sql.append(cleanName);
            sql.append("')");
            break;
            case "CONTAINS":
                sql.append(" LIKE ");        
                //sql.append(" '%' || REPLACE(XWRL_UTILS.CLEANSE_NAME(UPPER('");
                //sql.append(cleanName);
                //sql.append("')),' ','%') || '%'");
                //T20220412.0031  vetting creation error (IRI)
                sql.append("'%");
                sql.append(cleanName);
                sql.append("%'");
                break;
            case "DOES_NO_CONTAIN":
                sql.append(" NOT LIKE ");
                //sql.append(" '%' || REPLACE(XWRL_UTILS.CLEANSE_NAME(UPPER('");
                //sql.append(cleanName);
                //sql.append("')),' ','%') || '%'");
                //T20220412.0031  vetting creation error (IRI)
                sql.append("'%");
                sql.append(cleanName);
                sql.append("%'");
                break;
        }
        
        LovVettingsNameScreenedViewImpl vo =
                    (LovVettingsNameScreenedViewImpl) ADFUtils.findIterator("LovVettingsNameScreenedView1Iterator").getViewObject();
        ViewCriteria vc = vo.getViewCriteriaManager().getViewCriteria("LovVettingsNameScreenedViewCriteria");
        vo.applyViewCriteria(vc);                                                            
        vc.ensureVariableManager().setVariableValue("pFullName", cleanName);   
                
        if("-".equals(selectedAdvFilter))
            vo.setWhereClause(null);
        else
            vo.setWhereClause(sql.toString());
        
        vo.executeQuery();        
        
    }

    public void nameScreenedTextVCL(ValueChangeEvent valueChangeEvent) {
        // Add event code here...
        
        //T20220207.0054 - TC 2.0 - TC Name Check Validation
        int ch = hasRecordInOFACORBlockedList(valueChangeEvent.getNewValue());
        if(ch == 0)
            isVettingInfoValid = false;
        else {
            isVettingInfoValid = true;
            return;
        }
        
        //T20211215.0029 - Create Vetting Popup changes
        isVettingInfoValid = false;
        oneSrchResltMsg = "";
        ViewObject dualVO = ADFUtils.findIterator("DualCreateVettingVO1Iterator").getViewObject();
        Row currentRow = dualVO.first();
        
        if("U".equals(currentRow.getAttribute("TransOperationType")))
            return;
        System.out.println("Create searching started");
        RichPopup popup = (RichPopup) JSFUtils.findComponentInRoot("nameScreenedTxtSearchPopup");            
        ResetUtils.reset(popup);
        if(valueChangeEvent.getNewValue() != null && !"".equals(iriUtils.nullStrToSpc(valueChangeEvent.getNewValue()))) 
        {
            
            if(hasName(iriUtils.nullStrToSpc(valueChangeEvent.getNewValue()))) {
                isVettingInfoValid = true;
                iriUtils.displayErrorMessage("Name already exists in association with this record.");
            } else {
            
            
            LovVettingsNameScreenedViewImpl vo =
                (LovVettingsNameScreenedViewImpl) ADFUtils.findIterator("LovVettingsNameScreenedView1Iterator").getViewObject();
            vo.removeViewCriteria("LovVettingsNameScreenedSearch");
            vo.removeViewCriteria("LovVettingsNameScreenedViewCriteria");
            vo.removeViewCriteria("LovVettingsNameScreenedViewCriteria1");
            vo.setWhereClause(null);
            vo.executeEmptyRowSet();
            System.out.println("Vetting nameScreenedTextVCL");
                
            // T20220412.0031  vetting creation error (IRI)    
            // TSUAZO -- Need to fix nameScreenedSearchStr containing apostrophe in the value
            
            // tsuazo 08/21/22023
            //RMIManualTradeComplianceAppModuleImpl amImpl = (RMIManualTradeComplianceAppModuleImpl) ADFUtils.getApplicationModuleForDataControl("RMIManualTradeComplianceAppModuleDataControl");
            AppModuleImpl amImpl = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");            Statement datasource = amImpl.getDBTransaction().createStatement(0);
            
            String sqlQuery = "SELECT XWRL_UTILS.CLEANSE_NAME(UPPER(?)) clean_name FROM DUAL";
            String cleanName = null;
            String parameterValue = (String) valueChangeEvent.getNewValue();
            
            try {
                Connection connection = datasource.getConnection();
                PreparedStatement statement = connection.prepareStatement(sqlQuery);
                statement.setString(1, parameterValue);
                ResultSet resultSet = statement.executeQuery();
                if (resultSet.next()) {
                    cleanName = resultSet.getString("clean_name");
                }
                
                //resultSet.close();
                //statement.close();
                //connection.close();
                
                System.out.println("CleanName: "+cleanName);
                
            } catch (SQLException e) {
                e.printStackTrace();
            }                
                
            if (cleanName != null) {
                ViewCriteria vc = vo.getViewCriteriaManager().getViewCriteria("LovVettingsNameScreenedViewCriteria");
                vo.setNamedWhereClauseParam("pFullName", cleanName);
                vo.applyViewCriteria(vc);
                vo.executeQuery();
            }
                
            System.out.println("Query:"+vo.getQuery());
            int count = vo.getRowCount();
            System.out.println("count:"+count);
            
            if(currentRow != null) {
                currentRow.setAttribute("TransOperationType", "C");
                currentRow.setAttribute("TransSourceTableColumn", RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TABLE_COLUMN"));
                currentRow.setAttribute("TransSourceTable", RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TABLE"));
                currentRow.setAttribute("TransSourceId", RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_ID"));
            }
            if(count == 1) 
            {
                Row row = vo.first();
                
                  //  nameScreenedSearchStr = valueChangeEvent.getNewValue().toString(); // 3 lines added today
                    
                RichPopup onschpup = (RichPopup) JSFUtils.findComponentInRoot("onschpup"); 
                onschpup.show(new RichPopup.PopupHints());
                
                try {
                    if (row != null) {
                        String sourceTab = iriUtils.nullStrToSpc(row.getAttribute("SourceTable"));
                        String sourceId = iriUtils.nullStrToSpc(row.getAttribute("SourceId"));
                        String fullName = iriUtils.nullStrToSpc(row.getAttribute("FullName"));

                        if (sourceTab.contains("SICD")) {
                            oneSrchResltMsg = fullName + " - FIN #" + sourceId;
                        }

                        else if (sourceTab.contains("CORP")) {
                            oneSrchResltMsg = fullName + " - CORP ID #" + sourceId;
                        }

                        else {
                            oneSrchResltMsg = fullName;
                        }
                    }
                } catch (Exception e) {
                    // TODO: Add catch code
                    e.printStackTrace();
                }
                        
            } else if(count > 1) 
            {
                nameScreenedSearchStr = valueChangeEvent.getNewValue().toString();
                popup.show(new RichPopup.PopupHints());
            }
            else if(count ==0) // added this else condition today
                {
                   // nameScreenedSearchStr = valueChangeEvent.getNewValue().toString();
                    RichPopup nschpup = (RichPopup) JSFUtils.findComponentInRoot("nschpup"); 
                    nschpup.show(new RichPopup.PopupHints());
                }
            }
        }
        
        AdfFacesContext.getCurrentInstance().addPartialTarget(JSFUtils.findComponentInRoot("pgl2"));

        runCount = 1;
        
    }    

    public void nameScreenedButtonAL(ActionEvent actionEvent) {
        

        
        // T20220412.0031  vetting creation error (IRI)
        
        System.out.println("Vetting nameScreenedButtonAL");
        
        RichInputText fullName = (RichInputText) JSFUtils.findComponentInRoot("it17");
        nameScreenedSearchStr = (String) fullName.getValue();
                
        System.out.println("Vetting nameScreenedButtonAL fullNameValue: "+nameScreenedSearchStr);

        if(nameScreenedSearchStr == null || "".equals(nameScreenedSearchStr)) {
            
            LovVettingsNameScreenedViewImpl lvo =
                (LovVettingsNameScreenedViewImpl) ADFUtils.findIterator("LovVettingsNameScreenedView1Iterator").getViewObject();        
            ViewCriteria vc = lvo.getViewCriteriaManager().getViewCriteria("LovVettingsNameScreenedViewCriteria");            
            lvo.executeEmptyRowSet();
        
            RichPopup popUp = (RichPopup) JSFUtils.findComponentInRoot("nameScreenedTxtSearchPopup");        
            RichPopup.PopupHints hints = new RichPopup.PopupHints();        
            popUp.show(hints);
        
        } else {
            if (runCount == 1) {
                runCount = 0;
                return;
            }       
            
        }
 
        //T20220207.0054 - TC 2.0 - TC Name Check Validation
        int ch = hasRecordInOFACORBlockedList(nameScreenedSearchStr);
        if(ch == 0)
            isVettingInfoValid = false;
        else {
            isVettingInfoValid = true;
            return;
        }
        
        //T20211215.0029 - Create Vetting Popup changes
        isVettingInfoValid = false;
        oneSrchResltMsg = "";
        ViewObject dualVO = ADFUtils.findIterator("DualCreateVettingVO1Iterator").getViewObject();
        Row currentRow = dualVO.first();
        
        if("U".equals(currentRow.getAttribute("TransOperationType")))
            return;
        System.out.println("Create searching started");
        RichPopup popup = (RichPopup) JSFUtils.findComponentInRoot("nameScreenedTxtSearchPopup");            
        ResetUtils.reset(popup);
        if(nameScreenedSearchStr != null && !"".equals(iriUtils.nullStrToSpc(nameScreenedSearchStr))) 
        {
            if(hasName(iriUtils.nullStrToSpc(nameScreenedSearchStr))) {
                isVettingInfoValid = true;
                iriUtils.displayErrorMessage("Name already exists in association with this record.");
            } else {
            
            LovVettingsNameScreenedViewImpl vo =
                (LovVettingsNameScreenedViewImpl) ADFUtils.findIterator("LovVettingsNameScreenedView1Iterator").getViewObject();
            vo.removeViewCriteria("LovVettingsNameScreenedSearch");
            vo.removeViewCriteria("LovVettingsNameScreenedViewCriteria");
            vo.removeViewCriteria("LovVettingsNameScreenedViewCriteria1");
            vo.setWhereClause(null);
            vo.executeEmptyRowSet();
            System.out.println("Vetting nameScreenedButtonAL");
                
            // T20220412.0031  vetting creation error (IRI)    
            // TSUAZO -- Need to fix nameScreenedSearchStr containing apostrophe in the value
            
            // tsuazo 08/21/22023
            //RMIManualTradeComplianceAppModuleImpl amImpl = (RMIManualTradeComplianceAppModuleImpl) ADFUtils.getApplicationModuleForDataControl("RMIManualTradeComplianceAppModuleDataControl");
            AppModuleImpl amImpl = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");            Statement datasource = amImpl.getDBTransaction().createStatement(0);
            
            String sqlQuery = "SELECT XWRL_UTILS.CLEANSE_NAME(UPPER(?)) clean_name FROM DUAL";
            String cleanName = null;
            String parameterValue = nameScreenedSearchStr;
            
            try {
                Connection connection = datasource.getConnection();
                PreparedStatement statement = connection.prepareStatement(sqlQuery);
                statement.setString(1, parameterValue);
                ResultSet resultSet = statement.executeQuery();
                if (resultSet.next()) {
                    cleanName = resultSet.getString("clean_name");
                }
                
                //resultSet.close();
                //statement.close();
                //connection.close();
                
                System.out.println("CleanName :"+cleanName);
                
            } catch (SQLException e) {
                e.printStackTrace();
            }                
                
            if (cleanName != null) {
                ViewCriteria vc = vo.getViewCriteriaManager().getViewCriteria("LovVettingsNameScreenedViewCriteria");
                vo.setNamedWhereClauseParam("pFullName", cleanName);
                vo.applyViewCriteria(vc);
                vo.executeQuery();
            }
                
            System.out.println("Query:"+vo.getQuery());
            int count = vo.getRowCount();
            System.out.println("count:"+count);
            
            if(currentRow != null) {
                currentRow.setAttribute("TransOperationType", "C");
                currentRow.setAttribute("TransSourceTableColumn", RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TABLE_COLUMN"));
                currentRow.setAttribute("TransSourceTable", RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_TABLE"));
                currentRow.setAttribute("TransSourceId", RequestContext.getCurrentInstance().getPageFlowScope().get("P_SOURCE_ID"));
            }
            if(count == 1) 
            {
                Row row = vo.first();
                
                  //  nameScreenedSearchStr = valueChangeEvent.getNewValue().toString(); // 3 lines added today
                    
                RichPopup onschpup = (RichPopup) JSFUtils.findComponentInRoot("onschpup"); 
                onschpup.show(new RichPopup.PopupHints());
                
                try {
                    if (row != null) {
                        String sourceTab = iriUtils.nullStrToSpc(row.getAttribute("SourceTable"));
                        String sourceId = iriUtils.nullStrToSpc(row.getAttribute("SourceId"));
                        //String fullName = iriUtils.nullStrToSpc(row.getAttribute("FullName"));

                        if (sourceTab.contains("SICD")) {
                            oneSrchResltMsg = nameScreenedSearchStr + " - FIN #" + sourceId;
                        }

                        else if (sourceTab.contains("CORP")) {
                            oneSrchResltMsg = nameScreenedSearchStr + " - CORP ID #" + sourceId;
                        }

                        else {
                            oneSrchResltMsg = nameScreenedSearchStr;
                        }
                    }
                } catch (Exception e) {
                    // TODO: Add catch code
                    e.printStackTrace();
                }
                        
            } else if(count > 1) 
            {
                popup.show(new RichPopup.PopupHints());
            }
            else if(count ==0) // added this else condition today
                {
                   // nameScreenedSearchStr = valueChangeEvent.getNewValue().toString();
                    RichPopup nschpup = (RichPopup) JSFUtils.findComponentInRoot("nschpup"); 
                    nschpup.show(new RichPopup.PopupHints());
                }
            }
        }
        
        AdfFacesContext.getCurrentInstance().addPartialTarget(JSFUtils.findComponentInRoot("pgl2"));
        
                
    }

}
