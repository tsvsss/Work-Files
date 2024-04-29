package oracle.apps.xwrl.beans.backing;

import com.rmi.manualtradecompliance.utils.ADFUtils;
import com.rmi.manualtradecompliance.utils.IRIUtils;

import java.sql.Date;

import java.text.DateFormat;
import java.text.SimpleDateFormat;

import oracle.adf.model.BindingContext;
import oracle.adf.model.OperationBinding;
import oracle.adf.model.binding.DCIteratorBinding;
import oracle.adf.share.ADFContext;

import oracle.apps.xwrl.model.am.AppModuleImpl;

import oracle.binding.BindingContainer;

public class UpdateParameters 
{
    public UpdateParameters() 
    {
        super();
        onload();
    }
    
    IRIUtils utils = new IRIUtils();
    
    public void onload() 
    {
        DCIteratorBinding iter = null;    
        BindingContainer bindings = null;
        String ipParam = "";
        String val = "";
        
        ipParam = utils.nullStrToSpc(ADFContext.getCurrent().getPageFlowScope().get("ipParam"));
        
        if("Add".equalsIgnoreCase(ipParam))
        {
           
            System.out.println("Add");
            setValXml(val);
        }
        else
        {
            
             bindings = BindingContext.getCurrent().getCurrentBindingsEntry();
             iter = (DCIteratorBinding) bindings.get("XwrlParametersView1Iterator");
             
             val = utils.nullStrToSpc(iter.getCurrentRow().getAttribute("Valxml"));
            setEditValXml(val);
            System.out.println("Edit");
        }
        
    }

    public void setIdVal(String idVal) {
        this.idVal = idVal;
    }

    public String getIdVal() {
        return idVal;
    }

    public void setKeyVal(String keyVal) {
        this.keyVal = keyVal;
    }

    public String getKeyVal() {
        return keyVal;
    }

    public void setValString(String valString) {
        this.valString = valString;
    }

    public void setValDate(Date valDate) {
        this.valDate = valDate;
    }

    public Date getValDate() {
        return valDate;
    }

    public String getValString() {
        return valString;
    }

   

    public void setValClob(String valClob) {
        this.valClob = valClob;
    }

    public String getValClob() {
        return valClob;
    }

    private String valXml;
    private String editValXml;

    public void setEditValXml(String editValXml) {
        this.editValXml = editValXml;
    }

    public String getEditValXml() {
        return editValXml;
    }
    private String idVal;
    private String keyVal;
    private String valString;
    private Date valDate;
    private String valClob;
    
    

    public void setValXml(String valXml) {
        this.valXml = valXml;
    }

    public String getValXml() {
        return valXml;
    }
    
    public void save() 
    {
        String ipParam = "";
        AppModuleImpl am = null;
        DCIteratorBinding iter = null;    
        BindingContainer bindings = null;
        String id = "";
        String key = "";
        String xmlString = "";
        java.sql.Date xmldate = null;
        String xmlclob = "";
        String errorMsg = "";
        
        try 
        {
            am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
            ipParam = utils.nullStrToSpc(ADFContext.getCurrent().getPageFlowScope().get("ipParam"));

            bindings = BindingContext.getCurrent().getCurrentBindingsEntry();
            iter = (DCIteratorBinding) bindings.get("XwrlParametersView1Iterator");
            
            if(iter.getCurrentRow()!=null && !"Add".equalsIgnoreCase(ipParam))
            {

                id = utils.nullStrToSpc(iter.getCurrentRow().getAttribute("Id"));
                key = utils.nullStrToSpc(iter.getCurrentRow().getAttribute("Key1"));
                xmlString = utils.nullStrToSpc(iter.getCurrentRow().getAttribute("ValueString"));
                
                System.out.println("Value Date::"+ iter.getCurrentRow().getAttribute("ValueDate"));
                
                if(!"".equals(utils.nullStrToSpc(iter.getCurrentRow().getAttribute("ValueDate"))))
                {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
                    java.util.Date date = sdf.parse(utils.nullStrToSpc(iter.getCurrentRow().getAttribute("ValueDate")));
                    java.sql.Date sqlDate  = new Date(date.getTime());
                    
                    DateFormat outputFormat = new SimpleDateFormat("dd-MMM-yyyy");
                    String outputString = outputFormat.format(sqlDate);
                    
                    SimpleDateFormat sdf1 = new SimpleDateFormat("dd-MMM-yyyy");
                    java.util.Date date1 = sdf1.parse(outputString);
                    xmldate = new Date(date1.getTime());      
                   //xmldate = java.sql.Date.valueOf(utils.nullStrToSpc(iter.getCurrentRow().getAttribute("ValueDate")));
                }
                
                xmlclob = utils.nullStrToSpc(iter.getCurrentRow().getAttribute("ValueClob"));
                
                errorMsg = am.saveParameters(ipParam, id, key, xmlString, xmldate, editValXml, xmlclob);
            }


            if("Add".equalsIgnoreCase(ipParam)) 
            {
                id = idVal;
                key = keyVal;
                xmlString = valString;
                xmldate = valDate;
                xmlclob = valClob;
                
                errorMsg = am.saveParameters(ipParam, id, key, xmlString, xmldate, valXml, xmlclob);
            }
            
            System.out.println("mode::"+ipParam);
            System.out.println("id::"+id);
            System.out.println("key::"+key);
            System.out.println("xmlString::"+xmlString);
            System.out.println("xmldate::"+xmldate);
            System.out.println("xmlclob::"+xmlclob);
            System.out.println("valXml::"+valXml);

            
            
            if("SUCCESS".equals(errorMsg))
            {
                utils.displaySuccessMessage("Parameters saved successfully");
            }
            else 
            {
                utils.displaySuccessMessage(errorMsg);
            }
            
        } catch (Exception e) {
            // TODO: Add catch code
            e.printStackTrace();
            utils.displayErrorMessage("Error saving Parameters info: "+e); 
        }
        
        
    }
    
    
    public String cancel() 
    {
        OperationBinding ops = null;
        
        try 
        {
           // ops = (OperationBinding) ADFUtils.findOperation("Rollback");
             //   ops.invoke(); 
            
            ops = (OperationBinding) ADFUtils.findOperation("Execute");
                ops.invoke(); 
                
                utils.displaySuccessMessage("Parameters cancelled");
        } catch (Exception e) 
        {
            utils.displayErrorMessage("Error cancelling Parameters: "+e); 
        }
        
        return "Close";
    }
}
