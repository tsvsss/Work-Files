/* Update Job Processing Parameters */

update xwrl_parameters
set value_string = 15
where id = 'LOADBALANCER'
and key = 'MAX_JOBS'
;

update xwrl_parameters
set value_string = 3
where id = 'LOADBALANCER'
and key = 'RATIO'
;

-- Update of frequence will not take effect until World-Check-Jobs.sql is run again 

update xwrl_parameters
set value_string = 5
where id = 'FREQUENCY'
and key =  (select instance_name from v$instance)
;


/* Point Database to Load Balancer */

update xwrl_parameters
set value_string = 'IRIPRODOWS'
where id = 'LOADBALANCE_SERVER'
and key =  (select instance_name from v$instance);

update xwrl_parameters
set value_string = 'IRIDROWS'
where id = 'LOADBALANCE_SERVER'
and key =  (select instance_name from v$instance);

/*  Point database  to OWS non-Prod Primary */

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


/* Point datebase  to OWS non-Prod Secondary */

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


/* Point Database to OWS Prod Primary */

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

/* Point Database  to OWS Prod Secondary */

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

/* Check current parameter values */

select 'Instance', xwrl_utils.get_instance,1 from dual
union
select 'Max Jobs', to_char(xwrl_utils.get_max_jobs),2 from dual
union
select 'Ratio', to_char(xwrl_utils.get_ratio),3 from dual
union
select 'Frequency',to_char(xwrl_utils.get_frequency),4 from dual
union
select 'Loadbalancer',xwrl_utils.get_wl_server ('LOADBALANCE_SERVER',xwrl_utils.get_instance),5 from dual
union
select 'Primary Server',xwrl_utils.get_wl_server ('PRIMARY_SERVER',xwrl_utils.get_instance),6 from dual
union
select 'Secondary Server',xwrl_utils.get_wl_server ('SECONDARY_SERVER',xwrl_utils.get_instance),7 from dual
order by 3;

