package oracle.apps.xwrl.beans.backing;

import com.rmi.manualtradecompliance.utils.ADFUtils;

import com.rmi.manualtradecompliance.utils.IRIUtils;
import com.rmi.manualtradecompliance.utils.JSFUtils;

import java.util.ArrayList;

import javax.ejb.Schedules;

import javax.faces.event.ValueChangeEvent;

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

public class Citylist 
{
    IRIUtils utils = new IRIUtils();
    private RichTable table;
    private RichQuery qry;
    
   
    
    
    public void add() 
          {
              BindingContainer bindings = null;
              DCIteratorBinding dciter = null;
              RowSetIterator rsi = null;
              Row firstRow = null;
              int firstRowIndex = 0;
              Row newRow = null;
               
               try 
               {
                      bindings = BindingContext.getCurrent().getCurrentBindingsEntry();
                      //access the name of the iterator the table is bound to. Its "allDepartmentsIterator"
                      //in this sample
                      dciter = (DCIteratorBinding) bindings.get("WcCityListView1Iterator");
                      //access the underlying RowSetIterator
                      rsi = dciter.getRowSetIterator();
                      //get handle to the last row
                      firstRow = rsi.first();
                      //obtain the index of the last row
                      firstRowIndex = rsi.getRangeIndexOf(firstRow);
                      //create a new row
                      newRow = rsi.createRow();
                      //initialize the row
                      newRow.setNewRowState(Row.STATUS_INITIALIZED);
                      //add row to last index + 1 so it becomes last in the range set
                      //rsi.insertRowAtRangeIndex(firstRowIndex, newRow);
                     
                      rsi.insertRow( newRow);
                      //make row the current row so it is displayed correctly
                      rsi.setCurrentRow(newRow);
                   
                   
                    
                  } catch (Exception e) 
                  {
                      utils.displayErrorMessage("Error adding City: "+e);
                  }
           
          }
       
    
    public void search() 
           {
               
               RichPanelSplitter ps = null;
               try 
               {
                   ps = (RichPanelSplitter) JSFUtils.findComponentInRoot("pscl");
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
               
               utils.resetSort(table,"WcCityListView1Iterator");
               
               utils.resetTableFilterAction(table);
       
               // Refresh view XwrlParametersView1Iterator
               utils.refreshTable("WcCityListView1Iterator","t1");
               
               ps = (RichPanelSplitter) JSFUtils.findComponentInRoot("pscl");
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
                   DCIteratorBinding iterBind = (DCIteratorBinding) dcBindings.get("WcCityListView1Iterator");
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
                
              /* dcBindingContainer = (DCBindingContainer) utils.getBindingsContOfOtherPage("view_txndocsPageDef");
               oiter = dcBindingContainer.findIteratorBinding("TxnTypesLovIterator");
               oiter.executeQuery(); */
               
                utils.refreshComponent(table);
                
                utils.displaySuccessMessage("Parameters cancelled");
        } catch (Exception e) 
        {
            utils.displayErrorMessage("Error cancelling city info: "+e); 
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
                    
                    /*iter = ADFUtils.findIterator("EcTxnTypesView1Iterator");
                    iter.executeQuery();
                    
                    ArrayList tableRowKey = new ArrayList();
                    tableRowKey.add(iter.getCurrentRow().getKey());
                    txnTypeTable.setScrollTopRowKey(tableRowKey); 
                    
                   dcBindingContainer = (DCBindingContainer) utils.getBindingsContOfOtherPage("view_txndocsPageDef");
                   oiter = dcBindingContainer.findIteratorBinding("TxnTypesLovIterator"); 
                   oiter.executeQuery();*/
                   
                    utils.refreshComponent(table);
                    
                    utils.displaySuccessMessage("City Saved Successfully");
               
                
               
                
            } catch (Exception e) 
            {
                utils.displayErrorMessage("Error Saving City information: "+e); 
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


