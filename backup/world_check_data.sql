CREATE OR REPLACE PACKAGE xwrl_data_processing AS

   v_rownum INTEGER := 10;

   PROCEDURE process_wc_data_individual (
      p_max_jobs INTEGER DEFAULT NULL
   );

   PROCEDURE process_wc_data_entity (
      p_max_jobs INTEGER DEFAULT NULL
   );

   PROCEDURE process_ows_error_resubmit (
      p_max_jobs   INTEGER DEFAULT NULL
      , p_id         INTEGER DEFAULT NULL
   );

   PROCEDURE stop_schedule_processing;

   PROCEDURE stop_job_processing;

   PROCEDURE start_schedule_processing;

END xwrl_data_processing;
/

CREATE OR REPLACE PACKAGE BODY xwrl_data_processing AS

   PROCEDURE process_wc_data_individual (
      p_max_jobs INTEGER DEFAULT NULL
   ) IS

      CURSOR c1 IS
   -- Note: This is for testing purpose and will need to be modified for Production
      SELECT
         wsr.wc_screening_request_id
         , wsr.name_screened
         , TO_CHAR (wsr.date_of_birth, 'YYYYMMDDHH24MI') date_of_birth
      FROM
         wc_screening_request   wsr
         , xwrl_requests          xr
      WHERE
         wsr.wc_screening_request_id = xr.wc_screening_request_id (+)
         AND wsr.entity_type = 'INDIVIDUAL'
      --AND trunc (wsr.creation_date) >= trunc (SYSDATE) - 30
         AND xr.wc_screening_request_id IS NULL
         AND ROWNUM <= v_rownum
      ORDER BY
         1 DESC;

      v_count                INTEGER;
      v_error                INTEGER;
      v_server               VARCHAR2 (50);
      v_program_name         VARCHAR2 (1000);
      v_job_name             VARCHAR2 (1000);
      v_instance             VARCHAR2 (50);
      is_service_available   BOOLEAN;
      v_max_jobs             INTEGER;
      v_ratio                INTEGER;
      isowsavailable         BOOLEAN;

   BEGIN

      v_program_name := 'OWS_INDIVIDUAL_SCREENING_PRG';

      v_count := 0;
      v_error := 0;
      isowsavailable := true;

      v_max_jobs := xwrl_utils.get_max_jobs; -- get maximum jobs for environment
      v_ratio := xwrl_utils.get_ratio; -- get load balancer ratio     
      v_instance := xwrl_utils.get_instance;
      v_server := xwrl_utils.get_wl_server ('PRIMARY_SERVER', v_instance);

      utl_http.set_response_error_check (true);
      utl_http.set_detailed_excp_support (true);

      -- Adjust Max Jobs if Primary is not available
      -- Note: Load Balancer is not currently able to monitor Real-Time Job Screening within the Application
      --             If the Real-Time Job Screening is not running, jobs will start to fail and will eventially cause the Application to fail.
      is_service_available := xwrl_utils.test_ows_web_service (p_debug => false, p_server => v_server, p_service_name => 'EDQ');
      IF is_service_available = false THEN
         v_server := xwrl_utils.get_wl_server ('SECONDARY_SERVER', v_instance);
         is_service_available := xwrl_utils.test_ows_web_service (p_debug => false, p_server => v_server, p_service_name => 'EDQ');
         IF is_service_available = false THEN
            isowsavailable := false;
         ELSE
            v_max_jobs := v_max_jobs / v_ratio;
         END IF;
      END IF;

      IF isowsavailable THEN

         -- Override max jobs is parameter is passed
         IF p_max_jobs IS NOT NULL THEN
            v_max_jobs := p_max_jobs;
         END IF;
         
         xwrl_data_processing.v_rownum := v_max_jobs;

         FOR c1rec IN c1 LOOP

            v_count := v_count + 1;

            c1rec.name_screened := replace (c1rec.name_screened, '&', chr (38) || 'amp;'); -- replace ampersand for XML processing
            c1rec.name_screened := replace (c1rec.name_screened, '"');  -- replace double quotes for XML processing

            v_job_name := 'OWS_I_' || TO_CHAR (SYSDATE, 'YYYYMMDDSS') || '_' || v_count || '_JOB';

            dbms_scheduler.create_job (job_name => v_job_name, program_name => v_program_name, start_date => SYSDATE, end_date => NULL, enabled => false, comments => 'Oracle OWS Individual Screening');

         -- Uncomment Server for testing purpose
         --dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'Server', argument_value => 'IRIDROWS-PRI'); -- Server
            dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'SourceTable', argument_value => NULL); -- SourceTable
            dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'SourceId', argument_value => NULL); -- SourceId
            dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'WcScreeningRequestId', argument_value => c1rec.wc_screening_request_id); -- WcScreeningRequestId
            dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'JobId', argument_value => v_job_name); -- JobId
            dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'FullName', argument_value => c1rec.name_screened); -- FullName
            dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'DateOfBirth', argument_value => c1rec.date_of_birth); -- DateOfBirth

            dbms_scheduler.enable (name => v_job_name);

         END LOOP;
      END IF;

   END process_wc_data_individual;

   PROCEDURE process_wc_data_entity (
      p_max_jobs INTEGER DEFAULT NULL
   ) IS

      CURSOR c1 IS
   -- Note: This is for testing purpose and will need to be modified for Production
      SELECT
         wsr.wc_screening_request_id
         , wsr.name_screened
      FROM
         wc_screening_request   wsr
         , xwrl_requests          xr
      WHERE
         wsr.wc_screening_request_id = xr.wc_screening_request_id (+)
         AND wsr.entity_type = 'ORGANISATION'
      --AND trunc (wsr.creation_date) >= trunc (SYSDATE) - 30
         AND xr.wc_screening_request_id IS NULL
         AND ROWNUM <= v_rownum
      ORDER BY
         1 DESC;

      v_count                INTEGER;
      v_error                INTEGER;
      v_instance             VARCHAR2 (50);
      v_server               VARCHAR2 (50);
      v_program_name         VARCHAR2 (1000);
      v_job_name             VARCHAR2 (1000);
      is_service_available   BOOLEAN;
      v_max_jobs             INTEGER;
      v_ratio                INTEGER;
      isowsavailable         BOOLEAN;


   BEGIN

      v_program_name := 'OWS_ENTITY_SCREENING_PRG';

      v_count := 0;
      v_error := 0;
      isowsavailable := true;

      v_max_jobs := xwrl_utils.get_max_jobs; -- get maximum jobs for environment
      v_ratio := xwrl_utils.get_ratio; -- get load balancer ratio     
      v_instance := xwrl_utils.get_instance;
      v_server := xwrl_utils.get_wl_server ('PRIMARY_SERVER', v_instance);

      utl_http.set_response_error_check (true);
      utl_http.set_detailed_excp_support (true);
            
      -- Adjust Max Jobs if Primary is not available
      is_service_available := xwrl_utils.test_ows_web_service (p_debug => false, p_server => v_server, p_service_name => 'EDQ');
      IF is_service_available = false THEN
         v_server := xwrl_utils.get_wl_server ('SECONDARY_SERVER', v_instance);
         is_service_available := xwrl_utils.test_ows_web_service (p_debug => false, p_server => v_server, p_service_name => 'EDQ');
         IF is_service_available = false THEN
            isowsavailable := false;
         ELSE
            v_max_jobs := v_max_jobs / v_ratio;
         END IF;
      END IF;

      IF isowsavailable THEN

         -- Override max jobs is parameter is passed
         IF p_max_jobs IS NOT NULL THEN
            v_max_jobs := p_max_jobs;
         END IF;
         
         xwrl_data_processing.v_rownum := v_max_jobs;

         FOR c1rec IN c1 LOOP

            v_count := v_count + 1;

            c1rec.name_screened := replace (c1rec.name_screened, '&', chr (38) || 'amp;'); -- replace ampersand for XML processing
            c1rec.name_screened := replace (c1rec.name_screened, '"');  -- replace double quotes for XML processing

            v_job_name := 'OWS_E_' || TO_CHAR (SYSDATE, 'YYYYMMDDSS') || '_' || v_count || '_JOB';

            dbms_scheduler.create_job (job_name => v_job_name, program_name => v_program_name, start_date => SYSDATE, end_date => NULL, enabled => false, comments => 'Oracle OWS Entity Screening');

         -- Uncomment Server for testing purpose
         --dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'Server', argument_value => 'IRIDROWS-PRI'); -- Server
            dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'SourceTable', argument_value => NULL); -- SourceTable
            dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'SourceId', argument_value => NULL); -- SourceId
            dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'WcScreeningRequestId', argument_value => c1rec.wc_screening_request_id); -- WcScreeningRequestId
            dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'JobId', argument_value => v_job_name); -- JobId
            dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'EntityName', argument_value => c1rec.name_screened); -- EntityName

            dbms_scheduler.enable (name => v_job_name);

         END LOOP;

      END IF;

   END process_wc_data_entity;


   PROCEDURE process_ows_error_resubmit (
      p_max_jobs   INTEGER DEFAULT NULL
      , p_id         INTEGER DEFAULT NULL
   ) IS

      CURSOR c1 IS
   -- Note: This is for testing purpose and will need to be modified for Production
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
      v_instance             VARCHAR2 (50);
      v_server               VARCHAR2 (50);
      v_program_name         VARCHAR2 (1000);
      v_job_name             VARCHAR2 (1000);
      is_service_available   BOOLEAN;
      v_max_jobs             INTEGER;
      v_ratio                INTEGER;
      isowsavailable         BOOLEAN;

   BEGIN

      v_program_name := 'OWS_RESUBMIT_SCREENING_PRG';

      v_count := 0;
      v_error := 0;
      isowsavailable := true;

      v_max_jobs := xwrl_utils.get_max_jobs; -- get maximum jobs for environment
      v_ratio := xwrl_utils.get_ratio; -- get load balancer ratio     
      v_instance := xwrl_utils.get_instance;
      v_server := xwrl_utils.get_wl_server ('PRIMARY_SERVER', v_instance);

      utl_http.set_response_error_check (true);
      utl_http.set_detailed_excp_support (true);

      -- Adjust Max Jobs if Primary is not available
      is_service_available := xwrl_utils.test_ows_web_service (p_debug => false, p_server => v_server, p_service_name => 'EDQ');
      IF is_service_available = false THEN
         v_server := xwrl_utils.get_wl_server ('SECONDARY_SERVER', v_instance);
         is_service_available := xwrl_utils.test_ows_web_service (p_debug => false, p_server => v_server, p_service_name => 'EDQ');
         IF is_service_available = false THEN
            isowsavailable := false;
         ELSE
            v_max_jobs := v_max_jobs / v_ratio;
         END IF;
      END IF;

      IF isowsavailable THEN
     
         -- Override max jobs is parameter is passed
         IF p_max_jobs IS NOT NULL THEN
            v_max_jobs := p_max_jobs;
         END IF;
         
         xwrl_data_processing.v_rownum := v_max_jobs;
         
         FOR c1rec IN c1 LOOP

            v_count := v_count + 1;

            v_job_name := 'OWS_R_' || TO_CHAR (SYSDATE, 'YYYYMMDDSS') || '_' || v_count || '_JOB';

            dbms_scheduler.create_job (job_name => v_job_name, program_name => v_program_name, start_date => SYSDATE, end_date => NULL, enabled => false, comments => 'Oracle OWS Resubmit Screening');

         -- Uncomment Server for testing purpose
         --dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'Server', argument_value => 'IRIDROWS-PRI'); -- Server
            dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'SourceTable', argument_value => NULL); -- SourceTable
            dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'SourceId', argument_value => NULL); -- SourceId
            dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'WcScreeningRequestId', argument_value => c1rec.wc_screening_request_id); -- WcScreeningRequestId
            dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'JobId', argument_value => v_job_name); -- JobId
            dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'Id', argument_value => c1rec.id); -- EntityName

            dbms_scheduler.enable (name => v_job_name);

         END LOOP;
      END IF;

   END process_ows_error_resubmit;

   PROCEDURE stop_schedule_processing IS

   BEGIN

      dbms_scheduler.disable (name => 'PROCESS_WC_DATA_INDIVIDUAL');
      dbms_scheduler.disable (name => 'PROCESS_WC_DATA_ENTITY');
      dbms_scheduler.disable (name => 'PROCESS_OWS_ERRORS');

   END stop_schedule_processing;

   PROCEDURE stop_job_processing IS

      CURSOR c1 IS
      SELECT
         job_name
         , program_name
      FROM
         all_scheduler_jobs
      WHERE
         program_name IN (
            'OWS_INDIVIDUAL_SCREENING_PRG'
            , 'OWS_ENTITY_SCREENING_PRG'
            , 'OWS_RESUBMIT_SCREENING_PRG'
         );

   BEGIN

      FOR c1rec IN c1 LOOP
         BEGIN
            dbms_scheduler.stop_job (job_name => c1rec.job_name, force => true);
         EXCEPTION
            WHEN OTHERS THEN
               dbms_scheduler.drop_job (job_name => c1rec.job_name);
         END;
      END LOOP;

   END stop_job_processing;

   PROCEDURE start_schedule_processing IS

   BEGIN

      dbms_scheduler.enable (name => 'PROCESS_WC_DATA_INDIVIDUAL');
      dbms_scheduler.enable (name => 'PROCESS_WC_DATA_ENTITY');
      dbms_scheduler.enable (name => 'PROCESS_OWS_ERRORS');

   END start_schedule_processing;


END xwrl_data_processing;
/