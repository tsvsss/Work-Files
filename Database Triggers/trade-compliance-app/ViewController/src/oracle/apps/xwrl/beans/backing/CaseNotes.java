package oracle.apps.xwrl.beans.backing;

import com.rmi.manualtradecompliance.utils.ADFUtils;
import com.rmi.manualtradecompliance.utils.IRIUtils;
import com.rmi.manualtradecompliance.utils.JSFUtils;

import java.io.IOException;

import java.math.BigDecimal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.faces.component.UIComponent;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;

import oracle.adf.controller.ControllerContext;
import oracle.adf.model.binding.DCIteratorBinding;
import oracle.adf.share.ADFContext;
import oracle.adf.share.logging.ADFLogger;
import oracle.adf.view.rich.component.rich.RichPopup;
import oracle.adf.view.rich.component.rich.data.RichTable;
import oracle.adf.view.rich.component.rich.input.RichInputText;
import oracle.adf.view.rich.component.rich.layout.RichPanelHeader;
import oracle.adf.view.rich.component.rich.nav.RichButton;
import oracle.adf.view.rich.component.rich.output.RichPanelCollection;
import oracle.adf.view.rich.context.AdfFacesContext;
import oracle.adf.view.rich.event.DialogEvent;
import oracle.adf.view.rich.event.PopupCanceledEvent;
import oracle.adf.view.rich.event.PopupFetchEvent;

import oracle.apps.xwrl.beans.session.UserRespAndSessionInfo;
import oracle.apps.xwrl.model.am.AppModuleImpl;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

import oracle.jbo.Key;
import oracle.jbo.Row;
import oracle.jbo.RowSetIterator;
import oracle.jbo.ViewCriteria;
import oracle.jbo.ViewObject;

import org.apache.myfaces.trinidad.event.SelectionEvent;
import org.apache.myfaces.trinidad.model.RowKeySet;
import org.apache.myfaces.trinidad.model.RowKeySetImpl;

public class CaseNotes {
    private static ADFLogger LOGGER = ADFLogger.createADFLogger(CaseNotes.class);
    IRIUtils utils = new IRIUtils();
    private RichPanelHeader caseNotesPanelHeaderObj;

    public CaseNotes() {
    }
    
    public void onLoad() {
        try {
            System.out.println("start:"+new Date());
            AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
            
            FacesContext fctx = FacesContext.getCurrentInstance();
            ExternalContext ectx = fctx.getExternalContext();
            Map m = ectx.getRequestParameterMap();
            
            am.executeRequestView(utils.nullStrToSpc(m.get("requestId")));
            
            ADFContext.getCurrent().getPageFlowScope().put("Type", m.get("path"));
            System.out.println("end:"+new Date());
        } catch(Exception e) {
            e.printStackTrace();
        }
        
    }
    
    public void initializeCaseNotes() {
        System.out.println("CaseNotes:onload");
        try{
            String masterId=null;
            String aliasId=null;
            String xrefId=null;
          
            AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
            Row r=am.getXwrlRequestsView1().getCurrentRow();
            Object masterIdObj=r.getAttribute("MasterId");
            Object aliasIdObj=r.getAttribute("AliasId");
            Object xrefIdObj=r.getAttribute("XrefId");
            if(masterIdObj != null)
                masterId=((BigDecimal)masterIdObj).intValue()+"";
            if(aliasIdObj != null)
                aliasId=((BigDecimal)aliasIdObj).intValue()+"";
            if(xrefIdObj != null)
            xrefId=((BigDecimal)xrefIdObj).intValue()+"";
            
            String sq = "select RMI_OWS_COMMON_UTIL.get_master_id(?,?,?) from dual";
            PreparedStatement st =  am.getDBTransaction().createPreparedStatement(sq, 0);
       
            System.out.println("masterId.intValue():"+masterId);
           System.out.println("aliasId.intValue():"+aliasId);
           System.out.println("xrefId.intValue():"+xrefId);
           st.setString(1, masterId);
           st.setString(2, aliasId);
           st.setString(3,xrefId);

           ResultSet rs=st.executeQuery();
           if(rs.next()){
               Object origMasterId=rs.getObject(1);
               System.out.println("getAllCaseNotes:origMasterId:"+origMasterId);
               ViewObject vo=am.getXwrlCaseNotesSumView1();
               ViewCriteria vc=vo.getViewCriteriaManager().getViewCriteria("XwrlCaseNotesSumViewCriteria1");
               vc.ensureVariableManager().setVariableValue("p_origMasterId", origMasterId);
               vo.applyViewCriteria(vc);
               vo.executeQuery();
               
               
           }
        
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public void setCaseNotesPanelHeaderObj(RichPanelHeader caseNotesPanelHeaderObj) {
        this.caseNotesPanelHeaderObj = caseNotesPanelHeaderObj;
    }

    public RichPanelHeader getCaseNotesPanelHeaderObj() {
        initializeCaseNotes();
        return caseNotesPanelHeaderObj;
    }
    
    
    public void editShowPopup(ActionEvent event) 
        {
       DCIteratorBinding tabIter = null;
                DCIteratorBinding tabIter2 = null;
                DCIteratorBinding tabIter3 = null;
                DCIteratorBinding tabIter4 = null;
                
                ADFContext adfCtx = ADFContext.getCurrent();
        Map pageFlowScope = adfCtx.getPageFlowScope();
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
      //  UIComponent alignSource = JSFUtils.findComponentInRoot("iasph");
        RichPopup comp = (RichPopup) JSFUtils.findComponentInRoot("iap1");
        LOGGER.finest("comp: " + comp);
        String alignId = source.getClientId(context);
        LOGGER.finest("alignId: " + alignId);
        RichPopup.PopupHints hints = new RichPopup.PopupHints();
      //  hints.add(RichPopup.PopupHints.HintTypes.HINT_ALIGN_ID, alignSource);
        hints.add(RichPopup.PopupHints.HintTypes.HINT_LAUNCH_ID, source);
        hints.add(RichPopup.PopupHints.HintTypes.HINT_ALIGN, RichPopup.PopupHints.AlignTypes.ALIGN_OVERLAP);
        comp.show(hints);
    }
    
    public void deleteShowPopup(ActionEvent event) 
        {
        String id = "";
                int cnt = 0;
                
                try
                {
                        id = utils.nullStrToSpc(JSFUtils.resolveExpressionAsBigDecimal("#{bindings.Id.inputValue}"));
                }catch(Exception e)
                {
                        
                }
                
                try
                {
                        id = utils.nullStrToSpc(JSFUtils.resolveExpressionAsBigDecimal("#{bindings.ReqId.inputValue}"));
                 }catch(Exception e)
                {
                        
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
       // UIComponent alignSource = JSFUtils.findComponentInRoot("iasph");
       // LOGGER.finest("alignSource: " + alignSource);
        RichPopup comp = (RichPopup) JSFUtils.findComponentInRoot("iap3");
                if(comp==null)
                {
                        comp = (RichPopup) JSFUtils.findComponentInRoot("p3");
                }
        LOGGER.finest("comp: " + comp);
        String alignId = source.getClientId(context);
        LOGGER.finest("alignId: " + alignId);
        RichPopup.PopupHints hints = new RichPopup.PopupHints();
     //   hints.add(RichPopup.PopupHints.HintTypes.HINT_ALIGN_ID, alignSource);
        hints.add(RichPopup.PopupHints.HintTypes.HINT_LAUNCH_ID, source);
        hints.add(RichPopup.PopupHints.HintTypes.HINT_ALIGN, RichPopup.PopupHints.AlignTypes.ALIGN_OVERLAP);
        comp.show(hints);
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
                   //id = utils.nullStrToSpc(JSFUtils.resolveExpressionAsBigDecimal("#{bindings.Id.inputValue}"));
                   //reqId= Integer.parseInt(id);
                   
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
                System.out.println("selection:id:"+id);
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
        if (popupFetchEvent.getLaunchSourceClientId().contains("iabadd")) {
            BindingContainer bc = ADFUtils.getBindingContainer();
            OperationBinding op = bc.getOperationBinding("CreateInsert");
            op.execute();
        }else if(popupFetchEvent.getLaunchSourceClientId().contains("iabedt")){
            AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
            ViewObject voSum=am.getXwrlCaseNotesSumView1();
            
            if(voSum.getCurrentRow()!=null)
           {
            String idVal= utils.nullStrToSpc(voSum.getCurrentRow().getAttribute("Id"));
            System.out.println("CaseNote:id:"+idVal);

           if(!"".equals(idVal))
           {
            DCIteratorBinding binding = ADFUtils.findIterator("XwrlCaseNotesView1Iterator");

            ViewObject vo = binding.getViewObject();
            ViewCriteria vc=vo.getViewCriteriaManager().getViewCriteria("XwrlCaseNotesViewCriteria1");
            vc.ensureVariableManager().setVariableValue("p_id", new BigDecimal(idVal));
            vo.applyViewCriteria(vc);
            vo.executeQuery();
            
            Row[] rows = vo.getAllRowsInRange();
            
            if(rows !=null && rows.length==0)
            {
                RichPopup comp = (RichPopup) JSFUtils.findComponentInRoot("iap3");
                if(comp==null)
                {
                  comp = (RichPopup) JSFUtils.findComponentInRoot("p3");
                }
                comp.hide();
            }
            }
           }
           else {
               RichPopup comp = (RichPopup) JSFUtils.findComponentInRoot("iap3");
               if(comp==null)
               {
                 comp = (RichPopup) JSFUtils.findComponentInRoot("p3");
               }
               comp.hide();
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
       // RichTable tab = (RichTable) JSFUtils.findComponentInRoot("iaat");
       // AdfFacesContext.getCurrentInstance().addPartialTarget(tab);
    }
    
    public void editDialogListener(DialogEvent dialogEvent) 
        {
        
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
            if (dialogEvent.getOutcome().name().equals("ok")) {
                
                BindingContainer bc = ADFUtils.getBindingContainer();
                OperationBinding op = bc.getOperationBinding("Commit");
                op.execute();
                
                LOGGER.finest("Commit");

            } else if (dialogEvent.getOutcome().name().equals("cancel")) {
                BindingContainer bc = ADFUtils.getBindingContainer();
                OperationBinding op = bc.getOperationBinding("Rollback");
                op.execute();
                LOGGER.finest("Rollback");
            }
               /*     
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
            BindingContainer bc = ADFUtils.getBindingContainer();
            OperationBinding op = bc.getOperationBinding("Execute1");
            op.execute();
        } catch (Exception e) {
            // TODO: Add catch code
            e.printStackTrace();
        }
                
            //  tabIter.getCurrentRow().refresh(Row.REFRESH_WITH_DB_FORGET_CHANGES);
            */
                    
               initializeCaseNotes(); // adding this for refreshing table 

            RichTable tab = (RichTable) JSFUtils.findComponentInRoot("t2");
            AdfFacesContext.getCurrentInstance().addPartialTarget(tab);
                    
            
        } catch (Exception e) {
            // TODO: Add catch code
            e.printStackTrace();
        }
        
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
      //  UIComponent alignSource = JSFUtils.findComponentInRoot("iasph");
        RichPopup comp = (RichPopup) JSFUtils.findComponentInRoot("iap2");
        LOGGER.finest("comp: " + comp);
        String alignId = source.getClientId(context);
        LOGGER.finest("alignId: " + alignId);
        RichPopup.PopupHints hints = new RichPopup.PopupHints();
      //  hints.add(RichPopup.PopupHints.HintTypes.HINT_ALIGN_ID, alignSource);
        hints.add(RichPopup.PopupHints.HintTypes.HINT_LAUNCH_ID, source);
        hints.add(RichPopup.PopupHints.HintTypes.HINT_ALIGN, RichPopup.PopupHints.AlignTypes.ALIGN_OVERLAP);
        comp.show(hints);
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

        try {
            RichTable tab = (RichTable) JSFUtils.findComponentInRoot("iaat");
            if (tab != null) {
                AdfFacesContext.getCurrentInstance().addPartialTarget(tab);
            }
        } catch (Exception e) {
            // TODO: Add catch code
            e.printStackTrace();
        }
    }
    
    public void deleteDialogListener(DialogEvent dialogEvent) {
        // Add event code here...
        LOGGER.finest("deleteDialogListener");
        LOGGER.finest("outcome: " + dialogEvent.getOutcome().name());
        BindingContainer bc = ADFUtils.getBindingContainer();
        if (dialogEvent.getOutcome().name().equals("ok")) {            
                AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
                ViewObject voSum=am.getXwrlCaseNotesSumView1();
                String idVal=voSum.getCurrentRow().getAttribute("Id").toString();
                System.out.println("CaseNote:id:"+idVal);
                
                ViewObject vo = am.getXwrlCaseNotesView3();
                System.out.println("VO:"+vo);
                ViewCriteria vc=vo.getViewCriteriaManager().getViewCriteria("XwrlCaseNotesViewCriteria1");
                    
                System.out.println("VC:"+vc);
                vc.ensureVariableManager().setVariableValue("p_id", new BigDecimal(idVal));
                vo.applyViewCriteria(vc);
                vo.executeQuery();
                if(vo.hasNext()){
                    Row row=vo.next();
                    row.remove();
                    System.out.println("row deleted");
                }
                
                
    //            OperationBinding op = bc.getOperationBinding("Delete");
    //            op.execute();
                LOGGER.finest("Delete");

            bc = ADFUtils.getBindingContainer();
            OperationBinding op = bc.getOperationBinding("Commit");
            op.execute();
            //T20200507.0012 - RE: OWS TC - duplicated case notes and case docs (IRI)
            //syncNotes();
        } else if (dialogEvent.getOutcome().name().equals("cancel")) {
            OperationBinding op = bc.getOperationBinding("Rollback");
            op.execute();
            LOGGER.finest("Rollback");
        }
        OperationBinding op = bc.getOperationBinding("Execute1");
        op.execute();
        RichTable tab = (RichTable) JSFUtils.findComponentInRoot("t2");
        AdfFacesContext.getCurrentInstance().addPartialTarget(tab);
        
        RichPanelCollection pc = (RichPanelCollection) JSFUtils.findComponentInRoot("iaspc1");
        AdfFacesContext.getCurrentInstance().addPartialTarget(pc);
        
                
        RichButton edt = (RichButton) JSFUtils.findComponentInRoot("iabedt");
        AdfFacesContext.getCurrentInstance().addPartialTarget(edt);
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
}
