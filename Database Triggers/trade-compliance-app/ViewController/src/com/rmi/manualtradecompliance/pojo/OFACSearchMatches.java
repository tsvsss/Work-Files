package com.rmi.manualtradecompliance.pojo;

public class OFACSearchMatches {
    public OFACSearchMatches() {
        super();
    }
    
    public OFACSearchMatches(String primaryName,String aliasName, String  country, String matchScore) {
     this.primaryName=primaryName;
     this.aliasName=aliasName;
     this.country=country;
     this.matchScore=matchScore;
    }
    
    private String primaryName;
    private String aliasName;

    public void setPrimaryName(String primaryName) {
        this.primaryName = primaryName;
    }

    public String getPrimaryName() {
        return primaryName;
    }

    public void setAliasName(String aliasName) {
        this.aliasName = aliasName;
    }

    public String getAliasName() {
        return aliasName;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getCountry() {
        return country;
    }

    public void setMatchScore(String matchScore) {
        this.matchScore = matchScore;
    }

    public String getMatchScore() {
        return matchScore;
    }
    private String country;
    private String matchScore;
   
}
