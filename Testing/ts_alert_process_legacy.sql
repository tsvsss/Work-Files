DECLARE

cursor c1 is
WITH req as (select  unique r.id, r.matches, r.name_screened, r.date_of_birth, r.country_of_residence, r.passport_number, r.master_id, r.alias_id, r.xref_id
,mst.passport_issuing_country_code, mst.passport_number mst_passport_number
from xwrl_requests r
,xwrl_party_master mst
where r.master_id = mst.id 
and r.case_status = 'O' 
--and r.case_workflow in ( 'L', 'SL' )
--and r.matches >= 50
and r.alias_id is null
and r.xref_id is null)
select unique( ind.request_id )
from xwrl_response_ind_columns ind
,req
where ind.request_id = req.id
and substr(x_state,7) = 'Open'
--and ind.request_id = 224482
order by request_id
;


cursor c2 (p_request_id integer) is
WITH req as (select  r.id, r.matches, r.name_screened, r.date_of_birth, r.country_of_residence, r.passport_number, r.master_id, r.alias_id, r.xref_id
,mst.passport_issuing_country_code, mst.passport_number mst_passport_number
from xwrl_requests r
,xwrl_party_master mst
where r.master_id = mst.id 
and r.case_status = 'O' 
--and r.case_workflow in ( 'L', 'SL' )
--and r.matches >= 50
and r.alias_id is null
and r.xref_id is null)
select ind.request_id,  ind.alertid,  ind.x_state, ind.rec, ind.listrecordtype, ind.listid,req.name_screened, ind.listfamilyname,ind.listgivennames, ind.listfullname, ind.listnametype, ind.listprimaryname, req.master_id, req.alias_id, req.xref_id
--,req.date_of_birth
,to_date(substr(req.date_of_birth,1,10),'YYYY-MM-DD') date_of_birth
,nvl(req.country_of_residence,req.passport_issuing_country_code) passport_issuing_country_code
,nvl(req.passport_number,req.mst_passport_number) passport_number
from xwrl_response_ind_columns ind
,req
where ind.request_id = req.id
and substr(x_state,7) = 'Open'
--and ind.request_id = 224482
;

alert_tab   xwrl_alert_tbl_in_type;
i   NUMBER                 := 0;
v_notes varchar2(1000);
v_last_updated_by integer;
v_count integer;

BEGIN

for c1rec in c1 loop

v_count := 0;
alert_tab := xwrl_alert_tbl_in_type();

begin

for c2rec in c2(c1rec.request_id) loop

     begin



     select notes, last_updated_by
     into v_notes, v_last_updated_by
     from (select wc.notes
      ,wc.last_updated_by
         from wc_content wc
         ,wc_screening_request wr
         ,sicd_countries c
         where wc.wc_screening_request_id = wr.wc_screening_request_id
         and wr.passport_issuing_country_code = c.country_code (+)
         and wr.status = 'Approved'
         and wc.matchstatus = 'NEGATIVE'
         and substr(wc.matchentityidentifier,10) = c2rec.listid
         --and wc.surname = 'KHAN' -- Could use ind.listfamilyname
         --and upper(wc.given_name) = 'MOHAMMED'  -- Could use ind.listgivennames
         and wr.name_screened = c2rec.name_screened
         and wr.date_of_birth = nvl(c2rec.date_of_birth,wr.date_of_birth)
          and c.iso_alpha2_code = nvl(c2rec.passport_issuing_country_code,c.iso_alpha2_code)
          and wr.passport_number = nvl(c2rec.passport_number,wr.passport_number)
         order by wc_content_id desc)
         where rownum = 1
         ;

        v_count :=  v_count + 1;
        alert_tab.EXTEND;    

         alert_tab(v_count) :=  xwrl_alert_in_rec (c2rec.alertid
                                  ,c2rec.listrecordtype||' - False Positive'
                                ,v_notes
                                  );
                             
         --dbms_output.put_line('Alert: '||alert_tab(i).p_alert_id);
         --dbms_output.put_line('State: '||alert_tab(i).p_to_state); 
        --dbms_output.put_line('Note: '||alert_tab(i).p_comment );
         
   exception
   when no_data_found then null;
   end;

end loop;

         if v_count > 0 then

            xwrl_ows_utils.process_alerts (p_user_id         => v_last_updated_by,
                                           p_session_id      => 999,
                                           p_request_id      => c1rec.request_id,
                                           p_alert_tab       => alert_tab
                                          );
            v_count := 0;
                                          
         end if;

   exception
   when no_data_found then null;
   end;

end loop;

END;
/