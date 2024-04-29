--DEPARTMENTS

SELECT KEY AS OptionKey,VALUE_STRING AS OptionValue        
FROM XWRL_PARAMETERS        
WHERE ID = 'CASE_DEPARTMENTS'  
AND DISPLAY_FLAG = 'Y'
ORDER BY OptionValue;

--OFFICES

select salesrep_id, code AS OptionKey, description AS OptionValue
from vssl_offices  
where salesrep_id is not null  
and enable = 'Y'  
order by description;

--DOCUMENTS

SELECT CODE AS OptionKey,DESCRIPTION AS OptionValue        
FROM XWRL_DOCUMENT_REFERENCE        
ORDER BY SORT_KEY ASC;




select count(*)
from (select source_table, source_id, name_screened, count(*)
from xwrl_requests
where  source_table is not null
group by source_table, source_id,  name_screened
having count(*) > 1
order by 4 desc)
;

select *
from all_tables
;

ALTER TABLE xwrl.xwrl_response_ind_columns DISABLE ALL TRIGGERS;
ALTER TABLE xwrl.xwrl_response_entity_columns DISABLE ALL TRIGGERS;
ALTER TABLE xwrl.xwrl_response_rows DISABLE ALL TRIGGERS;
ALTER TABLE xwrl.xwrl_alert_documents DISABLE ALL TRIGGERS;
ALTER TABLE xwrl.xwrl_case_documents DISABLE ALL TRIGGERS;
ALTER TABLE xwrl.xwrl_request_ind_columns DISABLE ALL TRIGGERS;
ALTER TABLE xwrl.xwrl_request_entity_columns DISABLE ALL TRIGGERS;
ALTER TABLE xwrl.xwrl_request_rows DISABLE ALL TRIGGERS;
ALTER TABLE xwrl.xwrl_requests DISABLE ALL TRIGGERS;


declare
cursor c1 is
select source_table, source_id, name_screened, count(*)
from xwrl_requests
where  source_table is not null
group by source_table, source_id,  name_screened
having count(*) > 1
order by 4 desc;

cursor c2
(p_source_table varchar2
,p_source_id integer
,p_name_screened varchar2)
is 
select *
from xwrl_requests
where source_table = p_source_table
and source_id = p_source_id 
and  name_screened = p_name_screened;

v_id integer;


v_count integer ;
v_max integer;

begin

v_count := 0;
v_max := 1;

for c1rec in c1 loop

v_count := v_count + 1;

select max(id)
into v_id
from xwrl_requests 
where source_table = c1rec.source_table
and source_id = c1rec.source_id 
and name_screened = c1rec.name_screened;

for c2rec in c2 (c1rec.source_table, c1rec.source_id, c1rec.name_screened) loop

if c2rec.id <> v_id then

         DELETE from xwrl_response_ind_columns where request_id = c2rec.id;
         DELETE from xwrl_response_entity_columns where request_id = c2rec.id;
         DELETE xwrl_response_rows where request_id = c2rec.id;
         DELETE from xwrl_alert_documents where request_id = c2rec.id;
         DELETE from xwrl_case_documents where request_id = c2rec.id;
         DELETE from xwrl_request_ind_columns where request_id = c2rec.id;
         DELETE from xwrl_request_entity_columns where request_id = c2rec.id;
         DELETE from xwrl_request_rows where request_id = c2rec.id;
         DELETE from xwrl_requests where id = c2rec.id;

         commit;
end if;

end loop;

if v_count >= v_max then
   exit;
end if;

end loop;

end;
/

ALTER TABLE xwrl.xwrl_requests ENABLE ALL TRIGGERS;
ALTER TABLE xwrl.xwrl_response_ind_columns ENABLE ALL TRIGGERS;
ALTER TABLE xwrl.xwrl_response_entity_columns ENABLE ALL TRIGGERS;
ALTER TABLE xwrl.xwrl_response_rows ENABLE ALL TRIGGERS;
ALTER TABLE xwrl.xwrl_alert_documents ENABLE ALL TRIGGERS;
ALTER TABLE xwrl.xwrl_case_documents ENABLE ALL TRIGGERS;
ALTER TABLE xwrl.xwrl_request_ind_columns ENABLE ALL TRIGGERS;
ALTER TABLE xwrl.xwrl_request_entity_columns ENABLE ALL TRIGGERS;
ALTER TABLE xwrl.xwrl_request_rows ENABLE ALL TRIGGERS;

select *
from xwrl_requests
order by id;

select id,  batch_id, name_screened
from xwrl_requests
order by id desc
;

select *
from xwrl_parameters
where id = 'WIP_DEPARTMENT_NAMES'
;

select code, description
from xwrl_document_reference
;


SELECT ID, rmi_ows_common_util.get_department (ID) dept,
       rmi_ows_common_util.get_doc_type (ID) doc_type,
       rmi_ows_common_util. get_office(id) office
  FROM xwrl_requests
  WHERE SOURCE_TABLE = 'SICD_SEAFARERS'
  and rmi_ows_common_util.get_doc_type (ID) IS NOT NULL
  ;

SELECT rmi_ows_common_util.get_department (ID, 'CODE') deptcode,
       rmi_ows_common_util.get_department (ID) dept,
       rmi_ows_common_util.get_doc_type (ID) doc_type,
       rmi_ows_common_util.get_office (ID) office, source_id
  FROM xwrl_requests
  WHERE SOURCE_TABLE = 'SICD_SEAFARERS'
  and rmi_ows_common_util.get_doc_type (ID)  is not null
  ;
  
  select *
  from xwrl_requests;
  
  declare
  cursor c1 is
  SELECT rmi_ows_common_util.get_department (ID, 'CODE') deptcode,
       rmi_ows_common_util.get_department (ID) dept,
       rmi_ows_common_util.get_doc_type (ID) doc_type,
       rmi_ows_common_util.get_office (ID) office, source_id
  FROM xwrl_requests;
  
  begin
  
  for c1rec in c1 loop
  
        update xwrl_requests
        set department = c1rec.deptcode
        ,department_ext  = c1rec.doc_type
        where id = c1rec.id;
  
  end loop;
  
  end;
  /
  
  
  SELECT c.owner, c.table_name, c.constraint_name, c.constraint_type
   FROM all_constraints c, all_tables t
   WHERE c.table_name = t.table_name
   and lower(t.table_name) in ( 'xwrl_response_ind_columns','xwrl_response_entity_columns','xwrl_response_rows','xwrl_alert_documents','xwrl_case_documents','xwrl_request_ind_columns','xwrl_request_entity_columns' )
   AND c.status = 'ENABLED'
   AND NOT (t.iot_type IS NOT NULL AND c.constraint_type = 'P')
   ORDER BY decode(c.constraint_type,'P',1,'R'z DESC
   ;
   
   
   BEGIN
  FOR c IN
  (SELECT c.owner, c.table_name, c.constraint_name
   FROM all_constraints c, all_tables t
   WHERE c.table_name = t.table_name
   and lower(t.table_name) in ( 'xwrl_response_ind_columns','xwrl_response_entity_columns','xwrl_response_rows','xwrl_alert_documents','xwrl_case_documents','xwrl_request_ind_columns','xwrl_request_entity_columns' )
   AND c.status = 'DISABLED'
   ORDER BY c.constraint_type)
  LOOP
    dbms_utility.exec_ddl_statement('alter table "' || c.owner || '"."' || c.table_name || '" enable constraint ' || c.constraint_name);
  END LOOP;
END;
/


Wc_request_documents

select *
from all_objects
where object_name like  'XWRL\_%' escape '\'
and object_type <> 'SYNONYM'
AND OWNER = 'APPS'
order by 1
;

drop package apps.XWRL_DATA_PROCESSING;

BEGIN
FOR c IN
 (select owner, index_name
from all_indexes
where index_name like  'XWRL\_%' escape '\'
and owner = 'APPS')

LOOP
    dbms_utility.exec_ddl_statement('drop index ' || c.owner || '.' || c.index_name );
  END LOOP;
  END;
/




select count(*)
from (select source_table, source_id, name_screened, count(*)
from xwrl_requests
where  source_table is not null
group by source_table, source_id,  name_screened
having count(*) > 1
order by 4 desc)
;

select req.id, maxreq.max_id
from xwrl_requests req
,(select source_table, source_id, name_screened, count(*)
from xwrl_requests
where  source_table is not null
group by source_table, source_id,  name_screened
having count(*) > 1) dups
,(select max(id) max_id, source_table, source_id,  name_screened
from xwrl_requests 
group by source_table, source_id,  name_screened) maxreq
where req.source_table = dups.source_table
and req.source_id = dups.source_id
and req.name_screened = dups.name_screened
and req.source_table = maxreq.source_table
and req.source_id = maxreq.source_id
and req.name_screened = maxreq.name_screened
and req.id <> max_id
;

  SELECT rmi_ows_common_util.get_department (ID, 'CODE') deptcode,
       rmi_ows_common_util.get_department (ID) dept,
       rmi_ows_common_util.get_doc_type (ID) doc_type,
       rmi_ows_common_util.get_office (ID) office, source_id
  FROM xwrl_requests;

select salesrep_id, code AS OptionKey, description AS OptionValue
from vssl_offices  
where salesrep_id is not null  
and enable = 'Y'  
order by description;


select *
from xwrl_case_documents
;

select *
from xwrl_alert_documents
;


SELECT rmi_ows_common_util.get_department (ID, 'CODE') deptcode,
       rmi_ows_common_util.get_department (ID) dept,
              rmi_ows_common_util.get_office (ID, 'CODE') officecode,
      rmi_ows_common_util.get_office (ID) office,
rmi_ows_common_util.get_doc_type (ID) doc_type,
       req.source_id
  FROM xwrl_requests req
      ;


declare
  cursor c1 is
SELECT rmi_ows_common_util.get_department (ID, 'CODE') deptcode,
       rmi_ows_common_util.get_department (ID) dept,
       rmi_ows_common_util.get_doc_type (ID) doc_type,
       rmi_ows_common_util.get_office (ID) office,
       rmi_ows_common_util.get_office (ID, 'CODE') officecode,
       office.optionkey,
       req.source_id,
       req.id
  FROM xwrl_requests req
  ,(select salesrep_id, code AS OptionKey, description AS OptionValue
      from vssl_offices  
      where salesrep_id is not null  
      and enable = 'Y'  )  office
      where rmi_ows_common_util.get_office (req.ID)  = office.optionvalue (+);
  
  v_count integer := 0;
  
  begin
  
  
  for c1rec in c1 loop
  
         v_count := v_count + 1;
  
        update xwrl_requests
        set department = c1rec.deptcode
        ,department_ext  = c1rec.doc_type
        ,office = c1rec.optionkey
        where id = c1rec.id;
        
        if v_count >= 1000 then
            commit;
            v_count := 0;
        end if;
  
  end loop;
  
  commit;
  
  end;
  /
  
  
  
  select *
  from xwrl_requests
  where batch_id = 119305
  ;
  
  
  select *
  from xwrl_party_master
  where source_table = 'SICD_SEAFARERS'
  and source_id = 1271679
  ;
  
  select *
  from wc_screening_request
  where wc_screening_request_id = 860908
  ;
  
  select unique status
  from wc_screening_request
  --where wc_screening_request_id = 860908
  ;
  
select req.id, req.source_table, req.source_id, req.name_screened, mst.full_name, mst.created_by, nvl(mst.last_updated_by,mst.created_by) last_updated_by
from xwrl_requests req
,xwrl_party_master mst
where req.source_table = mst.source_table
and req.source_id = mst.source_id
and req.name_screened = mst.full_name
and mst.state not like 'Delete%'
order by id
;

select *
from wc_screening_request
WHERE requires_legal_approval IS NULL
;

select *
from xwrl_party_master
;

   select B.VALUE_STRING WORK_FLOW,  A.CASE_STATUS, COUNT(*) RECORD_COUNT
   from xwrl_requests A
   , ( select KEY, VALUE_STRING
   from xwrl_parameters
   where ID = 'CASE_WORK_FLOW') B
   WHERE A.case_workflow = B.KEY
   AND A.CASE_STATUS = 'O'
   group by B.VALUE_STRING, A.CASE_STATUS
   ORDER BY 2 DESC;

SELECT COUNT(*)
FROM XWRL_REQUESTS
WHERE case_workflow = 'L'
AND MATCHES = 0
;   
   
SELECT *
FROM XWRL_REQUESTS
WHERE case_workflow = 'L'
AND MATCHES = 0
;


select * 
from XWRL_REQUESTS
where case_workflow = 'L'
;
SELECT *
FROM wc_screening_request
WHERE requires_legal_approval is not null
and status <> 'Approved'
;

SELECT  status, count(*)
FROM wc_screening_request
WHERE requires_legal_approval is NULL
group by status
;


SELECT  status, count(*)
FROM wc_screening_request
WHERE requires_legal_approval = 'N'
group by status
;


SELECT  status, count(*)
FROM wc_screening_request
WHERE requires_legal_approval is NULL
group by status
;


SELECT  status, count(*)
FROM wc_screening_request
WHERE requires_legal_approval = 'N'
and status in ('Pending','Provisional')
group by status
;

 select  xmst.id
   , xmst.state
   , xmst.source_table
   , xmst.source_table_column
   , xmst.source_id   
   , xmst.wc_screening_request_id
   from (select mst.id
   , mst.state
   , mst.source_table 
   , mst.source_table_column 
   , mst.source_id 
   , mst.wc_screening_request_id
   , mst.source_table||mst.source_id source_key
   from xwrl_party_master mst ) xmst
   ,(select req.id,  req.source_table, req.source_id, req.wc_screening_request_id, req.source_table||req.source_id source_key
   from xwrl_requests req) xreq
   where xmst.source_key = xreq.source_key (+) 
   and xmst.state not like 'Delete%'
   and xreq.source_key is null
   --and rownum <= p_row_num
   order by xmst.wc_screening_request_id desc
   
;



   


SELECT  status, count(*)
FROM wc_screening_request
WHERE requires_legal_approval is NULL
and status in ('Legal Review','Sr. Legal Review')
group by status
;

select *
from WORLDCHECK_EXTERNAL_XREF
;

select *
from xwrl_requests
;

select unique req.wc_screening_request_id, req.status, req.name_screened, xref.source_table, xref.source_table_column, xref.source_table_id
from wc_screening_request req
,WORLDCHECK_EXTERNAL_XREF xref
,xwrl_requests xr
WHERE req.wc_screening_request_id = xref.wc_screening_request_id
and req.wc_screening_request_id = xr.wc_screening_request_id (+)
and req.requires_legal_approval is NULL
and req.status in ('Legal Review','Sr. Legal Review')
and xr.wc_screening_request_id is null
order by req.wc_screening_request_id
;


/*    General Users   */

select count(*)
from (select unique req.wc_screening_request_id, req.status, req.name_screened, xref.source_table, xref.source_table_column, xref.source_table_id
from wc_screening_request req
,WORLDCHECK_EXTERNAL_XREF xref
,xwrl_requests xr
WHERE req.wc_screening_request_id = xref.wc_screening_request_id
and req.wc_screening_request_id = xr.wc_screening_request_id (+)
and req.requires_legal_approval = 'N'
and req.status in ('Pending','Provisional')
and xr.wc_screening_request_id is null
order by req.wc_screening_request_id);

select unique req.wc_screening_request_id, req.status, req.name_screened, xref.source_table, xref.source_table_column, xref.source_table_id
from wc_screening_request req
,WORLDCHECK_EXTERNAL_XREF xref
,xwrl_requests xr
WHERE req.wc_screening_request_id = xref.wc_screening_request_id
and req.wc_screening_request_id = xr.wc_screening_request_id (+)
and req.requires_legal_approval = 'N'
and req.status in ('Pending','Provisional')
and xr.wc_screening_request_id is null
order by req.wc_screening_request_id
;


/*    Legal Review   */

select count(*)
from (select unique req.wc_screening_request_id, req.status, req.name_screened, xref.source_table, xref.source_table_column, xref.source_table_id
from wc_screening_request req
,WORLDCHECK_EXTERNAL_XREF xref
,xwrl_requests xr
WHERE req.wc_screening_request_id = xref.wc_screening_request_id
and req.wc_screening_request_id = xr.wc_screening_request_id (+)
and req.requires_legal_approval is NULL
and req.status in ('Legal Review','Sr. Legal Review')
and xr.wc_screening_request_id is null
order by req.wc_screening_request_id);


select unique req.wc_screening_request_id, req.status, req.name_screened, xref.source_table, xref.source_table_column, xref.source_table_id
from wc_screening_request req
,WORLDCHECK_EXTERNAL_XREF xref
,xwrl_requests xr
WHERE req.wc_screening_request_id = xref.wc_screening_request_id
and req.wc_screening_request_id = xr.wc_screening_request_id (+)
and req.requires_legal_approval is NULL
and req.status in ('Legal Review','Sr. Legal Review')
and xr.wc_screening_request_id is null
order by req.wc_screening_request_id
;




  select *
  from xwrl_requests
  where case_id = 'OWS-201911-271201-361809-IND'
  ;
  
  select *
  from xwrl_response_ind_columns
  where request_id = 1128
  -- 1127
  -- 1128
  ;
  
  select *
  from wc_screening_request
  where wc_screening_request_id in ( 919987)
  ;
  
  SELECT *
  FROM WORLDCHECK_EXTERNAL_XREF
   where wc_screening_request_id in ( 919987);
  
  
  select case_id, count(*)
from xwrl_requests
group by case_id
having count(*) > 1;



select *
from xwrl_requests 
where case_id = 'OWS-201911-271459-D61D06-IND';


select MAX( req.wc_screening_request_id) wc_screening_request_id,  xref.source_table, xref.source_table_column, xref.source_table_id
from wc_screening_request req
,WORLDCHECK_EXTERNAL_XREF xref
,xwrl_requests xr
WHERE req.wc_screening_request_id = xref.wc_screening_request_id
and req.wc_screening_request_id = xr.wc_screening_request_id (+)
and req.requires_legal_approval is NULL
and req.status in ('Legal Review','Sr. Legal Review')
and xr.wc_screening_request_id is null
GROUP BY xref.source_table, xref.source_table_column, xref.source_table_id
order by 1
;

-- xwrl_alert_clearing_xref_uk

select *
from all_constraints
where constraint_name = 'XWRL_ALERT_CLEARING_XREF_UK'
;

SELECT *
FROM xwrl_alert_clearing_xref;

select count(*)
from xwrl_party_master
where xref_source_table is not null
;

select *
from xwrl_party_master
where source_table = 'AR_CUSTOMERS'
and source_id = 21851
;

select *
from ar_customers
where customer_id = 21851 --   3106-CORP     NEXLAW MARITIME LEGAL CONSULTANCY (Registered with
;


select *
from xwrl_party_master
where id = 1434
;

select *
from xwrl_party_alias
--where master_id = 1434
;

select *
from wc_screening_request
where name_screened like '%NEXLAW MARITIME LEGAL CONSULTANCY%'
;

SELECT *
from XWRL_PARTY_MASTER
WHERE WC_SCREENING_REQUEST_ID = 479645
;


select *
from wc_screening_request
WHERE WC_SCREENING_REQUEST_ID = 479645
;

SELECT *
FROM WORLDCHECK_EXTERNAL_XREF
WHERE WC_SCREENING_REQUEST_ID = 479645
;

SELECT *
FROM WORLDCHECK_EXTERNAL_XREF
WHERE WORLDCHECK_EXTERNAL_XREF_ID = 479645 -- SICD_SEAFARERS	570222	SEAFARER_ID
;



select *
from wc_screening_request
WHERE WC_SCREENING_REQUEST_ID = 555596   ---   CORP_MAIN CORP_ID	1014746	
;


SELECT *
FROM CORP_MAIN
WHERE CORP_ID IN (1014746,1093569,1104413)
;


select name_screened, date_of_birth,  country_of_residence, matches
from xwrl_requests
where path = 'INDIVIDUAL'
and matches >= 100
;


   select MAX( req.wc_screening_request_id) wc_screening_request_id,  xref.source_table, xref.source_table_column, xref.source_table_id
   from wc_screening_request req
   ,WORLDCHECK_EXTERNAL_XREF xref
   ,xwrl_requests xr
   WHERE req.wc_screening_request_id = xref.wc_screening_request_id
   and req.wc_screening_request_id = xr.wc_screening_request_id (+)
   and req.requires_legal_approval is NULL
   and req.status in ('Legal Review','Sr. Legal Review')
   and xr.wc_screening_request_id is null
   GROUP BY xref.source_table, xref.source_table_column, xref.source_table_id
   having count(*) > 1;

   with xr as (select x.source_table, x.source_id, x.source_table||x.source_id source_key
   from xwrl_requests x)
   select xref.source_table, xref.source_table_column, xref.source_table_id, xref.source_table|| xref.source_table_id source_key
   from wc_screening_request req
   ,WORLDCHECK_EXTERNAL_XREF xref
   , xr
   WHERE req.wc_screening_request_id = xref.wc_screening_request_id
   and xref.source_table|| xref.source_table_id = xr.source_key (+)
   --and req.status in ('Legal Review','Sr. Legal Review')
   -- and req.requires_legal_approval is NULL
   and req.status in ('Pending','Provisional')
   and req.requires_legal_approval = 'N'
   and xr.source_key is null
   GROUP BY xref.source_table, xref.source_table_column, xref.source_table_id, xref.source_table|| xref.source_table_id 
   order by 1;   


   select xref.source_table, xref.source_table_column, xref.source_table_id, xref.source_table|| xref.source_table_id source_key
   from wc_screening_request req
   ,WORLDCHECK_EXTERNAL_XREF xref
   WHERE req.wc_screening_request_id = xref.wc_screening_request_id
   and req.requires_legal_approval is NULL
   and req.status in ('Legal Review','Sr. Legal Review')
   GROUP BY xref.source_table, xref.source_table_column, xref.source_table_id, xref.source_table|| xref.source_table_id 
   order by 1;
   
select count(*)
from (
   with xr as (select x.source_table, x.source_id, x.source_table||x.source_id source_key
   from xwrl_requests x)
   select xref.source_table, xref.source_table_column, xref.source_table_id, xref.source_table|| xref.source_table_id source_key
   from wc_screening_request req
   ,WORLDCHECK_EXTERNAL_XREF xref
   , xr
   WHERE req.wc_screening_request_id = xref.wc_screening_request_id
   and xref.source_table|| xref.source_table_id = xr.source_key (+)
   and req.status in ('Legal Review','Sr. Legal Review')
   and req.requires_legal_approval is NULL
   --and req.status in ('Pending','Provisional')
   --and req.requires_legal_approval = 'N'
   and xr.source_key is null
   and xref.source_table_id is not null
   GROUP BY xref.source_table, xref.source_table_column, xref.source_table_id, xref.source_table|| xref.source_table_id 
);

select count(*)
from (
   with xr as (select x.source_table, x.source_id, x.source_table||x.source_id source_key
   from xwrl_requests x)
   select xref.source_table, xref.source_table_column, xref.source_table_id, xref.source_table|| xref.source_table_id source_key
   from wc_screening_request req
   ,WORLDCHECK_EXTERNAL_XREF xref
   , xr
   WHERE req.wc_screening_request_id = xref.wc_screening_request_id
   and xref.source_table|| xref.source_table_id = xr.source_key (+)
   --and req.status in ('Legal Review','Sr. Legal Review')
   --and req.requires_legal_approval is NULL
   and req.status in ('Pending','Provisional')
   and req.requires_legal_approval = 'N'
   and xr.source_key is null
   and xref.source_table_id is not null
   GROUP BY xref.source_table, xref.source_table_column, xref.source_table_id, xref.source_table|| xref.source_table_id 
);


   with xr as (select x.source_table, x.source_id, x.source_table||x.source_id source_key
   from xwrl_requests x)
   select xref.source_table, xref.source_table_column, xref.source_table_id, xref.source_table|| xref.source_table_id source_key
   from wc_screening_request req
   ,WORLDCHECK_EXTERNAL_XREF xref
   , xr
   WHERE req.wc_screening_request_id = xref.wc_screening_request_id
   and xref.source_table|| xref.source_table_id = xr.source_key (+)
   and req.requires_legal_approval is NULL
   and req.status in ('Legal Review','Sr. Legal Review')
   and xr.source_key is null
   GROUP BY xref.source_table, xref.source_table_column, xref.source_table_id, xref.source_table|| xref.source_table_id 
   order by 1;
   
   with xr as (select x.source_table, x.source_id, x.source_table||x.source_id source_key
   from xwrl_requests x)
   select xref.source_table, xref.source_table_column, xref.source_table_id, xref.source_table|| xref.source_table_id source_key
   from wc_screening_request req
   ,WORLDCHECK_EXTERNAL_XREF xref
   , xr
   WHERE req.wc_screening_request_id = xref.wc_screening_request_id
   and xref.source_table|| xref.source_table_id = xr.source_key (+)
   and req.status in ('Legal Review','Sr. Legal Review')
   and req.requires_legal_approval is NULL
   --and req.status in ('Pending','Provisional')
   --and req.requires_legal_approval = 'N'
   and xr.source_key is null
   and xref.source_table_id is not null
   GROUP BY xref.source_table, xref.source_table_column, xref.source_table_id, xref.source_table|| xref.source_table_id 
   order by 1;   
 
   
   select *
   from xwrl_document_reference
   where department = 'SICD'
   ORDER BY SORT_KEY
   ;
   
   DELETE FROM xwrl_document_reference
   where ID=138;
   
   UPDATE xwrl_document_reference
   SET PRIORITY_LEVEL = 'Medium'
   where id = 136;
   
   update xwrl_document_reference
   set sort_key = sort_key * 10
   where  department = 'SICD';
   
   UPDATE xwrl_document_reference
   set sort_key = 1405
   where id = 136;
   
   rmi_ows_common_util
   
   select corp_number
   from corp_main
   where corp_id = 1102168;
   
   select *
   from xwrl_requests;
   
  SELECT rmi_ows_common_util.get_department (req.ID, 'CODE') deptcode,
       rmi_ows_common_util.get_department (req.ID) dept_ext,
       rmi_ows_common_util.get_doc_type (req.ID) doc_type,
       rmi_ows_common_util.get_office (req.ID) office,
       office.optionkey,
       req.source_id,
       req.id
  FROM xwrl_requests req
  ,(select salesrep_id, code AS OptionKey, description AS OptionValue
      from vssl_offices  
      where salesrep_id is not null  
      and enable = 'Y'  )  office
      where rmi_ows_common_util.get_office (req.ID)  = office.optionvalue (+)
        AND department = 'CORP'
      ;   
   
   
   declare
  cursor c1 is
  SELECT rmi_ows_common_util.get_department (req.ID, 'CODE') deptcode,
       rmi_ows_common_util.get_department (req.ID) dept_ext,
       rmi_ows_common_util.get_doc_type (req.ID) doc_type,
       rmi_ows_common_util.get_office (req.ID) office,
       office.optionkey,
       req.source_id,
       req.id
  FROM xwrl_requests req
  ,(select salesrep_id, code AS OptionKey, description AS OptionValue
      from vssl_offices  
      where salesrep_id is not null  
      and enable = 'Y'  )  office
      where rmi_ows_common_util.get_office (req.ID)  = office.optionvalue (+);
  
  v_count integer := 0;
  
  begin
  
  for c1rec in c1 loop
  
         v_count := v_count + 1;
  
        update xwrl_requests
        set department = c1rec.deptcode
        ,department_ext  = c1rec.dept_ext
        ,office = c1rec.optionkey
        where id = c1rec.id;
        
        if v_count >= 1000 then
            commit;
            v_count := 0;
        end if;
  
  end loop;
  
  commit;
  
  end;
  /
  
  
  
  declare
cursor c1 is 
select req.id, req.source_table, req.source_id, req.name_screened, mst.full_name, mst.created_by, nvl(mst.last_updated_by,mst.created_by) last_updated_by, mst.creation_date, mst.last_update_date
from xwrl_requests req
,xwrl_party_master mst
where req.source_table = mst.source_table
and req.source_id = mst.source_id
--and req.name_screened = mst.full_name
--and mst.state not like 'Delete%'
--and req.created_by is null
order by mst.created_by nulls first, id
;

  v_count integer := 0;

begin

for c1rec in c1 loop

         v_count := v_count + 1;
  
        update xwrl_requests
        set created_by = c1rec.created_by
        ,last_updated_by = c1rec.last_updated_by
        ,creation_date = c1rec.creation_date
        ,last_update_date = c1rec.last_update_date
        where id = c1rec.id;
        
        if v_count >= 1000 then
            commit;
            v_count := 0;
        end if;
  
  end loop;
  
  commit;
  
  end;
/



SELECT *
              FROM xwrl_parameters
             WHERE ID = 'CASE_DEPARTMENTS'
               AND display_flag = 'Y';
               
               
               
select *
from xwrl_parameters
where id = 'CASE_ASSIGNMENT'
;

delete from  xwrl_parameters
where id = 'CASE_ASSIGNMENT'
and value_string in ('TSUAZO','ZKHAN','LWAN','VTONDAPU','GVELLA');


update xwrl_parameters
set creation_date = sysdate
,last_update_date = sysdate
,created_by = 1156
,last_updated_by = 1156
;


select *
from xwrl_document_reference
;


update xwrl_document_reference
set creation_date = sysdate
,last_update_date = sysdate
,created_by = 1156
,last_updated_by = 1156
;


select *
from xwrl_note_templates
;


update xwrl_note_templates
set creation_date = sysdate
,last_update_date = sysdate
,created_by = 1156
,last_updated_by = 1156
;




 select xref.source_table, xref.source_table_column, xref.source_table_id, xref.source_table|| xref.source_table_id source_key, max(req.wc_screening_request_id) wc_screening_request_id
   from wc_screening_request req
   ,WORLDCHECK_EXTERNAL_XREF xref
   WHERE req.wc_screening_request_id = xref.wc_screening_request_id
   group by xref.source_table, xref.source_table_column, xref.source_table_id, xref.source_table|| xref.source_table_id 
   ;



declare
cursor c1 is 
select req.id, req.source_table, req.source_id, req.name_screened, mst.full_name, mst.created_by, nvl(mst.last_updated_by,mst.created_by) last_updated_by, mst.creation_date, mst.last_update_date
from xwrl_requests req
,xwrl_party_master mst
where req.source_table = mst.source_table
and req.source_id = mst.source_id
--and req.name_screened = mst.full_name
--and mst.state not like 'Delete%'
--and req.created_by is null
order by mst.created_by nulls first, id
;

  v_count integer := 0;

begin

for c1rec in c1 loop

         v_count := v_count + 1;
  
        update xwrl_requests
        set created_by = c1rec.created_by
        ,last_updated_by = c1rec.last_updated_by
        ,creation_date = c1rec.creation_date
        ,last_update_date = c1rec.last_update_date
        where id = c1rec.id;
        
        if v_count >= 1000 then
            commit;
            v_count := 0;
        end if;
  
  end loop;
  
  commit;
  
  end;
/


select *
from xwrl_requests
where batch_id = 1748;

select *
from xwrl_response_entity_columns
where  request_id in (3015, 3023, 3041)
;

select *
from mt_log
where notes like ('%To State%')
order by 1 desc
;

select *
from xwrl_audit_log
where table_name = 'XWRL_RESPONSE_ENTITY_COLUMNS'
and table_id = 3288
;

select *
from xwrl_audit_log
where table_name = 'XWRL_ALERT_NOTES'

;

select * from xwrl_alert_notes
where alert_id = 'SEN-9691045'
;

select *
from xwrl_alert_clearing_xref
where source_table = 'CORP_MAIN'
and source_id = 1083222
order by creation_date
;


select *
from xwrl_response_ind_columns
where id = 4827;
;

select *
from xwrl_response_entity_columns
;

alter table xwrl.xwrl_response_ind_columns disable all triggers;

alter table xwrl.xwrl_response_entity_columns disable all triggers;

alter table xwrl.xwrl_response_ind_columns enable all triggers;

alter table xwrl.xwrl_response_entity_columns enable all triggers;


update xwrl_response_ind_columns
set x_state = xwrl_ows_utils.ChangeOwsState(x_state)
;

update xwrl_response_entity_columns
set x_state = xwrl_ows_utils.ChangeOwsState(x_state)
;

-- ENTITY

WITH ows_req as 
(select EXTERNAL_ID, CURRENT_STATE from IRIP1_EDQCONFIG.dn_case@ebstoows2.coresys.com 
UNION
select EXTERNAL_ID, CURRENT_STATE  from IRIP2_EDQCONFIG.dn_case@ebstoows2.coresys.com)
select id, x_state, current_state, alertid, listrecordtype
from xwrl_response_entity_columns col
,ows_req
where col.alertid = ows_req.EXTERNAL_ID
and col.x_state <> xwrl_ows_utils.changeowsstate(CURRENT_STATE);

WITH ows_req as 
(select EXTERNAL_ID, CURRENT_STATE from iridr_edqconfig.dn_case@ebstoows2.coresys.com 
UNION
select EXTERNAL_ID, CURRENT_STATE  from iridr2_edqconfig.dn_case@ebstoows2.coresys.com)
select id, x_state, current_state, alertid, listrecordtype
from xwrl_response_entity_columns col
,ows_req
where col.alertid = ows_req.EXTERNAL_ID
and col.x_state <> xwrl_ows_utils.changeowsstate(CURRENT_STATE);


xwrl_ows_utils

-- INDIVIDUAL

WITH ows_req as 
(select EXTERNAL_ID, CURRENT_STATE from IRIP1_EDQCONFIG.dn_case@ebstoows2.coresys.com 
UNION
select EXTERNAL_ID, CURRENT_STATE  from IRIP2_EDQCONFIG.dn_case@ebstoows2.coresys.com)
select id, x_state, current_state, alertid, listrecordtype
from xwrl_response_ind_columns col
,ows_req
where col.alertid = ows_req.EXTERNAL_ID
and col.x_state <> xwrl_ows_utils.changeowsstate(CURRENT_STATE);

WITH ows_req as 
(select EXTERNAL_ID, CURRENT_STATE from iridr_edqconfig.dn_case@ebstoows2.coresys.com 
UNION
select EXTERNAL_ID, CURRENT_STATE  from iridr2_edqconfig.dn_case@ebstoows2.coresys.com)
select id, x_state, current_state, alertid, listrecordtype
from xwrl_response_ind_columns col
,ows_req
where col.alertid = ows_req.EXTERNAL_ID
and col.x_state <> xwrl_ows_utils.changeowsstate(CURRENT_STATE);




SELECT *
FROM XWRL_PARAMETERS
WHERE ID = 'CASE_WORK_FLOW'
;

SELECT *
FROM ALL_TRIGGERS
WHERE TRIGGER_NAME LIKE 'XWRL\_%' ESCAPE '\'
AND STATUS  <> 'ENABLED'
;

ALTER TABLE XWRL.xwrl_requests DISABLE ALL TRIGGERS;

ALTER TABLE XWRL.xwrl_requests ENABLE ALL TRIGGERS;

select *
from xwrl_requests
where case_workflow = 'L'
and case_status = 'O'
;

UPDATE  xwrl_requests
SET case_workflow = 'SL'
where case_workflow = 'L'
and case_status = 'O';

declare

cursor c1 is
WITH ows_req as 
(select EXTERNAL_ID, CURRENT_STATE from IRIP1_EDQCONFIG.dn_case@ebstoows2.coresys.com 
UNION
select EXTERNAL_ID, CURRENT_STATE  from IRIP2_EDQCONFIG.dn_case@ebstoows2.coresys.com)
select *
from xwrl_response_ind_columns col
,ows_req
where col.alertid = ows_req.EXTERNAL_ID
and col.x_state <> xwrl_ows_utils.changeowsstate(CURRENT_STATE);

/*
cursor c1 is
WITH ows_req as 
(select EXTERNAL_ID, CURRENT_STATE from iridr_edqconfig.dn_case@ebstoows2.coresys.com 
UNION
select EXTERNAL_ID, CURRENT_STATE  from iridr2_edqconfig.dn_case@ebstoows2.coresys.com)
select *
from xwrl_response_ind_columns col
,ows_req
where col.alertid = ows_req.EXTERNAL_ID
and col.x_state <> xwrl_ows_utils.changeowsstate(CURRENT_STATE);
*/
begin

for c1rec in c1 loop

update xwrl_response_ind_columns
set x_state = xwrl_ows_utils.ChangeOwsState(c1rec.current_state)
where id = c1rec.id;

end loop;

end;
/


select *
from corp_main
;

select corp_number
from corp_main
where corp_id 
;

select *
from xwrl_alert_clearing_xref
;

select *
from xwrl_requests
;

select *
from xwrl_response_ind_columns col
,xwrl_requests req
where col.request_id = req.id
;


select *
from WORLDCHECK_EXTERNAL_XREF
order by worldcheck_external_xref_id desc
;


with xref as 
(select 
select *
from xwrl_requests
;

select *
from xwrl_requests
where batch_id = 1172
;