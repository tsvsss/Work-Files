declare

cursor c1 is 
select id
from xwrl_requests
--where case_id is null
;

v_case_id varchar2(100);

begin

for c1rec in c1 loop
begin
      SELECT
        substr(x.id,instr(x.id,'|',1,2)+1,length(x.id)) case_id
         into v_case_id
FROM
         xwrl_requests t
         , XMLTABLE (XMLNAMESPACES ('http://schemas.xmlsoap.org/soap/envelope' AS "env", 'http://www.datanomic.com/ws' AS "dn"), '//dn:response' PASSING t.response COLUMNS rec FOR ORDINALITY,id varchar2(2700) path '@id'
         ) x 
      WHERE
         t.id = c1rec.id
         and t.case_id is null
         ;
      
      update xwrl_requests
      set case_id = v_case_id
      where id = c1rec.id;
      exception when no_data_found then null;
      end;
      end loop;

      COMMIT;
      
      end;
      /
      
      SELECT
              substr(x.id,instr(x.id,'|',1,2)+1,length(x.id)) case_id
FROM
         xwrl_requests t
         , XMLTABLE (XMLNAMESPACES ('http://schemas.xmlsoap.org/soap/envelope' AS "env", 'http://www.datanomic.com/ws' AS "dn"), '//dn:response' PASSING t.response COLUMNS rec FOR ORDINALITY,id varchar2(2700) path '@id'
         ) x 
      WHERE
         t.id = 1054
         ;      