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

--cursor c1 is

--select *
--from tmp_names
--where rownum = 1;

/*
select n.full_name, id master_id
from (select name_screened full_name, count(*)
from (SELECT NAME_SCREENED, matches
FROM xwrl_requests
GROUP BY name_screened, matches)
group by name_screened
having count(*) > 1) n
,xwrl_party_master m
where n.full_name = m.full_name
and m.id = (select max(x.id) from xwrl_party_master x where x.full_name = m.full_name)
;
*/

begin

v_user_id  := 1156;  -- EBS user id from fnd_user table
SELECT userenv('sessionid') INTO  v_session_id FROM DUAL; -- EBS session id

v_source_table := 'SICD_SEAFARERS';
v_source_table_column := 'SEAFARER_ID';
v_source_id :=  826655;
v_fullname := 'YOUNG SIK KIM';
v_batch_id := 100;

/*
v_source_table := 'SICD_SEAFARERS';
v_source_table_column := 'SEAFARER_ID';
v_source_id :=  789849;
v_fullname := 'MANUEL ENRIQUE GARCIA';
v_dateofbirth := '19770408';
v_addresscountrycode := 'IR';
v_residencycountrycode := 'US';
v_countryofbirthcode := 'IR';
v_nationalitycountrycodes := 'UK';

v_source_table := 'SICD_SEAFARERS';
v_source_table_column := 'SEAFARER_ID';
v_source_id :=  1088238;
v_fullname := 'KIRILL PRILEPSKII';
v_dateofbirth := '19840209';
v_addresscountrycode := 'IR';
v_residencycountrycode := 'RU';
v_city_id := 488;
v_countryofbirthcode := 'IR';
v_nationalitycountrycodes := 'UK';
v_passportnumber := '73 3796305';
v_gender := 'MALE';
*/

--v_fullname := 'JAI DEEP SINGH';
--v_fullname := 'SINGH RAJ KISHOR';
--v_fullname := 'REY MARK SAPLOT RICO';
--v_fullname := 'ANTON MOROZ';
--v_master_id := 1502083;

--for c1rec in c1 loop

--v_fullname := c1rec.full_name;
--v_batch_id := 100;
--v_master_id := c1rec.master_id;

xwrl_utils.ows_individual_screening (
p_show_request => 'FALSE'
,p_user_id => v_user_id
,p_session_id => v_session_id
,p_master_id => v_master_id
,p_source_table => v_source_table
,p_source_id => v_source_id
,p_fullname => v_fullname
,p_dateofbirth => v_dateofbirth
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

--end loop;


end;
/
