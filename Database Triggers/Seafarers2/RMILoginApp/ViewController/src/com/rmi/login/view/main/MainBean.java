package com.rmi.login.view.main;

import static com.rmi.login.view.utils.RmiAdfUtils.findOperation;
import com.rmi.login.view.utils.RmiJsfUtils;
import static com.rmi.login.view.utils.RmiUtils.isNullOrEmptyObject;
import static com.rmi.login.view.utils.RmiUtils.isNullOrEmptyString;

import com.rmi.manualtradecompliance.utils.JSFUtils;

import java.io.Serializable;

import java.math.BigDecimal;

import javax.faces.application.FacesMessage;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import oracle.adf.controller.TaskFlowId;
import oracle.adf.share.ADFContext;
import oracle.adf.share.logging.ADFLogger;
import oracle.adf.view.rich.component.rich.RichPopup;
import oracle.adf.view.rich.component.rich.fragment.RichRegion;
import oracle.adf.view.rich.component.rich.layout.RichPanelSplitter;
import oracle.adf.view.rich.context.AdfFacesContext;

import oracle.binding.OperationBinding;

import oracle.jbo.Row;

import org.apache.myfaces.trinidad.event.DisclosureEvent;

import weblogic.servlet.security.ServletAuthentication;

public class MainBean implements Serializable {
    private static final long serialVersionUID = -1742639428600618808L;
    private static ADFLogger logger = ADFLogger.createADFLogger(MainBean.class);
    private String userId = (ADFContext.getCurrent().getSessionScope().get("UserId") != null) 
                             ? ADFContext.getCurrent().getSessionScope().get("UserId").toString()
                             : "";
    private String userName = (String) ADFContext.getCurrent().getSessionScope().get("FirstName"); ;
    private String roleId =  (ADFContext.getCurrent().getSessionScope().get("RoleId") != null) 
                             ? ADFContext.getCurrent().getSessionScope().get("RoleId").toString()
                             : "";
    private String defaultTaskflowId = (String) ADFContext.getCurrent().getSessionScope().get("DefaultTaskflow");
    private RichRegion regionBinding;
    private String taskFlowId = getTaskflowUrl(defaultTaskflowId, roleId);
    private RichPanelSplitter menuCollapseBinding;
    private RichPopup homeButtonPopupBinding;

    public TaskFlowId getDynamicTaskFlowId() 
    {
        if(taskFlowId != null)
            return TaskFlowId.parse(taskFlowId);
        else
            return null;
    }

    public void setDynamicTaskFlowId(String taskFlowId) {
        this.taskFlowId = taskFlowId;
    }

    public String getTaskFlowId() {
        return taskFlowId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserName() {
        return userName;
    }

    public void setRoleId(String roleId) {
        this.roleId = roleId;
    }

    public String getRoleId() {
        return roleId;
    }

    public void setDefaultTaskflowId(String defaultTaskflowId) {
        this.defaultTaskflowId = defaultTaskflowId;
    }

    public String getDefaultTaskflowId() {
        return defaultTaskflowId;
    }

    public MainBean() {
        try {

            if (!isNullOrEmptyString(userId)) {
                OperationBinding menuOnLoad = findOperation("menuOnLoad");
                menuOnLoad.getParamsMap().put("userId", userId);
                Row row = (Row) menuOnLoad.execute();
                if (menuOnLoad.getErrors().isEmpty()) {
                } else {
                    RmiJsfUtils.addFormattedFacesErrorMessage(" Please try logging in again.",
                                                              " Please try logging in again.",
                                                              FacesMessage.SEVERITY_ERROR);
                }
            }
            if (!isNullOrEmptyString(defaultTaskflowId) && !isNullOrEmptyString(roleId)) {
                getTaskflowUrl(defaultTaskflowId, roleId);
            } else {
                RmiJsfUtils.addFormattedFacesErrorMessage(" Please try logging in again.",
                                                          " Please try logging in again.",
                                                          FacesMessage.SEVERITY_ERROR);
            }
        } catch (Exception e) {
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while set default queue." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }

    public String getTaskflowUrl(String taskflowId, String roleId) {
        String taskFlowPath = null;
        try {
            System.out.println("defaultTaskflowId : "+taskFlowId);
            System.out.println("roleId : "+roleId);
            if (!isNullOrEmptyString(taskflowId) && !isNullOrEmptyString(roleId)) {
                OperationBinding getMenuItems = findOperation("getMenuItems");
                getMenuItems.getParamsMap().put("taskflowId", taskflowId);
                getMenuItems.getParamsMap().put("roleId", roleId);
                Row row = (Row) getMenuItems.execute();
                if (getMenuItems.getErrors().isEmpty() && !isNullOrEmptyObject(row)) {
                    Object taskFlowUrl = row.getAttribute("TaskflowUrl");
                    if (!isNullOrEmptyObject(taskFlowUrl)) {
                        taskFlowPath = "/WEB-INF/" + taskFlowUrl.toString() + "#" + taskflowId.replaceAll(".xml", "");
                        System.out.println("tasFlowPath : "+taskFlowPath);
                        setDynamicTaskFlowId(taskFlowPath);
                    }
                    else
                    {
                        System.out.println("inside else 1 : "+"/WEB-INF/com/rmi/login/view/pagetemplates/BlankTF.xml#BlankTF");
                        setDynamicTaskFlowId("/WEB-INF/com/rmi/login/view/pagetemplates/BlankTF.xml#BlankTF");
                    }
                }
                else
                {
                    System.out.println("inside else 2 : "+"/WEB-INF/com/rmi/login/view/pagetemplates/BlankTF.xml#BlankTF");
                    setDynamicTaskFlowId("/WEB-INF/com/rmi/login/view/pagetemplates/BlankTF.xml#BlankTF");
                }
            }
            else
            {
                System.out.println("inside else 3 : "+"/WEB-INF/com/rmi/login/view/pagetemplates/BlankTF.xml#BlankTF");
                setDynamicTaskFlowId("/WEB-INF/com/rmi/login/view/pagetemplates/BlankTF.xml#BlankTF");
            }
        } catch (Exception e) {
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching taskflow url." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
        return taskFlowPath;
    }

    public void fetchTaskflowUrl(ActionEvent actionEvent) {
        try {
            Object taskFlowId = actionEvent.getComponent().getAttributes().get("taskflowId");
            Object roleId = actionEvent.getComponent().getAttributes().get("roleId");
            if (!isNullOrEmptyObject(taskFlowId) && !isNullOrEmptyObject(roleId)) {
                getTaskflowUrl(taskFlowId.toString(), roleId.toString());
                AdfFacesContext.getCurrentInstance().addPartialTarget(regionBinding);
                setRoleDetails((BigDecimal) roleId);
//                menuCollapseBinding.setCollapsed(true);
//                AdfFacesContext.getCurrentInstance().addPartialTarget(menuCollapseBinding);
            }
        } catch (Exception e) {
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching taskflow url." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }

    public void setRoleDetails(BigDecimal roleId)
    {
        try 
        {
            if (roleId != null) {
                OperationBinding getRoleDetails = findOperation("getSingleRoleDetails");
                getRoleDetails.getParamsMap().put("userId", ADFContext.getCurrent().getSessionScope().get("UserId"));
                getRoleDetails.getParamsMap().put("roleId", roleId);
                Row row = (Row) getRoleDetails.execute();
                if (row != null) {
                    ADFContext.getCurrent().getSessionScope().put("RoleId", row.getAttribute("RoleId").toString());
                    ADFContext.getCurrent().getSessionScope().put("RoleName", row.getAttribute("RoleName").toString());
                    ADFContext.getCurrent().getSessionScope().put("RoleDescription",
                                                                  row.getAttribute("RoleDescription").toString());
                }
            }
        } catch (Exception e) {
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while setting role details." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }

    public void roleTabDisclosureListener(DisclosureEvent disclosureEvent) {
        try {
            if (disclosureEvent != null) {
                Object roleId = disclosureEvent.getComponent().getAttributes().get("roleId");
                if (roleId != null) {
                    OperationBinding getRoleDetails = findOperation("getSingleRoleDetails");
                    getRoleDetails.getParamsMap().put("userId", ADFContext.getCurrent().getSessionScope().get("UserId"));
                    getRoleDetails.getParamsMap().put("roleId", roleId);
                    Row row = (Row) getRoleDetails.execute();
                    if (getRoleDetails.getErrors().isEmpty()) {
                    }
                    if (row != null) {
                        System.out.println("inside roleTabDisclosureListener :: "+roleId);
                        ADFContext.getCurrent().getSessionScope().put("RoleId", row.getAttribute("RoleId").toString());
                        ADFContext.getCurrent().getSessionScope().put("RoleName", row.getAttribute("RoleName").toString());
                        ADFContext.getCurrent().getSessionScope().put("RoleDescription", row.getAttribute("RoleDescription").toString());
                        ADFContext.getCurrent().getSessionScope().put("DefaultTaskflow", row.getAttribute("DefaultTaskflow").toString());
                        ADFContext.getCurrent().getSessionScope().put("param_user_id", ADFContext.getCurrent().getSessionScope().get("UserId")); //NEW GAURAV ISSUE FIXES
                        ADFContext.getCurrent().getSessionScope().put("p_user_id", ADFContext.getCurrent().getSessionScope().get("UserId")); //NEW GAURAV ISSUE FIXES
                        ADFContext.getCurrent().getSessionScope().put("param_batch_status", "Pending"); // NEW GAURAV ISSUE FIXED
                        getTaskflowUrl(defaultTaskflowId, (((BigDecimal) roleId).toString()));
                    }
                }
            }
        } catch (Exception e) {
            JSFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching default qeueu." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
    }

    public void setRegionBinding(RichRegion regionBinding) {
        this.regionBinding = regionBinding;
    }

    public RichRegion getRegionBinding() {
        return regionBinding;
    }
      
    public void logout(ActionEvent actionEvent)
    {
        FacesContext fctx = FacesContext.getCurrentInstance();

        try 
        {
            ExternalContext ectx = fctx.getExternalContext();
            String url = getApplicationUrl() + "/seaf/adfAuthentication?logout=true&end_url="+getApplicationUrl()+"/seaf/Login";            
            String urlHttp = ectx.getRequestContextPath() + "/seaf/adfAuthentication?logout=true&end_url=seaf/Login";
//            HttpSession session = (HttpSession) ectx.getSession(false);
//            session.invalidate();
//            HttpServletRequest request = (HttpServletRequest) ectx.getRequest();
//            //               ServletAuthentication.logout(request);
//            request.logout();
//            ServletAuthentication.invalidateAll(request);
//            ServletAuthentication.killCookie(request);
            
            System.out.println("logout url :: "+url);            
            System.out.println("logout http url :: "+urlHttp);
            
            if(url != null)
                ADFContext.getCurrent().getApplicationScope().put("Url", url);

            if(urlHttp != null)
                ADFContext.getCurrent().getApplicationScope().put("HttpUrl", urlHttp);
            
            RmiJsfUtils.showPopup(homeButtonPopupBinding, true);
            ectx.redirect(urlHttp);
            
        } catch (Exception e) {
            e.printStackTrace();
            RmiJsfUtils.addFormattedFacesErrorMessage("System encountered some error while logging out.",
                                                      " Please contact system administrator :: "+e.getMessage(),
                                                      FacesMessage.SEVERITY_ERROR);
        }
        finally
        {
            fctx.responseComplete();            
        }
    }

    public String getApplicationUrl()
    {
        FacesContext facesCtx = FacesContext.getCurrentInstance();
        ExternalContext ectx = facesCtx.getExternalContext();
        HttpServletRequest req = (HttpServletRequest) ectx.getRequest();
        String url = req.getRequestURL().toString();
        return (url.substring(0, url.length() - req.getRequestURI().length()) + req.getContextPath());
    }

    public void setMenuCollapseBinding(RichPanelSplitter menuCollapseBinding) {
        this.menuCollapseBinding = menuCollapseBinding;
    }

    public RichPanelSplitter getMenuCollapseBinding() {
        return menuCollapseBinding;
    }

    public void setHomeButtonPopupBinding(RichPopup homeButtonPopupBinding) {
        this.homeButtonPopupBinding = homeButtonPopupBinding;
    }

    public RichPopup getHomeButtonPopupBinding() {
        return homeButtonPopupBinding;
    }
}
