declare

x_id INTEGER;
v_user_id number;
v_session_id number;

begin

v_user_id  := 1156;  -- EBS user id from fnd_user table
SELECT userenv('sessionid') INTO  v_session_id FROM DUAL; -- EBS session id

xwrl_utils.ows_individual_screening (
p_user_id => v_user_id
,p_session_id => v_session_id
,p_source_table => 'SICD_SEAFARERS'
,p_source_id => '625889'
,p_fullname => 'NAING MYINT OO'
,p_dateofbirth => '19680420'  --  Date Format is yyymmdd same as provided by OCG
--,p_dateofbirth =>  ' 1934-09-17T00:00:00Z' -- Date format YYYY-MM-DDTHH:MM:SSZ  same as web service tester
--,p_dateofbirth =>  '1934-09-17T00:00:00.000-04:00'  -- Copied from the response data
,p_customstring1 => 'SICD_SEAFARERS'
,p_customstring2 =>  '625889'
,p_customstring3 => 'Seafarers'
,p_customstring4 => 'Reston'
,p_customstring5 => 'UA'
,x_id => x_id);

/* Note: The URL is hardcoded.  However, this can be derived from the xwrl_parameters table */
dbms_output.put_line('http://127.0.0.1:7101/TradeCompliance/faces/Request?requestId='||x_id);
dbms_output.put_line('http://iriadf-dev.register-iri.com/TradeCompliance/faces/Request?requestId='||x_id);

end;
/
