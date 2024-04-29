select s.sid, 
s.serial#,
       s.username,
       s.machine,
       s.osuser, 
       cpu_time,
       (elapsed_time/1000000)/60 as minutes,
       sql_text
from gv$sqlarea a, gv$session s
where s.sql_id = a.sql_id
--and s.machine = :machine
--and sid = 742
--and osuser = 'tonys'
order by minutes desc
;


ALTER SYSTEM KILL SESSION '696,11751';

select *
from gv$sqlarea
;

select *
from gv$session
where osuser = 'tonys'
order by 1 desc
;

select *
from gv$sql
where sql_text like 'DELETE FROM XWRL\_%' ESCAPE '\' 
;

gbcsu2czj8m21
3p2kx0q11d51w
2cczvvvmp66ny
425wtn01jr946