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
    l_n_user         NUMBER        := NULL;
    l_n_alert_id     NUMBER        := NULL;
    l_val_from_state VARCHAR2(100) := NULL;
    l_val_to_state   VARCHAR2(100) := NULL;
    l_val_transition VARCHAR2(100) := NULL;
    l_val_curr_open  VARCHAR2(100) := NULL;
    l_d_sysdate      DATE          := SYSDATE;
    l_n_case_id      NUMBER        := NULL;
    l_c_insert_case  VARCHAR2(100) := NULL;
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
                   'IRIP1_EDQCONFIG'
                 , ID
                 , CURRENT_STATE
                 , PARENT_ID
            INTO
                   l_schema
                 , l_n_alert_id
                 , l_c_curr_state
                 , l_n_case_id
            FROM
                   IRIP1_EDQCONFIG.dn_case
            WHERE
                   CASE_TYPE       = 'issue'
                   AND EXTERNAL_ID = l_alert_in_tbl(i).alert_id
            ;
            l_alert_out_tbl(i).alert_id  := l_alert_in_tbl(i).alert_id;
            DBMS_OUTPUT.PUT_LINE('Alert found in IRIP1_EDQCONFIG : '
            ||l_alert_in_tbl(i).alert_id);
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Alert not found in IRIP1_EDQCONFIG : '
            ||l_alert_in_tbl(i).alert_id);
            --l_schema := NULL;
        END;
        BEGIN
            SELECT
                   'IRIP2_EDQCONFIG'
                 , ID
                 , CURRENT_STATE
                 , PARENT_ID
            INTO
                   l_schema
                 , l_n_alert_id
                 , l_c_curr_state
                 , l_n_case_id
            FROM
                   IRIP2_EDQCONFIG.dn_case
            WHERE
                   CASE_TYPE       = 'issue'
                   AND EXTERNAL_ID = l_alert_in_tbl(i).alert_id
            ;
            l_alert_out_tbl(i).alert_id  := l_alert_in_tbl(i).alert_id;
            DBMS_OUTPUT.PUT_LINE('Alert found in IRIP2_EDQCONFIG : '
            ||l_alert_in_tbl(i).alert_id);
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Alert not found in IRIP2_EDQCONFIG : '
            ||l_alert_in_tbl(i).alert_id);
            --l_schema := NULL;
        END;
        IF l_schema IS NULL THEN
		    l_alert_out_tbl(i).alert_id  := l_alert_in_tbl(i).alert_id;
            l_alert_out_tbl(i).status  := 'ERROR';
            x_status                   := 'ERROR';
            l_alert_out_tbl(i).err_msg := l_alert_in_tbl(i).alert_id
            ||' : Alert Not Found in watchlist, ';
            GOTO next_record;
        END IF;
        IF (l_schema = 'IRIP1_EDQCONFIG') THEN
            -- identify user
            BEGIN
                SELECT
                       ID
                INTO
                       l_n_user
                FROM
                       IRIP1_EDQCONFIG.dn_usergraveyard
                WHERE
                       UPPER(USERNAME)    = UPPER(p_user)
                       AND DELETED = 0
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Watchlist User not found in IRIP1_EDQCONFIG schema for : '
                ||p_user);
                l_alert_out_tbl(i).err_msg := l_alert_out_tbl(i).err_msg
                ||'Watchlist User not found in IRIP1_EDQCONFIG schema for : '
                ||p_user
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
                   IRIP1_EDQCONFIG.dn_case
            SET    MODIFIED_DATE_TIME     = SYSDATE
                 , CURRENT_STATE          = l_alert_in_tbl(i).to_state
                 , STATE_CHANGE_BY        = l_n_user
                 , STATE_CHANGE_DATE_TIME = SYSDATE
            WHERE
                   EXTERNAL_ID = l_alert_in_tbl(i).alert_id
            ;
            
            -- Insert Case COMMENT
            BEGIN
                INSERT INTO IRIP1_EDQCONFIG.dn_casecomment VALUES
                       ( l_n_alert_id
                            , (
                                     select
                                            NEXT_ID
                                     from
                                            IRIP1_EDQCONFIG.DN_IDENTITY
                                     WHERE
                                            TABLE_NAME = 'dn_casecomment'
                              )
                            , 'Sentry'
                            , l_n_user
                            , sysdate
                            , NVL(l_alert_in_tbl(i).comment, 'State Changed to '
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
                DBMS_OUTPUT.PUT_LINE('Error while inserting in to IRIP1_EDQCONFIG.dn_casecomment for alert id '
                ||l_n_alert_id);
                l_alert_out_tbl(i).err_msg := l_alert_out_tbl(i).err_msg
                ||'Error while inserting in to IRIP1_EDQCONFIG.dn_casecomment for alert id '
                ||l_n_alert_id
                ||SQLERRM
                ||' ,';
                l_alert_out_tbl(i).status := 'ERROR';
                x_status                  := 'ERROR';
            END;
            -- Update the next sequence for case comment
            UPDATE
                   IRIP1_EDQCONFIG.DN_IDENTITY
            SET    NEXT_ID = NEXT_ID + BATCH_SIZE
            WHERE
                   TABLE_NAME = 'dn_casecomment'
            ;
            
            -- insert case history
            BEGIN
                INSERT INTO IRIP1_EDQCONFIG.dn_casehistory VALUES
                       (
                              /*                        (
                              select
                              NEXT_ID
                              from
                              IRIP1_EDQCONFIG.DN_IDENTITY
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
                DBMS_OUTPUT.PUT_LINE('Error while inserting in to IRIP1_EDQCONFIG.dn_casehistory for alert id '
                ||l_n_alert_id);
                l_alert_out_tbl(i).err_msg := l_alert_out_tbl(i).err_msg
                ||'Error while inserting in to IRIP1_EDQCONFIG.dn_casehistory for alert id '
                ||l_n_alert_id
                ||SQLERRM
                ||' ,';
                l_alert_out_tbl(i).status := 'ERROR';
                x_status                  := 'ERROR';
            END;
            -- Update the next sequence for case history
            UPDATE
                   IRIP1_EDQCONFIG.DN_IDENTITY
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
                       IRIP1_EDQCONFIG.dn_casehistory
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
                    INSERT INTO IRIP1_EDQCONFIG.dn_casehistory VALUES
                           (
                                  /* (
                                  select
                                  NEXT_ID
                                  from
                                  IRIP1_EDQCONFIG.DN_IDENTITY
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
                    DBMS_OUTPUT.PUT_LINE('Error while inserting in to IRIP1_EDQCONFIG.dn_casehistory for case id '
                    ||l_n_case_id);
                    l_alert_out_tbl(i).err_msg := l_alert_out_tbl(i).err_msg
                    ||'Error while inserting in to IRIP1_EDQCONFIG.dn_casehistory for case id '
                    ||l_n_case_id
                    ||SQLERRM
                    ||' ,';
                    l_alert_out_tbl(i).status := 'ERROR';
                    x_status                  := 'ERROR';
                END;
                -- Update the next sequence for case history
                /*                 UPDATE
                IRIP1_EDQCONFIG.DN_IDENTITY
                SET    NEXT_ID = NEXT_ID + BATCH_SIZE
                WHERE
                TABLE_NAME = 'dn_casehistory'
                ;
                */
            END IF;
            -- check if entry for case transition needs to be entered
            -- insert in to DN_CASETRANSITIONS
            BEGIN
                INSERT INTO IRIP1_EDQCONFIG.DN_CASETRANSITIONS VALUES
                       (
                       (
                              select
                                     NEXT_ID
                              from
                                     IRIP1_EDQCONFIG.DN_IDENTITY
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
                DBMS_OUTPUT.PUT_LINE('Error while inserting in to IRIP1_EDQCONFIG.DN_CASETRANSITIONS for alert id '
                ||l_n_alert_id);
                l_alert_out_tbl(i).err_msg := l_alert_out_tbl(i).err_msg
                ||'Error while inserting in to IRIP1_EDQCONFIG.DN_CASETRANSITIONS for alert id '
                ||l_n_alert_id
                ||SQLERRM
                ||' ,';
                l_alert_out_tbl(i).status := 'ERROR';
                x_status                  := 'ERROR';
            END;
            -- Update the next sequence for case transition
            UPDATE
                   IRIP1_EDQCONFIG.DN_IDENTITY
            SET    NEXT_ID = NEXT_ID + BATCH_SIZE
            WHERE
                   TABLE_NAME = 'dn_casetransitions'
            ;
            
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
        IF (l_schema = 'IRIP2_EDQCONFIG') THEN
            -- identify user
            BEGIN
                SELECT
                       ID
                INTO
                       l_n_user
                FROM
                       IRIP2_EDQCONFIG.dn_usergraveyard
                WHERE
                       UPPER(USERNAME)    = UPPER(p_user)
                       AND DELETED = 0
                ;
            
            EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Watchlist User not found in IRIP2_EDQCONFIG schema for : '
                ||p_user);
                l_alert_out_tbl(i).err_msg := l_alert_out_tbl(i).err_msg
                ||'Watchlist User not found in IRIP2_EDQCONFIG schema for : '
                ||p_user
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
                   IRIP2_EDQCONFIG.dn_case
            SET    MODIFIED_DATE_TIME     = SYSDATE
                 , CURRENT_STATE          = l_alert_in_tbl(i).to_state
                 , STATE_CHANGE_BY        = l_n_user
                 , STATE_CHANGE_DATE_TIME = SYSDATE
            WHERE
                   EXTERNAL_ID = l_alert_in_tbl(i).alert_id
            ;
            
            -- Insert Case COMMENT
            BEGIN
                INSERT INTO IRIP2_EDQCONFIG.dn_casecomment VALUES
                       ( l_n_alert_id
                            , (
                                     select
                                            NEXT_ID
                                     from
                                            IRIP2_EDQCONFIG.DN_IDENTITY
                                     WHERE
                                            TABLE_NAME = 'dn_casecomment'
                              )
                            , 'Sentry'
                            , l_n_user
                            , sysdate
                            , NVL(l_alert_in_tbl(i).comment, 'State Changed to '
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
                DBMS_OUTPUT.PUT_LINE('Error while inserting in to IRIP2_EDQCONFIG.dn_casecomment for alert id '
                ||l_n_alert_id);
                l_alert_out_tbl(i).err_msg := l_alert_out_tbl(i).err_msg
                ||'Error while inserting in to IRIP2_EDQCONFIG.dn_casecomment for alert id '
                ||l_n_alert_id
                ||SQLERRM
                ||' ,';
                l_alert_out_tbl(i).status := 'ERROR';
                x_status                  := 'ERROR';
            END;
            -- Update the next sequence for case comment
            UPDATE
                   IRIP2_EDQCONFIG.DN_IDENTITY
            SET    NEXT_ID = NEXT_ID + BATCH_SIZE
            WHERE
                   TABLE_NAME = 'dn_casecomment'
            ;
            
            -- insert case history
            BEGIN
                INSERT INTO IRIP2_EDQCONFIG.dn_casehistory VALUES
                       (
                              /*                        (
                              select
                              NEXT_ID
                              from
                              IRIP2_EDQCONFIG.DN_IDENTITY
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
                DBMS_OUTPUT.PUT_LINE('Error while inserting in to IRIP2_EDQCONFIG.dn_casehistory for alert id '
                ||l_n_alert_id);
                l_alert_out_tbl(i).err_msg := l_alert_out_tbl(i).err_msg
                ||'Error while inserting in to IRIP2_EDQCONFIG.dn_casehistory for alert id '
                ||l_n_alert_id
                ||SQLERRM
                ||' ,';
                l_alert_out_tbl(i).status := 'ERROR';
                x_status                  := 'ERROR';
            END;
            -- Update the next sequence for case history
            UPDATE
                   IRIP2_EDQCONFIG.DN_IDENTITY
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
                       IRIP2_EDQCONFIG.dn_casehistory
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
                    INSERT INTO IRIP2_EDQCONFIG.dn_casehistory VALUES
                           (
                                  /* (
                                  select
                                  NEXT_ID
                                  from
                                  IRIP2_EDQCONFIG.DN_IDENTITY
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
                    DBMS_OUTPUT.PUT_LINE('Error while inserting in to IRIP2_EDQCONFIG.dn_casehistory for case id '
                    ||l_n_case_id);
                    l_alert_out_tbl(i).err_msg := l_alert_out_tbl(i).err_msg
                    ||'Error while inserting in to IRIP2_EDQCONFIG.dn_casehistory for case id '
                    ||l_n_case_id
                    ||SQLERRM
                    ||' ,';
                    l_alert_out_tbl(i).status := 'ERROR';
                    x_status                  := 'ERROR';
                END;
                -- Update the next sequence for case history
                /*                 UPDATE
                IRIP2_EDQCONFIG.DN_IDENTITY
                SET    NEXT_ID = NEXT_ID + BATCH_SIZE
                WHERE
                TABLE_NAME = 'dn_casehistory'
                ;
                */
            END IF;
            -- check if entry for case transition needs to be entered
            -- insert in to DN_CASETRANSITIONS
            BEGIN
                INSERT INTO IRIP2_EDQCONFIG.DN_CASETRANSITIONS VALUES
                       (
                       (
                              select
                                     NEXT_ID
                              from
                                     IRIP2_EDQCONFIG.DN_IDENTITY
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
                DBMS_OUTPUT.PUT_LINE('Error while inserting in to IRIP2_EDQCONFIG.DN_CASETRANSITIONS for alert id '
                ||l_n_alert_id);
                l_alert_out_tbl(i).err_msg := l_alert_out_tbl(i).err_msg
                ||'Error while inserting in to IRIP2_EDQCONFIG.DN_CASETRANSITIONS for alert id '
                ||l_n_alert_id
                ||SQLERRM
                ||' ,';
                l_alert_out_tbl(i).status := 'ERROR';
                x_status                  := 'ERROR';
            END;
            -- Update the next sequence for case transition
            UPDATE
                   IRIP2_EDQCONFIG.DN_IDENTITY
            SET    NEXT_ID = NEXT_ID + BATCH_SIZE
            WHERE
                   TABLE_NAME = 'dn_casetransitions'
            ;
            
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
END xxiri_cm_process_pkg;
/