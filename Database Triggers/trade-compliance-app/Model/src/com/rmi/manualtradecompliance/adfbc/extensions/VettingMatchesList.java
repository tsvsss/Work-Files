package com.rmi.manualtradecompliance.adfbc.extensions;

public class VettingMatchesList {
    public VettingMatchesList(String nameScreened, String matchScore, String idNumber, String dateOfBirth, 
                              String trans1, String trans2, String trans3, String trans4) {
        this.nameScreened = nameScreened;
        this.matchScore = matchScore;
        this.idNumber = idNumber;
        this.dateOfBirth = dateOfBirth;
        this.trans1 = trans1;
        this.trans2 = trans2;
        this.trans3 = trans3;
        this.trans4 = trans4;
//        super();
    }
    
    private String nameScreened;
    private String matchScore;
    private String idNumber;
    private String dateOfBirth;
    private String trans1;
    private String trans2;
    private String trans3;
    private String trans4;

    public void setNameScreened(String nameScreened) {
        this.nameScreened = nameScreened;
    }

    public String getNameScreened() {
        return nameScreened;
    }

    public void setMatchScore(String matchScore) {
        this.matchScore = matchScore;
    }

    public String getMatchScore() {
        return matchScore;
    }

    public void setIdNumber(String idNumber) {
        this.idNumber = idNumber;
    }

    public String getIdNumber() {
        return idNumber;
    }

    public void setDateOfBirth(String dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getDateOfBirth() {
        return dateOfBirth;
    }

    public void setTrans1(String trans1) {
        this.trans1 = trans1;
    }

    public String getTrans1() {
        return trans1;
    }

    public void setTrans2(String trans2) {
        this.trans2 = trans2;
    }

    public String getTrans2() {
        return trans2;
    }

    public void setTrans3(String trans3) {
        this.trans3 = trans3;
    }

    public String getTrans3() {
        return trans3;
    }

    public void setTrans4(String trans4) {
        this.trans4 = trans4;
    }

    public String getTrans4() {
        return trans4;
    }
}
