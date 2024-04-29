package oracle.apps.xwrl.beans.backing;

import com.rmi.manualtradecompliance.utils.ADFUtils;
import com.rmi.manualtradecompliance.utils.IRIUtils;

import com.rmi.manualtradecompliance.utils.JSFUtils;

import java.util.Map;

import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;

import oracle.adf.model.binding.DCIteratorBinding;

import oracle.apps.xwrl.beans.session.UserRespAndSessionInfo;
import oracle.apps.xwrl.model.am.AppModuleImpl;

import oracle.jbo.server.ViewObjectImpl;

public class InitialiseStatusboard {
    public InitialiseStatusboard() {
        super();
    }
    
    IRIUtils utils = new IRIUtils();
    public void onload() 
        {
             AppModuleImpl am = null;
          
            try 
            {
                FacesContext fctx = FacesContext.getCurrentInstance();
                ExternalContext ectx = fctx.getExternalContext();
                Map m = ectx.getRequestParameterMap();
                System.out.println("OWS BatchId:"+m.get("BatchId"));
                String status="O";
//                if(m.get("Status") != null && "Closed".equals(m.get("Status")))
//                    status = "C";
                am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
                
                
                // tsuazo 20230130 T20230124.0035 - Statusboard - Performance Issues
                // Replace logic
                //am.getXwrlRequestsView1().ensureVariableManager().setVariableValue("pBatchId",m.get("BatchId"));
                //am.getXwrlRequestsView1().ensureVariableManager().setVariableValue("pStatus",status);                
                //am.getXwrlRequestsView1().executeQuery();                
                //System.out.println("Query2::"+ am.getXwrlRequestsView1().getQuery());                
                //System.out.println("Estimated Row count2::"+ am.getXwrlRequestsView1().getEstimatedRowCount());

                // Test logic - hard code
                //am.getXwrlRequestsView1().setWhereClause("case_status= 'O'");
                //am.getXwrlRequestsView1().setOrderByClause("BATCH_ID desc, CREATION_DATE desc FETCH FIRST 250 ROWS ONLY");
                
                // Tuning logic - update VO
                //am.getXwrlRequestsView1().setNamedWhereClauseParam("pCaseStatus",status);
                
                
                // tsuazo - Moved from OwsStatusboard.java as it was called multiple times
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
                DCIteratorBinding binding = ADFUtils.findIterator("XwrlRequestsView1Iterator");
                ViewObjectImpl vo = (ViewObjectImpl) binding.getViewObject();
                vo.setWhereClause("NVL(Case_state, 'Xx') != 'D'");
                //vo.setOrderByClause("BATCH_ID desc, CREATION_DATE desc FETCH FIRST 100 ROWS ONLY");
                //System.out.println("OwsStatusboard::"+ vo.getQuery()); 
                //vo.executeQuery();
                //System.out.println("Row Count:"+vo.getEstimatedRowCount());
                }
                
                
                am.getXwrlRequestsView1().ensureVariableManager().setVariableValue("pBatchId",m.get("BatchId"));
                am.getXwrlRequestsView1().ensureVariableManager().setVariableValue("pStatus",status);  
                //System.out.println("onload::"+ am.getXwrlRequestsView1().getQuery());                                
                am.getXwrlRequestsView1().executeQuery();               
                //System.out.println("Query1::"+ am.getXwrlRequestsView1().getQuery());                                
                System.out.println("Estimated Row count1::"+ am.getXwrlRequestsView1().getEstimatedRowCount());
                
            } catch (Exception e) {
                // TODO: Add catch code
                e.printStackTrace();
            }
            
        }
}
