
xwrl_utils;
xwrl_ows_utils;
rmi_ows_common_util;

--SEN-10015100    193160
--SEN-10015099    193160

SELECT *
FROM xwrl_parameters;

SELECT *
FROM xwrl_alerts_debug
;

SELECT *
FROM xwrl_alert_notes
ORDER BY ID DESC;

SELECT *
FROM xwrl_note_xref
;

select *
from fnd_user
where user_id= 6910;

SELECT *
FROM xwrl_response_ind_columns
 where alertid = :p_alert_id
order by id desc
;


select * 
from xwrl_alert_clearing_xref
where request_id = :p_request_id
order by id desc
;

select * 
from xwrl_alert_clearing_xref
where alert_id  = :p_alert_id
order by id desc;

SELECT *
FROM xwrl_response_ind_columns
 where request_id  = :p_request_id
--order by id desc
order by alertid
;

SELECT id, request_id, rec, listfullname, x_state, alertid, listid
FROM xwrl_response_ind_columns
 where request_id  = :p_request_id
--order by id desc
order by alertid
;

SELECT c.*,r.master_id
FROM xwrl_response_ind_columns c
,xwrl_requests r
where c.request_id = r.id 
and exists (select 1 from xwrl_requests r where r.id = c.request_id and batch_id =  :p_batch_id)
and alertid =  :p_alert_id
--and listid = :p_list_id 
;  --SEN-10205455

/*
SEN-10205455
SEN-10205456
SEN-10205457
SEN-10205458
SEN-10205459
SEN-10205460
SEN-10205461
*/

/*
SEN-10209763
SEN-10209764
SEN-10209764
*/

/*
SEN-10210078
SEN-10210078
SEN-10210079
SEN-10210079
SEN-10210080
SEN-10210080
SEN-10210081
SEN-10210081
SEN-10210082
SEN-10210082
SEN-10210083
SEN-10210083
SEN-10210084
SEN-10210084
SEN-10210085
SEN-10210085
SEN-10210086
SEN-10210087
SEN-10210087
SEN-10210088
SEN-10210089
SEN-10210089
SEN-10210089
SEN-10210090
SEN-10210090
SEN-10210091
SEN-10210091
SEN-10210092
SEN-10210092
SEN-10210093
SEN-10210094
SEN-10210094
SEN-10210095
SEN-10210095
SEN-10210095
SEN-10210096
SEN-10210096
SEN-10210097
SEN-10210098
SEN-10210099
SEN-10210099
SEN-10210099
SEN-10210100
SEN-10210100
SEN-10210101
SEN-10210102
SEN-10210102
SEN-10210103
SEN-10210104
SEN-10210105
SEN-10210105
SEN-10210106
SEN-10210106
SEN-10210107
SEN-10210107
SEN-10210108
SEN-10210108
SEN-10210109
SEN-10210110
*/

select * 
from xwrl_alerts_debug
WHERE p_alert_id = :p_alert_id
order by id desc
;

select * 
from xwrl_alert_results_debug
--WHERE p_request_id = :p_request_id
WHERE p_alert_id = :p_alert_id
order by id desc
;

SELECT *
FROM mt_log
where upper(notes) like '%'||:p_alert_id||'%'
order by log_id desc
;

select *
from mt_log
where log_id between 19143310 and 19143330
order by log_id desc
;

--Request ID: 229562 User ID: 6910 Batch ID: 105456 Source ID: 1078952 List ID: 3487034 Alert Id: SEN-10205455 To State: EDD - False Positive

SELECT   cols.*
                                   FROM xwrl_requests req,
                                        xwrl_response_ind_columns cols
                                  WHERE req.ID = cols.request_id
                                    AND req.source_id = :l_source_id
                                    AND req.source_table = :l_source_table
                                    AND req.batch_id = :l_batch_id
                                    AND cols.listid = :l_listid
                                    AND req.ID != :p_request_id
                                    AND cols.x_state != :p_to_state
                               ORDER BY cols.request_id;

SELECT   cols.*
FROM xwrl_response_ind_columns cols
,xwrl_requests req
WHERE cols.request_id = req.id  
and req.batch_id = :l_batch_id
and req.master_id = :l_master_id 
and cols.listid = :l_listid  
;

select * 
from xwrl_alert_results_debug
WHERE p_request_id = :p_request_id
--WHERE p_alert_id = :p_alert_id
order by id desc
;

select * 
from xwrl_alert_results_debug
WHERE p_request_id = :p_request_id
--WHERE p_alert_id = :p_alert_id
order by id desc
;

/*

SEN-10218880
SEN-10218881
*/

SELECT *
FROM mt_log
where upper(notes) like '%'||:p_alert_id||'%'
order by log_id desc
;

select *
from xwrl_requests
where id = 233121
;

select *
from xwrl_response_ind_columns
where request_id = 233121
;

select *
from xwrl_alert_notes
where request_id = 233121
--where alert_id = 'SEN-10218881'
;

select *
from xwrl_alert_clearing_xref
where request_id = 233121
;


update xwrl_response_ind_columns
set x_state = 'EDD - False Positive'
where id = 549855;



--Batch ID: 108346
--Exception In Getting To State: ORA-01403: no data found
SELECT *
FROM mt_log
where log_id between 19640380 and 19640400 
order by log_id desc
;

--Batch ID: 107359
--Exception In Getting To State: ORA-01403: no data found
SELECT *
FROM mt_log
where log_id between 19561792 and 19561802 
order by log_id desc
;

--Exception In Getting To State: ORA-01403: no data found
SELECT *
FROM mt_log
where log_id between 19561798 and 19561808 
order by log_id desc
;

--Exception In Getting To State: ORA-01403: no data found
SELECT *
FROM mt_log
where log_id between 19561879 and 19561899 
order by log_id desc
;

--Batch ID: 108346
-- Exception In Getting To State: ORA-01403: no data found
SELECT *
FROM mt_log
where log_id between 19640380 and 19640400 
order by log_id desc
;

select *
from xwrl_alert_clearing_xref
where master_id = 501830
and list_id = 	2826638
order by id desc
;

                      select i.request_id, r.case_id,i.alertid,i.rec,listid,i.x_state, r.name_screened, r.master_id, r.alias_id, r.xref_id
                     from xwrl_response_ind_columns  i
                     ,xwrl_requests r
                     where i.request_id = r.id
                     and r.batch_id = 67968
                     and i.listid = 2826638
                     order by request_id, rec;

                      select unique i.request_id, r.case_id,i.alertid, listid, i.x_state, r.name_screened, r.master_id, r.alias_id, r.xref_id
                     from xwrl_response_ind_columns  i
                     ,xwrl_requests r
                     where i.request_id = r.id
                     and r.batch_id = 67974
                     and i.listid = 2826638
                     order by request_id, alertid;

select *
from xwrl_alert_notes
where request_id = 144062
;



      SELECT value_string
        FROM xwrl_parameters
       WHERE ID = 'XWRL_OWS_UTILS' AND KEY = 'DEBUG';

select *
from xwrl_requests
where batch_id = 67960
order by id desc
;

144015
144014
144013
144012

-- CURSOR c1 (p_max_id IN NUMBER)

        SELECT DISTINCT col.ID, col.request_id, r.source_table, r.source_id,
                         col.listid, col.alertid, col.x_state
                                                             --, col.listrecordtype||' - False Positive' to_state\
                                                             --SAURABH 13-JAN-2020
                         ,
                            col.listrecordtype
                         || SUBSTR (CLEAR.to_state, 4) to_state
                                                               -- TSUAZO 20-FEB-2020
                                                                      --,clear.to_state
                         ,
                         CLEAR.note, CLEAR.max_id
                    FROM xwrl_response_ind_columns col,
                         xwrl_requests r,
                         (WITH max_tab AS
                               (SELECT
                                         --x.source_table, x.source_id, x.list_id,
                                         x.master_id, x.alias_id, x.xref_id,
                                         x.list_id, MAX (ID) ID
                                    FROM xwrl_alert_clearing_xref x
                                --GROUP BY x.source_table, x.source_id, x.list_id
                                GROUP BY x.master_id,
                                         x.alias_id,
                                         x.xref_id,
                                         x.list_id)
                          SELECT x.source_table, x.source_id, x.list_id,
                                 x.to_state, x.note, x.master_id, x.alias_id,
                                 x.xref_id, max_tab.ID max_id
                            FROM xwrl_alert_clearing_xref x, max_tab
                           WHERE 1 = 1
--                    AND x.source_table = max_tab.source_table
--                    AND x.source_id = max_tab.source_id
                             AND x.master_id = max_tab.master_id
                             AND NVL (x.alias_id, -99) =
                                                    NVL (max_tab.alias_id,
                                                         -99)
                             AND NVL (x.xref_id, -99) =
                                                     NVL (max_tab.xref_id,
                                                          -99)
                             AND x.ID = max_tab.ID) CLEAR
                   WHERE col.request_id = r.ID
--            AND r.source_table = CLEAR.source_table
--            AND r.source_id = CLEAR.source_id
                     AND r.master_id = CLEAR.master_id
                     -- tsuazo 20200722 fix issue with the query
                     AND NVL (r.alias_id, -99) = NVL (CLEAR.alias_id, -99)
                     AND NVL (r.xref_id, -99) = NVL (CLEAR.xref_id, -99)
                     --AND NVL (r.alias_id, -99) = NVL (r.alias_id, -99)
                     --AND NVL (r.xref_id, -99) = NVL (r.xref_id, -99)
                     AND col.listid = CLEAR.list_id
                     AND col.request_id = :p_request_id
                     AND CLEAR.max_id > NVL (:p_max_id, -1);

select *
from xwrl_alert_clearing_xref
--where id = 14321972
where request_id = 144015
order by list_id desc,  id desc
;

--CURSOR c2 (p_max_id IN NUMBER)

         SELECT DISTINCT col.ID, col.request_id, r.source_table, r.source_id,
                         col.listid, col.alertid, col.x_state
                                                             --, col.listrecordtype||' - False Positive' to_state\
                                                             --SAURABH 13-JAN-2020
                         ,
                            col.listrecordtype
                         || SUBSTR (CLEAR.to_state, 4) to_state
                                                               -- TSUAZO 20-FEB-2020
                                                                     --,clear.to_state
                         ,
                         CLEAR.note, CLEAR.max_id
                    FROM xwrl_response_ind_columns col,
                         xwrl_requests r,
                         xwrl_party_xref r1,
                         (WITH max_tab AS
                               (SELECT   x.master_id, x.alias_id, x.xref_id,
                                         x.list_id, MAX (x.ID) ID
                                    FROM xwrl_alert_clearing_xref x
                                   WHERE 1 = 1
                                GROUP BY x.master_id,
                                         x.alias_id,
                                         x.xref_id,
                                         x.list_id)
                          SELECT x.source_table, x.source_id, x.list_id,
                                 x.to_state, x.note, x.master_id, x.alias_id,
                                 x.xref_id, r.relationship_master_id,
                                 max_tab.ID max_id
                            FROM xwrl_alert_clearing_xref x,
                                 xwrl_party_xref r,
                                 max_tab
                           WHERE 1 = 1
                             AND x.xref_id = r.ID
                             AND x.master_id = max_tab.master_id
                             AND NVL (x.alias_id, -99) =
                                                    NVL (max_tab.alias_id,
                                                         -99)
                             AND NVL (x.xref_id, -99) =
                                                     NVL (max_tab.xref_id,
                                                          -99)
                             AND x.ID = max_tab.ID) CLEAR
                   WHERE col.request_id = r.ID
                     AND r1.ID = r.xref_id
                     AND r1.relationship_master_id =
                                                  CLEAR.relationship_master_id
                     AND r.xref_id IS NOT NULL
                     --SAURABH
                     AND r.master_id <> CLEAR.master_id
                     --
                     AND col.listid = CLEAR.list_id
                     AND col.request_id = :p_request_id
                     AND CLEAR.max_id > NVL (:p_max_id, -1);

     -- CURSOR c3 (p_max_id IN NUMBER)
      
         SELECT DISTINCT col.ID, col.request_id, r.source_table, r.source_id,
                         col.listid, col.alertid, col.x_state
                                                             --, col.listrecordtype||' - False Positive' to_state\
                                                             --SAURABH 13-JAN-2020
                         ,
                            col.listrecordtype
                         || SUBSTR (CLEAR.to_state, 4) to_state
                                                               -- TSUAZO 20-FEB-2020
                                                                     --,clear.to_state
                         ,
                         CLEAR.note, CLEAR.max_id
                    FROM xwrl_response_ind_columns col,
                         xwrl_requests r,
                         xwrl_party_xref r1,
                         (WITH max_tab AS
                               (SELECT   x.master_id, x.alias_id, x.xref_id,
                                         x.list_id, MAX (x.ID) ID
                                    FROM xwrl_alert_clearing_xref x
                                   WHERE 1 = 1
                                GROUP BY x.master_id,
                                         x.alias_id,
                                         x.xref_id,
                                         x.list_id)
                          SELECT x.source_table, x.source_id, x.list_id,
                                 x.to_state, x.note, x.master_id, x.alias_id,
                                 x.xref_id, max_tab.ID max_id
                            FROM xwrl_alert_clearing_xref x, max_tab
                           WHERE 1 = 1
                             AND x.master_id = max_tab.master_id
                             AND NVL (x.alias_id, -99) =
                                                    NVL (max_tab.alias_id,
                                                         -99)
                             AND NVL (x.xref_id, -99) =
                                                     NVL (max_tab.xref_id,
                                                          -99)
                             --SAURABH
                             AND x.xref_id IS NULL
                             AND x.ID = max_tab.ID) CLEAR
                   WHERE col.request_id = r.ID
                     AND r1.ID = r.xref_id
                     AND r1.relationship_master_id = CLEAR.master_id
                     AND r.xref_id IS NOT NULL
                     AND col.listid = CLEAR.list_id
                     AND col.request_id = :p_request_id
                     AND CLEAR.max_id > NVL (:p_max_id, -1);

      --CURSOR c4 (p_max_id IN NUMBER)
      
         SELECT DISTINCT col.ID, col.request_id, r.source_table, r.source_id,
                         col.listid, col.alertid, col.x_state
                                                             --, col.listrecordtype||' - False Positive' to_state\
                                                             --SAURABH 13-JAN-2020
                         ,
                            col.listrecordtype
                         || SUBSTR (CLEAR.to_state, 4) to_state
                                                               -- TSUAZO 20-FEB-2020
                                                                     --,clear.to_state
                         ,
                         CLEAR.note, CLEAR.max_id
                    FROM xwrl_response_ind_columns col,
                         xwrl_requests r,
                         (WITH max_tab AS
                               (SELECT   x.master_id, x.alias_id, x.xref_id,
                                         x.list_id, MAX (x.ID) ID
                                    FROM xwrl_alert_clearing_xref x
                                   WHERE 1 = 1
                                GROUP BY x.master_id,
                                         x.alias_id,
                                         x.xref_id,
                                         x.list_id)
                          SELECT x.source_table, x.source_id, x.list_id,
                                 x.to_state, x.note, x.master_id, x.alias_id,
                                 x.xref_id, r.relationship_master_id,
                                 max_tab.ID max_id
                            FROM xwrl_alert_clearing_xref x,
                                 xwrl_party_xref r,
                                 max_tab
                           WHERE 1 = 1
                             AND x.xref_id = r.ID
                             AND x.master_id = max_tab.master_id
                             AND NVL (x.alias_id, -99) =
                                                    NVL (max_tab.alias_id,
                                                         -99)
                             AND NVL (x.xref_id, -99) =
                                                     NVL (max_tab.xref_id,
                                                          -99)
                             AND x.ID = max_tab.ID) CLEAR
                   WHERE col.request_id = r.ID
                     AND r.master_id = CLEAR.relationship_master_id
                     AND r.xref_id IS NULL
                     AND r.alias_id IS NULL
                     AND col.listid = CLEAR.list_id
                     AND col.request_id = :p_request_id
                     AND CLEAR.max_id > NVL (:p_max_id, -1);
                     
                     
                     
select count(unique r.id)
from xwrl_response_ind_columns c
,xwrl_requests r
where c. request_id = r.id
and r.case_status = 'O'
and r.case_state <> 'D'
--and r.case_workflow IN ( 'L','SL')
and exists (select 1
from xwrl_response_ind_columns c
where c.request_id = r.id
and substr(c.x_state,7) = 'Open')
--order by request_id  
;


select count(unique r.id)
from xwrl_response_entity_columns c
,xwrl_requests r
where c. request_id = r.id
and r.case_status = 'O'
and r.case_state <> 'D'
--and r.case_workflow IN ( 'L','SL')
and exists (select 1
from xwrl_response_entity_columns c
where c.request_id = r.id
and substr(c.x_state,7) = 'Open')
--order by request_id  
;

select *
from xwrl_requests
where batch_id = 67950
;



select n.id, n.request_id, n.case_key, n.alert_id, n.list_id,  n.from_state, n.to_state, note, n.master_id, n.alias_id, n.xref_id, n.created_by
from xwrl_alert_clearing_xref n
where exists (select 1
from xwrl_requests r
where r.id = n.request_id
and r.batch_id = 67980)
order by alert_id desc, list_id desc
;

select id, request_id, case_key, alert_id, list_id,  from_state, to_state, note, master_id, alias_id, xref_id, created_by
from xwrl_alert_clearing_xref
where master_id = 501830
--and list_id = 2826638
order by id desc
;

select *
from xwrl_requests
where id = 143988;

select *
from xwrl_response_ind_columns
where request_id = 143988
and alertid = 'SEN-12222113'
;

select n.*
from xwrl_alert_notes n
where alert_id = 'SEN-12222113'
;

select c.request_id, c.rec, c.listid, c.alertid, n.line_number, note
from xwrl_response_ind_columns c
,xwrl_requests r
,xwrl_alert_notes n
where c.request_id = r.id
and c.request_id = n.request_id
and c.alertid = n.alert_id
and r.batch_id = 67954
order by alert_id desc, rec
;

select n.*
from xwrl_alert_notes n
--where alert_id = 'SEN-12221768'
where exists (select 1
from xwrl_requests r
where r.id = n.request_id
and r.batch_id = 67954
--and r.id = 143988
)
--and alert_id = 'SEN-12222113'
order by alert_id desc, line_number desc
;

                      select unique i.request_id, r.case_id,i.alertid,listid, i.x_state, r.name_screened
                     from xwrl_response_ind_columns  i
                     ,xwrl_requests r
                     where i.request_id = r.id
                     and r.batch_id = 67953
                     and i.listid = 2826638
                      --and i.request_id = 143972
                     order by request_id, listid;

select *
from xwrl_alert_notes
;

select i.request_id, r.name_screened,r.case_id,i.alertid,i.rec,listid, i.listrecordtype, i.listfullname, i.x_state, n.line_number, n.note, n.creation_date, n.created_by
from xwrl_response_ind_columns  i
,xwrl_requests r
,xwrl_note_xref x
,XWRL_ALERT_NOTES n
where i.request_id = r.id
and r.batch_id = 67974
--and i.listid = 2866707
and i.request_id = x.request_id (+)
and i.alertid = x.alert_id (+)
and x.note_id = n.id (+)
order by request_id desc, alertid desc, rec desc, line_number desc
;

select i.request_id, r.name_screened,r.case_id,i.alertid,i.rec,listid, i.listrecordtype, i.listfullname, i.x_state, n.line_number, n.note, n.creation_date, n.created_by
from xwrl_response_entity_columns  i
,xwrl_requests r
,xwrl_note_xref x
,XWRL_ALERT_NOTES n
where i.request_id = r.id
and r.batch_id = 67975
--and i.listid = 2866707
and i.request_id = x.request_id (+)
and i.alertid = x.alert_id (+)
and x.note_id = n.id (+)
order by request_id desc, alertid desc, rec desc, line_number desc
;

select * 
from  xwrl_case_notes_sum_v
--where batch_id = 67944
--where orig_master_id = 501830
--where master_id = 501830
--where case_id = 'OWS-202007-231629-7BDB49-IND'
where id = 177013
;

select *
from xwrl_alert_notes
;

select *
from XWRL_ALERT_NOTES
--where alert_id = 'SEN-12223740'
order by id desc
;

501830
2300415


select count(*)
from xwrl_note_xref
where master_id = 501830
;

select *
from xwrl_alert_notes
where id = 181109
order by id desc;

select *
from xwrl_note_xref
where master_id = 501830
order by id desc;

select x.*
from xwrl_note_xref x
where x.master_id = :p_master_id
and x.list_id = :p_list_id
;

with max_note as 
      (select nn.note max_note,max(nn.id) max_id
      from xwrl_response_ind_columns  ii
      ,xwrl_requests rr
      ,xwrl_note_xref xx
      ,XWRL_ALERT_NOTES nn
      where ii.request_id = rr.id
      and rr.master_id = :p_master_id
      and decode(rr.alias_id ,nvl(:p_alias_id,rr.alias_id),1,0) = 1
      and decode(rr.xref_id ,nvl(:p_xref_id,rr.xref_id),1,0) = 1
      and ii.listid = :p_list_id
      and ii.request_id = xx.request_id (+)
      and ii.alertid = xx.alert_id (+)
      and xx.note_id = nn.id (+)
      group by nn.note)
      select n.id, n.request_id, n.line_number, n.note, n.creation_date, n.created_by, n.last_update_date, n.last_updated_by, n.last_update_login
      from xwrl_response_ind_columns  i
      ,xwrl_requests r
      ,xwrl_note_xref x
      ,XWRL_ALERT_NOTES n
      ,max_note
      where i.request_id = r.id
      and r.master_id = :p_master_id
      and decode(r.alias_id ,nvl(:p_alias_id,r.alias_id),1,0) = 1
      and decode(r.xref_id ,nvl(:p_xref_id,r.xref_id),1,0) = 1
      and i.listid = :p_list_id
      and i.request_id = x.request_id (+)
      and i.alertid = x.alert_id (+)
      and x.note_id = n.id (+)
      and n.id = max_note.max_id;

            SELECT r.source_table, r.source_id, r.path, r.master_id,  r.alias_id, r.xref_id, r.batch_id              
              FROM xwrl.xwrl_requests r
             WHERE r.id =:new.request_id;


select c.casekey, c.listid, c.x_state
from xwrl_response_ind_columns c;

SELECT xwrl_alert_notes_seq.NEXTVAL,
                            r_ind_cols.request_id request_id,
                            r_ind_cols.alertid alert_id
                            , line_number
                            , note
                            , last_update_date
                            , last_updated_by
                            , creation_date
                            , created_by
                            , last_update_login
                       FROM xwrl_alert_notes n
                      WHERE 1 = 1
                        AND n.request_id = p_request_id
                        AND n.alert_id = p_alert_in_tbl (i).p_alert_id
                       and n.line_number not in (select x.line_number from xwrl_alert_notes x where x.request_id = r_ind_cols.request_id and x.alert_id = r_ind_cols.alertid)
;

select *
from xwrl_requests
where batch_id = :p_batch_id;


      select c.casekey, c.listid, c.x_state, c.request_id, c.alertid
      from xwrl_response_ind_columns c
      ,xwrl_requests r
      where c.request_id = r.id
      and r.batch_id = :p_batch_id
      and c.request_id != :p_request_id
      and c.listid = :p_list_id;

select *
from xwrl_request;

truncate table mt_log;

select *
from mt_log
--where notes like 'xwrl_alert_notes%'
where notes like '%ERROR%'
order by 1 desc --10748709
;

select *
from mt_log
--where notes like 'xwrl_alert_notes%'
where notes like '%SEN-2247135%'
order by 1 desc --10748709
;

select *
from mt_log
--where notes like 'xwrl_alert_notes%'
where log_id between 22980300 and 22980390
order by 1 desc --10748709
;



      select c.casekey, c.listid, c.x_state, c.request_id, c.alertid alert_id,r.source_table, null source_table_column, r.source_id,   r.master_id,  r.alias_id, r.xref_id, r.batch_id        
      from xwrl_response_ind_columns c
      ,xwrl_requests r
      where c.request_id = r.id
      and r.batch_id = :p_batch_id
      --and c.alertid != p_alert_id
      and c.listid = :p_list_id
      ;
      select c.casekey, c.listid, c.x_state, c.request_id, c.alertid alert_id,r.source_table, null source_table_column, r.source_id,   r.master_id,  r.alias_id, r.xref_id, r.batch_id        
      from xwrl_response_ind_columns c
      ,xwrl_requests r
      where c.request_id = r.id
      and r.batch_id = :p_batch_id
      --and c.alertid != p_alert_id
      and c.listid = :p_list_id;


select *
from xwrl_alert_notes n
--where id = 181109
where exists (select 1 from xwrl_requests r where r.id = n.request_id and batch_id = :p_batch_id)
--and list_id = :p_list_id
order by id desc;


select *
from xwrl_note_xref n
where exists (select 1 from xwrl_requests r where r.id = n.request_id and batch_id = :p_batch_id)
and list_id = :p_list_id
--and note_id = :p_note_id
order by id desc;

--SEN-12226169 OWS-202007-270850-36BD64-IND
--SEN-12226155 OWS-202007-270850-B4A549-IND
--SEN-12226174 OWS-202007-270850-26EE32-IND
--SEN-12226150 OWS-202007-270849-6ECE58-IND

SELECT XwrlAlertNotes.ID,  
       XwrlAlertNotes.REQUEST_ID,  
       XwrlAlertNotes.ALERT_ID,  
       XwrlAlertNotes.LINE_NUMBER,  
       XwrlAlertNotes.NOTE,  
       XwrlAlertNotes.LAST_UPDATE_DATE,  
       XwrlAlertNotes.LAST_UPDATED_BY,  
       XwrlAlertNotes.CREATION_DATE,  
       XwrlAlertNotes.CREATED_BY,  
       XwrlAlertNotes.LAST_UPDATE_LOGIN,
       (select description from fnd_user 
       where user_id = XwrlAlertNotes.LAST_UPDATED_BY) as lastUpdatedByAttr,
       (select description from fnd_user 
       where user_id = XwrlAlertNotes.CREATED_BY) as createdByAttr
       --,XWRL_NOTE_XREF.*
FROM  XWRL_ALERT_NOTES XwrlAlertNotes
,XWRL_NOTE_XREF  XWRL_NOTE_XREF
where XWRL_NOTE_XREF.note_id=XwrlAlertNotes.id
and XWRL_NOTE_XREF.alert_id = :p_alert_id
order by XwrlAlertNotes.ID desc
;

--delete xwrl_note_xref where master_id = 501830;

SELECT XwrlAlertNotes.ID,
XwrlAlertNotes.REQUEST_ID,
XwrlAlertNotes.ALERT_ID,
XwrlAlertNotes.LINE_NUMBER,
XwrlAlertNotes.NOTE,
XwrlAlertNotes.LAST_UPDATE_DATE,
XwrlAlertNotes.LAST_UPDATED_BY,
XwrlAlertNotes.CREATION_DATE,
XwrlAlertNotes.CREATED_BY,
XwrlAlertNotes.LAST_UPDATE_LOGIN,
(select description from fnd_user
where user_id = XwrlAlertNotes.LAST_UPDATED_BY) as lastUpdatedByAttr,
(select description from fnd_user
where user_id = XwrlAlertNotes.CREATED_BY) as createdByAttr
--,XWRL_NOTE_XREF.*
FROM XWRL_ALERT_NOTES XwrlAlertNotes
,XWRL_NOTE_XREF XwrlNoteXref
where XwrlNoteXref.note_id=XwrlAlertNotes.id
--and XwrlNoteXref.alert_id=XwrlAlertNotes.alert_id
and XwrlNoteXref.alert_id = 'SEN-12226155'
order by XwrlAlertNotes.ID desc;


SELECT SUBSTR (to_state, 4)
FROM xwrl_alert_clearing_xref
WHERE alert_id = :p_alert_id
AND ID =  (SELECT MAX (ID) FROM xwrl_alert_clearing_xref WHERE alert_id = :p_alert_id);

select *
from xwrl_note_xref;

select *
from xwrl_requests
where batch_id = 115201
;

select *
from xwrl_response_ind_columns
where request_id = 248569
--and alertid = 'SEN-10286110'
and listid = 3077013
;

select *
from xwrl_note_xref;

select count(*)
from (with xref as
(select x.id, x.master_id, x.alias_id, x.xref_id, x.list_id, x.alert_id
from xwrl_note_xref x)
select c.casekey, c.listid, c.x_state, c.request_id, c.alertid alert_id, r.source_table, null source_table_column, r.source_id,   r.master_id,  r.alias_id, r.xref_id, r.batch_id, c.last_update_date, c.last_updated_by, c.creation_date, c.created_by, c.last_update_login
from xwrl_response_ind_columns c
,xwrl_requests r
,xref x
where c.request_id = r.id
and r.master_id = x.master_id (+)
and decode(r.alias_id ,nvl(x.alias_id (+),r.alias_id),1,0) = 1
and decode(r.xref_id ,nvl(x.xref_id (+),r.xref_id),1,0) = 1
and c.listid = x.list_id (+)
and c.alertid = x.alert_id (+)
and x.id is null)
;

select count(*)
from (with xref as
(select x.id, x.master_id, x.alias_id, x.xref_id, x.list_id, x.alert_id
from xwrl_note_xref x)
select c.casekey, c.listid, c.x_state, c.request_id, c.alertid alert_id, r.source_table, null source_table_column, r.source_id,   r.master_id,  r.alias_id, r.xref_id, r.batch_id, c.last_update_date, c.last_updated_by, c.creation_date, c.created_by, c.last_update_login
from xwrl_response_entity_columns c
,xwrl_requests r
,xref x
where c.request_id = r.id
and r.master_id = x.master_id (+)
and decode(r.alias_id ,nvl(x.alias_id (+),r.alias_id),1,0) = 1
and decode(r.xref_id ,nvl(x.xref_id (+),r.xref_id),1,0) = 1
and c.listid = x.list_id (+)
and c.alertid = x.alert_id (+)
and x.id is null)
;

select *
from xwrl_note_xref
order by id desc
;

select *
from mt_log
order by 1 desc;

select *
from mt_log
where notes like '%Alert ID: SEN-10300708%' --2257502
order by 1 desc;

SELECT *
FROM mt_log
where log_id between 25099767 and 25099771 
order by log_id desc
;


select nn.note max_note,max(nn.id) max_id
from xwrl_response_ind_columns  ii
,xwrl_requests rr
,xwrl_note_xref xx
,XWRL_ALERT_NOTES nn
where ii.request_id = rr.id
and rr.master_id = :p_master_id
and decode(rr.alias_id ,nvl(:p_alias_id,rr.alias_id),1,0) = 1
and decode(rr.xref_id ,nvl(:p_xref_id,rr.xref_id),1,0) = 1
and ii.listid = :p_list_id
and ii.request_id = xx.request_id (+)
and ii.alertid = xx.alert_id (+)
and xx.note_id = nn.id (+)
group by nn.note;


select *
from all_source
where lower(text) like '%xxiri_cm_process_pkg.update_alerts%'
;



select c.*
from xwrl_