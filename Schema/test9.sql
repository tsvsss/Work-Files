
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "APPS"."XWRL_OWS_UTILS" AS

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
* Name                : xwrl_ows_utils					                                                            *
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
*                                                                                                                   *
********************************************************************************************************************/

   PROCEDURE test_db_link (
      x_response OUT integer )
      IS

      BEGIN

      x_response := 0;

      select 1 into x_response from dual@ebstoows2.coresys.com;    

      exception
      when others then null;

      END test_db_link;


   PROCEDURE process_alerts (
      p_user_id      IN             NUMBER
      , p_session_id   IN             NUMBER
      , p_request_id   IN             INTEGER
      , p_alert_tab    IN             xwrl_alert_tbl_in_type
   ) IS

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
      v_user varchar2(100);

   BEGIN

      IF p_user_id IS NOT NULL THEN
         SELECT user_name into v_user from fnd_user where user_id = p_user_id;
      END IF;

     -- Process inbound table from ADF
      FOR i IN p_alert_tab.first..p_alert_tab.last LOOP
         l_alert_in_tbl (i).alert_id := p_alert_tab (i).p_alert_id;
         l_alert_in_tbl (i).to_state := ChangeToOwsState(p_alert_tab (i).p_to_state);
         l_alert_in_tbl (i).comment := p_alert_tab (i).p_comment;
         v_note := p_alert_tab (i).p_comment; -- Note: they will all have the same comment
      END LOOP;

      /* For debugging purposes 

      FOR i IN l_alert_in_tbl.first..l_alert_in_tbl.last LOOP

         dbms_output.put_line ('Alert - alert_id: ' || l_alert_in_tbl (i).alert_id);
         dbms_output.put_line ('Alert - to_state: ' || l_alert_in_tbl (i).to_state);
         dbms_output.put_line ('Alert - comment: ' || l_alert_in_tbl (i).comment);

         insert into tmp_xwrl_alerts (
            p_user
            , p_alert_id
            , p_to_state
            , p_comment
         ) VALUES (
            v_user
            , l_alert_in_tbl (i).alert_id
            , l_alert_in_tbl (i).to_state
            , l_alert_in_tbl (i).comment
         );

      END LOOP;

     */

      -- Execute OWS procedure
      xows.xxiri_cm_process_pkg.update_alerts@ebstoows2.coresys.com (p_user => v_user, p_alert_in_tbl => l_alert_in_tbl, x_alert_out_tbl => l_alert_out_tbl, x_status => x_status);

         dbms_output.put_line ('Alert - X_STATUS: ' || x_status);

     -- Process outbound table from OWS
      FOR i IN l_alert_out_tbl.first..l_alert_out_tbl.last LOOP

         dbms_output.put_line ('Alert - alert_id: ' || l_alert_out_tbl (i).alert_id);
         dbms_output.put_line ('Alert - key_label: ' || l_alert_out_tbl (i).key_label);
         dbms_output.put_line ('Alert - old_state: ' || l_alert_out_tbl (i).old_state);
         dbms_output.put_line ('Alert - new_state: ' || l_alert_out_tbl (i).new_state);
         dbms_output.put_line ('Alert - status: ' || l_alert_out_tbl (i).status);
         dbms_output.put_line ('Alert - err_msg: ' || l_alert_out_tbl (i).err_msg);

         v_key_label := l_alert_out_tbl (i).key_label;

         SELECT
            substr (v_key_label, 1, instr (v_key_label, ':', 1) - 1)
         INTO v_case_key
         FROM
            dual;

         SELECT
            to_number (substr (v_key_label, instr (v_key_label, ':', - 1) + 1, length (v_key_label)))
         INTO v_list_id
         FROM
            dual;

         SELECT
            source_table
            , source_id
            , path
         INTO
            v_source_table
         , v_source_id
         , v_path
         FROM
            xwrl.xwrl_requests
         WHERE
            id = p_request_id;

         /* For debugging purposes 

         insert into tmp_xwrl_alert_results (
            p_request_id
            , p_case_key
            , p_alert_id
            , p_list_id
            , p_key_label
            , p_old_state
            , p_new_state
            , p_status
            , p_err_msg
         ) VALUES (
            p_request_id
            , v_case_key
            , l_alert_out_tbl (i).alert_id
            , v_list_id
            , l_alert_out_tbl (i).key_label
            , l_alert_out_tbl (i).old_state
            , l_alert_out_tbl (i).new_state
            , l_alert_out_tbl (i).status
            , l_alert_out_tbl (i).err_msg
         );

         */        

         IF (l_alert_out_tbl (i).status = 'SUCCESS') THEN

            BEGIN
               SELECT
                  nvl (MAX (line_number), 0) + 10 line_number
               INTO v_line_number
               FROM
                  xwrl_alert_notes
               WHERE
                  alert_id = l_alert_out_tbl (i).alert_id;
            EXCEPTION
               WHEN no_data_found THEN
                  v_line_number := 10;
            END;

            insert /*+ append */ into xwrl_alert_notes (
               request_id
               , alert_id
               , line_number
               , note
               , last_update_date
               , last_updated_by
               , creation_date
               , created_by
               , last_update_login
            ) VALUES (
               p_request_id
               , l_alert_out_tbl (i).alert_id
               , v_line_number
               , v_note
               , SYSDATE
               , p_user_id
               , SYSDATE
               , p_user_id
               , p_session_id
            );

            COMMIT;

            /* Note:  Once a record is cleared for an EBS source, there is no need to maintain multiple entries for the same thing.
                              The unique contraint will limit the records in this table to what is applicable.  */


            BEGIN

            IF  v_source_table is not null and v_source_id is  not null then

            insert /*+ append */ into xwrl_alert_clearing_xref (
               request_id
               , source_table
               , source_id
               , case_key
               , alert_id
               , list_id
               , from_state
               , to_state
               , status
               , error_message
               , note
               , last_update_date
               , last_updated_by
               , creation_date
               , created_by
               , last_update_login               
            ) VALUES (
               p_request_id
               , v_source_table
               , v_source_id
               , v_case_key
               , l_alert_out_tbl (i).alert_id
               , v_list_id
               , ChangeOwsState(l_alert_out_tbl (i).old_state)
               , ChangeOwsState(l_alert_out_tbl (i).new_state)
               , l_alert_out_tbl (i).status
               , l_alert_out_tbl (i).err_msg
               , v_note
               , SYSDATE
               , p_user_id
               , SYSDATE
               , p_user_id
               , p_session_id               
            );

            COMMIT;

            end if;

            EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN NULL;
            END;

            IF v_path = 'INDIVIDUAL' THEN

               UPDATE xwrl_response_ind_columns
               SET
                  x_state = ChangeOwsState(l_alert_out_tbl (i).new_state)
                        ,last_updated_by = p_user_id
      ,last_update_date = SYSDATE
      ,last_update_login = p_session_id    
               WHERE
                  request_id = p_request_id
                  AND listid = v_list_id;

                  COMMIT;

            ELSIF v_path = 'ENTITY' THEN

               UPDATE xwrl_response_entity_columns
               SET
                  x_state = ChangeOwsState(l_alert_out_tbl (i).new_state)
                        ,last_updated_by = p_user_id
      ,last_update_date = SYSDATE
      ,last_update_login = p_session_id    
               WHERE
                  request_id = p_request_id
                  AND listid = v_list_id;

                  COMMIT;

            END IF;

         END IF;

      END LOOP;

      COMMIT;   -- tsuazo 11/4/2019 confirming this commit is at the end of the loop

   EXCEPTION
      WHEN OTHERS THEN
         raise_application_error (-20100, sqlerrm);

   END process_alerts;

   PROCEDURE process_alerts (
      p_user_id      IN             NUMBER
      , p_session_id   IN             NUMBER
      , p_request_id   IN             INTEGER
      , p_alert_tab    IN             alert_tbl_in_type
   ) IS

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
      v_user varchar2(100);

   BEGIN

      IF p_user_id IS NOT NULL THEN
         SELECT user_name into v_user from fnd_user where user_id = p_user_id;
      END IF;

     -- Process inbound table from ADF
      FOR i IN p_alert_tab.first..p_alert_tab.last LOOP
         l_alert_in_tbl (i).alert_id := p_alert_tab (i).p_alert_id;
         l_alert_in_tbl (i).to_state := ChangeToOwsState(p_alert_tab (i).p_to_state);
         l_alert_in_tbl (i).comment := p_alert_tab (i).p_comment;
         v_note := p_alert_tab (i).p_comment; -- Note: they will all have the same comment
      END LOOP;


      /* For debugging purposes 

      FOR i IN l_alert_in_tbl.first..l_alert_in_tbl.last LOOP       

         dbms_output.put_line ('Alert - alert_id: ' || l_alert_in_tbl (i).alert_id);
         dbms_output.put_line ('Alert - to_state: ' || l_alert_in_tbl (i).to_state);
         dbms_output.put_line ('Alert - comment: ' || l_alert_in_tbl (i).comment);


         insert into tmp_xwrl_alerts (
         p_user
         , p_alert_id
         , p_to_state
         , p_comment
      ) VALUES (
         p_user
         , l_alert_in_tbl (i).alert_id
         , l_alert_in_tbl (i).to_state
         , l_alert_in_tbl (i).comment
      );

      END LOOP;

      */

      -- Execute OWS procedure
      xows.xxiri_cm_process_pkg.update_alerts@ebstoows2.coresys.com (p_user => v_user, p_alert_in_tbl => l_alert_in_tbl, x_alert_out_tbl => l_alert_out_tbl, x_status => x_status);

      -- dbms_output.put_line ('Alert - X_STATUS: ' || x_status);

     -- Process outbound table from OWS
      FOR i IN l_alert_out_tbl.first..l_alert_out_tbl.last LOOP

         /*
         dbms_output.put_line ('Alert - alert_id: ' || l_alert_out_tbl (i).alert_id);
         dbms_output.put_line ('Alert - key_label: ' || l_alert_out_tbl (i).key_label);
         dbms_output.put_line ('Alert - old_state: ' || l_alert_out_tbl (i).old_state);
         dbms_output.put_line ('Alert - new_state: ' || l_alert_out_tbl (i).new_state);
         dbms_output.put_line ('Alert - status: ' || l_alert_out_tbl (i).status);
         dbms_output.put_line ('Alert - err_msg: ' || l_alert_out_tbl (i).err_msg);
         */

         v_key_label := l_alert_out_tbl (i).key_label;

         SELECT
            substr (v_key_label, 1, instr (v_key_label, ':', 1) - 1)
         INTO v_case_key
         FROM
            dual;

         SELECT
            to_number (substr (v_key_label, instr (v_key_label, ':', - 1) + 1, length (v_key_label)))
         INTO v_list_id
         FROM
            dual;

         SELECT
            source_table
            , source_id
            , path
         INTO
            v_source_table
         , v_source_id
         , v_path
         FROM
            xwrl.xwrl_requests
         WHERE
            id = p_request_id;

         /* For debugging purposes 

         insert into tmp_xwrl_alert_results (
            p_request_id
            , p_case_key
            , p_alert_id
            , p_list_id
            , p_key_label
            , p_old_state
            , p_new_state
            , p_status
            , p_err_msg
         ) VALUES (
            p_request_id
            , v_case_key
            , l_alert_out_tbl (i).alert_id
            , v_list_id
            , l_alert_out_tbl (i).key_label
            , l_alert_out_tbl (i).old_state
            , l_alert_out_tbl (i).new_state
            , l_alert_out_tbl (i).status
            , l_alert_out_tbl (i).err_msg
         );

         */

         IF (l_alert_out_tbl (i).status = 'SUCCESS') THEN

            BEGIN
               SELECT
                  nvl (MAX (line_number), 0) + 10 line_number
               INTO v_line_number
               FROM
                  xwrl_alert_notes
               WHERE
                  alert_id = l_alert_out_tbl (i).alert_id;
            EXCEPTION
               WHEN no_data_found THEN
                  v_line_number := 10;
            END;

            insert /*+ append */ into xwrl_alert_notes (
               request_id
               , alert_id
               , line_number
               , note
               , last_update_date
               , last_updated_by
               , creation_date
               , created_by
               , last_update_login
            ) VALUES (
               p_request_id
               , l_alert_out_tbl (i).alert_id
               , v_line_number
               , v_note
               , SYSDATE
               , p_user_id
               , SYSDATE
               , p_user_id
               , p_session_id
            );

            COMMIT;

            /* Note:  Once a record is cleared for an EBS source, there is no need to maintain multiple entries for the same thing.
                              The unique contraint will limit the records in this table to what is applicable.  */
            BEGIN
            insert /*+ append */ into xwrl_alert_clearing_xref (
               request_id
               , source_table
               , source_id
               , case_key
               , alert_id
               , list_id
               , from_state
               , to_state
               , status
               , error_message
               , note
               , last_update_date
               , last_updated_by
               , creation_date
               , created_by
               , last_update_login               
            ) VALUES (
               p_request_id
               , v_source_table
               , v_source_id
               , v_case_key
               , l_alert_out_tbl (i).alert_id
               , v_list_id
               , ChangeOwsState(l_alert_out_tbl (i).old_state)
               , ChangeOwsState(l_alert_out_tbl (i).new_state)
               , l_alert_out_tbl (i).status
               , l_alert_out_tbl (i).err_msg
               , v_note
               , SYSDATE
               , p_user_id
               , SYSDATE
               , p_user_id
               , p_session_id
            );
            EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN NULL;
            END;

            IF v_path = 'INDIVIDUAL' THEN

               UPDATE xwrl_response_ind_columns
               SET
                  x_state = ChangeOwsState(l_alert_out_tbl (i).new_state)
                        ,last_updated_by = p_user_id
      ,last_update_date = SYSDATE
      ,last_update_login = p_session_id    
               WHERE
                  request_id = p_request_id
                  AND listid = v_list_id;

                  COMMIT;

            ELSIF v_path = 'ENTITY' THEN

               UPDATE xwrl_response_entity_columns
               SET
                  x_state = ChangeOwsState(l_alert_out_tbl (i).new_state)
                        ,last_updated_by = p_user_id
      ,last_update_date = SYSDATE
      ,last_update_login = p_session_id    
               WHERE
                  request_id = p_request_id
                  AND listid = v_list_id;

                  COMMIT;

            END IF;

         END IF;

      END LOOP;

      COMMIT;  -- tsuazo 11/4/2019 confirming this commit is at the end of the loop

   EXCEPTION
      WHEN OTHERS THEN
         raise_application_error (-20100, sqlerrm);

   END process_alerts;

   PROCEDURE auto_clear_individuals (
      p_user_id      IN             NUMBER
      , p_session_id   IN             NUMBER
      , p_request_id   IN             INTEGER
   ) IS

       /* Note: The legacy data does not contain consistent information for EDD or PEP
                       Instead, this is derived from OWS for both.
      */

      CURSOR c1 IS
      SELECT
         col.id
         , col.request_id
         , r.source_table
         , r.source_id
         , col.listid
         , col.alertid
         , col.x_state
         , col.listrecordtype||' - False Positive' to_state
         --,clear.to_state
         , clear.note
      FROM
         xwrl_response_ind_columns   col
         , xwrl_requests               r
         , (
            WITH max_tab AS (
               SELECT
                  x.source_table
                  , x.source_id
                  , x.list_id
                  , MAX (id) id
               FROM
                  xwrl_alert_clearing_xref x
               GROUP BY
                  x.source_table
                  , x.source_id
                  , x.list_id
            )
            SELECT
               x.source_table
               , x.source_id
               , x.list_id
               , x.to_state
               , x.note
            FROM
               xwrl_alert_clearing_xref x
               , max_tab
            WHERE
               x.source_table = max_tab.source_table
               AND x.source_id = max_tab.source_id
               AND x.id = max_tab.id
         ) clear
      WHERE
         col.request_id = r.id
         AND r.source_table = clear.source_table
         AND r.source_id = clear.source_id
         AND col.listid = clear.list_id
         AND col.request_id = p_request_id;

      p_alert_tab   alert_tbl_in_type;
      v_count       INTEGER;

   BEGIN

      v_count := 0;


      FOR c1rec IN c1 LOOP

         v_count := v_count + 1;

         p_alert_tab (v_count).p_alert_id := c1rec.alertid;
         p_alert_tab (v_count).p_to_state := c1rec.to_state;
         p_alert_tab (v_count).p_comment := c1rec.note;

      END LOOP;

      IF v_count > 0 THEN

        process_alerts (p_user_id,p_session_id, p_request_id, p_alert_tab);

      END IF;

   EXCEPTION
      WHEN OTHERS THEN
         raise_application_error (-20100, sqlerrm);

   END auto_clear_individuals;

   PROCEDURE auto_clear_entities (
      p_user_id      IN             NUMBER
      , p_session_id   IN             NUMBER
      , p_request_id   IN             INTEGER
   ) IS

      /* Note: The legacy data does not contain consistent information for EDD or PEP
                       Instead, this is derived from OWS for both.
      */
      CURSOR c1 IS
      SELECT
         col.id
         , col.request_id
         , r.source_table
         , r.source_id
         , col.listid
         , col.alertid
         ,col.listrecordtype
         , col.x_state
         , col.listrecordtype||' - False Positive' to_state
         --,clear.to_state
         , clear.note
      FROM
         xwrl_response_entity_columns   col
         , xwrl_requests                  r
         , (
            WITH max_tab AS (
               SELECT
                  x.source_table
                  , x.source_id
                  , x.list_id
                  , MAX (id) id
               FROM
                  xwrl_alert_clearing_xref x
               GROUP BY
                  x.source_table
                  , x.source_id
                  , x.list_id
            )
            SELECT
               x.source_table
               , x.source_id
               , x.list_id
               , x.to_state
               , x.note
            FROM
               xwrl_alert_clearing_xref x
               , max_tab
            WHERE
               x.source_table = max_tab.source_table
               AND x.source_id = max_tab.source_id
               AND x.id = max_tab.id
         ) clear
      WHERE
         col.request_id = r.id
         AND r.source_table = clear.source_table
         AND r.source_id = clear.source_id
         AND col.listid = clear.list_id
         AND col.request_id = p_request_id;

      p_alert_tab   alert_tbl_in_type;
      v_count       INTEGER;

   BEGIN

      v_count := 0;

      FOR c1rec IN c1 LOOP

         v_count := v_count + 1;

         p_alert_tab (v_count).p_alert_id := c1rec.alertid;
         p_alert_tab (v_count).p_to_state := c1rec.to_state;
         p_alert_tab (v_count).p_comment := c1rec.note;

      END LOOP;

      IF v_count > 0 THEN

         process_alerts (p_user_id,p_session_id, p_request_id, p_alert_tab);

      END IF;

   EXCEPTION
      WHEN OTHERS THEN
         raise_application_error (-20100, sqlerrm);

   END auto_clear_entities;

      FUNCTION ChangeToOwsState(p_statename in varchar2) RETURN VARCHAR2 IS
        p_return_state varchar2(200);
BEGIN

  IF p_statename is not null
  THEN

		  IF p_statename = 'EDD - Open'
		  THEN
			  p_return_state := 'EDD - Open';
		  END IF;

		   IF p_statename = 'EDD - False Positive' OR p_statename = 'EDD - Closed'
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

		   IF p_statename = 'PEP - False Positive' OR p_statename = 'PEP - Closed'
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

		   IF p_statename = 'SAN - False Positive' OR p_statename = 'SAN - Closed'
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


FUNCTION ChangeOwsState(p_statename in varchar2) RETURN VARCHAR2 IS
        p_return_state varchar2(200);
BEGIN

    IF p_statename is not NULL
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

/
