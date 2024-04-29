select *
from WC_SCREENING_REQUEST
where wc_screening_request_id in (887895, 887896, 887897)
order by wc_screening_request_id desc
;


select *
from WC_ALIASES
where alias_wc_screening_request_id in (887895, 887896, 887897)
order by alias_wc_screening_request_id desc
;

select request.wc_screening_request_id wc_screening_request_id, request.name_screened name_screened, request.alias_wc_screening_request_id alias_wc_screening_request_id,   recursive.name_screened  primary_name, alias.name_screened alias_name_screened
from WC_SCREENING_REQUEST request
,WC_SCREENING_REQUEST recursive
,WC_ALIASES alias
where request.wc_screening_request_id in (887895, 887896, 887897)
and request.alias_wc_screening_request_id = recursive.wc_screening_request_id (+)
and request.wc_screening_request_id = alias.alias_wc_screening_request_id (+)
order by request.wc_screening_request_id 
;

select request.wc_screening_request_id wc_screening_request_id, request.name_screened name_screened, request.alias_wc_screening_request_id  alias_wc_screening_request_id,   recursive.name_screened  primary_name, alias.name_screened alias_name_screened

from WC_SCREENING_REQUEST request

,WC_SCREENING_REQUEST recursive

,WC_ALIASES alias

where request.wc_screening_request_id in (686387, -- primary

                                         542, -- alias

                                         686396, --alias

                                         686397, -- alias

                                         686399 ) -- alias

and request.alias_wc_screening_request_id = recursive.wc_screening_request_id (+)

and request.wc_screening_request_id = alias.alias_wc_screening_request_id (+)

order by request.alias_wc_screening_request_id desc

select *
from WC_ALIASES
where alias_wc_screening_request_id in (798592,887895)
order by alias_wc_screening_request_id desc
;

select *
from WC_MATCHES
where wc_screening_request_id in (887895, 887896, 887897)
order by wc_screening_request_id desc
;

select * 
from WC_CONTENT
where wc_screening_request_id in (887895, 887896, 887897)
order by wc_screening_request_id desc
;


select *
from WC_ALIAS_SYNCH_WORKING
where wc_screening_request_id in (887895, 887896, 887897)
;

-- 887895
-- 887896
-- 887897


