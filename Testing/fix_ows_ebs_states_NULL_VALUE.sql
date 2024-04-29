/* UPDATE EBS INDIVIDUAL (Review EBS Open) */

declare

cursor c1 is
WITH ows_req as 
(select EXTERNAL_ID, CURRENT_STATE from IRIP1_EDQCONFIG.dn_case@ebstoows2.coresys.com 
UNION
select EXTERNAL_ID, CURRENT_STATE  from IRIP2_EDQCONFIG.dn_case@ebstoows2.coresys.com)
select col.id,col. request_id, req.batch_id, req.case_state, req.case_status, req.case_workflow,  col. listfullname, col.x_state ebs_status
,xwrl_ows_utils.ChangeToOwsState(x_state) to_state
,xwrl_ows_utils.changeowsstate(CURRENT_STATE) ows_converted_state
, ows_req.current_state ows_state, col.alertid, col.listrecordtype, col.creation_date, col.listid
from xwrl_response_ind_columns col
,xwrl_requests req
,ows_req
where col.request_id = req.id and col.alertid = ows_req.EXTERNAL_ID
and req.case_state not IN ('D')
and col.x_state is null
--and decode(substr(col.x_state,7),'Positive',4,'Possible',3,'False Positive',2,'Open',1)  < decode(substr(xwrl_ows_utils.changeowsstate(CURRENT_STATE),7),'Positive',4,'Possible',3,'False Positive',2,'Open',1)
order by ebs_status
;

v_msg varchar2(4000);

begin

for c1rec in c1 loop

begin
update xwrl_response_ind_columns
set x_state = c1rec.ows_converted_state
where id = c1rec.id;
exception
when others then 
v_msg := sqlerrm;
dbms_output.put_line(sqlerrm);
end;

end loop;

commit;

end;
/



/* UPDATE EBS ENTITY (Review EBS Open) */

declare

cursor c1 is
WITH ows_req as 
(select EXTERNAL_ID, CURRENT_STATE from IRIP1_EDQCONFIG.dn_case@ebstoows2.coresys.com 
UNION
select EXTERNAL_ID, CURRENT_STATE  from IRIP2_EDQCONFIG.dn_case@ebstoows2.coresys.com)
select col.id,col. request_id, req.batch_id, req.case_state, req.case_status, req.case_workflow,  col. listentityname, col.x_state ebs_status
,xwrl_ows_utils.ChangeToOwsState(x_state) to_state
, xwrl_ows_utils.changeowsstate(CURRENT_STATE) ows_converted_state
, ows_req.current_state ows_state, col.alertid, col.listrecordtype, col.creation_date, col.listid
from xwrl_response_entity_columns col
,xwrl_requests req
,ows_req
where col.request_id = req.id 
and col.alertid = ows_req.EXTERNAL_ID
and req.case_state not IN ('D')
and col.x_state is null
--and decode(substr(col.x_state,7),'Positive',4,'Possible',3,'False Positive',2,'Open',1)  < decode(substr(xwrl_ows_utils.changeowsstate(CURRENT_STATE),7),'Positive',4,'Possible',3,'False Positive',2,'Open',1)
order by ebs_status
;

v_msg varchar2(4000);

begin

for c1rec in c1 loop

begin
update xwrl_response_entity_columns
set x_state = c1rec.ows_converted_state
where id = c1rec.id;
exception
when others then 
v_msg := sqlerrm;
dbms_output.put_line(sqlerrm);
end;

end loop;

commit;

end;
/