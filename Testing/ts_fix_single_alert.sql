set serveroutput on;
DECLARE
    p_user            VARCHAR2(200);
    p_alert_in_tbl    xows.xxiri_cm_process_pkg.alert_tbl_in_type@EBSTOOWS2.CORESYS.COM;
    x_alert_out_tbl   xows.xxiri_cm_process_pkg.alert_tbl_out_type@EBSTOOWS2.CORESYS.COM;
    x_status          VARCHAR2(200);
BEGIN
    --p_user := 'TSUAZO';
    p_user := 'FSHIN';

  -- 1st record
    p_alert_in_tbl(1).alert_id := 'SEN-10236001';
    p_alert_in_tbl(1).to_state := 'EDD - Open';
    p_alert_in_tbl(1).comment := 'tsuazo - This was a test';
    xows.xxiri_cm_process_pkg.update_alerts@EBSTOOWS2.CORESYS.COM ( p_user => p_user,p_alert_in_tbl => p_alert_in_tbl,x_alert_out_tbl => x_alert_out_tbl
,x_status => x_status );

    FOR j IN x_alert_out_tbl.first..x_alert_out_tbl.last LOOP
        dbms_output.put_line('ALert ID: '
                               || x_alert_out_tbl(j).alert_id
                               || ' New State: '
                               || x_alert_out_tbl(j).new_state
                               || ' status: '
                               || x_alert_out_tbl(j).status
                               || ' err_msg: '
                               || x_alert_out_tbl(j).err_msg
                               || ' Overall status: '
                               || x_status);
    END LOOP;
    
    update xwrl_response_ind_columns
    set x_state = 'EDD - Open'
    where alertid = 'SEN-10236001'
    ;

    COMMIT;
    
END;