declare

x_id INTEGER;
v_user_id number;
v_session_id number;
v_source_table varchar2(4000) := null;
v_source_table_column varchar2(4000) := null;
v_source_id number := null;
v_entityname varchar2(1000) := null;
v_imo_number integer := null;
v_vessel_indicator varchar2(100) := null;
v_batch_id integer := null;

begin

v_user_id  := 1156;  -- EBS user id from fnd_user table
SELECT userenv('sessionid') INTO  v_session_id FROM DUAL; -- EBS session id

v_source_table := 'NRMI_CERTIFICATES';
v_source_table_column := 'NRMI_CERTIFICATES_ID';
v_source_id :=  11549;
v_entityname :=  'SITEAM EXPLORER';
v_imo_number := 9326902;
v_vessel_indicator := 'Y';

xwrl_utils.ows_entity_screening (
p_user_id => v_user_id
,p_session_id => v_session_id
,p_source_table => v_source_table
,p_source_id => v_source_id
,p_entityname => v_entityname
,p_imo_number => v_imo_number
,p_vessel_indicator => v_vessel_indicator
,p_batch_id => v_batch_id
,x_id => x_id);

/* Note: The URL is hardcoded.  However, this can be derived from the xwrl_parameters table */
dbms_output.put_line('http://127.0.0.1:7101/TradeCompliance/faces/Request?requestId='||x_id);
dbms_output.put_line('http://iriadf-dev.register-iri.com/TradeCompliance/faces/Request?requestId='||x_id);


end;
/
