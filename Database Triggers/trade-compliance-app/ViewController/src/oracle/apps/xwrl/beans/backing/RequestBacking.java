package oracle.apps.xwrl.beans.backing;

import com.rmi.manualtradecompliance.utils.ADFUtils;

import com.rmi.manualtradecompliance.utils.IRIUtils;
import com.rmi.manualtradecompliance.utils.JSFUtils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import java.math.BigDecimal;

import java.sql.Array;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.faces.application.FacesMessage;
import javax.faces.application.ViewHandler;
import javax.faces.component.UIComponent;
import javax.faces.component.UIViewRoot;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.faces.event.ValueChangeEvent;
import javax.faces.model.SelectItem;

import javax.imageio.ImageIO;

import oracle.adf.controller.ControllerContext;
import oracle.adf.model.BindingContext;
import oracle.adf.model.binding.DCBindingContainer;
import oracle.adf.model.binding.DCIteratorBinding;
import oracle.adf.share.ADFContext;
import oracle.adf.share.logging.ADFLogger;
import oracle.adf.view.rich.component.rich.RichForm;
import oracle.adf.view.rich.component.rich.RichPopup;
import oracle.adf.view.rich.component.rich.data.RichTable;
import oracle.adf.view.rich.component.rich.input.RichInputText;
import oracle.adf.view.rich.component.rich.input.RichSelectBooleanCheckbox;
import oracle.adf.view.rich.component.rich.input.RichSelectManyChoice;
import oracle.adf.view.rich.component.rich.input.RichSelectOneChoice;
import oracle.adf.view.rich.component.rich.layout.RichPanelFormLayout;
import oracle.adf.view.rich.component.rich.nav.RichButton;
import oracle.adf.view.rich.component.rich.output.RichMessages;
import oracle.adf.view.rich.context.AdfFacesContext;
import oracle.adf.view.rich.event.DialogEvent;
import oracle.adf.view.rich.event.LaunchPopupEvent;
import oracle.adf.view.rich.event.PopupCanceledEvent;
import oracle.adf.view.rich.event.PopupFetchEvent;
import oracle.adf.view.rich.event.ReturnPopupDataEvent;
import oracle.adf.view.rich.event.ReturnPopupEvent;
import oracle.adf.view.rich.util.ResetUtils;

import oracle.apps.xwrl.beans.session.UserRespAndSessionInfo;

import oracle.apps.xwrl.beans.utils.Alert;
import oracle.apps.xwrl.model.am.AppModuleImpl;
import oracle.apps.xwrl.model.view.XwrlRequestsViewImpl;
import oracle.apps.xwrl.model.view.XwrlRequestsViewRowImpl;
import oracle.apps.xwrl.model.view.XwrlResponseEntityColumnsViewImpl;
import oracle.apps.xwrl.model.view.XwrlResponseIndColumnsViewImpl;

import oracle.binding.AttributeBinding;
import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

import oracle.jbo.Key;
import oracle.jbo.NameValuePairs;
import oracle.jbo.Row;
import oracle.jbo.RowIterator;
import oracle.jbo.RowSet;
import oracle.jbo.RowSetIterator;
import oracle.jbo.ViewCriteria;
import oracle.jbo.ViewObject;
import oracle.jbo.server.RowFinder;
import oracle.jbo.server.ViewObjectImpl;

import oracle.jdbc.OracleConnection;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.SystemUtils;
import org.apache.myfaces.trinidad.event.DisclosureEvent;
import org.apache.myfaces.trinidad.event.SelectionEvent;
import org.apache.myfaces.trinidad.model.RowKeySet;
import org.apache.myfaces.trinidad.model.RowKeySetImpl;


public class RequestBacking {

    private static ADFLogger LOGGER = ADFLogger.createADFLogger(RequestBacking.class);
    private RichInputText varSourceTable;
    private RichInputText varSourceId;
    private RichSelectBooleanCheckbox varVesselInd;
    
    private List<SelectItem> IndNotesAllValuesList;
    private List IndNotesSelectedValues;
    private List<SelectItem> EntNotesAllValuesList;
    private List EntNotesSelectedValues;
    private Date dateOfBirth;
    //private RichPanelHeader panelHeaderObj;
    
    //T20200715.0011 - OWS TC: Add Address Confirmation Date field in Request Page
    private Date addressConfirmationDate;

    public void setAddressConfirmationDate(Date addressConfirmationDate) {
        this.addressConfirmationDate = addressConfirmationDate;
    }

    public Date getAddressConfirmationDate() {
        return addressConfirmationDate;
    }
    
    //T20220217.0020 - TC 2.0 - Enhancement - East Asian Origin Name
    private Boolean eastAsianOiginName;

    public void setEastAsianOiginName(Boolean eastAsianOiginName) {
        this.eastAsianOiginName = eastAsianOiginName;
    }

    public Boolean getEastAsianOiginName() {
        return eastAsianOiginName;
    }
    
    //T20220304.0005 - TC 2.0 enhancement - Address for corporate users
    private String permanentAddress;

    public void setPermanentAddress(String permanentAddress) {
        this.permanentAddress = permanentAddress;
    }

    public String getPermanentAddress() {
        return permanentAddress;
    }

    //T20210127.0038 - Known Party
    private Date knownPartyStartDate, knownPartyEndDate;
    private boolean approved = false;
    public void setKnownPartyStartDate(Date knownPartyStartDate) {
        this.knownPartyStartDate = knownPartyStartDate;
    }

    public Date getKnownPartyStartDate() {
        return knownPartyStartDate;
    }
    
    private String knownPartyFlag = "No";

    public void setKnownPartyFlag(String knownPartyFlag) {
        this.knownPartyFlag = knownPartyFlag;
    }

    public String getKnownPartyFlag() {
        try {
            knownPartyFlag = "No";
            BigDecimal aliasId=null,masterId=null, xrefId=null;
                    
            if(JSFUtils.resolveExpressionAsBigDecimal("#{bindings.AliasId.inputValue}") != null)
                aliasId = JSFUtils.resolveExpressionAsBigDecimal("#{bindings.AliasId.inputValue}");
            if(JSFUtils.resolveExpressionAsBigDecimal("#{bindings.MasterId.inputValue}") != null)
                masterId = JSFUtils.resolveExpressionAsBigDecimal("#{bindings.MasterId.inputValue}");
            if(JSFUtils.resolveExpressionAsBigDecimal("#{bindings.XrefId.inputValue}") != null)
                xrefId = JSFUtils.resolveExpressionAsBigDecimal("#{bindings.XrefId.inputValue}");
            
            List params=new ArrayList();
            if(masterId != null)
                params.add(masterId.intValue());
            else 
                params.add(null);
            
            if(aliasId != null)
                params.add(aliasId.intValue());
            else
                params.add(null);
            
            if(xrefId != null)
                params.add(xrefId.intValue());
            else
                params.add(null);
            
            ResultSet rs = utils.getPlSqlFunctionData("select 'Yes' from xwrl_party_master where id=rmi_ows_common_util.get_master_id(?,?,?)\n" + 
            "AND known_party_start_date IS NOT NULL \n" + 
            "AND trunc(sysdate) BETWEEN known_party_start_date AND nvl(known_party_end_date, trunc(sysdate))" , params);
            if(rs.next()){
                knownPartyFlag = "Yes";
            }
            rs.close();
            
        }catch(Exception e){
            e.printStackTrace();
        }
        return knownPartyFlag;
    }

    public void setKnownPartyEndDate(Date knownPartyEndDate) {
        this.knownPartyEndDate = knownPartyEndDate;
    }

    public Date getKnownPartyEndDate() {
        return knownPartyEndDate;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    private HashMap reOrderMap = new HashMap();

	public void setReOrderMap(HashMap reOrderMap) 
	{
		this.reOrderMap = reOrderMap;
	}

	public HashMap getReOrderMap() 
	{
		return reOrderMap;
	}

  public void setVarVesselInd(RichSelectBooleanCheckbox varVesselInd)
  {
    this.varVesselInd = varVesselInd;
  }

  public RichSelectBooleanCheckbox getVarVesselInd()
  {
    return varVesselInd;
  }

  public RequestBacking() 
  {
      UserRespAndSessionInfo userRespAndSessionInfo = (UserRespAndSessionInfo) JSFUtils.getManagedBeanValue("sessionScope.UserRespAndSessionInfo");
      String superUsr= "";
      String readMode = "";
	  String path = "";
      DCIteratorBinding tabIter = null;
      Row row =null;
	 
      
	   if(userRespAndSessionInfo!=null)
	  {
	    superUsr  = userRespAndSessionInfo.getIsSuperUserOnly();
		readMode  = userRespAndSessionInfo.getIsReadOnly();
	  }
          
       if (superUsr.equals("Y"))
	   {
           ////T20200828.0004 - Summary column in 1st coulmn- OWS- TC
	       int columnsOrder=1;
           //T20200821.0045 - FW: Summary column (IRI)
		    reOrderMap.put("Summary", columnsOrder++);
			reOrderMap.put("Rec", columnsOrder++);
			reOrderMap.put("LegalReview", columnsOrder++);
	                reOrderMap.put("CorporateReview", columnsOrder++);
			reOrderMap.put("Category", columnsOrder++);
			reOrderMap.put("Listfullname", columnsOrder++);
			
			reOrderMap.put("Stateattr", columnsOrder++);
			reOrderMap.put("Samestate", columnsOrder++);
			
			reOrderMap.put("Listdob", columnsOrder++);
			reOrderMap.put("Dnyob", columnsOrder++);
			reOrderMap.put("Dngender", columnsOrder++);
			
			reOrderMap.put("Deceasedflag", columnsOrder++);
			reOrderMap.put("Deceaseddate", columnsOrder++);
			
			reOrderMap.put("Listnametype", columnsOrder++);
			reOrderMap.put("Listfamilyname", columnsOrder++);
			reOrderMap.put("Listgivennames", columnsOrder++);
			
			reOrderMap.put("Dnresidencycountrycode", columnsOrder++);
			reOrderMap.put("Listnationality", columnsOrder++);
			reOrderMap.put("Listcountry", columnsOrder++);
			reOrderMap.put("Listcity", columnsOrder++);
			
			reOrderMap.put("Dnstate", columnsOrder++);
			reOrderMap.put("Listcountryofbirth", columnsOrder++);
			reOrderMap.put("Dnaddress", columnsOrder++);
			reOrderMap.put("Dntitle", columnsOrder++);
			
			reOrderMap.put("Dnpassportnumber", columnsOrder++);
			
			reOrderMap.put("Dnnationalid", columnsOrder++);
			reOrderMap.put("Externalsources", columnsOrder++);
			
			reOrderMap.put("Cachedextsources", columnsOrder++);
			reOrderMap.put("Dnaddeddate", columnsOrder++);
			reOrderMap.put("Dnlastupdateddate", columnsOrder++);
			reOrderMap.put("Matchscore", columnsOrder++);
			
			reOrderMap.put("Listid", columnsOrder++);
			reOrderMap.put("Listkey", columnsOrder++);
	   }
	    if ((superUsr.equals("N") && readMode.equals("Y")) || userRespAndSessionInfo == null)
	   { 
	       //T20200828.0004 - Summary column in 1st coulmn- OWS- TC
                        int columnsOrder=1;	   
                        reOrderMap.put("Summary",columnsOrder++);
			reOrderMap.put("LegalReview", columnsOrder++);
	                reOrderMap.put("CorporateReview", columnsOrder++);
			reOrderMap.put("Rec", columnsOrder++);
			reOrderMap.put("Listfullname", columnsOrder++);
			reOrderMap.put("Stateattr", columnsOrder++);
			reOrderMap.put("Samestate", columnsOrder++);
			
			reOrderMap.put("Listnametype", columnsOrder++);
			reOrderMap.put("Listfamilyname", columnsOrder++);
			reOrderMap.put("Listgivennames", columnsOrder++);
			reOrderMap.put("Listdob", columnsOrder++);
			
			reOrderMap.put("Dnyob", columnsOrder++);
			reOrderMap.put("Dngender", columnsOrder++);
			reOrderMap.put("Deceasedflag", columnsOrder++);
			reOrderMap.put("Deceaseddate", columnsOrder++);
			
			reOrderMap.put("Dnresidencycountrycode", columnsOrder++);
			reOrderMap.put("Listnationality", columnsOrder++);
			reOrderMap.put("Listcountry", columnsOrder++);
			reOrderMap.put("Listcity", columnsOrder++);
			
			reOrderMap.put("Dnstate", columnsOrder++);
			reOrderMap.put("Listcountryofbirth", columnsOrder++);
			reOrderMap.put("Dnaddress", columnsOrder++);
			reOrderMap.put("Dntitle", columnsOrder++);
			
			reOrderMap.put("Dnpassportnumber", columnsOrder++);
			reOrderMap.put("Category", columnsOrder++);
			reOrderMap.put("Dnnationalid", columnsOrder++);
			reOrderMap.put("Externalsources", columnsOrder++);
			
			reOrderMap.put("Cachedextsources", columnsOrder++);
			reOrderMap.put("Dnaddeddate", columnsOrder++);
			reOrderMap.put("Dnlastupdateddate", columnsOrder++);
			reOrderMap.put("Matchscore", columnsOrder++);
			
			reOrderMap.put("Listid", columnsOrder++);
			reOrderMap.put("Listkey", columnsOrder++);
	   }

        try {
            tabIter = ADFUtils.findIterator("XwrlRequestsView1Iterator");
            row = tabIter.getCurrentRow();
            path = utils.nullStrToSpc(row.getAttribute("Path"));

            path = utils.nullStrToSpc(JSFUtils.resolveExpressionAsString("#{bindings.Path.inputValue}"));
            LOGGER.finest("Path during onload:: " + path);


            if ("ENTITY".equals(path)) {
                calEntRecordStateCount();
            } else {
                calIndRecordStateCount();
            }
        } catch (Exception e) {
            // TODO: Add catch code
            e.printStackTrace();
        }
      getAllAliasNames();
      initializeKnownParty();
      reformatDateOfBirth();
      
  }
  
  private void reformatDateOfBirth() {
      try{
          String dob = JSFUtils.resolveExpressionAsString("#{bindings.DateOfBirth.inputValue}");
          if(dob != null && !"".equals(dob)){
              dob=dob.split("T")[0];
              SimpleDateFormat format=new SimpleDateFormat("yyyyMMdd");
              SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd");
              if(dob.contains("-"))
                  dateOfBirth = format1.parse(dob);
              else
                  dateOfBirth = format.parse(dob);
          }
      } catch(Exception e) {
          e.printStackTrace();
      }
  }
  
  private void initializeKnownParty(){
      
      LOGGER.finest("initializeKnownParty - start");
      
      try{
          ////T20210127.0038 - Known Party
          BigDecimal masterId=null,aliasId=null,xrefId=null;
          if(JSFUtils.resolveExpressionAsBigDecimal("#{bindings.MasterId.inputValue}") != null)
              masterId = JSFUtils.resolveExpressionAsBigDecimal("#{bindings.MasterId.inputValue}");
          
          if(JSFUtils.resolveExpressionAsBigDecimal("#{bindings.AliasId.inputValue}") != null)
              aliasId = JSFUtils.resolveExpressionAsBigDecimal("#{bindings.AliasId.inputValue}");
          
          if(JSFUtils.resolveExpressionAsBigDecimal("#{bindings.XrefId.inputValue}") != null)
              xrefId = JSFUtils.resolveExpressionAsBigDecimal("#{bindings.XrefId.inputValue}");

          List params = new ArrayList();
          if(masterId != null)
              params.add(masterId.intValue());
          else 
              params.add(null);
          
          if(aliasId != null)
              params.add(aliasId.intValue());
          else
              params.add(null);
          
          if(xrefId != null)
              params.add(xrefId.intValue());
          else
              params.add(null);
          
          LOGGER.finest("initializeKnownParty PLSQL call");
          
          ResultSet rs = utils.getPlSqlFunctionData("select KNOWN_PARTY_START_DATE,KNOWN_PARTY_END_DATE from xwrl_party_master where id=rmi_ows_common_util.get_master_id(?,?,?) ", params);
          
          if(rs.next()){
              knownPartyStartDate = rs.getDate("KNOWN_PARTY_START_DATE");
              knownPartyEndDate = rs.getDate("KNOWN_PARTY_END_DATE");
          }else{
              knownPartyStartDate = knownPartyEndDate = null;
          }
          rs.close();
          getKnownPartyFlag();
          
          LOGGER.finest("initializeKnownParty - finish");
          
          
      }catch(Exception e){
          e.printStackTrace();
      }
  }
  
  private String aliasNames;

    public void setAliasNames(String aliasNames) {
        this.aliasNames = aliasNames;
    }

    public String getAliasNames() {
        return aliasNames;
    }
    
    /**
     * Display Alias Names for Primary in OWS Statusboard Application T20200501.0010
     */
    private void getAllAliasNames(){
        
      LOGGER.finest("getAllAliasNames");   
        
      AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
      ViewObject vo = am.getGetAliasNamesRVO1();
      ViewCriteria vc = vo.getViewCriteriaManager().getViewCriteria("GetAliasNamesRVOCriteria");
      Object reqId=am.getXwrlRequestsView1().getCurrentRow().getAttribute("Id");
      
      LOGGER.finest("getAllAliasNames ReqId:"+reqId);
      
      vo.setNamedWhereClauseParam("p_requestId", utils.nullStrToSpc(reqId));
      vo.applyViewCriteria(vc);
      vo.executeQuery();
      aliasNames="";
      while(vo.hasNext()){
          Row row=vo.next();
          if(aliasNames != null && !"".equals(aliasNames))
              aliasNames += ",";
          aliasNames +=utils.nullStrToSpc(row.getAttribute("AliasFullName"));
      }
  }

    IRIUtils utils = new IRIUtils();
	
    public void messageActionListener(ActionEvent actionEvent) {
        // Add event code here...
        String msg = "This is a test.";
        FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_INFO, msg.toString(), null);
        FacesContext.getCurrentInstance().addMessage(null, message);

    }

    public boolean isInlineMessage() {
        boolean lowPriorityMessage = true;
        Iterator<FacesMessage> iter = FacesContext.getCurrentInstance().getMessages();
        while (iter.hasNext()) {
            FacesMessage msg = iter.next();
            if (msg.getSeverity() == FacesMessage.SEVERITY_ERROR || msg.getSeverity() == FacesMessage.SEVERITY_FATAL) {
                lowPriorityMessage = false;
                break;
            }
        }
        RichMessages comp = (RichMessages) JSFUtils.findComponentInRoot("pt_m1");
        AdfFacesContext.getCurrentInstance().addPartialTarget(comp);
        return lowPriorityMessage;
    }

    public void save() {
        utils.displaySuccessMessage("Case changes saved Successfully");
    }

    public void cancel() {
        utils.displaySuccessMessage("Case changes cancelled ");
    }

    private void clearMessages() {
        FacesContext context = FacesContext.getCurrentInstance();
        Iterator<FacesMessage> it = context.getMessages();
        while (it.hasNext()) {
            it.next();
            it.remove();
        }
    }

    public void vesselIndicator(ValueChangeEvent valueChangeEvent) {
        // Add event code here...
        LOGGER.finest("vesselIndicator");
        LOGGER.finest("Old Value: " + valueChangeEvent.getOldValue());
        LOGGER.finest("New Value: " + valueChangeEvent.getNewValue());
        UIComponent comp = valueChangeEvent.getComponent();
        comp.processUpdates(FacesContext.getCurrentInstance());
    }

    public void setVarSourceTable(RichInputText varSourceTable) {
        this.varSourceTable = varSourceTable;
    }

    public RichInputText getVarSourceTable() {
        ADFContext adfCtx = ADFContext.getCurrent();
        Map pgflowScope = adfCtx.getPageFlowScope();
       String sourceTable = (String) pgflowScope.get("psourceTable");
       
        if (sourceTable != null) {
            ADFUtils.setBoundAttributeValue("varSourceTable1", sourceTable);
        }
        return varSourceTable;
    }

    public void setVarSourceId(RichInputText varSourceId) {
        this.varSourceId = varSourceId;
    }
    
    public void executeLock() 
    {
        RichButton actions = null;
        String suc = "";
        String err = "";
    
        BindingContainer bc = ADFUtils.getBindingContainer();
        OperationBinding lckBd = bc.getOperationBinding("setLock");
        lckBd.execute();
        
    }

    public RichInputText getVarSourceId() {
        ADFContext adfCtx = ADFContext.getCurrent();
       Map pgflowScope = adfCtx.getPageFlowScope();
        String sourceId = (String) pgflowScope.get("psourceId");
        if (sourceId != null) {
            ADFUtils.setBoundAttributeValue("varSourceId1", sourceId);
        }
        return varSourceId;
    }

    public void noteValueChangeListener(ValueChangeEvent valueChangeEvent) {
        // Add event code here...
        LOGGER.finest("noteValueChangeListener");
        LOGGER.finest("Old Value: " + valueChangeEvent.getOldValue());
        LOGGER.finest("New Value: " + valueChangeEvent.getNewValue());
        
        ADFContext adfCtx = ADFContext.getCurrent();
        Map pageFlowScope = adfCtx.getPageFlowScope();
        pageFlowScope.put("noteSelectionItem",valueChangeEvent.getNewValue());
    }
    
  public void varCountryValueChangeListener(ValueChangeEvent valueChangeEvent) 
  {
      // Add event code here...
      LOGGER.finest("noteValueChangeListener");
      LOGGER.finest("Old Value: " + valueChangeEvent.getOldValue());
      LOGGER.finest("New Value: " + valueChangeEvent.getNewValue());
    
    AppModuleImpl am = null;  
    am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
    am.getCaseRestrictedCityLOV1().ensureVariableManager().setVariableValue("varCountryCode",valueChangeEvent.getNewValue());
    am.getCaseRestrictedCityLOV1().executeQuery();
    
    LOGGER.finest("count::"+ am.getCaseRestrictedCityLOV1().getEstimatedRowCount());
  }


  public void priorityValueChangeListener(ValueChangeEvent valueChangeEvent) 
  {
      
      LOGGER.finest("priority: "+ valueChangeEvent.getNewValue());
      LOGGER.finest("dept: "+ JSFUtils.resolveExpression("#{bindings.Department.inputValue}"));
      
      String priority = "";
      
      if(utils.nullStrToSpc(valueChangeEvent.getNewValue()).equals("1")) 
      {
          priority = "High";
      }
      if(utils.nullStrToSpc(valueChangeEvent.getNewValue()).equals("2")) 
      {
          priority = "Medium";
      }
      if(utils.nullStrToSpc(valueChangeEvent.getNewValue()).equals("3")) 
      {
          priority = "Low";
      }
       
      BindingContainer bc = ADFUtils.getBindingContainer();
      OperationBinding coop = bc.getOperationBinding("executeDocType");
      coop.getParamsMap().put("dept", JSFUtils.resolveExpression("#{bindings.Department.inputValue}"));
      coop.getParamsMap().put("priority", priority);
      long cnt = (Long)coop.execute();
      LOGGER.finest("cnt in priority:: "+ cnt);
      
      RichSelectOneChoice soc = (RichSelectOneChoice) JSFUtils.findComponentInRoot("soc21");
      if(cnt==0) 
      {
          soc.setRequired(false);
      }
      else {
          soc.setRequired(true);
      }
      
      utils.refreshComponent(soc);
      
  }
  
    public void deptValueChangeListener(ValueChangeEvent valueChangeEvent) 
    {
        
        LOGGER.finest("dept: "+ valueChangeEvent.getNewValue());
        
        
        String priority = JSFUtils.resolveExpressionAsString("#{bindings.Priority.inputValue}");
        LOGGER.finest("priority: "+ priority);
        
            if(priority.equals("1")) 
            {
                priority = "High";
            }
            if(priority.equals("2")) 
            {
                priority = "Medium";
            }
            if(priority.equals("3")) 
            {
                priority = "Low";
            }
        
        BindingContainer bc = ADFUtils.getBindingContainer();
        OperationBinding coop = bc.getOperationBinding("executeDocType");
        coop.getParamsMap().put("priority", priority);
        coop.getParamsMap().put("dept", valueChangeEvent.getNewValue());
        long cnt = (Long)coop.execute();
        LOGGER.finest("cnt in dept:: "+ cnt);
        
        RichSelectOneChoice soc = (RichSelectOneChoice) JSFUtils.findComponentInRoot("soc21");
        if(cnt==0) 
        {
            soc.setRequired(false);
        }
        else {
            soc.setRequired(true);
        }
        
        utils.refreshComponent(soc);
    }

    public void addressCountryCodeListener(ValueChangeEvent valueChangeEvent) {
        // Add event code here...
        LOGGER.finest("noteValueChangeListener");
        LOGGER.finest("Old Value: " + valueChangeEvent.getOldValue());
        LOGGER.finest("New Value: " + valueChangeEvent.getNewValue());
        
        ADFUtils.setBoundAttributeValue("varAddresscountrycode", valueChangeEvent.getNewValue());
    }
    
  public void vsslIndCodeListener(ValueChangeEvent valueChangeEvent) {
      // Add event code here...
      LOGGER.finest("noteValueChangeListener");
      LOGGER.finest("Old Value: " + valueChangeEvent.getOldValue());
      LOGGER.finest("New Value: " + valueChangeEvent.getNewValue());
      
       
      if(valueChangeEvent.getNewValue().toString().equals("true") ||
      valueChangeEvent.getNewValue().toString().equals(true))
      {
        ADFUtils.setBoundAttributeValue("varVesselInd1", "Y"); 
        LOGGER.finest("Yes::");
      }
      else
      {
        ADFUtils.setBoundAttributeValue("varVesselInd1", null); 
        LOGGER.finest("null::::");
      }
      
      
  }

    public void setIndNotesAllValuesList(List<SelectItem> IndNotesAllValuesList) {
        this.IndNotesAllValuesList = IndNotesAllValuesList;
    }

    public List<SelectItem> getIndNotesAllValuesList() 
    {
        DCIteratorBinding iter = null;
        Row[] aRows = null;
        Row aRow = null;
        String note = "";
        boolean isValid = false;
        try 
        {   
            iter = ADFUtils.findIterator("CustClearAlertLov1Iterator");
            iter.executeQuery();
            aRows = iter.getAllRowsInRange();

            if (aRows != null) 
            {
                IndNotesAllValuesList = new ArrayList<SelectItem>();
                for (int sa = 0; sa < aRows.length; sa++) 
                {
                    aRow = aRows[sa];
                    note = utils.nullStrToSpc(aRow.getAttribute("Note"));
                    
                    IndNotesAllValuesList.add(new SelectItem(note, note));
                }
            }
        } catch (NumberFormatException nfe) 
        {
            // TODO: Add catch code
            nfe.printStackTrace();
        }
        catch (Exception e) 
        {
            // TODO: Add catch code
            e.printStackTrace();
        }
        
        return IndNotesAllValuesList;
    }

    public void setIndNotesSelectedValues(List IndNotesSelectedValues) {
        this.IndNotesSelectedValues = IndNotesSelectedValues;
    }

    public List getIndNotesSelectedValues() {
        return IndNotesSelectedValues;
    }

    public void setEntNotesAllValuesList(List<SelectItem> EntNotesAllValuesList) {
        this.EntNotesAllValuesList = EntNotesAllValuesList;
    }

    public List<SelectItem> getEntNotesAllValuesList() 
    {
        DCIteratorBinding iter = null;
        Row[] aRows = null;
        Row aRow = null;
        String note = "";
        try 
        {
            iter = ADFUtils.findIterator("CustClearEntityAlertLov1Iterator");
            iter.executeQuery();
            aRows = iter.getAllRowsInRange();

            if (aRows != null) 
            {
                EntNotesAllValuesList = new ArrayList<SelectItem>();
                for (int sa = 0; sa < aRows.length; sa++) 
                {
                    aRow = aRows[sa];
                    note = utils.nullStrToSpc(aRow.getAttribute("Note"));

                    EntNotesAllValuesList.add(new SelectItem(note, note));
                }
            }
        } catch (NumberFormatException nfe) 
        {
            // TODO: Add catch code
            nfe.printStackTrace();
        }
        catch (Exception e) 
        {
            // TODO: Add catch code
            e.printStackTrace();
        }
        return EntNotesAllValuesList;
    }

    public void setEntNotesSelectedValues(List EntNotesSelectedValues) {
        this.EntNotesSelectedValues = EntNotesSelectedValues;
    }

    public List getEntNotesSelectedValues() {
        return EntNotesSelectedValues;
    }

    // T20200602.0032 - Adding new Popup on OWS TradeCompliance Statusboar... (IRI)
    public void updateMasterDialogListener(DialogEvent dialogEvent) {
        // Add event code here...
        
        if (dialogEvent.getOutcome().name().equals("ok")) {
            LOGGER.finest("DOB:"+dateOfBirth);
            
            //T20200625.0041 - OWS - Save not working on clear DOB field in Updat... (IRI)
            if(dateOfBirth == null || "".equals(dateOfBirth)){
                AttributeBinding dobBinding=ADFUtils.findControlBinding("DateOfBirth");
                dobBinding.setInputValue("");
            }else if(dateOfBirth != null && !"".equals(dateOfBirth)){
                SimpleDateFormat format=new SimpleDateFormat("yyyy-MM-dd");
                String dobStr=format.format(dateOfBirth);
                AttributeBinding dobBinding=ADFUtils.findControlBinding("DateOfBirth");
                dobBinding.setInputValue(dobStr+"T00:00:00Z");
            }
            
            //T20210127.0038 - Known Party
            UserRespAndSessionInfo userRespAndSessionInfo = (UserRespAndSessionInfo) JSFUtils.getManagedBeanValue("sessionScope.UserRespAndSessionInfo");
            SimpleDateFormat format=new SimpleDateFormat("dd-MMM-yyyy");
            BigDecimal masterId=null, aliasId=null, xrefId=null;
            if(userRespAndSessionInfo != null) {
                if(JSFUtils.resolveExpressionAsBigDecimal("#{bindings.MasterId.inputValue}") != null)
                    masterId = JSFUtils.resolveExpressionAsBigDecimal("#{bindings.MasterId.inputValue}");
                
                if(JSFUtils.resolveExpressionAsBigDecimal("#{bindings.AliasId.inputValue}") != null)
                    aliasId = JSFUtils.resolveExpressionAsBigDecimal("#{bindings.AliasId.inputValue}");
                
                if(JSFUtils.resolveExpressionAsBigDecimal("#{bindings.XrefId.inputValue}") != null)
                    xrefId = JSFUtils.resolveExpressionAsBigDecimal("#{bindings.XrefId.inputValue}");
                
                
                List kpParams = new ArrayList();
                List eaonParams = new ArrayList();
                List pAParams = new ArrayList();
                if(knownPartyStartDate != null)
                    kpParams.add(format.format(knownPartyStartDate));
                else
                    kpParams.add("");
                if(knownPartyEndDate != null)
                    kpParams.add(format.format(knownPartyEndDate));
                else
                    kpParams.add("");
                
                if(eastAsianOiginName != null)
                    eaonParams.add((eastAsianOiginName)?"Y":"N");
                else
                    eaonParams.add("");
                
                if(permanentAddress != null && !"".equals(permanentAddress))
                    pAParams.add(permanentAddress);
                else
                    pAParams.add("");
                
                if(masterId != null) {
                    kpParams.add(masterId.intValue());
                    eaonParams.add(masterId.intValue());
                    pAParams.add(masterId.intValue());
                }else { 
                    kpParams.add(null);
                    eaonParams.add(null);
                    pAParams.add(null);
                }
                
                if(aliasId != null) {
                    kpParams.add(aliasId.intValue());
                    eaonParams.add(aliasId.intValue());
                    pAParams.add(aliasId.intValue());
                }else {
                    kpParams.add(null);
                    eaonParams.add(null);
                    pAParams.add(null);
                }
                
                if(xrefId != null) {
                    kpParams.add(xrefId.intValue());
                    eaonParams.add(xrefId.intValue());
                    pAParams.add(xrefId.intValue());
                } else {
                    kpParams.add(null);
                    eaonParams.add(null);
                    pAParams.add(null);
                }
                if("Y".equals(userRespAndSessionInfo.getIsSuperUserOnly())){
                    LOGGER.finest("Dialog: knownPartyStartDate:"+knownPartyStartDate);
                    LOGGER.finest("Dialog: knownPartyEndDate:"+knownPartyEndDate);
                    
                    int ch= utils.updateData("update xwrl_party_master set KNOWN_PARTY_START_DATE = ? " +
                        ", KNOWN_PARTY_END_DATE = ? where id=rmi_ows_common_util.get_master_id(?,?,?)", kpParams);
                    LOGGER.finest("Known Party Result:"+ch);
                    
                    //T20220304.0005 - TC 2.0 enhancement - Address for corporate users
                    if(!utils.nullStrToSpc(permanentAddress).equals(JSFUtils.resolveExpressionAsString("#{bindings.PermanentAddress.inputValue}"))) {
                        LOGGER.finest("Dialog: permanent address:"+permanentAddress);
                        
                        ch= utils.updateData("update xwrl_party_master set permanent_address = ? " +
                            " where id=rmi_ows_common_util.get_master_id(?,?,?)", pAParams);
                        LOGGER.finest("permanentAddress Result:"+ch);
                    }
                    
                }
                int ch= utils.updateData("update xwrl_party_master set EAST_ASIAN_ORIGIN_NAME = ? " +
                    "where id=rmi_ows_common_util.get_master_id(?,?,?)", eaonParams);
                LOGGER.finest("eastAsianOiginName Result:"+ch);
            }
            //T20200715.0011 - OWS TC: Add Address Confirmation Date field in Request Page            
            List params = new ArrayList();
            if(addressConfirmationDate != null)
                params.add(format.format(addressConfirmationDate));
            else
                params.add("");
            
            if(masterId != null)
                params.add(masterId.intValue());
            else 
                params.add(null);
            
            if(aliasId != null)
                params.add(aliasId.intValue());
            else
                params.add(null);
            
            if(xrefId != null)
                params.add(xrefId.intValue());
            else
                params.add(null);
            
            int ch= utils.updateData("update xwrl_party_master set ADDRESS_CONFIRMATION_DATE = ? " +
                " where id=rmi_ows_common_util.get_master_id(?,?,?)", params);
            System.out.println("Result:"+ch);
            
            ADFUtils.findIterator("XwrlRequestsView1Iterator").getViewObject().getCurrentRow().setAttribute("AddressConfirmationDate", addressConfirmationDate);
            
            BindingContainer bc = ADFUtils.getBindingContainer();
            OperationBinding op = bc.getOperationBinding("Commit");
            op.execute();
            
            LOGGER.finest("Commit");
            
            CallableStatement st = null;
            String sq = null;
            AppModuleImpl am = null;
            try{
                sq = "begin RMI_OWS_COMMON_UTIL.sync_master_to_tc(p_request_id => :1  ); end;";
                  am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
                  st = am.getDBTransaction().createCallableStatement(sq, 0);
                    BigDecimal reqId = (BigDecimal) JSFUtils.resolveExpression("#{bindings.Id.inputValue}");
                    LOGGER.finest("RequestId:"+reqId.intValue());
                  st.setInt(1, reqId.intValue());
                  st.execute();
            }catch(Exception e){
                e.printStackTrace();
            }
            ADFUtils.findIterator("XwrlRequestsView1Iterator").executeQuery();
        } else if (dialogEvent.getOutcome().name().equals("cancel")) {
            DCIteratorBinding tabIter = ADFUtils.findIterator("XwrlRequestsView1Iterator");
            tabIter.getCurrentRow().refresh(Row.REFRESH_WITH_DB_FORGET_CHANGES);
            tabIter.executeQuery();
            LOGGER.finest("Rollback");
        }        
        getKnownPartyFlag();
        AdfFacesContext.getCurrentInstance().addPartialTarget(JSFUtils.findComponentInRoot("plam6"));
        AdfFacesContext.getCurrentInstance().addPartialTarget(JSFUtils.findComponentInRoot("it119"));
        
    }

    // T20200602.0032 - Adding new Popup on OWS TradeCompliance Statusboar... (IRI)
    public void updateMasterPopupFetchListener(PopupFetchEvent popupFetchEvent) {
        // Add event code here...
        try{
            String dob = JSFUtils.resolveExpressionAsString("#{bindings.DateOfBirth.inputValue}");
            if(dob != null && !"".equals(dob)){
                dob=dob.split("T")[0];
                SimpleDateFormat format=new SimpleDateFormat("yyyyMMdd");
                SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd");
                if(dob.contains("-"))
                    dateOfBirth = format1.parse(dob);
                else
                    dateOfBirth = format.parse(dob);
            }
            
            initializeKnownParty();
            
            //T20200715.0011 - OWS TC: Add Address Confirmation Date field in Request Page
            BigDecimal masterId=null, aliasId=null, xrefId=null;    
            if(JSFUtils.resolveExpressionAsBigDecimal("#{bindings.MasterId.inputValue}") != null)
                masterId = JSFUtils.resolveExpressionAsBigDecimal("#{bindings.MasterId.inputValue}");
            
            if(JSFUtils.resolveExpressionAsBigDecimal("#{bindings.AliasId.inputValue}") != null)
                aliasId = JSFUtils.resolveExpressionAsBigDecimal("#{bindings.AliasId.inputValue}");
            
            if(JSFUtils.resolveExpressionAsBigDecimal("#{bindings.XrefId.inputValue}") != null)
                xrefId = JSFUtils.resolveExpressionAsBigDecimal("#{bindings.XrefId.inputValue}");
            
            List params = new ArrayList();                
            if(masterId != null)
                params.add(masterId.intValue());
            else 
                params.add(null);
            
            if(aliasId != null)
                params.add(aliasId.intValue());
            else
                params.add(null);
            
            if(xrefId != null)
                params.add(xrefId.intValue());
            else
                params.add(null);
            
            ResultSet rs = utils.getPlSqlFunctionData("select ADDRESS_CONFIRMATION_DATE, NVL(EAST_ASIAN_ORIGIN_NAME,'N') as \"EAST_ASIAN_ORIGIN_NAME\" from xwrl_party_master " +
                " where id=rmi_ows_common_util.get_master_id(?,?,?)", params);
            System.out.println("east asian origin name:"+eastAsianOiginName);
            if(rs.next()) {
                addressConfirmationDate = rs.getDate("ADDRESS_CONFIRMATION_DATE");
                //T20220217.0020 - TC 2.0 - Enhancement - East Asian Origin Name
                if("Y".equals(rs.getString("EAST_ASIAN_ORIGIN_NAME")))
                    eastAsianOiginName = true;
                else
                    eastAsianOiginName = false;
                System.out.println("if east asian origin name:"+eastAsianOiginName);
                    
            }
            rs.close();
            
            //T20220304.0005 - TC 2.0 enhancement - Address for corporate users
            permanentAddress = JSFUtils.resolveExpressionAsString("#{bindings.PermanentAddress.inputValue}");
            
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    // T20200717.0032 - OWS TC - Access 'View History' Information from Re... (IRI)
    public void viewHistoryPopupFetchListener(PopupFetchEvent popupFetchEvent) {
        // Add event code here...
        ResetUtils.reset(popupFetchEvent.getComponent());
        //Full History
        fullHistoryLogic();
        LOGGER.finest("ViewHistory set");
    }
    
    private void fullHistoryLogic() {
        AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
        DCIteratorBinding binding = ADFUtils.findIterator("XwrlRequestApprovalHistView1Iterator");
        ViewObject vo = binding.getViewObject();
        //Full History
        Row row=am.getXwrlRequestsView1().getCurrentRow();
        vo.setWhereClause(null);
        vo.setWhereClause(" MASTER_ID = "+row.getAttribute("MasterId")
                                          + " and nvl(ALIAS_ID,-99) = nvl("+row.getAttribute("AliasId")+",-99)"
                                          + " and nvl(XREF_ID,-99) = nvl("+row.getAttribute("XrefId")+",-99)");
                
                
        vo.applyViewCriteria(null);
        vo.executeQuery();
    }
    
    public void iriEdocsLinkingDisclosureListener(DisclosureEvent disclosureEvent) {
        // Add event code here...
        try{
            LOGGER.finest("isExpanded::::::"+disclosureEvent.isExpanded());
            if(disclosureEvent.isExpanded()){
                AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
                Row r=am.getXwrlRequestsView1().getCurrentRow();
                
                //T20201012.0026 - Linking E-Docs to Case Documents in OWS Statusboar... (IRI)
                Object sourceId=new BigDecimal(-1);
                if(r.getAttribute("SourceId") != null && !"".equals(r.getAttribute("SourceId")))
                    sourceId=r.getAttribute("SourceId");
                LOGGER.finest("SourceId:"+sourceId);
                ViewObjectImpl iriEdocsVO = am.getIriEdocsForCaseDocumentsRVO1();
                ViewCriteria vc=iriEdocsVO.getViewCriteriaManager().getViewCriteria("FilterIdentifierIriEdocsForCaseDocumentsRVOCriteria");
                vc.ensureVariableManager().setVariableValue("p_identifier",((BigDecimal)sourceId).toPlainString());
                iriEdocsVO.applyViewCriteria(vc);
                iriEdocsVO.executeQuery();
                LOGGER.finest("IRIEdocs prepated");
            }
          }catch(Exception e){
            e.printStackTrace();
        }
    }

    public void viewHistoryTransactionOnlyValueChangeListener(ValueChangeEvent valueChangeEvent) {
        // Add event code here...
        AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
        DCIteratorBinding binding = ADFUtils.findIterator("XwrlRequestApprovalHistView1Iterator");
        ViewObject vo = binding.getViewObject();
        
        if(Boolean.parseBoolean(valueChangeEvent.getNewValue().toString()) && valueChangeEvent.getNewValue() != null) {
            //Transaction History
            ViewCriteria vc = vo.getViewCriteriaManager().getViewCriteria("XwrlRequestApprovalHistViewCriteriaById");
            Row row=am.getXwrlRequestsView1().getCurrentRow();
            vo.setWhereClause(null);
            vo.applyViewCriteria(null);
            vc.ensureVariableManager().setVariableValue("p_requestId", row.getAttribute("Id"));
            vo.applyViewCriteria(vc);
            vo.executeQuery();
        } else {
            //Full History
            fullHistoryLogic();
        }
    }




    class AlertRecord {
        BigDecimal requestId;
        String alertId;
    }

    public ArrayList<List> ALERT_LIST;

    public void setALERT_REC_LIST(ArrayList<List> ALERT_REC_LIST) {
        this.ALERT_REC_LIST = ALERT_REC_LIST;
    }

    public ArrayList<List> getALERT_REC_LIST() {
        return ALERT_REC_LIST;
    }
    public ArrayList<List> ALERT_REC_LIST;

    public void setALERT_LIST(ArrayList<List> ALERT_LIST) {
        this.ALERT_LIST = ALERT_LIST;
    }

    public ArrayList<List> getALERT_LIST() {
        return ALERT_LIST;
    }

    Random rand = new Random();
    private Integer randomVal = rand.nextInt(2000) + 1;

    public void setRandomVal(Integer randomVal) {
        this.randomVal = randomVal;
    }

    public Integer getRandomVal() {
        return randomVal;
    }


    public void refreshActionListener(ActionEvent actionEvent) {
        // Add event code here...
        LOGGER.finest("refreshActionListener");
        RichForm form = (RichForm) JSFUtils.findComponentInRoot("f1");
        AdfFacesContext.getCurrentInstance().addPartialTarget(form);
    }

    public void uploadActionListener(ActionEvent actionEvent) 
	{
		// Add event code here...
        LOGGER.finest("uploadActionListener");

    }

    public void submitIndividualRequest(ActionEvent actionEvent) {
        LOGGER.finest("submitIndividualRequest");
        // Add event code here...#{bindings.submit_ows_individual.execute}
        JSFUtils.invokeMethodExpression("#{bindings.submit_ows_individual.execute}", Object.class, ActionEvent.class,
                                        actionEvent);
    }

    public void submitEntityRequest(ActionEvent actionEvent) {
        LOGGER.finest("submitEntityRequest");
        // Add event code here...#{bindings.submit_ows_individual.execute}
        JSFUtils.invokeMethodExpression("#{bindings.submit_ows_entity.execute}", Object.class, ActionEvent.class,
                                        actionEvent);
    }

    public void loadIndividualRequest(ActionEvent actionEvent) {
        // Add event code here...
        LOGGER.finest("resetIndividualRequest");

        //Note: Values set through AM so need to use PageFlowScope
        ADFContext adfCtx = ADFContext.getCurrent();
        Map pageFlowScope = adfCtx.getPageFlowScope();

        // Note: Need to handle formatting for date of birth
        DateFormat formatter = null;
        java.util.Date date = null;
        oracle.jbo.domain.Date jboDate = null;
        String val = (String) pageFlowScope.get("varDateofbirth");
        LOGGER.finest("val: " + val);
        if (val != null) {
            try {
                formatter = new SimpleDateFormat("yyyyMMdd");
                date = formatter.parse(val);
                java.sql.Date sqlDate = new java.sql.Date(date.getTime());
                jboDate = new oracle.jbo.domain.Date(sqlDate);
            } catch (ParseException e) {
                LOGGER.finest("Error: " + e);
            }
        }

        // Get values set in AM
        ADFUtils.setBoundAttributeValue("varSourceTable1", pageFlowScope.get("varSourceTable"));
        ADFUtils.setBoundAttributeValue("varSourceId1", pageFlowScope.get("varSourceId"));
        ADFUtils.setBoundAttributeValue("varListsubkey", pageFlowScope.get("varListsubkey"));
        ADFUtils.setBoundAttributeValue("varListrecordtype", pageFlowScope.get("varListrecordtype"));
        ADFUtils.setBoundAttributeValue("varListrecordorigin", pageFlowScope.get("varListrecordorigin"));
        ADFUtils.setBoundAttributeValue("varCustid", pageFlowScope.get("varCustid"));
        ADFUtils.setBoundAttributeValue("varCustsubid", pageFlowScope.get("varCustsubid"));
        ADFUtils.setBoundAttributeValue("varPassportnumber", pageFlowScope.get("varPassportnumber"));
        ADFUtils.setBoundAttributeValue("varNationalid", pageFlowScope.get("varNationalid"));
        ADFUtils.setBoundAttributeValue("varTitle", pageFlowScope.get("varTitle"));
        ADFUtils.setBoundAttributeValue("varFullname", pageFlowScope.get("varFullname"));
        ADFUtils.setBoundAttributeValue("varGivennames", pageFlowScope.get("varGivennames"));
        ADFUtils.setBoundAttributeValue("varFamilyname", pageFlowScope.get("varFamilyname"));
        ADFUtils.setBoundAttributeValue("varNametype", pageFlowScope.get("varNametype"));
        ADFUtils.setBoundAttributeValue("varNamequality", pageFlowScope.get("varNamequality"));
        ADFUtils.setBoundAttributeValue("varPrimaryname", pageFlowScope.get("varPrimaryname"));
        ADFUtils.setBoundAttributeValue("varOriginalscriptname", pageFlowScope.get("varOriginalscriptname"));
        ADFUtils.setBoundAttributeValue("varGender", pageFlowScope.get("varGender"));
        ADFUtils.setBoundAttributeValue("varDateofbirth", jboDate);
        ADFUtils.setBoundAttributeValue("varYearofbirth", pageFlowScope.get("varYearofbirth"));
        ADFUtils.setBoundAttributeValue("varOccupation", pageFlowScope.get("varOccupation"));
        ADFUtils.setBoundAttributeValue("varAddress1", pageFlowScope.get("varAddress1"));
        ADFUtils.setBoundAttributeValue("varAddress2", pageFlowScope.get("varAddress2"));
        ADFUtils.setBoundAttributeValue("varAddress3", pageFlowScope.get("varAddress3"));
        ADFUtils.setBoundAttributeValue("varAddress4", pageFlowScope.get("varAddress4"));
        ADFUtils.setBoundAttributeValue("varCity", pageFlowScope.get("varCity"));
        ADFUtils.setBoundAttributeValue("varState", pageFlowScope.get("varState"));
        ADFUtils.setBoundAttributeValue("varPostalcode", pageFlowScope.get("varPostalcode"));
        ADFUtils.setBoundAttributeValue("varAddresscountrycode", pageFlowScope.get("varAddresscountrycode"));
        ADFUtils.setBoundAttributeValue("varResidencycountrycode", pageFlowScope.get("varResidencycountrycode"));
        ADFUtils.setBoundAttributeValue("varCountryofbirthcode", pageFlowScope.get("varCountryofbirthcode"));
        ADFUtils.setBoundAttributeValue("varNationalitycountrycodes", pageFlowScope.get("varNationalitycountrycodes"));
        ADFUtils.setBoundAttributeValue("varProfilehyperlink", pageFlowScope.get("varProfilehyperlink"));
        ADFUtils.setBoundAttributeValue("varRiskscore", pageFlowScope.get("varRiskscore"));
        ADFUtils.setBoundAttributeValue("varDataconfidencescore", pageFlowScope.get("varDataconfidencescore"));
        ADFUtils.setBoundAttributeValue("varDataconfidencecomment", pageFlowScope.get("varDataconfidencecomment"));
        ADFUtils.setBoundAttributeValue("varCustomstring1", pageFlowScope.get("varCustomstring1"));
        ADFUtils.setBoundAttributeValue("varCustomstring2", pageFlowScope.get("varCustomstring2"));
        ADFUtils.setBoundAttributeValue("varCustomstring3", pageFlowScope.get("varCustomstring3"));
        ADFUtils.setBoundAttributeValue("varCustomstring4", pageFlowScope.get("varCustomstring4"));
        ADFUtils.setBoundAttributeValue("varCustomstring5", pageFlowScope.get("varCustomstring5"));
        ADFUtils.setBoundAttributeValue("varCustomstring6", pageFlowScope.get("varCustomstring6"));
        ADFUtils.setBoundAttributeValue("varCustomstring7", pageFlowScope.get("varCustomstring7"));
        ADFUtils.setBoundAttributeValue("varCustomstring8", pageFlowScope.get("varCustomstring8"));
        ADFUtils.setBoundAttributeValue("varCustomstring9", pageFlowScope.get("varCustomstring9"));
        ADFUtils.setBoundAttributeValue("varCustomstring10", pageFlowScope.get("varCustomstring10"));
        ADFUtils.setBoundAttributeValue("varCustomstring11", pageFlowScope.get("varCustomstring11"));
        ADFUtils.setBoundAttributeValue("varCustomstring12", pageFlowScope.get("varCustomstring12"));
        ADFUtils.setBoundAttributeValue("varCustomstring13", pageFlowScope.get("varCustomstring13"));
        ADFUtils.setBoundAttributeValue("varCustomstring14", pageFlowScope.get("varCustomstring14"));
        ADFUtils.setBoundAttributeValue("varCustomstring15", pageFlowScope.get("varCustomstring15"));
        ADFUtils.setBoundAttributeValue("varCustomstring16", pageFlowScope.get("varCustomstring16"));
        ADFUtils.setBoundAttributeValue("varCustomstring17", pageFlowScope.get("varCustomstring17"));
        ADFUtils.setBoundAttributeValue("varCustomstring18", pageFlowScope.get("varCustomstring18"));
        ADFUtils.setBoundAttributeValue("varCustomstring19", pageFlowScope.get("varCustomstring19"));
        ADFUtils.setBoundAttributeValue("varCustomstring20", pageFlowScope.get("varCustomstring20"));
        ADFUtils.setBoundAttributeValue("varCustomstring21", pageFlowScope.get("varCustomstring21"));
        ADFUtils.setBoundAttributeValue("varCustomstring22", pageFlowScope.get("varCustomstring22"));
        ADFUtils.setBoundAttributeValue("varCustomstring23", pageFlowScope.get("varCustomstring23"));
        ADFUtils.setBoundAttributeValue("varCustomstring24", pageFlowScope.get("varCustomstring24"));
        ADFUtils.setBoundAttributeValue("varCustomstring25", pageFlowScope.get("varCustomstring25"));
        ADFUtils.setBoundAttributeValue("varCustomstring26", pageFlowScope.get("varCustomstring26"));
        ADFUtils.setBoundAttributeValue("varCustomstring27", pageFlowScope.get("varCustomstring27"));
        ADFUtils.setBoundAttributeValue("varCustomstring28", pageFlowScope.get("varCustomstring28"));
        ADFUtils.setBoundAttributeValue("varCustomstring29", pageFlowScope.get("varCustomstring29"));
        ADFUtils.setBoundAttributeValue("varCustomstring30", pageFlowScope.get("varCustomstring30"));
        ADFUtils.setBoundAttributeValue("varCustomstring31", pageFlowScope.get("varCustomstring31"));
        ADFUtils.setBoundAttributeValue("varCustomstring32", pageFlowScope.get("varCustomstring32"));
        ADFUtils.setBoundAttributeValue("varCustomstring33", pageFlowScope.get("varCustomstring33"));
        ADFUtils.setBoundAttributeValue("varCustomstring34", pageFlowScope.get("varCustomstring34"));
        ADFUtils.setBoundAttributeValue("varCustomstring35", pageFlowScope.get("varCustomstring35"));
        ADFUtils.setBoundAttributeValue("varCustomstring36", pageFlowScope.get("varCustomstring36"));
        ADFUtils.setBoundAttributeValue("varCustomstring37", pageFlowScope.get("varCustomstring37"));
        ADFUtils.setBoundAttributeValue("varCustomstring38", pageFlowScope.get("varCustomstring38"));
        ADFUtils.setBoundAttributeValue("varCustomstring39", pageFlowScope.get("varCustomstring39"));
        ADFUtils.setBoundAttributeValue("varCustomstring40", pageFlowScope.get("varCustomstring40"));
        ADFUtils.setBoundAttributeValue("varCustomdate1", pageFlowScope.get("varCustomdate1"));
        ADFUtils.setBoundAttributeValue("varCustomdate2", pageFlowScope.get("varCustomdate2"));
        ADFUtils.setBoundAttributeValue("varCustomdate3", pageFlowScope.get("varCustomdate3"));
        ADFUtils.setBoundAttributeValue("varCustomdate4", pageFlowScope.get("varCustomdate4"));
        ADFUtils.setBoundAttributeValue("varCustomdate5", pageFlowScope.get("varCustomdate5"));
        ADFUtils.setBoundAttributeValue("varCustomnumber1", pageFlowScope.get("varCustomnumber1"));
        ADFUtils.setBoundAttributeValue("varCustomnumber2", pageFlowScope.get("varCustomnumber2"));
        ADFUtils.setBoundAttributeValue("varCustomnumber3", pageFlowScope.get("varCustomnumber3"));
        ADFUtils.setBoundAttributeValue("varCustomnumber4", pageFlowScope.get("varCustomnumber4"));
        ADFUtils.setBoundAttributeValue("varCustomnumber5", pageFlowScope.get("varCustomnumber5"));

        // Clear PageScope variables
        pageFlowScope.put("varSourceTable", null);
        pageFlowScope.put("varSourceId", null);
        pageFlowScope.put("varListsubkey", null);
        pageFlowScope.put("varListrecordtype", null);
        pageFlowScope.put("varListrecordorigin", null);
        pageFlowScope.put("varCustid", null);
        pageFlowScope.put("varCustsubid", null);
        pageFlowScope.put("varPassportnumber", null);
        pageFlowScope.put("varNationalid", null);
        pageFlowScope.put("varTitle", null);
        pageFlowScope.put("varFullname", null);
        pageFlowScope.put("varGivennames", null);
        pageFlowScope.put("varFamilyname", null);
        pageFlowScope.put("varNametype", null);
        pageFlowScope.put("varNamequality", null);
        pageFlowScope.put("varPrimaryname", null);
        pageFlowScope.put("varOriginalscriptname", null);
        pageFlowScope.put("varGender", null);
        pageFlowScope.put("varDateofbirth", null);
        pageFlowScope.put("varYearofbirth", null);
        pageFlowScope.put("varOccupation", null);
        pageFlowScope.put("varAddress1", null);
        pageFlowScope.put("varAddress2", null);
        pageFlowScope.put("varAddress3", null);
        pageFlowScope.put("varAddress4", null);
        pageFlowScope.put("varCity", null);
        pageFlowScope.put("varState", null);
        pageFlowScope.put("varPostalcode", null);
        pageFlowScope.put("varAddresscountrycode", null);
        pageFlowScope.put("varResidencycountrycode", null);
        pageFlowScope.put("varCountryofbirthcode", null);
        pageFlowScope.put("varNationalitycountrycodes", null);
        pageFlowScope.put("varProfilehyperlink", null);
        pageFlowScope.put("varRiskscore", null);
        pageFlowScope.put("varDataconfidencescore", null);
        pageFlowScope.put("varDataconfidencecomment", null);
        pageFlowScope.put("varCustomstring1", null);
        pageFlowScope.put("varCustomstring2", null);
        pageFlowScope.put("varCustomstring3", null);
        pageFlowScope.put("varCustomstring4", null);
        pageFlowScope.put("varCustomstring5", null);
        pageFlowScope.put("varCustomstring6", null);
        pageFlowScope.put("varCustomstring7", null);
        pageFlowScope.put("varCustomstring8", null);
        pageFlowScope.put("varCustomstring9", null);
        pageFlowScope.put("varCustomstring10", null);
        pageFlowScope.put("varCustomstring11", null);
        pageFlowScope.put("varCustomstring12", null);
        pageFlowScope.put("varCustomstring13", null);
        pageFlowScope.put("varCustomstring14", null);
        pageFlowScope.put("varCustomstring15", null);
        pageFlowScope.put("varCustomstring16", null);
        pageFlowScope.put("varCustomstring17", null);
        pageFlowScope.put("varCustomstring18", null);
        pageFlowScope.put("varCustomstring19", null);
        pageFlowScope.put("varCustomstring20", null);
        pageFlowScope.put("varCustomstring21", null);
        pageFlowScope.put("varCustomstring22", null);
        pageFlowScope.put("varCustomstring23", null);
        pageFlowScope.put("varCustomstring24", null);
        pageFlowScope.put("varCustomstring25", null);
        pageFlowScope.put("varCustomstring26", null);
        pageFlowScope.put("varCustomstring27", null);
        pageFlowScope.put("varCustomstring28", null);
        pageFlowScope.put("varCustomstring29", null);
        pageFlowScope.put("varCustomstring30", null);
        pageFlowScope.put("varCustomstring31", null);
        pageFlowScope.put("varCustomstring32", null);
        pageFlowScope.put("varCustomstring33", null);
        pageFlowScope.put("varCustomstring34", null);
        pageFlowScope.put("varCustomstring35", null);
        pageFlowScope.put("varCustomstring36", null);
        pageFlowScope.put("varCustomstring37", null);
        pageFlowScope.put("varCustomstring38", null);
        pageFlowScope.put("varCustomstring39", null);
        pageFlowScope.put("varCustomstring40", null);
        pageFlowScope.put("varCustomdate1", null);
        pageFlowScope.put("varCustomdate2", null);
        pageFlowScope.put("varCustomdate3", null);
        pageFlowScope.put("varCustomdate4", null);
        pageFlowScope.put("varCustomdate5", null);
        pageFlowScope.put("varCustomnumber1", null);
        pageFlowScope.put("varCustomnumber2", null);
        pageFlowScope.put("varCustomnumber3", null);
        pageFlowScope.put("varCustomnumber4", null);
        pageFlowScope.put("varCustomnumber5", null);

    }

    public void loadEntityRequest(ActionEvent actionEvent) {
        // Add event code here...
        LOGGER.finest("loadEntityRequest");

        // Note: Need to handle formatting for date of birth
        ADFContext adfCtx = ADFContext.getCurrent();
        Map pageFlowScope = adfCtx.getPageFlowScope();


        // Get values set in AM
        ADFUtils.setBoundAttributeValue("varSourceTable1", pageFlowScope.get("varSourceTable"));
        ADFUtils.setBoundAttributeValue("varSourceId1", pageFlowScope.get("varSourceId"));
        ADFUtils.setBoundAttributeValue("varImoNumber1", pageFlowScope.get("varImoNumber"));
        ADFUtils.setBoundAttributeValue("varListsubkey", pageFlowScope.get("varListsubkey"));
        ADFUtils.setBoundAttributeValue("varListrecordtype", pageFlowScope.get("varListrecordtype"));
        ADFUtils.setBoundAttributeValue("varListrecordorigin", pageFlowScope.get("varListrecordorigin"));
        ADFUtils.setBoundAttributeValue("varCustid", pageFlowScope.get("varCustid"));
        ADFUtils.setBoundAttributeValue("varCustsubid", pageFlowScope.get("varCustsubid"));
        ADFUtils.setBoundAttributeValue("varRegistrationnumber", pageFlowScope.get("varRegistrationnumber"));
        ADFUtils.setBoundAttributeValue("varEntityname", pageFlowScope.get("varEntityname"));
        ADFUtils.setBoundAttributeValue("varNametype", pageFlowScope.get("varNametype"));
        ADFUtils.setBoundAttributeValue("varNamequality", pageFlowScope.get("varNamequality"));
        ADFUtils.setBoundAttributeValue("varPrimaryname", pageFlowScope.get("varPrimaryname"));
        ADFUtils.setBoundAttributeValue("varOriginalscriptname", pageFlowScope.get("varOriginalscriptname"));
        ADFUtils.setBoundAttributeValue("varAliasisacronym", pageFlowScope.get("varAliasisacronym"));
        ADFUtils.setBoundAttributeValue("varAddress1", pageFlowScope.get("varAddress1"));
        ADFUtils.setBoundAttributeValue("varAddress2", pageFlowScope.get("varAddress2"));
        ADFUtils.setBoundAttributeValue("varAddress3", pageFlowScope.get("varAddress3"));
        ADFUtils.setBoundAttributeValue("varAddress4", pageFlowScope.get("varAddress4"));
        ADFUtils.setBoundAttributeValue("varCity", pageFlowScope.get("varCity"));
        ADFUtils.setBoundAttributeValue("varState", pageFlowScope.get("varState"));
        ADFUtils.setBoundAttributeValue("varPostalcode", pageFlowScope.get("varPostalcode"));
        ADFUtils.setBoundAttributeValue("varAddresscountrycode", pageFlowScope.get("varAddresscountrycode"));
        ADFUtils.setBoundAttributeValue("varRegistrationcountrycode", pageFlowScope.get("varRegistrationcountrycode"));
        ADFUtils.setBoundAttributeValue("varOperatingcountrycodes", pageFlowScope.get("varOperatingcountrycodes"));
        ADFUtils.setBoundAttributeValue("varProfilehyperlink", pageFlowScope.get("varProfilehyperlink"));
        ADFUtils.setBoundAttributeValue("varRiskscore", pageFlowScope.get("varRiskscore"));
        ADFUtils.setBoundAttributeValue("varDataconfidencescore", pageFlowScope.get("varDataconfidencescore"));
        ADFUtils.setBoundAttributeValue("varDataconfidencecomment", pageFlowScope.get("varDataconfidencecomment"));
        ADFUtils.setBoundAttributeValue("varCustomstring1", pageFlowScope.get("varCustomstring1"));
        ADFUtils.setBoundAttributeValue("varCustomstring2", pageFlowScope.get("varCustomstring2"));
        ADFUtils.setBoundAttributeValue("varCustomstring3", pageFlowScope.get("varCustomstring3"));
        ADFUtils.setBoundAttributeValue("varCustomstring4", pageFlowScope.get("varCustomstring4"));
        ADFUtils.setBoundAttributeValue("varCustomstring5", pageFlowScope.get("varCustomstring5"));
        ADFUtils.setBoundAttributeValue("varCustomstring6", pageFlowScope.get("varCustomstring6"));
        ADFUtils.setBoundAttributeValue("varCustomstring7", pageFlowScope.get("varCustomstring7"));
        ADFUtils.setBoundAttributeValue("varCustomstring8", pageFlowScope.get("varCustomstring8"));
        ADFUtils.setBoundAttributeValue("varCustomstring9", pageFlowScope.get("varCustomstring9"));
        ADFUtils.setBoundAttributeValue("varCustomstring10", pageFlowScope.get("varCustomstring10"));
        ADFUtils.setBoundAttributeValue("varCustomstring11", pageFlowScope.get("varCustomstring11"));
        ADFUtils.setBoundAttributeValue("varCustomstring12", pageFlowScope.get("varCustomstring12"));
        ADFUtils.setBoundAttributeValue("varCustomstring13", pageFlowScope.get("varCustomstring13"));
        ADFUtils.setBoundAttributeValue("varCustomstring14", pageFlowScope.get("varCustomstring14"));
        ADFUtils.setBoundAttributeValue("varCustomstring15", pageFlowScope.get("varCustomstring15"));
        ADFUtils.setBoundAttributeValue("varCustomstring16", pageFlowScope.get("varCustomstring16"));
        ADFUtils.setBoundAttributeValue("varCustomstring17", pageFlowScope.get("varCustomstring17"));
        ADFUtils.setBoundAttributeValue("varCustomstring18", pageFlowScope.get("varCustomstring18"));
        ADFUtils.setBoundAttributeValue("varCustomstring19", pageFlowScope.get("varCustomstring19"));
        ADFUtils.setBoundAttributeValue("varCustomstring20", pageFlowScope.get("varCustomstring20"));
        ADFUtils.setBoundAttributeValue("varCustomstring21", pageFlowScope.get("varCustomstring21"));
        ADFUtils.setBoundAttributeValue("varCustomstring22", pageFlowScope.get("varCustomstring22"));
        ADFUtils.setBoundAttributeValue("varCustomstring23", pageFlowScope.get("varCustomstring23"));
        ADFUtils.setBoundAttributeValue("varCustomstring24", pageFlowScope.get("varCustomstring24"));
        ADFUtils.setBoundAttributeValue("varCustomstring25", pageFlowScope.get("varCustomstring25"));
        ADFUtils.setBoundAttributeValue("varCustomstring26", pageFlowScope.get("varCustomstring26"));
        ADFUtils.setBoundAttributeValue("varCustomstring27", pageFlowScope.get("varCustomstring27"));
        ADFUtils.setBoundAttributeValue("varCustomstring28", pageFlowScope.get("varCustomstring28"));
        ADFUtils.setBoundAttributeValue("varCustomstring29", pageFlowScope.get("varCustomstring29"));
        ADFUtils.setBoundAttributeValue("varCustomstring30", pageFlowScope.get("varCustomstring30"));
        ADFUtils.setBoundAttributeValue("varCustomstring31", pageFlowScope.get("varCustomstring31"));
        ADFUtils.setBoundAttributeValue("varCustomstring32", pageFlowScope.get("varCustomstring32"));
        ADFUtils.setBoundAttributeValue("varCustomstring33", pageFlowScope.get("varCustomstring33"));
        ADFUtils.setBoundAttributeValue("varCustomstring34", pageFlowScope.get("varCustomstring34"));
        ADFUtils.setBoundAttributeValue("varCustomstring35", pageFlowScope.get("varCustomstring35"));
        ADFUtils.setBoundAttributeValue("varCustomstring36", pageFlowScope.get("varCustomstring36"));
        ADFUtils.setBoundAttributeValue("varCustomstring37", pageFlowScope.get("varCustomstring37"));
        ADFUtils.setBoundAttributeValue("varCustomstring38", pageFlowScope.get("varCustomstring38"));
        ADFUtils.setBoundAttributeValue("varCustomstring39", pageFlowScope.get("varCustomstring39"));
        ADFUtils.setBoundAttributeValue("varCustomstring40", pageFlowScope.get("varCustomstring40"));
        ADFUtils.setBoundAttributeValue("varCustomdate1", pageFlowScope.get("varCustomdate1"));
        ADFUtils.setBoundAttributeValue("varCustomdate2", pageFlowScope.get("varCustomdate2"));
        ADFUtils.setBoundAttributeValue("varCustomdate3", pageFlowScope.get("varCustomdate3"));
        ADFUtils.setBoundAttributeValue("varCustomdate4", pageFlowScope.get("varCustomdate4"));
        ADFUtils.setBoundAttributeValue("varCustomdate5", pageFlowScope.get("varCustomdate5"));
        ADFUtils.setBoundAttributeValue("varCustomnumber1", pageFlowScope.get("varCustomnumber1"));
        ADFUtils.setBoundAttributeValue("varCustomnumber2", pageFlowScope.get("varCustomnumber2"));
        ADFUtils.setBoundAttributeValue("varCustomnumber3", pageFlowScope.get("varCustomnumber3"));
        ADFUtils.setBoundAttributeValue("varCustomnumber4", pageFlowScope.get("varCustomnumber4"));
        ADFUtils.setBoundAttributeValue("varCustomnumber5", pageFlowScope.get("varCustomnumber5"));

        // Clear PageScope variables
        pageFlowScope.put("varSourceTable", null);
        pageFlowScope.put("varSourceId", null);
        pageFlowScope.put("varImoNumber", null);
        pageFlowScope.put("varListsubkey", null);
        pageFlowScope.put("varListrecordtype", null);
        pageFlowScope.put("varListrecordorigin", null);
        pageFlowScope.put("varCustid", null);
        pageFlowScope.put("varCustsubid", null);
        pageFlowScope.put("varRegistrationnumber", null);
        pageFlowScope.put("varEntityname", null);
        pageFlowScope.put("varNametype", null);
        pageFlowScope.put("varNamequality", null);
        pageFlowScope.put("varPrimaryname", null);
        pageFlowScope.put("varOriginalscriptname", null);
        pageFlowScope.put("varAliasisacronym", null);
        pageFlowScope.put("varAddress1", null);
        pageFlowScope.put("varAddress2", null);
        pageFlowScope.put("varAddress3", null);
        pageFlowScope.put("varAddress4", null);
        pageFlowScope.put("varCity", null);
        pageFlowScope.put("varState", null);
        pageFlowScope.put("varPostalcode", null);
        pageFlowScope.put("varAddresscountrycode", null);
        pageFlowScope.put("varRegistrationcountrycode", null);
        pageFlowScope.put("varOperatingcountrycodes", null);
        pageFlowScope.put("varProfilehyperlink", null);
        pageFlowScope.put("varRiskscore", null);
        pageFlowScope.put("varDataconfidencescore", null);
        pageFlowScope.put("varDataconfidencecomment", null);
        pageFlowScope.put("varCustomstring1", null);
        pageFlowScope.put("varCustomstring2", null);
        pageFlowScope.put("varCustomstring3", null);
        pageFlowScope.put("varCustomstring4", null);
        pageFlowScope.put("varCustomstring5", null);
        pageFlowScope.put("varCustomstring6", null);
        pageFlowScope.put("varCustomstring7", null);
        pageFlowScope.put("varCustomstring8", null);
        pageFlowScope.put("varCustomstring9", null);
        pageFlowScope.put("varCustomstring10", null);
        pageFlowScope.put("varCustomstring11", null);
        pageFlowScope.put("varCustomstring12", null);
        pageFlowScope.put("varCustomstring13", null);
        pageFlowScope.put("varCustomstring14", null);
        pageFlowScope.put("varCustomstring15", null);
        pageFlowScope.put("varCustomstring16", null);
        pageFlowScope.put("varCustomstring17", null);
        pageFlowScope.put("varCustomstring18", null);
        pageFlowScope.put("varCustomstring19", null);
        pageFlowScope.put("varCustomstring20", null);
        pageFlowScope.put("varCustomstring21", null);
        pageFlowScope.put("varCustomstring22", null);
        pageFlowScope.put("varCustomstring23", null);
        pageFlowScope.put("varCustomstring24", null);
        pageFlowScope.put("varCustomstring25", null);
        pageFlowScope.put("varCustomstring26", null);
        pageFlowScope.put("varCustomstring27", null);
        pageFlowScope.put("varCustomstring28", null);
        pageFlowScope.put("varCustomstring29", null);
        pageFlowScope.put("varCustomstring30", null);
        pageFlowScope.put("varCustomstring31", null);
        pageFlowScope.put("varCustomstring32", null);
        pageFlowScope.put("varCustomstring33", null);
        pageFlowScope.put("varCustomstring34", null);
        pageFlowScope.put("varCustomstring35", null);
        pageFlowScope.put("varCustomstring36", null);
        pageFlowScope.put("varCustomstring37", null);
        pageFlowScope.put("varCustomstring38", null);
        pageFlowScope.put("varCustomstring39", null);
        pageFlowScope.put("varCustomstring40", null);
        pageFlowScope.put("varCustomdate1", null);
        pageFlowScope.put("varCustomdate2", null);
        pageFlowScope.put("varCustomdate3", null);
        pageFlowScope.put("varCustomdate4", null);
        pageFlowScope.put("varCustomdate5", null);
        pageFlowScope.put("varCustomnumber1", null);
        pageFlowScope.put("varCustomnumber2", null);
        pageFlowScope.put("varCustomnumber3", null);
        pageFlowScope.put("varCustomnumber4", null);
        pageFlowScope.put("varCustomnumber5", null);

    }

    public String nullStrToSpc(Object obj) {

        LOGGER.finest("nullStrToSpc");
        String spcStr = "";

        if (obj == null) {
            return spcStr;
        } else {
            return obj.toString();
        }
    }

    public void clearEntityRequestAlerts(ActionEvent actionEvent) {
        // Add event code here...
        LOGGER.finest("clearEntityRequestAlerts");

        //Note: For multiple se3ect on table
        //      The multiple selected records are highlighted after processing.  However, when the user clicks on
        //      a selected record other than the current record, the records are not synchronized until another record is clicked.
        //      This will set the current active record as the selected record.  Then, this issue is resolved.


        DCIteratorBinding tabIter = ADFUtils.findIterator("XwrlResponseEntityColumnsView1");
        RowSetIterator rsi = tabIter.getRowSetIterator();
        LOGGER.finest("Row Rec: " + rsi.getCurrentRow().getAttribute("Rec"));

        // Get selected rows from table
        RichTable tab = (RichTable) JSFUtils.findComponentInRoot("t1");
        RowKeySet currentRks = tab.getSelectedRowKeys();
        String alert = null;

        LOGGER.finest("Rec Count: " + currentRks.size());

        StringBuilder msg = new StringBuilder("<html><body>");

        if (currentRks.size() > 0) {
            // Get Alert ID from iterator lookup of selected row from table
            for (Object selectedRowKey : currentRks) {
                LOGGER.finest("selectedRowKey: " + selectedRowKey);
                Key key = (Key) ((List) selectedRowKey).get(0);
                Row currentRow = rsi.getRow(key);
                LOGGER.finest("AlertID: " + currentRow.getAttribute("Alertid"));
                alert = (String) currentRow.getAttribute("Alertid");
                msg.append("AlertID: " + alert + "<br>");
            }

            // Note: Add code here to pass the alert ids to OWS
        } else {
            msg.append("No rows were selected.");
        }

        // Display list of alerts
        msg.append("</body></html>");
        FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_INFO, msg.toString(), null);
        FacesContext.getCurrentInstance().addMessage(null, message);

    }

    public void clearIndividualRequestAlerts(ActionEvent actionEvent) {
        // Add event code here...
        LOGGER.finest("clearIndividualRequestAlerts");

    }
    
    private void filterAlertNotes(String id){
        try{
            String iterName="XwrlAlertNotesExView1Iterator";
            ADFContext adfCtx = ADFContext.getCurrent();

            DCIteratorBinding tabIter = ADFUtils.findIterator(iterName);
            ViewObject vo=tabIter.getViewObject();
            ViewCriteria vc=vo.getViewCriteriaManager().getViewCriteria("XwrlAlertNotesExViewCriteria");
            LOGGER.finest("VC:"+vc);
            String alertId=utils.nullStrToSpc(JSFUtils.resolveExpressionAsString("#{bindings.Alertid.inputValue}"));
            LOGGER.finest("filterAlertNotes:id::"+id);
            vc.ensureVariableManager().setVariableValue("p_id", id);
            vo.applyViewCriteria(vc);
            vo.executeQuery();
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public void caseNoteSelList(SelectionEvent selectionEvent) {
        // Add event code here...
        // #{bindings.XwrlResponseIndColumnsView1.collectionModel.makeCurrent}
        LOGGER.finest("indCaseNoteSelList");
        
        String loggedUser = "";
        
        UserRespAndSessionInfo userRespAndSessionInfo = (UserRespAndSessionInfo) JSFUtils.getManagedBeanValue("sessionScope.UserRespAndSessionInfo");
        
        if(userRespAndSessionInfo!=null)
        {
          loggedUser  = utils.nullStrToSpc(userRespAndSessionInfo.getUserId());
            LOGGER.finest("loggedUser::"+loggedUser);
        }
        
        
        // Note: Created for multiple selection on table to get last clicked record.
        JSFUtils.invokeMethodExpression("#{bindings.XwrlCaseNotesSumView1.collectionModel.makeCurrent}",
                                        Object.class, SelectionEvent.class, selectionEvent);

        DCIteratorBinding tabIter = ADFUtils.findIterator("XwrlCaseNotesSumView1Iterator");
        RowSetIterator rsi = tabIter.getRowSetIterator();
        RichTable table = (RichTable) selectionEvent.getSource();
        RowKeySet selection = table.getSelectedRowKeys();
        Object activeRowKey = table.getActiveRowKey();
        String id = null;

        LOGGER.finest("selection size: " + selection.getSize());
        // Note: After clearing alerts with multiple records, clicking on a single record was out of sync with master/detail.
        //       This will ensure that the master/detail is synchronized through the binding iterator.
        if (selection.getSize() == 1) 
        {
            for (Object selectedRowKey : selection) 
            {
                LOGGER.finest("selectedRowKey: " + selectedRowKey);
                activeRowKey = selectedRowKey;
                Key key = (Key) ((List) selectedRowKey).get(0);
                Row currentRow = rsi.getRow(key);
                id =  currentRow.getAttribute("Id").toString();
                LOGGER.finest("selection:id:"+id);
            }
            Key key = new Key(new Object[] { id });
            Row row = rsi.findByKey(key, 1)[0];
            rsi.setCurrentRow(row);
            
            String createdby= utils.nullStrToSpc(row.getAttribute("CreatedBy"));
            LOGGER.finest("createdby::"+createdby);
            
            RichButton tab = (RichButton) JSFUtils.findComponentInRoot("iabedt");
            
            if(createdby.equals(loggedUser))
            {
               tab.setDisabled(false);
               LOGGER.finest("same");
            }
            else 
            {
                tab.setDisabled(true);
                LOGGER.finest("diff");
            }
            
            AdfFacesContext.getCurrentInstance().addPartialTarget(tab);
        }
    }


    public void editPopFetchListener(PopupFetchEvent popupFetchEvent) {
        // Add event code here...
        LOGGER.finest("editPopFetchListener");
        ADFContext adfCtx = ADFContext.getCurrent();
        Map pageFlowScope = adfCtx.getPageFlowScope();
        if (popupFetchEvent.getLaunchSourceClientId().contains("iabadd")) {
            BindingContainer bc = ADFUtils.getBindingContainer();
            OperationBinding op = bc.getOperationBinding("CreateInsert");
            op.execute();
            
            ViewObject vo = ADFUtils.findIterator(utils.nullStrToSpc(pageFlowScope.get("alertNoteIterBinding"))).getViewObject();
            Row row=vo.getCurrentRow();
            LOGGER.finest("Row:"+row);
            if(row != null){
                LOGGER.finest("id:"+row.getAttribute("Id"));
                String alertId= utils.nullStrToSpc(JSFUtils.resolveExpressionAsString("#{bindings.Alertid.inputValue}"));
                row.setAttribute("AlertId", alertId);
            }
        }else{
            
            try{
                DCIteratorBinding binding = ADFUtils.findIterator(pageFlowScope.get("alertNoteDataIterBinding").toString());
                LOGGER.finest("iterBinding:"+pageFlowScope.get("alertNoteIterBinding").toString());
                LOGGER.finest("dataIterBinding:"+pageFlowScope.get("alertNoteDataIterBinding").toString());
                
                    if(binding.getViewObject().getCurrentRow() != null){
                    LOGGER.finest("Selected::Id:"+binding.getViewObject().getCurrentRow().getAttribute("Id"));
                            ViewObject vo = ADFUtils.findIterator(pageFlowScope.get("alertNoteIterBinding").toString()).getViewObject();
                            ViewCriteria vc=vo.getViewCriteriaManager().getViewCriteria("XwrlAlertNotesExViewCriteria");
                            LOGGER.finest("VC:"+vc);
                            vc.ensureVariableManager().setVariableValue("p_id", binding.getViewObject().getCurrentRow().getAttribute("Id"));
                            vo.applyViewCriteria(vc);
                            vo.executeQuery();
                        
                        if(vo.hasNext()){
                            Row row=vo.next();
                            vo.setCurrentRow(row);
                            LOGGER.finest("Current row set");
                    }
                    LOGGER.finest("No rows:"+vo.getRowCount());
                }
                
                }catch(Exception e){
                    e.printStackTrace();
                }
        }
    }

    public void editPopupCancelListener(PopupCanceledEvent popupCanceledEvent) {
        LOGGER.finest("editPopupCancelListener");
        BindingContainer bc = ADFUtils.getBindingContainer();
        OperationBinding op = bc.getOperationBinding("Rollback");
        op.execute();
        //Note: Added setSubmittedValue when button Immediate property set to True
        RichInputText it = (RichInputText) JSFUtils.findComponentInRoot("iait5");
        it.setSubmittedValue(null);
        AdfFacesContext.getCurrentInstance().addPartialTarget(it);
        RichTable tab = (RichTable) JSFUtils.findComponentInRoot("iaat");
        AdfFacesContext.getCurrentInstance().addPartialTarget(tab);
    }
    
    private void syncNotes() 
    {
        LOGGER.finest("syncNotes method started");
        CallableStatement st = null;
        String sq = null;
        AppModuleImpl am = null;
       
     try 
     { 
            am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
            ViewObject vo=am.getXwrlRequestsView1();
            Row row=vo.getCurrentRow();
            Integer batchId = Integer.parseInt(utils.nullStrToSpc(row.getAttribute("BatchId")));
            Integer requestId = Integer.parseInt(utils.nullStrToSpc(row.getAttribute("Id")));
            LOGGER.finest("batchId:"+batchId);
            LOGGER.finest("requestId:"+requestId);
            sq = "begin RMI_OWS_COMMON_UTIL.sync_alias_notes(p_request_id => :1, p_batch_id=> :2); end;";
             st = (java.sql.CallableStatement) am.getDBTransaction().createCallableStatement(sq, 0);
    
            st.setInt(1, requestId);
            st.setInt(2, batchId);

            st.execute();
        } catch (Exception sqle) {
            // TODO: Add catch code
            sqle.printStackTrace();
            LOGGER.finest("Error while calling sync alias notes "+ sqle);
            
        }
        LOGGER.finest("syncNotes method ended");
    }

    public void editDialogListener(DialogEvent dialogEvent) 
	{
        LOGGER.finest("editDialogListener");
		try {
            String noteType = "";
            String categoryType = "";
            DCIteratorBinding tabIter = null;


            ADFContext adfCtx = ADFContext.getCurrent();
            Map pageFlowScope = adfCtx.getPageFlowScope();
           

            noteType = utils.nullStrToSpc(pageFlowScope.get("varNoteType"));
            categoryType = utils.nullStrToSpc(pageFlowScope.get("varNoteCategory"));
			
			 LOGGER.finest("varNoteType: " + noteType);
            LOGGER.finest("varNoteCategory: " + categoryType);


            // Add event code here...
            LOGGER.finest("editDialogListener");
            LOGGER.finest("outcome: " + dialogEvent.getOutcome().name());
            LOGGER.finest("outcome:"+dialogEvent.getOutcome().name());
            if (dialogEvent.getOutcome().name().equals("ok")) {
                
                
                
                //T20200611.0029 - RE: OWS - Note Xref (IRI)
                AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");

                DCIteratorBinding alertIterBinding = ADFUtils.findIterator(utils.nullStrToSpc(pageFlowScope.get("alertNoteIterBinding")));

                

                Row alertRow=alertIterBinding.getCurrentRow();
                Row requestRow=am.getXwrlRequestsView1().getCurrentRow();

                LOGGER.finest("NoteId:"+alertRow.getAttribute("Id"));
                LOGGER.finest("LineNumber:"+alertRow.getAttribute("LineNumber"));
                LOGGER.finest("AlertId"+alertRow.getAttribute("AlertId"));

                ViewObject vo=am.getXwrlNoteXrefView1();
                
                ViewCriteria vc=vo.getViewCriteriaManager().getViewCriteria("XwrlNoteXrefViewCriteria");
                LOGGER.finest("VC:"+vc);
                vc.ensureVariableManager().setVariableValue("p_noteId", alertRow.getAttribute("Id"));
                vo.applyViewCriteria(vc);
                vo.executeQuery();
                Integer userId = (Integer) ADFContext.getCurrent().getSessionScope().get("UserId");
                Integer sessionId = (Integer) ADFContext.getCurrent().getSessionScope().get("SessionId");
                if(!vo.hasNext())
                {
                    Row createRow = vo.createRow();
                    
                    createRow.setAttribute("NoteId",alertRow.getAttribute("Id"));
                    createRow.setAttribute("LineNumber",alertRow.getAttribute("LineNumber"));
                    createRow.setAttribute("RequestId",requestRow.getAttribute("Id"));
                    createRow.setAttribute("AlertId",alertRow.getAttribute("AlertId"));
                    createRow.setAttribute("CaseKey",requestRow.getAttribute("CaseId"));
                    createRow.setAttribute("AliasId",requestRow.getAttribute("AliasId"));
                    createRow.setAttribute("MasterId",requestRow.getAttribute("MasterId"));
                    createRow.setAttribute("XrefId",requestRow.getAttribute("XrefId"));
                    createRow.setAttribute("SourceTable",requestRow.getAttribute("SourceTable"));
                    createRow.setAttribute("SourceId",requestRow.getAttribute("SourceId"));
                    createRow.setAttribute("EnabledFlag","Y");
                    createRow.setAttribute("Status","N");
                    createRow.setAttribute("RecordComment","From Alert Notes");
    
                    DCIteratorBinding binding = ADFUtils.findIterator(pageFlowScope.get("alertNoteMasterIterBinding").toString());
                    
                    createRow.setAttribute("ListId", binding.getViewObject().getCurrentRow().getAttribute("Listid"));
                    
                    
                    Timestamp time = new Timestamp(System.currentTimeMillis());
    
                    if (userId != null) {
                        createRow.setAttribute("CreatedBy",Long.valueOf(userId));
                        createRow.setAttribute("LastUpdatedBy",Long.valueOf(userId));
                    }
    
                    if (sessionId != null) {
                        createRow.setAttribute("LastUpdateLogin",Long.valueOf(sessionId));
                    }
    
                    createRow.setAttribute("CreationDate",time);
                    createRow.setAttribute("LastUpdateDate",time);
                    
                    vo.insertRow(createRow);
                }

                BindingContainer bc = ADFUtils.getBindingContainer();
                OperationBinding op = bc.getOperationBinding("Commit");
                op.execute();
                
                String sql = "begin xwrl_ows_utils.process_notes(p_user_id => :1, p_session_id => :2, p_request_id => :3, p_alert_id => :4, p_notes => :5); end;";

                LOGGER.finest("sql: " + sql);
                CallableStatement stmt =  am.getDBTransaction().createCallableStatement(sql, 0);
                String note = utils.nullStrToSpc(JSFUtils.resolveExpressionAsString("#{bindings.Note.inputValue}"));
                LOGGER.finest("Note:"+note);
                LOGGER.finest("Request Id:"+requestRow.getAttribute("Id"));
                LOGGER.finest("Alert Id:"+alertRow.getAttribute("AlertId"));
                    stmt.setInt(1, userId);
                    stmt.setInt(2, sessionId);
                    stmt.setObject(3, requestRow.getAttribute("Id"));
                    stmt.setObject(4, alertRow.getAttribute("AlertId"));
                    stmt.setString(5,note);
                    stmt.execute();
                
                LOGGER.finest("Commit");
                
                //T20200507.0012 - RE: OWS TC - duplicated case notes and case docs (IRI)
                //syncNotes();

            } else if (dialogEvent.getOutcome().name().equals("cancel")) {
                BindingContainer bc = ADFUtils.getBindingContainer();
                OperationBinding op = bc.getOperationBinding("Rollback");
                op.execute();
                LOGGER.finest("Rollback");
            }
                    
            try {
            DCIteratorBinding atabIter = ADFUtils.findIterator("XwrlAlertNotesXrefView1Iterator");
            if(atabIter!=null)
            {
            atabIter.executeQuery();
                RichTable ac = (RichTable) JSFUtils.findComponentInRoot("iaat");
                AdfFacesContext.getCurrentInstance().addPartialTarget(ac);
            }
            } catch (Exception e) {
            // TODO: Add catch code
            e.printStackTrace();
            }
                    
            try {
            DCIteratorBinding a2tabIter = ADFUtils.findIterator("XwrlAlertNotesXrefView2Iterator");
            if(a2tabIter!=null)
            {
            a2tabIter.executeQuery();
                RichTable ac = (RichTable) JSFUtils.findComponentInRoot("iaat");
                AdfFacesContext.getCurrentInstance().addPartialTarget(ac);
            }
            } catch (Exception e) {
            // TODO: Add catch code
            e.printStackTrace();
            }

             try {
             tabIter = ADFUtils.findIterator("XwrlAlertNotesView1Iterator");
            if(tabIter!=null)
            {
            tabIter.executeQuery();
            }
        } catch (Exception e) {
            // TODO: Add catch code
            e.printStackTrace();
        }

        try {
            DCIteratorBinding tabIter2 = ADFUtils.findIterator("XwrlAlertNotesView2Iterator");
            if(tabIter2!=null)
            {
            tabIter2.executeQuery();
            }
        } catch (Exception e) {
            // TODO: Add catch code
            e.printStackTrace();
        }
		
		try {
            DCIteratorBinding tabIter3 = ADFUtils.findIterator("XwrlCaseNotesView1Iterator");
            if(tabIter3!=null)
            {
            tabIter3.executeQuery();
            }
        } catch (Exception e) {
            // TODO: Add catch code
            e.printStackTrace();
        }

        try {
            DCIteratorBinding tabIter4 = ADFUtils.findIterator("XwrlCaseNotesView2Iterator");
            if(tabIter4!=null)
            {
            tabIter4.executeQuery();
            }
            
        } catch (Exception e) {
            // TODO: Add catch code
            e.printStackTrace();
        }

            RichTable tab = (RichTable) JSFUtils.findComponentInRoot("t2");
            AdfFacesContext.getCurrentInstance().addPartialTarget(tab);
        } catch (Exception e) {
            // TODO: Add catch code
            e.printStackTrace();
        }
        
    }
    

    public void editShowPopup(ActionEvent event) 
	{
        ADFContext adfCtx = ADFContext.getCurrent();
        Map pageFlowScope = adfCtx.getPageFlowScope();
        
        pageFlowScope.put("alertNoteIterBinding",utils.nullStrToSpc(event.getComponent().getAttributes().get("iterBinding")));
        pageFlowScope.put("alertNoteMasterIterBinding", utils.nullStrToSpc(event.getComponent().getAttributes().get("masterIterBinding")));
        
        if(event.getComponent().getAttributes().get("dataIterBinding") != null)
            pageFlowScope.put("alertNoteDataIterBinding", utils.nullStrToSpc(event.getComponent().getAttributes().get("dataIterBinding")));        
       
       DCIteratorBinding tabIter = null;
		DCIteratorBinding tabIter2 = null;
		DCIteratorBinding tabIter3 = null;
		DCIteratorBinding tabIter4 = null;
		
        String noteType = utils.nullStrToSpc( pageFlowScope.get("varNoteType"));
		
		try{
            
            tabIter = ADFUtils.findIterator("XwrlAlertNotesView1Iterator");
		}catch(Exception e)
		{
			 LOGGER.finest("tabIter is null:"+ e);
		}
		
		try{
		tabIter2 = ADFUtils.findIterator("XwrlAlertNotesView2Iterator");
		}catch(Exception e)
		{
			 LOGGER.finest("tabIter2 is null:"+ e);
		}
		
		try{
		tabIter3 = ADFUtils.findIterator("XwrlCaseNotesView1Iterator");
		}catch(Exception e)
		{
			 LOGGER.finest("tabIter3 is null:"+ e);
		}
		
		try{
		tabIter4 = ADFUtils.findIterator("XwrlCaseNotesView2Iterator");
		}catch(Exception e)
		{
			 LOGGER.finest("tabIter is null:"+ e);
		}
		
		if (tabIter3!=null || tabIter4!=null) 
		{
			DCIteratorBinding tabIter1 = ADFUtils.findIterator("XwrlRequestsView1Iterator");
			String id = utils.nullStrToSpc(tabIter1.getCurrentRow().getAttribute("Id"));
			
			if("ERROR".equals(execRequestLock()))
			{
				return;
			}
        } 
		if (tabIter2!=null || tabIter!=null) 
		{
			 String id = utils.nullStrToSpc(JSFUtils.resolveExpressionAsBigDecimal("#{bindings.Id.inputValue}"));
			if("ERROR".equals(execRequestLock()))
			{
				return;
			}
        } 

		LOGGER.finest("editShowPopup");
        FacesContext context = FacesContext.getCurrentInstance();
        UIComponent source = (UIComponent) event.getSource();
        RichPopup comp = (RichPopup) JSFUtils.findComponentInRoot("iap1");
        LOGGER.finest("comp: " + comp);
        String alignId = source.getClientId(context);
        LOGGER.finest("alignId: " + alignId);
        RichPopup.PopupHints hints = new RichPopup.PopupHints();
        hints.add(RichPopup.PopupHints.HintTypes.HINT_LAUNCH_ID, source);
        hints.add(RichPopup.PopupHints.HintTypes.HINT_ALIGN, RichPopup.PopupHints.AlignTypes.ALIGN_OVERLAP);
        comp.show(hints);
    }

  public void getOldStatus()
     {
            Row rr = null;
            String oldStatus = "";
            String requestId = "";
            DCIteratorBinding tabIter = null;
            Row row = null;
            AppModuleImpl am = null;
            XwrlRequestsViewImpl rvo = null;
            RowFinder rfinder = null;
            NameValuePairs rnvp = null;
            RowIterator rri = null;
            String caseId = "";
            String lastupdtBy = "";
            
            tabIter = ADFUtils.findIterator("XwrlRequestsView1Iterator");
            row = tabIter.getCurrentRow();
            requestId = utils.nullStrToSpc(row.getAttribute("Id"));
            caseId = utils.nullStrToSpc(row.getAttribute("CaseId"));
            
            LOGGER.finest("requestId in oldStatus method:"+ requestId);
            LOGGER.finest("caseId in oldStatus method:"+ caseId);
			
            am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
            
            rvo = am.getXwrlRequestsView1();
            rfinder = rvo.lookupRowFinder("RequestIdFinder");
            rnvp = new NameValuePairs();
            rnvp.setAttribute("Id",requestId);
            rri = rfinder.execute(rnvp,rvo);
            
            while (rri.hasNext())
            {
            rr = rri.next();
            oldStatus = utils.nullStrToSpc(rr.getAttribute("CaseWorkflow"));
            lastupdtBy = utils.nullStrToSpc(rr.getAttribute("LastUpdatedBy"));    
            
            if (oldStatus != null && !"".equals(oldStatus)) 
            {
                ADFContext.getCurrent().getPageFlowScope().put("oldStatus",oldStatus);    
				LOGGER.finest("oldStatus in oldStatus method:"+ oldStatus);
            }
                
              if (lastupdtBy != null && !"".equals(lastupdtBy)) 
              {
                  ADFContext.getCurrent().getPageFlowScope().put("lastupdtBy",lastupdtBy);    
                                  LOGGER.finest("lastupdtBy in oldStatus method:"+ lastupdtBy);
              }    
              
          }
      }
  

    public void editShowCasePopup(ActionEvent event) {
        LOGGER.finest("editShowCasePopup start");
        System.out.println("editShowCasePopup start");
        try {
            String itrName = event.getComponent().getAttributes().get("itrName").toString();
            LOGGER.finest("itrName = " + itrName);
            
            /*T20221108.0024 - TC Role Based Access Control            
            if (itrName != null || itrName != "") {
                approved(itrName);
            }
            */
            
        } catch (Exception e) {
            LOGGER.finest("Exception = " + e.getMessage());
        }
        if ("ERROR".equals(execRequestLock())) {
            return;
        }
        
        FacesContext context = FacesContext.getCurrentInstance();
        UIComponent source = (UIComponent) event.getSource();
        RichPopup comp = (RichPopup) JSFUtils.findComponentInRoot("p2");
        LOGGER.finest("comp: " + comp);
        String alignId = source.getClientId(context);
        LOGGER.finest("alignId: " + alignId);
		
	String	id = utils.nullStrToSpc(JSFUtils.resolveExpressionAsBigDecimal("#{bindings.Id.inputValue}"));
        execRequestLock();    
        
        getOldStatus();
        executeDocType();
        executerestrictcity();
        
        RichPopup.PopupHints hints = new RichPopup.PopupHints();
        hints.add(RichPopup.PopupHints.HintTypes.HINT_LAUNCH_ID, source);
        hints.add(RichPopup.PopupHints.HintTypes.HINT_ALIGN, RichPopup.PopupHints.AlignTypes.ALIGN_OVERLAP);
        comp.show(hints);
        
        //T20200903.0030 - OWS - Change Priority LOV (IRI)
        ADFContext.getCurrent().getViewScope().put("isTempFin",true);
        try{
            AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
            am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
            String sq = "SELECT RMI_OWS_COMMON_UTIL.IS_ACK_PENDING(?) FROM DUAL";
            PreparedStatement st =  am.getDBTransaction().createPreparedStatement(sq, 0);
            
            
            st.setBigDecimal(1, JSFUtils.resolveExpressionAsBigDecimal("#{bindings.SourceId.inputValue}"));
    
            ResultSet rs=st.executeQuery();
            if(rs.next()){
                String str=rs.getString(1);
                LOGGER.finest("Str:"+str);
                if(str != null && !"".equals(str) && "N".equals(str))
                    ADFContext.getCurrent().getViewScope().put("isTempFin",false);
                else
                    ADFContext.getCurrent().getViewScope().put("isTempFin",true);
                
            }else
                ADFContext.getCurrent().getViewScope().put("isTempFin",true);
            LOGGER.finest("isTempFin:"+ADFContext.getCurrent().getViewScope().get("isTempFin"));
        }catch(Exception e){
            e.printStackTrace();
        }
        LOGGER.finest("editShowCasePopup end");
    }
    
    public void executeDocType() {
        try 
        {
            String priority = JSFUtils.resolveExpressionAsString("#{bindings.Priority.inputValue}");
            
            if(priority.equals("1")) 
            {
                priority = "High";
            }
            if(priority.equals("2")) 
            {
                priority = "Medium";
            }
            if(priority.equals("3")) 
            {
                priority = "Low";
            }
            
            
            BindingContainer bc2 = ADFUtils.getBindingContainer();
            OperationBinding coop2 = bc2.getOperationBinding("executeDocType");
            coop2.getParamsMap().put("dept", JSFUtils.resolveExpression("#{bindings.Department.inputValue}"));
            coop2.getParamsMap().put("priority", priority);
            coop2.execute();
        } catch (Exception e) {
            // TODO: Add catch code
            e.printStackTrace();
        } 
    }
    
    public String gotoEntity() 
    {
        String gotoact = "goEntityRequest";
        AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
        
        am.executeRequestView("");
        return gotoact;
    }
    
    public String goIndividualRequest() 
    {
        String gotoact = "goIndividualRequest";
        AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
        
        am.executeRequestView("");
        return gotoact;
    }
    
    public void executerestrictcity() 
    {
        try
        {
          AppModuleImpl am = null;
          
          BindingContainer bc = ADFUtils.getBindingContainer();
          OperationBinding coop = bc.getOperationBinding("restrictCity");
          coop.execute();
          
          
          am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
          am.getCaseRestrictedCityLOV1().ensureVariableManager().setVariableValue("varCountryCode", "tst");
          am.getCaseRestrictedCityLOV1().executeQuery();
        }
        catch (Exception e)
        {
          // TODO: Add catch code
          e.printStackTrace();
        }
    }
    
    public void countryValChgListnr(ValueChangeEvent evt) 
    {
        String country = utils.nullStrToSpc(evt.getNewValue());
        LOGGER.finest("country::"+country);
        DCIteratorBinding tabIter = null;
        
        AppModuleImpl am = null;  
        am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
        am.getCaseRestrictedCityLOV1().ensureVariableManager().setVariableValue("varCountryCode",evt.getNewValue());
        am.getCaseRestrictedCityLOV1().executeQuery();
        
        LOGGER.finest("count::"+ am.getCaseRestrictedCityLOV1().getEstimatedRowCount());
      
       if(!"RU".equals(country) && !"UA".equals(country))
       {
           JSFUtils.setExpressionValue("#{bindings.CityOfResidenceId1.inputValue}", null);
         JSFUtils.setExpressionValue("#{bindings.SubdivisionCityOfResidence.inputValue}", null);
         
           tabIter = ADFUtils.findIterator("XwrlRequestsView1Iterator");
           tabIter.getCurrentRow().setAttribute("CityOfResidenceId", null);
           tabIter.getCurrentRow().setAttribute("SubdivisionCityOfResidence", null);
           
         LOGGER.finest("setting null");
       }
    }

    public void editCaseDialogListener(DialogEvent dialogEvent) 
    {
        try{
        // Add event code here...
        LOGGER.finest("editCaseDialogListener");
        LOGGER.finest("outcome: " + dialogEvent.getOutcome().name());
        Object openCount = dialogEvent.getComponent().getAttributes().get("openCount");
        System.out.println("openCount:"+openCount);
        String caseWorkStatus= utils.nullStrToSpc(JSFUtils.resolveExpressionAsString("#{bindings.CaseWorkflow.inputValue}"));
	String oldStatus = utils.nullStrToSpc(ADFContext.getCurrent().getPageFlowScope().get("oldStatus"));
        String caseStatus= utils.nullStrToSpc(JSFUtils.resolveExpressionAsString("#{bindings.CaseStatus.inputValue}"));
        
	  
	  LOGGER.finest("caseWorkStatus::"+caseWorkStatus);
      LOGGER.finest("oldStatus::"+oldStatus);
	  
	  String readMode = "";
	  String superUsr = "";
        AppModuleImpl am = null;
	  
	 UserRespAndSessionInfo userRespAndSessionInfo = (UserRespAndSessionInfo) JSFUtils.getManagedBeanValue("sessionScope.UserRespAndSessionInfo");
	  
	  if(userRespAndSessionInfo!=null)
	  {
	    superUsr  = userRespAndSessionInfo.getIsSuperUserOnly();
		readMode  = userRespAndSessionInfo.getIsReadOnly();
	  }
          
      LOGGER.finest("superUsr::"+superUsr);
      LOGGER.finest("readMode::"+readMode);
        
        if (dialogEvent.getOutcome().name().equals("ok")) {
            //T20210803.0004 - OWS - Don't close request if any open alert existed
            if (Integer.parseInt(openCount.toString()) > 0 && "C".equals(caseStatus) &&
                ("A".equals(caseWorkStatus) || "PR".equals(caseWorkStatus))) {
                utils.displayErrorMessage(openCount + " alert(s) are in Open status so, not allowed to close request.");
            } else {
                BindingContainer bc = ADFUtils.getBindingContainer();
                OperationBinding coop = bc.getOperationBinding("Commit");
                
                if ((("Y".equals(readMode) && "N".equals(superUsr)) || userRespAndSessionInfo == null) &&
                    (oldStatus.equals("L") || (oldStatus.equals("SL"))) && caseWorkStatus.equals("A")) {
                    utils.displayErrorMessage("RMI OWS Trade Compliance User cannot change the Case Workflow state from Legal/Sr Legal to Approved");
                    return;
                } else {
                    if ("E".equals(checkRejection())) {
                        return;

                    } else {
                        try {
                            coop.execute();
                            //T20210817.0039 - OWS - TC Redesign - Remove obsolete code
                            //setExpirationDate();
                            LOGGER.finest("Commit");
                            
                        } catch (Exception e) {
                            // TODO: Add catch code
                            e.printStackTrace();
                        }
                    }
                }

                if ("Y".equals(superUsr)) {
                    if ("E".equals(checkRejection())) {
                        return;
                    } else {
                        try {
                            coop.execute();
                            //T20210817.0039 - OWS - TC Redesign - Remove obsolete code
                            //setExpirationDate();
                            LOGGER.finest("Commit");
                            

                        } catch (Exception e) {
                            // TODO: Add catch code
                            e.printStackTrace();
                        }
                    }
                }

                DCIteratorBinding tabIter = ADFUtils.findIterator("XwrlRequestsView1Iterator");
                tabIter.getCurrentRow().refresh(Row.REFRESH_WITH_DB_FORGET_CHANGES);
                tabIter.executeQuery();

                RichPanelFormLayout pfl = (RichPanelFormLayout) JSFUtils.findComponentInRoot("pfl4");
                AdfFacesContext.getCurrentInstance().addPartialTarget(pfl);
            }
        } else if (dialogEvent.getOutcome().name().equals("cancel")) 
                {
            BindingContainer bc = ADFUtils.getBindingContainer();
            OperationBinding op = bc.getOperationBinding("Rollback");
            op.execute();
            
            am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
            am.executeRequestView(utils.nullStrToSpc(JSFUtils.resolveExpressionAsBigDecimal("#{bindings.Id.inputValue}")));
        }
        
        RichPopup comp = (RichPopup) JSFUtils.findComponentInRoot("p2");
        comp.hide();
        }catch(Exception e) {
            e.printStackTrace();
            System.out.println("Errored4");
        }
    }
    
    public void notifyUsersAndTrade()
    {
        CallableStatement st = null;
        String sq = null;
        AppModuleImpl am = null;
        
        try 
        {
            am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
            
            DCIteratorBinding tabIter = ADFUtils.findIterator("XwrlRequestsView1Iterator");
            Row row = tabIter.getCurrentRow();
            
            String sourceTable = utils.nullStrToSpc(row.getAttribute("SourceTable"));
            Integer sourceId = Integer.parseInt(utils.nullStrToSpc(row.getAttribute("SourceId")));
            String nameScrnd = utils.nullStrToSpc(row.getAttribute("NameScreened"));
            
            String caseWorkStatus= utils.nullStrToSpc(JSFUtils.resolveExpressionAsString("#{bindings.CaseWorkflow.inputValue}"));
            BigDecimal requestId= JSFUtils.resolveExpressionAsBigDecimal("#{bindings.Id.inputValue}");
            String caseId = utils.nullStrToSpc(JSFUtils.resolveExpressionAsString("#{bindings.CaseId.inputValue}"));
            String lastupBy = utils.nullStrToSpc(ADFContext.getCurrent().getPageFlowScope().get("lastupdtBy"));
            
          sq = "begin notify_user_trade_wrflow_chg(?,?,?,?,?,?,?,?,?); end;";
            
            st = (java.sql.CallableStatement) am.getDBTransaction().createCallableStatement(sq, 0);

            st.setBigDecimal(1, requestId);
            st.setInt(2, Integer.parseInt(lastupBy));
            st.setString(3, nameScrnd);
            st.setString(4, caseId);
            st.setString(5, caseWorkStatus);
            st.setString(6, sourceTable);
            st.setInt(7, sourceId);
            st.registerOutParameter(8, Types.INTEGER);
            st.registerOutParameter(9, Types.VARCHAR);
            st.execute();
            
            Integer retCode = (Integer) st.getObject(8);
            String retMsg = (String) st.getObject(9);
            
            LOGGER.finest("retCode::"+retCode);
            LOGGER.finest("retMsg::"+retMsg);
            
        } catch (Exception e) 
        {
            // TODO: Add catch code
            e.printStackTrace();
              LOGGER.finest("Error invoking notify_user_trade_wrflow_chg ::"+e);
        }
        finally {
            try {
                if(st!=null) {
                    st.close();
                }
                
               
           } catch (Exception e) {
                // TODO: Add catch code
                e.printStackTrace();
            }
        }
    }
    
    
    public void setExpirationDate()
    {
        CallableStatement st = null;
        String sq = null;
        AppModuleImpl am = null;
        
        try 
        {
            am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
            
            String caseWorkStatus= utils.nullStrToSpc(JSFUtils.resolveExpressionAsString("#{bindings.CaseWorkflow.inputValue}"));
            String caseState= utils.nullStrToSpc(JSFUtils.resolveExpressionAsString("#{bindings.CaseState.inputValue}"));
            BigDecimal requestId= JSFUtils.resolveExpressionAsBigDecimal("#{bindings.Id.inputValue}");
            
           sq = "begin rmi_ows_common_util.set_expiration_date(p_request_id => :1, p_case_state=> :2, p_workflow_status => :3); end;";
            st = (java.sql.CallableStatement) am.getDBTransaction().createCallableStatement(sq, 0);

            st.setBigDecimal(1, requestId);
            st.setString(2, caseState);
            st.setString(3, caseWorkStatus);
            st.execute();
        } catch (Exception e) 
        {
            // TODO: Add catch code
            e.printStackTrace();
              LOGGER.finest("Error invoking rmi_ows_common_util.set_expiration_date ::"+e);
        }
        finally {
            try {
                if(st!=null) {
                    st.close();
                }
                
               
           } catch (Exception e) {
                // TODO: Add catch code
                e.printStackTrace();
            }
        }
    }
    
    
    public void popupcancldListnr(PopupCanceledEvent evt)
    {
        
        LOGGER.finest("popupcancldListnr");
        
        AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");                
        XwrlRequestsViewImpl vo = am.getXwrlRequestsView1();
        XwrlRequestsViewRowImpl row = (XwrlRequestsViewRowImpl) vo.getCurrentRow();
        
        row.getCaseStateLOV1().getViewObject().setWhereClause(null);
        row.getCaseStateLOV1().executeQuery();
        
        row.getCaseWorkflowLOV1().getViewObject().setWhereClause(null);
        row.getCaseWorkflowLOV1().executeQuery(); 
        
        DCIteratorBinding tabIter = ADFUtils.findIterator("XwrlRequestsView1Iterator");
        tabIter.getCurrentRow().refresh(Row.REFRESH_WITH_DB_FORGET_CHANGES);
        tabIter.executeQuery();
        
        RichPanelFormLayout pfl = (RichPanelFormLayout) JSFUtils.findComponentInRoot("pfl4");
        AdfFacesContext.getCurrentInstance().addPartialTarget(pfl);

        LOGGER.finest("Actions return listener");
    }
    
    public void execRollback() 
    {
        BindingContainer bc = ADFUtils.getBindingContainer();
        OperationBinding op = bc.getOperationBinding("Rollback");
        op.execute();
    }
    
    public String  checkRejection() 
    {
        String caseStatus= "";
        String rejctReason = "";
        String rejectreasonOther = "";
        String status = "S";
        String caseWorkflow = "";
        
        try {
            caseStatus= utils.nullStrToSpc(JSFUtils.resolveExpressionAsString("#{bindings.CaseState.inputValue}"));
           caseWorkflow= utils.nullStrToSpc(JSFUtils.resolveExpressionAsString("#{bindings.CaseWorkflow.inputValue}"));
           rejctReason= utils.nullStrToSpc(JSFUtils.resolveExpressionAsString("#{bindings.RejectionReason.inputValue}"));
           rejectreasonOther= utils.nullStrToSpc(JSFUtils.resolveExpressionAsString("#{bindings.RejectionReasonOthr.inputValue}"));
       
       if(caseStatus.equals("R") || caseWorkflow.equals("R")) 
       {
           if("".equals(rejctReason)) 
           {
               utils.displayErrorMessage("Select Rejection Reason");
               status = "E";
           }
           else 
           {
               if(rejctReason.equals("OTHR") && "".equals(rejectreasonOther)) 
               {
                   status = "E";
                   utils.displayErrorMessage("Enter value for Rejection Reason Other");
               }
           }
       }
            
        if(!"".equals(rejctReason)  && ! (caseStatus.equals("R") || caseWorkflow.equals("R"))) {
            status = "E";
            utils.displayErrorMessage("Case State and Case Workflow should be Rejected");
            
        }
       
       } catch (Exception e) {
            // TODO: Add catch code
            e.printStackTrace();
            status = "E";
        }
        return status;
    }

    public void templateDialogListener(DialogEvent dialogEvent) {
        // Add event code here...
        LOGGER.finest("templateDialogListener");
        LOGGER.finest("outcome: " + dialogEvent.getOutcome().name());
        if (dialogEvent.getOutcome().name().equals("ok")) {
            DCIteratorBinding tabIter = ADFUtils.findIterator("XwrlNoteTemplatesView1Iterator");
            Row row = tabIter.getCurrentRow();
            String val = (String) row.getAttribute("Note");
            LOGGER.finest("val: " + val);
            RichInputText it = (RichInputText) JSFUtils.findComponentInRoot("iait5");
            //Note: Change from setValue to setSubmittedValue when button Immediate property set to True
            //it.setValue(val);
            it.setSubmittedValue(val);
            AdfFacesContext.getCurrentInstance().addPartialTarget(it);
        } else if (dialogEvent.getOutcome().name().equals("cancel")) {
            BindingContainer bc = ADFUtils.getBindingContainer();
            OperationBinding op = bc.getOperationBinding("Rollback");
            op.execute();
            LOGGER.finest("Rollback");
        }
		
		 RichTable tab = (RichTable) JSFUtils.findComponentInRoot("iaat");
        AdfFacesContext.getCurrentInstance().addPartialTarget(tab);
    }

    public void templateShowPopup(ActionEvent event) {
        LOGGER.finest("templateShowPopup");
        ADFContext adfCtx = ADFContext.getCurrent();
        Map pageFlowScope = adfCtx.getPageFlowScope();
        LOGGER.finest("varNoteType: " + pageFlowScope.get("varNoteType"));
        LOGGER.finest("varNoteCategory: " + pageFlowScope.get("varNoteCategory"));
        BindingContainer bc = ADFUtils.getBindingContainer();
        OperationBinding op = bc.getOperationBinding("setNoteTemplate");
        op.execute();
        FacesContext context = FacesContext.getCurrentInstance();
        UIComponent source = (UIComponent) event.getSource();
        RichPopup comp = (RichPopup) JSFUtils.findComponentInRoot("iap2");
        LOGGER.finest("comp: " + comp);
        String alignId = source.getClientId(context);
        LOGGER.finest("alignId: " + alignId);
        RichPopup.PopupHints hints = new RichPopup.PopupHints();
        hints.add(RichPopup.PopupHints.HintTypes.HINT_LAUNCH_ID, source);
        hints.add(RichPopup.PopupHints.HintTypes.HINT_ALIGN, RichPopup.PopupHints.AlignTypes.ALIGN_OVERLAP);
        comp.show(hints);
    }

    public void deleteDialogListener(DialogEvent dialogEvent) {
        // Add event code here...
        LOGGER.finest("deleteDialogListener");
        LOGGER.finest("outcome: " + dialogEvent.getOutcome().name());
        BindingContainer bc = ADFUtils.getBindingContainer();
        ADFContext adfCtx = ADFContext.getCurrent();
        Map pageFlowScope = adfCtx.getPageFlowScope();
        
        DCIteratorBinding alertIterBinding = null;
        
        if (dialogEvent.getOutcome().name().equals("ok")) { 
            LOGGER.finest("Delete:alertNoteIterBinding:"+pageFlowScope.get("alertNoteIterBinding"));
             alertIterBinding = ADFUtils.findIterator(utils.nullStrToSpc(pageFlowScope.get("alertNoteIterBinding")));
            
            AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
            ViewObject vo=am.getXwrlNoteXrefView1();
            
            //T20200611.0029 - RE: OWS - Note Xref (IRI)
            ViewCriteria vc=vo.getViewCriteriaManager().getViewCriteria("XwrlNoteXrefViewCriteria");
            LOGGER.finest("VC:"+vc);
            vc.ensureVariableManager().setVariableValue("p_noteId", alertIterBinding.getCurrentRow().getAttribute("Id"));
            vo.applyViewCriteria(vc);
            vo.executeQuery();
            if(vo.hasNext()){
                vo.next().remove();
            }
                OperationBinding op = bc.getOperationBinding("Delete");
                op.execute();
                LOGGER.finest("Delete");

            bc = ADFUtils.getBindingContainer();
            op = bc.getOperationBinding("Commit");
            op.execute();
            
            op = bc.getOperationBinding("Execute");
            op.execute();
            
            RichTable atab = (RichTable) JSFUtils.findComponentInRoot("iaat");
            AdfFacesContext.getCurrentInstance().addPartialTarget(atab);
            
            pageFlowScope.put("alertNoteIterBinding",null);
            //T20200507.0012 - RE: OWS TC - duplicated case notes and case docs (IRI)
            //syncNotes();
        } else if (dialogEvent.getOutcome().name().equals("cancel")) {
            OperationBinding op = bc.getOperationBinding("Rollback");
            op.execute();
            LOGGER.finest("Rollback");
        }
    }

    public void deleteDocumentDialogListener(DialogEvent dialogEvent) {
        // Add event code here...
        // Delete documents
        try {
        LOGGER.finest("deleteDialogListener");
        LOGGER.finest("outcome: " + dialogEvent.getOutcome().name());
        if (dialogEvent.getOutcome().name().equals("ok")) 
        {
          
            ADFContext adfCtx = ADFContext.getCurrent();
            Map pageFlowScope = adfCtx.getPageFlowScope();
            String iterMasterBinding = (String) pageFlowScope.get("masterIter");
            String iterBinding = (String) pageFlowScope.get("iterBinding");
            LOGGER.finest("iterBinding: " + iterBinding);

            DCBindingContainer dbc = ADFUtils.getDCBindingContainer();
            DCIteratorBinding masterIter = dbc.findIteratorBinding(iterMasterBinding);
            Row masterRow = masterIter.getCurrentRow();

            String caseId = (String) masterRow.getAttribute("CaseId");
            LOGGER.finest("caseId: " + caseId);

            DCIteratorBinding iter1 = dbc.findIteratorBinding("XwrlCaseDocumentsSumView1Iterator");
            LOGGER.finest("iter1:"+iter1);
            Row row1 = iter1.getCurrentRow();
            LOGGER.finest("row1:"+row1);
            String idVal=utils.nullStrToSpc(row1.getAttribute("CaseDocId"));
            LOGGER.finest("row1 Id:"+idVal);
            
            AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
            
            ViewObject vo = am.getXwrlCaseDocumentsView3();
            LOGGER.finest("VO:"+vo);
            ViewCriteria vc=vo.getViewCriteriaManager().getViewCriteria("XwrlCaseDocumentsViewCriteria1");
            LOGGER.finest("VC:"+vc);
            vc.ensureVariableManager().setVariableValue("p_id", new BigDecimal(idVal));
            vo.applyViewCriteria(vc);
            vo.executeQuery();
            Row row=null;
            if(vo.hasNext()){
                row=vo.next();
            }

            String alertId = null;
            if (iterBinding.equals("XwrlAlertDocumentsView1Iterator")) {
                alertId = (String) row.getAttribute("AlertId");
            } else if (iterBinding.equals("XwrlAlertDocumentsView2Iterator")) {
                alertId = (String) row.getAttribute("AlertId");
            }
            LOGGER.finest("alertId: " + alertId);

            String filePath = (String) row.getAttribute("FilePath");
            LOGGER.finest("filePath: " + filePath);
            String documentFile = (String) row.getAttribute("DocumentFile");
            LOGGER.finest("documentFile: " + documentFile);
            String documentName = (String) row.getAttribute("DocumentName");
            LOGGER.finest("documentName: " + documentName);
            String imagePath = (String) row.getAttribute("ImagePath");
            LOGGER.finest("imagePath: " + imagePath);
            String imageFile = (String) row.getAttribute("ImageFile");
            LOGGER.finest("imageFile: " + imageFile);
            String imageName = (String) row.getAttribute("ImageName");
            LOGGER.finest("imageName: " + imageName);
            String docDirName = null;
            File docDir = null;
            String rootPath = null;

            FacesContext facesCtx = FacesContext.getCurrentInstance();
            ExternalContext ectx = facesCtx.getExternalContext();
            Map<String, Object> initParamsVar = ectx.getInitParameterMap();


            //OS.isFamilyWindows() Note: this stopped working 10/16/2019
            //SystemUtils.IS_OS_WINDOWS
            if (SystemUtils.IS_OS_WINDOWS) {
                rootPath = (String) initParamsVar.get("oracle.apps.xwrl.FILE_UPLOAD_WIN");
            } else {
                rootPath = (String) initParamsVar.get("oracle.apps.xwrl.FILE_UPLOAD_LINUX");
            }
            LOGGER.finest("rootPath: " + rootPath);

            // Get Year
            Date date = new Date();
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(date);
            int year = calendar.get(Calendar.YEAR);

            // Create Directory Path
            if (alertId != null) {
                docDirName =
                    rootPath + year + File.separator + "Trash" + File.separator + caseId + File.separator + alertId;
            } else {
                docDirName = rootPath + year + File.separator + "Trash" + File.separator + caseId;
            }
            LOGGER.finest("directory: " + docDir);

            
                File dirPath = new File(docDirName);
                if (!dirPath.exists()) {
                    dirPath.mkdirs();
                }

                File docFile = new File(documentFile);
                File docTargetFile = new File(dirPath + File.separator + documentName);
                if (docFile.exists()) {
                    try {
                        FileUtils.moveFile(docFile, docTargetFile);
                    } catch (IOException e) {
                        LOGGER.finest("Exception: " + e.getMessage());
                        e.printStackTrace();
                    }
                }
            
            row.remove();
            BindingContainer bc = ADFUtils.getBindingContainer();
            LOGGER.finest("Delete");
            bc = ADFUtils.getBindingContainer();
            OperationBinding op = bc.getOperationBinding("Commit");
            op.execute();
            
             op = bc.getOperationBinding("Execute1");
            op.execute();
            LOGGER.finest("Commit");
        } else if (dialogEvent.getOutcome().name().equals("cancel")) {
            BindingContainer bc = ADFUtils.getBindingContainer();
            OperationBinding op = bc.getOperationBinding("Rollback");
            op.execute();
            LOGGER.finest("Rollback");
        }

        RichTable tab = (RichTable) JSFUtils.findComponentInRoot("t3");
        LOGGER.finest("tab: " + tab);
        AdfFacesContext.getCurrentInstance().addPartialTarget(tab);
        
        } catch (Exception e) {
            // TODO: Add catch code
            e.printStackTrace();
        }
    }

    public void deleteShowPopup(ActionEvent event) 
	{
        String iterBinding= utils.nullStrToSpc(event.getComponent().getAttributes().get("iterBinding"));
        ADFContext adfCtx = ADFContext.getCurrent();
        Map pageFlowScope = adfCtx.getPageFlowScope();
    
        pageFlowScope.put("alertNoteIterBinding",iterBinding);
        
        String id = "";
		
		try
		{
			id = utils.nullStrToSpc(JSFUtils.resolveExpressionAsBigDecimal("#{bindings.Id.inputValue}"));
		}catch(Exception e)
		{
		    e.printStackTrace();
		}
		
		try
		{
			id = utils.nullStrToSpc(JSFUtils.resolveExpressionAsBigDecimal("#{bindings.ReqId.inputValue}"));
		 }catch(Exception e)
		{
			e.printStackTrace();
		}
		
		if(!"".equals(id))
		{
			if("ERROR".equals(execRequestLock()))
			{
				return;
			}
		}
		
		
		LOGGER.finest("deleteShowPopup");
        FacesContext context = FacesContext.getCurrentInstance();
        UIComponent source = (UIComponent) event.getSource();
        RichPopup comp = (RichPopup) JSFUtils.findComponentInRoot("iap3");
		if(comp==null)
		{
			comp = (RichPopup) JSFUtils.findComponentInRoot("p3");
		}
        LOGGER.finest("comp: " + comp);
        String alignId = source.getClientId(context);
        LOGGER.finest("alignId: " + alignId);
        RichPopup.PopupHints hints = new RichPopup.PopupHints();
        hints.add(RichPopup.PopupHints.HintTypes.HINT_LAUNCH_ID, source);
        hints.add(RichPopup.PopupHints.HintTypes.HINT_ALIGN, RichPopup.PopupHints.AlignTypes.ALIGN_OVERLAP);
        comp.show(hints);
    }

    public void alertPopupFetchListener(PopupFetchEvent popupFetchEvent) {
        // Add event code here...
        LOGGER.finest("alertPopupFetchListener");
        // Get iterator from binding
        DCIteratorBinding tabIter = null;
        DCIteratorBinding custAlertIter = null;   
        ADFContext adfCtx = ADFContext.getCurrent();
        Map pageFlowScope = adfCtx.getPageFlowScope();
        
        String alertIterator = (String) pageFlowScope.get("clearAlertIterator");
        LOGGER.finest("alertIterator: " + alertIterator);
        
        if (alertIterator.equals("XwrlResponseIndColumnsView1")) {
            tabIter = ADFUtils.findIterator("XwrlResponseIndColumnsView1Iterator");
            custAlertIter  =  ADFUtils.findIterator("CustClearAlertView1Iterator");
        } else if (alertIterator.equals("XwrlResponseEntityColumnsView1")) {
            tabIter = ADFUtils.findIterator("XwrlResponseEntityColumnsView1Iterator");
            custAlertIter  =  ADFUtils.findIterator("CustClearEntityAlertView1Iterator");
        } else {
            LOGGER.finest("alertIterator IS NOT FOUND");
        }
        
        LOGGER.finest("tabIter: " + tabIter.getVOName());
        LOGGER.finest("custAlertIter: " + custAlertIter.getVOName());
        

        RowSetIterator rsi = tabIter.getRowSetIterator();
        LOGGER.finest("Row Rec: " + rsi.getCurrentRow().getAttribute("Rec"));
        
        String readMode = "";
        String superUsr = "";
        String corporateReviewer = "";  // T20221108.0024 - TC Role Based Access Control
        String adminUsr = "";
        String legalReview = "";
        String corporateReview = "";  // T20221108.0024 - TC Role Based Access Control
        
        String rec = "";
        String recordState="";
        
        UserRespAndSessionInfo userRespAndSessionInfo = (UserRespAndSessionInfo) JSFUtils.getManagedBeanValue("sessionScope.UserRespAndSessionInfo");
        
        if(userRespAndSessionInfo!=null)
        {
          superUsr  = userRespAndSessionInfo.getIsSuperUserOnly();
          corporateReviewer = userRespAndSessionInfo.getIsCorporateReviewer();   // T20221108.0024 - TC Role Based Access Control
          LOGGER.finest("corporateReviewer: " + corporateReviewer);
          readMode  = userRespAndSessionInfo.getIsReadOnly();
          adminUsr  = userRespAndSessionInfo.getIsAdminOnly();
        }

        // Get selected rows from table
        RichTable tab = (RichTable) JSFUtils.findComponentInRoot("t1");
        RowKeySet currentRks = tab.getSelectedRowKeys();
        BigDecimal requestId = null;
        String alertId = null;
        Boolean addToList = true;
        ArrayList<String> alertList = new ArrayList<String>();
        ArrayList<String> alertRecList = new ArrayList<String>();
        ArrayList<AlertRecord> alertNoteList = new ArrayList<AlertRecord>();

        LOGGER.finest("Rec Count: " + currentRks.size());

        if (currentRks.size() > 0) {
            // Get Alert ID from iterator lookup of selected row from table
            for (Object selectedRowKey : currentRks) {
                LOGGER.finest("selectedRowKey: " + selectedRowKey);
                Key key = (Key) ((List) selectedRowKey).get(0);
                Row currentRow = rsi.getRow(key);
                //LOGGER.finest("Key: " + rowKey);
                LOGGER.finest("RequestId: " + currentRow.getAttribute("RequestId"));
                requestId = (BigDecimal) currentRow.getAttribute("RequestId");
                //LOGGER.finest("Rec: " + currentRow.getAttribute("Rec"));
                LOGGER.finest("AlertID: " + currentRow.getAttribute("Alertid"));
                
                legalReview = utils.nullStrToSpc(currentRow.getAttribute("LegalReview"));
                LOGGER.finest("legalReview:"+legalReview);
                
                // T20221108.0024 - TC Role Based Access Control
                // Note: Need to get for the Alert and not the Case (i.e. request)
                corporateReview = utils.nullStrToSpc(currentRow.getAttribute("CorporateReview"));                
                LOGGER.finest("corporateReview:"+corporateReview);

                //T20210401.0015 - possible matches with approved status
                recordState=utils.nullStrToSpc(currentRow.getAttribute("Stateattr"));
                LOGGER.finest("recordState:"+recordState);
                System.out.println("recordState:"+recordState);
                
                if("Y".equals(legalReview) && "Y".equals(readMode) && ("N".equals(adminUsr) && "N".equals(superUsr) || userRespAndSessionInfo == null))
                {
                    addToList = false;
                    LOGGER.finest("Don't add it to the list");
                    
                    LOGGER.finest("corporateReviewer:"+corporateReviewer);
                    LOGGER.finest("corporateReview:"+corporateReview);
                    
                    // T20221108.0024 - TC Role Based Access Control
                    // Handling as an override
                    if("Y".equals(corporateReviewer) && "Y".equals(corporateReview) )
                    {
                        LOGGER.finest("Add it to the list");
                        addToList = true;
                    }
                    
                }
                else if ("Possible".equals(recordState) && "Y".equals(readMode) && ("N".equals(adminUsr) && "N".equals(superUsr) || userRespAndSessionInfo == null))
                {
                    addToList = false;
                    LOGGER.finest("Don't add it to the list");

                    // T20221108.0024 - TC Role Based Access Control
                    // Handling as an override                    
                    if ("Y".equals(corporateReviewer))
                    {
                        LOGGER.finest("Add it to the list");
                        addToList = true;
                    }                    
                }
                else if ("Positive".equals(recordState) && "Y".equals(readMode) && ("N".equals(adminUsr) && "N".equals(superUsr) || userRespAndSessionInfo == null))
                {
                    addToList = false;
                    LOGGER.finest("Don't add it to the list");
                }
             
            if (addToList) {
                    
                    alertId = (String) currentRow.getAttribute("Alertid");
                    alertList.add(alertId);
                    
                    rec = utils.nullStrToSpc(currentRow.getAttribute("Rec"));
                    alertRecList.add(rec);
                    
                    AlertRecord alert = new AlertRecord();
                    alert.requestId = requestId;
                    alert.alertId = alertId;
                    alertNoteList.add(alert);
                    
                    this.setALERT_LIST((ArrayList) alertList);
                    this.setALERT_REC_LIST((ArrayList) alertRecList);

                    //Note: Need to save for alertDialogListener
                    pageFlowScope.put("varAlertNoteList", alertNoteList);
                }

                String alertType = (String) pageFlowScope.get("alertType");
                            
                ViewObject vo = custAlertIter.getViewObject();
                Row row = vo.createRow();
                vo.insertRow(row);
            }
        }
        
        //T20210908.0021 - TC - UAT - Issue
        if(alertNoteList.size()== 0) 
            pageFlowScope.put("varAlertNoteList", null);
        
    }

    public void alertDialogListener(DialogEvent dialogEvent) {
        // Add event code here...
        LOGGER.finest("alertDialogListener");
        LOGGER.finest("outcome: " + dialogEvent.getOutcome().name());

        DCIteratorBinding tabIter = null;
        DCIteratorBinding custAlertIter = null;
        String caseAlertState = "";
        
        ADFContext adfCtx = ADFContext.getCurrent();
        Map pageFlowScope = adfCtx.getPageFlowScope();
        String alertIterator = (String) pageFlowScope.get("clearAlertIterator");
        LOGGER.finest("alertIterator: " + alertIterator);
        
        if (alertIterator.equals("XwrlResponseIndColumnsView1")) {
            tabIter = ADFUtils.findIterator("XwrlResponseIndColumnsView1Iterator");            
            custAlertIter = ADFUtils.findIterator("CustClearAlertView1Iterator");  
          caseAlertState = utils.nullStrToSpc(JSFUtils.resolveExpression("#{bindings.CaseAlertState.inputValue}"));
        } else if (alertIterator.equals("XwrlResponseEntityColumnsView1")) {
            tabIter = ADFUtils.findIterator("XwrlResponseEntityColumnsView1Iterator");            
            custAlertIter = ADFUtils.findIterator("CustClearEntityAlertView1Iterator");  
          caseAlertState = utils.nullStrToSpc(JSFUtils.resolveExpression("#{bindings.CaseAlertStateAttr.inputValue}"));
        } else {
            LOGGER.finest("alertIterator IS NOT FOUND");
        }
        
        LOGGER.finest("tabIter: " + tabIter.getVOName());
        LOGGER.finest("custAlertIter: " + custAlertIter.getVOName());
        
        
        // Note: This works for both Individual and Entity pages
        String note = utils.nullStrToSpc(pageFlowScope.get("noteSelectionItem"));
        LOGGER.finest("noteSelectionItem: " + note);
        LOGGER.finest("noteSelectionItem: "+note);
        
        LOGGER.finest("caseAlertState::"+caseAlertState);
        
        if (dialogEvent.getOutcome().name().equals("ok")) {

            IRIUtils utils = new IRIUtils();
            Integer userId = (Integer) ADFContext.getCurrent().getSessionScope().get("UserId");
            Integer sessionId = (Integer) ADFContext.getCurrent().getSessionScope().get("SessionId");
            String userName = utils.nullStrToSpc(ADFContext.getCurrent().getSessionScope().get("UserName"));
            LOGGER.finest("userName: " + userName);

            ArrayList<AlertRecord> alertNoteList = (ArrayList<AlertRecord>) pageFlowScope.get("varAlertNoteList");
            LOGGER.finest("alertNoteList: " + alertNoteList.size());
            BigDecimal requestId = null;

            // Process Alerts
            Connection connection = null;
            CallableStatement stmt = null;
            String sql = null;


            try {
                
                final String typeTableName = "XWRL_ALERT_TBL_IN_TYPE";             
                String listRecordType = null;
                String pToState = null;
    
                LOGGER.finest("alertIterator: " + alertIterator);
                AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
                LOGGER.finest("am: " + am);

                final ArrayList<Alert> alerts = new ArrayList<Alert>();
                
                sql = "begin xwrl_ows_utils.test_db_link(?); end;";
                stmt = am.getDBTransaction().createCallableStatement(sql, 0);
                stmt.registerOutParameter(1, Types.INTEGER);
                stmt.execute();
                int dbLink = stmt.getInt(1);
                
                LOGGER.finest("dbLink: " + dbLink);
                
                if (dbLink != 0) 
                {
                    sql =
                        "begin xwrl_ows_utils.process_alerts(p_user_id => :1, p_session_id => :2, p_request_id => :3, p_alert_tab => :4); end;";

                    LOGGER.finest("sql: " + sql);
                    stmt = am.getDBTransaction().createCallableStatement(sql, 0);
                    connection = stmt.getConnection();
                    OracleConnection conn = connection.unwrap(OracleConnection.class);

                    for (AlertRecord item : alertNoteList) {

                        LOGGER.finest("item ALERT: " + item.alertId);

                        if (alertIterator.equals("XwrlResponseIndColumnsView1")) {
                            LOGGER.finest("alertIterator: " + alertIterator);
                            XwrlResponseIndColumnsViewImpl avo = am.getXwrlResponseIndColumnsView1();
                            RowFinder finder = avo.lookupRowFinder("RowFinder");
                            NameValuePairs nvp = new NameValuePairs();
                            nvp.setAttribute("Alertid", item.alertId);
                            LOGGER.finest("Alertid: " + item.alertId);
                            RowIterator ri = finder.execute(nvp, avo);
                            LOGGER.finest("ri row count: " + ri.getRowCount());
                            LOGGER.finest("ri: " + ri);
                            Row iterRow;
                            while (ri.hasNext()) {
                                iterRow = ri.next();
                                requestId = (BigDecimal) iterRow.getAttribute("RequestId");
                                listRecordType = (String) iterRow.getAttribute("Listrecordtype");
                                LOGGER.finest("listRecordType: " + listRecordType);
                            }

                        } else if (alertIterator.equals("XwrlResponseEntityColumnsView1")) {
                            LOGGER.finest("alertIterator: " + alertIterator);
                            XwrlResponseEntityColumnsViewImpl avo = am.getXwrlResponseEntityColumnsView1();
                            RowFinder finder = avo.lookupRowFinder("RowFinder");
                            NameValuePairs nvp = new NameValuePairs();
                            nvp.setAttribute("Alertid", item.alertId);
                            LOGGER.finest("Alertid: " + item.alertId);
                            RowIterator ri = finder.execute(nvp, avo);
                            LOGGER.finest("ri row count: " + ri.getRowCount());
                            Row iterRow;
                            while (ri.hasNext()) {
                                iterRow = ri.next();
                                requestId = (BigDecimal) iterRow.getAttribute("RequestId");
                                listRecordType = (String) iterRow.getAttribute("Listrecordtype");
                                LOGGER.finest("listRecordType: " + listRecordType);
                            }

                        }

                        if (listRecordType.equals("PEP")) 
                        {
                            pToState = "PEP - "+ caseAlertState;
                        } else if (listRecordType.equals("EDD")) 
                        {
                            pToState = "EDD - "+caseAlertState;
                        } else if (listRecordType.equals("SAN")) 
                        {
                            pToState = "SAN - "+caseAlertState;
                        }

                        LOGGER.finest("Alert Id: " + item.alertId);
						LOGGER.finest("pToState: " + pToState);
						LOGGER.finest("note: " + note);
						
                        final Alert alert = new Alert();
                        alert.setPAlert(item.alertId);
                        alert.setPToState(pToState);
                        alert.setPComment(note);
                        alerts.add(alert);

                    }

                    LOGGER.finest("IN Array: " + alerts);
                    LOGGER.finest("schema: " + conn.getCurrentSchema());
                    final Array dataArray = conn.createOracleArray(typeTableName, alerts.toArray());

                    LOGGER.finest("pUser: " + userName);
                    LOGGER.finest("dataArray: " + dataArray);

                    LOGGER.finest("userId: " + userId);
                    LOGGER.finest("sessionId: " + sessionId);
                    LOGGER.finest("requestId: " + requestId.intValue());
                    LOGGER.finest("dataArray: " + dataArray);

                    stmt.setInt(1, userId);
                    stmt.setInt(2, sessionId);
                    stmt.setInt(3, requestId.intValue());
                    stmt.setArray(4, dataArray);
                    try{
                        stmt.execute();
                    } catch(SQLException se) {
                        se.printStackTrace();
                        
                        String error = se.getMessage().split("\n")[0];
                        String msg = "";
                        if(error.contains(": Error: "))
                            msg = error.substring(("ORA-"+se.getErrorCode()+": Error: ").length(),error.length());
                        else
                            msg = error.substring(("ORA-"+se.getErrorCode()).length(),error.length());
                        
                        
                        FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_ERROR, msg, null);
                        FacesContext.getCurrentInstance().addMessage(null, message);
                        return;
                    }

                    DCIteratorBinding iter = null;
                    Row currRow = null;

                    if (alertIterator.equals("XwrlResponseIndColumnsView1")) {
                        LOGGER.finest("alertIterator: " + alertIterator);
                        iter = ADFUtils.findIterator("XwrlResponseIndColumnsView1Iterator");
                        iter.executeQuery();
                        calIndRecordStateCount();
                        currRow = iter.getCurrentRow();
                    } else if (alertIterator.equals("XwrlResponseEntityColumnsView1")) {
                        LOGGER.finest("alertIterator: " + alertIterator);
                        iter = ADFUtils.findIterator("XwrlResponseEntityColumnsView1Iterator");
                        iter.executeQuery();			
			calEntRecordStateCount();			
                        currRow = iter.getCurrentRow();
                    }


                    try {
                        
                        Key key = new Key(new Object[] { currRow.getAttribute("Id") });
                        iter.setCurrentRowWithKey(key.toStringFormat(true));                        
                        LOGGER.finest("alrt close rec numberd::"+ (BigDecimal)currRow.getAttribute("Rec"));
                        
                        ArrayList tableRowKey = new ArrayList();
                        tableRowKey.add(key);
                        RowKeySet rks = new RowKeySetImpl();
                        rks.add(tableRowKey);

                        RichTable tab = (RichTable) JSFUtils.findComponentInRoot("t1");
                        tab.setSelectedRowKeys(rks);
                        AdfFacesContext.getCurrentInstance().addPartialTarget(tab);
                        
                    } catch (Exception e) {
                        // TODO: Add catch code
                        e.printStackTrace();
                    }
                     
                    try 
                    {
                        Integer usrId = (Integer) ADFContext.getCurrent().getSessionScope().get("UserId");
                        Integer sesionId = (Integer) ADFContext.getCurrent().getSessionScope().get("SessionId");
                        //T20200924.0043 - Trade Compliance slow speed - FIN 1384937 (IRI)
                        String rType="";
                        if(alertIterator.equals("XwrlResponseEntityColumnsView1")) 
                        {
                            rType="E";
                        }
                            if(alertIterator.equals("XwrlResponseIndColumnsView1"))  
                        {
                            rType="I";
                        }
                    LOGGER.finest("calling XWRL_OWS_UTILS.invoke_process_clear_alerts procedure started");
                    callClearAlertsConc(rType,usrId,sesionId,requestId.intValue(),dataArray);
                        
                    } catch (Exception e) 
                    {
                        // TODO: Add catch code
                        e.printStackTrace();
                          LOGGER.finest("Error invoking XWRL_OWS_UTILS.auto_clear_individuals ::"+e);
                    }
                    finally {
                        try {
                            
                           if(stmt!=null) {
                               stmt.close();
                           }
                       } catch (Exception e) {
                            // TODO: Add catch code
                            e.printStackTrace();
                        }
                      }
                    
                    
                } else {
                    String msg = "Error: The DB link is not active.  Please contact system admistrator or try again later.";
                    FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_ERROR, msg.toString(), null);
                    FacesContext.getCurrentInstance().addMessage(null, message);
                }

                

            } catch (SQLException e) {
                e.printStackTrace();
                String msg = "Error: There is a database processing error: "+utils.returnStackTrace(e);
                FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_ERROR, msg.toString(), null);
                FacesContext.getCurrentInstance().addMessage(null, message);
            }


        } else if (dialogEvent.getOutcome().name().equals("cancel")) {
            BindingContainer bc = ADFUtils.getBindingContainer();
            OperationBinding op = bc.getOperationBinding("Rollback");
            op.execute();
            LOGGER.finest("Rollback");
        }
    }
    
    //T20200924.0043 - Trade Compliance slow speed - FIN 1384937 (IRI)
        private void callClearAlertsConc(String rType,Integer userId,Integer sessionId,Integer requestId,Array dataArray){
            LOGGER.finest("callClearAlertsConc method started");
            try{
                LOGGER.finest("calling XWRL_OWS_UTILS.invoke_process_clear_alerts procedure started");
                AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
                String sq="begin XWRL_OWS_UTILS.invoke_process_clear_alerts(p_type => :1,p_user_id => :2,p_session_id => :3,p_request_id => :4,p_alert_in_tbl => :5); end;";
                java.sql.CallableStatement st = am.getDBTransaction().createCallableStatement(sq, 0);
                
                st.setString(1,rType);
                st.setInt(2, userId);
                st.setInt(3, sessionId);
                st.setInt(4, requestId);
                st.setArray(5,dataArray);
                st.execute();
                
                LOGGER.finest("calling XWRL_OWS_UTILS.invoke_process_clear_alerts procedure ended");
            }catch(Exception e){
                e.printStackTrace();
            }
            LOGGER.finest("callClearAlertsConc method ended");
        }
    
    //T20200819.0006 - OWS - bulk add notes feature (IRI)
    public void bulkNotesDialogListener(DialogEvent dialogEvent) {
        // Add event code here...
        LOGGER.finest("alertDialogListener");
        LOGGER.finest("outcome: " + dialogEvent.getOutcome().name());

        DCIteratorBinding tabIter = null;
        DCIteratorBinding custAlertIter = null;
        
        ADFContext adfCtx = ADFContext.getCurrent();
        Map pageFlowScope = adfCtx.getPageFlowScope();
        String alertIterator = (String) pageFlowScope.get("clearAlertIterator");
        LOGGER.finest("alertIterator: " + alertIterator);
        
        if (alertIterator.equals("XwrlResponseIndColumnsView1")) {
            tabIter = ADFUtils.findIterator("XwrlResponseIndColumnsView1Iterator");            
            custAlertIter = ADFUtils.findIterator("CustClearAlertView1Iterator");  
        } else if (alertIterator.equals("XwrlResponseEntityColumnsView1")) {
            tabIter = ADFUtils.findIterator("XwrlResponseEntityColumnsView1Iterator");            
            custAlertIter = ADFUtils.findIterator("CustClearEntityAlertView1Iterator");  
        } else {
            LOGGER.finest("alertIterator IS NOT FOUND");
        }
        
        LOGGER.finest("tabIter: " + tabIter.getVOName());
        LOGGER.finest("custAlertIter: " + custAlertIter.getVOName());
        
        // Note: This works for both Individual and Entity pages
        String note = utils.nullStrToSpc(pageFlowScope.get("noteSelectionItem"));
        LOGGER.finest("noteSelectionItem: " + note);
        
        if (dialogEvent.getOutcome().name().equals("ok")) {

            //String pUser = "tsuazo";
            UserRespAndSessionInfo info = new UserRespAndSessionInfo();
            //String pUser = info.getUserName();
            IRIUtils utils = new IRIUtils();
            Integer userId = (Integer) ADFContext.getCurrent().getSessionScope().get("UserId");
            Integer sessionId = (Integer) ADFContext.getCurrent().getSessionScope().get("SessionId");
            String userName = utils.nullStrToSpc(ADFContext.getCurrent().getSessionScope().get("UserName"));
            LOGGER.finest("userName: " + userName);

            //Note: This call is outside of managed bean scope so need to get values from pageFlowScope
            BindingContainer bc = ADFUtils.getBindingContainer();

            ArrayList<AlertRecord> alertNoteList = (ArrayList<AlertRecord>) pageFlowScope.get("varAlertNoteList");
            LOGGER.finest("alertNoteList: " + alertNoteList.size());
            BigDecimal requestId = null;

            // Process Alerts
            Connection connection = null;
            CallableStatement stmt = null;
            String sql = null;
            
            Connection con = null;
            CallableStatement st = null;
            String sq = null;

            try {
                final String typeName = "XWRL_ALERT_IN_REC";
                final String typeTableName = "XWRL_ALERT_TBL_IN_TYPE";
                final String objectName = "XWRL_ALERT_TBL_IN_TYPE";
                String listRecordType = null;


                String pToState = null;
                String pComment = "Close Alert from EBS";

                LOGGER.finest("alertIterator: " + alertIterator);
                AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
                LOGGER.finest("am: " + am);

                final ArrayList<Alert> alerts = new ArrayList<Alert>();
                
                sql = "begin xwrl_ows_utils.test_db_link(?); end;";
                stmt = (java.sql.CallableStatement) am.getDBTransaction().createCallableStatement(sql, 0);
                stmt.registerOutParameter(1, Types.INTEGER);
                stmt.execute();
                int dbLink = stmt.getInt(1);
                
                LOGGER.finest("dbLink: " + dbLink);
                
                if (dbLink != 0) 
                {
                    sql =
                        "begin xwrl_ows_utils.process_notes(p_user_id => :1, p_session_id => :2, p_request_id => :3, p_alert_id => :4, p_notes => :5); end;";

                    LOGGER.finest("sql: " + sql);
                    stmt = (java.sql.CallableStatement) am.getDBTransaction().createCallableStatement(sql, 0);
                    connection = stmt.getConnection();
                    OracleConnection conn = connection.unwrap(OracleConnection.class);

                    
                    for (AlertRecord item : alertNoteList) {

                        LOGGER.finest("item ALERT: " + item.alertId);

                        if (alertIterator.equals("XwrlResponseIndColumnsView1")) {
                            LOGGER.finest("alertIterator: " + alertIterator);
                            XwrlResponseIndColumnsViewImpl avo =
                                (XwrlResponseIndColumnsViewImpl) am.getXwrlResponseIndColumnsView1();
                            RowFinder finder = avo.lookupRowFinder("RowFinder");
                            NameValuePairs nvp = new NameValuePairs();
                            nvp.setAttribute("Alertid", item.alertId);
                            LOGGER.finest("Alertid: " + item.alertId);
                            RowIterator ri = finder.execute(nvp, avo);
                            LOGGER.finest("ri row count: " + ri.getRowCount());
                            LOGGER.finest("ri: " + ri);
                            Row iterRow;
                            while (ri.hasNext()) {
                                iterRow = ri.next();
                                requestId = (BigDecimal) iterRow.getAttribute("RequestId");
                                listRecordType = (String) iterRow.getAttribute("Listrecordtype");
                                LOGGER.finest("listRecordType: " + listRecordType);
                            }

                        } else if (alertIterator.equals("XwrlResponseEntityColumnsView1")) {
                            LOGGER.finest("alertIterator: " + alertIterator);
                            XwrlResponseEntityColumnsViewImpl avo =
                                (XwrlResponseEntityColumnsViewImpl) am.getXwrlResponseEntityColumnsView1();
                            RowFinder finder = avo.lookupRowFinder("RowFinder");
                            NameValuePairs nvp = new NameValuePairs();
                            nvp.setAttribute("Alertid", item.alertId);
                            LOGGER.finest("Alertid: " + item.alertId);
                            RowIterator ri = finder.execute(nvp, avo);
                            LOGGER.finest("ri row count: " + ri.getRowCount());
                            Row iterRow;
                            while (ri.hasNext()) {
                                iterRow = ri.next();
                                requestId = (BigDecimal) iterRow.getAttribute("RequestId");
                                listRecordType = (String) iterRow.getAttribute("Listrecordtype");
                                LOGGER.finest("listRecordType: " + listRecordType);
                            }

                        }

                        LOGGER.finest("Alert Id: " + item.alertId);
                        //LOGGER.finest("pToState: " + pToState);
                        LOGGER.finest("note: " + note);
                                                

                        final Alert alert = new Alert();
                        alert.setPAlert(item.alertId);
                        alert.setPToState(" ");
                        alert.setPComment(note);
                        alerts.add(alert);
                        
                        stmt.setInt(1, userId);
                        stmt.setInt(2, sessionId);
                        stmt.setInt(3, requestId.intValue());
                        stmt.setString(4, item.alertId);
                        stmt.setString(5,note);
                        stmt.execute();

                    }

                    LOGGER.finest("IN Array: " + alerts);
                    LOGGER.finest("schema: " + conn.getCurrentSchema());
                    final Array dataArray = conn.createOracleArray(typeTableName, alerts.toArray());

                    LOGGER.finest("pUser: " + userName);
                    LOGGER.finest("dataArray: " + dataArray);

                    LOGGER.finest("userId: " + userId);
                    LOGGER.finest("sessionId: " + sessionId);
                    LOGGER.finest("requestId: " + requestId.intValue());
                    LOGGER.finest("dataArray: " + dataArray);

                    

                    DCIteratorBinding iter = null;
                    Row currRow = null;

                    if (alertIterator.equals("XwrlResponseIndColumnsView1")) {
                        LOGGER.finest("alertIterator: " + alertIterator);
                        XwrlResponseIndColumnsViewImpl avo =
                            (XwrlResponseIndColumnsViewImpl) am.getXwrlResponseIndColumnsView1();
                        iter = ADFUtils.findIterator("XwrlResponseIndColumnsView1Iterator");
                       // currRow = iter.getCurrentRow();
                        iter.executeQuery();
                                                
                                                calIndRecordStateCount();
                                                
                        currRow = iter.getCurrentRow();
                        
                        
                       
                    } else if (alertIterator.equals("XwrlResponseEntityColumnsView1")) {
                        LOGGER.finest("alertIterator: " + alertIterator);
                        XwrlResponseEntityColumnsViewImpl avo =
                            (XwrlResponseEntityColumnsViewImpl) am.getXwrlResponseEntityColumnsView1();
                        iter = ADFUtils.findIterator("XwrlResponseEntityColumnsView1Iterator");
                      //  currRow = iter.getCurrentRow();
                        iter.executeQuery();
                                                
                                                calEntRecordStateCount();
                                                
                        currRow = iter.getCurrentRow();
                        
                        
                    }


                    try {
                        
                    //   RowSetIterator rsi = iter.getRowSetIterator();
                        Key key = new Key(new Object[] { currRow.getAttribute("Id") });
                     //   Row row = rsi.findByKey(key, 1)[0];
                       // rsi.setCurrentRow(row);
                        iter.setCurrentRowWithKey(key.toStringFormat(true));
                        
                      LOGGER.finest("alrt close rec numberd::"+ (BigDecimal)currRow.getAttribute("Rec"));
                        
                        ArrayList tableRowKey = new ArrayList();
                        tableRowKey.add(key);
                        
                        
                        RowKeySet rks = new RowKeySetImpl();
                        rks.add(tableRowKey);
                        
                        RichTable tab = (RichTable) JSFUtils.findComponentInRoot("t1");
                        tab.setSelectedRowKeys(rks);
                      //  tab.setScrollTop(10);
                        AdfFacesContext.getCurrentInstance().addPartialTarget(tab);
                        
                    } catch (Exception e) {
                        // TODO: Add catch code
                        e.printStackTrace();
                    }
                    
                    
                            
                     // Auto Clear Individuals and entities
                               
                    try 
                    {
                        
                        Integer usrId = (Integer) ADFContext.getCurrent().getSessionScope().get("UserId");
                        Integer sesionId = (Integer) ADFContext.getCurrent().getSessionScope().get("SessionId");
                        //T20200924.0043 - Trade Compliance slow speed - FIN 1384937 (IRI)
                        String rType="";
                        if(alertIterator.equals("XwrlResponseEntityColumnsView1")) 
                        {
                            rType="E";
                            //sq = "begin XWRL_OWS_UTILS.auto_clear_entities(p_user_id => :1, p_session_id=> :2, p_request_id => :3); end;";
                        }
                            if(alertIterator.equals("XwrlResponseIndColumnsView1"))  
                        {
                            rType="I";
                            //sq = "begin XWRL_OWS_UTILS.auto_clear_individuals(p_user_id => :1, p_session_id=> :2, p_request_id => :3); end;";
                        }
                        
                        callClearAlertsConc(rType,usrId,sesionId,requestId.intValue(),dataArray);
                    } catch (Exception e) 
                    {
                        // TODO: Add catch code
                        e.printStackTrace();
                          LOGGER.finest("Error invoking XWRL_OWS_UTILS.auto_clear_individuals ::"+e);
                    }
                   
                            finally {
                                try {
                                    if(st!=null) {
                                        st.close();
                                    }
                                    
                                   if(stmt!=null) {
                                       stmt.close();
                                   }
                               } catch (Exception e) {
                                    // TODO: Add catch code
                                    e.printStackTrace();
                                }
                              }
                    
                    
                } else {
                    String msg = "Error: The DB link is not active.  Please contact system admistrator or try again later.";
                    FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_ERROR, msg.toString(), null);
                    FacesContext.getCurrentInstance().addMessage(null, message);
                }

                

            } catch (SQLException e) {
                e.printStackTrace();
                String msg = "Error: There is a database processing error: "+utils.returnStackTrace(e);
                FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_ERROR, msg.toString(), null);
                FacesContext.getCurrentInstance().addMessage(null, message);
            }


        } else if (dialogEvent.getOutcome().name().equals("cancel")) {
            BindingContainer bc = ADFUtils.getBindingContainer();
            OperationBinding op = bc.getOperationBinding("Rollback");
            op.execute();
            LOGGER.finest("Rollback");
        }
    }
    
    public String printSelectedAlertNames() 
    {
              RichTable tab = (RichTable) JSFUtils.findComponentInRoot("t1");
            RowKeySet selectedAlrts = tab.getSelectedRowKeys();    
            Iterator selectedAlrtIter = selectedAlrts.iterator();
            DCBindingContainer bindings = (DCBindingContainer)BindingContext.getCurrent().getCurrentBindingsEntry();
            DCIteratorBinding empIter = bindings.findIteratorBinding("XwrlResponseIndColumnsView1Iterator");
            RowSetIterator empRSIter = empIter.getRowSetIterator();
             while(selectedAlrtIter.hasNext())
             {
               Key key = (Key)((List)selectedAlrtIter.next()).get(0);
               Row currentRow = empRSIter.getRow(key);
               LOGGER.finest("Legal Review in print" +currentRow.getAttribute("LegalReview"));
                 LOGGER.finest("UID in print" +currentRow.getAttribute("Listid"));
             }
             return null;
          }

   public void execIndAlertNotes(ActionEvent evt) 
   {
       DCIteratorBinding iter = null;
               DCBindingContainer dcBindingContainer = null;
               String com = "";

              try {
                  dcBindingContainer =
                      (DCBindingContainer) utils.getBindingsContOfOtherPage("oracle_apps_xwrl_view_EnterIndividualAlertNotePageDef");
                  iter = dcBindingContainer.findIteratorBinding("XwrlAlertNotesView1Iterator");
                  iter.executeQuery();
                  
                  LOGGER.finest("Ind Alert Count::"+ iter.getEstimatedRowCount());
              } catch (Exception e) {
                  // TODO: Add catch code
                  e.printStackTrace();
              }
   }
   
    public void execEntAlertNotes(ActionEvent evt) 
    {
        DCIteratorBinding iter = null;
                DCBindingContainer dcBindingContainer = null;
                String com = "";

               try {
                   dcBindingContainer =
                       (DCBindingContainer) utils.getBindingsContOfOtherPage("oracle_apps_xwrl_view_EnterEntityAlertNotePageDef");
                   iter = dcBindingContainer.findIteratorBinding("XwrlAlertNotesView2Iterator");
                   iter.executeQuery();
                   
                   LOGGER.finest("Entity Alert Count::"+ iter.getEstimatedRowCount());
               } catch (Exception e) {
                   // TODO: Add catch code
                   e.printStackTrace();
               }
    }
   
    


    public void alertShowPopup(ActionEvent event) 
	{
        ADFContext adfCtx = ADFContext.getCurrent();
        Map pageFlowScope = adfCtx.getPageFlowScope();
        String alertIterator = (String) pageFlowScope.get("clearAlertIterator");
        LOGGER.finest("alertIterator: " + alertIterator);
		
		String id = utils.nullStrToSpc(JSFUtils.resolveExpressionAsBigDecimal("#{bindings.Id.inputValue}"));
        
        
        if (alertIterator.equals("XwrlResponseIndColumnsView1")) 
		{
			if("ERROR".equals(execRequestLock()))
			{
				return;
			}
        } 
		if (alertIterator.equals("XwrlResponseEntityColumnsView1")) 
		{
			if("ERROR".equals(execRequestLock()))
			{
				return;
			}
        } 
		
		
			
		LOGGER.finest("alertShowPopup");
        FacesContext context = FacesContext.getCurrentInstance();
        UIComponent source = (UIComponent) event.getSource();
        //UIComponent alignSource = JSFUtils.findComponentInRoot("ph5");
        RichPopup comp = (RichPopup) JSFUtils.findComponentInRoot("p1");

        RichTable tab = (RichTable) JSFUtils.findComponentInRoot("t1");
        RowKeySet currentRks = tab.getSelectedRowKeys();
        
        if (currentRks.size() > 0) 
        {

            LOGGER.finest("comp: " + comp);
            String alignId = source.getClientId(context);
            LOGGER.finest("alignId: " + alignId);
            RichPopup.PopupHints hints = new RichPopup.PopupHints();
            //hints.add(RichPopup.PopupHints.HintTypes.HINT_ALIGN_ID, alignSource);
            hints.add(RichPopup.PopupHints.HintTypes.HINT_LAUNCH_ID, source);
            hints.add(RichPopup.PopupHints.HintTypes.HINT_ALIGN, RichPopup.PopupHints.AlignTypes.ALIGN_OVERLAP);
            comp.show(hints);
            
            
        } else {
            String msg = "Please select record(s) from the table.";
            FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_ERROR, msg.toString(), null);
            FacesContext.getCurrentInstance().addMessage(null, message);
        }
    }
    
    //T20200819.0006 - OWS - bulk add notes feature (IRI)
    public void bulkNotesShowPopup(ActionEvent event) 
        {
        ADFContext adfCtx = ADFContext.getCurrent();
        Map pageFlowScope = adfCtx.getPageFlowScope();
        String alertIterator = (String) pageFlowScope.get("clearAlertIterator");
        LOGGER.finest("alertIterator: " + alertIterator);
                
                String id = utils.nullStrToSpc(JSFUtils.resolveExpressionAsBigDecimal("#{bindings.Id.inputValue}"));
        
        
        if (alertIterator.equals("XwrlResponseIndColumnsView1")) 
                {
                        if("ERROR".equals(execRequestLock()))
                        {
                                return;
                        }
        } 
                if (alertIterator.equals("XwrlResponseEntityColumnsView1")) 
                {
                        if("ERROR".equals(execRequestLock()))
                        {
                                return;
                        }
        } 
                
                
                        
                LOGGER.finest("alertShowPopup");
        FacesContext context = FacesContext.getCurrentInstance();
        UIComponent source = (UIComponent) event.getSource();
        //UIComponent alignSource = JSFUtils.findComponentInRoot("ph5");
        RichPopup comp = (RichPopup) JSFUtils.findComponentInRoot("p6");

        RichTable tab = (RichTable) JSFUtils.findComponentInRoot("t1");
        RowKeySet currentRks = tab.getSelectedRowKeys();
        
        if (currentRks.size() > 0) 
        {

            LOGGER.finest("comp: " + comp);
            String alignId = source.getClientId(context);
            LOGGER.finest("alignId: " + alignId);
            RichPopup.PopupHints hints = new RichPopup.PopupHints();
            //hints.add(RichPopup.PopupHints.HintTypes.HINT_ALIGN_ID, alignSource);
            hints.add(RichPopup.PopupHints.HintTypes.HINT_LAUNCH_ID, source);
            hints.add(RichPopup.PopupHints.HintTypes.HINT_ALIGN, RichPopup.PopupHints.AlignTypes.ALIGN_OVERLAP);
            comp.show(hints);
            
            
        } else {
            String msg = "Please select record(s) from the table.";
            FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_ERROR, msg.toString(), null);
            FacesContext.getCurrentInstance().addMessage(null, message);
        }
    }

    public void overrideValueChangeListener(ValueChangeEvent valueChangeEvent) {
        // Add event code here...
        LOGGER.finest("overrideValueChangeListener");
        LOGGER.finest("Old Value: " + valueChangeEvent.getOldValue());
        LOGGER.finest("New Value: " + valueChangeEvent.getNewValue());
        UIComponent comp = valueChangeEvent.getComponent();
        //T20200910.0014 - OWS - Note field issue in Group Notes (IRI)
        LOGGER.finest("CompId:"+comp.getId());
                String socId="";
                String itId="";
        if(comp.getId().endsWith("sbc1")){
            socId="socOvr1";
            itId="itOvr1";
        }else{
            socId="socOvr2";
            itId="itOvr2";
        }
        
        LOGGER.finest("socId:"+socId);
        LOGGER.finest("itId:"+itId);
        
        comp.processUpdates(FacesContext.getCurrentInstance());
        RichSelectManyChoice soc = (RichSelectManyChoice) JSFUtils.findComponentInRoot(socId);
        if(soc != null){
            soc.setValue(null);
            soc.setSubmittedValue(null);
        }
        RichInputText it = (RichInputText) JSFUtils.findComponentInRoot(itId);
        if(it != null){
            it.setValue(null);
            it.setSubmittedValue(null);
        }

        AdfFacesContext.getCurrentInstance().addPartialTarget(soc);
        AdfFacesContext.getCurrentInstance().addPartialTarget(it);
    }

    public void docShowPopup(ActionEvent actionEvent) {
        // Add event code here...
        LOGGER.finest("docShowPopup");
        FacesContext context = FacesContext.getCurrentInstance();
        UIComponent source = (UIComponent) actionEvent.getSource();
        UIComponent alignSource = JSFUtils.findComponentInRoot("ph2");
        RichPopup comp = (RichPopup) JSFUtils.findComponentInRoot("p2");
        LOGGER.finest("comp: " + comp);
        String alignId = source.getClientId(context);
        LOGGER.finest("alignId: " + alignId);
        RichPopup.PopupHints hints = new RichPopup.PopupHints();
        hints.add(RichPopup.PopupHints.HintTypes.HINT_ALIGN_ID, alignSource);
        hints.add(RichPopup.PopupHints.HintTypes.HINT_LAUNCH_ID, source);
        hints.add(RichPopup.PopupHints.HintTypes.HINT_ALIGN, RichPopup.PopupHints.AlignTypes.ALIGN_OVERLAP);
        comp.show(hints);
    }
    
    
    public void downloadCaseDocsFileListener(FacesContext facesContext, OutputStream outputStream) throws IOException {
        //Read file from particular path, path bind is binding of table field that contains path
        LOGGER.finest("downloadFileListener");
        
        
        UIComponent comp=facesContext.getViewRoot().getCurrentComponent(facesContext);
        Object id=comp.getAttributes().get("Id");
        LOGGER.finest("downloadFileListener:Id:"+id);

        String msg = "Download processing has started.";
        FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_INFO, msg.toString(), null);
        FacesContext.getCurrentInstance().addMessage(null, message);

        try {

            AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
            ViewObject vo=am.getXwrlCaseDocumentsView3();
            ViewCriteria vc=vo.getViewCriteriaManager().getViewCriteria("XwrlCaseDocumentsViewCriteria1");
            vc.ensureVariableManager().setVariableValue("p_id", id);
            vo.applyViewCriteria(vc);
            vo.executeQuery();
            LOGGER.finest("row count:"+vo.getRowCount());
            String documentFile=null;
                
            Row row=vo.first();
            documentFile = (String) row.getAttribute("DocumentFile");
            LOGGER.finest("downloadFileListener:documentFile:"+documentFile);
            
            LOGGER.finest("documentFile: " + documentFile);

            downloadFile(documentFile, outputStream);

            FacesContext context = FacesContext.getCurrentInstance();
            Iterator<FacesMessage> it = context.getMessages();
            while (it.hasNext()) {
                it.next();
                it.remove();
            }

            msg = "Download processing has completed.";
            message = new FacesMessage(FacesMessage.SEVERITY_INFO, msg.toString(), null);
            FacesContext.getCurrentInstance().addMessage(null, message);

        } catch (Exception e) {
            // TODO: Add catch code
            msg = "Download processing has failed.";
            message = new FacesMessage(FacesMessage.SEVERITY_ERROR, msg.toString(), null);
            FacesContext.getCurrentInstance().addMessage(null, message);
            e.printStackTrace();
        } finally {
            outputStream.close();
            outputStream.flush();
        }

    }

    public void downloadFileListener(FacesContext facesContext, OutputStream outputStream) throws IOException {
        //Read file from particular path, path bind is binding of table field that contains path
        LOGGER.finest("downloadFileListener");

        String msg = "Download processing has started.";
        FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_INFO, msg.toString(), null);
        FacesContext.getCurrentInstance().addMessage(null, message);

        try {
            ADFContext adfCtx = ADFContext.getCurrent();
            Map pageFlowScope = adfCtx.getPageFlowScope();
            String iterBinding = (String) pageFlowScope.get("iterBinding");
            LOGGER.finest("iterBinding: " + iterBinding);

            DCBindingContainer bc = ADFUtils.getDCBindingContainer();
            DCIteratorBinding iter = bc.findIteratorBinding(iterBinding);

            Row row = iter.getCurrentRow();
            String documentFile = (String) row.getAttribute("DocumentFile");
            LOGGER.finest("documentFile: " + documentFile);

            downloadFile(documentFile, outputStream);

            FacesContext context = FacesContext.getCurrentInstance();
            Iterator<FacesMessage> it = context.getMessages();
            while (it.hasNext()) {
                it.next();
                it.remove();
            }

            msg = "Download processing has completed.";
            message = new FacesMessage(FacesMessage.SEVERITY_INFO, msg.toString(), null);
            FacesContext.getCurrentInstance().addMessage(null, message);

        } catch (Exception e) {
            // TODO: Add catch code
            msg = "Download processing has failed.";
            message = new FacesMessage(FacesMessage.SEVERITY_ERROR, msg.toString(), null);
            FacesContext.getCurrentInstance().addMessage(null, message);
            e.printStackTrace();
        } finally {
            outputStream.close();
            outputStream.flush();
        }

    }

    private void downloadFile(String documentFile,OutputStream outputStream){
        try{
            File file = new File(documentFile);
            FileInputStream fis;
            byte[] b;

            fis = new FileInputStream(file);

            int n;
            while ((n = fis.available()) > 0) {
                b = new byte[n];
                int result = fis.read(b);
                outputStream.write(b, 0, b.length);
                if (result == -1)
                    break;
            }
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    private void refreshPage() {
        LOGGER.finest("refreshPage");
        FacesContext fc = FacesContext.getCurrentInstance();
        String refreshpage = fc.getViewRoot().getViewId();
        ViewHandler ViewH = fc.getApplication().getViewHandler();
        UIViewRoot UIV = ViewH.createView(fc, refreshpage);
        UIV.setViewId(refreshpage);
        fc.setViewRoot(UIV);
    }

    private void saveAsImage(String fileName, String imageFormat, InputStream inputStream) {
        LOGGER.finest("saveAsImage");
        LOGGER.finest("fileName: " + fileName);
        LOGGER.finest("imageFormat: " + imageFormat);

        try {
            File file = new File(fileName + "." + imageFormat);
            LOGGER.finest("file: " + file);
            //ImageIO.setUseCache(false);
            ImageIO.write(ImageIO.read(inputStream), imageFormat, file);
            LOGGER.finest("write");
        } catch (IOException exp) {
            LOGGER.finest("saveAsImage: " + exp.getMessage());
            exp.printStackTrace();
        }

    }

    private static void saveAsFile(String fileName, InputStream inputStream, String fileExtension) {
        LOGGER.finest("saveAsFile");
        LOGGER.finest("InputStream: " + inputStream);
        LOGGER.finest("fileExtension: " + fileExtension);
        try {
            OutputStream outputStream = new FileOutputStream(fileName + fileExtension);
            int read = 0;
            byte[] bytes = new byte[1024];
            while ((read = inputStream.read(bytes)) != -1) {
                outputStream.write(bytes, 0, read);
            }
            outputStream.close();
            outputStream.flush();
        } catch (Exception exp) {
            LOGGER.finest("Exception: " + exp.getMessage());
            exp.printStackTrace();
        }
    }
    
    
    public void notifyLegal(ActionEvent evt)
     {

          BindingContainer bc = null;
          OperationBinding op = null;
              RichTable tab = null;
           RowKeySet currentRks = null;

           tab = (RichTable) JSFUtils.findComponentInRoot("t1");
           currentRks = tab.getSelectedRowKeys();
           
               DCIteratorBinding tabIter = null; 
               ADFContext adfCtx = ADFContext.getCurrent();
               Map pageFlowScope = adfCtx.getPageFlowScope();
                   
    
               String alertIterator = (String) pageFlowScope.get("notifyIterator");
               LOGGER.finest("alertIterator: " + alertIterator);
               
               if (alertIterator.equals("XwrlResponseIndColumnsView1")) {
                   tabIter = ADFUtils.findIterator("XwrlResponseIndColumnsView1Iterator");
               } else if (alertIterator.equals("XwrlResponseEntityColumnsView1")) {
                   tabIter = ADFUtils.findIterator("XwrlResponseEntityColumnsView1Iterator");
               } else {
                   LOGGER.finest("alertIterator IS NOT FOUND");
               }
                           
                String id = utils.nullStrToSpc(JSFUtils.resolveExpressionAsBigDecimal("#{bindings.Id.inputValue}"));	   
                if (alertIterator.equals("XwrlResponseIndColumnsView1")) 
                {
                        if("ERROR".equals(execRequestLock()))
                        {
                                return;
                        }
                } 
                if (alertIterator.equals("XwrlResponseEntityColumnsView1")) 
                {
                        if("ERROR".equals(execRequestLock()))
                        {
                                return;
                        }
                } 
               
               LOGGER.finest("tabIter: " + tabIter.getVOName());
               

               RowSetIterator rsi = tabIter.getRowSetIterator();

           LOGGER.finest("Rec Count: " + currentRks.size());

           if (currentRks.size() > 0) 
            {
               for (Object selectedRowKey : currentRks) 
                {
                
                Key key = (Key) ((List) selectedRowKey).get(0);
                Row row = rsi.getRow(key);
                
                    if("Open".equalsIgnoreCase(utils.nullStrToSpc(row.getAttribute("Stateattr"))))
                    {
                    row.setAttribute("LegalReview","Y");
                     LOGGER.finest("Value set to Y");
                    }
                }
                                   
               bc = ADFUtils.getBindingContainer();
               op = bc.getOperationBinding("Commit");
               op.execute();
               
                    tabIter.executeQuery();
                    AdfFacesContext.getCurrentInstance().addPartialTarget(tab);
                   
                }
           }
    
            public void unlockRequestLock() 
            {
                AppModuleImpl am = null;
                String id = "";
                BindingContainer bc = null;
                OperationBinding op = null;
                
                String requestId = "";
                           DCIteratorBinding tabIter = null;
                           Row row = null;
                
                try {
            am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
            tabIter = ADFUtils.findIterator("XwrlRequestsView1Iterator");
                       row = tabIter.getCurrentRow();
                       requestId = utils.nullStrToSpc(row.getAttribute("Id"));
                    
            LOGGER.finest("reqId in unlock::"+ requestId);        

            am.getRequestLockInfoView1().setNamedWhereClauseParam("pRequestId", requestId);
            am.getRequestLockInfoView1().executeQuery();
                    
            Row[] rows =  am.getRequestLockInfoView1().getAllRowsInRange();
            if(rows!=null && rows.length>0) 
            {
                row = rows[0];
                LOGGER.finest(" id unlock: " +utils.nullStrToSpc(row.getAttribute("Id")));
                row.remove();
                
                bc = ADFUtils.getBindingContainer();
                op = bc.getOperationBinding("Commit");
                op.execute();
                
                utils.displaySuccessMessage("Lock released successfully");
            }

        } catch (Exception e) {
            // TODO: Add catch code
            e.printStackTrace();
            utils.displaySuccessMessage("Error while releasing the lock "+e);
        }
                
            }
    
         public String execRequestLock() 
         {
             String status = "";
             AppModuleImpl am = null;
             String id = "";
             int reqId= 0;
             Integer userId = 0;
             String errmsg = "";
             String requestId = "";
                         DCIteratorBinding tabIter = null;
                         Row row = null;
             
             try
             {
                 tabIter = ADFUtils.findIterator("XwrlRequestsView1Iterator");
                            row = tabIter.getCurrentRow();
                            requestId = utils.nullStrToSpc(row.getAttribute("Id"));
                 reqId = Integer.parseInt(requestId);
                 
              userId = (Integer) ADFContext.getCurrent().getSessionScope().get("UserId");
                 
                 LOGGER.finest("reqId and userid  in request lock::"+ reqId + " "+ userId);
              
              am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
              HashMap map = am.owsRequestlock(userId,reqId);
              status = nullStrToSpc(map.get("status"));
              errmsg = nullStrToSpc(map.get("errMsg"));
              
            
                  if("RECORD LOCKED".equalsIgnoreCase(errmsg))  
                  {
                      try
                        {
                      FacesContext fctx = FacesContext.getCurrentInstance();
                         ExternalContext ectx = fctx.getExternalContext();
                        ControllerContext controllerCtx = null;
                        controllerCtx = ControllerContext.getInstance();
                        String activityURL = controllerCtx.getGlobalViewActivityURL("Error");
                      
                             //ectx.getRequestParameterMap().put("errMsg",err);
                             ectx.redirect(activityURL);
                            // ectx.getRequestParameterMap().put("errMsg",err);
                             
                           
                          
                      } catch (IOException e) 
                      {
                             e.printStackTrace();
                      }
                  }
                  else
                  {
                      if("SUCCESS".equalsIgnoreCase(status)) 
                      {
                         LOGGER.finest("Success");
                         // utils.displaySuccessMessage(nullStrToSpc(map.get("errMsg")));
                      }
                     else
                      {
                     utils.displayErrorMessage(nullStrToSpc(map.get("errMsg")));
                      }
                  }
              
              
             } catch (Exception nfe) {
              // TODO: Add catch code
              nfe.printStackTrace();
              utils.displayErrorMessage("Error while locking the record: "+ nfe);
             }
             
             return status;
             
         }
      
		   
		   public String execSelectForUpdate(String id, String action)
		   {
                       String status = "";
		       AppModuleImpl am = null;
		       //String id = "";
                       int reqId= 0;
                       
                    try 
                    {
                        
                        am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
                        HashMap map = am.callRecordLock(Types.VARCHAR, "rmi_ows_req_lock_row(?,?)", new Object[] { id }, action);
                        status = nullStrToSpc(map.get("status"));
                        
                       // if(!"SUCCESS".equalsIgnoreCase(status)) 
                        {
                            if("RESOURCE BUSY".equalsIgnoreCase(status))  
                            {
                                try
                                  {
                                FacesContext fctx = FacesContext.getCurrentInstance();
                                   ExternalContext ectx = fctx.getExternalContext();
                                  ControllerContext controllerCtx = null;
                                  controllerCtx = ControllerContext.getInstance();
                                  String activityURL = controllerCtx.getGlobalViewActivityURL("Error");
                                
                                       //ectx.getRequestParameterMap().put("errMsg",err);
                                       ectx.redirect(activityURL);
                                      // ectx.getRequestParameterMap().put("errMsg",err);
                                       
                                     
                                    
                                } catch (IOException e) 
                                {
                                       e.printStackTrace();
                                }
                            }
                            else
                            {
                                if("SUCCESS".equalsIgnoreCase(status)) 
                                {
                                   LOGGER.finest("Success");
                                   // utils.displaySuccessMessage(nullStrToSpc(map.get("errMsg")));
                                }
                               else
                                {
                               utils.displayErrorMessage(nullStrToSpc(map.get("errMsg")));
                                }
                            }
                        }
                        
                    } catch (Exception nfe) {
                        // TODO: Add catch code
                        nfe.printStackTrace();
                        utils.displayErrorMessage("Error while locking the record: "+ nfe);
                    }
                    
                   return status;
				 
		   }
                   
                   public void refreshIndColumns() 
                   {
                        BigDecimal id = null;
                        
                        DCIteratorBinding indIter = ADFUtils.findIterator("XwrlResponseIndColumnsView1Iterator");
                        indIter.executeQuery();
						
						calIndRecordStateCount();
                        
                        
                      //  RowSetIterator rsi = indIter.getRowSetIterator();
                        Row currentRow = indIter.getCurrentRow();
                        id = (BigDecimal) currentRow.getAttribute("Id");
                        LOGGER.finest("Id::"+ id);
                        LOGGER.finest("Irec numberd::"+ (BigDecimal)currentRow.getAttribute("Rec"));
                        Key key = new Key(new Object[] { id });
                      //  Row row = rsi.findByKey(key, 1)[0];
                      // rsi.setCurrentRow(row);
                       indIter.setCurrentRowWithKey(key.toStringFormat(true));
                       // indIter.setCurrentRowWithKeyValue(utils.nullStrToSpc(id));
                        
                       ArrayList tableRowKey = new ArrayList();
                       tableRowKey.add(key);
                       
                       
                       RowKeySet rks = new RowKeySetImpl();
                       rks.add(tableRowKey);
                       
                        RichTable tab = (RichTable) JSFUtils.findComponentInRoot("t1");
                        tab.setSelectedRowKeys(rks);
                     //  tab.setScrollTop(10);
                        utils.refreshComponent(tab);
                        
                       
                   }
                   
    public void refreshEntColumns() 
    {
        BigDecimal id = null;
		
        DCIteratorBinding entIter = ADFUtils.findIterator("XwrlResponseEntityColumnsView1Iterator");
        entIter.executeQuery();
                        
        calEntRecordStateCount();

        Row currentRow = entIter.getCurrentRow();
        id = (BigDecimal) currentRow.getAttribute("Id");
        LOGGER.finest("Id::"+ id);
        LOGGER.finest("erec numberd::"+ (BigDecimal)currentRow.getAttribute("Rec"));
        Key key = new Key(new Object[] { id });
        entIter.setCurrentRowWithKey(key.toStringFormat(true));
        
        ArrayList tableRowKey = new ArrayList();
        tableRowKey.add(key);
        
        RowKeySet rks = new RowKeySetImpl();
        rks.add(tableRowKey);
        
        RichTable tab = (RichTable) JSFUtils.findComponentInRoot("t1");
        tab.setSelectedRowKeys(rks);

        utils.refreshComponent(tab);
		
        
    }
    
    public void calIndRecordStateCount() 
    {
        AppModuleImpl am = null;
        String state = "";
        int openCount = 0;
        int positiveCount = 0;
        int possibleCount = 0;
        int falsePositivecnt = 0;
        Map map = null;
        DCIteratorBinding indIter = null;
        RowSetIterator rsi = null;
	 
        try {
             indIter = ADFUtils.findIterator("XwrlResponseIndColumnsView1Iterator");
            if (indIter != null) {
                 rsi = indIter.getViewObject().createRowSetIterator(null);
                 
                while (rsi.hasNext()) {
                    Row row = rsi.next();
                    state = nullStrToSpc(row.getAttribute("Stateattr"));

                    if (!"".equals(state) && "Open".equalsIgnoreCase(state)) {
                        openCount++;
                    }
                    if (!"".equals(state) && "Possible".equalsIgnoreCase(state)) {
                        possibleCount++;
                    }
                    if (!"".equals(state) && "Positive".equalsIgnoreCase(state)) {
                        positiveCount++;
                    }
                    if (!"".equals(state) && "False Positive".equalsIgnoreCase(state)) {
                        falsePositivecnt++;
                    }
                }

                rsi.closeRowSetIterator();

                LOGGER.finest("IndOpCnt " + openCount);
                LOGGER.finest("IndPosCnt " + positiveCount);
                LOGGER.finest("IndPossCnt " + possibleCount);
                LOGGER.finest("IndFpCnt " + falsePositivecnt);

                map = ADFContext.getCurrent().getPageFlowScope();
                map.put("IndOpCnt", openCount);
                map.put("IndPosCnt", positiveCount);
                map.put("IndPossCnt", possibleCount);
                map.put("IndFpCnt", falsePositivecnt);
            }
        } catch (Exception e) {
            // TODO: Add catch code
            e.printStackTrace();
        }
        
    }
    
    public void calEntRecordStateCount() 
    {
        AppModuleImpl am = null;
        String state = "";
        int openCount = 0;
        int positiveCount = 0;
        int possibleCount = 0;
        int falsePositivecnt = 0;
        Map map = null;
        DCIteratorBinding entIter = null;
        RowSetIterator rsi = null;


        try {
            
            entIter = ADFUtils.findIterator("XwrlResponseEntityColumnsView1Iterator");
            if (entIter != null) {
                 rsi = entIter.getViewObject().createRowSetIterator(null);

                while (rsi.hasNext()) {
                    Row row = rsi.next();
                    state = nullStrToSpc(row.getAttribute("Stateattr"));

                    if (!"".equals(state) && "Open".equalsIgnoreCase(state)) {
                        openCount++;
                    }
                    if (!"".equals(state) && "Possible".equalsIgnoreCase(state)) {
                        possibleCount++;
                    }
                    if (!"".equals(state) && "Positive".equalsIgnoreCase(state)) {
                        positiveCount++;
                    }
                    if (!"".equals(state) && "False Positive".equalsIgnoreCase(state)) {
                        falsePositivecnt++;
                    }
                }

                rsi.closeRowSetIterator();

                LOGGER.finest("EntOpCnt " + openCount);
                LOGGER.finest("EntPosCnt " + positiveCount);
                LOGGER.finest("EntPossCnt " + possibleCount);
                LOGGER.finest("EntFpCnt " + falsePositivecnt);

                map = ADFContext.getCurrent().getPageFlowScope();
                map.put("EntOpCnt", openCount);
                map.put("EntPosCnt", positiveCount);
                map.put("EntPossCnt", possibleCount);
                map.put("EntFpCnt", falsePositivecnt);
            }
        } catch (Exception e) {
            // TODO: Add catch code
            e.printStackTrace();
        }
        
    }
    //T20210127.0035 - Legacy Vettings
    private String legacy = "No";

    public void setLegacy(String legacy) {
        this.legacy = legacy;
    }
    
    public String getLegacy() {
        try {
            legacy = "No";
            BigDecimal aliasId = null, masterId = null, xrefId = null;

            if (JSFUtils.resolveExpressionAsBigDecimal("#{bindings.AliasId.inputValue}") != null)
                aliasId = JSFUtils.resolveExpressionAsBigDecimal("#{bindings.AliasId.inputValue}");
            if (JSFUtils.resolveExpressionAsBigDecimal("#{bindings.MasterId.inputValue}") != null)
                masterId = JSFUtils.resolveExpressionAsBigDecimal("#{bindings.MasterId.inputValue}");
            if (JSFUtils.resolveExpressionAsBigDecimal("#{bindings.XrefId.inputValue}") != null)
                xrefId = JSFUtils.resolveExpressionAsBigDecimal("#{bindings.XrefId.inputValue}");

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

            ResultSet rs =
                utils.getPlSqlFunctionData("select 'Yes' from xwrl_party_master where id=rmi_ows_common_util.get_master_id(?,?,?)\n" +
                                           "AND LEGACY_VETTING_FLAG = 'Yes'",
                                           params);
            if (rs.next()) {
                legacy = "Yes";
            }
            rs.close();


        } catch (Exception e) {
            e.printStackTrace();
        }
        return legacy;
    }
    //T20210401.0015 - possible matches with approved status
    private void approved(String itrName) {
        LOGGER.finest("approved start");
        UserRespAndSessionInfo userInfo;
        BindingContext context;
        DCBindingContainer container;
        DCIteratorBinding iterator;
        String superUser = "";
        int openCount = 0;
        int positiveCount = 0;
        int possibleCount = 0;
        int falsePositiveCount = 0;
        String approved = "N";
        try {
            userInfo = (UserRespAndSessionInfo) JSFUtils.getManagedBeanValue("sessionScope.UserRespAndSessionInfo");
            if (userInfo != null) {
                superUser = userInfo.getIsSuperUserOnly();
                System.out.println("superUser = " + superUser);
            }
            context = BindingContext.getCurrent();
            container = (DCBindingContainer) context.getCurrentBindingsEntry();
            iterator = container.findIteratorBinding(itrName);
            RowSetIterator rowSetIterator;
            if (iterator != null) {
                rowSetIterator = iterator.getViewObject().createRowSetIterator(null);
                Row row;
                String state;
                while (rowSetIterator.hasNext()) {
                     row = rowSetIterator.next();
                     state = nullStrToSpc(row.getAttribute("Stateattr"));
                    if (!"".equals(state) && "Open".equalsIgnoreCase(state)) {
                        openCount++;
                    }
                    if (!"".equals(state) && "Possible".equalsIgnoreCase(state)) {
                        possibleCount++;
                    }
                    if (!"".equals(state) && "Positive".equalsIgnoreCase(state)) {
                        positiveCount++;
                    }
                    if (!"".equals(state) && "False Positive".equalsIgnoreCase(state)) {
                        falsePositiveCount++;
                    }
                }
                rowSetIterator.closeRowSetIterator();
            }
            System.out.println("open=" + openCount);
            System.out.println("positive=" + positiveCount);
            System.out.println("possible=" + possibleCount);
            System.out.println("falsePositive=" + falsePositiveCount);
            if (openCount > 0) {
                System.out.println("openCount greater than zero");
                approved = "N";
            } else if ("N".equals(superUser) || userInfo == null) {
                if (openCount == 0 && positiveCount == 0 && possibleCount == 0 && falsePositiveCount >= 0) {
                    System.out.println("all counts = 0 and falsePositiveCount >= 0");
                    approved = "Y";
                }
            } else if ("Y".equals(superUser)) {
                if (positiveCount >= 0 || possibleCount >= 0 || falsePositiveCount >= 0) {
                    System.out.println("super user condition");
                    approved = "Y";
                }
            } else {
                approved = "N";
            }
            Map map = ADFContext.getCurrent().getPageFlowScope();
            map.put("approved", approved);
        } catch (Exception e) {
            LOGGER.finest("Exception = " + e.getMessage());
        }
        LOGGER.finest("approved = " + approved);
        LOGGER.finest("approved end");
    }
    
    public void caseStateLaunchListener(LaunchPopupEvent launchPopupEvent) {
        // Add event code here...
        
        LOGGER.finest("caseStateLaunchListener");

        // T20221108.0024 - TC Role Based Access Control

        AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");                
        XwrlRequestsViewImpl vo = am.getXwrlRequestsView1();
        XwrlRequestsViewRowImpl row = (XwrlRequestsViewRowImpl) vo.getCurrentRow();
        Map sessionMap = ADFContext.getCurrent().getSessionScope();
        
        Integer userId = (Integer) sessionMap.get("UserId");
        String req = utils.nullStrToSpc(row.getAttribute("Id"));
        String dept = utils.nullStrToSpc(row.getAttribute("Department"));
        String cls = " rmi_tc_roles_pkg.is_tc_action_allowed(" + userId + "," + req + ",ID,OPTIONKEY,'" + dept + "') = 'Y'";

        row.getCaseStateLOV1().getViewObject().setWhereClause(cls);
        row.getCaseStateLOV1().executeQuery();        
        
    }

    public void caseStateReturnListener(ReturnPopupEvent returnPopupEvent) {
        // Add event code here...
        
        LOGGER.finest("caseStateReturnListener");
        
        // T20221108.0024 - TC Role Based Access Control

        AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");                
        XwrlRequestsViewImpl vo = am.getXwrlRequestsView1();
        XwrlRequestsViewRowImpl row = (XwrlRequestsViewRowImpl) vo.getCurrentRow();
        
        row.getCaseStateLOV1().getViewObject().setWhereClause(null);
        row.getCaseStateLOV1().executeQuery(); 
    }          
    
    public void caseStateDataListener(ReturnPopupDataEvent returnPopupDataEvent) {
        // Add event code here...
        
        LOGGER.finest("caseStateDataListener");
        
        /*
        AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");                
        XwrlRequestsViewImpl vo = am.getXwrlRequestsView1();
        XwrlRequestsViewRowImpl row = (XwrlRequestsViewRowImpl) vo.getCurrentRow();
        
        row.getCaseStateLOV1().getViewObject().setWhereClause(null);
        row.getCaseStateLOV1().executeQuery(); 
        */
        
    }    

    public void caseWorkflowLaunchListener(LaunchPopupEvent launchPopupEvent) {
        // Add event code here...

        LOGGER.finest("caseWorkflowLaunchListener");

        // T20221108.0024 - TC Role Based Access Control

        AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");                
        XwrlRequestsViewImpl vo = am.getXwrlRequestsView1();
        XwrlRequestsViewRowImpl row = (XwrlRequestsViewRowImpl) vo.getCurrentRow();
        Map sessionMap = ADFContext.getCurrent().getSessionScope();
        
        Integer userId = (Integer) sessionMap.get("UserId");
        String req = utils.nullStrToSpc(row.getAttribute("Id"));
        String dept = utils.nullStrToSpc(row.getAttribute("Department"));
        String cls = " rmi_tc_roles_pkg.is_tc_action_allowed(" + userId + "," + req + ",ID,OPTIONKEY,'" + dept + "') = 'Y'";

        row.getCaseWorkflowLOV1().getViewObject().setWhereClause(cls);
        row.getCaseWorkflowLOV1().executeQuery();        
        
    }

    public void caseWorkflowReturnListener(ReturnPopupEvent returnPopupEvent) {
        // Add event code here...
        
        LOGGER.finest("caseWorkflowReturnListener");
        
        // T20221108.0024 - TC Role Based Access Control

        AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");                
        XwrlRequestsViewImpl vo = am.getXwrlRequestsView1();
        XwrlRequestsViewRowImpl row = (XwrlRequestsViewRowImpl) vo.getCurrentRow();
        
        row.getCaseWorkflowLOV1().getViewObject().setWhereClause(null);
        row.getCaseWorkflowLOV1().executeQuery(); 
    }    
    
    public void caseWorkflowDataListener(ReturnPopupDataEvent returnPopupDataEvent) {
        // Add event code here...
        
        LOGGER.finest("caseWorkflowDataListener");
        
        /*
        AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");                
        XwrlRequestsViewImpl vo = am.getXwrlRequestsView1();
        XwrlRequestsViewRowImpl row = (XwrlRequestsViewRowImpl) vo.getCurrentRow();
        
        row.getCaseStateLOV1().getViewObject().setWhereClause(null);
        row.getCaseStateLOV1().executeQuery(); 
        */
        
    }    
    
}
