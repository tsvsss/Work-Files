declare

x_id INTEGER;
v_user_id number;
v_session_id number;
v_source_table varchar2(4000) := null;
v_source_table_column varchar2(4000) := null;
v_source_id number := null;
v_entityname varchar2(1000) := null;
-- Country Codes are  ISO Alpha-2
v_addresscountrycode varchar2(10) := null;
v_residencycountrycode varchar2(10) := null;
v_registrationcountrycode varchar2(10) := null;
v_OperatingCountryCodes varchar2(10) := null;
v_batch_id integer := null;

begin

v_user_id  := 1156;  -- EBS user id from fnd_user table
v_batch_id := 100;  -- Note: Change this value

SELECT userenv('sessionid') INTO  v_session_id FROM DUAL; -- EBS session id


v_entityname := 'BLACKLIGHT S A';
/*
v_source_table := 'CORP_MAIN';
v_source_table_column := 'CORP_ID';
v_source_id :=  1062798;
v_addresscountrycode := 'IE';
v_registrationcountrycode := 'US';
v_OperatingCountryCodes := 'IR';
v_residencycountrycode := 'FI'; 
*/

xwrl_utils.ows_entity_screening (
--p_show_request => 'TRUE'
p_user_id => v_user_id
,p_session_id => v_session_id
/*
,p_source_table => v_source_table
,p_source_id => v_source_id
,p_addresscountrycode => v_addresscountrycode
,p_residencycountrycode => v_residencycountrycode
,p_registrationcountrycode => v_registrationcountrycode
,p_OperatingCountryCodes => v_OperatingCountryCodes
*/
,p_entityname => v_entityname
,p_batch_id => v_batch_id
,x_id => x_id);

/* Note: The URL is hardcoded.  However, this can be derived from the xwrl_parameters table */
dbms_output.put_line('http://127.0.0.1:7101/TradeCompliance/faces/Request?requestId='||x_id);
dbms_output.put_line('http://iriadf-dev.register-iri.com/TradeCompliance/faces/Request?requestId='||x_id);


end;
/