/********************************************************************************************************************
* Oracle : EDQ                                                                                         *
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: XOWS_SEQUENCE.sql 1.1 2019/03/18 12:00:00CST   rrathod (Inspirage) Exp         $*/
/********************************************************************************************************************
* Type                : Grants                                                                                     *
* Name                : XOWS_SEQUENCE                                                                              *
* Script Name         : XOWS_SEQUENCE.sql                                                                                 *
* Purpose             : This script is used to create the sequence for integration with EDQ                           *
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
CREATE SEQUENCE XOWS.XXIRI_HISTORY_ID
  MINVALUE 999999999
  MAXVALUE 999999999999999999999999999
  START WITH 999999999
  INCREMENT BY 1
  CACHE 20;