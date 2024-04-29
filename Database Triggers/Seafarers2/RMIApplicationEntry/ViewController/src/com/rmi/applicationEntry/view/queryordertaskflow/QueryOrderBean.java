package com.rmi.applicationEntry.view.queryordertaskflow;

import com.rmi.applicationEntry.view.utils.ADFUtils;

import javax.faces.application.FacesMessage;
import javax.faces.event.ActionEvent;

import oracle.adf.model.BindingContext;
import oracle.adf.view.rich.component.rich.input.RichInputText;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

public class QueryOrderBean {
    private RichInputText orderNumberBinding;

    public QueryOrderBean() {
    }

    public void setOrderNumberBinding(RichInputText orderNumberBinding) {
        this.orderNumberBinding = orderNumberBinding;
    }

    public RichInputText getOrderNumberBinding() {
        return orderNumberBinding;
    }
    public BindingContainer getBindings(){
            return BindingContext.getCurrent().getCurrentBindingsEntry();
        }
    public void searchMethod(ActionEvent actionEvent) {
//       System.out.println(orderNumberBinding.getValue().toString().length());
        try {
            Integer order_number = null;
            if (orderNumberBinding.getValue() != null) {
                if (orderNumberBinding.getValue().toString().length() > 0) {
                    order_number = Integer.parseInt(orderNumberBinding.getValue().toString());

                    OperationBinding ob = getBindings().getOperationBinding("searchQueryOrder");
                    ob.getParamsMap().put("orderNumber", order_number);
                    ob.execute();
                    
                    OperationBinding ob1 = getBindings().getOperationBinding("queryOrderFound");
                    //        ob.getParamsMap().put("orderNumber", order_number);
                  String found =  ob1.execute().toString();
                  if(found.equalsIgnoreCase("notfound"))
                  {
                          ADFUtils.addFormattedFacesErrorMessage("No match found with given order number." +
                          "" , 
                          "", FacesMessage.SEVERITY_ERROR);  
                      }
                }
            }
        } catch (NumberFormatException nfe) {
            ADFUtils.addFormattedFacesErrorMessage("Please enter a valid value." +
            "Only numeric value is allowed." , 
            "", FacesMessage.SEVERITY_ERROR);
            nfe.printStackTrace();
        }
    }

    public void resetButton(ActionEvent actionEvent) {
            orderNumberBinding.resetValue();
            orderNumberBinding.setValue(null);
        OperationBinding ob = getBindings().getOperationBinding("searchQueryOrder");
//        ob.getParamsMap().put("orderNumber", order_number);
        ob.execute();    }
}
