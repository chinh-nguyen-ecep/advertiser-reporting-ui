CREATE TABLE emj_agent_uniques AS
SELECT pv.user_agent_sk, SUM(pv.page_view_count) AS views, COUNT(DISTINCT pv.uid) AS uniques
FROM page_view_fact pv
WHERE pv.request_type_sk = 1
AND pv.eastern_date_sk BETWEEN 2617 AND 2647
GROUP BY pv.user_agent_sk
