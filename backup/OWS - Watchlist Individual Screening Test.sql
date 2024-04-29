DECLARE

   CURSOR c1 IS
   -- Note: This is for testing purpose and will need to be modified for Production
   SELECT
      wsr.wc_screening_request_id
      , wsr.name_screened
      , TO_CHAR (wsr.date_of_birth, 'YYYYMMDDHH24MI') date_of_birth
   FROM
      wc_screening_request wsr,
      xwrl_requests xr
   WHERE wsr.wc_screening_request_id = xr.wc_screening_request_id (+)
      AND wsr.entity_type = 'INDIVIDUAL'
      --AND trunc (wsr.creation_date) >= trunc (SYSDATE) - 30
      AND xr.wc_screening_request_id is null
      AND ROWNUM < 101
      ORDER BY 1 DESC;

   v_count          INTEGER;
   v_error          INTEGER;
   v_server         VARCHAR2 (50);
   v_program_name   VARCHAR2 (1000);
   v_job_name       VARCHAR2 (1000);
   v_instance       VARCHAR2 (50);

BEGIN

   v_program_name := 'OWS_INDIVIDUAL_SCREENING_PRG';

   v_count := 0;
   v_error := 0;

   utl_http.set_response_error_check (true);
   utl_http.set_detailed_excp_support (true);

   FOR c1rec IN c1 LOOP

      v_count := v_count + 1;

      v_job_name := 'OWS_I_' || TO_CHAR (SYSDATE, 'YYYYMMDDSS') || '_' || v_count || '_JOB';

      dbms_scheduler.create_job (job_name => v_job_name, program_name => v_program_name, start_date => SYSDATE, end_date => NULL, enabled => false, comments => 'Oracle OWS Individual Screening');

      --dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'Server', argument_value => 'POC'); -- Server
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'SourceTable', argument_value => NULL); -- SourceTable
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'SourceId', argument_value => NULL); -- SourceId
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'WcScreeningRequestId', argument_value => c1rec.wc_screening_request_id); -- WcScreeningRequestId
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'FullName', argument_value => c1rec.name_screened); -- FullName
      dbms_scheduler.set_job_argument_value (job_name => v_job_name, argument_name => 'DateOfBirth', argument_value => c1rec.date_of_birth); -- DateOfBirth

      dbms_scheduler.enable (name => v_job_name);

   END LOOP;

END;
/

