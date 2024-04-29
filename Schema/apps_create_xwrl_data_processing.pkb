create or replace PACKAGE BODY xwrl_data_processing AS

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_create_xwrl_data_processing.pkb 1.1 2019/11/15 12:00:00ET   IRI Exp                               $*/
/********************************************************************************************************************
* Object Type         : Package Body                                                                                *
* Name                : xwrl_data_processing                                                            *
* Script Name         : apps_create_xwrl_data_processing.pkb                                                        *
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
* 19-NOV-2019 IRI              1.2                TSUAZO          19-NOV-2019  I     Diable WC processing; Add Master record processing              *
*                                                                                                                   *
********************************************************************************************************************/

   FUNCTION verify_master_fullname (
      p_source_table          VARCHAR2
      , p_source_table_column   VARCHAR2
      , p_source_id             INTEGER
      , p_entity_type           VARCHAR2 DEFAULT NULL
      , p_target_column           VARCHAR2 DEFAULT NULL
   ) RETURN VARCHAR2 IS

      v_sql             VARCHAR2 (1000);

      v_append          VARCHAR2 (500);

      v_target_column   VARCHAR2 (4000);
      v_name            VARCHAR2 (4000);
      v_source_table            VARCHAR2 (4000);

   BEGIN

      v_sql := NULL;
      v_append := NULL;
      v_name := NULL;

      v_source_table := p_source_table;

      if p_source_table = 'NRMI_VESSELS_KNOWN_PARTY' then
        v_source_table := 'NRMI_KNOWN_PARTIES';
      end if;

      if p_source_table = 'NRMI_CERTIFICATES_rq' or p_source_table = 'NRMI_CERTIFICATES_bt' then
        v_source_table := 'NRMI_CERTIFICATES';
      end if;

      if p_source_table = 'NRMI_VESSELS_reg_own' or p_source_table = 'NRMI_VESSELS_vssl' then
        v_source_table := 'NRMI_VESSELS';
      end if;

      IF p_target_column IS NULL THEN

         v_target_column := NULL;

         IF p_source_table = 'CORP_MAIN' THEN
            v_target_column := 'CORP_NAME1';
         END IF;

         IF p_source_table = 'AR_CUSTOMERS' THEN
            v_target_column := 'CUSTOMER_NAME';
         END IF;

         IF p_source_table = 'SICD_SEAFARERS' THEN
            v_target_column := 'ltrim(first_name||' || chr (39) || ' ' || chr (39) || '||last_name)';
         END IF;

         IF p_source_table = 'EXSICD_SEAFARERS_IFACE' THEN
            v_target_column := 'ltrim(first_name||' || chr (39) || ' ' || chr (39) || '||last_name)';
             v_append := ' and rownum = 1';
         END IF;

         IF p_source_table = 'AR_CONTACTS_V' THEN
            v_target_column := 'ltrim(first_name||' || chr (39) || ' ' || chr (39) || '||last_name)';
            v_append := ' and rownum = 1';
         END IF;

         IF p_source_table = 'VSSL_VESSELS' THEN
            v_target_column := 'NAME';  
      /* Note: FROM VSSL_STATUSESwhere unique_record_identifier = 'Y' 
      v_append := ' and status in ('||CHR(39)||'AC'||CHR(39)||','||CHR(39)||'A'||CHR(39)||','||CHR(39)||'SU'||CHR(39)||','||CHR(39)||'RV'||CHR(39)||','||CHR(39)||'S'||CHR(39)||')'; */
      /* Note: We just need to confirm that there is a single match because it might be in a historical record depending on chronological order of process through the system */
            v_append := ' and rownum = 1';

         END IF;

      ELSE

         v_target_column := p_target_column;

      END IF;

      IF v_target_column IS NOT NULL THEN
         v_sql := 'select ' || v_target_column || ' from ' || v_source_table || ' where ' || p_source_table_column || ' = ' || p_source_id;
         IF v_append IS NOT NULL THEN
            v_sql := v_sql || v_append;
         END IF;
         EXECUTE IMMEDIATE v_sql
         INTO v_name;
      END IF;


   --dbms_output.put_line('SQL :'||v_sql);

      RETURN UPPER(TRIM( BOTH  FROM v_name));

   END verify_master_fullname;


   PROCEDURE process_wc_data_individual (
      p_max_jobs INTEGER DEFAULT NULL
   ) IS

      CURSOR crequest IS
   -- Note: This is for testing purpose and will need to be modified for Production
      WITH xref AS (
         select unique wc_screening_request_id
from xwrl_party_master
      )
      SELECT UNIQUE
         wsr.wc_screening_request_id
         , wsr.name_screened
         , wsr.entity_type
         , TO_CHAR (wsr.date_of_birth, 'YYYYMMDD') date_of_birth
         , wsr.sex
         , wsr.passport_number
         , wsr.passport_issuing_country_code
         , wsr.citizenship_country_code
         , wsr.residence_country_code
         , wsr.city_name
         , wsr.wc_city_list_id
         , wsr.alias_wc_screening_request_id
         , wsr.created_by
         , wsr.creation_date
         , wsr.last_updated_by
         , wsr.last_update_date
      FROM
         wc_screening_request wsr
         , xref
      WHERE
         wsr.wc_screening_request_id = xref.wc_screening_request_id (+)
         AND xref.wc_screening_request_id IS NULL
         AND wsr.entity_type = 'INDIVIDUAL'
         AND (wsr.status IN (
            'Provisional'
            , 'Legal Review'
            , 'Pending'
            , 'Sr. Legal Review'
         )
              OR wsr.status = 'Approved'
              AND trunc (status_date) > trunc (SYSDATE) - 2)
      ORDER BY
         1 DESC;

      CURSOR cxref (
         p_request_id INTEGER
      ) IS
      SELECT
         xref.wc_screening_request_id
         , xref.source_table
         , xref.source_table_column
         , xref.source_table_id
         , xref.created_by
         , xref.creation_date
         , xref.last_updated_by
         , xref.last_update_date
      FROM
         worldcheck_external_xref xref
      WHERE
         xref.wc_screening_request_id = p_request_id
         AND xref.source_table_id IS NOT NULL
      ORDER BY
         xref.worldcheck_external_xref_id;

      v_count                       INTEGER;
      v_error                       INTEGER;
      v_edq                         INTEGER;
      v_server                      VARCHAR2 (50);
      v_program_name                VARCHAR2 (1000);
      v_job_name                    VARCHAR2 (1000);
      v_job_class                   VARCHAR2 (1000);
      v_instance                    VARCHAR2 (50);
      is_service_available          BOOLEAN;
      v_max_jobs                    INTEGER;
      v_ratio                       INTEGER;
      isowsavailable                BOOLEAN;

      v_pass_issuing_country_code   VARCHAR2 (10);
      v_citizenship_country_code    VARCHAR2 (10);
      v_residence_country_code      VARCHAR2 (10);

   BEGIN

      v_program_name := 'OWS_INDIVIDUAL_SCREENING_PRG';
      v_job_class := 'OWS_JOB_CLASS';

      v_count := 0;
      v_error := 0;

      v_max_jobs := xwrl_utils.get_max_jobs; -- get maximum jobs for environment
      v_instance := xwrl_utils.get_instance;

      utl_http.set_response_error_check (true);
      utl_http.set_detailed_excp_support (true);




         -- Override max jobs is parameter is passed
      IF p_max_jobs IS NOT NULL THEN
         v_max_jobs := p_max_jobs;
      END IF;

      xwrl_data_processing.v_rownum := v_max_jobs;

      FOR crequestrec IN crequest LOOP
 FOR cxrefrec IN cxref (crequestrec.wc_screening_request_id) LOOP

         v_count := v_count + 1;

         IF crequestrec.passport_issuing_country_code IS NOT NULL THEN
            SELECT
               iso_alpha2_code
            INTO v_pass_issuing_country_code
            FROM
               sicd_countries
            WHERE
               country_code = crequestrec.passport_issuing_country_code;
         END IF;

         IF crequestrec.citizenship_country_code IS NOT NULL THEN
            SELECT
               iso_alpha2_code
            INTO v_citizenship_country_code
            FROM
               sicd_countries
            WHERE
               country_code = crequestrec.citizenship_country_code;
         END IF;

         IF crequestrec.residence_country_code IS NOT NULL THEN
            SELECT
               iso_alpha2_code
            INTO v_residence_country_code
            FROM
               sicd_countries
            WHERE
               country_code = crequestrec.residence_country_code;
         END IF;

         crequestrec.name_screened := replace (crequestrec.name_screened, '&', chr (38) || 'amp;'); -- replace ampersand for XML processing
         crequestrec.name_screened := replace (crequestrec.name_screened, '"');  -- replace double quotes for XML processing

         v_job_name := 'OWS_I_' || TO_CHAR (SYSDATE, 'YYYYMMDDHH24MISS') || '_' || v_count || '_JOB';

         dbms_scheduler.create_job (job_name => v_job_name, job_class => v_job_class, program_name => v_program_name, start_date => SYSDATE, end_date => NULL, enabled => false, comments => 'Oracle OWS Individual Screening');


         -- Uncomment Server for testing purpose
         --dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'Server', argument_value => 'IRIDROWS-PRI'); -- Server
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'SourceTable', argument_value => cxrefrec.source_table); -- SourceTable
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'SourceId', argument_value => cxrefrec.source_table_id); -- SourceId
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'WcScreeningRequestId', argument_value => crequestrec.wc_screening_request_id); -- WcScreeningRequestId
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'JobId', argument_value => v_job_name); -- JobId
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'FullName', argument_value => crequestrec.name_screened); -- FullName
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'DateOfBirth', argument_value => crequestrec.date_of_birth); -- DateOfBirth
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'UserId', argument_value => crequestrec.created_by); -- UserId
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'PassportNumber', argument_value => crequestrec.passport_number);
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'ResidencyCountryCode', argument_value => v_residence_country_code); -- UserId
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'NationalityCountryCodes', argument_value => v_citizenship_country_code); -- UserId   
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'Gender', argument_value => crequestrec.sex);
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'City', argument_value => crequestrec.city_name);
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'UpdateUserId', argument_value => crequestrec.last_updated_by);
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'ParentId', argument_value => crequestrec.alias_wc_screening_request_id);
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'RelationshipType', argument_value => NULL);
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'CityId', argument_value => crequestrec.wc_city_list_id);

         dbms_scheduler.enable (name => v_job_name);

         dbms_lock.sleep (xwrl_utils.get_max_pause);

      END LOOP;

      END LOOP;

   END process_wc_data_individual;

   PROCEDURE process_wc_data_entity (
      p_max_jobs INTEGER DEFAULT NULL
   ) IS

      CURSOR crequest IS
   -- Note: This is for testing purpose and will need to be modified for Production
      WITH xref AS (
         SELECT UNIQUE
            wc_screening_request_id
         FROM
            xwrl_requests
      )
      SELECT UNIQUE
         wsr.wc_screening_request_id
         , wsr.name_screened
         , wsr.entity_type
         , DECODE (wsr.entity_type, 'VESSEL', 'Y', NULL) vessel_indicator
         , wsr.corp_residence_country_code
         , wsr.city_name
         , wsr.wc_city_list_id
         , wsr.imo_number
         , wsr.alias_wc_screening_request_id
         , wsr.created_by
         , wsr.last_updated_by
      FROM
         wc_screening_request wsr
         , xref
      WHERE
         wsr.wc_screening_request_id = xref.wc_screening_request_id (+)
         AND xref.wc_screening_request_id IS NULL
         AND wsr.entity_type <> 'INDIVIDUAL'
         AND (wsr.status IN (
            'Provisional'
            , 'Legal Review'
            , 'Pending'
            , 'Sr. Legal Review'
         )
              OR wsr.status = 'Approved'
              AND trunc (status_date) > trunc (SYSDATE) - 2)
      ORDER BY
         1 DESC;

      CURSOR cxref (
         p_request_id INTEGER
      ) IS
      SELECT
         xref.wc_screening_request_id
         , xref.source_table
         , xref.source_table_column
         , xref.source_table_id
         , xref.created_by
         , xref.creation_date
         , xref.last_updated_by
         , xref.last_update_date
      FROM
         worldcheck_external_xref xref
      WHERE
         xref.wc_screening_request_id = p_request_id
         AND xref.source_table_id IS NOT NULL
      ORDER BY
         xref.worldcheck_external_xref_id;

      v_count                         INTEGER;
      v_error                         INTEGER;
      v_edq                           INTEGER;
      v_instance                      VARCHAR2 (50);
      v_server                        VARCHAR2 (50);
      v_program_name                  VARCHAR2 (1000);
      v_job_name                      VARCHAR2 (1000);
      v_job_class                     VARCHAR2 (1000);
      is_service_available            BOOLEAN;
      v_max_jobs                      INTEGER;
      v_ratio                         INTEGER;
      isowsavailable                  BOOLEAN;
      v_corp_residence_country_code   VARCHAR2 (10);

   BEGIN

      v_program_name := 'OWS_ENTITY_SCREENING_PRG';
      v_job_class := 'OWS_JOB_CLASS';

      v_count := 0;
      v_error := 0;

      v_max_jobs := xwrl_utils.get_max_jobs; -- get maximum jobs for environment
      v_instance := xwrl_utils.get_instance;

      utl_http.set_response_error_check (true);
      utl_http.set_detailed_excp_support (true);




         -- Override max jobs is parameter is passed
      IF p_max_jobs IS NOT NULL THEN
         v_max_jobs := p_max_jobs;
      END IF;

      xwrl_data_processing.v_rownum := v_max_jobs;

      FOR crequestrec IN crequest LOOP
 FOR cxrefrec IN cxref (crequestrec.wc_screening_request_id) LOOP

         v_count := v_count + 1;

         v_corp_residence_country_code := NULL;
         IF crequestrec.corp_residence_country_code IS NOT NULL THEN
            BEGIN
               SELECT
                  iso_alpha2_code
               INTO v_corp_residence_country_code
               FROM
                  sicd_countries
               WHERE
                  country_code = crequestrec.corp_residence_country_code;
            EXCEPTION
               WHEN no_data_found THEN
                  NULL;
            END;
         END IF;

         crequestrec.name_screened := replace (crequestrec.name_screened, '&', chr (38) || 'amp;'); -- replace ampersand for XML processing
         crequestrec.name_screened := replace (crequestrec.name_screened, '"');  -- replace double quotes for XML processing

         v_job_name := 'OWS_E_' || TO_CHAR (SYSDATE, 'YYYYMMDDHH24MISS') || '_' || v_count || '_JOB';

         dbms_scheduler.create_job (job_name => v_job_name, job_class => v_job_class, program_name => v_program_name, start_date => SYSDATE, end_date => NULL, enabled => false, comments => 'Oracle OWS Entity Screening');


         -- Uncomment Server for testing purpose
         --dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'Server', argument_value => 'IRIDROWS-PRI'); -- Server
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'SourceTable', argument_value => cxrefrec.source_table); -- SourceTable
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'SourceId', argument_value => cxrefrec.source_table_id); -- SourceId
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'WcScreeningRequestId', argument_value => crequestrec.wc_screening_request_id); -- WcScreeningRequestId
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'JobId', argument_value => v_job_name); -- JobId
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'EntityName', argument_value => crequestrec.name_screened); -- EntityName
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'UserId', argument_value => crequestrec.created_by); -- UserId
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'RegistrationCountryCode', argument_value => v_corp_residence_country_code); -- UserId
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'City', argument_value => crequestrec.city_name);
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'VesselIndicator', argument_value => crequestrec.vessel_indicator);
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'ImoNumber', argument_value => crequestrec.imo_number);
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'UpdateUserId', argument_value => crequestrec.last_updated_by);
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'ParentId', argument_value => crequestrec.alias_wc_screening_request_id);
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'RelationshipType', argument_value => NULL);
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'CityId', argument_value => crequestrec.wc_city_list_id);


         dbms_scheduler.enable (name => v_job_name);

         dbms_lock.sleep (xwrl_utils.get_max_pause);

      END LOOP;

      END LOOP;

   END process_wc_data_entity;


   PROCEDURE process_ows_error_resubmit (
      p_max_jobs   INTEGER DEFAULT NULL
      , p_id         INTEGER DEFAULT NULL
   ) IS

      CURSOR c1 IS

      SELECT
         id
         , source_table
         , source_id
         , wc_screening_request_id
      FROM
         xwrl_requests
      WHERE
         status = 'ERROR'
         AND id = nvl (p_id, id)
         AND ROWNUM <= v_rownum
      ORDER BY
         id;

      v_count                INTEGER;
      v_error                INTEGER;
      v_edq                  INTEGER;
      v_instance             VARCHAR2 (50);
      v_server               VARCHAR2 (50);
      v_program_name         VARCHAR2 (1000);
      v_job_name             VARCHAR2 (1000);
      v_job_class            VARCHAR2 (1000);
      is_service_available   BOOLEAN;
      v_max_jobs             INTEGER;
      v_ratio                INTEGER;
      isowsavailable         BOOLEAN;

   BEGIN

      v_program_name := 'OWS_RESUBMIT_SCREENING_PRG';
      v_job_class := 'OWS_JOB_CLASS';
      v_server := xwrl_utils.get_wl_server ('LOADBALANCE_SERVER', v_instance);

      v_count := 0;
      v_error := 0;

      v_max_jobs := xwrl_utils.get_max_jobs; -- get maximum jobs for environment
      v_instance := xwrl_utils.get_instance;

      utl_http.set_response_error_check (true);
      utl_http.set_detailed_excp_support (true);




         -- Override max jobs is parameter is passed
      IF p_max_jobs IS NOT NULL THEN
         v_max_jobs := p_max_jobs;
      END IF;

      xwrl_data_processing.v_rownum := v_max_jobs;

      FOR crequestrec IN c1 LOOP

         v_count := v_count + 1;

         v_job_name := 'OWS_R_' || TO_CHAR (SYSDATE, 'YYYYMMDDHH24MISS') || '_' || v_count || '_JOB';

         dbms_scheduler.create_job (job_name => v_job_name, job_class => v_job_class, program_name => v_program_name, start_date => SYSDATE, end_date => NULL, enabled => false, comments => 'Oracle OWS Resubmit Screening');

         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'Server', argument_value => v_server); -- Server
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'SourceTable', argument_value => NULL); -- SourceTable
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'SourceId', argument_value => NULL); -- SourceId
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'WcScreeningRequestId', argument_value => crequestrec.wc_screening_request_id); -- WcScreeningRequestId
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'JobId', argument_value => v_job_name); -- JobId
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'Id', argument_value => crequestrec.id); -- EntityName         


         dbms_scheduler.enable (name => v_job_name);

         dbms_lock.sleep (xwrl_utils.get_max_pause);

      END LOOP;

   END process_ows_error_resubmit;

   PROCEDURE stop_schedule_processing IS

   BEGIN

      /* TSUAZO 11/19/2019 Disable WC Data Processing
      dbms_scheduler.disable (name => 'PROCESS_WC_DATA_INDIVIDUAL');
      dbms_scheduler.disable (name => 'PROCESS_WC_DATA_ENTITY');
      dbms_scheduler.disable (name => 'PROCESS_OWS_ERRORS');
      dbms_scheduler.disable (name => 'PROCESS_WC_XML_PARSER');
      */
      dbms_scheduler.disable (name => 'PROCESS_MASTER_RECORDS');

   END stop_schedule_processing;

   PROCEDURE stop_job_processing IS

      CURSOR c1 IS
      SELECT
         job_name
         , program_name
      FROM
         all_scheduler_jobs
      /* TSUAZO 11/19/2019 Disable WC Data Processing
      WHERE         program_name IN (            'OWS_INDIVIDUAL_SCREENING_PRG'            , 'OWS_ENTITY_SCREENING_PRG'            , 'OWS_RESUBMIT_SCREENING_PRG'         )
      */
      WHERE         program_name =  'OWS_PROCESS_MASTER_PRG'  
      ;

   BEGIN

      FOR crequestrec IN c1 LOOP
         BEGIN
            dbms_scheduler.stop_job (job_name => crequestrec.job_name, force => true);
         EXCEPTION
            WHEN OTHERS THEN
               dbms_scheduler.drop_job (job_name => crequestrec.job_name);
         END;
      END LOOP;

   END stop_job_processing;

   PROCEDURE start_schedule_processing IS

   BEGIN

      /* TSUAZO 11/19/2019 Disable WC Data Processing
      dbms_scheduler.enable (name => 'PROCESS_WC_DATA_INDIVIDUAL');
      dbms_scheduler.enable (name => 'PROCESS_WC_DATA_ENTITY');
      dbms_scheduler.enable (name => 'PROCESS_OWS_ERRORS');
      dbms_scheduler.enable (name => 'PROCESS_WC_XML_PARSER');
      */
      dbms_scheduler.enable (name => 'PROCESS_MASTER_RECORDS');

   END start_schedule_processing;

   PROCEDURE start_schedule_processing (
      p_start_date VARCHAR2
   ) IS

   BEGIN

      /* TSUAZO 11/19/2019 Disable WC Data Processing
      dbms_scheduler.set_attribute (name => 'PROCESS_WC_DATA_INDIVIDUAL', attribute => 'START_DATE', value => to_timestamp (p_start_date, 'YYYY-MM-DD HH24:MI:SS'));
      dbms_scheduler.set_attribute (name => 'PROCESS_WC_DATA_INDIVIDUAL', attribute => 'END_DATE', value => '');
      dbms_scheduler.enable (name => 'PROCESS_WC_DATA_INDIVIDUAL');
      dbms_scheduler.set_attribute (name => 'PROCESS_WC_DATA_ENTITY', attribute => 'START_DATE', value => to_timestamp (p_start_date, 'YYYY-MM-DD HH24:MI:SS'));
      dbms_scheduler.set_attribute (name => 'PROCESS_WC_DATA_ENTITY', attribute => 'END_DATE', value => '');
      dbms_scheduler.enable (name => 'PROCESS_WC_DATA_ENTITY');
      dbms_scheduler.set_attribute (name => 'PROCESS_OWS_ERRORS', attribute => 'START_DATE', value => to_timestamp (p_start_date, 'YYYY-MM-DD HH24:MI:SS'));
      dbms_scheduler.set_attribute (name => 'PROCESS_OWS_ERRORS', attribute => 'END_DATE', value => '');
      dbms_scheduler.enable (name => 'PROCESS_OWS_ERRORS');
      dbms_scheduler.set_attribute (name => 'PROCESS_WC_XML_PARSER', attribute => 'START_DATE', value => to_timestamp (p_start_date, 'YYYY-MM-DD HH24:MI:SS'));
      dbms_scheduler.set_attribute (name => 'PROCESS_WC_XML_PARSER', attribute => 'END_DATE', value => '');
      dbms_scheduler.enable (name => 'PROCESS_WC_XML_PARSER');
      */

      dbms_scheduler.set_attribute (name => 'PROCESS_MASTER_RECORDS', attribute => 'START_DATE', value => to_timestamp (p_start_date, 'YYYY-MM-DD HH24:MI:SS'));
      dbms_scheduler.set_attribute (name => 'PROCESS_MASTER_RECORDS', attribute => 'END_DATE', value => '');
      dbms_scheduler.enable (name => 'PROCESS_MASTER_RECORDS');      

   END start_schedule_processing;

   PROCEDURE stop_schedule_processing (
      p_end_date VARCHAR2
   ) IS

   BEGIN

      /* TSUAZO 11/19/2019 Disable WC Data Processing 
      dbms_scheduler.set_attribute (name => 'PROCESS_WC_DATA_INDIVIDUAL', attribute => 'END_DATE', value => to_timestamp (p_end_date, 'YYYY-MM-DD HH24:MI:SS'));
      dbms_scheduler.enable (name => 'PROCESS_WC_DATA_INDIVIDUAL');
      dbms_scheduler.set_attribute (name => 'PROCESS_WC_DATA_ENTITY', attribute => 'END_DATE', value => to_timestamp (p_end_date, 'YYYY-MM-DD HH24:MI:SS'));
      dbms_scheduler.enable (name => 'PROCESS_WC_DATA_ENTITY');
      dbms_scheduler.set_attribute (name => 'PROCESS_OWS_ERRORS', attribute => 'END_DATE', value => to_timestamp (p_end_date, 'YYYY-MM-DD HH24:MI:SS'));
      dbms_scheduler.enable (name => 'PROCESS_OWS_ERRORS');
      dbms_scheduler.set_attribute (name => 'PROCESS_WC_XML_PARSER', attribute => 'END_DATE', value => to_timestamp (p_end_date, 'YYYY-MM-DD HH24:MI:SS'));
      dbms_scheduler.enable (name => 'PROCESS_WC_XML_PARSER');
      */  

      dbms_scheduler.set_attribute (name => 'PROCESS_MASTER_RECORDS', attribute => 'END_DATE', value => to_timestamp (p_end_date, 'YYYY-MM-DD HH24:MI:SS'));
      dbms_scheduler.enable (name => 'PROCESS_MASTER_RECORDS');

   END stop_schedule_processing;

   PROCEDURE create_job_processing (
      p_start_date VARCHAR2
   ) IS

      v_job_name    VARCHAR2 (1000);
      v_frequency   INTEGER;

   BEGIN

/*
      v_job_name := 'PROCESS_WC_DATA_INDIVIDUAL';
      v_frequency := xwrl_utils.get_frequency;

      dbms_scheduler.create_job (job_name => v_job_name, job_type => 'STORED_PROCEDURE', job_class => 'OWS_JOB_CLASS', job_action => 'XWRL_DATA_PROCESSING.PROCESS_WC_DATA_INDIVIDUAL', start_date => to_timestamp (p_start_date, 'YYYY-MM-DD HH24:MI:SS'), repeat_interval => 'FREQ=MINUTELY; INTERVAL=' || v_frequency, end_date => NULL, enabled => true, comments => 'Process WC Individual data');

      v_job_name := 'PROCESS_WC_DATA_ENTITY';
      v_frequency := xwrl_utils.get_frequency;

      dbms_scheduler.create_job (job_name => v_job_name, job_type => 'STORED_PROCEDURE', job_class => 'OWS_JOB_CLASS', job_action => 'XWRL_DATA_PROCESSING.PROCESS_WC_DATA_ENTITY', start_date => to_timestamp (p_start_date, 'YYYY-MM-DD HH24:MI:SS'), repeat_interval => 'FREQ=MINUTELY; INTERVAL=' || TO_CHAR (v_frequency), end_date => NULL, enabled => true, comments => 'Process WC Entity data');


      v_job_name := 'PROCESS_OWS_ERRORS';
      v_frequency := xwrl_utils.get_frequency;

      dbms_scheduler.create_job (job_name => v_job_name, job_type => 'STORED_PROCEDURE', job_class => 'OWS_JOB_CLASS', job_action => 'XWRL_DATA_PROCESSING.PROCESS_OWS_ERROR_RESUBMIT', start_date => to_timestamp (p_start_date, 'YYYY-MM-DD HH24:MI:SS'), repeat_interval => 'FREQ=MINUTELY; INTERVAL=' || v_frequency, end_date => NULL, enabled => true, comments => 'Process OWS Errors for Resubmit');

      v_job_name := 'PROCESS_WC_XML_PARSER';
      v_frequency := xwrl_utils.get_frequency;

      dbms_scheduler.create_job (job_name => v_job_name, job_type => 'STORED_PROCEDURE', job_class => 'OWS_JOB_CLASS', job_action => 'XWRL_DATA_PROCESSING.PROCESS_WC_XML_PARSER', start_date => to_timestamp (p_start_date, 'YYYY-MM-DD HH24:MI:SS'), repeat_interval => 'FREQ=MINUTELY; INTERVAL=' || v_frequency, end_date => NULL, enabled => true, comments => 'Process WC XML Parser');

      */


     v_job_name := 'PROCESS_MASTER_RECORDS';
      v_frequency := xwrl_utils.get_frequency;

      dbms_scheduler.create_job (job_name => v_job_name, job_type => 'STORED_PROCEDURE', job_class => 'OWS_JOB_CLASS', job_action => 'XWRL_DATA_PROCESSING.PROCESS_MASTER_RECORDS', start_date => to_timestamp (p_start_date, 'YYYY-MM-DD HH24:MI:SS'), repeat_interval => 'FREQ=MINUTELY; INTERVAL=' || v_frequency, end_date => NULL, enabled => true, comments => 'Process Master Records');


   END create_job_processing;


   PROCEDURE process_wc_xml_parser IS

      CURSOR c1 IS
      SELECT
         c.wc_screening_request_id
         , c.wc_matches_id
         , c.wc_content_id
         , xc.wc_content_id wc_id
      FROM
         wc_content         c
         , xwrl_requests      r
         , xwrl_wc_contents   xc
      WHERE
         c.wc_screening_request_id = r.wc_screening_request_id
         AND c.wc_content_id = xc.wc_content_id (+)
--and c.WC_SCREENING_REQUEST_ID = 848005
         AND xc.wc_content_id IS NULL
      ORDER BY
         c.wc_screening_request_id DESC;

      trec     xwrl_wc_contents%rowtype;

      vtab     world_check_iface.display_details_tab;
      vrec     world_check_iface.display_details_rec;
      vempty   world_check_iface.display_details_tab;

      idx      PLS_INTEGER;

   BEGIN

      FOR crequestrec IN c1 LOOP

         vtab := vempty;
         world_check_iface.display_details (crequestrec.wc_content_id, vtab);

         FOR idx IN 1..vtab.count LOOP

            vrec := vtab (idx);

            trec.wc_screening_request_id := crequestrec.wc_screening_request_id;
            trec.wc_matches_id := crequestrec.wc_matches_id;
            trec.wc_content_id := crequestrec.wc_content_id;
            trec.heading := vrec.heading;
            trec.data_type := vrec.data_type;
            trec.display_data := vrec.display_data;

            INSERT /*+ append */ INTO xwrl_wc_contents VALUES trec;

            COMMIT;

         END LOOP;

      END LOOP;

   END process_wc_xml_parser;

   PROCEDURE process_master_records (p_max_jobs INTEGER DEFAULT NULL)  is

   cursor c1 (p_row_num in integer) is 
   with xr as (select x.source_table, x.source_id, x.source_table||x.source_id source_key
   from xwrl_requests x)
   select xref.source_table, xref.source_table_column, xref.source_table_id, xref.source_table|| xref.source_table_id source_key
   from wc_screening_request req
   ,WORLDCHECK_EXTERNAL_XREF xref
   , xr
   WHERE req.wc_screening_request_id = xref.wc_screening_request_id
   and xref.source_table|| xref.source_table_id = xr.source_key (+)
   --and req.status in ('Legal Review','Sr. Legal Review')
   --and req.requires_legal_approval is NULL
   and req.status in ('Pending','Provisional')
   and req.requires_legal_approval = 'N'
   and xr.source_key is null
   and xref.source_table_id is not null
   GROUP BY xref.source_table, xref.source_table_column, xref.source_table_id, xref.source_table|| xref.source_table_id 
   order by 1; 


      v_count                       INTEGER;
      v_error                       INTEGER;
      v_edq                         INTEGER;
      v_server                      VARCHAR2 (50);
      v_program_name                VARCHAR2 (1000);
      v_job_name                    VARCHAR2 (1000);
      v_job_class                   VARCHAR2 (1000);

   v_source_table varchar2(4000);
   v_source_table_column varchar2(4000);
   v_source_id varchar2(4000);

   x_batch_id integer;
   x_return_status varchar2(4000);
   x_return_msg varchar2(4000);

   v_max_jobs integer;

   begin

      v_program_name := 'OWS_PROCESS_MASTER_PRG';
      v_job_class := 'OWS_JOB_CLASS';

   if p_max_jobs is null  then
         v_max_jobs := xwrl_utils.get_max_jobs; -- get maximum jobs for environment
   else
         v_max_jobs := p_max_jobs;
   end if;
   
   v_count := 0;

   for c1rec in c1 (v_max_jobs) loop
   
         if v_count > v_max_jobs then
             exit;
         end if;

         v_job_name := 'OWS_B_' || TO_CHAR (SYSDATE, 'YYYYMMDDHH24MISS') || '_' || v_count || '_JOB';

         dbms_scheduler.create_job (job_name => v_job_name, job_class => v_job_class, program_name => v_program_name, start_date => SYSDATE, end_date => NULL, enabled => false, comments => 'Oracle OWS Batch Vestting');

         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'p_source_table', argument_value => c1rec.source_table); -- source_table
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'p_source_table_column', argument_value => c1rec.source_table_column); -- source_table_column
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'p_source_id', argument_value => c1rec.source_table_id); -- source_id
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'x_batch_id', argument_value =>x_batch_id); -- x_batch_id
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'x_return_status', argument_value => x_return_status); -- x_return_status
         dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'x_return_msg', argument_value => x_return_msg); -- x_return_msg         
         --dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'p_wc_screening_request_id', argument_value => c1rec.wc_screening_request_id); -- source_id

         dbms_scheduler.enable (name => v_job_name);

         dbms_lock.sleep (xwrl_utils.get_max_pause);                     

         v_count := v_count + 1;

   end loop;                     

   end process_master_records;


   PROCEDURE ebs_master_records (p_max_jobs integer)  is

   cursor c1 (p_row_num in integer) is 
   select  xmst.id
   , xmst.state
   , xmst.source_table
   , xmst.source_table_column
   , xmst.source_id   
   , xmst.wc_screening_request_id
   from (select mst.id
   , mst.state
   , mst.source_table 
   , mst.source_table_column 
   , mst.source_id 
   , mst.wc_screening_request_id
   , mst.source_table||mst.source_id source_key
   from xwrl_party_master mst ) xmst
   ,(select req.id,  req.source_table, req.source_id, req.wc_screening_request_id, req.source_table||req.source_id source_key
   from xwrl_requests req) xreq
   where xmst.source_key = xreq.source_key (+) 
   and xmst.state not like 'Delete%'
   and xreq.source_key is null
   --and rownum <= p_row_num
   order by xmst.wc_screening_request_id desc
   ;

   v_source_table varchar2(4000);
   v_source_table_column varchar2(4000);
   v_source_id varchar2(4000);

   x_batch_id integer;
   x_return_status varchar2(4000);
   x_return_msg varchar2(4000);

   v_max_jobs integer;

   v_result varchar2(20);

   begin

   if p_max_jobs is null  then
         v_max_jobs := xwrl_utils.get_max_jobs; -- get maximum jobs for environment
   else
         v_max_jobs := p_max_jobs;
   end if;

   for c1rec in c1 (v_max_jobs) loop

          select value_string
          into v_result
   from xwrl_parameters
   where id = 'XWRL_PARTY_MASTER'
   and key = 'PROCESS'
   ;

   if v_result = 'FALSE' THEN
     EXIT;

   END IF;

      rmi_ows_common_util.create_batch_vetting (
                         p_source_table             => c1rec.source_table,
                          p_source_table_column      => c1rec.source_table_column,
                          p_source_id                => c1rec.source_id,
                          x_batch_id                 => x_batch_id,
                          x_return_status            => x_return_status,
                          x_return_msg               => x_return_msg
                          );



   end loop;                     

   end ebs_master_records;


END xwrl_data_processing;