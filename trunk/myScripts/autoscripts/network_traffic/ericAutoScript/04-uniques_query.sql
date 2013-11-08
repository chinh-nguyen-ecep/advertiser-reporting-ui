SELECT pv.user_agent_sk as ua_sk, ua.user_agent_name, views, uniques, uniques::float / views as ratio
FROM emj_agent_uniques pv
INNER JOIN user_agent_dim ua ON pv.user_agent_sk = ua.user_agent_sk
WHERE ua.organic = 'f' and ua.auto_generated = 'f'
AND views > 1000 /*AND uniques::float / views > 0.75*/
ORDER BY uniques::float /views desc;
