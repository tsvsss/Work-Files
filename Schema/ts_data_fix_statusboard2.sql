declare
cursor c1 is
select req.id, wc.sent_to_legal_date, wc.sent_to_legal_by, wc.creation_date, wc.created_by, wc.last_update_date, wc.last_updated_by, wc.last_update_login,  rmi_ows_common_util.get_department (req.id) department_ext
from xwrl_requests req
,wc_screening_request wc
where req.wc_screening_request_id = wc.wc_screening_request_id
;

begin

for c1rec in c1 loop

update xwrl_requests
set sent_to_legal_date = c1rec.sent_to_legal_date
,sent_to_legal_by = c1rec.sent_to_legal_by
,creation_date = c1rec.creation_date
,created_by = c1rec.created_by
,last_update_date = c1rec.last_update_date
,last_updated_by = c1rec.last_updated_by
,last_update_login = c1rec.last_update_login
,department_ext = c1rec.department_ext
where id = c1rec.id
;

end loop;

commit;

end;
/