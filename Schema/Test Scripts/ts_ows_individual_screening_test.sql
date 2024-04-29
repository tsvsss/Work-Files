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
v_ctr integer := 1;

cursor c1 is
select *
from tmp_names
where rownum <= 1
--where full_name = 'THOMAS JAMES JACKSON'
order by full_name
;

begin

v_user_id  := 1156;  -- EBS user id from fnd_user table
v_batch_id := 100;  -- Note: Change this value

SELECT userenv('sessionid') INTO  v_session_id FROM DUAL; -- EBS session id

for i in 1..10 loop

v_batch_id := v_batch_id + v_ctr;  
dbms_output.put_line('BatchId='||v_batch_id);

for c1rec in c1 loop

v_fullname := c1rec.full_name;
v_master_id := c1rec.master_id;

xwrl_utils.ows_individual_screening (
p_user_id => v_user_id
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

dbms_output.put_line('RequestId='||x_id);

end loop;

end loop;

end;
/
