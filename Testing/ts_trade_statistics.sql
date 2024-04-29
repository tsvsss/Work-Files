select path
,decode(matches,0,'N','Y') matches_found
, XWRL_DATA_PROCESSING.get_office(office) office
, XWRL_DATA_PROCESSING.get_case_status(case_status) case_status
, XWRL_DATA_PROCESSING.get_case_workflow(case_workflow) case_workflow
, XWRL_DATA_PROCESSING.get_case_state(case_state) case_state
, XWRL_DATA_PROCESSING.contains_legal_review(path,id) legal_review
, count(*)
from xwrl_requests
group by path,decode(matches,0,'N','Y') , office, case_status, case_workflow, case_state,XWRL_DATA_PROCESSING.contains_legal_review(path,id)
order by 1, 2, 3, 4, 5,6,7
;