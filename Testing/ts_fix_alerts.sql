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