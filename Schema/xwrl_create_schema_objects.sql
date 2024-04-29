/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: xwrl_create_schema_objects.sql 1.1 2019/11/15 12:00:00ET   IRI Exp                                     $*/
/********************************************************************************************************************
* Object Type         : Script                                                                                      *
* Name                :                                                                                             *
* Script Name         : xwrl_create_schema_objects.sql                                                              *
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
* 15-NOV-2019 IRI              1.2                TSUAZO          15-NOV-2019  I      Add XWRL_AUDIT_LOG              *
*                                                                                                                   *
********************************************************************************************************************/

/* XWRL */


/* DROP TYPES */
DROP TYPE xwrl_alert_tbl_in_type;
DROP TYPE xwrl_alert_in_rec;
DROP TYPE xwrl_alert_tbl_out_type;
DROP TYPE xwrl_alert_out_rec;


/* DROP SEQUENCES */
DROP SEQUENCE xwrl_alert_documents_seq;
DROP SEQUENCE xwrl_alert_notes_seq;
DROP SEQUENCE xwrl_doc_reference_seq;
DROP SEQUENCE xwrl_case_documents_seq;
DROP SEQUENCE xwrl_case_notes_seq;
DROP SEQUENCE xwrl_note_templates_seq;
DROP SEQUENCE xwrl_requests1_seq;
DROP SEQUENCE xwrl_requests2_seq;
DROP SEQUENCE xwrl_requests3_seq;
DROP SEQUENCE xwrl_requests4_seq;
DROP SEQUENCE xwrl_requests5_seq;
DROP SEQUENCE xwrl_requests6_seq;
DROP SEQUENCE xwrl_requests_seq;
DROP sequence xwrl_batch_seq;
drop sequence XWRL_AUDIT_LOG_seq;

/*
DROP SEQUENCE xwrl_alert_clearing_xref_seq;
DROP SEQUENCE xwrl_party_alias_seq;
DROP SEQUENCE xwrl_party_master_seq;
DROP SEQUENCE xwrl_party_xref_seq;
*/

DROP SEQUENCE XWRL.XWRL_CASE_NOTES_LINE_SEQ;
DROP  SEQUENCE XWRL.XWRL_ALERT_NOTES_LINE_SEQ;

/* DROP TABLES */
DROP TABLE xwrl_alert_documents CASCADE CONSTRAINTS;
DROP TABLE xwrl_alert_notes CASCADE CONSTRAINTS;
DROP TABLE xwrl_case_documents CASCADE CONSTRAINTS;
DROP TABLE xwrl_case_notes CASCADE CONSTRAINTS;
DROP TABLE xwrl_document_reference CASCADE CONSTRAINTS;
DROP TABLE xwrl_keywords CASCADE CONSTRAINTS;
DROP TABLE xwrl_location_types CASCADE CONSTRAINTS;
DROP TABLE xwrl_note_templates CASCADE CONSTRAINTS;
DROP TABLE xwrl_parameters CASCADE CONSTRAINTS;
DROP TABLE xwrl_request_entity_columns CASCADE CONSTRAINTS;
DROP TABLE xwrl_request_ind_columns CASCADE CONSTRAINTS;
DROP TABLE xwrl_request_rows CASCADE CONSTRAINTS;
DROP TABLE xwrl_response_entity_columns CASCADE CONSTRAINTS;
DROP TABLE xwrl_response_ind_columns CASCADE CONSTRAINTS;
DROP TABLE xwrl_response_rows CASCADE CONSTRAINTS;
DROP TABLE xwrl_wc_contents CASCADE CONSTRAINTS;
DROP TABLE xwrl_requests CASCADE CONSTRAINTS;
DROP TABLE XWRL_AUDIT_LOG ;


/*
DROP TABLE xwrl_alert_clearing_xref CASCADE CONSTRAINTS;
DROP TABLE xwrl_party_alias CASCADE CONSTRAINTS;
DROP TABLE xwrl_party_master CASCADE CONSTRAINTS;
DROP TABLE xwrl_party_xref CASCADE CONSTRAINTS;
*/

/* CREATE TYPES */
CREATE OR REPLACE TYPE xwrl_alert_in_rec AS OBJECT (
   p_alert_id   VARCHAR2 (100)
   , p_to_state   VARCHAR2 (100)
   , p_comment    VARCHAR2 (1000)
);
/

CREATE OR REPLACE TYPE xwrl_alert_tbl_in_type AS
   TABLE OF xwrl_alert_in_rec;
/

CREATE OR REPLACE TYPE xwrl_alert_out_rec IS OBJECT (
   alert_id    VARCHAR2 (100)
   , key_label   VARCHAR2 (500)
   , old_state   VARCHAR (100)
   , new_state   VARCHAR (100)
   , status      VARCHAR2 (100)
   , err_msg     VARCHAR2 (1000)
);
/

CREATE OR REPLACE TYPE xwrl_alert_tbl_out_type IS
   TABLE OF xwrl_alert_out_rec;
/

/* CREATE SEQUENCES */

CREATE SEQUENCE xwrl_alert_documents_seq START WITH 1000 NOCACHE;
CREATE SEQUENCE xwrl_alert_notes_seq START WITH 1000 NOCACHE;
CREATE SEQUENCE xwrl_case_documents_seq START WITH 1000 NOCACHE;
CREATE SEQUENCE xwrl_case_notes_seq START WITH 1000 NOCACHE;
CREATE SEQUENCE xwrl_doc_reference_seq;
CREATE SEQUENCE xwrl_note_templates_seq START WITH 1000 NOCACHE;

CREATE SEQUENCE xwrl_requests1_seq START WITH 1000 NOCACHE;
CREATE SEQUENCE xwrl_requests2_seq START WITH 1000 NOCACHE;
CREATE SEQUENCE xwrl_requests3_seq START WITH 1000 NOCACHE;
CREATE SEQUENCE xwrl_requests4_seq START WITH 1000 NOCACHE;
CREATE SEQUENCE xwrl_requests5_seq START WITH 1000 NOCACHE;
CREATE SEQUENCE xwrl_requests6_seq START WITH 1000 NOCACHE;
CREATE SEQUENCE xwrl_requests_seq START WITH 1000 NOCACHE;
create sequence xwrl_batch_seq  START WITH 1000 NOCACHE;

CREATE SEQUENCE XWRL.XWRL_CASE_NOTES_LINE_SEQ START WITH 10 INCREMENT BY 10  NOCACHE;
CREATE SEQUENCE XWRL.XWRL_ALERT_NOTES_LINE_SEQ START WITH 10 INCREMENT BY 10  NOCACHE;

create sequence XWRL_AUDIT_LOG_seq  START WITH 1000 NOCACHE;

/*
CREATE SEQUENCE xwrl_alert_clearing_xref_seq START WITH 1000 NOCACHE;
CREATE SEQUENCE xwrl_party_alias_seq START WITH 1000 NOCACHE;
CREATE SEQUENCE xwrl_party_master_seq START WITH 1000 NOCACHE;
CREATE SEQUENCE xwrl_party_xref_seq START WITH 1000 NOCACHE;
*/

  CREATE TABLE XWRL_AUDIT_LOG 
   (AUDIT_LOG_ID NUMBER NOT NULL, 
	TABLE_NAME VARCHAR2(50) NOT NULL, 
	TABLE_COLUMN VARCHAR2(50) NOT NULL, 
	TABLE_ID NUMBER NOT NULL, 
	ROW_ACTION VARCHAR2(50) NOT NULL, 
	OLD_VALUE VARCHAR2(3000)  , 
   NEW_VALUE VARCHAR2(3000)  , 
	LAST_UPDATE_DATE DATE, 
	LAST_UPDATED_BY NUMBER,
	CREATION_DATE DATE, 
	CREATED_BY NUMBER,
	LAST_UPDATE_LOGIN NUMBER
   )
   nologging;


/* CREATE TABLES */

CREATE TABLE xwrl_alert_documents (
   id                  INTEGER NOT NULL
   , request_id          INTEGER NOT NULL
   , alert_id            VARCHAR2 (50) NOT NULL
   , edoc_id             INTEGER
   , document_file       VARCHAR2 (500)
   , document_name       VARCHAR2 (500)
   , document_category   VARCHAR2 (100)
   , document_type       VARCHAR2 (100)
   , file_name           VARCHAR2 (500) NOT NULL
   , file_path           VARCHAR2 (500)
   , content_type        VARCHAR2 (500)
   , image_file          VARCHAR2 (500)
   , image_name          VARCHAR2 (500)
   , image_path          VARCHAR2 (500)
   , url_path            VARCHAR2 (500)
   , "COMMENT"           VARCHAR2 (500)
   , last_update_date    DATE
   , last_updated_by     NUMBER (15)
   , creation_date       DATE
   , created_by          NUMBER (15)
   , last_update_login   NUMBER (15)
)
nologging;

CREATE TABLE xwrl_alert_notes (
   id                  INTEGER NOT NULL
   , request_id          INTEGER NOT NULL
   , alert_id            VARCHAR2 (50) NOT NULL
   , line_number         INTEGER NOT NULL
   , note                VARCHAR2 (4000) NOT NULL
   , last_update_date    DATE
   , last_updated_by     NUMBER (15)
   , creation_date       DATE
   , created_by          NUMBER (15)
   , last_update_login   NUMBER (15)
)
nologging;

CREATE TABLE xwrl_case_documents (
   id                  INTEGER NOT NULL
   , request_id          INTEGER NOT NULL
   , case_id             VARCHAR2 (50) NOT NULL
   , edoc_id             INTEGER
   , document_file       VARCHAR2 (500)
   , document_name       VARCHAR2 (500)
   , document_category   VARCHAR2 (100)
   , document_type       VARCHAR2 (100)
   , file_name           VARCHAR2 (500) NOT NULL
   , file_path           VARCHAR2 (500)
   , content_type        VARCHAR2 (500)
   , image_file          VARCHAR2 (500)
   , image_name          VARCHAR2 (500)
   , image_path          VARCHAR2 (500)
   , url_path            VARCHAR2 (500)
   , "COMMENT"           VARCHAR2 (500)
   , last_update_date    DATE
   , last_updated_by     NUMBER (15)
   , creation_date       DATE
   , created_by          NUMBER (15)
   , last_update_login   NUMBER (15)
)
nologging;

CREATE TABLE xwrl_case_notes (
   id                  INTEGER NOT NULL
   , request_id          INTEGER NOT NULL
   , case_id             VARCHAR2 (50) NOT NULL
   , line_number         INTEGER NOT NULL
   , note                VARCHAR2 (4000) NOT NULL
   , last_update_date    DATE
   , last_updated_by     NUMBER (15)
   , creation_date       DATE
   , created_by          NUMBER (15)
   , last_update_login   NUMBER (15)
)
nologging;

CREATE TABLE xwrl_document_reference (
   id                  INTEGER NOT NULL
   , department           VARCHAR2 (30) NOT NULL
   , code       VARCHAR2 (30) NOT NULL
   , description                VARCHAR2 (500) NOT NULL
   , report_description                VARCHAR2 (500) NOT NULL   
   , priority_level VARCHAR2 (30)
   , sort_key            INTEGER 
   , last_update_date    DATE
   , last_updated_by     NUMBER (15)
   , creation_date       DATE
   , created_by          NUMBER (15)
   , last_update_login   NUMBER (15)
)
nologging;

CREATE TABLE xwrl_keywords (
   keyword_abbreviation   VARCHAR2 (30) NOT NULL
   , full_name_of_source    VARCHAR2 (500) NOT NULL
   , country_of_authority   VARCHAR2 (100)
   , type                   VARCHAR2 (50)
   , explanation            VARCHAR2 (3000) NOT NULL
   , last_update_date       DATE
   , last_updated_by        NUMBER (15)
   , creation_date          DATE
   , created_by             NUMBER (15)
   , last_update_login      NUMBER (15)
)
nologging;

CREATE TABLE xwrl_location_types (
   loc_type            VARCHAR2 (30) NOT NULL
   , country             VARCHAR2 (100) NOT NULL
   , full_name           VARCHAR2 (500) NOT NULL
   , last_update_date    DATE
   , last_updated_by     NUMBER (15)
   , creation_date       DATE
   , created_by          NUMBER (15)
   , last_update_login   NUMBER (15)
)
nologging;

CREATE TABLE xwrl_note_templates (
   id                  INTEGER NOT NULL
   , sort_key            INTEGER NOT NULL
   , note_type           VARCHAR2 (30) NOT NULL
   , note_category       VARCHAR2 (30) NOT NULL
   , note                VARCHAR2 (4000) NOT NULL
   , last_update_date    DATE
   , last_updated_by     NUMBER (15)
   , creation_date       DATE
   , created_by          NUMBER (15)
   , last_update_login   NUMBER (15)
)
nologging;

CREATE TABLE xwrl_parameters (
   id                  VARCHAR2 (100) NOT NULL
   , key                 VARCHAR2 (500) NOT NULL
   , value_string        VARCHAR2 (500)
   , value_date          DATE
   , value_xml           XMLTYPE
   , value_clob          CLOB
   , sort_order          INTEGER
   , display_flag        VARCHAR2 (10)
   , last_update_date    DATE
   , last_updated_by     NUMBER (15)
   , creation_date       DATE
   , created_by          NUMBER (15)
   , last_update_login   NUMBER (15)
)
LOGGING XMLTYPE COLUMN value_xml STORE AS BINARY XML (
   STORAGE (PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 BUFFER_POOL DEFAULT)
   RETENTION
   ENABLE STORAGE IN ROW
   NOCACHE
);


CREATE TABLE xwrl_requests (
   id                              INTEGER NOT NULL
   , resubmit_id                     INTEGER
   , source_table                    VARCHAR2 (50)
   , source_id                       NUMBER
   , vessel_pk                       NUMBER
   , vessel_uk                       NUMBER
   , wc_screening_request_id         NUMBER
   , master_id                       INTEGER
   , alias_id                        INTEGER
   , xref_id                         INTEGER
   , batch_id                        INTEGER
   , version_id    NUMBER
   , parent_id                       INTEGER
   , case_id                         VARCHAR2 (2700)
   , server                          VARCHAR2 (100)
   , path                            VARCHAR2 (100)
   , soap_query                      VARCHAR2 (3000)
   , request                         XMLTYPE
   , response                        XMLTYPE
   , job_id                          VARCHAR2 (100)
   , matches                         INTEGER
   , status                          VARCHAR2 (30)
   , name_screened                   VARCHAR2 (1000)
   , date_of_birth                   VARCHAR2 (2700)
   , imo_number                      INTEGER
   , department                      VARCHAR2 (100)
   , department_ext                      VARCHAR2 (300)
   , office                          VARCHAR2 (100)
   , priority                        VARCHAR2 (10)
   , risk_level                      VARCHAR2 (10)
   , document_type                   VARCHAR2 (100)
   , closed_date                     DATE
   , assigned_to                     NUMBER (15)
   , vessel_indicator                VARCHAR2 (10)
   , category_restriction_indicator                VARCHAR2 (10)
   , country_of_address            VARCHAR2 (10)
   , country_of_residence            VARCHAR2 (10)
   , country_of_nationality            VARCHAR2 (10)
   , country_of_birth            VARCHAR2 (10)
   , country_of_registration           VARCHAR2 (10)
   , country_of_operation           VARCHAR2 (10)
   , city_of_residence               VARCHAR2 (2700)
   , city_of_residence_id            NUMBER
   , subdivision_city_of_residence   VARCHAR2 (2700)
   , case_status                     VARCHAR2 (30)
   , case_state                      VARCHAR2 (30)
   , case_workflow                   VARCHAR2 (30)
   , rejection_reason                VARCHAR2 (30)
    ,REJECTION_REASON_OTHR VARCHAR2(200)   
   , error_code                      VARCHAR2 (100)
   , error_message                   VARCHAR2 (1000)
   ,expiration_date                DATE
   ,sent_to_legal_date date
   ,sent_to_legal_by number(15)
   , last_update_date                DATE
   , last_updated_by                 NUMBER (15)
   , creation_date                   DATE
   , created_by                      NUMBER (15)
   , last_update_login               NUMBER (15)
) XMLTYPE COLUMN request STORE AS BINARY XML (
   STORAGE (PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 BUFFER_POOL DEFAULT)
   RETENTION
   ENABLE STORAGE IN ROW
   NOCACHE
) XMLTYPE COLUMN response STORE AS BINARY XML (
   STORAGE (PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 BUFFER_POOL DEFAULT)
   RETENTION
   ENABLE STORAGE IN ROW
   NOCACHE
)
nologging;

CREATE TABLE xwrl_request_entity_columns (
   id                        INTEGER NOT NULL
   , request_id                INTEGER NOT NULL
   , listsubkey                VARCHAR2 (2700)
   , listrecordtype            VARCHAR2 (2700)
   , listrecordorigin          VARCHAR2 (2700)
   , custid                    VARCHAR2 (2700)
   , custsubid                 VARCHAR2 (2700)
   , registrationnumber        VARCHAR2 (2700)
   , entityname                VARCHAR2 (2700)
   , nametype                  VARCHAR2 (2700)
   , namequality               VARCHAR2 (2700)
   , primaryname               VARCHAR2 (2700)
   , originalscriptname        VARCHAR2 (2700)
   , aliasisacronym            VARCHAR2 (2700)
   , address1                  VARCHAR2 (2700)
   , address2                  VARCHAR2 (2700)
   , address3                  VARCHAR2 (2700)
   , address4                  VARCHAR2 (2700)
   , city                      VARCHAR2 (2700)
   , state                     VARCHAR2 (2700)
   , postalcode                VARCHAR2 (2700)
   , addresscountrycode        VARCHAR2 (2700)
   , registrationcountrycode   VARCHAR2 (2700)
   , operatingcountrycodes     VARCHAR2 (2700)
   , profilehyperlink          VARCHAR2 (2700)
   , riskscore                 VARCHAR2 (2700)
   , dataconfidencescore       VARCHAR2 (2700)
   , dataconfidencecomment     VARCHAR2 (2700)
   , customstring1             VARCHAR2 (2700)
   , customstring2             VARCHAR2 (2700)
   , customstring3             VARCHAR2 (2700)
   , customstring4             VARCHAR2 (2700)
   , customstring5             VARCHAR2 (2700)
   , customstring6             VARCHAR2 (2700)
   , customstring7             VARCHAR2 (2700)
   , customstring8             VARCHAR2 (2700)
   , customstring9             VARCHAR2 (2700)
   , customstring10            VARCHAR2 (2700)
   , customstring11            VARCHAR2 (2700)
   , customstring12            VARCHAR2 (2700)
   , customstring13            VARCHAR2 (2700)
   , customstring14            VARCHAR2 (2700)
   , customstring15            VARCHAR2 (2700)
   , customstring16            VARCHAR2 (2700)
   , customstring17            VARCHAR2 (2700)
   , customstring18            VARCHAR2 (2700)
   , customstring19            VARCHAR2 (2700)
   , customstring20            VARCHAR2 (2700)
   , customstring21            VARCHAR2 (2700)
   , customstring22            VARCHAR2 (2700)
   , customstring23            VARCHAR2 (2700)
   , customstring24            VARCHAR2 (2700)
   , customstring25            VARCHAR2 (2700)
   , customstring26            VARCHAR2 (2700)
   , customstring27            VARCHAR2 (2700)
   , customstring28            VARCHAR2 (2700)
   , customstring29            VARCHAR2 (2700)
   , customstring30            VARCHAR2 (2700)
   , customstring31            VARCHAR2 (2700)
   , customstring32            VARCHAR2 (2700)
   , customstring33            VARCHAR2 (2700)
   , customstring34            VARCHAR2 (2700)
   , customstring35            VARCHAR2 (2700)
   , customstring36            VARCHAR2 (2700)
   , customstring37            VARCHAR2 (2700)
   , customstring38            VARCHAR2 (2700)
   , customstring39            VARCHAR2 (2700)
   , customstring40            VARCHAR2 (2700)
   , customdate1               VARCHAR2 (2700)
   , customdate2               VARCHAR2 (2700)
   , customdate3               VARCHAR2 (2700)
   , customdate4               VARCHAR2 (2700)
   , customdate5               VARCHAR2 (2700)
   , customnumber1             VARCHAR2 (2700)
   , customnumber2             VARCHAR2 (2700)
   , customnumber3             VARCHAR2 (2700)
   , customnumber4             VARCHAR2 (2700)
   , customnumber5             VARCHAR2 (2700)
   , last_update_date          DATE
   , last_updated_by           NUMBER (15)
   , creation_date             DATE
   , created_by                NUMBER (15)
   , last_update_login         NUMBER (15)
)
nologging;

CREATE TABLE xwrl_request_ind_columns (
   id                        INTEGER NOT NULL
   , request_id                INTEGER NOT NULL
   , listsubkey                VARCHAR2 (2700)
   , listrecordtype            VARCHAR2 (2700)
   , listrecordorigin          VARCHAR2 (2700)
   , custid                    VARCHAR2 (2700)
   , custsubid                 VARCHAR2 (2700)
   , passportnumber            VARCHAR2 (2700)
   , nationalid                VARCHAR2 (2700)
   , title                     VARCHAR2 (2700)
   , fullname                  VARCHAR2 (2700)
   , givennames                VARCHAR2 (2700)
   , familyname                VARCHAR2 (2700)
   , nametype                  VARCHAR2 (2700)
   , namequality               VARCHAR2 (2700)
   , primaryname               VARCHAR2 (2700)
   , originalscriptname        VARCHAR2 (2700)
   , gender                    VARCHAR2 (2700)
   , dateofbirth               VARCHAR2 (2700)
   , yearofbirth               VARCHAR2 (2700)
   , occupation                VARCHAR2 (2700)
   , address1                  VARCHAR2 (2700)
   , address2                  VARCHAR2 (2700)
   , address3                  VARCHAR2 (2700)
   , address4                  VARCHAR2 (2700)
   , city                      VARCHAR2 (2700)
   , state                     VARCHAR2 (2700)
   , postalcode                VARCHAR2 (2700)
   , addresscountrycode        VARCHAR2 (2700)
   , residencycountrycode      VARCHAR2 (2700)
   , countryofbirthcode        VARCHAR2 (2700)
   , nationalitycountrycodes   VARCHAR2 (2700)
   , profilehyperlink          VARCHAR2 (2700)
   , riskscore                 VARCHAR2 (2700)
   , dataconfidencescore       VARCHAR2 (2700)
   , dataconfidencecomment     VARCHAR2 (2700)
   , customstring1             VARCHAR2 (2700)
   , customstring2             VARCHAR2 (2700)
   , customstring3             VARCHAR2 (2700)
   , customstring4             VARCHAR2 (2700)
   , customstring5             VARCHAR2 (2700)
   , customstring6             VARCHAR2 (2700)
   , customstring7             VARCHAR2 (2700)
   , customstring8             VARCHAR2 (2700)
   , customstring9             VARCHAR2 (2700)
   , customstring10            VARCHAR2 (2700)
   , customstring11            VARCHAR2 (2700)
   , customstring12            VARCHAR2 (2700)
   , customstring13            VARCHAR2 (2700)
   , customstring14            VARCHAR2 (2700)
   , customstring15            VARCHAR2 (2700)
   , customstring16            VARCHAR2 (2700)
   , customstring17            VARCHAR2 (2700)
   , customstring18            VARCHAR2 (2700)
   , customstring19            VARCHAR2 (2700)
   , customstring20            VARCHAR2 (2700)
   , customstring21            VARCHAR2 (2700)
   , customstring22            VARCHAR2 (2700)
   , customstring23            VARCHAR2 (2700)
   , customstring24            VARCHAR2 (2700)
   , customstring25            VARCHAR2 (2700)
   , customstring26            VARCHAR2 (2700)
   , customstring27            VARCHAR2 (2700)
   , customstring28            VARCHAR2 (2700)
   , customstring29            VARCHAR2 (2700)
   , customstring30            VARCHAR2 (2700)
   , customstring31            VARCHAR2 (2700)
   , customstring32            VARCHAR2 (2700)
   , customstring33            VARCHAR2 (2700)
   , customstring34            VARCHAR2 (2700)
   , customstring35            VARCHAR2 (2700)
   , customstring36            VARCHAR2 (2700)
   , customstring37            VARCHAR2 (2700)
   , customstring38            VARCHAR2 (2700)
   , customstring39            VARCHAR2 (2700)
   , customstring40            VARCHAR2 (2700)
   , customdate1               VARCHAR2 (2700)
   , customdate2               VARCHAR2 (2700)
   , customdate3               VARCHAR2 (2700)
   , customdate4               VARCHAR2 (2700)
   , customdate5               VARCHAR2 (2700)
   , customnumber1             VARCHAR2 (2700)
   , customnumber2             VARCHAR2 (2700)
   , customnumber3             VARCHAR2 (2700)
   , customnumber4             VARCHAR2 (2700)
   , customnumber5             VARCHAR2 (2700)
   , last_update_date          DATE
   , last_updated_by           NUMBER (15)
   , creation_date             DATE
   , created_by                NUMBER (15)
   , last_update_login         NUMBER (15)
)
nologging;

CREATE TABLE xwrl_request_rows (
   id                  INTEGER NOT NULL
   , request_id          INTEGER NOT NULL
   , path                VARCHAR2 (50)
   , rw                  INTEGER
   , key                 VARCHAR2 (100)
   , value               VARCHAR2 (2700)
   , last_update_date    DATE
   , last_updated_by     NUMBER (15)
   , creation_date       DATE
   , created_by          NUMBER (15)
   , last_update_login   NUMBER (15)
)
nologging;

CREATE TABLE xwrl_response_entity_columns (
   id                          INTEGER NOT NULL
   , request_id                  INTEGER NOT NULL
   , x_state                     VARCHAR2 (100)
   ,LEGAL_REVIEW VARCHAR2(10) 
   , rec                         INTEGER NOT NULL
   , listkey                     VARCHAR2 (2700)
   , listsubkey                  VARCHAR2 (2700)
   , listrecordtype              VARCHAR2 (2700)
   , listrecordorigin            VARCHAR2 (2700)
   , listid                      VARCHAR2 (2700)
   , listentityname              VARCHAR2 (2700)
   , listprimaryname             VARCHAR2 (2700)
   , listoriginalscriptname      VARCHAR2 (2700)
   , listnametype                VARCHAR2 (2700)
   , listcity                    VARCHAR2 (2700)
   , listcountry                 VARCHAR2 (2700)
   , listoperatingcountries      VARCHAR2 (2700)
   , listregistrationcountries   VARCHAR2 (2700)
   , matchrule                   VARCHAR2 (2700)
   , matchscore                  VARCHAR2 (2700)
   , casekey                     VARCHAR2 (2700)
   , alertid                     VARCHAR2 (2700)
   , riskscore                   VARCHAR2 (2700)
   , riskscorepep                VARCHAR2 (2700)
   , last_update_date            DATE
   , last_updated_by             NUMBER (15)
   , creation_date               DATE
   , created_by                  NUMBER (15)
   , last_update_login           NUMBER (15)
   , category                    VARCHAR2 (100)
   , dnregistrationnumber        VARCHAR2 (2700)
   , dnoriginalentityname        VARCHAR2 (4000)
   , dnentityname                VARCHAR2 (4000)
   , dnnametype                  VARCHAR2 (100)
   , dnnamequality               VARCHAR2 (100)
   , dnprimaryname               VARCHAR2 (4000)
   , dnvesselindicator           VARCHAR2 (100)
   , dnvesselinfo                VARCHAR2 (4000)
   , dnaddress                   VARCHAR2 (4000)
   , dncity                      VARCHAR2 (4000)
   , dnstate                     VARCHAR2 (4000)
   , dnpostalcode                VARCHAR2 (100)
   , dnaddresscountrycode        VARCHAR2 (100)
   , dnregistrationcountrycode   VARCHAR2 (100)
   , dnoperatingcountrycodes     VARCHAR2 (100)
   , dnpepclassification         VARCHAR2 (100)
   , dnallcountrycodes           VARCHAR2 (100)
   , externalsources             VARCHAR2 (4000)
   , cachedextsources            VARCHAR2 (4000)
   , dninactiveflag              VARCHAR2 (100)
   , dninactivesincedate         VARCHAR2 (100)
   , dnaddeddate                 VARCHAR2 (100)
   , dnlastupdateddate           VARCHAR2 (100)
   , AdditionalInformation VARCHAR2(4000)
   , dnAddressCountry VARCHAR2(4000)
  , dnRegistrationCountry VARCHAR2(4000)
  , dnOperatingCountries VARCHAR2(4000)
  , dnAllCountries VARCHAR2(4000)
)
nologging;




--alter TABLE xwrl_response_entity_columns add ( x_state varchar2(100));

CREATE TABLE xwrl_response_ind_columns (
   id                          INTEGER NOT NULL
   , request_id                  INTEGER NOT NULL
   , x_state                     VARCHAR2 (100)
   ,LEGAL_REVIEW VARCHAR2(10) 
   , rec                         INTEGER NOT NULL
   , listkey                     VARCHAR2 (2700)
   , listsubkey                  VARCHAR2 (2700)
   , listrecordtype              VARCHAR2 (2700)
   , listrecordorigin            VARCHAR2 (2700)
   , listid                      VARCHAR2 (2700)
   , listgivennames              VARCHAR2 (2700)
   , listfamilyname              VARCHAR2 (2700)
   , listfullname                VARCHAR2 (2700)
   , listnametype                VARCHAR2 (2700)
   , listprimaryname             VARCHAR2 (2700)
   , listoriginalscriptname      VARCHAR2 (2700)
   , listdob                     VARCHAR2 (2700)
   , listcity                    VARCHAR2 (2700)
   , listcountry                 VARCHAR2 (2700)
   , listcountryofbirth          VARCHAR2 (2700)
   , listnationality             VARCHAR2 (2700)
   , matchrule                   VARCHAR2 (2700)
   , matchscore                  VARCHAR2 (2700)
   , casekey                     VARCHAR2 (2700)
   , alertid                     VARCHAR2 (2700)
   , riskscore                   VARCHAR2 (2700)
   , riskscorepep                VARCHAR2 (2700)
   , last_update_date            DATE
   , last_updated_by             NUMBER (15)
   , creation_date               DATE
   , created_by                  NUMBER (15)
   , last_update_login           NUMBER (15)
   , category                    VARCHAR2 (100)
   , dnpassportnumber            VARCHAR2 (1000)
   , dnnationalid                VARCHAR2 (1000)
   , dntitle                     VARCHAR2 (1000)
   , dnyob                       VARCHAR2 (100)
   , dngender                    VARCHAR2 (100)
   , deceasedflag                VARCHAR2 (100)
   , deceaseddate                VARCHAR2 (100)
   , dnoccupation                VARCHAR2 (1000)
   , dnaddress                   VARCHAR2 (4000)
   , dncity                      VARCHAR2 (4000)
   , dnstate                     VARCHAR2 (4000)
   , dnpostalcode                VARCHAR2 (100)
   , dnaddresscountrycode        VARCHAR2 (100)
   , dnresidencycountrycode      VARCHAR2 (100)
   , dncountryofbirthcode        VARCHAR2 (100)
   , dnnationalitycountrycodes   VARCHAR2 (100)
   , externalsources             VARCHAR2 (4000)
   , cachedextsources            VARCHAR2 (4000)
   , dnaddeddate                 VARCHAR2 (100)
   , dnlastupdateddate           VARCHAR2 (100)
   , AdditionalInformation VARCHAR2(4000)
   , dnAddressCountry VARCHAR2(4000)
  , dnResidencyCountry VARCHAR2(4000)
  , dnCountryOfBirth VARCHAR2(4000)
  , dnNationalitiesCountries VARCHAR2(4000)
  , dnAllCountries VARCHAR2(4000)
)
nologging;

CREATE TABLE xwrl_response_rows (
   id                  INTEGER NOT NULL
   , request_id          INTEGER NOT NULL
   , path                VARCHAR2 (50)
   , ows_id              VARCHAR2 (500)
   , rec_row             INTEGER
   , det_row             INTEGER
   , key                 VARCHAR2 (100)
   , value               VARCHAR2 (4000)
   , label               VARCHAR2 (100)
   , display             VARCHAR2 (500)
   , sort_id             INTEGER
   , last_update_date    DATE
   , last_updated_by     NUMBER (15)
   , creation_date       DATE
   , created_by          NUMBER (15)
   , last_update_login   NUMBER (15)
)
nologging;

CREATE TABLE xwrl_wc_contents (
   wc_screening_request_id   NUMBER
   , wc_matches_id             NUMBER
   , wc_content_id             NUMBER
   , heading                   VARCHAR2 (100)
   , data_type                 VARCHAR2 (100)
   , display_data              VARCHAR2 (4000)
)
nologging;




/*
CREATE TABLE xwrl_alert_clearing_xref (
   id                        INTEGER NOT NULL
   , request_id                INTEGER
   , case_key                  VARCHAR2 (50)
   , alert_id                  VARCHAR2 (50)
   , wc_screening_request_id   NUMBER
   , wc_matches_id             NUMBER
   , wc_content_id             NUMBER
   , source_table              VARCHAR2 (50) NOT NULL
   , source_table_column       VARCHAR2 (50)
   , source_id                 NUMBER NOT NULL
   , source_key       VARCHAR2 (300)
   , list_id                   INTEGER NOT NULL
   , from_state                VARCHAR2 (100)
   , to_state                  VARCHAR2 (100)
   , status                    VARCHAR2 (100)
   , parent_request_id         INTEGER
   , relationship_type         VARCHAR2 (100)
   , error_message             VARCHAR2 (1000)
   , note                      VARCHAR2 (4000)
   , last_update_date          DATE
   , last_updated_by           NUMBER (15)
   , creation_date             DATE
   , created_by                NUMBER (15)
   , last_update_login         NUMBER (15)
);



CREATE TABLE xwrl_party_master (
   id                              INTEGER NOT NULL
   , wc_screening_request_id         NUMBER
   ,   batch_id                        INTEGER
   , relationship_type               VARCHAR2 (50) NOT NULL
   , entity_type                     VARCHAR2 (100) NOT NULL
   , state                           VARCHAR2 (100) NOT NULL
   , status                          VARCHAR2 (100) NOT NULL
   , source_table                    VARCHAR2 (50)
   , source_table_column             VARCHAR2 (50)
   , source_id                       NUMBER
   ,source_key   VARCHAR2(300)
   , xref_source_table               VARCHAR2 (50)
   , xref_source_table_column        VARCHAR2 (50)
   , xref_source_id                  NUMBER
   ,xref_source_key   VARCHAR2(300)
   , source_target_column       VARCHAR2 (500)
   , full_name                       VARCHAR2 (2700)
   , family_name                     VARCHAR2 (2700)
   , given_name                      VARCHAR2 (2700)
   , date_of_birth                   VARCHAR2 (2700)
   , sex                             VARCHAR2 (100)
   , imo_number                      INTEGER
   , department                      VARCHAR2 (100)
   , office                          VARCHAR2 (100)
   , priority                        VARCHAR2 (10)
   , risk_level                      VARCHAR2 (10)
   , document_type                   VARCHAR2 (100)
   , closed_date                     DATE
   , assigned_to                     NUMBER (15)
   , vessel_indicator                VARCHAR2 (10)
   , passport_number                 VARCHAR2 (2700)
   , passport_issuing_country_code   VARCHAR2 (10)
   , citizenship_country_code        VARCHAR2 (10)
   , country_of_residence            VARCHAR2 (10)
   , city_of_residence_id            NUMBER
   , note                            VARCHAR2 (4000)
   ,start_date  DATE
   ,end_date DATE   
   , last_update_date                DATE
   , last_updated_by                 NUMBER (15)
   , creation_date                   DATE
   , created_by                      NUMBER (15)
   , last_update_login               NUMBER (15)
)
nologging;

CREATE TABLE xwrl_party_alias (
   id                              INTEGER NOT NULL
   , master_id                       INTEGER
   , wc_screening_request_id         NUMBER
   , relationship_type               VARCHAR2 (10) NOT NULL
   , state                           VARCHAR2 (100) NOT NULL
   , status                          VARCHAR2 (100) NOT NULL
   , entity_type                     VARCHAR2 (100) NOT NULL   
   --,source_key   VARCHAR2(300)
   --, source_table           VARCHAR2 (50)
   --, source_table_column    VARCHAR2 (50)
   --, source_id              NUMBER
   , full_name                       VARCHAR2 (2700)
   , family_name                     VARCHAR2 (2700)
   , given_name                      VARCHAR2 (2700)
   , date_of_birth                   VARCHAR2 (2700)
   , sex                             VARCHAR2 (100)
   , imo_number                      INTEGER
   , department                      VARCHAR2 (100)
   , office                          VARCHAR2 (100)
   , priority                        VARCHAR2 (10)
   , risk_level                      VARCHAR2 (10)
   , document_type                   VARCHAR2 (100)
   , closed_date                     DATE
   , assigned_to                     NUMBER (15)
   , vessel_indicator                VARCHAR2 (10)
   , passport_number                 VARCHAR2 (2700)
   , passport_issuing_country_code   VARCHAR2 (10)
   , citizenship_country_code        VARCHAR2 (10)
   , country_of_residence            VARCHAR2 (10)
   , city_of_residence_id            NUMBER
   , sort_order                      INTEGER
   ,start_date  DATE
   ,end_date DATE   
   , last_update_date                DATE
   , last_updated_by                 NUMBER (15)
   , creation_date                   DATE
   , created_by                      NUMBER (15)
   , last_update_login               NUMBER (15)
)
nologging;

CREATE TABLE xwrl_party_xref (
   id                       INTEGER NOT NULL
   , master_id                INTEGER NOT NULL
   , relationship_master_id   INTEGER NOT NULL
   , relationship_type        VARCHAR2 (100)
   , state                    VARCHAR2 (100) NOT NULL
   , status                   VARCHAR2 (100) NOT NULL
   , note                     VARCHAR2 (100)
   , sort_order               INTEGER
   ,start_date  DATE
   ,end_date DATE
   , last_update_date         DATE
   , last_updated_by          NUMBER (15)
   , creation_date            DATE
   , created_by               NUMBER (15)
   , last_update_login        NUMBER (15)
)
nologging;
*/



/* CREATE TRIGGERS */


CREATE OR REPLACE TRIGGER xwrl_resp_ind_col_trg BEFORE
   INSERT ON xwrl_response_ind_columns
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests4_seq.nextval;
   END IF;
END;
/

CREATE OR REPLACE TRIGGER xwrl_alert_notes_trg BEFORE
   INSERT ON xwrl_alert_notes
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_alert_notes_seq.nextval;
   END IF;
END;
/

CREATE OR REPLACE TRIGGER xwrl_resp_ind_col_trg BEFORE
   INSERT ON xwrl_response_ind_columns
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests4_seq.nextval;
   END IF;
END;
/

CREATE OR REPLACE TRIGGER xwrl_case_notes_trg BEFORE
   INSERT ON xwrl_case_notes
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_case_notes_seq.nextval;
   END IF;
END;
/

CREATE OR REPLACE TRIGGER xwrl_doc_reference_trg BEFORE
   INSERT ON xwrl_document_reference
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_doc_reference_seq.nextval;
   END IF;
END;
/

CREATE OR REPLACE TRIGGER xwrl_note_templates_trg BEFORE
   INSERT ON xwrl_note_templates
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_note_templates_seq.nextval;
   END IF;
END;
/

CREATE OR REPLACE TRIGGER xwrl_requests BEFORE
   INSERT ON xwrl_requests
   FOR EACH ROW
BEGIN

   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests_seq.nextval;
   END IF;

END;
/

CREATE OR REPLACE TRIGGER xwrl_request_entity_col_trg BEFORE
   INSERT ON xwrl_request_entity_columns
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests2_seq.nextval;
   END IF;
END;
/

CREATE OR REPLACE TRIGGER xwrl_request_ind_col_trg BEFORE
   INSERT ON xwrl_request_ind_columns
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests1_seq.nextval;
   END IF;
END;
/

CREATE OR REPLACE TRIGGER xwrl_request_rows_trg BEFORE
   INSERT ON xwrl_request_rows
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests3_seq.nextval;
   END IF;
END;
/

CREATE OR REPLACE TRIGGER xwrl_response_rows_trg BEFORE
   INSERT ON xwrl_response_rows
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests6_seq.nextval;
   END IF;
END;
/

CREATE OR REPLACE TRIGGER xwrl_resp_entity_col_trg BEFORE
   INSERT ON xwrl_response_entity_columns
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests5_seq.nextval;
   END IF;
END;
/

CREATE OR REPLACE TRIGGER xwrl_resp_ind_col_trg BEFORE
   INSERT ON xwrl_response_ind_columns
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_requests4_seq.nextval;
   END IF;
END;
/

CREATE OR REPLACE TRIGGER XWRL_AUDIT_LOG_trg BEFORE
   INSERT ON XWRL_AUDIT_LOG
   FOR EACH ROW
BEGIN
   IF (:new.AUDIT_LOG_ID IS NULL) THEN
      :new.AUDIT_LOG_ID := XWRL_AUDIT_LOG_seq.nextval;
   END IF;
END;
/   


/*


CREATE OR REPLACE TRIGGER xwrl_alert_clearing_xref_trg BEFORE
   INSERT ON xwrl_alert_clearing_xref
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_alert_clearing_xref_seq.nextval;
   END IF;
   
   :NEW.source_key := :NEW.source_table||:NEW.source_table_column||:NEW.source_id;
   
END;
/

CREATE OR REPLACE TRIGGER xwrl_party_alias BEFORE
   INSERT ON xwrl_party_alias
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_party_alias_seq.nextval;
   END IF;
END;
/

CREATE OR REPLACE TRIGGER xwrl_party_master_trg BEFORE
   INSERT ON xwrl_party_master
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_party_master_seq.nextval;
   END IF;
   
   :NEW.source_key := :NEW.source_table||:NEW.source_table_column||:NEW.source_id;
   :NEW.xref_source_key := :NEW.xref_source_table||:NEW.xref_source_table_column||:NEW.xref_source_id;
   
END;
/

CREATE OR REPLACE TRIGGER xwrl_party_xref_trg BEFORE
   INSERT ON xwrl_party_xref
   FOR EACH ROW
BEGIN
   IF (:new.id IS NULL) THEN
      :new.id := xwrl_party_xref_seq.nextval;
   END IF;
END;
/

*/

/* CREATE CONSTRAINTS */


ALTER TABLE xwrl_alert_documents ADD CONSTRAINT xwrl_alert_documents_pk PRIMARY KEY ( id );
ALTER TABLE xwrl_alert_notes ADD CONSTRAINT xwrl_alert_notes_pk PRIMARY KEY ( id );
ALTER TABLE xwrl_case_documents ADD CONSTRAINT xwrl_case_documents_pk PRIMARY KEY ( id );
ALTER TABLE xwrl_case_notes ADD CONSTRAINT xwrl_case_notes_pk PRIMARY KEY ( id );
ALTER TABLE xwrl_document_reference ADD CONSTRAINT xwrl_document_reference_pk PRIMARY KEY (id);
ALTER TABLE xwrl_keywords ADD CONSTRAINT xwrl_keywords_pk PRIMARY KEY (keyword_abbreviation);
ALTER TABLE xwrl_location_types ADD CONSTRAINT xwrl_location_types_pk PRIMARY KEY (loc_type);
ALTER TABLE xwrl_note_templates ADD CONSTRAINT xwrl_note_templates_pk PRIMARY KEY ( id );
ALTER TABLE xwrl_parameters ADD CONSTRAINT xwrl_parameters_pk PRIMARY KEY (id, key);

ALTER TABLE xwrl_requests ADD CONSTRAINT xwrl_requests_pk PRIMARY KEY (id);
ALTER TABLE xwrl_request_ind_columns ADD CONSTRAINT xwrl_request_ind_columns_pk PRIMARY KEY (id);
ALTER TABLE xwrl_request_entity_columns ADD CONSTRAINT xwrl_request_entity_columns_pk PRIMARY KEY (id);
ALTER TABLE xwrl_request_rows ADD CONSTRAINT xwrl_request_rows_pk PRIMARY KEY (id);
ALTER TABLE xwrl_response_ind_columns ADD CONSTRAINT xwrl_response_ind_columns_pk PRIMARY KEY (id);
ALTER TABLE xwrl_response_entity_columns ADD CONSTRAINT xwrl_response_entity_col_pk PRIMARY KEY (id);
ALTER TABLE xwrl_response_rows ADD CONSTRAINT xwrl_response_rows_pk PRIMARY KEY (id);
ALTER TABLE XWRL_AUDIT_LOG ADD CONSTRAINT XWRL_AUDIT_LOG_pk PRIMARY KEY (AUDIT_LOG_ID);

ALTER TABLE xwrl_request_ind_columns ADD CONSTRAINT xwrl_request_ind_columns_fk1 FOREIGN KEY (request_id) REFERENCES xwrl_requests (id);
ALTER TABLE xwrl_request_entity_columns ADD CONSTRAINT xwrl_request_entity_col_fk1 FOREIGN KEY (request_id) REFERENCES xwrl_requests (id);
ALTER TABLE xwrl_request_rows ADD CONSTRAINT xwrl_request_rows_fk1 FOREIGN KEY (request_id) REFERENCES xwrl_requests (id);
ALTER TABLE xwrl_response_ind_columns ADD CONSTRAINT xwrl_response_ind_columns_fk1 FOREIGN KEY (request_id) REFERENCES xwrl_requests (id);
ALTER TABLE xwrl_response_entity_columns ADD CONSTRAINT xwrl_response_entity_col_fk1 FOREIGN KEY (request_id) REFERENCES xwrl_requests (id);
ALTER TABLE xwrl_response_rows ADD CONSTRAINT xwrl_response_rows_fk1 FOREIGN KEY (request_id) REFERENCES xwrl_requests (id);


--ALTER TABLE xwrl_alert_notes DROP CONSTRAINT   xwrl_alert_notes_uk;
--ALTER TABLE xwrl_case_notes DROP CONSTRAINT    xwrl_case_notes_uk;
-- Note: Alert Id is not unique wiithin the Response.  Added Id to make a unique record in the Notes tables.

ALTER TABLE xwrl_alert_notes ADD CONSTRAINT xwrl_alert_notes_uk unique ( id, alert_id, line_number );
ALTER TABLE xwrl_case_notes ADD CONSTRAINT  xwrl_case_notes_uk unique (id, case_id, line_number);
ALTER TABLE xwrl_document_reference ADD CONSTRAINT xwrl_doc_reference_uk unique (department, code);

-- ALTER TABLE xwrl_alert_clearing_xref ADD constraint xwrl_alert_clearing_xref_uk UNIQUE ( source_table,source_id,list_id ); -- replaced with source_key
-- ALTER TABLE xwrl.xwrl_party_master ADD CONSTRAINT  xwrl_party_master_uk unique (entity_type,source_key);  -- Needs to be run after the data fix scripts

alter table  xwrl_alert_clearing_xref drop constraint xwrl_alert_clearing_xref_uk;

/* 

ALTER TABLE xwrl_alert_clearing_xref ADD CONSTRAINT xwrl_alert_clearing_xref_pk PRIMARY KEY (id);
ALTER TABLE xwrl_alert_clearing_xref ADD CONSTRAINT xwrl_alert_clearing_xref_uk unique ( source_key, list_id );
ALTER TABLE xwrl_party_alias ADD CONSTRAINT xwrl_party_alias_pk PRIMARY KEY (id);
ALTER TABLE xwrl_party_master ADD CONSTRAINT xwrl_party_master_pk PRIMARY KEY (id);
ALTER TABLE xwrl_party_xref ADD CONSTRAINT xwrl_party_xref_pk PRIMARY KEY (id);
ALTER TABLE xwrl_party_alias ADD CONSTRAINT xwrl_party_alias_fk1 FOREIGN KEY (master_id) REFERENCES xwrl_party_master (id);

*/


/* CREATE GRANTS */
GRANT ALL ON xwrl_alert_clearing_xref TO apps;
GRANT ALL ON xwrl_alert_clearing_xref_seq TO apps;
GRANT ALL ON xwrl_alert_tbl_in_type TO apps;
GRANT ALL ON xwrl_alert_tbl_out_type TO apps;
GRANT ALL ON xwrl_alert_documents TO apps;
GRANT ALL ON xwrl_alert_documents_seq TO apps;
GRANT ALL ON xwrl_alert_in_rec TO apps;
GRANT ALL ON xwrl_alert_notes TO apps;
GRANT ALL ON xwrl_alert_out_rec TO apps;
GRANT ALL ON xwrl_case_documents TO apps;
GRANT ALL ON xwrl_case_documents_seq TO apps;
GRANT ALL ON xwrl_case_notes TO apps;
GRANT ALL ON xwrl_doc_reference_seq TO apps;
GRANT ALL ON xwrl_document_reference TO apps;
GRANT ALL ON xwrl_keywords TO apps;
GRANT ALL ON xwrl_location_types TO apps;
GRANT ALL ON xwrl_party_alias TO apps;
GRANT ALL ON xwrl_party_master TO apps;
GRANT ALL ON xwrl_party_xref TO apps;
GRANT ALL ON xwrl_parameters TO apps;
GRANT ALL ON xwrl_requests TO apps;
GRANT ALL ON xwrl_request_ind_columns TO apps;
GRANT ALL ON xwrl_request_entity_columns TO apps;
GRANT ALL ON xwrl_request_rows TO apps;
GRANT ALL ON xwrl_response_ind_columns TO apps;
GRANT ALL ON xwrl_response_entity_columns TO apps;
GRANT ALL ON xwrl_response_rows TO apps;
GRANT ALL ON xwrl_requests_seq TO apps;
GRANT ALL ON xwrl_requests1_seq TO apps;
GRANT ALL ON xwrl_requests2_seq TO apps;
GRANT ALL ON xwrl_requests3_seq TO apps;
GRANT ALL ON xwrl_requests4_seq TO apps;
GRANT ALL ON xwrl_requests5_seq TO apps;
GRANT ALL ON xwrl_requests6_seq TO apps;
GRANT ALL ON xwrl_note_templates TO apps;
GRANT ALL ON xwrl_note_templates_seq TO apps;
GRANT ALL ON  xwrl_batch_seq to apps;
GRANT ALL ON  XWRL_CASE_NOTES_LINE_SEQ   to apps;
GRANT ALL ON  XWRL_ALERT_NOTES_LINE_SEQ to apps;
GRANT ALL ON  XWRL_AUDIT_LOG_seq to apps;
GRANT ALL ON  XWRL_AUDIT_LOG to apps;



GRANT ALL ON xwrl_alert_clearing_xref TO appsro;
GRANT ALL ON xwrl_alert_clearing_xref_seq TO appsro;
GRANT ALL ON xwrl_alert_tbl_in_type TO appsro;
GRANT ALL ON xwrl_alert_tbl_out_type TO appsro;
GRANT ALL ON xwrl_alert_documents TO appsro;
GRANT ALL ON xwrl_alert_documents_seq TO appsro;
GRANT ALL ON xwrl_alert_in_rec TO appsro;
GRANT ALL ON xwrl_alert_notes TO appsro;
GRANT ALL ON xwrl_alert_out_rec TO appsro;
GRANT ALL ON xwrl_case_documents TO appsro;
GRANT ALL ON xwrl_case_documents_seq TO appsro;
GRANT ALL ON xwrl_case_notes TO appsro;
GRANT ALL ON xwrl_doc_reference_seq TO appsro;
GRANT ALL ON xwrl_document_reference TO appsro;
GRANT ALL ON xwrl_keywords TO appsro;
GRANT ALL ON xwrl_location_types TO appsro;
GRANT ALL ON xwrl_party_alias TO appsro;
GRANT ALL ON xwrl_party_master TO appsro;
GRANT ALL ON xwrl_party_xref TO appsro;
GRANT ALL ON xwrl_parameters TO appsro;
GRANT ALL ON xwrl_requests TO appsro;
GRANT ALL ON xwrl_request_ind_columns TO appsro;
GRANT ALL ON xwrl_request_entity_columns TO appsro;
GRANT ALL ON xwrl_request_rows TO appsro;
GRANT ALL ON xwrl_response_ind_columns TO appsro;
GRANT ALL ON xwrl_response_entity_columns TO appsro;
GRANT ALL ON xwrl_response_rows TO appsro;
GRANT ALL ON xwrl_requests_seq TO appsro;
GRANT ALL ON xwrl_requests1_seq TO appsro;
GRANT ALL ON xwrl_requests2_seq TO appsro;
GRANT ALL ON xwrl_requests3_seq TO appsro;
GRANT ALL ON xwrl_requests4_seq TO appsro;
GRANT ALL ON xwrl_requests5_seq TO appsro;
GRANT ALL ON xwrl_requests6_seq TO appsro;
GRANT ALL ON xwrl_note_templates TO appsro;
GRANT ALL ON xwrl_note_templates_seq TO appsro;
GRANT ALL ON  xwrl_batch_seq to appsro;
GRANT ALL ON  XWRL_CASE_NOTES_LINE_SEQ   to appsro;
GRANT ALL ON  XWRL_ALERT_NOTES_LINE_SEQ to appsro;
GRANT ALL ON  XWRL_AUDIT_LOG_seq to appsro;
GRANT ALL ON  XWRL_AUDIT_LOG to appsro;