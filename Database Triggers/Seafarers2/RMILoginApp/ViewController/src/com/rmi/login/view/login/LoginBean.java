package com.rmi.login.view.login;


import com.rmi.login.adfbc.utils.AdfUtils;
import com.rmi.login.view.utils.RmiAdfUtils;
import com.rmi.login.view.utils.RmiJsfUtils;
import com.rmi.login.view.utils.RmiUtils;
import static com.rmi.login.view.utils.RmiAdfUtils.findOperation;
import com.rmi.login.view.utils.RmiPasswordEncryptor;
import static com.rmi.login.view.utils.RmiUtils.isNullOrEmptyObject;
import static com.rmi.login.view.utils.RmiUtils.isNullOrEmptyString;

import java.sql.Timestamp;

import java.text.ParseException;
import java.text.SimpleDateFormat;

import java.util.Date;
import java.util.Random;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.faces.application.FacesMessage;
import javax.faces.application.ViewHandler;
import javax.faces.component.UIComponent;
import javax.faces.component.UIViewRoot;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;

import javax.faces.event.PhaseEvent;
import javax.faces.validator.ValidatorException;

import javax.security.auth.Subject;
import javax.security.auth.callback.CallbackHandler;
import javax.security.auth.login.FailedLoginException;

import javax.servlet.http.HttpServletRequest;

import javax.servlet.http.HttpSession;

import oracle.adf.model.BindingContext;
import oracle.adf.share.ADFContext;
import oracle.adf.share.logging.ADFLogger;
import oracle.adf.view.rich.component.rich.RichPoll;
import oracle.adf.view.rich.component.rich.RichPopup;
import oracle.adf.view.rich.component.rich.input.RichInputText;

import oracle.adf.view.rich.context.AdfFacesContext;

import oracle.adf.view.rich.event.PopupCanceledEvent;
import oracle.adf.view.rich.event.PopupFetchEvent;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

import oracle.jbo.Row;

import org.apache.myfaces.trinidad.event.PollEvent;

import weblogic.security.SimpleCallbackHandler;
import weblogic.security.services.Authentication;

import weblogic.servlet.security.ServletAuthentication;

public class LoginBean {
    @SuppressWarnings({
                      "compatibility:-3141168461614551632",
                      "oracle.jdeveloper.java.serialversionuid-field-in-nonserializable-class" })
    private static final long serialVersionUID = -2449918677504648555L;
    private static ADFLogger logger = ADFLogger.createADFLogger(LoginBean.class);
    private String userName = null;
    private String password = null;
    private String firstName = null;
    private String userId = null;
    private int randomInt = 0;
    private String usernametest = null;
    private RichInputText oldpassword;
    private RichInputText newpassword;
    private RichInputText confirmpassword;
    private String RoleID = null;
    private RichPopup passwrdpopup;
    private RichPopup forgotpasswordpopup;
    private RichInputText regemailid;
    private RichInputText regmobileno;
    private RichPopup onetimepasswordpopup;
    private String saltPassword = null;
    private RichInputText authenication;
    private Timestamp otpStartTime;
    private Timestamp otpEndTime;
    private RichPoll otpTimerPollBinding;
    private static String sessionCreated;

    public void setSaltPassword(String saltPassword) {
        this.saltPassword = saltPassword;
    }

    public String getSaltPassword() {
        return saltPassword;
    }
    private RichPopup authenticationpasswrdpopup;
    private RichInputText otpemail;

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserName() {
        return userName;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPassword() {
        return password;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserId() {
        return userId;
    }

    public void setRandomInt(int randomInt) {
        this.randomInt = randomInt;
    }

    public int getRandomInt() {
        return randomInt;
    }


    public void setUsernametest(String usernametest) {
        this.usernametest = usernametest;
    }

    public String getUsernametest() {
        return usernametest;
    }

    public void setOldpassword(RichInputText oldpassword) {
        this.oldpassword = oldpassword;
    }

    public RichInputText getOldpassword() {
        return oldpassword;
    }

    public void setNewpassword(RichInputText newpassword) {
        this.newpassword = newpassword;
    }

    public RichInputText getNewpassword() {
        return newpassword;
    }

    public void setConfirmpassword(RichInputText confirmpassword) {
        this.confirmpassword = confirmpassword;
    }

    public RichInputText getConfirmpassword() {
        return confirmpassword;
    }

    public void setRoleID(String RoleID) {
        this.RoleID = RoleID;
    }

    public String getRoleID() {
        return RoleID;
    }

    public void setPasswrdpopup(RichPopup passwrdpopup) {
        this.passwrdpopup = passwrdpopup;
    }

    public RichPopup getPasswrdpopup() {
        return passwrdpopup;
    }

    public void setForgotpasswordpopup(RichPopup forgotpasswordpopup) {
        this.forgotpasswordpopup = forgotpasswordpopup;
    }

    public RichPopup getForgotpasswordpopup() {
        return forgotpasswordpopup;
    }

    public void setRegemailid(RichInputText regemailid) {
        this.regemailid = regemailid;
    }

    public RichInputText getRegemailid() {
        return regemailid;
    }

    public void setRegmobileno(RichInputText regmobileno) {
        this.regmobileno = regmobileno;
    }

    public RichInputText getRegmobileno() {
        return regmobileno;
    }

    public void setOnetimepasswordpopup(RichPopup onetimepasswordpopup) {
        this.onetimepasswordpopup = onetimepasswordpopup;
    }

    public RichPopup getOnetimepasswordpopup() {
        return onetimepasswordpopup;
    }

    public BindingContainer getBindings() {
        return BindingContext.getCurrent().getCurrentBindingsEntry();
    }

    public void setAuthenticationpasswrdpopup(RichPopup authenticationpasswrdpopup) {
        this.authenticationpasswrdpopup = authenticationpasswrdpopup;
    }

    public RichPopup getAuthenticationpasswrdpopup() {
        return authenticationpasswrdpopup;
    }

    public void setOtpemail(RichInputText otpemail) {
        this.otpemail = otpemail;
    }

    public RichInputText getOtpemail() {
        return otpemail;
    }

    /**
     * This method will do the login of rmI User with SQL Authenticator.
     * gets the user and role details from DB and puts the same into Session scope.
     */
    @SuppressWarnings("unchecked")
    public String doLogin() {
        
        if(userName != null)
            userName = userName.toUpperCase();
        
        logger.info("doLogin method Start userName = " + userName);
        String action = "";
        //user name validation
        if (isNullOrEmptyString(userName)) {
            RmiJsfUtils.addFacesInformationMessage("Please enter username.");
            return null;
        }
        //password validation
        if (isNullOrEmptyString(password)) {
            RmiJsfUtils.addFacesInformationMessage("Please enter password.");
            return null;
        }

        Row userRow = null;
        Row roleRow = null;
        String encryptedPassword = RmiPasswordEncryptor.Encrypt(password);
                    
        try {
            //get user details by passing user name
            OperationBinding getUserDetails = findOperation("getUserDetails");
            getUserDetails.getParamsMap().put("userName", userName);
            userRow = (Row) getUserDetails.execute();

            if (userRow == null) {
                AdfUtils.addFormattedFacesErrorMessage("User does not exist in application. Please contact your System Administrator.",
                                                       "", FacesMessage.SEVERITY_ERROR);
                return null;
            }
            
            String userId = userRow.getAttribute("UserId").toString();
            
            OperationBinding getUserFNdDetails = findOperation("getUserRmiDetails");
            getUserFNdDetails.getParamsMap().put("pUserId", userId);
            Row userfndRow = (Row) getUserFNdDetails.execute();
            
            int countrmi = 99;
            if (!isNullOrEmptyObject(userRow) && getUserDetails.getErrors().isEmpty()) {
                
                this.setUserId(userId);
                logger.info("logged in userId = " + userId);
                //Account Inactive validation
                if (!isNullOrEmptyObject(userRow.getAttribute("InactiveDate"))) {
                    long millis = System.currentTimeMillis();
                    java.sql.Date date = new java.sql.Date(millis);
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    try {
                        Date date1 = sdf.parse(userRow.getAttribute("InactiveDate").toString());
                        Date date2 = sdf.parse(date.toString());
                        countrmi = date1.compareTo(date2);
                        
                    } catch (ParseException e) {
                        logger.severe("ParseException at account inactive validation for : " + userName);
                        e.printStackTrace();
                    }
                }
                
                int countfnd = 0;
                if (!(userId.equalsIgnoreCase("100000")) && (!isNullOrEmptyObject(userfndRow.getAttribute("EndDate")))) {
                    long millis = System.currentTimeMillis();
                    java.sql.Date date = new java.sql.Date(millis);
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    try {
                        Date date1 = sdf.parse(userfndRow.getAttribute("EndDate").toString());
                        Date date2 = sdf.parse(date.toString());
                        
                        countfnd = date1.compareTo(date2);
                       
                    } catch (ParseException e) {
                        logger.severe("ParseException at account inactive validation for : " + userName);
                        e.printStackTrace();
                    }
                    
                }
                
                if (countrmi <= 0 || countfnd < 0) {
                    
                    RmiJsfUtils.addFacesInformationMessage("Your account is no longer active, Please contact administrator.");
                    return null;
                }
                //password validation
                if (userRow.getAttribute("Status").toString().equalsIgnoreCase("P") 
                        && userRow.getAttribute("Password") != null) 
                {
                    String decryptedPassword = RmiPasswordEncryptor.Decrypt(userRow.getAttribute("Password").toString());
                    
//                    System.out.println("entered password :: "+password);
//                    System.out.println("DbPassword :: "+userRow.getAttribute("Password").toString());
//                    System.out.println("decrypted DbPassword :: "+decryptedPassword);
                    
                    if (decryptedPassword.equalsIgnoreCase(password)) {
                        RichPopup.PopupHints hints = new RichPopup.PopupHints();
                        getPasswrdpopup().show(hints);
                        return null;
                    } else {
                        RmiJsfUtils.addFacesInformationMessage("Please enter valid user name and password.");
                    return null;
                    }
                }
            } else {
                RmiJsfUtils.addFacesInformationMessage("User details not found in database, Please contact administrator.");
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while validating password. Please contact your System Administrator.",
                                          "", FacesMessage.SEVERITY_ERROR); 
        }
        String firstName = (userRow.getAttribute("FirstName") != null) 
                            ? userRow.getAttribute("FirstName").toString()
                            : userRow.getAttribute("LastName").toString();
        FacesContext facesContext = FacesContext.getCurrentInstance();
        //get role details
        OperationBinding getRoleDetails = findOperation("getRoleDetails");
        getRoleDetails.getParamsMap().put("userId", userId);
        roleRow = (Row) getRoleDetails.execute();
        Boolean userType = userRow.getAttribute("UserType").toString().equalsIgnoreCase("Internal");
//        logger.info("UserType :: "+userRow.getAttribute("UserType"));
            
        try 
        {
            //SQL Authenticator login logic
            ExternalContext externalContext = facesContext.getExternalContext();
            HttpServletRequest httpServletRequest = (HttpServletRequest) externalContext.getRequest();
            CallbackHandler callbackHandler = new SimpleCallbackHandler(userName, password.toCharArray());
            Subject mySubject = Authentication.login(callbackHandler);
            ServletAuthentication.runAs(mySubject, httpServletRequest);
            ServletAuthentication.generateNewSessionID(httpServletRequest);
                        
            int daysBetween = daysBetween((userRow.getAttribute("PasswordUpdationDate") != null) 
                                          ? (Timestamp) userRow.getAttribute("PasswordUpdationDate")
                                          : (Timestamp) userRow.getAttribute("CreationDate"), new Timestamp(System.currentTimeMillis()));
            if (daysBetween >= 90) {
                RmiJsfUtils.addFacesInformationMessage("Your password has expired. Please reset your password.");
                RmiJsfUtils.showPopup(passwrdpopup, true);
                return null;
            }

//            if (userType && !isNullOrEmptyObject(roleRow) && getRoleDetails.getErrors().isEmpty())
            if (false && !isNullOrEmptyObject(roleRow) && getRoleDetails.getErrors().isEmpty()) // commented to skip otp due to email issue
            {
                //sets SessionId for current login session 
                
                setSessionId(externalContext);
                setUserDetailsInSession(userRow);
                setRoleDetailsInSession(roleRow);
                
                OperationBinding updUsrLoginTimeOp = findOperation("updateUserLoginTime");
                updUsrLoginTimeOp.getParamsMap().put("userName", userName);
                updUsrLoginTimeOp.execute();
                
                action = "success";
            } else {
                try {
                    saltPassword = saltPassword();
                    if (!isNullOrEmptyString(saltPassword)) {
                        setSaltPassword(saltPassword);
                        String emailType = "Login_OTP";
                        OperationBinding sendMail = findOperation("sendMail");
                        sendMail.getParamsMap().put("to", userRow.getAttribute("EmailId"));
                        sendMail.getParamsMap().put("cc", null);
                        sendMail.getParamsMap().put("bcc", null);
                        sendMail.getParamsMap().put("subject", "RMI OSSD One Time Password  " + userName);
                        sendMail.getParamsMap().put("body", getEmailBody(emailType, userName, firstName, saltPassword));
                        sendMail.execute();
            //                    logger.info("after execute :: "+getEmailBody(emailType, userName, userRow.getAttribute("FirstName").toString(), saltPassword));
                        ADFContext.getCurrent().getPageFlowScope().put("OTP_EXPIRED", "N");
                        ADFContext.getCurrent().getPageFlowScope().put("OTP_INVALID", "N");
                        
                        RichPopup.PopupHints hints = new RichPopup.PopupHints();
                        getAuthenticationpasswrdpopup().show(hints);
                        if(authenication != null)
                            authenication.setValue(null);                        
                        
                        OperationBinding updUsrOtpTimeOp = findOperation("updateOtpTime");
                        updUsrOtpTimeOp.getParamsMap().put("userName", userName);
                        updUsrOtpTimeOp.execute();
                        
                        otpStartTime = new Timestamp(System.currentTimeMillis());
                        otpEndTime = new Timestamp(System.currentTimeMillis() + TimeUnit.MINUTES.toMillis(10));
                        
                    }
                } catch (Exception e) {
                    AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while sending email notification !",
                                                           "", FacesMessage.SEVERITY_ERROR);
                }
            }
        } catch (FailedLoginException e) {
            System.out.println("userName in doLogin FailedLoginException :: "+userName);
            System.out.println("password in doLogin FailedLoginException :: "+password);
            System.out.println("exception message :: "+e.getMessage());
            FacesMessage msg =
                new FacesMessage(FacesMessage.SEVERITY_ERROR, "Invalid username or password",
                                 "Invalid username or password");
            facesContext.addMessage(null, msg);
        } catch (Exception e) {
            System.out.println("userName in doLogin Exception :: "+userName);
            System.out.println("password in doLogin Exception :: "+password);
            System.out.println("exception message :: "+e.getMessage());
            e.printStackTrace();
//            RmiAdfUtils.printTmpLogs("printTmpLogs called :: "+e.getMessage());            
//                new FacesMessage(FacesMessage.SEVERITY_ERROR, e.getMessage(),
//                                 e.getMessage());
            FacesMessage msg =
                new FacesMessage(FacesMessage.SEVERITY_ERROR, "Please contact your Administrator",
                                 "");
            facesContext.addMessage(null, msg);
        }
        return action;
    }

    public String externalAgentLoginAction() 
    {
        FacesContext fctx = FacesContext.getCurrentInstance();
        Row userRow = null;
        Row roleRow = null;
        String action = null;
        String encryptedPassword = RmiPasswordEncryptor.Encrypt(password);
        Timestamp currentTime = new Timestamp(System.currentTimeMillis());
        
        if(userName != null)
            userName = userName.toUpperCase();
        
//        System.out.println("currentTime :: "+currentTime);        
//        System.out.println("otpEndTime :: "+otpEndTime);        
//        System.out.println("currentTime.compareTo(otpEndTime) :: "+currentTime.compareTo(otpEndTime));
        
        if(currentTime != null && otpEndTime != null && currentTime.compareTo(otpEndTime) > 0)
        {            
            ADFContext.getCurrent().getPageFlowScope().put("OTP_EXPIRED", "Y");
//            authenticationpasswrdpopup.hide();
//            RmiJsfUtils.addFormattedFacesErrorMessage("The entered OTP has expired. Please try again.",
//                                                      "", FacesMessage.SEVERITY_ERROR);
            return null;
        }
        
        if (authenication.getValue() != null && 
                authenication.getValue().toString().length() > 0) {
//            logger.info("external user otp" + saltPassword);
            Boolean authetVal = authenication.getValue().toString().equals(saltPassword);
            if (authetVal) {

                OperationBinding getUserDetails = findOperation("getUserDetails");
                getUserDetails.getParamsMap().put("userName", userName);
                userRow = (Row) getUserDetails.execute();

                OperationBinding getRoleDetails = findOperation("getRoleDetails");
                getRoleDetails.getParamsMap().put("userId", userId);
                roleRow = (Row) getRoleDetails.execute();
                
                try {
                    //SQL Authenticator login logic
                    ExternalContext externalContext = fctx.getExternalContext();
                    HttpServletRequest httpServletRequest = (HttpServletRequest) externalContext.getRequest();
                    CallbackHandler callbackHandler = new SimpleCallbackHandler(userName, password.toCharArray());
                    Subject mySubject = Authentication.login(callbackHandler);
                    ServletAuthentication.runAs(mySubject, httpServletRequest);
                    ServletAuthentication.generateNewSessionID(httpServletRequest);
                    
                    //sets SessionId for current login session
                    
                    setSessionId(externalContext);
                    setUserDetailsInSession(userRow);
                    setRoleDetailsInSession(roleRow);
                    
                    OperationBinding updUsrLoginTimeOp = findOperation("updateUserLoginTime");
                    updUsrLoginTimeOp.getParamsMap().put("userName", userName);
                    updUsrLoginTimeOp.execute();
                    
                    OperationBinding commitOp = findOperation("Commit");
                    commitOp.execute();
                    
                    action = "success";
                }catch (FailedLoginException e) {
                        FacesMessage msg =
                            new FacesMessage(FacesMessage.SEVERITY_ERROR,
                                             "Invalid Username or Password",
                                             "Invalid Username or Password");
                        fctx.addMessage(null, msg);
                }catch (Exception e) {
                    System.out.println("userName in doLogin Exception :: "+userName);
                    System.out.println("password in doLogin Exception :: "+password);
                    System.out.println("exception message :: "+e.getMessage());
                    e.printStackTrace();
//                    RmiAdfUtils.printTmpLogs("printTmpLogs called :: "+e.getMessage());
//                        new FacesMessage(FacesMessage.SEVERITY_ERROR, e.getMessage(),
//                                         e.getMessage());
                    FacesMessage msg =
                        new FacesMessage(FacesMessage.SEVERITY_ERROR,
                                         "Please contact your Administrator",
                                         "");
                    fctx.addMessage(null, msg);
                }
            }
            else {
                System.out.println("OTP_INVALID :: "+"Y");
                ADFContext.getCurrent().getPageFlowScope().put("OTP_INVALID", "Y");
            }
        }
        
        System.out.println("before return");
        return action;
    }

    public void setSessionId(ExternalContext externalContext)
    {
        if(externalContext != null)
        {
            HttpSession session = (HttpSession) externalContext.getSession(false);
            String sessionId = session.getId();
            String externalContextUrl = getExternalContextUrl();
            System.out.println("externalContextUrl :: "+externalContextUrl);
            if(externalContextUrl != null)
                ADFContext.getCurrent().getApplicationScope().put("ExternalContextUrl", externalContextUrl);
            
            String applicationUrl = getApplicationUrl();
            System.out.println("applicationUrl :: "+applicationUrl);
            if(applicationUrl != null)
                ADFContext.getCurrent().getApplicationScope().put("ApplicationUrl", applicationUrl);
            
//            System.out.println("applicationUrl :: "+ADFContext.getCurrent().getApplicationScope().get("ApplicationUrl"));
            ADFContext.getCurrent().getSessionScope().put("SessionId", new Integer(2));
        }
    }
    
    public int daysBetween(Timestamp t1, Timestamp t2) {
        return (int) ((t2.getTime() - t1.getTime()) / (1000 * 60 * 60 * 24));
    }

    public String getApplicationUrl()
    {
        FacesContext facesCtx = FacesContext.getCurrentInstance();
        ExternalContext ectx = facesCtx.getExternalContext();
        HttpServletRequest req = (HttpServletRequest) ectx.getRequest();
        String url = req.getRequestURL().toString();
//        return (url.substring(0, url.length() - req.getRequestURI().length()) + req.getContextPath()).replaceAll("http", "https");
        return (url.substring(0, url.length() - req.getRequestURI().length()) + req.getContextPath());
    }
    
    public String getExternalContextUrl()
    {
        FacesContext fctx = FacesContext.getCurrentInstance();
        ExternalContext ectx = fctx.getExternalContext();
        String url = ectx.getRequestContextPath();
        System.out.println("external context url :: "+url);        
        return url;
    }

    /**
     * This method will sets the user details in session scope
     * */
    @SuppressWarnings("unchecked")
    public String setUserDetailsInSession(Row row) {
        try {
            if (!isNullOrEmptyObject(row)) {
                ADFContext.getCurrent().getSessionScope().put("UserId", row.getAttribute("UserId").toString());
                ADFContext.getCurrent().getSessionScope().put("UserName", row.getAttribute("UserName").toString());
                ADFContext.getCurrent().getSessionScope().put("param_user_id",
                                                              ADFContext.getCurrent().getSessionScope().get("UserId")); //NEW GAURAV ISSUE FIXES
                ADFContext.getCurrent().getSessionScope().put("p_user_id",
                                                              ADFContext.getCurrent().getSessionScope().get("UserId")); //NEW GAURAV ISSUE FIXES
                ADFContext.getCurrent().getSessionScope().put("param_batch_status",
                                                              "Pending"); // NEW GAURAV ISSUE FIXED

                String firstName = (row.getAttribute("FirstName") != null) 
                                    ? row.getAttribute("FirstName").toString() 
                                    : row.getAttribute("LastName").toString();
                ADFContext.getCurrent().getSessionScope().put("FirstName", firstName);
                this.setUserName(row.getAttribute("UserName").toString());
                
                setDataCcontrolFrameToSession();
            }
        } catch (Exception e) {
            RmiJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while validating user details. Please contact your System Administrator. !",
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }    
    
    public void setDataCcontrolFrameToSession() {
        String dcFrameName =
            BindingContext.getCurrent().getCurrentDataControlFrame();
        System.out.println("Frame name: " + dcFrameName);

        FacesContext ctx = FacesContext.getCurrentInstance();
        HttpSession session =
            (HttpSession)ctx.getExternalContext().getSession(false);
        session.setAttribute("DC_FRAME_NAME", dcFrameName);
    }

    /**
     * set the role details is session
     * */
    @SuppressWarnings("unchecked")
    public String setRoleDetailsInSession(Row row) {
        try {
            if (!isNullOrEmptyObject(row)) {
                ADFContext.getCurrent().getSessionScope().put("RoleId", row.getAttribute("RoleId").toString());
                ADFContext.getCurrent().getSessionScope().put("RoleName", row.getAttribute("RoleName").toString());
                ADFContext.getCurrent().getSessionScope().put("RoleDescription",
                                                              row.getAttribute("RoleDescription").toString());
                ADFContext.getCurrent().getSessionScope().put("DefaultTaskflow","/WEB-INF/com/rmi/login/view/pagetemplates/BlankTF.xml#BlankTF");
//                ADFContext.getCurrent().getSessionScope().put("DefaultTaskflow",row.getAttribute("DefaultTaskflow").toString());
            }
        } catch (Exception e) {
            RmiJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while validating user details. Please contact your System Administrator. !",
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }

    /**
     * genarate the salt password and returns the salt password
     * */
    public String saltPassword() {
        String SALTCHARS = "Aab@_15C665DEH@@GU75873RFH@JSH87957DHHF6784!_cdefghijk@lmnopqrstBCP986747383650";
        StringBuilder saltPassword = new StringBuilder();
        Random random = new Random();
        try {
            while (saltPassword.length() < 6) { // length of the random string.
                int index = (int) (random.nextFloat() * SALTCHARS.length());
                saltPassword.append(SALTCHARS.charAt(index));
            }
        } catch (Exception e) {
            RmiJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while generating password/otp." +
                                                   " Please contact your System Administrator.", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
        return saltPassword.toString();
    }

    /**
     * reset the user name and password
     * */
    public String reset(ActionEvent actionEvent) {
        if (!isNullOrEmptyString(userName) && !isNullOrEmptyString(password)) {
            try {
                OperationBinding getUserDetails = RmiAdfUtils.findOperation("getUserDetails");
                getUserDetails.getParamsMap().put("userName", userName.toUpperCase());
                Row row = (Row) getUserDetails.execute();
                if (getUserDetails.getErrors().isEmpty() && !isNullOrEmptyObject(row)) {
                    String decryptedPassword = RmiPasswordEncryptor.Decrypt(row.getAttribute("Password").toString());
//                    String decryptedPassword = row.getAttribute("Password").toString();
                    Boolean processing = row.getAttribute("Status").toString().equalsIgnoreCase("A");
                    Boolean active = row.getAttribute("Status").toString().equalsIgnoreCase("P");
                    Boolean validate = decryptedPassword.equals(password);
                    Boolean uservalidate = row.getAttribute("UserName").toString().equals(userName.toUpperCase());
                    if (uservalidate.equals(false)) {
                        RmiJsfUtils.addFacesInformationMessage("Please enter valid User");
                        return null;
                    }
                    if (validate.equals(false)) {
                        RmiJsfUtils.addFacesErrorMessage("Please enter valid password");
                        return null;
                    }
                    if (processing.equals(true) || active.equals(true)) {
                        RichPopup.PopupHints hints = new RichPopup.PopupHints();
                        getPasswrdpopup().show(hints);
                    }
                } else {
                    RmiJsfUtils.addFacesErrorMessage("Please enter valid user/password");
                    return null;
                }
            } catch (Exception e) {
                RmiJsfUtils.addFormattedFacesErrorMessage("System encountered an exception during password reset. Please contact your System Administrator.",
                                                          "", FacesMessage.SEVERITY_ERROR);
            }
        }
        return null;
    }

    /**
     * this method for forget password
     * */
    public String forgotPassword(ActionEvent actionEvent) {
        try {
            if (!isNullOrEmptyString(userName)) {
                OperationBinding getUserDetails = findOperation("getUserDetails");
                getUserDetails.getParamsMap().put("userName", userName.toUpperCase());
                Row row = (Row) getUserDetails.execute();
                if (getUserDetails.getErrors().isEmpty() && !isNullOrEmptyObject(row)) {
                    Boolean Status = row.getAttribute("Status").toString().equals("A");
                    Boolean uservalidate = row.getAttribute("UserName").toString().equals(userName.toUpperCase());
                        RmiJsfUtils.showPopup(this.forgotpasswordpopup, true);
                        AdfFacesContext.getCurrentInstance().addPartialTarget(forgotpasswordpopup);
                } else {
                    RmiJsfUtils.addFacesErrorMessage("Please enter valid username");
                    return null;
                }
            } else {
                RmiJsfUtils.addFacesErrorMessage("Please enter valid username");
                return null;
            }
        } catch (Exception e) {
            RmiJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while using �Forgot Password�. Please contact your System Administrator.",
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }

    /**
     * method for validationg new password
     *
     * */
    public void newpasswordValidator(FacesContext facesContext, UIComponent uIComponent, Object object) 
    {
        if (!isNullOrEmptyObject(object)) {
            String name = object.toString();
//            String expression = "((?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%]).{6,20})";
            String expression = "((?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+=|<>?{}\\\\[\\\\]~-]).{6,20})";
            CharSequence charSequence = name;
            Pattern pattern = Pattern.compile(expression);
            Matcher matcher = pattern.matcher(charSequence);
            String msg =
                "Password must be of minimum 6 characters and maximum 20. Must contain one digit, one special character, one lowercase character and one uppercase character";
            if (!matcher.matches()) {
                throw new ValidatorException(new FacesMessage(FacesMessage.SEVERITY_ERROR, null, msg));
            }

            OperationBinding vldtPwdHistOp = findOperation("validatePasswordHistory");
            vldtPwdHistOp.getParamsMap().put("password", name);
            vldtPwdHistOp.getParamsMap().put("userName", userName);
            String vldtPwdHistOpResult = (String) vldtPwdHistOp.execute();
            
            msg = "Please enter another password as this password has been used recently.";
            if(vldtPwdHistOpResult != null && vldtPwdHistOpResult.equalsIgnoreCase("N"))
                throw new ValidatorException(new FacesMessage(FacesMessage.SEVERITY_ERROR, null, msg));
        }
    }

    /**
     * method for validationg confirm password
     *
     * */
    public void confirmpasswordValidator(FacesContext facesContext, UIComponent uIComponent, Object object) 
    {
        if (!RmiUtils.isNullOrEmptyObject(object)) {
            String name = object.toString();
            String expression = "((?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+=|<>?{}\\\\[\\\\]~-]).{6,20})";
            CharSequence charSequence = name;
            Pattern pattern = Pattern.compile(expression);
            Matcher matcher = pattern.matcher(charSequence);
            String msg =
                "Password must be of minimum 6 characters and maximum 20. Must contain one digit, one special character, one lowercase character and one uppercase character";
            if (!matcher.matches()) {
                throw new ValidatorException(new FacesMessage(FacesMessage.SEVERITY_ERROR, null, msg));
            }
        }
    }

    /**
     * This method for the change password option
     * */
    public String changePassword(ActionEvent actionEvent) {
        try {
            OperationBinding getUserDetais = findOperation("getUserDetails");
            getUserDetais.getParamsMap().put("userName", userName.toUpperCase());
            Row row = (Row) getUserDetais.execute();
            if (getUserDetais.getErrors().isEmpty() && !isNullOrEmptyObject(row)) 
            {
                String decryptedPassword = RmiPasswordEncryptor.Decrypt(row.getAttribute("Password").toString());
//                String decryptedPassword = row.getAttribute("Password").toString();
                    
                if (oldpassword.getValue() != null && newpassword.getValue() != null 
                     && confirmpassword.getValue() != null) 
                {
                    Boolean value = oldpassword.getValue().toString().equals(decryptedPassword);
                    if (value.equals(false)) {
                        RmiJsfUtils.addFormattedFacesErrorMessage("Old Password does not match",
                                                                  "Old Password does not match !",
                                                                  FacesMessage.SEVERITY_WARN);
                        return null;
                    }
                    if (oldpassword.getValue().toString().equals(password) &&
                        newpassword.getValue().toString().equals(password) &&
                        confirmpassword.getValue().toString().equals(password)) {
                        RmiJsfUtils.addFormattedFacesErrorMessage("The Old Password and New Password should not be the same.",
                                                                  "The Old Password and New Password should not be the same. ",
                                                                  FacesMessage.SEVERITY_WARN);
                        return null;
                    }
                    if (newpassword.getValue().toString().equals(confirmpassword.getValue().toString())) {
                        OperationBinding changePassword = findOperation("changePassword");
                        changePassword.getParamsMap().put("userName", userName.toUpperCase());
                        changePassword.getParamsMap().put("password", RmiPasswordEncryptor.Encrypt(confirmpassword.getValue().toString()));
                        changePassword.execute();                        
                        
                        String emailType = "Login_PasswordReset";
                        String firstName = (row.getAttribute("EmailId") != null && row.getAttribute("FirstName") != null) 
                                            ? row.getAttribute("FirstName").toString()
                                            : userName.toUpperCase();
                        String emailBody = getEmailBody(emailType, userName.toUpperCase(), firstName, confirmpassword.getValue().toString());                        
                        OperationBinding sendMail = findOperation("sendMail");
                        sendMail.getParamsMap().put("to", row.getAttribute("EmailId"));
//                        sendMail.getParamsMap().put("cc", row.getAttribute("EmailId"));
                        sendMail.getParamsMap().put("cc", null);
                        sendMail.getParamsMap().put("bcc", null);
                        sendMail.getParamsMap().put("subject", "RMI OSSD Password Reset Notification  " + userName.toUpperCase());
                        sendMail.getParamsMap().put("body", emailBody);
                        sendMail.execute();
                        
                        RichPopup.PopupHints hints = new RichPopup.PopupHints();
                        getPasswrdpopup().hide();
                        oldpassword.resetValue();
                        newpassword.resetValue();
                        confirmpassword.resetValue();
                        RmiJsfUtils.addFormattedFacesErrorMessage("Password has been successfully reset. A notification has been sent to your registered Email address.",
                                                                  "Password has been successfully reset.",
                                                                  FacesMessage.SEVERITY_INFO);
                    } else {
                        RmiJsfUtils.addFormattedFacesErrorMessage("New Password and Confirm Password does not match",
                                                                  "New Password and Confirm Password does not match",
                                                                  FacesMessage.SEVERITY_ERROR);
                        return null;
                    }
                } else {
                    RmiJsfUtils.addFormattedFacesErrorMessage("Please enter password", "Please enter password",
                                                              FacesMessage.SEVERITY_ERROR);
                    return null;
                }
            }
        } catch (Exception e) {
            RmiJsfUtils.addFormattedFacesErrorMessage("System encountered an exception during password reset. Please contact your System Administrator.",
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }

    @SuppressWarnings("unchecked")
    public String confirmForgPassword(ActionEvent actionEvent) {
        FacesContext fctx = FacesContext.getCurrentInstance();
        try {
            if (regemailid.getValue() != null || regmobileno.getValue() != null) 
            {                
                OperationBinding getUserDetails = RmiAdfUtils.findOperation("getUserDetails");
                getUserDetails.getParamsMap().put("userName", userName.toUpperCase());
                Row row = (Row) getUserDetails.execute();
                if (getUserDetails.getErrors().isEmpty() && !isNullOrEmptyObject(row)) 
                {
                    String emailId = (row.getAttribute("EmailId") != null) ? row.getAttribute("EmailId").toString() : "";
                    String contact = (row.getAttribute("Contact") != null) ? row.getAttribute("Contact").toString() : "";
                    
                    Boolean Validateemailid = ((regemailid.getValue() != null) 
                        ? emailId.equalsIgnoreCase(regemailid.getValue().toString())
                        : true);
                    Boolean Validatemobile =((regmobileno.getValue() != null) 
                        ? contact.equalsIgnoreCase(regmobileno.getValue().toString())
                        : true);
                    
                    if (Validateemailid.equals(true) && Validatemobile.equals(true)) {
                        String saltPassword = null;
                        saltPassword = saltPassword();
                        if (!RmiUtils.isNullOrEmptyString(saltPassword)) {
                            OperationBinding sendMail = findOperation("sendMail");
                            String emailType = "Login_ForgotPassword";
                            String firstName = (row.getAttribute("EmailId") != null && row.getAttribute("FirstName") != null) 
                                                ? row.getAttribute("FirstName").toString()
                                                : userName.toUpperCase();
                            String body = getEmailBody(emailType, userName.toUpperCase(), firstName, saltPassword);
                            sendMail.getParamsMap().put("to", row.getAttribute("EmailId"));
//                            sendMail.getParamsMap().put("cc", row.getAttribute("EmailId"));
//                            sendMail.getParamsMap().put("bcc", row.getAttribute("EmailId"));
                            sendMail.getParamsMap().put("cc", null);
                            sendMail.getParamsMap().put("bcc", null);
                            sendMail.getParamsMap().put("subject", "RMI OSSD Password Reset Notification  " + userName.toUpperCase());
                            sendMail.getParamsMap().put("body", body);
                            sendMail.execute();
                            
                            OperationBinding setResetPassword = findOperation("setResetPassword");
                            setResetPassword.getParamsMap().put("userName", userName.toUpperCase());
                            setResetPassword.getParamsMap().put("resetPassword", RmiPasswordEncryptor.Encrypt(saltPassword));
                            setResetPassword.execute();
                            regemailid.resetValue();
                            regmobileno.resetValue();
                            forgotpasswordpopup.hide();
                            FacesMessage fm=new FacesMessage("Password has been sent on Registered Email ID.");
                            fctx = FacesContext.getCurrentInstance();
                            fctx.addMessage(null,fm);
                        }
                    } else {
                        RmiJsfUtils.addFormattedFacesErrorMessageDetail("",
                                                                  "Dear User, The Registered Email Address entered by you does not match with the details entered in our database. Please enter the correct details or contact the respective office for futher assistance.",
                                                                  FacesMessage.SEVERITY_ERROR);
                        return null;
                    }
                } else {
                    RmiJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while resetting password. Please contact your System Administrator.", 
                                                              "",
                                                              FacesMessage.SEVERITY_ERROR);
                    return null;
                }
            } else {
                RmiJsfUtils.addFormattedFacesErrorMessageDetail("", "Please enter Registered Email ID !",
                                                          FacesMessage.SEVERITY_ERROR);
                return null;
            }
        } catch (Exception e) {
            RmiJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while using �Forgot Password�. Please contact your System Administrator.",
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }

    public String confirmonetimePassword(ActionEvent actionEvent) {
        try {
            if (!isNullOrEmptyObject(otpemail.getValue()) && !isNullOrEmptyObject(otpemail.getValue())) {
                OperationBinding getUserDetails = findOperation("getUserDetails");
                getUserDetails.getParamsMap().put("username", userName.toUpperCase());
                Row row = (Row) getUserDetails.execute();
                if (getUserDetails.getErrors().isEmpty() && !isNullOrEmptyObject(row)) {
                    Boolean validateotp =
                        row.getAttribute("ResetPassword").toString().equals(otpemail.getValue().toString());
                    if (validateotp.equals(true)) {
                        OperationBinding changePassword = findOperation("changePassword");
                        changePassword.getParamsMap().put("username", userName.toUpperCase());
                        changePassword.getParamsMap().put("password", row.getAttribute("ResetPassword").toString());
                        changePassword.execute();
                        RichPopup.PopupHints hints = new RichPopup.PopupHints();
                        getOnetimepasswordpopup().hide();
                        getPasswrdpopup().show(hints);
                    } else {
                        RmiJsfUtils.addFormattedFacesErrorMessage("Please enter correct password",
                                                                  "Please enter correct password",
                                                                  FacesMessage.SEVERITY_ERROR);
                        return null;
                    }
                }
            }
        } catch (Exception e) {
            RmiJsfUtils.addFormattedFacesErrorMessage("System encountered an exception while entering OTP. Please contact your System Administrator.",
                                                      "", FacesMessage.SEVERITY_ERROR);
        }
        return null;
    }

    public String getEmailBody(String emailType, String userName, String firstName, String password) {
        String body, firstname, username, passwrd = null;
        try {            
            if (!isNullOrEmptyObject(emailType) && !isNullOrEmptyObject(userName)
                 && !isNullOrEmptyObject(firstName) && !isNullOrEmptyObject(password)) {
                OperationBinding getEmailNotifBody = findOperation("getEmailNotifBody");
                getEmailNotifBody.getParamsMap().put("emailType", emailType);
                Row row = (Row) getEmailNotifBody.execute();
                if (getEmailNotifBody.getErrors().isEmpty() && !isNullOrEmptyObject(row)) {
                    body = row.getAttribute("EmailBody").toString();
                    firstname = body.replaceAll("#FIRSTNAME", firstName);
                    username = firstname.replaceAll("#USERNAME", userName);
                    passwrd = username.replaceAll("#PASSWORD", password);
//                    newLine = passwrd.replaceAll("\\n", "\n");
                }
            }
        } catch (Exception e) {
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching email details !", "",
                                                   FacesMessage.SEVERITY_ERROR);
        }
        return passwrd;
    }

    public void setAuthenication(RichInputText authenication) {
        this.authenication = authenication;
    }

    public RichInputText getAuthenication() {
        return authenication;
    }

    public void forgotPasswordPopupFetchListener(PopupFetchEvent popupFetchEvent)
    {
        if(regemailid != null && regmobileno != null)
        {
            regemailid.resetValue();
            regmobileno.resetValue();
        }
    }

    public void setOtpStartTime(Timestamp otpStartTime) {
        this.otpStartTime = otpStartTime;
    }

    public Timestamp getOtpStartTime() {
        return otpStartTime;
    }

    public void setOtpEndTime(Timestamp otpEndTime) {
        this.otpEndTime = otpEndTime;
    }

    public Timestamp getOtpEndTime() {
        return otpEndTime;
    }

    public void resendOtpAL(ActionEvent actionEvent) 
    {
        try 
        {
            if(userName != null)
            {
                OperationBinding getUserDetails = findOperation("getUserDetails");
                getUserDetails.getParamsMap().put("userName", userName.toUpperCase());
                Row userRow = (Row) getUserDetails.execute();

                String firstName = (userRow.getAttribute("FirstName") != null) 
                                    ? userRow.getAttribute("FirstName").toString()
                                    : userRow.getAttribute("LastName").toString();

                if (userRow == null) {
                    AdfUtils.addFormattedFacesErrorMessage("User does not exist in application. Please contact your System Administrator.",
                                                           "", FacesMessage.SEVERITY_ERROR);
                    return;
                }
                
                saltPassword = saltPassword();
//                System.out.println("saltPassword :: "+saltPassword);
                if (!isNullOrEmptyString(saltPassword)) {
                    setSaltPassword(saltPassword);
                    String emailType = "Login_OTP";
                    OperationBinding sendMail = findOperation("sendMail");
                    sendMail.getParamsMap().put("to", userRow.getAttribute("EmailId"));
                    sendMail.getParamsMap().put("cc", null);
                    sendMail.getParamsMap().put("bcc", null);
                    sendMail.getParamsMap().put("subject", "RMI OSSD One Time Password  " + userName);
                    sendMail.getParamsMap().put("body", getEmailBody(emailType, userName, firstName, saltPassword));
                    sendMail.execute();
                //                    logger.info("after execute :: "+getEmailBody(emailType, userName, userRow.getAttribute("FirstName").toString(), saltPassword));

                    OperationBinding updUsrOtpTimeOp = findOperation("updateOtpTime");
                    updUsrOtpTimeOp.getParamsMap().put("userName", userName);
                    updUsrOtpTimeOp.execute();
                    
                    otpStartTime = new Timestamp(System.currentTimeMillis());
                    otpEndTime = new Timestamp(System.currentTimeMillis() + TimeUnit.MINUTES.toMillis(10));
                    ADFContext.getCurrent().getPageFlowScope().put("OTP_EXPIRED", "N");
                    ADFContext.getCurrent().getPageFlowScope().put("OTP_INVALID", "N");
                    authenication.setValue(null);
                    AdfFacesContext.getCurrentInstance().addPartialTarget(authenication);
                }
            }            
        } catch (Exception e) {
            e.printStackTrace();
            AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while sending email notification !",
                                                   "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void refreshOtpEndTimePollListener(PollEvent pollEvent)
    {
        OperationBinding refreshOtpEndTimeOp = findOperation("refreshOtpEndTime");
        refreshOtpEndTimeOp.getParamsMap().put("otpEndTime", otpEndTime);
        refreshOtpEndTimeOp.execute();
    }

    public void setOtpTimerPollBinding(RichPoll otpTimerPollBinding) {
        this.otpTimerPollBinding = otpTimerPollBinding;
    }

    public RichPoll getOtpTimerPollBinding() {
        return otpTimerPollBinding;
    }

    public void otpPopupCanceledListener(PopupCanceledEvent popupCanceledEvent)
    {
        FacesContext fctx = FacesContext.getCurrentInstance();
        String pageToRefresh = fctx.getViewRoot().getViewId(); //getting View Id of current page
        ViewHandler viewHandler = fctx.getApplication().getViewHandler();
        UIViewRoot viewRoot = viewHandler.createView(fctx, pageToRefresh); //ViewRoot for current page
        viewRoot.setViewId(pageToRefresh);
        fctx.setViewRoot(viewRoot);
    }

    public void loginBeforePhaseListener(PhaseEvent phaseEvent)
    {
        try 
        {
            System.out.println("loginBeforePhaseListener :: "+phaseEvent.getSource());
            System.out.println("sessionCreated :: "+this.sessionCreated);
            
            if(this.sessionCreated != null)
            {
                FacesContext fctx = FacesContext.getCurrentInstance();
                ExternalContext ectx = fctx.getExternalContext();
                HttpSession oldSession = (HttpSession) ectx.getSession(false);
                System.out.println("oldSession.getId() :: "+oldSession.getId());
                oldSession.invalidate();
                HttpServletRequest request = (HttpServletRequest) ectx.getRequest();
                ServletAuthentication.invalidateAll(request);
                ServletAuthentication.killCookie(request);
                HttpSession newSession = (HttpSession) ectx.getSession(true);
                System.out.println("newSession.getId() :: "+newSession.getId());
            }
            else
            {
                System.out.println("already created :: "+this.sessionCreated);
                this.sessionCreated = "Y";
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}