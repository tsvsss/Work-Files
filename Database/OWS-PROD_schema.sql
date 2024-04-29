select *
from all_users
where username like 'IRI%'
order by 1
;

select *
from all_objects
where owner in ( 'IRIP1_EDQCONFIG','IRIP1_EDQRESULTS','IRIP1_EDQSTAGING')
and object_type not in ('TABLE','INDEX')
;

select *
from all_objects
where owner in ( 'IRIP1_EDQCONFIG','IRIP1_EDQRESULTS','IRIP1_EDQSTAGING')
and object_type = 'TABLE'
;

SELECT *
FROM IRIP1_EDQRESULTS.DN_SD_TABLES;

SELECT *
FROM all_objects
where object_name like '%CASE%'
and object_type not in ('INDEX')
ORDER BY OWNER, OBJECT_NAME
;

SELECT *
FROM all_objects
where object_name like '%ALERT%'
and object_type not in ('INDEX')
ORDER BY OWNER, OBJECT_NAME
;

SELECT *
FROM all_objects
where object_name like '%DATA%'
and object_type not in ('INDEX')
ORDER BY OWNER, OBJECT_NAME
;

SELECT *
FROM all_objects
where object_name like 'DN\_%' escape '\'
and object_name not like 'DN\_UD\_%' escape '\'
and object_type not in ('INDEX')
and owner = 'IRIP1_EDQCONFIG'
ORDER BY OWNER, OBJECT_NAME
;


select *
from IRIP1_EDQCONFIG.DN_CASE;

select *
from IRIP1_EDQCONFIG.DN_USER;


select *
from IRIP1_EDQCONFIG.DN_CASE
UNION
select *
from IRIP2_EDQCONFIG.DN_CASE;