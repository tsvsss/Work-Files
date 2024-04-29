-- Temporary Integration Tables
-- Need to create audit log tables

truncate table tmp_xwrl_alerts;
truncate table tmp_xwrl_alert_results;

SELECT * FROM tmp_xwrl_alerts;

SELECT * FROM tmp_xwrl_alert_results;

--  Alert Notes Table
-- Need to fix unique contraint issue
SELECT * FROM xwrl_alert_notes
WHERE trunc (creation_date) = trunc (SYSDATE);

DELETE FROM xwrl_alert_notes
WHERE trunc (creation_date) = trunc (SYSDATE);

