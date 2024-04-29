select * from xwrl_parameters where id = 'PATH' 
--and key = 'ENTITY'
;

select * from xwrl_parameters where id = 'PATH'  and key = 'INDIVIDUAL';
select * from xwrl_parameters where id = 'PATH'  and key = 'ENTITY';


select * from xwrl_parameters where id = 'XML' and key = 'COMPRESSED_XML'
;

/* SAN - 1 Bucket Implementation*/

update xwrl_parameters set value_string = '/edq/webservices/SAN%20Watchlist%20Screening:EntityScreen' where id = 'PATH' and key = 'ENTITY';
update xwrl_parameters set value_string = '/edq/webservices/SAN%20Watchlist%20Screening:IndividualScreen' where id = 'PATH' and key = 'INDIVIDUAL';


/* Standard - 3 Bucket Implementation*/

update xwrl_parameters set value_string = '/edq/webservices/Watchlist%20Screening:EntityScreen' where id = 'PATH' and key = 'ENTITY';
update xwrl_parameters set value_string = '/edq/webservices/Watchlist%20Screening:IndividualScreen' where id = 'PATH' and key = 'INDIVIDUAL';


[I220O] Additional names typo tolerant only


UPDATE XWRL_PARAMETERS
SET VALUE_STRING = 'TRUE'
WHERE ID = 'XML'
AND key = 'COMPRESSED_XML';

UPDATE XWRL_PARAMETERS
SET VALUE_STRING = 'FALSE'
WHERE ID = 'XML'
AND key = 'COMPRESSED_XML';