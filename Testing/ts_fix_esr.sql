select *
from rmi_corp_esr_info
;

select *
from all_objects
where object_name like '%\_ESR\_%' ESCAPE '\'
ORDER BY LAST_DDL_TIME DESC
;


SELECT *
FROM ALL_OBJECTS
WHERE STATUS != 'VALID'
AND object_name like '%\_ESR\_%' ESCAPE '\'
ORDER BY OBJECT_NAME
;

RMI_CORP_ESR_CERT_PKG;

RMI_CORP_ESR_OWS_TC_PKG;

select e.esr_id
,e.corp_name
,e.ows_esr_req_id
,ows_req_batch_id
,ind.id ind_request_id
,ind.batch_id ind_batch_id
,e.ows_corp_esr_req_id
,e.ows_corp_req_batch_id
,corp.id corp_request_id
,corp.batch_id corp_batch_id
,resub.id resub_request_id
,resub.batch_id resub_batch_id
,e.esr_certificate_status
,e.esr_action
,e.creation_date
from rmi_corp_esr_info e
,xwrl_requests ind
,xwrl_requests corp
,xwrl_requests resub
--where e.esr_certificate_status != 'Active'
--where corp_number in (56140,85156)
--where unique_pin in  ('CJCCM6ENBM','0CHYDUHXC9')
--and trunc(e.creation_date) = trunc(sysdate)
where e.ows_esr_req_id = ind.id (+)
and e.ows_corp_esr_req_id = corp.id (+)
and e.ows_corp_esr_req_id = resub.resubmit_id (+)
--and e.ows_esr_req_id is null
--and resub.id is not null
--and upper(e.corp_name) = 'CELESTIAL HOLDINGS S.A.'
--and e.corp_name = 'CELESTIA HOLDINGS S.A.'
and e.esr_id = 1242
order by e.creation_date desc
;


select *
from xwrl_requests
--where resubmit_id = 258281
-- id = 258281
-- and batch_id = 120582
where id = 267092
;


select e.esr_id
,e.ows_esr_req_id
,ows_req_batch_id
,ind.id ind_request_id
,ind.batch_id ind_batch_id
,e.ows_corp_esr_req_id
,e.ows_corp_req_batch_id
,corp.id corp_request_id
,corp.batch_id corp_batch_id
,resub.id resub_request_id
,resub.batch_id resub_batch_id
,e.esr_certificate_status
,e.esr_action
,e.creation_date
from rmi_corp_esr_info e
,xwrl_requests ind
,xwrl_requests corp
,xwrl_requests resub
where e.esr_certificate_status != 'Active'
--where corp_number in (56140,85156)
--where unique_pin in  ('CJCCM6ENBM','0CHYDUHXC9')
and unique_pin = 'E46TMD8OHG'
--and trunc(e.creation_date) = trunc(sysdate)
and e.ows_esr_req_id = ind.id (+)
and e.ows_corp_esr_req_id = corp.id (+)
and e.ows_corp_esr_req_id = resub.resubmit_id (+)
and e.ows_esr_req_id is null
and resub.id is not null
order by e.creation_date desc
;

select *
from corp_main
where pin_number = 'E46TMD8OHG'
;


declare
cursor c1 is
select e.esr_id
,e.ows_esr_req_id
,ows_req_batch_id
,ind.id ind_request_id
,ind.batch_id ind_batch_id
,e.ows_corp_esr_req_id
,e.ows_corp_req_batch_id
,corp.id corp_request_id
,corp.batch_id corp_batch_id
,resub.id resub_request_id
,resub.batch_id resub_batch_id
,e.esr_certificate_status
,e.esr_action
,e.creation_date
from rmi_corp_esr_info e
,xwrl_requests ind
,xwrl_requests corp
,xwrl_requests resub
where e.esr_certificate_status != 'Active'
--where corp_number in (56140,85156)
--where unique_pin in  ('CJCCM6ENBM','0CHYDUHXC9')
and unique_pin = 'E46TMD8OHG'
--and trunc(e.creation_date) = trunc(sysdate)
and e.ows_esr_req_id = ind.id (+)
and e.ows_corp_esr_req_id = corp.id (+)
and e.ows_corp_esr_req_id = resub.resubmit_id (+)
and e.ows_esr_req_id is null
and resub.id is not null
order by e.creation_date desc
;

begin

for c1rec in c1 loop

update rmi_corp_esr_info
set ows_corp_esr_req_id = c1rec.resub_request_id
where esr_id = c1rec.esr_id;

commit;
end loop;
end;
/


select *
from xwrl_party_master
where source_table = 'CORP_MAIN' 
and source_id = 1034929
--where full_name = 'C&S ENTERPRISE, LTD.';
;

UPDATE xwrl_party_master
SET BATCH_ID = 124777
WHERE ID = 619845
;


SELECT *
FROM CORP_MAIN
WHERE pin_NUMBER = 'GN33MN4IER'
;

select *
from rmi_corp_esr_info e
WHERE unique_pin = 'GN33MN4IER'
;


select *
from all_objects
where object_name like '%\_ESR\_%' ESCAPE '\'
and object_type = 'TABLE'
ORDER BY object_type, object_name
;

SELECT *
FROM CORP_MAIN
WHERE corp_number = '71364'
;

select *
from xwrl_requests
where batch_id = 125819
;

SELECT *
FROM CORP_MAIN
--WHERE pin_NUMBER = :p_pin_number
WHERE pin_number in ('T3DWSHS2Z3','PNOCJV4AR5')
;

select e.ows_corp_esr_req_id
,e.ows_corp_req_batch_id
,e.*
from rmi_corp_esr_info e
--where tax_id_number is not null
--WHERE unique_pin = :p_pin_number
where corp_number = 71364
;

select *
from xwrl_requests
where batch_id = 125819
;

select * from RMI_CORP_ESR_DUE_DETAILS
WHERE CORP_ID = :p_corp_id
ORDER BY 1 DESC
;

select * from RMI_CORP_ESR_INFO 
WHERE esr_id = :p_esr_id
order by 1 desc
;


select det.*, c.corp_number, c.corp_name1, c.pin_number, decode(esr.esr_id,null,'No ESR Record',esr.esr_id) esr_record
from RMI_CORP_ESR_DUE_DETAILS det
,corp_main c
,RMI_CORP_ESR_INFO esr
where det.corp_id = c.corp_id
--and c.pin_number in ('T3DWSHS2Z3','PNOCJV4AR5','GN33MN4IER')
and c.corp_number = '34624'
and det.esr_id = esr.esr_id (+)
order by det.corp_id, det.creation_date desc
;

select det.*, c.corp_number, c.corp_name1, decode(esr.esr_id,null,'No ESR Record',esr.esr_id) esr_record
from RMI_CORP_ESR_DUE_DETAILS det
,corp_main c
,RMI_CORP_ESR_INFO esr
where det.corp_id = c.corp_id
and c.pin_number in ('T3DWSHS2Z3','PNOCJV4AR5','GN33MN4IER')
and det.esr_id = esr.esr_id (+)
order by det.corp_id, det.creation_date desc
;


update RMI_CORP_ESR_DUE_DETAILS
set due_date = to_date('28-AUG-2021','DD-MON-YYYY')
where corp_id = 1099549;

update RMI_CORP_ESR_DUE_DETAILS
set due_date = to_date('26-AUG-2021','DD-MON-YYYY')
where corp_id = 1091996;

update RMI_CORP_ESR_DUE_DETAILS
set due_date = to_date('09-JUL-2021','DD-MON-YYYY')
where corp_id = 1043269;

select * from RMI_CORP_ESR_INFO 
WHERE unique_pin = :p_pin_number
order by 1 desc
;

select * from RMI_ESR_CERT_DETAILS
where unique_tracking_number = :p_pin_number
;
