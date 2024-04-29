 select *
 from xwrl_requests
 where status = 'ERROR'
 ;
 
 xwrl_utils;
 
 DROP table tmp_sdn_individuals;

create table tmp_sdn_individuals (
dnlistrecordid integer
,dnfullname varchar2(2000)
,dnprimaryname varchar2(2000)
,dndob varchar2(100)
,dnyob varchar2(10)
,dndeceasedflag varchar2(10)
);

select * 
from tmp_sdn_individuals
;

DROP table tmp_sdn_entities;

create table tmp_sdn_entities (
dnlistrecordid integer
,dnentityname varchar2(2000)
,dnprimaryname varchar2(2000)
);

select * 
from tmp_sdn_individuals
;

select * 
from tmp_sdn_entities
;

select count(*)
from tmp_sdn_individuals
;

select *
from all_source
;

select count(*)
from tmp_sdn_entities
;

select *
from xwrl_requests
;

select dnlistrecordid, dnfullname
from tmp_sdn_individuals
where dnfullname is not null
union
select dnlistrecordid, dnprimaryname
from tmp_sdn_individuals
where dnfullname is null
;

select req.id, req.batch_id, req.master_id, req.alias_id, req.xref_id, req.path, req.name_screened
from xwrl_requests req
where path = 'INDIVIDUAL' 
and exists 
(select 1
from (select dnlistrecordid, dnfullname
from tmp_sdn_individuals
where dnfullname is not null
union
select dnlistrecordid, dnprimaryname
from tmp_sdn_individuals
where dnfullname is null) x
where upper(req.name_screened) = upper(x.dnfullname))
order by name_screened;

select unique  req.name_screened
from xwrl_requests req
where path = 'INDIVIDUAL' 
and exists 
(select 1
from (select dnlistrecordid, dnfullname
from tmp_sdn_individuals
where dnfullname is not null
union
select dnlistrecordid, dnprimaryname
from tmp_sdn_individuals
where dnfullname is null) x
where upper(req.name_screened) = upper(x.dnfullname))
order by name_screened;


select req.id, req.batch_id, req.master_id, req.alias_id, req.xref_id, req.path, req.name_screened
from xwrl_requests req
where path = 'ENTITY' 
and exists 
(select 1
from (select dnlistrecordid, dnentityname
from tmp_sdn_entities
where dnentityname is not null
union
select dnlistrecordid, dnprimaryname
from tmp_sdn_entities
where dnentityname is null) x
where upper(req.name_screened) = upper(x.dnentityname))
order by name_screened;

select unique req.name_screened
from xwrl_requests req
where path = 'ENTITY' 
and exists 
(select 1
from (select dnlistrecordid, dnentityname
from tmp_sdn_entities
where dnentityname is not null
union
select dnlistrecordid, dnprimaryname
from tmp_sdn_entities
where dnentityname is null) x
where upper(req.name_screened) = upper(x.dnentityname))
order by name_screened;

select *
from xwrl_requests
where creation_date >= trunc(sysdate)
order by id desc
;



SELECT id, request_id, alertid, rec,

       DECODE(XwrlResponseIndColumns.LEGAL_REVIEW,'Y','Legal Checked','Legal Unchecked') LEGAL_CHECKED

      ,substr(XwrlResponseIndColumns.x_state,7,length(XwrlResponseIndColumns.x_state)) STATE

  ,CASE

  WHEN substr(XwrlResponseIndColumns.x_state,7,length(XwrlResponseIndColumns.x_state)) = 'Open'

  THEN

       substr(XwrlResponseIndColumns.x_state,7,length(XwrlResponseIndColumns.x_state))

       ||' '||

       DECODE(XwrlResponseIndColumns.LEGAL_REVIEW,'Y','Legal Checked','Legal Unchecked')

   WHEN substr(XwrlResponseIndColumns.x_state,7,length(XwrlResponseIndColumns.x_state)) = 'False Positive'

  THEN

       substr(XwrlResponseIndColumns.x_state,7,length(XwrlResponseIndColumns.x_state))

   WHEN substr(XwrlResponseIndColumns.x_state,7,length(XwrlResponseIndColumns.x_state)) = 'Possible'

  THEN

       substr(XwrlResponseIndColumns.x_state,7,length(XwrlResponseIndColumns.x_state))

    WHEN substr(XwrlResponseIndColumns.x_state,7,length(XwrlResponseIndColumns.x_state)) = 'Positive'

  THEN

       substr(XwrlResponseIndColumns.x_state,7,length(XwrlResponseIndColumns.x_state))    

END as STATE_LEGAL

FROM  XWRL_RESPONSE_IND_COLUMNS XwrlResponseIndColumns

where request_id = 2091

order by decode ((CASE

  WHEN substr(XwrlResponseIndColumns.x_state,7,length(XwrlResponseIndColumns.x_state)) = 'Open'

  THEN

       substr(XwrlResponseIndColumns.x_state,7,length(XwrlResponseIndColumns.x_state))

       ||' '||

       DECODE(XwrlResponseIndColumns.LEGAL_REVIEW,'Y','Legal Checked','Legal Unchecked')

   WHEN substr(XwrlResponseIndColumns.x_state,7,length(XwrlResponseIndColumns.x_state)) = 'False Positive'

  THEN

       substr(XwrlResponseIndColumns.x_state,7,length(XwrlResponseIndColumns.x_state))

   WHEN substr(XwrlResponseIndColumns.x_state,7,length(XwrlResponseIndColumns.x_state)) = 'Possible'

  THEN

       substr(XwrlResponseIndColumns.x_state,7,length(XwrlResponseIndColumns.x_state))

    WHEN substr(XwrlResponseIndColumns.x_state,7,length(XwrlResponseIndColumns.x_state)) = 'Positive'

  THEN

       substr(XwrlResponseIndColumns.x_state,7,length(XwrlResponseIndColumns.x_state))    

END)  

                 ,'Open Legal Unchecked',1 

                 ,'Open Legal Checked',2

                 ,'Positive',4  

                 ,'Possible',3  

                 ,'False Positive',5) asc, rec desc;
                 
select to_char(s.begin_interval_time, 'DD-MON-YYYY HH24:MI:SS') snap_time,
       p.instance_number,
       p.snap_id,
       p.name,
       p.old_value,
       p.new_value,
       decode(trim(translate(p.new_value, '0123456789', '          ')),
              '',
              trim(to_char(to_number(p.new_value) - to_number(p.old_value),
                           '999999999999990')),
              '') diff
  from (select dbid,
               instance_number,
               snap_id,
               parameter_name name,
               lag(trim(lower(value))) over(partition by dbid, instance_number, parameter_name order by snap_id) old_value,
               trim(lower(value)) new_value,
               decode(nvl(lag(trim(lower(value)))
                          over(partition by dbid,
                               instance_number,
                               parameter_name order by snap_id),
                          trim(lower(value))),
                      trim(lower(value)),
                      '~NO~CHANGE~',
                      trim(lower(value))) diff
          from dba_hist_parameter) p,
       dba_hist_snapshot s
 where s.begin_interval_time between trunc(sysdate - 31) and
       sysdate
   and p.dbid = s.dbid
   and p.instance_number = s.instance_number
   and p.snap_id = s.snap_id
   and p.diff <> '~NO~CHANGE~'
 order by snap_time, instance_number;


select *
from xwrl_party_master
order by id desc
;
                 
select req.id, req.batch_id, req.master_id, req.alias_id, req.xref_id, req.path, req.name_screened, req.case_id, req.matches, req.creation_date, req.last_update_date
from xwrl_requests req                 
where req.creation_date >= trunc(sysdate)
order by req.id desc;

                 
select req.id, req.batch_id, req.master_id, req.alias_id, req.xref_id, req.path, req.name_screened, req.case_id, req.matches, req.creation_date, req.last_update_date, status
from xwrl_requests req                 
where batch_id = 66274
order by req.id desc;

select *
from xwrl_requests
where batch_id in (99874,74579);

select *
from xwrl_requests
where source_id in (99874,74579);

select *
from xwrl_requests
where name_screened = 'LI QIANG'
;

select *
from xwrl_party_master 
where full_name = 'LI QIANG'
order by id desc
;

select *
from corp_main
where corp_number = to_char(74579);

select *
from xwrl_requests
where master_id = 1674794;

select *
from xwrl_audit_log
where table_name = 'XWRL_REQUESTS'
and table_column = 'MASTER_ID'
AND NEW_VALUE = 1674794
;


select *
from xwrl_audit_log
where table_name = 'XWRL_REQUESTS'
and table_column = 'MASTER_ID'
AND NEW_VALUE IN (SELECT ID from xwrl_party_master 
where full_name = 'LI QIANG')
;

SELECT *
FROM tmp_alert_error
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

alter table tmp_names add
(master_id integer);

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

update xwrl_response_ind_columns
set x_state = 'SAN - False Positive'
where id =165825;

select *
from tmp_names
;

delete from tmp_names
where master_id is null;

select count(*)
from tmp_names
;

select *
from xwrl_requests
order by id desc;

select req.id, req.batch_id, req.master_id, req.alias_id, req.xref_id, req.path, req.name_screened, req.case_id, req.matches, req.creation_date, req.last_update_date, status, req.job_id
from xwrl_requests req                 
where batch_id <= 100
order by req.id desc
;

select *
from tmp_names
;

select unique batch_id
from xwrl_requests
where batch_id < 1000
group by batch_id
;

select req.id, req.batch_id, req.request, req.master_id, req.alias_id, req.xref_id, req.path, req.name_screened, req.case_id, req.matches, req.creation_date, req.last_update_date, status, req.job_id, req.error_message
from xwrl_requests req                 
where batch_id < 100
order by req.id desc
;

select *
from XWRL_ALERT_CLEARING_XREF 
order by id desc;

SELECT COL.ID, COL.REQUEST_ID, R.SOURCE_TABLE, R.SOURCE_ID, COL.LISTID,

              COL.ALERTID, COL.X_STATE , COL.LISTRECORDTYPE||SUBSTR(CLEAR.TO_STATE,4)

              TO_STATE , CLEAR.NOTE FROM XWRL_RESPONSE_IND_COLUMNS COL, XWRL_REQUESTS

              R, (WITH MAX_TAB AS (SELECT X.MASTER_ID, X.ALIAS_ID, X.XREF_ID,

              X.LIST_ID, MAX (X.ID) ID FROM XWRL_ALERT_CLEARING_XREF X WHERE 1 = 1

              GROUP BY X.MASTER_ID, X.ALIAS_ID, X.XREF_ID, X.LIST_ID) SELECT

              X.SOURCE_TABLE, X.SOURCE_ID, X.LIST_ID, X.TO_STATE, X.NOTE,

              X.MASTER_ID, X.ALIAS_ID, X.XREF_ID, R.RELATIONSHIP_MASTER_ID FROM

              XWRL_ALERT_CLEARING_XREF X, XWRL_PARTY_XREF R, MAX_TAB WHERE 1 = 1 AND

              X.XREF_ID = R.ID AND X.MASTER_ID = MAX_TAB.MASTER_ID AND NVL

              (X.ALIAS_ID, -99) = NVL (MAX_TAB.ALIAS_ID, -99) AND NVL (X.XREF_ID,

              -99) = NVL (MAX_TAB.XREF_ID, -99) AND X.ID = MAX_TAB.ID) CLEAR WHERE

              COL.REQUEST_ID = R.ID AND R.MASTER_ID = CLEAR.RELATIONSHIP_MASTER_ID

              AND R.XREF_ID IS NULL AND R.ALIAS_ID IS NULL AND COL.LISTID =

              CLEAR.LIST_ID AND COL.REQUEST_ID = :B1;


update xwrl_requests 
set status = 'ERROR'
where batch_id = 80;


select id, name_screened, batch_id, department, department_ext, office, document_type
from xwrl_requests
order by id desc;

select id, name_screened, batch_id, department, department_ext, office, document_type
from xwrl_requests
where document_type is not null
order by id desc;



declare
cursor c1 is
select 'exec  fnd_stats.gather_table_stats('||chr(39)||owner||chr(39)||','||chr(39)||table_name||chr(39)||',100,NULL,NULL,'||chr(39)||'NOBACKUP'||chr(39)||',TRUE,'||chr(39)||'DEFAULT'||chr(39)||');' v_sql, table_name
from all_tables
where owner = 'XWRL'
order by table_name
;

begin

for c1rec in c1 loop
   execute immediate c1rec.v_sql;
   dbms_output.put_line('Gather statistics: '||c1rec.table_name);
end loop;

end;
/

/*

alter  trigger xwrl.XWRL_REQUESTS_INS_UPD enable;
alter  trigger xwrl.XWRL_REQUESTS_INS_UPD disable;
*/

select req.id, req.resubmit_id, req.batch_id, req.request, req.response, req.master_id, req.alias_id, req.xref_id, req.path, req.name_screened, req.case_id, req.matches, req.creation_date, req.last_update_date, status, req.job_id, req.error_message, req.created_by, req.last_updated_by
from xwrl_requests req                 
--where batch_id < 100
--where status = 'ERROR'
--where case_id is null
--where batch_id = 66640
order by req.id desc
;

update xwrl_requests
set status = 'ERROR'
where case_id is null;


select *
from xwrl_party_master 
where id in (589327, 589329);

select *
from xwrl_party_master 
where source_table = 'SICD_SEAFARERS'
and source_table_column = 'SEAFARER_ID'
and source_id = 1346804
;

select *
from fnd_user
where user_id = 9804;

select *
from xwrl_requests
where master_id  in (589327, 589329)
order by id desc;

select req.id, req.batch_id, req.request, req.response, req.master_id, req.alias_id, req.xref_id, req.path, req.name_screened, req.case_id, req.matches, req.edq_url, req.creation_date, req.last_update_date, status, req.job_id, req.error_message, req.created_by, req.last_updated_by
from xwrl_requests req             
--where status = 'ERROR'
--where batch_id < 100
--where id = 149972
--where batch_id = 62198
order by req.id desc
;


select req.id, req.batch_id, req.request, req.response, req.master_id, req.alias_id, req.xref_id, req.path, req.name_screened, req.case_id, req.matches, req.edq_url, req.creation_date, req.last_update_date, status, req.job_id, req.error_message, req.created_by, req.last_updated_by
from xwrl_requests req             
--where status = 'ERROR'
--where batch_id < 100
--where id = 149972
--where batch_id = 62198
where matches >= 500
and trunc(creation_date) >= to_date('04/26/2020','MM/DD/YYYY')
order by req.id desc
;

select req.id, req.batch_id, req.master_id, req.alias_id, req.xref_id, req.path, req.name_screened, req.case_id, req.matches, req.creation_date, req.last_update_date, status, req.job_id, req.error_message, req.created_by, req.last_updated_by
from xwrl_requests req             
--where status = 'ERROR'
--where batch_id < 100
--where id = 149972
--where batch_id = 62198
where matches >= 500
and trunc(creation_date) >= to_date('04/26/2020','MM/DD/YYYY')
order by req.id desc
;

select req.*
from xwrl_requests req             
where matches >= 500
and trunc(creation_date) >= to_date('04/26/2020','MM/DD/YYYY')
order by req.id desc
;


select req.id, req.batch_id, req.master_id, req.alias_id, req.xref_id, req.path, req.name_screened, req.case_id, req.matches, req.creation_date, req.last_update_date, status, req.job_id, req.error_message, req.created_by, fusr.user_name created_user, req.last_updated_by, fusr2.user_name update_user
from xwrl_requests req             
,fnd_user fusr
,fnd_user fusr2
where matches >= 500
and trunc(req.creation_date) >= to_date('04/26/2020','MM/DD/YYYY')
and req.created_by = fusr.user_id
and req.last_updated_by = fusr2.user_id
order by req.id desc
;

select count(*)
from xwrl_requests req             
--where status = 'ERROR'
--where batch_id < 100
--where id = 149972
--where batch_id = 62198
where matches >= 500
and trunc(creation_date) >= to_date('04/26/2020','MM/DD/YYYY')
order by req.id desc
;

select count(*)
from xwrl_requests req             
--where status = 'ERROR'
--where batch_id < 100
--where id = 149972
--where batch_id = 62198
where trunc(creation_date) >= to_date('04/26/2020','MM/DD/YYYY')
order by req.id desc
;

select round(avg(matches)) avg_matches
from xwrl_requests req             
--where status = 'ERROR'
--where batch_id < 100
--where id = 149972
--where batch_id = 62198
where matches < 500
and trunc(creation_date) >= to_date('04/26/2020','MM/DD/YYYY')
;

select round(avg(matches)) avg_matches
from xwrl_requests req             
--where status = 'ERROR'
--where batch_id < 100
--where id = 149972
--where batch_id = 62198
where trunc(creation_date) >= to_date('04/26/2020','MM/DD/YYYY')
;

select round(avg(matches)) avg_matches
from xwrl_requests req             
--where status = 'ERROR'
--where batch_id < 100
--where id = 149972
--where batch_id = 62198
where trunc(creation_date) >= to_date('04/26/2020','MM/DD/YYYY')
;


select *
from fnd_user
where user_id = 6806
;

rmi_ows_common_util;

xwrl_utils;

xwrl_data_processing;


select *
from xwrl_parameters
--where id like '%URL'
WHERE KEY = 'IRIDR'
;

SELECT *
FROM XWRL_PARAMETERS
WHERE KEY = 'IRIDROWS';

SELECT *
FROM XWRL_PARAMETERS
WHERE VALUE_STRING like 'http%';

SELECT *
FROM V$DATABASE;

RMI_OWS_COMMON_UTIL;

iri_sicd_online;

select *
from all_source
where lower(text) like '%xxiri_cm_process_pkg.update_alerts%'
;


RMI_OWS_COMMON_UTIL.close_ows_alert -- line 4889 // Needs to_state change
l_alert_in_tbl (1).to_state :=
            xwrl_ows_utils.changetoowsstate (   r_alert_rec.listrecordtype
                                             || ' - False Positive'
                                            );
RMI_OWS_COMMON_UTIL.sync_matches -- line 6966 // this is ok
RMI_OWS_COMMON_UTIL.sync_matches -- line 7119  // this is ok
RMI_OWS_COMMON_UTIL.update_alert_status_gender -- line 8119  // Needs to_state change
      l_alert_in_tbl (1).to_state :=
                               xwrl_ows_utils.changetoowsstate (p_alert_state);

Example:)
l_alert_in_tbl (1).to_state := xwrl_ows_utils.changetoowsstate(r_ind_cols.listrecordtype||l_to_state);



select *
from xwrl_parameters
where id = 'XML'
and key = 'REQUEST_INDIVIDUAL'
;

select *
from xwrl_parameters
where id = 'XML'
and key = 'REQUEST_ENTITY'
;

select *
from xwrl_parameters
where id = 'XML'
and key = 'REQUEST_ENTITY_COMPRESSED'
;

xwrl_utils;



declare

cursor c1 is
SELECT
   req.id
 , req.batch_id
 , req.master_id
 , req.alias_id
 , req.xref_id
 , req.path
 , req.name_screened
 , req.date_of_birth
 , req.gender
 ,req.passport_number
 , req.country_of_address
 , req.country_of_residence
 , req.country_of_nationality
 , req.country_of_birth
 , req.city_of_residence
 , req.city_of_residence_id
 --, mst.full_name
 --, mst.date_of_birth 
 , mst.passport_number m_passport_number
 , mst.passport_issuing_country_code m_pass_issuing_country_code
 , mst.citizenship_country_code m_citizenship_country_code
 , mst.country_of_residence m_country_of_residence
 , mst.city_of_residence_id m_city_of_residence_id
 , req.case_id
 , req.matches
 , req.creation_date
 , req.last_update_date
 , req.status
 , req.job_id
 , req.error_message
 , req.created_by
 , fusr.user_name     created_user
 , req.last_updated_by
 , fusr2.user_name    update_user
FROM
   xwrl_requests      req
 , fnd_user           fusr
 , fnd_user           fusr2
 , xwrl_party_master  mst
WHERE
       req.created_by = fusr.user_id
   AND req.last_updated_by = fusr2.user_id
   AND req.master_id = mst.id
--and matches >= 500
       AND req.creation_date between  TO_DATE ('05/06/2020 08:00:00', 'MM/DD/YYYY HH24:MI:SS') and TO_DATE ('05/06/2020 12:05:00', 'MM/DD/YYYY HH24:MI:SS')
   AND req.path = 'INDIVIDUAL'
   AND req.country_of_nationality IS  NULL
ORDER BY
   req.id DESC;
   
   begin
   
   for c1rec in c1 loop
   
   update xwrl_requests REQ
   set  req.passport_number = c1rec.m_passport_number
 , req.country_of_address = c1rec.m_pass_issuing_country_code
 , req.country_of_residence = c1rec.m_country_of_residence
 , req.country_of_nationality = c1rec.m_citizenship_country_code
 , req.country_of_birth = c1rec.m_citizenship_country_code
 , req.city_of_residence_id = c1rec.m_city_of_residence_id
 WHERE REQ.ID = C1REC.ID;
   
   end loop;
   
   commit;
   
   end;
   /
   
   select *
   from xwrl_parameters
   where key = 'DEBUG'
   --order by creation_date desc
   ;
   

                                 
                                SELECT count(*) --into v_key_count
                              FROM
                                 xwrl_parameters t,
                                 XMLTABLE(XMLNAMESPACES( 'http://schemas.xmlsoap.org/soap/envelope' as "soapenv", 'http://www.datanomic.com/ws' as "ws"),
                                 '//ws:*'
                                 PASSING t.value_xml
                                 COLUMNS key varchar2(2700) PATH 'name()'
                                 , value varchar2(2700) PATH 'text()'
                               ) x
                              WHERE
                                 t.id = 'XML'
                                 AND t.key = 'REQUEST_INDIVIDUAL_COMPRESSED'
                                 and x.key = :v_soap_key;
                                 
                                 
   select value_xml
   from xwrl_parameters
   WHERE     id = 'XML'
                                 AND key = 'REQUEST_INDIVIDUAL_COMPRESSED';                  
                                 
   select value_xml
   from xwrl_parameters
   WHERE     id = 'XML'
                                 AND key = 'REQUEST_ENTITY_COMPRESSED';                                        
                                 
                                 select *
                           from xwrl_parameters
   WHERE     id = 'XML'         ;
   
   SELECT value_string
   FROM xwrl_parameters
   WHERE id = 'XML'
   AND key = 'COMPRESSED_XML';
