package com.rmi.applicationEntry.view.craprocessingtaskflow;

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

import oracle.adf.view.rich.component.rich.input.RichSelectBooleanCheckbox;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

import org.apache.myfaces.trinidad.render.ExtendedRenderKitService;
import org.apache.myfaces.trinidad.util.Service;

public class CraProcessingBean {
    private RichPopup emailPopup;

    public CraProcessingBean() {
    }
    public BindingContainer getBindings(){
            return BindingContext.getCurrent().getCurrentBindingsEntry();
        }
  
    public void createCraBatchButton(ActionEvent actionEvent) {
        try {
            OperationBinding val = getBindings().getOperationBinding("validateCraLines");
          String res =  val.execute().toString();
            
            if(res.equalsIgnoreCase("success"))
            {
            
            OperationBinding ob = getBindings().getOperationBinding("createcrabatch");
            ob.execute();
            FacesMessage Message = new FacesMessage("Create CRA Batch Done.");
            Message.setSeverity(FacesMessage.SEVERITY_INFO);
            FacesContext fc = FacesContext.getCurrentInstance();
            fc.addMessage(null, Message);
            }
            else
            {
                    FacesMessage Message = new FacesMessage("Please select at least one line.");
                    Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);    
                }
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while creating cra." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
    }
    private void showPopup(RichPopup pop, boolean visible) {
            try {
                FacesContext context = FacesContext.getCurrentInstance();
                if (context != null && pop != null) {
                    String popupId = pop.getClientId(context);
                    if (popupId != null) {
                        StringBuilder script = new StringBuilder();
                        script.append("var popup = AdfPage.PAGE.findComponent('").append(popupId).append("'); ");
                        if (visible) {
                            script.append("if (!popup.isPopupVisible()) { ").append("popup.show();}");
                        } else {
                            script.append("if (popup.isPopupVisible()) { ").append("popup.hide();}");
                        }
                        ExtendedRenderKitService erks =
                            Service.getService(context.getRenderKit(), ExtendedRenderKitService.class);
                        erks.addScript(context, script.toString());
                    }
                }
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }
    public void batchEmailCraButton(ActionEvent actionEvent) {
        try {
            OperationBinding val = getBindings().getOperationBinding("validateCraLines");
            String res =  val.execute().toString();
            if(res.equalsIgnoreCase("success"))
            {
            OperationBinding ob = getBindings().getOperationBinding("batchEmailCra");
            ob.execute();
            showPopup(emailPopup, true);
            }
            else
            {
                    FacesMessage Message = new FacesMessage("Please select at least one line.");
                    Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);      
                }
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while creating email for cra." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
    }

    public void setEmailPopup(RichPopup emailPopup) {
        this.emailPopup = emailPopup;
    }

    public RichPopup getEmailPopup() {
        return emailPopup;
    }

    public void sendButtonOnPopup(ActionEvent actionEvent) {
        try {
            OperationBinding ob1 = getBindings().getOperationBinding("validateSendCra");
           String val = ob1.execute().toString();
            if(val.equalsIgnoreCase("false"))
            {
            OperationBinding ob = getBindings().getOperationBinding("sendCRAMailButton");
            ob.execute();
            emailPopup.hide();
            FacesMessage Message = new FacesMessage("CRA Document Sent to Agent.");
            Message.setSeverity(FacesMessage.SEVERITY_INFO);
            FacesContext fc = FacesContext.getCurrentInstance();
            fc.addMessage(null, Message);
            }
            else
            {
                    FacesMessage Message = new FacesMessage("Please enter destination email address.");
                    Message.setSeverity(FacesMessage.SEVERITY_ERROR);
                    FacesContext fc = FacesContext.getCurrentInstance();
                    fc.addMessage(null, Message);   
                
                }
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while sending email." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
    }

    public void cancelButtonOnEmailPopup(ActionEvent actionEvent) {
emailPopup.hide();    }
    public String getApplicationUrl()
       {
           FacesContext facesCtx = FacesContext.getCurrentInstance();
           ExternalContext ectx = facesCtx.getExternalContext();
           HttpServletRequest req = (HttpServletRequest) ectx.getRequest();
           String url = req.getRequestURL().toString();
           return (url.substring(0, url.length() - req.getRequestURI().length()) + req.getContextPath());
       }


    public void viewCraButton(ActionEvent actionEvent) {
        OperationBinding ob = getBindings().getOperationBinding("cpyCraFile");
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
//            System.out.println(ADFContext.getCurrent().getSessionScope().get("ServletGlobalParam").toString()+"---11");
            
                    FacesContext context = FacesContext.getCurrentInstance();
                           context.getExternalContext().getSessionMap().put("userid", res);
            
                    sb.append("winPop = window.open(\"" +
                    getApplicationUrl()+"/seaf/previewdocumentservlet?path=" + "-1" +
                    "\", \"_blank\"); ");
                    ExtendedRenderKitService erks =
                        Service.getRenderKitService(FacesContext.getCurrentInstance(), ExtendedRenderKitService.class);
                    StringBuilder script = new StringBuilder();
                    script.append(sb.toString());
                    erks.addScript(FacesContext.getCurrentInstance(), script.toString());
                } catch (Exception e) {
                    e.printStackTrace();
                    ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading log file." +
                                                           " Please contact your System Administrator.", "",
                                                           FacesMessage.SEVERITY_ERROR);
                }       }

    public void selectValueChangeListener(ValueChangeEvent valueChangeEvent) {
        valueChangeEvent.getComponent().processUpdates(FacesContext.getCurrentInstance());
                                                                                      
        OperationBinding ob = getBindings().getOperationBinding("deselectCraProcessing");
       String res = ob.execute().toString();
       if(res.equalsIgnoreCase("reject"))
       {
               ADFUtils.addFormattedFacesErrorMessage("A CRA cannot be approved untill Trade Compliance has been approved." +
                                                      "", "",
                                                      FacesMessage.SEVERITY_ERROR);     
           }

    }
}
