package oracle.apps.xwrl.beans.session;

import java.util.Date;
import java.util.Random;

import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;

import javax.servlet.http.HttpSession;

import oracle.adf.share.logging.ADFLogger;


public class UserRespAndSessionInfo {
    
    private static ADFLogger LOGGER = ADFLogger.createADFLogger(UserRespAndSessionInfo.class);
    
    public UserRespAndSessionInfo() 
    {
        super();
        LOGGER.finest("UserRespAndSessionInfo");
    }

    public String SESSION_ID;

    public void setSESSION_ID(String SESSION_ID) {
        this.SESSION_ID = SESSION_ID;
    }

    public String getSESSION_ID() {
        FacesContext fctx = FacesContext.getCurrentInstance();
        ExternalContext ectx = fctx.getExternalContext();
        HttpSession session = (HttpSession) ectx.getSession(false);
        String sessionId = session.getId(); 
        LOGGER.finest("sessionId: "+sessionId);
        //System.out.println("Session Id = "+ sessionId); 
        SESSION_ID = sessionId;
        return SESSION_ID;
    }

    public void setIsReadOnly(String isReadOnly) {
        this.isReadOnly = isReadOnly;
    }

    public String getIsReadOnly() {
        return isReadOnly;
    }

    private Integer userId;
    private Integer sessionId;
    private Integer responsibilityId;
    private String responsibility;
    private String responsibilityName;
    private String pageTitle;
    private String userName;

    public void setTodayDate(Date todayDate) {
        System.out.println("todayDate::"+todayDate);
        this.todayDate = todayDate;
    }

    public Date getTodayDate() 
    {
       
        return todayDate;
    }

    public void setIsAdminOnly(String isAdminOnly) {
        this.isAdminOnly = isAdminOnly;
    }

    public String getIsAdminOnly() {
        return isAdminOnly;
    }

    private String dbName;
    private String home;
    private String isReadOnly;
    private String isAdminOnly;
    private String isSuperUserOnly;
    private String isCorporateReviewer;   // T20221108.0024 - TC Role Based Access Control
    private String isRecordLockUser;
    private String isGenericAdminOnly;

    public void setIsGenericAdminOnly(String isGenericAdminOnly) {
        this.isGenericAdminOnly = isGenericAdminOnly;
    }

    public String getIsGenericAdminOnly() {
        return isGenericAdminOnly;
    }

    public void setIsSuperUserOnly(String isSuperUserOnly) {
        this.isSuperUserOnly = isSuperUserOnly;
    }

    public String getIsSuperUserOnly() {
        return isSuperUserOnly;
    }
    
    public void setIsCorporateReviewer(String isCorporateReviewer) {
        this.isCorporateReviewer = isCorporateReviewer;
    }

    public String getIsCorporateReviewer() {
        return isCorporateReviewer;
    }    

    public void setIsRecordLockUser(String isRecordLockUser) {
        this.isRecordLockUser = isRecordLockUser;
    }

    public String getIsRecordLockUser() {
        return isRecordLockUser;
    }

    private Date todayDate = new Date();
    public void setTechrandomVal(Integer techrandomVal) {
            System.out.println("techrandomVal::"+techrandomVal);
            this.techrandomVal = techrandomVal;
        }

        public Integer getTechrandomVal() {
           
            return techrandomVal;
        }
                
        Random techrand = new Random();
        private Integer techrandomVal =  techrand.nextInt(1000) + 1;
    
    private String skinName = "Custom";

    public void setSkinName(String skinName) {
        this.skinName = skinName;
    }

    public String getSkinName() {
        return skinName;
    }   
   
    public void setResponsibility(String responsibility) {
        this.responsibility = responsibility;
    }

    public String getResponsibility() {
        return responsibility;
    }

    public void setPageTitle(String pageTitle) {
        this.pageTitle = pageTitle;
    }

    public String getPageTitle() {
        return pageTitle;
    }    

    public void setResponsibilityName(String responsibilityName) {
        this.responsibilityName = responsibilityName;
    }

    public String getResponsibilityName() {
        return responsibilityName;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setSessionId(Integer sessionId) {
        this.sessionId = sessionId;
    }

    public Integer getSessionId() {
        return sessionId;
    }

    public void setResponsibilityId(Integer responsibilityId) {
        this.responsibilityId = responsibilityId;
    }

    public Integer getResponsibilityId() {
        return responsibilityId;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserName() {
        return userName;
    }

    public void setDbName(String dbName) {
        this.dbName = dbName;
    }

    public String getDbName() {
        return dbName;
    }

    public void setHome(String home) {
        this.home = home;
    }

    public String getHome() {
        return home;
    }

    public void initRequest() {
        this.setPageTitle("Trade Compliance");
    }
    
    public void initSearch() {
        this.setPageTitle("Trade Compliance - Comparison");
    }
    
}
