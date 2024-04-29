/* Check Server Status */

declare

is_service_available boolean;
v_status varchar2(10);
v_server varchar2(30);

type v_rec is record (v_server varchar2(50));

type v_tab is table of v_rec index by binary_integer;

v_list v_tab;

begin

v_list(1).v_server := 'IRIPRODOWS-PRI';
v_list(2).v_server := 'IRIPRODOWS-SEC';
v_list(3).v_server := 'IRIPRODDOWS';
v_list(4).v_server := 'IRIDROWS-PRI';
v_list(5).v_server := 'IRIDROWS-SEC';
v_list(6).v_server := 'IRIDROWS';

for i in  v_list.first..v_list.last  loop

v_server := v_list(i).v_server;
is_service_available :=  xwrl_utils.test_ows_web_service (p_debug => false, p_server => v_server, p_service_name => 'EDQ');

if is_service_available then
   v_status := 'true';
else v_status := 'false';
end if;

dbms_output.put_line('server: '||v_server||' status: '||v_status);

end loop;

end;
/
/* Check database job queues setting */

select * from v$parameter where name='job_queue_processes';

/* Check Master Scheduler Jobs */

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

/* Check Running Jobs */

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


/* Check Job History */

select *
from all_scheduler_job_run_details
where job_name like 'PROC%'
order by log_id desc
;

select *
from all_scheduler_job_run_details
where job_name like 'OWS%'
order by log_id desc
;

/* Check Job Run Times */

select run_duration
from  all_scheduler_job_run_details
group by run_duration
order by 1 desc
;

