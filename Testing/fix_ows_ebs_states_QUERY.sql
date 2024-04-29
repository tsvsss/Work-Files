-- MASTER  INDIVIDUAL QUERY

WITH ows_req as 
(select EXTERNAL_ID, CURRENT_STATE from IRIP1_EDQCONFIG.dn_case@ebstoows2.coresys.com 
UNION
select EXTERNAL_ID, CURRENT_STATE  from IRIP2_EDQCONFIG.dn_case@ebstoows2.coresys.com)
select col.id,col. request_id, req.name_screened, req.batch_id, req.master_id, req.alias_id, req.xref_id, req.source_table, req.source_id
, col.casekey, col.alertid, col.listid, req.matches, col.rec, req.case_state, req.case_status, req.case_workflow,  col. listfullname, req.gender, col.listrecordtype, col.x_state ebs_status
,xwrl_ows_utils.ChangeToOwsState(x_state) to_state
,xwrl_ows_utils.changeowsstate(CURRENT_STATE) ows_converted_state
,decode(substr(col.x_state,7),'Positive',4,'Possible',3,'False Positive',2,'Open',1) ebs_level
,decode(substr(xwrl_ows_utils.changeowsstate(CURRENT_STATE),7),'Positive',4,'Possible',3,'False Positive',2,'Open',1) ows_level
, ows_req.current_state ows_state
,col.legal_review
 ,col.creation_date
 ,col.last_update_date
,fura.user_name case_created_by
,furb.user_name case_last_updated_by
,cura.user_name alert_created_by
,curb.user_name alert_last_updated_by
from xwrl_response_ind_columns col
,xwrl_requests req
,ows_req
,fnd_user fura
,fnd_user furb
,fnd_user cura
,fnd_user curb
where col.request_id = req.id 
and col.alertid = ows_req.EXTERNAL_ID
and req.created_by = fura.user_id
and req.last_updated_by = furb.user_id
and col.created_by = cura.user_id
and col.last_updated_by = curb.user_id
and req.case_state not IN ('D')
and (col.x_state <> xwrl_ows_utils.changeowsstate(CURRENT_STATE) or col.x_state is null) -- Note: Not a match or null
--order by ebs_level
--order by listfullname
--order by alertid
--order by ebs_status
--order by request_id, listid
--and req.batch_id = 126200
order by id desc
;

-- MASTER ENTITY QUERY

WITH ows_req as 
(select EXTERNAL_ID, CURRENT_STATE from IRIP1_EDQCONFIG.dn_case@ebstoows2.coresys.com 
UNION
select EXTERNAL_ID, CURRENT_STATE  from IRIP2_EDQCONFIG.dn_case@ebstoows2.coresys.com)
select col.id,col. request_id, req.name_screened, req.batch_id, req.master_id, req.alias_id, req.xref_id, req.source_table, req.source_id
, col.casekey, col.alertid, col.listid, col.rec, req.matches, req.case_state, req.case_status, req.case_workflow,  col. listentityname, col.listrecordtype, col.x_state ebs_status
,xwrl_ows_utils.ChangeToOwsState(x_state) to_state
, xwrl_ows_utils.changeowsstate(CURRENT_STATE) ows_converted_state
,decode(substr(col.x_state,7),'Positive',4,'Possible',3,'False Positive',2,'Open',1) ebs_level
,decode(substr(xwrl_ows_utils.changeowsstate(CURRENT_STATE),7),'Positive',4,'Possible',3,'False Positive',2,'Open',1) ows_level
, ows_req.current_state ows_state
,col.legal_review
 ,col.creation_date
 ,col.last_update_date
,fura.user_name case_created_by
,furb.user_name case_last_updated_by
,cura.user_name alert_created_by
,curb.user_name alert_last_updated_by
from xwrl_response_entity_columns col
,xwrl_requests req
,ows_req
,fnd_user fura
,fnd_user furb
,fnd_user cura
,fnd_user curb
where col.request_id = req.id 
and col.alertid = ows_req.EXTERNAL_ID
and req.created_by = fura.user_id
and req.last_updated_by = furb.user_id
and col.created_by = cura.user_id
and col.last_updated_by = curb.user_id
and req.case_state not IN ('D')
and (col.x_state <> xwrl_ows_utils.changeowsstate(CURRENT_STATE) or col.x_state is null)  -- Note: Not a match or null
--order by ebs_level
order by listentityname
--order by alertid
;

-- Check for Alert Note synchronization
select c.casekey, c.listid, c.x_state, c.request_id, c.alertid alert_id, r.source_table, null source_table_column, r.source_id,   r.master_id,  r.alias_id, r.xref_id, r.batch_id, c.last_update_date, c.last_updated_by, c.creation_date, c.created_by, c.last_update_login, n.line_number, n.id note_id
from xwrl_alert_notes n
,xwrl_response_ind_columns c
,xwrl_requests r
where n.request_id = r.id 
and n.request_id = c.request_id
and n.alert_id = c.alertid
and not exists (select 1 from xwrl_note_xref x where x.note_id = n.id)
;

select c.casekey, c.listid, c.x_state, c.request_id, c.alertid alert_id, r.source_table, null source_table_column, r.source_id,   r.master_id,  r.alias_id, r.xref_id, r.batch_id, c.last_update_date, c.last_updated_by, c.creation_date, c.created_by, c.last_update_login, n.line_number, n.id note_id
from xwrl_alert_notes n
,xwrl_response_entity_columns c
,xwrl_requests r
where n.request_id = r.id 
and n.request_id = c.request_id
and n.alert_id = c.alertid
and not exists (select 1 from xwrl_note_xref x where x.note_id = n.id);


-- Check for Zero Match issues

select count(*)
from xwrl_requests r
where r.matches = 0
and r.case_state = 'O' -- Open Case
and exists (select 1
from xwrl_requests x
where x.master_id = r.master_id
and x.matches > 0);

select count(*)
from xwrl_requests r
where r.matches = 0
and r.case_state = 'C' -- Closed Case
and r.case_workflow = 'A' -- Approved Workflow
and r.case_status = 'A' -- Approved Status
and exists (select 1
from xwrl_requests x
where x.master_id = r.master_id
and x.matches > 0);
