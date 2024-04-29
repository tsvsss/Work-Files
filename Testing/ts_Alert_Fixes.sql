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
and col.x_state <> CURRENT_STATE;

-- INDIVIDUAL

WITH ows_req as 
(select EXTERNAL_ID, CURRENT_STATE from IRIP1_EDQCONFIG.dn_case@ebstoows2.coresys.com 
UNION
select EXTERNAL_ID, CURRENT_STATE  from IRIP2_EDQCONFIG.dn_case@ebstoows2.coresys.com)
select id, x_state, current_state, alertid, listrecordtype
from xwrl_response_ind_columns col
,ows_req
where col.alertid = ows_req.EXTERNAL_ID
and col.x_state <> CURRENT_STATE;


declare

cursor c1 is
WITH ows_req as 
(select EXTERNAL_ID, CURRENT_STATE from IRIP1_EDQCONFIG.dn_case@ebstoows2.coresys.com 
UNION
select EXTERNAL_ID, CURRENT_STATE  from IRIP2_EDQCONFIG.dn_case@ebstoows2.coresys.com)
select *
from xwrl_response_entity_columns col
,ows_req
where col.alertid = ows_req.EXTERNAL_ID
and col.x_state <> CURRENT_STATE;

begin

for c1rec in c1 loop

update xwrl_response_entity_columns
set x_state = xwrl_ows_utls.ChangeOwsState(c1rec.current_state)
where id = c1rec.id;

end loop;

end;
/


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
and col.x_state <> CURRENT_STATE;

begin

for c1rec in c1 loop

update xwrl_response_ind_columns
set x_state = xwrl_ows_utls.ChangeOwsState(c1rec.current_state)
where id = c1rec.id;

end loop;

end;
/