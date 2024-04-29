declare

v_source_table varchar2(4000);
v_source_table_column varchar2(4000);
v_source_id varchar2(4000);

x_batch_id integer;
x_return_status varchar2(4000);
x_return_msg varchar2(4000);

cursor c1 is

select n.full_name, n.master_id, m.source_table, m.source_table_column, m.source_id
from tmp_names n
,xwrl_party_master m
where n.master_id = m.id
and rownum = 1
;

begin

for c1rec in c1 loop

rmi_ows_common_util.create_batch_vetting (
                   p_source_table             => c1rec.source_table,
                    p_source_table_column      => c1rec.source_table_column,
                    p_source_id                => c1rec.source_id,
                    x_batch_id                 => x_batch_id,
                    x_return_status            => x_return_status,
                    x_return_msg               => x_return_msg
                    );

dbms_output.put_line('x_batch_id: '||x_batch_id);
dbms_output.put_line('x_return_status: '||x_return_status);
dbms_output.put_line('x_return_msg: '||x_return_msg);

end loop;

end;
/

