/* Test Individual */
begin
    xwrl_data_processing.process_wc_data_individual(10); -- set number of jobs
end;
/

/* Test Entity */
begin
   xwrl_data_processing.process_wc_data_entity(10); -- set number of jobs
end;  
/

/* Test Resubmit */
begin
      xwrl_data_processing.process_ows_error_resubmit(20); -- set number of jobs
      --xwrl_data_processing.process_ows_error_resubmit(1,205712); -- set number of jobs, set request id
end;      
/


begin
xwrl_data_processing.process_master_records(400);
end;
/

begin
xwrl_data_processing.ebs_master_records(1);
end;
/