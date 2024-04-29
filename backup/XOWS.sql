/********************************************************************************************************************
* Oracle Applications : R12                                                                                         *
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: XOWS.sql 1.1 2019/03/18 12:00:00CST   rrathod (Inspirage) Exp  					  $*/
/********************************************************************************************************************
* Type                : User creation                                                                               *
* Name                : XOWS		                                                                            *
* Script Name         : XOWS.sql                                                                                 *
* Purpose             : This script is used to create the user for integration with EDQ                           *
*                                                                                                                   *
* Company             : Inspirage LLC                                                                               *
* Client              : IRI	                                                                                    *
* Created By          : Rajiv Rathod                                                                                *
* Created Date        : 07-JUL-2019                                                                                 *
* Last Reviewed By    : Rajiv Rathod                                                                                *
* Last Reviewed Date  : 07-JUL-2019                                                                                 *
*********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
* Date        By               Script               By            Date     Type  Details                            *
* ----------- ---------------- -------- --------- --------------- ----------- -----  ------------------------------ *
* 07-JUL-2019  Inspirage         1.1          	 Rajiv Rathod    07-JUL-2019   I  Created for integration with EDQ  *
*                                                                                                                   *
********************************************************************************************************************/
CREATE USER XOWS IDENTIFIED BY Welcome2IRI;
ALTER USER XOWS QUOTA UNLIMITED ON USERS;
GRANT UNLIMITED TABLESPACE TO XOWS;
GRANT CONNECT TO XOWS;
GRANT CREATE SESSION TO XOWS;
GRANT CREATE TABLE TO XOWS;
GRANT CREATE VIEW TO XOWS;
GRANT CREATE ANY TRIGGER TO XOWS;
GRANT CREATE ANY PROCEDURE TO XOWS;
GRANT CREATE SEQUENCE TO XOWS;
GRANT CREATE SYNONYM TO XOWS;