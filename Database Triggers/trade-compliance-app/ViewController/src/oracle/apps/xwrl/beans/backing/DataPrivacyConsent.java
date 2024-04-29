package oracle.apps.xwrl.beans.backing;

import com.rmi.manualtradecompliance.utils.ADFUtils;
import com.rmi.manualtradecompliance.utils.IRIUtils;

import com.rmi.manualtradecompliance.utils.JSFUtils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.Serializable;

import java.math.BigDecimal;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;

import java.text.SimpleDateFormat;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.faces.event.ValueChangeEvent;

import javax.servlet.ServletContext;

import oracle.adf.model.binding.DCIteratorBinding;
import oracle.adf.share.ADFContext;
import oracle.adf.share.logging.ADFLogger;
import oracle.adf.view.rich.component.rich.input.RichInputFile;

import oracle.adf.view.rich.util.ResetUtils;

import oracle.apps.xwrl.model.am.AppModuleImpl;

import oracle.jbo.Row;
import oracle.jbo.ViewCriteria;
import oracle.jbo.ViewObject;

import org.apache.commons.io.FilenameUtils;
import org.apache.myfaces.trinidad.model.UploadedFile;

public class DataPrivacyConsent implements Serializable{
    @SuppressWarnings("compatibility:-1473751144226756711")
    private static final long serialVersionUID = 1L;
    private String entityId,entityType,masterId,aliasId,xrefId;
    private IRIUtils iriUtils = new IRIUtils();
    
    private String entType;

    public void setEntType(String entType) {
        this.entType = entType;
    }

    public String getEntType() {
        return entType;
    }

    public void setEntityType(String entityType) {
        this.entityType = entityType;
    }

    public String getEntityType() {
        return entityType;
    }
    private InputStream uploadedFileStream;
    
    private String diskPath;
    //T20210409.0021 - DPCF Online Forms
    private String onlineDiskPath;
    private String fileName,selectedFileName,onlineFileName;

    public void setOnlineFileName(String onlineFileName) {
        this.onlineFileName = onlineFileName;
    }

    public String getOnlineFileName() {
        return onlineFileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFileName() {
        return fileName;
    }
    private RichInputFile fileUploadObj;
    private Date consentDate,consentExpireDate;
    private String acknowledgeNumber;
    private String selectedEntityType;
    private ADFLogger LOGGER=ADFLogger.createADFLogger(DataPrivacyConsent.class);
    private String sourceId;
    private Date onlineConsentDate,onlineConsentExpireDate;
    private String consentId;
    private String l_name;
    private String l_nationality;
    private String l_dob;
    private boolean mailCommunicationFlag;
    private String edocId;
    private String onlineEdocId;
    private String categoryId;
    private String docCode;
    private String docType;
    private String acknowledgeNumberVerify ;
    

    public DataPrivacyConsent() {
        super();
        LOGGER.finest("DataPrivacyConsent constructor started");
        System.out.println("DataPrivacyConsent constructor started");
        try{
            DCIteratorBinding dcib=ADFUtils.findIterator("XwrlRequestsView1Iterator");
            Row row = dcib.getViewObject().getCurrentRow();
            String sourceTable="";
            
            if(row != null){
                LOGGER.finest("inside if");
                if(row.getAttribute("SourceId") != null)
                    entityId=((BigDecimal)row.getAttribute("SourceId")).toPlainString();
                LOGGER.finest("entityId:"+entityId);
                if(row.getAttribute("SourceTable") != null)
                    sourceTable=row.getAttribute("SourceTable").toString();
                LOGGER.finest("entityType:"+entityType);
                if(row.getAttribute("MasterId") != null)
                    masterId=((BigDecimal)row.getAttribute("MasterId")).toPlainString();
                LOGGER.finest("masterId:"+masterId);
                if(row.getAttribute("AliasId") != null)
                    aliasId=((BigDecimal)row.getAttribute("AliasId")).toPlainString();
                LOGGER.finest("aliasId:"+aliasId);
                if(row.getAttribute("XrefId") != null)
                    xrefId=((BigDecimal)row.getAttribute("XrefId")).toPlainString();
                LOGGER.finest("xrefId:"+xrefId);
                if(row.getAttribute("NameScreened") != null)
                    l_name=empty(row.getAttribute("NameScreened"));
                LOGGER.finest("l_name:"+l_name);
                if(row.getAttribute("DateOfBirth") != null){
                    l_dob=empty(row.getAttribute("DateOfBirth")).split("T",2)[0];
                    if(l_dob != null && !"".equals(l_dob)){
                        SimpleDateFormat format=new SimpleDateFormat("yyyy-MM-dd");
                        SimpleDateFormat format1=new SimpleDateFormat("yyyyMMdd");
                        Date d=null;
                        if(l_dob.contains("-"))
                            d=format.parse(l_dob);
                        else
                            d=format1.parse(l_dob);
                        format=new SimpleDateFormat("dd-MMM-yyyy");
                        l_dob=format.format(d);
                    }
                }
                LOGGER.finest("l_dob:"+l_dob);
                if(row.getAttribute("CountryOfNationality") != null)
                    l_nationality=empty(row.getAttribute("CountryOfNationality"));
                LOGGER.finest("l_nationality:"+l_nationality);
                
                getConsentId();
                //Find Correct Master Id for this request
                if((xrefId == null || "".equals(xrefId)) && (aliasId == null || "".equals(aliasId))){
                    //No change in masterId
                    LOGGER.finest("No changes:"+masterId);
                }else if(aliasId != null && !"".equals(aliasId) ){
                    List params=new ArrayList();
                    params.add(aliasId);
                    ResultSet rs=iriUtils.getPlSqlFunctionData("select master_id from xwrl_party_alias where id = ?", params);
                    if(rs.next())
                        masterId=rs.getString(1);
                    LOGGER.finest("aliasId is not null:"+masterId);
                }else if(xrefId != null && !"".equals(xrefId)){
                    List params=new ArrayList();
                    params.add(xrefId);
                    ResultSet rs=iriUtils.getPlSqlFunctionData("select relationship_master_id from xwrl_party_xref where id = ?", params);
                    if(rs.next())
                        masterId=rs.getString(1);
                    LOGGER.finest("xref id is not null:"+masterId);
                }
                System.out.println("Final master id is:"+masterId);
            }
            
            if("SICD_SEAFARERS".equals(sourceTable))
                entityType="SEAFARERS";
            else if("CORP_MAIN".equals(sourceTable))
                entityType="CORPORATION";
            else if("AR_CUSTOMERS".equals(sourceTable))
                entityType="FILING AGENT";
            //T20201116.0024 - ESR Category for DPCF in OWS (IRI)
            else if("ESR_REQUEST_USER_DETAILS".equals(sourceTable))
                entityType="ESR";
            else if("XWRL_PARTY_MASTER".equals(sourceTable))
                entType="PARTY MASTER";    
            else //T20200519.0003 - DPC Upload Issues on ADF side (IRI)
                new IRIUtils().displayWarningMessage("DPC category not available for this source");
            
          /* // T20211213.0034 - Failure to uploading DP consent in Case document (IRI) 
            else if("XWRL_PARTY_MASTER".equals(sourceTable))
                entityType=" ";    */
          
            
            
            selectedEntityType=entityType;
            getInitialData();
           LOGGER.finest("ConsentId:"+consentId);
        
        }catch(Exception e){
            e.printStackTrace();
        }
        System.out.println("DataPrivacyConsent constructor ended");
        LOGGER.finest("DataPrivacyConsent constructor ended");
    }
    
    private String empty(Object value){
        if(value == null || "".equals(value))
            return "";
        else
            return value.toString();
    }
    
    //T20200519.0003 - DPC Upload Issues on ADF side (IRI)
    private void getConsentId(){
        CallableStatement st = null;
        String sq = null;
        AppModuleImpl am = null;
        try{
            sq = "begin RMI_OWS_COMMON_UTIL.getDPCDetails(p_source_table_id => :1, " +
                "p_master_id => :2, " +
                "p_xref_id => :3, " +
                "p_alias_id => :4, " +
                "p_source_table => :5, " +
                "l_consent_id => :6, " +
                "l_name => :7, " +
                "l_dob => :8, " +
                "l_entity => :9, " +
                "l_nationality => :10 ); end;";
              am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
              st = am.getDBTransaction().createCallableStatement(sq, 0);

              st.setString(1, entityId);
              st.setString(2, masterId);
              st.setString(3, xrefId);
              st.setString(4, aliasId);
              st.setString(5, entityType);
              st.registerOutParameter(6, Types.VARCHAR);
              st.registerOutParameter(7, Types.VARCHAR);
              st.registerOutParameter(8, Types.VARCHAR);
              st.registerOutParameter(9, Types.VARCHAR);
              st.registerOutParameter(10, Types.VARCHAR);
              st.execute();
              
              if(st.getObject(6) != null)
                consentId = st.getObject(6).toString();
            
            if(st.getObject(7) != null)
              l_name = st.getObject(7).toString();
            
            if(st.getObject(8) != null)
                l_dob = st.getObject(8).toString();
            
            if(st.getObject(9) != null){
                String l_entity = st.getObject(9).toString();}
            
            if(st.getObject(10) != null)
                l_nationality = st.getObject(10).toString();
              
              LOGGER.finest("consentId:getConsentId method:"+consentId);
              LOGGER.finest("l_name:getConsentId method:"+l_name);
            System.out.println("consentId:getConsentId method:"+consentId);
            System.out.println("l_name:getConsentId method:"+l_name);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    private void getInitialData() throws SQLException {
        LOGGER.finest("getInitialData method started");
        DCIteratorBinding dcib=ADFUtils.findIterator("RmiDataPrivacyConsentVO1Iterator");
        ViewObject vo = dcib.getViewObject();
        ViewCriteria vc = vo.getViewCriteriaManager().getViewCriteria("RmiDataPrivacyConsentVOCriteria");
        if(consentId != null){
        
            vo.setNamedWhereClauseParam("p_consentId", consentId);
            vo.setNamedWhereClauseParam(("p_consentSource"), "Trade Compliance");
            vo.applyViewCriteria(vc);
            vo.executeQuery();
            if(vo.hasNext()){
                Row row=vo.next();
                
                LOGGER.finest("ConsentId:"+row.getAttribute("ConsentId"));
                    consentId=empty(row.getAttribute("ConsentId"));
                    selectedEntityType=empty(row.getAttribute("EntityType"));
                    edocId=empty(row.getAttribute("EdocId"));
                    if(row.getAttribute("ConsentDate") != null)
                        consentDate =  ((oracle.jbo.domain.Date)row.getAttribute("ConsentDate")).getValue();
                    
                    if(row.getAttribute("ConsentExpireDate") != null)
                        consentExpireDate = ((oracle.jbo.domain.Date) row.getAttribute("ConsentExpireDate")).getValue();
                    
                    String markCommFlag=empty(row.getAttribute("MarketingCommunication"));
                    mailCommunicationFlag="Y".equals(markCommFlag);
          
                
                LOGGER.finest("Acknowledge Number:"+acknowledgeNumber);
                LOGGER.finest("Marketing Communication flag:"+mailCommunicationFlag);
                LOGGER.finest("row ConsentDate:"+row.getAttribute("ConsentDate"));
                LOGGER.finest("row ConsentExpireDate:"+row.getAttribute("ConsentExpireDate"));
                LOGGER.finest("ConsentDate:"+consentDate);
                LOGGER.finest("ConsentExpireDate:"+consentExpireDate);
                LOGGER.finest("onlineConsentDate:"+onlineConsentDate);
                LOGGER.finest("onlineConsentExpireDate:"+onlineConsentExpireDate);
                System.out.println("Consent Id:getinitial Data:"+consentId);
                LOGGER.finest("----------------");
            }else
                consentId=null;
        }
        
        System.out.println("DPC masterId:"+masterId);
        //Get Online DPC details using Master Id
        vc = vo.getViewCriteriaManager().getViewCriteria("RmiDataPrivacyConsentVOCriteria1");
        vo.setNamedWhereClauseParam("p_masterId", masterId);
        vo.setNamedWhereClauseParam(("p_consentSource"), "Online");
        vo.applyViewCriteria(vc);
        vo.executeQuery();
        if(vo.hasNext()){
            Row row=vo.next();
            System.out.println("DPC inside online consent");
            //T20210409.0021 - DPCF Online Forms
            onlineEdocId=empty(row.getAttribute("EdocId"));
        
            if(row.getAttribute("ConsentDate") != null)
                onlineConsentDate = ((oracle.jbo.domain.Date) row.getAttribute("ConsentDate")).getValue();
            
            if(row.getAttribute("ConsentExpireDate") != null)
                onlineConsentExpireDate = ((oracle.jbo.domain.Date) row.getAttribute("ConsentExpireDate")).getValue();
            acknowledgeNumber=empty(row.getAttribute("ConfirmationNumber"));
            acknowledgeNumberVerify = empty(row.getAttribute("ConfirmationNumber"));
            System.out.println("DPC ackNumber:"+acknowledgeNumber);
        }
            
        
        LOGGER.finest("ConsentId:"+consentId);
        LOGGER.finest("onlineEdocId:"+onlineEdocId);
        System.out.println("ConsentId:"+consentId);
        System.out.println("onlineEdocId:"+onlineEdocId);
        
        if(edocId != null || onlineEdocId !=  null)
            prepareEdocInfo();
        
        LOGGER.finest("getInitialData method ended");
    }
    
    
    private void loadCategoryId(){
        LOGGER.finest("loadCategoryId method started");
        try{
            System.out.println("loadCategoryId:selectedEntityType:"+selectedEntityType);
            List params=new ArrayList();
            //T20201116.0024 - ESR Category for DPCF in OWS
            if("CORPORATION".equals(selectedEntityType) || "ESR".equals(selectedEntityType)){
                params.add("CORP");
                params.add("DPC");
                docCode="DPC";
                docType="CORP";
            }//T20190530.0024 - TC - DP consent Problem (IRI)
            else if("GENERAL".equals(selectedEntityType) || "NAUTICAL INSPECTOR".equals(selectedEntityType) || "MARKETING".equals(selectedEntityType)){
                params.add("VSSL");
                params.add("DPC");
                docCode="DPC";
                docType="VSSL";
            }else{
                params.add("SICD");
                params.add("0025");
                docCode="0025";
                docType="SICD";
            }
            ResultSet rs=iriUtils.getPlSqlFunctionData("select iri_edocs_pkg.get_category_id(?,?,'Consent') from dual", params);
            if(rs.next())
                categoryId=rs.getString(1);
            LOGGER.finest("Category Id:"+categoryId);
        }catch(Exception e){
            e.printStackTrace();
        }
        LOGGER.finest("loadCategoryId method ended");
    }
    
    private void prepareEdocInfo(){
        DCIteratorBinding dcib=ADFUtils.findIterator("IriEdocsVO1Iterator");
        ViewObject vo = dcib.getViewObject();
        if(edocId != null){
            ViewCriteria vc = vo.getViewCriteriaManager().getViewCriteria("IriEdocsVOCriteria2");
            vo.setNamedWhereClauseParam("p_edocId", new BigDecimal(edocId));
            vo.applyViewCriteria(vc);
            vo.executeQuery();
            
            if(vo.hasNext()){
                Row row=vo.next();
                diskPath=empty(row.getAttribute("DiskPath"));
                fileName=empty(row.getAttribute("FileName"));
            }
        }
        
        LOGGER.finest("DiskPath:"+diskPath);
        LOGGER.finest("FileName:"+fileName);
        LOGGER.finest("edocId:"+edocId);
        
        if(onlineEdocId != null && !"".equals(onlineEdocId)){
            ViewCriteria vc = vo.getViewCriteriaManager().getViewCriteria("IriEdocsVOCriteria2");
            vo.setNamedWhereClauseParam("p_edocId", new BigDecimal(onlineEdocId));
            vo.applyViewCriteria(vc);
            vo.executeQuery();
            
            if(vo.hasNext()){
                Row row=vo.next();
                onlineDiskPath=empty(row.getAttribute("DiskPath"));
                onlineFileName=empty(row.getAttribute("FileName"));
            }
        }
        System.out.println("onlineDiskPath:"+onlineDiskPath);
         System.out.println("onlineFileName:"+onlineFileName);
         System.out.println("edocId:"+edocId);
    }

    public void saveActionListener(ActionEvent actionEvent) {
        // Add event code here...
        LOGGER.finest("saveActionListener method started");
        AppModuleImpl am  = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
        
        // T20230427.0021 - TC - FA - online DPCF codes (IRI)

                
        if(acknowledgeNumberVerify == null && acknowledgeNumber != null) {
            updateOnlineConsent();
        } else {
        
            try{
                if(uploadedFileStream == null){
                    showMessage("Please upload the Document", FacesMessage.SEVERITY_ERROR);
                    return;
                }
                
                System.out.println("SaveAction:categoryId:"+categoryId);
                
                loadCategoryId();
                DCIteratorBinding dcib=ADFUtils.findIterator("RmiDataPrivacyConsentVO1Iterator");
                ViewObject vo = dcib.getViewObject();
                ViewCriteria vc = vo.getViewCriteriaManager().getViewCriteria("RmiDataPrivacyConsentVOCriteria");
                vo.setNamedWhereClauseParam("p_consentId", consentId);
                vo.setNamedWhereClauseParam("p_consentSource", "Trade Compliance");
                vo.applyViewCriteria(vc);
                Object userId=ADFContext.getCurrent().getSessionScope().get("UserId");
                Object sessionId=ADFContext.getCurrent().getSessionScope().get("SessionId");
                System.out.println("SaveAction:consentId:"+consentId);
                System.out.println("SaveAction:edocId:"+edocId);
                if(consentId != null && !"0".equals(consentId) && edocId != null){
                    vo.executeQuery();
                    System.out.println("vo row:"+vo.getRowCount());
                    if(vo.hasNext()){
                        System.out.println("SaveAction:if");
                        System.out.println("SaveAction:ConsentDate:"+consentDate);
                        System.out.println("SaveAction:ConsentExpireDate:"+consentExpireDate);
                        System.out.println("SaveAction:EntityType:"+selectedEntityType);
                        Row row=vo.next();
                        row.setAttribute("ConsentDate", consentDate);
                        row.setAttribute("ConsentExpireDate", consentExpireDate);
                        row.setAttribute("MarketingCommunication", (mailCommunicationFlag)?'Y':'N');
                        row.setAttribute("ConsentSource", "Trade Compliance");
                        row.setAttribute("LastUpdatedBy", userId);
                        row.setAttribute("LastUpdateLogin", sessionId);
                        row.setAttribute("EntityType", selectedEntityType);
                        Timestamp time = new Timestamp(System.currentTimeMillis());
                        row.setAttribute("LastUpdateDate",time);
    
                        createEdocEntry();
                        row.setAttribute("EdocId", edocId);
                        am.getDBTransaction().commit();
                    }
                }else{
                    
                    List params=new ArrayList();
                    ResultSet rs=iriUtils.getPlSqlFunctionData("select APPS.RMI_DATA_PRIVACY_CONSENT_S.nextval from dual", params);
                    String cId="";
                    if(rs.next())
                        cId=rs.getString(1);
                    LOGGER.finest("Generated Consent Id:"+cId);
                    System.out.println("Generated Consent Id:"+cId);
                    
                    Row row=vo.createRow();
                    row.setAttribute("ConsentId", cId);
                    row.setAttribute("ConsentDate", consentDate);
                    row.setAttribute("ConsentExpireDate", consentExpireDate);
                    row.setAttribute("MarketingCommunication", (mailCommunicationFlag)?'Y':'N');
                    row.setAttribute("EntityType", selectedEntityType);
                    row.setAttribute("ConsentSource", "Trade Compliance");
                    row.setAttribute("EntityId", entityId);
                    row.setAttribute("MasterId", masterId);
                    row.setAttribute("LastUpdatedBy", userId);
                    row.setAttribute("CreatedBy", userId);
                    row.setAttribute("LastUpdateLogin", sessionId);
                    Timestamp time = new Timestamp(System.currentTimeMillis());
                    row.setAttribute("LastUpdateDate",time);
                    row.setAttribute("CreationDate",time);
                    
                    System.out.println("MasterId:"+masterId);
                    createEdocEntry();
                    row.setAttribute("EdocId", edocId);
                    consentId=cId;
                    am.getDBTransaction().commit();
                }
                
                LOGGER.finest("uploadedFileStream:"+uploadedFileStream);
                // T20221005.0018 - TC - FA - DPCF not in OWS but is in Oracle
                // Note: This is working.  Need to figure out where diskPath is definted.
                
                System.out.println("DPC Upload Path :"+diskPath);
                                
                if(uploadedFileStream != null){
                    copyFile(diskPath);
                    
                    validateConsent();
                }
                updateOnlineConsent();
            }catch(Exception e){
                e.printStackTrace();
                validateConsent();
                am.getDBTransaction().rollback();
            }
        }
        LOGGER.finest("saveActionListener method ended");
    }    
    
    private void updateOnlineConsent() {
        
        //T20230427.0021 - TC - FA - online DPCF codes (IRI)
        
        try{
            
            System.out.print("updateOnlineConsent: Calling rmi_generic_tc.update_online_consent");
            
            String sq = "begin ?:=rmi_generic_tc.update_online_consent(?,?,?,?,?); end;";
            AppModuleImpl am = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
            CallableStatement st = am.getDBTransaction().createCallableStatement(sq, 0);
            Row reqRow = ADFUtils.findIterator("XwrlRequestsView1Iterator").getViewObject().getCurrentRow();
            st.registerOutParameter(1, Types.VARCHAR);
            st.setString(2, sourceId);
            st.setString(3, acknowledgeNumber);
            st.setObject(4, reqRow.getAttribute("MasterId"));
            st.setObject(5, reqRow.getAttribute("AliasId"));
            st.setObject(6, reqRow.getAttribute("XrefId"));
            st.execute();
            
            acknowledgeNumberVerify=acknowledgeNumber;
            if("S".equals(st.getObject(1))) {
                showMessage("Online consent Saved Successfully!",FacesMessage.SEVERITY_INFO);
            }
            System.out.println("online ack status:"+st.getObject(1));
        }catch(Exception e) {
            e.printStackTrace();
        }
    }
    
    private void validateConsent() {
        AppModuleImpl am  = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
        if(!new File(diskPath).exists()) {
            if(edocId != null) {
                DCIteratorBinding dcib=ADFUtils.findIterator("IriEdocsVO1Iterator");
                ViewObject iriVo = dcib.getViewObject();
                ViewCriteria iriVc = iriVo.getViewCriteriaManager().getViewCriteria("IriEdocsVOCriteria2");
                iriVo.setNamedWhereClauseParam("p_edocId", edocId);
                iriVo.applyViewCriteria(iriVc);
                iriVo.executeQuery();
                
                if(iriVo.hasNext()) {
                    Row iriRow = iriVo.next();
                    iriRow.setAttribute("MarkedForDeletion", "Y");
                    iriRow.setAttribute("MarkedForDeletionDate", new Timestamp(System.currentTimeMillis()));
                }
            }
            
            if(consentId != null) {
                DCIteratorBinding dcib=ADFUtils.findIterator("RmiDataPrivacyConsentVO1Iterator");
                ViewObject consentVo = dcib.getViewObject();
                ViewCriteria consentVc = consentVo.getViewCriteriaManager().getViewCriteria("RmiDataPrivacyConsentVOCriteria");
                consentVo.setNamedWhereClauseParam("p_consentId", consentId);
                consentVo.setNamedWhereClauseParam("p_consentSource", "Trade Compliance");
                consentVo.applyViewCriteria(consentVc);
                consentVo.executeQuery();
                
                if(consentVo.hasNext()) {
                    Row consentRow = consentVo.next();
                    consentRow.setAttribute("EdocId", null);
                }
            }
            am.getDBTransaction().commit();
        }
    }
    
    private void createEdocEntry()
    {
      String seq = "";
      String filePath = "";
      String dirPath = "";
      ServletContext servContext = null;
      String actualFileName = "";
      String actualFileExt = "";
      String targetFileName = "";
      String targetFilePath = "";
      int len = 0;
      String subId = "";
      String docSelectedValue="Consent";
            
      try
      {

            actualFileName = selectedFileName;
            actualFileExt = FilenameUtils.getExtension(actualFileName);

            seq = calculateSeqNum()+"";
            
            seq=String.format("%03d", Integer.parseInt(seq));
            actualFileName = entityId + "-" + docCode + "-" + seq + "." + actualFileExt;
            targetFileName = entityId + "-" + docCode + "-" + seq + ".pdf";

            servContext = (ServletContext) FacesContext.getCurrentInstance().getExternalContext().getContext();

             len = entityId.length();
            if (len < 5)
                subId = "0";
            else if (len == 5)
                subId = entityId.substring(0, 1);
            else if (len == 6)
                subId = entityId.substring(0, 2);
            else if (len == 7)
                subId = entityId.substring(0, 3);
            else if (len == 8)
                subId = entityId.substring(0, 4);
                  
          // T20221005.0018 - TC - FA - DPCF not in OWS but is in Oracle
          //  Note: Updated init parameter from iri.edocs. to oracle.apps.xwrl. because iri.edocs. did not exist
          
          if("CORP".equals(docType)){
              dirPath=servContext.getInitParameter("oracle.apps.xwrl.CORP_DIRECTORY_WINDOWS");
          }//T20190530.0024 - TC - DP consent Problem (IRI)
          else if("VSSL".equals(docType)){
              dirPath=servContext.getInitParameter("oracle.apps.xwrl.VSSL_DIRECTORY_WINDOWS");
          }else{
              dirPath=servContext.getInitParameter("oracle.apps.xwrl.SICD_DIRECTORY_WINDOWS");
          }
               
            if (File.separator.equals("/"))
            {
              filePath = dirPath + "/" + subId + "/" + entityId + "/" + docSelectedValue + "/" + actualFileName;
            }
            else
            {
              filePath = dirPath + File.separator + subId + File.separator +entityId + File.separator + docSelectedValue + File.separator + actualFileName;
            }
          
          // T20221005.0018 - TC - FA - DPCF not in OWS but is in Oracle
          
          System.out.println("DPC dirPath::"+dirPath);
          System.out.println("DPC filePath::"+filePath);
          System.out.println("DPC fileName::"+actualFileName);

            File file = new File(filePath);
            file.getParentFile().mkdirs();
            

            LOGGER.finest("filePath:: " + filePath);
            LOGGER.finest("fileName:: " + actualFileName);

            LOGGER.finest("target filePath:: " + targetFilePath);
            LOGGER.finest("target fileName:: " + targetFileName);
          
          
          System.out.println("categoryId:"+categoryId);
          System.out.println("entityId:"+entityId);
          System.out.println("seq:"+seq);
          System.out.println("docSelectedValue:"+docSelectedValue);
          System.out.println("subId:"+subId);

            

        LOGGER.finest("File Path and filename inserting in database " + filePath + "  "+  actualFileName);
          
        insertEdoc(categoryId, filePath, actualFileName, entityId, seq, docSelectedValue, subId);
          
          
          
        
      }
      catch (Exception e)
      {
        e.printStackTrace();
          AppModuleImpl am  = (AppModuleImpl) ADFUtils.getApplicationModuleForDataControl("AppModuleDataControl");
          am.getDBTransaction().rollback();
      }
      
    }
    
    private void updateEdoc(String categoryId,String filePath,String fileName,String entityId,String seq,String docSelectedValue,String subId){
        try{
            
            DCIteratorBinding dcib=ADFUtils.findIterator("IriEdocsVO1Iterator");
            ViewObject vo = dcib.getViewObject();
            ViewCriteria vc = vo.getViewCriteriaManager().getViewCriteria("IriEdocsVOCriteria2");
            vo.setNamedWhereClauseParam("p_edocId", edocId);
            vo.applyViewCriteria(vc);
            vo.executeQuery();
           
            if(vo.hasNext()){
                Row newRow = vo.next();
                newRow.setAttribute("CategoryId", categoryId);
                newRow.setAttribute("DiskPath", filePath);
                newRow.setAttribute("FileName", fileName);
                newRow.setAttribute("Url",
                                    docType + File.separator + subId + File.separator + entityId + File.separator + docSelectedValue +
                                    File.separator + fileName);
                System.out.println("URL:"+docType + File.separator + subId + File.separator + entityId + File.separator + docSelectedValue +
                                    File.separator + fileName);

            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    private void insertEdoc(String categoryId,String filePath,String fileName,String entityId,String seq,String docSelectedValue,String subId){
        try{
            DCIteratorBinding dcib=ADFUtils.findIterator("IriEdocsVO1Iterator");
            ViewObject vo = dcib.getViewObject();
            ViewCriteria vc = vo.getViewCriteriaManager().getViewCriteria("IriEdocsVOCriteria1");
            vo.setNamedWhereClauseParam("p_identifier", entityId);
            vo.setNamedWhereClauseParam("p_diskPath", filePath);
            vo.applyViewCriteria(vc);
            vo.executeQuery();
            this.diskPath=filePath;
            this.fileName=fileName;
            if(vo.getRowCount() == 0){
                Row newRow = vo.createRow();
                newRow.setAttribute("CategoryId", categoryId);
                newRow.setAttribute("DiskPath", filePath);
                newRow.setAttribute("FileName", fileName);
                newRow.setAttribute("Identifier", entityId);
                newRow.setAttribute("Sequence", seq);
                newRow.setAttribute("CreationDate", new Date());
                newRow.setAttribute("Url",
                                    docType + File.separator + subId + File.separator + entityId + File.separator + docSelectedValue +
                                    File.separator + fileName);
                System.out.println("URL:"+docType + File.separator + subId + File.separator + entityId + File.separator + docSelectedValue +
                                    File.separator + fileName);
                
                List params=new ArrayList();
                ResultSet rs=iriUtils.getPlSqlFunctionData("select IRI_EDOCS_COUNTER.nextval from dual", params);
                if(rs.next())
                    edocId=rs.getString(1);
                
                newRow.setAttribute("Id",edocId);
                System.out.println("On insertEdoc edocid:"+edocId);
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    private void copyFile(String outputFilePath){
        
        // T20221005.0018 - TC - FA - DPCF not in OWS but is in Oracle
        // Note: This is working.
        
        try{
            FileOutputStream out = new FileOutputStream(outputFilePath);
            int read = 0;
            byte[] bytes = new byte[1024];
            
            while ((read = uploadedFileStream.read(bytes)) != -1) {
                out.write(bytes, 0, read);
            }
            uploadedFileStream.close();
            out.flush();
            out.close();
            fileUploadObj.resetValue();
            uploadedFileStream=null;
            showMessage("File Saved Successfully!",FacesMessage.SEVERITY_INFO);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    private int calculateSeqNum(){
        try{
            List params=new ArrayList();
            params.add(entityId);
            params.add(categoryId);
            ResultSet rs=iriUtils.getPlSqlFunctionData("select nvl(max(sequence),0) SEQCNT from iri_edocs where identifier=? and category_id=?", params);
            String cId="";
            if(rs.next())
                return rs.getInt(1)+1;
        }catch(Exception e){
            e.printStackTrace();
        }
        return 0;
    }
    
    private void showMessage(String msg,FacesMessage.Severity sev) {
        FacesMessage Message = new FacesMessage(msg);
        Message.setSeverity(FacesMessage.SEVERITY_INFO);
        FacesContext fc = FacesContext.getCurrentInstance();
        fc.addMessage(null, Message);
    }

    public void onUploadDocument(ValueChangeEvent valueChangeEvent) {
        // Add event code here...
        LOGGER.finest("onUploadDocument method started");
        UploadedFile file = (UploadedFile)valueChangeEvent.getNewValue();
        try {
            // T20210427.0020 - JPEG file Extension for Data Privacy Consent Forms
            if (file.getFilename().toLowerCase().endsWith("pdf")||file.getFilename().toLowerCase().endsWith("jpeg")||file.getFilename().toLowerCase().endsWith("jpg")) {
                selectedFileName=file.getFilename();
                uploadedFileStream = file.getInputStream();
            }else{
                new IRIUtils().displayWarningMessage("Please upload pdf or jpeg or jpg file");
                ((RichInputFile)valueChangeEvent.getComponent()).resetValue();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        LOGGER.finest("onUploadDocument method ended");
    }
    
    public void setMailCommunicationFlag(boolean mailCommunicationFlag) {
        this.mailCommunicationFlag = mailCommunicationFlag;
    }

    public boolean isMailCommunicationFlag() {
        return mailCommunicationFlag;
    }
    public void setFileUploadObj(RichInputFile fileUploadObj) {
        this.fileUploadObj = fileUploadObj;
    }

    public RichInputFile getFileUploadObj() {
        return fileUploadObj;
    }
    
    public void setSourceId(String sourceId) {
        this.sourceId = sourceId;
    }

    public String getSourceId() {
        return sourceId;
    }

    public void setSelectedEntityType(String selectedEntityType) {
        this.selectedEntityType = selectedEntityType;
    }

    public String getSelectedEntityType() {
        return selectedEntityType;
    }

    public void setAcknowledgeNumber(String acknowledgeNumber) {
        this.acknowledgeNumber = acknowledgeNumber;
    }

    public String getAcknowledgeNumber() {
        return acknowledgeNumber;
    }

    public void setConsentDate(Date consentDate) {
        this.consentDate = consentDate;
    }

    public Date getConsentDate() {
        return consentDate;
    }

    public void setConsentExpireDate(Date consentExpireDate) {
        this.consentExpireDate = consentExpireDate;
    }

    public Date getConsentExpireDate() {
        return consentExpireDate;
    }

    public void setOnlineConsentDate(Date onlineConsentDate) {
        this.onlineConsentDate = onlineConsentDate;
    }

    public Date getOnlineConsentDate() {
        return onlineConsentDate;
    }

    public void setOnlineConsentExpireDate(Date onlineConsentExpireDate) {
        this.onlineConsentExpireDate = onlineConsentExpireDate;
    }

    public Date getOnlineConsentExpireDate() {
        return onlineConsentExpireDate;
    }

    public void fileDownloadListener(FacesContext facesContext, OutputStream outputStream) {
        // Add event code here...
        downloadFile(diskPath, outputStream);
    }
    
    private void downloadFile(String diskPath, OutputStream outputStream) {
        LOGGER.finest("fileDownloadListener method started");
            try{
                File inputFile = new File(diskPath);

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
                showMessage("Download processing has completed.",FacesMessage.SEVERITY_INFO);
            }catch(Exception e){
                showMessage("Download processing has failed.",FacesMessage.SEVERITY_ERROR);
                e.printStackTrace();
            }finally {
                try {
                    outputStream.flush();
                    outputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
                
        }
        
        LOGGER.finest("fileDownloadListener method ended");
    }

    public void onConsentDateChangeListener(ValueChangeEvent valueChangeEvent) {
        // Add event code here...
        Object obj=valueChangeEvent.getNewValue();
        if(obj == null){
            consentExpireDate=null;
        }else{
            Date d=(Date)obj;
            Calendar c = Calendar.getInstance();
            c.setTime(d);
            c.add(Calendar.YEAR, 5);
            c.add(Calendar.DATE,-1);
            consentExpireDate = c.getTime();
        }
    }
    
    //T20210409.0021 - DPCF Online Forms
    public void onlineFileDownloadListener(FacesContext facesContext, OutputStream outputStream) {
        // Add event code here...
        downloadFile(onlineDiskPath, outputStream);
    }
    
    public void onlineConsentAckNumberVCL(ValueChangeEvent valueChangeEvent) {
        // Add event code here...
        
        //T20230427.0021 - TC - FA - online DPCF codes (IRI)    
        if (valueChangeEvent.getOldValue() != null) {
            if (!valueChangeEvent.getOldValue().equals(valueChangeEvent.getNewValue())) {
                acknowledgeNumberVerify = null;
                acknowledgeNumber = (String) valueChangeEvent.getNewValue();
            }             
        }        
        if(acknowledgeNumberVerify == null) {
            if(valueChangeEvent.getNewValue() != null) {
                ViewObject vo = ADFUtils.findIterator("GetConsentDetailsByConfNumberView1Iterator").getViewObject();
                vo.setNamedWhereClauseParam("p_conf_number", valueChangeEvent.getNewValue());
                vo.executeQuery();
                if(vo.hasNext()) {
                    Row row = vo.next();
                    onlineConsentDate = (Timestamp)row.getAttribute("ConsentDate");
                    onlineConsentExpireDate = (Timestamp) row.getAttribute("ConsentExpireDate");
                } else {
                    ResetUtils.reset(valueChangeEvent.getComponent());
                }
            }
        }
    }
}
