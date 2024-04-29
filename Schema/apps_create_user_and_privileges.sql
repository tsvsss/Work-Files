/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: apps_create_user_and_privileges.sql 1.1 2019/11/15 12:00:00ET   IRI Exp                                $*/
/********************************************************************************************************************
* Object Type         : Script                                                                                      *
* Name                :                                         									                *
* Script Name         : apps_create_user_and_privileges.sql                                                         *
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
*                                                                                                                   *
********************************************************************************************************************/

SELECT
   *
FROM
   v$tablespace;

SELECT
   *
FROM
   database_properties
WHERE
   property_name LIKE 'DEFAULT%TABLESPACE';


CREATE USER xwrl IDENTIFIED BY xwrl;

ALTER USER xwrl
   DEFAULT TABLESPACE apps_ts_tx_data
   TEMPORARY TABLESPACE temp;

GRANT connect, resource TO xwrl;

GRANT
   CREATE SESSION
TO xwrl;

GRANT
   UNLIMITED TABLESPACE
TO xwrl;

grant MANAGE SCHEDULER to apps;
grant create job to apps;
grant  create any job to apps;
grant scheduler_admin to apps;


GRANT EXECUTE ON utl_http TO xwrl;
GRANT EXECUTE ON dbms_lock TO xwrl;