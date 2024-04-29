select *
from v$tablespace
order by name
;

select *
from v$datafile
;

select t.name tablespace, d.name datafile, d.create_bytes
from v$tablespace t
,v$datafile d
where t.ts# = d.ts#
;

select nvl(b.tablespace_name,
nvl(a.tablespace_name,'UNKOWN')) name,
kbytes_alloc kbytes,
kbytes_alloc-nvl(kbytes_free,0) used,
nvl(kbytes_free,0) free,
round(((kbytes_alloc-nvl(kbytes_free,0))/
kbytes_alloc)*100,2) pct_used,
nvl(largest,0) largest
from ( select sum(bytes)/1024 Kbytes_free,
max(bytes)/1024 largest,
tablespace_name
from sys.dba_free_space
group by tablespace_name ) a,
( select sum(bytes)/1024 Kbytes_alloc,
tablespace_name
from sys.dba_data_files
group by tablespace_name )b
where a.tablespace_name (+) = b.tablespace_name
--order by pct_used desc;
and a.tablespace_name like '%RES'
order by name
;

select t.name tablespace, d.name datafile, d.create_bytes
from v$tablespace t
,v$datafile d
where t.ts# = d.ts#
and t.name = :tablespace
;

alter tablespace  IRIDR_EDQ_RES add datafile '/iridrows/data01/IRIDROWS/IRIDR_edq_res8.dbf' size 10g;
alter tablespace  IRIDR_EDQ_RES add datafile '/iridrows/data01/IRIDROWS/IRIDR_edq_res9.dbf' size 10g;
alter tablespace  IRIDR_EDQ_RES add datafile '/iridrows/data01/IRIDROWS/IRIDR_edq_res10.dbf' size 10g;
alter tablespace  IRIDR_EDQ_RES add datafile '/iridrows/data01/IRIDROWS/IRIDR_edq_res11.dbf' size 10g;
alter tablespace  IRIDR_EDQ_RES add datafile '/iridrows/data01/IRIDROWS/IRIDR_edq_res12.dbf' size 10g;

alter tablespace  IRIDR_EDQ_RES add datafile '/iridrows/data01/IRIDROWS/IRIDR_edq_res13.dbf' size 10g;
alter tablespace  IRIDR_EDQ_RES add datafile '/iridrows/data01/IRIDROWS/IRIDR_edq_res14.dbf' size 10g;
alter tablespace  IRIDR_EDQ_RES add datafile '/iridrows/data01/IRIDROWS/IRIDR_edq_res15.dbf' size 10g;

alter tablespace  IRIP1_EDQ_CONF add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_conf1.dbf' size 20g;

alter tablespace  IRIDR_EDQ_CONF add datafile '/iridrows/data01/IRIDROWS/IRIDR_EDQ_CONF_004.dbf' size 5g;
alter tablespace  IRIDR_EDQ_CONF add datafile '/iridrows/data01/IRIDROWS/IRIDR_EDQ_CONF_006.dbf' size 10g;

alter tablespace  IRIDR_EDQ_CONF add datafile '/iridrows/data01/IRIDROWS/IRIDR_EDQ_CONF_005.dbf' size 5g;
alter tablespace  IRIDR2_EDQ_CONF add datafile '/iridrows/data01/IRIDROWS/IRIDR2_edq_conf_002.dbf' size 5g;
alter tablespace  IRIDR2_EDQ_CONF add datafile '/iridrows/data01/IRIDROWS/IRIDR2_edq_conf_003.dbf' size 10g


;

alter tablespace  SYSAUX add datafile '/iripows/data01/IRIPOWS/sysaux02.dbf' size 1g;

alter tablespace  SYSAUX add datafile '/iridrows/data01/IRIDROWS/sysaux01_002.dbf' size 1g;

alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res8.dbf' size 10g;

alter tablespace  IRIP2_EDQ_CONF add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_conf2.dbf' size 10g;

alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res9.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res10.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res11.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res12.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res13.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res14.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res15.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res16.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res17.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res18.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res19.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res20.dbf' size 10g;

alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res21.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res22.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res23.dbf' size 10g;



alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res24.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res25.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res26.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res27.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res28.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res29.dbf' size 10g;


alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res30.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res31.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res32.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res33.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res34.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res35.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res36.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res37.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res38.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res39.dbf' size 10g;
alter tablespace  IRIP1_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_res40.dbf' size 10g;









alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res7.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res8.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res9.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res10.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res11.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res12.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res13.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res14.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res15.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res16.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res17.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res18.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res19.dbf' size 10g;

alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res20.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res21.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res22.dbf' size 10g;

alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res23.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res24.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res25.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res26.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res27.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res28.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res29.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res30.dbf' size 10g;

alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res31.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res32.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res33.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res34.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res35.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res36.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res37.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res38.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res39.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res40.dbf' size 10g;

alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res41.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res42.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res43.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res44.dbf' size 10g;
alter tablespace  IRIP2_EDQ_RES add datafile '/iripows/data01/IRIPOWS/IRIP2_edq_res45.dbf' size 10g;

ALTER DATABASE MOVE DATAFILE '/iripows/data01/IRIPOWS/IRIP3_edq_res21.dbf'  TO '/iripows/data01/IRIPOWS/IRIP2_edq_res21.dbf'














alter tablespace  IRIDR2_EDQ_RES add datafile '/iridrows/data01/IRIDROWS/IRIDR2_edq_res6.dbf' size 10g;
alter tablespace  IRIDR2_EDQ_RES add datafile '/iridrows/data01/IRIDROWS/IRIDR2_edq_res7.dbf' size 10g;
alter tablespace  IRIDR2_EDQ_RES add datafile '/iridrows/data01/IRIDROWS/IRIDR2_edq_res8.dbf' size 10g;
alter tablespace  IRIDR2_EDQ_RES add datafile '/iridrows/data01/IRIDROWS/IRIDR2_edq_res9.dbf' size 10g;
alter tablespace  IRIDR2_EDQ_RES add datafile '/iridrows/data01/IRIDROWS/IRIDR2_edq_res10.dbf' size 10g;

alter tablespace  IRIDR2_EDQ_RES add datafile '/iridrows/data01/IRIDROWS/IRIDR2_edq_res11.dbf' size 10g;
alter tablespace  IRIDR2_EDQ_RES add datafile '/iridrows/data01/IRIDROWS/IRIDR2_edq_res12.dbf' size 10g;
alter tablespace  IRIDR2_EDQ_RES add datafile '/iridrows/data01/IRIDROWS/IRIDR2_edq_res13.dbf' size 10g;
alter tablespace  IRIDR2_EDQ_RES add datafile '/iridrows/data01/IRIDROWS/IRIDR2_edq_res14.dbf' size 10g;
alter tablespace  IRIDR2_EDQ_RES add datafile '/iridrows/data01/IRIDROWS/IRIDR2_edq_res15.dbf' size 10g;


select property_name, property_value from database_properties
where property_name = 'DEFAULT_TEMP_TABLESPACE';

select username, temporary_tablespace, account_status from dba_users;

select unique temporary_tablespace
from dba_users
where temporary_tablespace <> 'TEMP'
ORDER by 1;

select tb.tablespace_name, tf.file_name from dba_tablespaces tb left join dba_temp_files tf on tf.tablespace_name = tb.tablespace_name where tb.contents = 'TEMPORARY';

SELECT * FROM dba_temp_free_space;

SELECT tablespace_name, tablespace_size / 1024 / 1024 tablespace_size_mb, allocated_space / 1024 / 1024 allocated_space_mb, free_space / 1024 / 1024 free_space_mb FROM dba_temp_free_space;

alter tablespace IRIDR2_EDQ_RESTEMP shrink space;


select 'alter tablespace '||tablespace_name||' shrink space;'
from dba_temp_files
;






alter tablespace IRIDR2_EDQ_CONFTEMP shrink space;
alter tablespace IRIDR2_EDQ_RESTEMP shrink space;
alter tablespace IRIDR2_EDQ_STAGINGTEMP shrink space;
alter tablespace IRIDR2_IAS_TEMP shrink space;
alter tablespace IRIDRS_IAS_TEMP shrink space;
alter tablespace IRIDR_EDQ_CONFTEMP shrink space;
alter tablespace IRIDR_EDQ_RESTEMP shrink space;
alter tablespace IRIDR_EDQ_STAGINGTEMP shrink space;
alter tablespace IRIDR_IAS_TEMP shrink space;
alter tablespace TEMP shrink space;



select 
   a.tablespace_name, 
   a.file_name, 
   a.bytes /1024/1024 size_mb
   ,b.free_bytes /1024/1024 free_space_mb
FROM 
   dba_temp_files a, 
   (SELECT file_id, SUM(bytes) free_bytes
      FROM dba_free_space b GROUP BY file_id) b
WHERE 
a.file_id=b.file_id
ORDER BY 
a.tablespace_name;


	
 
	 	
Temporary Tablespaces
Oracle Tips by Burleson Consulting

Temporary Tablespaces
Temporary tablespaces are used for special operations, particularly for sorting data results on disk and for hash joins in SQL. For SQL with millions of rows returned, the sort operation is too large for the RAM area and must occur on disk.  The temporary tablespace is where this takes place. 

Each database should have one temporary tablespace that is created when the database is created. You create, drop and manage tablespaces with create temporary tablespace, drop temporary tablespace and alter temporary tablespace commands, each of which is like it?s create tablespace counterpart.

The only other difference is that a temporary tablespace uses temporary files (also called tempfiles) rather than regular datafiles. Thus, instead of using the datafiles keyword you use the tempfiles keyword when issuing a create, drop or alter tablespace command as you can see in these examples:

CREATE TEMPORARY TABLESPACE temp
TEMPFILE ?/ora01/oracle/oradata/booktst_temp_01.dbf? SIZE 50m;
DROP TEMPORARY TABLESPACE temp INCLUDING CONTENTS AND DATAFILES;

Tempfiles are a bit different than datafiles in that you may not immediately see them grow to the size that they have been allocated (this particular functionality is platform dependent). Hence, don?t panic if you see a file that looks too small.

col allocated_bytes format 999,999,999,999,999

col free_bytes format 999,999,999,999,999


select 
   a.tablespace_name, 
   a.file_name, 
   a.bytes c3, 
   b.free_bytes 
FROM 
   dba_temp_files a, 
   (SELECT file_id, SUM(bytes) free_bytes
      FROM dba_free_space b GROUP BY file_id) b
WHERE 
a.file_id=b.file_id
ORDER BY 
a.tablespace_name;

Here is a script that will display the contents of the TEMP tablespace.

set pagesize 60 linesize 132 verify off 
break on file_id skip 1 

column file_id heading "File|Id" 
column tablespace_name for a15 
column object          for a15 
column owner           for a15 
column MBytes          for 999,999

select tablespace_name, 
'free space' owner, /*"owner" of free space */ 
' ' object,         /*blank object name */ 
file_id, /*file id for the extent header*/ 
block_id, /*block id for the extent header*/ 
CEIL(blocks*4/1024) MBytes /*length of the extent, in Mega Bytes*/ 
from dba_free_space 
where tablespace_name like '%TEMP%' 
union 
select tablespace_name, 
substr(owner, 1, 20), /*owner name (first 20 chars)*/ 
substr(segment_name, 1, 32), /*segment name */ 
file_id, /*file id for extent header */ 
block_id, /*block id for extent header */ 
CEIL(blocks*4/1024) MBytes /*length of the extent, in Mega Bytes*/ 
from dba_extents 
where tablespace_name like '%TEMP%' 
order by 1, 4, 5 
/ 


