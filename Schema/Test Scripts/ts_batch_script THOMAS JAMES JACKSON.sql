declare

v_source_table varchar2(4000);
v_source_table_column varchar2(4000);
v_source_id varchar2(4000);

x_batch_id integer;
x_return_status varchar2(4000);
x_return_msg varchar2(4000);

begin

v_source_table := 'SICD_SEAFARERS';
v_source_table_column := 'SEAFARER_ID';
v_source_id :=  1346804;

rmi_ows_common_util.create_batch_vetting (
                   p_source_table             => v_source_table,
                    p_source_table_column      => v_source_table_column,
                    p_source_id                => v_source_id,
                    x_batch_id                 => x_batch_id,
                    x_return_status            => x_return_status,
                    x_return_msg               => x_return_msg
                    );

dbms_output.put_line('x_batch_id: '||x_batch_id);
dbms_output.put_line('x_return_status: '||x_return_status);
dbms_output.put_line('x_return_msg: '||x_return_msg);

end;
/
