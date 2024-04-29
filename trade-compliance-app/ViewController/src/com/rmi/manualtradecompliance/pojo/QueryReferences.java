package com.rmi.manualtradecompliance.pojo;

public class QueryReferences {
    public QueryReferences() {
        super();
    }
    
    public QueryReferences(String wcScreeningRequestId,String nameScreened,String matchScore,String nodeID,String parentNodeID,String  referenceDescription, String wcExtXRefId) {
        this.wcScreeningRequestId = wcScreeningRequestId;
        this.nameScreened = nameScreened;
        this.matchScore = matchScore;
        this.nodeID = nodeID;
        this.parentNodeID = parentNodeID;
        this.referenceDescription = referenceDescription;
        this.wcExtXRefId = wcExtXRefId;
    }
    
    private String wcScreeningRequestId;
    private String nameScreened;
    private String matchScore;
    private String nodeID;
    private String parentNodeID;
    private String referenceDescription;
    private String wcExtXRefId;

    public void setWcScreeningRequestId(String wcScreeningRequestId) {
        this.wcScreeningRequestId = wcScreeningRequestId;
    }

    public String getWcScreeningRequestId() {
        return wcScreeningRequestId;
    }

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

    public void setNodeID(String nodeID) {
        this.nodeID = nodeID;
    }

    public String getNodeID() {
        return nodeID;
    }

    public void setParentNodeID(String parentNodeID) {
        this.parentNodeID = parentNodeID;
    }

    public String getParentNodeID() {
        return parentNodeID;
    }

    public void setReferenceDescription(String referenceDescription) {
        this.referenceDescription = referenceDescription;
    }

    public String getReferenceDescription() {
        return referenceDescription;
    }

    public void setWcExtXRefId(String wcExtXRefId) {
        this.wcExtXRefId = wcExtXRefId;
    }

    public String getWcExtXRefId() {
        return wcExtXRefId;
    }
}
