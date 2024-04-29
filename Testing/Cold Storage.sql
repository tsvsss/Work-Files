select *
from iri_edocs
where category_id = 1621
;

select *
from iri_edocs_categories
WHERE category = 'SICD'
and DOCUMENT_TYPE = 'Application'
order by description
;


select *
from all_tables
where table_name LIKE 'IRI_EDOC%'
;


select year, count(*) number_of_files, round(sum(space_allocation) / 1024 / 1024 / 1024,2) space_allocation_gb
from (select EXTRACT( YEAR FROM creation_date) year , file_api.length(disk_path) space_allocation
from iri_edocs
where creation_date is not null
--and EXTRACT( YEAR FROM creation_date) = 2008
)
group by year
;