select a.sid, a.serial#
from v$session a, v$locked_object b, dba_objects c
where b.object_id = c.object_id
and a.sid = b.session_id
and OBJECT_NAME = 'WC_CONTENT'
;

SELECT *
FROM v$session
WHERE SID = '1457'
;

SELECT *
FROM v$locked_object
;

alter system kill session 'sid, serial#';

create index vssl.WC_CONTENT_IDX4 on wc_content (wc_screening_request_id);