select *
from xwrl_party_master
where source_table = 'SICD_SEAFARERS'
and source_table_column = 'SEAFARER_ID'
and source_id =  826655;

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
v_source_id :=  1024032;
--v_source_id := 123761; -- RAJ KUMAR

/*
v_source_table := 'SICD_SEAFARERS';
v_source_table_column := 'SEAFARER_ID';
v_source_id :=  826655;
--v_source_id := 123761; -- RAJ KUMAR

REG11_HEADER
15008

v_source_table := 'CORP_MAIN';
v_source_table_column := 'CORP_ID';
v_source_id :=  7;


v_source_table := 'NRMI_CERTIFICATES';
v_source_table_column := 'NRMI_CERTIFICATES_ID';
v_source_id :=  11549;

v_source_table := 'AR_CONTACTS_V';
v_source_table_column := 'CONTACT_ID';
v_source_id :=  1443397;


v_source_table := 'SICD_SEAFARERS';
v_source_table_column := 'SEAFARER_ID';
v_source_id :=  1317919;

*/

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

