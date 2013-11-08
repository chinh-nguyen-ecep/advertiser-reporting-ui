require "utils.pl";
my @aggTableDw1=();

push(@aggTableDw1,"dw.daily_agg_ap_module_breakdown");
push(@aggTableDw1,"dw.daily_agg_group_act_all");
push(@aggTableDw1,"dw.daily_agg_group_portal_act_all");
push(@aggTableDw1,"dw.daily_agg_network_act_all");
push(@aggTableDw1,"dw.daily_agg_partner_act_all");
push(@aggTableDw1,"dw.daily_agg_partner_act_cont_mod_type");
push(@aggTableDw1,"dw.daily_agg_partner_act_content_category");
push(@aggTableDw1,"dw.daily_agg_partner_act_content_module");
push(@aggTableDw1,"dw.daily_agg_partner_act_date");
push(@aggTableDw1,"dw.daily_agg_partner_act_day_of_week");
push(@aggTableDw1,"dw.daily_agg_partner_act_device");
push(@aggTableDw1,"dw.daily_agg_partner_act_hour");
push(@aggTableDw1,"dw.daily_agg_partner_act_portal");
push(@aggTableDw1,"dw.daily_agg_portal_act_all");
push(@aggTableDw1,"dw.daily_agg_site_traffic");
push(@aggTableDw1,"dw.daily_agg_site_traffic_historical");
my @aggTableDw3=();
push(@aggTableDw3,"adm.daily_agg_adm_data_feed");
push(@aggTableDw3,"adm.daily_agg_order_atc");
push(@aggTableDw3,"adm.daily_agg_order_placement_creative_flight");
push(@aggTableDw3,"adm.daily_agg_publisher_website_partner");
push(@aggTableDw3,"adm.daily_agg_revenue_by_order");

push(@aggTableDw3,"adstraffic.daily_ad_serving_stats");
push(@aggTableDw3,"adstraffic.daily_ad_serving_stats_by_content_category");
push(@aggTableDw3,"adstraffic.daily_ad_serving_stats_by_device");
push(@aggTableDw3,"adstraffic.daily_adcel_stats");
push(@aggTableDw3,"adstraffic.daily_db_sellthrough_by_metro");
push(@aggTableDw3,"adstraffic.daily_db_sellthrough_by_site");
#push(@aggTableDw3,"adstraffic.daily_location_stats_by_metro");
#push(@aggTableDw3,"adstraffic.daily_location_stats_by_region");

#push(@aggTableDw3,"dbclk.daily_agg_adm_creative");
#push(@aggTableDw3,"dbclk.daily_agg_adm_creative_delivery");
push(@aggTableDw3,"dbclk.daily_agg_campaign");
#push(@aggTableDw3,"dbclk.daily_agg_publisher_device");
push(@aggTableDw3,"dbclk.daily_agg_publishers_day");
push(@aggTableDw3,"dbclk.daily_agg_site_campaign_day");
push(@aggTableDw3,"dbclk.daily_agg_site_day");
push(@aggTableDw3,"dbclk.daily_agg_site_order");
#push(@aggTableDw3,"dbclk.daily_order_count_site");

push(@aggTableDw3,"adsense.daily_site_performance");
push(@aggTableDw3,"jumptap.daily_publisher_performance");
push(@aggTableDw3,"millenial.daily_site_performance");
push(@aggTableDw3,"marchex.daily_site_performance");
push(@aggTableDw3,"adwhere.daily_partner_performance");
foreach $table(@aggTableDw1){
	print getReportName($table)."\n";
}
foreach $table(@aggTableDw3){
	print getReportName($table)."\n";
}