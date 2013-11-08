#!/bin/sh

mysql -u regwriter -h db2 --password=$1 -B clientreg <<EOSQL
SELECT concat('UPDATE user_agent_dim SET device_manufacturer = ''Associated Press'', device_type = ''iPad MNN Client'', auto_generated = ''f'', organic = ''t'' WHERE auto_generated = ''t'' AND device_type = ''Unallocated'' AND lower(user_agent_name) LIKE ''', lower(a.app_key), ':', lower(v.version), ':%'';') AS \`-- AP iPad\`
FROM version v JOIN app a ON v.app_id = a.id
WHERE a.id in (46, 425)
UNION

SELECT concat('UPDATE user_agent_dim SET device_manufacturer = ''Associated Press'', device_type = ''iPhone MNN Client'', auto_generated = ''f'', organic = ''t'' WHERE auto_generated = ''t'' AND device_type = ''Unallocated'' AND lower(user_agent_name) LIKE ''', lower(a.app_key), ':', lower(v.version), ':%'';') AS \`-- AP iPhone\`
FROM version v JOIN app a ON v.app_id = a.id
WHERE a.id in (1, 11)
UNION

SELECT concat('UPDATE user_agent_dim SET device_manufacturer = ''Associated Press'', device_type = ''Android MNN Client'', auto_generated = ''f'', organic = ''t'' WHERE auto_generated = ''t'' AND device_type = ''Unallocated'' AND lower(user_agent_name) LIKE ''', lower(a.app_key), ':', lower(v.version), ':%'';') AS \`-- AP Android\`
FROM version v JOIN app a ON v.app_id = a.id
WHERE a.id = 9
UNION

SELECT concat('UPDATE user_agent_dim SET device_manufacturer = ''Associated Press'', device_type = ''BlackBerry MNN Client'', auto_generated = ''f'', organic = ''t'' WHERE auto_generated = ''t'' AND device_type = ''Unallocated'' AND lower(user_agent_name) LIKE ''', lower(a.app_key), ':', lower(v.version), ':%'';') AS \`-- AP BlackBerry\`
FROM version v JOIN app a ON v.app_id = a.id
WHERE a.id = 44
UNION

SELECT concat('UPDATE user_agent_dim SET device_manufacturer = ''Associated Press'', device_type = ''Freerange MNN Client'', auto_generated = ''f'', organic = ''t'' WHERE auto_generated = ''t'' AND device_type = ''Unallocated'' AND lower(user_agent_name) LIKE ''', lower(a.app_key), ':', lower(v.version), ':%'';') AS \`-- AP Freerange\`
FROM version v JOIN app a ON v.app_id = a.id
WHERE a.id in (2, 3, 4, 10, 14) AND v.version <> '2.5.6'
UNION

SELECT concat('UPDATE user_agent_dim SET device_manufacturer = ''Associated Press'', device_type = ''Nokia WRT Widget (Pre-Installed)'', auto_generated = ''f'', organic = ''t'' WHERE auto_generated = ''t'' AND device_type = ''Unallocated'' AND lower(user_agent_name) LIKE ''', lower(a.app_key), ':', lower(v.version), ':%'';') AS \`-- AP Nokia WRT\`
FROM version v JOIN app a ON v.app_id = a.id
WHERE a.id = 5 AND lower(v.version) LIKE '%pre%'
UNION

SELECT concat('UPDATE user_agent_dim SET device_manufacturer = ''Associated Press'', device_type = ''Nokia WRT Widget'', auto_generated = ''f'', organic = ''t'' WHERE auto_generated = ''t'' AND device_type = ''Unallocated'' AND lower(user_agent_name) LIKE ''', lower(a.app_key), ':', lower(v.version), ':%'';') AS \`-- AP Nokia WRT\`
FROM version v JOIN app a ON v.app_id = a.id
WHERE a.id = 5 AND lower(v.version) NOT LIKE '%pre%'
UNION

SELECT concat('UPDATE user_agent_dim SET device_manufacturer = ''Associated Press'', device_type = ''Palm WebOS Widget'', auto_generated = ''f'', organic = ''t'' WHERE auto_generated = ''t'' AND device_type = ''Unallocated'' AND lower(user_agent_name) LIKE ''', lower(a.app_key), ':', lower(v.version), ':%'';') AS \`-- AP Palm WebOS\`
FROM version v JOIN app a ON v.app_id = a.id
WHERE a.id = 8
UNION

SELECT concat('UPDATE user_agent_dim SET device_manufacturer = ''Associated Press'', device_type = ''Windows Mobile MNN Client'', auto_generated = ''f'', organic = ''t'' WHERE auto_generated = ''t'' AND device_type = ''Unallocated'' AND lower(user_agent_name) LIKE ''', lower(a.app_key), ':', lower(v.version), ':%'';') AS \`-- AP Windows Mobile\`
FROM version v JOIN app a ON v.app_id = a.id
WHERE a.id = 51
UNION

SELECT concat('UPDATE user_agent_dim SET device_manufacturer = ''Associated Press'', device_type = ''Samsung Bada MNN Client'', auto_generated = ''f'', organic = ''t'' WHERE auto_generated = ''t'' AND device_type = ''Unallocated'' AND lower(user_agent_name) LIKE ''', lower(a.app_key), ':', lower(v.version), ':%'';') AS \`-- AP Samsung Bada\`
FROM version v JOIN app a ON v.app_id = a.id
WHERE a.id = 59
UNION

SELECT concat('UPDATE user_agent_dim SET device_manufacturer = ''Associated Press'', device_type = ''MeeGo MNN Client'', auto_generated = ''f'', organic = ''t'' WHERE auto_generated = ''t'' AND device_type = ''Unallocated'' AND lower(user_agent_name) LIKE ''', lower(a.app_key), ':', lower(v.version), ':%'';') AS \`-- AP MeeGo\`
FROM version v JOIN app a ON v.app_id = a.id
WHERE a.id = 104
UNION

SELECT concat('UPDATE user_agent_dim SET device_manufacturer = ''Associated Press'', device_type = ''Windows Phone 7 MNN Client'', auto_generated = ''f'', organic = ''t'' WHERE auto_generated = ''t'' AND device_type = ''Unallocated'' AND lower(user_agent_name) LIKE ''', lower(a.app_key), ':', lower(v.version), ':%'';') AS \`-- AP WP7\`
FROM version v JOIN app a ON v.app_id = a.id
WHERE a.id = 70
UNION

SELECT concat('UPDATE user_agent_dim SET device_manufacturer = ''Canadian Press'', device_type = ''iPad MNN Client'', auto_generated = ''f'', organic = ''t'' WHERE auto_generated = ''t'' AND device_type = ''Unallocated'' AND lower(user_agent_name) LIKE ''', lower(a.app_key), ':', lower(v.version), ':%'';') AS \`-- CP iPad\`
FROM version v JOIN app a ON v.app_id = a.id
WHERE a.id = 75
UNION

SELECT concat('UPDATE user_agent_dim SET device_manufacturer = ''Canadian Press'', device_type = ''Freerange MNN Client'', auto_generated = ''f'', organic = ''t'' WHERE auto_generated = ''t'' AND device_type = ''Unallocated'' AND lower(user_agent_name) LIKE ''', lower(a.app_key), ':', lower(v.version), ':%'';') AS \`-- CP Freerange\`
FROM version v JOIN app a ON v.app_id = a.id
WHERE a.id in (6, 7) AND v.version <> '2.5.6'
UNION

SELECT concat('UPDATE user_agent_dim SET device_manufacturer = ''Canadian Press'', device_type = ''BlackBerry MNN Client'', auto_generated = ''f'', organic = ''t'' WHERE auto_generated = ''t'' AND device_type = ''Unallocated'' AND lower(user_agent_name) LIKE ''', lower(a.app_key), ':', lower(v.version), ':%'';') AS \`-- CP BlackBerry\`
FROM version v JOIN app a ON v.app_id = a.id
WHERE a.id IN (100, 101)
UNION

SELECT concat('UPDATE user_agent_dim SET device_manufacturer = ''Canadian Press'', device_type = ''iPhone MNN Client'', auto_generated = ''f'', organic = ''t'' WHERE auto_generated = ''t'' AND device_type = ''Unallocated'' AND lower(user_agent_name) LIKE ''', lower(a.app_key), ':', lower(v.version), ':%'';') AS \`-- CP iPhone\`
FROM version v JOIN app a ON v.app_id = a.id
WHERE a.id = 12
UNION

SELECT concat('UPDATE user_agent_dim SET device_manufacturer = ''Canadian Press'', device_type = ''Palm WebOS Widget'', auto_generated = ''f'', organic = ''t'' WHERE auto_generated = ''t'' AND device_type = ''Unallocated'' AND lower(user_agent_name) LIKE ''', lower(a.app_key), ':', lower(v.version), ':%'';') AS \`-- CP Palm WebOS\`
FROM version v JOIN app a ON v.app_id = a.id
WHERE a.id = 17
UNION

SELECT concat('UPDATE user_agent_dim SET device_manufacturer = ''Canadian Press'', device_type = ''Android MNN Client'', auto_generated = ''f'', organic = ''t'' WHERE auto_generated = ''t'' AND device_type = ''Unallocated'' AND lower(user_agent_name) LIKE ''', lower(a.app_key), ':', lower(v.version), ':%'';') AS \`-- CP Android\`
FROM version v JOIN app a ON v.app_id = a.id
WHERE a.id = 18
UNION

SELECT concat('UPDATE user_agent_dim SET device_manufacturer = ''Verve Wireless'', device_type = ''Nokia WRT Widget (Pre-Installed)'', auto_generated = ''f'', organic = ''t'' WHERE auto_generated = ''t'' AND device_type = ''Unallocated'' AND lower(user_agent_name) LIKE ''', lower(a.app_key), ':', lower(v.version), ':%'';')
FROM version v JOIN app a ON v.app_id = a.id
WHERE a.description NOT LIKE 'AP %' AND a.description NOT LIKE 'CP %' AND a.platform = 'Nokia Web Run-Time' AND lower(v.version) LIKE '%pre%'
UNION

SELECT concat('UPDATE user_agent_dim SET device_manufacturer = ''Verve Wireless'', device_type = ''Nokia WRT Widget'', auto_generated = ''f'', organic = ''t'' WHERE auto_generated = ''t'' AND device_type = ''Unallocated'' AND lower(user_agent_name) LIKE ''', lower(a.app_key), ':', lower(v.version), ':%'';')
FROM version v JOIN app a ON v.app_id = a.id
WHERE a.description NOT LIKE 'AP %' AND a.description NOT LIKE 'CP %' AND a.platform = 'Nokia Web Run-Time' AND lower(v.version) NOT LIKE '%pre%'
UNION

SELECT concat('UPDATE user_agent_dim SET device_manufacturer = ''Verve Wireless'', device_type = ''Verve iPad Client'', auto_generated = ''f'', organic = ''t'' WHERE auto_generated = ''t'' AND device_type = ''Unallocated'' AND lower(user_agent_name) LIKE ''', lower(a.app_key), ':', lower(v.version), ':%'';')
FROM version v JOIN app a ON v.app_id = a.id
WHERE a.description NOT LIKE 'AP %' AND a.description NOT LIKE 'CP %' AND a.app_key NOT LIKE '%npgco%' AND a.app_key NOT LIKE '%chaione%' AND a.platform = 'Apple iPad'
UNION

SELECT concat('UPDATE user_agent_dim SET device_manufacturer = ''Verve Wireless'', device_type = ''Verve iPhone Client'', auto_generated = ''f'', organic = ''t'' WHERE auto_generated = ''t'' AND device_type = ''Unallocated'' AND lower(user_agent_name) LIKE ''', lower(a.app_key), ':', lower(v.version), ':%'';')
FROM version v JOIN app a ON v.app_id = a.id
WHERE a.description NOT LIKE 'AP %' AND a.description NOT LIKE 'CP %' AND a.app_key NOT LIKE '%npgco%' AND a.app_key NOT LIKE '%chaione%' AND a.platform = 'Apple iPhone'
UNION

SELECT concat('UPDATE user_agent_dim SET device_manufacturer = ''Verve Wireless'', device_type = ''iPhoneOS Framework'', auto_generated = ''f'', organic = ''t'' WHERE auto_generated = ''t'' AND device_type = ''Unallocated'' AND lower(user_agent_name) LIKE ''', lower(a.app_key), ':', lower(v.version), ':%'';')
FROM version v JOIN app a ON v.app_id = a.id
WHERE a.app_key LIKE '%npgco%' OR a.app_key like '%chaione%' AND a.platform = 'Apple iPhone'
UNION

SELECT concat('UPDATE user_agent_dim SET device_manufacturer = ''Verve Wireless'', device_type = ''Verve BlackBerry Client'', auto_generated = ''f'', organic = ''t'' WHERE auto_generated = ''t'' AND device_type = ''Unallocated'' AND lower(user_agent_name) LIKE ''', lower(a.app_key), ':', lower(v.version), ':%'';')
FROM version v JOIN app a ON v.app_id = a.id
WHERE a.description NOT LIKE 'AP %' AND a.description NOT LIKE 'CP %' AND a.platform = 'BlackBerry'
UNION

SELECT concat('UPDATE user_agent_dim SET device_manufacturer = ''Verve Wireless'', device_type = ''Verve Android Client'', auto_generated = ''f'', organic = ''t'' WHERE auto_generated = ''t'' AND device_type = ''Unallocated'' AND lower(user_agent_name) LIKE ''', lower(a.app_key), ':', lower(v.version), ':%'';')
FROM version v JOIN app a ON v.app_id = a.id
WHERE a.description NOT LIKE 'AP %' AND a.description NOT LIKE 'CP %' AND a.platform = 'Android'
EOSQL
