---- Find footprint

SELECT SYS_CONTEXT('xwrl_ctx', 'disable_trigger') FROM dual;
exec xwrl_trg_ctx.disable_trg_ctx;
exec xwrl_trg_ctx.enable_trg_ctx;

select *
from FND_RESPONSIBILITY_VL 
where responsibility_name like 'RMI%';

mo_global.init ('ONT');
mo_global.set_policy_context ('S', 122);
--fnd_global.apps_initialize (user_id, responsibility_id, resp_appl_id);
fnd_global.apps_initialize (1156, 52369, 20003);
DBMS_APPLICATION_INFO.set_client_info (122);

xwrl_utils;
xwrl_ows_utils;
rmi_ows_common_util;

SELECT *
FROM FND_USER
where user_id = 3007
;

 SELECT value_string
     FROM xwrl_parameters
    WHERE ID = 'XWRL_OWS_UTILS' AND KEY = 'DEBUG';

select *
from xwrl_requests
where batch_id = :p_batch_id
;

select *
from xwrl_requests
where batch_id in (67937,67938)
order by id desc
;

select *
from xwrl_response_ind_columns
where alertid = :p_alert_id
order by id desc;

select *
from xwrl_response_ind_columns
where request_id = :p_request_id
order by id desc;


select c.*
from xwrl_response_ind_columns c
,xwrl_requests r
where c.request_id = r.id
and r.master_id = :p_master_id
order by c.id desc;

select c.*
from xwrl_response_ind_columns c
,xwrl_requests r
where c.request_id = r.id
and r.batch_id = :p_batch_id
order by c.id desc;

select unique(c.listid)
from xwrl_response_ind_columns c
,xwrl_requests r
where c.request_id = r.id
and r.batch_id = :p_batch_id
;

select x.*
from xwrl_alert_clearing_xref x
where exists (select 1
from xwrl_response_ind_columns c
,xwrl_requests r
where c.request_id = r.id
and r.batch_id = :p_batch_id
and x.alert_id = c.alertid)
order by x.list_id, id desc
;

select unique(c.alertid)
from xwrl_response_ind_columns c
,xwrl_requests r
where c.request_id = r.id
and r.batch_id = :p_batch_id
;


select *
from xwrl_response_ind_columns
where alertid = :p_alert_id
order by id desc;

select *
from xwrl_response_entity_columns
where alertid = :p_alert_id
order by id desc;

select c.*
from xwrl_response_entity_columns c
where exists (select 1 from xwrl_requests r where r.id = c.request_id and r.batch_id = :p_batch_id)
order by id desc;

select *
from xwrl_alert_clearing_xref
where alert_id = :p_alert_id
order by id desc;

select *
from xwrl_alert_clearing_xref
where master_id = :p_master_id
order by id desc;

select x.*
from xwrl_alert_clearing_xref x
where exists (select 1
from xwrl_response_ind_columns c
,xwrl_requests r
where c.request_id = r.id
and r.batch_id = :p_batch_id
and x.alert_id = c.alertid)
;

select *
from xwrl_audit_log
where table_name = upper('xwrl_response_ind_columns')
and table_id = :p_id
order by 1 desc
;

select *
from xwrl_audit_log
where table_name = upper('xwrl_response_entity_columns')
and table_id = :p_id
order by 1 desc
;

select *
from xwrl_alert_notes
where alert_id = :p_alert_id
ORDER BY ID DESC
;

select *
from xwrl_alert_clearing_xref
where alert_id = :p_alert_id
ORDER BY ID DESC
;

select *
from xwrl_alerts_debug
where p_alert_id = :p_alert_id
order by id desc
;

select *
from xwrl_alert_results_debug
where p_alert_id = :p_alert_id
order by id desc
;

select c.*
from xwrl_response_ind_columns c
where exists (select 1 from xwrl_requests r where r.id = c.request_id and r.batch_id = :p_batch_id)
order by id desc;

select c.*
from xwrl_response_entity_columns c
where exists (select 1 from xwrl_requests r where r.id = c.request_id and r.batch_id = :p_batch_id)
order by id desc;

select *
from xwrl_alert_clearing_xref
where master_id = 370601
and list_id = 2495134;

SELECT *
FROM mt_log
where notes like '%'||:p_alert_id||'%'
order by log_id desc
;

SELECT *
FROM mt_log
where notes like '%Batch ID: '||:p_batch_id||'%'
order by log_id desc
;

SELECT *
FROM mt_log
where notes like '%Batch ID: '||:p_batch_id||'%'||'Alert Id: '||:p_alert_id||'%'
order by log_id desc
;

--SEN-2257536

SELECT *
FROM mt_log
where log_id between 25086848 and 25086851 
order by log_id desc
;


