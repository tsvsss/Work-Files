package  com.rmi.manualtradecompliance.utils;


import com.rmi.manualtradecompliance.adfbc.services.RMIManualTradeComplianceAppModuleImpl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.Serializable;
import java.io.StringWriter;
import java.io.Writer;

import java.math.BigDecimal;

import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import java.util.Map;

import javax.el.ELContext;
import javax.el.ExpressionFactory;

import javax.el.ValueExpression;

import javax.faces.application.Application;
import javax.faces.application.FacesMessage;

import javax.faces.application.ViewHandler;
import javax.faces.component.UIComponent;
import javax.faces.component.UIViewRoot;
import javax.faces.context.FacesContext;

import oracle.adf.model.BindingContext;
import oracle.adf.model.OperationBinding;
import oracle.adf.model.binding.DCBindingContainer;
import oracle.adf.model.binding.DCIteratorBinding;
import oracle.adf.share.ADFContext;
import oracle.adf.view.rich.component.rich.data.RichTable;
import oracle.adf.view.rich.component.rich.data.RichTreeTable;
import oracle.adf.view.rich.context.AdfFacesContext;

import oracle.adf.view.rich.event.QueryEvent;
import oracle.adf.view.rich.model.AttributeCriterion;
import oracle.adf.view.rich.model.ConjunctionCriterion;
import oracle.adf.view.rich.model.Criterion;
import oracle.adf.view.rich.model.FilterableQueryDescriptor;

import oracle.apps.xwrl.model.am.AppModuleImpl;

import oracle.binding.BindingContainer;

import oracle.jbo.Key;
import oracle.jbo.Row;
import oracle.jbo.RowSetIterator;
import oracle.jbo.SortCriteria;
import oracle.jbo.ViewObject;
import oracle.jbo.uicli.binding.JUCtrlListBinding;

import org.apache.commons.io.IOUtils;
import org.apache.myfaces.trinidad.event.SortEvent;
import org.apache.myfaces.trinidad.model.SortCriterion;
import org.apache.myfaces.trinidad.model.UploadedFile;
import org.apache.myfaces.trinidad.render.ExtendedRenderKitService;
import org.apache.myfaces.trinidad.util.Service;


public class IRIUtils implements Serializable{
    @SuppressWarnings("compatibility:-2969619708224722338")
    private static final long serialVersionUID = 1L;

    public IRIUtils() {
        super();
    }
    
    /**
     *  Method scrolls the table to top.
     *  @param table binding of the table.
     *  @param iter instance of DCIteratorBinding.
     **/
    public void setTableScroll(RichTable table, DCIteratorBinding iter) 
    {       
        try 
        {
            Row row = iter.getCurrentRow();
            if (row != null) {
                Key key = row.getKey();
                ArrayList<Object> tableList = new ArrayList<Object>();
                tableList.add(key);
                table.setScrollTopRowKey(tableList);
            } else {
                table.setScrollTop(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while scrolling the table." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }
    
    /**
     *  Method resets all the filter criteria of the table.
     *  @param table binding of the table.
     **/
    public void resetTableFilterAction(RichTable table) 
    {
        try 
        {
            FilterableQueryDescriptor queryDescriptor = (FilterableQueryDescriptor) table.getFilterModel();
            if (queryDescriptor != null && queryDescriptor.getFilterConjunctionCriterion() != null) {
                ConjunctionCriterion cc = queryDescriptor.getFilterConjunctionCriterion();
                List<Criterion> lc = cc.getCriterionList();
                for (Criterion c : lc) {
                    if (c instanceof AttributeCriterion) {
                        AttributeCriterion ac = (AttributeCriterion) c;
                        ac.setValue(null);
                    }
                }
                table.queueEvent(new QueryEvent(table, queryDescriptor));
            }
        } catch (Exception e) {
            e.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while resetting table filter." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }
    
    /**
     *  Method resets sorting the table.
     *  @param table binding of the table.
     *  @param iterName name of DCIteratorBinding.
     **/        
    public void resetSort(RichTable table,String iterName)
    {
                // get the binding container
            try {
                BindingContainer bindings = BindingContext.getCurrent().getCurrentBindingsEntry();
                DCBindingContainer dcBindings = (DCBindingContainer) bindings;
                //RichTable table = this.getStatusboardTable();
                table.queueEvent(new SortEvent(table, new ArrayList<SortCriterion>()));
                DCIteratorBinding iterBind = (DCIteratorBinding) dcBindings.get(iterName);
                Key currentRow = null;
                Row row = iterBind.getCurrentRow();
                if (row != null)
                    currentRow = row.getKey();
                SortCriteria[] sc = new SortCriteria[0];
                iterBind.applySortCriteria(sc); // iterBind is the iterator the table uses
                iterBind.executeQuery();
                if (currentRow != null)
                {
                   // iterBind.setCurrentRowWithKey(currentRow.toStringFormat(true));
                }
            } catch (Exception e) {
                e.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while resetting table sorting." +
                                                 "Please contact your System Administrator." , 
                                                 "", FacesMessage.SEVERITY_ERROR);
            }
    }
    
    /**
     *  Method resolves the expression passed and returns it's value.
     *  @param data whole expression.
     *  @return Object returns value of expression.
     **/  
    public Object resolvEl(String data) 
    {
            FacesContext fc = FacesContext.getCurrentInstance();
            Application app = fc.getApplication();
            ExpressionFactory elFactory = app.getExpressionFactory();
            ELContext elContext = fc.getELContext();
            ValueExpression valueExp = elFactory.createValueExpression(elContext, data, Object.class);
            Object Message = valueExp.getValue(elContext);
            return Message;
        }
        
        /**Method to get BindingContainer of Another page ,pageUsageId is the usageId of page defined in DataBindings.cpx file
         * @param pageUsageId
         * @return
         */
        public BindingContainer getBindingsContOfOtherPage(String pageUsageId) {
            return (BindingContainer) resolvEl("#{data." + pageUsageId + "}");
        }
    
    /**
     *  Method converts and returns null String value to blank space.
     *  @param obj pass String value to be checked.
     *  @return String returns either the String value or blank space.
     **/  
    public String nullStrToSpc(Object obj) 
    {
        String spcStr = "";

        if (obj == null) 
        {
            return spcStr;
        } else 
        {
            return obj.toString();
        }
    }
    
    /**
     *  Method removes all messages shown on screen.
     **/  
    public void clearMessages() 
    {
        try {
            Iterator<FacesMessage> msgIterator = FacesContext.getCurrentInstance().getMessages();
            while (msgIterator.hasNext()) {
                msgIterator.next();
                msgIterator.remove();
            }
        } catch (Exception e) {
            e.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while clearing messages." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }

    
    /**
     *  Method returns the Stack trace of any error occurred.
     *  @param e pass the instance of Exception class.
     *  @return String returns the log of the exception generated.
     **/  
    public String returnStackTrace(Exception e) 
    {
        Writer writer = new StringWriter();
        PrintWriter printWriter = new PrintWriter(writer);
        e.printStackTrace(printWriter);
        String stackTrace = nullStrToSpc(writer);
        return stackTrace;
    }
    
    /**
     *  Method displays info type message.
     *  @param succMsg pass message to be shown.
     **/  
    public void displaySuccessMessage(String succMsg) 
       {
           FacesMessage Message = new FacesMessage(succMsg);   
           Message.setSeverity(FacesMessage.SEVERITY_INFO);   
           FacesContext fc = FacesContext.getCurrentInstance();   
           fc.addMessage(null, Message); 
       }
    
    /**
     *  Method displays error type message.
     *  @param succMsg pass message to be shown.
     **/   
       public void displayErrorMessage(String errMsg) 
       {
           FacesMessage Message = new FacesMessage(errMsg);   
           Message.setSeverity(FacesMessage.SEVERITY_ERROR);   
           FacesContext fc = FacesContext.getCurrentInstance();   
           fc.addMessage(null, Message); 
       }
    
    /**
     *  Method displays warning type message.
     *  @param succMsg pass message to be shown.
     **/   
       public void displayWarningMessage(String warnMsg) 
       {
           FacesMessage Message = new FacesMessage(warnMsg);   
           Message.setSeverity(FacesMessage.SEVERITY_WARN);   
           FacesContext fc = FacesContext.getCurrentInstance();   
           fc.addMessage(null, Message); 
       }
    
    /**
     *  Method refreshes the component passed.
     *  @param component UIComponent of the table.
     **/  
       public  void refreshComponent(UIComponent component) 
       {
           AdfFacesContext.getCurrentInstance().addPartialTarget(component);
       }
       
    // PRIVATE     
    /**
     *  Method resets all filters on the table.
     *  @param component component name of the table.
     **/     
    public void resetTable(String component) 
    {
        try 
        {
            RichTable table = null;
            FilterableQueryDescriptor queryDescriptor = null;
            ConjunctionCriterion cc = null;
            List<Criterion> lc = null;
            AttributeCriterion ac = null;


            table = (RichTable) JSFUtils.findComponentInRoot(component);
            queryDescriptor = (FilterableQueryDescriptor) table.getFilterModel();

            if (queryDescriptor != null && queryDescriptor.getFilterConjunctionCriterion() != null) {
                cc = queryDescriptor.getFilterConjunctionCriterion();
                lc = cc.getCriterionList();

                for (Criterion c : lc) {
                    if (c instanceof AttributeCriterion) {
                        ac = (AttributeCriterion) c;
                        ac.setValue(null);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while resetting table filter." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }
    
    /**
     *  Method resets sorting the table.
     *  @param iterName name of DCIteratorBinding.
     *  @param component component name of the table.
     **/  
    public void refreshTable(String iterName, String component) 
    {
        try 
        {
            DCIteratorBinding iter = null;
            RichTable table = null;
            iter = ADFUtils.findIterator(iterName);
            iter.executeQuery();
            table = (RichTable) JSFUtils.findComponentInRoot(component);
            refreshComponent(table);
        } catch (Exception e) {
            e.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while refreshing table." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }
    
    /**
     *  Method refreshes the page.
     **/  
    public  void refreshPage() 
    {
        try 
        {
            FacesContext fctx = FacesContext.getCurrentInstance();
            String refreshpage = fctx.getViewRoot().getViewId();
            ViewHandler ViewH = fctx.getApplication().getViewHandler();
            UIViewRoot UIV = ViewH.createView(fctx, refreshpage);
            UIV.setViewId(refreshpage);
            fctx.setViewRoot(UIV);
        } catch (Exception e) {
            e.printStackTrace();
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while refreshing page." +
                                             "Please contact your System Administrator." , 
                                             "", FacesMessage.SEVERITY_ERROR);
        }
    }

    /**Method to upload file to actual path on Server*/
    public static String uploadFile(InputStream inputStream, String path) {

        if (inputStream != null && (path != null && path.trim().length() > 0)) {
            System.out.println("path :: " + path);
            try {
                
                // T20221005.0018 - TC - FA - DPCF not in OWS but is in Oracle
                
                FileOutputStream out = new FileOutputStream(path);
                byte[] buffer = new byte[8192];
                int bytesRead = 0;
                while ((bytesRead = inputStream.read(buffer, 0, 8192)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
                out.flush();
                out.close();
            } catch (Exception e) {
                // handle exception
                e.printStackTrace();
            } finally {
                try {
                    if(inputStream != null)
                        inputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return path;
    }
    
    public ResultSet getPlSqlFunctionData(String query,List params){
        ResultSet rs=null;
        PreparedStatement st = null;
        RMIManualTradeComplianceAppModuleImpl am = null;
        try{
            am = (RMIManualTradeComplianceAppModuleImpl) ADFUtils.getApplicationModuleForDataControl("RMIManualTradeComplianceAppModuleDataControl");
            st = am.getDBTransaction().createPreparedStatement(query, 0);
            int index=1;
            for(Object value:params)
                st.setObject(index++,value);
            
            rs=st.executeQuery();
            
        }catch(Exception e){
            e.printStackTrace();
        }
        return rs;
    }
    
    public int updateData(String query,List params){
        PreparedStatement st = null;
        AppModuleImpl am = null;
        try{
            am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
            st = am.getDBTransaction().createPreparedStatement(query, 0);
            int index=1;
            for(Object value:params)
                st.setObject(index++,value);
            
            return st.executeUpdate();

        }catch(Exception e){
            e.printStackTrace();
        } finally {
            try {
            if(st != null)
                st.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return -1;
    }
    
    public void downloadFile(String diskPath, OutputStream outputStream) {
        try{
            File inputFile = new File(diskPath);
            if(!inputFile.exists()){
                JSFUtils.addFormattedFacesErrorMessage(inputFile.getName()+" file not existed." +
                                                       "Please contact your System Administrator.", "",
                                                       FacesMessage.SEVERITY_ERROR);
            }else{
                FileInputStream fis = new FileInputStream(inputFile);
                int n;
                byte[] b;
                while ((n = fis.available()) > 0) {
                    b = new byte[n];
                    int result = fis.read(b);
                    outputStream.write(b, 0, b.length);
                    if (result == -1)
                        break;
                }
                JSFUtils.addFormattedFacesErrorMessage("Download processing has completed." +
                                                       "", "",
                                                       FacesMessage.SEVERITY_INFO);
            }
        }catch(Exception e){
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while downloading the file." +
                                                   "Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }finally {
            try {
                outputStream.flush();
                outputStream.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
    
    public void initVersionAYear() {
        ADFContext.getCurrent().getSessionScope().put("currentYear",Calendar.getInstance().get(Calendar.YEAR)+"");
        
        ADFContext.getCurrent().getSessionScope().put("Version","11.6.5");
    }
    
    /**Helper Method to call Javascript
     * @param javascriptCode
     */
    public void writeJavaScriptToClient(String javascriptCode) {
        FacesContext facesCtx = FacesContext.getCurrentInstance();
        ExtendedRenderKitService service = Service.getRenderKitService(facesCtx, ExtendedRenderKitService.class);
        service.addScript(facesCtx, javascriptCode);
    }
    
    /**Method to open Lov popup programmatically
     * @param actionEvent
     */
    public void openInputTextLovPopupUsingJS(String id) {
        StringBuilder sb = new StringBuilder();
        //Here deartmentNameId is ID attribute of InputLov
        sb.append("var lovComp =AdfPage.PAGE.findComponent('"+id+"');");
        sb.append(" AdfLaunchPopupEvent.queue(lovComp, true);");
        writeJavaScriptToClient(sb.toString());
    }
}

