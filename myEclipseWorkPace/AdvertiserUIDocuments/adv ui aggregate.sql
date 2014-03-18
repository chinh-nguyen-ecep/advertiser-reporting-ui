insert into binh.wip_creatives_by_hour select * from binh.agg_creatives_by_hour;
DROP PROCEDURE IF EXISTS `sp_publish_creatives_by_hour`;
CREATE DEFINER = 'song'@'%' PROCEDURE `sp_publish_creatives_by_hour`()
    DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
    DECLARE max_period INT DEFAULT 0;
    
    -- Get min and max replicatered peiod 
    SELECT  MAX(period) INTO  max_period
    FROM   `agg_creatives_by_hour`;
	
	    -- Delete old data on same replicatered date
    DELETE FROM `agg_creatives_by_date` WHERE period BETWEEN max_period-6 AND max_period;
        
    -- Insert historical data from production
    INSERT INTO `agg_creatives_by_date` 
	select period,date,flight_id,creative_id,sum(clicks) as clicks , sum(impressions) as impressions , sum(cta_maps) as cta_maps 
	from `agg_creatives_by_hour` 
	where period BETWEEN max_period-6 AND max_period
	group by  period,date,flight_id,creative_id ;

END;

DROP PROCEDURE IF EXISTS `sp_publish_agg_creatives_by_hour`;

CREATE DEFINER = CURRENT_USER PROCEDURE `sp_publish_agg_creatives_by_hour`()
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
	DECLARE min_period INT DEFAULT 0;
	DECLARE max_period INT DEFAULT 0;
    
    -- Get min and max replicatered peiod 
    SELECT  MIN(period), MAX(period) INTO  min_period, max_period
    FROM   `wip_creatives_by_hour`;
    
    -- Delete old data on same replicatered date
    DELETE FROM `agg_creatives_by_hour` WHERE period BETWEEN min_period AND max_period;

	INSERT INTO `agg_creatives_by_hour` 
	SELECT a.`period`, a.`date`, a.`hour`, a.`flight_id`, a.`creative_id`
         , COALESCE(d.`adm_creative_id`, -1) as adm_creative_id
         , COALESCE(b.`adm_flight_id`, -1) as adm_flight_id
         , COALESCE(c.`adm_order_id`, -1) as adm_order_id
         , COALESCE(c.`adm_organization_id`, -1) as adm_organization_id
         , COALESCE(c.`adm_publisher_id`, -1) as adm_publisher_id
         , COALESCE(c.`adm_advertiser_id`, -1) as adm_advertiser_id
         , sum(a.`clicks`) as clicks
         , sum(a.`impressions`) as impressions
         , sum(a.`cta_maps`) as cta_maps 
	FROM `wip_creatives_by_hour` a
    LEFT JOIN `dim_flights` b ON b.`dfp_version` = 2 AND b.`dfp_flight_id` = a.`flight_id`
    LEFT JOIN `dim_orders` c ON c.`dfp_version` = 2 AND c.`adm_order_id` = b.`adm_order_id`
    LEFT JOIN `dim_creatives` d ON d.`dfp_version` = 2 AND d.`dfp_creative_id` = a.`creative_id`
	;
END;

drop table binh.agg_creatives_by_hour;
CREATE TABLE `agg_creatives_by_hour` (
  `period` INTEGER(11) NOT NULL,
  `date` DATE NOT NULL,
  `hour` INTEGER(11) NOT NULL,
  `flight_id` BIGINT(11) NOT NULL,
  `creative_id` BIGINT(11) NOT NULL,
  `adm_creative_id` BIGINT(11) NOT NULL,
  `adm_flight_id` BIGINT(11) NOT NULL,
  `adm_order_id` BIGINT(11) NOT NULL,
  `adm_organization_id` BIGINT(11) NOT NULL,
  `adm_publisher_id` BIGINT(11) NOT NULL,
  `adm_advertiser_id` BIGINT(11) NOT NULL,
  `clicks` INTEGER(11) NOT NULL,
  `impressions` INTEGER(11) NOT NULL,
  `cta_maps` INTEGER(11) DEFAULT NULL,
  KEY `idx_agg_creatives_by_hour_01` (`date`),
  KEY `idx_agg_creatives_by_hour_02` (`date`, `hour`),
  KEY `idx_agg_creatives_by_hour_03` (`date`, `hour`,`flight_id`),
  KEY `idx_agg_creatives_by_hour_04` (`date`, `hour`,`creative_id`),
  KEY `idx_agg_creatives_by_hour_05` (`date`, `hour`,`adm_creative_id`),
  KEY `idx_agg_creatives_by_hour_06` (`date`, `hour`,`adm_flight_id`),
  KEY `idx_agg_creatives_by_hour_07` (`date`, `hour`,`adm_order_id`),
  KEY `idx_agg_creatives_by_hour_08` (`date`, `hour`,`adm_organization_id`),
  KEY `idx_agg_creatives_by_hour_09` (`date`, `hour`,`adm_publisher_id`),
  KEY `idx_agg_creatives_by_hour_10` (`date`, `hour`,`adm_advertiser_id`)

)ENGINE=MyISAM
ROW_FORMAT=FIXED CHARACTER SET 'utf8' COLLATE 'utf8_general_ci';


drop table binh.agg_creatives_by_date;
CREATE TABLE `agg_creatives_by_date` (
  `period` INTEGER(11) NOT NULL,
  `date` DATE NOT NULL,
  `flight_id` BIGINT(11) NOT NULL,
  `creative_id` BIGINT(11) NOT NULL,
  `adm_creative_id` BIGINT(11) NOT NULL,
  `adm_flight_id` BIGINT(11) NOT NULL,
  `adm_order_id` BIGINT(11) NOT NULL,
  `adm_organization_id` BIGINT(11) NOT NULL,
  `adm_publisher_id` BIGINT(11) NOT NULL,
  `adm_advertiser_id` BIGINT(11) NOT NULL,
  `clicks` INTEGER(11) NOT NULL,
  `impressions` INTEGER(11) NOT NULL,
  `cta_maps` INTEGER(11) DEFAULT NULL,
  KEY `idx_agg_creatives_by_hour_01` (`date`),
  KEY `idx_agg_creatives_by_hour_02` (`date`,`flight_id`),
  KEY `idx_agg_creatives_by_hour_03` (`date`,`creative_id`),
  KEY `idx_agg_creatives_by_hour_04` (`date`,`adm_creative_id`),
  KEY `idx_agg_creatives_by_hour_05` (`date`,`adm_flight_id`),
  KEY `idx_agg_creatives_by_hour_06` (`date`,`adm_order_id`),
  KEY `idx_agg_creatives_by_hour_07` (`date`,`adm_organization_id`),
  KEY `idx_agg_creatives_by_hour_08` (`date`,`adm_publisher_id`),
  KEY `idx_agg_creatives_by_hour_09` (`date`,`adm_advertiser_id`)

)ENGINE=MyISAM
ROW_FORMAT=FIXED CHARACTER SET 'utf8' COLLATE 'utf8_general_ci';

call `sp_publish_agg_creatives_by_hour`;

DROP PROCEDURE IF EXISTS `sp_publish_agg_creatives_by_date`;

CREATE DEFINER = CURRENT_USER PROCEDURE `sp_publish_agg_creatives_by_date`()
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
	DECLARE min_period INT DEFAULT 0;
	DECLARE max_period INT DEFAULT 0;
    
    -- Get min and max replicatered peiod 
    SELECT  MIN(period), MAX(period) INTO  min_period, max_period
    FROM   `wip_creatives_by_hour`;
    
    -- Delete old data on same replicatered date
    DELETE FROM `agg_creatives_by_date` WHERE period BETWEEN min_period AND max_period;

	INSERT INTO `agg_creatives_by_date` 
	SELECT a.`period`, a.`date`, a.`flight_id`, a.`creative_id`
         , COALESCE(d.`adm_creative_id`, -1) as adm_creative_id
         , COALESCE(b.`adm_flight_id`, -1) as adm_flight_id
         , COALESCE(c.`adm_order_id`, -1) as adm_order_id
         , COALESCE(c.`adm_organization_id`, -1) as adm_organization_id
         , COALESCE(c.`adm_publisher_id`, -1) as adm_publisher_id
         , COALESCE(c.`adm_advertiser_id`, -1) as adm_advertiser_id
         , sum(a.`clicks`) as clicks
         , sum(a.`impressions`) as impressions
         , sum(a.`cta_maps`) as cta_maps 
	FROM `wip_creatives_by_hour` a
    LEFT JOIN `dim_flights` b ON b.`dfp_version` = 2 AND b.`dfp_flight_id` = a.`flight_id`
    LEFT JOIN `dim_orders` c ON c.`dfp_version` = 2 AND c.`adm_order_id` = b.`adm_order_id`
    LEFT JOIN `dim_creatives` d ON d.`dfp_version` = 2 AND d.`dfp_creative_id` = a.`creative_id`
    GROUP BY a.`period`, a.`date`, a.`flight_id`, a.`creative_id`
         , COALESCE(d.`adm_creative_id`, -1)
         , COALESCE(b.`adm_flight_id`, -1)
         , COALESCE(c.`adm_order_id`, -1)
         , COALESCE(c.`adm_organization_id`, -1)
         , COALESCE(c.`adm_publisher_id`, -1)
         , COALESCE(c.`adm_advertiser_id`, -1)
	;
END;

INSERT INTO `agg_creatives_by_hour` 
	SELECT a.`period`, a.`date`, a.`hour`, a.`flight_id`, a.`creative_id`
         , COALESCE(d.`adm_creative_id`, -1) as adm_creative_id
         , COALESCE(b.`adm_flight_id`, -1) as adm_flight_id
         , COALESCE(c.`adm_order_id`, -1) as adm_order_id
         , COALESCE(c.`adm_organization_id`, -1) as adm_organization_id
         , COALESCE(c.`adm_publisher_id`, -1) as adm_publisher_id
         , COALESCE(c.`adm_advertiser_id`, -1) as adm_advertiser_id
         , sum(a.`clicks`) as clicks
         , sum(a.`impressions`) as impressions
         , sum(a.`cta_maps`) as cta_maps 
	FROM `wip_creatives_by_hour` a
    LEFT JOIN `dim_flights` b ON b.`dfp_version` = 2 AND b.`dfp_flight_id` = a.`flight_id`
    LEFT JOIN `dim_orders` c ON c.`dfp_version` = 2 AND c.`adm_order_id` = b.`adm_order_id`
    LEFT JOIN `dim_creatives` d ON d.`dfp_version` = 2 AND d.`dfp_creative_id` = a.`creative_id`
    WHERE period BETWEEN 3265 AND 3265
	;
3104