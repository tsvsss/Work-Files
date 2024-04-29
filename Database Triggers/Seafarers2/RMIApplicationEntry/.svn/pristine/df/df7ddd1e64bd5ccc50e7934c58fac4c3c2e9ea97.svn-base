package com.rmi.applicationEntry.view.accountstatustaskflow;

import com.rmi.applicationEntry.view.utils.ADFUtils;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;

import oracle.adf.model.BindingContext;

import oracle.adf.view.rich.component.rich.RichPopup;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

public class AccountStatusBean {
    private RichPopup searchInvoicePopup;

    public AccountStatusBean() {
    }

    public BindingContainer getBindings() {
        return BindingContext.getCurrent().getCurrentBindingsEntry();
    }

    public void emailInvoiceButton(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("email_invoice");
            ob.execute();

            FacesMessage Message = new FacesMessage("Email sent successfully.");
            Message.setSeverity(FacesMessage.SEVERITY_INFO);
            FacesContext fc = FacesContext.getCurrentInstance();
            fc.addMessage(null, Message);
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while sending invoice." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
                        e.printStackTrace();
        }
    }

    public String searchInvoiceAction() 
    {
        try 
        {
            OperationBinding vldtSearchInvoiceOp = getBindings().getOperationBinding("validateSearchInvoice");
            vldtSearchInvoiceOp.execute();

            if (vldtSearchInvoiceOp.getResult() != null &&
                vldtSearchInvoiceOp.getResult().toString().equalsIgnoreCase("Y")) {
                OperationBinding searchInvoiceOp = getBindings().getOperationBinding("searchInvoice");
                searchInvoiceOp.execute();
                searchInvoicePopup.hide();
            } else
                ADFUtils.addFormattedFacesErrorMessage("Please enter at least 1 search parameter.", "",
                                                       FacesMessage.SEVERITY_WARN);
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while Searching Invoice." +
                                          " Please contact your System Administrator.", "", FacesMessage.SEVERITY_ERROR);
        }
        
        return null;
    }

    public String cancelInvoiceAction() {
        // Add event code here...
        return null;
    }

    public void setSearchInvoicePopup(RichPopup searchInvoicePopup) {
        this.searchInvoicePopup = searchInvoicePopup;
    }

    public RichPopup getSearchInvoicePopup() {
        return searchInvoicePopup;
    }
}
