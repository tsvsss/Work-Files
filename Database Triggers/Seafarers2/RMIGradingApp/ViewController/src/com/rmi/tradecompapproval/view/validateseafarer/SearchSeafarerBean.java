package com.rmi.tradecompapproval.view.validateseafarer;

import com.rmi.tradecompapproval.utils.IriAdfUtils;

import com.rmi.tradecompapproval.utils.IriJsfUtils;

import java.io.OutputStream;

import java.util.List;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.faces.event.ValueChangeEvent;

import oracle.adf.controller.ControllerContext;
import oracle.adf.controller.ViewPortContext;

import oracle.adf.model.BindingContext;
import oracle.adf.model.binding.DCIteratorBinding;
import oracle.adf.share.ADFContext;

import oracle.adf.view.rich.component.rich.data.RichTable;
import oracle.adf.view.rich.context.AdfFacesContext;
import oracle.adf.view.rich.event.QueryEvent;
import oracle.adf.view.rich.model.AttributeCriterion;
import oracle.adf.view.rich.model.ConjunctionCriterion;
import oracle.adf.view.rich.model.Criterion;
import oracle.adf.view.rich.model.FilterableQueryDescriptor;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

import oracle.jbo.Key;
import oracle.jbo.Row;

public class SearchSeafarerBean {
    private RichTable searchSeafarerTableBind;

    public SearchSeafarerBean() {
    }

    public String actionUseSeafarer() 
    {
        try 
        {
            OperationBinding countSeafarerSelected = IriAdfUtils.findOperation("countSeafarerSelected");
            String countCheck = countSeafarerSelected.execute().toString();
            
             if(countCheck.equalsIgnoreCase("multiple"))
             {
                 IriJsfUtils.addFormattedFacesErrorMessage("Please select only one Seafarer." +
                                                                 "" , 
                                                               "", FacesMessage.SEVERITY_ERROR);  
             }
            else
             {
                OperationBinding fltrSfrOp = IriAdfUtils.findOperation("filterUseSeafarerVO");
                fltrSfrOp.execute();
                
                Object useSelected = ADFContext.getCurrent().getPageFlowScope().get("P_USE_SELECTED_SEAFARER");
                
                if(useSelected != null && useSelected.toString().equalsIgnoreCase("NotSelected"))
                {
                    IriJsfUtils.addFormattedFacesErrorMessage("Please select 1 Seafarer to continue." , 
                                                              "", FacesMessage.SEVERITY_ERROR);
                }
                else
                    return "useSeafarer";
             }
        } catch (Exception e) {
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception on selection." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }

    public String actionCancelSeafarerNotFound() 
    {
        try 
        {
            System.out.println("inside actionCancelSeafarerNotFound");
                        
            OperationBinding cnclSfrOp = IriAdfUtils.findOperation("cancelSeafarerNotFound");
            cnclSfrOp.execute();
            
            
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception on cancel." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        
        return "cancelSeafarerNotFound";
    }

    public void useSelectedSeafarerVCL(ValueChangeEvent valueChangeEvent) 
    {        
        try 
        {            
            if (valueChangeEvent.getNewValue() != null &&
                (valueChangeEvent.getNewValue().toString().equalsIgnoreCase("true") ||
                 valueChangeEvent.getNewValue().toString().equalsIgnoreCase("Y"))) {
//                valueChangeEvent.getComponent().processDecodes(FacesContext.getCurrentInstance());
//                OperationBinding unchkOp = IriAdfUtils.findOperation("unselectOtherSeafarers");
//                unchkOp.execute();
            }
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception on Selection." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public BindingContainer getBindings() {
        return BindingContext.getCurrent().getCurrentBindingsEntry();
    }
    
    public Key getCurrentRowKey(String iteratorName)
    {
        if(iteratorName != null)
        {
            BindingContainer bindings = getBindings();
            DCIteratorBinding parentIter = (DCIteratorBinding) bindings.get(iteratorName);
            Key rowKey = parentIter.getCurrentRow().getKey();
            parentIter.setCurrentRowWithKey(rowKey.toStringFormat(true));
            
            if(rowKey != null)
                return rowKey;
        }
        return null;
    }    

    public void setCurrentRowKey(String iteratorName, Key rowKey)
    {
        if(iteratorName != null && rowKey != null)
        {
            BindingContainer bindings = getBindings();
            DCIteratorBinding parentIter = (DCIteratorBinding) bindings.get(iteratorName);
            parentIter.setCurrentRowWithKey(rowKey.toStringFormat(true));
        }
    }
    
    public void exceptionHandler()
    {
//        System.out.println("inside ViewBatchTF exceptionHandler");
        ControllerContext ctx = ControllerContext.getInstance();
        ViewPortContext viewprt = ctx.getCurrentViewPort();

        if (viewprt.isExceptionPresent())
        {
            Exception exc = viewprt.getExceptionData();
            IriJsfUtils.addFormattedFacesErrorMessage("There has been exception while performing this task. ", exc.getMessage(), FacesMessage.SEVERITY_ERROR);
        }
    }

    public void setSearchSeafarerTableBind(RichTable searchSeafarerTableBind) {
        this.searchSeafarerTableBind = searchSeafarerTableBind;
    }

    public RichTable getSearchSeafarerTableBind() {
        return searchSeafarerTableBind;
    }

    public void cancelSeafarerNotFoundAL(ActionEvent actionEvent)
    {
        if(getSearchSeafarerTableBind() != null)
        {
            System.out.println("inside cancelSeafarerNotFoundAL");
            
            FilterableQueryDescriptor queryDescriptor = (FilterableQueryDescriptor) getSearchSeafarerTableBind().getFilterModel();
            if (queryDescriptor != null && queryDescriptor.getFilterConjunctionCriterion() != null) {
                ConjunctionCriterion cc = queryDescriptor.getFilterConjunctionCriterion();
                List<Criterion> lc = cc.getCriterionList();
                for (Criterion c : lc) {
                    if (c instanceof AttributeCriterion) {
                        AttributeCriterion ac = (AttributeCriterion) c;
                        ac.setValue(null);
                    }
                }
                getSearchSeafarerTableBind().queueEvent(new QueryEvent(getSearchSeafarerTableBind(), queryDescriptor));
            }
        }        
    }

    public void additionalFilterSearchAL(ActionEvent actionEvent)
    {
        try 
        {
            OperationBinding additionalFilterSearchOp = IriAdfUtils.findOperation("additionalFilterSearch");
            additionalFilterSearchOp.execute();
            
            if(searchSeafarerTableBind != null)
                AdfFacesContext.getCurrentInstance().addPartialTarget(searchSeafarerTableBind);
            
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception on Additional Filter Search." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void additionalFilterResetAL(ActionEvent actionEvent)
    {
        try 
        {
            OperationBinding additionalFilterResetOp = IriAdfUtils.findOperation("additionalFilterReset");
            additionalFilterResetOp.execute();
            
            if(searchSeafarerTableBind != null)
                AdfFacesContext.getCurrentInstance().addPartialTarget(searchSeafarerTableBind);
            
        } catch (Exception e) {
            e.printStackTrace();
            IriJsfUtils.addFormattedFacesErrorMessage("System encountered an exception on Additional Filter Reset." +
                                                        " Please contact your System Administrator." , 
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void fileDownloadListener(FacesContext facesContext, OutputStream outputStream) 
    {
        DCIteratorBinding searchSfrrVo = IriAdfUtils.findIterator("SearchSeafarerRO1Iterator");
        
        if(searchSfrrVo != null)
        {
            Row currentRow = searchSfrrVo.getCurrentRow();
            
            if(currentRow != null && currentRow.getAttribute("Photo") != null)
            {
                System.out.println("seafarer photo :: "+currentRow.getAttribute("Photo"));
                IriJsfUtils.downloadFile(currentRow.getAttribute("Photo").toString(), outputStream);                
            }
        }        
    }
}
