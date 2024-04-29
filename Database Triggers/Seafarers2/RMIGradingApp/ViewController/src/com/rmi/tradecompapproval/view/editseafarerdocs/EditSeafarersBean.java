package com.rmi.tradecompapproval.view.editseafarerdocs;

//import com.rmi.manualtradecompliance.utils.JSFUtils;
import com.rmi.tradecompapproval.adfbc.utils.AdfUtils;
import com.rmi.tradecompapproval.utils.IriAdfUtils;
import com.rmi.tradecompapproval.utils.IriJsfUtils;

import java.awt.image.BufferedImage;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import java.io.OutputStream;

import javax.faces.application.FacesMessage;

import javax.faces.context.FacesContext;
import javax.faces.event.ValueChangeEvent;

import javax.imageio.ImageIO;

import oracle.adf.controller.ControllerContext;
import oracle.adf.controller.ViewPortContext;

import oracle.adf.model.binding.DCIteratorBinding;
import oracle.adf.view.rich.component.rich.RichPopup;
import oracle.adf.view.rich.component.rich.input.RichInputFile;
import oracle.adf.view.rich.component.rich.input.RichSelectOneChoice;
import oracle.adf.view.rich.context.AdfFacesContext;

import oracle.adf.view.rich.event.DialogEvent;

import oracle.adf.view.rich.event.PopupFetchEvent;

import oracle.binding.OperationBinding;

import oracle.jbo.Row;

import org.apache.myfaces.trinidad.event.SelectionEvent;
import org.apache.myfaces.trinidad.model.UploadedFile;

public class EditSeafarersBean {
    private RichPopup seafarerStatusConfirmPopup;
    private RichPopup seafarerShortTextPopup;

    public EditSeafarersBean() {
    }

    public String searchSeafarerAction() 
    {
        try 
        {
            OperationBinding searchOp = IriAdfUtils.findOperation("searchEditSeafarers");
            searchOp.execute();
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while searching seafarer. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        
        return null;
    }

    public String resetSearchSeafarerAction() 
    {
        try 
        {
            OperationBinding resetOp = IriAdfUtils.findOperation("resetSearchEditSeafarers");
            resetOp.execute();
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while resetting search form. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        
        return null;
    }

    public String actionSave() 
    {
        try 
        {
            OperationBinding saveOp = IriAdfUtils.findOperation("Commit");
            saveOp.execute();
            
            OperationBinding createBatchVettingOp = IriAdfUtils.findOperation("createBatchVetting");            
            createBatchVettingOp.getParamsMap().put("seafarerId", null);
            createBatchVettingOp.execute();
            
            IriJsfUtils.addFormattedFacesErrorMessage("Record Saved Successfully !", null, FacesMessage.SEVERITY_INFO);
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while saving changes. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }

    public String actionCancel() 
    {
        try 
        {
            OperationBinding cnclOp = IriAdfUtils.findOperation("Rollback");
            cnclOp.execute();

            IriJsfUtils.addFormattedFacesErrorMessage("Changes Reverted Successfully !", null,
                                                      FacesMessage.SEVERITY_INFO);

        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception on cancel. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }
    
    public void exceptionHandler()
    {
        //System.out.println("inside EditSeafarersTF exceptionHandler");
        ControllerContext ctx = ControllerContext.getInstance();
        ViewPortContext viewprt = ctx.getCurrentViewPort();

        if (viewprt.isExceptionPresent())
        {
            Exception exc = viewprt.getExceptionData();
            IriJsfUtils.addFormattedFacesErrorMessage("There has been exception while performing this task. ", exc.getMessage(), FacesMessage.SEVERITY_ERROR);
        }
    }

    public String actionAddSeafarer()
    {
        try 
        {
            OperationBinding addSeafarerOp = IriAdfUtils.findOperation("CreateSeafarer");
            addSeafarerOp.execute();

        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while creating Seafarer. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }

    public void uploadPhotoValuechangelistener(ValueChangeEvent valueChangeEvent) {
        try {
            String rejected = "no";

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
                        FacesMessage Message =
                            new FacesMessage("Photo size is not valid. Photo should be between 35*45 mm and 26*32 mm OR between 130*170 pixels and 98*120 pixels.");
                        Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                        FacesContext fc = FacesContext.getCurrentInstance();
                        fc.addMessage(null, Message);
                    } 
                    else {
                        String fileName = file.getFilename();

                        OperationBinding ob = IriAdfUtils.findOperation("uploadPhoto");
                        ob.getParamsMap().put("param1", "SICD");
                        ob.getParamsMap().put("param2", "0002");
                        ob.getParamsMap().put("param3", "Application");
                        ob.getParamsMap().put("fileName", fileName);
                        ob.getParamsMap().put("rejected", rejected);
                        String path = ob.execute().toString();
                        IriJsfUtils.uploadFile(file, path);
//                        IriJsfUtils.uploadFile(file, "D://"+file.getFilename());
                                                                        
                        OperationBinding assignFilePermsOp = IriAdfUtils.findOperation("createDocumentPreviewFolderWithPerms");
                        assignFilePermsOp.getParamsMap().put("folderPath", path);
                        assignFilePermsOp.execute();
                        
                        OperationBinding updSeafarerPhotoOb = IriAdfUtils.findOperation("updateSeafarerPhoto");
                        updSeafarerPhotoOb.getParamsMap().put("edocId", null);
                        updSeafarerPhotoOb.getParamsMap().put("seafarerId", null);
                        updSeafarerPhotoOb.execute();
                        System.out.println("updSeafarerPhotoOb :: "+updSeafarerPhotoOb.getResult());
                    }
                }
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading document." +
                                                      " Please contact your System Administrator.", "",
                                                      FacesMessage.SEVERITY_ERROR);
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
            byte[] bytes = new byte[1024];
            while ((read = inputStream.read(bytes)) != -1) {
                outputStream.write(bytes, 0, read);
            }
        } catch (IOException e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while uploading document." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
        return newFile;
    }

    public void editSeafarersRowSelectionListener(SelectionEvent selectionEvent) {
        try
        {
            IriJsfUtils.invokeEL("#{bindings.EditSeafarersVO1.collectionModel.makeCurrent}", new Class[] {
                                 SelectionEvent.class }, new Object[] { selectionEvent });
            Row selectedRow = (Row) IriJsfUtils.resolveExpression("#{bindings.EditSeafarersVO1Iterator.currentRow}");

            OperationBinding fetchSeafarerStatusOp = IriAdfUtils.findOperation("fetchSelectedSeafarerStatus");
            fetchSeafarerStatusOp.execute();
            
            Object seafarerStatus = fetchSeafarerStatusOp.getResult(); 
            
            if(seafarerStatus != null)
            {
                if (seafarerStatus.toString().equalsIgnoreCase("Suspended") ||
                    seafarerStatus.toString().equalsIgnoreCase("Deceased"))
                    AdfUtils.addFormattedFacesErrorMessage("Seafarer FIN record status is "+seafarerStatus, "",
                                                               FacesMessage.SEVERITY_ERROR);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception selecting Seafarer. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }     
    }

    public void seafarerStatusValueChangeListener(ValueChangeEvent valueChangeEvent)
    {
        try
        {
            valueChangeEvent.getComponent().processUpdates(FacesContext.getCurrentInstance());
            
            OperationBinding fetchSeafarerStatusOp = IriAdfUtils.findOperation("fetchSelectedSeafarerStatus");
            fetchSeafarerStatusOp.execute();
            
            Object seafarerStatus = fetchSeafarerStatusOp.getResult();
            
            if(seafarerStatus != null)
            {
                if (seafarerStatus.toString().equalsIgnoreCase("Suspended")
                     || seafarerStatus.toString().equalsIgnoreCase("Deceased")
                     || seafarerStatus.toString().equalsIgnoreCase("Rejected"))
                    IriJsfUtils.showPopup(seafarerStatusConfirmPopup, true);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while changing Seafarer status. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }     
    }

    public void setSeafarerStatusConfirmPopup(RichPopup seafarerStatusConfirmPopup) {
        this.seafarerStatusConfirmPopup = seafarerStatusConfirmPopup;
    }

    public RichPopup getSeafarerStatusConfirmPopup() {
        return seafarerStatusConfirmPopup;
    }

    public void seafarerStatusCnfDialogListener(DialogEvent dialogEvent)
    {
        try 
        {
            if (dialogEvent.getOutcome() != null &&
                (dialogEvent.getOutcome().toString().equalsIgnoreCase("yes") ||
                 (dialogEvent.getOutcome().toString().equalsIgnoreCase("ok"))))
            {
                OperationBinding updateSeafarerDocStatus = IriAdfUtils.findOperation("updateSeafarerDocStatus");
                updateSeafarerDocStatus.execute();
                OperationBinding saveOp = IriAdfUtils.findOperation("Commit");
                saveOp.execute();

                IriJsfUtils.addFormattedFacesErrorMessage("Seafarer Status Updated Successfully.", "",
                                                          FacesMessage.SEVERITY_INFO);
            }
            else
            {
                OperationBinding rollbackOp = IriAdfUtils.findOperation("Rollback");
                rollbackOp.execute();
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating Seafarer Status." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public void setSeafarerShortTextPopup(RichPopup seafarerShortTextPopup) {
        this.seafarerShortTextPopup = seafarerShortTextPopup;
    }

    public RichPopup getSeafarerShortTextPopup() {
        return seafarerShortTextPopup;
    }

    public void seafarerShortTextPopupFetchListener(PopupFetchEvent popupFetchEvent)
    {
        try {
            OperationBinding filterSeafarerShortText = IriAdfUtils.findOperation("filterSeafarerShortText");
            filterSeafarerShortText.execute();
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating Seafarer Notes." +
                                             " Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR); 
        }
    }

    public void seafarerShortTextDialogListener(DialogEvent dialogEvent)
    {
        try 
        {
            if (dialogEvent.getOutcome() != null &&
                (dialogEvent.getOutcome().toString().equalsIgnoreCase("yes") ||
                 (dialogEvent.getOutcome().toString().equalsIgnoreCase("ok"))))
            {
                OperationBinding updateSeafarerShortText = IriAdfUtils.findOperation("updateSeafarerShortText");
                updateSeafarerShortText.execute();
                
                if(updateSeafarerShortText.getResult() != null && updateSeafarerShortText.getResult().toString().equalsIgnoreCase("Y"))
                {
                    AdfUtils.addFormattedFacesErrorMessage("Record Saved Successfully.", 
                                                         "", FacesMessage.SEVERITY_INFO);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating Seafarer Notes." +
                                                 " Please contact your System Administrator." , 
                                                 "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void photoDownloadListener(FacesContext facesContext, OutputStream outputStream) 
    {
        DCIteratorBinding searchSfrrVo = IriAdfUtils.findIterator("EditSeafarersVO1Iterator");
        
        if(searchSfrrVo != null)
        {
            Row currentRow = searchSfrrVo.getCurrentRow();
            
            if(currentRow != null && currentRow.getAttribute("Photo") != null)
            {
                System.out.println("seafarer photo :: "+currentRow.getAttribute("Photo"));
                IriJsfUtils.downloadFile(currentRow.getAttribute("Photo").toString(), outputStream);                
            }
        }        
    }
}