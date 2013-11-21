add jar /usr/local/hive/lib/csv-serde-1.1.2.jar;
add jar /usr/local/hive/lib/jackson-core-asl-1.8.8.jar;
add jar /usr/local/hive/lib/jackson-jaxrs-1.8.8.jar;
add jar /usr/local/hive/lib/jackson-mapper-asl-1.8.8.jar;
add jar /usr/local/hive/lib/jackson-xc-1.8.8.jar;


DROP TABLE IF EXISTS daily_millenial_log;
CREATE EXTERNAL TABLE IF NOT EXISTS daily_millenial_log(
id BIGINT,
name STRING,
`date` STRING,
requests BIGINT,
ads_served BIGINT,
fill_rate_percentage DOUBLE,
clicks INT,
click_thru_rate_percentage DOUBLE,
net_revenue DOUBLE,
net_ecpm DOUBLE
)
row format serde 'com.bizo.hive.serde.csv.CSVSerde'
STORED AS TEXTFILE
LOCATION 'hdfs://ecep1:9000/user/hive/warehouse/logs/daily_millenial_log';

DROP TABLE IF EXISTS gen_millenial_performance;
CREATE EXTERNAL TABLE IF NOT EXISTS gen_millenial_performance(
gen_millenial_performance_id INT,
id STRING,
name STRING,
report_date STRING,
requests STRING,
ads_served STRING,
fill_rate_percentage STRING,
clicks STRING,
click_thru_rate_percentage STRING,
net_revenue STRING,
net_ecpm STRING,
data_file_id INT,
dt_lastchanged STRING,
eastern_date STRING,
eastern_time STRING,
local_date STRING,
local_time STRING,
gmt_date STRING,
gmt_time STRING,
response_date_pacific STRING,
eastern_date_sk INT,
eastern_time_sk INT,
local_date_sk INT,
local_time_sk INT,
gmt_date_sk INT,
gmt_time_sk INT,
partner_sk INT,
portal_sk INT,
partner_keyword STRING,
portal_keyword STRING
)
STORED AS TEXTFILE
LOCATION 'hdfs://ecep1:9000/user/hive/warehouse/staging/gen_millenial_performance/';

DROP TABLE IF EXISTS gen_millenial_performance_1;
CREATE TABLE gen_millenial_performance_1
LIKE gen_millenial_performance
LOCATION 'hdfs://ecep1:9000/user/hive/warehouse/staging/gen_millenial_performance_1/';

-- Load data from log file to staging gen_millenial_performance
INSERT OVERWRITE TABLE gen_millenial_performance 
SELECT 
-100,
id,
name,
`date`,
requests,
ads_served,
fill_rate_percentage,
clicks,
click_thru_rate_percentage,
net_revenue,
net_ecpm,
-100,
unix_timestamp(), 
from_unixtime(unix_timestamp(from_utc_timestamp(to_utc_timestamp(from_unixtime(unix_timestamp(`date`, "yyyy-MM-dd HH:mm:ss.S"), 'yyyy-MM-dd HH:00:00'), 'GMT'), 'America/New_York')), 'yyyy-MM-dd') AS eastern_date, 
from_unixtime(unix_timestamp(from_utc_timestamp(to_utc_timestamp(from_unixtime(unix_timestamp(`date`, "yyyy-MM-dd HH:mm:ss.S"), 'yyyy-MM-dd HH:00:00'), 'GMT'), 'America/New_York')), 'HH:mm:ss') AS eastern_time, 
from_unixtime(unix_timestamp(`date`, "yyyy-MM-dd HH:mm:ss.S"), 'yyyy-MM-dd') AS local_date,
from_unixtime(unix_timestamp(`date`, "yyyy-MM-dd HH:mm:ss.S"), 'HH:mm:ss') AS local_time,
from_unixtime(unix_timestamp(from_utc_timestamp(to_utc_timestamp(from_unixtime(unix_timestamp(`date`, "yyyy-MM-dd HH:mm:ss.S"), 'yyyy-MM-dd HH:00:00'), 'GMT'), 'UTC')), 'yyyy-MM-dd') AS gmt_date, 
from_unixtime(unix_timestamp(from_utc_timestamp(to_utc_timestamp(from_unixtime(unix_timestamp(`date`, "yyyy-MM-dd HH:mm:ss.S"), 'yyyy-MM-dd HH:00:00'), 'GMT'), 'UTC')), 'HH:mm:ss') AS gmt_time,
from_unixtime(unix_timestamp(from_utc_timestamp(to_utc_timestamp(from_unixtime(unix_timestamp(`date`, "yyyy-MM-dd HH:mm:ss.S"), 'yyyy-MM-dd HH:00:00'), 'GMT'), 'America/Los_Angeles')), 'yyyy-MM-dd') AS response_date_pacific, 
-100,
-100,
-100,
-100,
-100,
-100,
b.partner_sk,
b.portal_sk,
split(name,'_')[0] AS partner_keyword,
split(name,'_')[1] AS portal_keyword
FROM daily_millenial_log a
LEFT OUTER JOIN
(
   SELECT aa.current_millennial_media_name, bb.partner_sk, cc.portal_sk
   FROM mapping_mm aa
   INNER JOIN partner_dim bb ON bb.partner_id = aa.partner_id AND to_date(bb.dt_expire)>=to_date('9999-12-31')
   INNER JOIN portal_dim cc ON cc.portal_id = aa.portal_id AND to_date(cc.dt_expire)>=to_date('9999-12-31')
)b ON (a.name=b.current_millennial_media_name);

-- Load to gen_millenial_performance_1
INSERT OVERWRITE TABLE gen_millenial_performance_1 
SELECT 
a.gen_millenial_performance_id,
a.id,
a.name,
report_date,
requests,
ads_served,
fill_rate_percentage,
clicks,
click_thru_rate_percentage,
net_revenue,
net_ecpm,
a.data_file_id,
dt_lastchanged,
a.eastern_date,
a.eastern_time,
local_date,
local_time,
gmt_date,
gmt_time,
a.response_date_pacific,
b.date_sk AS eastern_date_sk,
eastern_time_sk,
local_date_sk,
local_time_sk,
gmt_date_sk,
gmt_time_sk,
COALESCE(c.partner_sk,-2) AS partner_sk,
COALESCE(d.portal_sk,-2) AS portal_sk,
a.partner_keyword,
a.portal_keyword
FROM gen_millenial_performance a
JOIN date_dim b JOIN partner_dim c JOIN portal_dim d
WHERE a.eastern_date=b.full_date
AND a.partner_keyword=c.keyword 
AND a.portal_keyword=d.keyword
AND to_date(a.response_date_pacific) >= COALESCE(to_date(c.dt_effective),to_date('2007-10-28')) 
AND to_date(a.response_date_pacific)<=COALESCE(to_date(c.dt_expire),to_date('9999-12-31'))
AND to_date(a.response_date_pacific) >= COALESCE(to_date(d.dt_effective),to_date('2007-10-28')) 
AND to_date(a.response_date_pacific)<=COALESCE(to_date(d.dt_expire),to_date('9999-12-31'))

SELECT 
date_dim.date_sk AS eastern_date_sk,
eastern_time_sk,
local_date_sk,
local_time_sk,
gmt_date_sk,
gmt_time_sk,
COALESCE(partner_dim.partner_sk,-2) AS partner_sk,
-100 AS portal_sk,
gen_millenial_performance.partner_keyword,
gen_millenial_performance.portal_keyword
FROM gen_millenial_performance 
JOIN date_dim JOIN partner_dim 
WHERE (gen_millenial_performance.eastern_date=date_dim.full_date)
AND (to_date(gen_millenial_performance.response_date_pacific) > to_date(partner_dim.dt_effective) AND gen_millenial_performance.partner_keyword=partner_dim.keyword)

