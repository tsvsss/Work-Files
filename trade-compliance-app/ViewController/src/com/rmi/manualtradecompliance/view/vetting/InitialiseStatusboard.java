package com.rmi.manualtradecompliance.view.vetting;

import com.rmi.manualtradecompliance.adfbc.services.RMIManualTradeComplianceAppModuleImpl;
import com.rmi.manualtradecompliance.utils.ADFUtils;
import com.rmi.manualtradecompliance.utils.IRIUtils;

import com.sun.org.apache.xml.internal.security.utils.Base64;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;

import oracle.adf.share.ADFContext;

import oracle.apps.xwrl.model.am.AppModuleImpl;

public class InitialiseStatusboard {
    public InitialiseStatusboard() {
        super();
    }
    
    public void onLoad() {
        try{
          /* FacesContext fctx = FacesContext.getCurrentInstance();
            ExternalContext ectx = fctx.getExternalContext();
            Map m = ectx.getRequestParameterMap();
            Map pMap =  ADFContext.getCurrent().getPageFlowScope();
            Map sessionMap = ADFContext.getCurrent().getSessionScope();
            
            if(pMap.get("P_SOURCE_ID") == null)
               pMap.put("P_SOURCE_ID",m.get("sourceId"));
            
            if(pMap.get("P_SOURCE_TABLE") == null)
               pMap.put("P_SOURCE_TABLE",m.get("sourceTable"));
            
            if(pMap.get("P_SOURCE_TABLE_COLUMN") == null)
               pMap.put("P_SOURCE_TABLE_COLUMN",m.get("sourceTableColumn"));
            
            if(pMap.get("P_SOURCE_TYPE") == null)
                pMap.put("P_SOURCE_TYPE",m.get("sourceType"));
            
            sessionMap.put("regionOWSRendered",pMap.get("P_OWS_REGION_RENDERED"));
            sessionMap.put("pFacesServlet",pMap.get("P_FACES_SERVLET"));
            
            System.out.println("seafarerId:"+pMap.get("P_SOURCE_ID"));
            System.out.println("sourceTable:"+pMap.get("P_SOURCE_TABLE"));*/
            
            /* Provisional Check */
            
            // tsuazo 08/21/2023
            //String sourceTable = (String) pMap.get("P_SOURCE_TABLE");  
            
            
           /* String sourceTable = pMap.get("P_SOURCE_TABLE").toString();            
            String docType = null;
            
            if (sourceTable != null) {
                Integer lInstr = sourceTable.indexOf('_');
                String lSourceTab = sourceTable.substring(0,lInstr);
                
                System.out.println("lInstr:"+lInstr);
                System.out.println("lSourceTab:"+lSourceTab);

                List<String> list = Arrays.asList("SICD");
                boolean isExists = list.contains(lSourceTab);
                
                
                if (isExists) {
                    
                    // tsuazo 08/21/2023
                    //Integer sourceId = Integer.valueOf((String) pMap.get("P_SOURCE_ID"));
                    Integer sourceId = Integer.valueOf(pMap.get("P_SOURCE_ID").toString());
                    
                    // tsuazo 08/21/22023
                    //RMIManualTradeComplianceAppModuleImpl amImpl = (RMIManualTradeComplianceAppModuleImpl) ADFUtils.getApplicationModuleForDataControl("RMIManualTradeComplianceAppModuleDataControl");
                    AppModuleImpl amImpl = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");                    Statement datasource = amImpl.getDBTransaction().createStatement(0);
                    
                    String sqlQuery = "SELECT RMI_SICD_PUB_EXT.get_seafarer_doc_type(?) doc_type FROM DUAL";
                    
                    try {
                        Connection connection = datasource.getConnection();
                        PreparedStatement statement = connection.prepareStatement(sqlQuery);
                        statement.setInt(1, sourceId);
                        ResultSet resultSet = statement.executeQuery();
                        System.out.println("nameScreenContainVCL resultSet:"+resultSet);
                        if (resultSet.next()) {
                            docType = resultSet.getString("doc_type");
                        }
                        
                        //resultSet.close();
                        //statement.close();
                        //connection.close();
                        
                        
                        
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }   
                    
                    System.out.println("nameScreenContainVCL onLoad docType: "+docType);
                    
                }
            }

            // T20230601.0005 - Eligible for TC Provisional Approval
            //String sourceTab = (String) m.get("sourceTable");
            
            // tsuazo 08/21/2020
            //String sourceTab = (String) pMap.get("P_SOURCE_TABLE");
            String sourceTab = pMap.get("P_SOURCE_TABLE").toString();
            
            if (sourceTab != null) {
                Integer lInstr = sourceTab.indexOf('_');
                String lSourceTab = sourceTab.substring(0,lInstr);                
                System.out.println("lInstr:"+lInstr);
                System.out.println("lSourceTab:"+lSourceTab);
                
                // T20230330.0026 - LONO - TC Department (IRI)
                List<String> list = Arrays.asList("SICD","NRMI","LONO");
                boolean isExists = list.contains(lSourceTab);
                if (isExists) {
                    pMap.put("Provisional","Y");
                    
                    if (lSourceTab.equals("SICD")) {
                        
                        // pMap.put("ProvisionalDocumentType","PRVFT");
                        
                        if (docType != null) {
                            pMap.put("Provisional","Y");
                            pMap.put("ProvisionalDocumentType",docType);                             
                        } else {
                            pMap.put("Provisional","N");
                            pMap.put("ProvisionalDocumentType",null); 
                        }
                        
                        
                        
                    } else if (lSourceTab.equals("NRMI")) {
                        pMap.put("ProvisionalDocumentType","NRMI");
                    } else if (lSourceTab.equals("LONO")) {
                        pMap.put("ProvisionalDocumentType","LONO");     
                    }
                    
                } else {
                    pMap.put("Provisional","N");
                    pMap.put("ProvisionalDocumentType",null);   
                }
                
            }            
            
            System.out.println("Provisional:"+pMap.get("Provisional"));
            System.out.println("ProvisionalDocumentType:"+pMap.get("ProvisionalDocumentType")); */
            
            /* End Provisional Check */ 
            
            new IRIUtils().initVersionAYear();
            
            
        }catch(Exception e){
            e.printStackTrace();
        }
    }
}
