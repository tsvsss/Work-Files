package com.rmi.tradecompapproval.view.ocverification;

import com.rmi.tradecompapproval.utils.IriJsfUtils;
import com.rmi.tradecompapproval.utils.IriAdfUtils;

import com.rmi.tradecompapproval.utils.IriJsfUtils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import java.io.OutputStream;

import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.faces.event.ValueChangeEvent;

import oracle.adf.controller.ControllerContext;
import oracle.adf.controller.ViewPortContext;
import oracle.adf.view.rich.component.rich.RichPopup;
import oracle.adf.view.rich.component.rich.input.RichInputFile;
import oracle.adf.view.rich.component.rich.output.RichInlineFrame;
import oracle.adf.view.rich.context.AdfFacesContext;
import oracle.adf.view.rich.event.DialogEvent;

import oracle.adf.view.rich.event.PopupCanceledEvent;
import oracle.adf.view.rich.event.PopupFetchEvent;

import oracle.adf.view.rich.util.ResetUtils;

import oracle.binding.OperationBinding;

import org.apache.commons.io.IOUtils;
import org.apache.myfaces.trinidad.context.RequestContext;
import org.apache.myfaces.trinidad.model.UploadedFile;
import org.apache.myfaces.trinidad.render.ExtendedRenderKitService;
import org.apache.myfaces.trinidad.util.Service;

public class OcVerificationBean {
    
    public UploadedFile file;
    private String filePath;
    private String fileName;    
    public UploadedFile fileWaitng;
    private String fileWaitngPath;
    private String fileWaitngName;
    private String tabActvFlg = "U";
    private String inlineFrameSource = null;
    private String inlineFrameWaitingSource = null;
    private RichInlineFrame inlineFrameBinding;
    private RichInlineFrame inlineFrameWaitingBinding;
    private RichInputFile inputFileBinding;
    private RichInputFile inputFileWaitingBinding;
    private RichPopup bindingVerificationPopup;
    private RichPopup bindingWaitingPopup;

    public void setInlineFrameWaitingSource(String inlineFrameWaitingSource) {
        this.inlineFrameWaitingSource = inlineFrameWaitingSource;
    }

    public String getInlineFrameWaitingSource() {
        return inlineFrameWaitingSource;
    }

    public void setInlineFrameSource(String inlineFrameSource) {
        this.inlineFrameSource = inlineFrameSource;
    }

    public String getInlineFrameSource() {
        return inlineFrameSource;
    }

    public OcVerificationBean() {
    }

    public void setFileWaitng(UploadedFile fileWaitng) {
        this.fileWaitng = fileWaitng;
    }

    public UploadedFile getFileWaitng() {
        return fileWaitng;
    }

    public void setFileWaitngPath(String fileWaitngPath) {
        this.fileWaitngPath = fileWaitngPath;
    }

    public String getFileWaitngPath() 
    {
        try 
        {
            OperationBinding filePathOp = IriAdfUtils.findOperation("getCocFileName");
            filePathOp.getParamsMap().put("colType", "filePath");
            filePathOp.getParamsMap().put("docType", "W");
            filePathOp.execute();

            Object filePth = filePathOp.getResult();

            if (filePth != null && filePth.toString().length() > 0) {
                return filePth.toString();

            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching COC file name." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return fileWaitngPath;
    }

    public void setFileWaitngName(String fileWaitngName) {
        this.fileWaitngName = fileWaitngName;
    }

    public String getFileWaitngName() 
    {
        try 
        {
            OperationBinding fileNmOp = IriAdfUtils.findOperation("getCocFileName");
            fileNmOp.getParamsMap().put("colType", "fileNm");
            fileNmOp.getParamsMap().put("docType", "W");
            fileNmOp.execute();

            Object fileNm = fileNmOp.getResult();

            if (fileNm != null && fileNm.toString().length() > 0) {
                return fileNm.toString();
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching COC file name." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return fileWaitngName;
    }
    private RichPopup bindingEmailPopup;

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getFilePath() 
    {
        try 
        {
            OperationBinding filePathOp = IriAdfUtils.findOperation("getCocFileName");
            filePathOp.getParamsMap().put("colType", "filePath");
            filePathOp.getParamsMap().put("docType", "U");
            filePathOp.execute();

            Object filePth = filePathOp.getResult();

            if (filePth != null && filePth.toString().length() > 0) {
                return filePth.toString();
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching COC file path." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }

        return filePath;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFileName() 
    {
        try 
        {
            OperationBinding fileNmOp = IriAdfUtils.findOperation("getCocFileName");
            fileNmOp.getParamsMap().put("colType", "fileNm");
            fileNmOp.getParamsMap().put("docType", "U");
            fileNmOp.execute();

            Object fileNm = fileNmOp.getResult();

            if (fileNm != null && fileNm.toString().length() > 0) {
                return fileNm.toString();
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching COC file name." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return this.fileName;
    }

    public void setFile(UploadedFile file) {
        this.file = file;
    }

    public UploadedFile getFile() {
        return file;
    }

    public void valueChangeViewOrders(ValueChangeEvent valueChangeEvent) 
    {
        try 
        {
            if (valueChangeEvent.getNewValue() != null && valueChangeEvent.getNewValue().toString().length() > 0) {
                OperationBinding fltrOcOp = IriAdfUtils.findOperation("filterOcVerification");
                fltrOcOp.getParamsMap().put("filterType", valueChangeEvent.getNewValue().toString());
                fltrOcOp.execute();
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while documents pending OC verification." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    /**Method to download file from actual path
     * @param facesContext
     * @param outputStream
     */
    public void downloadFileListener(FacesContext facesContext, OutputStream outputStream) throws IOException {
        //Read file from particular path, path bind is binding of table field that contains path
        try 
        {
            OperationBinding filePathOp = IriAdfUtils.findOperation("getCocFileName");
            filePathOp.getParamsMap().put("colType", "filePath");
            filePathOp.getParamsMap().put("docType", "U");
            filePathOp.execute();

            Object filePth = filePathOp.getResult();

            if (filePth != null && filePth.toString().length() > 0) {
                setFilePath(filePth.toString());
            }

            File filed = new File(filePath);
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
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while downloading file." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
            }
            outputStream.flush();
        } catch (IOException ioe) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while downloading file." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }
    
    /**Method to download file from actual path
     * @param facesContext
     * @param outputStream
     */
    public void downloadFileListenerWaiting(FacesContext facesContext, OutputStream outputStream) throws IOException {
        //Read file from particular path, path bind is binding of table field that contains path
        
        try {
            OperationBinding filePathOp = IriAdfUtils.findOperation("getCocFileName");
            filePathOp.getParamsMap().put("colType", "filePath");
            filePathOp.getParamsMap().put("docType", "W");
            filePathOp.execute();

            Object filePth = filePathOp.getResult();

            if (filePth != null && filePth.toString().length() > 0) {
                setFileWaitngPath(filePth.toString());
            }

            File filed = new File(fileWaitngPath);
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
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while downloading file." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
            }
            outputStream.flush();
        } catch (IOException ioe) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while downloading file." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void dialogOcVerification(DialogEvent dialogEvent) 
    {
        try 
        {
            if (dialogEvent.getOutcome() != null && dialogEvent.getOutcome().toString().equalsIgnoreCase("ok")) {
                OperationBinding updDocStatOp = IriAdfUtils.findOperation("updateDocVerifiedStatus");
                updDocStatOp.getParamsMap().put("docType", "U");
                updDocStatOp.execute();
                setFile(null);
                inputFileBinding.resetValue();
                inputFileBinding.setValid(false);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception updating document status." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void dialogWaitingResponse(DialogEvent dialogEvent) 
    {
        try 
        {
            if (dialogEvent.getOutcome() != null && dialogEvent.getOutcome().toString().equalsIgnoreCase("ok")) {
                OperationBinding updDocStatOp = IriAdfUtils.findOperation("updateDocVerifiedStatus");
                updDocStatOp.getParamsMap().put("docType", "W");
                updDocStatOp.execute();
                setFileWaitng(null);
                inputFileWaitingBinding.resetValue();
                inputFileWaitingBinding.setValid(false);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating document status." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void dialogEmailNotification(DialogEvent dialogEvent) 
    {
        try 
        {
            if (dialogEvent.getOutcome() != null && dialogEvent.getOutcome().toString().equalsIgnoreCase("ok")) {
                OperationBinding unvrfdMailOp = IriAdfUtils.findOperation("sendEmailNotification");
                unvrfdMailOp.getParamsMap().put("docType", tabActvFlg);
                unvrfdMailOp.execute();
                
                bindingEmailPopup.hide();
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while sending email notification." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void cancelEmailNotificationPopup(PopupCanceledEvent popupCanceledEvent) {
        // Add event code here...
    }

    public void valueChangeUploadDocument(ValueChangeEvent valueChangeEvent) 
    {
        if (valueChangeEvent.getNewValue() != null) 
        {
            try {
                UploadedFile fileVal = (UploadedFile) valueChangeEvent.getNewValue();
                this.fileName = fileVal.getFilename();
                OperationBinding ob = IriAdfUtils.findOperation("uploadDocument");
                ob.getParamsMap().put("param1", "SICD");
                ob.getParamsMap().put("param2", "0010");
                ob.getParamsMap().put("param3", "Application");
                ob.getParamsMap().put("fileName", fileVal.getFilename());
                ob.getParamsMap().put("docType", tabActvFlg);
                ob.execute();

                if (ob.getResult() != null) {
                    this.filePath = ob.getResult().toString();
                }

                InputStream in = fileVal.getInputStream();
//                uploadFile(in, this.filePath);
                IriJsfUtils.uploadFile(fileVal, this.filePath);
//                ResetUtils.reset(valueChangeEvent.getComponent());
                
            } catch (MalformedURLException murle) {
                IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading file." +
                                                            " Please contact your System Administrator." , 
                                                          "", FacesMessage.SEVERITY_ERROR);
            } catch (IOException ioe) {
                IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading file." +
                                                            " Please contact your System Administrator." , 
                                                          "", FacesMessage.SEVERITY_ERROR);
            }
        }
    }

    public void valueChangeUploadDocumentWaiting(ValueChangeEvent valueChangeEvent) 
    {
        if (valueChangeEvent.getNewValue() != null) 
        {
            try {
                UploadedFile fileVal = (UploadedFile) valueChangeEvent.getNewValue();
                this.fileWaitngName = fileVal.getFilename();
                OperationBinding ob = IriAdfUtils.findOperation("uploadDocument");
                ob.getParamsMap().put("param1", "SICD");
                ob.getParamsMap().put("param2", "0010");
                ob.getParamsMap().put("param3", "Application");
                ob.getParamsMap().put("fileName", fileVal.getFilename());
                ob.getParamsMap().put("docType", tabActvFlg);
                ob.execute();

                if (ob.getResult() != null) {
                    this.fileWaitngPath = ob.getResult().toString();
                }

                InputStream in = fileVal.getInputStream();
//                uploadFile(in, this.fileWaitngPath);
                IriJsfUtils.uploadFile(fileVal, this.filePath);
//                ResetUtils.reset(valueChangeEvent.getComponent());
                
            } catch (MalformedURLException murle) {
                IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading file." +
                                                            " Please contact your System Administrator." , 
                                                          "", FacesMessage.SEVERITY_ERROR);
            } catch (IOException ioe) {
                IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading file." +
                                                            " Please contact your System Administrator." , 
                                                          "", FacesMessage.SEVERITY_ERROR);
            }
        }
    }

    public void setBindingEmailPopup(RichPopup bindingEmailPopup) {
        this.bindingEmailPopup = bindingEmailPopup;
    }

    public RichPopup getBindingEmailPopup() {
        return bindingEmailPopup;
    }

    public String actionSendEmailPending() 
    {
        try 
        {
            OperationBinding fetchOp = IriAdfUtils.findOperation("setEmailNotificationDetails");
            fetchOp.execute();
            tabActvFlg = "U";
            IriJsfUtils.showPopup(bindingEmailPopup, true);
            
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching email credentials." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }

    public String actionSendEmailWaiting() 
    {
        try 
        {
            OperationBinding fetchOp = IriAdfUtils.findOperation("setEmailNotificationWaiting");
            fetchOp.execute();
            tabActvFlg = "W";
            IriJsfUtils.showPopup(bindingEmailPopup, true);
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching email credentials." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }

    public void setInlineFrameBinding(RichInlineFrame inlineFrameBinding) {
        this.inlineFrameBinding = inlineFrameBinding;
    }

    public RichInlineFrame getInlineFrameBinding() {
        return inlineFrameBinding;
    }

    public void viewCocActionListener(ActionEvent actionEvent) 
    {
        getFilePath();
    }

    public void viewCocWaitingActionListener(ActionEvent actionEvent) 
    {
        getFileWaitngPath();
    }

    public void popupFetchListenerVerifyPending(PopupFetchEvent popupFetchEvent) 
    {
        setInlineFrameSource(null);
        setFilePath(null);
        setFile(null);
    }

    public void popupFetchListenerVerifyWaiting(PopupFetchEvent popupFetchEvent) 
    {
        setInlineFrameWaitingSource(null);
        setFileWaitngPath(null);
        setFileWaitng(null);
    }
    
    public void setInlineFrameWaitingBinding(RichInlineFrame inlineFrameWaitingBinding) {
        this.inlineFrameWaitingBinding = inlineFrameWaitingBinding;
    }

    public RichInlineFrame getInlineFrameWaitingBinding() {
        return inlineFrameWaitingBinding;
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

    public void dialogOcManualVerification(DialogEvent dialogEvent)
    {        
        try 
        {
            if (dialogEvent.getOutcome() != null &&
                (dialogEvent.getOutcome().toString().equalsIgnoreCase("yes") ||
                 (dialogEvent.getOutcome().toString().equalsIgnoreCase("ok")))) {
                OperationBinding updDocStatOp = IriAdfUtils.findOperation("updateDocVerifiedStatusManually");
                updDocStatOp.getParamsMap().put("docType", "U");
                updDocStatOp.execute();
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating document status." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void setInputFileBinding(RichInputFile inputFileBinding) {
        this.inputFileBinding = inputFileBinding;
    }

    public RichInputFile getInputFileBinding() {
        return inputFileBinding;
    }

    public void setInputFileWaitingBinding(RichInputFile inputFileWaitingBinding) {
        this.inputFileWaitingBinding = inputFileWaitingBinding;
    }

    public RichInputFile getInputFileWaitingBinding() {
        return inputFileWaitingBinding;
    }

    public String actionVerifyOnline()
    {
        try 
        {
            OperationBinding fetchVerifyOnlineUrlOp = IriAdfUtils.findOperation("fetchVerifyOnlineUrl");
            fetchVerifyOnlineUrlOp.getParamsMap().put("docType", "U");
            fetchVerifyOnlineUrlOp.execute();
            
            if(fetchVerifyOnlineUrlOp.getResult() != null)
            {                
                String[] urls = (String[]) fetchVerifyOnlineUrlOp.getResult();
                
                for(String url : urls)
                {
                    if(url != null && url.trim().length() > 0)
                        openUrlNewTab("http"+url);
                }
                
                IriJsfUtils.showPopup(bindingVerificationPopup, true);
//                AdfFacesContext.getCurrentInstance().addPartialTarget(bindingVerificationPopup);
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while opening verifcation window." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }

    public String actionVerifyWaiting()
    {
        try 
        {
            OperationBinding fetchVerifyOnlineUrlOp = IriAdfUtils.findOperation("fetchVerifyOnlineUrl");
            fetchVerifyOnlineUrlOp.getParamsMap().put("docType", "W");
            fetchVerifyOnlineUrlOp.execute();

            if (fetchVerifyOnlineUrlOp.getResult() != null) {
                String[] urls = (String[]) fetchVerifyOnlineUrlOp.getResult();

                for (String url : urls) {
//                    System.out.println("url :: " + url);
                    openUrlNewTab(url);
                }

                IriJsfUtils.showPopup(bindingWaitingPopup, true);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while opening verifcation window." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }    

    public void openUrlNewTab(String url)
    {
        try 
        {
            if(url != null && url.length() > 0)
            {
                StringBuffer sb = new StringBuffer();
                sb.append("var winPop = true;");
                sb.append("winPop = window.open(\"" +
                          url +
                          "\", \"_blank\"); ");
                ExtendedRenderKitService erks =
                    Service.getRenderKitService(FacesContext.getCurrentInstance(), ExtendedRenderKitService.class);
                StringBuilder script = new StringBuilder();
                script.append(sb.toString());
                erks.addScript(FacesContext.getCurrentInstance(), script.toString());
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while opening url." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }

    public void setBindingVerificationPopup(RichPopup bindingVerificationPopup) {
        this.bindingVerificationPopup = bindingVerificationPopup;
    }

    public RichPopup getBindingVerificationPopup() {
        return bindingVerificationPopup;
    }

    public void setBindingWaitingPopup(RichPopup bindingWaitingPopup) {
        this.bindingWaitingPopup = bindingWaitingPopup;
    }

    public RichPopup getBindingWaitingPopup() {
        return bindingWaitingPopup;
    }
}
