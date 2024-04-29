package com.rmi.applicationEntry.view.submittedbatchestaskflow;

import com.rmi.applicationEntry.view.utils.ADFUtils;

import java.util.Map;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;

import oracle.adf.controller.binding.BindingUtils;
import oracle.adf.model.BindingContext;
import oracle.adf.model.binding.DCBindingContainer;
import oracle.adf.model.binding.DCIteratorBinding;
import oracle.adf.view.rich.context.AdfFacesContext;
import oracle.adf.view.rich.event.PopupFetchEvent;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

import oracle.jbo.Row;
import oracle.jbo.ViewObject;

public class SubmittedBatchesBean {
    public SubmittedBatchesBean() {
    }
    String securityLink;
    String consentLink;
    String additionalDocLink;

    public void setAdditionalDocLink(String additionalDocLink) {
        this.additionalDocLink = additionalDocLink;
    }

    public String getAdditionalDocLink() {
        return additionalDocLink;
    }

    public void setConsentLink(String consentLink) {
        this.consentLink = consentLink;
    }

    public String getConsentLink() {
        return consentLink;
    }
    String securityLinkVisible;
    String attestaionLinkVisible;

    public void setSecurityLink(String securityLink) {
        this.securityLink = securityLink;
    }

    public String getSecurityLink() {
        return securityLink;
    }

    public void setSecurityLinkVisible(String securityLinkVisible) {
        this.securityLinkVisible = securityLinkVisible;
    }

    public String getSecurityLinkVisible() {
        return securityLinkVisible;
    }

    public void setAttestaionLinkVisible(String attestaionLinkVisible) {
        this.attestaionLinkVisible = attestaionLinkVisible;
    }

    public String getAttestaionLinkVisible() {
        return attestaionLinkVisible;
    }

    public void setAffidavitLinkVisible(String affidavitLinkVisible) {
        this.affidavitLinkVisible = affidavitLinkVisible;
    }

    public String getAffidavitLinkVisible() {
        return affidavitLinkVisible;
    }

    public void setSupportLinkVisible(String supportLinkVisible) {
        this.supportLinkVisible = supportLinkVisible;
    }

    public String getSupportLinkVisible() {
        return supportLinkVisible;
    }

    public void setIdentityLinkVisible(String identityLinkVisible) {
        this.identityLinkVisible = identityLinkVisible;
    }

    public String getIdentityLinkVisible() {
        return identityLinkVisible;
    }

    public void setMedicalLinkVisible(String medicalLinkVisible) {
        this.medicalLinkVisible = medicalLinkVisible;
    }

    public String getMedicalLinkVisible() {
        return medicalLinkVisible;
    }

    public void setSeaserviceLinkVisible(String seaserviceLinkVisible) {
        this.seaserviceLinkVisible = seaserviceLinkVisible;
    }

    public String getSeaserviceLinkVisible() {
        return seaserviceLinkVisible;
    }

    public void setPhotoLink(String photoLink) {
        this.photoLink = photoLink;
    }

    public String getPhotoLink() {
        return photoLink;
    }

    public void setIdentityLink(String identityLink) {
        this.identityLink = identityLink;
    }

    public String getIdentityLink() {
        return identityLink;
    }

    public void setMedicalLink(String medicalLink) {
        this.medicalLink = medicalLink;
    }

    public String getMedicalLink() {
        return medicalLink;
    }

    public void setSeaserviceLink(String seaserviceLink) {
        this.seaserviceLink = seaserviceLink;
    }

    public String getSeaserviceLink() {
        return seaserviceLink;
    }

    public void setAttestaionLink(String attestaionLink) {
        this.attestaionLink = attestaionLink;
    }

    public String getAttestaionLink() {
        return attestaionLink;
    }

    public void setAffidavitLink(String affidavitLink) {
        this.affidavitLink = affidavitLink;
    }

    public String getAffidavitLink() {
        return affidavitLink;
    }

    public void setSupportLink(String supportLink) {
        this.supportLink = supportLink;
    }

    public String getSupportLink() {
        return supportLink;
    }
    String affidavitLinkVisible;
    String supportLinkVisible;
    String identityLinkVisible;
    String medicalLinkVisible;
    String seaserviceLinkVisible;
    String photoLink;
    String identityLink;
    String medicalLink;
    String seaserviceLink;
    String attestaionLink;
    String affidavitLink;
    String supportLink;
    public BindingContainer getBindings(){
            return BindingContext.getCurrent().getCurrentBindingsEntry();
        }
    public void documentPopupFetchlistener(PopupFetchEvent popupFetchEvent) {
//        System.out.println("-------in the fetch listener");
        try {
            OperationBinding ob1 = getBindings().getOperationBinding("getUsertypeForBatchesPage");
            String user_type = ob1.execute().toString();

                    System.out.println("user_type ---"+user_type);
            OperationBinding ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0002");
            String path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
//            System.out.println(path + "------path");
            setPhotoLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0003");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
path = object.toString();                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
//            System.out.println(path + "------path");
            setIdentityLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0004");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
path = object.toString();                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
//            System.out.println(path + "------path");
            setMedicalLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0008");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
path = object.toString();                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
//            System.out.println(path + "------path");
            setSeaserviceLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0001");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
path = object.toString();                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
//            System.out.println(path + "------path");
            setAttestaionLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0009");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
path = object.toString();                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
//            System.out.println(path + "------path");
            setAffidavitLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0016");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
path = object.toString();                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
//            System.out.println(path + "------path");
            setSecurityLink(path);

            ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0031");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
path = object.toString();                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
//            System.out.println(path + "------path");
            setSupportLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0025");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
path = object.toString();                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
//            System.out.println(path + "------path");
            setConsentLink(path);
            
            
            ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0033");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
path = object.toString();                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //            System.out.println(path + "------path");
            setAdditionalDocLink(path);

            if (user_type.equalsIgnoreCase("External")) {
                setIdentityLinkVisible("Y");
                setMedicalLinkVisible("Y");
                setAffidavitLinkVisible("Y");
                setAttestaionLinkVisible("Y");
                setSeaserviceLinkVisible("Y");
                setSecurityLinkVisible("Y");
                setSupportLinkVisible("N");
            } else {
                setIdentityLinkVisible("N");
                setMedicalLinkVisible("N");
                setAffidavitLinkVisible("N");
                setAttestaionLinkVisible("N");
                setSeaserviceLinkVisible("N");
                setSecurityLinkVisible("N");
                setSupportLinkVisible("Y");
            }
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching data." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
    }

    public String editButtonOnRejectedTab() {
        try {
            BindingContext context = BindingUtils.getBindingContext();
            DCBindingContainer bindings = (DCBindingContainer) context.getCurrentBindingsEntry();
            DCIteratorBinding iterator;
            iterator = (DCIteratorBinding) bindings.findIteratorBinding("BatchesRejectedROIterator");
            ViewObject PendingBatchVO = iterator.getViewObject();
            Row currRow = PendingBatchVO.getCurrentRow();
            Integer batchId = Integer.parseInt(currRow.getAttribute("EsiBatchId").toString());


            AdfFacesContext adfFacesContext = AdfFacesContext.getCurrentInstance();
            Map pageFlowScope = adfFacesContext.getPageFlowScope();
            pageFlowScope.put("batchMode", "edit");
            pageFlowScope.put("batchNumber", batchId);
            pageFlowScope.put("batchReject", "yes");
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while processing." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
        return "batchCreateEdit";
    }

    public void requestedPopupFetchListener(PopupFetchEvent popupFetchEvent) {
        try {
            OperationBinding ob1 = getBindings().getOperationBinding("getUsertypeForBatchesPage");
            String user_type = ob1.execute().toString();

            //        System.out.println("user_type ---"+user_type);
            OperationBinding ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0002");
            String path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setPhotoLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0003");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setIdentityLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0004");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setMedicalLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0008");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setSeaserviceLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0001");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setAttestaionLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0009");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setAffidavitLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0016");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setSecurityLink(path);

            ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0031");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setSupportLink(path);
            ob = getBindings().getOperationBinding("getlinkforBatchespage");
            ob.getParamsMap().put("code", "0025");
            path = null;
            try {
                Object object = ob.execute();
                if(object != null)
                {
                    path = object.toString();
                }
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setConsentLink(path);

            if (user_type.equalsIgnoreCase("External")) {
                setIdentityLinkVisible("Y");
                setMedicalLinkVisible("Y");
                setAffidavitLinkVisible("Y");
                setAttestaionLinkVisible("Y");
                setSeaserviceLinkVisible("Y");
                setSecurityLinkVisible("Y");
                setSupportLinkVisible("N");
            } else {
                setIdentityLinkVisible("N");
                setMedicalLinkVisible("N");
                setAffidavitLinkVisible("N");
                setAttestaionLinkVisible("N");
                setSeaserviceLinkVisible("N");
                setSecurityLinkVisible("N");
                setSupportLinkVisible("Y");
            }
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while loading popup." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
        }
    }

    public void batchDetailPopupFetchListener(PopupFetchEvent popupFetchEvent) {
        OperationBinding ob = getBindings().getOperationBinding("filterOrderHold");
            ob.execute();    }
}
