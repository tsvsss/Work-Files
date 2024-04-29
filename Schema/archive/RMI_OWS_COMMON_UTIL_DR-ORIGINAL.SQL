CREATE OR REPLACE PACKAGE APPS.rmi_ows_common_util
AS
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
      name_screened                   VARCHAR2 (200)
   );

   FUNCTION get_instance_name
      RETURN VARCHAR2;

   FUNCTION get_entity_type (p_id IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_ows_url (p_source_table IN VARCHAR2, p_source_id IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_url
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

   PROCEDURE send_notice_to_legal (p_id IN NUMBER, x_message IN VARCHAR2);

   PROCEDURE send_notice_from_trigger (
      p_id               IN       NUMBER,
      p_created_by       IN       NUMBER,
--   p_name_screened          IN       VARCHAR2,
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
      t_data            IN OUT   world_check_iface.screening_tab
   );

   FUNCTION get_id_request_values (p_id IN NUMBER, p_attr_name IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_country_name_iso (p_country_code IN VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION is_city_crimean (p_city_list_id IN NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_sanction_status (p_iso_country IN VARCHAR2)
      RETURN VARCHAR2;
   FUNCTION wc_locked(p_id IN NUMBER) RETURN VARCHAR2;
   
END; 
/

CREATE OR REPLACE PACKAGE BODY APPS.rmi_ows_common_util
AS
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

   FUNCTION get_open_case (p_source_table IN VARCHAR2, p_source_id IN NUMBER)
      RETURN xwrl_requests%ROWTYPE
   IS
      CURSOR get_req_ows
      IS
         SELECT   req.*
             FROM xwrl_requests req
            WHERE req.source_table = p_source_table
              AND req.source_id = p_source_id
              AND case_status != 'C'
         ORDER BY last_update_date DESC;

      l_req_ows   xwrl_requests%ROWTYPE;
   BEGIN
      OPEN get_req_ows;

      FETCH get_req_ows
       INTO l_req_ows;

      CLOSE get_req_ows;

      RETURN l_req_ows;
   END get_open_case;

   FUNCTION get_open_request (
      p_source_table   IN   VARCHAR2,
      p_source_id      IN   NUMBER,
      p_name           IN   VARCHAR2,
      p_type           IN   VARCHAR2
   )
      RETURN xwrl_requests%ROWTYPE
   IS
      CURSOR get_req_ows
      IS
         SELECT   req.*
             FROM xwrl_requests req
            WHERE req.source_table = p_source_table
              AND req.source_id = p_source_id
              AND case_status != 'C'
              AND get_name (req.ID) = p_name
              AND PATH = DECODE (p_type, 'VESSEL', 'ENTITY', PATH)
              AND NVL (vessel_indicator, 'N') =
                     DECODE (p_type,
                             'VESSEL', 'Y',
                             NVL (vessel_indicator, 'N')
                            )
         ORDER BY last_update_date DESC;

      l_req_ows   xwrl_requests%ROWTYPE;
   BEGIN
      OPEN get_req_ows;

      FETCH get_req_ows
       INTO l_req_ows;

      CLOSE get_req_ows;

      RETURN l_req_ows;
   END get_open_request;

   FUNCTION get_case (
      p_source_table   IN   VARCHAR2,
      p_source_id      IN   NUMBER,
      p_status         IN   VARCHAR2
   )
      RETURN xwrl_requests%ROWTYPE
   IS
      CURSOR get_req_ows
      IS
         SELECT   req.*
             FROM xwrl_requests req
            WHERE req.source_table = p_source_table
              AND req.source_id = p_source_id
              AND case_status = NVL (p_status, case_status)
         ORDER BY last_update_date DESC;

      l_req_ows   xwrl_requests%ROWTYPE;
   BEGIN
      OPEN get_req_ows;

      FETCH get_req_ows
       INTO l_req_ows;

      CLOSE get_req_ows;

      RETURN l_req_ows;
   END get_case;

   FUNCTION get_case_details (p_id IN NUMBER)
      RETURN xwrl_requests%ROWTYPE
   IS
      CURSOR get_req_ows
      IS
         SELECT req.*
           FROM xwrl_requests req
          WHERE req.ID = p_id;

      l_req_ows   xwrl_requests%ROWTYPE;
   BEGIN
      OPEN get_req_ows;

      FETCH get_req_ows
       INTO l_req_ows;

      CLOSE get_req_ows;

      RETURN l_req_ows;
   END get_case_details;

   FUNCTION get_wf_case (
      p_source_table   IN   VARCHAR2,
      p_source_id      IN   NUMBER,
      p_wf_status      IN   VARCHAR2
   )
      RETURN xwrl_requests%ROWTYPE
   IS
      CURSOR get_req_ows
      IS
         SELECT   req.*
             FROM xwrl_requests req
            WHERE req.source_table = p_source_table
              AND req.source_id = p_source_id
              AND case_workflow = p_wf_status
         ORDER BY last_update_date DESC;

      l_req_ows   xwrl_requests%ROWTYPE;
   BEGIN
      OPEN get_req_ows;

      FETCH get_req_ows
       INTO l_req_ows;

      CLOSE get_req_ows;

      RETURN l_req_ows;
   END get_wf_case;

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
      SELECT iso_alpha2_code
        INTO l_iso_code
        FROM sicd_countries
       WHERE 1 = 1 AND country_code = p_country_code;

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
       WHERE 1 = 1 AND iso_alpha2_code = p_country_code;

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
       WHERE 1 = 1 AND country_code = p_country_code;

      RETURN l_iso_code;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END get_country_name;

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
         SELECT *
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
         IF seaf_rec.physical_edoc_id IS NOT NULL
         THEN
            OPEN get_edoc_data (seaf_rec.physical_edoc_id);

            FETCH get_edoc_data
             INTO l_edoc_rec;

            CLOSE get_edoc_data;

            BEGIN
               INSERT INTO xwrl.xwrl_case_documents
                           (ID, request_id,
                            case_id, edoc_id, document_file, document_name,
                            document_category, document_type,
                            file_name, file_path,
                            content_type, image_file, image_name,
                            image_path, url_path, last_update_date,
                            last_updated_by, creation_date, created_by,
                            last_update_login
                           )
                    VALUES (xwrl_case_documents_seq.NEXTVAL, x.ID,
                            x.case_id, seaf_rec.physical_edoc_id, '', '',
                            '',                                -- Doc Category
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
               OPEN get_edoc_data (seaf_rec.physical_edoc_id);

               FETCH get_edoc_data
                INTO l_edoc_rec;

               CLOSE get_edoc_data;

               INSERT INTO xwrl.xwrl_case_documents
                           (ID, request_id,
                            case_id, edoc_id, document_file,
                            document_name, document_category, document_type,
                            file_name, file_path,
                            content_type, image_file, image_name,
                            image_path, url_path, last_update_date,
                            last_updated_by, creation_date, created_by,
                            last_update_login
                           )
                    VALUES (xwrl_case_documents_seq.NEXTVAL, x.ID,
                            x.case_id, seaf_rec.identity_doc_edoc_id, '',
                            '', '',                            -- Doc Category
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
               OPEN get_edoc_data (seaf_rec.physical_edoc_id);

               FETCH get_edoc_data
                INTO l_edoc_rec;

               CLOSE get_edoc_data;

               INSERT INTO xwrl.xwrl_case_documents
                           (ID, request_id,
                            case_id, edoc_id, document_file, document_name,
                            document_category, document_type,
                            file_name, file_path,
                            content_type, image_file, image_name,
                            image_path, url_path, last_update_date,
                            last_updated_by, creation_date, created_by,
                            last_update_login
                           )
                    VALUES (xwrl_case_documents_seq.NEXTVAL, x.ID,
                            x.case_id, seaf_rec.sat_edoc_id, '', '',
                            '',                                -- Doc Category
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
               OPEN get_edoc_data (seaf_rec.physical_edoc_id);

               FETCH get_edoc_data
                INTO l_edoc_rec;

               CLOSE get_edoc_data;

               INSERT INTO xwrl.xwrl_case_documents
                           (ID, request_id,
                            case_id,
                            edoc_id, document_file, document_name,
                            document_category, document_type,
                            file_name, file_path,
                            content_type, image_file, image_name,
                            image_path, url_path, last_update_date,
                            last_updated_by, creation_date, created_by,
                            last_update_login
                           )
                    VALUES (xwrl_case_documents_seq.NEXTVAL, x.ID,
                            x.case_id,
                            seaf_rec.seaservice_transcript_edoc_id, '', '',
                            '',                                -- Doc Category
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
               OPEN get_edoc_data (seaf_rec.physical_edoc_id);

               FETCH get_edoc_data
                INTO l_edoc_rec;

               CLOSE get_edoc_data;

               INSERT INTO xwrl.xwrl_case_documents
                           (ID, request_id,
                            case_id, edoc_id, document_file, document_name,
                            document_category, document_type,
                            file_name, file_path,
                            content_type, image_file, image_name,
                            image_path, url_path, last_update_date,
                            last_updated_by, creation_date, created_by,
                            last_update_login
                           )
                    VALUES (xwrl_case_documents_seq.NEXTVAL, x.ID,
                            x.case_id, seaf_rec.application_edoc_id, '', '',
                            '',                                -- Doc Category
                               'Online Order -  MI-271',
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
                  OPEN get_edoc_data (seaf_rec.physical_edoc_id);

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
                               x.case_id, y.edoc_id, '',
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

   FUNCTION get_seafarer_ows_id (p_seafarer_id IN NUMBER)
      RETURN NUMBER
   IS
      x_id            INTEGER;

      --
      CURSOR cur_seafarer_details
      IS
         SELECT a.*, DECODE (a.status, 'Deceased', 'Y', 'N') deceasedflag
           FROM sicd_seafarers a
          WHERE seafarer_id = p_seafarer_id;

      v_user_id       NUMBER                 := fnd_profile.VALUE ('USER_ID');
      v_session_id    NUMBER;
      l_req           rmi_ows_common_util.ows_request_rec;
      x_return_code   VARCHAR2 (100);
      x_return_msg    VARCHAR2 (100);
   BEGIN
      SELECT USERENV ('sessionid')
        INTO v_session_id
        FROM DUAL;                                           -- EBS session id

      FOR rec IN cur_seafarer_details
      LOOP
         l_req.entity_type := 'INDIVIDUAL';
         l_req.source_table := 'SICD_SEAFARERS';
         l_req.source_id := rec.seafarer_id;
         l_req.first_name := rec.first_name;
         l_req.last_name := rec.last_name;
         l_req.gender := rec.gender;
         l_req.date_of_birth := format_date (rec.birth_date);
         l_req.residence_country_code :=
                                       get_country_iso_code (rec.nationality);
         create_ows_generic (p_req              => l_req,
                             p_custom_id1       => NULL,
                             p_custom_id2       => NULL,
                             p_return_code      => x_return_code,
                             p_ret_msg          => x_return_msg,
                             x_id               => x_id
                            );
--         xwrl_utils.ows_individual_screening
--            (p_debug                     => 'TRUE',
--             p_show_request              => 'FALSE',
--             p_show_response             => 'FALSE',
--             p_user_id                   => v_user_id,
--             p_session_id                => v_session_id,
--             p_source_table              => 'SICD_SEAFARERS',
--             p_source_id                 => rec.seafarer_id,
----             p_fullname                     => rec.first_name|| ' '|| rec.middle_initial|| ' '|| rec.last_name,
--             p_givennames                => rec.first_name,
--             p_familyname                => rec.last_name,
--             p_gender                    => SUBSTR (rec.gender, 1, 1),
--             p_dateofbirth               => format_date (rec.birth_date),
--             p_yearofbirth               => TO_CHAR (rec.birth_date, 'RRRR'),
----             p_city                         => SUBSTR(rec.birth_place,1,INSTR(rec.birth_place,',',1,1)- 1),
--             p_residencycountrycode      => get_country_iso_code
--                                                              (rec.nationality),
--             --p_nationalitycountrycodes      => get_country_iso_code(rec.nationality),
--             p_nationalid                => NULL,
--             --p_DeceasedFlag                 => rec.DeceasedFlag,
--             x_id                        => x_id
--            );
         RETURN x_id;
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN -999;
   END get_seafarer_ows_id;

   PROCEDURE get_seafarer_ows_id (p_seafarer_id IN NUMBER)
   IS
      --PRAGMA AUTONOMOUS_TRANSACTION;
      x_id              INTEGER;

      --
      CURSOR cur_seafarer_details
      IS
         SELECT a.*, DECODE (a.status, 'Deceased', 'Y', 'N') deceasedflag
           FROM sicd_seafarers a
          WHERE seafarer_id = p_seafarer_id;

      l_xwrl_requests   xwrl_requests%ROWTYPE;
      l_req             rmi_ows_common_util.ows_request_rec;
      x_return_code     VARCHAR2 (100);
      x_return_msg      VARCHAR2 (100);
   BEGIN
      FOR rec IN cur_seafarer_details
      LOOP
         l_xwrl_requests := get_open_case ('SICD_SEAFARERS', rec.seafarer_id);

         IF l_xwrl_requests.ID IS NOT NULL
         THEN
            x_id := l_xwrl_requests.ID;
            RETURN;
         END IF;

         l_req.entity_type := 'INDIVIDUAL';
         l_req.source_table := 'SICD_SEAFARERS';
         l_req.source_id := rec.seafarer_id;
         l_req.first_name := rec.first_name;
         l_req.last_name := rec.last_name;
         l_req.gender := rec.gender;
         l_req.date_of_birth := format_date (rec.birth_date);
         l_req.residence_country_code :=
                                        get_country_iso_code (rec.nationality);
         create_ows_generic (p_req              => l_req,
                             p_custom_id1       => NULL,
                             p_custom_id2       => NULL,
                             p_return_code      => x_return_code,
                             p_ret_msg          => x_return_msg,
                             x_id               => x_id
                            );
--      xwrl_utils.ows_individual_screening
--             (p_debug                     => 'TRUE',
--              p_show_request              => 'FALSE',
--              p_show_response             => 'FALSE',
--              p_user_id                   => v_user_id,
--              p_session_id                => v_session_id,
--              p_source_table              => 'SICD_SEAFARERS',
--              p_source_id                 => rec.seafarer_id,
----             p_fullname                     => rec.first_name|| ' '|| rec.middle_initial|| ' '|| rec.last_name,
--              p_givennames                => rec.first_name,
--              p_familyname                => rec.last_name,
--              p_gender                    => SUBSTR (rec.gender, 1, 1),
--              p_dateofbirth               => format_date (rec.birth_date),
--              p_yearofbirth               => TO_CHAR (rec.birth_date, 'RRRR'),
----             p_city                         => SUBSTR(rec.birth_place,1,INSTR(rec.birth_place,',',1,1)- 1),
--              p_residencycountrycode      => get_country_iso_code
--                                                              (rec.nationality),
--              --p_nationalitycountrycodes      => get_country_iso_code(rec.nationality),
--              p_nationalid                => NULL,
--              --p_DeceasedFlag                 => rec.DeceasedFlag,
--              x_id                        => x_id
--             );
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         RAISE;
   END get_seafarer_ows_id;

   PROCEDURE get_contact_ows_id (p_contact_id IN NUMBER)
   IS
      --PRAGMA AUTONOMOUS_TRANSACTION;
      x_id              INTEGER;

      --
      CURSOR cur_contact_details
      IS
         SELECT a.*
           FROM ra_contacts a
          WHERE contact_id = p_contact_id;

      l_xwrl_requests   xwrl_requests%ROWTYPE;
      l_req             rmi_ows_common_util.ows_request_rec;
      x_return_code     VARCHAR2 (100);
      x_return_msg      VARCHAR2 (100);
   BEGIN
      FOR rec IN cur_contact_details
      LOOP
         l_xwrl_requests := get_open_case ('AR_CONTACTS', rec.contact_id);

         IF l_xwrl_requests.ID IS NOT NULL
         THEN
            x_id := l_xwrl_requests.ID;
            RETURN;
         END IF;

         l_req.entity_type := 'INDIVIDUAL';
         l_req.source_table := 'AR_CONTACTS';
         l_req.source_id := rec.contact_id;
         l_req.first_name := rec.first_name;
         l_req.last_name := rec.last_name;
         l_req.title := rec.title;
         create_ows_generic (p_req              => l_req,
                             p_custom_id1       => NULL,
                             p_custom_id2       => NULL,
                             p_return_code      => x_return_code,
                             p_ret_msg          => x_return_msg,
                             x_id               => x_id
                            );
--         xwrl_utils.ows_individual_screening (p_debug              => 'TRUE',
--                                              p_show_request       => 'FALSE',
--                                              p_show_response      => 'FALSE',
--                                              p_user_id            => v_user_id,
--                                              p_session_id         => v_session_id,
--                                              p_source_table       => 'AR_CONTACTS',
--                                              p_source_id          => rec.contact_id,
--                                              p_givennames         => rec.first_name,
--                                              p_familyname         => rec.last_name,
--                                              p_title              => rec.title,
--                                              x_id                 => x_id
--                                             );
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         RAISE;
   END get_contact_ows_id;

   PROCEDURE get_extseafarer_ows_id (p_esi_id IN NUMBER)
   IS
      --PRAGMA AUTONOMOUS_TRANSACTION;
      x_id              INTEGER;

      --
      CURSOR cur_seafarer_details
      IS
         SELECT *
           FROM exsicd_seafarers_iface
          WHERE esi_id = p_esi_id;

      l_xwrl_requests   xwrl_requests%ROWTYPE;
      l_req             rmi_ows_common_util.ows_request_rec;
      x_return_code     VARCHAR2 (100);
      x_return_msg      VARCHAR2 (100);
   BEGIN
      FOR rec IN cur_seafarer_details
      LOOP
         l_xwrl_requests := get_open_case ('SICD_SEAFARERS', rec.seafarer_id);

         IF l_xwrl_requests.ID IS NOT NULL
         THEN
            x_id := l_xwrl_requests.ID;
            RETURN;
         END IF;

         --
         l_req.entity_type := 'INDIVIDUAL';
         l_req.source_table := 'SICD_SEAFARERS';
         l_req.source_id := rec.seafarer_id;
         l_req.first_name := rec.first_name;
         l_req.last_name := rec.last_name;
         l_req.gender := rec.gender;
         l_req.date_of_birth := rec.birth_date;
         --format_date (rec.birth_date);
         l_req.residence_country_code :=
                             get_country_iso_code (rec.residence_country_code);
         l_req.nationality := get_country_iso_code (rec.nationality);
         create_ows_generic (p_req              => l_req,
                             p_custom_id1       => NULL,
                             p_custom_id2       => NULL,
                             p_return_code      => x_return_code,
                             p_ret_msg          => x_return_msg,
                             x_id               => x_id
                            );
      --
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         RAISE;
   END get_extseafarer_ows_id;

   PROCEDURE get_agent_ows_id (p_customer_id IN NUMBER)
   IS
      --PRAGMA AUTONOMOUS_TRANSACTION;
      x_id            INTEGER;

      --
      CURSOR cur_customer_details
      IS
         SELECT *
           FROM ar_customers
          WHERE customer_id = p_customer_id;

      l_req           rmi_ows_common_util.ows_request_rec;
      x_return_code   VARCHAR2 (100);
      x_return_msg    VARCHAR2 (100);
   BEGIN
      FOR rec IN cur_customer_details
      LOOP
         l_req.entity_type := 'INDIVIDUAL';
         l_req.source_table := 'AR_CUSTOMERS';
         l_req.source_id := rec.customer_id;
         l_req.full_name := rec.customer_name;
         create_ows_generic (p_req              => l_req,
                             p_custom_id1       => NULL,
                             p_custom_id2       => NULL,
                             p_return_code      => x_return_code,
                             p_ret_msg          => x_return_msg,
                             x_id               => x_id
                            );
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         RAISE;
   END get_agent_ows_id;

   PROCEDURE get_customer_ows_id (p_customer_id IN NUMBER)
   IS
      --PRAGMA AUTONOMOUS_TRANSACTION;
      x_id              INTEGER;

      --
      CURSOR cur_customer_details
      IS
         SELECT *
           FROM ar_customers
          WHERE customer_id = p_customer_id;

      v_user_id         NUMBER               := fnd_profile.VALUE ('USER_ID');
      v_session_id      NUMBER;
      l_xwrl_requests   xwrl_requests%ROWTYPE;
      l_req             rmi_ows_common_util.ows_request_rec;
      x_return_code     VARCHAR2 (100);
      x_return_msg      VARCHAR2 (100);
   BEGIN
      FOR rec IN cur_customer_details
      LOOP
         l_xwrl_requests := get_open_case ('AR_CUSTOMERS', rec.customer_id);

         IF l_xwrl_requests.ID IS NOT NULL
         THEN
            x_id := l_xwrl_requests.ID;
            RETURN;
         END IF;

         l_req.entity_type := 'ENTITY';
         l_req.source_table := 'AR_CUSTOMERS';
         l_req.source_id := rec.customer_id;
         l_req.entity_name := rec.customer_name;
         create_ows_generic (p_req              => l_req,
                             p_custom_id1       => NULL,
                             p_custom_id2       => NULL,
                             p_return_code      => x_return_code,
                             p_ret_msg          => x_return_msg,
                             x_id               => x_id
                            );
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         RAISE;
   END get_customer_ows_id;

   PROCEDURE get_corp_ows_id (p_corp_id IN NUMBER)
   IS
      --PRAGMA AUTONOMOUS_TRANSACTION;
      x_id              INTEGER;

      --
      CURSOR cur_corp_details
      IS
         SELECT *
           FROM corp_main
          WHERE corp_id = p_corp_id;

      l_xwrl_requests   xwrl_requests%ROWTYPE;
      l_req             rmi_ows_common_util.ows_request_rec;
      x_return_code     VARCHAR2 (100);
      x_return_msg      VARCHAR2 (100);
   BEGIN
      -- EBS session id
      FOR rec IN cur_corp_details
      LOOP
         l_xwrl_requests := get_open_case ('CORP_MAIN', rec.corp_id);

         IF l_xwrl_requests.ID IS NOT NULL
         THEN
            x_id := l_xwrl_requests.ID;
            RETURN;
         END IF;

         l_req.entity_type := 'ENTITY';
         l_req.source_table := 'CORP_MAIN';
         l_req.source_id := rec.corp_id;
         l_req.entity_name := rec.corp_name1;
         create_ows_generic (p_req              => l_req,
                             p_custom_id1       => NULL,
                             p_custom_id2       => NULL,
                             p_return_code      => x_return_code,
                             p_ret_msg          => x_return_msg,
                             x_id               => x_id
                            );
--         xwrl_utils.ows_entity_screening (p_debug              => 'TRUE',
--                                          p_show_request       => 'FALSE',
--                                          p_show_response      => 'FALSE',
--                                          p_user_id            => v_user_id,
--                                          p_session_id         => v_session_id,
--                                          p_source_table       => 'CORP_MAIN',
--                                          p_source_id          => rec.corp_id,
--                                          p_entityname         => rec.corp_name1,
--                                          x_id                 => x_id
--                                         );
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         RAISE;
   END get_corp_ows_id;

   PROCEDURE get_vetting_ows_id (p_reg11_header_id IN NUMBER)
   IS
      --PRAGMA AUTONOMOUS_TRANSACTION;
      x_id              INTEGER;

      --
      CURSOR cur_vetting_details
      IS
         SELECT *
           FROM reg11_header
          WHERE reg11_header_id = p_reg11_header_id;

      l_xwrl_requests   xwrl_requests%ROWTYPE;
      l_req             rmi_ows_common_util.ows_request_rec;
      x_return_code     VARCHAR2 (100);
      x_return_msg      VARCHAR2 (100);
   BEGIN
      FOR rec IN cur_vetting_details
      LOOP
         l_xwrl_requests :=
                          get_open_case ('REG11_HEADER', rec.reg11_header_id);

         IF l_xwrl_requests.ID IS NOT NULL
         THEN
            x_id := l_xwrl_requests.ID;
            RETURN;
         END IF;

         l_req.entity_type := 'ENTITY';
         l_req.source_table := 'REG11_HEADER';
         l_req.source_id := rec.reg11_header_id;
         l_req.entity_name := rec.current_name;
         create_ows_generic (p_req              => l_req,
                             p_custom_id1       => NULL,
                             p_custom_id2       => NULL,
                             p_return_code      => x_return_code,
                             p_ret_msg          => x_return_msg,
                             x_id               => x_id
                            );
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         RAISE;
   END get_vetting_ows_id;

   PROCEDURE get_vessel_ows_id (p_vessel_pk_id IN NUMBER)
   IS
      --PRAGMA AUTONOMOUS_TRANSACTION;
      x_id              INTEGER;

      --
      CURSOR cur_vessel_details
      IS
         SELECT *
           FROM vssl_vessels
          WHERE vessel_pk = p_vessel_pk_id;

      l_xwrl_requests   xwrl_requests%ROWTYPE;
      l_req             rmi_ows_common_util.ows_request_rec;
      x_return_code     VARCHAR2 (100);
      x_return_msg      VARCHAR2 (100);
   BEGIN
      FOR rec IN cur_vessel_details
      LOOP
         l_xwrl_requests := get_open_case ('VSSL_VESSELS', rec.vessel_pk);

         IF l_xwrl_requests.ID IS NOT NULL
         THEN
            x_id := l_xwrl_requests.ID;
            RETURN;
         END IF;

         l_req.entity_type := 'ENTITY';
         l_req.source_table := 'VSSL_VESSELS';
         l_req.source_id := rec.vessel_pk;
         l_req.entity_name := rec.NAME;
         l_req.registrationnumber := rec.imo_number;
         l_req.vessel_indicator := 'Y';
         create_ows_generic (p_req              => l_req,
                             p_custom_id1       => NULL,
                             p_custom_id2       => NULL,
                             p_return_code      => x_return_code,
                             p_ret_msg          => x_return_msg,
                             x_id               => x_id
                            );
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         RAISE;
   END get_vessel_ows_id;

   PROCEDURE get_vessel_contact_ows_id (
      p_contact_id   IN   NUMBER,
      p_vessel_id    IN   NUMBER
   )
   IS
      --PRAGMA AUTONOMOUS_TRANSACTION;
      x_id              INTEGER;

      --
      CURSOR cur_contact_details
      IS
         SELECT *
           FROM vssl_contacts_v
          WHERE contact_id = p_contact_id AND vessel_id = p_vessel_id;

      l_xwrl_requests   xwrl_requests%ROWTYPE;
      l_req             rmi_ows_common_util.ows_request_rec;
      x_return_code     VARCHAR2 (100);
      x_return_msg      VARCHAR2 (100);
   BEGIN
      FOR rec IN cur_contact_details
      LOOP
         l_xwrl_requests := get_open_case ('VSSL_CONTACTS_V', rec.contact_id);

         IF l_xwrl_requests.ID IS NOT NULL
         THEN
            x_id := l_xwrl_requests.ID;
            RETURN;
         END IF;

         l_req.entity_type := 'INDIVIDUAL';
         l_req.source_table := 'VSSL_CONTACTS_V';
         l_req.source_id := rec.contact_id;
         l_req.first_name := rec.first_name;
         l_req.last_name := rec.last_name;
         l_req.title := rec.title;
         create_ows_generic (p_req              => l_req,
                             p_custom_id1       => NULL,
                             p_custom_id2       => NULL,
                             p_return_code      => x_return_code,
                             p_ret_msg          => x_return_msg,
                             x_id               => x_id
                            );
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         RAISE;
   END get_vessel_contact_ows_id;

   PROCEDURE get_nrmi_ows_id (p_nrmi_cert_id IN NUMBER)
   IS
      --PRAGMA AUTONOMOUS_TRANSACTION;
      x_id              INTEGER;

      --
      CURSOR cur_nrmi_details
      IS
         SELECT *
           FROM nrmi_certificates
          WHERE nrmi_certificates_id = p_nrmi_cert_id;

      l_xwrl_requests   xwrl_requests%ROWTYPE;
      l_req             rmi_ows_common_util.ows_request_rec;
      x_return_code     VARCHAR2 (100);
      x_return_msg      VARCHAR2 (100);
   BEGIN
      FOR rec IN cur_nrmi_details
      LOOP
         nrmi_certs.create_trade_compliance
                         (p_nrmi_certificates_id      => rec.nrmi_certificates_id,
                          p_return_code               => x_return_code,
                          p_return_message            => x_return_msg
                         );
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         RAISE;
   END get_nrmi_ows_id;

   PROCEDURE get_insp_contact_ows_id (p_inspector_contact_id IN NUMBER)
   IS
      --PRAGMA AUTONOMOUS_TRANSACTION;
      x_id              INTEGER;

      --
      CURSOR cur_insp_details
      IS
         SELECT *
           FROM insp_inspector_contacts
          WHERE inspector_contact_id = p_inspector_contact_id;

      l_xwrl_requests   xwrl_requests%ROWTYPE;
      l_req             rmi_ows_common_util.ows_request_rec;
      x_return_code     VARCHAR2 (100);
      x_return_msg      VARCHAR2 (100);
   BEGIN
      FOR rec IN cur_insp_details
      LOOP
         l_xwrl_requests :=
            get_open_case ('INSP_INSPECTOR_CONTACTS',
                           rec.inspector_contact_id
                          );

         IF l_xwrl_requests.ID IS NOT NULL
         THEN
            x_id := l_xwrl_requests.ID;
            RETURN;
         END IF;

         l_req.entity_type := 'INDIVIDUAL';
         l_req.source_table := 'INSP_INSPECTOR_CONTACTS';
         l_req.source_id := rec.inspector_contact_id;
         l_req.first_name := rec.given_name;
         l_req.last_name := rec.surname;
         l_req.gender := rec.sex;
         l_req.nationality := get_country_iso_code (rec.citizenship);
         create_ows_generic (p_req              => l_req,
                             p_custom_id1       => NULL,
                             p_custom_id2       => NULL,
                             p_return_code      => x_return_code,
                             p_ret_msg          => x_return_msg,
                             x_id               => x_id
                            );
--         xwrl_utils.ows_individual_screening
--            (p_debug                        => 'TRUE',
--             p_show_request                 => 'FALSE',
--             p_show_response                => 'FALSE',
--             p_user_id                      => v_user_id,
--             p_session_id                   => v_session_id,
--             p_source_table                 => 'INSP_INSPECTOR_CONTACTS',
--             p_source_id                    => rec.inspector_contact_id,
--             p_givennames                   => rec.given_name,
--             p_familyname                   => rec.surname,
--             p_gender                       => rec.sex,
--             p_nationalitycountrycodes      => get_country_iso_code
--                                                              (rec.citizenship),
--             x_id                           => x_id
--            );
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         RAISE;
   END get_insp_contact_ows_id;

   PROCEDURE get_insp_ows_id (p_insp_id IN NUMBER)
   IS
      --PRAGMA AUTONOMOUS_TRANSACTION;
      x_id              INTEGER;

      --
      CURSOR cur_insp_details
      IS
         SELECT *
           FROM insp_inspectors
          WHERE inspector_id = p_insp_id;

      l_xwrl_requests   xwrl_requests%ROWTYPE;
      l_req             rmi_ows_common_util.ows_request_rec;
      x_return_code     VARCHAR2 (100);
      x_return_msg      VARCHAR2 (100);
   BEGIN
      FOR rec IN cur_insp_details
      LOOP
         l_xwrl_requests :=
                          get_open_case ('INSP_INSPECTORS', rec.inspector_id);

         IF l_xwrl_requests.ID IS NOT NULL
         THEN
            x_id := l_xwrl_requests.ID;
            RETURN;
         END IF;

         l_req.entity_type := 'ENTITY';
         l_req.source_table := 'INSP_INSPECTORS';
         l_req.source_id := rec.inspector_id;
         l_req.entity_name := rec.NAME;
         create_ows_generic (p_req              => l_req,
                             p_custom_id1       => NULL,
                             p_custom_id2       => NULL,
                             p_return_code      => x_return_code,
                             p_ret_msg          => x_return_msg,
                             x_id               => x_id
                            );
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         RAISE;
   END get_insp_ows_id;

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
   BEGIN
      l_req_details := get_case_details (p_id);

      IF l_req_details.PATH = 'INDIVIDUAL'
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

   PROCEDURE send_notice_to_legal (p_id IN NUMBER, x_message IN VARCHAR2)
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
      p_name_screened             VARCHAR2 (100);
   BEGIN
      --
      p_name_screened := get_name (p_id);
      sender_email_address := '#IRI-Trade@register-iri.com';
      destination_email_address :=
                          'Legal@register-iri.com,IRI-Trade@Register-IRI.com';
      v_subject_line :=
            'OWS TEST!Trade Compliance for blocked entity '
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
--   p_name_screened          IN       VARCHAR2,
      p_status           IN       VARCHAR2,
--   p_notes                  IN       VARCHAR2,
      p_source_table     IN       VARCHAR2,
      p_source_id        IN       NUMBER,
      p_return_code      OUT      NUMBER,
      p_return_message   OUT      VARCHAR2
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
      cc2                         VARCHAR2 (300);
      l_fin_no                    VARCHAR2 (100);
      p_name_screened             VARCHAR2 (100);
      p_notes                     VARCHAR2 (1000);

      CURSOR cur_notes
      IS
         SELECT   xcn.note
             FROM xwrl_case_notes xcn, xwrl_requests xr
            WHERE xcn.case_id = xr.case_id AND xr.ID = p_id
         ORDER BY xcn.ID DESC;
   BEGIN
      p_name_screened := get_name (p_id);
      p_return_code := 0;
      p_return_message := 'Successful';
      sender_email_address := '#IRI-Trade@register-iri.com';
      DBMS_OUTPUT.put_line ('Start');

--      OPEN cur_notes;

      --      FETCH cur_notes
--       INTO p_notes;

      --      CLOSE cur_notes;

      --      --SAURABH 16-NOV-2018 T20181115.0015
      --destination_email_address := get_user_email_address(p_created_by);
      IF world_check_iface.is_user_internal (p_created_by)
      THEN
         destination_email_address := get_user_email_address (p_created_by);
      END IF;

      -- 29-MAR-2019 SAURABH T20190328.0004
      IF p_source_table = 'SICD_SEAFARERS'
      THEN
         l_fin_no := p_source_id;
      --
      END IF;

      --
      DBMS_OUTPUT.put_line ('p_source_id' || l_fin_no);

      --APPS.mt_log_error(p_NAME_SCREENED||' '||destination_email_address ||' '||SYSDATE); -- ZK 06072018
      IF p_status IN ('Approved', 'Rejected')
      THEN
         v_subject_line :=
               'Trade Compliance for '
            -- 29-MAR-2019 SAURABH T20190328.0004
            || l_fin_no
            --
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
      ELSIF p_status = 'Pending'
      THEN
         -- Changed Subject Line to match other cases ZK 06082018 T20180607.0017
         v_subject_line :=
               'Trade Compliance for '
            -- 29-MAR-2019 SAURABH T20190328.0004
            || l_fin_no
            || p_name_screened
            || ' has been set to Pending.';
         detail_line :=
               'Trade Compliance for '
            || p_name_screened
            || ' has been set to Pending. <BR> <BR>Please address the following comments: <BR><BR>'
            || REPLACE (p_notes, CHR (10), '<BR>')
            || '<BR><BR><BR>These comments can be viewed in the TC screen by pressing the Enter/View Notes button in the upper right section of the screen.';
      -- APPS.mt_log_error(p_NAME_SCREENED||' '||'Detail Line '||SYSDATE); -- ZK 06072018

      --SAURABH T20181107.0012 14-NOV-2018
      --START
      ELSIF p_status = 'Provisional'
      THEN
         v_subject_line :=
               'Trade Compliance for '
            -- 29-MAR-2019 SAURABH T20190328.0004
            || l_fin_no
            || p_name_screened
            || ' has been set to Provisional.';
         detail_line :=
               'Trade Compliance for '
            || p_name_screened
            || ' has been set to Provisional. <BR> <BR>Please address the following comments: <BR><BR>'
            || REPLACE (p_notes, CHR (10), '<BR>')
            || '<BR><BR><BR>These comments can be viewed in the TC screen by pressing the Enter/View Notes button in the upper right section of the screen.';
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
            'chickman@register-iri.com,pfeild@register-iri.com,jvannuys@register-iri.com,jnotay@register-iri.com,jpatsios@Register-IRI.com';
                         -- T20181205.0025 - Added Jordan and removed Natalie
--, zkhan@Register-IRI.com'; T20180910.0010 ZK  Added and then removed Nancy F.; T20181030.0032 ZK 11012018 removed Ryan
   --- APPS.mt_log_error(p_NAME_SCREENED||' cc: '||cc||' '||SYSDATE); -- ZK 06072018
      ELSE
         cc := 'chickman@register-iri.com,pfeild@Register-IRI.com';
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
         demo_mail.begin_mail (sender          => sender_email_address,
                               cc              => cc,
                               recipients      => destination_email_address,
                               subject         => 'OWS - ' || v_subject_line,
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

      SELECT worldcheck_external_xref_seq.NEXTVAL
        INTO xref.worldcheck_external_xref_id
        FROM DUAL;

      return_code := 0;
      return_message := 'OK';

      SELECT DECODE (xref.source_table,
                     'CORP_MAIN', 'CORP_ID',
                     'NRMI_CERTIFICATES_rq', 'NRMI_CERTIFICATES_ID',
                     'REG11_HEADER', 'REG11_HEADER_ID',
                     'NRMI_VESSELS_KNOWN_PARTY', 'NRMI_CERTIFICATES_ID',
                     'NRMI_CERTIFICATES_bt', 'NRMI_CERTIFICATES_ID',
                     'NRMI_CERTIFICATES', 'NRMI_CERTIFICATES_ID',
                     'NRMI_VESSELS_vssl', 'NRMI_CERTIFICATES_ID',
                     'NRMI_VESSELS_reg_own', 'NRMI_CERTIFICATES_ID',
                     'SICD_SEAFARERS', 'SEAFARER_ID',
                     'AR_CUSTOMERS', 'CUSTOMER_ID',
                     'VSSL_VESSELS', 'VESSEL_PK',
                     'VSSL_CONTACTS_V', 'CONTACT_ID',
                     'INSP_INSPECTORS', 'INSPECTOR_ID'
                    )
        INTO l_source_table_column
        FROM DUAL;

      BEGIN
         UPDATE vssl.worldcheck_external_xref
            SET source_table_status_column = xref.source_table_status_column,
                source_table_column =
                         NVL (xref.source_table_column, l_source_table_column),
                last_update_date = SYSDATE,
                last_updated_by = user_id,
                last_update_login = login_id
          WHERE 1 = 1
            AND source_table = xref.source_table
            AND source_table_id = xref.source_table_id
            AND wc_screening_request_id = xref.wc_screening_request_id
            AND TRUNC (creation_date) >= g_ows_cutoff_date;

         IF SQL%ROWCOUNT = 0
         THEN
            INSERT INTO vssl.worldcheck_external_xref
                        (worldcheck_external_xref_id,
                         wc_screening_request_id,
                         source_table,
                         source_table_id,
                         source_table_column,
                         source_table_status_column,
                         created_by,
                         creation_date,
                         last_updated_by,
                         last_update_date,
                         last_update_login
                        )
                 VALUES (xref.worldcheck_external_xref_id /* WORLDCHECK_EXTERNAL_XREF_ID */,
                         xref.wc_screening_request_id /* WC_SCREENING_REQUEST_ID */,
                         xref.source_table /* SOURCE_TABLE */,
                         xref.source_table_id /* SOURCE_TABLE_ID */,
                         NVL
                            (xref.source_table_column, l_source_table_column) /* SOURCE_TABLE_COLUMN */,
                         xref.source_table_status_column /* SOURCE_TABLE_STATUS_COLUMN */,
                         user_id /* CREATED_BY */,
                         SYSDATE /* CREATION_DATE */,
                         user_id /* LAST_UPDATED_BY */,
                         SYSDATE /* LAST_UPDATE_DATE */,
                         login_id                      /* LAST_UPDATE_LOGIN */
                        );
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            ROLLBACK;
            return_code := SQLCODE;
            return_message := SQLERRM;
            RETURN;
      END;

      COMMIT;
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
         UNION ALL
         SELECT xrc.x_state matchstatus, xrc.CATEGORY category_type
           FROM xwrl_requests xr, xwrl_response_entity_columns xrc
          WHERE 1 = 1
            AND xr.ID = p_id
            AND xr.ID = xrc.request_id
            AND xr.PATH = 'ENTITY';
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
         SELECT *
           FROM xwrl_requests xr
          WHERE ID = p_wc_screening_request_id;

      ows_rec                      get_ows_req%ROWTYPE;

      CURSOR get_ows_ind (p_request_id IN NUMBER)
      IS
         SELECT xrc.*
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
         l_passport_issuing_country := ows_ind.addresscountrycode;
         l_citizenship_country_code := ows_ind.nationalitycountrycodes;
         l_residence_country_code := ows_ind.residencycountrycode;
         l_city_id := rmi_ows_common_util.get_city_list_id (ows_ind.city);
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
                              world_check_iface.c_automatic_approval_uid,
                              --WORLDCHECK_AUTOMATIC_APPROVAL
                              SYSDATE,
                              'A',
                              ows_rec.ID;

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
      location_msg          VARCHAR2 (100)            := 'create_wc_generic:';
      sub_msg               VARCHAR2 (500);

      CURSOR get_request_info (p_id IN NUMBER)
      IS
         SELECT *
           FROM xwrl_requests
          WHERE ID = p_id;

      scrrqst               get_request_info%ROWTYPE;

      CURSOR get_wc_matches_ind (p_request_id IN NUMBER)
      IS
         SELECT COUNT (1)                                             --xrc.*
           FROM xwrl_requests xr, xwrl_response_ind_columns xrc
          WHERE 1 = 1
            AND xr.ID = p_request_id
            AND xr.ID = xrc.request_id
            AND xr.PATH = 'INDIVIDUAL';

      CURSOR get_wc_matches_ent (p_request_id IN NUMBER)
      IS
         SELECT COUNT (1)                                              --xrc.*
           FROM xwrl_requests xr, xwrl_response_entity_columns xrc
          WHERE 1 = 1
            AND xr.ID = p_request_id
            AND xr.ID = xrc.request_id
            AND xr.PATH = 'ENTITY';

      mtch_ind              get_wc_matches_ind%ROWTYPE;
      l_number_of_matches   NUMBER                                   := 0;
      l_user_id             NUMBER            := fnd_profile.VALUE ('USER_ID');
      l_session_id          NUMBER;
      xref                  rmi_ows_common_util.wc_external_xref_rec;
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
         xwrl_utils.ows_individual_screening
            (p_debug                     => 'TRUE',
             p_show_request              => 'FALSE',
             p_show_response             => 'FALSE',
             p_user_id                   => l_user_id,
             p_session_id                => l_session_id,
             p_source_table              => p_req.source_table,
             p_source_id                 => p_req.source_id,
             p_fullname                  => p_req.full_name,
             p_familyname                => p_req.last_name,
             p_givennames                => p_req.first_name,
             p_gender                    => SUBSTR (p_req.gender, 1, 1),
             p_dateofbirth               => rmi_ows_common_util.format_date
                                                          (p_req.date_of_birth),
             p_yearofbirth               => TO_CHAR (p_req.date_of_birth,
                                                     'RRRR'
                                                    ),
             p_city                      => p_req.city,
             p_countryofbirthcode        => rmi_ows_common_util.get_country_iso_code
                                                            (p_req.nationality),
             p_addresscountrycode        => rmi_ows_common_util.get_country_iso_code
                                               (p_req.passport_issuing_country_code
                                               ),
             p_residencycountrycode      => rmi_ows_common_util.get_country_iso_code
                                                 (p_req.residence_country_code),
             --p_nationalitycountrycodes      => get_country_iso_code(rec.nationality),
             p_nationalid                => NULL,
             p_passportnumber            => p_req.passport_number,
             p_customstring1             => p_custom_id1,
             p_customstring2             => p_custom_id2,
             x_id                        => x_id
            );
         sub_msg := 'after initiate_wc_screening :' || p_ret_msg;
         DBMS_OUTPUT.put_line (sub_msg);

         IF x_id > 0
         THEN
            -- Create Xref
            xref.source_table := p_req.source_table;
            xref.source_table_id := p_req.source_id;
            xref.source_table_status_column := p_req.source_table_column;
            xref.worldcheck_external_xref_id := NULL;
            xref.wc_screening_request_id := x_id;
            rmi_ows_common_util.create_new_xref (xref,
                                                 p_return_code,
                                                 p_ret_msg
                                                );

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
         ELSE
            p_return_code := 'ERROR_CREATING_OWS';
         END IF;
      ELSE
         xwrl_utils.ows_entity_screening
                               (p_debug                 => 'TRUE',
                                p_show_request          => 'FALSE',
                                p_show_response         => 'FALSE',
                                p_user_id               => l_user_id,
                                p_session_id            => l_session_id,
                                p_source_table          => p_req.source_table,
                                p_source_id             => p_req.source_id,
                                p_entityname            => p_req.entity_name,
                                p_vessel_indicator      => p_req.vessel_indicator,
                                x_id                    => x_id
                               );
         sub_msg := 'after initiate_wc_screening :' || p_ret_msg;
         DBMS_OUTPUT.put_line (sub_msg);

         IF x_id > 0
         THEN
            -- Create Xref
            xref.source_table := p_req.source_table;
            xref.source_table_id := p_req.source_id;
            xref.source_table_status_column := p_req.source_table_column;
            xref.worldcheck_external_xref_id := NULL;
            xref.wc_screening_request_id := x_id;
            rmi_ows_common_util.create_new_xref (xref,
                                                 p_return_code,
                                                 p_ret_msg
                                                );

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
      t_data            IN OUT   world_check_iface.screening_tab
   )
   IS
      CURSOR get_unattached_ows
      IS
         SELECT   *
             FROM xwrl_requests r
            WHERE NOT EXISTS (
                     SELECT 'x'
                       FROM worldcheck_external_xref xr
                      WHERE r.ID = xr.wc_screening_request_id
                        AND xr.creation_date >= g_ows_cutoff_date)
              AND 1 = 2
         ORDER BY creation_date DESC;

      screening_rec2_ows              get_unattached_ows%ROWTYPE;

      CURSOR get_screening_ows
      IS
         SELECT   r.*
             FROM worldcheck_external_xref xr, xwrl_requests r
            WHERE xr.wc_screening_request_id = r.ID
              AND xr.source_table = p_source_table
--           AND source_table_column = p_source_column
              AND xr.source_table_id = p_source_id
              AND xr.creation_date > = g_ows_cutoff_date
         ORDER BY r.creation_date DESC;

      alias_name                      vssl.wc_screening_request.name_screened%TYPE;
      alias_wc_screening_request_id   vssl.wc_screening_request.alias_wc_screening_request_id%TYPE;
      ii                              NUMBER                              := 1;
      name_addition                   VARCHAR2 (100);
   BEGIN
      name_addition := NULL;

      IF is_ows_user = 'N'
      THEN
         world_check_iface.query_cross_reference (p_source_table,
                                                  p_source_column,
                                                  p_source_id,
                                                  t_data
                                                 );
         RETURN;
      END IF;

      -- OWS User
      IF p_source_id IS NOT NULL
      THEN
         --dbms_output.put_line('before loop');
         FOR screening_rec IN get_screening_ows
         LOOP
--dbms_output.put_line('screen_rec loop');
--         alias_wc_screening_request_id := screening_rec.alias_wc_screening_request_id;
--         t_data (ii).citizenship_country_code := screening_rec.citizenship_country_code;
--         t_data (ii).corp_residence_country_code := screening_rec.COUNTRY_OF_RESIDENCE;
            t_data (ii).created_by := screening_rec.created_by;
            t_data (ii).creation_date := screening_rec.creation_date;
--         t_data (ii).date_of_birth := screening_rec.date_of_birth;
            t_data (ii).last_updated_by := screening_rec.last_updated_by;
            t_data (ii).entity_type :=
                       rmi_ows_common_util.get_entity_type (screening_rec.ID);
            t_data (ii).last_updated_date := screening_rec.last_update_date;
            t_data (ii).last_update_login := screening_rec.last_update_login;
--         t_data (ii).name_identifier := rmi_ows_common_util.get_name(r.id);
            t_data (ii).name_screened :=
                              rmi_ows_common_util.get_name (screening_rec.ID);
--         t_data (ii).notes := screening_rec.notes;
--         t_data (ii).notify_user_upon_approval := screening_rec.notify_user_upon_approval;
--         t_data (ii).ofac_list_edoc_id := screening_rec.ofac_list_edoc_id;
            t_data (ii).ofac_list_is_enty_on_list := 'N';
--         t_data (ii).passport_issuing_country_code :=screening_rec.passport_issuing_country_code;
--         t_data (ii).passport_number := screening_rec.passport_number;
--         t_data (ii).sent_to_legal_date := screening_rec.sent_to_legal_date;
--         t_data (ii).sex := screening_rec.sex;
            t_data (ii).status :=
               rmi_ows_common_util.case_wf_status
                                                 (screening_rec.case_workflow);
            t_data (ii).status_date := screening_rec.last_update_date;
            t_data (ii).status_updated_by := screening_rec.last_updated_by;
            t_data (ii).wc_screening_request_id := screening_rec.ID;
            ---EXIT WHEN get_screening%NOTFOUND;
            ii := ii + 1;
         END LOOP;
      ---CLOSE get_screening;
      ELSE
         OPEN get_unattached_ows;

         LOOP
            FETCH get_unattached_ows
             INTO screening_rec2_ows;

--         alias_wc_screening_request_id := screening_rec2.alias_wc_screening_request_id;
--         t_data (ii).citizenship_country_code :=
--                                      screening_rec2.citizenship_country_code;
--         t_data (ii).corp_residence_country_code :=
--                                   screening_rec2.corp_residence_country_code;
            t_data (ii).created_by := screening_rec2_ows.created_by;
            t_data (ii).creation_date := screening_rec2_ows.creation_date;
--         t_data (ii).date_of_birth := screening_rec2.date_of_birth;
            t_data (ii).entity_type :=
                  rmi_ows_common_util.get_entity_type (screening_rec2_ows.ID);
            t_data (ii).last_updated_by := screening_rec2_ows.last_updated_by;
            t_data (ii).last_updated_date :=
                                          screening_rec2_ows.last_update_date;
            t_data (ii).last_update_login :=
                                         screening_rec2_ows.last_update_login;
--         t_data (ii).name_identifier := screening_rec2.name_identifier;
            t_data (ii).name_screened :=
                         rmi_ows_common_util.get_name (screening_rec2_ows.ID);
--         t_data (ii).notes := screening_rec2.notes;
--         t_data (ii).notify_user_upon_approval :=
--                                      screening_rec2.notify_user_upon_approval;
--         t_data (ii).ofac_list_edoc_id := screening_rec2.ofac_list_edoc_id;
            t_data (ii).ofac_list_is_enty_on_list := 'N';
--         t_data (ii).passport_issuing_country_code :=
--                                  screening_rec2.passport_issuing_country_code;
--         t_data (ii).passport_number := screening_rec2.passport_number;
--         t_data (ii).sent_to_legal_date := screening_rec2.sent_to_legal_date;
--         t_data (ii).sex := screening_rec2.sex;
            t_data (ii).status :=
               rmi_ows_common_util.case_wf_status
                                            (screening_rec2_ows.case_workflow);
            t_data (ii).status_date := screening_rec2_ows.last_update_date;
            t_data (ii).status_updated_by :=
                                           screening_rec2_ows.last_updated_by;
            t_data (ii).wc_screening_request_id := screening_rec2_ows.ID;
            EXIT WHEN get_unattached_ows%NOTFOUND;
            ii := ii + 1;
         END LOOP;

         CLOSE get_unattached_ows;
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
          WHERE iso_alpha2_code = p_iso_country;
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
END; 
/

