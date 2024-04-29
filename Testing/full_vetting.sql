select *
from xwrl_case_notes
where lower(note) like '%initial portion%'
;

select *
from xwrl_case_notes
where lower(note) like '%vetting%'
;

select *
from xwrl_case_notes
where lower(note) like '%provisional approval%'
;

select count(*)
from (select *
from xwrl_case_notes
where lower(note) like '%vetting%');

select count(*)
from (select *
from xwrl_case_notes
where lower(note) like '%provisional approval%');


select r.batch_id, r.case_id, u.user_name case_user,  rmi_ows_common_util.get_office(r.id) office, r.case_status, r.case_workflow, r.case_state, un.user_name note_user, n.note 
from xwrl_case_notes n
,xwrl_requests r
,fnd_user u
,fnd_user un
where n.request_id = r.id
and r.created_by = u.user_id
and n.created_by = un.user_id
and lower(n.note) like '%provisional approval%'
order by office, case_user
;

select *
from xwrl_alert_clearing_xref
where substr(from_state,7) = 'Open'
and substr(to_state,7) = 'Possible'
and note = '[Full vetting to be completed upon the next transaction.]';
;


select sum(alert_count)
from (with min_alert as
(select xx.alert_id, min(xx.id) min_id
from xwrl_alert_clearing_xref xx
group by xx.alert_id)
select u.user_name, count(*) alert_count
from xwrl_alert_clearing_xref x
,fnd_user u
,min_alert
where x.created_by = u.user_id 
and substr(x.from_state,7) = 'Open'
and substr(x.to_state,7) = 'Possible'
and x.note = '[Full vetting to be completed upon the next transaction.]'
and x.alert_id = min_alert.alert_id
and x.id = min_alert.min_id
group by u.user_name);

select count(unique alert_id)
from xwrl_alert_clearing_xref
;

select count(unique alertid)
from (
select alertid
from xwrl_response_ind_columns
union 
select alertid
from xwrl_response_entity_columns
)
;

with min_alert as
(select xx.alert_id, min(xx.id) min_id
from xwrl_alert_clearing_xref xx
group by xx.alert_id)
select u.user_name, count(*) alert_count
from xwrl_alert_clearing_xref x
,fnd_user u
,min_alert
where x.created_by = u.user_id 
and substr(x.from_state,7) = 'Open'
and substr(x.to_state,7) = 'Possible'
and x.note = '[Full vetting to be completed upon the next transaction.]'
and x.alert_id = min_alert.alert_id
and x.id = min_alert.min_id
group by u.user_name
order by 1
;


with min_alert as
(select xx.alert_id, min(xx.id) min_id
from xwrl_alert_clearing_xref xx
where substr(xx.from_state,7) = 'Open'
and substr(xx.to_state,7) = 'Possible'
and xx.note = '[Full vetting to be completed upon the next transaction.]'
group by xx.alert_id)
,max_alert as
(select xx.alert_id, max(xx.id) max_id
from xwrl_alert_clearing_xref xx
group by xx.alert_id)
select min_alert.alert_id, a.id initial_id, a.from_state intial_from_state, a.to_state intial_to_state, a.note intial_note, aa.user_name initial_user, a.creation_date initial_creation_date, b.id current_id,  b.from_state current_from_state, b.to_state current_to_state, b.note current_note, bb.user_name current_user, a.creation_date current_creation_date
from min_alert
,xwrl_alert_clearing_xref a
,fnd_user aa
,max_alert
,xwrl_alert_clearing_xref b
,fnd_user bb
where min_alert.alert_id = max_alert.alert_id (+)
and min_alert.min_id = a.id
and a.created_by = aa.user_id
and max_alert.max_id = b.id (+)
and b.created_by = bb.user_id (+)
order by a.id desc
;
