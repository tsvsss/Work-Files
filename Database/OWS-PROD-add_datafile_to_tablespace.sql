select *
from v$tablespace
where name = 'IRIP1_EDQ_CONF'
;


select *
from v$datafile
where ts# = 14
;


alter tablespace  IRIP1_EDQ_CONF add datafile '/iripows/data01/IRIPOWS/IRIP1_edq_conf1.dbf' size 20g
;