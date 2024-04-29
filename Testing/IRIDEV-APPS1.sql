select *
from xwrl_requests
where id = 12756 
;

-- request_id 12727
-- wc_screening_request_id 811703

select *
from xwrl_request_ind_columns
where request_id = :request_id
;

select *
from xwrl_request_entity_columns
where request_id = :request_id
;

select *
from xwrl_request_rows
where request_id = :request_id
;

select *
from xwrl_response_ind_columns
where request_id = :request_id
;

select *
from xwrl_response_entity_columns
where request_id = :request_id;


select *
from xwrl_response_rows
where request_id = :request_id
;

-- request_id 12764
-- wc_screening_request_id 	811644
-- wc_matches_id 1635265
-- wc_content_id 16798563


select count(*)
from wc_content
;

select *
from wc_matches
where wc_screening_request_id = :wc_screening_request_id
;

select *
from wc_content
where wc_screening_request_id = :wc_screening_request_id
and  wc_matches_id = :wc_matches_id
;

select *
from xwrl_wc_contents
where wc_screening_request_id = :wc_screening_request_id
and  wc_matches_id = :wc_matches_id
and wc_content_id = :wc_content_id
;


select *
from xwrl_wc_contents
where wc_screening_request_id = 809859
and wc_matches_id = 1631022
and wc_content_id = 16730133
;



create index vssl.WC_CONTENT_IDX4 on wc_content (wc_screening_request_id);