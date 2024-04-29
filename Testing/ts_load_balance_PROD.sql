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