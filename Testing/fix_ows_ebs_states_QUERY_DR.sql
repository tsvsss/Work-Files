-- MASTER  INDIVIDUAL QUERY

WITH ows_req as 
(select EXTERNAL_ID, CURRENT_STATE from IRIDR_EDQCONFIG.dn_case@ebstoows2.coresys.com 
UNION
select EXTERNAL_ID, CURRENT_STATE  from IRIDR2_EDQCONFIG.dn_case@ebstoows2.coresys.com)
select col.id,col. request_id, req.batch_id, col.rec, req.case_state, req.case_status, req.case_workflow,  col. listfullname, req.gender, col.listrecordtype, col.x_state ebs_status
,xwrl_ows_utils.ChangeToOwsState(x_state) to_state
,xwrl_ows_utils.changeowsstate(CURRENT_STATE) ows_converted_state
,decode(substr(col.x_state,7),'Positive',4,'Possible',3,'False Positive',2,'Open',1) ebs_level
,decode(substr(xwrl_ows_utils.changeowsstate(CURRENT_STATE),7),'Positive',4,'Possible',3,'False Positive',2,'Open',1) ows_level
, ows_req.current_state ows_state,col.casekey, col.alertid, col.listid
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
ORDER BY ID DESC
;

-- MASTER ENTITY QUERY

WITH ows_req as 
(select EXTERNAL_ID, CURRENT_STATE from IRIDR_EDQCONFIG.dn_case@ebstoows2.coresys.com 
UNION
select EXTERNAL_ID, CURRENT_STATE  from IRIDR2_EDQCONFIG.dn_case@ebstoows2.coresys.com)
select col.id,col. request_id, req.batch_id, col.rec, req.case_state, req.case_status, req.case_workflow,  col. listentityname, col.listrecordtype, col.x_state ebs_status
,xwrl_ows_utils.ChangeToOwsState(x_state) to_state
, xwrl_ows_utils.changeowsstate(CURRENT_STATE) ows_converted_state
,decode(substr(col.x_state,7),'Positive',4,'Possible',3,'False Positive',2,'Open',1) ebs_level
,decode(substr(xwrl_ows_utils.changeowsstate(CURRENT_STATE),7),'Positive',4,'Possible',3,'False Positive',2,'Open',1) ows_level
, ows_req.current_state ows_state, col.casekey, col.alertid, col.listid
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