select *
from all_objects
where object_name like 'XWRL\_%' escape '\'
--and object_name like '%\_IDX%' escape '\'
--and owner = 'XWRL'
--and object_type = 'SEQUENCE'
order by object_type, object_name
;


select *
from all_objects
where object_name like 'XWRL\_%' escape '\'
and owner = 'APPS'
and object_type = 'SYNONYM'
order by object_type, object_name
;

select 'DROP SYNONYM '||lower(object_name)||';'
from all_objects
where object_name like 'XWRL\_%' escape '\'
and owner = 'APPS'
and object_type = 'SYNONYM'
order by object_type, object_name
;

select 'CREATE SYNONYM '||lower(object_name)||' FOR xwrl.'||lower(object_name)||';'
from all_objects
where object_name like 'XWRL\_%' escape '\'
and owner = 'APPS'
and object_type = 'SYNONYM'
order by object_type, object_name
;

select *
from all_objects
where object_name like 'XWRL\_%' escape '\'
and object_name like '%\_IDX%' escape '\'
and owner = 'XWRL'
and object_type = 'INDEX'
order by object_type, object_name
;

select 'DROP TABLE '||object_name||'  CASCADE CONSTRAINTS;'
from all_objects
where object_name like 'XWRL\_%' escape '\'
--and object_name like '%\_IDX%' escape '\'
and owner = 'XWRL'
and object_type = 'TABLE'
order by object_type, object_name
;

select 'CREATE SEQUENCE xwrl.'||lower(object_name) ||' START WITH 1000 NOCACHE;'
from all_objects
where object_name like 'XWRL\_%' escape '\'
--and object_name like '%\_IDX%' escape '\'
and owner = 'XWRL'
and object_type = 'SEQUENCE'
order by object_type, object_name
;
select  'DROP SEQUENCE '||object_name||' ;'
from all_objects
where object_name like 'XWRL\_%' escape '\'
--and object_name like '%\_IDX%' escape '\'
and owner = 'XWRL'
and object_type = 'SEQUENCE'
order by object_type, object_name
;

select *
from all_objects
where object_name like 'XWRL\_%' escape '\'
--and object_name like '%\_IDX%' escape '\'
and owner = 'XWRL'
and object_type = 'TABLE'
order by object_type, object_name
;




SELECT *
FROM all_constraints
where owner = 'XWRL'
and constraint_name like 'XWRL\_%' escape '\'
;

SELECT *
FROM all_triggers
where owner = 'XWRL'
and trigger_name like 'XWRL\_%' escape '\'
order by 2
;


select *
from all_objects
where object_name like 'XWRL\_%' escape '\'
and owner = 'APPS'
and object_type = 'SYNONYM'
order by object_type, object_name
;

select *
from all_objects
where object_name like 'XWRL\_%' escape '\'
and object_name like '%\_IDX%' escape '\'
and owner = 'XWRL'
and object_type = 'INDEX'
order by object_type, object_name
;

select 'DROP TABLE '||object_name||'  CASCADE CONSTRAINTS;'
from all_objects
where object_name like 'XWRL\_%' escape '\'
--and object_name like '%\_IDX%' escape '\'
and owner = 'XWRL'
and object_type = 'TABLE'
order by object_type, object_name
;

select 'CREATE SEQUENCE xwrl.'||lower(object_name) ||' START WITH 1000 NOCACHE;'
from all_objects
where object_name like 'XWRL\_%' escape '\'
--and object_name like '%\_IDX%' escape '\'
and owner = 'XWRL'
and object_type = 'SEQUENCE'
order by object_type, object_name
;
select  'DROP SEQUENCE '||object_name||' ;'
from all_objects
where object_name like 'XWRL\_%' escape '\'
--and object_name like '%\_IDX%' escape '\'
and owner = 'XWRL'
and object_type = 'SEQUENCE'
order by object_type, object_name
;

select *
from all_objects
where object_name like 'XWRL\_%' escape '\'
--and object_name like '%\_IDX%' escape '\'
and owner = 'XWRL'
and object_type = 'TABLE'
order by object_type, object_name
;

select *
from all_objects
where object_name like 'XWRL\_%' escape '\'
--and object_name like '%\_IDX%' escape '\'
and owner = 'XWRL'
and object_type = 'SEQUENCE'
order by object_type, object_name
;


SELECT *
FROM all_constraints
where owner = 'XWRL'
and constraint_name like 'XWRL\_%' escape '\'
;

SELECT *
FROM all_triggers
where owner = 'XWRL'
and trigger_name like 'XWRL\_%' escape '\'
order by 2
;