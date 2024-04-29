select master.id
,alias.note note_1
,master.to_state
,alias.to_state to_state_1 
,alias.last_update_date last_update_date_1
,alias.last_updated_by  last_updated_by_1
,alias.creation_date creation_date_1
,alias.created_by created_by_1
,alias.last_update_login last_update_login_1
from (
with mst_lst as 
(select master_id, list_id, max(id) max_id
from xwrl_alert_clearing_xref
where alias_id is null
and xref_id is null
group by master_id, list_id)
select x.*, r.batch_id
from xwrl_alert_clearing_xref x
,mst_lst
,xwrl_requests r
where x.id = mst_lst.max_id
and x.request_id = r.id) master
,(with mst_lst as 
(select master_id, list_id, max(id) max_id
from xwrl_alert_clearing_xref
where alias_id is not null
and xref_id is null
group by master_id, list_id)
select x.*,r.batch_id
from xwrl_alert_clearing_xref x
,mst_lst
,xwrl_requests r
where x.id = mst_lst.max_id
and x.request_id = r.id) alias
where master.master_id = alias.master_id
and master.list_id = alias.list_id
--and master.batch_id = alias.batch_id
--and master.to_state != alias.to_state
--and master.note = '[Full vetting to be completed upon the next transaction.]'
--and alias.note != '[Full vetting to be completed upon the next transaction.]'
--and substr(alias.to_state,7) = 'False Positive'
--and master.note = '[Legal Review.]'
--and substr(alias.to_state,7) = 'False Positive'
--and substr(alias.note,1,1) != '['
--and master.creation_date > alias.creation_date
and master.batch_id = 126133
order by master.batch_id desc
;

declare

cursor c1 is
select master.id
,alias.note note_1
,master.to_state
,alias.to_state to_state_1 
,alias.last_update_date last_update_date_1
,alias.last_updated_by  last_updated_by_1
,alias.creation_date creation_date_1
,alias.created_by created_by_1
,alias.last_update_login last_update_login_1
from (
with mst_lst as 
(select master_id, list_id, max(id) max_id
from xwrl_alert_clearing_xref
where alias_id is null
and xref_id is null
group by master_id, list_id)
select x.*, r.batch_id
from xwrl_alert_clearing_xref x
,mst_lst
,xwrl_requests r
where x.id = mst_lst.max_id
and x.request_id = r.id) master
,(with mst_lst as 
(select master_id, list_id, max(id) max_id
from xwrl_alert_clearing_xref
where alias_id is not null
and xref_id is null
group by master_id, list_id)
select x.*,r.batch_id
from xwrl_alert_clearing_xref x
,mst_lst
,xwrl_requests r
where x.id = mst_lst.max_id
and x.request_id = r.id) alias
where master.master_id = alias.master_id
and master.list_id = alias.list_id
--and master.batch_id = alias.batch_id
and master.to_state != alias.to_state
--and master.note = '[Full vetting to be completed upon the next transaction.]'
--and alias.note != '[Full vetting to be completed upon the next transaction.]'
--and substr(alias.to_state,7) = 'False Positive'
--and master.note = '[Legal Review.]'
--and substr(alias.to_state,7) = 'False Positive'
--and substr(alias.note,1,1) != '['
--and master.creation_date > alias.creation_date
and master.batch_id = 126133
order by master.batch_id desc
;

v_rec xwrl_alert_clearing_xref%rowtype;

begin

/* NOTE: This is to add MASTER record where ALIAS is most recently updated */

for c1rec in c1 loop

select * into v_rec from xwrl_alert_clearing_xref where id = c1rec.id;

v_rec.id := null;
v_rec.note := c1rec.note_1;
v_rec.from_state := c1rec.to_state;
v_rec.to_state := c1rec.to_state_1;
v_rec.last_update_date := c1rec.last_update_date_1;
v_rec.last_updated_by := c1rec.last_updated_by_1;
v_rec.creation_date := c1rec.creation_date_1;
v_rec.created_by := c1rec.created_by_1;
v_rec.last_update_login := c1rec.last_update_login_1;

insert into xwrl_alert_clearing_xref values v_rec;

commit;

end loop;
end;
/



declare

cursor c1 is
select alias.id
,master.note note_1
,alias.to_state
,master.to_state to_state_1 
,master.last_update_date last_update_date_1
,master.last_updated_by  last_updated_by_1
,master.creation_date creation_date_1
,master.created_by created_by_1
,master.last_update_login last_update_login_1
from (
with mst_lst as 
(select master_id, list_id, max(id) max_id
from xwrl_alert_clearing_xref
where alias_id is null
and xref_id is null
group by master_id, list_id)
select x.*, r.batch_id
from xwrl_alert_clearing_xref x
,mst_lst
,xwrl_requests r
where x.id = mst_lst.max_id
and x.request_id = r.id) master
,(with mst_lst as 
(select master_id, list_id, max(id) max_id
from xwrl_alert_clearing_xref
where alias_id is not null
and xref_id is null
group by master_id, list_id)
select x.*,r.batch_id
from xwrl_alert_clearing_xref x
,mst_lst
,xwrl_requests r
where x.id = mst_lst.max_id
and x.request_id = r.id) alias
where master.master_id = alias.master_id
and master.list_id = alias.list_id
--and master.batch_id = alias.batch_id
and master.to_state != alias.to_state
and master.note != 'Test'
--and alias.note = '[Full vetting to be completed upon the next transaction.]'
--and alias.note = '[Legal Review.]'
--and master.creation_date > alias.creation_date
and alias.note = '[Legal Review.]'
and master.creation_date < alias.creation_date
order by master.batch_id desc
;

v_rec xwrl_alert_clearing_xref%rowtype;

begin

/* NOTE: This is to add ALIAS record where MASTER is most recently updated */

for c1rec in c1 loop

select * into v_rec from xwrl_alert_clearing_xref where id = c1rec.id;

v_rec.id := null;
v_rec.note := c1rec.note_1;
v_rec.from_state := c1rec.to_state;
v_rec.to_state := c1rec.to_state_1;
v_rec.last_update_date := c1rec.last_update_date_1;
v_rec.last_updated_by := c1rec.last_updated_by_1;
v_rec.creation_date := c1rec.creation_date_1;
v_rec.created_by := c1rec.created_by_1;
v_rec.last_update_login := c1rec.last_update_login_1;

insert into xwrl_alert_clearing_xref values v_rec;

commit;

end loop;
end;
/