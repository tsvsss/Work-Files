SELECT
   *
FROM
   wc_screening_request
WHERE
   wc_screening_request_id = 811805
ORDER BY
   wc_screening_request_id DESC;


SELECT
   *
FROM
   wc_matches
WHERE
   wc_screening_request_id = nvl (:wc_screening_request_id, wc_screening_request_id)
ORDER BY
   wc_screening_request_id DESC;

SELECT
   *
FROM
   wc_content
WHERE
   wc_screening_request_id = nvl (:wc_screening_request_id, wc_screening_request_id)
ORDER BY
   wc_screening_request_id DESC;
   
   select unique matchtype
   from wc_content;

SELECT
   wc_screening_request_id
   , wc_matches_id
   , wc_content_id
   , matchentityidentifier
   , matchstatus
   , notes
   , substr (matchentityidentifier, instr (matchentityidentifier, '_', - 1) + 1, length (matchentityidentifier)) listid
FROM
   wc_content
WHERE
   wc_screening_request_id = nvl (:wc_screening_request_id, wc_screening_request_id)
ORDER BY
   wc_screening_request_id DESC;

SELECT
   COUNT (*)
FROM
   worldcheck_external_xref;

SELECT
   *
FROM
   worldcheck_external_xref
WHERE
   wc_screening_request_id = nvl (:wc_screening_request_id, wc_screening_request_id)
ORDER BY
   wc_screening_request_id DESC;

SELECT
   wc_screening_request_id
   , wc_matches_id
   , wc_content_id
   , matchentityidentifier
   , matchstatus
   , notes
   , substr (matchentityidentifier, instr (matchentityidentifier, '_', - 1) + 1, length (matchentityidentifier)) listid
FROM
   wc_content
WHERE
   wc_screening_request_id = nvl (:wc_screening_request_id, wc_screening_request_id)
ORDER BY
   wc_screening_request_id DESC;


/* Note: Need to get the TO_STATE 
                 Data is found within the XML
*/

SELECT
   c.wc_screening_request_id
   , c.wc_matches_id
   , c.wc_content_id
   --, c.matchentityidentifier
   --, c.matchstatus
   --, x.worldcheck_external_xref_id
   , x.source_table
   , x.source_table_column
   , x.source_table_id
   , substr (c.matchentityidentifier, instr (c.matchentityidentifier, '_', - 1) + 1, length (c.matchentityidentifier)) listid   
      , c.notes
      ,sysdate
      ,-1
      ,sysdate
      ,-1
      ,1
FROM
   wc_content                 c
   , worldcheck_external_xref   x
WHERE
   c.wc_screening_request_id = x.wc_screening_request_id
   --AND c.wc_screening_request_id = nvl (:wc_screening_request_id, c.wc_screening_request_id)
   and c.matchstatus = 'NEGATIVE'
ORDER BY
      c.wc_content_id desc;
   
   
   
   