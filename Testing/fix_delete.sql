declare
cursor c1 is
select id, resubmit_id, status, creation_date, name_screened, master_id, case_state
from xwrl_requests
--where master_id = 501830  -- YOUNG SIK KIM
--WHERE STATUS = 'ERROR'
--and resubmit_id is not null
--WHERE STATUS = 'ERROR'
--and resubmit_id is not null
WHERE STATUS = 'RESUBMIT'
--where status in ('ERROR','RESUBMIT')
--WHERE STATUS = 'FAILED'
--WHERE CASE_ID IS NULL
--AND REQUEST IS NULL
--where ID = 142312
--where case_state = 'D'
--where case_state = 'E'
--and id = 167803
--where id in (98606,99135)
--where batch_id = 100
--where batch_id = 50
--where id in (139573,139574)
--where source_table = 'CORP_MAIN'
--and source_id = 7
--where id = 132450
--WHERE NAME_SCREENED = 'THOMAS JAMES JACKSON'
--where created_by = 1156
--AND TRUNC(CREATION_DATE) < TRUNC(SYSDATE)
--and id >= 191228
--WHERE NAME_SCREENED is null
;

v_ctr integer := 0;

begin

for  c1rec in c1 loop


begin

--DELETE from xwrl_alert_documents where request_id = c1rec.id;
--DELETE from xwrl_case_documents where request_id = c1rec.id;
delete from xwrl_response_ind_columns where request_id = c1rec.id;
delete from xwrl_response_entity_columns where request_id = c1rec.id;
delete xwrl_response_rows where request_id = c1rec.id;
DELETE from xwrl_request_ind_columns where request_id = c1rec.id;
DELETE from xwrl_request_entity_columns where request_id = c1rec.id;
DELETE from xwrl_request_rows where request_id = c1rec.id;
delete from xwrl_requests where id = c1rec.id;

v_ctr := v_ctr + 1;

exception 
when others then null;

if v_ctr = 100 then
   --commit;
   v_ctr := 0;
end if;   

end;

end loop;

dbms_output.put_line('Records processed: '||v_ctr);
--commit;

end;
/


-- 195658

-- 152265