SELECT * FROM DBA_SCHEDULER_JOB_CLASSES;

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
,enabled
 ,state
 ,next_run_date
, job_type
, job_action
--, number_of_arguments
, schedule_type, start_date, repeat_interval,  run_count, comments
FROM all_scheduler_jobs
where job_name like 'PROCESS%'
order by start_date desc
;

/* Check Running Jobs */

select owner, job_name
--,program_owner
--,program_name
,enabled
 ,state
 ,next_run_date
, job_type
, job_action
--, number_of_arguments
, schedule_type, start_date, repeat_interval,  run_count, comments
FROM all_scheduler_jobs
--where job_name like 'OWS%'
order by next_run_date
;


select *
from all_scheduler_job_run_details
where job_name like 'OWS%'
--where job_name = 'OWS_E_201903300203_50_JOB'
order by log_id desc
;

SELECT count(*)
FROM all_scheduler_jobs
where job_name like 'OWS%'
;

select length('https://www.world-check.com/portal/archive?uid=2730894&amp;url=http://e-disclosure.azipi.ru/organization/360533/ https://www.world-check.com/portal/archive?uid=2730894&amp;url=http://e-disclosure.ru/portal/company.aspx?id=10149 https://www.world-check.com/portal/archive?uid=2730894&amp;url=http://e-disclosure.ru/portal/company.aspx?id=12030 https://www.world-check.com/portal/archive?uid=2730894&amp;url=http://e-disclosure.ru/portal/company.aspx?id=12712 https://www.world-check.com/portal/archive?uid=2730894&amp;url=http://www.disclosure.ru/issuer/6660004997/ https://www.world-check.com/portal/archive?uid=2730894&amp;url=http://www.disclosure.ru/issuer/7900000373/') length
from dual
;

select length('Jewish Autonomous Region;Chelyabinsk Region;Tuva Republic;Karelia Republic;Tyumen Region;Sverdlovsk Region')
from dual;

/* Check Job History */

select *
from all_scheduler_jobs;



select *
from all_scheduler_job_run_details
where job_name like 'OWS%'
--where job_name = 'OWS_E_201903300203_50_JOB'
order by log_id desc
;
SELECT *
FROM XWRL_REQUESTS 
WHERE STATUS = 'ERROR';

--DELETE FROM XWRL_REQUESTS  WHERE STATUS = 'ERROR';


select *
from all_scheduler_job_run_details
--where job_name like 'OWS%'
order by log_id desc;

select *
from all_scheduler_job_run_details
where job_name like 'PROC%'
order by log_id desc
;

select *
from all_scheduler_job_run_details
where job_name like 'OWS%'
--where job_name = 'OWS_E_201903300203_50_JOB'
order by log_id desc
;


select substr(job_name,1,5), status
from all_scheduler_job_run_details
where job_name like 'OWS%'
--where job_name = 'OWS_E_201903300203_50_JOB'
group by substr(job_name,1,5), status
;

/* Check Job Run Times */

select run_duration, count(*)
from  all_scheduler_job_run_details
where log_date  >=  sysdate-1/24
and job_name like 'OWS%'
group by run_duration
order by 1 desc
;

select TO_CHAR (SYSDATE, 'YYYYMMDDHH24SS')
from dual;

declare
cursor c1 is 
select job_name
from all_scheduler_job_run_details
where job_name like 'OWS%'
and rownum <= 500;
begin
for c1rec in c1 loop
DBMS_SCHEDULER.PURGE_LOG(job_name=>c1rec.job_name);
end loop;
end;
/


begin
DBMS_SCHEDULER.PURGE_LOG();
end;
/







select owner, job_name
--,program_owner
--,program_name
,enabled
 ,state
 ,next_run_date
, job_type
, job_action
--, number_of_arguments
, schedule_type, start_date, repeat_interval,  run_count, comments
FROM all_scheduler_jobs
where job_name like 'OWS%'
order by next_run_date
;


select  state, count(*)
from all_scheduler_jobs
where job_name like 'OWS%'
--where job_name = 'OWS_E_201903300203_50_JOB'
group by state
;


SELECT
   trunc (d.actual_start_date, 'hh24') + (trunc (TO_CHAR (d.actual_start_date, 'mi') / :time_interval) * :time_interval) / 24 / 60 time_interval
   , COUNT (*) requests
   , round (AVG (EXTRACT (SECOND FROM d.run_duration)), 2) avg_time_sec
   , MIN (EXTRACT (SECOND FROM d.run_duration)) min_time_sec
   , MAX (EXTRACT (SECOND FROM d.run_duration)) max_time_sec
 from all_scheduler_job_run_details d
where job_name like 'OWS%'
 and trunc(d.ACTUAL_START_DATE) >= trunc(sysdate) - 365
 group by trunc (d.actual_start_date, 'hh24') + (trunc (TO_CHAR (d.actual_start_date, 'mi') / :time_interval) * :time_interval) / 24/ 60 order by 1 desc
 ;
 


select *
from all_scheduler_job_run_details
where job_name like 'OWS%'
--where job_name = 'OWS_E_201903300203_50_JOB'
order by log_id desc
;