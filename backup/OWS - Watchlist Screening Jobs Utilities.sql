/* Scheduling Utilities */

BEGIN
      xwrl_data_processing.stop_schedule_processing;
END;
/

BEGIN
      xwrl_data_processing.stop_job_processing;
END;
/

BEGIN
      xwrl_data_processing.start_schedule_processing;
END;
/