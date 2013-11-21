COPY (SELECT * FROM refer.portal_dim) TO '/opt/temp/portal_dim.csv' WITH DELIMITER '|' CSV QUOTE '"';
COPY (SELECT * FROM refer.partner_dim) TO '/opt/temp/partner_dim.csv' WITH DELIMITER '|' CSV QUOTE '"';
COPY (SELECT * FROM refer.date_dim) TO '/opt/temp/date_dim.csv' WITH DELIMITER '|' CSV QUOTE '"';
COPY (SELECT * FROM adnetwork.mapping_mm) TO '/opt/temp/mapping_mm.csv' WITH DELIMITER '|' CSV QUOTE '"';
add jar /usr/local/hive/lib/jackson-core-asl-1.8.8.jar;
add jar /usr/local/hive/lib/jackson-jaxrs-1.8.8.jar;
add jar /usr/local/hive/lib/jackson-mapper-asl-1.8.8.jar;
add jar /usr/local/hive/lib/jackson-xc-1.8.8.jar;
-- Portal dim
DROP TABLE IF EXISTS portal_dim;
CREATE EXTERNAL TABLE IF NOT EXISTS portal_dim(
 portal_sk BIGINT,
 portal_id INT,
 portal_name STRING,
 description STRING,
 default_partner_id INT,
 single_partner INT,
 ondeck STRING,
 auto_generated STRING,
 suppress STRING,
 data_file_id INT,
 dt_effective STRING,
 dt_expire STRING,
 portal_name_current STRING,
 description_current STRING,
 keyword STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION 'hdfs://ecep1:9000/user/hive/warehouse/dims/portal_dim';

SELECT portal_id,portal_name,single_partner,portal_name_current,keyword FROM portal_dim WHERE to_date(dt_expire)>=to_date('9999-12-31') AND portal_id>0;

-- partner dim
DROP TABLE IF EXISTS partner_dim;
CREATE EXTERNAL TABLE IF NOT EXISTS partner_dim(
partner_sk BIGINT,
partner_id INT,
name STRING,
description STRING,
locale STRING,
time_zone_id STRING,
keyword STRING,
msa_id INT,
msa_name STRING,
msa_is_metro smallint,
dtactive STRING,
dtinactive STRING,
is_published smallint,
dtdeleted STRING,
parent1_id INT,
parent1_type STRING,
parent1_name STRING,
parent2_id INT,
parent2_type STRING,
parent2_name STRING,
parent3_id INT,
parent3_type STRING,
parent3_name STRING,
auto_generated boolean,
suppress boolean,
data_file_id INT,
dt_effective STRING,
dt_expire STRING,
name_current STRING,
description_current STRING,
parent1_id_current INT,
parent1_type_current STRING,
parent1_name_current STRING,
partner_postal_code STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION 'hdfs://ecep1:9000/user/hive/warehouse/dims/partner_dim';

SELECT * FROM partner_dim WHERE to_date(dt_expire)>=to_date('9999-12-31') AND partner_id>0;

-- date dim
CREATE EXTERNAL TABLE IF NOT EXISTS date_dim(
date_sk INT,
full_date STRING,
day_since_2005 smallint,
month_since_2005 smallint,
day_of_week STRING,
calendar_month STRING,
calendar_year smallint,
calendar_year_month STRING,
day_of_month smallint,
day_of_year smallint,
week_of_year_sunday smallint,
year_week_sunday STRING,
week_sunday_start STRING,
week_of_year_monday smallint,
year_week_monday STRING,
week_monday_start STRING,
holiday STRING,
day_type STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION 'hdfs://ecep1:9000/user/hive/warehouse/dims/date_dim';

-- Mapping mm
CREATE EXTERNAL TABLE IF NOT EXISTS mapping_mm(
 current_millennial_media_name STRING,
 partner_keyword STRING,
 partner_id INT,
 partner_name STRING,
 group_id INT,
 group_name STRING,
 portal_id INT,
 portal_name STRING,
 new_millennial_media_name STRING,
 note STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION 'hdfs://ecep1:9000/user/hive/warehouse/dims/mapping_mm';