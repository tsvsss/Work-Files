/* 

AUTHOR: TSUAZO
LAST UPDATE: 01/14/2020 15:44

NOTES:



Hierarchy Level on the EBS Alert States

1) Positive
2) Possible
3) False Positive
4) Open

Procedures will do the following:

1) UPDATE LIST RECORD TYPE (Note: If under Legal Review, you may need to disable / enable trigger.  If so, I would recommend doing this in late afternoon US time)
2) UPDATE EBS Alerts
3) UPDATE OWS Alerts

/*  Note: You may need to disable and enable trigger to do the update if under Legal Review 
alter trigger XWRL.XWRL_REQUESTS_INS_UPD disable;
alter trigger XWRL.XWRL_REQUESTS_INS_UPD enable;
*/

/* UPDATE EBS INDIVIDUAL - LIST RECORD TYPE*/

declare

cursor c1 is
select col.id,col. request_id, req.batch_id, req.case_state, req.case_status, req.case_workflow,  col. listfullname, col.x_state ebs_status, col.alertid, col.listrecordtype, col.creation_date, substr(col.x_state, 1,3), replace(col.x_state,substr(col.x_state, 1,3),col.listrecordtype) correct_status
from xwrl_response_ind_columns col
,xwrl_requests req
where col.request_id = req.id 
and col.listrecordtype <> substr(col.x_state, 1,3);

v_msg varchar2(4000);

begin

for c1rec in c1 loop

begin
update xwrl_response_ind_columns
set x_state = c1rec.correct_status
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

/* UPDATE EBS ENTITY - LIST RECORD TYPE */

declare

cursor c1 is
select col.id,col. request_id, req.batch_id, req.case_state, req.case_status, req.case_workflow,  col. listentityname, col.x_state ebs_status, col.alertid, col.listrecordtype, col.creation_date, substr(col.x_state, 1,3), replace(col.x_state,substr(col.x_state, 1,3),col.listrecordtype) correct_status
from xwrl_response_entity_columns col
,xwrl_requests req
where col.request_id = req.id 
and col.listrecordtype <> substr(col.x_state, 1,3);

v_msg varchar2(4000);

begin

for c1rec in c1 loop

begin
update xwrl_response_entity_columns
set x_state = c1rec.correct_status
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


/* UPDATE EBS INDIVIDUAL (Review EBS Open) */

declare

cursor c1 is
WITH ows_req as 
(select EXTERNAL_ID, CURRENT_STATE from IRIDR_EDQCONFIG.dn_case@ebstoows2.coresys.com 
UNION
select EXTERNAL_ID, CURRENT_STATE  from IRIDR2_EDQCONFIG.dn_case@ebstoows2.coresys.com)
select col.id,col. request_id, req.batch_id, req.case_state, req.case_status, req.case_workflow,  col. listfullname, col.x_state ebs_status
,xwrl_ows_utils.ChangeToOwsState(x_state) to_state
,xwrl_ows_utils.changeowsstate(CURRENT_STATE) ows_converted_state
, ows_req.current_state ows_state, col.alertid, col.listrecordtype, col.creation_date, col.listid
from xwrl_response_ind_columns col
,xwrl_requests req
,ows_req
where col.request_id = req.id and col.alertid = ows_req.EXTERNAL_ID
and req.case_state not IN ('D')
and col.x_state like '%Open' -- Review EBS Open
and col.x_state <> xwrl_ows_utils.changeowsstate(CURRENT_STATE)
and decode(substr(col.x_state,7),'Positive',4,'Possible',3,'False Positive',2,'Open',1)  < decode(substr(xwrl_ows_utils.changeowsstate(CURRENT_STATE),7),'Positive',4,'Possible',3,'False Positive',2,'Open',1)
order by ebs_status
;

v_msg varchar2(4000);

begin

for c1rec in c1 loop

begin
update xwrl_response_ind_columns
set x_state = xwrl_ows_utils.ChangeOwsState(c1rec.ows_converted_state)
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
(select EXTERNAL_ID, CURRENT_STATE from IRIDR_EDQCONFIG.dn_case@ebstoows2.coresys.com 
UNION
select EXTERNAL_ID, CURRENT_STATE  from IRIDR2_EDQCONFIG.dn_case@ebstoows2.coresys.com)
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
and col.x_state like '%Open' -- Review EBS Open
and col.x_state <> xwrl_ows_utils.changeowsstate(CURRENT_STATE)
and decode(substr(col.x_state,7),'Positive',4,'Possible',3,'False Positive',2,'Open',1)  < decode(substr(xwrl_ows_utils.changeowsstate(CURRENT_STATE),7),'Positive',4,'Possible',3,'False Positive',2,'Open',1)
order by ebs_status
;

v_msg varchar2(4000);

begin

for c1rec in c1 loop

begin
update xwrl_response_entity_columns
set x_state = xwrl_ows_utils.ChangeOwsState(c1rec.ows_converted_state)
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

/* UPDATE OWS INDIVIDUAL (Review OWS Open) */

DECLARE

cursor c1 is
WITH ows_req as 
(select EXTERNAL_ID, CURRENT_STATE from IRIDR_EDQCONFIG.dn_case@ebstoows2.coresys.com 
UNION
select EXTERNAL_ID, CURRENT_STATE  from IRIDR2_EDQCONFIG.dn_case@ebstoows2.coresys.com)
select col.id,col. request_id, req.batch_id, req.case_state, req.case_status, req.case_workflow,  col. listfullname, col.x_state ebs_status
,xwrl_ows_utils.ChangeToOwsState(x_state) to_state
,xwrl_ows_utils.changeowsstate(CURRENT_STATE) ows_converted_state
, ows_req.current_state ows_state, col.alertid, col.listrecordtype, col.creation_date, col.listid
from xwrl_response_ind_columns col
,xwrl_requests req
,ows_req
where col.request_id = req.id 
and col.alertid = ows_req.EXTERNAL_ID
and req.case_state not IN ('D')
and  xwrl_ows_utils.changeowsstate(CURRENT_STATE) like '%Open'  -- Review OWS Open
and col.x_state <> xwrl_ows_utils.changeowsstate(CURRENT_STATE)
and decode(substr(col.x_state,7),'Positive',4,'Possible',3,'False Positive',2,'Open',1)  >  decode(substr(xwrl_ows_utils.changeowsstate(CURRENT_STATE),7),'Positive',4,'Possible',3,'False Positive',2,'Open',1)
order by ebs_status
;

   p_user            VARCHAR2 (200);
   p_alert_in_tbl    xows.xxiri_cm_process_pkg.alert_tbl_in_type@ebstoows2.coresys.com;
   x_alert_out_tbl   xows.xxiri_cm_process_pkg.alert_tbl_out_type@ebstoows2.coresys.com;
   x_status          VARCHAR2 (200);
   
   v_msg varchar2(4000);

BEGIN

   p_user := 'tsuazo';

for c1rec in c1 loop

   p_alert_in_tbl (1).alert_id := c1rec.alertid;
   p_alert_in_tbl (1).to_state := c1rec.to_state;
   p_alert_in_tbl (1).comment := 'Update OWS state from EBS state to resolve mismatch';

   xows.xxiri_cm_process_pkg.update_alerts@ebstoows2.coresys.com (p_user => p_user, p_alert_in_tbl => p_alert_in_tbl, x_alert_out_tbl => x_alert_out_tbl, x_status => x_status);

   FOR j IN x_alert_out_tbl.first..x_alert_out_tbl.last LOOP 
   
   begin
   dbms_output.put_line ('ALert ID: ' || x_alert_out_tbl (j).alert_id || ' New State: ' || x_alert_out_tbl (j).new_state || ' status: ' || x_alert_out_tbl (j).status || ' err_msg: ' || x_alert_out_tbl (j).err_msg || ' Overall status: ' || x_status);
   exception
   when others then 
   v_msg := sqlerrm;
   dbms_output.put_line(sqlerrm);
   end;

   END LOOP;

end loop;

commit;

END;
/


/* UPDATE OWS ENTITY  (Review OWS Open) */

DECLARE

cursor c1 is
WITH ows_req as 
(select EXTERNAL_ID, CURRENT_STATE from IRIDR_EDQCONFIG.dn_case@ebstoows2.coresys.com 
UNION
select EXTERNAL_ID, CURRENT_STATE  from IRIDR2_EDQCONFIG.dn_case@ebstoows2.coresys.com)
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
 and  xwrl_ows_utils.changeowsstate(CURRENT_STATE) like '%Open'  -- Review OWS Open
and col.x_state <> xwrl_ows_utils.changeowsstate(CURRENT_STATE)
and decode(substr(col.x_state,7),'Positive',4,'Possible',3,'False Positive',2,'Open',1)  >  decode(substr(xwrl_ows_utils.changeowsstate(CURRENT_STATE),7),'Positive',4,'Possible',3,'False Positive',2,'Open',1)
order by ebs_status
;

   p_user            VARCHAR2 (200);
   p_alert_in_tbl    xows.xxiri_cm_process_pkg.alert_tbl_in_type@ebstoows2.coresys.com;
   x_alert_out_tbl   xows.xxiri_cm_process_pkg.alert_tbl_out_type@ebstoows2.coresys.com;
   x_status          VARCHAR2 (200);
   
   v_msg varchar2(4000);

BEGIN

   p_user := 'tsuazo';

for c1rec in c1 loop

   p_alert_in_tbl (1).alert_id := c1rec.alertid;
   p_alert_in_tbl (1).to_state := c1rec.to_state;
   p_alert_in_tbl (1).comment := 'Update OWS state from EBS state to resolve mismatch';

   xows.xxiri_cm_process_pkg.update_alerts@ebstoows2.coresys.com (p_user => p_user, p_alert_in_tbl => p_alert_in_tbl, x_alert_out_tbl => x_alert_out_tbl, x_status => x_status);

   FOR j IN x_alert_out_tbl.first..x_alert_out_tbl.last LOOP 
   
   begin
   dbms_output.put_line ('ALert ID: ' || x_alert_out_tbl (j).alert_id || ' New State: ' || x_alert_out_tbl (j).new_state || ' status: ' || x_alert_out_tbl (j).status || ' err_msg: ' || x_alert_out_tbl (j).err_msg || ' Overall status: ' || x_status);
   exception
   when others then 
   v_msg := sqlerrm;
   dbms_output.put_line(sqlerrm);
   end;

   END LOOP;

end loop;

commit;

END;
/

