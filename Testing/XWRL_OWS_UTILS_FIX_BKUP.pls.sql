create or replace PACKAGE BODY      xwrl_ows_utils
AS
/********************************************************************************************************************
* Legend : Type                                                                                                     *
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_create_xwrl_ows_utils.pkb 1.1 2019/11/15 12:00:00ET   IRI Exp                                     $*/
/********************************************************************************************************************
* Object Type         : Package Body                                                                                *
* Name                : xwrl_ows_utils                                                                         *
* Script Name         : apps_create_xwrl_ows_utils.pkb                                                              *
* Purpose             :                                                                                             *
*                                                                                                                   *
* Company             : International Registries, Inc.                                                              *
* Module              : Trade Compliance                                                                            *
* Created By          : TSUAZO                                                                                      *
* Created Date        : 11-NOV-2019                                                                                 *
* Last Reviewed By    :                                                                                             *
* Last Reviewed Date  :                                                                                             *
*********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
* Date        By               Script               By            Date         Type  Details                        *
* ----------- ---------------- -------- --------- --------------- -----------  -----  ------------------------------*
* 15-NOV-2019 IRI              1.1                TSUAZO          15-NOV-2019  I      Trade Compliance              *
* 15-NOV-2019 IRI              1.2                TSUAZO          15-NOV-2019  I     Return immediate Commit to DML  instead of end of loop         *
* 15-JAN-2020 IRI              1.3                SAGARWAL        15-JAN-2020  I     Add check to validate OWS State*
* 18-JAN-2020 IRI              1.4                SAGARWAL        18-JAN-2020  I     Added Master ID Check          *
* 03-FEB-2020 IRI              1.5                SAGARWAL        03-FEB-2020  I     Enhanced Auto Clear            *
* 20-FEB-2020 IRI              1.6                TSUAZO        20-FEB-2020  I     Fix Alert Mismatch due to ListType difference            *
* 05-MAR-2020 IRI              1.7                TSUAZO        05-MAR-2020  I     Add Debug            *
* 11-MAY-2020 IRI 1.8 TSUAZO 11-MAY-2020 B Fix alert mismatch in process alerts for Individuals and Entities
* 13-MAY-2020 IRI 1.9 TSUAZO 12-MAY-2020 E Convert temporary debug tables to permanent tables              *
* 15-MAY-2020 IRI 1.10 TSUAZO 15-MAY-2020 B  Fix where clause for alert mismatch              *
* 02-JUN-2020 IRI 1.11 TSUAZO 02-JUN-2020 B Add missing commit statement
   * 17-JUL-2020 IRI                 1.12               TSUAZO              17-JUL-2020 B  Fix where clause for alert mismatch              *   
      * 20-JUL-2020 IRI                 1.13               TSUAZO              20-JUL-2020 B  Update commit statements          *   
       * 22-JUL-2020 IRI                 1.14               TSUAZO              22-JUL-2020 B  Fix issue with auto_clear array          * 
             * 22-JUL-2020 IRI                 1.15               TSUAZO              22-JUL-2020 B  Fix issue with auto_clear query          * 
  * 23-JUL-2020 IRI                 1.16               TSUAZO              23-JUL-2020 B  process alert remove OWS status check       *              
    * 23-JUL-2020 IRI                 1.17               TSUAZO              23-JUL-2020 B  Move alert clearing to within r_cols cursor      *  
    * 24-JUL-2020 IRI                 1.18               TSUAZO              24-JUL-2020 B  Resolved overloading procedure issue     *      
********************************************************************************************************************/
   PROCEDURE test_db_link (x_response OUT INTEGER)
   IS
   BEGIN
      x_response := 0;

      SELECT 1
        INTO x_response
        FROM DUAL@ebstoows2.coresys.com;
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END test_db_link;

   PROCEDURE process_alerts (
      p_user_id      IN   NUMBER,
      p_session_id   IN   NUMBER,
      p_request_id   IN   INTEGER,
      p_alert_tab    IN   xwrl_alert_tbl_in_type
   )
   IS
      l_alert_in_tbl    xows.xxiri_cm_process_pkg.alert_tbl_in_type@ebstoows2.coresys.com;
      l_alert_out_tbl   xows.xxiri_cm_process_pkg.alert_tbl_out_type@ebstoows2.coresys.com;
      x_status          VARCHAR2 (1000);
      v_key_label       VARCHAR2 (500);
      v_case_key        VARCHAR2 (500);
      v_list_id         INTEGER;
      v_source_table    VARCHAR2 (50);
      v_source_id       INTEGER;
      v_path            VARCHAR2 (50);
      v_note            VARCHAR2 (4000);
      v_line_number     NUMBER;
      v_user            VARCHAR2 (100);
      v_master_id       NUMBER;
      v_alias_id        NUMBER;
      v_xref_id         NUMBER;
      v_batch_id       NUMBER;  -- tsuazo 20200717
      v_debug           VARCHAR2 (10);
      --SAURABH 11-JUN-2020
      v_id              NUMBER;
      v_count integer;
      
      cursor c1 (p_master_id integer, p_alias_id integer, p_xref_id integer, p_list_id integer)is
      with max_note as 
(select nn.note max_note,max(nn.id) max_id
from xwrl_response_ind_columns  ii
,xwrl_requests rr
,xwrl_note_xref xx
,XWRL_ALERT_NOTES nn
where ii.request_id = rr.id
and rr.master_id = p_master_id
and decode(rr.alias_id ,nvl(p_alias_id,rr.alias_id),1,0) = 1
and decode(rr.xref_id ,nvl(p_xref_id,rr.xref_id),1,0) = 1
and ii.listid = p_list_id
and ii.request_id = xx.request_id (+)
and ii.alertid = xx.alert_id (+)
and xx.note_id = nn.id (+)
group by nn.note)
select n.id, n.line_number, n.note, n.creation_date, n.created_by, n.last_update_date, n.last_updated_by, n.last_update_login
from xwrl_response_ind_columns  i
,xwrl_requests r
,xwrl_note_xref x
,XWRL_ALERT_NOTES n
,max_note
where i.request_id = r.id
and r.master_id = p_master_id
and decode(r.alias_id ,nvl(p_alias_id,r.alias_id),1,0) = 1
and decode(r.xref_id ,nvl(p_xref_id,r.xref_id),1,0) = 1
and i.listid = p_list_id
and i.request_id = x.request_id (+)
and i.alertid = x.alert_id (+)
and x.note_id = n.id (+)
and n.id = max_note.max_id;
      
   BEGIN
   
         /* For debugging purposes */
      SELECT value_string
        INTO v_debug
        FROM xwrl_parameters
       WHERE ID = 'XWRL_OWS_UTILS' AND KEY = 'DEBUG';
   
      IF p_user_id IS NOT NULL
      THEN
         SELECT user_name
           INTO v_user
           FROM fnd_user
          WHERE user_id = p_user_id;
      END IF;

-- PROCESS INBOUND TABLE FROM EBS OR ADF

      FOR i IN p_alert_tab.FIRST .. p_alert_tab.LAST
      LOOP
         --SAURABH 16-JAN-2020 Check OWS Alert State
         --
--         DBMS_OUTPUT.put_line ('to_state Seq: ' || rmi_ows_common_util.get_ows_alert_sequence (p_alert_tab (i).p_to_state) );
--         DBMS_OUTPUT.put_line ('ows_state Seq: ' || rmi_ows_common_util.get_ows_alert_sequence (changeowsstate (rmi_ows_common_util.get_ows_alert_state (p_alert_tab (i).p_alert_id))));
--         DBMS_OUTPUT.put_line ('to_state : ' ||  (p_alert_tab (i).p_to_state) );
--         DBMS_OUTPUT.put_line ('ows_state : ' ||  (changeowsstate (rmi_ows_common_util.get_ows_alert_state (p_alert_tab (i).p_alert_id))));

         --         IF rmi_ows_common_util.get_ows_alert_sequence (p_alert_tab (i).p_to_state)
--            >=
--            rmi_ows_common_util.get_ows_alert_sequence (changeowsstate (rmi_ows_common_util.get_ows_alert_state (p_alert_tab (i).p_alert_id)))
--         THEN
         l_alert_in_tbl (i).alert_id := p_alert_tab (i).p_alert_id;
         l_alert_in_tbl (i).to_state :=
                                changetoowsstate (p_alert_tab (i).p_to_state);
         l_alert_in_tbl (i).COMMENT := p_alert_tab (i).p_comment;
         v_note := p_alert_tab (i).p_comment;
--         DBMS_OUTPUT.put_line ('to_state: ' || l_alert_in_tbl (i).to_state);
                                 -- Note: they will all have the same comment
--         END IF;
      END LOOP;

      IF v_debug = 'TRUE'
      THEN
      
         FOR i IN l_alert_in_tbl.FIRST .. l_alert_in_tbl.LAST
         LOOP
            DBMS_OUTPUT.put_line (   'Alert - alert_id: '
                                  || l_alert_in_tbl (i).alert_id
                                 );
            DBMS_OUTPUT.put_line (   'Alert - to_state: '
                                  || l_alert_in_tbl (i).to_state
                                 );
            DBMS_OUTPUT.put_line (   'Alert - comment: '
                                  || l_alert_in_tbl (i).COMMENT
                                 );

            INSERT INTO xwrl_alerts_debug
                        (procedure_name, p_user,
                         p_alert_id,
                         p_to_state,
                         p_comment, creation_date, created_by
                        )
                 VALUES ('XWRL_OWS_UTILS.PROCESS_ALERTS(1)', v_user,
                         l_alert_in_tbl (i).alert_id,
                         l_alert_in_tbl (i).to_state,
                         l_alert_in_tbl (i).COMMENT, SYSDATE, p_user_id
                        );

            COMMIT; -- TSUAZO 07/20/2020

         END LOOP;

      END IF;

-- EXECUTE OWS PROCEDURE

      IF l_alert_in_tbl.COUNT > 0
      THEN
         xows.xxiri_cm_process_pkg.update_alerts@ebstoows2.coresys.com
                                         (p_user               => v_user,
                                          p_alert_in_tbl       => l_alert_in_tbl,
                                          x_alert_out_tbl      => l_alert_out_tbl,
                                          x_status             => x_status
                                         );
         DBMS_OUTPUT.put_line ('Alert - X_STATUS: ' || x_status);


-- PROCESS OUTBOUND TABLE FROM OWS

         FOR i IN l_alert_out_tbl.FIRST .. l_alert_out_tbl.LAST
         LOOP
                 
            DBMS_OUTPUT.put_line (   'Alert - alert_id: '
                                  || l_alert_out_tbl (i).alert_id
                                 );
            DBMS_OUTPUT.put_line (   'Alert - key_label: '
                                  || l_alert_out_tbl (i).key_label
                                 );
            DBMS_OUTPUT.put_line (   'Alert - old_state: '
                                  || l_alert_out_tbl (i).old_state
                                 );
            DBMS_OUTPUT.put_line (   'Alert - new_state: '
                                  || l_alert_out_tbl (i).new_state
                                 );
            DBMS_OUTPUT.put_line (   'Alert - status: '
                                  || l_alert_out_tbl (i).status
                                 );
            DBMS_OUTPUT.put_line (   'Alert - err_msg: '
                                  || l_alert_out_tbl (i).err_msg
                                 );
                                 
            v_key_label := l_alert_out_tbl (i).key_label;

            SELECT SUBSTR (v_key_label, 1, INSTR (v_key_label, ':', 1) - 1)
              INTO v_case_key
              FROM DUAL;

            SELECT TO_NUMBER (SUBSTR (v_key_label,
                                      INSTR (v_key_label, ':', -1) + 1,
                                      LENGTH (v_key_label)
                                     )
                             )
              INTO v_list_id
              FROM DUAL;

-- tsuazo 20200717
-- GET REQUEST REFERENCE DATA

            SELECT source_table, source_id, PATH, master_id,  alias_id, xref_id, batch_id
              INTO v_source_table, v_source_id, v_path, v_master_id,  v_alias_id, v_xref_id, v_batch_id
              FROM xwrl.xwrl_requests
             WHERE ID = p_request_id;

            IF v_debug = 'TRUE'
            THEN
               INSERT INTO xwrl_alert_results_debug
                           (procedure_name,
                            p_request_id, p_case_key,
                            p_alert_id, p_list_id,
                            p_key_label,
                            p_old_state,
                            p_new_state,
                            p_status,
                            p_err_msg, creation_date, created_by
                           )
                    VALUES ('XWRL_OWS_UTILS.PROCESS_ALERTS(1)',
                            p_request_id, v_case_key,
                            l_alert_out_tbl (i).alert_id, v_list_id,
                            l_alert_out_tbl (i).key_label,
                            l_alert_out_tbl (i).old_state,
                            l_alert_out_tbl (i).new_state,
                            l_alert_out_tbl (i).status,
                            l_alert_out_tbl (i).err_msg, SYSDATE, p_user_id
                           );

               COMMIT; -- TSUAZO 07/20/2020                           

            END IF;

            --IF (l_alert_out_tbl (i).status = 'SUCCESS')  THEN  -- tsuazo 20200723 remove status check
            begin
               /*BEGIN
                  SELECT NVL (MAX (line_number), 0) + 10 line_number
                    INTO v_line_number
                    FROM xwrl_alert_notes
                   WHERE alert_id = l_alert_out_tbl (i).alert_id;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_line_number := 10;
               END;*/      

-- PROCESS INDIVIDUAL ALERT RESPONSE

IF     v_path = 'INDIVIDUAL'   AND l_alert_out_tbl (i).new_state IS NOT NULL THEN

                  UPDATE xwrl_response_ind_columns
                     --SET x_state = changeowsstate (l_alert_out_tbl (i).new_state),
                  SET x_state =
                            listrecordtype
                         || SUBSTR
                                (changeowsstate (l_alert_out_tbl (i).new_state),
                                 4
                                ),
                      -- tsuazo 20200511 fix alert record state issue
                      last_updated_by = p_user_id,
                      last_update_date = SYSDATE,
                      last_update_login = p_session_id
                   -- WHERE request_id = p_request_id AND listid = v_list_id;   -- tsuazo 20200515 Alert can have multiple response  records
                  -- WHERE  request_id = p_request_id AND alertid = l_alert_out_tbl (i).alert_id;
                  -- tsuazo 20200717 THIS NEED TO BE SYNCHRONIZED WITH RMI_OWS_COMMON_UTIL.SYNC_MATCHES
                      --WHERE  listid = v_list_id  and exists  (select 1 from xwrl_requests x where x.id = request_id and x.master_id = v_master_id and x.batch_id = v_batch_id); -- tsuazo 20200717 UID can exist in multiple response  records within a batch
                      WHERE  request_id = p_request_id AND alertid = l_alert_out_tbl (i).alert_id; -- tsuazo 20200717 Note: The RMI_OWS_COMMON_UTIL.SYNC_MATCHES will pick up the other records

                  COMMIT;

                  BEGIN               
               -- TSUAZO 20200717 Add loop for RESPONSE INDIVIDUAL
                FOR r_cols IN ( 
                      select unique  i.request_id, r.case_id,i.alertid, listid, i.x_state, r.name_screened, r.master_id, r.alias_id, r.xref_id
                     from xwrl_response_ind_columns  i
                     ,xwrl_requests r
                     where i.request_id = r.id
                     and r.batch_id = v_batch_id
                     and i.listid = v_list_id
                     order by request_id, alertid desc
                      )
                      LOOP
                      
                      /* Note:  Once a record is cleared for an EBS source, there is no need to maintain multiple entries for the same thing.
                                 The unique contraint will limit the records in this table to what is applicable.  */
                                 
               -- PROCESS ALERT CLEARING                                 
                                 
               BEGIN
                  INSERT INTO xwrl_alert_clearing_xref
                              (request_id, source_table, source_id,
                               case_key, alert_id,
                               list_id,
                               from_state,
                               to_state,
                               status,
                               error_message, note, last_update_date,
                               last_updated_by, creation_date, created_by,
                               last_update_login, master_id, alias_id,
                               xref_id
                              )
                       VALUES (p_request_id, v_source_table, v_source_id,
                               v_case_key, l_alert_out_tbl (i).alert_id,
                               v_list_id,
                               changeowsstate (l_alert_out_tbl (i).old_state),
                               changeowsstate (l_alert_out_tbl (i).new_state),
                               l_alert_out_tbl (i).status,
                               l_alert_out_tbl (i).err_msg, v_note, SYSDATE,
                               p_user_id, SYSDATE, p_user_id,
                               p_session_id
                               , r_cols.master_id
                               , r_cols.alias_id
                               , r_cols.xref_id
                              );

                  COMMIT;               -- TSUAZO 20200602 Add missing commit;

               EXCEPTION
                  WHEN DUP_VAL_ON_INDEX
                  THEN
                     NULL;
               END;

               -- PROCESS NOTES

               SELECT COUNT(*)
               INTO v_count
               FROM xwrl_alert_notes
                              WHERE request_id =  r_cols.request_id
               and alert_id = r_cols.alertid
               and note =  l_alert_in_tbl (i).COMMENT
               and created_by = p_user_id;
               
               if v_count =  0 then -- 20200723

             v_line_number := xwrl_alert_notes_line_seq.NEXTVAL;
               --SAURABH 11-JUN-2020
               v_id := xwrl_alert_notes_seq.NEXTVAL;

               INSERT INTO xwrl_alert_notes
                           (ID, request_id,
                            alert_id, line_number,
                            note, last_update_date, last_updated_by,
                            creation_date, created_by, last_update_login
                           )
                    VALUES (v_id, 
                    --p_request_id,
                      --      l_alert_out_tbl (i).alert_id, 
                                                     r_cols.request_id,
                               r_cols.alertid,
                            v_line_number,
                            l_alert_in_tbl (i).COMMENT,              --v_note,
                                                       SYSDATE, p_user_id,
                            SYSDATE, p_user_id, p_session_id
                           );

               COMMIT;
              
              --end if;
               
            --- PROCESS NOTES XREF

                  INSERT INTO xwrl_note_xref
                              (ID, 
                              note_id, 
                              request_id,
                               alert_id, 
                               line_number,
                               case_key, 
                               master_id, 
                               alias_id,
                               xref_id, 
                               source_table, 
                               source_table_column,
                               source_id, 
                               list_id,
                               from_state,
                               to_state,
                               enabled_flag, status, 
                               record_comment,
                               last_update_date, 
                               last_updated_by,
                               creation_date, 
                               created_by, 
                               last_update_login
                              )
                       VALUES (NULL,                  -- ID                  ,
                                    v_id,             -- NOTE_ID             ,
                                         --p_request_id, -- REQUEST_ID          ,
                               --l_alert_out_tbl (i).alert_id, -- ALERT_ID            ,
                               r_cols.request_id,
                               r_cols.alertid,
                                                            v_line_number, -- LINE_NUMBER         ,
                               v_case_key,            -- CASE_KEY            ,
                                          v_master_id, -- MASTER_ID           ,
                                                      v_alias_id, -- ALIAS_ID            ,
                               v_xref_id,             -- XREF_ID             ,
                                         v_source_table, -- SOURCE_TABLE        ,
                                                        NULL,  -- SOURCE_TABLE_COLUMN ,
                               v_source_id,           -- SOURCE_ID           ,
                                           v_list_id, -- LIST_ID             ,
                               changeowsstate (l_alert_out_tbl (i).old_state), -- FROM_STATE          ,
                               changeowsstate (l_alert_out_tbl (i).new_state), -- TO_STATE            ,
                               'Y',                    --ENABLED_FLAG        ,
                               'N', --STATUS              , add N as New for now
                                       'From Process Alert 1', --RECORD_COMMENT      ,
                               SYSDATE, p_user_id,
                               SYSDATE, p_user_id, p_session_id
                              );

                        COMMIT;
                        
                        end if;


               -- PROCESS NOTES
for c1rec in c1(r_cols.master_id, r_cols.alias_id, r_cols.xref_id, r_cols.listid) loop

               SELECT COUNT(*)
               INTO v_count
               FROM xwrl_alert_notes
                              WHERE request_id =  r_cols.request_id
               and alert_id = r_cols.alertid
               --and note =  l_alert_in_tbl (i).COMMENT
               and note = c1rec.note
               and created_by = p_user_id;
               
               if v_count =  0 then -- 20200723

             v_line_number := xwrl_alert_notes_line_seq.NEXTVAL;
               --SAURABH 11-JUN-2020
               v_id := xwrl_alert_notes_seq.NEXTVAL;

               INSERT INTO xwrl_alert_notes
                           (ID, request_id,
                            alert_id, line_number,
                            note, last_update_date, last_updated_by,
                            creation_date, created_by, last_update_login
                           )
                    VALUES (v_id, 
                    --p_request_id,
                      --      l_alert_out_tbl (i).alert_id, 
                                                     r_cols.request_id,
                               r_cols.alertid,
                            v_line_number,
                            --l_alert_in_tbl (i).COMMENT,              --v_note,
                            c1rec.note, -- note
                                                       SYSDATE, p_user_id,
                            SYSDATE, p_user_id, p_session_id
                           );

               COMMIT;
              
              --end if;
               
            --- PROCESS NOTES XREF

                  INSERT INTO xwrl_note_xref
                              (ID, 
                              note_id, 
                              request_id,
                               alert_id, 
                               line_number,
                               case_key, 
                               master_id, 
                               alias_id,
                               xref_id, 
                               source_table, 
                               source_table_column,
                               source_id, 
                               list_id,
                               from_state,
                               to_state,
                               enabled_flag, status, 
                               record_comment,
                               last_update_date, 
                               last_updated_by,
                               creation_date, 
                               created_by, 
                               last_update_login
                              )
                       VALUES (NULL,                  -- ID                  ,
                                    v_id,             -- NOTE_ID             ,
                                         --p_request_id, -- REQUEST_ID          ,
                               --l_alert_out_tbl (i).alert_id, -- ALERT_ID            ,
                               r_cols.request_id,
                               r_cols.alertid,
                                                            v_line_number, -- LINE_NUMBER         ,
                               v_case_key,            -- CASE_KEY            ,
                                          v_master_id, -- MASTER_ID           ,
                                                      v_alias_id, -- ALIAS_ID            ,
                               v_xref_id,             -- XREF_ID             ,
                                         v_source_table, -- SOURCE_TABLE        ,
                                                        NULL,  -- SOURCE_TABLE_COLUMN ,
                               v_source_id,           -- SOURCE_ID           ,
                                           v_list_id, -- LIST_ID             ,
                               changeowsstate (l_alert_out_tbl (i).old_state), -- FROM_STATE          ,
                               changeowsstate (l_alert_out_tbl (i).new_state), -- TO_STATE            ,
                               'Y',                    --ENABLED_FLAG        ,
                               'N', --STATUS              , add N as New for now
                                       'From Process Alert 1', --RECORD_COMMENT      ,
                               SYSDATE, p_user_id,
                               SYSDATE, p_user_id, p_session_id
                              );

                        COMMIT;
                        
                        
                        end if;

end loop;

                  END LOOP;

               EXCEPTION
                  WHEN DUP_VAL_ON_INDEX
                  THEN
                     NULL;
               END;

-- PROCESS ENTITY

ELSIF     v_path = 'ENTITY'    AND l_alert_out_tbl (i).new_state IS NOT NULL THEN

                  UPDATE xwrl_response_entity_columns
                     --SET x_state = changeowsstate (l_alert_out_tbl (i).new_state),
                  SET x_state =
                            listrecordtype
                         || SUBSTR
                                (changeowsstate (l_alert_out_tbl (i).new_state),
                                 4
                                ),
                      -- tsuazo 20200511 fix alert record state issue
                      last_updated_by = p_user_id,
                      last_update_date = SYSDATE,
                      last_update_login = p_session_id
                   -- WHERE request_id = p_request_id AND listid = v_list_id;   -- tsuazo 20200515 Alert can have multiple response  records
                  --WHERE  request_id = p_request_id                     AND alertid = l_alert_out_tbl (i).alert_id;
                  -- tsuazo 20200717 THIS NEED TO BE SYNCHRONIZED WITH RMI_OWS_COMMON_UTIL.SYNC_MATCHES
                  --WHERE  listid = v_list_id  and exists  (select 1 from xwrl_requests x where x.id = request_id and x.master_id = v_master_id and x.batch_id = v_batch_id); -- tsuazo 20200717 UID can exist in multiple response  records within a batch
                  WHERE  request_id = p_request_id AND alertid = l_alert_out_tbl (i).alert_id;   -- tsuazo 20200717 Note: The RMI_OWS_COMMON_UTIL.SYNC_MATCHES will pick up the other records

                  COMMIT;

                BEGIN               
               -- TSUAZO 20200717 Add loop for RESPOSNE ENTITY
                FOR r_cols IN ( 
                      select unique i.request_id, r.case_id,i.alertid,listid,i.x_state, r.name_screened, r.master_id, r.alias_id, r.xref_id
                     from xwrl_response_entity_columns  i
                     ,xwrl_requests r
                     where i.request_id = r.id
                     and r.batch_id = v_batch_id
                     and i.listid = v_list_id
                     order by request_id, alertid desc
                      )
                      LOOP

                     /* Note:  Once a record is cleared for an EBS source, there is no need to maintain multiple entries for the same thing.
                                 The unique contraint will limit the records in this table to what is applicable.  */
                                 
               -- PROCESS ALERT CLEARING                                 
                                 
               BEGIN
                  INSERT INTO xwrl_alert_clearing_xref
                              (request_id, source_table, source_id,
                               case_key, alert_id,
                               list_id,
                               from_state,
                               to_state,
                               status,
                               error_message, note, last_update_date,
                               last_updated_by, creation_date, created_by,
                               last_update_login, master_id, alias_id,
                               xref_id
                              )
                       VALUES (p_request_id, v_source_table, v_source_id,
                               v_case_key, l_alert_out_tbl (i).alert_id,
                               v_list_id,
                               changeowsstate (l_alert_out_tbl (i).old_state),
                               changeowsstate (l_alert_out_tbl (i).new_state),
                               l_alert_out_tbl (i).status,
                               l_alert_out_tbl (i).err_msg, v_note, SYSDATE,
                               p_user_id, SYSDATE, p_user_id,
                               p_session_id
                               , r_cols.master_id
                               , r_cols.alias_id
                               , r_cols.xref_id
                              );

                  COMMIT;               -- TSUAZO 20200602 Add missing commit;

               EXCEPTION
                  WHEN DUP_VAL_ON_INDEX
                  THEN
                     NULL;
               END;

               -- PROCESS NOTES

               SELECT COUNT(*)
               INTO v_count
               FROM xwrl_alert_notes
                              WHERE request_id =  r_cols.request_id
               and alert_id = r_cols.alertid
               and note =  l_alert_in_tbl (i).COMMENT
               and created_by = p_user_id;
               
               if v_count =  0 then -- 20200723

             v_line_number := xwrl_alert_notes_line_seq.NEXTVAL;
               --SAURABH 11-JUN-2020
               v_id := xwrl_alert_notes_seq.NEXTVAL;

               INSERT INTO xwrl_alert_notes
                           (ID, request_id,
                            alert_id, line_number,
                            note, last_update_date, last_updated_by,
                            creation_date, created_by, last_update_login
                           )
                    VALUES (v_id, 
                    --p_request_id,
                      --      l_alert_out_tbl (i).alert_id, 
                                                     r_cols.request_id,
                               r_cols.alertid,
                            v_line_number,
                            l_alert_in_tbl (i).COMMENT,              --v_note,
                                                       SYSDATE, p_user_id,
                            SYSDATE, p_user_id, p_session_id
                           );

               COMMIT;
              
              --end if;
               
            --- PROCESS NOTES XREF

                  INSERT INTO xwrl_note_xref
                              (ID, 
                              note_id, 
                              request_id,
                               alert_id, 
                               line_number,
                               case_key, 
                               master_id, 
                               alias_id,
                               xref_id, 
                               source_table, 
                               source_table_column,
                               source_id, 
                               list_id,
                               from_state,
                               to_state,
                               enabled_flag, status, 
                               record_comment,
                               last_update_date, 
                               last_updated_by,
                               creation_date, 
                               created_by, 
                               last_update_login
                              )
                       VALUES (NULL,                  -- ID                  ,
                                    v_id,             -- NOTE_ID             ,
                                         --p_request_id, -- REQUEST_ID          ,
                               --l_alert_out_tbl (i).alert_id, -- ALERT_ID            ,
                               r_cols.request_id,
                               r_cols.alertid,
                                                            v_line_number, -- LINE_NUMBER         ,
                               v_case_key,            -- CASE_KEY            ,
                                          v_master_id, -- MASTER_ID           ,
                                                      v_alias_id, -- ALIAS_ID            ,
                               v_xref_id,             -- XREF_ID             ,
                                         v_source_table, -- SOURCE_TABLE        ,
                                                        NULL,  -- SOURCE_TABLE_COLUMN ,
                               v_source_id,           -- SOURCE_ID           ,
                                           v_list_id, -- LIST_ID             ,
                               changeowsstate (l_alert_out_tbl (i).old_state), -- FROM_STATE          ,
                               changeowsstate (l_alert_out_tbl (i).new_state), -- TO_STATE            ,
                               'Y',                    --ENABLED_FLAG        ,
                               'N', --STATUS              , add N as New for now
                                       'From Process Alert 1', --RECORD_COMMENT      ,
                               SYSDATE, p_user_id,
                               SYSDATE, p_user_id, p_session_id
                              );

                        COMMIT;
                        
                        end if;

                  END LOOP;

               EXCEPTION
                  WHEN DUP_VAL_ON_INDEX
                  THEN
                     NULL;
               END;

               END IF;
            --END IF;
              exception
              when others then null;
              end;
         END LOOP;

         COMMIT;
      END IF;
   -- tsuazo 11/4/2019 confirming this commit is at the end of the loop
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SQLERRM);
   END process_alerts;

   PROCEDURE auto_clear_individuals (
      p_user_id      IN   NUMBER,
      p_session_id   IN   NUMBER,
      p_request_id   IN   INTEGER
   )
   IS
       /* Note: The legacy data does not contain consistent information for EDD or PEP
                       Instead, this is derived from OWS for both.
      */
      CURSOR c1 (p_max_id IN NUMBER)
      IS
         SELECT DISTINCT col.ID, col.request_id, r.source_table, r.source_id,
                         col.listid, col.alertid, col.x_state
                                                             --, col.listrecordtype||' - False Positive' to_state\
                                                             --SAURABH 13-JAN-2020
                         ,
                            col.listrecordtype
                         || SUBSTR (CLEAR.to_state, 4) to_state
                                                               -- TSUAZO 20-FEB-2020
                                                                      --,clear.to_state
                         ,
                         CLEAR.note, CLEAR.max_id
                    FROM xwrl_response_ind_columns col,
                         xwrl_requests r,
                         (WITH max_tab AS
                               (SELECT
                                         --x.source_table, x.source_id, x.list_id,
                                         x.master_id, x.alias_id, x.xref_id,
                                         x.list_id, MAX (ID) ID
                                    FROM xwrl_alert_clearing_xref x
                                --GROUP BY x.source_table, x.source_id, x.list_id
                                GROUP BY x.master_id,
                                         x.alias_id,
                                         x.xref_id,
                                         x.list_id)
                          SELECT x.source_table, x.source_id, x.list_id,
                                 x.to_state, x.note, x.master_id, x.alias_id,
                                 x.xref_id, max_tab.ID max_id
                            FROM xwrl_alert_clearing_xref x, max_tab
                           WHERE 1 = 1
--                    AND x.source_table = max_tab.source_table
--                    AND x.source_id = max_tab.source_id
                             AND x.master_id = max_tab.master_id
                             AND NVL (x.alias_id, -99) = NVL (max_tab.alias_id, -99)
                             AND NVL (x.xref_id, -99) = NVL (max_tab.xref_id, -99)
                             AND x.ID = max_tab.ID) CLEAR
                   WHERE col.request_id = r.ID
--            AND r.source_table = CLEAR.source_table
--            AND r.source_id = CLEAR.source_id
                     AND r.master_id = CLEAR.master_id
                     -- tsuazo 20200722 fix issue with the query
                     AND NVL (r.alias_id, -99) = NVL (CLEAR.alias_id, -99)
                     AND NVL (r.xref_id, -99) = NVL (CLEAR.xref_id, -99)
                     --AND NVL (r.alias_id, -99) = NVL (r.alias_id, -99)
                     --AND NVL (r.xref_id, -99) = NVL (r.xref_id, -99)
                     AND col.listid = CLEAR.list_id
                     AND col.request_id = p_request_id
                     AND CLEAR.max_id > NVL (p_max_id, -1);

      CURSOR c2 (p_max_id IN NUMBER)
      IS
         SELECT DISTINCT col.ID, col.request_id, r.source_table, r.source_id,
                         col.listid, col.alertid, col.x_state
                                                             --, col.listrecordtype||' - False Positive' to_state\
                                                             --SAURABH 13-JAN-2020
                         ,
                            col.listrecordtype
                         || SUBSTR (CLEAR.to_state, 4) to_state
                                                               -- TSUAZO 20-FEB-2020
                                                                     --,clear.to_state
                         ,
                         CLEAR.note, CLEAR.max_id
                    FROM xwrl_response_ind_columns col,
                         xwrl_requests r,
                         xwrl_party_xref r1,
                         (WITH max_tab AS
                               (SELECT   x.master_id, x.alias_id, x.xref_id,
                                         x.list_id, MAX (x.ID) ID
                                    FROM xwrl_alert_clearing_xref x
                                   WHERE 1 = 1
                                GROUP BY x.master_id,
                                         x.alias_id,
                                         x.xref_id,
                                         x.list_id)
                          SELECT x.source_table, x.source_id, x.list_id,
                                 x.to_state, x.note, x.master_id, x.alias_id,
                                 x.xref_id, r.relationship_master_id,
                                 max_tab.ID max_id
                            FROM xwrl_alert_clearing_xref x,
                                 xwrl_party_xref r,
                                 max_tab
                           WHERE 1 = 1
                             AND x.xref_id = r.ID
                             AND x.master_id = max_tab.master_id
                             AND NVL (x.alias_id, -99) =
                                                    NVL (max_tab.alias_id,
                                                         -99)
                             AND NVL (x.xref_id, -99) =
                                                     NVL (max_tab.xref_id,
                                                          -99)
                             AND x.ID = max_tab.ID) CLEAR
                   WHERE col.request_id = r.ID
                     AND r1.ID = r.xref_id
                     AND r1.relationship_master_id =
                                                  CLEAR.relationship_master_id
                     AND r.xref_id IS NOT NULL
                     --SAURABH
                     AND r.master_id <> CLEAR.master_id
                     --
                     AND col.listid = CLEAR.list_id
                     AND col.request_id = p_request_id
                     AND CLEAR.max_id > NVL (p_max_id, -1);

      CURSOR c3 (p_max_id IN NUMBER)
      IS
         SELECT DISTINCT col.ID, col.request_id, r.source_table, r.source_id,
                         col.listid, col.alertid, col.x_state
                                                             --, col.listrecordtype||' - False Positive' to_state\
                                                             --SAURABH 13-JAN-2020
                         ,
                            col.listrecordtype
                         || SUBSTR (CLEAR.to_state, 4) to_state
                                                               -- TSUAZO 20-FEB-2020
                                                                     --,clear.to_state
                         ,
                         CLEAR.note, CLEAR.max_id
                    FROM xwrl_response_ind_columns col,
                         xwrl_requests r,
                         xwrl_party_xref r1,
                         (WITH max_tab AS
                               (SELECT   x.master_id, x.alias_id, x.xref_id,
                                         x.list_id, MAX (x.ID) ID
                                    FROM xwrl_alert_clearing_xref x
                                   WHERE 1 = 1
                                GROUP BY x.master_id,
                                         x.alias_id,
                                         x.xref_id,
                                         x.list_id)
                          SELECT x.source_table, x.source_id, x.list_id,
                                 x.to_state, x.note, x.master_id, x.alias_id,
                                 x.xref_id, max_tab.ID max_id
                            FROM xwrl_alert_clearing_xref x, max_tab
                           WHERE 1 = 1
                             AND x.master_id = max_tab.master_id
                             AND NVL (x.alias_id, -99) =
                                                    NVL (max_tab.alias_id,
                                                         -99)
                             AND NVL (x.xref_id, -99) =
                                                     NVL (max_tab.xref_id,
                                                          -99)
                             --SAURABH
                             AND x.xref_id IS NULL
                             AND x.ID = max_tab.ID) CLEAR
                   WHERE col.request_id = r.ID
                     AND r1.ID = r.xref_id
                     AND r1.relationship_master_id = CLEAR.master_id
                     AND r.xref_id IS NOT NULL
                     AND col.listid = CLEAR.list_id
                     AND col.request_id = p_request_id
                     AND CLEAR.max_id > NVL (p_max_id, -1);

      CURSOR c4 (p_max_id IN NUMBER)
      IS
         SELECT DISTINCT col.ID, col.request_id, r.source_table, r.source_id,
                         col.listid, col.alertid, col.x_state
                                                             --, col.listrecordtype||' - False Positive' to_state\
                                                             --SAURABH 13-JAN-2020
                         ,
                            col.listrecordtype
                         || SUBSTR (CLEAR.to_state, 4) to_state
                                                               -- TSUAZO 20-FEB-2020
                                                                     --,clear.to_state
                         ,
                         CLEAR.note, CLEAR.max_id
                    FROM xwrl_response_ind_columns col,
                         xwrl_requests r,
                         (WITH max_tab AS
                               (SELECT   x.master_id, x.alias_id, x.xref_id,
                                         x.list_id, MAX (x.ID) ID
                                    FROM xwrl_alert_clearing_xref x
                                   WHERE 1 = 1
                                GROUP BY x.master_id,
                                         x.alias_id,
                                         x.xref_id,
                                         x.list_id)
                          SELECT x.source_table, x.source_id, x.list_id,
                                 x.to_state, x.note, x.master_id, x.alias_id,
                                 x.xref_id, r.relationship_master_id,
                                 max_tab.ID max_id
                            FROM xwrl_alert_clearing_xref x,
                                 xwrl_party_xref r,
                                 max_tab
                           WHERE 1 = 1
                             AND x.xref_id = r.ID
                             AND x.master_id = max_tab.master_id
                             AND NVL (x.alias_id, -99) =
                                                    NVL (max_tab.alias_id,
                                                         -99)
                             AND NVL (x.xref_id, -99) =
                                                     NVL (max_tab.xref_id,
                                                          -99)
                             AND x.ID = max_tab.ID) CLEAR
                   WHERE col.request_id = r.ID
                     AND r.master_id = CLEAR.relationship_master_id
                     AND r.xref_id IS NULL
                     AND r.alias_id IS NULL
                     AND col.listid = CLEAR.list_id
                     AND col.request_id = p_request_id
                     AND CLEAR.max_id > NVL (p_max_id, -1);

      --p_alert_tab    alert_tbl_in_type;
      p_alert_tab   xwrl_alert_tbl_in_type;
      v_count        INTEGER;
      v_debug        VARCHAR2 (10);
      v_max_listid   NUMBER;
   BEGIN
      v_count := 0;
      p_alert_tab := xwrl_alert_tbl_in_type();

      -- Clear Alerts for Same Master
      FOR c1rec IN c1 (v_max_listid)
      LOOP
         v_count := v_count + 1;
         p_alert_tab.EXTEND;
         p_alert_tab (v_count) := xwrl_alert_in_rec(c1rec.alertid,c1rec.to_state,c1rec.note);
         v_max_listid := c1rec.max_id;
      END LOOP;

      -- Clear Alets where Cross Reference is already clearerd under other Master as Cross Ref
      FOR c1rec IN c2 (v_max_listid)
      LOOP
         v_count := v_count + 1;
         p_alert_tab.EXTEND;
         p_alert_tab (v_count) := xwrl_alert_in_rec(c1rec.alertid,c1rec.to_state,c1rec.note);
         v_max_listid := c1rec.max_id;
      END LOOP;

      -- Clear Alets where Cross Reference is already clearerd as Master
      FOR c1rec IN c3 (v_max_listid)
      LOOP
         v_count := v_count + 1;
         p_alert_tab.EXTEND;
         p_alert_tab (v_count) := xwrl_alert_in_rec(c1rec.alertid,c1rec.to_state,c1rec.note);
         v_max_listid := c1rec.max_id;
      END LOOP;

      -- Clear Alets where Master is already clearerd as Cross Ref under other Master
      FOR c1rec IN c4 (v_max_listid)
      LOOP
         v_count := v_count + 1;
         p_alert_tab.EXTEND;
         p_alert_tab (v_count) := xwrl_alert_in_rec(c1rec.alertid,c1rec.to_state,c1rec.note);
         v_max_listid := c1rec.max_id;
      END LOOP;

      IF v_count > 0
      THEN
         process_alerts (p_user_id, p_session_id, p_request_id, p_alert_tab);
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SQLERRM);
   END auto_clear_individuals;

   PROCEDURE auto_clear_entities (
      p_user_id      IN   NUMBER,
      p_session_id   IN   NUMBER,
      p_request_id   IN   INTEGER
   )
   IS
      /* Note: The legacy data does not contain consistent information for EDD or PEP
                       Instead, this is derived from OWS for both.
      */
      CURSOR c1 (p_max_id IN NUMBER)
      IS
         SELECT DISTINCT col.ID, col.request_id, r.source_table, r.source_id,
                         col.listid, col.alertid, col.x_state
                                                             --, col.listrecordtype||' - False Positive' to_state\
                                                             --SAURABH 13-JAN-2020
                         ,
                            col.listrecordtype
                         || SUBSTR (CLEAR.to_state, 4) to_state
                                                               -- TSUAZO 20-FEB-2020
                                                                      --,clear.to_state
                         ,
                         CLEAR.note, CLEAR.max_id
                    FROM xwrl_response_entity_columns col,
                         xwrl_requests r,
                         (WITH max_tab AS
                               (SELECT
                                         --x.source_table, x.source_id, x.list_id,
                                         x.master_id, x.alias_id, x.xref_id,
                                         x.list_id, MAX (ID) ID
                                    FROM xwrl_alert_clearing_xref x
                                --GROUP BY x.source_table, x.source_id, x.list_id
                                GROUP BY x.master_id,
                                         x.alias_id,
                                         x.xref_id,
                                         x.list_id)
                          SELECT x.source_table, x.source_id, x.list_id,
                                 x.to_state, x.note, x.master_id, x.alias_id,
                                 x.xref_id, max_tab.ID max_id
                            FROM xwrl_alert_clearing_xref x, max_tab
                           WHERE 1 = 1
--                    AND x.source_table = max_tab.source_table
--                    AND x.source_id = max_tab.source_id
                             AND x.master_id = max_tab.master_id
                             AND NVL (x.alias_id, -99) = NVL (max_tab.alias_id, -99)
                             AND NVL (x.xref_id, -99) = NVL (max_tab.xref_id, -99)
                             AND x.ID = max_tab.ID) CLEAR
                   WHERE col.request_id = r.ID
--            AND r.source_table = CLEAR.source_table
--            AND r.source_id = CLEAR.source_id
                     AND r.master_id = CLEAR.master_id
                     -- tsuazo 20200722 fix issue with the query
                     AND NVL (r.alias_id, -99) = NVL (CLEAR.alias_id, -99)
                     AND NVL (r.xref_id, -99) = NVL (CLEAR.xref_id, -99)
                     --AND NVL (r.alias_id, -99) = NVL (r.alias_id, -99)
                     --AND NVL (r.xref_id, -99) = NVL (r.xref_id, -99)
                     AND col.listid = CLEAR.list_id
                     AND col.request_id = p_request_id
                     AND CLEAR.max_id > NVL (p_max_id, -1);

      CURSOR c2 (p_max_id IN NUMBER)
      IS
         SELECT DISTINCT col.ID, col.request_id, r.source_table, r.source_id,
                         col.listid, col.alertid, col.x_state
                                                             --, col.listrecordtype||' - False Positive' to_state\
                                                             --SAURABH 13-JAN-2020
                         ,
                            col.listrecordtype
                         || SUBSTR (CLEAR.to_state, 4) to_state
                                                               -- TSUAZO 20-FEB-2020
                                                                     --,clear.to_state
                         ,
                         CLEAR.note, CLEAR.max_id
                    FROM xwrl_response_entity_columns col,
                         xwrl_requests r,
                         xwrl_party_xref r1,
                         (WITH max_tab AS
                               (SELECT   x.master_id, x.alias_id, x.xref_id,
                                         x.list_id, MAX (x.ID) ID
                                    FROM xwrl_alert_clearing_xref x
                                   WHERE 1 = 1
                                GROUP BY x.master_id,
                                         x.alias_id,
                                         x.xref_id,
                                         x.list_id)
                          SELECT x.source_table, x.source_id, x.list_id,
                                 x.to_state, x.note, x.master_id, x.alias_id,
                                 x.xref_id, r.relationship_master_id,
                                 max_tab.ID max_id
                            FROM xwrl_alert_clearing_xref x,
                                 xwrl_party_xref r,
                                 max_tab
                           WHERE 1 = 1
                             AND x.xref_id = r.ID
                             AND x.master_id = max_tab.master_id
                             AND NVL (x.alias_id, -99) =
                                                    NVL (max_tab.alias_id,
                                                         -99)
                             AND NVL (x.xref_id, -99) =
                                                     NVL (max_tab.xref_id,
                                                          -99)
                             AND x.ID = max_tab.ID) CLEAR
                   WHERE col.request_id = r.ID
                     AND r1.ID = r.xref_id
                     AND r1.relationship_master_id =
                                                  CLEAR.relationship_master_id
                     AND r.xref_id IS NOT NULL
                     --SAURABH
                     AND r.master_id <> CLEAR.master_id
                     --
                     AND col.listid = CLEAR.list_id
                     AND col.request_id = p_request_id
                     AND CLEAR.max_id > NVL (p_max_id, -1);

      CURSOR c3 (p_max_id IN NUMBER)
      IS
         SELECT DISTINCT col.ID, col.request_id, r.source_table, r.source_id,
                         col.listid, col.alertid, col.x_state
                                                             --, col.listrecordtype||' - False Positive' to_state\
                                                             --SAURABH 13-JAN-2020
                         ,
                            col.listrecordtype
                         || SUBSTR (CLEAR.to_state, 4) to_state
                                                               -- TSUAZO 20-FEB-2020
                                                                     --,clear.to_state
                         ,
                         CLEAR.note, CLEAR.max_id
                    FROM xwrl_response_entity_columns col,
                         xwrl_requests r,
                         xwrl_party_xref r1,
                         (WITH max_tab AS
                               (SELECT   x.master_id, x.alias_id, x.xref_id,
                                         x.list_id, MAX (x.ID) ID
                                    FROM xwrl_alert_clearing_xref x
                                   WHERE 1 = 1
                                GROUP BY x.master_id,
                                         x.alias_id,
                                         x.xref_id,
                                         x.list_id)
                          SELECT x.source_table, x.source_id, x.list_id,
                                 x.to_state, x.note, x.master_id, x.alias_id,
                                 x.xref_id, max_tab.ID max_id
                            FROM xwrl_alert_clearing_xref x, max_tab
                           WHERE 1 = 1
                             AND x.master_id = max_tab.master_id
                             AND NVL (x.alias_id, -99) =
                                                    NVL (max_tab.alias_id,
                                                         -99)
                             AND NVL (x.xref_id, -99) =
                                                     NVL (max_tab.xref_id,
                                                          -99)
                             --SAURABH
                             AND x.xref_id IS NULL
                             AND x.ID = max_tab.ID) CLEAR
                   WHERE col.request_id = r.ID
                     AND r1.ID = r.xref_id
                     AND r1.relationship_master_id = CLEAR.master_id
                     AND r.xref_id IS NOT NULL
                     AND col.listid = CLEAR.list_id
                     AND col.request_id = p_request_id
                     AND CLEAR.max_id > NVL (p_max_id, -1);

      CURSOR c4 (p_max_id IN NUMBER)
      IS
         SELECT DISTINCT col.ID, col.request_id, r.source_table, r.source_id,
                         col.listid, col.alertid, col.x_state
                                                             --, col.listrecordtype||' - False Positive' to_state\
                                                             --SAURABH 13-JAN-2020
                         ,
                            col.listrecordtype
                         || SUBSTR (CLEAR.to_state, 4) to_state
                                                               -- TSUAZO 20-FEB-2020
                                                                     --,clear.to_state
                         ,
                         CLEAR.note, CLEAR.max_id
                    FROM xwrl_response_entity_columns col,
                         xwrl_requests r,
                         (WITH max_tab AS
                               (SELECT   x.master_id, x.alias_id, x.xref_id,
                                         x.list_id, MAX (x.ID) ID
                                    FROM xwrl_alert_clearing_xref x
                                   WHERE 1 = 1
                                GROUP BY x.master_id,
                                         x.alias_id,
                                         x.xref_id,
                                         x.list_id)
                          SELECT x.source_table, x.source_id, x.list_id,
                                 x.to_state, x.note, x.master_id, x.alias_id,
                                 x.xref_id, r.relationship_master_id,
                                 max_tab.ID max_id
                            FROM xwrl_alert_clearing_xref x,
                                 xwrl_party_xref r,
                                 max_tab
                           WHERE 1 = 1
                             AND x.xref_id = r.ID
                             AND x.master_id = max_tab.master_id
                             AND NVL (x.alias_id, -99) =
                                                    NVL (max_tab.alias_id,
                                                         -99)
                             AND NVL (x.xref_id, -99) =
                                                     NVL (max_tab.xref_id,
                                                          -99)
                             AND x.ID = max_tab.ID) CLEAR
                   WHERE col.request_id = r.ID
                     AND r.master_id = CLEAR.relationship_master_id
                     AND r.xref_id IS NULL
                     AND r.alias_id IS NULL
                     AND col.listid = CLEAR.list_id
                     AND col.request_id = p_request_id
                     AND CLEAR.max_id > NVL (p_max_id, -1);

      --p_alert_tab    alert_tbl_in_type;
      p_alert_tab   xwrl_alert_tbl_in_type;
      v_count        INTEGER;
      v_debug        VARCHAR2 (10);
      v_max_listid   NUMBER;
   BEGIN
      v_count := 0;
      p_alert_tab := xwrl_alert_tbl_in_type();

      -- Clear Alerts for Same Master
      FOR c1rec IN c1 (v_max_listid)
      LOOP
         v_count := v_count + 1;
         p_alert_tab.EXTEND;
         p_alert_tab (v_count) := xwrl_alert_in_rec(c1rec.alertid,c1rec.to_state,c1rec.note);
         v_max_listid := c1rec.max_id;
      END LOOP;

      -- Clear Alets where Cross Reference is already clearerd under other Master as Cross Ref
      FOR c1rec IN c2 (v_max_listid)
      LOOP
         v_count := v_count + 1;
         p_alert_tab.EXTEND;
         p_alert_tab (v_count) := xwrl_alert_in_rec(c1rec.alertid,c1rec.to_state,c1rec.note);
         v_max_listid := c1rec.max_id;
      END LOOP;

      -- Clear Alets where Cross Reference is already clearerd as Master
      FOR c1rec IN c3 (v_max_listid)
      LOOP
         v_count := v_count + 1;
         p_alert_tab.EXTEND;
         p_alert_tab (v_count) := xwrl_alert_in_rec(c1rec.alertid,c1rec.to_state,c1rec.note);
         v_max_listid := c1rec.max_id;
      END LOOP;

      -- Clear Alets where Master is already clearerd as Cross Ref under other Master
      FOR c1rec IN c4 (v_max_listid)
      LOOP
         v_count := v_count + 1;
         p_alert_tab.EXTEND;
         p_alert_tab (v_count) := xwrl_alert_in_rec(c1rec.alertid,c1rec.to_state,c1rec.note);
         v_max_listid := c1rec.max_id;
      END LOOP;

      IF v_count > 0
      THEN
         process_alerts (p_user_id, p_session_id, p_request_id, p_alert_tab);
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SQLERRM);
   END auto_clear_entities;

   FUNCTION changetoowsstate (p_statename IN VARCHAR2)
      RETURN VARCHAR2
   IS
      p_return_state   VARCHAR2 (200);
   BEGIN
      IF p_statename IS NOT NULL
      THEN
         IF p_statename = 'EDD - Open'
         THEN
            p_return_state := 'EDD - Open';
         END IF;

         IF    p_statename = 'EDD - False Positive'
            OR p_statename = 'EDD - Closed'
         THEN
            p_return_state := 'EDD - False Positive';
         END IF;

         IF p_statename = 'EDD - Possible'
         THEN
            p_return_state := 'EDD - Suspected True Match';
         END IF;

         IF p_statename = 'EDD - Positive'
         THEN
            p_return_state := 'EDD - True Match Not Monitored';
         END IF;

         IF p_statename = 'PEP - Open'
         THEN
            p_return_state := 'PEP - Open';
         END IF;

         IF    p_statename = 'PEP - False Positive'
            OR p_statename = 'PEP - Closed'
         THEN
            p_return_state := 'PEP - False Positive';
         END IF;

         IF p_statename = 'PEP - Possible'
         THEN
            p_return_state := 'PEP - Suspected True Match';
         END IF;

         IF p_statename = 'PEP - Positive'
         THEN
            p_return_state := 'PEP - True Match Not Monitored';
         END IF;

         IF p_statename = 'SAN - Open'
         THEN
            p_return_state := 'SAN - Open';
         END IF;

         IF    p_statename = 'SAN - False Positive'
            OR p_statename = 'SAN - Closed'
         THEN
            p_return_state := 'SAN - False Positive';
         END IF;

         IF p_statename = 'SAN - Possible'
         THEN
            p_return_state := 'SAN - Suspected True Match';
         END IF;

         IF p_statename = 'SAN - Positive'
         THEN
            p_return_state := 'SAN - True Match Not Monitored';
         END IF;
      END IF;

      RETURN p_return_state;
   END;

   FUNCTION changeowsstate (p_statename IN VARCHAR2)
      RETURN VARCHAR2
   IS
      p_return_state   VARCHAR2 (200);
   BEGIN
      IF p_statename IS NOT NULL
      THEN
         IF p_statename = 'EDD - Open'
         THEN
            p_return_state := 'EDD - Open';
         END IF;

         IF p_statename = 'EDD - False Positive'
         THEN
            p_return_state := 'EDD - False Positive';
         END IF;

         IF p_statename = 'EDD - Suspected True Match'
         THEN
            p_return_state := 'EDD - Possible';
         END IF;

         IF p_statename = 'EDD - True Match Not Monitored'
         THEN
            p_return_state := 'EDD - Positive';
         END IF;

         IF p_statename = 'PEP - Open'
         THEN
            p_return_state := 'PEP - Open';
         END IF;

         IF p_statename = 'PEP - False Positive'
         THEN
            p_return_state := 'PEP - False Positive';
         END IF;

         IF p_statename = 'PEP - Suspected True Match'
         THEN
            p_return_state := 'PEP - Possible';
         END IF;

         IF p_statename = 'PEP - True Match Not Monitored'
         THEN
            p_return_state := 'PEP - Positive';
         END IF;

         IF p_statename = 'SAN - Open'
         THEN
            p_return_state := 'SAN - Open';
         END IF;

         IF p_statename = 'SAN - False Positive'
         THEN
            p_return_state := 'SAN - False Positive';
         END IF;

         IF p_statename = 'SAN - Suspected True Match'
         THEN
            p_return_state := 'SAN - Possible';
         END IF;

         IF p_statename = 'SAN - True Match Not Monitored'
         THEN
            p_return_state := 'SAN - Positive';
         END IF;
      END IF;

      RETURN p_return_state;
   END;
END xwrl_ows_utils;