declare

x_id INTEGER;
v_user_id number;
v_session_id number;
v_master_id number;
v_source_table varchar2(4000) := null;
v_source_table_column varchar2(4000) := null;
v_source_id number := null;
v_fullname varchar2(1000) := null;
v_dateofbirth varchar2(100) := null; -- --  Date Format is yyymmdd same as provided by OCG
v_birthyear varchar2(10) := null;
-- Country Codes are  ISO Alpha-2
v_addresscountrycode varchar2(10) := null;
v_residencycountrycode varchar2(10) := null;
v_city_id number := null;
v_countryofbirthcode varchar2(10) := null;
v_nationalitycountrycodes varchar2(10) := null; 
v_passportnumber varchar2(300) := null;
v_nationalid varchar2(300) := null; -- Note: The XWRL_PARTY_MASTER and XWRL_PARTY_ALIAS table do not store this informatoin
v_gender varchar2(30) := null;
v_batch_id integer := null;
v_ctr integer := 1;

begin

v_user_id  := 1156;  -- EBS user id from fnd_user table
v_batch_id := 100;  -- Note: Change this value

SELECT userenv('sessionid') INTO  v_session_id FROM DUAL; -- EBS session id

/*
select *
from xwrl_party_master
where full_name =  'THOMAS JAMES JACKSON';

SELECT *
FROM XWRL_REQUESTS
WHERE NAME_SCREENED = 'THOMAS JAMES JACKSON';

SELECT *
FROM XWRL_REQUESTS
ORDER BY ID DESC;


SELECT * 
FROM XWRL_PARAMETERS
WHERE ID = 'XML'
AND key = 'COMPRESSED_XML';

*/

v_fullname := 'JOHN DOE';
v_dateofbirth := '19870407';
v_birthyear := '1987';
v_gender := 'M';
v_addresscountrycode := 'US';
v_countryofbirthcode := 'CA';
v_nationalitycountrycodes := 'DK';
v_residencycountrycode := 'FI';  -- Note: Adding this caused Error: utl_http.REQUEST_FAILED.  
--v_master_id := 589329 -- PROD
--v_master_id := 71808; -- DR

xwrl_utils.ows_individual_screening (
p_show_request => 'TRUE'
,p_user_id => v_user_id
,p_session_id => v_session_id
,p_master_id => v_master_id
,p_source_table => v_source_table
,p_source_id => v_source_id
,p_fullname => v_fullname
,p_dateofbirth => v_dateofbirth
,p_yearofbirth => v_birthyear
,p_addresscountrycode => v_addresscountrycode
,p_residencycountrycode => v_residencycountrycode
,p_city_id => v_city_id
,p_countryofbirthcode => v_countryofbirthcode
,p_nationalitycountrycodes => v_nationalitycountrycodes
,p_passportnumber => v_passportnumber
,p_gender => v_gender
,p_batch_id => v_batch_id
,x_id => x_id);

/* Note: The URL is hardcoded.  However, this can be derived from the xwrl_parameters table */
dbms_output.put_line('http://127.0.0.1:7101/TradeCompliance/faces/Request?requestId='||x_id);
dbms_output.put_line('http://iriadf-dev.register-iri.com/TradeCompliance/faces/Request?requestId='||x_id);

end;
/
