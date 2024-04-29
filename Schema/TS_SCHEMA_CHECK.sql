select *
from all_objects
where (object_name like 'XWRL\_%' ESCAPE '\'
or object_name like 'RMI\_OWS\_%' ESCAPE '\'
or object_name like 'IRI\_SICD\_ONLINE' ESCAPE '\'
or  object_name like 'NRMI\_CERTS%' ESCAPE '\')
AND OBJECT_TYPE IN ('PACKAGE','PACKAGE BODY','TRIGGER')
ORDER BY 1,2
;    


select *
from all_objects
where (object_name like 'XWRL\_%' ESCAPE '\'
or object_name like 'RMI\_OWS\_%' ESCAPE '\')
AND OBJECT_TYPE IN ('PACKAGE','PACKAGE BODY','TRIGGER')
ORDER BY decode(object_type,'PACKAGE',1,'PACKAGE BODY',2,'TRIGGER',3), object_name
; 

select dbms_metadata.get_ddl('PACKAGE_BODY','RMI_OWS_COMMON_UTIL','APPS') from dual;

select dbms_metadata.get_ddl('TRIGGER','XWRL_AUDIT_LOG_TRG','XWRL') from dual;

drop table v_code;

create table v_code (v_sql clob);

truncate table v_code;

select * from v_code;


CREATE OR REPLACE  DIRECTORY TRADE_SCRIPTS AS '/iridr/oracle_files/DR/scripts';

select *
from all_directories
where directory_name = 'TRADE_SCRIPTS'
order by directory_path
;

select decode(object_type,'PACKAGE BODY','PACKAGE_BODY',object_type) object_type, object_name, owner
from all_objects
where (object_name like 'XWRL\_%' ESCAPE '\'
or object_name like 'RMI\_OWS\_%' ESCAPE '\')
AND OBJECT_TYPE IN ('PACKAGE','PACKAGE BODY','TRIGGER')
--and rownum = 1
ORDER BY decode(object_type,'PACKAGE',1,'PACKAGE BODY',2,'TRIGGER',3), object_name;

select *
from xwrl_party_master
;

declare

cursor c1 is
select decode(object_type,'PACKAGE','PACKAGE_SPEC','PACKAGE BODY','PACKAGE_BODY',object_type)  object_type, object_name, owner
from all_objects
where (object_name like 'XWRL\_%' ESCAPE '\'
or object_name like 'RMI\_OWS\_%' ESCAPE '\')
AND OBJECT_TYPE IN ('PACKAGE','PACKAGE BODY','TRIGGER')
--and object_type = 'TRIGGER'
--and rownum = 1
ORDER BY decode(object_type,'PACKAGE',1,'PACKAGE_SPEC',2,'PACKAGE BODY',3,'PACKAGE_BODY',4,object_type,5) , object_name
;

v_file_handle  utl_file.file_type;
v_amt number default 32000;
v_offset number default 1;
v_length number;
v_text clob;
v_ctr integer := 0;
v_directory varchar2(100) := 'TRADE_SCRIPTS';
 v_filename varchar2(100);
 
begin


for c1rec in c1 loop

v_offset := 1;
v_ctr := v_ctr + 1;
v_filename := 'test'||v_ctr||'.sql';
v_text := null;

v_file_handle := utl_file.fopen(v_directory,v_filename,'w',32760);

select dbms_metadata.get_ddl(c1rec.object_type,c1rec.object_name,c1rec.owner) into v_text from dual;
v_length := nvl(dbms_lob.getlength(v_text),0);

while (v_offset < v_length) loop   
   if c1rec.object_type = 'TRIGGER' then
      utl_file.put(v_file_handle, replace(dbms_lob.substr(v_text,v_amt,v_offset),'END;'||CHR(10)||CHR(10)||'ALTER','END;'||CHR(10)||'/'||CHR(10)||'ALTER'));
      else
      utl_file.put(v_file_handle, dbms_lob.substr(v_text,v_amt,v_offset));
  end if;
   utl_file.fflush(v_file_handle);
   v_offset := v_offset + v_amt;
end loop;
utl_file.new_line(v_file_handle);
if c1rec.object_type = 'TRIGGER' then
  utl_file.put_line(v_file_handle,';');
else
  utl_file.put_line(v_file_handle,'/');
end if;
utl_file.fclose(v_file_handle);

end loop;

end;
/


declare

v_ctr integer := 0;

begin

for i  in 1..40 loop

v_ctr := v_ctr + 1;

dbms_output.put_line('@ test'||v_ctr||'.sql');

end loop;

end;
/
