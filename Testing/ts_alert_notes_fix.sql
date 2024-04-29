select *
from XWRL_ALERT_NOTES 
order by id desc
;

select *
from xwrl_response_ind_columns
where alertid in ('SEN-12191210','SEN-12191214');

select *
from xwrl_requests
where id in (143741,143742)
;

select i.*, r.case_id
from xwrl_response_ind_columns  i
,xwrl_requests r
where i.request_id = r.id
and r.batch_id = 67872
and listid = 2866707
;

select n.*, r.case_id
from XWRL_ALERT_NOTES  n
,xwrl_requests r
where n.request_id = r.id
and r.batch_id = 67872
;

select *
from xwrl_requests
where batch_id = 67872
;

select *
from xwrl_response_ind_columns
;

select i.id,i.request_id,i.rec,listid,i.listfullname,i.alertid, r.case_id, i.x_state
from xwrl_response_ind_columns  i
,xwrl_requests r
where i.request_id = r.id
and r.batch_id = 96735
and i.listid = 4388172
AND (i.x_state != 'EDD - False Positive'  or i.x_state <> xwrl_ows_utils.changeowsstate('EDD - Open') )  -- tsuazo 20200714
;

select *
from xwrl_response_ind_columns
;

select i.id,i.request_id,i.rec,listid,i.listfullname,i.alertid, r.case_id, i.x_state
from xwrl_response_ind_columns  i
,xwrl_requests r
where i.request_id = r.id
and r.batch_id = 96735
and i.listid = 4388172
;

select i.id,i.request_id,i.rec,listid,i.listfullname,i.alertid, i.x_state, r.case_id, n.line_number, n.note, n.creation_date, n.created_by
from xwrl_response_ind_columns  i
,xwrl_requests r
,XWRL_ALERT_NOTES n
where i.request_id = r.id
and r.batch_id = 67895
and i.listid = 2866707
and i.request_id = n.request_id (+)
and i.alertid = n.alert_id (+)
;


select *
from xwrl_note_xref
order by id desc
;

select i.request_id, r.name_screened,r.case_id,i.alertid,i.rec,listid,i.listfullname, i.x_state, n.line_number, n.note, n.creation_date, n.created_by
from xwrl_response_ind_columns  i
,xwrl_requests r
,XWRL_ALERT_NOTES n
where i.request_id = r.id
and r.batch_id = 67895
and i.listid = 2866707
and i.request_id = n.request_id (+)
and i.alertid = n.alert_id (+)
order by request_id, rec
;

select i.request_id, r.case_id,i.alertid,i.rec,listid,i.listfullname, i.x_state, r.name_screened
from xwrl_response_ind_columns  i
,xwrl_requests r
where i.request_id = r.id
and r.batch_id = 67895
and i.listid = 2866707
order by request_id, rec
;

select i.request_id, r.name_screened,r.case_id,i.alertid,i.rec,listid, i.listrecordtype, i.listfullname, i.x_state, n.line_number, n.note, n.creation_date, n.created_by
from xwrl_response_ind_columns  i
,xwrl_requests r
,xwrl_note_xref x
,XWRL_ALERT_NOTES n
where i.request_id = r.id
and r.batch_id = 67895
and i.listid = 2866707
and i.request_id = x.request_id (+)
and i.alertid = x.alert_id (+)
and x.note_id = n.id (+)
order by request_id, rec
;

select *
from xwrl_note_xref
order by id desc
;
