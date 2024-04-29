CREATE OR REPLACE PACKAGE BODY XXIRI_CM_PROCESS_PKG
    /********************************************************************************************************************
    * Oracle EDQ Watchlist                                                                                              *
    * I --> Initial                                                                                                     *
    * E --> Enhancement                                                                                                 *
    * R --> Requirement                                                                                                 *
    * B --> Bug                                                                                                         *
    ********************************************************************************************************************/
    /*$Header: XXIRI_CM_PROCESS_PKG_PKB.sql 1.1 2019/07/26 12:00:00CST   rrathod (Inspirage) Exp                $*/
    /********************************************************************************************************************
    * Type                : PACKAGE  BODY                                                                               *
    * Name                : XXIRI_CM_PROCESS_PKG                                                                        *
    * Script Name         : XXIRI_CM_PROCESS_PKG_PKB.sql                                                                *
    * Purpose             : This script change state of alert in EDQ watchlist                                    *
    *                                                                                                                   *
    * Company             : Inspirage LLC                                                                               *
    * Client              : IRI                                                                                         *
    * Created By          : Rajiv Rathod                                                                                *
    * Created Date        : 26-JUL-2019                                                                                 *
    * Last Reviewed By    : Rajiv Rathod                                                                                *
    * Last Reviewed Date  : 26-JUL-2019                                                                                 *
    *********************************************************************************************************************
    * <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
    * Date        By               Script               By            Date     Type  Details                            *
    * ----------- ---------------- -------- --------- --------------- ----------- -----  ------------------------------ *
    * 26-JUL-2019  Inspirage         1.1            Rajiv Rathod    26-JUL-2019   I  Intetial version          *
    * 29-AUG-2019  IRI                     1.3            Tony Suazo       29-AUG-2019 I  Add to ALERT_OUT_REC - Key Label, Old State          *
    *                                                                                                                   *
    ********************************************************************************************************************/
AS
    /********************************************************************************************************************
    * Type                : Procedure                                                                                   *
    * Name                : update_alerts                                                                               *
    * Purpose             : This is procedure to update the alert status                                          *
    *  INBOUND VARIABLES  :                            *
    p_user         - This should be EDQ user which will update the alert status             *
    p_alert_in_tbl    - This should be input table type with alert ID, to state and comment           *
    *  OUTBOUND VARIABLES :                          *
    x_alert_out_tbl   - Output table type with alert status and err message           *
    x_status          - Output variable with overall status with 3 possible values (SUCCESS, WARNING, ERROR)  *
    *********************************************************************************************************************
    * <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
    * Date        By               Script               By            Date     Type  Details                            *
    * ----------- ---------------- -------- --------- --------------- ----------- -----  ------------------------------ *
    * 26-JUL-2019  Inspirage         1.1            Rajiv Rathod    26-JUL-2019   I  Intetial version          *
    *                                                                                                                   *
    /*******************************************************************************************************************/
PROCEDURE update_alerts
                       (
                           p_user VARCHAR2
                         , p_alert_in_tbl IN xxiri_cm_process_pkg.alert_tbl_in_type
                         , x_alert_out_tbl OUT xxiri_cm_process_pkg.alert_tbl_out_type
                         , x_status OUT VARCHAR2
                       )
IS
    --Declaring variables
    l_alert_in_tbl xxiri_cm_process_pkg.alert_tbl_in_type := p_alert_in_tbl;
    l_alert_out_tbl xxiri_cm_process_pkg.alert_tbl_out_type;
    -- local variables
    l_schema         VARCHAR2(100) := NULL;
    l_c_curr_state   VARCHAR2(100) := NULL;
    l_c_key_label    VARCHAR2(500) := NULL; -- tsuazo 20190829
    l_n_user         NUMBER        := NULL;
    l_n_alert_id     NUMBER        := NULL;
    l_val_from_state VARCHAR2(100) := NULL;
    l_val_to_state   VARCHAR2(100) := NULL;
    l_val_transition VARCHAR2(100) := NULL;
    l_val_curr_open  VARCHAR2(100) := NULL;
    l_d_sysdate      DATE          := SYSDATE;
    l_n_case_id      NUMBER        := NULL;
    l_c_insert_case  VARCHAR2(100) := NULL;
    l_c_system_user  VARCHAR2(100) := 'WEBLOGIC';
BEGIN
    DBMS_OUTPUT.PUT_LINE('Start of procedure');
    -- Insert log for API call
    FOR j IN l_alert_in_tbl.FIRST..l_alert_in_tbl.LAST
    LOOP
        INSERT INTO XOWS.XXIRI_ALERT_LOG VALUES
               (l_alert_in_tbl(j).alert_id
                    , l_alert_in_tbl(j).to_state
                    , p_user
                    , l_d_sysdate
                    , NULL
                    , NULL
                    , NULL
               )
        ;
    
    END LOOP;
    --  COMMIT;
    x_status := 'SUCCESS';
    FOR i IN l_alert_in_tbl.FIRST..l_alert_in_tbl.LAST
    LOOP
        -- Initialising variables
        l_schema         := NULL;
        l_n_user         := NULL;
        l_n_alert_id     := NULL;
        l_c_curr_state   := NULL;
        l_c_key_label    := NULL; -- tsuazo 20190829
        l_val_from_state := NULL;
        l_val_to_state   := NULL;
        l_val_transition := NULL;
        l_val_curr_open  := NULL;
        l_n_case_id      := NULL;
        l_c_insert_case  := NULL;
        DBMS_OUTPUT.PUT_LINE('Alert ID is : '
        ||l_alert_in_tbl(i).alert_id
        ||' change to state : '
        ||l_alert_in_tbl(i).to_state
        ||' and comments are : '
        ||l_alert_in_tbl(i).comment);
        l_alert_out_tbl(i).alert_id := l_alert_in_tbl(i).alert_id;
        l_alert_out_tbl(i).status   := 'SUCCESS';
        l_alert_out_tbl(i).err_msg  := NULL;
        -- Identify in which schema the record exist
        BEGIN
            SELECT
                   'IRIDR_EDQCONFIG'
                 , ID
                 , CURRENT_STATE
                 , PARENT_ID
                 , KEY_LABEL -- tsuazo 20190829
            INTO
                   l_schema
                 , l_n_alert_id
                 , l_c_curr_state
                 , l_n_case_id
                 , l_c_key_label -- tsuazo 20190829
            FROM
                   iridr_edqconfig.dn_case
            WHERE
                   CASE_TYPE       = 'issue'
                   AND EXTERNAL_ID = l_alert_in_tbl(i).alert_id
            ;
            
            l_alert_out_tbl(i).alert_id := l_alert_in_tbl(i).alert_id;
            DBMS_OUTPUT.PUT_LINE('Alert found in IRIDR_EDQCONFIG : '
            ||l_alert_in_tbl(i).alert_id);
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Alert not found in IRIDR_EDQCONFIG : '
            ||l_alert_in_tbl(i).alert_id);
            --l_schema := NULL;
        END;
        BEGIN
            SELECT
                   'IRIDR2_EDQCONFIG'
                 , ID
                 , CURRENT_STATE
                 , PARENT_ID
                 , KEY_LABEL -- tsuazo 20190829
            INTO
                   l_schema
                 , l_n_alert_id
                 , l_c_curr_state
                 , l_n_case_id
                 , l_c_key_label -- tsuazo 20190829
            FROM
                   iridr2_edqconfig.dn_case
            WHERE
                   CASE_TYPE       = 'issue'
                   AND EXTERNAL_ID = l_alert_in_tbl(i).alert_id
            ;
            
            l_alert_out_tbl(i).alert_id := l_alert_in_tbl(i).alert_id;
            DBMS_OUTPUT.PUT_LINE('Alert found in IRIDR2_EDQCONFIG : '
            ||l_alert_in_tbl(i).alert_id);
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Alert not found in IRIDR2_EDQCONFIG : '
            ||l_alert_in_tbl(i).alert_id);
            --l_schema := NULL;
        END;
        IF l_schema IS NULL THEN
            l_alert_out_tbl(i).alert_id := l_alert_in_tbl(i).alert_id;
            l_alert_out_tbl(i).status   := 'ERROR';
            x_status                    := 'ERROR';
            l_alert_out_tbl(i).err_msg  := l_alert_in_tbl(i).alert_id
            ||' : Alert Not Found in watchlist, ';
            GOTO next_record;
        END IF;
        IF (l_schema = 'IRIDR_EDQCONFIG') THEN
            -- identify user
            BEGIN
                SELECT
                       ID
                INTO
                       l_n_user
                FROM
                       IRIDR_EDQCONFIG.dn_usergraveyard
                WHERE
                       UPPER(USERNAME) = UPPER(l_c_system_user)
                       AND DELETED     = 0
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Watchlist User not found in IRIDR_EDQCONFIG schema for : '
                ||l_c_system_user);
                l_alert_out_tbl(i).err_msg := l_alert_out_tbl(i).err_msg
                ||'Watchlist User not found in IRIDR_EDQCONFIG schema for : '
                ||l_c_system_user
                ||' ,';
                l_alert_out_tbl(i).status := 'ERROR';
                x_status                  := 'ERROR';
                GOTO next_record;
            END;
            --Validate to - state
            BEGIN
                SELECT
                       FROM_STATE
                     , TO_STATE
                     , TRANSITION
                INTO
                       l_val_from_state
                     , l_val_to_state
                     , l_val_transition
                FROM
                       XOWS.XXIRI_ALERT_VALIDATION
                WHERE
                       TO_STATE = l_alert_in_tbl(i).to_state
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Transfer to state is not valid OR not found in state validation table : '
                ||l_alert_in_tbl(i).to_state);
                l_alert_out_tbl(i).err_msg := l_alert_out_tbl(i).err_msg
                ||'Transfer to state is not valid and not found in state validation table: '
                ||l_alert_in_tbl(i).to_state
                ||' ,';
                l_alert_out_tbl(i).status := 'ERROR';
                x_status                  := 'ERROR';
                GOTO next_record;
            END;
            -- Validate the existing from state
            BEGIN
                SELECT
                       'NOT_VALID_OPEN'
                INTO
                       l_val_curr_open
                FROM
                       DUAL
                WHERE
                       1                  =1
                       AND l_c_curr_state = l_val_from_state
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Existing state of alert is not open so it cannot be closed OR the alert can not be transitioned to provided to be state for current state : '
                ||l_c_curr_state);
                l_alert_out_tbl(i).err_msg := l_alert_out_tbl(i).err_msg
                ||'Existing state of alert is not open so it cannot be closed OR the alert can not be transitioned to provided to be state for current state : '
                ||l_c_curr_state
                ||' ,';
                l_alert_out_tbl(i).status := 'ERROR';
                x_status                  := 'ERROR';
                GOTO next_record;
            END;
            --Update dn_case
            UPDATE
                   IRIDR_EDQCONFIG.dn_case
            SET    MODIFIED_DATE_TIME     = SYSDATE
                 , MODIFIED_BY            = l_n_user
                 , CURRENT_STATE          = l_alert_in_tbl(i).to_state
                 , STATE_CHANGE_BY        = l_n_user
                 , STATE_CHANGE_DATE_TIME = SYSDATE
            WHERE
                   EXTERNAL_ID = l_alert_in_tbl(i).alert_id
            ;
            
            -- Insert Case COMMENT
            BEGIN
                INSERT INTO IRIDR_EDQCONFIG.dn_casecomment VALUES
                       ( l_n_alert_id
                            , (
                                     select
                                            NEXT_ID
                                     from
                                            IRIDR_EDQCONFIG.DN_IDENTITY
                                     WHERE
                                            TABLE_NAME = 'dn_casecomment'
                              )
                            , 'Sentry'
                            , l_n_user
                            , sysdate
                            , (l_alert_in_tbl(i).comment
                                     || ' State Changed to '
                                     ||l_alert_in_tbl(i).to_state
                                     ||' by user '
                                     ||p_user
                                     ||' on '
                                     ||SYSDATE )
                            , 0
                            , NULL
                            , 1
                            , 0
                       )
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error while inserting in to IRIDR_EDQCONFIG.dn_casecomment for alert id '
                ||l_n_alert_id);
                l_alert_out_tbl(i).err_msg := l_alert_out_tbl(i).err_msg
                ||'Error while inserting in to IRIDR_EDQCONFIG.dn_casecomment for alert id '
                ||l_n_alert_id
                ||SQLERRM
                ||' ,';
                l_alert_out_tbl(i).status := 'ERROR';
                x_status                  := 'ERROR';
            END;
            -- Update the next sequence for case comment
            UPDATE
                   IRIDR_EDQCONFIG.DN_IDENTITY
            SET    NEXT_ID = NEXT_ID + BATCH_SIZE
            WHERE
                   TABLE_NAME = 'dn_casecomment'
            ;
            
            -- insert case history
            BEGIN
                INSERT INTO IRIDR_EDQCONFIG.dn_casehistory VALUES
                       (
                              /*                        (
                              select
                              NEXT_ID
                              from
                              IRIDR_EDQCONFIG.DN_IDENTITY
                              WHERE
                              TABLE_NAME = 'dn_casehistory'
                              ) */
                              XOWS.XXIRI_HISTORY_ID.NEXTVAL
                            , l_n_alert_id
                            , 'Sentry'
                            , l_n_user
                            , SYSDATE
                            , 'currentState'
                            , l_c_curr_state
                            , l_alert_in_tbl(i).to_state
                            , l_c_curr_state
                            , l_alert_in_tbl(i).to_state
                              -- , SUBSTR(l_c_curr_state,1,3)
                              --         ||' - Eliminate (Reviewer)'
                            , l_val_transition
                            , 1
                            , 0
                       )
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error while inserting in to IRIDR_EDQCONFIG.dn_casehistory for alert id '
                ||l_n_alert_id);
                l_alert_out_tbl(i).err_msg := l_alert_out_tbl(i).err_msg
                ||'Error while inserting in to IRIDR_EDQCONFIG.dn_casehistory for alert id '
                ||l_n_alert_id
                ||SQLERRM
                ||' ,';
                l_alert_out_tbl(i).status := 'ERROR';
                x_status                  := 'ERROR';
            END;
            -- Update the next sequence for case history
            UPDATE
                   IRIDR_EDQCONFIG.DN_IDENTITY
            SET    NEXT_ID = NEXT_ID + BATCH_SIZE
            WHERE
                   TABLE_NAME = 'dn_casehistory'
            ;
            
            BEGIN
                SELECT
                       'N'
                INTO
                       l_c_insert_case
                FROM
                       IRIDR_EDQCONFIG.dn_casehistory
                WHERE
                       case_id    = l_n_case_id
                       AND ROWNUM = 1
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                l_c_insert_case := 'Y';
            END;
            IF (l_c_insert_case = 'Y') THEN
                BEGIN
                    INSERT INTO IRIDR_EDQCONFIG.dn_casehistory VALUES
                           (
                                  /* (
                                  select
                                  NEXT_ID
                                  from
                                  IRIDR_EDQCONFIG.DN_IDENTITY
                                  WHERE
                                  TABLE_NAME = 'dn_casehistory'
                                  ) */
                                  XOWS.XXIRI_HISTORY_ID.NEXTVAL
                                , l_n_case_id
                                , 'Sentry'
                                , l_n_user
                                , SYSDATE
                                , 'derivedState'
                                , 'New'
                                , 'In Progress'
                                , 'New'
                                , 'In Progress'
                                , NULL
                                , 1
                                , 0
                           )
                    ;
                
                EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('Error while inserting in to IRIDR_EDQCONFIG.dn_casehistory for case id '
                    ||l_n_case_id);
                    l_alert_out_tbl(i).err_msg := l_alert_out_tbl(i).err_msg
                    ||'Error while inserting in to IRIDR_EDQCONFIG.dn_casehistory for case id '
                    ||l_n_case_id
                    ||SQLERRM
                    ||' ,';
                    l_alert_out_tbl(i).status := 'ERROR';
                    x_status                  := 'ERROR';
                END;
                -- Update the next sequence for case history
                /*                 UPDATE
                IRIDR_EDQCONFIG.DN_IDENTITY
                SET    NEXT_ID = NEXT_ID + BATCH_SIZE
                WHERE
                TABLE_NAME = 'dn_casehistory'
                ;
                */
            END IF;
            -- check if entry for case transition needs to be entered
            -- insert in to DN_CASETRANSITIONS
            BEGIN
                INSERT INTO IRIDR_EDQCONFIG.DN_CASETRANSITIONS VALUES
                       (
                       (
                              select
                                     NEXT_ID
                              from
                                     IRIDR_EDQCONFIG.DN_IDENTITY
                              WHERE
                                     TABLE_NAME = 'dn_casetransitions'
                       )
                     , 'Sentry'
                     , l_n_alert_id
                     , l_n_user
                     , SUBSTR(l_c_curr_state,1,3)
                              ||' - Eliminate (Reviewer)'
                     , l_c_curr_state
                     , l_alert_in_tbl(i).to_state
                     , SYSDATE
                     , 0
                     , 1
                     , 0
                       )
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error while inserting in to IRIDR_EDQCONFIG.DN_CASETRANSITIONS for alert id '
                ||l_n_alert_id);
                l_alert_out_tbl(i).err_msg := l_alert_out_tbl(i).err_msg
                ||'Error while inserting in to IRIDR_EDQCONFIG.DN_CASETRANSITIONS for alert id '
                ||l_n_alert_id
                ||SQLERRM
                ||' ,';
                l_alert_out_tbl(i).status := 'ERROR';
                x_status                  := 'ERROR';
            END;
            -- Update the next sequence for case transition
            UPDATE
                   IRIDR_EDQCONFIG.DN_IDENTITY
            SET    NEXT_ID = NEXT_ID + BATCH_SIZE
            WHERE
                   TABLE_NAME = 'dn_casetransitions'
            ;
            
            l_alert_out_tbl(i).key_label := l_c_key_label;    -- tsuazo 20190829
            l_alert_out_tbl(i).old_state := l_val_from_state; -- tsuazo 20190829
            l_alert_out_tbl(i).new_state := l_alert_in_tbl(i).to_state;
            -- Update the internal log table
            UPDATE
                   XOWS.XXIRI_ALERT_LOG
            SET    SCHEMA  = l_schema
                 , STATUS  = l_alert_out_tbl(i).status
                 , ERR_MSG = l_alert_out_tbl(i).err_msg
            WHERE
                   ALERT_ID     = l_alert_in_tbl(i).alert_id
                   AND LOG_TIME = l_d_sysdate
            ;
        
        END IF;
        IF (l_schema = 'IRIDR2_EDQCONFIG') THEN
            -- identify user
            BEGIN
                SELECT
                       ID
                INTO
                       l_n_user
                FROM
                       IRIDR2_EDQCONFIG.dn_usergraveyard
                WHERE
                       UPPER(USERNAME) = UPPER(l_c_system_user)
                       AND DELETED     = 0
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Watchlist User not found in IRIDR2_EDQCONFIG schema for : '
                ||l_c_system_user);
                l_alert_out_tbl(i).err_msg := l_alert_out_tbl(i).err_msg
                ||'Watchlist User not found in IRIDR2_EDQCONFIG schema for : '
                ||l_c_system_user
                ||' ,';
                l_alert_out_tbl(i).status := 'ERROR';
                x_status                  := 'ERROR';
                GOTO next_record;
            END;
            --Validate to - state
            BEGIN
                SELECT
                       FROM_STATE
                     , TO_STATE
                     , TRANSITION
                INTO
                       l_val_from_state
                     , l_val_to_state
                     , l_val_transition
                FROM
                       XOWS.XXIRI_ALERT_VALIDATION
                WHERE
                       TO_STATE = l_alert_in_tbl(i).to_state
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Transfer to state is not valid OR not found in state validation table : '
                ||l_alert_in_tbl(i).to_state);
                l_alert_out_tbl(i).err_msg := l_alert_out_tbl(i).err_msg
                ||'Transfer to state is not valid and not found in state validation table: '
                ||l_alert_in_tbl(i).to_state
                ||' ,';
                l_alert_out_tbl(i).status := 'ERROR';
                x_status                  := 'ERROR';
                GOTO next_record;
            END;
            -- Validate the existing from state
            BEGIN
                SELECT
                       'NOT_VALID_OPEN'
                INTO
                       l_val_curr_open
                FROM
                       DUAL
                WHERE
                       1                  =1
                       AND l_c_curr_state = l_val_from_state
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Existing state of alert is not open so it cannot be closed OR the alert can not be transitioned to provided to be state for current state : '
                ||l_c_curr_state);
                l_alert_out_tbl(i).err_msg := l_alert_out_tbl(i).err_msg
                ||'Existing state of alert is not open so it cannot be closed OR the alert can not be transitioned to provided to be state for current state : '
                ||l_c_curr_state
                ||' ,';
                l_alert_out_tbl(i).status := 'ERROR';
                x_status                  := 'ERROR';
                GOTO next_record;
            END;
            --Update dn_case
            UPDATE
                   IRIDR2_EDQCONFIG.dn_case
            SET    MODIFIED_DATE_TIME     = SYSDATE
                 , MODIFIED_BY            = l_n_user
                 , CURRENT_STATE          = l_alert_in_tbl(i).to_state
                 , STATE_CHANGE_BY        = l_n_user
                 , STATE_CHANGE_DATE_TIME = SYSDATE
            WHERE
                   EXTERNAL_ID = l_alert_in_tbl(i).alert_id
            ;
            
            -- Insert Case COMMENT
            BEGIN
                INSERT INTO IRIDR2_EDQCONFIG.dn_casecomment VALUES
                       ( l_n_alert_id
                            , (
                                     select
                                            NEXT_ID
                                     from
                                            IRIDR2_EDQCONFIG.DN_IDENTITY
                                     WHERE
                                            TABLE_NAME = 'dn_casecomment'
                              )
                            , 'Sentry'
                            , l_n_user
                            , sysdate
                            , (l_alert_in_tbl(i).comment
                                     || ' State Changed to '
                                     ||l_alert_in_tbl(i).to_state
                                     ||' by user '
                                     ||p_user
                                     ||' on '
                                     ||SYSDATE )
                            , 0
                            , NULL
                            , 1
                            , 0
                       )
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error while inserting in to IRIDR2_EDQCONFIG.dn_casecomment for alert id '
                ||l_n_alert_id);
                l_alert_out_tbl(i).err_msg := l_alert_out_tbl(i).err_msg
                ||'Error while inserting in to IRIDR2_EDQCONFIG.dn_casecomment for alert id '
                ||l_n_alert_id
                ||SQLERRM
                ||' ,';
                l_alert_out_tbl(i).status := 'ERROR';
                x_status                  := 'ERROR';
            END;
            -- Update the next sequence for case comment
            UPDATE
                   IRIDR2_EDQCONFIG.DN_IDENTITY
            SET    NEXT_ID = NEXT_ID + BATCH_SIZE
            WHERE
                   TABLE_NAME = 'dn_casecomment'
            ;
            
            -- insert case history
            BEGIN
                INSERT INTO IRIDR2_EDQCONFIG.dn_casehistory VALUES
                       (
                              /*                        (
                              select
                              NEXT_ID
                              from
                              IRIDR2_EDQCONFIG.DN_IDENTITY
                              WHERE
                              TABLE_NAME = 'dn_casehistory'
                              ) */
                              XOWS.XXIRI_HISTORY_ID.NEXTVAL
                            , l_n_alert_id
                            , 'Sentry'
                            , l_n_user
                            , SYSDATE
                            , 'currentState'
                            , l_c_curr_state
                            , l_alert_in_tbl(i).to_state
                            , l_c_curr_state
                            , l_alert_in_tbl(i).to_state
                              -- , SUBSTR(l_c_curr_state,1,3)
                              --         ||' - Eliminate (Reviewer)'
                            , l_val_transition
                            , 1
                            , 0
                       )
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error while inserting in to IRIDR2_EDQCONFIG.dn_casehistory for alert id '
                ||l_n_alert_id);
                l_alert_out_tbl(i).err_msg := l_alert_out_tbl(i).err_msg
                ||'Error while inserting in to IRIDR2_EDQCONFIG.dn_casehistory for alert id '
                ||l_n_alert_id
                ||SQLERRM
                ||' ,';
                l_alert_out_tbl(i).status := 'ERROR';
                x_status                  := 'ERROR';
            END;
            -- Update the next sequence for case history
            UPDATE
                   IRIDR2_EDQCONFIG.DN_IDENTITY
            SET    NEXT_ID = NEXT_ID + BATCH_SIZE
            WHERE
                   TABLE_NAME = 'dn_casehistory'
            ;
            
            BEGIN
                SELECT
                       'N'
                INTO
                       l_c_insert_case
                FROM
                       IRIDR2_EDQCONFIG.dn_casehistory
                WHERE
                       case_id    = l_n_case_id
                       AND ROWNUM = 1
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                l_c_insert_case := 'Y';
            END;
            IF (l_c_insert_case = 'Y') THEN
                BEGIN
                    INSERT INTO IRIDR2_EDQCONFIG.dn_casehistory VALUES
                           (
                                  /* (
                                  select
                                  NEXT_ID
                                  from
                                  IRIDR2_EDQCONFIG.DN_IDENTITY
                                  WHERE
                                  TABLE_NAME = 'dn_casehistory'
                                  ) */
                                  XOWS.XXIRI_HISTORY_ID.NEXTVAL
                                , l_n_case_id
                                , 'Sentry'
                                , l_n_user
                                , SYSDATE
                                , 'derivedState'
                                , 'New'
                                , 'In Progress'
                                , 'New'
                                , 'In Progress'
                                , NULL
                                , 1
                                , 0
                           )
                    ;
                
                EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('Error while inserting in to IRIDR2_EDQCONFIG.dn_casehistory for case id '
                    ||l_n_case_id);
                    l_alert_out_tbl(i).err_msg := l_alert_out_tbl(i).err_msg
                    ||'Error while inserting in to IRIDR2_EDQCONFIG.dn_casehistory for case id '
                    ||l_n_case_id
                    ||SQLERRM
                    ||' ,';
                    l_alert_out_tbl(i).status := 'ERROR';
                    x_status                  := 'ERROR';
                END;
                -- Update the next sequence for case history
                /*                 UPDATE
                IRIDR2_EDQCONFIG.DN_IDENTITY
                SET    NEXT_ID = NEXT_ID + BATCH_SIZE
                WHERE
                TABLE_NAME = 'dn_casehistory'
                ;
                */
            END IF;
            -- check if entry for case transition needs to be entered
            -- insert in to DN_CASETRANSITIONS
            BEGIN
                INSERT INTO IRIDR2_EDQCONFIG.DN_CASETRANSITIONS VALUES
                       (
                       (
                              select
                                     NEXT_ID
                              from
                                     IRIDR2_EDQCONFIG.DN_IDENTITY
                              WHERE
                                     TABLE_NAME = 'dn_casetransitions'
                       )
                     , 'Sentry'
                     , l_n_alert_id
                     , l_n_user
                     , SUBSTR(l_c_curr_state,1,3)
                              ||' - Eliminate (Reviewer)'
                     , l_c_curr_state
                     , l_alert_in_tbl(i).to_state
                     , SYSDATE
                     , 0
                     , 1
                     , 0
                       )
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error while inserting in to IRIDR2_EDQCONFIG.DN_CASETRANSITIONS for alert id '
                ||l_n_alert_id);
                l_alert_out_tbl(i).err_msg := l_alert_out_tbl(i).err_msg
                ||'Error while inserting in to IRIDR2_EDQCONFIG.DN_CASETRANSITIONS for alert id '
                ||l_n_alert_id
                ||SQLERRM
                ||' ,';
                l_alert_out_tbl(i).status := 'ERROR';
                x_status                  := 'ERROR';
            END;
            -- Update the next sequence for case transition
            UPDATE
                   IRIDR2_EDQCONFIG.DN_IDENTITY
            SET    NEXT_ID = NEXT_ID + BATCH_SIZE
            WHERE
                   TABLE_NAME = 'dn_casetransitions'
            ;
            
            l_alert_out_tbl(i).key_label := l_c_key_label;    -- tsuazo 20190829
            l_alert_out_tbl(i).old_state := l_val_from_state; -- tsuazo 20190829
            l_alert_out_tbl(i).new_state := l_alert_in_tbl(i).to_state;
            -- Update the internal log table
            UPDATE
                   XOWS.XXIRI_ALERT_LOG
            SET    SCHEMA  = l_schema
                 , STATUS  = l_alert_out_tbl(i).status
                 , ERR_MSG = l_alert_out_tbl(i).err_msg
            WHERE
                   ALERT_ID     = l_alert_in_tbl(i).alert_id
                   AND LOG_TIME = l_d_sysdate
            ;
        
        END IF;
        << next_record >> NULL;
        UPDATE
               XOWS.XXIRI_ALERT_LOG
        SET    SCHEMA  = l_schema
             , STATUS  = l_alert_out_tbl(i).status
             , ERR_MSG = l_alert_out_tbl(i).err_msg
        WHERE
               ALERT_ID     = l_alert_in_tbl(i).alert_id
               AND LOG_TIME = l_d_sysdate
        ;
    
    END LOOP;
    -- COMMIT;
    x_alert_out_tbl := l_alert_out_tbl;
EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('I am in exception of procedure update_alerts'
    ||SQLERRM);
    x_status := 'ERROR';
    ROLLBACk;
END update_alerts;
/********************************************************************************************************************
* Type                : Procedure                                                                                   *
* Name                : update_case                                                                                 *
* Purpose             : This is procedure to update the case status                                           *
*  INBOUND VARIABLES  :                            *
p_user         - This should be EDQ user which will update the case status              *
p_alert_close_override - If this flag is 'Y' then close all open alerts to false positive in case before closing case                                    *
p_case_in_tbl    - This should be input table type with case ID, to state and comment          *
*  OUTBOUND VARIABLES :                          *
x_case_out_tbl   - Output table type with case new state,status and err message         *
x_status          - Output variable with overall status with 3 possible values (SUCCESS, WARNING, ERROR)  *
*********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
* Date        By               Script               By            Date     Type  Details                            *
* ----------- ---------------- -------- --------- --------------- ----------- -----  ------------------------------ *
* 20-Oct-2019  Inspirage         1.1            Rajiv Rathod    20-Oct-2019   I  Inetial version           *
*                                                                                                                   *
/*******************************************************************************************************************/
PROCEDURE update_case
                     (
                         p_user                 VARCHAR2
                       , p_alert_close_override VARCHAR2
                       , p_case_in_tbl IN xxiri_cm_process_pkg.case_tbl_in_type
                       , x_case_out_tbl OUT xxiri_cm_process_pkg.case_tbl_out_type
                       , x_status OUT VARCHAR2
                     )
IS
    --Declaring variables
    l_case_in_tbl xxiri_cm_process_pkg.case_tbl_in_type := p_case_in_tbl;
    l_case_out_tbl xxiri_cm_process_pkg.case_tbl_out_type;
    -- local variables
    l_schema       VARCHAR2(100) := NULL;
    l_c_curr_state VARCHAR2(100) := NULL;
    l_c_key_label  VARCHAR2(500) := NULL;
    l_n_user       NUMBER        := NULL;
    --  l_n_case_id     NUMBER        := NULL;
    l_val_from_state  VARCHAR2(100) := NULL;
    l_val_to_state    VARCHAR2(100) := NULL;
    l_val_transition  VARCHAR2(100) := NULL;
    l_val_curr_open   VARCHAR2(100) := NULL;
    l_d_sysdate       DATE          := SYSDATE;
    l_n_case_id       NUMBER        := NULL;
    l_c_insert_case   VARCHAR2(100) := NULL;
    l_c_derived_state VARCHAR2(100) := NULL;
    p_alert_in_tbl xows.xxiri_cm_process_pkg.alert_tbl_in_type;
    x_alert_out_tbl xows.xxiri_cm_process_pkg.alert_tbl_out_type;
    x_alert_status  VARCHAR2(200);
    j               NUMBER        := 1;
    l_n_nonopen     NUMBER        := 0;
    l_c_system_user VARCHAR2(100) := 'WEBLOGIC';
BEGIN
    DBMS_OUTPUT.PUT_LINE('Start of procedure');
    -- Insert log for API call
    FOR j IN l_case_in_tbl.FIRST..l_case_in_tbl.LAST
    LOOP
        INSERT INTO XOWS.XXIRI_case_LOG VALUES
               (l_case_in_tbl(j).case_id
                    , l_case_in_tbl(j).to_state
                    , p_user
                    , l_d_sysdate
                    , NULL
                    , NULL
                    , NULL
               )
        ;
    
    END LOOP;
    x_status := 'SUCCESS';
    FOR i IN l_case_in_tbl.FIRST..l_case_in_tbl.LAST
    LOOP
        -- Initialising variables
        l_schema := NULL;
        l_n_user := NULL;
        --      l_n_case_id     := NULL;
        l_c_curr_state   := NULL;
        l_c_key_label    := NULL;
        l_val_from_state := NULL;
        l_val_to_state   := NULL;
        l_val_transition := NULL;
        l_val_curr_open  := NULL;
        l_n_case_id      := NULL;
        l_c_insert_case  := NULL;
        DBMS_OUTPUT.PUT_LINE('case ID is : '
        ||l_case_in_tbl(i).case_id
        ||' change to state : '
        ||l_case_in_tbl(i).to_state
        ||' and comments are : '
        ||l_case_in_tbl(i).comment);
        l_case_out_tbl(i).case_id := l_case_in_tbl(i).case_id;
        l_case_out_tbl(i).status  := 'SUCCESS';
        l_case_out_tbl(i).err_msg := NULL;
        l_c_derived_state         := NULL;
        p_alert_in_tbl.DELETE;
        x_alert_out_tbl.DELETE;
        x_alert_status := NULL;
        l_n_nonopen    := 0;
        -- Identify in which schema the record exist
        BEGIN
            SELECT
                   'IRIDR_EDQCONFIG'
                 , ID
                 , CURRENT_STATE
                   --       , PARENT_ID
                 , KEY_LABEL
            INTO
                   l_schema
                 , l_n_case_id
                 , l_c_curr_state
                   --        , l_n_case_id
                 , l_c_key_label
            FROM
                   iridr_edqconfig.dn_case
            WHERE
                   CASE_TYPE       = 'case'
                   AND EXTERNAL_ID = l_case_in_tbl(i).case_id
            ;
            
            l_case_out_tbl(i).case_id := l_case_in_tbl(i).case_id;
            DBMS_OUTPUT.PUT_LINE('case found in IRIDR_EDQCONFIG : '
            ||l_case_in_tbl(i).case_id);
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('case not found in IRIDR_EDQCONFIG : '
            ||l_case_in_tbl(i).case_id);
            --l_schema := NULL;
        END;
        BEGIN
            SELECT
                   'IRIDR2_EDQCONFIG'
                 , ID
                 , CURRENT_STATE
                   --, PARENT_ID
                 , KEY_LABEL
            INTO
                   l_schema
                 , l_n_case_id
                 , l_c_curr_state
                   -- , l_n_case_id
                 , l_c_key_label
            FROM
                   iridr2_edqconfig.dn_case
            WHERE
                   CASE_TYPE       = 'case'
                   AND EXTERNAL_ID = l_case_in_tbl(i).case_id
            ;
            
            l_case_out_tbl(i).case_id := l_case_in_tbl(i).case_id;
            DBMS_OUTPUT.PUT_LINE('case found in IRIDR2_EDQCONFIG : '
            ||l_case_in_tbl(i).case_id);
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('case not found in IRIDR2_EDQCONFIG : '
            ||l_case_in_tbl(i).case_id);
            --l_schema := NULL;
        END;
        IF l_schema IS NULL THEN
            l_case_out_tbl(i).case_id := l_case_in_tbl(i).case_id;
            l_case_out_tbl(i).status  := 'ERROR';
            x_status                  := 'ERROR';
            l_case_out_tbl(i).err_msg := l_case_in_tbl(i).case_id
            ||' : case Not Found in watchlist, ';
            GOTO next_record;
        END IF;
        IF (l_schema = 'IRIDR_EDQCONFIG') THEN
            -- identify user
            BEGIN
                SELECT
                       ID
                INTO
                       l_n_user
                FROM
                       IRIDR_EDQCONFIG.dn_usergraveyard
                WHERE
                       UPPER(USERNAME) = UPPER(l_c_system_user)
                       AND DELETED     = 0
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Watchlist User not found in IRIDR_EDQCONFIG schema for : '
                ||l_c_system_user);
                l_case_out_tbl(i).err_msg := l_case_out_tbl(i).err_msg
                ||'Watchlist User not found in IRIDR_EDQCONFIG schema for : '
                ||l_c_system_user
                ||' ,';
                l_case_out_tbl(i).status := 'ERROR';
                x_status                 := 'ERROR';
                GOTO next_record;
            END;
            --Validate to - state
            BEGIN
                SELECT
                       FROM_STATE
                     , TO_STATE
                     , TRANSITION
                INTO
                       l_val_from_state
                     , l_val_to_state
                     , l_val_transition
                FROM
                       XOWS.XXIRI_case_VALIDATION
                WHERE
                       TO_STATE = l_case_in_tbl(i).to_state
					   AND FROM_STATE = l_c_curr_state
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Transfer to state is not valid OR not found in state validation table : '
                ||l_case_in_tbl(i).to_state);
                l_case_out_tbl(i).err_msg := l_case_out_tbl(i).err_msg
                ||'Transfer to state is not valid and not found in state validation table: '
                ||l_case_in_tbl(i).to_state
                ||' ,';
                l_case_out_tbl(i).status := 'ERROR';
                x_status                 := 'ERROR';
                GOTO next_record;
            END;
            -- Validate the existing from state
            BEGIN
                SELECT
                       'NOT_VALID_OPEN'
                INTO
                       l_val_curr_open
                FROM
                       DUAL
                WHERE
                       1                  =1
                       AND l_c_curr_state = l_val_from_state
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Existing state of case is not open so it cannot be closed OR the case can not be transitioned to provided to be state for current state : '
                ||l_c_curr_state);
                l_case_out_tbl(i).err_msg := l_case_out_tbl(i).err_msg
                ||'Existing state of case is not open so it cannot be closed OR the case can not be transitioned to provided to be state for current state : '
                ||l_c_curr_state
                ||' ,';
                l_case_out_tbl(i).status := 'ERROR';
                x_status                 := 'ERROR';
                GOTO next_record;
            END;
            -- Logic to close open alerts before closing case
            l_c_derived_state := 'Complete';
            j                 := 1;
            -- Logic to find out any alert in different status other than open
            IF(p_alert_close_override <> 'Y'
                OR
                p_alert_close_override IS NULL) THEN
                BEGIN
                    SELECT
                           NVL(count(1), 0)
                    INTO
                           l_n_nonopen
                    FROM
                           IRIDR_EDQCONFIG.dn_case
                    WHERE
                           PARENT_ID                = l_n_case_id
                           AND CASE_TYPE            = 'issue'
                           AND CURRENT_STATE NOT LIKE '%False%'
                    ;
                    
                    IF ( l_n_nonopen = 0 ) THEN
                        l_c_derived_state := 'Complete';
                    ELSE
                        l_c_derived_state := 'In Progress';
                    END IF;
                EXCEPTION
                WHEN OTHERS THEN
                    NULL;
                END;
            END IF;
            IF(p_alert_close_override = 'Y') THEN
                l_c_derived_state := 'Complete';
                BEGIN
                    FOR k IN
                    (
                           SELECT
                                  EXTERNAL_ID
                                , CURRENT_STATE
                           FROM
                                  IRIDR_EDQCONFIG.dn_case
                           WHERE
                                  PARENT_ID     = l_n_case_id
                                  AND CASE_TYPE = 'issue'
                    )
                    LOOP
                        IF(k.CURRENT_STATE LIKE '%Open%') THEN
                            p_alert_in_tbl(j).alert_id := k.EXTERNAL_ID;
                            p_alert_in_tbl(j).to_state := SUBSTR(k.CURRENT_STATE,1,3)
                            || ' - False Positive';
                            p_alert_in_tbl(j).comment := 'Close Alert';
                        ELSE
                            l_c_derived_state := 'In Progress';
                        END IF;
                        j:= j+1;
                    END LOOP;
                    xows.xxiri_cm_process_pkg.update_alerts
                                                           (
                                                               p_user         => p_user
                                                             ,p_alert_in_tbl  => p_alert_in_tbl
                                                             ,x_alert_out_tbl => x_alert_out_tbl
                                                             ,x_status        => x_alert_status
                                                           );
                    IF(x_alert_status <> 'SUCCESS') THEN
                        DBMS_OUTPUT.PUT_LINE('Error while closing alerts for  '
                        ||l_n_case_id);
                        l_case_out_tbl(i).err_msg := l_case_out_tbl(i).err_msg
                        ||'Error while closing alerts for  '
                        ||l_n_case_id
                        ||SQLERRM
                        ||' ,';
                        l_case_out_tbl(i).status := 'WARNING';
                        x_status                 := 'WARNING';
                    END IF;
                EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('Error while closing alerts for  '
                    ||l_n_case_id);
                    l_case_out_tbl(i).err_msg := l_case_out_tbl(i).err_msg
                    ||'Error while closing alerts for  '
                    ||l_n_case_id
                    ||SQLERRM
                    ||' ,';
                    l_case_out_tbl(i).status := 'ERROR';
                    x_status                 := 'ERROR';
                END;
            END IF;
            --Update dn_case
            UPDATE
                   IRIDR_EDQCONFIG.dn_case
            SET    MODIFIED_DATE_TIME     = SYSDATE
                 , MODIFIED_BY            = l_n_user
                 , CURRENT_STATE          = l_case_in_tbl(i).to_state
                 , DERIVED_STATE          = l_c_derived_state
                 , STATE_CHANGE_BY        = l_n_user
                 , STATE_CHANGE_DATE_TIME = SYSDATE
            WHERE
                   EXTERNAL_ID = l_case_in_tbl(i).case_id
            ;
            
            -- Insert Case COMMENT
            BEGIN
                INSERT INTO IRIDR_EDQCONFIG.dn_casecomment VALUES
                       ( l_n_case_id
                            , (
                                     select
                                            NEXT_ID
                                     from
                                            IRIDR_EDQCONFIG.DN_IDENTITY
                                     WHERE
                                            TABLE_NAME = 'dn_casecomment'
                              )
                            , 'Sentry'
                            , l_n_user
                            , sysdate
                            , (l_case_in_tbl(i).comment
                                     || ' State Changed to '
                                     ||l_case_in_tbl(i).to_state
                                     ||' by user '
                                     ||p_user
                                     ||' on '
                                     ||SYSDATE )
                            , 0
                            , NULL
                            , 1
                            , 0
                       )
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error while inserting in to IRIDR_EDQCONFIG.dn_casecomment for case id '
                ||l_n_case_id);
                l_case_out_tbl(i).err_msg := l_case_out_tbl(i).err_msg
                ||'Error while inserting in to IRIDR_EDQCONFIG.dn_casecomment for case id '
                ||l_n_case_id
                ||SQLERRM
                ||' ,';
                l_case_out_tbl(i).status := 'ERROR';
                x_status                 := 'ERROR';
            END;
            -- Update the next sequence for case comment
            UPDATE
                   IRIDR_EDQCONFIG.DN_IDENTITY
            SET    NEXT_ID = NEXT_ID + BATCH_SIZE
            WHERE
                   TABLE_NAME = 'dn_casecomment'
            ;
            
            -- insert case history
            BEGIN
                INSERT INTO IRIDR_EDQCONFIG.dn_casehistory VALUES
                       (
                              /*                        (
                              select
                              NEXT_ID
                              from
                              IRIDR_EDQCONFIG.DN_IDENTITY
                              WHERE
                              TABLE_NAME = 'dn_casehistory'
                              ) */
                              XOWS.XXIRI_HISTORY_ID.NEXTVAL
                            , l_n_case_id
                            , 'Sentry'
                            , l_n_user
                            , SYSDATE
                            , 'currentState'
                            , l_c_curr_state
                            , l_case_in_tbl(i).to_state
                            , l_c_curr_state
                            , l_case_in_tbl(i).to_state
                              -- , SUBSTR(l_c_curr_state,1,3)
                              --         ||' - Eliminate (Reviewer)'
                            , l_val_transition
                            , 1
                            , 0
                       )
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error while inserting in to IRIDR_EDQCONFIG.dn_casehistory for case id '
                ||l_n_case_id);
                l_case_out_tbl(i).err_msg := l_case_out_tbl(i).err_msg
                ||'Error while inserting in to IRIDR_EDQCONFIG.dn_casehistory for case id '
                ||l_n_case_id
                ||SQLERRM
                ||' ,';
                l_case_out_tbl(i).status := 'ERROR';
                x_status                 := 'ERROR';
            END;
            -- Update the next sequence for case history
            UPDATE
                   IRIDR_EDQCONFIG.DN_IDENTITY
            SET    NEXT_ID = NEXT_ID + BATCH_SIZE
            WHERE
                   TABLE_NAME = 'dn_casehistory'
            ;
            
            IF (l_c_derived_state = 'Complete') THEN
                BEGIN
                    INSERT INTO IRIDR_EDQCONFIG.dn_casehistory VALUES
                           (
                                  /* (
                                  select
                                  NEXT_ID
                                  from
                                  IRIDR_EDQCONFIG.DN_IDENTITY
                                  WHERE
                                  TABLE_NAME = 'dn_casehistory'
                                  ) */
                                  XOWS.XXIRI_HISTORY_ID.NEXTVAL
                                , l_n_case_id
                                , 'Sentry'
                                , l_n_user
                                , SYSDATE
                                , 'derivedState'
                                , 'In Progress'
                                , 'Complete'
                                , 'In Progress'
                                , 'Complete'
                                , NULL
                                , 1
                                , 0
                           )
                    ;
                
                EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('Error while inserting in to IRIDR_EDQCONFIG.dn_casehistory for case id '
                    ||l_n_case_id);
                    l_case_out_tbl(i).err_msg := l_case_out_tbl(i).err_msg
                    ||'Error while inserting in to IRIDR_EDQCONFIG.dn_casehistory for case id '
                    ||l_n_case_id
                    ||SQLERRM
                    ||' ,';
                    l_case_out_tbl(i).status := 'ERROR';
                    x_status                 := 'ERROR';
                END;
                -- Update the next sequence for case history
                /*                 UPDATE
                IRIDR_EDQCONFIG.DN_IDENTITY
                SET    NEXT_ID = NEXT_ID + BATCH_SIZE
                WHERE
                TABLE_NAME = 'dn_casehistory'
                ;
                */
            END IF;
            -- check if entry for case transition needs to be entered
            -- insert in to DN_CASETRANSITIONS
            BEGIN
                INSERT INTO IRIDR_EDQCONFIG.DN_CASETRANSITIONS VALUES
                       (
                       (
                              select
                                     NEXT_ID
                              from
                                     IRIDR_EDQCONFIG.DN_IDENTITY
                              WHERE
                                     TABLE_NAME = 'dn_casetransitions'
                       )
                     , 'Sentry'
                     , l_n_case_id
                     , l_n_user
                     , 'toClosed'
                     , l_c_curr_state
                     , l_case_in_tbl(i).to_state
                     , SYSDATE
                     , 0
                     , 1
                     , 0
                       )
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error while inserting in to IRIDR_EDQCONFIG.DN_CASETRANSITIONS for case id '
                ||l_n_case_id);
                l_case_out_tbl(i).err_msg := l_case_out_tbl(i).err_msg
                ||'Error while inserting in to IRIDR_EDQCONFIG.DN_CASETRANSITIONS for case id '
                ||l_n_case_id
                ||SQLERRM
                ||' ,';
                l_case_out_tbl(i).status := 'ERROR';
                x_status                 := 'ERROR';
            END;
            -- Update the next sequence for case transition
            UPDATE
                   IRIDR_EDQCONFIG.DN_IDENTITY
            SET    NEXT_ID = NEXT_ID + BATCH_SIZE
            WHERE
                   TABLE_NAME = 'dn_casetransitions'
            ;
            
            l_case_out_tbl(i).key_label := l_c_key_label;
            l_case_out_tbl(i).old_state := l_val_from_state;
            l_case_out_tbl(i).new_state := l_case_in_tbl(i).to_state;
            -- Update the internal log table
            UPDATE
                   XOWS.XXIRI_case_LOG
            SET    SCHEMA  = l_schema
                 , STATUS  = l_case_out_tbl(i).status
                 , ERR_MSG = l_case_out_tbl(i).err_msg
            WHERE
                   case_ID      = l_case_in_tbl(i).case_id
                   AND LOG_TIME = l_d_sysdate
            ;
        
        END IF;
        IF (l_schema = 'IRIDR2_EDQCONFIG') THEN
            -- identify user
            BEGIN
                SELECT
                       ID
                INTO
                       l_n_user
                FROM
                       IRIDR2_EDQCONFIG.dn_usergraveyard
                WHERE
                       UPPER(USERNAME) = UPPER(l_c_system_user)
                       AND DELETED     = 0
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Watchlist User not found in IRIDR2_EDQCONFIG schema for : '
                ||l_c_system_user);
                l_case_out_tbl(i).err_msg := l_case_out_tbl(i).err_msg
                ||'Watchlist User not found in IRIDR2_EDQCONFIG schema for : '
                ||l_c_system_user
                ||' ,';
                l_case_out_tbl(i).status := 'ERROR';
                x_status                 := 'ERROR';
                GOTO next_record;
            END;
            --Validate to - state
            BEGIN
                SELECT
                       FROM_STATE
                     , TO_STATE
                     , TRANSITION
                INTO
                       l_val_from_state
                     , l_val_to_state
                     , l_val_transition
                FROM
                       XOWS.XXIRI_case_VALIDATION
                WHERE
                       TO_STATE = l_case_in_tbl(i).to_state
					   AND FROM_STATE = l_c_curr_state
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Transfer to state is not valid OR not found in state validation table : '
                ||l_case_in_tbl(i).to_state);
                l_case_out_tbl(i).err_msg := l_case_out_tbl(i).err_msg
                ||'Transfer to state is not valid and not found in state validation table: '
                ||l_case_in_tbl(i).to_state
                ||' ,';
                l_case_out_tbl(i).status := 'ERROR';
                x_status                 := 'ERROR';
                GOTO next_record;
            END;
            -- Validate the existing from state
            BEGIN
                SELECT
                       'NOT_VALID_OPEN'
                INTO
                       l_val_curr_open
                FROM
                       DUAL
                WHERE
                       1                  =1
                       AND l_c_curr_state = l_val_from_state
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Existing state of case is not open so it cannot be closed OR the case can not be transitioned to provided to be state for current state : '
                ||l_c_curr_state);
                l_case_out_tbl(i).err_msg := l_case_out_tbl(i).err_msg
                ||'Existing state of case is not open so it cannot be closed OR the case can not be transitioned to provided to be state for current state : '
                ||l_c_curr_state
                ||' ,';
                l_case_out_tbl(i).status := 'ERROR';
                x_status                 := 'ERROR';
                GOTO next_record;
            END;
            -- Logic to close open alerts before closing case
            l_c_derived_state := 'Complete';
            j                 := 1;
            -- Logic to find out any alert in different status other than open
            IF(p_alert_close_override <> 'Y'
                OR
                p_alert_close_override IS NULL) THEN
                BEGIN
                    SELECT
                           NVL(count(1), 0)
                    INTO
                           l_n_nonopen
                    FROM
                           IRIDR2_EDQCONFIG.dn_case
                    WHERE
                           PARENT_ID                = l_n_case_id
                           AND CASE_TYPE            = 'issue'
                           AND CURRENT_STATE NOT LIKE '%False%'
                    ;
                    
                    IF ( l_n_nonopen = 0 ) THEN
                        l_c_derived_state := 'Complete';
                    ELSE
                        l_c_derived_state := 'In Progress';
                    END IF;
                EXCEPTION
                WHEN OTHERS THEN
                    NULL;
                END;
            END IF;
            IF(p_alert_close_override = 'Y') THEN
                l_c_derived_state := 'Complete';
                BEGIN
                    FOR k IN
                    (
                           SELECT
                                  EXTERNAL_ID
                                , CURRENT_STATE
                           FROM
                                  IRIDR2_EDQCONFIG.dn_case
                           WHERE
                                  PARENT_ID     = l_n_case_id
                                  AND CASE_TYPE = 'issue'
                    )
                    LOOP
                        IF(k.CURRENT_STATE LIKE '%Open%') THEN
                            p_alert_in_tbl(j).alert_id := k.EXTERNAL_ID;
                            p_alert_in_tbl(j).to_state := SUBSTR(k.CURRENT_STATE,1,3)
                            || ' - False Positive';
                            p_alert_in_tbl(j).comment := 'Close Alert';
                        ELSE
                            l_c_derived_state := 'In Progress';
                        END IF;
                        j:= j+1;
                    END LOOP;
                    xows.xxiri_cm_process_pkg.update_alerts
                                                           (
                                                               p_user         => p_user
                                                             ,p_alert_in_tbl  => p_alert_in_tbl
                                                             ,x_alert_out_tbl => x_alert_out_tbl
                                                             ,x_status        => x_alert_status
                                                           );
                    IF(x_alert_status <> 'SUCCESS') THEN
                        DBMS_OUTPUT.PUT_LINE('Error while closing alerts for  '
                        ||l_n_case_id);
                        l_case_out_tbl(i).err_msg := l_case_out_tbl(i).err_msg
                        ||'Error while closing alerts for  '
                        ||l_n_case_id
                        ||SQLERRM
                        ||' ,';
                        l_case_out_tbl(i).status := 'WARNING';
                        x_status                 := 'WARNING';
                    END IF;
                EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('Error while closing alerts for  '
                    ||l_n_case_id);
                    l_case_out_tbl(i).err_msg := l_case_out_tbl(i).err_msg
                    ||'Error while closing alerts for  '
                    ||l_n_case_id
                    ||SQLERRM
                    ||' ,';
                    l_case_out_tbl(i).status := 'ERROR';
                    x_status                 := 'ERROR';
                END;
            END IF;
            --Update dn_case
            UPDATE
                   IRIDR2_EDQCONFIG.dn_case
            SET    MODIFIED_DATE_TIME     = SYSDATE
                 , MODIFIED_BY            = l_n_user
                 , CURRENT_STATE          = l_case_in_tbl(i).to_state
                 , DERIVED_STATE          = l_c_derived_state
                 , STATE_CHANGE_BY        = l_n_user
                 , STATE_CHANGE_DATE_TIME = SYSDATE
            WHERE
                   EXTERNAL_ID = l_case_in_tbl(i).case_id
            ;
            
            -- Insert Case COMMENT
            BEGIN
                INSERT INTO IRIDR2_EDQCONFIG.dn_casecomment VALUES
                       ( l_n_case_id
                            , (
                                     select
                                            NEXT_ID
                                     from
                                            IRIDR2_EDQCONFIG.DN_IDENTITY
                                     WHERE
                                            TABLE_NAME = 'dn_casecomment'
                              )
                            , 'Sentry'
                            , l_n_user
                            , sysdate
                            , (l_case_in_tbl(i).comment
                                     || ' State Changed to '
                                     ||l_case_in_tbl(i).to_state
                                     ||' by user '
                                     ||p_user
                                     ||' on '
                                     ||SYSDATE )
                            , 0
                            , NULL
                            , 1
                            , 0
                       )
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error while inserting in to IRIDR2_EDQCONFIG.dn_casecomment for case id '
                ||l_n_case_id);
                l_case_out_tbl(i).err_msg := l_case_out_tbl(i).err_msg
                ||'Error while inserting in to IRIDR2_EDQCONFIG.dn_casecomment for case id '
                ||l_n_case_id
                ||SQLERRM
                ||' ,';
                l_case_out_tbl(i).status := 'ERROR';
                x_status                 := 'ERROR';
            END;
            -- Update the next sequence for case comment
            UPDATE
                   IRIDR2_EDQCONFIG.DN_IDENTITY
            SET    NEXT_ID = NEXT_ID + BATCH_SIZE
            WHERE
                   TABLE_NAME = 'dn_casecomment'
            ;
            
            -- insert case history
            BEGIN
                INSERT INTO IRIDR2_EDQCONFIG.dn_casehistory VALUES
                       (
                              /*                        (
                              select
                              NEXT_ID
                              from
                              IRIDR2_EDQCONFIG.DN_IDENTITY
                              WHERE
                              TABLE_NAME = 'dn_casehistory'
                              ) */
                              XOWS.XXIRI_HISTORY_ID.NEXTVAL
                            , l_n_case_id
                            , 'Sentry'
                            , l_n_user
                            , SYSDATE
                            , 'currentState'
                            , l_c_curr_state
                            , l_case_in_tbl(i).to_state
                            , l_c_curr_state
                            , l_case_in_tbl(i).to_state
                              -- , SUBSTR(l_c_curr_state,1,3)
                              --         ||' - Eliminate (Reviewer)'
                            , l_val_transition
                            , 1
                            , 0
                       )
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error while inserting in to IRIDR2_EDQCONFIG.dn_casehistory for case id '
                ||l_n_case_id);
                l_case_out_tbl(i).err_msg := l_case_out_tbl(i).err_msg
                ||'Error while inserting in to IRIDR2_EDQCONFIG.dn_casehistory for case id '
                ||l_n_case_id
                ||SQLERRM
                ||' ,';
                l_case_out_tbl(i).status := 'ERROR';
                x_status                 := 'ERROR';
            END;
            -- Update the next sequence for case history
            UPDATE
                   IRIDR2_EDQCONFIG.DN_IDENTITY
            SET    NEXT_ID = NEXT_ID + BATCH_SIZE
            WHERE
                   TABLE_NAME = 'dn_casehistory'
            ;
            
            IF (l_c_derived_state = 'Complete') THEN
                BEGIN
                    INSERT INTO IRIDR2_EDQCONFIG.dn_casehistory VALUES
                           (
                                  /* (
                                  select
                                  NEXT_ID
                                  from
                                  IRIDR2_EDQCONFIG.DN_IDENTITY
                                  WHERE
                                  TABLE_NAME = 'dn_casehistory'
                                  ) */
                                  XOWS.XXIRI_HISTORY_ID.NEXTVAL
                                , l_n_case_id
                                , 'Sentry'
                                , l_n_user
                                , SYSDATE
                                , 'derivedState'
                                , 'In Progress'
                                , 'Complete'
                                , 'In Progress'
                                , 'Complete'
                                , NULL
                                , 1
                                , 0
                           )
                    ;
                
                EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('Error while inserting in to IRIDR2_EDQCONFIG.dn_casehistory for case id '
                    ||l_n_case_id);
                    l_case_out_tbl(i).err_msg := l_case_out_tbl(i).err_msg
                    ||'Error while inserting in to IRIDR2_EDQCONFIG.dn_casehistory for case id '
                    ||l_n_case_id
                    ||SQLERRM
                    ||' ,';
                    l_case_out_tbl(i).status := 'ERROR';
                    x_status                 := 'ERROR';
                END;
                -- Update the next sequence for case history
                /*                 UPDATE
                IRIDR2_EDQCONFIG.DN_IDENTITY
                SET    NEXT_ID = NEXT_ID + BATCH_SIZE
                WHERE
                TABLE_NAME = 'dn_casehistory'
                ;
                */
            END IF;
            -- check if entry for case transition needs to be entered
            -- insert in to DN_CASETRANSITIONS
            BEGIN
                INSERT INTO IRIDR2_EDQCONFIG.DN_CASETRANSITIONS VALUES
                       (
                       (
                              select
                                     NEXT_ID
                              from
                                     IRIDR2_EDQCONFIG.DN_IDENTITY
                              WHERE
                                     TABLE_NAME = 'dn_casetransitions'
                       )
                     , 'Sentry'
                     , l_n_case_id
                     , l_n_user
                     , 'toClosed'
                     , l_c_curr_state
                     , l_case_in_tbl(i).to_state
                     , SYSDATE
                     , 0
                     , 1
                     , 0
                       )
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error while inserting in to IRIDR2_EDQCONFIG.DN_CASETRANSITIONS for case id '
                ||l_n_case_id);
                l_case_out_tbl(i).err_msg := l_case_out_tbl(i).err_msg
                ||'Error while inserting in to IRIDR2_EDQCONFIG.DN_CASETRANSITIONS for case id '
                ||l_n_case_id
                ||SQLERRM
                ||' ,';
                l_case_out_tbl(i).status := 'ERROR';
                x_status                 := 'ERROR';
            END;
            -- Update the next sequence for case transition
            UPDATE
                   IRIDR2_EDQCONFIG.DN_IDENTITY
            SET    NEXT_ID = NEXT_ID + BATCH_SIZE
            WHERE
                   TABLE_NAME = 'dn_casetransitions'
            ;
            
            l_case_out_tbl(i).key_label := l_c_key_label;
            l_case_out_tbl(i).old_state := l_val_from_state;
            l_case_out_tbl(i).new_state := l_case_in_tbl(i).to_state;
            -- Update the internal log table
            UPDATE
                   XOWS.XXIRI_case_LOG
            SET    SCHEMA  = l_schema
                 , STATUS  = l_case_out_tbl(i).status
                 , ERR_MSG = l_case_out_tbl(i).err_msg
            WHERE
                   case_ID      = l_case_in_tbl(i).case_id
                   AND LOG_TIME = l_d_sysdate
            ;
        
        END IF;
        << next_record >> NULL;
        UPDATE
               XOWS.XXIRI_case_LOG
        SET    SCHEMA  = l_schema
             , STATUS  = l_case_out_tbl(i).status
             , ERR_MSG = l_case_out_tbl(i).err_msg
        WHERE
               case_ID      = l_case_in_tbl(i).case_id
               AND LOG_TIME = l_d_sysdate
        ;
    
    END LOOP;
    x_case_out_tbl := l_case_out_tbl;
EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('I am in exception of procedure update_cases'
    ||SQLERRM);
    x_status := 'ERROR';
    ROLLBACk;
END update_case;
END xxiri_cm_process_pkg;
/