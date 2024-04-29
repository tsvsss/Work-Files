/********************************************************************************************************************
* Oracle : EDQ                                                                                         *
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: XOWS_GRANTS.sql 1.1 2019/03/18 12:00:00CST   rrathod (Inspirage) Exp         $*/
/********************************************************************************************************************
* Type                : Grants                                                                                     *
* Name                : XOWS                                                                              *
* Script Name         : XOWS_GRANTS.sql                                                                                 *
* Purpose             : This script is used to create the user for integration with EDQ                           *
*                                                                                                                   *
* Company             : Inspirage LLC                                                                               *
* Client              : IRI                                                                                     *
* Created By          : Rajiv Rathod                                                                                *
* Created Date        : 07-JUL-2019                                                                                 *
* Last Reviewed By    : Rajiv Rathod                                                                                *
* Last Reviewed Date  : 07-JUL-2019                                                                                 *
*********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
* Date        By               Script               By            Date     Type  Details                            *
* ----------- ---------------- -------- --------- --------------- ----------- -----  ------------------------------ *
* 07-JUL-2019  Inspirage         1.1            Rajiv Rathod    07-JUL-2019   I  Created for integration with EDQ  *
*                                                                                                                   *
********************************************************************************************************************/
GRANT ALL ON IRIP1_EDQCONFIG.dn_case to XOWS;
GRANT ALL ON IRIP2_EDQCONFIG.dn_case to XOWS;
GRANT ALL ON IRIP1_EDQCONFIG.dn_casecomment to XOWS;
GRANT ALL ON IRIP2_EDQCONFIG.dn_casecomment to XOWS;
GRANT ALL ON IRIP1_EDQCONFIG.dn_usergraveyard to XOWS;
GRANT ALL ON IRIP2_EDQCONFIG.dn_usergraveyard to XOWS;
GRANT ALL ON IRIP1_EDQCONFIG.DN_IDENTITY to XOWS;
GRANT ALL ON IRIP2_EDQCONFIG.DN_IDENTITY to XOWS;
GRANT ALL ON IRIP1_EDQCONFIG.dn_casehistory to XOWS;
GRANT ALL ON IRIP2_EDQCONFIG.dn_casehistory to XOWS;
GRANT ALL ON IRIP1_EDQCONFIG.DN_CASETRANSITIONS to XOWS;
GRANT ALL ON IRIP2_EDQCONFIG.DN_CASETRANSITIONS to XOWS;