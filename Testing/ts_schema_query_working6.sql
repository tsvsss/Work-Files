SELECT apps.rmi_ows_common_util.get_sanction_status('US')
FROM dual;

select *
from xwrl_requests
where id = 100724;

select *
from xwrl_response_entity_columns
where request_id = 100724
and listid in (2406124,4261827)
order by id
;

xwrl_utils;

xwrl_ows_utils;

select count(*)
from xwrl_requests
where batch_id is null
and case_status = 'O'
;

select *
from xwrl_requests
where id = 35839;

select *
from xwrl_requests
where batch_id is null
and case_status = 'O'
--and matches = 0
order by id desc
;

select *
from xwrl_requests
--WHERE BATCH_ID IS NULL
WHERE case_status = 'O'
AND batch_id is null
--and matches = 0
--AND NAME_SCREENED IS NULL
order by id desc
;

SELECT NEW_VALUE
FROM XWRL_AUDIT_LOG
WHERE TABLE_NAME = 'XWRL_REQUESTS'
and table_id = 38411
and table_column =  'BATCH_ID'
and row_action = 'INSERT'
;


DECLARE
cursor c1 is
select ID, RESUBMIT_ID
from xwrl_requests
--WHERE BATCH_ID IS NULL
WHERE case_status = 'O'
AND batch_id is null;

v_batch_id integer;

begin

for c1rec in c1 loop

v_batch_id := null;

if c1rec.resubmit_id is not null then



SELECT NEW_VALUE into v_batch_id
FROM XWRL_AUDIT_LOG
WHERE TABLE_NAME = 'XWRL_REQUESTS'
and table_id = c1rec.resubmit_id
and table_column =  'BATCH_ID'
and row_action = 'INSERT'
;

dbms_output.put_line('Batch Id: '||v_batch_id);

end if;

if v_batch_id is not null then

update xwrl_requests
set batch_id = v_batch_id
where id = c1rec.id;

end if;

end loop;
end;
/


SELECT NEW_VALUE
FROM XWRL_AUDIT_LOG
WHERE TABLE_NAME = 'XWRL_REQUESTS'
and table_id = 38411
--and table_column =  'BATCH_ID'
and row_action = 'INSERT'
;

SELECT *
FROM xwrl_requests
WHERE CASE_ID IS NULL;

update xwrl_requests
set case_status = 'C'
,case_state = 'A'
,case_workflow = 'A'
where batch_id is null
and case_status = 'O'
and matches = 0;


select count(*)
from xwrl_alert_clearing_xref
;

select *
from xwrl_alert_clearing_xref
order by 1 desc
;

select *
from sicd_seafarers
where seafarer_id = 574368
;

update xwrl_response_ind_columns
set x_state =  'PEP - False Positive'
where id = 73208;

select *
from xwrl_response_ind_columns
;

select substr(x_state,7) alert_state, count(*)
from xwrl_response_ind_columns
group by substr(x_state,7)
order by decode(substr(x_state,7),'Open',1,'False Positive',2,'Possible',3,4)
;

select substr(x_state,7) alert_state, count(*)
from xwrl_response_entity_columns
group by substr(x_state,7)
order by decode(substr(x_state,7),'Open',1,'False Positive',2,'Possible',3,4);


select *
from xwrl_requests
where batch_id = 50361
;

select *
from xwrl_party_master
where id = 1101121
;


select *
from xwrl_party_master
--where full_name = 'YVGENIY MEDVEDEV'
where id = 1681268
;

select *
from xwrl_party_xref
where master_id = 1101121
;

select *
from xwrl_party_master
where source_table = 'CORP_MAIN'
and source_id = 1110911
;

select *
from WC_SCREENING_REQUEST
where name_screened = 'WANG SHANLIN'
;

select *
from WORLDCHECK_EXTERNAL_XREF
WHERE wc_screening_request_id = 878318
;

select *
from xwrl_party_master
where id = 1677234;

select *
from xwrl_party_xref
where master_id = 1677234;

select *
from xwrl_party_xref
where relationship_master_id = 1677234;

select *
from xwrl_party_alias
where master_id = 1677234
;

select *
from xwrl_party_xref;

rmi_ows_common_util;

select count(*)
from xwrl_alert_clearing_xref;

select *
from xwrl_requests
order by id  desc;

select name_screened, matches
from xwrl_requests
where matches > 0
group by name_screened, matches
;


select name_screened, matches
from xwrl_requests
where matches = 0
group by name_screened, matches
;

select *
from xwrl_requests
;

 



select master_id, alias_id, xref_id, name_screened
--,count(*)
from (select master_id, alias_id, xref_id, name_screened, matches
from xwrl_requests
where matches > 0
group by master_id, alias_id, xref_id, name_screened, matches
union
select master_id, alias_id, xref_id, name_screened, matches
from xwrl_requests
where matches = 0
group by master_id, alias_id, xref_id, name_screened, matches)
group by master_id, alias_id, xref_id, name_screened
having count(*) > 1
order by ltrim(name_screened)
;

select count(*) from xwrl_requests;


select *
from xwrl_requests
where master_id = 3734;


select id, name_screened
from xwrl_requests
where name_screened <> ltrim(name_screened)
order by id desc
;

declare
cursor c1 is
select id, name_screened
from xwrl_requests
where name_screened <> ltrim(name_screened)
order by id desc
;

begin

for c1rec in c1 loop

begin
update xwrl_requests
set name_screened = ltrim(c1rec.name_screened)
where id = c1rec.id;
exception
when others then
dbms_output.put_line('Error: '||sqlerrm);
dbms_output.put_line('ID '||c1rec.id|| ' '||'Name: '||c1rec.name_screened);
end;

end loop;
commit;
end;
/

select *
from xwrl_party_master
where FULL_NAME = 'BING CHEN'
;

select *
from xwrl_party_master
--where FULL_NAME = 'BING CHEN'
WHERE SOURCE_TABLE = 'CORP_MAIN'
;

select full_name, count(*)
from xwrl_party_master
--where FULL_NAME = 'BING CHEN'
WHERE SOURCE_TABLE = 'CORP_MAIN'
and full_name is not null
group by full_name
having count(*) > 1
order by full_name
;

select full_name,state,status, count(*)
from xwrl_party_master
--where FULL_NAME = 'BING CHEN'
WHERE SOURCE_TABLE = 'CORP_MAIN'
and full_name is not null
group by full_name,state,status
having count(*) > 1
order by full_name
;


select *
from xwrl_party_master
where full_name = 'ACE PAWLIKOWSKI'
;

select *
from xwrl_party_xref
where master_id in (select id from xwrl_party_master where full_name = 'ACE PAWLIKOWSKI')
order by master_id
;

select *
from xwrl_party_xref
where relationship_master_id in (select id from xwrl_party_master where full_name = 'ACE PAWLIKOWSKI')
order by relationship_master_id, master_id
;

select *
from corp_main
;

select mst.id, mst.batch_id, mst.relationship_type, mst.entity_type, mst.state, mst.status, mst.source_table, mst.full_name, mst.tc_excluded, cm.corp_number, cm.corp_name1 corp_name
from xwrl_party_master mst
,corp_main cm
where mst.full_name = 'ACE PAWLIKOWSKI'
and cm.corp_id = source_id
order by corp_name
;

select xref.id, xref.master_id, xref.relationship_master_id, xref.relationship_type, xref.state, xref.status, xref.start_date, xref.end_date, xref.tc_excluded, mst.full_name, ref.full_name corp_name
from xwrl_party_xref xref
,xwrl_party_master mst
,xwrl_party_master ref
where xref.relationship_master_id = mst.id
and xref.master_id = ref.id
and xref.relationship_master_id in (select id from xwrl_party_master where full_name = 'ACE PAWLIKOWSKI')
order by corp_name
;



select *
from xwrl_requests
where name_screened = 'RAJ KUMAR'
and id = 112083
order by id desc
;

select *
from xwrl_party_master
where id in (123761,475474)
;

select *
from xwrl_alert_clearing_xref
order by id desc
;

select count(*)
from xwrl_alert_clearing_xref;

select *
from xwrl_requests
where batch_id in (55166,55200,37617);

select *
from xwrl_party_master
where batch_id in (36506);


select *
from xwrl_party_alias
where batch_id in (36506)
;

update  xwrl_party_master
set batch_id = null
where batch_id in (36506);

update xwrl_party_alias
set batch_id = null
where batch_id in (36506);

select *
from xwrl_requests
where batch_id = 36478;

select *
from xwrl_party_master
where batch_id = 36478
--where id = 542157
;

select *
from xwrl_party_master
where full_name = 'TRANSGLOBAL DEVELOPMENT AND INVESTMENT CORP.'
;

select * 
from xwrl_party_xref
where master_id = 542156
;


select xref.id, xref.master_id, xref.relationship_master_id, xref.relationship_type, xref.state, xref.status, xref.start_date, xref.end_date, xref.tc_excluded, mst.full_name, ref.full_name corp_name
from xwrl_party_xref xref
,xwrl_party_master mst
,xwrl_party_master ref
where xref.relationship_master_id = mst.id
and xref.master_id = ref.id
and xref.master_id  = 542156
order by id
;

delete from xwrl_party_xref
where id in (4379885,4380377,4837339,4837355)
;


select * 
from xwrl_party_xref
where relationship_master_id = 542156
;


SELECT
   full_name
   , source_table
   , id
   , TO_DATE (date_of_birth, 'YYYYMMDD') dob
   , CASE
      WHEN source_table = 'SICD_SEAFARERS' THEN
         (
            SELECT
               'FIN#: ' || TO_CHAR (seafarer_id)
            FROM
               sicd_seafarers
            WHERE
               seafarer_id = source_id
         )
      WHEN source_table = 'AR_CUSTOMERS'   THEN
         (
            SELECT
               'Customer#: ' || customer_number
            FROM
               ar_customers
            WHERE
               customer_id = source_id
         )
      WHEN source_table = 'CORP_MAIN'      THEN
         (
            SELECT
               'Corp#: ' || corp_number
            FROM
               corp_main
            WHERE
               corp_id = source_id
         )
      WHEN source_table = 'REG11_HEADER'   THEN
         (
            SELECT
               'IMO#: ' || imo_number
            FROM
               reg11_header
            WHERE
               reg11_header_id = source_id
         )
      WHEN source_table = 'VSSL_VESSELS'   THEN
         (
            SELECT
               'IMO#: ' || MAX (imo_number)
            FROM
               vssl_vessels
            WHERE
               vessel_pk = source_id
               AND ROWNUM <= 1
         )
      WHEN source_table LIKE 'NRMI%' THEN
         (
            SELECT
               'Request#: ' || nrmi_certificates_id
            FROM
               nrmi_certificates
            WHERE
               nrmi_certificates_id = source_id
         )
   END identifier
FROM
   xwrl.xwrl_party_master
WHERE
   status = 'Enabled'
   AND state NOT IN (
      'Delete - Duplicate'
      , 'Delete - Alias'
   )
   AND trunc (SYSDATE) BETWEEN trunc (nvl (start_date, SYSDATE)) AND trunc (nvl (end_date, SYSDATE))
ORDER BY
   1;
   
select *
from xwrl_party_master
;

select *
from xwrl_party_alias
;


select * from  xwrl.xwrl_party_master

where CITY_OF_RESIDENCE_ID =499

and COUNTRY_OF_RESIDENCE <> 'RU'

and COUNTRY_OF_RESIDENCE <> 'RUSS'

and COUNTRY_OF_RESIDENCE <> 'UA'

and COUNTRY_OF_RESIDENCE <> 'UKRA'
;
 

select * from  xwrl.xwrl_party_alias


where CITY_OF_RESIDENCE_ID =499

and COUNTRY_OF_RESIDENCE <> 'RU'

and COUNTRY_OF_RESIDENCE <> 'RUSS'

and COUNTRY_OF_RESIDENCE <> 'UA'

and COUNTRY_OF_RESIDENCE <> 'UKRA'
;

update xwrl.xwrl_party_master

set  CITY_OF_RESIDENCE_ID =null

where CITY_OF_RESIDENCE_ID =499

and COUNTRY_OF_RESIDENCE <> 'RU'

and COUNTRY_OF_RESIDENCE <> 'RUSS'

and COUNTRY_OF_RESIDENCE <> 'UA'

and COUNTRY_OF_RESIDENCE <> 'UKRA'
;

 

update xwrl.xwrl_party_alias

set  CITY_OF_RESIDENCE_ID =null

where CITY_OF_RESIDENCE_ID =499

and COUNTRY_OF_RESIDENCE <> 'RU'

and COUNTRY_OF_RESIDENCE <> 'RUSS'

and COUNTRY_OF_RESIDENCE <> 'UA'

and COUNTRY_OF_RESIDENCE <> 'UKRA'
;

xwrl_ows_utils;

xwrl_utils;

select *
from xwrl_parameters
order by id, key
;

select count(*)
from xwrl_requests
where case_state = 'D'
;

alter table xwrl.xwrl_alert_clearing_xref add 
(master_id number
,alias_id number
,xref_id number);

xxiri_cm_process_pkg;

select *
from xwrl_requests
where case_id = 'OWS-202003-090912-C9ED0C-IND'
;

select *
from xwrl_requests
where id = 120989
;

select *
from xwrl_response_ind_columns
--where request_id = 120989
where alertid = 'SEN-2138845'
;

select *
from xwrl_alert_notes
where request_id = 120989
order by id desc
;

select *
from fnd_user
where user_id = 11018;

select *
from xwrl_party_cross_ref_v
;

select *
from all_objects
where object_name = 'XWRL_PARTY_CROSS_REF_V'
;

SELECT *
FROM ALL_VIEWS
WHERE view_name = 'XWRL_PARTY_CROSS_REF_V'
;

select *
from all_source
where lower(text) like '%xxiri_cm_process_pkg.update_alerts%'
;

XWRL_OWS_UTILS;

RMI_OWS_COMMON_UTIL;

select *
from xwrl_party_cross_ref_v
;

create view apps.XWRL_PARTY_CROSS_REF_V
as
(SELECT DISTINCT reference_desc,source_id
           FROM (SELECT source_id, --id,
                        rmi_ows_common_util.get_custom_tag_info
                                                (source_table,
                                                 source_id
                                                ) reference_desc
                   FROM xwrl_party_master
                 UNION
                 SELECT m1.source_id, --relationship_master_id,
                        rmi_ows_common_util.get_custom_tag_info
                                                              (m.source_table,
                                                               m.source_id
                                                              )
                   FROM xwrl_party_xref x,
                        xwrl_party_master m,
                        xwrl_party_master m1
                  WHERE 1 = 1
                    AND m1.relationship_type = 'Primary'
                    AND m.ID = x.master_id
                    AND m1.ID = x.relationship_master_id
                 UNION
                 SELECT m1.source_id, --relationship_master_id,
                        rmi_ows_common_util.get_custom_tag_info
                                                              (m.source_table,
                                                               m.source_id
                                                              )
                   FROM xwrl_party_xref x,
                        xwrl_party_master m,
                        xwrl_party_master m1
                  WHERE 1 = 1
                    AND m1.relationship_type != 'Primary'
                    AND m.ID = x.master_id
                    AND m1.ID = x.relationship_master_id)
--          WHERE source_id = 849716 
);


      SELECT count(*)
        FROM xwrl_requests
       WHERE case_id IS NULL;

select *
from sicd_seafarers
where seafarer_id = 781693
;
       
select *
from xwrl_requests
where name_screened = 'SALEEM  ALI'
;

2962 - master
2964
2933
2934

select *
from xwrl_party_master 
where full_name = 'SALEEM  ALI'
and id = 1423448
;

select count(*)
from sicd_seafarers
where first_name <> ltrim(first_name)
;

select count(*)
from sicd_seafarers
where last_name <> ltrim(last_name)
;

select *
from corp_main
;

select count(*)
from corp_main
where corp_name1 <> ltrim(corp_name1)
;

SELECT COUNTRY_NAME, COUNTRY_CODE , iso_alpha2_code
  FROM SICD_COUNTRIES
WHERE STATUS = 'Active'
--and country_code = 'CNCA'
ORDER BY iso_alpha2_code;

select iso_alpha2_code OptionKey,     
country_name OptionValue       
from SICD_COUNTRIES         
WHERE STATUS = 'Active'         
--and iso_alpha2_code is not null 
order by country_name
;


select *
from xwrl_requests
where batch_id in (55459,57378,58539)
and master_id = 163263
and alias_id is null
order by id desc
;

select *
from xwrl_response_ind_columns
where request_id in (select id from xwrl_requests where batch_id in (55459,57378,58539) and master_id = 163263 and alias_id is null)
order by request_id desc, id desc
;

select *
from xwrl_alert_clearing_xref
where request_id in (select id from xwrl_requests where batch_id in (55459,57378,58539) and master_id = 163263 and alias_id is null)
order by request_id desc, id desc, list_id desc
;

-- Party Master
select *
from xwrl_party_master
where id = 163263
;

-- 	SINGH HARMEET
-- NONCONVICTION TERROR

-- passport N2358232

-- Case Level

select id, batch_id, master_id, case_id, name_screened, date_of_birth, department, department_ext, office, xref.last_updated_by, cuser.user_name created_user, uuser.user_name updated_user
from xwrl_requests xref
,fnd_user cuser
,fnd_user uuser
where batch_id in (55459,57378,58539)
--and master_id = 163263
and alias_id is null
and xref.created_by = cuser.user_id
and xref.last_updated_by = uuser.user_id
order by id desc
;

-- Alert Level

select id, request_id, x_state, rec, listfullname, listnametype, category, alertid, listid, xref.creation_date,  xref.created_by, xref.last_update_date, xref.last_updated_by, cuser.user_name created_user, uuser.user_name updated_user
from xwrl_response_ind_columns xref
,fnd_user cuser
,fnd_user uuser
where request_id in (select id from xwrl_requests where batch_id in (55459,57378,58539) and master_id = 163263 and alias_id is null)
and category not in ('INDIVIDUAL')
and xref.created_by = cuser.user_id
and xref.last_updated_by = uuser.user_id
and listid = 3642955
order by request_id desc, id desc
;

-- Alert Notes

with alerts as (select id, request_id, x_state, rec, listfullname, listnametype, category, alertid, listid, xref.created_by, xref.last_updated_by, cuser.user_name created_user, uuser.user_name updated_user
from xwrl_response_ind_columns xref
,fnd_user cuser
,fnd_user uuser
where request_id in (select id from xwrl_requests where batch_id in (55459,57378,58539) and master_id = 163263 and alias_id is null)
and category not in ('INDIVIDUAL')
and xref.created_by = cuser.user_id
and xref.last_updated_by = uuser.user_id
order by request_id desc, id desc)
select note.id, note.request_id, note.alert_id, note.line_number, note.note, note.created_by, note.creation_date, usr.user_name created_by, note.last_update_date, uusr.user_name updated_by
from xwrl_alert_notes note
,fnd_user usr
,fnd_user uusr
,alerts
where note.created_by = usr.user_id 
and note.last_updated_by = uusr.user_id 
and note.request_id in (select id from xwrl_requests where batch_id in (55459,57378,58539) and master_id = 163263 and alias_id is null)
and note.alert_id = alerts.alertid
and listid = 3642955
order by request_id desc, note.id desc
;

-- Alert Clearing XREF

select id, request_id, master_id, alert_id, list_id, from_state, to_state, note, xref.creation_date, xref.created_by, xref.last_update_date, xref.last_updated_by, cuser.user_name created_user, uuser.user_name updated_user
from xwrl_alert_clearing_xref xref
,fnd_user cuser
,fnd_user uuser
where request_id in (select id from xwrl_requests where batch_id in (55459,57378,58539) and master_id = 163263 and alias_id is null)
and xref.created_by = cuser.user_id
and xref.last_updated_by = uuser.user_id
--and alert_id = 'SEN-9839907'
and list_id = 3642955
order by request_id desc, id desc, list_id desc
;

select *
from WC_SCREENING_REQUEST
where name_screened = 'HARMEET SINGH'
and passport_number = 'N2358232'
order by 1 desc
;

select *
from wc_content
where wc_screening_request_id = 198232
and lower(notes) like '%low risk%'
--and matchentityidentifier = 'e_tr_wci_3642955'
;

-- 3642955

select id, entity_type, full_name
from xwrl_party_master
where source_table = 'CORP_MAIN'
and source_id = 7
order by id desc
;

select *
from xwrl_requests
where source_table = 'CORP_MAIN'
and source_id = 7
order by id desc
;

select *
from xwrl_requests
--where batch_id = 1884
order by id desc
;

select batch_id, id, name_screened, matches, error_message, creation_date
from xwrl_requests
where source_table = 'CORP_MAIN'
and source_id = 7
and error_message is not null
order by id desc
;

select id, full_name, length(full_name) - length(replace(full_name, ' ', '')) + 1 NumbofWords
from xwrl_party_master
order by id
;

select req.id, req.master_id, mst.full_name, nvl(mst.number_of_words,3)
from xwrl_requests req
,xwrl_party_master mst
where req.master_id = mst.id
and mst.number_of_words is null
;

select id, request_id, rec, listid, listfullname,  matchrule, category, creation_date
from xwrl_response_ind_columns
--where request_id in (select id from xwrl_requests where batch_id = 1884)
--and matchrule = '[I220O] Additional names typo tolerant only'
where matchrule = '[I220O] Additional names typo tolerant only'
order by creation_date desc
;

select *
from xwrl_response_ind_columns
order by id desc;

select *
from xwrl_response_rows
--where key = 'MatchRule' 
--and value= '[I220O] Additional names typo tolerant only'
;

select value_string
FROM  xwrl_parameters
          WHERE id                  = 'CASE_RESTRICTIONS';
          
                 select count(*)
       FROM xwrl.xwrl_parameters
       WHERE id                  = 'CASE_RESTRICTIONS'
       AND UPPER(value_string) = UPPER(:Category); 

         SELECT 'Y'
           INTO l_category_restricted
           FROM xwrl.xwrl_parameters
          WHERE id                  = 'CASE_RESTRICTIONS'
            AND UPPER(value_string) = UPPER(:NEW.value);
            
select *
from xwrl_requests
order by id desc
;

select batch_id
from xwrl_requests
order by batch_id
;

create table tmp_names 
(full_name varchar2(100));

insert into tmp_names (full_name) values ('ABHISHEK KUMAR SINGH');
insert into tmp_names (full_name) values ('ANAND KUMAR');
insert into tmp_names (full_name) values ('ANUSHKA KHATRI');
insert into tmp_names (full_name) values ('CHEN HU');
insert into tmp_names (full_name) values ('HU CHEN');
insert into tmp_names (full_name) values ('IBRAHIM');
insert into tmp_names (full_name) values ('IGNACIO GARCIA');
insert into tmp_names (full_name) values ('ISMAEL');
insert into tmp_names (full_name) values ('LI LI WEI');
insert into tmp_names (full_name) values ('LI WEI');
insert into tmp_names (full_name) values ('LI ZHANG');
insert into tmp_names (full_name) values ('MICHAEL WALLACE');
insert into tmp_names (full_name) values ('MICHAEL WILLIAMS');
insert into tmp_names (full_name) values ('MOHAMED HARSHED JALEEL');
insert into tmp_names (full_name) values ('MUSTAFA KAAN ARSLAN');
insert into tmp_names (full_name) values ('NAVEEN KUMAR ARJALA');
insert into tmp_names (full_name) values ('OZGUR MEHMET');
insert into tmp_names (full_name) values ('SERGEI POPOV');
insert into tmp_names (full_name) values ('SERGEI VLADMIROVICH POPOV');
insert into tmp_names (full_name) values ('SUNIL KUMAR');
insert into tmp_names (full_name) values ('THOMAS JAMES JACKSON');
insert into tmp_names (full_name) values ('VAN SU NGUYEN');
insert into tmp_names (full_name) values ('VIC ANTHONY DE LA CRUZ');
insert into tmp_names (full_name) values ('WEI LI');
insert into tmp_names (full_name) values ('WEI LI LI');
insert into tmp_names (full_name) values ('ZHANG LI');

select count(*)
from tmp_names
;

select * 
from xwrl_requests
where batch_id = 100
order by id desc
;

select id, request_id, listid, listfullname, category, matchrule, alertid
from xwrl_response_ind_columns
where request_id = 3174
;

select *
from xwrl_response_rows
where request_id = 3174
;

select *
from tmp_names
;

alter table tmp_names add
(master_id integer);

select n.full_name, id master_id
from tmp_names n
,xwrl_party_master m
where n.full_name = m.full_name
and m.id = (select max(x.id) from xwrl_party_master x where x.full_name = m.full_name)
;

declare
cursor c1 is
select n.full_name, id master_id
from tmp_names n
,xwrl_party_master m
where n.full_name = m.full_name
and m.id = (select max(x.id) from xwrl_party_master x where x.full_name = m.full_name)
;

begin

for c1rec in c1 loop
update tmp_names
set master_id = c1rec.master_id
where full_name = c1rec.full_name;

commit;

end loop;
end;
/

SELECT O.OBJECT_NAME, S.SID, S.SERIAL#, P.SPID, S.PROGRAM,S.USERNAME,
S.MACHINE,S.PORT , S.LOGON_TIME,SQ.SQL_FULLTEXT 
FROM V$LOCKED_OBJECT L, DBA_OBJECTS O, V$SESSION S, 
V$PROCESS P, V$SQL SQ 
WHERE L.OBJECT_ID = O.OBJECT_ID 
AND L.SESSION_ID = S.SID AND S.PADDR = P.ADDR 
AND S.SQL_ADDRESS = SQ.ADDRESS;

alter system kill session '1889,7552';;



WITH workflow as
(SELECT KEY, VALUE_STRING, sort_order
FROM XWRL_PARAMETERS
WHERE ID = 'CASE_WORK_FLOW')
select TO_CHAR(xr.creation_date,'MM/DD/YYYY') creation_date ,  workflow.value_string case_workflow, count(*) 
from xwrl_requests  xr
,workflow
where case_workflow = workflow.key
and xr.creation_date >= to_date('20191210 08:00 PM','YYYYMMDD HH:MI AM')
group by TO_CHAR(xr.creation_date,'MM/DD/YYYY'), workflow.value_string, sort_order
order by 1 desc, workflow.sort_order
;

select req.id, req.master_id, req.name_screened, req.matches, req.case_status, req.case_state, req.case_workflow, req.creation_date
from xwrl_requests req
where req.batch_id = 100
order by req.name_screened
;

xwrl_utils;

select *
from all_source
where lower(text) like '%ows_web_service%'
;

select id,master_id, 
from xwrl_requests
where batch_id = 100
order by id desc;

select name_screened full_name, count(*)
from (SELECT NAME_SCREENED, matches
FROM xwrl_requests
GROUP BY name_screened, matches)
group by name_screened
having count(*) > 1;



select n.full_name, m.id master_id
from (select name_screened full_name, count(*)
from (SELECT NAME_SCREENED, matches
FROM xwrl_requests
GROUP BY name_screened, matches)
group by name_screened
having count(*) > 1) n
,xwrl_party_master m
where n.full_name = m.full_name
and m.id = (select max(x.id) from xwrl_party_master x where x.full_name = m.full_name);


select * 
from xwrl_requests 
where batch_id = 100
order by id desc;



select count(*)
from xwrl_requests 
where batch_id = 100;

select count(*)
from xwrl_requests 
where batch_id = 100
and matches = 0
;


select value_string
FROM  xwrl_parameters
          WHERE id                  = 'CASE_RESTRICTIONS';
          
          rmi_ows_common_util;
          
          xwrl_utils;
          
          xwrl_ows_utils;
          
          
select id, case_id, path, request, response, status, name_screened, error_message, creation_date
from xwrl_requests
order by id desc
;
