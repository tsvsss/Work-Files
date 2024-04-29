package oracle.apps.xwrl.beans.upload;

/*import com.groupdocs.viewer.config.ViewerConfig;
import com.groupdocs.viewer.converter.options.ImageOptions;
import com.groupdocs.viewer.domain.image.PageImage;
import com.groupdocs.viewer.handler.ViewerImageHandler;*/

import com.rmi.manualtradecompliance.utils.ADFUtils;
import com.rmi.manualtradecompliance.utils.IRIUtils;
import com.rmi.manualtradecompliance.utils.JSFUtils;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;

import java.math.BigDecimal;

import java.sql.CallableStatement;
import java.sql.Types;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.el.ELContext;
import javax.el.ExpressionFactory;
import javax.el.ValueExpression;

import javax.faces.application.Application;
import javax.faces.application.FacesMessage;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;

import javax.imageio.ImageIO;

import oracle.adf.controller.ControllerContext;
import oracle.adf.model.binding.DCIteratorBinding;
import oracle.adf.share.ADFContext;
import oracle.adf.share.logging.ADFLogger;
import oracle.adf.view.rich.component.rich.layout.RichPanelBox;
import oracle.adf.view.rich.component.rich.layout.RichToolbar;
import oracle.adf.view.rich.component.rich.output.RichActiveOutputText;
import oracle.adf.view.rich.context.AdfFacesContext;

import oracle.apps.xwrl.beans.utils.UploadedFiles;
import oracle.apps.xwrl.model.am.AppModuleImpl;

import oracle.jbo.Row;
import oracle.jbo.ViewObject;
import oracle.jbo.server.DBTransaction;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.SystemUtils;
import org.apache.myfaces.trinidad.event.ReturnEvent;

//public class UploadModel extends ActiveCollectionModelDecorator {

public class UploadModel { 

    // Properties
    private static ADFLogger LOGGER = ADFLogger.createADFLogger(UploadModel.class);
    private String iterBinding;
    private String pageFlowId;
    private List fileItems;
    private AppModuleImpl am;
    private String filePath;
    private String licensePath;
    
    private List<DocumentRecord> documentList;
    
    public class DocumentRecord {
        public FileItem fileItem;
        public String licensePath;
        public String docDirName;
        public String docFileName;
        public String imageFileBase;
    }


   IRIUtils utils = new IRIUtils();
   

    public UploadModel() {
        super();
    }

/*
    @Override
    public ActiveDataModel getActiveDataModel() {
        // TODO Implement this method
        System.out.println("getActiveDataModel");
        return null;
    }

    @Override
    protected CollectionModel getCollectionModel() {
        // TODO Implement this method
        System.out.println("getCollectionModel");
        return null;
    }
*/
    // Public

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
         status = utils.nullStrToSpc(map.get("status"));
         
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
                utils.displayErrorMessage(utils.nullStrToSpc(map.get("errMsg")));
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

    
    public String execRequestLock() 
    {
        String status = "";
        AppModuleImpl am = null;
        String id = "";
        int reqId= 0;
        Integer userId = 0;
        String errmsg = "";
        
        try
        {
            am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
            ViewObject voMaster = am.getXwrlRequestsView1(); //Individual
         
         id = utils.nullStrToSpc(voMaster.getCurrentRow().getAttribute("Id"));
         reqId= Integer.parseInt(id);
            
         userId = (Integer) ADFContext.getCurrent().getSessionScope().get("UserId");
            LOGGER.finest("reqId and userid in upload request lock::"+ reqId + " "+ userId);
         
        
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

    public String uploadActionListener() 
	{
        // Add event code here...
        LOGGER.finest("UPLOADJOB - uploadActionListener");
        //showPageScopeMap();
        //createMap();
			
		AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
		 ViewObject voMaster = am.getXwrlRequestsView1(); 
            String id = utils.nullStrToSpc(voMaster.getCurrentRow().getAttribute("Id"));
		
		if("ERROR".equals(execRequestLock()))
			{
				return null;
			}
			
			

        ADFContext adfCtx = ADFContext.getCurrent();
        Map<String, Object> pageFlowScope = adfCtx.getPageFlowScope();
        iterBinding = (String) pageFlowScope.get("iterBinding");
        LOGGER.finest("iterBinding: " + iterBinding);
        pageFlowId = pageFlowScope.toString();
        pageFlowScope.put("pageFlowId", pageFlowId); // Value passed to UploadServlet

        Map<String, Object> sessionScopeMap = adfCtx.getSessionScope();
        sessionScopeMap.remove(pageFlowId + ".fileItems"); // Remove previous values before setting in UploadServlet
		
		if("Entity Case".equals(utils.nullStrToSpc(pageFlowScope.get("panelHeader"))))
			{
				return "UploadEnt";
			}
			else
			{
				 return "UploadInd";
			}

        //UploadActive uploadActive = this.getUploadActive();
        //uploadActive.setPageFlowId(pageFlowId);

     /*   RichToolbar parentComp = (RichToolbar) JSFUtils.findComponentInRoot("t2");
        System.out.println("parentComp: " + parentComp);

        String outputTextId = (String) pageFlowScope.get("outputTextId");

        RichActiveOutputText ot = (RichActiveOutputText) JSFUtils.findComponentInRoot(outputTextId);
        System.out.println("ot: " + ot);

        if (ot != null) {
            System.out.println("Remove");
            System.out.println("getChildCount: " + parentComp.getChildCount());
            //showPageScopeMap();
            parentComp.getChildren().remove(ot);
            AdfFacesContext.getCurrentInstance().addPartialTarget(parentComp);

        }  */

    }
    
    public void uploadReturnListener(ReturnEvent returnEvent) 
    {
        FacesContext facesCtx = FacesContext.getCurrentInstance();
        ExternalContext ectx = facesCtx.getExternalContext();
        LOGGER.finest("facesCtx: " + facesCtx);
        LOGGER.finest("ectx: " + ectx);
        //OS.isFamilyWindows() Note: this stopped working 10/16/2019
        //SystemUtils.IS_OS_WINDOWS
        LOGGER.finest("SystemUtils.IS_OS_WINDOWS: " + SystemUtils.IS_OS_WINDOWS);
        if (SystemUtils.IS_OS_WINDOWS) {
            filePath = ectx.getInitParameter("oracle.apps.xwrl.FILE_UPLOAD_WIN");
            licensePath = ectx.getInitParameter("GROUPDOCS_VIEWER_LICENSE_WIN");
        } else {
            filePath = ectx.getInitParameter("oracle.apps.xwrl.FILE_UPLOAD_LINUX");
            licensePath = ectx.getInitParameter("GROUPDOCS_VIEWER_LICENSE_LINUX");
        }

        LOGGER.finest("filePath: " + filePath);
        LOGGER.finest("licensePath: " + licensePath);

        am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
        LOGGER.finest("am: " + am);
        
        ADFContext adfCtx = ADFContext.getCurrent();
        Map<String, Object> pageFlowScope = adfCtx.getPageFlowScope();
        iterBinding = (String) pageFlowScope.get("iterBinding");
        LOGGER.finest("iterBinding: " + iterBinding);
        pageFlowId = (String) pageFlowScope.get("pageFlowId");
        LOGGER.finest("pageFlowId: " + pageFlowId);
        Map<String, Object> sessionScopeMap = adfCtx.getSessionScope(); // Must be called after setting pageFlowId
        fileItems = (List) sessionScopeMap.get(pageFlowId + ".fileItems");
        LOGGER.finest("fileItems: " + fileItems);
        
        UploadedFiles uFiles = (UploadedFiles) JSFUtils.getManagedBeanValue("UploadedFilesBean");
        System.out.println("uFiles:"+uFiles);
        fileItems =uFiles.getFilesList();
        System.out.println("uFiles fileItems: " + fileItems);
        
        DCIteratorBinding iter = null;
        
        try {
            
            createDatabaseRecords();
            
            iter = ADFUtils.findIterator(iterBinding);
            iter.executeQuery();
            am.getXwrlCaseDocumentsSumView1().executeQuery();
            utils.refreshPage();
            
            
            LOGGER.finest("database records created ");
            
            
        } catch (Exception exc) {
            LOGGER.finest("MyThread exceptioned out."+exc);
            exc.printStackTrace();
        }finally {
            if(fileItems!=null && fileItems.size()>0)
            {
                fileItems.clear();
            }
            
            JSFUtils.setManagedBeanValue("UploadedFilesBean.filesList", fileItems);
            System.out.println("FileItems:::"+fileItems);
        }
    }
    
    public void syncDocs(Integer requestId, Integer batchId) 
    {
        CallableStatement st = null;
        String sq = null;
        AppModuleImpl am = null;
       
     try 
     { 
            am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
            sq = "begin RMI_OWS_COMMON_UTIL.SYNC_ALIAS_DOCUMENTS(p_request_id => :1, p_batch_id=> :2); end;";
             st = (java.sql.CallableStatement) am.getDBTransaction().createCallableStatement(sq, 0);
    
            st.setInt(1, requestId);
            st.setInt(2, batchId);

            st.execute();
        } catch (Exception sqle) {
            // TODO: Add catch code
            sqle.printStackTrace();
            LOGGER.finest("Error while calling sync alias documents "+ sqle);
            
        }
    }
    
    private void createDatabaseRecords() {
        LOGGER.finest("createDatabaseRecords");

        LOGGER.finest("Document create database records - START");

        //showPageScopeMap();
        //showRequestScopeMap();
        //showMap();

        // Initialize variables
        ViewObject voMaster = null;
        ViewObject voDetail = null;
        String caseId = null;
        String alertId = null;
        String docDirName = null;
        String docFileName = null;
        String imageDirName = null;
        String imageFileBase = null;
        String imageFileName = null;
        String imageName = null;
        String imageSaveBase = null;
        File docDir = null;
        File imageDir = null;
        Row row = null;
        BigDecimal requestId = null;
        BigDecimal recId = null;
        String documentBaseName = null;
        String documentName = null;
        String fieldName = null;
        String fileName = null;
        String contentType = null;
        String fileExt = null;
        boolean isInMemory = false;
        long sizeInBytes = 0;

        String msg = null;
        FacesMessage message = null;
        
        Integer reqId = 0;
        Integer batchId = 0;

        /*
        msg = "Upload has started.";
        message = new FacesMessage(FacesMessage.SEVERITY_INFO, msg.toString(), null);
        FacesContext.getCurrentInstance().addMessage(null, message);
        */

        LOGGER.finest("Document create database records - Get GROUPDOC license");

        LOGGER.finest("filePath: " + filePath);
        LOGGER.finest("licensePath: " + licensePath);

        LOGGER.finest("Document Process - Create directory path");

        // Get Application Module
       am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");


        // Get Values and store iterator for RequestBacking bean (dialogReturnListener)
        if (iterBinding.equals("XwrlCaseDocumentsView1Iterator")) {
            LOGGER.finest("Iterator XwrlCaseDocumentsView1Iterator");
            voMaster = am.getXwrlRequestsView1(); //Individual
            voDetail = am.getXwrlCaseDocumentsView1(); //Individual Case
            caseId = (String) voMaster.getCurrentRow().getAttribute("CaseId");
            reqId = Integer.parseInt(utils.nullStrToSpc(voMaster.getCurrentRow().getAttribute("Id")));
            try {
                batchId = Integer.parseInt(utils.nullStrToSpc(voMaster.getCurrentRow().getAttribute("BatchId")));
            } catch (NumberFormatException nfe) {
                // TODO: Add catch code
                nfe.printStackTrace();
            }
        } else if (iterBinding.equals("XwrlAlertDocumentsView1Iterator")) {
            LOGGER.finest("Iterator XwrlAlertDocumentsView1Iterator");
            voMaster = am.getXwrlRequestsView1(); //Individual                    
            voDetail = am.getXwrlResponseIndColumnsView1(); //Individual Alert                                        
            caseId = (String) voMaster.getCurrentRow().getAttribute("CaseId");                
            alertId = (String) voDetail.getCurrentRow().getAttribute("Alertid");           
            voDetail = am.getXwrlAlertDocumentsView1(); // Used to create db record
        } else if (iterBinding.equals("XwrlCaseDocumentsView2Iterator")) {                    
            LOGGER.finest("Iterator XwrlCaseDocumentsView2Iterator");
            voMaster = am.getXwrlRequestsView1(); //Entity
            voDetail = am.getXwrlCaseDocumentsView2(); //Individual Case
            caseId = (String) voMaster.getCurrentRow().getAttribute("CaseId");
            reqId = Integer.parseInt(utils.nullStrToSpc(voMaster.getCurrentRow().getAttribute("Id")));
            try {
                batchId = Integer.parseInt(utils.nullStrToSpc(voMaster.getCurrentRow().getAttribute("BatchId")));
            } catch (NumberFormatException nfe) {
                // TODO: Add catch code
                nfe.printStackTrace();
            }
        } else if (iterBinding.equals("XwrlAlertDocumentsView2Iterator")) {
            LOGGER.finest("Iterator XwrlAlertDocumentsView2Iterator");
            voMaster = am.getXwrlRequestsView1(); //Entity                    
            voDetail = am.getXwrlResponseEntityColumnsView1(); //Entity Alert
            caseId = (String) voMaster.getCurrentRow().getAttribute("CaseId");
            alertId = (String) voDetail.getCurrentRow().getAttribute("Alertid");
            voDetail = am.getXwrlAlertDocumentsView2(); // Used to create db record
        }

        
        LOGGER.finest("CaseId: " + caseId);
        LOGGER.finest("AlertId: " + alertId);

        // Get Year
        Date date = new Date();
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        int year = calendar.get(Calendar.YEAR);

        LOGGER.finest("Document create database records - Create document file path");

        // Create Directory Path
        if (alertId != null) {
            docDirName = filePath + year + File.separator + caseId + File.separator + alertId;
        } else {
            docDirName = filePath + year + File.separator + caseId;
        }

        docDir = new File(docDirName);
        // Check if directory exists and create if needed
        if (!docDir.exists()) {
            docDir.mkdirs();
        }

        LOGGER.finest("Document create database records - Create directory image path");

        LOGGER.finest("directory: " + docDir);

        imageDirName = docDirName + File.separator + "Images";
        LOGGER.finest("imageDirName: " + imageDirName);

        imageDir = new File(imageDirName);
        if (!imageDir.exists()) {
            imageDir.mkdirs();
        }

        LOGGER.finest("Document create database records - Create database records");
        if (fileItems != null) {

            // CREATE DOCUMENT FILE ON THE SERVER

            try {
                // Process the uploaded file items
                Iterator i = fileItems.iterator();
                List<DocumentRecord> docList = new ArrayList<DocumentRecord>(); // Used to create list of documents

                while (i.hasNext()) {
                    FileItem fileItem = (FileItem) i.next();
                    if (!fileItem.isFormField()) {

                        // Initialize database record
                        row = voDetail.createRow();
                        voDetail.insertRow(row);
                        

                        // Set variables
                        fieldName = fileItem.getFieldName();
                        fileName = fileItem.getName();
                        contentType = fileItem.getContentType();
                        fileExt = FilenameUtils.getExtension(fileName);
                        isInMemory = fileItem.isInMemory();
                        sizeInBytes = fileItem.getSize();
                        requestId = (BigDecimal) voDetail.getCurrentRow().getAttribute("RequestId");
                        recId = (BigDecimal) voDetail.getCurrentRow().getAttribute("Id");
                        documentBaseName = "TradeDocument_" + requestId + "_" + recId;
                        documentName = documentBaseName + "." + fileExt;
                        docFileName = docDir + File.separator + documentName;

                        imageName = documentBaseName + ".png";
                        imageSaveBase = imageDir + File.separator + documentBaseName;
                        imageFileBase = imageDir + File.separator + documentBaseName;
                        imageFileName = imageFileBase + ".png";


                        LOGGER.finest("fileItem: " + fileItem); // Save for document files
                        LOGGER.finest("licensePath: " + licensePath); // Save for image files
                        LOGGER.finest("docDirName: " + docDirName); // Save for image files
                        LOGGER.finest("docFileName: " + docFileName); // Save for document and image files
                        LOGGER.finest("imageFileBase: " + imageFileBase); // Save for image files


                        // Set Database Record Attributes
                        LOGGER.finest("Set Database Record Attributes");
                        row.setAttribute("FileName", fileName);
                        row.setAttribute("FilePath", docDirName);
                        row.setAttribute("ContentType", contentType); // Used for download link
                        row.setAttribute("DocumentName", documentName);
                        row.setAttribute("DocumentFile", docFileName); // Used for preview link
                        row.setAttribute("ImageFile", imageFileName);
                        row.setAttribute("ImagePath", imageDirName);
                        row.setAttribute("ImageName", imageName);

                        UploadModel activeModel = new UploadModel();
                        UploadModel.DocumentRecord docRec = activeModel.new DocumentRecord(); // Used to create document record
                        docRec.fileItem = fileItem;
                        docRec.licensePath = licensePath;
                        docRec.docDirName = docDirName;
                        docRec.docFileName = docFileName;
                        docRec.imageFileBase = imageFileBase;
                        docList.add(docRec);

                       
                    }

                }

                DBTransaction txn = am.getDBTransaction(); // Commit database records
                txn.commit();

                
                
                voDetail.executeQuery(); //Not showing up in the page
                documentList = (List<UploadModel.DocumentRecord>) docList;
                //this.setDocumentList(docList);
                //voDetail.executeQuery();

                //pageFlowScope.put(pageFlowId + ".uploadStatus","Complete");
                
                createDocumentFiles(documentList);
                
                try 
                {
                    LOGGER.finest("reqId:: "+ reqId);
                    LOGGER.finest("batchId:: "+ batchId);
                    
                    //syncDocs(reqId, batchId);
                } catch (Exception e) {
                    // TODO: Add catch code
                    e.printStackTrace();
                    LOGGER.finest("Error calling sync docs in create database records method :"+ e);
                }

            } catch (Exception e) {
                //pageFlowScope.put(pageFlowId + ".uploadStatus","Failed");
                LOGGER.finest("Document create database records - ERROR");

                DBTransaction txn = am.getDBTransaction(); // Rollback database records
                txn.rollback();

                msg = "The Upload create database records failed.";
                message = new FacesMessage(FacesMessage.SEVERITY_ERROR, msg.toString(), null);
                FacesContext.getCurrentInstance().addMessage(null, message);
                e.printStackTrace();
            } finally {
                LOGGER.finest("Document create database records - FINISH");
            }

        }
    }

    private void createDocumentFiles(List<DocumentRecord> docList) {
        LOGGER.finest("createDocumentFiles");

        LOGGER.finest("Document create document files - START");

        //showPageScopeMap();
        //showRequestScopeMap();
        //showMap();

        // Initialize variables
        String docFileName = null;
        List fileItems = null;
        File file = null;
        String msg = null;
        FacesMessage message = null;

        // CREATE DOCUMENT FILE ON THE SERVER

        try {
            // Process the uploaded file items

            for (DocumentRecord docRec : docList) {

                // Create document file
                LOGGER.finest("Document create document files - write files");
                file = new File(docRec.docFileName);
                docRec.fileItem.write(file);

                

            }

        } catch (Exception e) {
            //pageFlowScope.put(pageFlowId + ".uploadStatus","Failed");
            LOGGER.finest("Document create document files - ERROR");

            msg = "The Upload create document file failed.";
            message = new FacesMessage(FacesMessage.SEVERITY_ERROR, msg.toString(), null);
            FacesContext.getCurrentInstance().addMessage(null, message);
            e.printStackTrace();
        } finally {
            LOGGER.finest("Document create document files - FINISH");
        }

    }

    public void uploadReturnListenerOld(ReturnEvent returnEvent) {
        // Add event code here...
        LOGGER.finest("uploadReturnListener");

        ADFContext adfCtx = ADFContext.getCurrent();
        Map<String, Object> sessionScopeMap = adfCtx.getSessionScope(); // Must be called after setting pageFlowId
        fileItems = (List) sessionScopeMap.get(pageFlowId + ".fileItems");

        if (fileItems != null) {
            Map<String, Object> pageFlowScope = adfCtx.getPageFlowScope();

            RichToolbar parentComp = (RichToolbar) JSFUtils.findComponentInRoot("t2");
            LOGGER.finest("parentComp: " + parentComp);

            String outputTextId = (String) pageFlowScope.get("outputTextId");

            RichActiveOutputText ot = (RichActiveOutputText) JSFUtils.findComponentInRoot(outputTextId);
            LOGGER.finest("ot: " + ot);

            LOGGER.finest("Add");
            AdfFacesContext.getCurrentInstance().addPartialTarget(parentComp);
            pageFlowScope.put("UploadActiveDataModel", null);
            ot = new RichActiveOutputText();
            ot.setId(outputTextId);
            ot.setInlineStyle("color:blue;font-size:18px;font-weight:bold;text-align:center;");
            ot.setValueExpression("value", getValueExpression("#{pageFlowScope.UploadActiveDataModel.state}"));
          // ot.setValue(uploadActiveDataModel.getState());
            LOGGER.finest("getChildCount: " + parentComp.getChildCount());
            parentComp.getChildren().add(ot);
            AdfFacesContext.getCurrentInstance().addPartialTarget(ot);        }

    }

    // Private
    private ValueExpression getValueExpression(String data) {
        FacesContext fc = FacesContext.getCurrentInstance();
        Application app = fc.getApplication();
        ExpressionFactory elFactory = app.getExpressionFactory();
        ELContext elContext = fc.getELContext();
        ValueExpression valueExp = elFactory.createValueExpression(elContext, data, Object.class);
        return valueExp;
    }
    
    
    private void createDocumentImages(ActionEvent evt) {
        LOGGER.finest("createDocumentImages");

        LOGGER.finest("Document create document image files - START");
        // Initialize variables

        String storagePath = null;
        InputStream imageStream = null;
        String msg = null;
        FacesMessage message = null;


        // CREATE IMAGE FILE ON THE SERVER
        try {

            DocumentRecord  docRec = new DocumentRecord();
                
           // docRec.fileItem = fileItem;
          //  docRec.licensePath = licensePath;
          //  docRec.docDirName = docDirName;
         //   docRec.docFileName = docFileName;
         //   docRec.imageFileBase = imageFileBase;

            //Long jobs = (Long) JSFUtils.getManagedBeanValue("viewScope.maxProgressModelVal");
            //System.out.println("jobs: "+jobs);

         //   for (DocumentRecord docRec : docList) 
           // {

                LOGGER.finest("Document create document image records - configure Group Docs Viewer");
                /*Removed groupdocs jar usage :: 17-May-2022
                com.groupdocs.viewer.licensing.License lic = new com.groupdocs.viewer.licensing.License();
                //Note: Make sure that this name matches license name
                LOGGER.finest("com.groupdocs.viewer.licensing.License: "+lic);
                
                lic.setLicense(licensePath + "GroupDocs.Viewer.lic");
                List<Integer> pg = new ArrayList<Integer>();
                pg.add(1);

                LOGGER.finest("ViewerConfig");
                ViewerConfig config = new ViewerConfig();
                config.setEnableCaching(false);
                
                LOGGER.finest("ViewerImageHandler");
                ViewerImageHandler imageHandler = new ViewerImageHandler(config);
                
                LOGGER.finest("ImageOptions");
                ImageOptions options = new ImageOptions();
                options.setPageNumber(1);
                options.setPageNumbersToRender(pg);
                options.setCountPagesToRender(1);
                // Excel Options
                options.getCellsOptions().setOnePagePerSheet(false);
                options.getCellsOptions().setCountRowsPerPage(50);

                // CREATE IMAGE FILE ON THE SERVER
                // Note: This slows down the upload process.  Check to see if this can be moved to dialogReturnListener
                //       in RequestBacking bean
                LOGGER.finest("Create Image");

                // Set variables
                storagePath = docRec.docDirName; // get from array
                config.setStoragePath(storagePath);

                // Create image file
                List<PageImage> pages;

                pages = imageHandler.getPages(docRec.docFileName, options); // get from array

                LOGGER.finest("pages: " + pages.size());
                LOGGER.finest("Create Image File");

                LOGGER.finest("Document create document image records - create document image files");
                for (PageImage page : pages) {
                    try {
                        imageStream = page.getStream();
                        saveAsImage(docRec.imageFileBase, "png", imageStream); // get from array
                        imageStream.close();
                    } catch (IOException e) {
                        // TODO: Add catch code
                        imageStream.close();
                        LOGGER.finest("Unable to create image file - ERROR");
                        e.printStackTrace();
                    }
                }*/


         //   }

        } catch (Exception e) {
            // TODO: Add catch code

            LOGGER.finest("Document create document image files - ERROR");
            msg = "The Upload create document file failed.";
            message = new FacesMessage(FacesMessage.SEVERITY_ERROR, msg.toString(), null);
            FacesContext.getCurrentInstance().addMessage(null, message);
            e.printStackTrace();
        } finally {
            LOGGER.finest("Document create document image files - FINISH");
        }

    }

    private void saveAsImage(String fileName, String imageFormat, InputStream inputStream) {
        LOGGER.finest("saveAsImage");
        LOGGER.finest("saveAsImage");
        LOGGER.finest("fileName: " + fileName);
        LOGGER.finest("imageFormat: " + imageFormat);

        try {
            File file = new File(fileName + "." + imageFormat);
            ImageIO.write(ImageIO.read(inputStream), imageFormat, file);
        } catch (IOException exp) {
            LOGGER.finest("saveAsImage: " + exp.getMessage());
            exp.printStackTrace();
        }

    }

    private void showPageScopeMap() {
        LOGGER.finest("showPageScopeMap");
        ADFContext adfCtx = ADFContext.getCurrent();
        Map<String, Object> map = adfCtx.getPageFlowScope();
        for (String key : map.keySet()) {
            LOGGER.finest("key: " + key);
            LOGGER.finest("value: " + map.get(key));
        }
    }

    // Test
    public void uploadActionTrialListener(ActionEvent actionEvent) {
        // Add event code here...
        LOGGER.finest("uploadActionListener");
        FacesContext fctx = FacesContext.getCurrentInstance();

        RichToolbar parentComp = (RichToolbar) JSFUtils.findComponentInRoot("t2");
        LOGGER.finest("parentComp: " + parentComp);

        ADFContext adfCtx = ADFContext.getCurrent();
        Map<String, Object> pageFlowScopeMap = adfCtx.getPageFlowScope();
        String outputTextId = (String) pageFlowScopeMap.get("outputTextId");

        RichActiveOutputText ot = (RichActiveOutputText) JSFUtils.findComponentInRoot(outputTextId);
        LOGGER.finest("ot: " + ot);

        if (ot != null) {
            LOGGER.finest("Remove");
            LOGGER.finest("getChildCount: " + parentComp.getChildCount());
            //showPageScopeMap();
            parentComp.getChildren().remove(ot);
            parentComp.processUpdates(fctx);
            AdfFacesContext.getCurrentInstance().addPartialTarget(parentComp);

        } else {
            LOGGER.finest("Add");
            AdfFacesContext.getCurrentInstance().addPartialTarget(parentComp);
            pageFlowScopeMap.put("UploadActiveDataModel", null);
            ot = new RichActiveOutputText();
            ot.setId(outputTextId);
            ot.setInlineStyle("color:blue;font-size:18px;font-weight:bold;text-align:center;");
            ot.setValueExpression("value", getValueExpression("#{pageFlowScope.UploadActiveDataModel.state}"));
            LOGGER.finest("getChildCount: " + parentComp.getChildCount());
            parentComp.getChildren().add(ot);
            AdfFacesContext.getCurrentInstance().addPartialTarget(ot);
        }
    }

    public void uploadActionTestListener(ActionEvent actionEvent) {
        LOGGER.finest("uploadActionTestListener");
        RichPanelBox comp = (RichPanelBox) JSFUtils.findComponentInRoot("pb1");
        RichActiveOutputText ot = (RichActiveOutputText) JSFUtils.findComponentInRoot("aot1");

        if (ot == null) {
            ADFContext adfCtx = ADFContext.getCurrent();
            Map<String, Object> pageFlowScopeMap = adfCtx.getPageFlowScope();
            //pageFlowScopeMap.put("UploadActiveDataModel",null);
            pageFlowScopeMap.remove("UploadActiveDataModel");
            ot = new RichActiveOutputText();
            ot.setId("aot1");
           ot.setValueExpression("value", getValueExpression("#{pageFlowScope.UploadActiveDataModel.state}"));
          // ot.setValue(uploadActiveDataModel.getState());
            ot.setVisible(true);
            comp.getChildren().add(ot);
            AdfFacesContext.getCurrentInstance().addPartialTarget(comp);
        } else {
            comp.getChildren().remove(ot);
            AdfFacesContext.getCurrentInstance().addPartialTarget(comp);
            //showPageScopeMap();

        }
    }    

}
