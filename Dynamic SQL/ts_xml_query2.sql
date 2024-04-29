select owner, job_name
--,program_owner
--,program_name
, job_type
, job_action
--, number_of_arguments
, schedule_type, start_date, repeat_interval, enabled, state, run_count, next_run_date,comments
FROM all_scheduler_jobs
where job_name like 'PROCESS%'
order by start_date desc
;

select owner, job_name
--,program_owner
--,program_name
, job_type
, job_action
--, number_of_arguments
, schedule_type, start_date, repeat_interval, enabled, state, run_count, next_run_date,comments
FROM all_scheduler_jobs
where job_name like 'OWS%'
order by next_run_date
;

SELECT count(*)
FROM all_scheduler_jobs
where job_name like 'OWS%'
;

select *
from all_scheduler_job_run_details
WHERE job_name like 'PROCESS%'
--and rownum < 500
ORDER BY 1 DESC
;

select *
from all_scheduler_job_run_details
WHERE job_name like 'OWS%'
--and rownum < 500
ORDER BY 1 DESC
;