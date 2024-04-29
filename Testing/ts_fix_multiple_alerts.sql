with mst_lst as 
(select master_id, list_id, max(id) max_id
from xwrl_alert_clearing_xref
where alias_id is null
and xref_id is not null
and request_id = 269198
group by master_id, list_id)
--select x.*, r.batch_id
select x.id, x.request_id, alert_id, to_state, note
from xwrl_alert_clearing_xref x
,mst_lst
where x.id = mst_lst.max_id
--and alert_id = 'SEN-2269833'
;

DECLARE

   l  xwrl_alert_tbl_in_type;
   i  NUMBER := 0;

BEGIN

   l := xwrl_alert_tbl_in_type ();
   FOR rec IN (
      SELECT *
      FROM         xwrl_response_entity_columns
      WHERE      request_id = 70521
      AND alertid = 'SEN-9788209'
   )
 LOOP

      i := i + 1;
      l.extend;

      l (i) := xwrl_alert_in_rec (rec.alertid
      ,'EDD - Possible'
       ,'test'
      );

   END LOOP;


   xwrl_ows_utils.process_alerts (
      p_user_id     => 0,
       p_session_id  => 999,
      p_request_id  => 1906,
       p_alert_tab   => l
   );

END;
/