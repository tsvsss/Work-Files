package com.rmi.manualtradecompliance.utils;

import oracle.adf.view.rich.component.rich.input.RichInputText;

public class DocInfo {
    public DocInfo() {
        super();
    }

    public String documentType;
    public String documentNumber;
    public String officialNumber;
    public String imoNumber;
    public String vesselName;
    public String callSign;

    public void setDocumentType(String documentType) {
        this.documentType = documentType;
    }

    public String getDocumentType() {
        return documentType;
    }

    public void setDocumentNumber(String documentNumber) {
        this.documentNumber = documentNumber;
    }

    public String getDocumentNumber() {
        return documentNumber;
    }

    public void setOfficialNumber(String officialNumber) {
        this.officialNumber = officialNumber;
    }

    public String getOfficialNumber() {
        return officialNumber;
    }

    public void setImoNumber(String imoNumber) {
        this.imoNumber = imoNumber;
    }

    public String getImoNumber() {
        return imoNumber;
    }

    public void setVesselName(String vesselName) {
        this.vesselName = vesselName;
    }

    public String getVesselName() {
        return vesselName;
    }

    public void setCallSign(String callSign) {
        this.callSign = callSign;
    }

    public String getCallSign() {
        return callSign;
    }
}
