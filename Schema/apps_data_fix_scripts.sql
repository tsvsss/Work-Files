/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_data_fix_scripts.sql 1.1 2019/11/15 12:00:00ET   IRI Exp                                          $*/
/********************************************************************************************************************
* Object Type         : Script                                                                                      *
* Name                :                                                                                             *
* Script Name         : apps_data_fix_scripts.sql                                                                   *
* Purpose             :                                                                                             *
*                                                                                                                   *
* Company             : International Registries, Inc.                                                              *
* Module              : Trade Compliance                                                                            *
* Created By          : TSUAZO                                                                                      *
* Created Date        : 11-NOV-2019                                                                                 *
* Last Reviewed By    :                                                                                             *
* Last Reviewed Date  :                                                                                             *
*********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
* Date        By               Script               By            Date         Type  Details                        *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ------------------------------*
* 15-NOV-2019 IRI              1.1                TSUAZO          15-NOV-2019  I      Trade Compliance              *
*                                                                                                                   *
********************************************************************************************************************/

/* Update Country Codes */

declare

cursor c1 is

select id
,passport_issuing_country_code
,citizenship_country_code
,country_of_residence
from xwrl_party_master
order by id desc;

v_pass_iss_country_code varchar2(10);
v_citizenship_country_code varchar2(10);
v_country_of_residence varchar2(10);

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

v_pass_iss_country_code := null;
v_citizenship_country_code := null;
v_country_of_residence := null;

begin
select iso_alpha2_code into v_pass_iss_country_code from sicd_countries where country_code = c1rec.passport_issuing_country_code;
exception when no_data_found then null; end;

begin
select iso_alpha2_code into v_citizenship_country_code from sicd_countries where country_code = c1rec.citizenship_country_code;
exception when no_data_found then null; end;

begin
select iso_alpha2_code into v_country_of_residence from sicd_countries where country_code = c1rec.country_of_residence;
exception when no_data_found then null; end;

 v_count := v_count + 1;

update xwrl_party_master
set passport_issuing_country_code = nvl(v_pass_iss_country_code,passport_issuing_country_code)
,citizenship_country_code =  nvl(v_citizenship_country_code,citizenship_country_code)
,country_of_residence =  nvl(v_country_of_residence,country_of_residence)
where id = c1rec.id;

      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/



declare

cursor c1 is

select id
,passport_issuing_country_code
,citizenship_country_code
,country_of_residence
from xwrl_party_alias
order by id desc;

v_pass_iss_country_code varchar2(10);
v_citizenship_country_code varchar2(10);
v_country_of_residence varchar2(10);

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

v_pass_iss_country_code := null;
v_citizenship_country_code := null;
v_country_of_residence := null;

begin
select iso_alpha2_code into v_pass_iss_country_code from sicd_countries where country_code = c1rec.passport_issuing_country_code;
exception when no_data_found then null; end;

begin
select iso_alpha2_code into v_citizenship_country_code from sicd_countries where country_code = c1rec.citizenship_country_code;
exception when no_data_found then null; end;

begin
select iso_alpha2_code into v_country_of_residence from sicd_countries where country_code = c1rec.country_of_residence;
exception when no_data_found then null; end;

 v_count := v_count + 1;

update xwrl_party_alias
set passport_issuing_country_code = nvl(v_pass_iss_country_code,passport_issuing_country_code)
,citizenship_country_code =  nvl(v_citizenship_country_code,citizenship_country_code)
,country_of_residence =  nvl(v_country_of_residence,country_of_residence)
where id = c1rec.id;

      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/

/* Verify Corporate Record with exact match on source and target name */

declare

cursor c1 is 
select id, status, state, entity_type, relationship_type, source_table, source_table_column, source_table_id, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, mst.full_name
, xwrl_data_processing.verify_master_fullname(mst.source_table, mst.source_table_column, mst.source_id) target_full_name
from xwrl_party_master mst
where  mst.entity_type = 'ORGANISATION'
and mst.source_table = 'CORP_MAIN'
and mst.source_table_column = 'CORP_ID')
WHERE REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(target_full_name), '[^0-9A-Za-z]', '') 
and state <> 'Verified'
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
      ,source_target_column = 'CORP_NAME1'
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/



/* Verify Customer Record  with exact match on source and target name */

declare

cursor c1 is 
select id, status, state, entity_type, relationship_type, source_table, source_table_column, source_table_id, customer_id, contact_id
--, full_name2
, job_title, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, mst.full_name
,ar.customer_id
,acv.CONTACT_ID
--,LTRIM(FIRST_NAME||' '||LAST_NAME) FULL_NAME2
, JOB_TITLE
, xwrl_data_processing.verify_master_fullname('AR_CONTACTS_V', 'CONTACT_ID', acv.CONTACT_ID) target_full_name
from xwrl_party_master mst
,AR_CUSTOMERS ar
,AR_CONTACTS_V acv
where  mst.source_id  = ar.customer_id
and ar.customer_id = acv.customer_id
and mst.entity_type = 'INDIVIDUAL'
and mst.source_table = 'AR_CUSTOMERS'
and mst.source_table_column = 'CUSTOMER_ID'
--and mst.source_id = 41568466
)
where REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(target_full_name), '[^0-9A-Za-z]', '') 
and state <> 'Verified'  
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,xref_source_table = 'AR_CONTACTS_V'
       ,xref_source_table_column = 'CONTACT_ID'
       ,xref_source_id = c1rec.contact_id
       ,note = c1rec.JOB_TITLE
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/

/* Verify Customer Record  with exact match on source and target name */

declare

cursor c1 is 
select id, status, state, entity_type, relationship_type, source_table, source_table_column, source_table_id, full_name, target_full_name, contact_id
from (select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, mst.full_name
,CA.CONTACT_ID
, xwrl_data_processing.verify_master_fullname('AR_CONTACTS_V', 'CONTACT_ID', CA.CONTACT_ID) target_full_name
from xwrl_party_master mst
,CORP_MAIN CM
,CORP_AGENTS CA
where  mst.source_id  = CM.CORP_ID
and CM.CORP_ID =  CA.MAIN_CORP_ID 
and CA.contact_id is not null
and mst.entity_type = 'INDIVIDUAL'
and mst.source_table = 'CORP_MAIN'
and mst.source_table_column = 'CORP_ID'
--and mst.source_id = 41568466
)
where REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(target_full_name), '[^0-9A-Za-z]', '') 
and state <> 'Verified'  
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,xref_source_table = 'AR_CONTACTS_V'
       ,xref_source_table_column = 'CONTACT_ID'
       ,xref_source_id = c1rec.contact_id
       --,note = c1rec.JOB_TITLE
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/


/* Verify Customer Record  with exact match on source and target name */

declare

cursor c1 is 
select id, status, state, entity_type, relationship_type, source_table, source_table_column, source_table_id, customer_id, contact_id
--, full_name2
, job_title, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, mst.full_name
,ar.customer_id
,acv.CONTACT_ID
--,LTRIM(FIRST_NAME||' '||LAST_NAME) FULL_NAME2
, JOB_TITLE
, xwrl_data_processing.verify_master_fullname('AR_CONTACTS_V', 'CONTACT_ID', acv.CONTACT_ID) target_full_name
from xwrl_party_master mst
,corp_main cm
,AR_CUSTOMERS ar
,AR_CONTACTS_V acv
where  mst.source_id  =  cm.corp_id
and cm.customer_id = ar.customer_id
and ar.customer_id = acv.customer_id
and mst.entity_type = 'INDIVIDUAL'
and mst.source_table = 'CORP_MAIN'
and mst.source_table_column = 'CORP_ID'
--and mst.source_id = 41568466
)
where REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(target_full_name), '[^0-9A-Za-z]', '') 
and state <> 'Verified'  
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,xref_source_table = 'AR_CONTACTS_V'
       ,xref_source_table_column = 'CONTACT_ID'
       ,xref_source_id = c1rec.contact_id
       ,note = c1rec.JOB_TITLE
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/



declare

cursor c1 is 
select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, mst.full_name
,cm.corp_id
,cm.customer_id corp_customer_id
,cm.current_agent corp_current_agent
--,cm.contact_id
,ar.customer_id
,av.CONTACT_ID
,av.job_title
,REGEXP_REPLACE(UPPER(ltrim(av.first_name||' '||av.last_name)), '[^0-9A-Za-z]', ' ')   contact_name
from xwrl_party_master mst
, corp_main cm
, AR_CONTACTS_V av
,AR_CUSTOMERS ar
WHERE cm.corp_id = mst.source_id
and REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', ' ') = REGEXP_REPLACE(UPPER(ltrim(av.first_name||' '||av.last_name)), '[^0-9A-Za-z]', ' ')  
AND av.customer_id = ar.customer_id
and mst.entity_type = 'INDIVIDUAL'
and mst.source_table = 'CORP_MAIN'
and mst.source_table_column = 'CORP_ID'
and substr(ar.customer_number,instr(ar.customer_number,'-',1)+1,length(ar.customer_number)) = 'CORP'
and mst.state <> 'Verified'  
--and mst.full_name = 'KURT PLANKL'
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,xref_source_table = 'AR_CONTACTS_V'
       ,xref_source_table_column = 'CONTACT_ID'
       ,xref_source_id = c1rec.contact_id
       ,note = c1rec.JOB_TITLE
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/

declare

cursor c1 is 
select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, mst.full_name
,cm.corp_id
,cm.customer_id corp_customer_id
,cm.current_agent corp_current_agent
--,cm.contact_id
,ar.customer_id
,av.CONTACT_ID
,av.job_title
,REGEXP_REPLACE(UPPER(ltrim(av.first_name||' '||av.last_name)), '[^0-9A-Za-z]', ' ')   contact_name
from xwrl_party_master mst
, corp_main cm
, AR_CONTACTS_V av
,AR_CUSTOMERS ar
WHERE cm.corp_id = mst.source_id
and REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', ' ') = REGEXP_REPLACE(UPPER(ltrim(av.first_name||' '||av.last_name)), '[^0-9A-Za-z]', ' ')  
AND av.customer_id = ar.customer_id
and mst.entity_type = 'INDIVIDUAL'
and mst.source_table = 'CORP_MAIN'
and mst.source_table_column = 'CORP_ID'
--and substr(ar.customer_number,instr(ar.customer_number,'-',1)+1,length(ar.customer_number)) = 'CORP'
and mst.state <> 'Verified'  
--and mst.full_name = 'KURT PLANKL'
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,xref_source_table = 'AR_CONTACTS_V'
       ,xref_source_table_column = 'CONTACT_ID'
       ,xref_source_id = c1rec.contact_id
       ,note = c1rec.JOB_TITLE
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/


declare

cursor c1 is 
select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, mst.full_name
--,cm.contact_id
,ar.customer_id
,av.CONTACT_ID
,av.job_title
,REGEXP_REPLACE(UPPER(ltrim(av.first_name||' '||av.last_name)), '[^0-9A-Za-z]', ' ')   contact_name
from xwrl_party_master mst
, AR_CONTACTS_V av
,AR_CUSTOMERS ar
WHERE  REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', ' ') = REGEXP_REPLACE(UPPER(ltrim(av.first_name||' '||av.last_name)), '[^0-9A-Za-z]', ' ')  
AND av.customer_id = ar.customer_id
and mst.entity_type = 'INDIVIDUAL'
and mst.source_table = 'CORP_MAIN'
and mst.source_table_column = 'CORP_ID'
--and substr(ar.customer_number,instr(ar.customer_number,'-',1)+1,length(ar.customer_number)) = 'CORP'
and mst.state <> 'Verified'  
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,xref_source_table = 'AR_CONTACTS_V'
       ,xref_source_table_column = 'CONTACT_ID'
       ,xref_source_id = c1rec.contact_id
       ,note = c1rec.JOB_TITLE
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/

declare

cursor c1 is 
select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, mst.full_name
,av.CONTACT_ID
,av.job_title
,REGEXP_REPLACE(UPPER(ltrim(av.first_name||' '||av.last_name)), '[^0-9A-Za-z]', ' ')   contact_name
from xwrl_party_master mst
, AR_CONTACTS_V av
WHERE  REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', ' ') = REGEXP_REPLACE(UPPER(ltrim(av.first_name||' '||av.last_name)), '[^0-9A-Za-z]', ' ')  
AND mst.entity_type = 'INDIVIDUAL'
--and substr(ar.customer_number,instr(ar.customer_number,'-',1)+1,length(ar.customer_number)) = 'CORP'
and mst.state <> 'Verified'  
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,xref_source_table = 'AR_CONTACTS_V'
       ,xref_source_table_column = 'CONTACT_ID'
       ,xref_source_id = c1rec.contact_id
       ,note = c1rec.JOB_TITLE
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/

declare

cursor c1 is 
select id, status, state, entity_type, relationship_type, source_table, source_table_column, source_table_id, customer_id, contact_id
--, full_name2
, job_title, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, mst.full_name
,ar.customer_id
,acv.CONTACT_ID
--,LTRIM(FIRST_NAME||' '||LAST_NAME) FULL_NAME2
, JOB_TITLE
, xwrl_data_processing.verify_master_fullname('AR_CONTACTS_V', 'CONTACT_ID', acv.CONTACT_ID) target_full_name
from xwrl_party_master mst
,corp_main cm
,AR_CUSTOMERS ar
,AR_CONTACTS_V acv
where  mst.source_id  =  cm.corp_id
and cm.current_agent = ar.customer_id
and ar.customer_id = acv.customer_id
and mst.entity_type = 'INDIVIDUAL'
and mst.source_table = 'CORP_MAIN'
and mst.source_table_column = 'CORP_ID'
--and mst.source_id = 41568466
)
where REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(target_full_name), '[^0-9A-Za-z]', '') 
and state <> 'Verified'  
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,xref_source_table = 'AR_CONTACTS_V'
       ,xref_source_table_column = 'CONTACT_ID'
       ,xref_source_id = c1rec.contact_id
       ,note = c1rec.JOB_TITLE
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/




/* Verify Corporate Record with exact match on source and target name */

declare

cursor c1 is 
select id, status, state, entity_type, relationship_type, source_table, source_table_column, source_table_id, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, mst.full_name
, xwrl_data_processing.verify_master_fullname(mst.source_table, mst.source_table_column, mst.source_id) target_full_name
from xwrl_party_master mst
where  mst.entity_type = 'ORGANISATION'
and mst.source_table = 'AR_CUSTOMERS'
and mst.source_table_column = 'CUSTOMER_ID')
where REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(target_full_name), '[^0-9A-Za-z]', '') 
and state <> 'Verified'
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,source_target_column = 'REGISTERED_OWNER_NAME'
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/

/* Verify Seaferer Record with exact match on source and target name */

declare

cursor c1 is 
select id, status, state, entity_type, relationship_type, source_table, source_table_column, source_table_id, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, mst.full_name
, xwrl_data_processing.verify_master_fullname(mst.source_table, mst.source_table_column, mst.source_id) target_full_name
from xwrl_party_master mst
where  mst.entity_type = 'INDIVIDUAL'
and mst.source_table = 'SICD_SEAFARERS'
and mst.source_table_column = 'SEAFARER_ID')
where REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(target_full_name), '[^0-9A-Za-z]', '') 
and state <> 'Verified'
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,source_target_column = 'FIRST_NAME LAST_NAME'
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/



/* Verify Seafarer Record  with exact match on source and target name */

declare

cursor c1 is 
select id, status, state, entity_type, relationship_type, source_table, source_table_column, source_table_id, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, mst.full_name
, xwrl_data_processing.verify_master_fullname('EXSICD_SEAFARERS_IFACE', 'SEAFARER_ID', mst.source_id) target_full_name
from xwrl_party_master mst
where  mst.entity_type = 'INDIVIDUAL'
and mst.source_table = 'SICD_SEAFARERS'
and mst.source_table_column = 'SEAFARER_ID'
)
where REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(target_full_name), '[^0-9A-Za-z]', '') 
and state <> 'Verified'
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,xref_source_table = 'EXSICD_SEAFARERS_IFACE'
       ,xref_source_table_column = 'SEAFARER_ID'
       ,xref_source_id = c1rec.source_table_id
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/

declare

cursor c1 is 
select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.full_name
, REGEXP_REPLACE(UPPER(ltrim(first_name||' '||last_name)), '[^0-9A-Za-z]', ' ') actual_name
from xwrl_party_master mst
, sicd_seafarers seaf
where seaf.seafarer_id = mst.source_id  
and mst.entity_type = 'INDIVIDUAL'
and mst.source_table = 'SICD_SEAFARERS'
and mst.source_table_column = 'SEAFARER_ID'
and mst.state = 'Migrated'
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,full_name = c1rec.actual_name
      ,note = 'Name converted from legacy request using Seafarer Id'
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/



declare

cursor c1 is 
select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.full_name
, REGEXP_REPLACE(UPPER(ltrim(first_name||' '||last_name)), '[^0-9A-Za-z]', ' ')  seaf_name
, mst.source_id
, seaf.seafarer_id
from xwrl_party_master mst
, sicd_seafarers seaf
WHERE REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(ltrim(first_name||' '||last_name)), '[^0-9A-Za-z]', '')  
AND mst.date_of_birth = TO_CHAR(seaf.BIRTH_DATE,'YYYYMMDD')
and mst.entity_type = 'INDIVIDUAL'
and mst.source_table = 'SICD_SEAFARERS'
and mst.source_table_column = 'SEAFARER_ID'
and mst.state = 'Migrated'
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
      ,xref_source_table = 'SICD_SEAFARERS'
       ,xref_source_table_column = 'SEAFARER_ID'
       ,xref_source_id = c1rec.seafarer_id
      ,note = 'Found with Name and Birth Date'
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/

/* Verify Vessel Record with exact match on source and target name */

declare

cursor c1 is 
select id, status, state, entity_type, relationship_type, source_table, source_table_column, source_table_id, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, mst.full_name
, xwrl_data_processing.verify_master_fullname(mst.source_table, mst.source_table_column, mst.source_id) target_full_name
from xwrl_party_master mst
where  mst.entity_type = 'VESSEL'
and mst.source_table = 'VSSL_VESSELS'
and mst.source_table_column = 'VESSEL_PK')
where REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(target_full_name), '[^0-9A-Za-z]', '') 
and state <> 'Verified'
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
      ,source_target_column = 'NAME'
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/

/************ REG11 ************************/

/* Verify REG11 Record with exact match on source and target name */

declare

cursor c1 is 
select id, status, state, entity_type, relationship_type, source_table, source_table_column, source_table_id, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, mst.full_name
, xwrl_data_processing.verify_master_fullname(mst.source_table, mst.source_table_column, mst.source_id, mst.entity_type,'CURRENT_NAME') target_full_name
from xwrl_party_master mst
--where  mst.entity_type = 'VESSEL'
where mst.source_table = 'REG11_HEADER'
and mst.source_table_column = 'REG11_HEADER_ID')
where REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(target_full_name), '[^0-9A-Za-z]', '') 
and state <> 'Verified'
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,source_target_column = 'CURRENT_NAME'
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/

/* Verify REG11 Record with exact match on source and target name */

declare

cursor c1 is 
select id, status, state, entity_type, relationship_type, source_table, source_table_column, source_table_id, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, mst.full_name
, xwrl_data_processing.verify_master_fullname(mst.source_table, mst.source_table_column, mst.source_id, mst.entity_type,'REG_NAME') target_full_name
from xwrl_party_master mst
---where  mst.entity_type = 'VESSEL'
where mst.source_table = 'REG11_HEADER'
and mst.source_table_column = 'REG11_HEADER_ID')
where REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(target_full_name), '[^0-9A-Za-z]', '') 
and state <> 'Verified'
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,source_target_column = 'REG_NAME'
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/

/* Verify REG11 Record with exact match on source and target name */

declare

cursor c1 is 
select id, status, state, entity_type, relationship_type, source_table, source_table_column, source_table_id, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, mst.full_name
, xwrl_data_processing.verify_master_fullname(mst.source_table, mst.source_table_column, mst.source_id, mst.entity_type,'REGISTERED_OWNER_NAME') target_full_name
from xwrl_party_master mst
--where  mst.entity_type = 'ORGANISATION'
where mst.source_table = 'REG11_HEADER'
and mst.source_table_column = 'REG11_HEADER_ID')
where REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(target_full_name), '[^0-9A-Za-z]', '') 
and state <> 'Verified'
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,source_target_column = 'REGISTERED_OWNER_NAME'
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/

/* Verify REG11 Record with exact match on source and target name */

declare

cursor c1 is 
select id, status, state, entity_type, relationship_type, source_table, source_table_column, source_table_id, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, UPPER(mst.full_name) full_name
, xwrl_data_processing.verify_master_fullname(mst.source_table, mst.source_table_column, mst.source_id, mst.entity_type,'BENEFICIAL_OWNER_NAME') target_full_name
from xwrl_party_master mst
--where  mst.entity_type = 'ORGANISATION'
where mst.source_table = 'REG11_HEADER'
and mst.source_table_column = 'REG11_HEADER_ID')
where REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(target_full_name), '[^0-9A-Za-z]', '') 
and state <> 'Verified'
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,source_target_column = 'BENEFICIAL_OWNER_NAME'
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/

/* Verify REG11 Record with exact match on source and target name */

declare

cursor c1 is 
select id, status, state, entity_type, relationship_type, source_table, source_table_column, source_table_id, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, UPPER(mst.full_name) full_name
, xwrl_data_processing.verify_master_fullname(mst.source_table, mst.source_table_column, mst.source_id, mst.entity_type,'ISM_MANAGER') target_full_name
from xwrl_party_master mst
--where  mst.entity_type = 'ORGANISATION'
where mst.source_table = 'REG11_HEADER'
and mst.source_table_column = 'REG11_HEADER_ID')
where REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(target_full_name), '[^0-9A-Za-z]', '') 
and state <> 'Verified'
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,source_target_column = 'ISM_MANAGER'
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/

declare

cursor c1 is 
select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id 
, mst.full_name
, wc.name_checked
, wc.status wc_status
, wc.notes
from xwrl_party_master mst
,reg11_world_check wc
where mst.source_id = wc.reg11_header_id
and REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(name_checked), '[^0-9A-Za-z]', '') 
and mst.state <> 'Verified';


v_count integer;
begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,source_target_column = 'REG11_WORLD_CHECK | '||c1rec.notes
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;
end;
/

/************ NRMI ************************/


/* Verify NRMI Record with exact match on source and target name */

declare

cursor c1 is 
select id, status, state, entity_type, relationship_type, source_table, source_table_column, source_table_id, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, UPPER(mst.full_name) full_name
, xwrl_data_processing.verify_master_fullname('NRMI_VESSELS_KNOWN_PARTY', mst.source_table_column, mst.source_id, mst.entity_type,'KP_NAME') target_full_name
from xwrl_party_master mst
--where  mst.entity_type = 'ORGANISATION'
where mst.source_table = 'NRMI_VESSELS_KNOWN_PARTY'
and mst.source_table_column = 'NRMI_KP_ID')
where REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(target_full_name), '[^0-9A-Za-z]', '') 
and state <> 'Verified'
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,source_target_column = 'KP_NAME'
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/

/* Verify NRMI Record with exact match on source and target name */

declare

cursor c1 is 
select id, status, state, entity_type, relationship_type, source_table, source_table_column, source_table_id, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, UPPER(mst.full_name) full_name
, xwrl_data_processing.verify_master_fullname(mst.source_table, mst.source_table_column, mst.source_id, mst.entity_type,'RQ_NAME') target_full_name
from xwrl_party_master mst
--where  mst.entity_type = 'ORGANISATION'
where mst.source_table = 'NRMI_CERTIFICATES'
and mst.source_table_column = 'NRMI_CERTIFICATES_ID')
where REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(target_full_name), '[^0-9A-Za-z]', '') 
and state <> 'Verified'
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,source_target_column = 'RQ_NAME'
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/


/* Verify NRMI Record with exact match on source and target name */

declare

cursor c1 is 
select id, status, state, entity_type, relationship_type, source_table, source_table_column, source_table_id, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, UPPER(mst.full_name) full_name
, xwrl_data_processing.verify_master_fullname(mst.source_table, mst.source_table_column, mst.source_id, mst.entity_type,'BT_CUSTOMER_NAME') target_full_name
from xwrl_party_master mst
--where  mst.entity_type = 'ORGANISATION'
where mst.source_table = 'NRMI_CERTIFICATES'
and mst.source_table_column = 'NRMI_CERTIFICATES_ID')
where REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(target_full_name), '[^0-9A-Za-z]', '') 
and state <> 'Verified'
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,source_target_column = 'BT_CUSTOMER_NAME'
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/

/* Verify NRMI Record with exact match on source and target name */

declare

cursor c1 is 
select id, status, state, entity_type, relationship_type, source_table, source_table_column, source_table_id, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, UPPER(mst.full_name) full_name
, xwrl_data_processing.verify_master_fullname('NRMI_CERTIFICATES_rq', mst.source_table_column, mst.source_id, mst.entity_type,'RQ_NAME') target_full_name
from xwrl_party_master mst
--where  mst.entity_type = 'ORGANISATION'
where mst.source_table = 'NRMI_CERTIFICATES_rq'
and mst.source_table_column = 'NRMI_CERTIFICATES_ID')
WHERE REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(target_full_name), '[^0-9A-Za-z]', '') 
and state <> 'Verified'
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,source_target_column = 'RQ_NAME'
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/


/* Verify NRMI Record with exact match on source and target name */

declare

cursor c1 is 
select id, status, state, entity_type, relationship_type, source_table, source_table_column, source_table_id, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, UPPER(mst.full_name) full_name
, xwrl_data_processing.verify_master_fullname('NRMI_CERTIFICATES_bt', mst.source_table_column, mst.source_id, mst.entity_type,'BT_CUSTOMER_NAME') target_full_name
from xwrl_party_master mst
--where  mst.entity_type = 'ORGANISATION'
where mst.source_table = 'NRMI_CERTIFICATES_bt'
and mst.source_table_column = 'NRMI_CERTIFICATES_ID')
WHERE REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(target_full_name), '[^0-9A-Za-z]', '') 
and state <> 'Verified'
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,source_target_column = 'BT_CUSTOMER_NAME'
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/

/* Verify NRMI Record with exact match on source and target name */

declare

cursor c1 is 
select id, status, state, entity_type, relationship_type, source_table, source_table_column, source_table_id, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, UPPER(mst.full_name) full_name
, xwrl_data_processing.verify_master_fullname('NRMI_VESSELS_reg_own', mst.source_table_column, mst.source_id, mst.entity_type,'VESSEL_NAME') target_full_name
from xwrl_party_master mst
--where  mst.entity_type = 'ORGANISATION'
where mst.source_table = 'NRMI_VESSELS_vssl'
and mst.source_table_column = 'NRMI_VESSELS_ID')
WHERE REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(target_full_name), '[^0-9A-Za-z]', '') 
and state <> 'Verified'
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,source_target_column = 'VESSEL_NAME'
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/

/* Verify NRMI Record with exact match on source and target name */

declare

cursor c1 is 
select id, status, state, entity_type, relationship_type, source_table, source_table_column, source_table_id, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, UPPER(mst.full_name) full_name
, xwrl_data_processing.verify_master_fullname('NRMI_VESSELS_reg_own', mst.source_table_column, mst.source_id, mst.entity_type,'REGISTERED_OWNER_NAME') target_full_name
from xwrl_party_master mst
--where  mst.entity_type = 'ORGANISATION'
where mst.source_table = 'NRMI_VESSELS_vssl'
and mst.source_table_column = 'NRMI_VESSELS_ID')
WHERE REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(target_full_name), '[^0-9A-Za-z]', '') 
and state <> 'Verified'
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,source_target_column = 'REGISTERED_OWNER_NAME'
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/

/* Verify NRMI Record with exact match on source and target name */

declare

cursor c1 is 
select id, status, state, entity_type, relationship_type, source_table, source_table_column, source_table_id, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, UPPER(mst.full_name) full_name
, xwrl_data_processing.verify_master_fullname('NRMI_VESSELS_reg_own', mst.source_table_column, mst.source_id, mst.entity_type,'ADDRESS_REG_OWN') target_full_name
from xwrl_party_master mst
--where  mst.entity_type = 'ORGANISATION'
where mst.source_table = 'NRMI_VESSELS_vssl'
and mst.source_table_column = 'NRMI_VESSELS_ID')
WHERE REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(target_full_name), '[^0-9A-Za-z]', '') 
and state <> 'Verified'
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,source_target_column = 'ADDRESS_REG_OWN'
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/

/* Verify NRMI Record with exact match on source and target name */

declare

cursor c1 is 
select id, status, state, entity_type, relationship_type, source_table, source_table_column, source_table_id, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, UPPER(mst.full_name) full_name
, xwrl_data_processing.verify_master_fullname('NRMI_VESSELS_reg_own', mst.source_table_column, mst.source_id, mst.entity_type,'VESSEL_NAME') target_full_name
from xwrl_party_master mst
--where  mst.entity_type = 'ORGANISATION'
where mst.source_table = 'NRMI_VESSELS_reg_own'
and mst.source_table_column = 'NRMI_VESSELS_ID')
WHERE REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(target_full_name), '[^0-9A-Za-z]', '') 
and state <> 'Verified'
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,source_target_column = 'VESSEL_NAME'
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/

/* Verify NRMI Record with exact match on source and target name */

declare

cursor c1 is 
select id, status, state, entity_type, relationship_type, source_table, source_table_column, source_table_id, full_name, target_full_name
from (select mst.id
, mst.relationship_type
, mst.state
, mst.status
, mst.entity_type
, mst.source_table
, mst.source_table_column
, mst.source_id source_table_id
, UPPER(mst.full_name) full_name
, xwrl_data_processing.verify_master_fullname('NRMI_VESSELS_reg_own', mst.source_table_column, mst.source_id, mst.entity_type,'REGISTERED_OWNER_NAME') target_full_name
from xwrl_party_master mst
--where  mst.entity_type = 'ORGANISATION'
where mst.source_table = 'NRMI_VESSELS_reg_own'
and mst.source_table_column = 'NRMI_VESSELS_ID')
WHERE REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(target_full_name), '[^0-9A-Za-z]', '') 
and state <> 'Verified'
;

v_count integer;

begin

v_count := 0;

for c1rec in c1 loop

     v_count := v_count + 1;
     
      update xwrl_party_master
      set state = 'Verified'
       ,source_target_column = 'REGISTERED_OWNER_NAME'
      where id = c1rec.id;
      
      if v_count = 1000 then
         commit;
      end if;

end loop;

commit;

end;
/

/* Verify NRMI Record with exact match on source and target name */
DECLARE
   CURSOR c1 IS
   SELECT
      id
      , status
      , state
      , entity_type
      , relationship_type
      , source_table
      , source_table_column
      , source_table_id
      , full_name
      , target_full_name
   FROM
      (
         SELECT
            mst.id
            , mst.relationship_type
            , mst.state
            , mst.status
            , mst.entity_type
            , mst.source_table
            , mst.source_table_column
            , mst.source_id source_table_id
            , upper (mst.full_name) full_name
            , xwrl_data_processing.verify_master_fullname ('NRMI_VESSELS_reg_own', mst.source_table_column, mst.source_id, mst.entity_type, 'ADDRESS_REG_OWN') target_full_name
         FROM
            xwrl_party_master mst
--where  mst.entity_type = 'ORGANISATION'
         WHERE
            mst.source_table = 'NRMI_VESSELS_reg_own'
            AND mst.source_table_column = 'NRMI_VESSELS_ID'
      )
where REGEXP_REPLACE(UPPER(full_name), '[^0-9A-Za-z]', '') = REGEXP_REPLACE(UPPER(target_full_name), '[^0-9A-Za-z]', '') 
      AND state <> 'Verified';
   v_count INTEGER;
BEGIN
   v_count := 0;
   FOR c1rec IN c1 LOOP
      v_count := v_count + 1;

      UPDATE xwrl_party_master
      SET
         state = 'Verified'
      , source_target_column = 'ADDRESS_REG_OWN'
      WHERE
         id = c1rec.id;

      IF v_count = 1000 THEN
         COMMIT;
      END IF;
   END LOOP;
   COMMIT;
END;
/

