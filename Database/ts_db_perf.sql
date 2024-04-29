SELECT
   *
FROM
   v$version;

SELECT
   *
FROM
   v$session;

SELECT
   *
FROM
   v$process;

SELECT
   name
   , log_mode
FROM
   v$database;

SELECT
   COUNT (*)
FROM
   v$session;

SELECT
   COUNT (*)
FROM
   v$process;


SELECT
   nvl (ses.username, 'ORACLE PROC') || ' (' || ses.sid || ')' username
   , sid
   , machine
   , replace (sql.sql_text, CHR (10), '') stmt
   , ltrim (TO_CHAR (floor (ses.last_call_et / 3600), '09')) || ':' || ltrim (TO_CHAR (floor (mod (ses.last_call_et, 3600) / 60), '09')) || ':' || ltrim (TO_CHAR (mod (ses.last_call_et, 60), '09')) runt
FROM
   v$session                 ses
   , v$sqltext_with_newlines   sql
WHERE
   ses.status = 'ACTIVE'
   AND ses.username IS NOT NULL
   AND ses.sql_address = sql.address
   AND ses.sql_hash_value = sql.hash_value
   AND ses.audsid <> userenv ('SESSIONID')
ORDER BY
   runt DESC
   , 1
   , sql.piece;

SELECT
   x.sid
   , x.serial#
   , x.username
   , x.sql_id
   , x.sql_child_number
   , optimizer_mode
   , hash_value
   , address
   , sql_text
FROM
   v$sqlarea   sqlarea
   , v$session   x
WHERE
   x.sql_hash_value = sqlarea.hash_value
   AND x.sql_address = sqlarea.address
   AND x.username IS NOT NULL;

SELECT
   sesion.sid
   , sesion.username
   , optimizer_mode
   , hash_value
   , address
   , cpu_time
   , elapsed_time
   , sql_text
FROM
   v$sqlarea   sqlarea
   , v$session   sesion
WHERE
   sesion.sql_hash_value = sqlarea.hash_value
   AND sesion.sql_address = sqlarea.address
   AND sesion.username IS NOT NULL;

SELECT
   name
   , value
FROM
   v$parameter
WHERE
   name = 'processes';

SELECT
   name
   , value
FROM
   v$parameter
ORDER BY
   name;

SELECT
   name
   , value
FROM
   v$parameter
WHERE
   name LIKE '%dest'
ORDER BY
   name;

SELECT
   osuser
   , machine
   , COUNT (*)
FROM
   v$session
GROUP BY
   osuser
   , machine;

SELECT
   *
FROM
   all_objects
WHERE
   owner = 'APPIRIWT2';

SELECT
   profile
   , limit
FROM
   dba_profiles
WHERE
   resource_name = 'IDLE_TIME';

SELECT
   username
   , profile
FROM
   dba_users
WHERE
   username LIKE '%EDQ%';


SELECT
   *
FROM
   dba_free_space;



SELECT
   username
   , COUNT (*)
FROM
   v$session
GROUP BY
   username
ORDER BY
   1;

SELECT
   *
FROM
   v$session
WHERE
   username LIKE '%EDQ%';

SHOW parameter
background_dump_dest;

SELECT
   COUNT (*)
FROM
   v$process;

SELECT
   username
   , COUNT (*)
FROM
   v$session
WHERE
   username LIKE '%EDQ%'
GROUP BY
   username
ORDER BY
   1;



SELECT
   'exec fnd_stats.gather_table_stats(' || CHR (39) || owner || CHR (39) || ',' || CHR (39) || table_name || CHR (39) || ',100,NULL,NULL,' || CHR (39) || 'NOBACKUP' || CHR (39) || ',TRUE,' || CHR (39) || 'DEFAULT' || CHR (39) || ');'
FROM
   all_tables
WHERE
   owner = 'XWRL'
ORDER BY
   table_name;


SELECT
   TO_CHAR (s.begin_interval_time, 'DD-MON-YYYY HH24:MI:SS') snap_time
   , p.instance_number
   , p.snap_id
   , p.name
   , p.old_value
   , p.new_value
   , DECODE (TRIM (translate (p.new_value, '0123456789', '          ')), '', TRIM (TO_CHAR (to_number (p.new_value) - to_number (p.old_value), '999999999999990')), '') diff
FROM
   (
      SELECT
         dbid
         , instance_number
         , snap_id
         , parameter_name name
         , LAG (TRIM (lower (value))) OVER (
            PARTITION BY dbid, instance_number, parameter_name
            ORDER BY
               snap_id
         ) old_value
         , TRIM (lower (value)) new_value
         , DECODE (nvl (LAG (TRIM (lower (value))) OVER (
            PARTITION BY dbid, instance_number, parameter_name
            ORDER BY
               snap_id
         ), TRIM (lower (value))), TRIM (lower (value)), '~NO~CHANGE~', TRIM (lower (value))) diff
      FROM
         dba_hist_parameter
   ) p
   , dba_hist_snapshot s
WHERE
   s.begin_interval_time BETWEEN trunc (SYSDATE - 31) AND SYSDATE
   AND p.dbid = s.dbid
   AND p.instance_number = s.instance_number
   AND p.snap_id = s.snap_id
   AND p.diff <> '~NO~CHANGE~'
ORDER BY
   snap_time
   , instance_number;

Select POOL, name, Round(bytes/1024/1024,0) Free_Memory_In_MB
   From V$sgastat
   Where Name Like '%memory%';
   
   select *
   from V$sgastat
   ;
   
    select name, Round(value/1024/1024,0) Free_Memory_In_MB
   from V$pgastat
   ;