/********************************************************************************************************************
* Oracle : EDQ                                                                                         *
* I --> Initial                                                                                                     *
* E --> Enhancement                                                                                                 *
* R --> Requirement                                                                                                 *
* B --> Bug                                                                                                         *
********************************************************************************************************************/
/*$Header: XOWS_TABLE.sql 1.1 2019/08/10 12:00:00CST   rrathod (Inspirage) Exp        $*/
/********************************************************************************************************************
* Type                : Grants                                                                                     *
* Name                : XOWS_TABLE                                                                              *
* Script Name         : XOWS_TABLE.sql                                                                                    *
* Purpose             : This script is used to create Tables for integration with EDQ                               *
*                                                                                                                   *
* Company             : Inspirage LLC                                                                               *
* Client              : IRI                                                                                     *
* Created By          : Rajiv Rathod                                                                                *
* Created Date        : 07-AUG-2019                                                                                 *
* Last Reviewed By    : Rajiv Rathod                                                                                *
* Last Reviewed Date  : 07-AUG-2019                                                                                 *
*********************************************************************************************************************
* <------- ---Modified ---------> <---- Version ----> <--------- Reviewed --------> <--------- Modification ------->*
* Date        By               Script               By            Date     Type  Details                            *
* ----------- ---------------- -------- --------- --------------- ----------- -----  ------------------------------ *
* 07-AUG-2019  Inspirage         1.1            Rajiv Rathod    07-AUG-2019   I  Created for integration with EDQ  *
*                                                                                                                   *
********************************************************************************************************************/
/********************************************************************************************************************
* Type                : TABLE                                                                                     *
* Name                : XXIRI_ALERT_LOG                                                                		      *
* Purpose             : This is table for capturing log for Alert API call                       						  *
/*******************************************************************************************************************/
DROP TABLE XOWS.XXIRI_ALERT_LOG;
CREATE TABLE XOWS.XXIRI_ALERT_LOG
             (
                          ALERT_ID  VARCHAR2(100)
                        , NEW_STATE VARCHAR2(100)
                        , EDQ_USER  VARCHAR2(100)
                        , LOG_TIME  DATE
                        , SCHEMA    VARCHAR2(100)
                        , STATUS    VARCHAR2(100)
                        , ERR_MSG   VARCHAR2(1000)
             )
;

CREATE INDEX XOWS.XXIRI_ALERT_LOG_N1
ON
             XOWS.XXIRI_ALERT_LOG
             (
                          ALERT_ID
             )
;

/********************************************************************************************************************
* Type                : TABLE                                                                                     *
* Name                : XXIRI_ALERT_VALIDATION                                                                    *
* Purpose             : This is table for validation of state in EDQ wtachlist                       			  *
/*******************************************************************************************************************/
DROP TABLE XOWS.XXIRI_ALERT_VALIDATION;
CREATE TABLE XOWS.XXIRI_ALERT_VALIDATION
             (
                          FROM_STATE VARCHAR2(100)
                        , TO_STATE   VARCHAR2(100)
                        , TRANSITION VARCHAR2(100)
             )
;

insert into XOWS.XXIRI_ALERT_VALIDATION VALUES
('PEP - Open', 'PEP - False Positive', 'PEP - Eliminate (Reviewer)');

insert into XOWS.XXIRI_ALERT_VALIDATION VALUES
('EDD - Open', 'EDD - False Positive', 'EDD - Eliminate (Reviewer)');

insert into XOWS.XXIRI_ALERT_VALIDATION VALUES
('SAN - Open', 'SAN - False Positive', 'SAN - Eliminate (Reviewer)');
COMMIT;

/********************************************************************************************************************
* Type                : TABLE                                                                                     *
* Name                : XXIRI_CASE_LOG                                                                		      *
* Purpose             : This is table for capturing log for CASE API call                  			  *
/*******************************************************************************************************************/
DROP TABLE XOWS.XXIRI_CASE_LOG;
CREATE TABLE XOWS.XXIRI_CASE_LOG
             (
                          CASE_ID  VARCHAR2(100)
                        , NEW_STATE VARCHAR2(100)
                        , EDQ_USER  VARCHAR2(100)
                        , LOG_TIME  DATE
                        , SCHEMA    VARCHAR2(100)
                        , STATUS    VARCHAR2(100)
                        , ERR_MSG   VARCHAR2(1000)
             )
;

CREATE INDEX XOWS.XXIRI_CASE_LOG_N1
ON
             XOWS.XXIRI_CASE_LOG
             (
                          CASE_ID
             )
;

/********************************************************************************************************************
* Type                : TABLE                                                                                     *
* Name                : XXIRI_CASE_VALIDATION                                                                    *
* Purpose             : This is table for validation of state in EDQ wtachlist                       			  *
/*******************************************************************************************************************/
DROP TABLE XOWS.XXIRI_CASE_VALIDATION;
CREATE TABLE XOWS.XXIRI_CASE_VALIDATION
             (
                          FROM_STATE VARCHAR2(100)
                        , TO_STATE   VARCHAR2(100)
                        , TRANSITION VARCHAR2(100)
             )
;
insert into XOWS.XXIRI_CASE_VALIDATION VALUES
('Generated', 'Closed', 'toClosed');
insert into XOWS.XXIRI_CASE_VALIDATION VALUES
('Open', 'Closed', 'toClosed');
COMMIT;