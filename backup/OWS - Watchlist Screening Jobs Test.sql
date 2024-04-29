/* Test Individual */
--Note: Consider changing xwrl_data_processing.v_rownum parameter

begin
    xwrl_data_processing.v_rownum := 101;
    xwrl_data_processing.process_wc_data_individual;
end;
/

/* Test Entity */
--Note: Consider changing xwrl_data_processing.v_rownum parameter
begin
   xwrl_data_processing.v_rownum := 101;
   xwrl_data_processing.process_wc_data_entity;
end;  
/

/* Test Resubmit */
--Note: Consider changing xwrl_data_processing.v_rownum parameter
begin
      xwrl_data_processing.v_rownum := 101;
      xwrl_data_processing.process_ows_error_resubmit;
end;      
/
