create or replace PACKAGE BODY      "RMI_OWS_COMMON_UTIL"
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
   * 26-MAY-2020 IRI              1.58               SAGARWAL       26-MAY-2020  E  Added Procedure get_master_id                             *
   * 28-MAY-2020 IRI              1.59              TSUAZO               28-MAY-2020 B Additional fix for alert mismatch
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
                           (ID, request_id,
                            case_id,
                            edoc_id,
                            document_file, document_name, document_category,
                            document_type,
                            file_name, file_path,
                            content_type, image_file, image_name,
                            image_path, url_path, last_update_date,
                            last_updated_by, creation_date, created_by,
                            last_update_login
                           )
                    VALUES (xwrl_case_documents_seq.NEXTVAL, x.ID,
                            x.case_id,
                            seaf_rec.seaservice_transcript_edoc_id,
                            l_edoc_rec.disk_path, '', '',      -- Doc Category
                            'Online Order -  Sea Service',
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
                  p_error_msg := 'Inserting Sea Service: ' || SQLERRM;
                  ROLLBACK;
                  p_return_code := 'ERROR';
                  RETURN;
            END;

            COMMIT;
         END IF;

         IF seaf_rec.application_edoc_id IS NOT NULL
         THEN
            BEGIN
               OPEN get_edoc_data (seaf_rec.application_edoc_id);

               FETCH get_edoc_data
                INTO l_edoc_rec;

               CLOSE get_edoc_data;

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
                            x.case_id, seaf_rec.application_edoc_id,
                            l_edoc_rec.disk_path, '', '',      -- Doc Category
                            'Online Order -  MI-271', l_edoc_rec.file_name,
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
                  p_error_msg := 'Inserting MI-271: ' || SQLERRM;
                  ROLLBACK;
                  p_return_code := 'ERROR';
                  RETURN;
            END;

            COMMIT;
         END IF;

         FOR y IN get_seafarer_docs
         LOOP
            IF y.edoc_id IS NOT NULL
            THEN
               BEGIN
                  OPEN get_edoc_data (y.edoc_id);

                  FETCH get_edoc_data
                   INTO l_edoc_rec;

                  CLOSE get_edoc_data;

                  INSERT INTO xwrl.xwrl_case_documents
                              (ID, request_id,
                               case_id, edoc_id, document_file,
                               document_name, document_category,
                               document_type,
                               file_name, file_path,
                               content_type, image_file, image_name,
                               image_path, url_path, last_update_date,
                               last_updated_by, creation_date, created_by,
                               last_update_login
                              )
                       VALUES (xwrl_case_documents_seq.NEXTVAL, x.ID,
                               x.case_id, y.edoc_id, l_edoc_rec.disk_path,
                               '', '',                         -- Doc Category
                               SUBSTR (   'Online Order - '
                                       || y.grade_name
                                       || ' Records',
                                       1,
                                       50
                                      ),
                               l_edoc_rec.file_name, l_edoc_rec.disk_path,
                               NULL, NULL, NULL,
                               NULL,                             -- image path
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
                     p_error_msg :=
                              'Inserting ' || y.grade_code || ': ' || SQLERRM;
                     ROLLBACK;
                     p_return_code := 'ERROR';
                     RETURN;
               END;

               COMMIT;
            END IF;
         END LOOP;
      END LOOP;

      COMMIT;
   END;

   PROCEDURE create_document_references (
      p_batch_id      IN       NUMBER,
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
         SELECT -- * SAURABH Remove *
                ID,CASE_ID
           FROM xwrl_requests xref
          WHERE 1 = 1
            AND source_table = 'SICD_SEAFARERS'
            AND source_id = p_seafarer_id
            AND batch_id = p_batch_id;


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
                            'Online Order - Photo', l_edoc_rec.file_name,
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
                           (ID, request_id,
                            case_id,
                            edoc_id,
                            document_file, document_name, document_category,
                            document_type,
                            file_name, file_path,
                            content_type, image_file, image_name,
                            image_path, url_path, last_update_date,
                            last_updated_by, creation_date, created_by,
                            last_update_login
                           )
                    VALUES (xwrl_case_documents_seq.NEXTVAL, x.ID,
                            x.case_id,
                            seaf_rec.seaservice_transcript_edoc_id,
                            l_edoc_rec.disk_path, '', '',      -- Doc Category
                            'Online Order -  Sea Service',
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
                  p_error_msg := 'Inserting Sea Service: ' || SQLERRM;
                  ROLLBACK;
                  p_return_code := 'ERROR';
                  RETURN;
            END;

            COMMIT;
         END IF;

         IF seaf_rec.application_edoc_id IS NOT NULL
         THEN
            BEGIN
               OPEN get_edoc_data (seaf_rec.application_edoc_id);

               FETCH get_edoc_data
                INTO l_edoc_rec;

               CLOSE get_edoc_data;

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
                            x.case_id, seaf_rec.application_edoc_id,
                            l_edoc_rec.disk_path, '', '',      -- Doc Category
                            'Online Order -  MI-271', l_edoc_rec.file_name,
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
                  p_error_msg := 'Inserting MI-271: ' || SQLERRM;
                  ROLLBACK;
                  p_return_code := 'ERROR';
                  RETURN;
            END;

            COMMIT;
         END IF;

         FOR y IN get_seafarer_docs
         LOOP
            IF y.edoc_id IS NOT NULL
            THEN
               BEGIN
                  OPEN get_edoc_data (y.edoc_id);

                  FETCH get_edoc_data
                   INTO l_edoc_rec;

                  CLOSE get_edoc_data;

                  INSERT INTO xwrl.xwrl_case_documents
                              (ID, request_id,
                               case_id, edoc_id, document_file,
                               document_name, document_category,
                               document_type,
                               file_name, file_path,
                               content_type, image_file, image_name,
                               image_path, url_path, last_update_date,
                               last_updated_by, creation_date, created_by,
                               last_update_login
                              )
                       VALUES (xwrl_case_documents_seq.NEXTVAL, x.ID,
                               x.case_id, y.edoc_id, l_edoc_rec.disk_path,
                               '', '',                         -- Doc Category
                               SUBSTR (   'Online Order - '
                                       || y.grade_name
                                       || ' Records',
                                       1,
                                       50
                                      ),
                               l_edoc_rec.file_name, l_edoc_rec.disk_path,
                               NULL, NULL, NULL,
                               NULL,                             -- image path
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
                     p_error_msg :=
                              'Inserting ' || y.grade_code || ': ' || SQLERRM;
                     ROLLBACK;
                     p_return_code := 'ERROR';
                     RETURN;
               END;

               COMMIT;
            END IF;
         END LOOP;
      END LOOP;

      COMMIT;
   END;

   FUNCTION is_request_sanctioned (p_id IN NUMBER)
      RETURN VARCHAR2
   IS
      CURSOR cur_sanctioned_count
      IS
         SELECT COUNT (1)
           FROM xwrl_requests xr, xwrl_response_ind_columns xrc
          WHERE 1 = 1
            AND xr.ID = p_id
            AND xr.ID = xrc.request_id
            AND xr.PATH = 'INDIVIDUAL'
            AND listrecordtype = 'SAN'
         UNION
         SELECT COUNT (1)
           FROM xwrl_requests xr, xwrl_response_entity_columns xrc
          WHERE 1 = 1
            AND xr.ID = p_id
            AND xr.ID = xrc.request_id
            AND listrecordtype = 'SAN'
            AND xr.PATH = 'ENTITY';

      l_cnt   NUMBER := 0;
   BEGIN
      OPEN cur_sanctioned_count;

      FETCH cur_sanctioned_count
       INTO l_cnt;

      CLOSE cur_sanctioned_count;

      IF l_cnt > 0
      THEN
         RETURN 'Y';
      ELSE
         RETURN 'N';
      END IF;
   END is_request_sanctioned;



   FUNCTION name_in_blocklist (p_id IN NUMBER, x_message OUT VARCHAR2)
      RETURN VARCHAR2
   IS
      l_return   VARCHAR2 (1)   := 'N';
      l_name     VARCHAR2 (100);
   BEGIN
      l_name := get_name (p_id);

      IF l_name IS NOT NULL
      THEN
         SELECT 'Y', block_message
           INTO l_return, x_message
           FROM vssl.rmi_tc_entities_on_blocklist
          WHERE TRIM (UPPER (entity_name)) = TRIM (UPPER (l_name))
            AND enabled_flag = 'Y';
      END IF;

      RETURN l_return;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 'N';
   END name_in_blocklist;

      FUNCTION get_name (p_id IN NUMBER)
      RETURN VARCHAR2
   IS
      l_name          VARCHAR2 (100);
      l_last_name     VARCHAR2 (100);
      l_req_details   xwrl_requests%ROWTYPE;
      l_path          VARCHAR2(100);
   BEGIN
--      l_req_details := get_case_details (p_id);

      SELECT path INTO l_path
           FROM xwrl_requests req
          WHERE req.ID = p_id;

      IF l_path = 'INDIVIDUAL'
      THEN
         SELECT VALUE
           INTO l_name
           FROM xwrl_request_rows
          WHERE request_id = p_id AND KEY = 'GivenNames';

         IF l_name IS NOT NULL
         THEN
            SELECT VALUE
              INTO l_last_name
              FROM xwrl_request_rows
             WHERE request_id = p_id AND KEY = 'FamilyName';

            l_name := l_name || ' ' || l_last_name;
         ELSE
            SELECT VALUE
              INTO l_name
              FROM xwrl_request_rows
             WHERE request_id = p_id AND KEY = 'FullName';
         END IF;
      ELSE
         SELECT VALUE
           INTO l_name
           FROM xwrl_request_rows
          WHERE request_id = p_id AND KEY = 'EntityName';
      END IF;

      RETURN l_name;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END get_name;


   PROCEDURE send_notice_to_legal (
      p_name_screened   IN   VARCHAR2,
      x_message         IN   VARCHAR2
   )
   IS
      conn                        UTL_SMTP.connection;
      email_text                  VARCHAR2 (5000);
      header_line                 VARCHAR2 (300);
      detail_line                 VARCHAR2 (4000);
      v_subject_line              VARCHAR2 (4000);
      -- ZK 06082018 T20180607.0017
      sender_email_address        VARCHAR2 (300);
      destination_email_address   VARCHAR2 (300);
      --      x_ref_data                  world_check_iface.xref_tab;
      comment1                    VARCHAR2 (100);
      comment2                    VARCHAR2 (100);
      email_message_full          VARCHAR2 (4000);
      email_message_line          VARCHAR2 (4000);
      error_message               VARCHAR2 (400)      := 'Success';
      cc                          VARCHAR2 (300);
   BEGIN
      --
      --p_name_screened := get_name (p_id);
      sender_email_address := '#IRI-Trade@register-iri.com';
      destination_email_address :=
                          'Legal@register-iri.com,IRI-Trade@Register-IRI.com';
      v_subject_line :=
            'Trade Compliance for blocked entity '
         --
         || p_name_screened
         || ' has been initiated.'
         || '.';                                 -- ZK 06082018 T20180607.0017
      detail_line :=
            'Trade Compliance for blocked entity '
         || p_name_screened
         || ' has been initiated.'
         || '<BR><BR>'
         --||'See Nonpaper on U.S. Sanctions Targeting Iran''s Enrichment-Related Procurement Activities July 2019'
         || x_message;
      cc := 'zkhan@register-iri.com,saurabh.agarwal@qspear.com';
      email_message_full := detail_line;
      conn :=
         demo_mail.begin_mail (sender          => sender_email_address,
                               cc              => cc,
                               recipients      => destination_email_address,
                               subject         => v_subject_line,
                               mime_type       => 'text/html'
                              );
      email_message_line := '<BR><BR>' || detail_line || '<BR><BR>';
      email_message_full := email_message_full || email_message_line;
      demo_mail.write_text (conn => conn, MESSAGE => email_message_line);
      email_message_line :=
         '<BR><BR><BR><BR><BR><BR><BR><center>This is an automated e-mail message. </center>';
      email_message_full := email_message_full || email_message_line;
      demo_mail.write_text (conn => conn, MESSAGE => email_message_line);
      demo_mail.end_mail (conn => conn);
   EXCEPTION
      WHEN OTHERS
      THEN
         error_message := SQLERRM;
   END send_notice_to_legal;

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
   )
   IS
      conn                        UTL_SMTP.connection;
      email_text                  VARCHAR2 (6000);
      --VARCHAR2 (5000); -- SHIVI
      header_line                 VARCHAR2 (300);
      detail_line                 VARCHAR2 (4000);
      v_subject_line              VARCHAR2 (4000);
      -- ZK 06082018 T20180607.0017
      sender_email_address        VARCHAR2 (300);
      destination_email_address   VARCHAR2 (300);
      --      x_ref_data                  world_check_iface.xref_tab;
      comment1                    VARCHAR2 (100);
      comment2                    VARCHAR2 (100);
      email_message_full          VARCHAR2 (4000);
      email_message_line          VARCHAR2 (4000);
      error_message               VARCHAR2 (400)      := 'Success';
      cc                          VARCHAR2 (300);
      cc2                         VARCHAR2 (300);
      l_fin_no                    VARCHAR2 (100);
      --      p_name_screened             VARCHAR2 (100);
      p_notes                     VARCHAR2 (1000);
      p_notes_all                 VARCHAR2 (2000);

      CURSOR cur_notes
      IS
         --    /*     SELECT   substr(xcn.note,1,100) note
         --             FROM xwrl_case_notes xcn, xwrl_requests xr
         --            WHERE xcn.case_id = xr.case_id AND xr.ID = p_id
         SELECT SUBSTR (xcn.note, 1, 1000) note
           FROM xwrl_case_notes xcn
          WHERE xcn.request_id = p_id;
   --         ORDER BY xcn.ID DESC;
   BEGIN
      --      p_name_screened := get_name (p_id);
      p_return_code := 0;
      p_return_message := 'Successful';
      sender_email_address := '#IRI-Trade@register-iri.com';
      DBMS_OUTPUT.put_line ('Start');

      OPEN cur_notes;

      LOOP
         FETCH cur_notes
          INTO p_notes;

         EXIT WHEN cur_notes%NOTFOUND;
         p_notes_all := p_notes || '<BR> <BR>' || p_notes_all;
      END LOOP;

      CLOSE cur_notes;

      --      --SAURABH 16-NOV-2018 T20181115.0015
      --destination_email_address := get_user_email_address(p_created_by);

      /*shivi goel 20dec2019      T20191220.0028  */
      IF world_check_iface.is_user_internal (p_created_by)
      THEN
         destination_email_address := get_user_email_address (p_created_by);
      END IF;

      /*T20191220.0028 end of code change*/

      -- 29-MAR-2019 SAURABH T20190328.0004
      IF p_source_table = 'SICD_SEAFARERS'
      THEN
         l_fin_no := p_source_id;
         v_subject_line  := 'Trade Compliance for FIN: ';    -- SHIVI T20200211.0009
         ELSE
         v_subject_line  := 'Trade Compliance for';
      END IF;

      --
      DBMS_OUTPUT.put_line ('p_source_id' || l_fin_no);

      --APPS.mt_log_error(p_NAME_SCREENED||' '||destination_email_address ||' '||SYSDATE); -- ZK 06072018
      IF p_status IN ('Approved', 'Rejected')
      THEN
         v_subject_line :=
               v_subject_line   --'Trade Compliance for FIN: '  -- SHIVI T20200211.0009
            -- 29-MAR-2019 SAURABH T20190328.0004
            || l_fin_no
            --
            || ' '                            -- T20191221.0019 SHIVI 23122019
            || p_name_screened
            || ' has been '
            || p_status
            || '.';                              -- ZK 06082018 T20180607.0017
         detail_line :=
               'Trade Compliance for '
            || p_name_screened
            || ' has been '
            || p_status
            || '.';

         IF p_notes_all IS NOT NULL
         THEN
            detail_line :=
                  detail_line
               || 'Please address the following comments: <BR> <BR>'
               || REPLACE (p_notes_all, CHR (10), '<BR>')
               || '<BR><BR>These comments can be viewed in the TC screen by pressing the Enter/View Notes button in the upper right section of the screen.';
         END IF;
      ELSIF p_status = 'Pending'
      THEN
         -- Changed Subject Line to match other cases ZK 06082018 T20180607.0017
         v_subject_line :=
             v_subject_line   --'Trade Compliance for FIN: '  -- SHIVI T20200211.0009
                           -- 29-MAR-2019 SAURABH T20190328.0004
            || l_fin_no
            || ' '                            -- T20191221.0019 SHIVI 23122019
            || p_name_screened
            || ' has been set to Pending. ';
         detail_line :=
               'Trade Compliance for '
            || p_name_screened
            || ' has been set to Pending. ';

         -- APPS.mt_log_error(p_NAME_SCREENED||' '||'Detail Line '||SYSDATE); -- ZK 06072018

         --SAURABH T20181107.0012 14-NOV-2018
         IF p_notes_all IS NOT NULL
         THEN
            detail_line :=
                  detail_line
               || 'Please address the following comments: <BR> <BR>'
               || REPLACE (p_notes_all, CHR (10), '<BR>')
               || '<BR><BR>These comments can be viewed in the TC screen by pressing the Enter/View Notes button in the upper right section of the screen.';
         END IF;
      --START
      ELSIF p_status = 'Provisional'
      THEN
         v_subject_line :=
               v_subject_line   --'Trade Compliance for FIN: '  -- SHIVI T20200211.0009
            -- 29-MAR-2019 SAURABH T20190328.0004
            || l_fin_no
            || ' '                            -- T20191221.0019 SHIVI 23122019
            || p_name_screened
            || ' has been set to Provisional.';
         detail_line :=
               'Trade Compliance for '
            || p_name_screened
            || ' has been set to Provisional. <BR> <BR>';

         IF p_notes_all IS NOT NULL
         THEN
            detail_line :=
                  detail_line
               || 'Please address the following comments: <BR> <BR>'
               || REPLACE (p_notes_all, CHR (10), '<BR>')
               || '<BR><BR>These comments can be viewed in the TC screen by pressing the Enter/View Notes button in the upper right section of the screen.';
         END IF;
      --SAURABH T20181107.0012 14-NOV-2018
      --END
      ELSE
         v_subject_line :=
                    'Please contact Legal /IT this message went out in error';
         detail_line :=
            'Please contact Legal /IT this message went out in error!!<BR><BR>';
      END IF;

      IF p_source_table = 'SICD_SEAFARERS'
      THEN
         --- Added Nancy's email as per Help Desk ticket T20180910.0010
         cc :=
--'chickman@register-iri.com,pfeild@register-iri.com,jvannuys@register-iri.com,jnotay@register-iri.com,jpatsios@Register-IRI.com';

                     --'chickman@register-iri.com,pfeild@register-iri.com,TCSeafarers@register-iri.com';
                     -- Gopi Vella Removed Peters Email as per the ticket T20191211.0074
                     'chickman@register-iri.com,TCSeafarers@register-iri.com';
      -- T20181205.0025 - Added Jordan and removed Natalie
      --, zkhan@Register-IRI.com'; T20180910.0010 ZK  Added and then removed Nancy F.; T20181030.0032 ZK 11012018 removed Ryan
      --- APPS.mt_log_error(p_NAME_SCREENED||' cc: '||cc||' '||SYSDATE); -- ZK 06072018
      ELSE
         -- Gopi Vella Removed Peters Email as per the ticket T20191211.0074
         --cc := 'chickman@register-iri.com,pfeild@Register-IRI.com';
         cc := 'chickman@register-iri.com';
         --, zkhan@Register-IRI.com';T20181030.0032 ZK 11012018 removed Ryan
         cc2 := get_user_cc_email_address (p_created_by);

         IF cc2 IS NOT NULL
         THEN
            cc := cc || ',' || cc2;
         END IF;
      -- APPS.mt_log_error(p_NAME_SCREENED||' cc:'||cc||' second cc '||SYSDATE); -- ZK 06072018
      END IF;

      email_message_full := detail_line;
      DBMS_OUTPUT.put_line ('start mail');
      conn :=
         demo_mail.begin_mail
               (sender          => sender_email_address,
                cc              => cc,
                recipients      => destination_email_address,
                subject         =>                            --'IRIDR OWS - '
                                   v_subject_line,        --|| v_subject_line,
                --    detail_line  ZK 06082018 T20180607.0017
                mime_type       => 'text/html'
               );
      email_message_line :=
            'Dear '
         || get_username_propername (p_created_by)
         || ': <BR><BR>'
         || detail_line
         || '<BR><BR>';
      email_message_full := email_message_full || email_message_line;
      demo_mail.write_text (conn => conn, MESSAGE => email_message_line);
      email_message_line :=
         '<BR><BR><BR><BR><BR><BR><BR><center>This is an automated e-mail message. </center>';
      email_message_full := email_message_full || email_message_line;
      --APPS.mt_log_error(p_NAME_SCREENED||' '||'Before second write text '||SYSDATE); -- ZK 06072018
      demo_mail.write_text (conn => conn, MESSAGE => email_message_line);
      -- APPS.mt_log_error(p_NAME_SCREENED||' '||'After second write text '||SYSDATE); -- ZK 06072018
      demo_mail.end_mail (conn => conn);
   --APPS.mt_log_error(p_NAME_SCREENED||' '||'After Insert '||SYSDATE); -- ZK 06072018
   EXCEPTION
      WHEN OTHERS
      THEN
         RAISE;
         error_message := SQLERRM;
   --APPS.mt_log_error(p_NAME_SCREENED||' '||error_message||': Exception Send Notice From Trigger '||SYSDATE); -- ZK 06072018

   --raise_application_error(-20001,'World_check_iface.send_notice '||sqlerrm);
   END send_notice_from_trigger;

   PROCEDURE create_new_xref (
      xref             IN OUT   rmi_ows_common_util.wc_external_xref_rec,
      return_code      OUT      NUMBER,
      return_message   OUT      VARCHAR2
   )
   IS
      user_id                 NUMBER;
      login_id                NUMBER;
      l_source_table_column   VARCHAR2 (100);
   BEGIN
      user_id := get_userid;
      login_id := get_loginid;
   --      SELECT worldcheck_external_xref_seq.NEXTVAL
   --        INTO xref.worldcheck_external_xref_id
   --        FROM DUAL;

   --      return_code := 0;
   --      return_message := 'OK';

   --      SELECT DECODE (xref.source_table,
   --                     'CORP_MAIN', 'CORP_ID',
   --                     'NRMI_CERTIFICATES_rq', 'NRMI_CERTIFICATES_ID',
   --                     'REG11_HEADER', 'REG11_HEADER_ID',
   --                     'NRMI_VESSELS_KNOWN_PARTY', 'NRMI_CERTIFICATES_ID',
   --                     'NRMI_CERTIFICATES_bt', 'NRMI_CERTIFICATES_ID',
   --                     'NRMI_CERTIFICATES', 'NRMI_CERTIFICATES_ID',
   --                     'NRMI_VESSELS_vssl', 'NRMI_CERTIFICATES_ID',
   --                     'NRMI_VESSELS_reg_own', 'NRMI_CERTIFICATES_ID',
   --                     'SICD_SEAFARERS', 'SEAFARER_ID',
   --                     'AR_CUSTOMERS', 'CUSTOMER_ID',
   --                     'VSSL_VESSELS', 'VESSEL_PK',
   --                     'VSSL_CONTACTS_V', 'CONTACT_ID',
   --                     'INSP_INSPECTORS', 'INSPECTOR_ID'
   --                    )
   --        INTO l_source_table_column
   --        FROM DUAL;

   --      BEGIN
   --         UPDATE vssl.worldcheck_external_xref
   --            SET source_table_status_column = xref.source_table_status_column,
   --                source_table_column =
   --                         NVL (xref.source_table_column, l_source_table_column),
   --                last_update_date = SYSDATE,
   --                last_updated_by = user_id,
   --                last_update_login = login_id
   --          WHERE 1 = 1
   --            AND source_table = xref.source_table
   --            AND source_table_id = xref.source_table_id
   --            AND wc_screening_request_id = xref.wc_screening_request_id
   --            AND TRUNC (creation_date) >= g_ows_cutoff_date;

   --         IF SQL%ROWCOUNT = 0
   --         THEN
   --            INSERT INTO vssl.worldcheck_external_xref
   --                        (worldcheck_external_xref_id,
   --                         wc_screening_request_id,
   --                         source_table,
   --                         source_table_id,
   --                         source_table_column,
   --                         source_table_status_column,
   --                         created_by,
   --                         creation_date,
   --                         last_updated_by,
   --                         last_update_date,
   --                         last_update_login
   --                        )
   --                 VALUES (xref.worldcheck_external_xref_id /* WORLDCHECK_EXTERNAL_XREF_ID */,
   --                         xref.wc_screening_request_id /* WC_SCREENING_REQUEST_ID */,
   --                         xref.source_table /* SOURCE_TABLE */,
   --                         xref.source_table_id /* SOURCE_TABLE_ID */,
   --                         NVL
   --                            (xref.source_table_column, l_source_table_column) /* SOURCE_TABLE_COLUMN */,
   --                         xref.source_table_status_column /* SOURCE_TABLE_STATUS_COLUMN */,
   --                         user_id /* CREATED_BY */,
   --                         SYSDATE /* CREATION_DATE */,
   --                         user_id /* LAST_UPDATED_BY */,
   --                         SYSDATE /* LAST_UPDATE_DATE */,
   --                         login_id                      /* LAST_UPDATE_LOGIN */
   --                        );
   --         END IF;
   --      EXCEPTION
   --         WHEN OTHERS
   --         THEN
   --            ROLLBACK;
   --            return_code := SQLCODE;
   --            return_message := SQLERRM;
   --            RETURN;
   --      END;

   --      COMMIT;
   END;

   FUNCTION is_vetting_category_restricted (p_id IN NUMBER)
      RETURN VARCHAR2
   IS
      auto_approve   BOOLEAN := TRUE;

      CURSOR get_ows_alerts
      IS
         SELECT xrc.x_state matchstatus, xrc.CATEGORY category_type
           FROM xwrl_requests xr, xwrl_response_ind_columns xrc
          WHERE 1 = 1
            AND xr.ID = p_id
            AND xr.ID = xrc.request_id
            AND xr.PATH = 'INDIVIDUAL'
            AND UPPER (xrc.x_state) NOT LIKE '%FALSE POSITIVE%'
         UNION ALL
         SELECT xrc.x_state matchstatus, xrc.CATEGORY category_type
           FROM xwrl_requests xr, xwrl_response_entity_columns xrc
          WHERE 1 = 1
            AND xr.ID = p_id
            AND xr.ID = xrc.request_id
            AND xr.PATH = 'ENTITY'
            AND UPPER (xrc.x_state) NOT LIKE '%FALSE POSITIVE%';
   BEGIN
      FOR a IN get_ows_alerts
      LOOP
         IF UPPER (a.category_type) IN
               ('TERRORISM', 'BLACKLISTED', 'CRIME - FINANCIAL',
                'CRIME - NARCOTICS', 'CRIME - ORGANIZED', 'CRIME - OTHER',
                'CRIME - WAR', 'MILITARY', 'POLITICAL INDIVIDUAL')
         THEN
            auto_approve := FALSE;
            EXIT;
         END IF;
      END LOOP;

      -- T20191218.0037 SAURABH 09-JAN-2020
      UPDATE xwrl_response_ind_columns
         SET legal_review = 'Y'
       WHERE request_id = p_id
         AND UPPER (CATEGORY) IN
                ('TERRORISM', 'BLACKLISTED', 'CRIME - FINANCIAL',
                 'CRIME - NARCOTICS', 'CRIME - ORGANIZED', 'CRIME - OTHER',
                 'CRIME - WAR', 'MILITARY', 'POLITICAL INDIVIDUAL');

      -- T20191218.0037 SAURABH 09-JAN-2020
      UPDATE xwrl_response_entity_columns
         SET legal_review = 'Y'
       WHERE request_id = p_id
         AND UPPER (CATEGORY) IN
                ('TERRORISM', 'BLACKLISTED', 'CRIME - FINANCIAL',
                 'CRIME - NARCOTICS', 'CRIME - ORGANIZED', 'CRIME - OTHER',
                 'CRIME - WAR', 'MILITARY', 'POLITICAL INDIVIDUAL');

      COMMIT;

      IF auto_approve
      THEN
         RETURN 'N';
      END IF;

      RETURN 'Y';
   END is_vetting_category_restricted;

   PROCEDURE update_request_status (
      p_id               IN       NUMBER,
      p_status_code      IN       VARCHAR2,
      p_return_code      OUT      NUMBER,
      p_return_message   OUT      VARCHAR2
   )
   IS
      v_sql       VARCHAR2 (2000) := NULL;
      l_user_id   NUMBER          := fnd_profile.VALUE ('USER_ID');
   BEGIN
      v_sql :=
         'UPDATE XWRL_REQUESTS
SET    CASE_WORKFLOW = :1,
       LAST_UPDATED_BY = :2,
       LAST_UPDATE_DATE= :3
WHERE  ID = :4 ';

      BEGIN
         EXECUTE IMMEDIATE v_sql
                     USING p_status_code, l_user_id, SYSDATE, p_id;

         DBMS_OUTPUT.put_line ('OWS23 updated');
      EXCEPTION
         WHEN OTHERS
         THEN
            p_return_code := 'SQLERROR';
            p_return_message := 'update_screening_request ' || SQLERRM;
            DBMS_OUTPUT.put_line ('OWS23 err' || SQLERRM);
            ROLLBACK;
            RETURN;
      END;

      COMMIT;
   END;

   FUNCTION can_vetting_be_autoapproved (p_wc_screening_request_id IN NUMBER)
      RETURN VARCHAR2
   IS
      CURSOR get_content
      IS
         SELECT wc.*
           FROM wc_content_v wc, wc_matches_v wv
          WHERE wv.wc_screening_request_id = p_wc_screening_request_id
            AND wc.wc_matches_id = wv.wc_matches_id;

      auto_approve   BOOLEAN := TRUE;

      CURSOR get_ows_alerts
      IS
         SELECT xrc.x_state matchstatus, xrc.CATEGORY
           FROM xwrl_requests xr, xwrl_response_ind_columns xrc
          WHERE 1 = 1
            AND xr.ID = p_wc_screening_request_id
            AND xr.ID = xrc.request_id
            AND xr.PATH = 'INDIVIDUAL'
         UNION ALL
         SELECT xrc.x_state matchstatus, xrc.CATEGORY
           FROM xwrl_requests xr, xwrl_response_entity_columns xrc
          WHERE 1 = 1
            AND xr.ID = p_wc_screening_request_id
            AND xr.ID = xrc.request_id
            AND xr.PATH = 'ENTITY';
   BEGIN
      IF rmi_ows_common_util.is_request_sanctioned (p_wc_screening_request_id) =
                                                                          'Y'
      THEN
         auto_approve := FALSE;
      ELSE
         FOR x IN get_ows_alerts
         LOOP
            IF UPPER (x.matchstatus) NOT LIKE '%FALSE%'
            THEN
               auto_approve := FALSE;
               EXIT;
            END IF;
         END LOOP;
      END IF;

      IF auto_approve
      THEN
         RETURN 'Y';
      END IF;

      RETURN 'N';
   END can_vetting_be_autoapproved;

   PROCEDURE approve_screening_request (
      p_wc_screening_request_id   IN       NUMBER,
      p_return_code               OUT      NUMBER,
      p_return_message            OUT      VARCHAR2
   )
   IS
      v_sql                        VARCHAR2 (2000)          := NULL;

      CURSOR get_vetting
      IS
         SELECT *
           FROM wc_screening_request
          WHERE wc_screening_request_id = p_wc_screening_request_id;

      CURSOR get_ows_req
      IS
         SELECT --* SAURABH Remove *
                ID, path, case_id
           FROM xwrl_requests xr
          WHERE ID = p_wc_screening_request_id;


      ows_rec                      get_ows_req%ROWTYPE;

      CURSOR get_ows_ind (p_request_id IN NUMBER)
      IS
         SELECT xrc.*, xr.city_of_residence_id
           FROM xwrl_requests xr, xwrl_request_ind_columns xrc
          WHERE 1 = 1
            AND xr.ID = p_request_id
            AND xr.ID = xrc.request_id
            AND xr.PATH = 'INDIVIDUAL';

      ows_ind                      get_ows_ind%ROWTYPE;

      CURSOR get_ows_entity (p_request_id IN NUMBER)
      IS
         SELECT xrc.*
           FROM xwrl_requests xr, xwrl_request_entity_columns xrc
          WHERE 1 = 1
            AND xr.ID = p_request_id
            AND xr.ID = xrc.request_id
            AND xr.PATH = 'ENTITY';

      ows_entity                   get_ows_entity%ROWTYPE;
      vet_rec                      get_vetting%ROWTYPE;
      sanction_status              VARCHAR2 (30);
      auto_approve                 BOOLEAN                  := TRUE;
      --SAURABH 18-SEP-2019 T20190912.0051
      l_user_id                    NUMBER     := fnd_profile.VALUE ('USER_ID');
      l_passport_issuing_country   VARCHAR2 (10);
      l_citizenship_country_code   VARCHAR2 (10);
      l_residence_country_code     VARCHAR2 (10);
      l_city_id                    NUMBER;
      l_username                   VARCHAR2 (25);
   BEGIN
      -- OWS
      DBMS_OUTPUT.put_line ('OWS APPROVE');

      OPEN get_ows_req;

      FETCH get_ows_req
       INTO ows_rec;

      CLOSE get_ows_req;

      IF ows_rec.PATH = 'INDIVIDUAL'
      THEN
         DBMS_OUTPUT.put_line ('OWS 1');

         OPEN get_ows_ind (ows_rec.ID);

         FETCH get_ows_ind
          INTO ows_ind;

         CLOSE get_ows_ind;

         DBMS_OUTPUT.put_line ('OWS21');
         --         l_passport_issuing_country := ows_ind.addresscountrycode;
         --         l_citizenship_country_code := ows_ind.nationalitycountrycodes;
         --         l_residence_country_code := ows_ind.residencycountrycode;

         --SAURABH 09-JAN-2020 T20191217.0029
         l_passport_issuing_country :=
                                get_country_code (ows_ind.addresscountrycode);
         l_citizenship_country_code :=
                           get_country_code (ows_ind.nationalitycountrycodes);
         l_residence_country_code :=
                              get_country_code (ows_ind.residencycountrycode);
         --l_city_id := rmi_ows_common_util.get_city_list_id (ows_ind.city);  -- TSUAZO 12/11/2019 City is blank
         l_city_id := ows_ind.city_of_residence_id;
         DBMS_OUTPUT.put_line ('OWS22');
      ELSIF ows_rec.PATH = 'ENTITY'
      THEN
         OPEN get_ows_entity (ows_rec.ID);

         FETCH get_ows_entity
          INTO ows_entity;

         CLOSE get_ows_entity;
      --       l_passport_issuing_country := ows_entity.ADDRESSCOUNTRYCODE;
      --      l_citizenship_country_code := ows_entity.NATIONALITYCOUNTRYCODES;
      --      l_residence_country_code := ows_entity.RESIDENCYCOUNTRYCODE;
      END IF;

      sanction_status :=
            world_check_iface.get_sanction_status (l_passport_issuing_country);

      IF sanction_status IN ('PROHIBITED')
      THEN
         auto_approve := FALSE;
      END IF;

      sanction_status :=
            world_check_iface.get_sanction_status (l_citizenship_country_code);

      IF sanction_status IN ('PROHIBITED')
      THEN
         auto_approve := FALSE;
      END IF;

      sanction_status :=
              world_check_iface.get_sanction_status (l_residence_country_code);

      IF sanction_status IN ('PROHIBITED')
      THEN
         auto_approve := FALSE;
      END IF;

      sanction_status :=
            world_check_iface.get_sanction_status (l_passport_issuing_country);

      IF     sanction_status IN ('CONDITIONAL')
         AND world_check_iface.get_city_tc_status (l_city_id) IN
                                              ('TC_VERIFY', 'TC_PROVISIONAL')
      THEN
         auto_approve := FALSE;
      END IF;

      sanction_status :=
            world_check_iface.get_sanction_status (l_citizenship_country_code);

      IF     sanction_status IN ('CONDITIONAL')
         AND world_check_iface.get_city_tc_status (l_city_id) IN
                                              ('TC_VERIFY', 'TC_PROVISIONAL')
      THEN
         auto_approve := FALSE;
      END IF;

      sanction_status :=
              world_check_iface.get_sanction_status (l_residence_country_code);

      IF     sanction_status IN ('CONDITIONAL')
         AND world_check_iface.get_city_tc_status (l_city_id) IN
                                              ('TC_VERIFY', 'TC_PROVISIONAL')
      THEN
         auto_approve := FALSE;
      END IF;

      DBMS_OUTPUT.put_line ('OWS23' || sanction_status);

      IF auto_approve = TRUE
      THEN
         p_return_code := 200;
         p_return_message := 'Normal';
         --SAURABH 18-SEP-2019 T20190912.0051
         v_sql :=
            'UPDATE XWRL_REQUESTS
SET    CASE_WORKFLOW = :1,
       LAST_UPDATED_BY = :2,
       LAST_UPDATE_DATE= :3,
       CASE_STATE= :4
WHERE  ID = :5 ';

         BEGIN
            EXECUTE IMMEDIATE v_sql
                        USING 'A',
                              --world_check_iface.c_automatic_approval_uid,
                              l_user_id, SYSDATE, 'A', ows_rec.ID;

            DBMS_OUTPUT.put_line ('OWS23 updated');
         EXCEPTION
            WHEN OTHERS
            THEN
               p_return_code := 'SQLERROR';
               p_return_message := 'approve_screening_request ' || SQLERRM;
               DBMS_OUTPUT.put_line ('OWS23 err' || SQLERRM);
               ROLLBACK;
               RETURN;
         END;

         COMMIT;
         set_expiration_date (ows_rec.ID, NULL, NULL);

         --- Added By Gopi Vella To Close the OWS Case
         BEGIN
            BEGIN
               SELECT user_name
                 INTO l_username
                 FROM fnd_user
                WHERE user_id = l_user_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  l_username := 'SYSADMIN';
            END;

            close_ows_case (l_username, ows_rec.case_id, ows_rec.ID);

            UPDATE xwrl_requests
               SET case_status = 'C'
             WHERE ID = ows_rec.ID;

            COMMIT;
         END;
      --- End code change.
      END IF;
   END;

PROCEDURE create_ows_generic (
   p_req           IN OUT   rmi_ows_common_util.ows_request_rec,
   p_custom_id1    IN       VARCHAR2,
   p_custom_id2    IN       VARCHAR2,
   p_return_code   OUT      VARCHAR2,
   p_ret_msg       OUT      VARCHAR2,
   x_id            OUT      NUMBER
)
IS
   return_code           NUMBER;
   return_message        VARCHAR2 (500);
   location_msg          VARCHAR2 (100)               := 'create_wc_generic:';
   sub_msg               VARCHAR2 (500);

   CURSOR get_request_info (p_id IN NUMBER)
   IS
      SELECT                                             --* SAURABH Remove *
             ID, case_id, PATH
        FROM xwrl_requests
       WHERE ID = p_id;

   scrrqst               get_request_info%ROWTYPE;

   CURSOR get_wc_matches_ind (p_request_id IN NUMBER)
   IS
      SELECT COUNT (1)                                                --xrc.*
        FROM xwrl_requests xr, xwrl_response_ind_columns xrc
       WHERE 1 = 1
         AND xr.ID = p_request_id
         AND xr.ID = xrc.request_id
         AND xr.PATH = 'INDIVIDUAL';

   CURSOR get_wc_matches_ent (p_request_id IN NUMBER)
   IS
      SELECT COUNT (1)                                                 --xrc.*
        FROM xwrl_requests xr, xwrl_response_entity_columns xrc
       WHERE 1 = 1
         AND xr.ID = p_request_id
         AND xr.ID = xrc.request_id
         AND xr.PATH = 'ENTITY';

   mtch_ind              get_wc_matches_ind%ROWTYPE;
   l_number_of_matches   NUMBER                                   := 0;
   l_user_id             NUMBER               := fnd_profile.VALUE ('USER_ID');
   l_session_id          NUMBER;
   xref                  rmi_ows_common_util.wc_external_xref_rec;
   l_case_id             xwrl_requests.case_id%TYPE;
BEGIN
   sub_msg := 'start';
   p_ret_msg := 'Normal';
   p_return_code := 'SUCCESS';
   sub_msg := 'before nitiate_wc_screening :' || p_ret_msg;

   SELECT USERENV ('sessionid')
     INTO l_session_id
     FROM DUAL;

   IF p_req.entity_type = 'INDIVIDUAL'
   THEN

      IF NVL (p_req.full_name, p_req.first_name || p_req.last_name) IS NULL
      THEN
         p_return_code := 'ERROR_CREATING_OWS';
         p_ret_msg := 'Name is required for vetting';
         RETURN;
      END IF;


      xwrl_utils.ows_individual_screening
         (p_debug                        => 'TRUE',
          p_show_request                 => 'FALSE',
          p_show_response                => 'FALSE',
          p_user_id                      => l_user_id,
          p_session_id                   => l_session_id,
          p_source_table                 => p_req.source_table,
          p_source_id                    => p_req.source_id,
          p_batch_id                     => p_req.batch_id,
          p_fullname                     => NVL (p_req.full_name,
                                                    p_req.first_name
                                                 || ' '
                                                 || p_req.last_name
                                                ),
          p_gender                       => SUBSTR (p_req.gender, 1, 1),
          p_dateofbirth                  => rmi_ows_common_util.format_date
                                                          (p_req.date_of_birth),
          p_yearofbirth                  => TO_CHAR (p_req.date_of_birth,
                                                     'RRRR'
                                                    ),
          p_city                         => p_req.city,
          p_city_id                      => NVL (p_req.city_id,get_city_list_id (p_req.city)),
          -- SAURABH 05-MAY-2020 Comment Country Information to OWS
          p_countryofbirthcode           => rmi_ows_common_util.get_country_iso_code(p_req.nationality),
          p_addresscountrycode           => rmi_ows_common_util.get_country_iso_code(p_req.passport_issuing_country_code),
          p_residencycountrycode         => rmi_ows_common_util.get_country_iso_code(p_req.residence_country_code),
          --p_nationalitycountrycodes      => get_country_iso_code(rec.nationality),
          --- Code Added By Gopi Vella For T20200311.0014
          p_nationalitycountrycodes      => rmi_ows_common_util.get_country_iso_code(p_req.nationality),
          --- End Code Change
          p_nationalid                   => NULL,
          p_passportnumber               => p_req.passport_number,
          p_customstring1                => NULL,              --p_custom_id1,
          p_customstring2                => NULL,              --p_custom_id2,
          p_master_id                    => p_req.master_id,
          p_alias_id                     => p_req.alias_id,
          p_xref_id                      => p_req.xref_id,
          p_wc_screening_request_id      => p_req.wc_screening_request_id,
          x_id                           => x_id
         );
      sub_msg := 'after initiate_wc_screening :' || p_ret_msg;
      DBMS_OUTPUT.put_line (sub_msg);
      fnd_file.put_line (fnd_file.LOG, 'msg' || sub_msg || x_id);

      IF x_id > 0
      THEN
         -- Create Xref
         --            xref.source_table := p_req.source_table;
         --            xref.source_table_id := p_req.source_id;
         --            xref.source_table_status_column := p_req.source_table_column;
         --            xref.worldcheck_external_xref_id := NULL;
         --            xref.wc_screening_request_id := x_id;
         --            rmi_ows_common_util.create_new_xref (xref,
         --                                                 p_return_code,
         --                                                 p_ret_msg
         --                                                );

         -- Check Case ID NULL then mark as error
         BEGIN
            SELECT case_id
              INTO l_case_id
              FROM xwrl_requests
             WHERE ID = x_id;
         EXCEPTION
            WHEN OTHERS
            THEN
               l_case_id := NULL;
         END;

         IF l_case_id IS NULL
         THEN
            UPDATE xwrl_requests
               SET case_state = 'E',
                   case_workflow = 'P',
                   case_status = 'C'
             WHERE ID = x_id;

            COMMIT;
         ELSE
            OPEN get_wc_matches_ind (x_id);

            FETCH get_wc_matches_ind
             INTO l_number_of_matches;

            CLOSE get_wc_matches_ind;

            DBMS_OUTPUT.put_line (l_number_of_matches);

            IF l_number_of_matches = 0
            THEN
               sub_msg := 'Approve -1';
               approve_screening_request (x_id, return_code, p_ret_msg);
            ELSIF is_vetting_category_restricted (x_id) = 'Y'
            THEN
               update_request_status
                     (x_id,
                      rmi_ows_common_util.case_wf_status_dsp ('Legal Review'),
                      return_code,
                      p_ret_msg
                     );
            ELSIF can_vetting_be_autoapproved (x_id) = 'Y'
            THEN
               DBMS_OUTPUT.put_line ('Vetting Auto Approve');
               sub_msg := 'Approve -1.1';
               approve_screening_request (x_id, return_code, p_ret_msg);
            END IF;
         END IF;
      ELSE
         p_return_code := 'ERROR_CREATING_OWS';
      END IF;
   ELSE
      IF p_req.entity_name IS NULL
      THEN
         p_return_code := 'ERROR_CREATING_OWS';
         p_ret_msg := 'Name is required for vetting';
         RETURN;
      END IF;

      xwrl_utils.ows_entity_screening
                  (p_debug                        => 'TRUE',
                   p_show_request                 => 'FALSE',
                   p_show_response                => 'FALSE',
                   p_user_id                      => l_user_id,
                   p_session_id                   => l_session_id,
                   p_source_table                 => p_req.source_table,
                   p_source_id                    => p_req.source_id,
                   p_batch_id                     => p_req.batch_id,
                   p_entityname                   => p_req.entity_name,
                   p_vessel_indicator             => p_req.vessel_indicator,
                   p_master_id                    => p_req.master_id,
                   p_alias_id                     => p_req.alias_id,
                   p_xref_id                      => p_req.xref_id,
                   p_wc_screening_request_id      => p_req.wc_screening_request_id,
                   x_id                           => x_id
                  );
      sub_msg := 'after initiate_wc_screening :' || p_ret_msg;
      DBMS_OUTPUT.put_line (sub_msg);

      IF x_id > 0
      THEN
         -- Create Xref
         --            xref.source_table := p_req.source_table;
         --            xref.source_table_id := p_req.source_id;
         --            xref.source_table_status_column := p_req.source_table_column;
         --            xref.worldcheck_external_xref_id := NULL;
         --            xref.wc_screening_request_id := x_id;
         --            rmi_ows_common_util.create_new_xref (xref,
         --                                                 p_return_code,
         --                                                 p_ret_msg
         --                                                );

         -- Check Case ID NULL then mark as error
         BEGIN
            SELECT case_id
              INTO l_case_id
              FROM xwrl_requests
             WHERE ID = x_id;
         EXCEPTION
            WHEN OTHERS
            THEN
               l_case_id := NULL;
         END;

         IF l_case_id IS NULL
         THEN
            UPDATE xwrl_requests
               SET case_state = 'E',
                   case_workflow = 'P',
                   case_status = 'C'
             WHERE ID = x_id;

            COMMIT;
         ELSE
            OPEN get_wc_matches_ent (x_id);

            FETCH get_wc_matches_ent
             INTO l_number_of_matches;

            CLOSE get_wc_matches_ent;

            DBMS_OUTPUT.put_line (l_number_of_matches);

            IF l_number_of_matches = 0
            THEN
               sub_msg := 'Approve -1';
               approve_screening_request (x_id, return_code, p_ret_msg);
            ELSIF is_vetting_category_restricted (x_id) = 'Y'
            THEN
               update_request_status
                     (x_id,
                      rmi_ows_common_util.case_wf_status_dsp ('Legal Review'),
                      return_code,
                      p_ret_msg
                     );
            ELSIF can_vetting_be_autoapproved (x_id) = 'Y'
            THEN
               DBMS_OUTPUT.put_line ('Vetting Auto Approve');
               sub_msg := 'Approve -1.1';
               approve_screening_request (x_id, return_code, p_ret_msg);
            END IF;
         END IF;
      ELSE
         p_return_code := 'ERROR_CREATING_OWS';
      END IF;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      p_return_code := 'SQLERROR';
      p_ret_msg := SQLERRM || ' ' || location_msg || sub_msg;

      IF get_request_info%ISOPEN
      THEN
         CLOSE get_request_info;
      END IF;

      IF get_wc_matches_ind%ISOPEN
      THEN
         CLOSE get_wc_matches_ind;
      END IF;
END create_ows_generic;

   FUNCTION does_wc_exist (
      p_xref   IN   rmi_ows_common_util.wc_external_xref_rec,
      p_req    IN   rmi_ows_common_util.ows_request_rec
   )
      RETURN BOOLEAN
   IS
      --   CURSOR get_xref
      --   IS
      --      SELECT COUNT (*)
      --        FROM vssl.worldcheck_external_xref xref,
      --             vssl.wc_screening_request req
      --       WHERE xref.source_table = p_xref.source_table
      --         AND xref.source_table_column = p_xref.source_table_column
      --         AND xref.source_table_id = p_xref.source_table_id
      --         AND xref.wc_screening_request_id = req.wc_screening_request_id
      --         AND req.name_screened = p_req.name_screened;
      CURSOR get_xref_ows
      IS
         SELECT COUNT (*)
           FROM vssl.worldcheck_external_xref xref, xwrl_requests req
          WHERE xref.source_table = p_xref.source_table
            AND xref.source_table_column = p_xref.source_table_column
            AND xref.source_table_id = p_xref.source_table_id
            AND xref.wc_screening_request_id = req.ID
            AND req.name_screened = p_req.name_screened
                                                       --         AND case_status != 'C'
      ;

      rec_count    NUMBER  := 0;
      ret_status   BOOLEAN;
   BEGIN
      ret_status := FALSE;

      -- OWS USer
      OPEN get_xref_ows;

      FETCH get_xref_ows
       INTO rec_count;

      CLOSE get_xref_ows;

      IF rec_count > 0
      THEN
         ret_status := TRUE;
      ELSE
         ret_status := FALSE;
      END IF;

      RETURN (ret_status);
   END;

   PROCEDURE query_cross_reference (
      p_source_table    IN       VARCHAR2,
      p_source_column   IN       VARCHAR2,
      p_source_id       IN       NUMBER,
      t_data            IN OUT   screening_tab
   )
   IS
      CURSOR get_screening_ows
      IS
         SELECT   *
             FROM xwrl_party_master r
            WHERE 1 = 1
              AND relationship_type = 'Primary'
              AND status = 'Enabled'
              AND state NOT LIKE '%Delete%'
              AND source_table =
                     DECODE (p_source_table,
                             '***', 'XWRL_PARTY_MASTER',
                             NVL (p_source_table, 'XWRL_PARTY_MASTER')
                            )
              AND source_table_column =
                     DECODE (p_source_column,
                             '***', 'ID',
                             NVL (p_source_column, 'ID')
                            )
              AND source_id =
                     DECODE (p_source_id,
                             '***', source_id,
                             NVL (p_source_id, source_id)
                            )
         ORDER BY r.creation_date DESC;

      CURSOR get_nrmi_ows
      IS
         SELECT   *
             FROM xwrl_party_master r
            WHERE 1 = 1
              AND relationship_type = 'Primary'
              AND status = 'Enabled'
              AND state NOT LIKE '%Delete%'
              AND source_table LIKE 'NRMI%'
              AND source_table_column LIKE 'NRMI%'
              AND source_id = p_source_id
         ORDER BY r.creation_date DESC;

      CURSOR get_cross_references (p_id IN NUMBER)
      IS
         SELECT   b.*, xref.start_date, xref.end_date, xref.master_id,
                  xref.relationship_master_id, xref.ID xref_id,
                  xref.tc_excluded
             FROM xwrl_party_xref xref,
                  (SELECT ID, relationship_type, entity_type, state, status,
                          source_table, source_table_column, source_id,
                          full_name, batch_id, created_by, creation_date,
                          last_update_date, last_updated_by,
                          last_update_login, date_of_birth, family_name,
                          given_name, sex, passport_number,
                          citizenship_country_code,
                          passport_issuing_country_code, country_of_residence,
                          city_of_residence_id, imo_number,
                          wc_screening_request_id
                     FROM xwrl_party_master) b
            WHERE xref.master_id = p_id
              AND xref.relationship_master_id = b.ID
              AND b.status = 'Enabled'
              AND b.state NOT LIKE '%Delete%'
              AND xref.status = 'Enabled'
              AND xref.relationship_master_id <> xref.master_id
              AND TRUNC (SYSDATE) BETWEEN TRUNC (NVL (xref.start_date,
                                                      SYSDATE)
                                                )
                                      AND TRUNC (NVL (xref.end_date, SYSDATE))
         ORDER BY xref.creation_date;

      CURSOR get_aliases (p_id IN NUMBER)
      IS
         SELECT *
           FROM xwrl_party_alias b
          WHERE b.master_id = p_id
            AND b.status = 'Enabled'
            AND TRUNC (SYSDATE) BETWEEN TRUNC (NVL (b.start_date, SYSDATE))
                                    AND TRUNC (NVL (b.end_date, SYSDATE));

      ii   NUMBER := 1;
   BEGIN
      --
      IF p_source_table <> 'NRMI_CERTIFICATES'
      THEN
         ---
         apps.mt_log_error ('Source Table: ' || p_source_table);
         apps.mt_log_error ('Source Column : ' || p_source_column);
         apps.mt_log_error ('Source ID : ' || p_source_id);

         ---
         FOR screening_rec IN get_screening_ows
         LOOP
            t_data (ii).created_by := screening_rec.created_by;
            t_data (ii).creation_date := screening_rec.creation_date;
            t_data (ii).last_updated_by := screening_rec.last_updated_by;
            t_data (ii).last_update_date := screening_rec.last_update_date;
            t_data (ii).last_update_login := screening_rec.last_update_login;
            t_data (ii).relationship_type := screening_rec.relationship_type;
            t_data (ii).entity_type := screening_rec.entity_type;
            t_data (ii).state := screening_rec.state;
            t_data (ii).status := screening_rec.status;
            t_data (ii).source_table := screening_rec.source_table;
            t_data (ii).source_table_column :=
                                            screening_rec.source_table_column;
            t_data (ii).source_id := screening_rec.source_id;
            t_data (ii).full_name := screening_rec.full_name;
            t_data (ii).batch_id := screening_rec.batch_id;
            t_data (ii).start_date := screening_rec.start_date;
            t_data (ii).end_date := screening_rec.end_date;

            IF screening_rec.date_of_birth IS NOT NULL
            THEN
               t_data (ii).date_of_birth :=
                            TO_DATE (screening_rec.date_of_birth, 'YYYYMMDD');
            END IF;

            t_data (ii).family_name := screening_rec.family_name;
            t_data (ii).given_name := screening_rec.given_name;
            t_data (ii).sex := screening_rec.sex;
            t_data (ii).passport_number := screening_rec.passport_number;
            t_data (ii).citizenship_country_code :=
                                        screening_rec.citizenship_country_code;
            t_data (ii).passport_issuing_country_code :=
                                   screening_rec.passport_issuing_country_code;
            t_data (ii).country_of_residence :=
                                            screening_rec.country_of_residence;
            t_data (ii).city_of_residence_id :=
                                            screening_rec.city_of_residence_id;
            ---
            apps.mt_log_error (   'T Data City Id: '
                               || t_data (ii).city_of_residence_id
                              );
            apps.mt_log_error (   'Screening City ID : '
                               || screening_rec.city_of_residence_id
                              );
            ---
            t_data (ii).imo_number := screening_rec.imo_number;
            t_data (ii).tc_excluded := screening_rec.tc_excluded;
            t_data (ii).master_id := screening_rec.ID;
            t_data (ii).alias_id := NULL;
            t_data (ii).xref_id := NULL;
            t_data (ii).wc_screening_request_id :=
                                         screening_rec.wc_screening_request_id;
            ii := ii + 1;

            FOR rec IN get_aliases (screening_rec.ID)
            LOOP
               t_data (ii).created_by := rec.created_by;
               t_data (ii).creation_date := rec.creation_date;
               t_data (ii).last_updated_by := rec.last_updated_by;
               t_data (ii).last_update_date := rec.last_update_date;
               t_data (ii).last_update_login := rec.last_update_login;
               t_data (ii).relationship_type := rec.relationship_type;
               t_data (ii).entity_type := rec.entity_type;
               t_data (ii).state := rec.state;
               t_data (ii).status := rec.status;
               t_data (ii).source_table := screening_rec.source_table;
               t_data (ii).source_table_column :=
                                            screening_rec.source_table_column;
               t_data (ii).source_id := screening_rec.source_id;
               t_data (ii).full_name := rec.full_name;
               t_data (ii).batch_id := rec.batch_id;
               t_data (ii).start_date := rec.start_date;
               t_data (ii).end_date := rec.end_date;

               IF rec.date_of_birth IS NOT NULL
               THEN
                  t_data (ii).date_of_birth :=
                                      TO_DATE (rec.date_of_birth, 'YYYYMMDD');
               END IF;

               t_data (ii).family_name := rec.family_name;
               t_data (ii).given_name := rec.given_name;
               t_data (ii).sex := rec.sex;
               t_data (ii).passport_number := rec.passport_number;
               t_data (ii).citizenship_country_code :=
                                                  rec.citizenship_country_code;
               t_data (ii).passport_issuing_country_code :=
                                             rec.passport_issuing_country_code;
               t_data (ii).country_of_residence := rec.country_of_residence;
               t_data (ii).city_of_residence_id := rec.city_of_residence_id;
               t_data (ii).imo_number := rec.imo_number;
               t_data (ii).tc_excluded := rec.tc_excluded;
               t_data (ii).master_id := rec.master_id;
               t_data (ii).alias_id := rec.ID;
               t_data (ii).xref_id := NULL;
               t_data (ii).wc_screening_request_id :=
                                                   rec.wc_screening_request_id;
               ii := ii + 1;
            END LOOP;

            FOR rec IN get_cross_references (screening_rec.ID)
            LOOP
               t_data (ii).created_by := rec.created_by;
               t_data (ii).creation_date := rec.creation_date;
               t_data (ii).last_updated_by := rec.last_updated_by;
               t_data (ii).last_update_date := rec.last_update_date;
               t_data (ii).last_update_login := rec.last_update_login;
               t_data (ii).relationship_type := rec.relationship_type;
               t_data (ii).entity_type := rec.entity_type;
               t_data (ii).state := rec.state;
               t_data (ii).status := rec.status;
               t_data (ii).source_table := rec.source_table;
               t_data (ii).source_table_column := rec.source_table_column;
               t_data (ii).source_id := rec.source_id;
               t_data (ii).full_name := rec.full_name;
               t_data (ii).batch_id := rec.batch_id;
               t_data (ii).start_date := rec.start_date;
               t_data (ii).end_date := rec.end_date;

               IF rec.date_of_birth IS NOT NULL
               THEN
                  t_data (ii).date_of_birth :=
                                      TO_DATE (rec.date_of_birth, 'YYYYMMDD');
               END IF;

               t_data (ii).family_name := rec.family_name;
               t_data (ii).given_name := rec.given_name;
               t_data (ii).sex := rec.sex;
               t_data (ii).passport_number := rec.passport_number;
               t_data (ii).citizenship_country_code :=
                                                  rec.citizenship_country_code;
               t_data (ii).passport_issuing_country_code :=
                                             rec.passport_issuing_country_code;
               t_data (ii).country_of_residence := rec.country_of_residence;
               t_data (ii).city_of_residence_id := rec.city_of_residence_id;
               t_data (ii).imo_number := rec.imo_number;
               t_data (ii).tc_excluded := rec.tc_excluded;
               t_data (ii).master_id := rec.master_id;
               t_data (ii).alias_id := NULL;
               t_data (ii).xref_id := rec.xref_id;
               t_data (ii).wc_screening_request_id :=
                                                   rec.wc_screening_request_id;
               ii := ii + 1;

               FOR rec1 IN get_aliases (rec.ID)
               LOOP
                  t_data (ii).created_by := rec1.created_by;
                  t_data (ii).creation_date := rec1.creation_date;
                  t_data (ii).last_updated_by := rec1.last_updated_by;
                  t_data (ii).last_update_date := rec1.last_update_date;
                  t_data (ii).last_update_login := rec1.last_update_login;
                  t_data (ii).relationship_type := rec1.relationship_type;
                  t_data (ii).entity_type := rec1.entity_type;
                  t_data (ii).state := rec1.state;
                  t_data (ii).status := rec1.status;
                  t_data (ii).source_table := rec.source_table;
                  t_data (ii).source_table_column := rec.source_table_column;
                  t_data (ii).source_id := rec.source_id;
                  t_data (ii).full_name := rec1.full_name;
                  t_data (ii).batch_id := rec1.batch_id;
                  t_data (ii).start_date := rec1.start_date;
                  t_data (ii).end_date := rec1.end_date;

                  IF rec1.date_of_birth IS NOT NULL
                  THEN
                     t_data (ii).date_of_birth :=
                                     TO_DATE (rec1.date_of_birth, 'YYYYMMDD');
                  END IF;

                  t_data (ii).family_name := rec1.family_name;
                  t_data (ii).given_name := rec1.given_name;
                  t_data (ii).sex := rec1.sex;
                  t_data (ii).passport_number := rec1.passport_number;
                  t_data (ii).citizenship_country_code :=
                                                 rec1.citizenship_country_code;
                  t_data (ii).passport_issuing_country_code :=
                                            rec1.passport_issuing_country_code;
                  t_data (ii).country_of_residence :=
                                                     rec1.country_of_residence;
                  t_data (ii).city_of_residence_id :=
                                                     rec1.city_of_residence_id;
                  t_data (ii).imo_number := rec1.imo_number;
                  t_data (ii).tc_excluded := rec1.tc_excluded;
                  t_data (ii).master_id := rec1.master_id;
                  t_data (ii).alias_id := rec1.ID;
                  t_data (ii).xref_id := NULL;
                  t_data (ii).wc_screening_request_id :=
                                                  rec1.wc_screening_request_id;
                  ii := ii + 1;
               END LOOP;
            END LOOP;
         END LOOP;
      ELSE
         -- NRMI Code
         FOR screening_rec IN get_nrmi_ows
         LOOP
            t_data (ii).created_by := screening_rec.created_by;
            t_data (ii).creation_date := screening_rec.creation_date;
            t_data (ii).last_updated_by := screening_rec.last_updated_by;
            t_data (ii).last_update_date := screening_rec.last_update_date;
            t_data (ii).last_update_login := screening_rec.last_update_login;
            t_data (ii).relationship_type := screening_rec.relationship_type;
            t_data (ii).entity_type := screening_rec.entity_type;
            t_data (ii).state := screening_rec.state;
            t_data (ii).status := screening_rec.status;
            t_data (ii).source_table := screening_rec.source_table;
            t_data (ii).source_table_column :=
                                            screening_rec.source_table_column;
            t_data (ii).source_id := screening_rec.source_id;
            t_data (ii).full_name := screening_rec.full_name;
            t_data (ii).batch_id := screening_rec.batch_id;
            t_data (ii).start_date := screening_rec.start_date;
            t_data (ii).end_date := screening_rec.end_date;

            IF screening_rec.date_of_birth IS NOT NULL
            THEN
               t_data (ii).date_of_birth :=
                            TO_DATE (screening_rec.date_of_birth, 'YYYYMMDD');
            END IF;

            t_data (ii).family_name := screening_rec.family_name;
            t_data (ii).given_name := screening_rec.given_name;
            t_data (ii).sex := screening_rec.sex;
            t_data (ii).passport_number := screening_rec.passport_number;
            t_data (ii).citizenship_country_code :=
                                        screening_rec.citizenship_country_code;
            t_data (ii).passport_issuing_country_code :=
                                   screening_rec.passport_issuing_country_code;
            t_data (ii).country_of_residence :=
                                            screening_rec.country_of_residence;
            t_data (ii).city_of_residence_id :=
                                            screening_rec.city_of_residence_id;
            t_data (ii).imo_number := screening_rec.imo_number;
            t_data (ii).department := 'VESDOC';
            t_data (ii).master_id := screening_rec.ID;
            t_data (ii).alias_id := NULL;
            t_data (ii).xref_id := NULL;
            t_data (ii).wc_screening_request_id :=
                                         screening_rec.wc_screening_request_id;
            ii := ii + 1;

            FOR rec IN get_aliases (screening_rec.ID)
            LOOP
               t_data (ii).created_by := rec.created_by;
               t_data (ii).creation_date := rec.creation_date;
               t_data (ii).last_updated_by := rec.last_updated_by;
               t_data (ii).last_update_date := rec.last_update_date;
               t_data (ii).last_update_login := rec.last_update_login;
               t_data (ii).relationship_type := rec.relationship_type;
               t_data (ii).entity_type := rec.entity_type;
               t_data (ii).state := rec.state;
               t_data (ii).status := rec.status;
               t_data (ii).source_table := screening_rec.source_table;
               t_data (ii).source_table_column :=
                                            screening_rec.source_table_column;
               t_data (ii).source_id := screening_rec.source_id;
               t_data (ii).full_name := rec.full_name;
               t_data (ii).batch_id := screening_rec.batch_id;
               t_data (ii).start_date := rec.start_date;
               t_data (ii).end_date := rec.end_date;

               IF rec.date_of_birth IS NOT NULL
               THEN
                  t_data (ii).date_of_birth :=
                                      TO_DATE (rec.date_of_birth, 'YYYYMMDD');
               END IF;

               t_data (ii).family_name := rec.family_name;
               t_data (ii).given_name := rec.given_name;
               t_data (ii).sex := rec.sex;
               t_data (ii).passport_number := rec.passport_number;
               t_data (ii).citizenship_country_code :=
                                                  rec.citizenship_country_code;
               t_data (ii).passport_issuing_country_code :=
                                             rec.passport_issuing_country_code;
               t_data (ii).country_of_residence := rec.country_of_residence;
               t_data (ii).city_of_residence_id := rec.city_of_residence_id;
               t_data (ii).imo_number := rec.imo_number;
               t_data (ii).department := 'VESDOC';
               t_data (ii).master_id := rec.master_id;
               t_data (ii).alias_id := rec.ID;
               t_data (ii).xref_id := NULL;
               t_data (ii).wc_screening_request_id :=
                                                   rec.wc_screening_request_id;
               ii := ii + 1;
            END LOOP;

            FOR rec IN get_cross_references (screening_rec.ID)
            LOOP
               t_data (ii).created_by := rec.created_by;
               t_data (ii).creation_date := rec.creation_date;
               t_data (ii).last_updated_by := rec.last_updated_by;
               t_data (ii).last_update_date := rec.last_update_date;
               t_data (ii).last_update_login := rec.last_update_login;
               t_data (ii).relationship_type := rec.relationship_type;
               t_data (ii).entity_type := rec.entity_type;
               t_data (ii).state := rec.state;
               t_data (ii).status := rec.status;
               t_data (ii).source_table := rec.source_table;
               t_data (ii).source_table_column := rec.source_table_column;
               t_data (ii).source_id := rec.source_id;
               t_data (ii).full_name := rec.full_name;
               t_data (ii).batch_id := rec.batch_id;
               t_data (ii).start_date := rec.start_date;
               t_data (ii).end_date := rec.end_date;

               IF rec.date_of_birth IS NOT NULL
               THEN
                  t_data (ii).date_of_birth :=
                                      TO_DATE (rec.date_of_birth, 'YYYYMMDD');
               END IF;

               t_data (ii).family_name := rec.family_name;
               t_data (ii).given_name := rec.given_name;
               t_data (ii).sex := rec.sex;
               t_data (ii).passport_number := rec.passport_number;
               t_data (ii).citizenship_country_code :=
                                                  rec.citizenship_country_code;
               t_data (ii).passport_issuing_country_code :=
                                             rec.passport_issuing_country_code;
               t_data (ii).country_of_residence := rec.country_of_residence;
               t_data (ii).city_of_residence_id := rec.city_of_residence_id;
               t_data (ii).imo_number := rec.imo_number;
               t_data (ii).department := 'VESDOC';
               t_data (ii).master_id := rec.master_id;
               t_data (ii).alias_id := NULL;
               t_data (ii).xref_id := rec.xref_id;
               t_data (ii).wc_screening_request_id :=
                                                   rec.wc_screening_request_id;
               ii := ii + 1;

               FOR rec1 IN get_aliases (rec.ID)
               LOOP
                  t_data (ii).created_by := rec1.created_by;
                  t_data (ii).creation_date := rec1.creation_date;
                  t_data (ii).last_updated_by := rec1.last_updated_by;
                  t_data (ii).last_update_date := rec1.last_update_date;
                  t_data (ii).last_update_login := rec1.last_update_login;
                  t_data (ii).relationship_type := rec1.relationship_type;
                  t_data (ii).entity_type := rec1.entity_type;
                  t_data (ii).state := rec1.state;
                  t_data (ii).status := rec1.status;
                  t_data (ii).source_table := rec.source_table;
                  t_data (ii).source_table_column := rec.source_table_column;
                  t_data (ii).source_id := rec.source_id;
                  t_data (ii).full_name := rec1.full_name;
                  t_data (ii).batch_id := rec.batch_id;
                  t_data (ii).start_date := rec1.start_date;
                  t_data (ii).end_date := rec1.end_date;

                  IF rec1.date_of_birth IS NOT NULL
                  THEN
                     t_data (ii).date_of_birth :=
                                     TO_DATE (rec1.date_of_birth, 'YYYYMMDD');
                  END IF;

                  t_data (ii).family_name := rec1.family_name;
                  t_data (ii).given_name := rec1.given_name;
                  t_data (ii).sex := rec1.sex;
                  t_data (ii).passport_number := rec1.passport_number;
                  t_data (ii).citizenship_country_code :=
                                                 rec1.citizenship_country_code;
                  t_data (ii).passport_issuing_country_code :=
                                            rec1.passport_issuing_country_code;
                  t_data (ii).country_of_residence :=
                                                     rec1.country_of_residence;
                  t_data (ii).city_of_residence_id :=
                                                     rec1.city_of_residence_id;
                  t_data (ii).imo_number := rec1.imo_number;
                  t_data (ii).department := 'VESDOC';
                  t_data (ii).master_id := rec1.master_id;
                  t_data (ii).alias_id := rec1.ID;
                  t_data (ii).xref_id := NULL;
                  t_data (ii).wc_screening_request_id :=
                                                  rec1.wc_screening_request_id;
                  ii := ii + 1;
               END LOOP;
            END LOOP;
         END LOOP;
      END IF;
   END;

   FUNCTION get_id_request_values (p_id IN NUMBER, p_attr_name IN VARCHAR2)
      RETURN VARCHAR2
   IS
      CURSOR cur_data
      IS
         SELECT VALUE
           FROM xwrl_request_rows
          WHERE 1 = 1 AND request_id = p_id AND KEY = p_attr_name;

      l_value   VARCHAR2 (100);
   BEGIN
      OPEN cur_data;

      FETCH cur_data
       INTO l_value;

      CLOSE cur_data;

      RETURN l_value;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   FUNCTION is_city_crimean (p_city_list_id IN NUMBER)
      RETURN VARCHAR2
   IS
      CURSOR cur_city_check (p_city_id IN NUMBER)
      IS
         SELECT 'Y'
           FROM wc_city_list city
          WHERE wc_city_list_id = p_city_list_id
            AND city.status = 'TC_VERIFY'
            AND country_code IN ('UKRA', 'RUSS');

      is_crimean   VARCHAR2 (1) := 'N';
   BEGIN
      IF p_city_list_id IS NOT NULL
      THEN
         OPEN cur_city_check (p_city_list_id);

         FETCH cur_city_check
          INTO is_crimean;

         CLOSE cur_city_check;
      END IF;

      RETURN is_crimean;
   END is_city_crimean;

   FUNCTION get_sanction_status (p_iso_country IN VARCHAR2)
      RETURN VARCHAR2
   IS
      l_sanction_status   VARCHAR2 (25);

      CURSOR cur_sanction
      IS
         SELECT UPPER (sanction_status)
           FROM sicd_countries
          WHERE iso_alpha2_code = p_iso_country AND status = 'Active';
   BEGIN
      OPEN cur_sanction;

      FETCH cur_sanction
       INTO l_sanction_status;

      CLOSE cur_sanction;

      RETURN l_sanction_status;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 'NONE';
   END get_sanction_status;

   FUNCTION wc_locked (p_id IN NUMBER)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN 'N';
   END;

   FUNCTION is_blocklisted (p_name IN VARCHAR2)
      RETURN VARCHAR2
   IS
      l_return   VARCHAR2 (1) := 'N';
   BEGIN
      IF p_name IS NOT NULL
      THEN
         SELECT 'Y'
           INTO l_return
           FROM vssl.rmi_tc_entities_on_blocklist
          WHERE TRIM (UPPER (entity_name)) = TRIM (UPPER (p_name))
            AND enabled_flag = 'Y';
      END IF;

      RETURN l_return;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 'N';
   END is_blocklisted;

   FUNCTION get_batch_id (p_source_table IN VARCHAR2, p_source_id IN NUMBER)
      RETURN NUMBER
   IS
      CURSOR cur_batch
      IS
         SELECT MAX (batch_id)
           FROM xwrl_requests
          WHERE source_id = p_source_id
            AND source_table = p_source_table
            AND case_status = 'O'
            AND batch_id IS NOT NULL
            AND case_state NOT IN ('D', 'E');

      CURSOR cur_batch_nrmi
      IS
         SELECT MAX (batch_id)
           FROM xwrl_requests
          WHERE source_id = p_source_id
            AND source_table LIKE 'NRMI%'
            AND case_status = 'O'
            AND batch_id IS NOT NULL
            AND case_state NOT IN ('D', 'E');

      l_batch_id   NUMBER;
   BEGIN
      IF p_source_table != 'NRMI_CERTIFICATES'
      THEN
         OPEN cur_batch;

         FETCH cur_batch
          INTO l_batch_id;

         CLOSE cur_batch;
      ELSE
         OPEN cur_batch_nrmi;

         FETCH cur_batch_nrmi
          INTO l_batch_id;

         CLOSE cur_batch_nrmi;
      END IF;

      RETURN l_batch_id;
   END get_batch_id;

   FUNCTION get_last_batch_id (
      p_source_table   IN   VARCHAR2,
      p_source_id      IN   NUMBER
   )
      RETURN NUMBER
   IS
      CURSOR cur_batch
      IS
         SELECT MAX (batch_id)
           FROM xwrl_requests
          WHERE source_id = p_source_id
            AND source_table = p_source_table
            --            AND case_status = 'O'
            AND batch_id IS NOT NULL
            AND case_state NOT IN ('D', 'E');

      CURSOR cur_batch_nrmi
      IS
         SELECT MAX (batch_id)
           FROM xwrl_requests
          WHERE source_id = p_source_id
            AND source_table LIKE 'NRMI%'
            --            AND case_status = 'O'
            AND batch_id IS NOT NULL
            AND case_state NOT IN ('D', 'E');

      l_batch_id   NUMBER;
   BEGIN
      IF p_source_table != 'NRMI_CERTIFICATES'
      THEN
         OPEN cur_batch;

         FETCH cur_batch
          INTO l_batch_id;

         CLOSE cur_batch;
      ELSE
         OPEN cur_batch_nrmi;

         FETCH cur_batch_nrmi
          INTO l_batch_id;

         CLOSE cur_batch_nrmi;
      END IF;

      RETURN l_batch_id;
   END get_last_batch_id;

   FUNCTION get_prev_batch_id (
      p_source_table   IN   VARCHAR2,
      p_source_id      IN   NUMBER
   )
      RETURN NUMBER
   IS
      CURSOR cur_batch
      IS
         SELECT MAX (batch_id)
           FROM xwrl_requests
          WHERE source_id = p_source_id
            AND source_table = p_source_table
            --            AND case_status = 'O'
            AND batch_id IS NOT NULL
            AND case_state NOT IN ('D', 'E');

      CURSOR cur_batch_nrmi
      IS
         SELECT MAX (batch_id)
           FROM xwrl_requests
          WHERE source_id = p_source_id
            AND source_table LIKE 'NRMI%'
            --            AND case_status = 'O'
            AND batch_id IS NOT NULL
            AND case_state NOT IN ('D', 'E');

      l_batch_id   NUMBER;
   BEGIN
      IF p_source_table != 'NRMI_CERTIFICATES'
      THEN
         OPEN cur_batch;

         FETCH cur_batch
          INTO l_batch_id;

         CLOSE cur_batch;
      ELSE
         OPEN cur_batch_nrmi;

         FETCH cur_batch_nrmi
          INTO l_batch_id;

         CLOSE cur_batch_nrmi;
      END IF;

      RETURN l_batch_id;
   END get_prev_batch_id;

   PROCEDURE create_batch_vetting (
      p_source_table          IN       VARCHAR2,
      p_source_table_column   IN       VARCHAR2,
      p_source_id             IN       NUMBER,
      x_batch_id              OUT      NUMBER,
      x_return_status         OUT      VARCHAR2,
      x_return_msg            OUT      VARCHAR2
   )
   IS
      entity_data        rmi_ows_common_util.screening_tab;
      l_req              rmi_ows_common_util.ows_request_rec;
      l_id               NUMBER;
      x_return_code      VARCHAR2 (100);
      x_retrun_msg       VARCHAR2 (500);
      l_batch_id         NUMBER;
      v_pause            INTEGER                             := 0;
      -- 2019112 tsuazo Add pause between OWS requests
      l_user_id          NUMBER              := fnd_profile.VALUE ('USER_ID');
      l_login_id         NUMBER             := fnd_profile.VALUE ('LOGIN_ID');
      l_new_batch        VARCHAR2 (1)                        := 'N';
      l_username         VARCHAR2 (100)     := fnd_profile.VALUE ('USERNAME');
      --- Added By Gopi Vella
      l_prev_batch_id    NUMBER;
      l_doc_rec          xwrl_case_documents%ROWTYPE;
      l_note_rec         xwrl_case_notes%ROWTYPE;
      l_alert_note_rec   xwrl_alert_notes%ROWTYPE;
      l_doc_id           NUMBER;
      l_note_id          NUMBER;
      l_case_id          VARCHAR2 (50);
      l_request_id       NUMBER;
      x_id               NUMBER;
   --- End Code Change
   BEGIN
      BEGIN
         SELECT xwrl_utils.get_ebs_pause "EBS_Pause_Time"
           INTO v_pause
           FROM DUAL;
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      DBMS_OUTPUT.put_line ('Start');
      -- Fetch all related entities into table type variable
      rmi_ows_common_util.query_cross_reference (p_source_table,
                                                 p_source_table_column,
                                                 p_source_id,
                                                 entity_data
                                                );
      DBMS_OUTPUT.put_line ('Total Reference Count ' || entity_data.COUNT);

      IF entity_data.COUNT = 0
      THEN
         insert_party_master (p_source_table,
                              p_source_table_column,
                              p_source_id,
                              x_id
                             );
         COMMIT;
      END IF;

      --
      -- check if any entity has batch id not assigned to it
      FOR i IN 1 .. entity_data.COUNT
      LOOP
         --
         DBMS_OUTPUT.put_line ('Ref Name:' || (i)
                               || entity_data (i).full_name);
         DBMS_OUTPUT.put_line ('Ref Batch:' || (i)
                               || entity_data (i).batch_id);

         IF entity_data (i).batch_id IS NULL
         THEN
            l_new_batch := 'Y';
            EXIT;
         END IF;

         DBMS_OUTPUT.put_line ('New Batch? ' || l_new_batch);
      --
      END LOOP;

      -- get last open batch details
      l_batch_id :=
                rmi_ows_common_util.get_batch_id (p_source_table, p_source_id);
      --rmi_ows_common_util.get_prev_batch_id (p_source_table, p_source_id);
      --- Added By Gopi Vella.
      --      BEGIN
      --         SELECT MAX (batch_id)
      --           INTO l_prev_batch_id
      --           FROM xwrl_requests
      --          WHERE source_id = p_source_id
      --            AND source_table = p_source_table
      --            AND batch_id IS NOT NULL
      --            AND case_state NOT IN ('E');

      --         apps.mt_log_error ('Previous Batch ID: ' || l_prev_batch_id);
      --         COMMIT;
      --      EXCEPTION
      --         WHEN OTHERS
      --         THEN
      --            l_prev_batch_id := NULL;
      --            apps.mt_log_error
      --                      (   'Error Occurred While Deriving Previous Batch ID: '
      --                       || SQLERRM
      --                      );
      --            COMMIT;
      --      END;

      -- T20191218.0037 SAURABH 13-JAN-2020
      l_prev_batch_id :=
           rmi_ows_common_util.get_prev_batch_id (p_source_table, p_source_id);
      --l_prev_batch_id := l_batch_id;

      --- End Code Change
      DBMS_OUTPUT.put_line ('Existing Batch ID ' || l_batch_id);

      -- Match Old batch with New Batch

      -- Close and Delete Batch if new batch is needed
      IF l_new_batch = 'Y' AND l_batch_id IS NOT NULL
      THEN
         --
         -- Close ALerts
         FOR rec IN (SELECT ID, case_id
                       FROM xwrl_requests
                      WHERE batch_id = l_batch_id AND case_status <> 'C')
         LOOP
            close_ows_case (p_user_name       => l_username,
                            p_case_id         => rec.case_id,
                            p_request_id      => rec.ID
                           );
            DBMS_OUTPUT.put_line ('Case ID ' || rec.case_id);
         END LOOP;

         --
         UPDATE xwrl_requests
            SET case_state = 'D',
                case_status = 'C',
                last_update_date = SYSDATE,
                last_updated_by = l_user_id,
                last_update_login = l_login_id
          WHERE 1 = 1 AND batch_id = l_batch_id;

         DBMS_OUTPUT.put_line (   'Batch Updated '
                               || l_batch_id
                               || ' '
                               || SQL%ROWCOUNT
                              );
         COMMIT;
      ELSIF l_batch_id IS NULL
      THEN
         l_new_batch := 'Y';
      END IF;

      --
      IF l_new_batch = 'Y' AND entity_data.COUNT > 0
      THEN
         SELECT xwrl_batch_seq.NEXTVAL
           INTO l_batch_id
           FROM DUAL;

         -- Loop through each entity and create OWS vetting
         FOR i IN 1 .. entity_data.COUNT
         LOOP
            IF NVL (entity_data (i).tc_excluded, 'N') != 'Y'
            THEN
               l_id := NULL;
               x_return_code := 'SUCCESS';
               x_retrun_msg := NULL;
               l_req := NULL;
               -- assign vetting variables
               l_req.batch_id := l_batch_id;

               IF entity_data (i).entity_type = 'INDIVIDUAL'
               THEN
                  l_req.entity_type := 'INDIVIDUAL';
                  l_req.source_table := entity_data (i).source_table;
                  l_req.source_table_column :=
                                          entity_data (i).source_table_column;
                  l_req.source_id := entity_data (i).source_id;
                  l_req.city_id := entity_data (i).city_of_residence_id;
                  --
                  apps.mt_log_error (   'Entity Data City ID: '
                                     || entity_data (i).city_of_residence_id
                                    );
                  apps.mt_log_error (   'City ID Sent For Screening: '
                                     || l_req.city_id
                                    );
                  --
                  l_req.name_screened := entity_data (i).full_name;
                  l_req.full_name := entity_data (i).full_name;
                  l_req.last_name := entity_data (i).family_name;
                  l_req.first_name := entity_data (i).given_name;
                  l_req.gender := entity_data (i).sex;
                  l_req.date_of_birth := entity_data (i).date_of_birth;
                  l_req.residence_country_code :=
                     get_country_iso_code (entity_data (i).country_of_residence
                                          );
                  l_req.nationality :=
                     get_country_iso_code
                                      (entity_data (i).citizenship_country_code
                                      );
                  l_req.passport_issuing_country_code :=
                     get_country_iso_code
                                 (entity_data (i).passport_issuing_country_code
                                 );
                  l_req.passport_number := entity_data (i).passport_number;
                  l_req.master_id := entity_data (i).master_id;
                  l_req.alias_id := entity_data (i).alias_id;
                  l_req.xref_id := entity_data (i).xref_id;
                  l_req.wc_screening_request_id :=
                                       entity_data (i).wc_screening_request_id;
                  l_req.department := entity_data (i).department;
                  l_req.priority := entity_data (i).priority;
                  l_req.document_type := entity_data (i).document_type;
               ELSIF entity_data (i).entity_type = 'ORGANISATION'
               THEN
                  l_req.entity_type := 'ENTITY';
                  l_req.source_table := entity_data (i).source_table;
                  l_req.source_table_column :=
                                          entity_data (i).source_table_column;
                  l_req.source_id := entity_data (i).source_id;
                  l_req.entity_name := entity_data (i).full_name;
                  l_req.master_id := entity_data (i).master_id;
                  l_req.alias_id := entity_data (i).alias_id;
                  l_req.xref_id := entity_data (i).xref_id;
                  l_req.wc_screening_request_id :=
                                      entity_data (i).wc_screening_request_id;
                  l_req.department := entity_data (i).department;
                  l_req.priority := entity_data (i).priority;
                  l_req.document_type := entity_data (i).document_type;
               ELSIF entity_data (i).entity_type = 'VESSEL'
               THEN
                  l_req.entity_type := 'ENTITY';
                  l_req.source_table := entity_data (i).source_table;
                  l_req.source_table_column :=
                                          entity_data (i).source_table_column;
                  l_req.source_id := entity_data (i).source_id;
                  l_req.entity_name := entity_data (i).full_name;
                  l_req.registrationnumber := entity_data (i).imo_number;
                  l_req.vessel_indicator := 'Y';
                  l_req.master_id := entity_data (i).master_id;
                  l_req.alias_id := entity_data (i).alias_id;
                  l_req.xref_id := entity_data (i).xref_id;
                  l_req.wc_screening_request_id :=
                                      entity_data (i).wc_screening_request_id;
                  l_req.department := entity_data (i).department;
                  l_req.priority := entity_data (i).priority;
                  l_req.document_type := entity_data (i).document_type;
               END IF;

               -- call OWS API to generate request
               create_ows_generic (p_req              => l_req,
                                   p_custom_id1       => NULL,
                                   p_custom_id2       => NULL,
                                   p_return_code      => x_return_code,
                                   p_ret_msg          => x_retrun_msg,
                                   x_id               => l_id
                                  );
            END IF;

            IF x_return_code = 'SUCCESS'
            THEN
               -- Copy Old notes and Document in new batch
               --
               IF entity_data (i).batch_id <> NVL (l_prev_batch_id, -99)
               THEN
                  FOR r_request_rec IN
                     (SELECT ID, name_screened, master_id, alias_id
                        FROM xwrl_requests
                       WHERE batch_id = entity_data (i).batch_id
                         AND master_id =
                                (SELECT relationship_master_id
                                   FROM xwrl_party_xref
                                  WHERE ID = entity_data (i).xref_id
                                    AND NVL (start_date, SYSDATE) <= SYSDATE
                                    AND NVL (end_date, SYSDATE) >= SYSDATE)
                         AND NVL (alias_id, -99) =
                                            NVL (entity_data (i).alias_id,
                                                 -99)
                         AND xref_id IS NULL)
                  LOOP
                     apps.mt_log_error (   'Name Screened: '
                                        || r_request_rec.name_screened
                                        || ' Id: '
                                        || r_request_rec.ID
                                       );
                     COMMIT;

                     FOR r_doc_rec IN (SELECT xc.*
                                         FROM xwrl_case_documents xc
                                        WHERE 1 = 1
                                          AND xc.request_id = r_request_rec.ID)
                     LOOP
                        l_doc_rec := NULL;
                        l_case_id := NULL;
                        l_request_id := NULL;
                        l_doc_rec := r_doc_rec;

                        BEGIN
                           SELECT xwrl_case_documents_seq.NEXTVAL
                             INTO l_doc_id
                             FROM DUAL;
                        EXCEPTION
                           WHEN OTHERS
                           THEN
                              l_doc_id := NULL;
                        END;

                        apps.mt_log_error (   'Batch ID: '
                                           || l_batch_id
                                           || ' Name Screened: '
                                           || r_request_rec.name_screened
                                          );
                        COMMIT;

                        BEGIN
                           SELECT case_id, ID
                             INTO l_case_id, l_request_id
                             FROM xwrl_requests
                            WHERE batch_id = l_batch_id
                              AND master_id = entity_data (i).master_id
                              AND NVL (alias_id, -99) =
                                              NVL (r_request_rec.alias_id,
                                                   -99)
                              AND xref_id =
                                     (SELECT ID
                                        FROM xwrl_party_xref
                                       WHERE master_id =
                                                     entity_data (i).master_id
                                         AND relationship_master_id =
                                                       r_request_rec.master_id);
                        EXCEPTION
                           WHEN OTHERS
                           THEN
                              apps.mt_log_error
                                 (   'Exception While Fetching Case Details: '
                                  || SQLERRM
                                 );
                              COMMIT;
                              l_case_id := NULL;
                              l_request_id := NULL;
                        END;

                        apps.mt_log_error (   'Case ID: '
                                           || l_case_id
                                           || ' Request ID: '
                                           || l_request_id
                                          );
                        COMMIT;

                        IF l_case_id IS NOT NULL AND l_request_id IS NOT NULL
                        THEN
                           l_doc_rec.ID := l_doc_id;
                           l_doc_rec.case_id := l_case_id;
                           l_doc_rec.request_id := l_request_id;
                           apps.mt_log_error ('Inserting Into Case Documents');
                           COMMIT;

                           INSERT INTO xwrl_case_documents
                                VALUES l_doc_rec;

                           COMMIT;
                        END IF;
                     END LOOP;

                     FOR r_note_rec IN (SELECT xc.*
                                          FROM xwrl_case_notes xc
                                         WHERE 1 = 1
                                           AND xc.request_id =
                                                              r_request_rec.ID)
                     LOOP
                        l_note_rec := NULL;
                        l_case_id := NULL;
                        l_request_id := NULL;
                        l_note_rec := r_note_rec;

                        BEGIN
                           SELECT xwrl_case_notes_seq.NEXTVAL
                             INTO l_note_id
                             FROM DUAL;
                        EXCEPTION
                           WHEN OTHERS
                           THEN
                              l_note_id := NULL;
                        END;

                        apps.mt_log_error (   'Batch ID: '
                                           || l_batch_id
                                           || ' Name Screened: '
                                           || r_request_rec.name_screened
                                          );
                        COMMIT;

                        BEGIN
                           SELECT case_id, ID
                             INTO l_case_id, l_request_id
                             FROM xwrl_requests
                            WHERE batch_id = l_batch_id
                              AND master_id = entity_data (i).master_id
                              AND NVL (alias_id, -99) =
                                              NVL (r_request_rec.alias_id,
                                                   -99)
                              AND xref_id =
                                     (SELECT ID
                                        FROM xwrl_party_xref
                                       WHERE master_id =
                                                     entity_data (i).master_id
                                         AND relationship_master_id =
                                                       r_request_rec.master_id);
                        EXCEPTION
                           WHEN OTHERS
                           THEN
                              apps.mt_log_error
                                 (   'Exception While Fetching Case Details: '
                                  || SQLERRM
                                 );
                              COMMIT;
                              l_case_id := NULL;
                              l_request_id := NULL;
                        END;

                        apps.mt_log_error (   'Case ID: '
                                           || l_case_id
                                           || ' Request ID: '
                                           || l_request_id
                                          );
                        COMMIT;

                        IF l_case_id IS NOT NULL AND l_request_id IS NOT NULL
                        THEN
                           l_note_rec.ID := l_note_id;
                           l_note_rec.case_id := l_case_id;
                           l_note_rec.request_id := l_request_id;
                           apps.mt_log_error ('Inserting Into Case Documents');
                           COMMIT;

                           INSERT INTO xwrl_case_notes
                                VALUES l_note_rec;

                           COMMIT;
                        END IF;
                     END LOOP;
                  END LOOP;
               END IF;

               -- Update Batch ID
               IF entity_data (i).relationship_type = 'Alias'
               THEN
                  UPDATE xwrl_party_alias
                     SET batch_id = l_batch_id,
                         last_update_date = SYSDATE,
                         last_updated_by = l_user_id,
                         last_update_login = l_login_id
                   WHERE ID = entity_data (i).alias_id
                     AND NVL (tc_excluded, 'N') != 'Y';
               ELSE
                  IF entity_data (i).xref_id IS NULL
                  THEN
                     UPDATE xwrl_party_master
                        SET batch_id = l_batch_id,
                            last_update_date = SYSDATE,
                            last_updated_by = l_user_id,
                            last_update_login = l_login_id
                      WHERE ID = entity_data (i).master_id
                        AND NVL (tc_excluded, 'N') != 'Y';
                  ELSE
                     UPDATE xwrl_party_xref
                        SET last_update_date = SYSDATE,
                            last_updated_by = l_user_id,
                            last_update_login = l_login_id
                      WHERE ID = entity_data (i).xref_id
                        AND NVL (tc_excluded, 'N') != 'Y';

                     UPDATE xwrl_party_master
                        SET batch_id = l_batch_id,
                            last_update_date = SYSDATE,
                            last_updated_by = l_user_id,
                            last_update_login = l_login_id
                      WHERE ID =
                               (SELECT relationship_master_id
                                  FROM xwrl_party_xref
                                 WHERE ID = entity_data (i).xref_id
                                   AND NVL (tc_excluded, 'N') != 'Y');
                  END IF;
               END IF;

               COMMIT;
            END IF;

            DBMS_LOCK.sleep (v_pause);
         -- 2019112 tsuazo Add pause between OWS requests
         END LOOP;

         --- Added By Gopi Vella To Sync The Case Documents
         apps.mt_log_error (   'Copy Case Documents Previous Batch ID: '
                            || l_prev_batch_id
                           );
         COMMIT;

         FOR r_request_rec IN (SELECT --* SAURABH Remove *
                                      name_screened, id, xref_id, alias_id, master_id
                                 FROM xwrl_requests
                                WHERE batch_id = l_prev_batch_id)
         LOOP

            apps.mt_log_error (   'Name Screened: '
                               || r_request_rec.name_screened
                               || ' Id: '
                               || r_request_rec.ID
                              );
            COMMIT;

            FOR r_doc_rec IN (SELECT xc.*
                                FROM xwrl_case_documents xc, xwrl_requests xr
                               WHERE 1 = 1
                                 AND xc.request_id = xr.ID
                                 AND xr.batch_id = l_prev_batch_id
                                 AND xr.name_screened =
                                                   r_request_rec.name_screened)
            LOOP
               l_doc_rec := NULL;
               l_case_id := NULL;
               l_request_id := NULL;
               l_doc_rec := r_doc_rec;

               BEGIN
                  SELECT xwrl_case_documents_seq.NEXTVAL
                    INTO l_doc_id
                    FROM DUAL;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_doc_id := NULL;
               END;

               apps.mt_log_error (   'Batch ID: '
                                  || l_batch_id
                                  || ' Name Screened: '
                                  || r_request_rec.name_screened
                                 );
               COMMIT;

               BEGIN
                  SELECT case_id, ID
                    INTO l_case_id, l_request_id
                    FROM xwrl_requests
                   WHERE batch_id = l_batch_id
                     --                     AND name_screened = r_request_rec.name_screened
                     AND master_id = r_request_rec.master_id
                     AND NVL (alias_id, -99) =
                                              NVL (r_request_rec.alias_id,
                                                   -99)
                     AND NVL (xref_id, -99) = NVL (r_request_rec.xref_id, -99);
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     apps.mt_log_error
                                (   'Exception While Fetching Case Details: '
                                 || SQLERRM
                                );
                     COMMIT;
                     l_case_id := NULL;
                     l_request_id := NULL;
               END;

               apps.mt_log_error (   'Case ID: '
                                  || l_case_id
                                  || ' Request ID: '
                                  || l_request_id
                                 );
               COMMIT;

               IF l_case_id IS NOT NULL AND l_request_id IS NOT NULL
               THEN
                  l_doc_rec.ID := l_doc_id;
                  l_doc_rec.case_id := l_case_id;
                  l_doc_rec.request_id := l_request_id;
                  apps.mt_log_error ('Inserting Into Case Documents');
                  COMMIT;

                  INSERT INTO xwrl_case_documents
                       VALUES l_doc_rec;

                  COMMIT;
               END IF;
            END LOOP;

            -- Copy Case Notes
            --
            FOR r_note_rec IN (SELECT xc.*
                                 FROM xwrl_case_notes xc, xwrl_requests xr
                                WHERE 1 = 1
                                  AND xc.request_id = xr.ID
                                  AND xr.batch_id = l_prev_batch_id
                                  AND xr.name_screened =
                                                   r_request_rec.name_screened)
            LOOP
               l_note_rec := NULL;
               l_case_id := NULL;
               l_request_id := NULL;
               l_note_rec := r_note_rec;

               BEGIN
                  SELECT xwrl_case_notes_seq.NEXTVAL
                    INTO l_note_id
                    FROM DUAL;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_note_id := NULL;
               END;

               apps.mt_log_error (   'Batch ID: '
                                  || l_batch_id
                                  || ' Name Screened: '
                                  || r_request_rec.name_screened
                                 );
               COMMIT;

               BEGIN
                  SELECT case_id, ID
                    INTO l_case_id, l_request_id
                    FROM xwrl_requests
                   WHERE batch_id = l_batch_id
                     --                     AND name_screened = r_request_rec.name_screened
                     AND master_id = r_request_rec.master_id
                     AND NVL (alias_id, -99) =
                                              NVL (r_request_rec.alias_id,
                                                   -99)
                     AND NVL (xref_id, -99) = NVL (r_request_rec.xref_id, -99);
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     apps.mt_log_error
                                (   'Exception While Fetching Case Details: '
                                 || SQLERRM
                                );
                     COMMIT;
                     l_case_id := NULL;
                     l_request_id := NULL;
               END;

               apps.mt_log_error (   'Case ID: '
                                  || l_case_id
                                  || ' Request ID: '
                                  || l_request_id
                                 );
               COMMIT;

               IF l_case_id IS NOT NULL AND l_request_id IS NOT NULL
               THEN
                  l_note_rec.ID := l_note_id;
                  l_note_rec.case_id := l_case_id;
                  l_note_rec.request_id := l_request_id;
                  apps.mt_log_error ('Inserting Into Case Documents');
                  COMMIT;

                  INSERT INTO xwrl_case_notes
                       VALUES l_note_rec;

                  COMMIT;
               END IF;
            END LOOP;
           -- Copy Alert Notes
         --
         --            FOR r_note_rec IN (SELECT xc.*
         --                                 FROM xwrl_alert_notes xc, xwrl_requests xr
         --                                WHERE 1 = 1
         --                                  AND xc.request_id = xr.ID
         --                                  AND xr.batch_id = l_prev_batch_id
         --                                  AND xr.name_screened =
         --                                                   r_request_rec.name_screened)
         --            LOOP
         --               l_alert_note_rec := NULL;
         --               -- l_case_id := NULL;
         --               l_request_id := NULL;
         --               l_alert_note_rec := r_note_rec;

         --               BEGIN
         --                  SELECT xwrl_alert_notes_seq.NEXTVAL
         --                    INTO l_note_id
         --                    FROM DUAL;
         --               EXCEPTION
         --                  WHEN OTHERS
         --                  THEN
         --                     l_note_id := NULL;
         --               END;

         --               apps.mt_log_error (   'Batch ID: '
         --                                  || l_batch_id
         --                                  || ' Name Screened: '
         --                                  || r_request_rec.name_screened
         --                                 );
         --               COMMIT;

         --               BEGIN
         --                  SELECT case_id, ID
         --                    INTO l_case_id, l_request_id
         --                    FROM xwrl_requests
         --                   WHERE batch_id = l_batch_id
         ----                     AND name_screened = r_request_rec.name_screened
         --                     AND master_id = r_request_rec.master_id
         --                     AND NVL (alias_id, -99) =
         --                                              NVL (r_request_rec.alias_id,
         --                                                   -99)
         --                     AND NVL (xref_id, -99) = NVL (r_request_rec.xref_id, -99);
         --               EXCEPTION
         --                  WHEN OTHERS
         --                  THEN
         --                     apps.mt_log_error
         --                                (   'Exception While Fetching Case Details: '
         --                                 || SQLERRM
         --                                );
         --                     COMMIT;
         --                     l_case_id := NULL;
         --                     l_request_id := NULL;
         --               END;

         --               apps.mt_log_error (   'Case ID: '
         --                                  || l_case_id
         --                                  || ' Request ID: '
         --                                  || l_request_id
         --                                 );
         --               COMMIT;

         --               IF l_case_id IS NOT NULL AND l_request_id IS NOT NULL
         --               THEN
         --                  l_alert_note_rec.ID := l_note_id;
         --                  --l_alert_note_rec.case_id := l_case_id;
         --                  l_alert_note_rec.request_id := l_request_id;
         --                  apps.mt_log_error ('Inserting Into Case Documents');
         --                  COMMIT;

         --                  INSERT INTO xwrl_alert_notes
         --                       VALUES l_alert_note_rec;

         --                  COMMIT;
         --               END IF;
         --            END LOOP;
         END LOOP;

         --- End Code Change

         -- Sync Alias Documents
         sync_batch_alias_documents (l_batch_id);
         -- Sync Alias Notes
         sync_batch_alias_notes (l_batch_id);
      END IF;

      x_batch_id := l_batch_id;
      x_return_status := 'S';
   EXCEPTION
      WHEN OTHERS
      THEN
         x_batch_id := l_batch_id;
         x_return_status := 'E';
         x_return_msg := 'Exception while submitting OWS Batch ' || SQLERRM;
   END create_batch_vetting;

   PROCEDURE create_new_vetting (
      p_source_table          IN       VARCHAR2,
      p_source_table_column   IN       VARCHAR2,
      p_source_id             IN       NUMBER,
      x_batch_id              OUT      NUMBER,
      x_return_status         OUT      VARCHAR2,
      x_return_msg            OUT      VARCHAR2
   )
   IS
      entity_data        rmi_ows_common_util.screening_tab;
      l_req              rmi_ows_common_util.ows_request_rec;
      l_id               NUMBER;
      x_return_code      VARCHAR2 (100);
      x_retrun_msg       VARCHAR2 (500);
      l_batch_id         NUMBER;
      v_pause            INTEGER                             := 0;
      -- 2019112 tsuazo Add pause between OWS requests
      l_user_id          NUMBER              := fnd_profile.VALUE ('USER_ID');
      l_login_id         NUMBER             := fnd_profile.VALUE ('LOGIN_ID');
      l_username         VARCHAR2 (100)     := fnd_profile.VALUE ('USERNAME');
      --- Added By Gopi Vella
      l_prev_batch_id    NUMBER;
      l_doc_rec          xwrl_case_documents%ROWTYPE;
      l_note_rec         xwrl_case_notes%ROWTYPE;
      l_alert_note_rec   xwrl_alert_notes%ROWTYPE;
      l_doc_id           NUMBER;
      l_note_id          NUMBER;
      l_case_id          VARCHAR2 (50);
      l_request_id       NUMBER;
   --- End Code Change
   BEGIN
      BEGIN
         SELECT xwrl_utils.get_ebs_pause "EBS_Pause_Time"
           INTO v_pause
           FROM DUAL;
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      DBMS_OUTPUT.put_line ('Start');
      -- Fetch all related entities into table type variable
      rmi_ows_common_util.query_cross_reference (p_source_table,
                                                 p_source_table_column,
                                                 p_source_id,
                                                 entity_data
                                                );
      DBMS_OUTPUT.put_line ('Total Reference Count ' || entity_data.COUNT);
      -- get last open batch details
      l_batch_id :=
                rmi_ows_common_util.get_batch_id (p_source_table, p_source_id);

      --- Added By Gopi Vella.
      BEGIN
         SELECT MAX (batch_id)
           INTO l_prev_batch_id
           FROM xwrl_requests
          WHERE source_id = p_source_id
            AND source_table = p_source_table
            AND batch_id IS NOT NULL
            AND case_state NOT IN ('E');

         apps.mt_log_error ('Previous Batch ID: ' || l_prev_batch_id);
         COMMIT;
      EXCEPTION
         WHEN OTHERS
         THEN
            l_prev_batch_id := NULL;
            apps.mt_log_error
                      (   'Error Occurred While Deriving Previous Batch ID: '
                       || SQLERRM
                      );
            COMMIT;
      END;

      --- End Code Change
      DBMS_OUTPUT.put_line ('Existing Batch ID ' || l_batch_id);

      -- Match Old batch with New Batch

      -- Close and Delete Batch if new batch is needed
      IF l_batch_id IS NOT NULL
      THEN
         --
         -- Close ALerts
         FOR rec IN (SELECT ID, case_id
                       FROM xwrl_requests
                      WHERE batch_id = l_batch_id)
         LOOP
            close_ows_case (p_user_name       => l_username,
                            p_case_id         => rec.case_id,
                            p_request_id      => rec.ID
                           );
            DBMS_OUTPUT.put_line ('Case ID ' || rec.case_id);
         END LOOP;

         --
         UPDATE xwrl_requests
            SET case_state = 'D',
                case_status = 'C',
                last_update_date = SYSDATE,
                last_updated_by = l_user_id,
                last_update_login = l_login_id
          WHERE 1 = 1 AND batch_id = l_batch_id;

         DBMS_OUTPUT.put_line (   'Batch Updated '
                               || l_batch_id
                               || ' '
                               || SQL%ROWCOUNT
                              );
         COMMIT;
      END IF;

      --
      IF entity_data.COUNT > 0
      THEN
         SELECT xwrl_batch_seq.NEXTVAL
           INTO l_batch_id
           FROM DUAL;

         -- Loop through each entity and create OWS vetting
         FOR i IN 1 .. entity_data.COUNT
         LOOP
            IF NVL (entity_data (i).tc_excluded, 'N') != 'Y'
            THEN
               l_id := NULL;
               x_return_code := 'SUCCESS';
               x_retrun_msg := NULL;
               l_req := NULL;
               -- assign vetting variables
               l_req.batch_id := l_batch_id;

               IF entity_data (i).entity_type = 'INDIVIDUAL'
               THEN
                  l_req.entity_type := 'INDIVIDUAL';
                  l_req.source_table := entity_data (i).source_table;
                  l_req.source_table_column :=
                                          entity_data (i).source_table_column;
                  l_req.source_id := entity_data (i).source_id;
                  l_req.city_id := entity_data (i).city_of_residence_id;
                  l_req.name_screened := entity_data (i).full_name;
                  l_req.full_name := entity_data (i).full_name;
                  l_req.last_name := entity_data (i).family_name;
                  l_req.first_name := entity_data (i).given_name;
                  l_req.gender := entity_data (i).sex;
                  l_req.date_of_birth := entity_data (i).date_of_birth;
                  l_req.residence_country_code :=
                     get_country_iso_code
                                         (entity_data (i).country_of_residence
                                         );
                  l_req.nationality :=
                     get_country_iso_code
                                      (entity_data (i).citizenship_country_code
                                      );
                  l_req.passport_issuing_country_code :=
                     get_country_iso_code
                                 (entity_data (i).passport_issuing_country_code
                                 );
                  l_req.passport_number := entity_data (i).passport_number;
                  l_req.master_id := entity_data (i).master_id;
                  l_req.alias_id := entity_data (i).alias_id;
                  l_req.xref_id := entity_data (i).xref_id;
                  l_req.wc_screening_request_id :=
                                       entity_data (i).wc_screening_request_id;
               ELSIF entity_data (i).entity_type = 'ORGANISATION'
               THEN
                  l_req.entity_type := 'ENTITY';
                  l_req.source_table := entity_data (i).source_table;
                  l_req.source_table_column :=
                                          entity_data (i).source_table_column;
                  l_req.source_id := entity_data (i).source_id;
                  l_req.entity_name := entity_data (i).full_name;
                  l_req.master_id := entity_data (i).master_id;
                  l_req.alias_id := entity_data (i).alias_id;
                  l_req.xref_id := entity_data (i).xref_id;
                  l_req.wc_screening_request_id :=
                                      entity_data (i).wc_screening_request_id;
               ELSIF entity_data (i).entity_type = 'VESSEL'
               THEN
                  l_req.entity_type := 'ENTITY';
                  l_req.source_table := entity_data (i).source_table;
                  l_req.source_table_column :=
                                          entity_data (i).source_table_column;
                  l_req.source_id := entity_data (i).source_id;
                  l_req.entity_name := entity_data (i).full_name;
                  l_req.registrationnumber := entity_data (i).imo_number;
                  l_req.vessel_indicator := 'Y';
                  l_req.master_id := entity_data (i).master_id;
                  l_req.alias_id := entity_data (i).alias_id;
                  l_req.xref_id := entity_data (i).xref_id;
                  l_req.wc_screening_request_id :=
                                      entity_data (i).wc_screening_request_id;
               END IF;

               -- call OWS API to generate request
               create_ows_generic (p_req              => l_req,
                                   p_custom_id1       => NULL,
                                   p_custom_id2       => NULL,
                                   p_return_code      => x_return_code,
                                   p_ret_msg          => x_retrun_msg,
                                   x_id               => l_id
                                  );
            END IF;

            IF x_return_code = 'SUCCESS'
            THEN
               -- Update Batch ID
               IF entity_data (i).relationship_type = 'Alias'
               THEN
                  UPDATE xwrl_party_alias
                     SET batch_id = l_batch_id,
                         last_update_date = SYSDATE,
                         last_updated_by = l_user_id,
                         last_update_login = l_login_id
                   WHERE ID = entity_data (i).alias_id;
               ELSE
                  IF entity_data (i).xref_id IS NULL
                  THEN
                     UPDATE xwrl_party_master
                        SET batch_id = l_batch_id,
                            last_update_date = SYSDATE,
                            last_updated_by = l_user_id,
                            last_update_login = l_login_id
                      WHERE ID = entity_data (i).master_id;
                  ELSE
                     UPDATE xwrl_party_xref
                        SET last_update_date = SYSDATE,
                            last_updated_by = l_user_id,
                            last_update_login = l_login_id
                      WHERE ID = entity_data (i).xref_id;

                     UPDATE xwrl_party_master
                        SET batch_id = l_batch_id,
                            last_update_date = SYSDATE,
                            last_updated_by = l_user_id,
                            last_update_login = l_login_id
                      WHERE ID = (SELECT relationship_master_id
                                    FROM xwrl_party_xref
                                   WHERE ID = entity_data (i).xref_id);
                  END IF;
               END IF;

               COMMIT;
            END IF;

            DBMS_LOCK.sleep (v_pause);
         -- 2019112 tsuazo Add pause between OWS requests
         END LOOP;

         --- Added By Gopi Vella To Sync The Case Documents
         apps.mt_log_error (   'Copy Case Documents Previous Batch ID: '
                            || l_prev_batch_id
                           );
         COMMIT;

         FOR r_request_rec IN (SELECT --* SAURABH Remove *
                                      name_screened, id, xref_id, alias_id, master_id
                                 FROM xwrl_requests
                                WHERE batch_id = l_prev_batch_id)
         LOOP

            apps.mt_log_error (   'Name Screened: '
                               || r_request_rec.name_screened
                               || ' Id: '
                               || r_request_rec.ID
                              );
            COMMIT;

            FOR r_doc_rec IN (SELECT xc.*
                                FROM xwrl_case_documents xc, xwrl_requests xr
                               WHERE 1 = 1
                                 AND xc.request_id = xr.ID
                                 AND xr.batch_id = l_prev_batch_id
                                 AND xr.name_screened =
                                                   r_request_rec.name_screened)
            LOOP
               l_doc_rec := NULL;
               l_case_id := NULL;
               l_request_id := NULL;
               l_doc_rec := r_doc_rec;

               BEGIN
                  SELECT xwrl_case_documents_seq.NEXTVAL
                    INTO l_doc_id
                    FROM DUAL;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_doc_id := NULL;
               END;

               apps.mt_log_error (   'Batch ID: '
                                  || l_batch_id
                                  || ' Name Screened: '
                                  || r_request_rec.name_screened
                                 );
               COMMIT;

               BEGIN
                  SELECT case_id, ID
                    INTO l_case_id, l_request_id
                    FROM xwrl_requests
                   WHERE batch_id = l_batch_id
                     --                     AND name_screened = r_request_rec.name_screened
                     AND master_id = r_request_rec.master_id
                     AND NVL (alias_id, -99) =
                                              NVL (r_request_rec.alias_id,
                                                   -99)
                     AND NVL (xref_id, -99) = NVL (r_request_rec.xref_id, -99);
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     apps.mt_log_error
                                (   'Exception While Fetching Case Details: '
                                 || SQLERRM
                                );
                     COMMIT;
                     l_case_id := NULL;
                     l_request_id := NULL;
               END;

               apps.mt_log_error (   'Case ID: '
                                  || l_case_id
                                  || ' Request ID: '
                                  || l_request_id
                                 );
               COMMIT;

               IF l_case_id IS NOT NULL AND l_request_id IS NOT NULL
               THEN
                  l_doc_rec.ID := l_doc_id;
                  l_doc_rec.case_id := l_case_id;
                  l_doc_rec.request_id := l_request_id;
                  apps.mt_log_error ('Inserting Into Case Documents');
                  COMMIT;

                  INSERT INTO xwrl_case_documents
                       VALUES l_doc_rec;

                  COMMIT;
               END IF;
            END LOOP;

            -- Copy Case Notes
            --
            FOR r_note_rec IN (SELECT xc.*
                                 FROM xwrl_case_notes xc, xwrl_requests xr
                                WHERE 1 = 1
                                  AND xc.request_id = xr.ID
                                  AND xr.batch_id = l_prev_batch_id
                                  AND xr.name_screened =
                                                   r_request_rec.name_screened)
            LOOP
               l_note_rec := NULL;
               l_case_id := NULL;
               l_request_id := NULL;
               l_note_rec := r_note_rec;

               BEGIN
                  SELECT xwrl_case_notes_seq.NEXTVAL
                    INTO l_note_id
                    FROM DUAL;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_note_id := NULL;
               END;

               apps.mt_log_error (   'Batch ID: '
                                  || l_batch_id
                                  || ' Name Screened: '
                                  || r_request_rec.name_screened
                                 );
               COMMIT;

               BEGIN
                  SELECT case_id, ID
                    INTO l_case_id, l_request_id
                    FROM xwrl_requests
                   WHERE batch_id = l_batch_id
                     --                     AND name_screened = r_request_rec.name_screened
                     AND master_id = r_request_rec.master_id
                     AND NVL (alias_id, -99) =
                                              NVL (r_request_rec.alias_id,
                                                   -99)
                     AND NVL (xref_id, -99) = NVL (r_request_rec.xref_id, -99);
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     apps.mt_log_error
                                (   'Exception While Fetching Case Details: '
                                 || SQLERRM
                                );
                     COMMIT;
                     l_case_id := NULL;
                     l_request_id := NULL;
               END;

               apps.mt_log_error (   'Case ID: '
                                  || l_case_id
                                  || ' Request ID: '
                                  || l_request_id
                                 );
               COMMIT;

               IF l_case_id IS NOT NULL AND l_request_id IS NOT NULL
               THEN
                  l_note_rec.ID := l_note_id;
                  l_note_rec.case_id := l_case_id;
                  l_note_rec.request_id := l_request_id;
                  apps.mt_log_error ('Inserting Into Case Documents');
                  COMMIT;

                  INSERT INTO xwrl_case_notes
                       VALUES l_note_rec;

                  COMMIT;
               END IF;
            END LOOP;
           -- Copy Alert Notes
         --
         --            FOR r_note_rec IN (SELECT xc.*
         --                                 FROM xwrl_alert_notes xc, xwrl_requests xr
         --                                WHERE 1 = 1
         --                                  AND xc.request_id = xr.ID
         --                                  AND xr.batch_id = l_prev_batch_id
         --                                  AND xr.name_screened =
         --                                                   r_request_rec.name_screened)
         --            LOOP
         --               l_alert_note_rec := NULL;
         --               -- l_case_id := NULL;
         --               l_request_id := NULL;
         --               l_alert_note_rec := r_note_rec;

         --               BEGIN
         --                  SELECT xwrl_alert_notes_seq.NEXTVAL
         --                    INTO l_note_id
         --                    FROM DUAL;
         --               EXCEPTION
         --                  WHEN OTHERS
         --                  THEN
         --                     l_note_id := NULL;
         --               END;

         --               apps.mt_log_error (   'Batch ID: '
         --                                  || l_batch_id
         --                                  || ' Name Screened: '
         --                                  || r_request_rec.name_screened
         --                                 );
         --               COMMIT;

         --               BEGIN
         --                  SELECT case_id, ID
         --                    INTO l_case_id, l_request_id
         --                    FROM xwrl_requests
         --                   WHERE batch_id = l_batch_id
         ----                     AND name_screened = r_request_rec.name_screened
         --                     AND master_id = r_request_rec.master_id
         --                     AND NVL (alias_id, -99) =
         --                                              NVL (r_request_rec.alias_id,
         --                                                   -99)
         --                     AND NVL (xref_id, -99) = NVL (r_request_rec.xref_id, -99);
         --               EXCEPTION
         --                  WHEN OTHERS
         --                  THEN
         --                     apps.mt_log_error
         --                                (   'Exception While Fetching Case Details: '
         --                                 || SQLERRM
         --                                );
         --                     COMMIT;
         --                     l_case_id := NULL;
         --                     l_request_id := NULL;
         --               END;

         --               apps.mt_log_error (   'Case ID: '
         --                                  || l_case_id
         --                                  || ' Request ID: '
         --                                  || l_request_id
         --                                 );
         --               COMMIT;

         --               IF l_case_id IS NOT NULL AND l_request_id IS NOT NULL
         --               THEN
         --                  l_alert_note_rec.ID := l_note_id;
         --                  --l_alert_note_rec.case_id := l_case_id;
         --                  l_alert_note_rec.request_id := l_request_id;
         --                  apps.mt_log_error ('Inserting Into Case Documents');
         --                  COMMIT;

         --                  INSERT INTO xwrl_alert_notes
         --                       VALUES l_alert_note_rec;

         --                  COMMIT;
         --               END IF;
         --            END LOOP;
         END LOOP;
      --- End Code Change
      END IF;

      x_batch_id := l_batch_id;
      x_return_status := 'S';
   EXCEPTION
      WHEN OTHERS
      THEN
         x_batch_id := l_batch_id;
         x_return_status := 'E';
         x_return_msg := 'Exception while submitting OWS Batch ' || SQLERRM;
   END create_new_vetting;

   PROCEDURE update_master (t_data IN OUT rmi_ows_common_util.screening_tab)
   IS
      l_user_id   NUMBER := fnd_profile.VALUE ('USER_ID');
   BEGIN
      FOR i IN 1 .. t_data.COUNT
      LOOP
         UPDATE xwrl_party_master
            SET start_date = t_data (i).start_date,
                end_date = t_data (i).end_date,
                tc_excluded = t_data (i).tc_excluded,
                batch_id = t_data (i).batch_id,
                last_update_date = SYSDATE,
                last_updated_by = l_user_id
          WHERE 1 = 1
            AND ID = t_data (i).master_id
            AND t_data (i).alias_id IS NULL
            AND t_data (i).xref_id IS NULL;

         UPDATE xwrl_party_xref
            SET start_date = t_data (i).start_date,
                end_date = t_data (i).end_date,
                last_update_date = SYSDATE,
                last_updated_by = l_user_id,
                tc_excluded = t_data (i).tc_excluded
          WHERE 1 = 1 AND ID = t_data (i).xref_id;

         --         UPDATE xwrl_party_master
         --            SET start_date = t_data (i).start_date,
         --                end_date = t_data (i).end_date,
         --                last_update_date = SYSDATE,
         --                last_updated_by = l_user_id,
         --                tc_excluded = t_data (i).tc_excluded
         --          WHERE 1 = 1 AND ID = (SELECT relationship_master_id
         --                                  FROM xwrl_party_xref
         --                                 WHERE 1 = 1 AND ID = t_data (i).xref_id);
         UPDATE xwrl_party_alias
            SET start_date = t_data (i).start_date,
                end_date = t_data (i).end_date,
                tc_excluded = t_data (i).tc_excluded,
                batch_id = t_data (i).batch_id,
                last_update_date = SYSDATE,
                last_updated_by = l_user_id
          WHERE 1 = 1
                     --AND ID = t_data (i).master_id;
                AND ID = t_data (i).alias_id;
      END LOOP;

      COMMIT;
   END;

   PROCEDURE close_ows_case (
      p_user_name    IN   VARCHAR2,
      p_case_id      IN   VARCHAR2,
      p_request_id   IN   VARCHAR2
   )
   IS
      l_case_in_tbl    xows.xxiri_cm_process_pkg.case_tbl_in_type@ebstoows2.coresys.com;
      l_case_out_tbl   xows.xxiri_cm_process_pkg.case_tbl_out_type@ebstoows2.coresys.com;
      l_status         VARCHAR2 (200);
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      l_case_in_tbl (1).case_id := p_case_id;        --alert_rec.external_id;
      l_case_in_tbl (1).to_state := 'Closed';
      l_case_in_tbl (1).COMMENT := 'Close case';
      xows.xxiri_cm_process_pkg.update_case@ebstoows2.coresys.com
                                           (p_user                      => p_user_name,
                                            p_alert_close_override      => 'Y',
                                            p_case_in_tbl               => l_case_in_tbl,
                                            x_case_out_tbl              => l_case_out_tbl,
                                            x_status                    => l_status
                                           );
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         mt_log_error (   p_case_id
                       || ' '
                       || p_request_id
                       || ' '
                       || 'exception while closing alerts: '
                       || SQLERRM
                      );
         ROLLBACK;
   END close_ows_case;

   PROCEDURE close_ows_alert (
   p_user_id      IN   NUMBER,
   p_request_id   IN   VARCHAR2,
   p_row_number   IN   VARCHAR2
)
IS
   l_alert_id        VARCHAR2 (25);
   l_user            VARCHAR2 (200);
   l_record_type     VARCHAR2 (10);
   l_alert_in_tbl    xows.xxiri_cm_process_pkg.alert_tbl_in_type@ebstoows2.coresys.com;
   x_alert_out_tbl   xows.xxiri_cm_process_pkg.alert_tbl_out_type@ebstoows2.coresys.com;
   x_status          VARCHAR2 (200);
   l_error           VARCHAR2 (500);
   l_to_state        VARCHAR2 (100);
   v_debug           VARCHAR2 (10);
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   l_alert_in_tbl.DELETE;
   x_alert_out_tbl.DELETE;

   BEGIN
      SELECT user_name
        INTO l_user
        FROM apps.fnd_user
       WHERE user_id = p_user_id;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_user := 'SYSADMIN';
   END;

   SELECT value_string
     INTO v_debug
     FROM xwrl_parameters
    WHERE ID = 'XWRL_OWS_UTILS' AND KEY = 'DEBUG';

   FOR r_alert_rec IN (SELECT alertid, listrecordtype
                         FROM xwrl_response_entity_columns
                        WHERE request_id = p_request_id AND rec = p_row_number
                                                                              --AND dnvesselindicator = 'Y'
                     )
   LOOP
      apps.mt_log_error (   p_request_id
                         || ' '
                         || p_row_number
                         || ' '
                         || 'Alert Id'
                         || ' '
                         || r_alert_rec.alertid
                        --||' '
                        );
      apps.mt_log_error (   p_request_id
                         || ' '
                         || p_row_number
                         || ' '
                         || 'Record Type'
                         || ' '
                         || r_alert_rec.listrecordtype
                         || ' - False Positive'
                        --||' '
                        );

      --SAURABH 04-MAY-2020 Get TO-STATE dynamically
      BEGIN
         SELECT SUBSTR (to_state, 4)
           INTO l_to_state
           FROM xwrl_alert_clearing_xref
          WHERE alert_id = r_alert_rec.alertid
            AND ID = (SELECT MAX (ID)
                        FROM xwrl_alert_clearing_xref
                       WHERE alert_id = r_alert_rec.alertid);
      EXCEPTION
         WHEN OTHERS
         THEN
            apps.mt_log_error ('Exception In Getting To State: ' || SQLERRM);
            l_to_state := NULL;
      END;

      IF l_to_state IS NOT NULL
      THEN
         l_alert_in_tbl (1).alert_id := r_alert_rec.alertid;    --l_alert_id;
         --SAURABH 04-MAY-2020 Get TO-STATE dynamically
         --l_alert_in_tbl (1).to_state :=
         --   xwrl_ows_utils.changetoowsstate (   r_alert_rec.listrecordtype
         --                                    || ' - False Positive'
         --                                   );
         l_alert_in_tbl (1).to_state :=
            xwrl_ows_utils.changetoowsstate (   r_alert_rec.listrecordtype
                                             || l_to_state
                                            );
         l_alert_in_tbl (1).COMMENT :=
                   'Marking as False Positive Becuase of Vessel Indicator Y/N';

         IF v_debug = 'TRUE'
         THEN
            FOR i IN l_alert_in_tbl.FIRST .. l_alert_in_tbl.LAST
            LOOP

               INSERT INTO xwrl_alerts_debug
                           (procedure_name, p_user,
                            p_alert_id,
                            p_to_state,
                            p_comment, creation_date, created_by
                           )
                    VALUES ('RMI_OWS_COMMON_UTIL.CLOSE_OWS_ALERT', l_user,
                            l_alert_in_tbl (i).alert_id,
                            l_alert_in_tbl (i).to_state,
                            l_alert_in_tbl (i).COMMENT, SYSDATE, p_user_id
                           );
            END LOOP;
         END IF;

         xows.xxiri_cm_process_pkg.update_alerts@ebstoows2.coresys.com
                                          (p_user               => l_user,
                                           p_alert_in_tbl       => l_alert_in_tbl,
                                           x_alert_out_tbl      => x_alert_out_tbl,
                                           x_status             => x_status
                                          );
         apps.mt_log_error (   p_request_id
                            || ' '
                            || p_row_number
                            || ' '
                            || 'API Status'
                            || ' '
                            || x_status
                           --||' '
                           );

         FOR i IN x_alert_out_tbl.FIRST .. x_alert_out_tbl.LAST
         LOOP
            IF v_debug = 'TRUE'
            THEN
               INSERT INTO xwrl_alert_results_debug
                           (procedure_name, p_request_id,
                            p_case_key,
                            p_alert_id,
                            p_list_id,
                            p_key_label,
                            p_old_state,
                            p_new_state,
                            p_status,
                            p_err_msg, creation_date, created_by
                           )
                    VALUES ('XWRL_OWS_UTILS.CLOSE_OWS_ALERT', p_request_id,
                            SUBSTR (x_alert_out_tbl (i).key_label,
                                    1,
                                      INSTR (x_alert_out_tbl (i).key_label,
                                             ':',
                                             1
                                            )
                                    - 1
                                   ),
                            x_alert_out_tbl (i).alert_id,
                            TO_NUMBER
                               (SUBSTR (x_alert_out_tbl (i).key_label,
                                          INSTR (x_alert_out_tbl (i).key_label,
                                                 ':',
                                                 -1
                                                )
                                        + 1,
                                        LENGTH (x_alert_out_tbl (i).key_label)
                                       )
                               ),
                            x_alert_out_tbl (i).key_label,
                            x_alert_out_tbl (i).old_state,
                            x_alert_out_tbl (i).new_state,
                            x_alert_out_tbl (i).status,
                            x_alert_out_tbl (i).err_msg, SYSDATE, p_user_id
                           );
            END IF;

            IF x_status != 'SUCCESS'
            THEN
               l_error :=
                     ' status: '
                  || x_alert_out_tbl (i).status
                  || ' err_msg: '
                  || x_alert_out_tbl (i).err_msg
                  || ' Overall status: '
                  || x_status;
               apps.mt_log_error (   p_request_id
                                  || ' '
                                  || p_row_number
                                  || ' '
                                  || 'API Error'
                                  || ' '
                                  || x_alert_out_tbl (i).err_msg
                                 --||' '
                                 );
            END IF;

            IF x_status != 'SUCCESS'
            THEN
               FOR j IN x_alert_out_tbl.FIRST .. x_alert_out_tbl.LAST
               LOOP
                  l_error :=
                        ' status: '
                     || x_alert_out_tbl (j).status
                     || ' err_msg: '
                     || x_alert_out_tbl (j).err_msg
                     || ' Overall status: '
                     || x_status;
                  apps.mt_log_error (   p_request_id
                                     || ' '
                                     || p_row_number
                                     || ' '
                                     || 'API Error'
                                     || ' '
                                     || x_alert_out_tbl (j).err_msg
                                    --||' '
                                    );
               END LOOP;
            END IF;
         END LOOP;

         UPDATE xwrl_response_entity_columns
            SET x_state = r_alert_rec.listrecordtype || ' - False Positive'
          WHERE request_id = p_request_id AND alertid = r_alert_rec.alertid;
      END IF;
   END LOOP;

   COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN
      apps.mt_log_error (   p_request_id
                         || ' '
                         || p_row_number
                         || ' '
                         || 'API Exception'
                         || ' '
                         || SQLERRM
                        );
      ROLLBACK;
END close_ows_alert;


   PROCEDURE insert_party_master (
      p_source_table          IN       VARCHAR2,
      p_source_table_column   IN       VARCHAR2,
      p_source_id             IN       NUMBER,
      x_id                    IN OUT   NUMBER
   )
   IS
      CURSOR cur_seafarer
      IS
         SELECT *
           FROM sicd_seafarers
          WHERE seafarer_id = p_source_id;

      CURSOR cur_seafarer_ext
      IS
         SELECT   *
             FROM exsicd_seafarers_iface
            WHERE seafarer_id = p_source_id
         ORDER BY 1 DESC;

      CURSOR cur_corp
      IS
         SELECT *
           FROM corp_main
          WHERE corp_id = p_source_id;

      CURSOR cur_customer
      IS
         SELECT hca.cust_account_id customer_id, hp.party_name customer_name
           --FROM ar_customers
         FROM   hz_parties hp, hz_cust_accounts hca
          WHERE hca.cust_account_id = p_source_id
            AND hca.party_id = hp.party_id;

      CURSOR cur_inspectors
      IS
         SELECT *
           FROM insp_inspectors
          WHERE inspector_id = p_source_id;

      CURSOR cur_vessels
      IS
         SELECT *
           FROM vssl_vessels
          WHERE vessel_pk = p_source_id AND status = 'A' AND ROWNUM <= 1;

      CURSOR cur_vssl_contacts
      IS
         SELECT *
           FROM vssl_contacts_v
          WHERE contact_id = p_source_id;

      CURSOR cur_vetting
      IS
         SELECT *
           FROM reg11_header
          WHERE reg11_header_id = p_source_id;

      CURSOR cur_nrmi
      IS
         SELECT *
           FROM nrmi_certificates
          WHERE nrmi_certificates_id = p_source_id;

      l_batch_id    NUMBER;
      l_user_id     NUMBER                    := fnd_profile.VALUE ('USER_ID');
      l_login_id    NUMBER                   := fnd_profile.VALUE ('LOGIN_ID');
      l_party_rec   xwrl_party_master%ROWTYPE;
      l_cnt         NUMBER                      := 0;
   BEGIN
      --
      SELECT COUNT (1)
        INTO l_cnt
        FROM xwrl_party_master
       WHERE status = 'Enabled'
         AND relationship_type = 'Primary'
         AND source_table = p_source_table
         AND source_table_column = p_source_table_column
         AND source_id = p_source_id;

      IF l_cnt = 0 AND p_source_id IS NOT NULL
      THEN
         l_party_rec.ID := xwrl.xwrl_party_master_seq.NEXTVAL;

         IF p_source_table = 'SICD_SEAFARERS'
         THEN
            FOR rec IN cur_seafarer
            LOOP
               --
               l_party_rec.wc_screening_request_id := NULL;
               l_party_rec.relationship_type := 'Primary';
               l_party_rec.entity_type := 'INDIVIDUAL';
               l_party_rec.state := 'Verified';
               l_party_rec.status := 'Enabled';
               l_party_rec.source_table := 'SICD_SEAFARERS';
               l_party_rec.source_table_column := 'SEAFARER_ID';
               l_party_rec.source_id := rec.seafarer_id;
               l_party_rec.xref_source_table := NULL;
               l_party_rec.xref_source_table_column := NULL;
               l_party_rec.xref_source_id := NULL;
               l_party_rec.full_name :=
                                TRIM (rec.first_name || ' ' || rec.last_name);
               l_party_rec.family_name := rec.last_name;
               l_party_rec.given_name := rec.first_name;

               IF rec.birth_date IS NOT NULL
               THEN
                  l_party_rec.date_of_birth :=
                                         TO_CHAR (rec.birth_date, 'YYYYMMDD');
               END IF;

               l_party_rec.sex := UPPER (rec.gender);
               l_party_rec.imo_number := NULL;
               l_party_rec.department := NULL;
               l_party_rec.office := NULL;
               l_party_rec.priority := NULL;
               l_party_rec.risk_level := NULL;
               l_party_rec.document_type := NULL;
               l_party_rec.closed_date := NULL;
               l_party_rec.assigned_to := NULL;
               l_party_rec.vessel_indicator := NULL;
               l_party_rec.passport_number := NULL;
               l_party_rec.passport_issuing_country_code := get_country_iso_code (rec.nationality);
               l_party_rec.citizenship_country_code := NULL;

			   --l_party_rec.country_of_residence := NULL;
			   l_party_rec.country_of_residence := get_country_iso_code (rec.nationality);

               l_party_rec.city_of_residence_id := NULL;
               l_party_rec.note := NULL;
               l_party_rec.start_date := SYSDATE;
               l_party_rec.end_date := NULL;
               l_party_rec.last_update_date := SYSDATE;
               l_party_rec.last_updated_by := l_user_id;
               l_party_rec.creation_date := SYSDATE;
               l_party_rec.created_by := l_user_id;
               l_party_rec.last_update_login := l_login_id;
               l_party_rec.source_target_column := NULL;
               l_party_rec.batch_id := l_batch_id;
            END LOOP;

            IF l_party_rec.source_id IS NULL
            THEN
               -- Insert from External Seafarers
               FOR rec IN cur_seafarer_ext
               LOOP
                  --
                  l_party_rec.wc_screening_request_id := NULL;
                  l_party_rec.relationship_type := 'Primary';
                  l_party_rec.entity_type := 'INDIVIDUAL';
                  l_party_rec.state := 'Verified';
                  l_party_rec.status := 'Enabled';
                  l_party_rec.source_table := 'SICD_SEAFARERS';
                  l_party_rec.source_table_column := 'SEAFARER_ID';
                  l_party_rec.source_id := rec.seafarer_id;
                  l_party_rec.xref_source_table := NULL;
                  l_party_rec.xref_source_table_column := NULL;
                  l_party_rec.xref_source_id := NULL;
                  l_party_rec.full_name :=
                                TRIM (rec.first_name || ' ' || rec.last_name);
                  l_party_rec.family_name := rec.last_name;
                  l_party_rec.given_name := rec.first_name;

                  IF rec.birth_date IS NOT NULL
                  THEN
                     l_party_rec.date_of_birth :=
                                         TO_CHAR (rec.birth_date, 'YYYYMMDD');
                  END IF;

                  l_party_rec.sex := UPPER (rec.gender);
                  l_party_rec.imo_number := NULL;
                  l_party_rec.department := NULL;
                  l_party_rec.office := NULL;
                  l_party_rec.priority := NULL;
                  l_party_rec.risk_level := NULL;
                  l_party_rec.document_type := NULL;
                  l_party_rec.closed_date := NULL;
                  l_party_rec.assigned_to := NULL;
                  l_party_rec.vessel_indicator := NULL;
                  l_party_rec.passport_number := NULL;
                  l_party_rec.passport_issuing_country_code :=
                                        get_country_iso_code (rec.nationality);
                  l_party_rec.citizenship_country_code := NULL;
                  l_party_rec.country_of_residence :=
                             get_country_iso_code (rec.residence_country_code);
                  l_party_rec.city_of_residence_id := NULL;
                  l_party_rec.note := NULL;
                  l_party_rec.start_date := SYSDATE;
                  l_party_rec.end_date := NULL;
                  l_party_rec.last_update_date := SYSDATE;
                  l_party_rec.last_updated_by := l_user_id;
                  l_party_rec.creation_date := SYSDATE;
                  l_party_rec.created_by := l_user_id;
                  l_party_rec.last_update_login := l_login_id;
                  l_party_rec.source_target_column := NULL;
                  l_party_rec.batch_id := l_batch_id;
                  EXIT;
               END LOOP;
            END IF;
         ELSIF p_source_table = 'CORP_MAIN'
         THEN
            FOR rec IN cur_corp
            LOOP
               --
               l_party_rec.wc_screening_request_id := NULL;
               l_party_rec.relationship_type := 'Primary';
               l_party_rec.entity_type := 'ORGANISATION';
               l_party_rec.state := 'Verified';
               l_party_rec.status := 'Enabled';
               l_party_rec.source_table := 'CORP_MAIN';
               l_party_rec.source_table_column := 'CORP_ID';
               l_party_rec.source_id := rec.corp_id;
               l_party_rec.xref_source_table := NULL;
               l_party_rec.xref_source_table_column := NULL;
               l_party_rec.xref_source_id := NULL;
               l_party_rec.full_name := TRIM (rec.corp_name1);
               l_party_rec.family_name := NULL;
               l_party_rec.given_name := NULL;
               l_party_rec.date_of_birth := NULL;
               l_party_rec.sex := NULL;
               l_party_rec.imo_number := NULL;
               l_party_rec.department := NULL;
               l_party_rec.office := NULL;
               l_party_rec.priority := NULL;
               l_party_rec.risk_level := NULL;
               l_party_rec.document_type := NULL;
               l_party_rec.closed_date := NULL;
               l_party_rec.assigned_to := NULL;
               l_party_rec.vessel_indicator := NULL;
               l_party_rec.passport_number := NULL;
               l_party_rec.passport_issuing_country_code := NULL;
               l_party_rec.citizenship_country_code := NULL;
               l_party_rec.country_of_residence := NULL;
               l_party_rec.city_of_residence_id := NULL;
               l_party_rec.note := NULL;
               l_party_rec.start_date := SYSDATE;
               l_party_rec.end_date := NULL;
               l_party_rec.last_update_date := SYSDATE;
               l_party_rec.last_updated_by := l_user_id;
               l_party_rec.creation_date := SYSDATE;
               l_party_rec.created_by := l_user_id;
               l_party_rec.last_update_login := l_login_id;
               l_party_rec.source_target_column := NULL;
               l_party_rec.batch_id := l_batch_id;
            END LOOP;
         ELSIF p_source_table = 'AR_CUSTOMERS'
         THEN
            FOR rec IN cur_customer
            LOOP
               --
               l_party_rec.wc_screening_request_id := NULL;
               l_party_rec.relationship_type := 'Primary';
               l_party_rec.entity_type := 'ORGANISATION';
               l_party_rec.state := 'Verified';
               l_party_rec.status := 'Enabled';
               l_party_rec.source_table := 'AR_CUSTOMERS';
               l_party_rec.source_table_column := 'CUSTOMER_ID';
               l_party_rec.source_id := rec.customer_id;
               l_party_rec.xref_source_table := NULL;
               l_party_rec.xref_source_table_column := NULL;
               l_party_rec.xref_source_id := NULL;
               l_party_rec.full_name := TRIM (rec.customer_name);
               l_party_rec.family_name := NULL;
               l_party_rec.given_name := NULL;
               l_party_rec.date_of_birth := NULL;
               l_party_rec.sex := NULL;
               l_party_rec.imo_number := NULL;
               l_party_rec.department := NULL;
               l_party_rec.office := NULL;
               l_party_rec.priority := NULL;
               l_party_rec.risk_level := NULL;
               l_party_rec.document_type := NULL;
               l_party_rec.closed_date := NULL;
               l_party_rec.assigned_to := NULL;
               l_party_rec.vessel_indicator := NULL;
               l_party_rec.passport_number := NULL;
               l_party_rec.passport_issuing_country_code := NULL;
               l_party_rec.citizenship_country_code := NULL;
               l_party_rec.country_of_residence := NULL;
               l_party_rec.city_of_residence_id := NULL;
               l_party_rec.note := NULL;
               l_party_rec.start_date := SYSDATE;
               l_party_rec.end_date := NULL;
               l_party_rec.last_update_date := SYSDATE;
               l_party_rec.last_updated_by := l_user_id;
               l_party_rec.creation_date := SYSDATE;
               l_party_rec.created_by := l_user_id;
               l_party_rec.last_update_login := l_login_id;
               l_party_rec.source_target_column := NULL;
               l_party_rec.batch_id := l_batch_id;
            END LOOP;
         ELSIF p_source_table = 'INSP_INSPECTORS'
         THEN
            FOR rec IN cur_inspectors
            LOOP
               --
               l_party_rec.wc_screening_request_id := NULL;
               l_party_rec.relationship_type := 'Primary';
               l_party_rec.entity_type := 'ORGANISATION';
               l_party_rec.state := 'Verified';
               l_party_rec.status := 'Enabled';
               l_party_rec.source_table := 'INSP_INSPECTORS';
               l_party_rec.source_table_column := 'INSPECTOR_ID';
               l_party_rec.source_id := rec.inspector_id;
               l_party_rec.xref_source_table := NULL;
               l_party_rec.xref_source_table_column := NULL;
               l_party_rec.xref_source_id := NULL;
               l_party_rec.full_name := TRIM (rec.NAME);
               l_party_rec.family_name := NULL;
               l_party_rec.given_name := NULL;
               l_party_rec.date_of_birth := NULL;
               l_party_rec.sex := NULL;
               l_party_rec.imo_number := NULL;
               l_party_rec.department := NULL;
               l_party_rec.office := NULL;
               l_party_rec.priority := NULL;
               l_party_rec.risk_level := NULL;
               l_party_rec.document_type := NULL;
               l_party_rec.closed_date := NULL;
               l_party_rec.assigned_to := NULL;
               l_party_rec.vessel_indicator := NULL;
               l_party_rec.passport_number := NULL;
               l_party_rec.passport_issuing_country_code := NULL;
               l_party_rec.citizenship_country_code := NULL;
               l_party_rec.country_of_residence := NULL;
               l_party_rec.city_of_residence_id := NULL;
               l_party_rec.note := NULL;
               l_party_rec.start_date := SYSDATE;
               l_party_rec.end_date := NULL;
               l_party_rec.last_update_date := SYSDATE;
               l_party_rec.last_updated_by := l_user_id;
               l_party_rec.creation_date := SYSDATE;
               l_party_rec.created_by := l_user_id;
               l_party_rec.last_update_login := l_login_id;
               l_party_rec.source_target_column := NULL;
               l_party_rec.batch_id := l_batch_id;
            END LOOP;
         ELSIF p_source_table = 'VSSL_VESSELS'
         THEN
            FOR rec IN cur_vessels
            LOOP
               --
               l_party_rec.wc_screening_request_id := NULL;
               l_party_rec.relationship_type := 'Primary';
               l_party_rec.entity_type := 'VESSEL';
               l_party_rec.state := 'Verified';
               l_party_rec.status := 'Enabled';
               l_party_rec.source_table := 'VSSL_VESSELS';
               l_party_rec.source_table_column := 'VESSEL_PK';
               l_party_rec.source_id := rec.vessel_pk;
               l_party_rec.xref_source_table := NULL;
               l_party_rec.xref_source_table_column := NULL;
               l_party_rec.xref_source_id := NULL;
               l_party_rec.full_name := rec.NAME;
               l_party_rec.family_name := NULL;
               l_party_rec.given_name := NULL;
               l_party_rec.date_of_birth := NULL;
               l_party_rec.sex := NULL;
               l_party_rec.imo_number := rec.imo_number;
               l_party_rec.department := NULL;
               l_party_rec.office := NULL;
               l_party_rec.priority := NULL;
               l_party_rec.risk_level := NULL;
               l_party_rec.document_type := NULL;
               l_party_rec.closed_date := NULL;
               l_party_rec.assigned_to := NULL;
               l_party_rec.vessel_indicator := 'Y';
               l_party_rec.passport_number := NULL;
               l_party_rec.passport_issuing_country_code := NULL;
               l_party_rec.citizenship_country_code := NULL;
               l_party_rec.country_of_residence := NULL;
               l_party_rec.city_of_residence_id := NULL;
               l_party_rec.note := NULL;
               l_party_rec.start_date := SYSDATE;
               l_party_rec.end_date := NULL;
               l_party_rec.last_update_date := SYSDATE;
               l_party_rec.last_updated_by := l_user_id;
               l_party_rec.creation_date := SYSDATE;
               l_party_rec.created_by := l_user_id;
               l_party_rec.last_update_login := l_login_id;
               l_party_rec.source_target_column := NULL;
               l_party_rec.batch_id := l_batch_id;
            END LOOP;
         ELSIF p_source_table = 'VSSL_CONTACTS_V'
         THEN
            FOR rec IN cur_vssl_contacts
            LOOP
               --
               l_party_rec.wc_screening_request_id := NULL;
               l_party_rec.relationship_type := 'Primary';
               l_party_rec.entity_type := 'INDIVIDUAL';
               l_party_rec.state := 'Verified';
               l_party_rec.status := 'Enabled';
               l_party_rec.source_table := 'VSSL_CONTACTS_V';
               l_party_rec.source_table_column := 'CONTACT_ID';
               l_party_rec.source_id := rec.contact_id;
               l_party_rec.xref_source_table := NULL;
               l_party_rec.xref_source_table_column := NULL;
               l_party_rec.xref_source_id := NULL;
               l_party_rec.full_name :=
                                TRIM (rec.first_name || ' ' || rec.last_name);
               l_party_rec.family_name := rec.last_name;
               l_party_rec.given_name := rec.first_name;
               --               l_party_rec.date_of_birth :=
               --                                         TO_CHAR (rec.birth_date, 'YYYYMMDD');
               --               l_party_rec.sex := UPPER (rec.gender);
               l_party_rec.imo_number := NULL;
               l_party_rec.department := NULL;
               l_party_rec.office := NULL;
               l_party_rec.priority := NULL;
               l_party_rec.risk_level := NULL;
               l_party_rec.document_type := NULL;
               l_party_rec.closed_date := NULL;
               l_party_rec.assigned_to := NULL;
               l_party_rec.vessel_indicator := NULL;
               l_party_rec.passport_number := NULL;
               l_party_rec.passport_issuing_country_code := NULL;
               l_party_rec.citizenship_country_code := NULL;
               l_party_rec.country_of_residence := rec.country;
               -- get_country_code (rec.country);
               l_party_rec.city_of_residence_id := NULL;
               l_party_rec.note := NULL;
               l_party_rec.start_date := SYSDATE;
               l_party_rec.end_date := NULL;
               l_party_rec.last_update_date := SYSDATE;
               l_party_rec.last_updated_by := l_user_id;
               l_party_rec.creation_date := SYSDATE;
               l_party_rec.created_by := l_user_id;
               l_party_rec.last_update_login := l_login_id;
               l_party_rec.source_target_column := NULL;
               l_party_rec.batch_id := l_batch_id;
            END LOOP;
         ELSIF p_source_table = 'REG11_HEADER'
         THEN
            FOR rec IN cur_vetting
            LOOP
               --
               l_party_rec.wc_screening_request_id := NULL;
               l_party_rec.relationship_type := 'Primary';
               l_party_rec.entity_type := 'ORGANISATION';
               l_party_rec.state := 'Verified';
               l_party_rec.status := 'Enabled';
               l_party_rec.source_table := 'REG11_HEADER';
               l_party_rec.source_table_column := 'REG11_HEADER_ID';
               l_party_rec.source_id := rec.reg11_header_id;
               l_party_rec.xref_source_table := NULL;
               l_party_rec.xref_source_table_column := NULL;
               l_party_rec.xref_source_id := NULL;
               l_party_rec.full_name := rec.current_name;
               l_party_rec.family_name := NULL;
               l_party_rec.given_name := NULL;
               l_party_rec.date_of_birth := NULL;
               l_party_rec.sex := NULL;
               l_party_rec.imo_number := rec.imo_number;
               l_party_rec.department := NULL;
               l_party_rec.office := NULL;
               l_party_rec.priority := NULL;
               l_party_rec.risk_level := NULL;
               l_party_rec.document_type := NULL;
               l_party_rec.closed_date := NULL;
               l_party_rec.assigned_to := NULL;
               l_party_rec.vessel_indicator := NULL;
               l_party_rec.passport_number := NULL;
               l_party_rec.passport_issuing_country_code := NULL;
               l_party_rec.citizenship_country_code := NULL;
               l_party_rec.country_of_residence := NULL;
               l_party_rec.city_of_residence_id := NULL;
               l_party_rec.note := NULL;
               l_party_rec.start_date := SYSDATE;
               l_party_rec.end_date := NULL;
               l_party_rec.last_update_date := SYSDATE;
               l_party_rec.last_updated_by := l_user_id;
               l_party_rec.creation_date := SYSDATE;
               l_party_rec.created_by := l_user_id;
               l_party_rec.last_update_login := l_login_id;
               l_party_rec.source_target_column := NULL;
               l_party_rec.batch_id := l_batch_id;
            END LOOP;
         ELSIF p_source_table = 'NRMI_CERTIFICATES'
         THEN
            FOR rec IN cur_nrmi
            LOOP
               --
               l_party_rec.wc_screening_request_id := NULL;
               l_party_rec.relationship_type := 'Primary';
               l_party_rec.entity_type := 'ORGANISATION';
               l_party_rec.state := 'Verified';
               l_party_rec.status := 'Enabled';
               l_party_rec.source_table := 'NRMI_CERTIFICATES';
               l_party_rec.source_table_column := 'NRMI_CERTIFICATES_ID';
               l_party_rec.source_id := rec.nrmi_certificates_id;
               l_party_rec.xref_source_table := NULL;
               l_party_rec.xref_source_table_column := NULL;
               l_party_rec.xref_source_id := NULL;
               l_party_rec.full_name := rec.rq_name;
               l_party_rec.family_name := NULL;
               l_party_rec.given_name := NULL;
               l_party_rec.date_of_birth := NULL;
               l_party_rec.sex := NULL;
               l_party_rec.imo_number := NULL;
               l_party_rec.department := 'VESDOC';
               l_party_rec.office := NULL;
               l_party_rec.priority := NULL;
               --SAURABH 22-JAN-2020
               --l_party_rec.risk_level := NULL;
               l_party_rec.risk_level := '1';
               l_party_rec.document_type := 'NRMI';
               l_party_rec.closed_date := NULL;
               l_party_rec.assigned_to := NULL;
               l_party_rec.vessel_indicator := NULL;
               l_party_rec.passport_number := NULL;
               l_party_rec.passport_issuing_country_code := NULL;
               l_party_rec.citizenship_country_code := NULL;
               l_party_rec.country_of_residence := NULL;
               l_party_rec.city_of_residence_id := NULL;
               l_party_rec.note := NULL;
               l_party_rec.start_date := SYSDATE;
               l_party_rec.end_date := NULL;
               l_party_rec.last_update_date := SYSDATE;
               l_party_rec.last_updated_by := l_user_id;
               l_party_rec.creation_date := SYSDATE;
               l_party_rec.created_by := l_user_id;
               l_party_rec.last_update_login := l_login_id;
               l_party_rec.source_target_column := NULL;
               l_party_rec.batch_id := l_batch_id;
            END LOOP;
         END IF;

         DBMS_OUTPUT.put_line (   'Insert data into party master..'
                               || l_party_rec.relationship_type
                              );

         IF l_party_rec.source_id IS NOT NULL
         THEN
            INSERT INTO xwrl_party_master
                 VALUES l_party_rec;

            COMMIT;
         END IF;

         x_id := l_party_rec.ID;
         l_party_rec := NULL;
         --
         insert_cross_references (p_source_table,
                                  p_source_table_column,
                                  p_source_id,
                                  x_id
                                 );
      --         -- Create Cross Reference Relations
      --         IF p_source_table = 'CORP_MAIN'
      --         THEN
      --            FOR rec IN cur_corp
      --            LOOP
      --               IF rec.customer_id IS NOT NULL
      --               THEN
      --                  -- insert customer
      --                  FOR rec_cust IN cur_customer
      --                  LOOP
      --                     --
      --                     l_party_rec.wc_screening_request_id := NULL;
      --                     l_party_rec.relationship_type := 'Standalone';
      --                     l_party_rec.entity_type := 'ORGANISATION';
      --                     l_party_rec.state := 'Verified';
      --                     l_party_rec.status := 'Enabled';
      --                     l_party_rec.source_table := 'CORP_MAIN';
      --                     l_party_rec.source_table_column := 'CORP_ID';
      --                     l_party_rec.source_id := rec.corp_id;
      --                     l_party_rec.xref_source_table := NULL;
      --                     l_party_rec.xref_source_table_column := NULL;
      --                     l_party_rec.xref_source_id := NULL;
      --                     l_party_rec.full_name := rec_cust.customer_name;
      --                     l_party_rec.family_name := NULL;
      --                     l_party_rec.given_name := NULL;
      --                     l_party_rec.date_of_birth := NULL;
      --                     l_party_rec.sex := NULL;
      --                     l_party_rec.imo_number := NULL;
      --                     l_party_rec.department := NULL;
      --                     l_party_rec.office := NULL;
      --                     l_party_rec.priority := NULL;
      --                     l_party_rec.risk_level := NULL;
      --                     l_party_rec.document_type := NULL;
      --                     l_party_rec.closed_date := NULL;
      --                     l_party_rec.assigned_to := NULL;
      --                     l_party_rec.vessel_indicator := NULL;
      --                     l_party_rec.passport_number := NULL;
      --                     l_party_rec.passport_issuing_country_code := NULL;
      --                     l_party_rec.citizenship_country_code := NULL;
      --                     l_party_rec.country_of_residence := NULL;
      --                     l_party_rec.city_of_residence_id := NULL;
      --                     l_party_rec.note := NULL;
      --                     l_party_rec.start_date := SYSDATE;
      --                     l_party_rec.end_date := NULL;
      --                     l_party_rec.last_update_date := SYSDATE;
      --                     l_party_rec.last_updated_by := l_user_id;
      --                     l_party_rec.creation_date := SYSDATE;
      --                     l_party_rec.created_by := l_user_id;
      --                     l_party_rec.last_update_login := l_login_id;
      --                     l_party_rec.source_target_column := NULL;
      --                     l_party_rec.batch_id := l_batch_id;

      --                     INSERT INTO xwrl_party_master
      --                          VALUES l_party_rec;

      --                     COMMIT;
      --                  END LOOP;
      --               END IF;
      --            END LOOP;
      --         END IF;
      ELSE
         DBMS_OUTPUT.put_line ('Master exists');
      END IF;
   END insert_party_master;

   PROCEDURE insert_cross_references (
      p_source_table          IN   VARCHAR2,
      p_source_table_column   IN   VARCHAR2,
      p_source_id             IN   NUMBER,
      p_id                    IN   NUMBER
   )
   IS
      --
      --Fetch corp details
      CURSOR cur_corp
      IS
         SELECT *
           FROM corp_main
          WHERE corp_id = p_source_id;

      --Fetch Inspection details
      CURSOR insp_contacts
      IS
         SELECT DECODE (insp.sex,
                        'M', 'MALE',
                        'F', 'FEMALE',
                        insp.sex
                       ) gender,
                insp.*
           FROM insp_inspector_contacts insp
          WHERE inspector_id = p_source_id AND NVL (enabled, 'Y') = 'Y';

      CURSOR cur_nrmi
      IS
         SELECT *
           FROM nrmi_certificates
          WHERE nrmi_certificates_id = p_source_id;

      CURSOR get_vessel
      IS
         SELECT *
           FROM nrmi_vessels
          WHERE nrmi_certificates_id = p_source_id;

      CURSOR get_known_parties
      IS
         SELECT *
           FROM nrmi_known_parties
          WHERE nrmi_certificates_id = p_source_id;

      CURSOR cust_contacts
      IS
         SELECT *
           FROM ra_contacts
          WHERE customer_id = p_source_id
            AND job_title = 'FILING AGENT'
            AND status = 'A';

      --
      lv_cnt          NUMBER;
      lv_id           NUMBER;
      lv_name         VARCHAR2 (400);
      lv_last_name    VARCHAR2 (400);
      lv_first_name   VARCHAR2 (400);
      l_party_rec     xwrl_party_master%ROWTYPE;
      l_login_id      NUMBER                 := fnd_profile.VALUE ('LOGIN_ID');
      l_user_id       NUMBER                  := fnd_profile.VALUE ('USER_ID');
   --
   BEGIN
      --
      IF p_source_table = 'CORP_MAIN'
      THEN
         --
         FOR l_rec IN cur_corp
         LOOP
            --
            IF l_rec.customer_id IS NOT NULL
            THEN
               BEGIN
                  SELECT MAX (ID)
                    INTO lv_id
                    --FROM xwrl_party_master xpm, ar_customers ac
                  FROM   xwrl_party_master xpm,
                         hz_parties hp,
                         hz_cust_accounts hca
                   WHERE xpm.source_id = hca.cust_account_id
                     AND hca.party_id = hp.party_id
                     AND TRIM (xpm.full_name) = TRIM (hp.party_name)
                     AND xpm.source_id = l_rec.customer_id
                     AND xpm.source_table = 'AR_CUSTOMERS'
                     AND xpm.source_table_column = 'CUSTOMER_ID'
                     AND xpm.entity_type = 'ORGANISATION';
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     lv_id := NULL;
               END;

               IF lv_id IS NULL
               THEN
                  rmi_ows_common_util.insert_party_master ('AR_CUSTOMERS',
                                                           'CUSTOMER_ID',
                                                           l_rec.customer_id,
                                                           lv_id
                                                          );
               END IF;

               --Insert into party cross ref
               INSERT INTO xwrl_party_xref
                           (master_id, relationship_master_id,
                            relationship_type, state,
                            status, last_update_date, last_updated_by,
                            creation_date, created_by, last_update_login,
                            start_date, end_date
                           )
                    VALUES (p_id, lv_id,
                            'ORGANISATION to ORGANISATION', 'Verified',
                            'Enabled', SYSDATE, l_user_id,
                            SYSDATE, l_user_id, l_login_id,
                            SYSDATE, NULL
                           );

               COMMIT;
            --
            END IF;

            lv_id := NULL;

            IF l_rec.contact_id IS NOT NULL
            THEN
               --
               BEGIN
                  --
                  SELECT first_name, last_name,
                         TRIM (first_name || ' ' || last_name)
                    INTO lv_first_name, lv_last_name,
                         lv_name
                    FROM ra_contacts
                   WHERE contact_id = l_rec.contact_id;
               --
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     lv_name := NULL;
               END;

               BEGIN
                  SELECT MAX (ID)
                    INTO lv_id
                    FROM xwrl_party_master xpm
                   WHERE TRIM (xpm.full_name) = lv_name
                     AND xpm.source_id = l_rec.customer_id
                     AND xpm.source_table = 'AR_CUSTOMERS'
                     AND xpm.source_table_column = 'CUSTOMER_ID';
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     lv_id := NULL;
               END;

               --
               IF lv_id IS NULL
               THEN
                  --
                  lv_id := xwrl.xwrl_party_master_seq.NEXTVAL;
                  --
                  l_party_rec.ID := lv_id;
                  l_party_rec.wc_screening_request_id := NULL;
                  l_party_rec.relationship_type := 'Standalone';
                  l_party_rec.entity_type := 'INDIVIDUAL';
                  l_party_rec.state := 'Verified';
                  l_party_rec.status := 'Enabled';
                  l_party_rec.source_table := 'AR_CUSTOMERS';
                  l_party_rec.source_table_column := 'CUSTOMER_ID';
                  l_party_rec.source_id := l_rec.customer_id;
                  l_party_rec.xref_source_table := NULL;
                  l_party_rec.xref_source_table_column := NULL;
                  l_party_rec.xref_source_id := NULL;
                  l_party_rec.full_name := lv_name;
                  l_party_rec.family_name := lv_last_name;
                  l_party_rec.given_name := lv_first_name;
                  l_party_rec.date_of_birth := NULL;
                  l_party_rec.sex := NULL;
                  l_party_rec.imo_number := NULL;
                  l_party_rec.department := NULL;
                  l_party_rec.office := NULL;
                  l_party_rec.priority := NULL;
                  l_party_rec.risk_level := NULL;
                  l_party_rec.document_type := NULL;
                  l_party_rec.closed_date := NULL;
                  l_party_rec.assigned_to := NULL;
                  l_party_rec.vessel_indicator := NULL;
                  l_party_rec.passport_number := NULL;
                  l_party_rec.passport_issuing_country_code := NULL;
                  l_party_rec.citizenship_country_code := NULL;
                  l_party_rec.country_of_residence := NULL;
                  l_party_rec.city_of_residence_id := NULL;
                  l_party_rec.note := NULL;
                  l_party_rec.start_date := SYSDATE;
                  l_party_rec.end_date := NULL;
                  l_party_rec.last_update_date := SYSDATE;
                  l_party_rec.last_updated_by := l_user_id;
                  l_party_rec.creation_date := SYSDATE;
                  l_party_rec.created_by := l_user_id;
                  l_party_rec.last_update_login := l_login_id;
                  l_party_rec.source_target_column := NULL;
                  l_party_rec.batch_id := NULL;

                  --
                  INSERT INTO xwrl_party_master
                       VALUES l_party_rec;
               --
               END IF;

               --
               --Insert into party cross ref
               INSERT INTO xwrl_party_xref
                           (master_id, relationship_master_id,
                            relationship_type, state,
                            status, last_update_date, last_updated_by,
                            creation_date, created_by, last_update_login,
                            start_date, end_date
                           )
                    VALUES (p_id, lv_id,
                            'ORGANISATION to INDIVIDUAL', 'Verified',
                            'Enabled', SYSDATE, l_user_id,
                            SYSDATE, l_user_id, l_login_id,
                            SYSDATE, NULL
                           );

               COMMIT;
            --
            END IF;
         --
         END LOOP;
      --
      ELSIF p_source_table = 'INSP_INSPECTORS'
      THEN
         --
         BEGIN
            SELECT MAX (xpm.ID)
              INTO lv_id
              FROM xwrl_party_master xpm, insp_inspectors insp
             WHERE 1 = 1
               AND xpm.source_id = insp.inspector_id
               AND TRIM (xpm.full_name) = TRIM (insp.NAME)
               AND xpm.source_table = 'INSP_INSPECTORS'
               AND xpm.source_table_column = 'INSPECTOR_ID'
               AND xpm.entity_type = 'ORGANISATION'
               AND xpm.source_id = p_source_id;
         EXCEPTION
            WHEN OTHERS
            THEN
               lv_id := NULL;
         END;

         IF lv_id IS NULL
         THEN
            rmi_ows_common_util.insert_party_master ('INSP_INSPECTORS',
                                                     'INSPECTOR_ID',
                                                     p_source_id,
                                                     lv_id
                                                    );
         END IF;

         --
         --Insert into party cross ref
         INSERT INTO xwrl_party_xref
                     (master_id, relationship_master_id, relationship_type,
                      state, status, last_update_date, last_updated_by,
                      creation_date, created_by, last_update_login,
                      start_date, end_date
                     )
              VALUES (p_id, lv_id, 'ORGANISATION to ORGANISATION',
                      'Verified', 'Enabled', SYSDATE, l_user_id,
                      SYSDATE, l_user_id, l_login_id,
                      SYSDATE, NULL
                     );

         COMMIT;

         --Fetch Inspection Contacts
         FOR l_rec IN insp_contacts
         LOOP
            --
            lv_id := NULL;

            --
            BEGIN
               SELECT MAX (xpm.ID)
                 INTO lv_id
                 FROM xwrl_party_master xpm
                WHERE 1 = 1
                  AND UPPER (TRIM (xpm.full_name)) =
                         UPPER (TRIM (l_rec.given_name || ' ' || l_rec.surname)
                               )
                  AND xpm.source_table = 'INSP_INSPECTORS'
                  AND xpm.source_table_column = 'INSPECTOR_ID'
                  AND xpm.entity_type = 'INDIVIDUAL'
                  AND xpm.source_id = p_source_id;
            EXCEPTION
               WHEN OTHERS
               THEN
                  lv_id := NULL;
            END;

            --
            IF lv_id IS NULL
            THEN
               --
               lv_id := xwrl.xwrl_party_master_seq.NEXTVAL;
               --
               l_party_rec.ID := lv_id;
               l_party_rec.wc_screening_request_id := NULL;
               l_party_rec.relationship_type := 'Standalone';
               l_party_rec.entity_type := 'INDIVIDUAL';
               l_party_rec.state := 'Verified';
               l_party_rec.status := 'Enabled';
               l_party_rec.source_table := 'INSP_INSPECTORS';
               l_party_rec.source_table_column := 'INSPECTOR_ID';
               l_party_rec.source_id := l_rec.inspector_id;
               l_party_rec.xref_source_table := NULL;
               l_party_rec.xref_source_table_column := NULL;
               l_party_rec.xref_source_id := NULL;
               l_party_rec.full_name :=
                              TRIM (l_rec.given_name || ' ' || l_rec.surname);
               l_party_rec.family_name := l_rec.surname;
               l_party_rec.given_name := l_rec.given_name;
               --l_party_rec.date_of_birth := l_rec.birth_date;
               l_party_rec.date_of_birth := TO_CHAR(l_rec.birth_date,'YYYYMMDD');
               l_party_rec.sex := l_rec.gender;
               l_party_rec.imo_number := NULL;
               l_party_rec.department := NULL;
               l_party_rec.office := NULL;
               l_party_rec.priority := NULL;
               l_party_rec.risk_level := NULL;
               l_party_rec.document_type := NULL;
               l_party_rec.closed_date := NULL;
               l_party_rec.assigned_to := NULL;
               l_party_rec.vessel_indicator := NULL;
               l_party_rec.passport_number := NULL;
               l_party_rec.passport_issuing_country_code := NULL;
               l_party_rec.citizenship_country_code := NULL;
               l_party_rec.country_of_residence := NULL;
               l_party_rec.city_of_residence_id := NULL;
               l_party_rec.note := NULL;
               l_party_rec.start_date := SYSDATE;
               l_party_rec.end_date := NULL;
               l_party_rec.last_update_date := SYSDATE;
               l_party_rec.last_updated_by := l_user_id;
               l_party_rec.creation_date := SYSDATE;
               l_party_rec.created_by := l_user_id;
               l_party_rec.last_update_login := l_login_id;
               l_party_rec.source_target_column := NULL;
               l_party_rec.batch_id := NULL;

               --
               INSERT INTO xwrl_party_master
                    VALUES l_party_rec;
            --
            END IF;

            --
            --Insert into party cross ref
            INSERT INTO xwrl_party_xref
                        (master_id, relationship_master_id,
                         relationship_type, state, status,
                         last_update_date, last_updated_by, creation_date,
                         created_by, last_update_login, start_date, end_date
                        )
                 VALUES (p_id, lv_id,
                         'ORGANISATION to INDIVIDUAL', 'Verified', 'Enabled',
                         SYSDATE, l_user_id, SYSDATE,
                         l_user_id, l_login_id, SYSDATE, NULL
                        );

            COMMIT;
         --
         END LOOP;
      --
      ELSIF p_source_table = 'NRMI_CERTIFICATES'
      THEN
         --

         -- check KP
         --
         FOR rec IN cur_nrmi
         LOOP
            -- check bill to
            IF rec.bt_customer_name IS NOT NULL
            THEN
               BEGIN
                  SELECT MAX (ID)
                    INTO lv_id
                    FROM xwrl_party_master xpm
                   WHERE 1 = 1
                     AND TRIM (xpm.full_name) = TRIM (rec.bt_customer_name)
                     AND xpm.source_id = rec.nrmi_certificates_id
                     AND xpm.source_table = 'NRMI_CERTIFICATES_bt'
                     AND xpm.source_table_column = 'NRMI_CERTIFICATES_ID';
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     lv_id := NULL;
               END;

               IF lv_id IS NULL
               THEN
                  lv_id := xwrl.xwrl_party_master_seq.NEXTVAL;
                  l_party_rec.ID := lv_id;
                  l_party_rec.wc_screening_request_id := NULL;
                  l_party_rec.relationship_type := 'Standalone';
                  l_party_rec.entity_type := 'ORGANISATION';
                  l_party_rec.state := 'Verified';
                  l_party_rec.status := 'Enabled';
                  l_party_rec.source_table := 'NRMI_CERTIFICATES_bt';
                  l_party_rec.source_table_column := 'NRMI_CERTIFICATES_ID';
                  l_party_rec.source_id := rec.nrmi_certificates_id;
                  l_party_rec.xref_source_table := NULL;
                  l_party_rec.xref_source_table_column := NULL;
                  l_party_rec.xref_source_id := NULL;
                  l_party_rec.full_name := TRIM (rec.bt_customer_name);
                  l_party_rec.family_name := NULL;
                  l_party_rec.given_name := NULL;
                  l_party_rec.date_of_birth := NULL;
                  l_party_rec.sex := NULL;
                  l_party_rec.imo_number := NULL;
                  l_party_rec.department := 'VESDOC';
                  l_party_rec.office := NULL;
                  l_party_rec.priority := '1';
                  l_party_rec.risk_level := NULL;
                  l_party_rec.document_type := 'NRMI';
                  l_party_rec.closed_date := NULL;
                  l_party_rec.assigned_to := NULL;
                  l_party_rec.vessel_indicator := NULL;
                  l_party_rec.passport_number := NULL;
                  l_party_rec.passport_issuing_country_code := NULL;
                  l_party_rec.citizenship_country_code := NULL;
                  l_party_rec.country_of_residence := NULL;
                  l_party_rec.city_of_residence_id := NULL;
                  l_party_rec.note := NULL;
                  l_party_rec.start_date := SYSDATE;
                  l_party_rec.end_date := NULL;
                  l_party_rec.last_update_date := SYSDATE;
                  l_party_rec.last_updated_by := l_user_id;
                  l_party_rec.creation_date := SYSDATE;
                  l_party_rec.created_by := l_user_id;
                  l_party_rec.last_update_login := l_login_id;
                  l_party_rec.source_target_column := NULL;

                  INSERT INTO xwrl_party_master
                       VALUES l_party_rec;
               END IF;

               --Insert into party cross ref
               INSERT INTO xwrl_party_xref
                           (master_id, relationship_master_id,
                            relationship_type, state,
                            status, last_update_date, last_updated_by,
                            creation_date, created_by, last_update_login,
                            start_date, end_date
                           )
                    VALUES (p_id, lv_id,
                            'ORGANISATION to ORGANISATION', 'Verified',
                            'Enabled', SYSDATE, l_user_id,
                            SYSDATE, l_user_id, l_login_id,
                            SYSDATE, NULL
                           );

               COMMIT;
            END IF;

            -- check vessels
            FOR rec_vessel IN get_vessel
            LOOP
               IF rec_vessel.vessel_name IS NOT NULL
               THEN
                  BEGIN
                     SELECT MAX (ID)
                       INTO lv_id
                       FROM xwrl_party_master xpm
                      WHERE 1 = 1
                        AND TRIM (xpm.full_name) =
                                                 TRIM (rec_vessel.vessel_name)
                        AND xpm.source_id = rec_vessel.nrmi_certificates_id
                        AND xpm.source_table = 'NRMI_CERTIFICATES_vssl'
                        AND xpm.source_table_column = 'NRMI_VESSELS_ID';
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        lv_id := NULL;
                  END;

                  IF lv_id IS NULL
                  THEN
                     lv_id := xwrl.xwrl_party_master_seq.NEXTVAL;
                     l_party_rec.ID := lv_id;
                     l_party_rec.wc_screening_request_id := NULL;
                     l_party_rec.relationship_type := 'Standalone';
                     l_party_rec.entity_type := 'ORGANISATION';
                     l_party_rec.state := 'Verified';
                     l_party_rec.status := 'Enabled';
                     l_party_rec.source_table := 'NRMI_CERTIFICATES_vssl';
                     l_party_rec.source_table_column := 'NRMI_VESSELS_ID';
                     l_party_rec.source_id := rec.nrmi_certificates_id;
                     l_party_rec.xref_source_table := NULL;
                     l_party_rec.xref_source_table_column := NULL;
                     l_party_rec.xref_source_id := NULL;
                     l_party_rec.full_name := TRIM (rec_vessel.vessel_name);
                     l_party_rec.family_name := NULL;
                     l_party_rec.given_name := NULL;
                     l_party_rec.date_of_birth := NULL;
                     l_party_rec.sex := NULL;
                     l_party_rec.imo_number := rec_vessel.vessel_imo_number;
                     l_party_rec.department := 'VESDOC';
                     l_party_rec.office := NULL;
                     l_party_rec.priority := '1';
                     l_party_rec.risk_level := NULL;
                     l_party_rec.document_type := 'NRMI';
                     l_party_rec.closed_date := NULL;
                     l_party_rec.assigned_to := NULL;
                     l_party_rec.vessel_indicator := 'Y';
                     l_party_rec.passport_number := NULL;
                     l_party_rec.passport_issuing_country_code := NULL;
                     l_party_rec.citizenship_country_code := NULL;
                     l_party_rec.country_of_residence := NULL;
                     l_party_rec.city_of_residence_id := NULL;
                     l_party_rec.note := NULL;
                     l_party_rec.start_date := SYSDATE;
                     l_party_rec.end_date := NULL;
                     l_party_rec.last_update_date := SYSDATE;
                     l_party_rec.last_updated_by := l_user_id;
                     l_party_rec.creation_date := SYSDATE;
                     l_party_rec.created_by := l_user_id;
                     l_party_rec.last_update_login := l_login_id;
                     l_party_rec.source_target_column := NULL;

                     INSERT INTO xwrl_party_master
                          VALUES l_party_rec;
                  END IF;

                  --Insert into party cross ref
                  INSERT INTO xwrl_party_xref
                              (master_id, relationship_master_id,
                               relationship_type, state,
                               status, last_update_date, last_updated_by,
                               creation_date, created_by, last_update_login,
                               start_date, end_date
                              )
                       VALUES (p_id, lv_id,
                               'ORGANISATION to VESSEL', 'Verified',
                               'Enabled', SYSDATE, l_user_id,
                               SYSDATE, l_user_id, l_login_id,
                               SYSDATE, NULL
                              );

                  COMMIT;
               END IF;

               -- check registered_owner_name
               IF rec_vessel.registered_owner_name IS NOT NULL
               THEN
                  BEGIN
                     SELECT MAX (ID)
                       INTO lv_id
                       FROM xwrl_party_master xpm
                      WHERE 1 = 1
                        AND TRIM (xpm.full_name) =
                                       TRIM (rec_vessel.registered_owner_name)
                        AND xpm.source_id = rec_vessel.nrmi_certificates_id
                        AND xpm.source_table = 'NRMI_VESSELS_reg_own'
                        AND xpm.source_table_column = 'NRMI_VESSELS_ID';
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        lv_id := NULL;
                  END;

                  IF lv_id IS NULL
                  THEN
                     lv_id := xwrl.xwrl_party_master_seq.NEXTVAL;
                     l_party_rec.ID := lv_id;
                     l_party_rec.wc_screening_request_id := NULL;
                     l_party_rec.relationship_type := 'Standalone';
                     l_party_rec.entity_type := 'ORGANISATION';
                     l_party_rec.state := 'Verified';
                     l_party_rec.status := 'Enabled';
                     l_party_rec.source_table := 'NRMI_VESSELS_reg_own';
                     l_party_rec.source_table_column := 'NRMI_VESSELS_ID';
                     l_party_rec.source_id := rec.nrmi_certificates_id;
                     l_party_rec.xref_source_table := NULL;
                     l_party_rec.xref_source_table_column := NULL;
                     l_party_rec.xref_source_id := NULL;
                     l_party_rec.full_name :=
                                      TRIM (rec_vessel.registered_owner_name);
                     l_party_rec.family_name := NULL;
                     l_party_rec.given_name := NULL;
                     l_party_rec.date_of_birth := NULL;
                     l_party_rec.sex := NULL;
                     l_party_rec.imo_number := NULL;
                     l_party_rec.department := 'VESDOC';
                     l_party_rec.office := NULL;
                     l_party_rec.priority := '1';
                     l_party_rec.risk_level := NULL;
                     l_party_rec.document_type := 'NRMI';
                     l_party_rec.closed_date := NULL;
                     l_party_rec.assigned_to := NULL;
                     l_party_rec.vessel_indicator := NULL;
                     l_party_rec.passport_number := NULL;
                     l_party_rec.passport_issuing_country_code := NULL;
                     l_party_rec.citizenship_country_code := NULL;
                     l_party_rec.country_of_residence := NULL;
                     l_party_rec.city_of_residence_id := NULL;
                     l_party_rec.note := NULL;
                     l_party_rec.start_date := SYSDATE;
                     l_party_rec.end_date := NULL;
                     l_party_rec.last_update_date := SYSDATE;
                     l_party_rec.last_updated_by := l_user_id;
                     l_party_rec.creation_date := SYSDATE;
                     l_party_rec.created_by := l_user_id;
                     l_party_rec.last_update_login := l_login_id;
                     l_party_rec.source_target_column := NULL;

                     INSERT INTO xwrl_party_master
                          VALUES l_party_rec;
                  END IF;

                  --Insert into party cross ref
                  INSERT INTO xwrl_party_xref
                              (master_id, relationship_master_id,
                               relationship_type, state,
                               status, last_update_date, last_updated_by,
                               creation_date, created_by, last_update_login,
                               start_date, end_date
                              )
                       VALUES (p_id, lv_id,
                               'ORGANISATION to ORGANISATION', 'Verified',
                               'Enabled', SYSDATE, l_user_id,
                               SYSDATE, l_user_id, l_login_id,
                               SYSDATE, NULL
                              );

                  COMMIT;
               END IF;
            END LOOP;

            FOR rec_kp IN get_known_parties
            LOOP
               lv_id := NULL;

               --
               BEGIN
                  SELECT MAX (xpm.ID)
                    INTO lv_id
                    FROM xwrl_party_master xpm
                   WHERE 1 = 1
                     AND xpm.full_name = rec_kp.kp_name
                     AND xpm.source_table = 'NRMI_VESSELS_KNOWN_PARTY'
                     AND xpm.source_table_column = 'NRMI_KP_ID'
                     AND xpm.source_id = p_source_id;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     lv_id := NULL;
               END;

               --
               IF lv_id IS NULL
               THEN
                  --
                  lv_id := xwrl.xwrl_party_master_seq.NEXTVAL;
                  --
                  l_party_rec.ID := lv_id;
                  l_party_rec.wc_screening_request_id := NULL;
                  l_party_rec.relationship_type := 'Standalone';
                  l_party_rec.entity_type := 'INDIVIDUAL';
                  l_party_rec.state := 'Verified';
                  l_party_rec.status := 'Enabled';
                  l_party_rec.source_table := 'NRMI_VESSELS_KNOWN_PARTY';
                  l_party_rec.source_table_column := 'NRMI_KP_ID';
                  l_party_rec.source_id := rec_kp.nrmi_certificates_id;
                  l_party_rec.xref_source_table := NULL;
                  l_party_rec.xref_source_table_column := NULL;
                  l_party_rec.xref_source_id := NULL;
                  l_party_rec.full_name := rec_kp.kp_name;
                  l_party_rec.family_name := NULL;
                  l_party_rec.given_name := NULL;
                  l_party_rec.date_of_birth := NULL;
                  l_party_rec.sex := NULL;
                  l_party_rec.imo_number := NULL;
                  l_party_rec.department := 'VESDOC';
                  l_party_rec.office := NULL;
                  l_party_rec.priority := '1';
                  l_party_rec.risk_level := NULL;
                  l_party_rec.document_type := 'NRMI';
                  l_party_rec.closed_date := NULL;
                  l_party_rec.assigned_to := NULL;
                  l_party_rec.vessel_indicator := NULL;
                  l_party_rec.passport_number := NULL;
                  l_party_rec.passport_issuing_country_code := NULL;
                  l_party_rec.citizenship_country_code := NULL;
                  l_party_rec.country_of_residence := NULL;
                  l_party_rec.city_of_residence_id := NULL;
                  l_party_rec.note := NULL;
                  l_party_rec.start_date := SYSDATE;
                  l_party_rec.end_date := NULL;
                  l_party_rec.last_update_date := SYSDATE;
                  l_party_rec.last_updated_by := l_user_id;
                  l_party_rec.creation_date := SYSDATE;
                  l_party_rec.created_by := l_user_id;
                  l_party_rec.last_update_login := l_login_id;
                  l_party_rec.source_target_column := NULL;
                  l_party_rec.batch_id := NULL;

                  --
                  INSERT INTO xwrl_party_master
                       VALUES l_party_rec;
               --
               END IF;

               --
               --Insert into party cross ref
               INSERT INTO xwrl_party_xref
                           (master_id, relationship_master_id,
                            relationship_type, state,
                            status, last_update_date, last_updated_by,
                            creation_date, created_by, last_update_login,
                            start_date, end_date
                           )
                    VALUES (p_id, lv_id,
                            'ORGANISATION to INDIVIDUAL', 'Verified',
                            'Enabled', SYSDATE, l_user_id,
                            SYSDATE, l_user_id, l_login_id,
                            SYSDATE, NULL
                           );

               COMMIT;
            END LOOP;
         END LOOP;
      ELSIF p_source_table = 'AR_CUSTOMERS'
      THEN
         --
         --         BEGIN
         --            SELECT MAX (xpm.ID)
         --              INTO lv_id
         --              FROM xwrl_party_master xpm, ar_customers insp
         --             WHERE 1 = 1
         --               AND xpm.source_id = insp.customer_id
         --               AND TRIM (xpm.full_name) = TRIM (insp.NAME)
         --               AND xpm.source_table = 'AR_CUSTOMERS'
         --               AND xpm.source_table_column = 'CUSTOMER_ID'
         --               AND xpm.source_id = p_source_id;
         --         EXCEPTION
         --            WHEN OTHERS
         --            THEN
         --               lv_id := NULL;
         --         END;

         --         IF lv_id IS NULL
         --         THEN
         --            rmi_ows_common_util.insert_party_master ('INSP_INSPECTORS',
         --                                                     'INSPECTOR_ID',
         --                                                     p_source_id,
         --                                                     lv_id
         --                                                    );
         --         END IF;

         --         --
         --         --Insert into party cross ref
         --         INSERT INTO xwrl_party_xref
         --                     (master_id, relationship_master_id, relationship_type,
         --                      state, status, last_update_date, last_updated_by,
         --                      creation_date, created_by, last_update_login,
         --                      start_date, end_date
         --                     )
         --              VALUES (p_id, lv_id, 'ORGANISATION to ORGANISATION',
         --                      'Verified', 'Enabled', SYSDATE, l_user_id,
         --                      SYSDATE, l_user_id, l_login_id,
         --                      SYSDATE, NULL
         --                     );

         --         COMMIT;

         --Fetch Inspection Contacts
         FOR l_rec IN cust_contacts
         LOOP
            --
            lv_id := NULL;

            --
            BEGIN
               SELECT MAX (xpm.ID)
                 INTO lv_id
                 FROM xwrl_party_master xpm
                WHERE 1 = 1
                  AND UPPER (TRIM (xpm.full_name)) =
                         UPPER (TRIM (l_rec.last_name || ' '
                                      || l_rec.first_name
                                     )
                               )
                  AND xpm.source_table = 'AR_CUSTOMERS'
                  AND xpm.source_table_column = 'CUSTOMER_ID'
                  AND xpm.entity_type = 'INDIVIDUAL'
                  AND xpm.source_id = p_source_id;
            EXCEPTION
               WHEN OTHERS
               THEN
                  lv_id := NULL;
            END;

            --
            IF lv_id IS NULL
            THEN
               --
               lv_id := xwrl.xwrl_party_master_seq.NEXTVAL;
               --
               l_party_rec.ID := lv_id;
               l_party_rec.wc_screening_request_id := NULL;
               l_party_rec.relationship_type := 'Standalone';
               l_party_rec.entity_type := 'INDIVIDUAL';
               l_party_rec.state := 'Verified';
               l_party_rec.status := 'Enabled';
               l_party_rec.source_table := 'AR_CUSTOMERS';
               l_party_rec.source_table_column := 'CUSTOMER_ID';
               l_party_rec.source_id := l_rec.customer_id;
               l_party_rec.xref_source_table := NULL;
               l_party_rec.xref_source_table_column := NULL;
               l_party_rec.xref_source_id := NULL;
               l_party_rec.full_name :=
                            TRIM (l_rec.first_name || ' ' || l_rec.last_name);
               l_party_rec.family_name := l_rec.last_name;
               l_party_rec.given_name := l_rec.first_name;
               l_party_rec.date_of_birth := NULL;
               l_party_rec.sex := NULL;
               l_party_rec.imo_number := NULL;
               l_party_rec.department := NULL;
               l_party_rec.office := NULL;
               l_party_rec.priority := NULL;
               l_party_rec.risk_level := NULL;
               l_party_rec.document_type := NULL;
               l_party_rec.closed_date := NULL;
               l_party_rec.assigned_to := NULL;
               l_party_rec.vessel_indicator := NULL;
               l_party_rec.passport_number := NULL;
               l_party_rec.passport_issuing_country_code := NULL;
               l_party_rec.citizenship_country_code := NULL;
               l_party_rec.country_of_residence := NULL;
               l_party_rec.city_of_residence_id := NULL;
               l_party_rec.note := NULL;
               l_party_rec.start_date := SYSDATE;
               l_party_rec.end_date := NULL;
               l_party_rec.last_update_date := SYSDATE;
               l_party_rec.last_updated_by := l_user_id;
               l_party_rec.creation_date := SYSDATE;
               l_party_rec.created_by := l_user_id;
               l_party_rec.last_update_login := l_login_id;
               l_party_rec.source_target_column := NULL;
               l_party_rec.batch_id := NULL;

               --
               INSERT INTO xwrl_party_master
                    VALUES l_party_rec;
            --
            END IF;

            --
            --Insert into party cross ref
            INSERT INTO xwrl_party_xref
                        (master_id, relationship_master_id,
                         relationship_type, state, status,
                         last_update_date, last_updated_by, creation_date,
                         created_by, last_update_login, start_date, end_date
                        )
                 VALUES (p_id, lv_id,
                         'ORGANISATION to INDIVIDUAL', 'Verified', 'Enabled',
                         SYSDATE, l_user_id, SYSDATE,
                         l_user_id, l_login_id, SYSDATE, NULL
                        );

            COMMIT;
         --
         END LOOP;
      END IF;
   --
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END insert_cross_references;

   FUNCTION remove_special_char (p_string IN VARCHAR2)
      RETURN VARCHAR2
   IS
      l_string   VARCHAR2 (500);
   BEGIN
      l_string := REPLACE (p_string, ' ', NULL);
      l_string := REPLACE (l_string, '"', NULL);
      l_string := REPLACE (l_string, '-', NULL);
      l_string := REPLACE (l_string, '.', NULL);
      RETURN l_string;
   END;

   --SAURABH 13-DEC-2019
   /*FUNCTION get_wc_status (
         p_source_table          IN   VARCHAR2,
         p_source_table_column   IN   VARCHAR2,
         p_source_id             IN   NUMBER,
         p_name_screened         IN   VARCHAR2
      )
         RETURN VARCHAR2
      IS
         tc_status   VARCHAR2 (100);
         l_status    VARCHAR2 (10);
         l_id        NUMBER;

         CURSOR cur_request
         IS
            SELECT   case_workflow, ID
   --             INTO l_status
            FROM     xwrl_requests
               WHERE 1 = 1
                 AND source_table = p_source_table
                 AND source_id = p_source_id
   --              AND case_status = 'O'
                 AND case_state NOT IN ('D', 'E')
   --              AND remove_special_char (name_screened) = remove_special_char (p_name_screened)
                 --SAURABH 11-DEC-2019
                 --SAURABH 12-DEC-2019
                 AND TRIM(XWRL_UTILS.CLEANSE_NAME (name_screened)) = TRIM(XWRL_UTILS.CLEANSE_NAME (p_name_screened))
                 AND p_source_table <> 'NRMI_CERTIFICATES'
            UNION ALL
            SELECT   case_workflow, ID
   --             INTO l_status
            FROM     xwrl_requests
               WHERE 1 = 1
                 AND source_table LIKE 'NRMI%'
                 AND source_id = p_source_id
   --              AND case_status = 'O'
                 AND case_state NOT IN ('D', 'E')
                 AND TRIM(XWRL_UTILS.CLEANSE_NAME (name_screened)) = TRIM(XWRL_UTILS.CLEANSE_NAME (p_name_screened))
                 AND p_source_table = 'NRMI_CERTIFICATES'
            ORDER BY ID DESC;
      BEGIN
         OPEN cur_request;

         FETCH cur_request
          INTO l_status, l_id;

         CLOSE cur_request;

         tc_status :=
                NVL (rmi_ows_common_util.case_wf_status (l_status), 'NO_RECORD');
         RETURN tc_status;
      EXCEPTION
         WHEN OTHERS
         THEN
            tc_status := 'NO_RECORD';
            RETURN tc_status;
      END get_wc_status;*/
   FUNCTION get_wc_status (
      p_source_table          IN   VARCHAR2,
      p_source_table_column   IN   VARCHAR2,
      p_source_id             IN   NUMBER,
      p_name_screened         IN   VARCHAR2
   )
      RETURN VARCHAR2
   IS
      tc_status           VARCHAR2 (100);
      l_status            VARCHAR2 (10);
      l_id                NUMBER;

      CURSOR get_xref_ows (p_status IN VARCHAR2, p_batch_id IN NUMBER)
      IS
         SELECT COUNT (1)
           FROM xwrl_requests
          WHERE batch_id = p_batch_id
            AND case_state NOT IN ('D', 'E')
            AND case_workflow =
                   NVL (rmi_ows_common_util.case_wf_status_dsp (p_status),
                        case_workflow
                       );

      l_batch_id          NUMBER;
      total_count         NUMBER         := 0;
      pending_count       NUMBER         := 0;
      approved_count      NUMBER         := 0;
      provisional_count   NUMBER         := 0;
      rejected_count      NUMBER         := 0;
   BEGIN
      --
      -- Get Latest Batch ID from OWS
      SELECT MAX (batch_id)
        INTO l_batch_id
        FROM xwrl_requests
       WHERE source_id = p_source_id
         AND source_table = p_source_table
         AND 1 = 1
         AND case_state NOT IN ('D', 'E');

      IF l_batch_id IS NULL
      THEN
         RETURN 'NO_RECORD';
      END IF;

      OPEN get_xref_ows (NULL, l_batch_id);

      FETCH get_xref_ows
       INTO total_count;

      CLOSE get_xref_ows;

      DBMS_OUTPUT.put_line ('total_count' || total_count);

      IF total_count = 0
      THEN
         RETURN ('NO_RECORD');
      END IF;

      OPEN get_xref_ows ('Approved', l_batch_id);

      FETCH get_xref_ows
       INTO approved_count;

      CLOSE get_xref_ows;

      IF approved_count = total_count
      THEN
         RETURN ('Approved');
      END IF;

      OPEN get_xref_ows ('Provisional', l_batch_id);

      FETCH get_xref_ows
       INTO provisional_count;

      CLOSE get_xref_ows;

      IF provisional_count + approved_count = total_count
      THEN
         RETURN ('Provisional');
      END IF;

      OPEN get_xref_ows ('Pending Provisional', l_batch_id);

      FETCH get_xref_ows
       INTO provisional_count;

      CLOSE get_xref_ows;

      IF provisional_count = total_count
      THEN
         RETURN ('Pending Provisional');
      END IF;

      OPEN get_xref_ows ('Rejected', l_batch_id);

      FETCH get_xref_ows
       INTO rejected_count;

      CLOSE get_xref_ows;

      IF rejected_count > 0
      THEN
         RETURN ('Rejected');
      END IF;

      OPEN get_xref_ows ('On Hold', l_batch_id);

      FETCH get_xref_ows
       INTO rejected_count;

      CLOSE get_xref_ows;

      IF rejected_count > 0
      THEN
         RETURN ('On Hold');
      END IF;

      OPEN get_xref_ows ('Senior Legal Review', l_batch_id);

      FETCH get_xref_ows
       INTO rejected_count;

      CLOSE get_xref_ows;

      IF rejected_count > 0
      THEN
         RETURN ('Senior Legal Review');
      END IF;

      OPEN get_xref_ows ('Legal Review', l_batch_id);

      FETCH get_xref_ows
       INTO rejected_count;

      CLOSE get_xref_ows;

      IF rejected_count > 0
      THEN
         RETURN ('Legal Review');
      END IF;

	  OPEN get_xref_ows ('Processor Review', l_batch_id);

      FETCH get_xref_ows
       INTO rejected_count;

      CLOSE get_xref_ows;

      IF rejected_count > 0
      THEN
         RETURN ('Processor Review');
      END IF;

      RETURN ('Pending');
   EXCEPTION
      WHEN OTHERS
      THEN
         tc_status := 'NO_RECORD';
         RETURN tc_status;
   END get_wc_status;

   FUNCTION get_wc_status_date (
      p_source_table          IN   VARCHAR2,
      p_source_table_column   IN   VARCHAR2,
      p_source_id             IN   NUMBER,
      p_name_screened         IN   VARCHAR2
   )
      RETURN DATE
   IS
      l_status_date   DATE;

      CURSOR cur_request
      IS
         SELECT   TRUNC (last_update_date)
             FROM xwrl_requests
            WHERE 1 = 1
              AND source_table = p_source_table
              AND source_id = p_source_id
              AND case_state NOT IN ('D', 'E')
              --AND remove_special_char (name_screened) = remove_special_char (p_name_screened)
              --SAURABH 11-DEC-2019
              AND TRIM (xwrl_utils.cleanse_name (name_screened)) =
                              TRIM (xwrl_utils.cleanse_name (p_name_screened))
         ORDER BY ID DESC;
   BEGIN
      OPEN cur_request;

      FETCH cur_request
       INTO l_status_date;

      CLOSE cur_request;

      RETURN l_status_date;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN l_status_date;
   END get_wc_status_date;

   FUNCTION master_exists (
      p_source_table          IN   VARCHAR2,
      p_source_table_column   IN   VARCHAR2,
      p_source_id             IN   NUMBER
   )
      RETURN VARCHAR2
   IS
      CURSOR get_master
      IS
         SELECT 'Y'
           FROM xwrl_party_master
          WHERE source_table = p_source_table
            AND source_table_column = p_source_table_column
            AND source_id = p_source_id
            AND relationship_type = 'Primary';

      l_flag   VARCHAR2 (10) := 'N';
   BEGIN
      OPEN get_master;

      FETCH get_master
       INTO l_flag;

      CLOSE get_master;

      RETURN l_flag;
   END;

   PROCEDURE update_case_workflow (p_request_id IN NUMBER)
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      UPDATE xwrl.xwrl_requests
         SET case_workflow = 'L'
       WHERE ID = p_request_id;

      COMMIT;
   END update_case_workflow;

   FUNCTION is_authorized_to_approve (p_user_id IN NUMBER)
      RETURN VARCHAR2
   IS
      l_tc_approver   VARCHAR2 (10);
   BEGIN
      SELECT 'Y'
        INTO l_tc_approver
        FROM fnd_lookup_values fa, fnd_user fu
       WHERE fu.user_name = fa.lookup_code
         AND lookup_type = 'WORLD_CHECK_APPROVERS'
         AND fu.user_id = p_user_id
         AND TRUNC (NVL (fa.end_date_active, SYSDATE + 1)) > TRUNC (SYSDATE);

      RETURN l_tc_approver;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 'N';
   END is_authorized_to_approve;

   --- Code Modified for HD T20200124.0030
   PROCEDURE sync_matches (
   p_request_id     IN   INTEGER,
   p_alert_in_tbl   IN   xwrl_alert_tbl_in_type,
   p_user           IN   VARCHAR2
)
IS
   l_source_id       NUMBER;
   l_source_table    VARCHAR2 (100);
   l_listid          NUMBER;
   l_userid          NUMBER;
   l_batch_id        NUMBER;
   x_status          VARCHAR2 (200);
   l_error           VARCHAR2 (500);
   l_path            VARCHAR2 (10);
   l_to_state        VARCHAR2 (25);
   i                 NUMBER;
   l_alert_in_tbl    xows.xxiri_cm_process_pkg.alert_tbl_in_type@ebstoows2.coresys.com;
   x_alert_out_tbl   xows.xxiri_cm_process_pkg.alert_tbl_out_type@ebstoows2.coresys.com;
   v_debug           VARCHAR2 (10);
   v_note_count integer;
BEGIN
   apps.mt_log_error ('Inside Sync Matches...');
   COMMIT;

   BEGIN
      SELECT user_id
        INTO l_userid
        FROM fnd_user
       WHERE user_name = p_user;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_userid := -1;
   END;

   apps.mt_log_error ('User: ' || l_userid);
   COMMIT;

   BEGIN
      SELECT UPPER (PATH)
        INTO l_path
        FROM xwrl_requests
       WHERE ID = p_request_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         l_path := NULL;
         apps.mt_log_error (   'Exception occurred while fetching Path: '
                            || SQLERRM
                           );
      WHEN TOO_MANY_ROWS
      THEN
         l_path := NULL;
         apps.mt_log_error (   'Exception occurred while fetching Path: '
                            || SQLERRM
                           );
   END;

   apps.mt_log_error ('Path: ' || l_path);
   COMMIT;

   BEGIN
      SELECT req.batch_id, req.source_id, req.source_table
        INTO l_batch_id, l_source_id, l_source_table
        FROM xwrl_requests req
       WHERE req.ID = p_request_id;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_batch_id := NULL;
         l_source_id := NULL;
         l_source_table := NULL;
         apps.mt_log_error
                      (   'Exception occurred while fetching Batch Details: '
                       || SQLERRM
                      );
   END;

   /* For debugging purposes */
   SELECT value_string
     INTO v_debug
     FROM xwrl_parameters
    WHERE ID = 'XWRL_OWS_UTILS' AND KEY = 'DEBUG';

   IF l_path = 'INDIVIDUAL'
   THEN
      apps.mt_log_error ('Inside Individual');

      FOR i IN p_alert_in_tbl.FIRST .. p_alert_in_tbl.LAST
      LOOP

      v_note_count := 0;

         apps.mt_log_error (   'Processing Alert ID: '|| p_alert_in_tbl (i).p_alert_id                           );

         IF v_debug = 'TRUE'
         THEN
            INSERT INTO xwrl_alerts_debug
                        (procedure_name, p_user,
                         p_alert_id,
                         p_to_state,
                         p_comment, creation_date, created_by
                        )
                 VALUES ('RMI_OWS_COMMON_UTIL.SYNC_MATCHES', p_user,
                         p_alert_in_tbl (i).p_alert_id,
                         p_alert_in_tbl (i).p_to_state,
                         p_alert_in_tbl (i).p_comment, SYSDATE, l_userid
                        );
         END IF;

         COMMIT;

         BEGIN
            SELECT DISTINCT listid
                       INTO l_listid
                       FROM xwrl_response_ind_columns req
                      WHERE alertid = p_alert_in_tbl (i).p_alert_id
                        AND request_id = p_request_id;
         EXCEPTION
            WHEN OTHERS
            THEN
               l_listid := NULL;
               apps.mt_log_error
                            (   'Exception occurred while fetching List ID: '
                             || SQLERRM
                            );
         END;

         apps.mt_log_error (   'Request ID: '
                            || p_request_id
                            || ' User ID: '
                            || l_userid
                            || ' Batch ID: '
                            || l_batch_id
                            || ' Source ID: '
                            || l_source_id
                            || ' List ID: '
                            || l_listid
                            || ' Alert Id: '
                            || p_alert_in_tbl (i).p_alert_id
                            || ' To State: '
                            || p_alert_in_tbl (i).p_to_state
                           ); -- tsuazo 20200528

         IF     l_source_id IS NOT NULL
            AND l_listid IS NOT NULL
            AND l_batch_id IS NOT NULL
         THEN
            apps.mt_log_error ('Inside Clear Alerts...');

            FOR r_ind_cols IN (SELECT   cols.*
                                   FROM xwrl_requests req,
                                        xwrl_response_ind_columns cols
                                  WHERE req.ID = cols.request_id
                                    AND req.source_id = l_source_id
                                    AND req.source_table = l_source_table
                                    AND req.batch_id = l_batch_id
                                    AND cols.listid = l_listid
                                    AND req.ID != p_request_id
                                    AND cols.x_state !=
                                                 p_alert_in_tbl (i).p_to_state
                               ORDER BY cols.request_id)
            LOOP
               apps.mt_log_error ('Processing Alert ID: '
                                  || r_ind_cols.alertid
                                 );

               BEGIN
                  SELECT SUBSTR (to_state, 4)
                    INTO l_to_state
                    FROM xwrl_alert_clearing_xref
                   WHERE alert_id = p_alert_in_tbl (i).p_alert_id
                     AND ID =
                             (SELECT MAX (ID)
                                FROM xwrl_alert_clearing_xref
                               WHERE alert_id = p_alert_in_tbl (i).p_alert_id);
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     apps.mt_log_error (   'Exception In Getting To State: '
                                        || SQLERRM
                                       );
                     l_to_state := NULL;
               END;

               apps.mt_log_error ('To State: ' || l_to_state);

               -- UPDATE OWS ALERT STATE
               IF l_to_state IS NOT NULL
               THEN
                  apps.mt_log_error (   'Changing Alert Id: '
                                     || r_ind_cols.alertid
                                     || ' '
                                     || 'To State: '
                                     || r_ind_cols.listrecordtype
                                     || l_to_state
                                    );
                  l_alert_in_tbl (1).alert_id := r_ind_cols.alertid;
                  l_alert_in_tbl (1).to_state :=
                     xwrl_ows_utils.changetoowsstate
                                                 (   r_ind_cols.listrecordtype
                                                  || l_to_state
                                                 );
             --xwrl_ows_utils.changetoowsstate(p_alert_in_tbl (i).p_to_state);
                  l_alert_in_tbl (1).COMMENT := 'Alert Status To Sync Matches';
                  xows.xxiri_cm_process_pkg.update_alerts@ebstoows2.coresys.com
                                          (p_user               => p_user,
                                           p_alert_in_tbl       => l_alert_in_tbl,
                                           x_alert_out_tbl      => x_alert_out_tbl,
                                           x_status             => x_status
                                          );
                  COMMIT;

                  IF v_debug = 'TRUE'
                  THEN
                     FOR i IN x_alert_out_tbl.FIRST .. x_alert_out_tbl.LAST
                     LOOP
                        INSERT INTO xwrl_alert_results_debug
                                    (procedure_name,
                                     p_request_id,
                                     p_case_key,
                                     p_alert_id,
                                     p_list_id,
                                     p_key_label,
                                     p_old_state,
                                     p_new_state,
                                     p_status,
                                     p_err_msg, creation_date,
                                     created_by
                                    )
                             VALUES ('RMI_OWS_COMMON_UTIL.SYNC_MATCHES:IND',
                                     r_ind_cols.request_id,
                                     SUBSTR
                                        (x_alert_out_tbl (i).key_label,
                                         1,
                                           INSTR
                                                (x_alert_out_tbl (i).key_label,
                                                 ':',
                                                 1
                                                )
                                         - 1
                                        ),
                                     x_alert_out_tbl (i).alert_id,
                                     TO_NUMBER
                                        (SUBSTR
                                            (x_alert_out_tbl (i).key_label,
                                               INSTR
                                                  (x_alert_out_tbl (i).key_label,
                                                   ':',
                                                   -1
                                                  )
                                             + 1,
                                             LENGTH
                                                 (x_alert_out_tbl (i).key_label
                                                 )
                                            )
                                        ),
                                     x_alert_out_tbl (i).key_label,
                                     x_alert_out_tbl (i).old_state,
                                     x_alert_out_tbl (i).new_state,
                                     x_alert_out_tbl (i).status,
                                     x_alert_out_tbl (i).err_msg, SYSDATE,
                                     l_userid
                                    );
                     END LOOP;
                  END IF;

                  apps.mt_log_error (   'API Status: '
                                     || x_status
                                     || ' '
                                     || x_alert_out_tbl (1).err_msg
                                    );

                  IF UPPER (x_status) = 'SUCCESS'
                  THEN

                  apps.mt_log_error (  'Update xwrl_response_ind_columns ');

                     UPDATE xwrl_response_ind_columns
                     --SET x_state = p_alert_in_tbl (i).p_to_state,
                        SET x_state = listrecordtype||substr(p_alert_in_tbl (i).p_to_state,4), -- tsuazo 20200528
                            last_updated_by = l_userid,
                            last_update_date = SYSDATE
                      --WHERE ID = r_ind_cols.ID AND listid = l_listid;   -- tsuazo 20200515 Alert can have multiple response  records
                      WHERE request_id = r_ind_cols.request_id AND alertid = r_ind_cols.alertid;

                     apps.mt_log_error (  'Update xwrl_response_ind_columns - ID: '|| r_ind_cols.ID|| ' UID: ' ||l_listid || ' Alert ID: '|| alertid || ' Alert State: '||  p_alert_in_tbl (i).p_to_state ); -- tsuazo 20200528

                     COMMIT;
                  END IF;
               END IF;

               -- Copy Alert notes of same matches
               --

               /*

               apps.mt_log_error (  'Update xwrl_alert_notes ');

               UPDATE xwrl_alert_notes
                  SET note =
                         (SELECT note
                            FROM xwrl_alert_notes
                           WHERE request_id = p_request_id
                             AND alert_id = p_alert_in_tbl (i).p_alert_id
                             AND ROWNUM <= 1),
                      last_update_date = SYSDATE,
                      last_updated_by = l_userid
                WHERE 1 = 1
                  AND request_id = r_ind_cols.request_id
                  AND alert_id = r_ind_cols.alertid;

                  apps.mt_log_error (  'Update xwrl_alert_notes : request_id '|| r_ind_cols.request_id|| ' AND alert_id' || r_ind_cols.alertid );

               COMMIT;

               */

               IF SQL%ROWCOUNT = 0
               THEN

                  if v_note_count = 0 then

                  apps.mt_log_error (  'Insert xwrl_alert_note ');

                  INSERT INTO xwrl_alert_notes
                     SELECT xwrl_alert_notes_seq.NEXTVAL,
                            r_ind_cols.request_id request_id,
                            r_ind_cols.alertid alert_id
                            , line_number
                            , note
                            , last_update_date
                            , last_updated_by
                            , creation_date
                            , created_by
                            , last_update_login
                       FROM xwrl_alert_notes n
                      WHERE 1 = 1
                        AND n.request_id = p_request_id
                        AND n.alert_id = p_alert_in_tbl (i).p_alert_id
                       and n.line_number not in (select x.line_number from xwrl_alert_notes x where x.request_id = r_ind_cols.request_id and x.alert_id = r_ind_cols.alertid)
                         ;

                        apps.mt_log_error (  'Insert xwrl_alert_notes - request_id:  '|| p_request_id|| ' AND alert_id: ' || p_alert_in_tbl (i).p_alert_id ); -- tsuazo 20200528

                  COMMIT;

                  v_note_count := v_note_count + 1; -- tsuazo added counter to prevent multiple notes to be created

                  end if;


               END IF;
            END LOOP;
         END IF;
      END LOOP;
   ELSIF l_path = 'ENTITY'
   THEN
      apps.mt_log_error ('Inside Entity');

      FOR i IN p_alert_in_tbl.FIRST .. p_alert_in_tbl.LAST
      LOOP

      v_note_count := 0;

         BEGIN
            SELECT listid
              INTO l_listid
              FROM xwrl_response_entity_columns
             WHERE alertid = p_alert_in_tbl (i).p_alert_id;
         EXCEPTION
            WHEN OTHERS
            THEN
               l_listid := NULL;
         END;

         apps.mt_log_error (   'Request ID: '
                            || p_request_id
                            || ' User ID: '
                            || l_userid
                            || ' Batch ID: '
                            || l_batch_id
                            || ' Source ID: '
                            || l_source_id
                            || ' List ID: '
                            || l_listid
                            || ' Alert Id: '
                            || p_alert_in_tbl (i).p_alert_id
                            || ' To State: '
                            || p_alert_in_tbl (i).p_to_state
                           ); -- tsuazo 20200528

         IF     l_source_id IS NOT NULL
            AND l_listid IS NOT NULL
            AND l_batch_id IS NOT NULL
         THEN
            apps.mt_log_error ('Inside Clear Alerts...');

            FOR r_ent_cols IN (SELECT   cols.*
                                   FROM xwrl_requests req,
                                        xwrl_response_entity_columns cols
                                  WHERE req.ID = cols.request_id
                                    AND req.source_id = l_source_id
                                    AND req.source_table = l_source_table
                                    AND req.batch_id = l_batch_id
                                    AND cols.listid = l_listid
                                    AND req.ID != p_request_id
                               ORDER BY cols.request_id)
            LOOP
               apps.mt_log_error ('Processing Alert ID: '
                                  || r_ent_cols.alertid
                                 );

               BEGIN
                  SELECT SUBSTR (to_state, 4)
                    INTO l_to_state
                    FROM xwrl_alert_clearing_xref
                   WHERE alert_id = p_alert_in_tbl (i).p_alert_id
                     AND ID =
                             (SELECT MAX (ID)
                                FROM xwrl_alert_clearing_xref
                               WHERE alert_id = p_alert_in_tbl (i).p_alert_id);
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     apps.mt_log_error (   'Exception In Getting To State: '
                                        || SQLERRM
                                       );
                     l_to_state := NULL;
               END;

               apps.mt_log_error ('To State: ' || l_to_state);

               -- UPDATE OWS ALERT STATE
               IF l_to_state IS NOT NULL
               THEN
                  apps.mt_log_error (   'Changing Alert Id: '
                                     || r_ent_cols.alertid
                                     || ' '
                                     || 'To State: '
                                     || r_ent_cols.listrecordtype
                                     || l_to_state
                                    );
                  l_alert_in_tbl (1).alert_id := r_ent_cols.alertid;
                  l_alert_in_tbl (1).to_state :=
                     xwrl_ows_utils.changetoowsstate
                                                 (   r_ent_cols.listrecordtype
                                                  || l_to_state
                                                 );
             --xwrl_ows_utils.changetoowsstate(p_alert_in_tbl (i).p_to_state);
                  l_alert_in_tbl (1).COMMENT := 'Alert Status To Sync Matches';
                  xows.xxiri_cm_process_pkg.update_alerts@ebstoows2.coresys.com
                                          (p_user               => p_user,
                                           p_alert_in_tbl       => l_alert_in_tbl,
                                           x_alert_out_tbl      => x_alert_out_tbl,
                                           x_status             => x_status
                                          );
                  COMMIT;

                  IF v_debug = 'TRUE'
                  THEN
                     FOR i IN x_alert_out_tbl.FIRST .. x_alert_out_tbl.LAST
                     LOOP
                        INSERT INTO xwrl_alert_results_debug
                                    (procedure_name,
                                     p_request_id,
                                     p_case_key,
                                     p_alert_id,
                                     p_list_id,
                                     p_key_label,
                                     p_old_state,
                                     p_new_state,
                                     p_status,
                                     p_err_msg, creation_date,
                                     created_by
                                    )
                             VALUES ('RMI_OWS_COMMON_UTIL.SYNC_MATCHES:ENTITY',
                                     r_ent_cols.request_id,
                                     SUBSTR
                                        (x_alert_out_tbl (i).key_label,
                                         1,
                                           INSTR
                                                (x_alert_out_tbl (i).key_label,
                                                 ':',
                                                 1
                                                )
                                         - 1
                                        ),
                                     x_alert_out_tbl (i).alert_id,
                                     TO_NUMBER
                                        (SUBSTR
                                            (x_alert_out_tbl (i).key_label,
                                               INSTR
                                                  (x_alert_out_tbl (i).key_label,
                                                   ':',
                                                   -1
                                                  )
                                             + 1,
                                             LENGTH
                                                 (x_alert_out_tbl (i).key_label
                                                 )
                                            )
                                        ),
                                     x_alert_out_tbl (i).key_label,
                                     x_alert_out_tbl (i).old_state,
                                     x_alert_out_tbl (i).new_state,
                                     x_alert_out_tbl (i).status,
                                     x_alert_out_tbl (i).err_msg, SYSDATE,
                                     l_userid
                                    );
                     END LOOP;
                  END IF;

                  apps.mt_log_error (   'API Status: '
                                     || x_status
                                     || ' '
                                     || x_alert_out_tbl (1).err_msg
                                    );

                  IF UPPER (x_status) = 'SUCCESS'
                  THEN

                  apps.mt_log_error (  'ENTITY Update xwrl_response_entity_columns ');

                     UPDATE xwrl_response_entity_columns
                        --SET x_state = p_alert_in_tbl (i).p_to_state,
                        SET x_state = listrecordtype||substr(p_alert_in_tbl (i).p_to_state,4), -- tsuazo 20200528
                            last_updated_by = l_userid,
                            last_update_date = SYSDATE
                      --WHERE ID = r_ent_cols.ID AND listid = l_listid; -- tsuazo 20200515 Alert can have multiple response  records
                      WHERE request_id = r_ent_cols.request_id AND alertid = r_ent_cols.alertid;

                      apps.mt_log_error (  'ENTITY Update xwrl_response_entity_columns - ID: '|| r_ent_cols.ID|| ' UID: ' ||l_listid || ' Alert ID: '|| alertid || ' Alert State: '||  p_alert_in_tbl (i).p_to_state ); -- tsuazo 20200528

                     COMMIT;
                  END IF;
               END IF;


/*
            apps.mt_log_error (  'ENTITY Update xwrl_alert_notes ');

               UPDATE xwrl_alert_notes
                  SET note =
                         (SELECT note
                            FROM xwrl_alert_notes
                           WHERE request_id = p_request_id
                             AND alert_id = p_alert_in_tbl (i).p_alert_id
                             AND ROWNUM <= 1),
                      last_update_date = SYSDATE,
                      last_updated_by = l_userid
                WHERE 1 = 1
                  AND request_id = r_ent_cols.request_id
                  AND alert_id = r_ent_cols.alertid;

                  apps.mt_log_error (  'ENTITY Update xwrl_alert_notes : request_id '|| r_ent_cols.request_id|| ' AND alert_id' || r_ent_cols.alertid );

               COMMIT;
*/
               IF SQL%ROWCOUNT = 0
               THEN

               if v_note_count = 0 then

               apps.mt_log_error (  'ENTITY Insert xwrl_alert_note ');

                  INSERT INTO xwrl_alert_notes
                     SELECT xwrl_alert_notes_seq.NEXTVAL,
                            r_ent_cols.request_id request_id,
                            r_ent_cols.alertid alert_id, line_number, note,
                            last_update_date, last_updated_by, creation_date,
                            created_by, last_update_login
                       FROM xwrl_alert_notes n
                      WHERE 1 = 1
                        AND request_id = p_request_id
                        AND n.alert_id = p_alert_in_tbl (i).p_alert_id
                       and n.line_number not in (select x.line_number from xwrl_alert_notes x where x.request_id = r_ent_cols.request_id and x.alert_id = r_ent_cols.alertid)
                        ;
                        
                         apps.mt_log_error (  'ENTITY Insert xwrl_alert_notes - request_id:  '|| p_request_id|| ' AND alert_id: ' || p_alert_in_tbl (i).p_alert_id ); -- tsuazo 20200528

                  COMMIT;

                  v_note_count := v_note_count + 1; -- tsuazo added counter to prevent multiple notes to be created

                  end if;
               END IF;
            END LOOP;
         END IF;
      END LOOP;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      mt_log_error (p_request_id || ' ' || 'API Exception' || ' ' || SQLERRM);
END sync_matches;

   --- End Code Changes

   PROCEDURE sync_alias_documents (
      p_request_id   IN   INTEGER,
      p_batch_id     IN   INTEGER
   )
   IS
      l_doc_rec     xwrl_case_documents%ROWTYPE;
      l_id          NUMBER;
      l_notes_rec   xwrl_case_notes%ROWTYPE;
   BEGIN
      apps.mt_log_error ('Inside Sync Alias Documnets...');
      COMMIT;

      FOR r_primary_rec IN (SELECT *
                              FROM xwrl_case_documents
                             WHERE request_id = p_request_id)
      LOOP
         apps.mt_log_error ('Inside Primary Rec...');
         COMMIT;
         l_doc_rec := r_primary_rec;

         FOR r_alias_rec IN (SELECT DISTINCT xr.ID, xr.case_id, xr.batch_id,
                                             xr.name_screened
                                        FROM xwrl_party_alias xpa,
                                             xwrl_requests xr,
                                             xwrl_party_master xpm
                                       WHERE 1 = 1
                                         AND xr.source_id = xpm.source_id
                                         AND xr.source_table =
                                                              xpm.source_table
                                         AND xpa.master_id = xpm.ID
                                         AND xpa.relationship_type = 'Alias'
                                         AND xr.ID != p_request_id
                                         AND xr.batch_id = p_batch_id)
         LOOP
            apps.mt_log_error ('Inside Alias Rec...');
            COMMIT;

            BEGIN
               SELECT xwrl_case_documents_seq.NEXTVAL
                 INTO l_id
                 FROM DUAL;
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_id := NULL;
                  apps.mt_log_error
                          (   'Excepption Occurred While Getting Sequence..:'
                           || SQLERRM
                          );
                  COMMIT;
            END;

            l_doc_rec.ID := l_id;
            l_doc_rec.case_id := r_alias_rec.case_id;
            l_doc_rec.request_id := r_alias_rec.ID;
            apps.mt_log_error (   'Request ID: '
                               || r_alias_rec.ID
                               || ' '
                               || 'Case ID: '
                               || r_alias_rec.case_id
                              );
            COMMIT;

            INSERT INTO xwrl_case_documents
                 VALUES l_doc_rec;

            COMMIT;
         END LOOP;
      END LOOP;

      FOR r_primary_rec IN (SELECT *
                              FROM xwrl_case_notes
                             WHERE request_id = p_request_id)
      LOOP
         apps.mt_log_error ('Inside Primary Rec...Notes');
         COMMIT;
         l_notes_rec := r_primary_rec;

         FOR r_alias_rec IN (SELECT DISTINCT xr.ID, xr.case_id, xr.batch_id,
                                             xr.name_screened
                                        FROM xwrl_party_alias xpa,
                                             xwrl_requests xr,
                                             xwrl_party_master xpm
                                       WHERE 1 = 1
                                         AND xr.source_id = xpm.source_id
                                         AND xr.source_table =
                                                              xpm.source_table
                                         AND xpa.master_id = xpm.ID
                                         AND xpa.relationship_type = 'Alias'
                                         AND xr.ID != p_request_id
                                         AND xr.batch_id = p_batch_id)
         LOOP
            apps.mt_log_error ('Inside Alias Rec...');
            COMMIT;

            BEGIN
               SELECT xwrl_case_notes_seq.NEXTVAL
                 INTO l_id
                 FROM DUAL;
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_id := NULL;
                  apps.mt_log_error
                          (   'Excepption Occurred While Getting Sequence..:'
                           || SQLERRM
                          );
                  COMMIT;
            END;

            l_notes_rec.ID := l_id;
            l_notes_rec.case_id := r_alias_rec.case_id;
            l_notes_rec.request_id := r_alias_rec.ID;
            apps.mt_log_error (   'Request ID: '
                               || r_alias_rec.ID
                               || ' '
                               || 'Case ID: '
                               || r_alias_rec.case_id
                              );
            COMMIT;

            INSERT INTO xwrl_case_notes
                 VALUES l_notes_rec;

            COMMIT;
         END LOOP;
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         apps.mt_log_error (   'Excepption Occurred Inside Sync Alias: '
                            || SQLERRM
                           );
         COMMIT;
   END sync_alias_documents;

   PROCEDURE sync_alias_notes (p_request_id IN INTEGER, p_batch_id IN INTEGER)
IS
   l_doc_rec     xwrl_case_documents%ROWTYPE;
   l_id          NUMBER;
   l_notes_rec   xwrl_case_notes%ROWTYPE;
BEGIN
   apps.mt_log_error ('Inside Sync Alias Notes...');
   COMMIT;

   FOR rec IN (SELECT ID, master_id, alias_id
                 FROM xwrl_requests
                WHERE ID = p_request_id)
   LOOP

      FOR r_alias_rec IN (SELECT xr.ID, xr.case_id, xr.batch_id,
                                 xr.name_screened
                            FROM xwrl_requests xr
                           WHERE batch_id = p_batch_id
                             AND alias_id IS NULL
                             AND rec.alias_ID IS NOT NULL
                             AND master_id = (SELECT master_id
                                                FROM xwrl.xwrl_party_alias
                                               WHERE ID = rec.alias_id)
                          UNION ALL
                          SELECT xr.ID, xr.case_id, xr.batch_id,
                                 xr.name_screened
                            FROM xwrl_requests xr
                           WHERE batch_id = p_batch_id
                             AND alias_id IS NOT NULL
                             AND rec.alias_ID IS NULL
                             AND alias_id IN (SELECT ID
                                                FROM xwrl.xwrl_party_alias
                                               WHERE master_id = rec.master_id))
      LOOP
         apps.mt_log_error ('Inside Alias Rec...');
         COMMIT;

         FOR r_primary_rec IN (SELECT *
                                 FROM xwrl_case_notes
                                WHERE request_id = p_request_id)
         LOOP
            apps.mt_log_error ('Inside Primary Rec...Notes');
            COMMIT;
            l_notes_rec := r_primary_rec;

            BEGIN
               SELECT xwrl_case_notes_seq.NEXTVAL
                 INTO l_id
                 FROM DUAL;
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_id := NULL;
                  apps.mt_log_error
                          (   'Excepption Occurred While Getting Sequence..:'
                           || SQLERRM
                          );
                  COMMIT;
            END;

            l_notes_rec.ID := l_id;
            l_notes_rec.case_id := r_alias_rec.case_id;
            l_notes_rec.request_id := r_alias_rec.ID;
            apps.mt_log_error (   'Request ID: '
                               || r_alias_rec.ID
                               || ' '
                               || 'Case ID: '
                               || r_alias_rec.case_id
                              );
            COMMIT;

            INSERT INTO xwrl_case_notes
                 VALUES l_notes_rec;

            COMMIT;
         END LOOP;
      END LOOP;
   END LOOP;
EXCEPTION
   WHEN OTHERS
   THEN
      apps.mt_log_error ('Excepption Occurred Inside Sync Alias: ' || SQLERRM);
      COMMIT;
END sync_alias_notes;

   PROCEDURE sync_batch_alias_documents (p_batch_id IN INTEGER)
   IS
      l_doc_rec   xwrl_case_documents%ROWTYPE;
      l_id        NUMBER;

      CURSOR cur_requests
      IS
         SELECT ID request_id, batch_id, master_id, xref_id
           FROM xwrl_requests
          WHERE batch_id = p_batch_id AND alias_id IS NULL;
   BEGIN
      apps.mt_log_error ('Inside Sync Batch Alias Documnets...');
      COMMIT;

      FOR rec IN cur_requests
      LOOP
         --
         FOR r_primary_rec IN (SELECT *
                                 FROM xwrl_case_documents
                                WHERE request_id = rec.request_id)
         LOOP
            apps.mt_log_error ('Inside Primary Rec...');
            COMMIT;
            l_doc_rec := r_primary_rec;

            FOR r_alias_rec IN (SELECT xr.ID, xr.case_id, xr.batch_id,
                                       xr.name_screened
                                  FROM xwrl_requests xr
                                 WHERE 1 = 1
                                   AND batch_id = rec.batch_id
                                   AND xr.alias_id IS NOT NULL
                                   AND xr.xref_id IS NULL
                                   AND xr.master_id = rec.master_id
                                UNION ALL
                                SELECT xr.ID, xr.case_id, xr.batch_id,
                                       xr.name_screened
                                  FROM xwrl_requests xr
                                 WHERE 1 = 1
                                   AND batch_id = rec.batch_id
                                   AND xr.alias_id IS NOT NULL
                                   AND xr.xref_id IS NULL
                                   AND xr.master_id =
                                              (SELECT relationship_master_id
                                                 FROM xwrl_party_xref
                                                WHERE ID = rec.xref_id))
            LOOP
               apps.mt_log_error ('Inside Alias Rec...');
               COMMIT;

               BEGIN
                  SELECT xwrl_case_documents_seq.NEXTVAL
                    INTO l_id
                    FROM DUAL;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_id := NULL;
                     apps.mt_log_error
                          (   'Excepption Occurred While Getting Sequence..:'
                           || SQLERRM
                          );
                     COMMIT;
               END;

               l_doc_rec.ID := l_id;
               l_doc_rec.case_id := r_alias_rec.case_id;
               l_doc_rec.request_id := r_alias_rec.ID;
               apps.mt_log_error (   'Request ID: '
                                  || r_alias_rec.ID
                                  || ' '
                                  || 'Case ID: '
                                  || r_alias_rec.case_id
                                 );
               COMMIT;

               INSERT INTO xwrl_case_documents
                    VALUES l_doc_rec;

               COMMIT;
            END LOOP;
         END LOOP;
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         apps.mt_log_error (   'Excepption Occurred Inside Sync Alias: '
                            || SQLERRM
                           );
         COMMIT;
   END sync_batch_alias_documents;

   PROCEDURE sync_batch_alias_notes (p_batch_id IN INTEGER)
   IS
      l_doc_rec   xwrl_case_notes%ROWTYPE;
      l_id        NUMBER;

      CURSOR cur_requests
      IS
         SELECT ID request_id, batch_id, master_id, xref_id
           FROM xwrl_requests
          WHERE batch_id = p_batch_id AND alias_id IS NULL;
   BEGIN
      apps.mt_log_error ('Inside Sync Batch Alias Documnets...');
      COMMIT;

      FOR rec IN cur_requests
      LOOP
         --
         FOR r_primary_rec IN (SELECT *
                                 FROM xwrl_case_notes
                                WHERE request_id = rec.request_id)
         LOOP
            apps.mt_log_error ('Inside Primary Rec...');
            COMMIT;
            l_doc_rec := r_primary_rec;

            FOR r_alias_rec IN (SELECT xr.ID, xr.case_id, xr.batch_id,
                                       xr.name_screened
                                  FROM xwrl_requests xr
                                 WHERE 1 = 1
                                   AND batch_id = rec.batch_id
                                   AND xr.alias_id IS NOT NULL
                                   AND xref_id IS NULL
                                   AND xr.master_id = rec.master_id
                                   UNION ALL
                                SELECT xr.ID, xr.case_id, xr.batch_id,
                                       xr.name_screened
                                  FROM xwrl_requests xr
                                 WHERE 1 = 1
                                   AND batch_id = rec.batch_id
                                   AND xr.alias_id IS NOT NULL
                                   AND xr.xref_id IS NULL
                                   AND xr.master_id =
                                              (SELECT relationship_master_id
                                                 FROM xwrl_party_xref
                                                WHERE ID = rec.xref_id))
            LOOP
               apps.mt_log_error ('Inside Alias Rec...');
               COMMIT;

               BEGIN
                  SELECT xwrl_case_notes_seq.NEXTVAL
                    INTO l_id
                    FROM DUAL;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     l_id := NULL;
                     apps.mt_log_error
                          (   'Excepption Occurred While Getting Sequence..:'
                           || SQLERRM
                          );
                     COMMIT;
               END;

               l_doc_rec.ID := l_id;
               l_doc_rec.case_id := r_alias_rec.case_id;
               l_doc_rec.request_id := r_alias_rec.ID;
               apps.mt_log_error (   'Request ID: '
                                  || r_alias_rec.ID
                                  || ' '
                                  || 'Case ID: '
                                  || r_alias_rec.case_id
                                 );
               COMMIT;

               INSERT INTO xwrl_case_notes
                    VALUES l_doc_rec;

               COMMIT;
            END LOOP;
         END LOOP;
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         apps.mt_log_error (   'Excepption Occurred Inside Sync Alias: '
                            || SQLERRM
                           );
         COMMIT;
   END sync_batch_alias_notes;

   PROCEDURE set_expiration_date (
      p_request_id        IN   NUMBER,
      p_case_state        IN   VARCHAR2,
      p_workflow_status   IN   VARCHAR2
   )
   IS
      l_batch_count      NUMBER;
      l_approved_count   NUMBER;
      l_batch_id         NUMBER;
      l_ofc              VARCHAR2(30);

      PRAGMA AUTONOMOUS_TRANSACTION;

   BEGIN
      mt_log_error (p_request_id || ' ' || 'Inside set_expiration_date');
      COMMIT;

      BEGIN
         SELECT batch_id, office
           INTO l_batch_id, l_ofc
           FROM xwrl_requests
          WHERE ID = p_request_id;
      EXCEPTION
         WHEN OTHERS
         THEN
            l_batch_id := 0;
      END;

      mt_log_error (l_batch_id || ' ' || 'Inside set_expiration_date');
      COMMIT;

      IF l_batch_id != 0
      THEN
         BEGIN
            SELECT COUNT (1)
              INTO l_batch_count
              FROM xwrl_requests
             WHERE batch_id = l_batch_id;

            SELECT COUNT (1)
              INTO l_approved_count
              FROM xwrl_requests
             WHERE batch_id = l_batch_id
               AND case_state = 'A'
               AND case_workflow IN ('A', 'PR');

            mt_log_error (   'Batch and Approved Cound: '
                          || l_batch_count
                          || ' '
                          || l_approved_count
                         );
            COMMIT;
         EXCEPTION
            WHEN OTHERS
            THEN
               l_batch_count := NULL;
               l_approved_count := NULL;
         END;

         IF (l_approved_count = l_batch_count)
         THEN
            mt_log_error ('Updating Expiration Date.');
            COMMIT;

            IF l_ofc = 'UA' AND TO_CHAR(SYSDATE,'DAY') = 'WEDNESDAY' THEN--'WEDNESDAY' THEN
            UPDATE xwrl_requests
               SET expiration_date = SYSDATE + 2
             WHERE batch_id = l_batch_id;
            ELSE
            UPDATE xwrl_requests
               SET expiration_date = SYSDATE + 1
             WHERE batch_id = l_batch_id;

             END IF;

            COMMIT;
         END IF;
      END IF;
   END set_expiration_date;


   FUNCTION get_department (
   p_request_id     IN   NUMBER DEFAULT NULL,
   p_return_type    IN   VARCHAR2 DEFAULT NULL,
   p_source_table   IN   VARCHAR2 DEFAULT NULL,
   p_source_id      IN   NUMBER DEFAULT NULL
)
   RETURN VARCHAR2
IS
   dept             VARCHAR2 (100);
   dept_ext         VARCHAR2 (100);
   deptcode         VARCHAR2 (100);
   v_corp_number    VARCHAR2 (50);

   CURSOR get_inspector (p_inspector_id IN NUMBER)
   IS
      SELECT NAME
        FROM insp_inspectors
       WHERE inspector_id = p_inspector_id;

   CURSOR get_cra (p_seafarer_id IN NUMBER)
   IS
      SELECT COUNT (*)
        FROM sicd_documents
       WHERE seafarer_id = p_seafarer_id
         AND NVL (certificate_type, 'xx') IN ('CRA', 'UA')
         AND status = 'Pending';

   CURSOR get_external_cra (p_seafarer_id IN NUMBER)
   IS
      SELECT COUNT (*)
        FROM exsicd_seafarers_iface s, exsicd_seafarer_docs_iface esd
       WHERE esd.esi_id = s.esi_id
         AND esd.cra_required = 'Y'
         AND esd.cra_approved_date IS NOT NULL
         AND esd.grading_status != 'Rejected'
         AND NOT EXISTS (
                SELECT 'x'
                  FROM sicd_documents sd
                 WHERE sd.grade_id = esd.grade_id
                   AND sd.creation_date >= esd.cra_approved_date
                   AND NVL (sd.certificate_type, 'xx') IN ('CRA', 'UA')
                   AND seafarer_id = s.seafarer_id)
         AND s.seafarer_id = p_seafarer_id;

   insp_name        VARCHAR2 (240);
   l_source_table   VARCHAR2 (240);
   l_source_id      NUMBER;
   nof_doc          NUMBER         := 0;
   l_temp           VARCHAR2 (20);
BEGIN
   IF p_request_id IS NOT NULL
   THEN
      SELECT source_table, source_id
        INTO l_source_table, l_source_id
        FROM xwrl_requests
       WHERE ID = p_request_id;
   ELSE
      l_source_table := p_source_table;
      l_source_id := p_source_id;
   END IF;

   IF l_source_table = 'CORP_MAIN'
   THEN
      dept := 'Corporate';
      dept_ext := 'Corporate';

      BEGIN
         SELECT corp_number
           INTO v_corp_number
           FROM corp_main
          WHERE corp_id = l_source_id;

         IF v_corp_number IS NOT NULL
         THEN
            dept_ext := 'Corporate (Corp Number: ' || v_corp_number || ')';
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

   ELSIF l_source_table = 'SICD_SEAFARERS'
   THEN

      -- dept_ext := 'Seafarers';     -- (FIN: ' || TO_CHAR (l_source_id) || ')';
      BEGIN
         SELECT 'FIN'
           INTO l_temp
           FROM sicd_seafarers
          WHERE seafarer_id = l_source_id;
      EXCEPTION
         WHEN OTHERS
         THEN
            l_temp := 'TEMP FIN';
      END;

      OPEN get_cra (l_source_id);

      FETCH get_cra
       INTO nof_doc;

      CLOSE get_cra;

      IF nof_doc > 0
      THEN
         dept := 'Seafarers';
         dept_ext :=
               'Seafarers (CRA/UA) Paper ('
            || l_temp
            || ': '
            || TO_CHAR (l_source_id)
            || ')';
      ELSE
         OPEN get_external_cra (l_source_id);

         FETCH get_external_cra
          INTO nof_doc;

         CLOSE get_external_cra;

         IF nof_doc > 0
         THEN
            dept := 'Seafarers';
            dept_ext :=
                  'Seafarers (CRA/UA) Online ('
               || l_temp
               || ': '
               || TO_CHAR (l_source_id)
               || ')';
         ELSE
            dept := 'Seafarers';
            dept_ext :=
               'Seafarers (' || l_temp || ': ' || TO_CHAR (l_source_id)
               || ')';
         END IF;
      END IF;
   ELSIF l_source_table = 'VSSL_VESSELS'
   THEN
      dept := 'Vessel Documentation';
      dept_ext := 'Vessel Documentation';
   ELSIF l_source_table = 'VSSL_CONTACTS_V'
   THEN
      dept := 'Vessel Documentation';
      dept_ext := 'Vessel Documentation';
   ELSIF l_source_table = 'REG11_HEADER'
   THEN
      dept := 'Vessel Registration';
      dept_ext := 'Vessel Registration';
   ELSIF l_source_table = 'AR_CUSTOMERS'
   THEN
      dept := 'Customer';
      dept_ext := 'Customer';
   ELSIF l_source_table = 'INSP_INSPECTORS'
   THEN
      OPEN get_inspector (l_source_id);

      FETCH get_inspector
       INTO insp_name;

      CLOSE get_inspector;

      dept := 'Inspectors';
      dept_ext := SUBSTR ('Inspectors ' || insp_name, 1, 50);
   ELSIF INSTR (l_source_table, 'NRMI') > 0
   THEN
      dept := 'Non-RMI';
      dept_ext := 'Non-RMI Request - ' || l_source_id;
   ELSE
      dept_ext := 'Unknown';
   END IF;

   IF p_return_type = 'CODE'
   THEN
      BEGIN
         SELECT KEY
           INTO deptcode
           FROM xwrl_parameters
          WHERE ID = 'CASE_DEPARTMENTS'
            AND display_flag = 'Y'
            AND value_string = dept;
      EXCEPTION
         WHEN OTHERS
         THEN
            deptcode := NULL;
      END;

      RETURN deptcode;
   ELSE
      RETURN dept_ext;
   END IF;
END get_department;

   FUNCTION get_office (
      p_request_id    IN   NUMBER,
      p_return_type   IN   VARCHAR2 DEFAULT NULL
   )
      RETURN VARCHAR2
   IS
      CURSOR cur_ofc
      IS
         SELECT fnd_profile.value_specific
                                (NAME         => 'ONT_DEFAULT_PERSON_ID',
                                 user_id      => req.created_by
                                ) salesrep_id
           FROM xwrl_requests req
          WHERE 1 = 1 AND req.ID = p_request_id;

      CURSOR cur_data (p_salesrep_id IN NUMBER)
      IS
         SELECT   DECODE (p_return_type, 'CODE', code, description) office
             FROM vssl_offices
            WHERE salesrep_id = p_salesrep_id AND ENABLE = 'Y'
         ORDER BY description;

      l_office        VARCHAR2 (100);
      l_salesrep_id   NUMBER;
   BEGIN
      OPEN cur_ofc;

      FETCH cur_ofc
       INTO l_salesrep_id;

      CLOSE cur_ofc;

      OPEN cur_data (l_salesrep_id);

      FETCH cur_data
       INTO l_office;

      CLOSE cur_data;

      RETURN l_office;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END get_office;

   FUNCTION get_doc_type (
      p_request_id     IN   NUMBER DEFAULT NULL,
      p_source_table   IN   VARCHAR2 DEFAULT NULL,
      p_source_id      IN   NUMBER DEFAULT NULL
   )
      RETURN VARCHAR2
   IS
      dept             VARCHAR2 (100);

      CURSOR get_cra (p_seafarer_id IN NUMBER)
      IS
         SELECT COUNT (*)
           FROM sicd_documents
          WHERE seafarer_id = p_seafarer_id
            AND NVL (certificate_type, 'xx') IN ('CRA', 'UA')
            AND status = 'Pending';

      CURSOR get_external_cra (p_seafarer_id IN NUMBER)
      IS
         SELECT COUNT (*)
           FROM exsicd_seafarers_iface s, exsicd_seafarer_docs_iface esd
          WHERE esd.esi_id = s.esi_id
            AND esd.cra_required = 'Y'
            AND esd.cra_approved_date IS NOT NULL
            AND esd.grading_status != 'Rejected'
            AND NOT EXISTS (
                   SELECT 'x'
                     FROM sicd_documents sd
                    WHERE sd.grade_id = esd.grade_id
                      AND sd.creation_date >= esd.cra_approved_date
                      AND NVL (sd.certificate_type, 'xx') IN ('CRA', 'UA')
                      AND seafarer_id = s.seafarer_id)
            AND s.seafarer_id = p_seafarer_id;

      nof_doc          NUMBER         := 0;
      l_source_table   VARCHAR2 (240);
      l_source_id      NUMBER;
   BEGIN
      IF p_request_id IS NOT NULL
      THEN
         SELECT source_table, source_id
           INTO l_source_table, l_source_id
           FROM xwrl_requests
          WHERE ID = p_request_id;
      ELSE
         l_source_table := p_source_table;
         l_source_id := p_source_id;
      END IF;

      IF l_source_table = 'SICD_SEAFARERS'
      THEN
         OPEN get_cra (l_source_id);

         FETCH get_cra
          INTO nof_doc;

         CLOSE get_cra;

         IF nof_doc > 0
         THEN
            dept := 'CRA/UA Paper';
         ELSE
            OPEN get_external_cra (l_source_id);

            FETCH get_external_cra
             INTO nof_doc;

            CLOSE get_external_cra;

            IF nof_doc > 0
            THEN
               dept := 'CRA/UA Online';
            END IF;
         END IF;
      END IF;

      RETURN dept;
   END get_doc_type;

   FUNCTION get_custom_tag_info (
      p_source_table   IN   VARCHAR2,
      p_source_id      IN   NUMBER
   )
      RETURN VARCHAR2
   IS
      CURSOR get_corp_number
      IS
         SELECT corp_number || ' ' || corp_name1
           FROM corp_main
          WHERE corp_id = p_source_id;

      CURSOR get_official_number
      IS
         SELECT   TO_CHAR (official_number) || ' ' || NAME
             FROM vssl_vessels
            WHERE vessel_pk = p_source_id
         ORDER BY status;

      CURSOR get_account_info
      IS
         SELECT account_number || ' - ' || party_name
           FROM hz_cust_accounts ca, hz_parties pty
          WHERE ca.cust_account_id = p_source_id
            AND pty.party_id = ca.party_id;

      CURSOR get_seafarer
      IS
         SELECT    ss.seafarer_id
                || ' - '
                || ss.first_name
                || ' '
                || ss.last_name
                || ' -  '
                || NVL (sc.country_name, 'Not Specified')
           FROM sicd_seafarers ss, sicd_countries sc
          WHERE ss.seafarer_id = p_source_id AND sc.country_code(+) =
                                                                ss.nationality
         UNION
         SELECT    ss.seafarer_id
                || ' - '
                || ss.first_name
                || ' '
                || ss.last_name
                || ' -  '
                || NVL (sc.country_name, 'Not Specified')
           FROM exsicd_seafarers_iface ss, sicd_countries sc
          WHERE ss.seafarer_id = p_source_id AND sc.country_code(+) =
                                                                ss.nationality;

      CURSOR get_vetting
      IS
         SELECT    reg_name
                || '  Vetting ID '
                || TO_CHAR (rh.reg11_header_id) rec_name
           FROM reg11_header rh, reg11_world_check rwc
          WHERE rh.reg11_header_id = rwc.reg11_header_id
            AND rwc.reg11_world_check_id = p_source_id;

      CURSOR get_contacts
      IS
         SELECT   TO_CHAR (official_number) || ' ' || NAME
             FROM vssl_contacts_v
            WHERE contact_id = p_source_id
         ORDER BY status;

      CURSOR get_nrmi
      IS
         SELECT TO_CHAR (nrmi_certificates_id) req_number
           FROM nrmi_certificates
          WHERE nrmi_certificates_id = p_source_id;

      CURSOR get_nrmi_kp
      IS
         SELECT TO_CHAR (nrmi_certificates_id) req_number
           FROM nrmi_known_parties c
          WHERE nrmi_kp_id = p_source_id;

      corp_number    VARCHAR2 (10);
      custom_str     VARCHAR2 (300);
      p_custom_id1   VARCHAR2 (100);
      p_custom_id2   VARCHAR2 (100);
   BEGIN
      IF p_source_table = 'CORP_MAIN'
      THEN
         p_custom_id1 := 'Corp Number';

         OPEN get_corp_number;

         FETCH get_corp_number
          INTO p_custom_id2;

         CLOSE get_corp_number;
      ELSIF p_source_table = 'SICD_SEAFARERS'
      THEN
         p_custom_id1 := 'Seafarer ID';

         OPEN get_seafarer;

         FETCH get_seafarer
          INTO custom_str;

         p_custom_id2 := SUBSTR (custom_str, 1, 100);

         CLOSE get_seafarer;
      ELSIF p_source_table = 'VSSL_VESSELS'
      THEN
         p_custom_id1 := 'Official Number';

         OPEN get_official_number;

         FETCH get_official_number
          INTO p_custom_id2;

         CLOSE get_official_number;
      ELSIF p_source_table = 'VSSL_CONTACTS_V'
      THEN
         p_custom_id1 := 'Contact for Official Number';

         OPEN get_contacts;

         FETCH get_contacts
          INTO p_custom_id2;

         CLOSE get_contacts;
      ELSIF p_source_table = 'AR_CUSTOMERS'
      THEN
         p_custom_id1 := 'Customer Account';

         OPEN get_account_info;

         FETCH get_account_info
          INTO custom_str;

         p_custom_id2 := SUBSTR (custom_str, 1, 100);

         CLOSE get_account_info;
      ELSIF p_source_table = 'REG11_WORLD_CHECK'
      THEN
         p_custom_id1 := 'Vessel Vetting';

         OPEN get_vetting;

         FETCH get_vetting
          INTO p_custom_id2;

         CLOSE get_vetting;
      ELSIF INSTR (p_source_table, 'NRMI_CERTIFICATES') > 0
      THEN
         --p_custom_id1:='NRMI Cert';                                             --     T20180103.0033  commented by SHIVI dated: 26062018
         p_custom_id1 := 'NRMI Request';

         --     T20180103.0033  Added by SHIVI dated: 26062018
         OPEN get_nrmi;

         FETCH get_nrmi
          INTO p_custom_id2;

         CLOSE get_nrmi;
      ELSIF INSTR (p_source_table, 'NRMI_VESSELS_KNOWN_PARTY') > 0
      THEN
         p_custom_id1 := 'NRMI Cert - Known Party ';

         OPEN get_nrmi_kp;

         FETCH get_nrmi_kp
          INTO p_custom_id2;

         CLOSE get_nrmi_kp;
      ELSE
         p_custom_id1 := p_source_table;
         p_custom_id2 := TO_CHAR (p_source_table);
      END IF;

      RETURN p_custom_id1 || ' ' || p_custom_id2;
   END;

   /*PROCEDURE update_alert_status_gender (
   p_user_id       IN   NUMBER,
   p_alert_id      IN   VARCHAR2,
   p_alert_state   IN   VARCHAR2,
   --SAURABH 04-MAY-2020 added new parameter
   p_listrecordtype IN  VARCHAR2
)
IS
   l_alert_id        VARCHAR2 (25);
   l_user            VARCHAR2 (200);
   l_record_type     VARCHAR2 (10);
   l_error           VARCHAR2 (500);
   l_alert_in_tbl    xows.xxiri_cm_process_pkg.alert_tbl_in_type@ebstoows2.coresys.com;
   x_alert_out_tbl   xows.xxiri_cm_process_pkg.alert_tbl_out_type@ebstoows2.coresys.com;
   x_status          VARCHAR2 (200);
   l_to_state        VARCHAR2 (100);
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   l_alert_in_tbl.DELETE;
   x_alert_out_tbl.DELETE;

   BEGIN
      SELECT user_name
        INTO l_user
        FROM apps.fnd_user
       WHERE user_id = p_user_id;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_user := 'SYSADMIN';
   END;

   --SAURABH 04-MAY-2020 Get to_state Dynamically

   BEGIN
      SELECT SUBSTR (to_state, 4)
        INTO l_to_state
        FROM xwrl_alert_clearing_xref
       WHERE alert_id = p_alert_id AND ID = (SELECT MAX (ID)
                                               FROM xwrl_alert_clearing_xref
                                              WHERE alert_id = p_alert_id);
   EXCEPTION
      WHEN OTHERS
      THEN
         apps.mt_log_error ('Exception In Getting To State: ' || SQLERRM);
         l_to_state := NULL;
   END;

   IF l_to_state IS NOT NULL
   THEN
      l_alert_in_tbl (1).alert_id := p_alert_id;                --l_alert_id;

      --SAURABH 04-MAY-2020 Get to_state Dynamically
      --l_alert_in_tbl (1).to_state :=
      --                        xwrl_ows_utils.changetoowsstate (p_alert_state);

      l_alert_in_tbl (1).to_state := xwrl_ows_utils.changetoowsstate(p_listrecordtype||l_to_state);

      l_alert_in_tbl (1).COMMENT :=
                       'Marking as False Positive Becuase of Gender Mismatch';







      xows.xxiri_cm_process_pkg.update_alerts@ebstoows2.coresys.com
                                         (p_user               => l_user,
                                          p_alert_in_tbl       => l_alert_in_tbl,
                                          x_alert_out_tbl      => x_alert_out_tbl,
                                          x_status             => x_status
                                         );
      COMMIT;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      ROLLBACK;
END update_alert_status_gender;*/


   FUNCTION is_valid_country_combination (
      p_country_of_address        IN   VARCHAR2,
      p_country_of_residence      IN   VARCHAR2,
      p_country_of_nationality    IN   VARCHAR2,
      p_country_of_birth          IN   VARCHAR2,
      p_country_of_registration   IN   VARCHAR2
   )
      RETURN VARCHAR2
   IS
      t_country    t_countryarray;
      l_country    VARCHAR2 (25)  := NULL;
      l_is_valid   VARCHAR2 (10)  := 'N';
      l_error      VARCHAR2 (500);
   BEGIN
      t_country :=
         t_countryarray (p_country_of_address,
                         p_country_of_residence,
                         p_country_of_nationality,
                         p_country_of_birth,
                         p_country_of_registration
                        );

      BEGIN
         SELECT DISTINCT COLUMN_VALUE
                    INTO l_country
                    FROM TABLE (CAST (t_country AS t_countryarray))
                   WHERE COLUMN_VALUE IS NOT NULL;

         IF l_country IS NOT NULL
         THEN
            l_is_valid := 'Y';
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            l_error := SQLERRM;
            l_is_valid := 'N';
      END;

      apps.mt_log_error ('Is a Valid Combination: ' || l_is_valid);
      RETURN l_is_valid;
   END is_valid_country_combination;

   FUNCTION get_ows_alert_state (p_alert_id IN VARCHAR2)
      RETURN VARCHAR2
   IS
      l_state    VARCHAR2 (100);
      sql_stmt   VARCHAR2 (1000);
   BEGIN
      IF get_instance_name = 'IRIPROD'
      THEN
         sql_stmt :=
            'select current_state from irip1_edqconfig.dn_case@ebstoows2.coresys.com WHERE external_id = :1
             union
             select current_state from irip2_edqconfig.dn_case@ebstoows2.coresys.com WHERE external_id = :2
            ';
      ELSE
         sql_stmt :=
            'select current_state from iridr_edqconfig.dn_case@ebstoows2.coresys.com WHERE external_id = :1
              union
             select current_state from iridr2_edqconfig.dn_case@ebstoows2.coresys.com WHERE external_id = :2
            ';
      END IF;

      EXECUTE IMMEDIATE sql_stmt
                   INTO l_state
                  USING p_alert_id, p_alert_id;

      RETURN l_state;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (SQLERRM);
         RAISE;
   END get_ows_alert_state;

   FUNCTION get_ows_alert_sequence (p_state IN VARCHAR2)
      RETURN NUMBER
   IS
   BEGIN
      IF SUBSTR (p_state, 7) = 'Positive'
      THEN
         RETURN 4;
      ELSIF SUBSTR (p_state, 7) = 'Possible'
      THEN
         RETURN 3;
      ELSIF SUBSTR (p_state, 7) = 'False Positive'
      THEN
         RETURN 2;
      ELSIF SUBSTR (p_state, 7) = 'Open'
      THEN
         RETURN 1;
      ELSE
         RETURN NULL;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END get_ows_alert_sequence;

   FUNCTION is_entity_crimean (
      xref            IN       rmi_ows_common_util.wc_external_xref_rec,
      p_return_code   OUT      VARCHAR,
      p_ret_msg       OUT      VARCHAR2
   )
      RETURN VARCHAR2
   IS
      CURSOR get_related_recs
      IS
         SELECT *
           FROM worldcheck_external_xref
          WHERE source_table = xref.source_table
            AND source_table_column = xref.source_table_column
            AND source_table_id = xref.source_table_id;

      CURSOR get_request_info (p_wc_screening_request_id IN NUMBER)
      IS
         SELECT COUNT (*)
           FROM wc_screening_request req, wc_city_list city
          WHERE wc_screening_request_id = p_wc_screening_request_id
            AND city.wc_city_list_id = req.wc_city_list_id
            AND city.status = 'TC_VERIFY'
            AND country_code IN ('UKRA', 'RUSS');

      nof_recs     NUMBER;
      req          get_request_info%ROWTYPE;
      is_crimean   VARCHAR2 (1)               := 'N';
      --OWS
      l_ows_req    xwrl_requests%ROWTYPE;
      l_ows_req_id NUMBER;

      CURSOR cur_req_details (p_id IN NUMBER)
      IS
         SELECT VALUE city
           FROM xwrl_request_rows a
          WHERE request_id = p_id AND KEY = 'City';

      l_ows_data   cur_req_details%ROWTYPE;

      CURSOR cur_city_check (p_city_id IN NUMBER)
      IS
         SELECT 'Y'
           FROM wc_city_list city
          WHERE wc_city_list_id = p_city_id
            AND city.status = 'TC_VERIFY'
            AND country_code IN ('UKRA', 'RUSS');
   BEGIN
      p_return_code := 'OK';
      p_ret_msg := 'Success';

      IF rmi_ows_common_util.is_ows_user = 'N'
      THEN
         FOR x IN get_related_recs
         LOOP
            nof_recs := 0;

            OPEN get_request_info (x.wc_screening_request_id);

            FETCH get_request_info
             INTO nof_recs;

            CLOSE get_request_info;

            IF nof_recs > 0 AND is_crimean = 'N'
            THEN
               is_crimean := 'Y';
               EXIT;
            END IF;
         END LOOP;
      ELSE
         l_ows_req_id :=
            rmi_ows_common_util.get_case_id (xref.source_table,
                                          xref.source_table_id,
                                          NULL
                                         );

         OPEN cur_req_details (l_ows_req_id);

         FETCH cur_req_details
          INTO l_ows_data;

         CLOSE cur_req_details;

         IF l_ows_data.city IS NOT NULL
         THEN
            OPEN cur_city_check
                       (rmi_ows_common_util.get_city_list_id (l_ows_data.city)
                       );

            FETCH cur_city_check
             INTO is_crimean;

            CLOSE cur_city_check;
         END IF;
      END IF;

      RETURN (is_crimean);
   END;


PROCEDURE delete_request (
   p_source_request_id   IN   NUMBER,                                    -- To
   p_target_request_id   IN   NUMBER                                   -- From
)
IS
   CURSOR get_source_data (p_source_request_id IN NUMBER)
   IS
      SELECT --* SAURABH Remove *
      name_screened, id, xref_id, alias_id, master_id,batch_id
        FROM xwrl_requests
       WHERE ID = p_source_request_id;

   p_source_data   get_source_data%ROWTYPE;

   CURSOR get_target_data (p_source_request_id IN NUMBER)
   IS
      SELECT --* SAURABH Remove *
      name_screened, id, xref_id, alias_id, master_id,batch_id
        FROM xwrl_requests
       WHERE ID = p_target_request_id;

   p_target_data   get_target_data%ROWTYPE;
BEGIN

   OPEN get_source_data (p_source_request_id);

   FETCH get_source_data
    INTO p_source_data;

   CLOSE get_source_data;

   OPEN get_target_data (p_target_request_id);

   FETCH get_target_data
    INTO p_target_data;

   CLOSE get_target_data;

   IF (p_source_request_id IS NOT NULL)
   THEN
      UPDATE xwrl_party_master
         SET batch_id = p_source_data.batch_id
       WHERE batch_id = p_target_data.batch_id;

      UPDATE xwrl_party_alias
         SET batch_id = p_source_data.batch_id
       WHERE batch_id = p_target_data.batch_id;

      UPDATE xwrl_alert_clearing_xref
         SET request_id = p_source_data.ID
       WHERE request_id = p_target_data.ID;
   END IF;

   IF (p_target_request_id IS NOT NULL)
   THEN
      DELETE FROM xwrl.xwrl_request_rows
            WHERE request_id = p_target_request_id;

      DELETE FROM xwrl.xwrl_request_ind_columns
            WHERE request_id = p_target_request_id;

      DELETE FROM xwrl.xwrl_request_entity_columns
            WHERE request_id = p_target_request_id;

      DELETE FROM xwrl.xwrl_response_rows
            WHERE request_id = p_target_request_id;

      DELETE FROM xwrl.xwrl_response_ind_columns
            WHERE request_id = p_target_request_id;

      DELETE FROM xwrl.xwrl_response_entity_columns
            WHERE request_id = p_target_request_id;

      DELETE FROM xwrl.xwrl_case_notes
            WHERE request_id = p_target_request_id;

      DELETE FROM xwrl.xwrl_case_documents
            WHERE request_id = p_target_request_id;

      DELETE FROM xwrl.xwrl_alert_notes
            WHERE request_id = p_target_request_id;

      DELETE FROM xwrl.xwrl_alert_documents
            WHERE request_id = p_target_request_id;

      DELETE FROM xwrl.xwrl_request_approval_history
            WHERE ID = p_target_request_id;

      DELETE FROM xwrl.xwrl_requests
            WHERE ID = p_target_request_id;
   END IF;

    --SAURABH 13-MAY-2020 T20200508.0028
	IF (p_source_request_id IS NOT NULL) THEN

      set_expiration_date(p_source_request_id,NULL,NULL);

    END IF;

   COMMIT;
END delete_request;


FUNCTION case_wf_state(p_state IN xwrl_parameters.KEY%TYPE)
    RETURN VARCHAR2 IS
    l_return_value xwrl_parameters.KEY%TYPE;
  BEGIN
    SELECT value_string
      INTO l_return_value
      FROM xwrl_parameters
     WHERE ID = 'CASE_STATE'
       AND KEY = p_state;

    RETURN l_return_value;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
END case_wf_state;

FUNCTION actual_fin (p_source_id IN NUMBER)
   RETURN NUMBER
IS
   CURSOR cur_seafarer
   IS
      SELECT seafarer_id
        FROM sicd_seafarers
       WHERE seafarer_id = p_source_id;

   l_fin   NUMBER;
BEGIN
   OPEN cur_seafarer;

   FETCH cur_seafarer
    INTO l_fin;

   CLOSE cur_seafarer;

   RETURN l_fin;
END;

--
   FUNCTION get_corp_number (p_source_id IN NUMBER)
   RETURN VARCHAR2
IS
   CURSOR cur_corpmain
   IS
      select corp_number from corp_main where corp_id = p_source_id;

   l_corp_number   VARCHAR2(10);
BEGIN
   OPEN cur_corpmain;

   FETCH cur_corpmain
    INTO l_corp_number;

   CLOSE cur_corpmain;

   RETURN l_corp_number;
END;

PROCEDURE delete_batch (p_batch_id IN NUMBER)
IS
   CURSOR cur_batch
   IS
      SELECT ID
        FROM xwrl_requests
       WHERE batch_id = p_batch_id;
BEGIN
   FOR rec IN cur_batch
   LOOP
      delete_request (NULL, rec.ID);
   END LOOP;

   COMMIT;
END delete_batch;

PROCEDURE delete_batch (p_batch_id IN NUMBER, p_user_id IN NUMBER)
IS
   CURSOR cur_batch
   IS
      SELECT ID
        FROM xwrl_requests
       WHERE batch_id = p_batch_id;

BEGIN

   fnd_global.apps_initialize(p_user_id,52369,52369);

   FOR rec IN cur_batch
   LOOP
      delete_request (NULL, rec.ID);
   END LOOP;

   COMMIT;
END delete_batch;

FUNCTION get_master_id (
   p_master_id   IN   NUMBER,
   p_alias_id    IN   NUMBER,
   p_xref_id     IN   NUMBER
)
   RETURN NUMBER
IS
   l_master_id   NUMBER;
BEGIN
   IF p_master_id IS NOT NULL AND p_alias_id IS NULL AND p_xref_id IS NULL
   THEN
      l_master_id := p_master_id;
   ELSIF     p_master_id IS NOT NULL
         AND p_alias_id IS NOT NULL
         AND p_xref_id IS NULL
   THEN
      SELECT master_id
        INTO l_master_id
        FROM xwrl_party_alias
       WHERE ID = p_alias_id;
   ELSIF     p_master_id IS NOT NULL
         AND p_alias_id IS NULL
         AND p_xref_id IS NOT NULL
   THEN
      SELECT relationship_master_id
        INTO l_master_id
        FROM xwrl_party_xref
       WHERE ID = p_xref_id;
   END IF;

   RETURN l_master_id;
END get_master_id;


--

END;