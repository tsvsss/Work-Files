/* Note: Using v_frequency is not accepted on IRIDR */

/* Process WC Individuals */
DECLARE

   v_job_name       VARCHAR2 (1000);
   v_frequency integer;

BEGIN

      v_job_name := 'PROCESS_WC_DATA_INDIVIDUAL';
      v_frequency := xwrl_utils.get_frequency;

      dbms_scheduler.drop_job(job_name => v_job_name);

      dbms_scheduler.create_job (job_name => v_job_name
      , job_type => 'STORED_PROCEDURE'
      ,job_action => 'XWRL_DATA_PROCESSING.PROCESS_WC_DATA_INDIVIDUAL'
      , start_date => timestamp '2019-03-08 08:00:00'
      ,repeat_interval => 'FREQ=MINUTELY; INTERVAL=5'
      , end_date => NULL
      ,enabled => TRUE
      , comments => 'Process WC Individual data');

END;
/

/* Process WC Entities */
DECLARE

   v_job_name       VARCHAR2 (1000);
v_frequency integer;

BEGIN

      v_job_name := 'PROCESS_WC_DATA_ENTITY';
      v_frequency := xwrl_utils.get_frequency;
      
      dbms_scheduler.drop_job(job_name => v_job_name);

      dbms_scheduler.create_job (job_name => v_job_name
      , job_type => 'STORED_PROCEDURE'
      ,job_action => 'XWRL_DATA_PROCESSING.PROCESS_WC_DATA_ENTITY'
      , start_date => timestamp '2019-03-08 08:00:00'
      ,repeat_interval => 'FREQ=MINUTELY; INTERVAL=5'
      , end_date => NULL
      ,enabled => TRUE
      , comments => 'Process WC Entity data');

END;
/

/* Process OWS Errors */
DECLARE

   v_job_name       VARCHAR2 (1000);
   v_frequency integer;

BEGIN

      v_job_name := 'PROCESS_OWS_ERRORS';
      v_frequency := xwrl_utils.get_frequency;
      
     dbms_scheduler.drop_job(job_name => v_job_name);

      dbms_scheduler.create_job (job_name => v_job_name
      , job_type => 'STORED_PROCEDURE'
      ,job_action => 'XWRL_DATA_PROCESSING.PROCESS_OWS_ERROR_RESUBMIT'
      , start_date => timestamp '2019-03-08 08:00:00'
      ,repeat_interval => 'FREQ=MINUTELY; INTERVAL=5'
      , end_date => NULL
      ,enabled => TRUE
      , comments => 'Process OWS Errors for Resubmit');

END;
/