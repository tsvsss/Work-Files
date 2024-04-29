package com.rmi.manualtradecompliance.adfbc.services.common;

import java.sql.Date;

import oracle.jbo.ApplicationModule;

import oracle.sql.Datum;
// ---------------------------------------------------------------------
// ---    File generated by Oracle ADF Business Components Design Time.
// ---    Mon Feb 11 14:04:01 IST 2019
// ---------------------------------------------------------------------
public interface RMIManualTradeComplianceAppModule extends ApplicationModule {
    void executeAllViewObjects();

    void createVetting();

    String validateCreateVetting();


    void fetchVettingMatches();


    String useExistingVetting();

    String genMergedSupportingDocs(Integer seafarerId);

    String getMergedFileName(Integer seafarerId);

    void fetchMatchesDisplayData();

    String filterConsentDetails();


    String getEdocFullURL(int edocId);

    void synchronize(int wc_screening_request_id);

    void getEdocCategoryId(int edocId);

    void syncAlias(int wc_screening_request_id);

    Datum[] getCrossReeferences(int wc_screening_request_id);

    Datum[] getOFACSDNMatches(String search_name, String entity_type);

    String getOFACDocLink(int ofac_list_edoc_id, String iriHTMLUrlType);


    Datum[] queryCrossReference(String p_source_table, String p_source_column, int p_source_id);


    String createAliasVetting();

    String filterConsentDetailsVetting(Number masterId);


    void selectMultipleVettings(String tcExcluded);

    Integer getAttributeValue(String attrName);


    void resetDualVettingRow();


    void createConsent(String consentEdocId);

    String uploadDocument(String entityName, String fileName);


    String uploadAffidavit(String fileName, String category, String action, String startDate, String endDate);

    void initializeViewContextAGetData(String filter, String sortByColumnName);

    void callXwrlPartyMaster();

    void updateCountryCity(String type, String country, String city);

    String createNewVetting();


    void createConsentVetting(Integer masterId, Integer aliasId, Integer xrefId, String consentEdocId);

    String callRunTc(String affidavitFlag, String documentType);


    String updateOnlineConsent(String sourceId, String consentId, String masterId, String aliasId, String xrefId);

    String updateEndDate(java.util.Date endDate, Integer masterId, Integer aliasId, Integer xrefId, String cursor);

    void logGenericTC(String type, String title, String message, String className, String methodName,
                      String detailedMessage);
    void saveVettingCheckBoxSelections();

    void onLoad();
}
