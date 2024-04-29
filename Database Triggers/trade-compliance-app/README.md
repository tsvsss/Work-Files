# Trade Compliance

## About The Project

All known parties to a vessel registration transaction, including individuals, entities, and the vessel herself, must be vetted before a vessel is registered 
with the RMI. When the details of ownership are known, and all associated parties have been entered into the system, the Trade compliance department will be 
responsible for checking all entries to ensure we are not dealing with sanctioned companies, persons, or countries. 

Oracle Watchlist Screening enables organizations to effectively and efficiently screen their customers to successfully meet anti-bribery, anticorruption, export control, and other legal regulation as well as all current anti-money laundering and counter-terrorist financing legislation. 
 
 1. New Vettings for Individuals and Entities (Corporations/Vessel) can be submitted to OWS
 2. Multiple name varitions (Alias) can be added to Primary name vetting and request can be submitted to OWS
 3. Supporting Notes can be added to OWS Cases
 4. Suporting Documents can be uploaded to OWS cases
 5. Statusboard section where anyone can search for all the requests submitted to OWS till date.
 

### Built With

* Oracle ADF 12.1.3

### Integrations With

* Oracle Watch list Screening (OWS)

### Accessed from

* Oracle Applications

## Getting Started

Steps to run the application from Jdeveloper

1. adf-settings.xml the adf-controller-config tag should point to either EbsMADFListener for the Weblogic server or LocalMADFListener for local IntegratedWeblogicServer (IWS)
2. AppModule should point to appropriate data source (DevDS, DRDS or ProdDS)
3. RMIManualTradeComplianceAppModule should point to appropriate data source (DevDS, DRDS or ProdDS)
3. DataBindings_generictc.cpx file should point to appropriate data source (DevDS, DRDS or ProdDS)
4. Include all the libraries neccessary to compile the application

Update context initialization parameters in web.xml to the appropriate environment (DEV, DR or PROD).  The values are in the Source.  Comment / Uncomment as appropriate.

* APPL_SERVER_ID_SECURE
* oracle.apps.xwrl.FILE_UPLOAD_LINUX
* oracle.apps.xwrl.CORP_DIRECTORY_WINDOWS
* oracle.apps.xwrl.SICD_DIRECTORY_WINDOWS
* oracle.apps.xwrl.VSSL_DIRECTORY_WINDOWS
* oracle.apps.xwrl.GROUPDOCS_VIEWER_LICENSE_LINUX

### Prerequisites

* Oracle Jdeveloper 12.1.3 has to be installed
* JDK 1.8 has to be installed

## Update Profile Option Values for FND_EXTERNAL_ADF_URL using Functional Administrator

* CORP USER IRI PROD
* Corporate Manager IRI PROD
* RMI OWS Generic Admin
* RMI OWS Trade Compliance
* RMI OWS Trade Compliance - Super User
* Trade Compliance Manager

## Roles

* Trade Group Users
* Corporate Reviewers
* General Trade Users

## JDeveloper Notes

The XwrlRequestsView is most likely corrupted.  Updating the VO through the GUI can corrupt multiple supporting files:

* attribute mappings are changed in the XML
* attribute mappings are changed in java files
* attribute methods are changed in java files
* java files are deleted.

Use Github to track the changes and discard if any of the above occurs unexpectedly.