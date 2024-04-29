package com.rmi.applicationEntry.view.taskassignmenttaskflow;

import com.rmi.applicationEntry.view.utils.ADFUtils;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;

import javax.faces.event.ValueChangeEvent;

import oracle.adf.controller.binding.BindingUtils;
import oracle.adf.model.BindingContext;
import oracle.adf.model.binding.DCBindingContainer;
import oracle.adf.model.binding.DCIteratorBinding;

import oracle.adf.view.rich.component.rich.RichPopup;

import oracle.adf.view.rich.component.rich.data.RichTable;
import oracle.adf.view.rich.component.rich.input.RichSelectBooleanCheckbox;
import oracle.adf.view.rich.component.rich.input.RichSelectBooleanRadio;
import oracle.adf.view.rich.context.AdfFacesContext;
import oracle.adf.view.rich.event.DialogEvent;

import oracle.adf.view.rich.event.PopupFetchEvent;

import oracle.binding.BindingContainer;
import oracle.binding.OperationBinding;

import oracle.jbo.Row;
import oracle.jbo.RowSetIterator;

import oracle.jbo.ViewObject;

import org.apache.myfaces.trinidad.render.ExtendedRenderKitService;
import org.apache.myfaces.trinidad.util.Service;

public class WorkflowBean {
    private RichPopup userPopup;
    private RichPopup informationPopup;
    private RichSelectBooleanCheckbox selectUserCheckBox;
    private RichPopup newUserPopup;
    private RichTable radioTable;
    private RichSelectBooleanRadio radioBinding;
    private RichPopup regionAssignPopup;

    public WorkflowBean() {
    }
    
    public BindingContainer getBindings(){
            return BindingContext.getCurrent().getCurrentBindingsEntry();
        }
    public void workFlowAssignButton(ActionEvent actionEvent) {
//        BindingContext context = BindingUtils.getBindingContext();
//        DCBindingContainer bindings =
//                    (DCBindingContainer)context.getCurrentBindingsEntry();
//        DCIteratorBinding iterator;
//        iterator = (DCIteratorBinding)bindings.findIteratorBinding("WorkFlowSubmittedBatchesVOIterator");
//        System.out.println(iterator+"------iterator");
//        RowSetIterator rowSetIterator= iterator.getViewObject().createRowSetIterator(null);
//        Integer batchId = null;
//        while (rowSetIterator.hasNext())
//              {
//                  Row r = rowSetIterator.next();
//                  String selected = "N";
//                             if(r.getAttribute("tranSelect") != null)
//                             {
//                             selected =  (String)r.getAttribute("tranSelect");
//                             }
//            if(selected.equalsIgnoreCase("Y"))
//            {
//                 batchId =Integer.parseInt(r.getAttribute("RegionId").toString());
//                System.out.println(batchId+"-------selected");
//                break;
//            }
//           
//              }
//        
//        
//        OperationBinding ob=getBindings().getOperationBinding("assigntask");
//        ob.getParamsMap().put("batch_id", batchId);
//        ob.execute();
//        System.out.println("-------selected");
        showPopup(regionAssignPopup, true);
    }
    String photoLink;
    String identityLink;
    String medicalLink;
    String seaserviceLink;
    String securityLink;
    String supportLink;
    String consentLink;

    public void setConsentLink(String consentLink) {
        this.consentLink = consentLink;
    }

    public String getConsentLink() {
        return consentLink;
    }
    String supportLinkVisible;

    public void setSupportLink(String supportLink) {
        this.supportLink = supportLink;
    }

    public String getSupportLink() {
        return supportLink;
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
    String identityLinkVisible;
    String medicalLinkVisible;
    String seaserviceLinkVisible;
    String securityLinkVisible;

    public void setSecurityLink(String securityLink) {
        this.securityLink = securityLink;
    }

    public String getSecurityLink() {
        return securityLink;
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
    String attestaionLink;
    String affidavitLink;
    String attestaionLinkVisible;
    String affidavitLinkVisible;
    public void setUserPopup(RichPopup userPopup) {
        this.userPopup = userPopup;
    }

    public RichPopup getUserPopup() {
        return userPopup;
    }
    private void showPopup(RichPopup pop, boolean visible) {
            try {
                FacesContext context = FacesContext.getCurrentInstance();
                if (context != null && pop != null) {
                    String popupId = pop.getClientId(context);
                    if (popupId != null) {
                        StringBuilder script = new StringBuilder();
                        script.append("var popup = AdfPage.PAGE.findComponent('").append(popupId).append("'); ");
                        if (visible) {
                            script.append("if (!popup.isPopupVisible()) { ").append("popup.show();}");
                        } else {
                            script.append("if (popup.isPopupVisible()) { ").append("popup.hide();}");
                        }
                        ExtendedRenderKitService erks =
                            Service.getService(context.getRenderKit(), ExtendedRenderKitService.class);
                        erks.addScript(context, script.toString());
                    }
                }
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }

    public void submitButtononPopup(ActionEvent actionEvent) {

        try {
            BindingContext context = BindingUtils.getBindingContext();
            DCBindingContainer bindings = (DCBindingContainer) context.getCurrentBindingsEntry();
            DCIteratorBinding iterator;
            iterator = (DCIteratorBinding) bindings.findIteratorBinding("WorkFlowAssignedToUsersLOVIterator");
            ViewObject users = iterator.getViewObject();
            Row currentRow = users.getCurrentRow();
            Integer userId = Integer.parseInt(currentRow.getAttribute("UserId").toString());
            //        System.out.println(userId+"-------user name");

            //        BindingContext context = BindingUtils.getBindingContext();
            //        DCBindingContainer bindings =
            //                    (DCBindingContainer)context.getCurrentBindingsEntry();
            //        DCIteratorBinding iterator;
            //        iterator = (DCIteratorBinding)bindings.findIteratorBinding("WorkFlowAssignedToUsersLOVIterator");
            //        RowSetIterator rowSetIterator= iterator.getViewObject().createRowSetIterator(null);
            //        Integer userId = null;
            //        while (rowSetIterator.hasNext())
            //              {
            //                  Row r = rowSetIterator.next();
            //                  String selected = "false";
            //                             if(r.getAttribute("selectUser") != null)
            //                             {
            //                             selected =  r.getAttribute("selectUser").toString();
            //                             }
            //               if(selected.equalsIgnoreCase("true"))
            //               {
            //                    userId =Integer.parseInt(r.getAttribute("UserId").toString());
            //               }
            //                  System.out.println(userId+"--------boolean");
            //              }

            OperationBinding ob = getBindings().getOperationBinding("assignTaskToUser");
            ob.getParamsMap().put("user_id", userId);
            ob.execute();

            newUserPopup.hide();

            showPopup(informationPopup, true);
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while assigning batch." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
        
    }
    
    public void submitButtononRegionPopup(ActionEvent actionEvent) {

        try {
            BindingContext context = BindingUtils.getBindingContext();
            DCBindingContainer bindings = (DCBindingContainer) context.getCurrentBindingsEntry();
            DCIteratorBinding iterator;
            iterator = (DCIteratorBinding) bindings.findIteratorBinding("RegionListForAssignROIterator");
            ViewObject region = iterator.getViewObject();
            Row currentRow = region.getCurrentRow();
            Integer regionId = Integer.parseInt(currentRow.getAttribute("SalesrepId").toString());
//                    System.out.println(regionId+"-------region name");


            OperationBinding ob = getBindings().getOperationBinding("assignBatchesToRegion");
            ob.getParamsMap().put("regionId", regionId);
            ob.execute();

            regionAssignPopup.hide();

            showPopup(informationPopup, true);
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while assigning batch." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
        
    }

    public void setInformationPopup(RichPopup informationPopup) {
        this.informationPopup = informationPopup;
    }

    public RichPopup getInformationPopup() {
        return informationPopup;
    }

    public void infoPopupDialogListener(DialogEvent dialogEvent) {
        try {
            if (dialogEvent.getOutcome() == DialogEvent.Outcome.ok) {
                OperationBinding ob = getBindings().getOperationBinding("refresh_workflow");
                ob.execute();
            } else {
                // write your custom code for cancel event
            }
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while refreshing data." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
        // Add event code here...
    }

    public void rowWiseAssignButton(ActionEvent actionEvent) {
//        BindingContext context = BindingUtils.getBindingContext();
//        DCBindingContainer bindings =
//                    (DCBindingContainer)context.getCurrentBindingsEntry();
//        DCIteratorBinding iterator;
//        iterator = (DCIteratorBinding)bindings.findIteratorBinding("WorkFlowSubmittedBatchesVOIterator");
//        ViewObject batchVo = iterator.getViewObject();
//        Row currentRow = batchVo.getCurrentRow();
//        Integer regionId = Integer.parseInt(currentRow.getAttribute("RegionId").toString());  
//            OperationBinding ob=getBindings().getOperationBinding("assigntask");
//            ob.getParamsMap().put("batch_id", batchId);
//            ob.execute();
//            System.out.println("-------selected");
//            showPopup(userPopup, true);
        }

    public void refreshButton(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("refresh_workflow");
            ob.execute();
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while refreshing data." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }   }

    public void searchButton(ActionEvent actionEvent) {
        try {
            OperationBinding ob = getBindings().getOperationBinding("filterTaskAssignment");
            ob.execute();
        } catch (Exception e) {
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while filtering data." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
    }

   

    public void setSelectUserCheckBox(RichSelectBooleanCheckbox selectUserCheckBox) {
        this.selectUserCheckBox = selectUserCheckBox;
    }

    public RichSelectBooleanCheckbox getSelectUserCheckBox() {
        return selectUserCheckBox;
    }

    public void setNewUserPopup(RichPopup newUserPopup) {
        this.newUserPopup = newUserPopup;
    }

    public RichPopup getNewUserPopup() {
        return newUserPopup;
    }

    public void radioValueChangeListner(ValueChangeEvent valueChangeEvent) {
  }

    public void setRadioTable(RichTable radioTable) {
        this.radioTable = radioTable;
    }

    public RichTable getRadioTable() {
        return radioTable;
    }

    public void setRadioBinding(RichSelectBooleanRadio radioBinding) {
        this.radioBinding = radioBinding;
    }

    public RichSelectBooleanRadio getRadioBinding() {
        return radioBinding;
    }

    public void setRegionAssignPopup(RichPopup regionAssignPopup) {
        this.regionAssignPopup = regionAssignPopup;
    }

    public RichPopup getRegionAssignPopup() {
        return regionAssignPopup;
    }

    public void documentPopupFetchListener(PopupFetchEvent popupFetchEvent) {

        try {
            OperationBinding ob1 = getBindings().getOperationBinding("getUsertypeForTaskAssignmentPage");
            String user_type = ob1.execute().toString();

            //        System.out.println("-------in the fetch listener");
            OperationBinding ob = getBindings().getOperationBinding("getlinkforTaskAssignmentpage");
            ob.getParamsMap().put("code", "0002");
            String path = null;
            try {
                path = ob.execute().toString();
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setPhotoLink(path);
            ob = getBindings().getOperationBinding("getlinkforTaskAssignmentpage");
            ob.getParamsMap().put("code", "0003");
            path = null;
            try {
                path = ob.execute().toString();
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setIdentityLink(path);
            ob = getBindings().getOperationBinding("getlinkforTaskAssignmentpage");
            ob.getParamsMap().put("code", "0004");
            path = null;
            try {
                path = ob.execute().toString();
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setMedicalLink(path);
            ob = getBindings().getOperationBinding("getlinkforTaskAssignmentpage");
            ob.getParamsMap().put("code", "0008");
            path = null;
            try {
                path = ob.execute().toString();
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setSeaserviceLink(path);
            ob = getBindings().getOperationBinding("getlinkforTaskAssignmentpage");
            ob.getParamsMap().put("code", "0001");
            path = null;
            try {
                path = ob.execute().toString();
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setAttestaionLink(path);
            ob = getBindings().getOperationBinding("getlinkforTaskAssignmentpage");
            ob.getParamsMap().put("code", "0009");
            path = null;
            try {
                path = ob.execute().toString();
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setAffidavitLink(path);
            ob = getBindings().getOperationBinding("getlinkforTaskAssignmentpage");
            ob.getParamsMap().put("code", "0016");
            path = null;
            try {
                path = ob.execute().toString();
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setSecurityLink(path);

            ob = getBindings().getOperationBinding("getlinkforTaskAssignmentpage");
            ob.getParamsMap().put("code", "0031");
            path = null;
            try {
                path = ob.execute().toString();
            } catch (Exception e) {
                path = null;
                e.printStackTrace();
            }
            //        System.out.println(path+"------path");
            setSupportLink(path);
            ob = getBindings().getOperationBinding("getlinkforTaskAssignmentpage");
            ob.getParamsMap().put("code", "0025");
            path = null;
            try {
                path = ob.execute().toString();
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
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching data." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
            e.printStackTrace();
        }
    }

    public void selectAllCheckBoxValueChangeListener(ValueChangeEvent valueChangeEvent) {
    try {
            if (valueChangeEvent.getNewValue() != null) {
                String val = valueChangeEvent.getNewValue().toString();

                OperationBinding ob = getBindings().getOperationBinding("selectAllonTaskAssignment");
                ob.getParamsMap().put("check", val);
                ob.execute();

            }
        } catch (Exception e) {
            e.printStackTrace();
            ADFUtils.addFormattedFacesErrorMessage("System encountered an exception while selecting rows." +
            " Please contact your System Administrator." , 
            "", FacesMessage.SEVERITY_ERROR);
        }
    
    }

    public void filterCRA(ActionEvent actionEvent) {
        OperationBinding ob = getBindings().getOperationBinding("filterOnTaskAssignment");
        ob.getParamsMap().put("p_filter", "cra");
        ob.execute();
    }

    public void filterExpedited(ActionEvent actionEvent) {
        OperationBinding ob = getBindings().getOperationBinding("filterOnTaskAssignment");
        ob.getParamsMap().put("p_filter", "expedited");
        ob.execute();    }

    public void filterResubmit(ActionEvent actionEvent) {
        OperationBinding ob = getBindings().getOperationBinding("filterOnTaskAssignment");
        ob.getParamsMap().put("p_filter", "resubmit");
        ob.execute();    }

    public void filterAll(ActionEvent actionEvent) {
        OperationBinding ob = getBindings().getOperationBinding("filterOnTaskAssignment");
        ob.getParamsMap().put("p_filter", "all");
        ob.execute();    }
}
