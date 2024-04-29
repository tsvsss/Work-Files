select *
from sicd_documents
where status = 'Active'
order by last_update_date
;

SELECT count(*)
  FROM SICD_DOCUMENTS A
WHERE STATUS                  = 'Active'
   AND TRUNC(EXPIRATION_DATE)  < TRUNC(SYSDATE)
   AND TRUNC(LAST_UPDATE_DATE) = TRUNC(SYSDATE)
   AND EXPIRATION_DATE         IS NOT NULL
ORDER BY LAST_UPDATE_DATE
;


SELECT *
  FROM SICD_DOCUMENTS A
WHERE STATUS                  = 'Active'
   AND TRUNC(EXPIRATION_DATE)  < TRUNC(SYSDATE)
   AND TRUNC(LAST_UPDATE_DATE) = TRUNC(SYSDATE)
   AND EXPIRATION_DATE         IS NOT NULL
ORDER BY LAST_UPDATE_DATE
;

 

SELECT *
  FROM SICD_DOCUMENTS A
WHERE 1                       = 1
   AND TRUNC(LAST_UPDATE_DATE) = TRUNC(SYSDATE)
	;

SELECT count(*)
  FROM SICD_DOCUMENTS A;	
	
SELECT count(*)
  FROM SICD_DOCUMENTS A
WHERE STATUS                  = 'Expired'	
;

select status, trunc(last_update_date), count(*)
from SICD_DOCUMENTS
where trunc(last_update_date) > trunc(sysdate) - 10
and status = 'Expired'
group by status, trunc(last_update_date)
;

select document_type, status, trunc(last_update_date), count(*)
from SICD_DOCUMENTS
where trunc(last_update_date) > trunc(sysdate) - 10
and status = 'Expired'
--and trunc(last_update_date) = to_date('30-AUG-18 12:00:00','DD-MON-RR HH:MI:SS')
group by document_type, status, trunc(last_update_date)
order by 3,1
;


select header_id, document_type, status, trunc(last_update_date), count(*)
from SICD_DOCUMENTS
where trunc(last_update_date) > trunc(sysdate) - 10
and status = 'Expired'
--and trunc(last_update_date) = to_date('30-AUG-18 12:00:00','DD-MON-RR HH:MI:SS')
group by header_id, document_type, status, trunc(last_update_date)
order by 4,1,2
;

exsicd_utils.approve_data_verification;

sicd_utl.change_status;