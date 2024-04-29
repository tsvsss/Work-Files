create or replace PACKAGE        "XWRL_UTILS" AS

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_create_xwrl_utils.pks 1.1 2019/11/15 12:00:00ET   IRI Exp                                         $*/
/********************************************************************************************************************
* Object Type         : Package Specification                                                                       *
* Name                : xwrl_utils                                                                                  *
* Script Name         : apps_create_xwrl_utils.pks                                                                  *
* Purpose             :                                                                                             *
*                                                                                                                   *
* Company             : International Registries, Inc.                                                              *
* Module              : Trade Compliance                                                                            *
* Created By          : TSUAZO                                                                                      *
* Created Date        : 11-NOV-2019                                                                                 *
* Last Reviewed By    :                                                                                             *
* Last Reviewed Date  :                                                                                             *
*********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
* Date        By               Script               By            Date         Type  Details                        *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ------------------------------*
* 15-NOV-2019 IRI              1.1                TSUAZO          15-NOV-2019  I      Trade Compliance              *
* 15-NOV-2019 IRI              1.2                TSUAZO          15-NOV-2019  I      Add    create_audit_record          *
* 16-NOV-2019 IRI              1.3                TSUAZO          16-NOV-2019  I      Remove    create_audit_record          *
* 17-NOV-2019 IRI              1.4                TSUAZO          17-NOV-2019  I     Update cleanse_name          *
* 17-NOV-2019 IRI              1.5                TSUAZO          17-NOV-2019  I     Add RMI_OWS_COMMON_UTIL functions          *        
* 12-DEC-2019 IRI              1.6                TSUAZO          12-DEC-2019  I     Add Master ID, Alias ID and XREF ID     *           
* 19-DEC-2019 IRI              1.7                VTONDAPU        19-DEC-2019  I     Added Gender, Passport info in SAVE_REQUEST_IND_COLUMNS AND OWS_WEB_SERVICE PROCEDURES    *                                                                                             
********************************************************************************************************************/

   TYPE p_rec IS RECORD (
      key VARCHAR2 (300)
      , value VARCHAR2 (32767)
   );

   TYPE p_tab IS
      TABLE OF p_rec INDEX BY BINARY_INTEGER;

   invalid_request EXCEPTION;
   server_unavailable EXCEPTION;
   invalid_xml EXCEPTION;

   server_not_whitelisted EXCEPTION;
   server_timeout EXCEPTION;
   server_end_of_input EXCEPTION;  
   syntax_error EXCEPTION;
   xml_parsing EXCEPTION;
   PRAGMA exception_init (server_not_whitelisted, -12541);  --ORA-12541: TNS:no listener
   PRAGMA exception_init (server_timeout, -12535);  --ORA-12535: TNS:operation timed out
   PRAGMA exception_init (server_end_of_input, -29259);  --ORA-29259: end-of-input reached
   PRAGMA exception_init (syntax_error, -19112);  --ORA-19112: error raised during evaluation: Syntax error
   PRAGMA exception_init (xml_parsing, -31011);  --ORA-31011: XML parsing failed

    FUNCTION cleanse_name (
   p_name varchar2
   ) return varchar2;

   FUNCTION get_instance RETURN VARCHAR2;

   FUNCTION get_wl_server (
      p_id VARCHAR2
      ,p_key varchar2
   ) RETURN VARCHAR2;

   FUNCTION get_max_jobs RETURN INTEGER;

   FUNCTION get_max_pause RETURN INTEGER;

      FUNCTION get_ebs_pause RETURN INTEGER;

   FUNCTION get_ratio RETURN INTEGER;

   FUNCTION get_frequency RETURN INTEGER;

   FUNCTION test_ows_web_service (
      p_debug          BOOLEAN
      , p_server         VARCHAR2
      , p_service_name   VARCHAR2
   ) RETURN BOOLEAN;

   PROCEDURE ows_web_service (
      p_debug           BOOLEAN
      , p_show_request    BOOLEAN
      , p_show_response   BOOLEAN
      , p_server          VARCHAR2
      ,p_user_id NUMBER DEFAULT NULL
      ,p_session_id NUMBER DEFAULT NULL
      ,p_source_table  VARCHAR2 DEFAULT NULL
      ,p_source_id      NUMBER DEFAULT NULL
      ,p_wc_screening_request_id NUMBER DEFAULT NULL      
      ,p_job_id                VARCHAR2 DEFAULT NULL
      ,p_batch_id NUMBER DEFAULT NULL  
	  ,p_master_id NUMBER DEFAULT NULL 
	  ,p_alias_id NUMBER DEFAULT NULL 
	  ,p_xref_id  NUMBER DEFAULT NULL 	  
      ,p_update_user_id number default null
      ,p_parent_id number default null
      ,p_relationship_type VARCHAR2 DEFAULT NULL
      ,p_city_id number default null      
      ,p_name_screened varchar2 default null
      ,p_imo_number integer default null
      ,p_vessel_indicator varchar2 default null
      ,p_department varchar2 default null
      ,p_office  varchar2 default null
      ,p_priority  varchar2 default null
      ,p_risk_level  varchar2 default null
      ,p_document_type  varchar2 default null
      ,p_closed_date  date default null
      ,p_assigned_to number default null
      , p_service_name    VARCHAR2
      , p_list            p_tab
      , p_id              INTEGER
      , x_id OUT INTEGER
   );

   PROCEDURE ows_individual_screening (
       p_debug                     VARCHAR2 DEFAULT 'FALSE'
      , p_show_request              VARCHAR2 DEFAULT 'FALSE'
      , p_show_response             VARCHAR2 DEFAULT 'FALSE'      
      , p_server                    VARCHAR2 DEFAULT NULL
      ,p_user_id NUMBER DEFAULT NULL
      ,p_session_id NUMBER DEFAULT NULL      
      ,p_source_table  VARCHAR2 DEFAULT NULL
      ,p_source_id      NUMBER DEFAULT NULL
      ,p_wc_screening_request_id NUMBER DEFAULT NULL
      ,p_job_id                VARCHAR2 DEFAULT NULL
      ,p_batch_id NUMBER DEFAULT NULL 
	  ,p_master_id NUMBER DEFAULT NULL 
	  ,p_alias_id NUMBER DEFAULT NULL 
	  ,p_xref_id  NUMBER DEFAULT NULL 
      ,p_update_user_id number default null
      ,p_parent_id number default null
      ,p_relationship_type VARCHAR2 DEFAULT NULL
      ,p_city_id number default null      
      ,p_name_screened varchar2 default null
      ,p_department varchar2 default null
      ,p_office  varchar2 default null
      ,p_priority  varchar2 default null
      ,p_risk_level  varchar2 default null
      ,p_document_type  varchar2 default null
      ,p_closed_date  date default null
      ,p_assigned_to number default null      
      , p_listsubkey                VARCHAR2 DEFAULT NULL
      , p_listrecordtype            VARCHAR2 DEFAULT NULL
      , p_listrecordorigin          VARCHAR2 DEFAULT NULL
      , p_custid                    VARCHAR2 DEFAULT NULL
      , p_custsubid                 VARCHAR2 DEFAULT NULL
      , p_passportnumber            VARCHAR2 DEFAULT NULL
      , p_nationalid                VARCHAR2 DEFAULT NULL
      , p_title                     VARCHAR2 DEFAULT NULL
      , p_fullname                  VARCHAR2 DEFAULT NULL
      , p_givennames                VARCHAR2 DEFAULT NULL
      , p_familyname                VARCHAR2 DEFAULT NULL
      , p_nametype                  VARCHAR2 DEFAULT NULL
      , p_namequality               VARCHAR2 DEFAULT NULL
      , p_primaryname               VARCHAR2 DEFAULT NULL
      , p_originalscriptname        VARCHAR2 DEFAULT NULL
      , p_gender                    VARCHAR2 DEFAULT NULL
      , p_dateofbirth               VARCHAR2 DEFAULT NULL
      , p_yearofbirth               VARCHAR2 DEFAULT NULL
      , p_occupation                VARCHAR2 DEFAULT NULL
      , p_address1                  VARCHAR2 DEFAULT NULL
      , p_address2                  VARCHAR2 DEFAULT NULL
      , p_address3                  VARCHAR2 DEFAULT NULL
      , p_address4                  VARCHAR2 DEFAULT NULL
      , p_city                      VARCHAR2 DEFAULT NULL
      , p_state                     VARCHAR2 DEFAULT NULL
      , p_postalcode                VARCHAR2 DEFAULT NULL
      , p_addresscountrycode        VARCHAR2 DEFAULT NULL
      , p_residencycountrycode      VARCHAR2 DEFAULT NULL
      , p_countryofbirthcode        VARCHAR2 DEFAULT NULL
      , p_nationalitycountrycodes   VARCHAR2 DEFAULT NULL
      , p_profilehyperlink          VARCHAR2 DEFAULT NULL
      , p_riskscore                 VARCHAR2 DEFAULT NULL
      , p_dataconfidencescore       VARCHAR2 DEFAULT NULL
      , p_dataconfidencecomment     VARCHAR2 DEFAULT NULL
      , p_customstring1             VARCHAR2 DEFAULT NULL
      , p_customstring2             VARCHAR2 DEFAULT NULL
      , p_customstring3             VARCHAR2 DEFAULT NULL
      , p_customstring4             VARCHAR2 DEFAULT NULL
      , p_customstring5             VARCHAR2 DEFAULT NULL
      , p_customstring6             VARCHAR2 DEFAULT NULL
      , p_customstring7             VARCHAR2 DEFAULT NULL
      , p_customstring8             VARCHAR2 DEFAULT NULL
      , p_customstring9             VARCHAR2 DEFAULT NULL
      , p_customstring10            VARCHAR2 DEFAULT NULL
      , p_customstring11            VARCHAR2 DEFAULT NULL
      , p_customstring12            VARCHAR2 DEFAULT NULL
      , p_customstring13            VARCHAR2 DEFAULT NULL
      , p_customstring14            VARCHAR2 DEFAULT NULL
      , p_customstring15            VARCHAR2 DEFAULT NULL
      , p_customstring16            VARCHAR2 DEFAULT NULL
      , p_customstring17            VARCHAR2 DEFAULT NULL
      , p_customstring18            VARCHAR2 DEFAULT NULL
      , p_customstring19            VARCHAR2 DEFAULT NULL
      , p_customstring20            VARCHAR2 DEFAULT NULL
      , p_customstring21            VARCHAR2 DEFAULT NULL
      , p_customstring22            VARCHAR2 DEFAULT NULL
      , p_customstring23            VARCHAR2 DEFAULT NULL
      , p_customstring24            VARCHAR2 DEFAULT NULL
      , p_customstring25            VARCHAR2 DEFAULT NULL
      , p_customstring26            VARCHAR2 DEFAULT NULL
      , p_customstring27            VARCHAR2 DEFAULT NULL
      , p_customstring28            VARCHAR2 DEFAULT NULL
      , p_customstring29            VARCHAR2 DEFAULT NULL
      , p_customstring30            VARCHAR2 DEFAULT NULL
      , p_customstring31            VARCHAR2 DEFAULT NULL
      , p_customstring32            VARCHAR2 DEFAULT NULL
      , p_customstring33            VARCHAR2 DEFAULT NULL
      , p_customstring34            VARCHAR2 DEFAULT NULL
      , p_customstring35            VARCHAR2 DEFAULT NULL
      , p_customstring36            VARCHAR2 DEFAULT NULL
      , p_customstring37            VARCHAR2 DEFAULT NULL
      , p_customstring38            VARCHAR2 DEFAULT NULL
      , p_customstring39            VARCHAR2 DEFAULT NULL
      , p_customstring40            VARCHAR2 DEFAULT NULL
      , p_customdate1               VARCHAR2 DEFAULT NULL
      , p_customdate2               VARCHAR2 DEFAULT NULL
      , p_customdate3               VARCHAR2 DEFAULT NULL
      , p_customdate4               VARCHAR2 DEFAULT NULL
      , p_customdate5               VARCHAR2 DEFAULT NULL
      , p_customnumber1             VARCHAR2 DEFAULT NULL
      , p_customnumber2             VARCHAR2 DEFAULT NULL
      , p_customnumber3             VARCHAR2 DEFAULT NULL
      , p_customnumber4             VARCHAR2 DEFAULT NULL
      , p_customnumber5             VARCHAR2 DEFAULT NULL      
      , x_id OUT INTEGER
   );

   PROCEDURE ows_entity_screening (
      p_debug                     VARCHAR2 DEFAULT 'FALSE'
      , p_show_request              VARCHAR2 DEFAULT 'FALSE'
      , p_show_response             VARCHAR2 DEFAULT 'FALSE'
      , p_server                    VARCHAR2 DEFAULT NULL 
      ,p_user_id NUMBER DEFAULT NULL
      ,p_session_id NUMBER DEFAULT NULL      
      ,p_source_table  VARCHAR2 DEFAULT NULL
      ,p_source_id      NUMBER DEFAULT NULL
      ,p_wc_screening_request_id NUMBER DEFAULT NULL      
      ,p_job_id                VARCHAR2 DEFAULT NULL
      ,p_batch_id NUMBER DEFAULT NULL      
	  ,p_master_id NUMBER DEFAULT NULL 
	  ,p_alias_id NUMBER DEFAULT NULL 
	  ,p_xref_id  NUMBER DEFAULT NULL 	  
      ,p_update_user_id number default null
      ,p_parent_id number default null
      ,p_relationship_type VARCHAR2 DEFAULT NULL
      ,p_city_id number default null        
      ,p_name_screened varchar2 default null
      ,p_imo_number integer default null
      ,p_vessel_indicator varchar2 default null
      ,p_department varchar2 default null
      ,p_office  varchar2 default null
      ,p_priority  varchar2 default null
      ,p_risk_level  varchar2 default null
      ,p_document_type  varchar2 default null
      ,p_closed_date  date default null
      ,p_assigned_to number default null
      , p_listsubkey                VARCHAR2 DEFAULT NULL
      , p_listrecordtype            VARCHAR2 DEFAULT NULL
      , p_listrecordorigin          VARCHAR2 DEFAULT NULL
      , p_custid                    VARCHAR2 DEFAULT NULL
      , p_custsubid                 VARCHAR2 DEFAULT NULL
      , p_registrationnumber        VARCHAR2 DEFAULT NULL
      , p_entityname                VARCHAR2 DEFAULT NULL
      , p_nametype                  VARCHAR2 DEFAULT NULL
      , p_namequality               VARCHAR2 DEFAULT NULL
      , p_primaryname               VARCHAR2 DEFAULT NULL
      , p_originalscriptname        VARCHAR2 DEFAULT NULL
      , p_aliasisacronym            VARCHAR2 DEFAULT NULL
      , p_address1                  VARCHAR2 DEFAULT NULL
      , p_address2                  VARCHAR2 DEFAULT NULL
      , p_address3                  VARCHAR2 DEFAULT NULL
      , p_address4                  VARCHAR2 DEFAULT NULL
      , p_city                      VARCHAR2 DEFAULT NULL
      , p_state                     VARCHAR2 DEFAULT NULL
      , p_postalcode                VARCHAR2 DEFAULT NULL
      , p_addresscountrycode        VARCHAR2 DEFAULT NULL
      , p_registrationcountrycode   VARCHAR2 DEFAULT NULL
      , p_OperatingCountryCodes     VARCHAR2 DEFAULT NULL
      , p_profilehyperlink          VARCHAR2 DEFAULT NULL
      , p_riskscore                 VARCHAR2 DEFAULT NULL
      , p_dataconfidencescore       VARCHAR2 DEFAULT NULL
      , p_dataconfidencecomment     VARCHAR2 DEFAULT NULL
      , p_customstring1             VARCHAR2 DEFAULT NULL
      , p_customstring2             VARCHAR2 DEFAULT NULL
      , p_customstring3             VARCHAR2 DEFAULT NULL
      , p_customstring4             VARCHAR2 DEFAULT NULL
      , p_customstring5             VARCHAR2 DEFAULT NULL
      , p_customstring6             VARCHAR2 DEFAULT NULL
      , p_customstring7             VARCHAR2 DEFAULT NULL
      , p_customstring8             VARCHAR2 DEFAULT NULL
      , p_customstring9             VARCHAR2 DEFAULT NULL
      , p_customstring10            VARCHAR2 DEFAULT NULL
      , p_customstring11            VARCHAR2 DEFAULT NULL
      , p_customstring12            VARCHAR2 DEFAULT NULL
      , p_customstring13            VARCHAR2 DEFAULT NULL
      , p_customstring14            VARCHAR2 DEFAULT NULL
      , p_customstring15            VARCHAR2 DEFAULT NULL
      , p_customstring16            VARCHAR2 DEFAULT NULL
      , p_customstring17            VARCHAR2 DEFAULT NULL
      , p_customstring18            VARCHAR2 DEFAULT NULL
      , p_customstring19            VARCHAR2 DEFAULT NULL
      , p_customstring20            VARCHAR2 DEFAULT NULL
      , p_customstring21            VARCHAR2 DEFAULT NULL
      , p_customstring22            VARCHAR2 DEFAULT NULL
      , p_customstring23            VARCHAR2 DEFAULT NULL
      , p_customstring24            VARCHAR2 DEFAULT NULL
      , p_customstring25            VARCHAR2 DEFAULT NULL
      , p_customstring26            VARCHAR2 DEFAULT NULL
      , p_customstring27            VARCHAR2 DEFAULT NULL
      , p_customstring28            VARCHAR2 DEFAULT NULL
      , p_customstring29            VARCHAR2 DEFAULT NULL
      , p_customstring30            VARCHAR2 DEFAULT NULL
      , p_customstring31            VARCHAR2 DEFAULT NULL
      , p_customstring32            VARCHAR2 DEFAULT NULL
      , p_customstring33            VARCHAR2 DEFAULT NULL
      , p_customstring34            VARCHAR2 DEFAULT NULL
      , p_customstring35            VARCHAR2 DEFAULT NULL
      , p_customstring36            VARCHAR2 DEFAULT NULL
      , p_customstring37            VARCHAR2 DEFAULT NULL
      , p_customstring38            VARCHAR2 DEFAULT NULL
      , p_customstring39            VARCHAR2 DEFAULT NULL
      , p_customstring40            VARCHAR2 DEFAULT NULL
      , p_customdate1               VARCHAR2 DEFAULT NULL
      , p_customdate2               VARCHAR2 DEFAULT NULL
      , p_customdate3               VARCHAR2 DEFAULT NULL
      , p_customdate4               VARCHAR2 DEFAULT NULL
      , p_customdate5               VARCHAR2 DEFAULT NULL
      , p_customnumber1             VARCHAR2 DEFAULT NULL
      , p_customnumber2             VARCHAR2 DEFAULT NULL
      , p_customnumber3             VARCHAR2 DEFAULT NULL
      , p_customnumber4             VARCHAR2 DEFAULT NULL
      , p_customnumber5             VARCHAR2 DEFAULT NULL
      , x_id OUT INTEGER
   );

      PROCEDURE ows_resubmit_screening (
      p_debug                     VARCHAR2 DEFAULT 'FALSE'
      , p_show_request              VARCHAR2 DEFAULT 'FALSE'
      , p_show_response             VARCHAR2 DEFAULT 'FALSE'
      , p_server          VARCHAR2
      ,p_user_id NUMBER DEFAULT NULL
      ,p_session_id NUMBER DEFAULT NULL      
      ,p_source_table  VARCHAR2 DEFAULT NULL
      ,p_source_id      NUMBER DEFAULT NULL
      ,p_wc_screening_request_id NUMBER DEFAULT NULL      
      , p_job_id                VARCHAR2 DEFAULT NULL
      , p_id              INTEGER
      , x_id OUT INTEGER
   );
   
END xwrl_utils;
/