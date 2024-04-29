package oracle.apps.xwrl.beans.view;


import com.rmi.manualtradecompliance.utils.ADFUtils;

import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;

import javax.servlet.ServletContext;

import oracle.adf.model.binding.DCBindingContainer;
import oracle.adf.share.logging.ADFLogger;



import oracle.binding.OperationBinding;

import org.apache.myfaces.trinidad.event.ReturnEvent;

public class AppView {
    
    public String DBNAME;
    public String APPNAME;   
    
    private static ADFLogger LOGGER = ADFLogger.createADFLogger(AppView.class);
    
    public AppView() {
    }

    public void setDBNAME(String DBNAME) {
        this.DBNAME = DBNAME;
    }

    public String getDBNAME() {
        LOGGER.finest("getDBNAME");
        DCBindingContainer bc = ADFUtils.getDCBindingContainer();
        OperationBinding oper = (OperationBinding) bc.get("getDatabaseName");
        String dbName = (String) oper.execute();
        return dbName;
        //return DBNAME;
    }

    public void setAPPNAME(String APPNAME) {
        this.APPNAME = APPNAME;
    }

    public String getAPPNAME() {
        LOGGER.finest("getAPPNAME");
        FacesContext fctx = FacesContext.getCurrentInstance();
        ExternalContext ectx = fctx.getExternalContext();
        ServletContext servletContext = (ServletContext) ectx.getContext();
        String appName = null;
        appName = servletContext.getInitParameter("oracle.apps.xwrl.view.APPLICATION_NAME");
        return appName;
        //return APPNAME;
    }
    
    public void dialogReturnListener(ReturnEvent returnEvent) {
      //BindingContext bc = BindingContext.getCurrent();
      //DCBindingContainer dcb = (DCBindingContainer)bc.getCurrentBindingsEntry();
      //DCIteratorBinding iter = dcb.findIteratorBinding("XwrlCaseDocumentsView2Iterator");
      //iter.executeQuery();
      //RequestContext.getCurrentInstance().addPartialTarget(returnEvent.getComponent().getParent().getParent());
    }
    
}
