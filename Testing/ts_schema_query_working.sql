T20200814.0043 - OWS-WC Notes not transferring for MIN CHEN, Corp # 63677, Batch Id 126133

T20200814.0048 - OWS - WC Notes not transferring for WANG JIA/JIA WANG FIN: 1373505 Batch Id 126257


select *
from xwrl_requests
where batch_id = 126129
--where id = 269198
;




select *
from xwrl_requests
where batch_id = 126133;

-- Master_id Xref_id
269198  -- 79828  4877397  MIN CHEN
269200   -- 79828  4877398   ZHIQIANG ZHOU

select *
from xwrl_response_ind_columns
where request_id = 269198
;




select *
from xwrl_alert_clearing_xref
where master_id = 79828
and xref_id = 4877397
--and xref_id = 4877398
order by request_id desc
;

-- Cheyenna took care of this one

select *
from xwrl_requests
where batch_id = 126257;

-- Master_id Alias_id

269420  -- 620494  JIA WANG
269426  -- 620494	344666  WANG JIA

select *
from xwrl_response_ind_columns
where request_id = 269426
;

select corp_id
from corp_main
where corp_number = '85708'
;

select *
from iri_edocs
where identifier = '1091920'
;

select *
from iri_edocs
where identifier = '85708'
;

update xwrl.xwrl_party_master
set request_id = 235634
where id = 41117;

update xwrl.xwrl_party_alias
set request_id = 235635
where id = 24741;


select *
from xwrl_requests
where batch_id = 127474
;

select *
from xwrl_party_master
where id = 621031
;


select esr_certificate_status 
from rmi_corp_esr_info
WHERE confirmation_number = 'X8IG0C92'
;

SELECT *
FROM xwrl_party_master
--where full_name like 'BAYI%'
WHERE id = 620283
;

SELECT *
FROM rmi_corp_esr_info
WHERE corp_id = 1075942
;

-- TABLES
--rmi_corp_esr_info
--rmi_corp_esr_due_details



select det.*, c.corp_number, c.corp_name1, c.pin_number, decode(esr.esr_id,null,'No ESR Record',esr.esr_id) esr_record
from RMI_CORP_ESR_DUE_DETAILS det
,corp_main c
,RMI_CORP_ESR_INFO esr
where det.corp_id = c.corp_id
and c.corp_number = '71364'
and det.esr_id = esr.esr_id (+)
order by det.corp_id, det.creation_date desc
;

select e.esr_id
,e.ows_esr_req_id
,e.unique_pin
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
where e.corp_id = 1075942
--where corp_number in (56140,85156)
--where unique_pin in  ('CJCCM6ENBM','0CHYDUHXC9')
--and unique_pin = '0V7T43HY28'
--and trunc(e.creation_date) = trunc(sysdate)
and e.ows_esr_req_id = ind.id (+)
and e.ows_corp_esr_req_id = corp.id (+)
and e.ows_corp_esr_req_id = resub.resubmit_id (+)
and e.ows_esr_req_id is null
and resub.id is not null
order by e.creation_date desc
;