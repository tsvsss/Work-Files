package oracle.apps.xwrl.beans.backing;

import com.rmi.manualtradecompliance.utils.ADFUtils;

import com.rmi.manualtradecompliance.utils.IRIUtils;

import java.math.BigDecimal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.util.Map;

import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;

import oracle.adf.share.ADFContext;


import oracle.apps.xwrl.model.am.AppModuleImpl;

import oracle.jbo.Row;
import oracle.jbo.ViewCriteria;
import oracle.jbo.ViewObject;

public class InitialiseUploadDocument {
    public InitialiseUploadDocument() {
        super();
    }
    
    IRIUtils utils = new IRIUtils();
    public void onload() 
        {
        System.out.println("InitialiseUploadDocument:onload");
            AppModuleImpl am = null;
          
            try 
            {
                
                am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
               
                FacesContext fctx = FacesContext.getCurrentInstance();
                ExternalContext ectx = fctx.getExternalContext();
                Map m = ectx.getRequestParameterMap();
                
                am.executeRequestView(utils.nullStrToSpc(m.get("requestId")));
                
                System.out.println("Type in init upload document:: "+  m.get("path"));
                
                applyFilterToCaseDocuments(am);
                    
                ADFContext.getCurrent().getPageFlowScope().put("Type", m.get("path"));
                
            } catch (Exception e) {
                // TODO: Add catch code
                e.printStackTrace();
            }
            
        }
    
    private void applyFilterToCaseDocuments(AppModuleImpl am){
        System.out.println("applyFilterToCaseDocuments started");
        try{
            String masterId=null;
            String aliasId=null;
            String xrefId=null;
            
            Row r=am.getXwrlRequestsView1().getCurrentRow();
            Object masterIdObj=r.getAttribute("MasterId");
            Object aliasIdObj=r.getAttribute("AliasId");
            Object xrefIdObj=r.getAttribute("XrefId");
            if(masterIdObj != null)
                masterId=((BigDecimal)masterIdObj).intValue()+"";
            if(aliasIdObj != null)
                aliasId=((BigDecimal)aliasIdObj).intValue()+"";
            if(xrefIdObj != null)
            xrefId=((BigDecimal)xrefIdObj).intValue()+"";
            
            
            
            String sq = "select RMI_OWS_COMMON_UTIL.get_master_id(?,?,?) from dual";
            PreparedStatement st =  am.getDBTransaction().createPreparedStatement(sq, 0);
            
            System.out.println("masterId.intValue():"+masterId);
            System.out.println("aliasId.intValue():"+aliasId);
            System.out.println("xrefId.intValue():"+xrefId);
            st.setString(1, masterId);
            st.setString(2, aliasId);
            st.setString(3,xrefId);

            ResultSet rs=st.executeQuery();
            if(rs.next()){
                Object origMasterId=rs.getObject(1);
                System.out.println("getAllCaseDocuments:origMasterId:"+origMasterId);
            ViewObject vo=am.getXwrlCaseDocumentsSumView1();
                //vo.setWhereClause(" ORIG_MASTER_ID="+origMasterId.toString());
                ViewCriteria vc=vo.getViewCriteriaManager().getViewCriteria("XwrlCaseDocumentsSumViewCriteria1");
                vc.ensureVariableManager().setVariableValue("p_origMasterId", new BigDecimal(origMasterId.toString()));
                vo.applyViewCriteria(vc);
            vo.executeQuery();
            }
                
            
        }catch(Exception e){
            e.printStackTrace();
        }
    }
}
