package oracle.apps.xwrl.beans.backing;

import com.rmi.manualtradecompliance.utils.ADFUtils;

import com.rmi.manualtradecompliance.utils.IRIUtils;
import com.rmi.manualtradecompliance.utils.JSFUtils;

import java.util.ArrayList;

import java.util.HashMap;
import java.util.List;

import java.util.Map;

import javax.el.ELContext;
import javax.el.ExpressionFactory;
import javax.el.ValueExpression;

import javax.faces.application.Application;
import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.faces.event.ValueChangeEvent;

import oracle.adf.model.binding.DCIteratorBinding;

import oracle.adf.share.ADFContext;
import oracle.adf.share.logging.ADFLogger;

import oracle.adf.view.rich.component.rich.input.RichSelectManyChoice;

import oracle.adf.view.rich.component.rich.input.RichSelectOneChoice;

import oracle.apps.xwrl.beans.session.UserRespAndSessionInfo;


import oracle.apps.xwrl.model.am.AppModuleImpl;

import oracle.jbo.Row;
import oracle.jbo.ViewCriteria;
import oracle.jbo.ViewObject;
import oracle.jbo.server.ViewObjectImpl;

//T20200730.0025 - Re: Statusboards (IRI)
public class Statusboard {
    private static ADFLogger LOGGER = ADFLogger.createADFLogger(Statusboard.class);
    private String savedSearch="Default";
    private List<String> stateList=new ArrayList<String>();
    private List<String> workflowList=new ArrayList<String>();
    private List<String> priorityList=new ArrayList<String>();
    private List<String> departmentList=new ArrayList<String>();
    private List<String> officeList=new ArrayList<String>();
    private List<String> docTypeList=new ArrayList<String>();
    

    public void setDocTypeList(List<String> docTypeList) {
        this.docTypeList = docTypeList;
    }

    public List<String> getDocTypeList() {
        return docTypeList;
    }
    private String statusValue="Open",caseTypeValue;

    public void setCaseTypeValue(String caseTypeValue) {
        this.caseTypeValue = caseTypeValue;
    }

    public String getCaseTypeValue() {
        return caseTypeValue;
    }


    public void setStatusValue(String statusValue) {
        this.statusValue = statusValue;
    }

    public String getStatusValue() {
        return statusValue;
    }

    public void setStateList(List<String> stateList) {
        this.stateList = stateList;
    }

    public List<String> getStateList() {
        return stateList;
    }

    public void setWorkflowList(List<String> workflowList) {
        this.workflowList = workflowList;
    }

    public List<String> getWorkflowList() {
        return workflowList;
    }

    public void setPriorityList(List<String> priorityList) {
        this.priorityList = priorityList;
    }

    public List<String> getPriorityList() {
        return priorityList;
    }

    public void setDepartmentList(List<String> departmentList) {
        this.departmentList = departmentList;
    }

    public List<String> getDepartmentList() {
        return departmentList;
    }

    public void setOfficeList(List<String> officeList) {
        this.officeList = officeList;
    }

    public List<String> getOfficeList() {
        return officeList;
    }

    public void setSavedSearch(String savedSearch) {
        this.savedSearch = savedSearch;
    }

    public String getSavedSearch() {
        return savedSearch;
    }

    public Statusboard() {
        super();
        
    }

    
    public void savedSearchValueChangeListener(ValueChangeEvent valueChangeEvent) {
        // Add event code here...
        stateList=new ArrayList<String>();
        workflowList=new ArrayList<String>();
        officeList=new ArrayList<String>();
        priorityList=new ArrayList<String>();
        departmentList=new ArrayList<String>();
        docTypeList=new ArrayList<String>();
        caseTypeValue="";
        statusValue="";        
                
        RichSelectManyChoice smc = (RichSelectManyChoice) JSFUtils.findComponentInRoot("smc1");
        smc.resetValue();
        
        smc = (RichSelectManyChoice) JSFUtils.findComponentInRoot("smc2");
        smc.resetValue();

        RichSelectOneChoice soc = (RichSelectOneChoice) JSFUtils.findComponentInRoot("soc24");
        soc = (RichSelectOneChoice) JSFUtils.findComponentInRoot("soc24");
        soc.resetValue();
        
        soc = (RichSelectOneChoice) JSFUtils.findComponentInRoot("soc25");
        soc.resetValue();
        
        smc = (RichSelectManyChoice) JSFUtils.findComponentInRoot("smc3");
        smc.resetValue();

        smc = (RichSelectManyChoice) JSFUtils.findComponentInRoot("smc4");
        smc.resetValue();

        smc = (RichSelectManyChoice) JSFUtils.findComponentInRoot("smc5");
        smc.resetValue();

        smc = (RichSelectManyChoice) JSFUtils.findComponentInRoot("smc6");
        smc.resetValue();
        
        if("TC a.m".equals(valueChangeEvent.getNewValue())){
            setValuesToCustomSearchList(1);
            doSearch(null);
        }else if("ESR".equals(valueChangeEvent.getNewValue())){
            DCIteratorBinding binding = ADFUtils.findIterator("GetCaseDocumentsLOV1Iterator");
            ViewObjectImpl vo = (ViewObjectImpl) binding.getViewObject();
            vo.applyViewCriteria(null);
            vo.executeQuery();
            setValuesToCustomSearchList(2);
            doSearch(null);
        }else  if("TC 3P".equals(valueChangeEvent.getNewValue())){
            setValuesToCustomSearchList(3);
            doSearch(null);
        }else  if("Trade".equals(valueChangeEvent.getNewValue())){
            setValuesToCustomSearchList(4);
            doSearch(null);            
            // T20210302.0032	RE: OWS - Statusboard - NRMI 
        }else  if("NRMI".equals(valueChangeEvent.getNewValue())){
                setValuesToCustomSearchList(5);
                doSearch(null);                    
        }else{
            doReset(null);
        }
    }
    
    public void doReset(ActionEvent actionEvent) {
        // Add event code here...
        stateList=new ArrayList<String>();
        workflowList=new ArrayList<String>();
        officeList=new ArrayList<String>();
        priorityList=new ArrayList<String>();
        departmentList=new ArrayList<String>();
        docTypeList=new ArrayList<String>();
        caseTypeValue="";
        statusValue="";
        DCIteratorBinding binding = ADFUtils.findIterator("XwrlRequestsView1Iterator");
        ViewObjectImpl vo = (ViewObjectImpl) binding.getViewObject();
        ViewCriteria criteria = vo.getViewCriteria("StatusboardCriteria");
        vo.applyViewCriteria(criteria);
        vo.setFullSqlMode(ViewObjectImpl.FULLSQL_MODE_AUGMENTATION);
        vo.clearCache();

        UserRespAndSessionInfo userRespAndSessionInfo = (UserRespAndSessionInfo) JSFUtils.getManagedBeanValue("sessionScope.UserRespAndSessionInfo");
        String superUsr= "";
        String readMode = "";
        
        if(userRespAndSessionInfo!=null)
        {
        superUsr  = userRespAndSessionInfo.getIsSuperUserOnly();
        readMode  = userRespAndSessionInfo.getIsReadOnly();
        }
               
        //T20200902.0016 - Some Case ID Being Marked "Delete" (IRI)
        if(superUsr.equals("N") || userRespAndSessionInfo == null){        
        vo.setWhereClause("NVL(Case_state, 'Xx') != 'D'");
        //vo.setOrderByClause("BATCH_ID desc, CREATION_DATE desc FETCH FIRST 100 ROWS ONLY");
        }

        LOGGER.finest("doReset::"+ vo.getQuery()); 
        vo.executeQuery();
        LOGGER.finest("Row Count:"+vo.getEstimatedRowCount());
    }
    
    private void setValuesToCustomSearchList(int ch){          

        stateList=new ArrayList<String>();
        workflowList=new ArrayList<String>();
        officeList=new ArrayList<String>();
        priorityList=new ArrayList<String>();
        departmentList=new ArrayList<String>();
        docTypeList=new ArrayList<String>();
        caseTypeValue="";
        statusValue="";
        
        switch(ch){
        case 1:       
            //TC a.m
            stateList.add("N");
            stateList.add("ACT");
            
            statusValue="Open";
            
            workflowList.add("L");
            workflowList.add("PP");
            
            officeList.add("GV");
            officeList.add("HG");
            officeList.add("IT");
            officeList.add("L");
            officeList.add("P");
            officeList.add("B");
            officeList.add("RN");
            officeList.add("Z");
            
            LOGGER.finest("stateList:"+stateList.size());
            LOGGER.finest("workflowList:"+workflowList.size());
            LOGGER.finest("priorityList:"+priorityList.size());
            LOGGER.finest("officeList:"+officeList.size());
            LOGGER.finest("docTypeList:"+docTypeList.size());
            
            break;
        
        case 2:
            //ESR
            stateList.add("N");
            stateList.add("ACT");
            
            statusValue="Open";
            
            workflowList.add("L");
            workflowList.add("PP");
            
            docTypeList.add("ESR");
            
            //T20200917.0025 - OWS - ESR Search (IRI)
            caseTypeValue="Individual";
            
            LOGGER.finest("stateList:"+stateList.size());
            LOGGER.finest("workflowList:"+workflowList.size());
            LOGGER.finest("priorityList:"+priorityList.size());
            LOGGER.finest("officeList:"+officeList.size());
            LOGGER.finest("docTypeList:"+docTypeList.size());
            
            break;
        
        case 3:
            //TC 3P
            stateList.add("N");
            stateList.add("ACT");
            
            statusValue="Open";
            
            workflowList.add("L");
            workflowList.add("PP");
            
            priorityList.add("3");  
            
            officeList.add("AZ");
            officeList.add("DC");
            officeList.add("UA");
            officeList.add("FL");
            officeList.add("HT");
            officeList.add("IJ");
            officeList.add("LC");
            officeList.add("MP");
            officeList.add("BI");
            officeList.add("NY");
            officeList.add("N");
            officeList.add("R");
            officeList.add("K");
            officeList.add("PR");
            officeList.add("T");
            officeList.add("HW");
            
            LOGGER.finest("stateList:"+stateList.size());
            LOGGER.finest("workflowList:"+workflowList.size());
            LOGGER.finest("priorityList:"+priorityList.size());
            LOGGER.finest("officeList:"+officeList.size());
            LOGGER.finest("docTypeList:"+docTypeList.size());            
            
            break;
        
        case 4:       
            
            //Trade
            stateList.add("N");
            stateList.add("ACT");
            
            statusValue="Open";
            
            workflowList.add("L");
            workflowList.add("PP");
            
            LOGGER.finest("stateList:"+stateList.size());
            LOGGER.finest("workflowList:"+workflowList.size());
            LOGGER.finest("priorityList:"+priorityList.size());
            LOGGER.finest("officeList:"+officeList.size());
            LOGGER.finest("docTypeList:"+docTypeList.size());            
            
            break;
        
        case 5:       
            //TC a.m
            stateList.add("N");
            stateList.add("ACT");
            
            statusValue="Open";
            
            workflowList.add("L");
            
            docTypeList.add("NRMI");

            break;
        
        }

    }
    
    public void doSearch(ActionEvent actionEvent) {
        // Add event code here...
        try{
            
            DCIteratorBinding binding = ADFUtils.findIterator("XwrlRequestsView1Iterator");
            ViewObjectImpl vo = (ViewObjectImpl) binding.getViewObject();
            vo.applyViewCriteria(null);
            vo.setWhereClause(null);
            String values="";
            
            //T20200902.0016 - Some Case ID Being Marked "Delete" (IRI)
            if(!isSuperUser())
                values += " AND NVL(CASE_STATE, 'Xx') != 'D'";           
            
            //LOGGER.finest("stateList:"+stateList.size());
            if(stateList != null && stateList.size() != 0)
                values = " AND CASE_STATE in "+stateList.toString().replace(", ", "','").replace("[", "('").replace("]", "')");
            
            //LOGGER.finest("workflowList:"+workflowList.size());
            if(workflowList != null && workflowList.size() != 0)
                values += " AND CASE_WORKFLOW in "+workflowList.toString().replace(", ", "','").replace("[", "('").replace("]", "')");

            //LOGGER.finest("priorityList:"+priorityList.size());                        
            if(priorityList != null && priorityList.size() != 0)
                values += " AND PRIORITY in "+priorityList.toString().replace(", ", "','").replace("[", "('").replace("]", "')");
            
            //LOGGER.finest("statusValue:"+statusValue);
            if(statusValue != null && !"".equals(statusValue))
                values += " AND CASE_STATUS = '"+((statusValue.equals("Open"))? "O" :  "C") +"'";

            //LOGGER.finest("departmentList:"+departmentList.size());
            if(departmentList != null && departmentList.size() != 0)
                values += " AND DEPARTMENT in "+departmentList.toString().replace(", ", "','").replace("[", "('").replace("]", "')");

            //LOGGER.finest("officeList:"+officeList.size());
            if(officeList != null && officeList.size() != 0)
                values += " AND OFFICE in "+officeList.toString().replace(", ", "','").replace("[", "('").replace("]", "')");

            //LOGGER.finest("docTypeList:"+docTypeList.size());            
            if(docTypeList != null && docTypeList.size() != 0)
                values += " AND DOCUMENT_TYPE in "+docTypeList.toString().replace(", ", "','").replace("[", "('").replace("]", "')");
            
            //T20200917.0025 - OWS - ESR Search (IRI)
            //LOGGER.finest("caseTypeValue:"+caseTypeValue);            
            if(caseTypeValue != null && !"".equals(caseTypeValue))
                values += " AND PATH = '"+((caseTypeValue.equals("Individual"))? "INDIVIDUAL" :  "ENTITY") +"'";

            vo.setWhereClause(" 1 = 1 "+values);
            //LOGGER.finest("Value:"+values);
            vo.setFullSqlMode(ViewObjectImpl.FULLSQL_MODE_AUGMENTATION);
            vo.clearCache();
             LOGGER.finest("doSearch::"+ vo.getQuery()); 
            vo.executeQuery();
            LOGGER.finest("Row Count:"+vo.getEstimatedRowCount());
                
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    private boolean isSuperUser(){
        UserRespAndSessionInfo userRespAndSessionInfo = (UserRespAndSessionInfo) JSFUtils.getManagedBeanValue("sessionScope.UserRespAndSessionInfo");
        String superUsr= "";
        String readMode = "";
        
        if(userRespAndSessionInfo!=null)
        {
        superUsr  = userRespAndSessionInfo.getIsSuperUserOnly();
        readMode  = userRespAndSessionInfo.getIsReadOnly();
        }
        LOGGER.finest("Superusr:"+superUsr);
        return "Y".equals(superUsr);
    }
    
    //T20220311.0012 - TC 2.0 - Saving assignments
    private IRIUtils utils = new IRIUtils();
    private List lockedIdsList =new ArrayList();
    public void assignedToValueChangeListener(ValueChangeEvent valueChangeEvent) {
        // Add event code here...
        try{
            //LOGGER.finest("valuechangeevent:"+valueChangeEvent.getNewValue());
            Map m = valueChangeEvent.getComponent().getAttributes();
            if(valueChangeEvent.getNewValue() != null && !"".equals(valueChangeEvent.getNewValue())) {
                
                //LOGGER.finest("assignedTo:"+m.get("requestId"));
                AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
                Integer userId = (Integer) ADFContext.getCurrent().getSessionScope().get("UserId");
                HashMap lckmap = am.owsRequestlock(userId, Integer.parseInt(m.get("requestId").toString()));
        
                String errmsg = utils.nullStrToSpc(lckmap.get("errMsg"));
                //LOGGER.finest("errmsg:"+errmsg);
                if ("RECORD LOCKED".equalsIgnoreCase(errmsg) || "RECORD AVAILABLE".equalsIgnoreCase(errmsg)) {
                    lockedIdsList.add(m.get("requestId"));
                }
            } else
                lockedIdsList.remove(m.get("requestId"));
            LOGGER.finest("locked Ids list:"+lockedIdsList);
        }catch(Exception e){
            e.printStackTrace();
        }
        
    }

    public void doSave(ActionEvent actionEvent) {
        // Add event code here...
        try{
            AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
            ViewObject vo = am.getRequestLockInfoView1();
            for(Object reqId:lockedIdsList) {
                LOGGER.finest("loop:"+reqId);
                vo.setNamedWhereClauseParam("pRequestId", reqId);
                vo.executeQuery();
                LOGGER.finest("size:"+vo.getRowCount());
                while(vo.hasNext())
                {
                    Row row = vo.next();
                    //LOGGER.finest(reqId+" id unlock" );
                    //LOGGER.finest(reqId+" id unlock" );
                    row.remove();
                }
            }
            lockedIdsList.clear();
            ADFUtils.findOperation("Commit").execute();
        }catch(Exception e) {
            e.printStackTrace();
        }
    }
}
