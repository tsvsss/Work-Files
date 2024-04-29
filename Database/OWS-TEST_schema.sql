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
FROM IRIDR_EDQCONFIG.DN_SD_TABLES;

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
and owner = 'IRIDR_EDQCONFIG'
ORDER BY OWNER, OBJECT_NAME
;

select *
from all_tables
where owner = 'APEX_050000'
--where owner not in ('SYS')
AND table_NAME LIKE '%STATE%'
order by 2
;

SELECT *
FROM APEX_050000.WWV_FLOW_TREE_STATE
;

DESC APEX_050000.WWV_FLOW_PROCESS_NATIVE;

SELECT *
FROM ALL_OBJECTS
WHERE OBJECT_NAME LIKE '%WWV_FLOW%'
AND OBJECT_TYPE NOT in ('INDEX')
ORDER BY OBJECT_NAME
;

SELECT *
FROM ALL_OBJECTS
WHERE OBJECT_NAME LIKE '%API%'
AND OBJECT_TYPE NOT in ('INDEX')
AND OWNER = 'PUBLIC'
ORDER BY OBJECT_NAME
;

DESC WWV_FLOW_API;

SELECT *
FROM ALL_SOURCE
WHERE TEXT LIKE '%STATE%';

select *
from all_views
where owner = 'APEX_050000'
--where owner not in ('SYS')
AND VIEW_NAME LIKE '%STATE%'
order by 2
;

select *
from APEX_APPLICATION_LOVS
where list_of_values_name like '%STATE%'
ORDER BY LIST_OF_VALUES_NAME
;

/* looking for workflow state lov */

select *
from IRIDR_EDQCONFIG.DN_CASE;

select *
from IRIDR_EDQCONFIG.DN_USER;



select *
from (
select *
from IRIDR_EDQCONFIG.DN_CASE
union
select *
from IRIDR2_EDQCONFIG.DN_CASE)
where external_id = 'SEN-9124705'
;

select *
from all_source
where UPPER(text) like '%DN\_CASE%' escape '\'
;


SELECT UNIQUE OWNER
FROM ALL_tables
ORDER BY 1
;

SELECT UNIQUE OWNER
FROM ALL_VIEWS
ORDER BY 1
;

SELECT *
FROM ALL_VIEWS
WHERE owner = 'IRIDR_EDQSTAGING'
;


select  id, version, case_group, case_type, external_id, description, priority, current_state
from (
select *
from IRIDR_EDQCONFIG.DN_CASE
union
select *
from IRIDR2_EDQCONFIG.DN_CASE)
where external_id = 'SEN-9124705'
;

select *
from all_tab_columns
where column_name = 'CUST_ID'
;

select *
from all_tab_columns
where column_name = 'CUSTID'
;

select *
from all_tab_columns
where column_name like '%CUSTOMSTRING%'
;


SELECT *
FROM all_tables
where owner = 'IRIDR_EDQCONFIG'
ORDER BY OWNER, table_name
;

SELECT *
FROM all_tables
where table_name like 'DN\_%' escape '\'
and table_name not like 'DN\_UD\_%' escape '\'
and owner = 'IRIDR_EDQCONFIG'
ORDER BY OWNER, table_name
;

select * from IRIDR_EDQCONFIG.DN_UD_9;

SELECT 'select * from '||owner||'.'||table_name||';'
FROM all_tables
where table_name like 'DN\_%' escape '\'
and table_name not like 'DN\_UD\_%' escape '\'
and owner = 'IRIDR_EDQCONFIG'
ORDER BY OWNER, table_name;

select * from IRIDR_EDQCONFIG.DN_ACCESSPERMISSIONS;
select * from IRIDR_EDQCONFIG.DN_ATTACHMENT;
select * from IRIDR_EDQCONFIG.DN_AUDITLOG;
select * from IRIDR_EDQCONFIG.DN_CASE;
select * from IRIDR_EDQCONFIG.DN_CASEATTACHMENT;
select * from IRIDR_EDQCONFIG.DN_CASECOMMENT;
select * from IRIDR_EDQCONFIG.DN_CASEHISTORY;
select * from IRIDR_EDQCONFIG.DN_CASEMETADATA;
select * from IRIDR_EDQCONFIG.DN_CASESOURCES;
select * from IRIDR_EDQCONFIG.DN_CASESTARTUP;
select * from IRIDR_EDQCONFIG.DN_CASESTORE;
select * from IRIDR_EDQCONFIG.DN_CASETRANSITIONS;
select * from IRIDR_EDQCONFIG.DN_CASEVERSION;
select * from IRIDR_EDQCONFIG.DN_DASHBOARDELEMENT;
select * from IRIDR_EDQCONFIG.DN_DEAGGREGATION;
select * from IRIDR_EDQCONFIG.DN_DEFAULTSTATUSRULE;
select * from IRIDR_EDQCONFIG.DN_DEPENDENCY;
select * from IRIDR_EDQCONFIG.DN_DEREALTIMEAGGREGATION;
select * from IRIDR_EDQCONFIG.DN_DESTATUSRULE;
select * from IRIDR_EDQCONFIG.DN_DETYPE;
select * from IRIDR_EDQCONFIG.DN_DGSYSTEMS;
select * from IRIDR_EDQCONFIG.DN_DIRTABLECOLUMNINFO;
select * from IRIDR_EDQCONFIG.DN_EVENTLOG2;
select * from IRIDR_EDQCONFIG.DN_EVENTLOGTERMS;
select * from IRIDR_EDQCONFIG.DN_EXTUSERMAP;
select * from IRIDR_EDQCONFIG.DN_GROUPHASPERMISSION;
select * from IRIDR_EDQCONFIG.DN_IDENTITY;
select * from IRIDR_EDQCONFIG.DN_ISSUE;
select * from IRIDR_EDQCONFIG.DN_LUCENEX8;
select * from IRIDR_EDQCONFIG.DN_PERIODICDESTATS;
select * from IRIDR_EDQCONFIG.DN_RESOURCEVALUE;
select * from IRIDR_EDQCONFIG.DN_RUNINFORMATION;
select * from IRIDR_EDQCONFIG.DN_SESSIONHISTORY;
select * from IRIDR_EDQCONFIG.DN_SOURCEDISPLAY;
select * from IRIDR_EDQCONFIG.DN_SOURCEWORKFLOWS;
select * from IRIDR_EDQCONFIG.DN_STATUSMETRIC;
select * from IRIDR_EDQCONFIG.DN_SUPPLEMENTARYDATA;
select * from IRIDR_EDQCONFIG.DN_SUPPLEMENTARYDISPLAY;
select * from IRIDR_EDQCONFIG.DN_TASKSTATUS;
select * from IRIDR_EDQCONFIG.DN_TEXTSTUFF;
select * from IRIDR_EDQCONFIG.DN_USER;
select * from IRIDR_EDQCONFIG.DN_USERDASHBOARDELEMENT;
select * from IRIDR_EDQCONFIG.DN_USERGRAVEYARD;
select * from IRIDR_EDQCONFIG.DN_USERGROUP;
select * from IRIDR_EDQCONFIG.DN_USERGROUPCANSEEDE;
select * from IRIDR_EDQCONFIG.DN_USERINGROUP;
select * from IRIDR_EDQCONFIG.DN_VERSION;
select * from IRIDR_EDQCONFIG.DN_XSTORE;
select * from IRIDR_EDQCONFIG.DN_XTREE;


40a5142292ad2577c3b869fd228d5b70

SELECT *
FROM all_tables
where table_name like 'DN\_%' escape '\'
and table_name not like 'DN\_UD\_%' escape '\'
and owner = 'IRIDR_EDQRESULTS'
ORDER BY OWNER, table_name
;

SELECT 'select * from '||owner||'.'||table_name||';'
FROM all_tables
where table_name like 'DN\_%' escape '\'
and table_name not like 'DN\_UD\_%' escape '\'
and owner = 'IRIDR_EDQRESULTS'
ORDER BY OWNER, table_name;

select * from  IRIDR_EDQRESULTS.DN_TABLECOLUMNINFO;

SELECT *
FROM ALL_TABLES
where owner = 'IRIDR_EDQSTAGING'
and table_name like 'EDQ%' escape '\'
;

SELECT *
FROM IRIDR_EDQSTAGING.EDQCDS_CANDIDATES_IND
;

SELECT *
FROM IRIDR_EDQSTAGING.EDQCDS_CANDIDATES_ENT
;