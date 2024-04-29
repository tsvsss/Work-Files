select SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') from dual;

SELECT sys_context('USERENV', 'DB_NAME') FROM DUAL;

SELECT sys_context('USERENV', 'CLIENT_INFO') FROM DUAL;

select * from V$CONTEXT;

select *
from all_objects
where object_name LIKE  '%CTX%'
and owner = 'APPS'
ORDER BY OBJECT_NAME
;

XLGL_SEC_CTX;

select * from xwrl_requests where id = 24441;

select * from xwrl.XWRL_REQUESTS_copy where id = 24441;

select * from xwrl.XWRL_REQUESTS_copy order by id;

select * from xwrl.XWRL_REQ_IND_COL_copy order by id;
select * from xwrl.XWRL_REQ_ENT_COL_copy order by id;
select * from xwrl.XWRL_REQ_ROWS_copy order by id;

select * from xwrl.XWRL_RESP_IND_COL_copy order by id;
select * from xwrl.XWRL_RESP_ENT_COL_copy order by id;
select * from xwrl.XWRL_RESP_ROWS_copy order by id;



SELECT source.*
from xwrl.XWRL_REQUESTS_copy source
,XWRL_REQUESTS target
where source.id = target.id (+)
and target.id is null
;

select *
from XWRL_REQUESTS
where id = 205993
;

select *
from xwrl.XWRL_REQUESTS_copy
where id = 205993
;

select *
from xwrl_audit_log
where table_name = 'XWRL_REQUESTS'
and table_column = 'ID'
and table_id = 205993
order by 1 desc
;

select count(*)
from xwrl.XWRL_REQUESTS_copy source
,XWRL_REQUESTS target
,(select TABLE_ID id
from xwrl_audit_log
where table_name = 'XWRL_REQUESTS'
and table_column = 'ID'
and row_action = 'DELETE'
--and table_id = 205993
--order by 1 desc
AND CREATION_DATE IS NOT NULL
--ORDER BY CREATION_DATE DESC
) DEL
where source.id = target.id (+)
and target.id is null
AND source.id <> del.id
;

select count(*)
from xwrl.XWRL_REQ_IND_COL_copy source
;

select count(*)
from xwrl.XWRL_REQ_IND_COL_copy source
,xwrl_request_ind_columns target
where source.id = target.id (+)
and target.id is null
;

select count(*)
from xwrl.XWRL_REQ_IND_COL_copy source
,xwrl_request_ind_columns target
where source.id = target.id 
;

select count(*)
from xwrl.XWRL_REQ_IND_COL_copy source
,xwrl_request_ind_columns target
,xwrl_requests req
where source.request_id = req.id
and source.id = target.id (+)
and target.id is null
;

select source.id
from xwrl.XWRL_RESP_IND_COL_copy source
,xwrl_response_ind_columns target
where source.id = target.id (+)
and target.id is null
;

select source.id
from xwrl.XWRL_RESP_IND_COL_copy source
,xwrl_response_ind_columns target
,(select TABLE_ID id
from xwrl_audit_log
where table_name = upper('xwrl_response_ind_columns')
and table_column = 'ID'
and row_action = 'DELETE'
--and table_id = 205993
--order by 1 desc
AND CREATION_DATE IS NOT NULL
--ORDER BY CREATION_DATE DESC
) DEL
where source.id = target.id (+)
and target.id is null
AND source.id <> del.id
;

select count(*)
from xwrl.XWRL_REQ_ROWS_copy
;

select count(*)
from xwrl.XWRL_REQ_ROWS_copy source
,xwrl_request_rows target
,xwrl_requests req
where source.request_id = req.id
and source.id = target.id (+)
and target.id is null
;

select count(*)
from xwrl.XWRL_RESP_IND_COL_copy source
,xwrl_response_ind_columns target
where source.id = target.id (+)
and target.id is null
;

select count(*)
from xwrl.XWRL_RESP_IND_COL_copy source
,xwrl_response_ind_columns target
,xwrl_requests req
where source.request_id = req.id
and source.id = target.id (+)
and target.id is null
;

select count(*)
from xwrl_audit_log
where table_name = upper('xwrl_response_ind_columns')
and table_column = 'ID'
and row_action = 'DELETE'
--and table_id = 205993
--order by 1 desc
AND CREATION_DATE IS NOT NULL
;

select count(*)
from xwrl.XWRL_RESP_IND_COL_copy source
,xwrl_response_ind_columns target
,(select TABLE_ID id
from xwrl_audit_log
where table_name = upper('xwrl_response_ind_columns')
and table_column = 'ID'
and row_action = 'DELETE'
--and table_id = 205993
--order by 1 desc
AND CREATION_DATE IS NOT NULL
--ORDER BY CREATION_DATE DESC
) DEL
where source.id = target.id (+)
and target.id is null
AND target.id <> del.id
;


with del_rec as (select TABLE_ID id
from xwrl_audit_log
where table_name = upper('xwrl_response_ind_columns')
and table_column = 'ID'
and row_action = 'DELETE'
--and table_id = 205993
--order by 1 desc
AND CREATION_DATE IS NOT NULL
--ORDER BY CREATION_DATE DESC
)
select count(*)
from xwrl.XWRL_RESP_IND_COL_copy source
,xwrl_response_ind_columns target
,xwrl_requests req
,del_rec
where source.id = target.id (+)
and source.request_id = req.id
and target.id is null
AND source.id <> del_rec.id
;

with del_rec as (select TABLE_ID id
from xwrl_audit_log
where table_name = upper('xwrl_response_ind_columns')
and table_column = 'ID'
and row_action = 'DELETE'
--and table_id = 205993
--order by 1 desc
AND CREATION_DATE IS NOT NULL
--ORDER BY CREATION_DATE DESC
)
select source.id
from xwrl.XWRL_RESP_IND_COL_copy source
,xwrl_response_ind_columns target
,xwrl_requests req
,del_rec
where source.request_id = req.id
and source.id = target.id (+)
and target.id is null
AND source.id <> del_rec.id
;

select round(count(*) / 500 * 838 / 60 / 60  ,2) copy_hours
from xwrl.XWRL_REQUESTS_copy source
,xwrl_requests target
where source.id = target.id (+)
and target.id is null
;

select count(*) from xwrl.XWRL_REQ_IND_COL_copy; -- 153851

select *
from xwrl_request_ind_columns
order by id;

 select *
 from xwrl.XWRL_REQ_IND_COL_copy
 order by id
 ;

select *
from xwrl.XWRL_REQ_IND_COL_copy source
,xwrl_request_ind_columns target
where source.id = target.id (+)
and target.id is null
order by source.id
;

select count(*)
from xwrl.XWRL_REQ_IND_COL_copy source
,xwrl_request_ind_columns target
where source.id = target.id (+)
and target.id is null
;

select count(*)
from xwrl_audit_log
where table_name = upper('xwrl_request_ind_columns')
and table_column = 'ID'
and row_action = 'DELETE'
--and table_id = 205993
--order by 1 desc
;

select count(*)
from xwrl_audit_log
where table_name = upper('xwrl_request_entity_columns')
and table_column = 'ID'
and row_action = 'DELETE'
--and table_id = 205993
--order by 1 desc
;

select count(*)
from xwrl_audit_log
where table_name = upper('xwrl_request_rows')
and table_column = 'ID'
and row_action = 'DELETE'
--and table_id = 205993
--order by 1 desc
;

select count(*)
from xwrl_audit_log
where table_name = upper('xwrl_response_ind_columns')
and table_column = 'ID'
and row_action = 'DELETE'
--and table_id = 205993
--order by 1 desc
;

select count(*)
from xwrl_audit_log
where table_name = upper('xwrl_response_entity_columns')
and table_column = 'ID'
and row_action = 'DELETE'
--and table_id = 205993
--order by 1 desc
;

select count(*)
from xwrl_audit_log
where table_name = upper('xwrl_response_rows')
and table_column = 'ID'
and row_action = 'DELETE'
--and table_id = 205993
--order by 1 desc
;



SELECT SYS_CONTEXT('xwrl_ctx', 'disable_trigger') FROM dual;

select count(*)
from xwrl.XWRL_RESP_IND_COL_copy source
,xwrl_response_ind_columns target
,xwrl_requests req
where source.request_id = req.id
and source.id = target.id (+)
and target.id is null
;

select id, count(*)
from xwrl_requests
group by id
having count(*) > 1
;

select id, count(*)
from XWRL_REQUEST_IND_COLUMNS
group by id
having count(*) > 1
;

select id, count(*)
from XWRL_REQUEST_ENTITY_COLUMNS
group by id
having count(*) > 1
;

select id, count(*)
from XWRL_REQUEST_ROWS
group by id
having count(*) > 1
;

select id, count(*)
from xwrl_response_ind_columns
group by id
having count(*) > 1
;

select id, count(*)
from xwrl_response_ENTITY_columns
group by id
having count(*) > 1
;

select id, count(*)
from xwrl_response_rows
group by id
having count(*) > 1
;