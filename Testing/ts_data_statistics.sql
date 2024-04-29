/* Statistics */

select entity_type,  state, count(*) row_count
from xwrl_party_master 
where source_table = NVL(:p_source_table,source_table)
group by entity_type,  state
order by entity_type, state desc
;


select entity_type, source_table, source_table_column,  state, count(*) row_count
from xwrl_party_master 
where source_table = NVL(:p_source_table,source_table)
--and state = 'Migrated'
group by entity_type, source_table, source_table_column, state
order by  source_table, source_table_column, state desc
;

select source_table, source_table_column, source_target_column, state, count(*) row_count
from xwrl_party_master 
where source_table = NVL(:p_source_table,source_table)
group by source_table, source_table_column, source_target_column, state
order by  source_table, source_table_column, state desc
;

select entity_type,source_table, source_table_column, source_target_column, state, count(*) row_count
from xwrl_party_master 
where source_table = NVL(:p_source_table,source_table)
group by entity_type,source_table, source_table_column, source_target_column, state
order by entity_type, source_table, source_table_column, state desc
;

select source_table, source_table_column, source_target_column, state, count(*) row_count
from xwrl_party_master 
where source_table = NVL(:p_source_table,source_table)
and state = 'Migrated'
group by source_table, source_table_column, source_target_column, state
order by  source_table, source_table_column, state desc
;

select entity_type, source_table, source_table_column,  state, count(*) row_count
from xwrl_party_master 
where source_table = NVL(:p_source_table,source_table)
and state = 'Migrated'
group by entity_type, source_table, source_table_column, state
order by  source_table, source_table_column, state desc
;

select *
from xwrl_party_master 
where source_table = NVL(:p_source_table,source_table)
and source_table_column = NVL(:p_source_table_column,source_table_column)
--and source_id = 1112202
and state = 'Migrated'
order by id desc
;


WITH parameters as
(SELECT KEY, VALUE_STRING, sort_order
FROM XWRL_PARAMETERS
WHERE ID = 'CASE_WORK_FLOW')
select  parameters.value_string case_workflow, count(*) 
from xwrl_requests  xr
,parameters
where case_workflow = parameters.key
group by parameters.value_string, sort_order
order by parameters.sort_order
;

WITH parameters as
(SELECT KEY, VALUE_STRING, sort_order
FROM XWRL_PARAMETERS
WHERE ID = 'CASE_STATE')
select  parameters.value_string case_state, count(*) 
from xwrl_requests  xr
,parameters
where case_state = parameters.key
group by parameters.value_string, sort_order
order by parameters.sort_order
;

WITH parameters as
(SELECT KEY, VALUE_STRING, sort_order
FROM XWRL_PARAMETERS
WHERE ID = 'CASE_STATUS')
select  parameters.value_string case_status, count(*) 
from xwrl_requests  xr
,parameters
where case_status = parameters.key
group by parameters.value_string, sort_order
order by 1 desc, parameters.sort_order
;

select unique status
from wc_screening_request
;

select id, department, department_ext, office, document_type
from xwrl_requests
where rownum < 10
order by 1 desc
;

  SELECT rmi_ows_common_util.get_department (ID, 'CODE') deptcode,
       rmi_ows_common_util.get_department (ID) dept,
       rmi_ows_common_util.get_doc_type (ID) doc_type,
       rmi_ows_common_util.get_office (ID,'CODE') office, id
  FROM xwrl_requests
  where rownum < 10
  order by 1 desc;

select department_ext, count(*)
from xwrl_requests
group by department_ext
order by 1 desc
;


select *
from (select 'INDIVIDUAL' alert_type,substr(x_state,7) alert_state, count(*)
from xwrl_response_ind_columns
group by substr(x_state,7)
union
select 'ENTITY' alert_type,substr(x_state,7) alert_state, count(*)
from xwrl_response_entity_columns
group by substr(x_state,7)
)
order by 1,decode(alert_state,'Open',1,'False Positive',2,'Possible',3,4)
;


  