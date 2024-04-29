package oracle.apps.xwrl.beans.backing;

import com.rmi.manualtradecompliance.utils.ADFUtils;

import com.rmi.manualtradecompliance.utils.IRIUtils;
import com.rmi.manualtradecompliance.utils.JSFUtils;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import java.io.OutputStream;

import java.math.BigDecimal;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Timestamp;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import java.util.Random;

import javax.faces.application.FacesMessage;
import javax.faces.component.UIComponent;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;

import javax.faces.event.ActionEvent;

import oracle.adf.controller.ControllerContext;
import oracle.adf.model.binding.DCBindingContainer;
import oracle.adf.model.binding.DCIteratorBinding;
import oracle.adf.share.ADFContext;
import oracle.adf.share.logging.ADFLogger;
import oracle.adf.view.rich.component.rich.RichPopup;
import oracle.adf.view.rich.component.rich.data.RichTable;
import oracle.adf.view.rich.context.AdfFacesContext;
import oracle.adf.view.rich.event.DialogEvent;

import oracle.apps.xwrl.model.am.AppModuleImpl;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

import oracle.jbo.Key;
import oracle.jbo.Row;
import oracle.jbo.RowSetIterator;
import oracle.jbo.ViewCriteria;
import oracle.jbo.ViewObject;
import oracle.jbo.server.ViewObjectImpl;

import oracle.jdbc.OracleConnection;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.SystemUtils;
import org.apache.myfaces.trinidad.event.DisclosureEvent;
import org.apache.myfaces.trinidad.model.RowKeySet;

public class CaseDocuments {
    private static ADFLogger LOGGER = ADFLogger.createADFLogger(CaseDocuments.class);
    private IRIUtils utils = new IRIUtils();
    
    Random rand = new Random();
    private Integer randomVal = rand.nextInt(2000) + 1;

    public void setRandomVal(Integer randomVal) {
        this.randomVal = randomVal;
    }

    public Integer getRandomVal() {
        return randomVal;
    }
    
    public CaseDocuments() {
    }
    
    public void iriEdocsLinkingDisclosureListener(DisclosureEvent disclosureEvent) {
        // Add event code here...
        try{
            System.out.println("isExpanded::::::"+disclosureEvent.isExpanded());
            if(disclosureEvent.isExpanded()){                
                //T20201012.0026 - Linking E-Docs to Case Documents in OWS Statusboar... (IRI)
                Object sourceId=new BigDecimal(-1);
                if(JSFUtils.resolveExpressionAsBigDecimal("#{bindings.SourceId.inputValue}") != null)
                    sourceId=JSFUtils.resolveExpressionAsBigDecimal("#{bindings.SourceId.inputValue}");
                
                ViewObjectImpl iriEdocsVO =
                    (ViewObjectImpl) ADFUtils.findIterator("IriEdocsForCaseDocumentsRVO1Iterator").getViewObject();
                ViewCriteria vc=iriEdocsVO.getViewCriteriaManager().getViewCriteria("FilterIdentifierIriEdocsForCaseDocumentsRVOCriteria");
                vc.ensureVariableManager().setVariableValue("p_identifier",((BigDecimal)sourceId).toPlainString());
                iriEdocsVO.applyViewCriteria(vc);
                iriEdocsVO.executeQuery();
                System.out.println("IRIEdocs prepated");
            }
          }catch(Exception e){
            e.printStackTrace();
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
            System.out.println("iter1:"+iter1);
            Row row1 = iter1.getCurrentRow();
            System.out.println("row1:"+row1);
            String idVal=utils.nullStrToSpc(row1.getAttribute("CaseDocId"));
            System.out.println("row1 Id:"+idVal);
            
            AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
            
            //DCBindingContainer dcbc = ADFUtils.getDCBindingContainer();
            //DCIteratorBinding iter = dcbc.findIteratorBinding("XwrlCaseDocumentsView1Iterator");
            ViewObject vo = am.getXwrlCaseDocumentsView3();
            System.out.println("VO:"+vo);
            ViewCriteria vc=vo.getViewCriteriaManager().getViewCriteria("XwrlCaseDocumentsViewCriteria1");
            System.out.println("VC:"+vc);
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
    
    public void editDialogListener(DialogEvent dialogEvent) 
        {
        System.out.println("editDialogListener");
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
            System.out.println("outcome:"+dialogEvent.getOutcome().name());
            if (dialogEvent.getOutcome().name().equals("ok")) {
                
                
                
                //T20200611.0029 - RE: OWS - Note Xref (IRI)
                AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");

                DCIteratorBinding alertIterBinding = ADFUtils.findIterator(utils.nullStrToSpc(pageFlowScope.get("alertNoteIterBinding")));

                

                Row alertRow=alertIterBinding.getCurrentRow();
                Row requestRow=am.getXwrlRequestsView1().getCurrentRow();

                System.out.println("NoteId:"+alertRow.getAttribute("Id"));
                System.out.println("LineNumber:"+alertRow.getAttribute("LineNumber"));
                System.out.println("AlertId"+alertRow.getAttribute("AlertId"));

                ViewObject vo=am.getXwrlNoteXrefView1();
                
                ViewCriteria vc=vo.getViewCriteriaManager().getViewCriteria("XwrlNoteXrefViewCriteria");
                System.out.println("VC:"+vc);
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
                CallableStatement stmt = (java.sql.CallableStatement) am.getDBTransaction().createCallableStatement(sql, 0);
                Connection connection = stmt.getConnection();
                OracleConnection conn = connection.unwrap(OracleConnection.class);
                String note = utils.nullStrToSpc(JSFUtils.resolveExpressionAsString("#{bindings.Note.inputValue}"));
                System.out.println("Note:"+note);
                System.out.println("Request Id:"+requestRow.getAttribute("Id"));
                System.out.println("Alert Id:"+alertRow.getAttribute("AlertId"));
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
    
    public void deleteShowPopup(ActionEvent event) 
        {
        String iterBinding= utils.nullStrToSpc(event.getComponent().getAttributes().get("iterBinding"));
        ADFContext adfCtx = ADFContext.getCurrent();
        Map pageFlowScope = adfCtx.getPageFlowScope();
    
        pageFlowScope.put("alertNoteIterBinding",iterBinding);
        
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
    
    public String execRequestLock() 
    {
        String status = "";
        AppModuleImpl am = null;
        
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
         status = utils.nullStrToSpc(map.get("status"));
         errmsg = utils.nullStrToSpc(map.get("errMsg"));
         
       
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
                utils.displayErrorMessage(utils.nullStrToSpc(map.get("errMsg")));
                 }
             }
         
         
        } catch (Exception nfe) {
         // TODO: Add catch code
         nfe.printStackTrace();
         utils.displayErrorMessage("Error while locking the record: "+ nfe);
        }
        
        return status;
        
    }
    
    public void downloadCaseDocsFileListener(FacesContext facesContext, OutputStream outputStream) throws IOException {
        //Read file from particular path, path bind is binding of table field that contains path
        LOGGER.finest("downloadFileListener");
        
        
        UIComponent comp=facesContext.getViewRoot().getCurrentComponent(facesContext);
        Object id=comp.getAttributes().get("Id");
        System.out.println("downloadFileListener:Id:"+id);

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
            System.out.println("row count:"+vo.getRowCount());
            String documentFile=null;
                
            Row row=vo.first();
            documentFile = (String) row.getAttribute("DocumentFile");
            System.out.println("downloadFileListener:documentFile:"+documentFile);
            
            
            //Row row = iter.getCurrentRow();
            //String documentFile = (String) row.getAttribute("DocumentFile");
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
    
    //T20201012.0026 - Linking E-Docs to Case Documents in OWS Statusboar... (IRI)
    public void iriEdocsToCaseDocumentsActionListener(ActionEvent actionEvent) {
        // Add event code here...
        try{
            // Get selected rows from table
            RichTable tab = (RichTable) JSFUtils.findComponentInRoot("edocst1");
            RowKeySet currentRks = tab.getSelectedRowKeys();

            DCIteratorBinding detailBinding = ADFUtils.findIterator("XwrlCaseDocumentsView1Iterator");
            ViewObject detailVO=detailBinding.getViewObject();

            DCIteratorBinding tabIter=ADFUtils.findIterator("IriEdocsForCaseDocumentsRVO1Iterator");
            RowSetIterator rsi = tabIter.getRowSetIterator();
            if (currentRks.size() > 0) {
            System.out.println("Size:"+currentRks.size());
            List<String> errorMsgs=new ArrayList<String>();
            for (Object selectedRowKey : currentRks) {
                Key key = (Key) ((List) selectedRowKey).get(0);
                Row currentRow = rsi.getRow(key);
                Object edocId=currentRow.getAttribute("Id");
                Object docFile=currentRow.getAttribute("DiskPath");
                Object docName=currentRow.getAttribute("FileName");
                Object docType=currentRow.getAttribute("Description");
                Object refId=isEdocExists((BigDecimal)edocId);
                System.out.println("refId:"+refId);
                    if(refId != null){
                        errorMsgs.add("Edoc Id: "+edocId+" already existed in Case Documents with Case doc Id: "+refId);
                    }else{
                        Row createRow = detailVO.createRow();
                        System.out.println("New Doc ID:"+createRow.getAttribute("Id"));
                        createRow.setAttribute("DocumentFile", docFile);
                        createRow.setAttribute("EdocId", edocId);
                        createRow.setAttribute("DocumentName", docName);
                        createRow.setAttribute("FileName", docName);
                        createRow.setAttribute("Comment", "Created from IRI Edocs");
                        createRow.setAttribute("DocumentType",docType);
                        detailVO.insertRow(createRow);
                    }
                }
                if(currentRks.size() != errorMsgs.size()){
                    ADFUtils.findOperation("Commit").execute();
                    ADFUtils.findIterator("XwrlCaseDocumentsSumView1Iterator").executeQuery();
                    if(errorMsgs.size() == 0){
                        String msg = "Selected record(s) added to case documents";
                        FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_INFO, msg.toString(), null);
                        FacesContext.getCurrentInstance().addMessage(null, message);
                    }else{
                        StringBuilder strMsg = new StringBuilder("<html><body>");
                        strMsg.append("<p>Selected record(s) added to case documents, Except below record(s)</p>");
                        int index=1;
                        for(String msg:errorMsgs)
                            strMsg.append("<p>"+(index++)+". "+msg+"</p>");
                        strMsg.append("</body></html>");
                        FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_WARN, strMsg.toString(), null);
                        FacesContext.getCurrentInstance().addMessage(null, message);
                    }
                }else{
                    StringBuilder strMsg = new StringBuilder("<html><body>");
                    strMsg.append("<p>Selected record(s) already added to case documents.</p>");
                    int index=1;
                    for(String msg:errorMsgs)
                        strMsg.append("<p>"+(index++)+". "+msg+"</p>");
                    strMsg.append("</body></html>");
                    FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_ERROR, strMsg.toString(), null);
                    FacesContext.getCurrentInstance().addMessage(null, message);
                }
            }else {
                String msg = "Please select record(s) from the table.";
                FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_ERROR, msg.toString(), null);
                FacesContext.getCurrentInstance().addMessage(null, message);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    private Object isEdocExists(BigDecimal id){
        try{
            DCIteratorBinding binding = ADFUtils.findIterator("XwrlCaseDocumentsSumView1Iterator");
            ViewObject vo=binding.getViewObject();
            vo.reset();
            for(int i=0;i<vo.getRowCount();i++){
                Row row=vo.getRowAtRangeIndex(i);
                if(id.toPlainString().equals(((BigDecimal)row.getAttribute("EdocId")).toPlainString())){
                    return row.getAttribute("CaseDocId");
                }
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return null;
    }
    
    public void downloadIRIEdocsFileListener(FacesContext facesContext, OutputStream outputStream) throws IOException {
        //Read file from particular path, path bind is binding of table field that contains path
        LOGGER.finest("downloadFileListener");
        
        
        UIComponent comp=facesContext.getViewRoot().getCurrentComponent(facesContext);
        Object diskPath=comp.getAttributes().get("diskPath");
        System.out.println("downloadFileListener:diskPath:"+diskPath);

        String msg = "Download processing has started.";
        FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_INFO, msg.toString(), null);
        FacesContext.getCurrentInstance().addMessage(null, message);

        try {
            
            LOGGER.finest("documentFile: " + diskPath);

            downloadFile(diskPath.toString(), outputStream);

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
    
}
