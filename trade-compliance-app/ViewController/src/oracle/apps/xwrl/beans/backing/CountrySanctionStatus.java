package oracle.apps.xwrl.beans.backing;

import com.rmi.manualtradecompliance.utils.ADFUtils;

import com.rmi.manualtradecompliance.utils.IRIUtils;
import com.rmi.manualtradecompliance.utils.JSFUtils;

import java.util.ArrayList;


import oracle.adf.model.BindingContext;
import oracle.adf.model.OperationBinding;
import oracle.adf.model.binding.DCBindingContainer;
import oracle.adf.model.binding.DCIteratorBinding;

import oracle.adf.view.rich.component.rich.RichQuery;
import oracle.adf.view.rich.component.rich.data.RichTable;

import oracle.adf.view.rich.component.rich.layout.RichPanelSplitter;


import oracle.binding.BindingContainer;

import oracle.jbo.Key;
import oracle.jbo.Row;
import oracle.jbo.RowSetIterator;

import oracle.jbo.SortCriteria;

import org.apache.myfaces.trinidad.event.SortEvent;
import org.apache.myfaces.trinidad.model.SortCriterion;


public class CountrySanctionStatus 
{
    IRIUtils utils = new IRIUtils();
    private RichTable table;
    private RichQuery qry;
    
   
    
    
   
    
    public void search() 
           {
               
               RichPanelSplitter ps = null;
               try 
               {
                   ps = (RichPanelSplitter) JSFUtils.findComponentInRoot("pscss");
                   ps.setCollapsed(false);
                   utils.refreshComponent(ps); 
                   
               } catch (Exception e) 
               {
                   utils.displayErrorMessage("Error displaying the search panel: "+e);
               }
                    
           }
       
       public void reset() 
       {
           OperationBinding ops = null;
           RichPanelSplitter ps = null;
           try 
           {
               // Clear view object
               ops = (OperationBinding) ADFUtils.findOperation("clearVC");
               ops.invoke();
              
               // Clear table filter and table sort criteria
               utils.resetTable("t1");
               
               utils.resetSort(table,"SicdCountriesView1Iterator");
               
               utils.resetTableFilterAction(table);
       
               // Refresh view XwrlParametersView1Iterator
               utils.refreshTable("SicdCountriesView1Iterator","t1");
               
               ps = (RichPanelSplitter) JSFUtils.findComponentInRoot("pscss");
               ps.setCollapsed(true);
               utils.refreshComponent(ps);
       
               //Refresh page
               utils.refreshComponent(qry);
               utils.refreshComponent(table);
               
           } catch (Exception e) 
           {
               utils.displayErrorMessage("Error during Reset: "+e); 
           }
       }
       
    public void resetSort()
           {
               // get the binding container
               try 
               {
                   BindingContainer bindings = BindingContext.getCurrent().getCurrentBindingsEntry();
                   DCBindingContainer dcBindings = (DCBindingContainer) bindings;
                   RichTable table = this.getTable();
                   table.queueEvent(new SortEvent(table, new ArrayList<SortCriterion>()));
                   DCIteratorBinding iterBind = (DCIteratorBinding) dcBindings.get("SicdCountriesView1Iterator");
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
               } catch (Exception e) 
               {
                   // TODO: Add catch code
                   e.printStackTrace();
               }
           }
    
    
    
    public void cancel() 
    {
        OperationBinding ops = null;
        
        DCBindingContainer dcBindingContainer = null;
        DCIteratorBinding oiter = null;
        try 
        {
            
                ops = (OperationBinding) ADFUtils.findOperation("Execute");
                ops.invoke(); 
               
                utils.refreshComponent(table);
                
                utils.displaySuccessMessage("Sanction Status info cancelled");
        } catch (Exception e) 
        {
            utils.displayErrorMessage("Error cancelling sanction status info: "+e); 
        }
    }
    
    public void save() 
        {
            OperationBinding ops = null;
            
            DCBindingContainer dcBindingContainer = null;
            DCIteratorBinding oiter = null;
            try 
            {
                
               
                    ops = (OperationBinding) ADFUtils.findOperation("Commit");
                    ops.invoke(); 
                
                    ops = (OperationBinding) ADFUtils.findOperation("Execute");
                    ops.invoke(); 
                    
                   
                    utils.refreshComponent(table);
                    
                    utils.displaySuccessMessage("Sanction Status Saved Successfully");
               
                
               
                
            } catch (Exception e) 
            {
                utils.displayErrorMessage("Error Saving sanction status information: "+e); 
            }
        }
    
    

  public void setTable(RichTable table)
  {
    this.table = table;
  }

  public RichTable getTable()
  {
    return table;
  }

  public void setQry(RichQuery qry)
  {
    this.qry = qry;
  }

  public RichQuery getQry()
  {
    return qry;
  }
}



