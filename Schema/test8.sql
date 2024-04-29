
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "APPS"."XWRL_DATA_UTILS" AS

/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_create_xwrl_utils.pks 1.1 2019/11/15 12:00:00ET   IRI Exp                                         $*/
/********************************************************************************************************************
* Object Type         : Package Specification                                                                       *
* Name                : xwrl_data_utils                                                                                  *
* Script Name         : apps_create_xwrl_data_utils.pkb                                                                  *
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
* 16-NOV-2019 IRI              1.2                TSUAZO          15-NOV-2019  I      Add    create_audit_record          *
*                                                                                                                   *
********************************************************************************************************************/


      procedure create_trigger_logic (p_table_name in varchar2, p_column_id in varchar2, p_action in varchar2 default null) IS

      cursor c1 is
      select column_name
      from all_tab_columns
      where table_name = p_table_name
      and data_type not in ('XMLTYPE')
      and column_name not in ('SOAP_QUERY');

      x_result varchar2(4000);

      begin

      for c1rec in c1 loop

      xwrl_data_utils.create_audit_record(p_table_name,  c1rec.column_name , p_column_id,  p_action,  x_result);

      --dbms_output.put_line('x_result: '||x_result);

      insert into tmp_sql (v_sql) values (x_result);

      end loop;

      commit;

      end create_trigger_logic;


      procedure create_audit_record (p_table_name IN varchar2, p_table_column IN varchar2, p_column in varchar2, p_action in varchar2  default null,  p_result OUT varchar2)  is

      cursor c1 is
      select column_name
      from all_tab_columns
      where table_name = p_table_name
      and column_name = nvl(p_table_column,column_name)
      and data_type not in ('XMLTYPE')
      ;

      cursor c2 (p_table_column varchar2) is
      select 'IF NVL(TO_CHAR(:OLD.'||column_name||'),'||CHR(39)||'X'||CHR(39)||') <> NVL(TO_CHAR(:NEW.'||column_name||'),'||CHR(39)||'X'||CHR(39)||')  THEN ' stmt
      -- select 'if :old.'||column_name||' <> :NEW.'||column_name||' then ' stmt
      from all_tab_columns
      where table_name = p_table_name
      and column_name = p_table_column;

       cursor c3 (p_table_column varchar2) is
      select 'v_rec.OLD_VALUE := :OLD.'||column_name stmt
      from all_tab_columns
      where table_name = p_table_name
      and column_name = p_table_column;

       cursor c4 (p_table_column varchar2) is
      select 'v_rec.NEW_VALUE := :NEW.'||column_name stmt
      from all_tab_columns
      where table_name = p_table_name
      and column_name = p_table_column;      

      v_sql varchar2(4000);
      v_result varchar2(4000);

      v_column varchar2(4000);
      v_count integer;

      begin

      v_count := 0;
      v_result := null;

   for c1rec in c1 loop

      --v_result := v_result||'DECLARE'||chr(13);   
      --v_result := v_result||'v_rec XWRL_AUDIT_LOG%rowtype'||chr(59)||chr(13);
      v_result := v_result||'BEGIN'||chr(13);


      for c2rec in c2 (c1rec.column_name) loop

         v_result := v_result||c2rec.stmt||chr(13);

      end loop;
/*
      IF p_action = 'DELETE' THEN
            v_result := v_result||'v_rec.TABLE_ID := :OLD.'||p_column||chr(59)||chr(13);
      ELSE
            v_result := v_result||'v_rec.TABLE_ID := :NEW.'||p_column||chr(59)||chr(13);
      END IF;
      */
      --v_result := v_result||'v_rec.TABLE_ID := DECODE(p_row_action,'||chr(39)||'DELETE'||CHR(39)||','||':OLD.'||p_column||','||':NEW.'||p_column||')'||chr(59)||chr(13);

      v_result := v_result||'IF p_row_action = '||chr(39)||'DELETE'||chr(39)||' THEN '||chr(13);
      v_result := v_result||'v_rec.TABLE_ID := :OLD.'||p_column||chr(59)||chr(13);
      v_result := v_result||'ELSE'||chr(13);
       v_result := v_result||'v_rec.TABLE_ID := :NEW.'||p_column||chr(59)||chr(13);
      v_result := v_result||'END IF' ||chr(59)||chr(13);
      v_result := v_result||'v_rec.TABLE_NAME := '||chr(39)||p_table_name||chr(39)||chr(59)||chr(13);
      v_result := v_result||'v_rec.TABLE_COLUMN := '||chr(39)||p_table_column||chr(39)||chr(59)||chr(13);   
     -- v_result := v_result||'v_rec.ROW_ACTION := '||chr(39)||p_action||chr(39)||chr(59)||chr(13);  
       v_result := v_result||'v_rec.ROW_ACTION :=  p_row_action'||chr(59)||chr(13);  

      for c3rec in c3 (c1rec.column_name) loop

         v_result := v_result||c3rec.stmt||chr(59)||chr(13);

      end loop;

      for c4rec in c4 (c1rec.column_name) loop

         v_result := v_result||c4rec.stmt||chr(59)||chr(13);

      end loop;

   end loop;

      v_result := v_result||'INSERT INTO XWRL_AUDIT_LOG values v_rec'||chr(59)||chr(13);
       v_result := v_result||'END IF'||chr(59)||chr(13);  
       v_result := v_result||'END'||chr(59)||chr(13);  

      p_result := v_result;

      end create_audit_record;

   END xwrl_data_utils;

/