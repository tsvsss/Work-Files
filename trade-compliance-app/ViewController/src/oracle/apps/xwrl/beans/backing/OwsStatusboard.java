package oracle.apps.xwrl.beans.backing;

import com.rmi.manualtradecompliance.utils.ADFUtils;
import com.rmi.manualtradecompliance.utils.IRIUtils;
import com.rmi.manualtradecompliance.utils.JSFUtils;

import java.io.PrintStream;

import java.io.UnsupportedEncodingException;

import java.sql.CallableStatement;

import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.faces.event.ActionEvent;

import java.lang.String;

import java.text.Normalizer;

import oracle.adf.model.binding.DCIteratorBinding;
import oracle.adf.share.ADFContext;
import oracle.adf.share.logging.ADFLogger;
import oracle.adf.view.rich.component.rich.RichPopup;
import oracle.adf.view.rich.component.rich.data.RichTable;
import oracle.adf.view.rich.component.rich.output.RichPanelCollection;
import oracle.adf.view.rich.context.AdfFacesContext;
import oracle.adf.view.rich.event.QueryEvent;
import oracle.adf.view.rich.event.QueryOperationEvent;
import oracle.adf.view.rich.model.AttributeCriterion;
import oracle.adf.view.rich.model.AttributeDescriptor;
import oracle.adf.view.rich.model.ConjunctionCriterion;
import oracle.adf.view.rich.model.Criterion;
import oracle.adf.view.rich.model.QueryDescriptor;

import oracle.apps.xwrl.beans.session.UserRespAndSessionInfo;
import oracle.apps.xwrl.model.am.AppModuleImpl;

import oracle.jbo.ViewCriteria;
import oracle.jbo.server.ViewObjectImpl;

import org.apache.myfaces.trinidad.event.ReturnEvent;

public class OwsStatusboard {
    private ADFLogger LOGGER=ADFLogger.createADFLogger(OwsStatusboard.class);
    private RichPopup deleteBatchPopup;


    public OwsStatusboard() 
  {
	        UserRespAndSessionInfo userRespAndSessionInfo = (UserRespAndSessionInfo) JSFUtils.getManagedBeanValue("sessionScope.UserRespAndSessionInfo");
	        String superUsr= "";
	        String readMode = "";
           
           if(userRespAndSessionInfo!=null)
	  {
	    superUsr  = userRespAndSessionInfo.getIsSuperUserOnly();
		readMode  = userRespAndSessionInfo.getIsReadOnly();
	  }
          
           if (superUsr.equals("Y")) {
                int order = 1;
                //T20200928.0036 - OWS change on the status board (IRI)
                reOrderMap.put("AssignedToAttr", order++);
                reOrderMap.put("CaseId", order++);
                reOrderMap.put("NameScreened", order++);
                reOrderMap.put("Departmentext", order++);

                reOrderMap.put("OfficeAttr", order++);
                reOrderMap.put("Priority", order++);
                reOrderMap.put("ProvisionalRequest", order++);

                reOrderMap.put("Opencnt", order++);

                //T20200730.0021 - OWS - Display Legal Review & Possible Alert Counts... (IRI)
                reOrderMap.put("LegalReviewcnt", order++);
                reOrderMap.put("Possiblecnt", order++);

                reOrderMap.put("Matches", order++);
                reOrderMap.put("Finnumber", order++);
                reOrderMap.put("CorpNumber", order++);

                reOrderMap.put("VesselIndicator", order++);
                reOrderMap.put("ImoNumber", order++);

                reOrderMap.put("Gender", order++);

                //T20200629.0034 - OWS TC - Display ESR User Details in Statusboard (IRI)
                reOrderMap.put("EsrUserEmailAddress", order++);
                reOrderMap.put("EsrUserId", order++);

                reOrderMap.put("ErbUserEmailAddress", order++);
                reOrderMap.put("ErbUserId", order++);


                reOrderMap.put("CaseStateAttr", order++);

                reOrderMap.put("CaseWorkFlowAttr", order++);
                reOrderMap.put("CaseStatusAttr", order++);
                reOrderMap.put("RiskLevel", order++);
                reOrderMap.put("PassportNumber", order++);
                reOrderMap.put("DocTypeAttr", order++);

                reOrderMap.put("DateOfBirth", order++);

                reOrderMap.put("RejectionReason", order++);

                //reOrderMap.put("RejectionAttr", 22);
                reOrderMap.put("CountryOfAddress", order++);
                reOrderMap.put("CountryOfResidence", order++);
                //reOrderMap.put("RistrictedCountryAttr", 25);

                reOrderMap.put("CityOfResidenceId", order++);
                reOrderMap.put("SubdivisionCityOfResidence", order++);
                reOrderMap.put("CountryOfNationality", order++);
                reOrderMap.put("CountryOfBirth", order++);

                reOrderMap.put("CountryOfRegistration", order++);
                reOrderMap.put("CountryOfOperation", order++);
                //T20200715.0025 - OWS Trade Compliance - Ukraine/Russia Address (IRI)
                reOrderMap.put("PermanentAddress", order++);


                reOrderMap.put("ClosedDate", order++);
                reOrderMap.put("SentToLegalBy", order++);
                reOrderMap.put("SentToLegalDate", order++);
                
                reOrderMap.put("BatchId", order++);
            }
                if ((superUsr.equals("N") && readMode.equals("Y")) || userRespAndSessionInfo == null) {
                int order = 1;
                //T20201015.0044 - OWS - Display Batch Id column at first for non tra... (IRI)
                reOrderMap.put("BatchId", order++);
                reOrderMap.put("CaseId", order++);

                reOrderMap.put("NameScreened", order++);
                reOrderMap.put("Departmentext", order++);
                reOrderMap.put("CaseWorkFlowAttr", order++);
                reOrderMap.put("Matches", order++);
                reOrderMap.put("Opencnt", order++);
                
                reOrderMap.put("OfficeAttr", order++);
                reOrderMap.put("Priority", order++);
                reOrderMap.put("ProvisionalRequest", order++);
                
                

                //T20200730.0021 - OWS - Display Legal Review & Possible Alert Counts... (IRI)
                reOrderMap.put("LegalReviewcnt", order++);
                reOrderMap.put("Possiblecnt", order++);
                
                reOrderMap.put("Finnumber", order++);
                reOrderMap.put("CorpNumber", order++);
                
                reOrderMap.put("DateOfBirth", order++);
                reOrderMap.put("Gender", order++);

                reOrderMap.put("CaseStateAttr", order++);
                

                reOrderMap.put("CaseStatusAttr", order++);
                reOrderMap.put("RiskLevel", order++);

                //T20200629.0034 - OWS TC - Display ESR User Details in Statusboard (IRI)
                reOrderMap.put("EsrUserEmailAddress", order++);
                reOrderMap.put("EsrUserId", order++);

                reOrderMap.put("ErbUserEmailAddress", order++);
                reOrderMap.put("ErbUserId", order++);

                reOrderMap.put("PassportNumber", order++);
                reOrderMap.put("DocTypeAttr", order++);


                reOrderMap.put("ImoNumber", order++);
                reOrderMap.put("VesselIndicator", order++);
                reOrderMap.put("RejectionReason", order++);

                //  reOrderMap.put("RejectionAttr", 21);
                reOrderMap.put("CountryOfAddress", order++);
                reOrderMap.put("CountryOfResidence", order++);
                //  reOrderMap.put("RistrictedCountryAttr", 24);

                reOrderMap.put("CityOfResidenceId", order++);
                reOrderMap.put("SubdivisionCityOfResidence", order++);
                reOrderMap.put("CountryOfNationality", order++);
                reOrderMap.put("CountryOfBirth", order++);

                reOrderMap.put("CountryOfRegistration", order++);
                reOrderMap.put("CountryOfOperation", order++);
                
                //T20200715.0025 - OWS Trade Compliance - Ukraine/Russia Address (IRI)
                reOrderMap.put("PermanentAddress", order++);
                reOrderMap.put("ClosedDate", order++);

                reOrderMap.put("SentToLegalBy", order++);
                reOrderMap.put("SentToLegalDate", order++);
                
                //T20201015.0044 - OWS - Display Batch Id column at first for non tra... (IRI)
                reOrderMap.put("AssignedToAttr", order++);
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
        return superUsr.equals("Y");
    }
    

    public void setStbPc(RichPanelCollection stbPc) {
        this.stbPc = stbPc;
    }

    public RichPanelCollection getStbPc() {
        return stbPc;
    }

    public void setStbPopup(RichPopup stbPopup) {
        this.stbPopup = stbPopup;
    }

    public RichPopup getStbPopup() {
        return stbPopup;
    }

    private RichTable stbTable;
    private RichPanelCollection stbPc;
    private RichPopup stbPopup;
    IRIUtils utils = new IRIUtils();

    public void setStbTable(RichTable stbTable) {
        this.stbTable = stbTable;
    }

    public RichTable getStbTable() {
        return stbTable;
    }
	
	private HashMap reOrderMap = new HashMap();

	public void setReOrderMap(HashMap reOrderMap) 
	{
		this.reOrderMap = reOrderMap;
	}

	public HashMap getReOrderMap() 
	{
		return reOrderMap;
	}
        
    public void processQuery(QueryEvent queryEvent) {
        // Add event code here...
        System.out.println("Process Query method called");
        QueryDescriptor descriptor = queryEvent.getDescriptor();

        ConjunctionCriterion conCrit = descriptor.getConjunctionCriterion();
            //access the list of search fields
            List<Criterion> criterionList = conCrit.getCriterionList();
            //iterate over the attributes to find FromDate and ToDate
            for (Criterion criterion : criterionList) {
                AttributeDescriptor attrDescriptor = ((AttributeCriterion)criterion).getAttribute();
                
                //String name = attrDescriptor.getName();
                if("inputText".equals(attrDescriptor.getComponentType().name())){
                    System.out.println("inputText Match found");
                    
                    String attrName = attrDescriptor.getName().toString();
                    Object attrVal;
                    System.out.println("attrName: "+attrName);
                    //NameScreened
                    Object currentVal;
                    attrVal = ((AttributeCriterion) criterion).getValues().get(0);                      
                    System.out.println("attrVal: "+attrVal);
                    
                    if ("NameScreened".equals(attrName) && attrVal != null) {
                      currentVal =  Normalizer.normalize(attrVal.toString(), Normalizer.Form.NFD).replaceAll("[^\\p{ASCII}]", "");                          
                    } else {
                      currentVal = ((AttributeCriterion) criterion).getValues().get(0);
                    }
                                        
                    System.out.println("CurrentValue:"+currentVal+":");
                    if(currentVal != null)
                        ((AttributeCriterion) criterion).setValue(currentVal.toString().trim());
                }
                

            }
        JSFUtils.invokeMethodExpression("#{bindings.StatusboardCriteriaQuery.processQuery}", Object.class, QueryEvent.class, queryEvent);
        
        AppModuleImpl am = null;
        am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
        System.out.println("count::" + am.getXwrlRequestsView1().getEstimatedRowCount());
        
    }


    public void resetSearch(QueryOperationEvent event) {
        try {
            AppModuleImpl am = null;
            ViewCriteria vc = null;
            System.out.println("Operation name: " + event.getOperation().name());
            if (!"MODE_CHANGE".equalsIgnoreCase(event.getOperation().name().toUpperCase())) {
                


                if ("RESET".equalsIgnoreCase(event.getOperation().name().toUpperCase())) {
                    am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");

                    vc = am.getXwrlRequestsView1().getViewCriteria("StatusboardCriteria");

                    System.out.println("Reset start time: " + new Date());
                    vc.resetCriteria();

                    am.getXwrlRequestsView1().ensureVariableManager().setVariableValue("pBatchId", null);
                    am.getXwrlRequestsView1().executeQuery();

                    System.out.println("count::" + am.getXwrlRequestsView1().getEstimatedRowCount());

                }
                /*else if("CRITERION_UPDATE".equalsIgnoreCase(event.getOperation().name())){
                    QueryDescriptor descriptor = event.getDescriptor();

                    ConjunctionCriterion conCrit = descriptor.getConjunctionCriterion();
                        //access the list of search fields
                        List<Criterion> criterionList = conCrit.getCriterionList();
                        //iterate over the attributes to find FromDate and ToDate
                        for (Criterion criterion : criterionList) {
                            AttributeDescriptor attrDescriptor = ((AttributeCriterion)criterion).getAttribute();
                            
                            //String name = attrDescriptor.getName();
                            if("inputText".equals(attrDescriptor.getComponentType().name())){
                                System.out.println("inputText Match found");
                                Object currentVal = ((AttributeCriterion) criterion).getValues().get(0);
                                System.out.println("CurrentValue:"+currentVal+":");
                                if(currentVal != null)
                                    ((AttributeCriterion) criterion).setValue(currentVal.toString().trim());
                            }
                            

                        }
                        
                }*/

            }


        } catch (Exception e) {
            utils.displayErrorMessage("Error during Reset of Search terms: " + e);
            System.out.println("Error while Reset of Query Search terms: " + utils.returnStackTrace(e));
        }
    }
    
    public void openScrnReqPopup() 
        {
            try {
            RichPopup.PopupHints hints = null;
            DCIteratorBinding iter = null;

            hints = new RichPopup.PopupHints();
            getStbPopup().show(hints);

            iter = ADFUtils.findIterator("ScreeningRequestViewIterator");
            iter.getViewObject().setNamedWhereClauseParam("pScreenReqId", ADFContext.getCurrent().getPageFlowScope().get("pScreenReqId"));    
            iter.getViewObject().executeQuery();
        } catch (Exception e) {
            // TODO: Add catch code
            e.printStackTrace();
        }
        }

    public void scrRetrunListener(ReturnEvent evt) 
    {
        try {
            DCIteratorBinding iter = null;
            iter = ADFUtils.findIterator("OwsStatusboardViewIterator");
            iter.executeQuery();
            
            AdfFacesContext.getCurrentInstance().addPartialTarget(stbPc);
            
                    } catch (Exception e) {
            // TODO: Add catch code
            e.printStackTrace();
        }
    }

    
    public void batchDeleteActionListener(ActionEvent actionEvent) {
        // Add event code here...
        ADFContext.getCurrent().getPageFlowScope().put("deleteBatchId", actionEvent.getComponent().getAttributes().get("batchId"));
        deleteBatchPopup.show(new RichPopup.PopupHints());
        System.out.println("deleteBatchId"+ADFContext.getCurrent().getPageFlowScope().get("deleteBatchId"));
    }
    
   

    public void batchDeleteConfirmedActionListener(ActionEvent actionEvent) {
        // Add event code here...
            CallableStatement st = null;
            String sq = null;
            AppModuleImpl am = null;
            String batchId=ADFContext.getCurrent().getPageFlowScope().get("deleteBatchId").toString();
        UserRespAndSessionInfo userRespAndSessionInfo = (UserRespAndSessionInfo) JSFUtils.getManagedBeanValue("sessionScope.UserRespAndSessionInfo");
            try 
            {
                am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");

                sq = "begin rmi_ows_common_util.delete_batch(p_batch_id => :1, p_user_id => :2); end;";
                st =  am.getDBTransaction().createCallableStatement(sq, 0);

                st.setString(1, batchId);
                st.setInt(2,userRespAndSessionInfo.getUserId());
                boolean b=st.execute();
                System.out.println("Result:"+b);
                new IRIUtils().displaySuccessMessage(batchId+" Batch deleted.");
                
            }catch(Exception e){
                e.printStackTrace();
            }
        DCIteratorBinding binding = ADFUtils.findIterator("XwrlRequestsView1Iterator");
        binding.getViewObject().reset();     
        
        ADFUtils.findOperation("Execute").execute();
        deleteBatchPopup.hide();
        
    }

    public void setDeleteBatchPopup(RichPopup deleteBatchPopup) {
        this.deleteBatchPopup = deleteBatchPopup;
    }

    public RichPopup getDeleteBatchPopup() {
        return deleteBatchPopup;
    }

    public void deleteBatchNoActionListener(ActionEvent actionEvent) {
        // Add event code here...
        
        deleteBatchPopup.hide();
    }


    
}
