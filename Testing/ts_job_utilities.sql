/* Scheduling Utilities */

/******************* Job Scheduling *******************/

BEGIN
      xwrl_data_processing.start_schedule_processing;
END;
/

BEGIN
      xwrl_data_processing.stop_schedule_processing;
END;
/

/******************* Job Scheduling with Date  *******************/

BEGIN
      xwrl_data_processing.start_schedule_processing('2019-11-24 09:15:00');
END;
/

BEGIN
      xwrl_data_processing.stop_schedule_processing('2019-11-24 11:00:00');
END;
/

/******************* Job Processing *******************/

BEGIN
     xwrl_data_processing.create_job_processing('2019-11-22 15:00:00');
END;
/

BEGIN
      xwrl_data_processing.stop_job_processing;
END;
/