package oracle.apps.xwrl.view.utils;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;

import oracle.adf.controller.ControllerContext;
import oracle.adf.controller.ViewPortContext;

public class ErrorHandler {
    public ErrorHandler() {
        super();
    }
    
    public void controllerExceptionHandler() {
        ControllerContext context = ControllerContext.getInstance();
        ViewPortContext currentRootViewPort = context.getCurrentRootViewPort();
        Exception exceptionData = currentRootViewPort.getExceptionData();
        
        if (currentRootViewPort.isExceptionPresent()) 
        {
            exceptionData.printStackTrace();
            currentRootViewPort.clearException();
            
            System.out.println("exceptionData.getMessage()::"+ exceptionData.getMessage());
          
            FacesContext facesContext = FacesContext.getCurrentInstance();
            facesContext.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_ERROR, exceptionData.getMessage(), null));
        }
    }
}

