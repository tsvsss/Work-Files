create or replace PACKAGE BODY "RMI_OWS_COMMON_UTIL"
AS
   /*$Header: rmi_ows_common_util.pkb 1.1 2019/11/15 12:00:00ET IRI Exp $ */
   /*******************************************************************************************************************************************
   * Object Type : Package Body *
   * Name : APPS.rmi_ows_common_util *
   * Script Name : rmi_ows_common_util.pkb *
   * Purpose : *
   * *
   * Company : International Registries, Inc. *
   * Module : Trade Compliance *
   * Created By : SAGARWAL *
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
   * 11-DEC-2019 IRI              1.17               SAGARWAL       11-DEC-2019  B  Used CLEANSE_NAME in GET_WC_STATUS, get_wc_status_date    *
   * 11-DEC-2019 IRI              1.18               SAGARWAL       11-DEC-2019  B  Used Changed SEND_NOTICE_FROM_TRIGGER to send mail to user*
   * 11-DEC-2019 IRI              1.19               TSUAZO         12-DEC-2019  B  Fix auto_approve for city                                 *
   * 12-DEC-2019 IRI              1.20               SAGARWAL       12-DEC-2019  B  Fix GET_WC_STATUS for leading space                       *
   * 12-DEC-2019 IRI              1.21               SAGARWAL       12-DEC-2019  B  Fix Removed Custom1 Custom2                               *
   * 13-DEC-2019 IRI              1.22               SAGARWAL       13-DEC-2019  B  New logic for TC Status implemented                       *
   * 13-DEC-2019 IRI              1.22               SAGARWAL       13-DEC-2019  B  New logic for TC Status implemented                       *
   * 16-DEC-2019 IRI              1.23               SAGARWAL       16-DEC-2019  B  Fix for General TC                                        *
   * 16-DEC-2019 IRI              1.24               SAGARWAL       16-DEC-2019  B  User Current User Name for Auto Approval                  *
   * 18-DEC-2019 IRI              1.25               SAGARWAL       18-DEC-2019  B  Show Only Active Countries                                *
   * 19-DEC-2019 IRI              1.26               SAGARWAL       19-DEC-2019  B  SEt Expiration Date for Provisional                       *
   * 19-DEC-2019 IRI              1.27               SGOEL          19-DEC-2019  B  Email notification with case notes                        *
   * 20-DEC-2019 IRI              1.28               SGOEL          20-DEC-2019  B  Email notification to Internal Users only T20191220.0028  *
   * 23-DEC-2019 IRI              1.29               SGOEL          23-DEC-2019  B  Add space in subject line T20191221.0019                  *
   * 26-DEC-2019 IRI              1.30               SAGARWAL       26-DEC-2019  B  Bug Fixes in get_batch_id for NRMI                        *
   * 26-DEC-2019 IRI              1.31               SAGARWAL       26-DEC-2019  B  Added code to sync documents and notes on alias           *
   * 03-JAN-2020 IRI              1.32               SAGARWAL       03-JAN-2020  B  Set Alert to Require Legal Review for restricted Category *
   * 09-JAN-2020 IRI              1.33               SAGARWAL       09-JAN-2020  B  Changes for Crimean Countries                             *
   * 16-JAN-2020 IRI              1.34               SAGARWAL       16-JAN-2020  E  Added code to check OWS Alert State before updating       *
   * 16-JAN-2020 IRI              1.35               TSUAZO         16-JAN-2020  B  Update sync_matches for Individual to move code to match Entity
   * 16-JAN-2020 IRI              1.36               SAGARWAL       16-JAN-2020  E  Added code to check OWS Alert State before updating       *
   * 28-JAN-2020 IRI              1.37               SAGARWAL       28-JAN-2020  E  Modified code to get full customer name from HZ_PARTIES   *
   * 29-JAN-2020 IRI              1.38               SAGARWAL       29-JAN-2020  B  Removed Leading Space fromm Full Name                     *
   * 10-FEB-2020 IRI              1.39               SAGARWAL       10-FEB-2020  E  Added get_last_batch_id Function                          *
   * 20-FEB-2020 IRI              1.40               ABHISHEK       20-FEB-2020  B  Added is_entity_crimean Function                          *
   * 09-MAR-2020 IRI              1.41               SAGARWAL       09-MAR-2020  B  Fixed issue in Case Notes/Documents Trasfer for Alias     *
   * 12-MAR-2020 IRI              1.42               SGOEL          12-MAR-2020  B  Added delete_request Procedure                            *
   * 12-MAR-2020 IRI              1.43               SGOEL          12-MAR-2020  B  Added case_wf_state Function                              *
   * 20-MAR-2020 IRI              1.44               SAGARWAL       20-MAR-2020  B  Duplicate Case Document Issue Fix                         *
   * 20-MAR-2020 IRI              1.44               SAGARWAL       20-MAR-2020  B  Duplicate Case Document Issue Fix                         *
   * 23-MAR-2020 IRI              1.45               SGOEL          23-MAR-2020  E  T20200211.0009 SEND_NOTICE_FROM_TRIGGER updated subject line*
   * 06-APR-2020 IRI              1.46               SAGARWAL       06-APR-2020  E  Approval Expiration Date for Dubai Office                 *
   * 16-APR-2020 IRI              1.47               BGUGGILAM      15-APR-2020  E  Added get_corp_number to display CorpNumber on OWS Statusboard
   * 30-APR-2020 IRI              1.48               SAGARWAL       30-APR-2020  E  Added delete_batch Function                               *
   * 30-APR-2020 IRI              1.49               SAGARWAL       30-APR-2020  E  Removed select * from XWRL_REQUESTS                       *
   * 01-MAY-2020 IRI              1.50               SAGARWAL       01-MAY-2020  E  Do not Auto Approve Error Requests                        *
   * 04-MAY-2020 IRI              1.51               SAGARWAL       04-MAY-2020  E  Alerts Mismatch Fix                                       *
   * 05-MAY-2020 IRI              1.52               SAGARWAL       05-MAY-2020  E  Passport and Country Blank to OWS                         *
   * 08-MAY-2020 IRI              1.53               SAGARWAL       08-MAY-2020  E  For Seafarers pass Nationality to Residence Country       *
   * 14-MAY-2020 IRI              1.54               SAGARWAL       14-MAY-2020  E  Added debug in Sync Matches and Close Alerts              *
   * 15-MAY-2020 IRI              1.55               TSUAZO         15-MAY-2020  B  Fix where clause for alert mismatch                       *
   * 22-MAY-2020 IRI              1.56               SAGARWAL       22-MAY-2020  E  Added User Id to Delete Batch                             *
   * 22-MAY-2020 IRI              1.57               SAGARWAL       22-MAY-2020  E  Seafarer TC Status Changes                                *
   * 26-MAY-2020 IRI              1.58               SAGARWAL       26-MAY-2020  E  Added Procedure get_master_id 
   * 29-JUN-2020 IRI              1.59               VTONDAPU       09-JUN-2020  E  Added  procedure insert_esr_user_master, insert_esr_user_cross_ref create_esr_corp_batch_vetting, query_esr_corp_cross_reference insert_esr_corp_party_master, insert_esr_corp_cross_ref. Modified get_department to display ESR User information 
   * 30-JUN-2020 IRI              1.60               SAGARWAL       30-JUN-2020  E  Fixes in CREATE_BATCH_VETTING                             *										
   * 02-JUL-2020 IRI              1.61               SAGARWAL       02-JUL-2020  E  Fixes in APPROVE_SCREENING_REQUEST                        *
   * 07-JUL-2020 IRI              1.62               TSUAZO         07-JUL-2020 B  Fix where clause for alert mismatch                        *   
   * 20-JUL-2020 IRI              1.63               TSUAZO         20-JUL-2020 B  Fix where clause for alert mismatch                        *   
   * 21-JUL-2020 IRI              1.64               SAGARWAL       21-JUL-2020 B  Fixes for Case Notes and Documents and other design changes*   
   * 22-JUL-2020 IRI              1.65               SAGARWAL       22-JUL-2020 B  Bug Fixes                                                  *
   * 22-JUL-2020 IRI              1.66               SAGARWAL       22-JUL-2020 B  Added User Validation in Create Batch Vetting              *
   * 23-JUL-2020 IRI              1.67               SAGARWAL       23-JUL-2020 B  Fixes in Get Office for External Users                     *
   * 26-JUL-2020 IRI              1.68               TSUAZO         26-JUL-2020 B  Fix alert notes                    *
   * 27-JUL-2020 IRI              1.69               SAGARWAL       27-JUL-2020 B  Fix create_ows_generic for Org                     *
   * 29-JUL-2020 IRI              1.70               SAGARWAL       29-JUL-2020 B  Fixes in CREATE_BATCH_VETTING                      *
*******************************************************************************************************************************************************/
   FUNCTION get_instance_name
      RETURN VARCHAR2
   IS
      l_name   VARCHAR2 (100);
   BEGIN
      SELECT SYS_CONTEXT ('USERENV', 'DB_NAME')
        INTO l_name
        FROM DUAL;

      RETURN l_name;
   END;

   FUNCTION get_entity_type (p_id IN NUMBER)
      RETURN VARCHAR2
   IS
      l_type   VARCHAR2 (30);
   BEGIN
      SELECT DECODE (vessel_indicator,
                     'Y', 'VESSEL',
                     DECODE (PATH,
                             'INDIVIDUAL', 'INDIVIDUAL',
                             'ENTITY', 'ORGANIZATION'
                            )
                    )
        INTO l_type
        FROM xwrl_requests
       WHERE ID = p_id;

      RETURN l_type;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END get_entity_type;

   FUNCTION get_ows_url (p_source_table IN VARCHAR2, p_source_id IN NUMBER)
      RETURN VARCHAR2
   IS
      l_url   VARCHAR2 (1000);
      l_id    NUMBER;
   BEGIN
      SELECT value_string
        INTO l_url
        FROM xwrl_parameters
       WHERE ID = 'TRADE_URL' AND KEY = get_instance_name;

      SELECT MAX (ID)
        INTO l_id
        FROM xwrl_requests
       WHERE source_table = p_source_table
         AND source_id = p_source_id
         AND status = 'COMPLETE';

      IF l_id IS NOT NULL
      THEN
         RETURN l_url || '?requestId=' || l_id;
      ELSE
         RETURN l_url;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN l_url;
   END get_ows_url;

   FUNCTION get_url
      RETURN VARCHAR2
   IS
      l_url   VARCHAR2 (1000);
   BEGIN
      SELECT value_string
        INTO l_url
        FROM xwrl_parameters
       WHERE ID = 'TRADE_URL' AND KEY = get_instance_name;

      RETURN l_url;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN l_url;
   END get_url;

   FUNCTION get_sb_url
      RETURN VARCHAR2
   IS
      l_url   VARCHAR2 (1000)
         := 'http://iriadf-dev.register-iri.com/TradeCompliance/faces/Statusboard';
   BEGIN
      SELECT value_string
        INTO l_url
        FROM xwrl_parameters
       WHERE ID = 'STATUSBOARD_URL' AND KEY = get_instance_name;

      RETURN l_url;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN l_url;
   END get_sb_url;

   FUNCTION get_ows_req_url (p_id IN NUMBER)
      RETURN VARCHAR2
   IS
      l_url   VARCHAR2 (1000);
   BEGIN
      SELECT value_string
        INTO l_url
        FROM xwrl_parameters
       WHERE ID = 'TRADE_URL' AND KEY = get_instance_name;

      IF p_id IS NOT NULL
      THEN
         RETURN l_url || '?requestId=' || p_id;
      ELSE
         RETURN l_url;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN l_url;
   END get_ows_req_url;

   FUNCTION get_city_list_id (p_city IN VARCHAR2)
      RETURN VARCHAR2
   IS
      l_city_id   NUMBER;
   BEGIN
      SELECT wc_city_list_id
        INTO l_city_id
        FROM wc_city_list
       WHERE city_name = p_city;

      RETURN l_city_id;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END get_city_list_id;

   FUNCTION get_city_name (p_wc_city_list_id IN NUMBER)
      RETURN VARCHAR2
   IS
      l_city_name   VARCHAR2 (100);
   BEGIN
      SELECT city_name
        INTO l_city_name
        FROM wc_city_list
       WHERE wc_city_list_id = p_wc_city_list_id;

      RETURN l_city_name;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END get_city_name;

   --   FUNCTION get_open_case (p_source_table IN VARCHAR2, p_source_id IN NUMBER)
--   RETURN xwrl_requests%ROWTYPE
--IS
--
--   CURSOR get_req_ows
--   IS
--      SELECT   req.*
--          FROM xwrl_requests req
--         WHERE req.source_table = p_source_table
--           AND req.source_id = p_source_id
--           AND case_status != 'C'
--      ORDER BY last_update_date DESC;

--   l_req_ows   xwrl_requests%ROWTYPE;
--BEGIN
--   OPEN get_req_ows;

--   FETCH get_req_ows
--    INTO l_req_ows;

--   CLOSE get_req_ows;

--   RETURN l_req_ows;
--END get_open_case;

FUNCTION get_open_case_id (p_source_table IN VARCHAR2, p_source_id IN NUMBER)
   RETURN NUMBER
IS

   CURSOR get_req_ows
   IS
      SELECT   --req.* SAURABH Remove *
               ID
          FROM xwrl_requests req
         WHERE req.source_table = p_source_table
           AND req.source_id = p_source_id
           AND case_status != 'C'
      ORDER BY last_update_date DESC;

   l_req_id   NUMBER;
BEGIN
   OPEN get_req_ows;

   FETCH get_req_ows
    INTO l_req_id;

   CLOSE get_req_ows;

   RETURN l_req_id;

END get_open_case_id;


   --   FUNCTION get_open_request (
--      p_source_table   IN   VARCHAR2,
--      p_source_id      IN   NUMBER,
--      p_name           IN   VARCHAR2,
--      p_type           IN   VARCHAR2
--   )
--      RETURN xwrl_requests%ROWTYPE
--   IS
--
--      l_xmltype XMLTYPE;
--
--      CURSOR get_req_ows
--      IS
--         SELECT   --req.* SAURABH Remove *
--               ID, resubmit_id, source_table, source_id, vessel_pk,
--               vessel_uk, wc_screening_request_id, master_id, alias_id,
--               xref_id, batch_id, version_id, parent_id, case_id, server,
--               PATH, NULL SOAP_QUERY, l_xmltype REQUEST, l_xmltype RESPONSE, NULL JOB_ID,
--               matches, status, name_screened, date_of_birth,
--               imo_number, department, department_ext, office, priority,
--               risk_level, document_type, closed_date, assigned_to,
--               vessel_indicator, category_restriction_indicator,
--               country_of_address, country_of_residence,
--               country_of_nationality, country_of_birth,
--               country_of_registration, country_of_operation,
--               city_of_residence, city_of_residence_id,
--               subdivision_city_of_residence, case_status, case_state,
--               case_workflow, rejection_reason, rejection_reason_othr,
--               ERROR_CODE, error_message, expiration_date,
--               sent_to_legal_date, sent_to_legal_by, last_update_date,
--               last_updated_by, creation_date, created_by, last_update_login,
--               gender, passport_number, edq_url
--             FROM xwrl_requests req
--            WHERE req.source_table = p_source_table
--              AND req.source_id = p_source_id
--              AND case_status != 'C'
--              AND get_name (req.ID) = p_name
--              AND PATH = DECODE (p_type, 'VESSEL', 'ENTITY', PATH)
--              AND NVL (vessel_indicator, 'N') =
--                     DECODE (p_type,
--                             'VESSEL', 'Y',
--                             NVL (vessel_indicator, 'N')
--                            )
--         ORDER BY last_update_date DESC;

--      l_req_ows   xwrl_requests%ROWTYPE;
--   BEGIN
--      OPEN get_req_ows;

--      FETCH get_req_ows
--       INTO l_req_ows;

--      CLOSE get_req_ows;

--      RETURN l_req_ows;
--   END get_open_request;

--   FUNCTION get_case (
--      p_source_table   IN   VARCHAR2,
--      p_source_id      IN   NUMBER,
--      p_status         IN   VARCHAR2
--   )
--      RETURN xwrl_requests%ROWTYPE
--   IS
--
--   l_xmltype XMLTYPE;
--
--      CURSOR get_req_ows
--      IS
--         SELECT   --req.* SAURABH Remove *
--               ID, resubmit_id, source_table, source_id, vessel_pk,
--               vessel_uk, wc_screening_request_id, master_id, alias_id,
--               xref_id, batch_id, version_id, parent_id, case_id, server,
--               PATH, NULL SOAP_QUERY, l_xmltype REQUEST, l_xmltype RESPONSE, NULL JOB_ID,
--               matches, status, name_screened, date_of_birth,
--               imo_number, department, department_ext, office, priority,
--               risk_level, document_type, closed_date, assigned_to,
--               vessel_indicator, category_restriction_indicator,
--               country_of_address, country_of_residence,
--               country_of_nationality, country_of_birth,
--               country_of_registration, country_of_operation,
--               city_of_residence, city_of_residence_id,
--               subdivision_city_of_residence, case_status, case_state,
--               case_workflow, rejection_reason, rejection_reason_othr,
--               ERROR_CODE, error_message, expiration_date,
--               sent_to_legal_date, sent_to_legal_by, last_update_date,
--               last_updated_by, creation_date, created_by, last_update_login,
--               gender, passport_number, edq_url
--             FROM xwrl_requests req
--            WHERE req.source_table = p_source_table
--              AND req.source_id = p_source_id
--              AND case_status = NVL (p_status, case_status)
--         ORDER BY ID DESC;

--      l_req_ows   xwrl_requests%ROWTYPE;
--   BEGIN
--      OPEN get_req_ows;

--      FETCH get_req_ows
--       INTO l_req_ows;

--      CLOSE get_req_ows;

--      RETURN l_req_ows;
--   END get_case;

   FUNCTION get_case_id (
      p_source_table   IN   VARCHAR2,
      p_source_id      IN   NUMBER,
      p_status         IN   VARCHAR2
   )
      RETURN NUMBER
   IS


      CURSOR get_req_ows
      IS
         SELECT
               ID
             FROM xwrl_requests req
            WHERE req.source_table = p_source_table
              AND req.source_id = p_source_id
              AND case_status = NVL (p_status, case_status)
         ORDER BY ID DESC;

      l_req_id   NUMBER;
   BEGIN
      OPEN get_req_ows;

      FETCH get_req_ows
       INTO l_req_id;

      CLOSE get_req_ows;

      RETURN l_req_id;
   END get_case_id;

--   FUNCTION get_case_details (p_id IN NUMBER)
--      RETURN xwrl_requests%ROWTYPE
--   IS
--
--   l_xmltype XMLTYPE;
--
--      CURSOR get_req_ows
--      IS
--         SELECT --req.* SAURABH Remove *
--               ID, resubmit_id, source_table, source_id, vessel_pk,
--               vessel_uk, wc_screening_request_id, master_id, alias_id,
--               xref_id, batch_id, version_id, parent_id, case_id, server,
--               PATH, NULL SOAP_QUERY, l_xmltype REQUEST, l_xmltype RESPONSE, NULL JOB_ID,
--               matches, status, name_screened, date_of_birth,
--               imo_number, department, department_ext, office, priority,
--               risk_level, document_type, closed_date, assigned_to,
--               vessel_indicator, category_restriction_indicator,
--               country_of_address, country_of_residence,
--               country_of_nationality, country_of_birth,
--               country_of_registration, country_of_operation,
--               city_of_residence, city_of_residence_id,
--               subdivision_city_of_residence, case_status, case_state,
--               case_workflow, rejection_reason, rejection_reason_othr,
--               ERROR_CODE, error_message, expiration_date,
--               sent_to_legal_date, sent_to_legal_by, last_update_date,
--               last_updated_by, creation_date, created_by, last_update_login,
--               gender, passport_number, edq_url
--           FROM xwrl_requests req
--          WHERE req.ID = p_id;

--      l_req_ows   xwrl_requests%ROWTYPE;
--   BEGIN
--      OPEN get_req_ows;

--      FETCH get_req_ows
--       INTO l_req_ows;

--      CLOSE get_req_ows;

--      RETURN l_req_ows;
--   END get_case_details;

--   FUNCTION get_wf_case (
--      p_source_table   IN   VARCHAR2,
--      p_source_id      IN   NUMBER,
--      p_wf_status      IN   VARCHAR2
--   )
--      RETURN xwrl_requests%ROWTYPE
--   IS
--
--   l_xmltype XMLTYPE;
--
--      CURSOR get_req_ows
--      IS
--         SELECT   --req.* SAURABH Remove *
--               ID, resubmit_id, source_table, source_id, vessel_pk,
--               vessel_uk, wc_screening_request_id, master_id, alias_id,
--               xref_id, batch_id, version_id, parent_id, case_id, server,
--               PATH, NULL SOAP_QUERY, l_xmltype REQUEST, l_xmltype RESPONSE, NULL JOB_ID,
--               matches, status, name_screened, date_of_birth,
--               imo_number, department, department_ext, office, priority,
--               risk_level, document_type, closed_date, assigned_to,
--               vessel_indicator, category_restriction_indicator,
--               country_of_address, country_of_residence,
--               country_of_nationality, country_of_birth,
--               country_of_registration, country_of_operation,
--               city_of_residence, city_of_residence_id,
--               subdivision_city_of_residence, case_status, case_state,
--               case_workflow, rejection_reason, rejection_reason_othr,
--               ERROR_CODE, error_message, expiration_date,
--               sent_to_legal_date, sent_to_legal_by, last_update_date,
--               last_updated_by, creation_date, created_by, last_update_login,
--               gender, passport_number, edq_url
--             FROM xwrl_requests req
--            WHERE req.source_table = p_source_table
--              AND req.source_id = p_source_id
--              AND case_workflow = p_wf_status
--         ORDER BY last_update_date DESC;

--      l_req_ows   xwrl_requests%ROWTYPE;
--   BEGIN
--      OPEN get_req_ows;

--      FETCH get_req_ows
--       INTO l_req_ows;

--      CLOSE get_req_ows;

--      RETURN l_req_ows;
--   END get_wf_case;


   FUNCTION is_ows_user
      RETURN VARCHAR2
   IS
      l_user_id     NUMBER       := fnd_profile.VALUE ('USER_ID');
      l_user_flag   VARCHAR2 (1) := 'N';
   BEGIN
      --
      RETURN 'Y';
   --      SELECT 'Y'
   --        INTO l_user_flag
   --        FROM fnd_lookup_values_vl flv, fnd_user fu
   --       WHERE 1 = 1
   --         AND fu.user_name = flv.lookup_code
   --         AND flv.lookup_type = 'RMI_OWS_USERS'
   --         AND flv.enabled_flag = 'Y'
   --         AND TRUNC (SYSDATE) BETWEEN TRUNC (NVL (flv.start_date_active,
   --                                                 SYSDATE
   --                                                )
   --                                           )
   --                                 AND TRUNC (NVL (flv.end_date_active, SYSDATE))
   --         AND fu.user_id = l_user_id;

   --      --
   --      RETURN l_user_flag;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 'N';
   END is_ows_user;

   FUNCTION case_wf_status_dsp (p_status IN xwrl_parameters.value_string%TYPE)
      RETURN VARCHAR2
   IS
      l_return_value   xwrl_parameters.KEY%TYPE;
   BEGIN
      SELECT KEY
        INTO l_return_value
        FROM xwrl_parameters
       WHERE ID = 'CASE_WORK_FLOW' AND value_string = p_status;

      RETURN l_return_value;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END case_wf_status_dsp;

   FUNCTION case_wf_status (p_status IN xwrl_parameters.KEY%TYPE)
      RETURN VARCHAR2
   IS
      l_return_value   xwrl_parameters.KEY%TYPE;
   BEGIN
      SELECT value_string
        INTO l_return_value
        FROM xwrl_parameters
       WHERE ID = 'CASE_WORK_FLOW' AND KEY = p_status;

      RETURN l_return_value;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END case_wf_status;

   FUNCTION format_date (p_date IN DATE)
      RETURN VARCHAR2
   IS
   BEGIN
      --      RETURN TO_CHAR (TO_TIMESTAMP_TZ (to_char(p_date,'RRRR-MM-DD'), 'RRRR-MM-DD'),
      --                      'rrrr-mm-dd"T"hh24:mi:ssxFFTZH:TZM'
      --                     );
      RETURN TO_CHAR (p_date, 'YYYYMMDD');
   END format_date;

   FUNCTION get_country_iso_code (p_country_code IN VARCHAR2)
      RETURN VARCHAR2
   IS
      l_iso_code   VARCHAR2 (10);
   BEGIN
      IF LENGTH (p_country_code) = 4
      THEN
         SELECT iso_alpha2_code
           INTO l_iso_code
           FROM sicd_countries
          WHERE 1 = 1 AND country_code = p_country_code AND status = 'Active';
      ELSE
         l_iso_code := p_country_code;
      END IF;

      RETURN l_iso_code;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END get_country_iso_code;

   FUNCTION get_country_iso_name (p_country_name IN VARCHAR2)
      RETURN VARCHAR2
   IS
      l_iso_code   VARCHAR2 (10);
   BEGIN

         SELECT iso_alpha2_code
           INTO l_iso_code
           FROM sicd_countries
          WHERE 1 = 1 AND country_name = p_country_name AND status = 'Active';

      RETURN l_iso_code;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END get_country_iso_name;

   FUNCTION get_country_name_iso (p_country_code IN VARCHAR2)
      RETURN VARCHAR2
   IS
      l_iso_code   VARCHAR2 (100);
   BEGIN
      SELECT country_name
        INTO l_iso_code
        FROM sicd_countries
       WHERE 1 = 1 AND iso_alpha2_code = p_country_code AND status = 'Active';

      RETURN l_iso_code;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END get_country_name_iso;

   FUNCTION get_country_name (p_country_code IN VARCHAR2)
      RETURN VARCHAR2
   IS
      l_iso_code   VARCHAR2 (100);
   BEGIN
      SELECT country_name
        INTO l_iso_code
        FROM sicd_countries
       WHERE 1 = 1 AND country_code = p_country_code AND status = 'Active';

      RETURN l_iso_code;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END get_country_name;

   FUNCTION get_country_code (p_country_code IN VARCHAR2)
      RETURN VARCHAR2
   IS
      l_iso_code   VARCHAR2 (100);
   BEGIN
      SELECT country_code
        INTO l_iso_code
        FROM sicd_countries
       WHERE 1 = 1 AND iso_alpha2_code = p_country_code AND status = 'Active';

      RETURN l_iso_code;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END get_country_code;

   PROCEDURE create_tc_document_references (
      p_ows_id        IN       NUMBER,
      p_esi_id        IN       NUMBER,
      p_return_code   IN OUT   VARCHAR2,
      p_error_msg     IN OUT   VARCHAR2
   )
   IS
      /* this procedure will create references in the trade compliance moduel (WC_REQUEST_DOCUMENTS) for a seafarer from the external system*/
      /* passport, COC, Sea-Time, etc -*/
      CURSOR get_seafarer
      IS
         SELECT *
           FROM exsicd_seafarers_iface a
          WHERE esi_id = p_esi_id;

      seaf_rec            get_seafarer%ROWTYPE;

      CURSOR get_vetting (p_seafarer_id IN NUMBER)
      IS
         SELECT --* SAURABH Remove *
                ID,case_id
           FROM xwrl_requests xref
          WHERE source_table = 'SICD_SEAFARERS'
            AND source_id = p_seafarer_id
            AND ID = p_ows_id;


      CURSOR get_seafarer_docs
      IS
         SELECT sd.*, sg.grade_code, sg.grade_name
           FROM exsicd_seafarer_docs_iface sd, sicd_grades sg
          WHERE esi_id = p_esi_id AND sg.grade_id = sd.grade_id;

      CURSOR get_edoc_data (p_edoc_id IN NUMBER)
      IS
         SELECT *
           FROM iri_edocs
          WHERE ID = p_edoc_id;

      l_edoc_rec          get_edoc_data%ROWTYPE;
      p_name_identifier   VARCHAR2 (100);
      user_id             NUMBER;
      login_id            NUMBER;
   BEGIN
      p_return_code := 'SUCCESS';
      p_error_msg := NULL;
      user_id := get_userid;
      login_id := get_loginid;

      OPEN get_seafarer;

      FETCH get_seafarer
       INTO seaf_rec;

      CLOSE get_seafarer;

      FOR x IN get_vetting (seaf_rec.seafarer_id)
      LOOP
         -- Data Privacy Consent
         IF seaf_rec.consent_edoc_id IS NOT NULL
         THEN
            OPEN get_edoc_data (seaf_rec.consent_edoc_id);

            FETCH get_edoc_data
             INTO l_edoc_rec;

            CLOSE get_edoc_data;

            BEGIN
               INSERT INTO xwrl.xwrl_case_documents
                           (ID, request_id,
                            case_id, edoc_id,
                            document_file, document_name, document_category,
                            document_type,
                            file_name, file_path,
                            content_type, image_file, image_name,
                            image_path, url_path, last_update_date,
                            last_updated_by, creation_date, created_by,
                            last_update_login
                           )
                    VALUES (xwrl_case_documents_seq.NEXTVAL, x.ID,
                            x.case_id, seaf_rec.consent_edoc_id,
                            l_edoc_rec.disk_path, '', '',      -- Doc Category
                            'Online Order - Data Privacy Consent',
                            l_edoc_rec.file_name, l_edoc_rec.disk_path,
                            NULL, NULL, NULL,
                            NULL,                                -- image path
                                 l_edoc_rec.url, SYSDATE,
                            user_id, SYSDATE, user_id,
                            login_id
                           );
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX
               THEN
                  NULL;
               WHEN OTHERS
               THEN
                  p_error_msg := 'Inserting DPC : ' || SQLERRM;
                  ROLLBACK;
                  p_return_code := 'ERROR';
                  RETURN;
            END;

            COMMIT;
         END IF;

         IF seaf_rec.photo_edoc_id IS NOT NULL
         THEN
            OPEN get_edoc_data (seaf_rec.photo_edoc_id);

            FETCH get_edoc_data
             INTO l_edoc_rec;

            CLOSE get_edoc_data;

            BEGIN
               INSERT INTO xwrl.xwrl_case_documents
                           (ID, request_id,
                            case_id, edoc_id,
                            document_file, document_name, document_category,
                            document_type, file_name,
                            file_path, content_type, image_file, image_name,
                            image_path, url_path, last_update_date,
                            last_updated_by, creation_date, created_by,
                            last_update_login
                           )
                    VALUES (xwrl_case_documents_seq.NEXTVAL, x.ID,
                            x.case_id, seaf_rec.photo_edoc_id,
                            l_edoc_rec.disk_path, '', '',      -- Doc Category
                            'Online Order -Photo', l_edoc_rec.file_name,
                            l_edoc_rec.disk_path, NULL, NULL, NULL,
                            NULL,                                -- image path
                                 l_edoc_rec.url, SYSDATE,
                            user_id, SYSDATE, user_id,
                            login_id
                           );
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX
               THEN
                  NULL;
               WHEN OTHERS
               THEN
                  p_error_msg := 'Inserting Photo : ' || SQLERRM;
                  ROLLBACK;
                  p_return_code := 'ERROR';
                  RETURN;
            END;

            COMMIT;
         END IF;

         IF seaf_rec.physical_edoc_id IS NOT NULL
         THEN
            OPEN get_edoc_data (seaf_rec.physical_edoc_id);

            FETCH get_edoc_data
             INTO l_edoc_rec;

            CLOSE get_edoc_data;

            BEGIN
               INSERT INTO xwrl.xwrl_case_documents
                           (ID, request_id,
                            case_id, edoc_id,
                            document_file, document_name, document_category,
                            document_type,
                            file_name, file_path,
                            content_type, image_file, image_name,
                            image_path, url_path, last_update_date,
                            last_updated_by, creation_date, created_by,
                            last_update_login
                           )
                    VALUES (xwrl_case_documents_seq.NEXTVAL, x.ID,
                            x.case_id, seaf_rec.physical_edoc_id,
                            l_edoc_rec.disk_path, '', '',      -- Doc Category
                            'Online Order -Physical Examination',
                            l_edoc_rec.file_name, l_edoc_rec.disk_path,
                            NULL, NULL, NULL,
                            NULL,                                -- image path
                                 l_edoc_rec.url, SYSDATE,
                            user_id, SYSDATE, user_id,
                            login_id
                           );
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX
               THEN
                  NULL;
               WHEN OTHERS
               THEN
                  p_error_msg := 'Inserting Physical Exam: ' || SQLERRM;
                  ROLLBACK;
                  p_return_code := 'ERROR';
                  RETURN;
            END;

            COMMIT;
         END IF;

         IF seaf_rec.identity_doc_edoc_id IS NOT NULL
         THEN
            BEGIN
               OPEN get_edoc_data (seaf_rec.identity_doc_edoc_id);

               FETCH get_edoc_data
                INTO l_edoc_rec;

               CLOSE get_edoc_data;

               INSERT INTO xwrl.xwrl_case_documents
                           (ID, request_id,
                            case_id, edoc_id,
                            document_file, document_name, document_category,
                            document_type,
                            file_name, file_path,
                            content_type, image_file, image_name,
                            image_path, url_path, last_update_date,
                            last_updated_by, creation_date, created_by,
                            last_update_login
                           )
                    VALUES (xwrl_case_documents_seq.NEXTVAL, x.ID,
                            x.case_id, seaf_rec.identity_doc_edoc_id,
                            l_edoc_rec.disk_path, '', '',      -- Doc Category
                            'Online Order - Identity Document',
                            l_edoc_rec.file_name, l_edoc_rec.disk_path,
                            NULL, NULL, NULL,
                            NULL,                                -- image path
                                 l_edoc_rec.url, SYSDATE,
                            user_id, SYSDATE, user_id,
                            login_id
                           );
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX
               THEN
                  NULL;
               WHEN OTHERS
               THEN
                  p_error_msg := 'Inserting ID Doc: ' || SQLERRM;
                  ROLLBACK;
                  p_return_code := 'ERROR';
                  RETURN;
            END;

            COMMIT;
         END IF;

         IF seaf_rec.sat_edoc_id IS NOT NULL
         THEN
            BEGIN
               OPEN get_edoc_data (seaf_rec.sat_edoc_id);

               FETCH get_edoc_data
                INTO l_edoc_rec;

               CLOSE get_edoc_data;

               INSERT INTO xwrl.xwrl_case_documents
                           (ID, request_id,
                            case_id, edoc_id,
                            document_file, document_name, document_category,
                            document_type,
                            file_name, file_path,
                            content_type, image_file, image_name,
                            image_path, url_path, last_update_date,
                            last_updated_by, creation_date, created_by,
                            last_update_login
                           )
                    VALUES (xwrl_case_documents_seq.NEXTVAL, x.ID,
                            x.case_id, seaf_rec.sat_edoc_id,
                            l_edoc_rec.disk_path, '', '',      -- Doc Category
                            'Online Order - Security Awareness',
                            l_edoc_rec.file_name, l_edoc_rec.disk_path,
                            NULL, NULL, NULL,
                            NULL,                                -- image path
                                 l_edoc_rec.url, SYSDATE,
                            user_id, SYSDATE, user_id,
                            login_id
                           );
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX
               THEN
                  NULL;
               WHEN OTHERS
               THEN
                  p_error_msg := 'Inserting SAT Doc: ' || SQLERRM;
                  ROLLBACK;
                  p_return_code := 'ERROR';
                  RETURN;
            END;

            COMMIT;
         END IF;

         IF seaf_rec.seaservice_transcript_edoc_id IS NOT NULL
         THEN
            BEGIN
               OPEN get_edoc_data (seaf_rec.seaservice_transcript_edoc_id);

               FETCH get_edoc_data
                INTO l_edoc_rec;

               CLOSE get_edoc_data;

               INSERT INTO xwrl.xwrl_case_documents
