require "utils.pl";

my $date=yesterday();
my $date2=yesterday2();
my $resultHTML="";
my $emailTitle="";
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

push(@aggTableDw3,"adnetwork.daily_mm_performance");
push(@aggTableDw3,"adnetwork.daily_jt_performance");
#push(@aggTableDw3,"adnetwork.daily_ga_performance");
push(@aggTableDw3,"adnetwork.daily_wh_performance");
push(@aggTableDw3,"adnetwork.daily_mx_performance");
push(@aggTableDw3,"adnetwork.daily_adsense_dbclk_channel");
push(@aggTableDw3,"adnetwork.daily_cg_performance");
push(@aggTableDw3,"adnetwork.daily_it_performance");
#push(@aggTableDw3,"adnetwork.daily_sp_performance");
push(@aggTableDw3,"adnetwork.daily_sp_blue_performance");
push(@aggTableDw3,"adnetwork.daily_yp_performance");


push(@aggTableDw3,"evttracker.daily_event_stats");
push(@aggTableDw3,"evttracker.daily_event_stats_by_hour");

my $time=getTime();
$resultHTML=$resultHTML."Report time: $time<p />";
$resultHTML=$resultHTML."<h1>Agg data on dw1 on date: $date2 </h1><p />";
$resultHTML=$resultHTML."<table border=1 cellpadding=0>
	<thead>
		<tr>
		<th width=130>Count data rows</th>
		<th width=300>Agg table</th>
		<th width=300>Reporting</th>
		</tr>
	</thead>
	<tbody>";
	#Create connection
	my $dbh = getConnectionDw1();
	foreach $table(@aggTableDw1){
		my $query="SELECT count(full_date) as rows FROM $table WHERE is_active=true AND full_date='$date2'";
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute();
		$query_handle->bind_columns(undef, \$rows);
		# LOOP THROUGH RESULTS
		while($query_handle->fetch()) {
		  my $reporting=getReportName($table);
		  print "$rows \t $table\n";
		  $resultHTML=$resultHTML."<tr><td>$rows</td><td>$table</td><td>$reporting</td></tr>"
		} 
		
	}
	#disconnect database		
	my $rv = $dbh->disconnect;	

$resultHTML=$resultHTML."</tbody></table>";

#get status on dw3
$resultText=$resultText."Agg data on dw3 on date: $date\nCount data rows \t Agg table\n";
$resultHTML=$resultHTML."<h1>Agg data on dw3 on date: $date </h1></p>";
$resultHTML=$resultHTML."<table border=1 cellpadding=0>
	<thead>
		<tr>
		<th width=130>Count data rows</th>
		<th width=300>Agg table</th>
		<th width=300>Reporting</th>
		</tr>
	</thead>
	<tbody>";
	#Create connection
	my $dbh = getConnectionDw3();
	foreach $table(@aggTableDw3){
		my $query="SELECT count(full_date) as rows FROM $table WHERE is_active=true AND full_date='$date'";
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute();
		$query_handle->bind_columns(undef, \$rows);
		# LOOP THROUGH RESULTS
		while($query_handle->fetch()) {
		  print "$rows \t $table\n";
		  my $reporting=getReportName($table);
		  $resultHTML=$resultHTML."<tr><td>$rows</td><td>$table</td><td>$reporting</td></tr>"
		} 		
	}
	#disconnect database		
	my $rv = $dbh->disconnect;

$resultHTML=$resultHTML."</tbody></table>";
$mailto="song.nguyen\@ecepvn.org";
sendMail($mailto,"[Notification!][Check Agg data status][$date]","$resultHTML.<p />Thanks,<br />Auto send mail.");





