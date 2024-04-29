/********************************************************************************************************************
* Legend : Type                                                                                                     * 
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: grant_script.sql 1.1 2019/11/15 12:00:00ET   IRI Exp                                                   $*/
/********************************************************************************************************************
* Object Type         : Script                                                                                      *
* Name                :                                                                                             *
* Script Name         : grant_script.sql                                                                            *
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
* 15-NOV-2019 IRI              1.2                TSUAZO          15-NOV-2019  I      Trade Compliance              *
*                                                                                                                   *
********************************************************************************************************************/

GRANT ALL ON APPS.RMI_OWS_COMMON_UTIL to XWRL
/

GRANT ALL ON APPS.MT_LOG_ERROR TO XWRL
/

GRANT ALL ON APPS.WORLD_CHECK_IFACE TO XWRL
/

GRANT ALL ON apps.fnd_lookup_values_vl TO XWRL
/

GRANT ALL ON apps.fnd_user TO XWRL
/

GRANT ALL ON IRI_SECURITY TO XWRL
/

GRANT ALL ON SICD.SICD_COUNTRIES TO XWRL
/

GRANT ALL ON VSSL.WC_CITY_LIST TO XWRL
/

grant all on apps.xwrl_utils to xwrl
/