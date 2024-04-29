select *
from xwrl_parameters
order by id, key
;

insert  into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE)  VALUES ('XWRL_OWS_UTILS','DEBUG','TRUE',1156,SYSDATE,1156,SYSDATE);

insert  into "XWRL"."XWRL_PARAMETERS" (ID, KEY, VALUE_STRING,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE)  VALUES ('XWRL_UTILS','DEBUG','TRUE',1156,SYSDATE,1156,SYSDATE);

select value_string
from xwrl_parameters
where id = 'XWRL_OWS_UTILS'
and key = 'DEBUG'
;

select value_string
from xwrl_parameters
where id = 'XWRL_UTILS'
and key = 'DEBUG'
;

update xwrl_parameters
set value_string = null
where id = 'XWRL_OWS_UTILS'
and key = 'DEBUG'
;

update xwrl_parameters
set value_string = null
where id = 'XWRL_UTILS'
and key = 'DEBUG'
;

update xwrl_parameters
set value_string = 'TRUE'
where id = 'XWRL_OWS_UTILS'
and key = 'DEBUG'
;

update xwrl_parameters
set value_string =  'TRUE'
where id = 'XWRL_UTILS'
and key = 'DEBUG'
;