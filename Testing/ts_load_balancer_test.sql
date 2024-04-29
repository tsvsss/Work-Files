/* Note: Pre-Performance tuning the Max Jobs was set to 15
     75 - 400% improvement
     90 - 500% improvement (non-Prod can hit this but it's really close and sometimes rolls over which is ok)

*/

/* Stress Test - Prod  */
update xwrl_parameters
set value_string = 10
where id = 'MAX_JOBS'
and key = xwrl_utils.get_wl_server ('LOADBALANCE_SERVER',xwrl_utils.get_instance)
;

update xwrl_parameters
set value_string = 0
where id = 'MAX_PAUSE'
and key = xwrl_utils.get_wl_server ('LOADBALANCE_SERVER',xwrl_utils.get_instance)
;

update xwrl_parameters
set value_string = 0
where id = 'EBS_PAUSE'
and key = xwrl_utils.get_wl_server ('LOADBALANCE_SERVER',xwrl_utils.get_instance)
;


/* Stress Test - Non-Prod */
update xwrl_parameters
set value_string = 80
where id = 'LOADBALANCER'
and key = 'MAX_JOBS'
;

/* Reset PROD */

update xwrl_parameters
set value_string = 'IRIPRODOWS'
where id = 'LOADBALANCE_SERVER'
and key =  (select instance_name from v$instance);

update xwrl_parameters
set value_string = 'IRIPRODOWS-PRI'
where id = 'PRIMARY_SERVER'
and key =  (select instance_name from v$instance);

update xwrl_parameters
set value_string = 'IRIPRODOWS-SEC'
where id = 'SECONDARY_SERVER'
and key =  (select instance_name from v$instance);

/* Point Database to OWS PROD Primary (IRIPROD) */

update xwrl_parameters
set value_string = 32
where id = 'MAX_JOBS'
and key = xwrl_utils.get_wl_server ('LOADBALANCE_SERVER',xwrl_utils.get_instance)
;

update xwrl_parameters
set value_string = 7
where id = 'MAX_PAUSE'
and key = xwrl_utils.get_wl_server ('LOADBALANCE_SERVER',xwrl_utils.get_instance)
;

update xwrl_parameters
set value_string = 'IRIPRODOWS-PRI'
where id = 'LOADBALANCE_SERVER'
and key =  (select instance_name from v$instance);

update xwrl_parameters
set value_string = 'IRIPRODOWS-PRI'
where id = 'PRIMARY_SERVER'
and key =  (select instance_name from v$instance);

update xwrl_parameters
set value_string = 'IRIPRODOWS-PRI'
where id = 'SECONDARY_SERVER'
and key =  (select instance_name from v$instance);

/* Point Database  to OWS PROD Secondary (IRITEST) */

update xwrl_parameters
set value_string = 7
where id = 'MAX_JOBS'
and key = xwrl_utils.get_wl_server ('LOADBALANCE_SERVER',xwrl_utils.get_instance)
;

update xwrl_parameters
set value_string = 7
where id = 'MAX_PAUSE'
and key = xwrl_utils.get_wl_server ('LOADBALANCE_SERVER',xwrl_utils.get_instance)
;

update xwrl_parameters
set value_string = 'IRIPRODOWS-SEC'
where id = 'LOADBALANCE_SERVER'
and key =  (select instance_name from v$instance);

update xwrl_parameters
set value_string = 'IRIPRODOWS-SEC'
where id = 'PRIMARY_SERVER'
and key =  (select instance_name from v$instance);

update xwrl_parameters
set value_string = 'IRIPRODOWS-SEC'
where id = 'SECONDARY_SERVER'
and key =  (select instance_name from v$instance);

/* Reset NON-PROD */

update xwrl_parameters
set value_string = 'IRIDROWS'
where id = 'LOADBALANCE_SERVER'
and key =  (select instance_name from v$instance);

update xwrl_parameters
set value_string = 'IRIDROWS-PRI'
where id = 'PRIMARY_SERVER'
and key =  (select instance_name from v$instance);

update xwrl_parameters
set value_string = 'IRIDROWS-SEC'
where id = 'SECONDARY_SERVER'
and key =  (select instance_name from v$instance);

/*  Point database  to OWS NON-PROD Primary (IRIDR) */

update xwrl_parameters
set value_string = 10
where id = 'MAX_JOBS'
and key = xwrl_utils.get_wl_server ('LOADBALANCE_SERVER',xwrl_utils.get_instance)
;

update xwrl_parameters
set value_string = 7
where id = 'MAX_PAUSE'
and key = xwrl_utils.get_wl_server ('LOADBALANCE_SERVER',xwrl_utils.get_instance)
;

update xwrl_parameters
set value_string = 'IRIDROWS-PRI'
where id = 'LOADBALANCE_SERVER'
and key =  (select instance_name from v$instance);

update xwrl_parameters
set value_string = 'IRIDROWS-PRI'
where id = 'PRIMARY_SERVER'
and key =  (select instance_name from v$instance);

update xwrl_parameters
set value_string = 'IRIDROWS-PRI'
where id = 'SECONDARY_SERVER'
and key =  (select instance_name from v$instance);

/* Point datebase  to OWS NON-PRODSecondary (IRIDEV) */

update xwrl_parameters
set value_string = 7
where id = 'MAX_JOBS'
and key = xwrl_utils.get_wl_server ('LOADBALANCE_SERVER',xwrl_utils.get_instance)
;

update xwrl_parameters
set value_string = 7
where id = 'MAX_PAUSE'
and key = xwrl_utils.get_wl_server ('LOADBALANCE_SERVER',xwrl_utils.get_instance)
;

update xwrl_parameters
set value_string = 'IRIDROWS-SEC'
where id = 'LOADBALANCE_SERVER'
and key =  (select instance_name from v$instance);

update xwrl_parameters
set value_string = 'IRIDROWS-SEC'
where id = 'PRIMARY_SERVER'
and key =  (select instance_name from v$instance);

update xwrl_parameters
set value_string = 'IRIDROWS-SEC'
where id = 'SECONDARY_SERVER'
and key =  (select instance_name from v$instance);


select *
from xwrl_parameters
where ID = 'MAX_JOBS'
;



update xwrl_parameters
set value_string = 1
where id = 'MAX_PAUSE'
and key = xwrl_utils.get_wl_server ('LOADBALANCE_SERVER',xwrl_utils.get_instance)
;

/* Check current parameter values */

select 'Instance', xwrl_utils.get_instance,1 from dual
union
select 'Job Queue Processes',value,2 from v$parameter where name='job_queue_processes'
union
select 'Max Jobs', to_char(xwrl_utils.get_max_jobs),3 from dual
union
select 'Ratio', to_char(xwrl_utils.get_ratio),4 from dual
union
select 'Frequency',to_char(xwrl_utils.get_frequency),5 from dual
union
select 'Loadbalancer',xwrl_utils.get_wl_server ('LOADBALANCE_SERVER',xwrl_utils.get_instance),6 from dual
union
select 'Primary Server',xwrl_utils.get_wl_server ('PRIMARY_SERVER',xwrl_utils.get_instance),7 from dual
union
select 'Secondary Server',xwrl_utils.get_wl_server ('SECONDARY_SERVER',xwrl_utils.get_instance),8 from dual
order by 3;

select *
from xwrl_requests
order by id desc;