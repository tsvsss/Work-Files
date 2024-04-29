WITH ows_req as 
(select EXTERNAL_ID, CURRENT_STATE from IRIP1_EDQCONFIG.dn_case@ebstoows2.coresys.com 
UNION
select EXTERNAL_ID, CURRENT_STATE  from IRIP2_EDQCONFIG.dn_case@ebstoows2.coresys.com)
select col.id,col. request_id, req.batch_id, req.case_state, req.case_status, req.case_workflow,  col. listfullname, col.x_state ebs_status
,xwrl_ows_utils.ChangeToOwsState(x_state) to_state
,xwrl_ows_utils.changeowsstate(CURRENT_STATE) ows_converted_state
,decode(substr(col.x_state,7),'Positive',4,'Possible',3,'False Positive',2,'Open',1) ebs_level
,decode(substr(xwrl_ows_utils.changeowsstate(CURRENT_STATE),7),'Positive',4,'Possible',3,'False Positive',2,'Open',1) ows_level
, ows_req.current_state ows_state, col.alertid, col.listrecordtype, col.creation_date, col.listid
from xwrl_response_ind_columns col
,xwrl_requests req
,ows_req
where col.request_id = req.id 
and col.alertid = ows_req.EXTERNAL_ID
and req.case_state not IN ('D')
and col.x_state <> xwrl_ows_utils.changeowsstate(CURRENT_STATE)
order by ebs_status
;

rmi_ows_common_util;
xwrl_utils;
xwrl_ows_utils;
mt_log_error;

select *
from xwrl_party_master
where id = 321162
;

select *
from xwrl_requests
where batch_id = 10463 
--and id = 20209
and case_id = 'OWS-201912-180414-36E518-IND' -- Note: this is the Master
--and case_id = 'OWS-201912-180414-D542D7-IND' -- Note: this is the Alias
;

select *
from xwrl_response_ind_columns
where request_id = 20208 -- Master
and alertid = 'SEN-9718649' -- Master
--and request_id = 20209 -- Alias
--and alertid = 'SEN-9718656' -- Alias
;

select *
from xwrl_response_entity_columns
;

select *
from xwrl_alert_clearing_xref
where source_table = 'SICD_SEAFARERS'
and source_id = 1134856
and list_id = 5409703  -- Note: the Alert ID is SEN-9718649 (Record for the Master)
--and alert_id =  'SEN-9718656'
order by id desc
;


select *
from mt_log
where upper(notes) like '%ALERT%'
order  by log_id desc;

select *
from all_source
--where lower(text) like '%auto_clear_individuals%'
where lower(text) like '%close_ows_alert%'
;

SELECT
   cols.*
FROM
   xwrl_requests               req
   , xwrl_response_ind_columns   cols
WHERE
   req.id = cols.request_id
   AND req.source_id = 1134856
   AND req.source_table = 'SICD_SEAFARERS'
   AND req.batch_id = 10463
   AND cols.listid = 5409703
   AND req.ID != 20208
   --AND cols.x_state !=   p_alert_in_tbl (i).p_to_state
ORDER BY
   cols.request_id;
   
   select *
   from all_source
   where type = 'TYPE'
   AND NAME = 'T_COUNTRYARRAY';
   
   select *
   from dba_types
   where lower(type_name) = 't_countryarray';
   
   
   rmi_ows_common_util;
xwrl_utils;
xwrl_ows_utils;


mt_log_error;


   
   SELECT *
   FROM ALL_OBJECTS
   WHERE OBJECT_NAME = 'RMI_OWS_COMMON_UTIL'
   ;
   
   
      SELECT *
   FROM ALL_OBJECTS
   WHERE OBJECT_NAME = 'XWRL_UTILS'
   ;
   
         SELECT *
   FROM ALL_OBJECTS
   WHERE OBJECT_NAME = 'XWRL_OWS_UTILS'
   ;
   
select *
from xwrl_requests
--where id between 54332 and 54382
order by id desc
;

SELECT apps.rmi_ows_common_util.get_sanction_status('US')
FROM dual;


select *
from xwrl_requests
where id = 2003
order by id desc
;

xwrl_ows_utils