select entry_name, entry_value
from (SELECT 'Running Jobs: ' entry_name, to_char(count(*))  entry_value, 10 FROM all_scheduler_jobs where job_name like 'OWS%'
union
select  job_name,enabled||' Next Run: '||to_char(next_run_date,'MM/DD/YYYY HH24:MI')||' End Date:  '||to_char(end_date,'MM/DD/YYYY HH24:MI'),20 FROM all_scheduler_jobs where job_name like 'PROCESS%'
union
select 'Complete: '  entry_name, to_char(count(*)) entry_value, 30 order_by from xwrl_requests where status =  'COMPLETE'
union
select 'Error: ',to_char(count(*)) ,40  from xwrl_requests where status =  'ERROR'
union
select 'Resubmit: ',to_char(count(*)),50  from xwrl_requests where status =  'RESUBMIT'
union
select 'Failed: ',to_char(count(*)),60  from xwrl_requests where status =  'FAILED'
union
select 'Delete: ',to_char(count(*)),65  from xwrl_requests where case_state = 'D'
union
select 'Instance', xwrl_utils.get_instance,70 from dual
union
select 'Max Jobs', to_char(xwrl_utils.get_max_jobs),90 from dual
union
select 'Max Pause', to_char(xwrl_utils.get_max_pause),100 from dual
union
select 'Max EBS Pause', to_char(xwrl_utils.get_ebs_pause),100 from dual
union
select 'Ratio', to_char(xwrl_utils.get_ratio),110 from dual
union
select 'Frequency',to_char(xwrl_utils.get_frequency),110 from dual
union
select 'Loadbalancer',xwrl_utils.get_wl_server ('LOADBALANCE_SERVER',xwrl_utils.get_instance),120 from dual
union
select 'Primary Server',xwrl_utils.get_wl_server ('PRIMARY_SERVER',xwrl_utils.get_instance),130 from dual
union
select 'Secondary Server',xwrl_utils.get_wl_server ('SECONDARY_SERVER',xwrl_utils.get_instance),140 from dual
union
select 'Job Queue Processes',value,150 from v$parameter where name='job_queue_processes'
union
select 'EDQ URL Path - Individual', value_string, 160 from xwrl_parameters where id = 'PATH' and key = 'INDIVIDUAL'
union
select 'EDQ URL Path - Entity', value_string, 170 from xwrl_parameters where id = 'PATH' and key = 'ENTITY'
union
select 'EDQ Compressed XML ', value_string, 180  from xwrl_parameters where id = 'XML' and key = 'COMPRESSED_XML'
order by 3)
;
