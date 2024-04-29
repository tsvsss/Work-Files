/* xwrl_requests */


SELECT SYS_CONTEXT('xwrl_ctx', 'disable_trigger') FROM dual;
exec xwrl_trg_ctx.disable_trg_ctx;
exec xwrl_trg_ctx.enable_trg_ctx;

declare

cursor c1 is
select source.id
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

source_row xwrl_requests%rowtype;

v_sql1 VARCHAR2(100) := 'alter table xwrl.xwrl_requests disable all triggers';
v_sql2 VARCHAR2(100) := 'alter table xwrl.xwrl_requests enable all triggers';

v_count integer := 0;

begin

xwrl_trg_ctx.disable_trg_ctx;

for c1rec in c1 loop

begin

SELECT *
INTO source_row
FROM xwrl.XWRL_REQUESTS_copy
WHERE id = c1rec.id;

insert into xwrl_requests values source_row;

v_count := v_count + 1;

if v_count = 500 then
    dbms_output.put_line('Processed records: '||v_count);
    commit;
    v_count := 0;
end if;    

exception
when others then 

commit;

end;

end loop;

commit;

end;
/

/* xwrl_request_ind_columns */

declare

cursor c1 is

SELECT SOURCE.ID
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

source_row xwrl_request_ind_columns%rowtype;

v_sql1 VARCHAR2(100) := 'alter table xwrl.xwrl_request_ind_columns disable all triggers';
v_sql2 VARCHAR2(100) := 'alter table xwrl.xwrl_request_ind_columns enable all triggers';

v_count integer := 0;

begin

xwrl_trg_ctx.disable_trg_ctx;

for c1rec in c1 loop

begin

SELECT *
INTO source_row
FROM xwrl.XWRL_REQ_IND_COL_copy
WHERE id = c1rec.id;

insert into xwrl_request_ind_columns values source_row;

v_count := v_count + 1;

if v_count = 500 then
    commit;
    v_count := 0;
end if;    

exception
when others then 
rollback;

end;

end loop;

commit;

end;
/


/* xwrl_request_entity_columns */

declare

cursor c1 is
select source.id
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

source_row xwrl_request_entity_columns%rowtype;

v_sql1 VARCHAR2(100) := 'alter table xwrl.xwrl_request_entity_columns disable all triggers';
v_sql2 VARCHAR2(100) := 'alter table xwrl.xwrl_request_entity_columns enable all triggers';

v_count integer := 0;

begin

xwrl_trg_ctx.disable_trg_ctx;

for c1rec in c1 loop

begin

SELECT *
INTO source_row
FROM xwrl.XWRL_REQ_ENT_COL_copy
WHERE id = c1rec.id;

insert into xwrl_request_entity_columns values source_row;

v_count := v_count + 1;

if v_count = 500 then
    commit;
    v_count := 0;
end if;    

exception
when others then 
rollback;

end;

end loop;

commit;

end;
/

/* xwrl_request_rows */

declare

cursor c1 is
select source.id
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

source_row xwrl_request_rows%rowtype;

v_sql1 VARCHAR2(100) := 'alter table xwrl.xwrl_request_rows disable all triggers';
v_sql2 VARCHAR2(100) := 'alter table xwrl.xwrl_request_rows enable all triggers';

v_count integer := 0;

begin

xwrl_trg_ctx.disable_trg_ctx;

for c1rec in c1 loop

begin

SELECT *
INTO source_row
FROM xwrl.XWRL_REQ_ROWS_copy
WHERE id = c1rec.id;

insert into xwrl_request_rows values source_row;

v_count := v_count + 1;

if v_count = 500 then
    commit;
    v_count := 0;
end if;    

exception
when others then 
rollback;

end;

end loop;

commit;

end;
/

/* xwrl_response_ind_columns */

declare

cursor c1 is
select source.id
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
--and rownum <= 1
;

source_row xwrl_response_ind_columns%rowtype;

v_sql1 VARCHAR2(100) := 'alter table xwrl.xwrl_response_ind_columns disable all triggers';
v_sql2 VARCHAR2(100) := 'alter table xwrl.xwrl_response_ind_columns enable all triggers';

v_count integer := 0;

begin

xwrl_trg_ctx.disable_trg_ctx;

for c1rec in c1 loop

begin

SELECT *
INTO source_row
FROM xwrl.XWRL_RESP_IND_COL_copy
WHERE id = c1rec.id;

insert into xwrl_response_ind_columns values source_row;

v_count := v_count + 1;

if v_count = 500 then
    commit;
    v_count := 0;
end if;    

exception
when others then 

rollback;

end;

end loop;

commit;

end;
/


/* xwrl_response_entity_columns */

declare

cursor c1 is
select source.id
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

source_row xwrl_response_entity_columns%rowtype;

v_sql1 VARCHAR2(100) := 'alter table xwrl.xwrl_response_entity_columns disable all triggers';
v_sql2 VARCHAR2(100) := 'alter table xwrl.xwrl_response_entity_columns enable all triggers';

v_count integer := 0;

begin

xwrl_trg_ctx.disable_trg_ctx;

for c1rec in c1 loop

begin

SELECT *
INTO source_row
FROM xwrl.XWRL_RESP_ENT_COL_copy
WHERE id = c1rec.id;

insert into xwrl_response_entity_columns values source_row;

v_count := v_count + 1;

if v_count = 500 then
    commit;
    v_count := 0;
end if;    

exception
when others then 
rollback;

end;

end loop;

commit;

end;
/


/* xwrl_response_rows */

declare

cursor c1 is
select source.id
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
--and rownum <= 1
;

source_row xwrl_response_rows%rowtype;

v_sql1 VARCHAR2(100) := 'alter table xwrl.xwrl_response_rows disable all triggers';
v_sql2 VARCHAR2(100) := 'alter table xwrl.xwrl_response_rows enable all triggers';

v_count integer := 0;

begin

xwrl_trg_ctx.disable_trg_ctx;

for c1rec in c1 loop

begin

SELECT *
INTO source_row
FROM xwrl.XWRL_RESP_ROWS_copy
WHERE id = c1rec.id;

insert into xwrl_response_rows values source_row;

v_count := v_count + 1;

if v_count = 500 then
    commit;
    v_count := 0;
end if;    

exception
when others then 
rollback;

end;

end loop;

commit;

end;
/
