package com.rmi.applicationEntry.view.findseafarertaskflow;

import com.rmi.applicationEntry.view.utils.ADFUtils;

import javax.faces.application.FacesMessage;
import javax.faces.event.ActionEvent;

import oracle.adf.model.BindingContext;
import oracle.adf.view.rich.component.rich.input.RichInputDate;
import oracle.adf.view.rich.component.rich.input.RichInputText;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

public class FindSeafarerBean {
    private RichInputDate dateOfBirthBind;

    public FindSeafarerBean() {
    }
    private RichInputText seafarerIdBinding;

    public void setSeafarerIdBinding(RichInputText seafarerIdBinding) {
        this.seafarerIdBinding = seafarerIdBinding;
    }

    public RichInputText getSeafarerIdBinding() {
        return seafarerIdBinding;
    }

    public void setSeafarerNameBinding(RichInputText seafarerNameBinding) {
        this.seafarerNameBinding = seafarerNameBinding;
    }

    public RichInputText getSeafarerNameBinding() {
        return seafarerNameBinding;
    }
    private RichInputText seafarerNameBinding;
    public BindingContainer getBindings(){
            return BindingContext.getCurrent().getCurrentBindingsEntry();
        }
    public void findButtonActionListener(ActionEvent actionEvent) {
//        System.out.println(seafarerIdBinding.getValue()+"---------111");
//        System.out.println(seafarerNameBinding.getValue()+"---------111");
        try {
           
            OperationBinding ob = getBindings().getOperationBinding("find_seafarer");
            ob.getParamsMap().put("esi_id", null);
            ob.getParamsMap().put("sea_name", null);
            ob.getParamsMap().put("birth_date", null);
            ob.execute();
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while searching seafarer." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
        
    }

    public void setDateOfBirthBind(RichInputDate dateOfBirthBind) {
        this.dateOfBirthBind = dateOfBirthBind;
    }

    public RichInputDate getDateOfBirthBind() {
        return dateOfBirthBind;
    }

    public void clearSearch(ActionEvent actionEvent) {
        OperationBinding ob = getBindings().getOperationBinding("clearFindSeafarerSearch");
        ob.execute();    }
}
