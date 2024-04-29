drop TRIGGER  XWRL.XWRL_ALERT_NOTES_TRG;

CREATE OR REPLACE TRIGGER  XWRL.XWRL_ALERT_NOTES_TRG
/*********************************************************************************************************************
* Legend : Type                                                                                                      * 
* I --> Initial                                                                                                      *
* E --> Enhancement                                                                                                  *
* R --> Requirement                                                                                                  *
* B --> Bug                                                                                                          *
*********************************************************************************************************************/
/*$Header: XWRL.XWRL_ALERT_NOTES_TRG 1.1 2020/07/25 12:00:00ET   IRI Exp                                           $*/
/*********************************************************************************************************************
* Object Type         : Trigger                                                                                      *
* Name                : xwrl_vessel_indicator                                                                        *
* Script Name         : XWRL.XWRL_ALERT_NOTES_TRG.trg.SQL                                                                    *
* Purpose             :                                                                                              *
*                                                                                                                    *
* Company             : International Registries, Inc.                                                               *
* Module              : Trade Compliance                                                                             *
* Created By          : TSUAZO                                                                                     *
* Created Date        : 25-JUL-2020                                                                                  *
* Last Reviewed By    : TSUAZO                                                                                       *
* Last Reviewed Date  : 25-JUL-2020                                                                                  *
**********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification -------> *
* Date        By               Script               By            Date         Type  Details                         *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ------------------------------ *
* 25-JUL-2020 IRI              1.1                TSUAZO        25-JUL-2020  I      Trade Compliance               *
**********************************************************************************************************************/

AFTER INSERT ON xwrl.xwrl_alert_notes 
FOR EACH ROW

DECLARE

      cursor c1(p_request_id integer) is
      SELECT r.source_table, null source_table_column, r.source_id, r.path, r.master_id,  r.alias_id, r.xref_id, r.batch_id              
      FROM xwrl.xwrl_requests r
      WHERE r.id = p_request_id;

      cursor c2(p_alert_id varchar2, p_batch_id integer, p_list_id varchar2) is
      select unique c.casekey, c.listid, c.x_state, c.request_id, c.alertid alert_id,r.source_table, null source_table_column, r.source_id,   r.master_id,  r.alias_id, r.xref_id, r.batch_id        
      from xwrl_response_ind_columns c
      ,xwrl_requests r
      where c.request_id = r.id
      and r.batch_id = p_batch_id
      and c.alertid != p_alert_id
      and c.listid = p_list_id
      ;

      cursor c3(p_alert_id varchar2, p_batch_id integer, p_list_id varchar2) is
      select unique c.casekey, c.listid, c.x_state, c.request_id, c.alertid alert_id, r.source_table, null source_table_column, r.source_id,  r.master_id,  r.alias_id, r.xref_id, r.batch_id        
      from xwrl_response_entity_columns c
       ,xwrl_requests r
      where c.request_id = r.id
      and r.batch_id = p_batch_id
      and c.alertid != p_alert_id
      and c.listid = p_list_id
      ;

	bypass_trigger EXCEPTION;
	v_bypass_trigger varchar2(10); 
   v_debug           VARCHAR2 (10);
   v_rec xwrl_note_xref%ROWTYPE;
   v_list_id varchar2(50);

BEGIN

         /* For debugging purposes */
      SELECT value_string
        INTO v_debug
        FROM xwrl_parameters
       WHERE ID = 'XWRL_OWS_UTILS' AND KEY = 'DEBUG';
       
 if  v_debug = 'TRUE' then
   dbms_output.put_line( 'xwrl_alert_notes: trigger - start');
   apps.mt_log_error( 'xwrl_alert_notes: xwrl_alert_notes: trigger - start');
end if;

	SELECT SYS_CONTEXT('xwrl_ctx', 'disable_trigger') into v_bypass_trigger FROM dual;
	if v_bypass_trigger = 'TRUE' then
	  raise bypass_trigger;
	end if;  

   for c1rec in c1 (:new.request_id) loop
   
      if c1rec.path = 'INDIVIDUAL' then

      if v_debug = 'TRUE'   then      
        dbms_output.put_line( 'INDIVIDUAL');
        apps.mt_log_error( 'xwrl_alert_notes: INDIVIDUAL');               
      end if;

         select unique listid into v_list_id from xwrl_response_ind_columns where alertid = :new.alert_id;

         for cNoteRec in c2 (:new.alert_id, c1rec.batch_id, v_list_id) loop
         
         if v_debug = 'TRUE'   then      
            dbms_output.put_line( 'xwrl_response_ind_columns');
            apps.mt_log_error( 'xwrl_alert_notes: xwrl_response_ind_columns');
        end if;
        
             v_rec.note_id := :new.id;
             v_rec.request_id := cNoteRec.request_id;
             v_rec.alert_id := cNoteRec.alert_id;
             v_rec.line_number := :new.line_number;
             v_rec.case_key := cNoteRec.casekey;
             v_rec.master_id := cNoteRec.master_id;
             v_rec.alias_id := cNoteRec.alias_id;
             v_rec.xref_id := cNoteRec.xref_id;
             v_rec.source_table := cNoteRec.source_table;
             v_rec.source_table_column := cNoteRec.source_table_column;
             v_rec.source_id := cNoteRec.source_id;
             v_rec.list_id := v_list_id;                        
             v_rec.to_state := null;
             v_rec.from_state := cNoteRec.x_state;
             v_rec.enabled_flag := 'Y';
             v_rec.status := 'N';
             v_rec.record_comment := 'xwrl_alert_notes trigger logic based on: '||:new.alert_id;
             v_rec.last_update_date := :new.last_update_date;
             v_rec.last_updated_by := :new.last_updated_by;
             v_rec.creation_date := :new.creation_date;
             v_rec.created_by := :new.created_by;
             v_rec.last_update_login := :new.last_update_login;
         
            insert into xwrl_note_xref values v_rec;

         end loop;
         
elsif c1rec.path = 'ENTITY'  then
      
      if v_debug = 'TRUE'   then      
         dbms_output.put_line( 'ENTITY');
         apps.mt_log_error( 'xwrl_alert_notes: ENTITY');
     end if;
          
          select unique to_number(listid) into v_list_id from xwrl_response_ind_columns where alertid = :new.alert_id;
          
          for cNoteRec in c3 (:new.alert_id, c1rec.batch_id, v_list_id) loop
          
          if v_debug = 'TRUE'   then      
               dbms_output.put_line( 'xwrl_response_entity_columns');
               apps.mt_log_error( 'xwrl_alert_notes: xwrl_response_entity_columns');
         end if;

            v_rec.note_id := :new.id;
             v_rec.request_id := cNoteRec.request_id;
             v_rec.alert_id := cNoteRec.alert_id;
             v_rec.line_number := :new.line_number;
             v_rec.case_key := cNoteRec.casekey;
             v_rec.master_id := c1rec.master_id;
             v_rec.alias_id := c1rec.alias_id;
             v_rec.xref_id := c1rec.xref_id;
             v_rec.source_table := c1rec.source_table;
             v_rec.source_table_column := c1rec.source_table_column;
             v_rec.source_id := c1rec.source_id;
             v_rec.list_id := v_list_id;                        
             v_rec.to_state := null;
             v_rec.from_state := cNoteRec.x_state;
             v_rec.enabled_flag := 'Y';
             v_rec.status := 'N';
             v_rec.record_comment := 'xwrl_alert_notes trigger logic based on: '||:new.alert_id;
             v_rec.last_update_date := :new.last_update_date;
             v_rec.last_updated_by := :new.last_updated_by;
             v_rec.creation_date := :new.creation_date;
             v_rec.created_by := :new.created_by;
             v_rec.last_update_login := :new.last_update_login;
         
            insert into xwrl_note_xref values v_rec;

         end loop;     
         
      end if;
   
   if v_debug = 'TRUE'   then      
     dbms_output.put_line( 'xwrl_alert_notes: trigger - finish');
     apps.mt_log_error( 'xwrl_alert_notes: xwrl_alert_notes: trigger - finish');
end if;     
   
   end loop;

EXCEPTION
	when bypass_trigger then null;
   WHEN OTHERS THEN    
      raise_application_error(-20100,'Exception occurred while clearing vessels: '||SQLERRM);
END;
/