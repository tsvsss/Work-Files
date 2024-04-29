package com.rmi.tradecompapproval.view.validateseafarer;

import com.rmi.tradecompapproval.utils.IriAdfUtils;
import com.rmi.tradecompapproval.utils.IriJsfUtils;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import java.sql.SQLException;

import java.text.ParseException;
import java.text.SimpleDateFormat;

import java.util.Calendar;

import javax.faces.application.FacesMessage;
import javax.faces.component.UIComponent;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;

import javax.faces.event.ValueChangeEvent;
import javax.faces.validator.ValidatorException;

import javax.servlet.http.HttpServletRequest;

import oracle.adf.controller.ControllerContext;
import oracle.adf.controller.ViewPortContext;
import oracle.adf.model.BindingContext;

import oracle.adf.model.binding.DCIteratorBinding;
import oracle.adf.share.ADFContext;
import oracle.adf.view.rich.component.rich.RichPopup;

import oracle.adf.view.rich.component.rich.input.RichInputListOfValues;
import oracle.adf.view.rich.component.rich.layout.RichShowDetailItem;
import oracle.adf.view.rich.context.AdfFacesContext;
import oracle.adf.view.rich.event.DialogEvent;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

import oracle.jbo.Key;
import oracle.jbo.domain.Date;

import org.apache.myfaces.trinidad.event.DisclosureEvent;
import org.apache.myfaces.trinidad.render.ExtendedRenderKitService;
import org.apache.myfaces.trinidad.util.Service;

public class ValidateSeafarerBean {
    
    public String mergedFile;
    private RichPopup printDocumentPopup;
    private RichShowDetailItem sqcTabBinding;
    private RichShowDetailItem ocTabBinding;
    private RichShowDetailItem bookTabBinding;
    private RichInputListOfValues ocCapacityBinding;
    private RichInputListOfValues ocFunctionBinding;

    public ValidateSeafarerBean() {
    }

    public void setMergedFile(String mergedFile) {
        this.mergedFile = mergedFile;
    }

    public String getMergedFile()
    {
        try 
        {
            if (this.mergedFile == null) {
                try {
                    OperationBinding supportDocOp = IriAdfUtils.findOperation("getMergedFileName");
                    supportDocOp.execute();

                    if (supportDocOp.getResult() != null && supportDocOp.getResult().toString().length() > 0) {
                        this.mergedFile = supportDocOp.getResult().toString();
                    }
                } catch (Exception exp) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching file path." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
                }
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching file path." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return mergedFile;
    }

    public BindingContainer getBindings() {
        return BindingContext.getCurrent().getCurrentBindingsEntry();
    }

    public String actionSaveOC() 
    {
        try 
        {
            String ocIteratorName = "OfficerCertificatesVO1Iterator";
            String sqcIteratorName = "SpecialQualificationsVO1Iterator";
            Key ocRowKey = null;
            Key sqcRowKey = null;
            
            if(ocTabBinding.isDisclosed())
                ocRowKey = getCurrentRowKey(ocIteratorName);
            if(sqcTabBinding.isDisclosed())
                sqcRowKey = getCurrentRowKey(sqcIteratorName);
            
            Object batchId = ADFContext.getCurrent().getSessionScope().get("batchId");
            OperationBinding saveOcOp = IriAdfUtils.findOperation("Commit");
            saveOcOp.execute();
            
            OperationBinding updDocOp = IriAdfUtils.findOperation("updateSeafarerDocsDetails");
            updDocOp.getParamsMap().put("batchId", ((batchId != null) ? Integer.parseInt(batchId.toString()) : null));
            updDocOp.execute();

             if (updDocOp.getErrors().isEmpty() &&
                 (updDocOp.getResult() != null && updDocOp.getResult().equals("Y"))) {
                 OperationBinding saveOp = IriAdfUtils.findOperation("Commit");
                 saveOp.execute();
                 
                 if(ocTabBinding.isDisclosed() || sqcTabBinding.isDisclosed() || bookTabBinding.isDisclosed())
                 {
                     OperationBinding executeOcSqcVoOp = IriAdfUtils.findOperation("refreshSicdOcSqcViews");
                     executeOcSqcVoOp.execute();
                 }
                 
//                 if(ocTabBinding.isDisclosed())
//                     setCurrentRowKey(ocIteratorName, ocRowKey);
//                 if(sqcTabBinding.isDisclosed())
//                     setCurrentRowKey(sqcIteratorName, sqcRowKey);

                IriJsfUtils.addFormattedFacesErrorMessage("Record Saved Successfully !", null, FacesMessage.SEVERITY_INFO);
             } else {
                 IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while updating Seafarer's endorsement details. " +
                                                             " Please contact your System Administrator." , 
                                                           "", FacesMessage.SEVERITY_ERROR);
             }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while saving changes." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }

    public Key getCurrentRowKey(String iteratorName)
    {
        if(iteratorName != null)
        {
            BindingContainer bindings = getBindings();
            DCIteratorBinding parentIter = (DCIteratorBinding) bindings.get(iteratorName);
            Key rowKey = parentIter.getCurrentRow().getKey();
            parentIter.setCurrentRowWithKey(rowKey.toStringFormat(true));
            
            if(rowKey != null)
                return rowKey;
        }
        return null;
    }   

    public void setCurrentRowKey(String iteratorName, Key rowKey)
    {
        if(iteratorName != null && rowKey != null)
        {
            BindingContainer bindings = getBindings();
            DCIteratorBinding parentIter = (DCIteratorBinding) bindings.get(iteratorName);
            parentIter.setCurrentRowWithKey(rowKey.toStringFormat(true));
        }
    }

    public String actionCancelOC()
    {
        try 
        {
            OperationBinding cnclOcOp = IriAdfUtils.findOperation("Rollback");
            cnclOcOp.execute();

            IriJsfUtils.addFormattedFacesErrorMessage("Changes Reverted Successfully !", null,
                                                      FacesMessage.SEVERITY_INFO);

        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception on cancel." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }

    public String actionBack()
    {
        /*OperationBinding cnclOcOp = IriAdfUtils.findOperation("Rollback");
        cnclOcOp.execute();
        IriJsfUtils.addFormattedFacesErrorMessage("Changes Reverted Successfully !", null, FacesMessage.SEVERITY_INFO);
         */
        return "back";
    }

    public void actionListenerAddOc(ActionEvent actionEvent) 
    {
        try 
        {
            OperationBinding addOcOp = IriAdfUtils.findOperation("CreateInsertOc");
            addOcOp.execute();
            OperationBinding defValuesOp = IriAdfUtils.findOperation("setDefaultValuesOnCreate");
            defValuesOp.getParamsMap().put("documentType", "OC");
            defValuesOp.execute();
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while adding new certificate." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void actionListenerAddBooks(ActionEvent actionEvent) 
    {
        try 
        {
            OperationBinding addBooksOp = IriAdfUtils.findOperation("CreateInsertBooks");
            addBooksOp.execute();
            OperationBinding defValuesOp = IriAdfUtils.findOperation("setDefaultValuesOnCreate");
            defValuesOp.getParamsMap().put("documentType", "BOOKS");
            defValuesOp.execute();
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while adding new book." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void actionListenerAddSqc(ActionEvent actionEvent) 
    {
        try 
        {
            OperationBinding addSqcOp = IriAdfUtils.findOperation("CreateInsertSqc");
            addSqcOp.execute();
            OperationBinding defValuesOp = IriAdfUtils.findOperation("setDefaultValuesOnCreate");
            defValuesOp.getParamsMap().put("documentType", "SQC");
            defValuesOp.execute();
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while adding new sqc." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void actionListenerDeleteOc(ActionEvent actionEvent) 
    {
        try 
        {
            OperationBinding deleteOcOp = IriAdfUtils.findOperation("DeleteOc");
            deleteOcOp.execute();

            OperationBinding saveOcOp = IriAdfUtils.findOperation("Commit");
            saveOcOp.execute();
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while deleting certificate." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }
    
    public void actionListenerDeleteBooks(ActionEvent actionEvent) 
    {
        try 
        {
            OperationBinding deleteBooksOp = IriAdfUtils.findOperation("DeleteBooks");
            deleteBooksOp.execute();

            OperationBinding saveOcOp = IriAdfUtils.findOperation("Commit");
            saveOcOp.execute();
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while deleting book." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void actionListenerDeleteSqc(ActionEvent actionEvent) 
    {
        try 
        {
            OperationBinding deleteSqcOp = IriAdfUtils.findOperation("DeleteSqc");
            deleteSqcOp.execute();

            OperationBinding saveOcOp = IriAdfUtils.findOperation("Commit");
            saveOcOp.execute();
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while deleting sqc." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
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

    public void supportingDocsFileDownloadListener(FacesContext facesContext, OutputStream outputStream) throws IOException
    {
        try 
        {
            System.out.println("called");
            OperationBinding supportDocOp = IriAdfUtils.findOperation("genMergedSupportingDocs");
            supportDocOp.execute();

            System.out.println("after method called");

            if (supportDocOp.getResult() != null && supportDocOp.getResult().toString().length() > 0) {
                System.out.println("inside if");
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
                    IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while generating supporting documents." +
                                                                " Please contact your System Administrator." , 
                                                              "", FacesMessage.SEVERITY_ERROR);
                } finally {
                    outputStream.flush();
                }
            }
            System.out.println("after called");
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while generating supporting documents." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public String actionSaveValidateSeafarer() 
    {
        try 
        {
            OperationBinding saveOcOp = IriAdfUtils.findOperation("Commit");
            saveOcOp.execute();
            
            IriJsfUtils.addFormattedFacesErrorMessage("Record Saved Successfully !", null, FacesMessage.SEVERITY_INFO);
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while saving changes." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }

    public void printSeafarerDocumentDL(DialogEvent dialogEvent) 
    {
        try 
        {
            OperationBinding printDocOp = IriAdfUtils.findOperation("printSeafarerDocument");
            printDocOp.execute();

            if (printDocOp.getErrors().isEmpty()) {
                if (printDocOp.getResult() != null && printDocOp.getResult().toString().length() > 1) {
                    
                    IriJsfUtils.addFormattedFacesErrorMessage(printDocOp.getResult().toString(), "", FacesMessage.SEVERITY_INFO);
                }
            } else {
                IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while printing selected document. " +
                                                            " Please contact your System Administrator." , 
                                                          "", FacesMessage.SEVERITY_ERROR);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while printing selected document. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void setPrintDocumentPopup(RichPopup printDocumentPopup) {
        this.printDocumentPopup = printDocumentPopup;
    }

    public RichPopup getPrintDocumentPopup() {
        return printDocumentPopup;
    }

    public String actionAddOcCapacity()
    {
        try
        {
           OperationBinding addOcCapacityOp = IriAdfUtils.findOperation("CreateOcCapacity");
            addOcCapacityOp.execute();
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while adding OC Capacity. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        
        return null;
    }

    public void deleteOcCapacityAL(ActionEvent actionEvent)
    {
        try
        {
           OperationBinding deleteOcCapacityOp = IriAdfUtils.findOperation("DeleteOcCapacity");
            deleteOcCapacityOp.execute();

            OperationBinding saveOcOp = IriAdfUtils.findOperation("Commit");
            saveOcOp.execute();
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while deleting OC Capacity. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public String actionAddOcFunction() 
    {
        try
        {
           OperationBinding addOcFunctionOp = IriAdfUtils.findOperation("CreateOcFunction");
            addOcFunctionOp.execute();
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while adding OC Function. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }

    public void deleteOcFunctionAL(ActionEvent actionEvent)
    {
        try
        {
           OperationBinding deleteOcFunctionOp = IriAdfUtils.findOperation("DeleteOcFunction");
            deleteOcFunctionOp.execute();
            
            OperationBinding saveOcOp = IriAdfUtils.findOperation("Commit");
            saveOcOp.execute();
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while deleting OC Function. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public String actionAddSqcCapacity() {
        try
        {
           OperationBinding addOcFunctionOp = IriAdfUtils.findOperation("CreateSqcDetailsCapacity");
            addOcFunctionOp.execute();
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while adding SQC Capacity. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }

    public String actionDeleteSqcCapacity() {
        try
        {
           OperationBinding addOcFunctionOp = IriAdfUtils.findOperation("DeleteSqcCapacity");
            addOcFunctionOp.execute();
            
            OperationBinding saveOcOp = IriAdfUtils.findOperation("Commit");
            saveOcOp.execute();
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while deleting SQC Capacity. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }

    public String actionAddSqcFunction() {
        try
        {
           OperationBinding addOcFunctionOp = IriAdfUtils.findOperation("CreateSqcFunction");
            addOcFunctionOp.execute();
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while adding SQC Function. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }

    public String actionDeleteSqcFunction() {
        try
        {
            OperationBinding addOcFunctionOp = IriAdfUtils.findOperation("DeleteSqcFunction");
            addOcFunctionOp.execute();

            OperationBinding saveOcOp = IriAdfUtils.findOperation("Commit");
            saveOcOp.execute();
            
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while deleting SQC Function. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }

    public void issueDateValidator(FacesContext facesContext, UIComponent uIComponent, Object object) 
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
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while validating issue date." +
                                                      " Please contact your System Administrator.", "",
                                                      FacesMessage.SEVERITY_ERROR);
        }
        int countfnd = date1.compareTo(date2);
        
        if (countfnd > 0) {
            throw new ValidatorException(new FacesMessage(FacesMessage.SEVERITY_ERROR,
                                                          "Issue date can not be greater than current date.", null));
        }
    }

    public void expirationDateValidator(FacesContext facesContext, UIComponent uIComponent, Object object)
    {
        try {
            Date expdate = new Date(object);
            OperationBinding ob = getBindings().getOperationBinding("validateExpDate");
            ob.getParamsMap().put("endDate", expdate);
            String res = ob.execute().toString();
            if (res.equalsIgnoreCase("true")) {
                throw new ValidatorException(new FacesMessage(FacesMessage.SEVERITY_ERROR,
                                                              "Expiration date can not be less than issue date.",
                                                              null));
            }
            java.util.Date utDate = null;
            java.util.Date date1 = null;
            if (expdate != null) {
                java.sql.Date sqldate = expdate.dateValue();
                utDate = new java.util.Date(sqldate.getTime());
                Calendar cal = Calendar.getInstance();
                try {
                    date1 = new SimpleDateFormat("dd/MM/yyyy").parse(getDate(cal));
                } catch (Exception e) {
                }
                if (utDate.before(date1)) {
                    throw new ValidatorException(new FacesMessage(FacesMessage.SEVERITY_ERROR,
                                                                  "Expiration date can not be less than current date.",
                                                                  null));
                }
            }
        } catch (SQLException sqle) {
        }
    }

    public static String getDate(Calendar cal) {
        return "" + cal.get(Calendar.DATE) + "/" + (cal.get(Calendar.MONTH) + 1) + "/" + cal.get(Calendar.YEAR);
    }

    public String actionResetOrderLineSicdPrintStatus()
    {
        try
        {
            String docType = "OC";
                        
            if(bookTabBinding.isDisclosed())
                docType = "BOOK";
            if(sqcTabBinding.isDisclosed())
                docType = "SQC";
            
           OperationBinding resetOrderPrintStatusOp = IriAdfUtils.findOperation("resetDocumentPrintStatus");
            resetOrderPrintStatusOp.getParamsMap().put("resetFor", "L");
            resetOrderPrintStatusOp.getParamsMap().put("docType", docType);
            resetOrderPrintStatusOp.execute();
            
            if (resetOrderPrintStatusOp.getResult() != null && resetOrderPrintStatusOp.getResult().toString().equals("Y")) 
            {
                OperationBinding commitOp = IriAdfUtils.findOperation("Commit");
                commitOp.execute();
                
                IriJsfUtils.addFormattedFacesErrorMessage("Document Print Status Successfully reset !", "",
                                                          FacesMessage.SEVERITY_INFO);
            } else {
                IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while resetting document print status. " +
                                                            " Please contact your System Administrator." ,
                                                          "",
                                                          FacesMessage.SEVERITY_ERROR);
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while resetting document print status. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        
        return null;
    }

    public void setSqcTabBinding(RichShowDetailItem sqcTabBinding) {
        this.sqcTabBinding = sqcTabBinding;
    }

    public RichShowDetailItem getSqcTabBinding() {
        return sqcTabBinding;
    }

    public void setOcTabBinding(RichShowDetailItem ocTabBinding) {
        this.ocTabBinding = ocTabBinding;
    }

    public RichShowDetailItem getOcTabBinding() {
        return ocTabBinding;
    }

    public void setBookTabBinding(RichShowDetailItem bookTabBinding) {
        this.bookTabBinding = bookTabBinding;
    }

    public RichShowDetailItem getBookTabBinding() {
        return bookTabBinding;
    }

    public void ocCapacityVCL(ValueChangeEvent valueChangeEvent) //throws ValidatorException
    {
        try 
        {
           if (valueChangeEvent.getNewValue() != null &&
                valueChangeEvent.getNewValue().toString().trim().length() > 0) 
           {
                OperationBinding vldtOcCapacityOp = IriAdfUtils.findOperation("validateDuplicateOcCapacity");
                vldtOcCapacityOp.getParamsMap().put("capacityName", valueChangeEvent.getNewValue().toString());
                vldtOcCapacityOp.execute();

                if (vldtOcCapacityOp.getResult() != null &&
                    vldtOcCapacityOp.getResult().toString().equalsIgnoreCase("Y")) 
                {
                    IriJsfUtils.addFormattedFacesErrorMessage("Record already exists. Please select any other Capacity !",
                                                              "", FacesMessage.SEVERITY_ERROR);
                    ocCapacityBinding.setValid(false);
                    ocCapacityBinding.setValue(null);
                    ocCapacityBinding.resetValue();
                    AdfFacesContext.getCurrentInstance().addPartialTarget(ocCapacityBinding);
                }
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while validating Capacity. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void ocFunctionVCL(ValueChangeEvent valueChangeEvent)
    {
        try 
        {
           if (valueChangeEvent.getNewValue() != null &&
                valueChangeEvent.getNewValue().toString().trim().length() > 0) 
           {
                OperationBinding vldtOcFunctionOp = IriAdfUtils.findOperation("validateDuplicateOcFunction");
                vldtOcFunctionOp.getParamsMap().put("functionName", valueChangeEvent.getNewValue().toString());
                vldtOcFunctionOp.execute();

                if (vldtOcFunctionOp.getResult() != null &&
                    vldtOcFunctionOp.getResult().toString().equalsIgnoreCase("Y")) 
                {
                    IriJsfUtils.addFormattedFacesErrorMessage("Record already exists. Please select any other Function !",
                                                              "", FacesMessage.SEVERITY_ERROR);
                    ocFunctionBinding.setValid(false);
                    ocFunctionBinding.setValue(null);
                    ocFunctionBinding.resetValue();
                    AdfFacesContext.getCurrentInstance().addPartialTarget(ocFunctionBinding);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while validating Function. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void setOcCapacityBinding(RichInputListOfValues ocCapacityBinding) {
        this.ocCapacityBinding = ocCapacityBinding;
    }

    public RichInputListOfValues getOcCapacityBinding() {
        return ocCapacityBinding;
    }

    public void setOcFunctionBinding(RichInputListOfValues ocFunctionBinding) {
        this.ocFunctionBinding = ocFunctionBinding;
    }

    public RichInputListOfValues getOcFunctionBinding() {
        return ocFunctionBinding;
    }

    public void resetDocPrintStatusDL(DialogEvent dialogEvent)
    {
        try
        {
            if(dialogEvent.getOutcome() != null && (dialogEvent.getOutcome().toString().equalsIgnoreCase("ok")
                || dialogEvent.getOutcome().toString().equalsIgnoreCase("yes")))
            {
                String docType = "OC";
                            
                if(bookTabBinding.isDisclosed())
                    docType = "BOOK";
                if(sqcTabBinding.isDisclosed())
                    docType = "SQC";
                
                OperationBinding printDocOp = IriAdfUtils.findOperation("printSeafarerIndividualDocument");
                printDocOp.getParamsMap().put("printFor", "L");
                printDocOp.getParamsMap().put("docType", docType);
                printDocOp.execute();

                if (printDocOp.getErrors().isEmpty()) 
                {
                    if (printDocOp.getResult() != null && printDocOp.getResult().toString().length() > 1) 
                    {
                        IriJsfUtils.addFormattedFacesErrorMessage(printDocOp.getResult().toString(), "",
                                                                  FacesMessage.SEVERITY_INFO);
                    }
                } else {
                    IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while printing selected document. " +
                                                              " Please contact your System Administrator.", "",
                                                              FacesMessage.SEVERITY_ERROR);
                }
            }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while printing selected document. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
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

    public String actionOpenGenericTc()
    {
        try
        {
            OperationBinding openGenericTcOp = IriAdfUtils.findOperation("setGenericTcParameters");
            openGenericTcOp.getParamsMap().put("calledFrom", "EditDocuments");
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

    public void ocDetailsTabDisclosureListener(DisclosureEvent disclosureEvent)
    {
        try
        {
            OperationBinding refreshOcDetailsOp = IriAdfUtils.findOperation("refreshTabDetails");
            refreshOcDetailsOp.getParamsMap().put("refreshFor", "OC");
            refreshOcDetailsOp.execute();
            
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while opening OC Details tab. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void sqcDetailsTabDisclosureListener(DisclosureEvent disclosureEvent)
    {
        try
        {
            OperationBinding refreshSqcDetailsOp = IriAdfUtils.findOperation("refreshTabDetails");
            refreshSqcDetailsOp.getParamsMap().put("refreshFor", "SQC");
            refreshSqcDetailsOp.execute();
            
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while opening SQC Details tab. " +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }
}
