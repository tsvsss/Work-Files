package com.rmi.applicationEntry.view.requestsubmittaskflow;

import com.rmi.applicationEntry.view.utils.ADFUtils;

import javax.faces.application.FacesMessage;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;

import javax.faces.event.ValueChangeEvent;

import javax.servlet.http.HttpServletRequest;

import oracle.adf.model.BindingContext;

import oracle.adf.share.ADFContext;
import oracle.adf.view.rich.component.rich.RichPopup;

import oracle.adf.view.rich.event.PopupFetchEvent;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

import org.apache.myfaces.trinidad.render.ExtendedRenderKitService;
import org.apache.myfaces.trinidad.util.Service;

public class RequestSubmissionBean {
    private RichPopup requestSubmitPopupBinding;

    public RequestSubmissionBean() {
    }
    public BindingContainer getBindings(){
            return BindingContext.getCurrent().getCurrentBindingsEntry();
        }
    public void searchButton(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("searchRequestDeatailView");
            ob.execute();
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while searching data." +
            "Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void resetButton(ActionEvent actionEvent) {
        // Add event code here...
        try {
            OperationBinding ob = getBindings().getOperationBinding("resetRequestSearchform");
            ob.execute();
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading data." +
            "Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void submitButton(ActionEvent actionEvent) {
                try {
                    OperationBinding validate = getBindings().getOperationBinding("validateRequestSubmit");
                    String valid = validate.execute().toString();
                    if(valid.equalsIgnoreCase("yes"))
                    {
                    OperationBinding ob = getBindings().getOperationBinding("submitRequest");
                   String res = ob.execute().toString();
                    requestSubmitPopupBinding.hide();


                        OperationBinding search = getBindings().getOperationBinding("searchRequestDeatailViewOnSubmission");
                        search.getParamsMap().put("RequestId", res);
                        search.execute();

                    FacesMessage Message = new FacesMessage("Request Submitted Successfully! Request Id - "+res);
                    Message.setSeverity(FacesMessage.SEVERITY_INFO);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);
                    }
                    else
                    {
                            FacesMessage Message = new FacesMessage("Please select a request.");
                            Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                            FacesContext fc = FacesContext.getCurrentInstance();
                            fc.addMessage(null, Message);    
                        }
                } catch (Exception e) {
                    e.printStackTrace();
                    ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while submitting request." +
                    "Please contact your System Administrator." , 
                    "", FacesMessage.SEVERITY_ERROR);
                }
            }
    String LogLink;

    public void setLogLink(String LogLink) {
        this.LogLink = LogLink;
    }

    public String getLogLink() {
         return "D:\\Testin.req";
    }

    public void setRequestSubmitPopupBinding(RichPopup requestSubmitPopupBinding) {
        this.requestSubmitPopupBinding = requestSubmitPopupBinding;
    }

    public RichPopup getRequestSubmitPopupBinding() {
        return requestSubmitPopupBinding;
    }

    public void viewLogActionListener(ActionEvent actionEvent) {
        
        OperationBinding ob = getBindings().getOperationBinding("copyLogFile");
        String res = ob.execute().toString();
        try 
                {
                    ///faces/Statusboard?BatchId=#{backingBeanScope.VettingBean.PBatchId}
                    StringBuffer sb = new StringBuffer();
                    sb.append("var winPop = true;");
//                    sb.append("winPop = window.open(\"" +
//                              ge/faces/Statusboard?BatchId=" "); ");
//            sb.append("winPop = window.open(\""+getApplicationUrl()+"/seaf/previewdocumentservlet?path=D:\\Testin.req);"); 
            
            
//                           ADFContext.getCurrent().getSessionScope().put("ServletGlobalParam", res);  
                    FacesContext context = FacesContext.getCurrentInstance();
                           context.getExternalContext().getSessionMap().put("userid", res);
            
                    sb.append("winPop = window.open(\"" +
                    getApplicationUrl()+"/seaf/previewdocumentservlet?path=" + "-3" +
                    "\", \"_blank\"); ");
                    ExtendedRenderKitService erks =
                        Service.getRenderKitService(FacesContext.getCurrentInstance(), ExtendedRenderKitService.class);
                    StringBuilder script = new StringBuilder();
                    script.append(sb.toString());
                    erks.addScript(FacesContext.getCurrentInstance(), script.toString());
                } catch (Exception e) {
                    e.printStackTrace();
                    ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading log file." +
                                                           "Please contact your System Administrator.", "",
                                                           FacesMessage.SEVERITY_ERROR);
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

    public void viewOutputActionListener(ActionEvent actionEvent) {
        OperationBinding ob = getBindings().getOperationBinding("copyOutFile");
        String res = ob.execute().toString();
        try 
                {
                    ///faces/Statusboard?BatchId=#{backingBeanScope.VettingBean.PBatchId}
                    StringBuffer sb = new StringBuffer();
                    sb.append("var winPop = true;");
        //                    sb.append("winPop = window.open(\"" +
        //                              ge/faces/Statusboard?BatchId=" "); ");
        //            sb.append("winPop = window.open(\""+getApplicationUrl()+"/seaf/previewdocumentservlet?path=D:\\Testin.req);");
            
            
//        ADFContext.getCurrent().getSessionScope().put("ServletGlobalParam", res);  
                                FacesContext context = FacesContext.getCurrentInstance();
                           context.getExternalContext().getSessionMap().put("userid", res);
            
                    sb.append("winPop = window.open(\"" +
                    getApplicationUrl()+"/seaf/previewdocumentservlet?path=" + "-2" +
                    "\", \"_blank\"); ");
                    ExtendedRenderKitService erks =
                        Service.getRenderKitService(FacesContext.getCurrentInstance(), ExtendedRenderKitService.class);
                    StringBuilder script = new StringBuilder();
                    script.append(sb.toString());
                    erks.addScript(FacesContext.getCurrentInstance(), script.toString());
                } catch (Exception e) {
                    e.printStackTrace();
                    ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading log file." +
                                                           "Please contact your System Administrator.", "",
                                                           FacesMessage.SEVERITY_ERROR);
                }       }

    public void selectRequestValueChangeListener(ValueChangeEvent valueChangeEvent) {
            valueChangeEvent.getComponent().processUpdates(FacesContext.getCurrentInstance());
        if(valueChangeEvent.getNewValue() != null)
        {
        OperationBinding ob = getBindings().getOperationBinding("selectRequestValueChange");
        ob.getParamsMap().put("newValue", valueChangeEvent.getNewValue().toString());
         ob.execute();    
        }}

    public void requestPopupFetchListener(PopupFetchEvent popupFetchEvent) {
        OperationBinding ob = getBindings().getOperationBinding("requestSubmitFetchListener");
        ob.execute();    }
}

