/* Test Individual */
begin
    xwrl_data_processing.process_wc_data_individual(10); -- set number of jobs
    --xwrl_data_processing.process_wc_data_individual;
end;
/

/* Test Entity */
begin
   xwrl_data_processing.process_wc_data_entity(10); -- set number of jobs
   --xwrl_data_processing.process_wc_data_entity;
end;  
/

/* Test Resubmit */
begin
      xwrl_data_processing.process_ows_error_resubmit(5); -- set number of jobs
      --xwrl_data_processing.process_ows_error_resubmit(1,1009); -- set number of jobs, set request id
      --xwrl_data_processing.process_ows_error_resubmit;
end;      
/
