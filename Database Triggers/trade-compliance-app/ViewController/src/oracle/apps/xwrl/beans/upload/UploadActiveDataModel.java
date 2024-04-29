package oracle.apps.xwrl.beans.upload;

/*import com.groupdocs.viewer.config.ViewerConfig;
import com.groupdocs.viewer.converter.options.ImageOptions;
import com.groupdocs.viewer.domain.image.PageImage;
import com.groupdocs.viewer.handler.ViewerImageHandler;*/

import com.rmi.manualtradecompliance.utils.ADFUtils;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;

import java.math.BigDecimal;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

import javax.annotation.PostConstruct;

import javax.faces.application.FacesMessage;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;

import javax.imageio.ImageIO;

import oracle.adf.share.ADFContext;
import oracle.adf.share.logging.ADFLogger;
import oracle.adf.view.rich.activedata.ActiveModelContext;
import oracle.adf.view.rich.activedata.BaseActiveDataModel;
import oracle.adf.view.rich.event.ActiveDataUpdateEvent;

import oracle.apps.xwrl.model.am.AppModuleImpl;

import oracle.jbo.Row;
import oracle.jbo.ViewObject;
import oracle.jbo.server.DBTransaction;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.SystemUtils;

public class UploadActiveDataModel extends BaseActiveDataModel{

    // Properties
    private static ADFLogger LOGGER = ADFLogger.createADFLogger(UploadActiveDataModel.class);

    private final AtomicInteger listenerCount = new AtomicInteger(0);
    private final AtomicInteger currentEventCount = new AtomicInteger();
    private String state = "Ready for Upload";    

    private List<DocumentRecord> documentList;
    private String iterBinding;
    private String pageFlowId;
    private List fileItems;
    private AppModuleImpl am;
    private String filePath;
    private String licensePath;
    private double originalNumItems;
    private double newNumItems;
    
    // Classes
    public class DocumentRecord {
        public FileItem fileItem;
        public String licensePath;
        public String docDirName;
        public String docFileName;
        public String imageFileBase;
    }
    
    
    public UploadActiveDataModel() 
    {
       super();
    }

    @Override
    protected void startActiveData(Collection<Object> collection, int i) {
        // TODO Implement this method
        LOGGER.fine("startActiveData");
        listenerCount.incrementAndGet();
        currentEventCount.set(0);
        this.runJob(); 
    }

    @Override
    protected void stopActiveData(Collection<Object> collection) {
        // TODO Implement this method
      //  LOGGER.fine("stopActiveData");
        listenerCount.decrementAndGet(); 
    }

    @Override
    public int getCurrentChangeCount() {
        // TODO Implement this method
        LOGGER.fine("getCurrentChangeCount");
        //return 0;
        return currentEventCount.get();
    }
    
    // Public
    @PostConstruct
    public void setupActiveData() {
        LOGGER.fine("setupActiveData");

        ActiveModelContext context = ActiveModelContext.getActiveModelContext();
        LOGGER.finest("getCurrentActiveComponent: "+context.getCurrentActiveComponent());
        LOGGER.finest("isComponentInterestedInActiveData: "+context.isComponentInterestedInActiveData());
        Object[] keyPath = new String[0];
        context.addActiveModelInfo(this, keyPath, "state");
       
    }
    
    public void bumpChangeCount() {
        LOGGER.fine("bumpChangeCount");
        currentEventCount.incrementAndGet();
    }
    
    public void bumpChangeCount(Integer count) {
        LOGGER.fine("bumpChangeCount");
        Integer newCount = currentEventCount.get() + count;
        currentEventCount.set(newCount);
    }

    public void dataChanged(ActiveDataUpdateEvent event) {
        LOGGER.fine("dataChanged");
        fireActiveDataUpdate(event);
    }

    public void setState(String state) {
        LOGGER.fine("setState");
        this.state = state;
    }

    public String getState() {
        LOGGER.fine("getState");
        return state;
    }
    
    public void runJob (){
        LOGGER.fine("runJob");
        
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

        newNumItems = 0;
        originalNumItems = 0;
        originalNumItems = fileItems.size() * 3;        
        
        Runnable dataChanger = new Runnable() {
            public void run() {
                LOGGER.finest("thread starting.");
                try {
                    LOGGER.finest("thread running");
                    this.createDatabaseRecords();
                    this.createDocumentFiles(documentList);
                    this.createDocumentImages(documentList);
                } catch (Exception exc) {
                    LOGGER.finest("MyThread exceptioned out.");
                }
                LOGGER.finest("thread terminating.");                

            }

            
            // Private Methods

            private void createDatabaseRecords() {
                LOGGER.fine("createDatabaseRecords");

                LOGGER.fine("Document create database records - START");

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

                /*
                msg = "Upload has started.";
                message = new FacesMessage(FacesMessage.SEVERITY_INFO, msg.toString(), null);
                FacesContext.getCurrentInstance().addMessage(null, message);
                */

                LOGGER.fine("Document create database records - Get GROUPDOC license");

                LOGGER.finest("filePath: " + filePath);
                LOGGER.finest("licensePath: " + licensePath);

                LOGGER.fine("Document Process - Create directory path");

                // Get Application Module
                //AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");


                // Get Values and store iterator for RequestBacking bean (dialogReturnListener)
                if (iterBinding.equals("XwrlCaseDocumentsView1Iterator")) {
                    LOGGER.finest("Iterator XwrlCaseDocumentsView1Iterator");
                    voMaster = am.getXwrlRequestsView1(); //Individual
                    voDetail = am.getXwrlCaseDocumentsView1(); //Individual Case
                    caseId = (String) voMaster.getCurrentRow().getAttribute("CaseId");
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

                LOGGER.fine("Document create database records - Create document file path");

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

                LOGGER.fine("Document create database records - Create directory image path");

                LOGGER.finest("directory: " + docDir);

                imageDirName = docDirName + File.separator + "Images";
                LOGGER.finest("imageDirName: " + imageDirName);

                imageDir = new File(imageDirName);
                if (!imageDir.exists()) {
                    imageDir.mkdirs();
                }

                LOGGER.fine("Document create database records - Create database records");
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


                                LOGGER.fine("fileItem: " + fileItem); // Save for document files
                                LOGGER.fine("licensePath: " + licensePath); // Save for image files
                                LOGGER.fine("docDirName: " + docDirName); // Save for image files
                                LOGGER.fine("docFileName: " + docFileName); // Save for document and image files
                                LOGGER.fine("imageFileBase: " + imageFileBase); // Save for image files


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

                                UploadActiveDataModel activeModel = new UploadActiveDataModel();
                                UploadActiveDataModel.DocumentRecord docRec =
                                    activeModel.new DocumentRecord(); // Used to create document record
                                docRec.fileItem = fileItem;
                                docRec.licensePath = licensePath;
                                docRec.docDirName = docDirName;
                                docRec.docFileName = docFileName;
                                docRec.imageFileBase = imageFileBase;
                                docList.add(docRec);

                                calculateReturnValue();
                            }

                        }

                        DBTransaction txn = am.getDBTransaction(); // Commit database records
                        txn.commit();
                        voDetail.executeQuery(); //Not showing up in the page
                        documentList = (List<UploadActiveDataModel.DocumentRecord>) docList;
                        //this.setDocumentList(docList);
                        //voDetail.executeQuery();

                        //pageFlowScope.put(pageFlowId + ".uploadStatus","Complete");

                    } catch (Exception e) {
                        //pageFlowScope.put(pageFlowId + ".uploadStatus","Failed");
                        LOGGER.fine("Document create database records - ERROR");

                        DBTransaction txn = am.getDBTransaction(); // Rollback database records
                        txn.rollback();

                        msg = "The Upload create database records failed.";
                        message = new FacesMessage(FacesMessage.SEVERITY_ERROR, msg.toString(), null);
                        FacesContext.getCurrentInstance().addMessage(null, message);
                        e.printStackTrace();
                    } finally {
                        LOGGER.fine("Document create database records - FINISH");
                    }

                }
            }

            private void createDocumentFiles(List<DocumentRecord> docList) {
                LOGGER.fine("createDocumentFiles");

                LOGGER.fine("Document create document files - START");

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
                        LOGGER.fine("Document create document files - write files");
                        file = new File(docRec.docFileName);
                        docRec.fileItem.write(file);

                        calculateReturnValue();

                    }

                } catch (Exception e) {
                    //pageFlowScope.put(pageFlowId + ".uploadStatus","Failed");
                    LOGGER.fine("Document create document files - ERROR");

                    msg = "The Upload create document file failed.";
                    message = new FacesMessage(FacesMessage.SEVERITY_ERROR, msg.toString(), null);
                    FacesContext.getCurrentInstance().addMessage(null, message);
                    e.printStackTrace();
                } finally {
                    LOGGER.fine("Document create document files - FINISH");
                }

            }

            private void createDocumentImages(List<DocumentRecord> docList) {
                LOGGER.fine("createDocumentImages");

                LOGGER.fine("Document create document image files - START");
                // Initialize variables

                String storagePath = null;
                InputStream imageStream = null;
                String msg = null;
                FacesMessage message = null;


                // CREATE IMAGE FILE ON THE SERVER
                try {


                    //Long jobs = (Long) JSFUtils.getManagedBeanValue("viewScope.maxProgressModelVal");
                    //LOGGER.finest("jobs: "+jobs);

                    for (DocumentRecord docRec : docList) {

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

                        LOGGER.fine("Document create document image records - create document image files");
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

                        calculateReturnValue();

                    }

                } catch (Exception e) {
                    // TODO: Add catch code

                    LOGGER.fine("Document create document image files - ERROR");
                    msg = "The Upload create document file failed.";
                    message = new FacesMessage(FacesMessage.SEVERITY_ERROR, msg.toString(), null);
                    FacesContext.getCurrentInstance().addMessage(null, message);
                    e.printStackTrace();
                } finally {
                    LOGGER.fine("Document create document image files - FINISH");
                }

            }

            private void saveAsImage(String fileName, String imageFormat, InputStream inputStream) {
                LOGGER.fine("saveAsImage");
                LOGGER.finest("saveAsImage");
                LOGGER.finest("fileName: " + fileName);
                LOGGER.finest("imageFormat: " + imageFormat);

                try {
                    File file = new File(fileName + "." + imageFormat);
                    ImageIO.write(ImageIO.read(inputStream), imageFormat, file);
                } catch (IOException exp) {
                    LOGGER.fine("saveAsImage: " + exp.getMessage());
                    exp.printStackTrace();
                }

            }

            private void calculateReturnValue() {
                LOGGER.fine("calculateReturnValue");
                newNumItems = newNumItems + 1;
                int outputNum = (int) Math.round((newNumItems * 100 / originalNumItems));                
                UploadChange chg = new UploadChange();
                try {
                    chg.triggerDataChange(UploadActiveDataModel.this, String.valueOf(outputNum));
                } catch (Exception e) {
                    LOGGER.finest("Exception: "+e);
                }
                LOGGER.fine("newNumItems " + newNumItems);
                LOGGER.fine("originalNumItems " + originalNumItems);
                LOGGER.fine("outputNum " + outputNum);
            }


        };
        //Thread newThrd = new Thread(dataChanger);
        //newThrd.start();
        ScheduledExecutorService ses = Executors.newScheduledThreadPool(1);
        ses.schedule(dataChanger, 3 , TimeUnit.SECONDS);
    }
    

    
    
    
}
