
  CREATE OR REPLACE EDITIONABLE PACKAGE "APPS"."RMI_OWS_COMMON_UTIL" 
AS
/*******************************************************************************************************************************************
* Legend : Type                                                                                                                            *
* I --> Initial                                                                                                                            *
* E --> Enhancement                                                                                                                        *
* R --> Requirement                                                                                                                        *
* B --> Bug                                                                                                                                *
********************************************************************************************************************************************/
/*$Header: rmi_ows_common_util.pkb 1.1 2019/11/15 12:00:00ET   IRI Exp                                            $                        */
/*******************************************************************************************************************************************
* Object Type         : Package Body                                                                                                       *
* Name                : rmi_ows_common_util                                                                                                *
* Script Name         : rmi_ows_common_util.pkb                                                                                            *
* Purpose             :                                                                                                                    *
*                                                                                                                                          *
* Company             : International Registries, Inc.                                                                                     *
* Module              : Trade Compliance                                                                                                   *
* Created By          : SAGARWAL                                                                                                           *
* Created Date        : 11-NOV-2019                                                                                                        *
* Last Reviewed By    :                                                                                                                    *
* Last Reviewed Date  :                                                                                                                    *
********************************************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification -------          >             *
* Date        By               Script               By            Date         Type  Details                                               *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ------------------------------                       *
* 15-NOV-2019 IRI              1.1                TSUAZO          15-NOV-2019  I      Trade Compliance                                     *
* 15-NOV-2019 IRI              1.2                GVELLA          15-NOV-2019  R     Modified approve_screening_request                    *
*                                                                                   to autoclose case if autoapproved                      *
* 17-NOV-2019 IRI              1.3                GVELLA          17-NOV-2019  R    Added function is_authorized_to_approve                *
*                                                                                   to check if user is autonrized to approve              *
* 18-NOV-2019 IRI              1.4                GVELLA          18-NOV-2019  R    Added procedure so sync primary and alias              *
* 19-NOV-2019 IRI              1.5                SAGARWAL        19-NOV-2019  R    New Changes                                            *
* 19-NOV-2019 IRI              1.6                GVELLA          19-NOV-2019  R    New procedure to set expiration date                   *
* 19-NOV-2019 IRI              1.7                TSUAZO          19-NOV-2019  R    Date of Birth can be null                              *
* 19-NOV-2019 IRI              1.8                SAGARWAL          19-NOV-2019  R  Added ROLLBACK in exception section in Close_OWS_ALERT *
* 19-NOV-2019 IRI              1.9                TSUAZO          19-NOV-2019  R   Comment out send_notice_from_trigger: Reset for GO LIVE *
* 19-NOV-2019 IRI              1.10                TSUAZO          19-NOV-2019  R   Comment out send_notice_to_legal: Reset for GO LIVE    *
* 25-NOV-2019 IRI              1.11               GVELLA          25-NOV-2019  R   Modifid the sync_alias_matches                          *
* 25-NOV-2019 IRI              1.12               GVELLA          25-NOV-2019  R  Bug fixes in sync_alias_matches                          *
* 26-NOV-2019 IRI              1.13               SAGARWAL        26-NOV-2019  E  New functions to get Departmetn, Office and Doc Types    *
* 26-NOV-2019 IRI              1.14               SAGARWAL        27-NOV-2019  P  Bug Fixes in Query Cross References                      *
* 03-DEC-2019 IRI              1.15               GVELLA         03-DEC-2019  P  Added Procedure to Sync Alias Documents                   *
* 04-DEC-2019 IRI              1.16               SAGARWAL       04-DEC-2019  E  Added Procedure to get Cross Rerference Desc              *
********************************************************************************************************************************************/

   g_ows_cutoff_date   DATE := '25-OCT-2019';

   TYPE wc_external_xref_rec IS RECORD (
      source_table                  vssl.worldcheck_external_xref.source_table%TYPE,
      source_table_column           vssl.worldcheck_external_xref.source_table_column%TYPE,
      source_table_id               vssl.worldcheck_external_xref.source_table_id%TYPE,
      source_table_status_column    vssl.worldcheck_external_xref.source_table_status_column%TYPE,
      worldcheck_external_xref_id   vssl.worldcheck_external_xref.worldcheck_external_xref_id%TYPE,
      wc_screening_request_id       vssl.worldcheck_external_xref.wc_screening_request_id%TYPE,
      created_by                    vssl.worldcheck_external_xref.created_by%TYPE,
      creation_date                 vssl.worldcheck_external_xref.creation_date%TYPE,
      last_updated_by               vssl.worldcheck_external_xref.last_updated_by%TYPE,
      last_update_date              vssl.worldcheck_external_xref.last_update_date%TYPE,
      last_update_login             vssl.worldcheck_external_xref.last_update_login%TYPE
   );

   TYPE ows_request_rec IS RECORD (
      entity_type                     VARCHAR2 (100),
      source_table                    VARCHAR2 (100),
      source_id                       VARCHAR2 (100),
      source_table_column             VARCHAR2 (100),
      ID                              NUMBER,
      status                          VARCHAR2 (100),
      full_name                       VARCHAR2 (100),
      first_name                      VARCHAR2 (100),
      last_name                       VARCHAR2 (100),
      title                           VARCHAR2 (100),
      entity_name                     VARCHAR2 (100),
      date_of_birth                   DATE,
      gender                          VARCHAR2 (100),
      passport_number                 VARCHAR2 (100),
      registrationnumber              VARCHAR2 (100),
      city                            VARCHAR2 (100),
      nationality                     VARCHAR2 (100),
      passport_issuing_country_code   VARCHAR2 (100),
      residence_country_code          VARCHAR2 (100),
      vessel_indicator                VARCHAR2 (10),
      created_by                      NUMBER,
      creation_date                   DATE,
      last_updated_by                 NUMBER,
      last_updated_date               DATE,
      last_update_login               NUMBER,
      name_screened                   VARCHAR2 (200),
      batch_id                        NUMBER,
      city_id                         NUMBER
   );

   TYPE xwrl_xref_rec IS RECORD (
      master_id                       NUMBER,
      relationship_type               VARCHAR (50),
      entity_type                     VARCHAR (100),
      state                           VARCHAR (100),
      status                          VARCHAR (100),
      source_table                    VARCHAR (50),
      source_table_column             VARCHAR (50),
      source_id                       NUMBER,
      full_name                       VARCHAR (300),
      batch_id                        NUMBER,
      start_date                      DATE,
      end_date                        DATE,
      creation_date                   DATE,
      created_by                      NUMBER,
      last_update_date                DATE,
      last_updated_by                 NUMBER,
      last_update_login               NUMBER,
      date_of_birth                   DATE,
      family_name                     VARCHAR (100),
      given_name                      VARCHAR (100),
      sex                             VARCHAR2 (10),
      passport_number                 VARCHAR2 (30),
      citizenship_country_code        VARCHAR2 (30),
      passport_issuing_country_code   VARCHAR2 (30),
      country_of_residence            VARCHAR2 (30),
      city_of_residence_id            NUMBER,
      imo_number                      VARCHAR2 (50),
      tc_excluded                     VARCHAR2 (1)
   
--      XREF_SOURCE_TABLE VARCHAR2 (50),
--      XREF_SOURCE_TABLE_COLUMN VARCHAR2 (50),
--      XREF_SOURCE_ID VARCHAR2 (50)
   );

   TYPE screening_tab IS TABLE OF xwrl_xref_rec
      INDEX BY BINARY_INTEGER;

   TYPE alert_in_rec IS RECORD (
      alert_id   VARCHAR2 (100),
      to_state   VARCHAR2 (100),
      COMMENT    VARCHAR2 (1000)
   );

   TYPE l_alert_tbl_in_type IS TABLE OF alert_in_rec
      INDEX BY BINARY_INTEGER;

   FUNCTION get_instance_name
      RETURN VARCHAR2;

   FUNCTION get_entity_type (p_id IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_ows_url (p_source_table IN VARCHAR2, p_source_id IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_url
      RETURN VARCHAR2;

   FUNCTION get_sb_url
      RETURN VARCHAR2;

   FUNCTION get_ows_req_url (p_id IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_city_list_id (p_city IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_city_name (p_wc_city_list_id IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_case (
      p_source_table   IN   VARCHAR2,
      p_source_id      IN   NUMBER,
      p_status         IN   VARCHAR2
   )
      RETURN xwrl_requests%ROWTYPE;

   FUNCTION get_wf_case (
      p_source_table   IN   VARCHAR2,
      p_source_id      IN   NUMBER,
      p_wf_status      IN   VARCHAR2
   )
      RETURN xwrl_requests%ROWTYPE;

   FUNCTION get_open_case (p_source_table IN VARCHAR2, p_source_id IN NUMBER)
      RETURN xwrl_requests%ROWTYPE;

   FUNCTION get_open_request (
      p_source_table   IN   VARCHAR2,
      p_source_id      IN   NUMBER,
      p_name           IN   VARCHAR2,
      p_type           IN   VARCHAR2
   )
      RETURN xwrl_requests%ROWTYPE;

   FUNCTION is_ows_user
      RETURN VARCHAR2;

   FUNCTION get_case_details (p_id IN NUMBER)
      RETURN xwrl_requests%ROWTYPE;

   FUNCTION case_wf_status_dsp (p_status IN xwrl_parameters.value_string%TYPE)
      RETURN VARCHAR2;

   FUNCTION case_wf_status (p_status IN xwrl_parameters.KEY%TYPE)
      RETURN VARCHAR2;

   FUNCTION format_date (p_date IN DATE)
      RETURN VARCHAR2;

   FUNCTION get_country_iso_code (p_country_code IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_country_name (p_country_code IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_country_code (p_country_code IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_seafarer_ows_id (p_seafarer_id IN NUMBER)
      RETURN NUMBER;

   PROCEDURE create_tc_document_references (
      p_ows_id        IN       NUMBER,
      p_esi_id        IN       NUMBER,
      p_return_code   IN OUT   VARCHAR2,
      p_error_msg     IN OUT   VARCHAR2
   );

   FUNCTION is_request_sanctioned (p_id IN NUMBER)
      RETURN VARCHAR2;

   PROCEDURE get_seafarer_ows_id (p_seafarer_id IN NUMBER);

   PROCEDURE get_contact_ows_id (p_contact_id IN NUMBER);

   PROCEDURE get_customer_ows_id (p_customer_id IN NUMBER);

   PROCEDURE get_extseafarer_ows_id (p_esi_id IN NUMBER);

   PROCEDURE get_agent_ows_id (p_customer_id IN NUMBER);

   PROCEDURE get_corp_ows_id (p_corp_id IN NUMBER);

   PROCEDURE get_vetting_ows_id (p_reg11_header_id IN NUMBER);

   PROCEDURE get_vessel_ows_id (p_vessel_pk_id IN NUMBER);

   PROCEDURE get_vessel_contact_ows_id (
      p_contact_id   IN   NUMBER,
      p_vessel_id    IN   NUMBER
   );

   PROCEDURE get_nrmi_ows_id (p_nrmi_cert_id IN NUMBER);

   PROCEDURE get_insp_ows_id (p_insp_id IN NUMBER);

   PROCEDURE get_insp_contact_ows_id (p_inspector_contact_id IN NUMBER);

   FUNCTION name_in_blocklist (p_id IN NUMBER, x_message OUT VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_name (p_id IN NUMBER)
      RETURN VARCHAR2;

   PROCEDURE send_notice_to_legal (
      p_name_screened   IN   VARCHAR2,
      x_message         IN   VARCHAR2
   );

   PROCEDURE send_notice_from_trigger (
      p_id               IN       NUMBER,
      p_created_by       IN       NUMBER,
      p_name_screened    IN       VARCHAR2,
      p_status           IN       VARCHAR2,
--   p_notes                  IN       VARCHAR2,
      p_source_table     IN       VARCHAR2,
      p_source_id        IN       NUMBER,
      p_return_code      OUT      NUMBER,
      p_return_message   OUT      VARCHAR2
   );

   PROCEDURE create_new_xref (
      xref             IN OUT   rmi_ows_common_util.wc_external_xref_rec,
      return_code      OUT      NUMBER,
      return_message   OUT      VARCHAR2
   );

   PROCEDURE create_ows_generic (
      p_req           IN OUT   rmi_ows_common_util.ows_request_rec,
      p_custom_id1    IN       VARCHAR2,
      p_custom_id2    IN       VARCHAR2,
      p_return_code   OUT      VARCHAR2,
      p_ret_msg       OUT      VARCHAR2,
      x_id            OUT      NUMBER
   );

   PROCEDURE update_request_status (
      p_id               IN       NUMBER,
      p_status_code      IN       VARCHAR2,
      p_return_code      OUT      NUMBER,
      p_return_message   OUT      VARCHAR2
   );

   FUNCTION does_wc_exist (
      p_xref   IN   rmi_ows_common_util.wc_external_xref_rec,
      p_req    IN   rmi_ows_common_util.ows_request_rec
   )
      RETURN BOOLEAN;

   PROCEDURE query_cross_reference (
      p_source_table    IN       VARCHAR2,
      p_source_column   IN       VARCHAR2,
      p_source_id       IN       NUMBER,
      t_data            IN OUT   screening_tab
   );

   FUNCTION get_id_request_values (p_id IN NUMBER, p_attr_name IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_country_name_iso (p_country_code IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION is_city_crimean (p_city_list_id IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_sanction_status (p_iso_country IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION wc_locked (p_id IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION is_blocklisted (p_name IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_batch_id (p_source_table IN VARCHAR2, p_source_id IN NUMBER)
      RETURN NUMBER;

   PROCEDURE create_batch_vetting (
      p_source_table          IN       VARCHAR2,
      p_source_table_column   IN       VARCHAR2,
      p_source_id             IN       NUMBER,
      x_batch_id              OUT      NUMBER,
      x_return_status         OUT      VARCHAR2,
      x_return_msg            OUT      VARCHAR2
   );

   PROCEDURE update_master (t_data IN OUT rmi_ows_common_util.screening_tab);

   PROCEDURE close_ows_case (
      p_user_name    IN   VARCHAR2,
      p_case_id      IN   VARCHAR2,
      p_request_id   IN   VARCHAR2
   );

   PROCEDURE close_ows_alert (
      p_user_id      IN   NUMBER,
      p_request_id   IN   VARCHAR2,
      p_row_number   IN   VARCHAR2
   );

   PROCEDURE insert_party_master (
      p_source_table          IN       VARCHAR2,
      p_source_table_column   IN       VARCHAR2,
      p_source_id             IN       NUMBER,
      x_id                    IN OUT   NUMBER
   );

   PROCEDURE insert_cross_references (
      p_source_table          IN   VARCHAR2,
      p_source_table_column   IN   VARCHAR2,
      p_source_id             IN   NUMBER,
      p_id                    IN   NUMBER
   );

   FUNCTION get_wc_status (
      p_source_table          IN   VARCHAR2,
      p_source_table_column   IN   VARCHAR2,
      p_source_id             IN   NUMBER,
      p_name_screened         IN   VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION get_wc_status_date (
      p_source_table          IN   VARCHAR2,
      p_source_table_column   IN   VARCHAR2,
      p_source_id             IN   NUMBER,
      p_name_screened         IN   VARCHAR2
   )
      RETURN DATE;

   FUNCTION master_exists (
      p_source_table          IN   VARCHAR2,
      p_source_table_column   IN   VARCHAR2,
      p_source_id             IN   NUMBER
   )
      RETURN VARCHAR2;

   PROCEDURE update_case_workflow (p_request_id IN NUMBER);

   FUNCTION is_authorized_to_approve (p_user_id IN NUMBER)
      RETURN VARCHAR2;

   PROCEDURE sync_matches (
      p_request_id     IN   INTEGER,
      p_alert_in_tbl   IN   xwrl_alert_tbl_in_type,
      p_user           IN   VARCHAR2
   );
   
   PROCEDURE sync_alias_documents (
      p_request_id IN INTEGER,
      p_batch_id   IN INTEGER     
   );

   FUNCTION remove_special_char (p_string IN VARCHAR2)
      RETURN VARCHAR2;

   PROCEDURE set_expiration_date (
      p_request_id        IN   NUMBER,
      p_case_state        IN   VARCHAR2,
      p_workflow_status   IN   VARCHAR2
   );

   FUNCTION get_department (
      p_request_id     IN   NUMBER DEFAULT NULL,
      p_return_type    IN   VARCHAR2 DEFAULT NULL,
      p_source_table   IN   VARCHAR2 DEFAULT NULL,
      p_source_id      IN   NUMBER DEFAULT NULL      
   )
      RETURN VARCHAR2;

   FUNCTION get_office (p_request_id IN NUMBER,p_return_type    IN   VARCHAR2 DEFAULT NULL)
      RETURN VARCHAR2;
      
   FUNCTION get_doc_type (
      p_request_id     IN   NUMBER DEFAULT NULL,
      p_source_table   IN   VARCHAR2 DEFAULT NULL,
      p_source_id      IN   NUMBER DEFAULT NULL
   )
      RETURN VARCHAR2;
      
   FUNCTION get_custom_tag_info (
      p_source_table   IN   VARCHAR2,
      p_source_id      IN   NUMBER
   )
      RETURN VARCHAR2;
--
END; 
/
