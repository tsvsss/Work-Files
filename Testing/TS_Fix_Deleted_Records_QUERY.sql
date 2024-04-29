select count(*)
from xwrl.XWRL_REQUESTS_copy source
,XWRL_REQUESTS target
where source.id = target.id (+)
and target.id is null
and not exists (select TABLE_ID id
from xwrl_audit_log
where table_name = 'XWRL_REQUESTS'
and table_column = 'ID'
and row_action = 'DELETE'
AND CREATION_DATE IS NOT NULL
and TABLE_ID = source.id) 
;

SELECT COUNT(*)
FROM XWRL.XWRL_REQ_IND_COL_COPY SOURCE
,XWRL_REQUEST_IND_COLUMNS TARGET
,XWRL_REQUESTS REQ
WHERE SOURCE.REQUEST_ID = REQ.ID
AND SOURCE.ID = TARGET.ID (+)
AND TARGET.ID IS NULL
and not exists (select TABLE_ID id
from xwrl_audit_log
where table_name = 'XWRL_REQUEST_IND_COLUMNS'
and table_column = 'ID'
and row_action = 'DELETE'
AND CREATION_DATE IS NOT NULL
and TABLE_ID = source.id) 
;

select count(*)
from xwrl.XWRL_REQ_ENT_COL_copy source
,xwrl_request_entity_columns target
,xwrl_requests req
where source.request_id = req.id
and source.id = target.id (+)
and target.id is null
and not exists (select TABLE_ID id
from xwrl_audit_log
where table_name = 'XWRL_REQUEST_ENTITY_COLUMNS'
and table_column = 'ID'
and row_action = 'DELETE'
AND CREATION_DATE IS NOT NULL
and TABLE_ID = source.id) 
;

select count(*)
from xwrl.XWRL_REQ_ROWS_copy source
,xwrl_request_rows target
,xwrl_requests req
where source.request_id = req.id
and source.id = target.id (+)
and target.id is null
and not exists (select TABLE_ID id
from xwrl_audit_log
where table_name = 'XWRL_REQUEST_ROWS'
and table_column = 'ID'
and row_action = 'DELETE'
AND CREATION_DATE IS NOT NULL
and TABLE_ID = source.id) 
; 

select count(source.id)
from xwrl.XWRL_RESP_IND_COL_copy source
,xwrl_response_ind_columns target
,xwrl_requests req
where source.request_id = req.id
and source.id = target.id (+)
and target.id is null
and not exists (select  TABLE_ID id
from xwrl_audit_log
where table_name = upper('xwrl_response_ind_columns')
and table_column = 'ID'
and row_action = 'DELETE'
AND CREATION_DATE IS NOT NULL
and TABLE_ID = source.id)
; --11883

select count(source.id)
from xwrl.XWRL_RESP_ENT_COL_copy source
,xwrl_response_entity_columns target
,xwrl_requests req
where source.request_id = req.id
and source.id = target.id (+)
and target.id is null
and not exists (select TABLE_ID id
from xwrl_audit_log
where table_name = upper('xwrl_response_entity_columns')
and table_column = 'ID'
and row_action = 'DELETE'
AND CREATION_DATE IS NOT NULL
and TABLE_ID = source.id)
;

select count(*)
from xwrl.XWRL_RESP_ROWS_copy source
,xwrl_response_rows target
,xwrl_requests req
where source.request_id = req.id
and source.id = target.id (+)
and target.id is null
and not exists (select TABLE_ID id
from xwrl_audit_log
where table_name = upper('xwrl_response_rows')
and table_column = 'ID'
and row_action = 'DELETE'
AND CREATION_DATE IS NOT NULL
and TABLE_ID = source.id)
; -- 1317915