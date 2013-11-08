require "../bin/dw_utils.pl";
require "config.pl";
	note("*Host run ETL:$host \n*Master host:$master_host \n*Master report host:$master_report_host\n");
	getDateSk();
	main();
	#transferFinalReportsToMasterHost();
	#transferEventAggForOlap();
sub main{
	
	my $group_process_name="Event Tracker";	#the name of group process to register to daily process status table
	register_process($today_date,$group_process_name,31,'00:40:00','00:50:00');
	register_process($today_date,$group_process_name,56,'00:40:00','00:50:00');
	register_process($today_date,$group_process_name,32,'00:40:00','00:50:00');
	register_process($today_date,$group_process_name,57,'00:40:00','00:50:00');
	register_process($today_date,$group_process_name,58,'00:40:00','00:50:00');
	register_process($today_date,$group_process_name,59,'00:40:00','00:50:00');
	register_process($today_date,$group_process_name,25,'00:40:00','00:50:00');
	note("###### STEP 0: CHECK ADCEL AND EVENT FILES WAS LOADED #######");
	checkAdcelFiles();
	checkEventFiles();
	note("###### STEP 1: RESOLVE MISSING USER AGENT AND EVENT #######");
	resolveMissingUserAgentAndEvent();
	note("################## STEP 2: COPY INDAY DATA ##################");
	copyIndayData();
	note("################## STEP 3: RUN DAILY FILTER #################");
	runDailyFilter();
	note("################## STEP 4: RUN DAILY FACTS ##################");
	runDailyFacts();
	note("################# STEP 5: RUN FINAL REPORTS #################");
	runFinalReports();
	note("############### STEP 6: TRANSFER FINAL REPORTS ##############");
	transferFinalReportsToMasterHost();
	transferEventAggForOlap();
	note("################ STEP 7: TRANSFER UPDATED DIM ###############");
	##transferUpdatedDim(); Move this process into transferFinalReportsToMasterHost()
	##note("############### fn_delete_event_esc_char($report_date)...");
	##fn_delete_event_esc_char();
}


sub getDateSk{
	my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
	$month++;
	$yr19+=1900;
	if($day<10){
		$day="0$day";
	}
	if($month<10){
		$month="0$month";
	}
	$today_date="$yr19-$month-$day";
	note( "*Today is $today_date");	
	note( "*Get report date_sk!");
	my $dbh = getConnection($master_host);
	my $query='SELECT date_sk-1 as report_date_sk_key,full_date-1 as full_date FROM refer.date_dim WHERE full_date=?';
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($today_date) ;
	$query_handle->bind_columns(undef, \$report_date_sk_key,\$full_date);
	while($query_handle->fetch()){	
			$report_date_sk=$report_date_sk_key;
			$report_date=$full_date;
	}
	my $rv = $dbh->disconnect;
	note( "**Report date_sk=$report_date_sk\n**Report date=$report_date");
}

sub checkAdcelFiles{
	note("*Check Adcel files!");
	my $date=$report_date;
	$date=~s/-//g;
	my $total_file=0;
	my $loaded_file=0;
	my $fail_file=0;
	my $dbh = getConnection($host);
	my $query="select b.total as total_file, count(*) as loaded_file, c.fail as fail_file
	from control.data_file 
	,(select count(*) as total from control.data_file where file_name like ?) b
	,(select count(*) as fail from control.data_file where file_name like ? and file_status='EF') c
	where file_name like ? and file_status='SU'
	group by b.total,c.fail";
	$query_handle = $dbh->prepare($query);
	$query_handle->execute("%ad_response\.$date%","%ad_response\.$date%","%ad_response\.$date%");
	$query_handle->bind_columns(undef, \$total_file,\$loaded_file,\$fail_file);
	while($query_handle->fetch()) {
		$total_file=$total_file;
		$loaded_file=$loaded_file;
		$fail_file=$fail_file;
	}
	sqlDisconnect($dbh);
	
	if($total_file==$loaded_file && $total_file>0 && $fail_file==0){
		note("**Adcel files loading is completed with total file= $total_file");
	}else{
		note("**Adcel files loading is not completed with total file=$total_file \t loaded file=$loaded_file \t fail files = $fail_file.\n**Recheck after 60s");
		sleep(60);
		checkAdcelFiles();
	}	
}

sub checkEventFiles{
	note("*Check Event Files!");
	my $date=$report_date;
	my $total_file=0;
	my $loaded_file=0;
	my $fail_file=0;
	my $dbh = getConnection($host);
	my $query="SELECT b.total as total_file, count(*) as loaded_file, c.fail as fail_file
				FROM control.data_file 
				,(select count(*) as total from control.data_file where file_name like ?) b
				,(select count(*) as fail from control.data_file where file_name like ? and file_status='EF') c
				WHERE file_name like ? and file_status='SU'
				GROUP BY b.total,c.fail;";
	$query_handle = $dbh->prepare($query);
	$query_handle->execute("%event-tracker-incremental_$date%","%event-tracker-incremental_$date%","%event-tracker-incremental_$date%");
	$query_handle->bind_columns(undef, \$total_file,\$loaded_file,\$fail_file);
	while($query_handle->fetch()) {
		$total_file=$total_file;
		$loaded_file=$loaded_file;
		$fail_file=$fail_file;
	}
	sqlDisconnect($dbh);
	
	if($total_file==$loaded_file && $total_file>0 && $fail_file==0){
		note("**Event files loading is completed with total file= $total_file");
	}else{
		note("**Event files loading is not completed with total file=$total_file \t loaded file=$loaded_file \t fail files = $fail_file.\n**Recheck after 60s");
		sleep(60);
		checkEventFiles();
	}
}

sub resolveMissingUserAgentAndEvent{
	note("* Step 1.1: transfer adcel missing user agent to master server (DW6 -> $master_host)");
	my $comand="ssh dw6 \'cd /u11/incoming/tranfer_eventtraker_incremental_useragent/ && java -jar Transfer_Eventtracker_incremental_dim.jar DW6ToDW3 $report_date\'";
	system($comand);
	
	note("* Step 1.2: insert new user agent and event on master server ($master_host)");
	my $dbh = getConnection($master_host);
	my $query="SELECT staging.fn_build_resolve_ad_response_fact_user_agent_dw6(1,1,\'PS\');
				SELECT staging.fn_build_resolve_event_tracker_incremental_fact_dw6(1,1,\'PS\');";
	sqlRunQuery($dbh,$query);
	sqlDisconnect($dbh);
	
	note("* Step 1.3: transfer new user agent to ETL server (DW4/DW5)");
	my $comand="ssh dw6 \'cd /u11/incoming/tranfer_eventtraker_incremental_useragent/ && java -jar Transfer_Eventtracker_incremental_dim.jar DW3ToDW6 $report_date\'";
	system($comand);
	
	note("* Step 1.4: resolve missing user agent on ETL server (DW4/DW5)");
	my $dbh = getConnection($host);
	my $query=" select staging.fn_manage_ad_response_process_tasks(31);
				select staging.fn_refresh_daily_resolve_user_agent(\'fn_build_resolve_adcel_user_agent_by_master\');
				select staging.fn_promote_daily_resolve_user_agent();";
	sqlRunQuery($dbh,$query);
	
	# Check
	my $row_count=0;
	my $query="select sum(row_count) as row_count from (
				select count(*) as row_count from adstraffic.ad_response_fact_app015_user_agent
				union all
				select count(*) as row_count from adstraffic.ad_response_fact_app016_user_agent
				union all
				select count(*) as row_count from adstraffic.ad_response_fact_app017_user_agent
				union all
				select count(*) as row_count from adstraffic.ad_response_fact_app018_user_agent
				union all
				select count(*) as row_count from adstraffic.ad_response_fact_app019_user_agent
				union all
				select count(*) as row_count from adstraffic.ad_response_fact_app020_user_agent
				union all
				select count(*) as row_count from adstraffic.ad_response_fact_app021_user_agent
				union all
				select count(*) as row_count from adstraffic.ad_response_fact_app024_user_agent
				union all
				select count(*) as row_count from adstraffic.ad_response_fact_app025_user_agent
				union all
				select count(*) as row_count from adstraffic.ad_response_fact_app026_user_agent
				union all
				select count(*) as row_count from adstraffic.ad_response_fact_app027_user_agent
				union all
				select count(*) as row_count from adstraffic.ad_response_fact_app12_user_agent
				union all
				select count(*) as row_count from adstraffic.ad_response_fact_app13_user_agent
				union all
				select count(*) as row_count from adstraffic.ad_response_fact_app14_user_agent
				union all
				select count(*) as row_count from adstraffic.ad_response_fact_app3_user_agent
				union all
				select count(*) as row_count from adstraffic.ad_response_fact_app4_user_agent
				union all
				select count(*) as row_count from adstraffic.ad_response_fact_app6_user_agent
				union all
				select count(*) as row_count from adstraffic.ad_response_fact_app8_user_agent
				union all
				select count(*) as row_count from adstraffic.ad_response_fact_app9_user_agent
				) a";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	$query_handle->bind_columns(undef, \$row_count);		

	while($query_handle->fetch()) {
	   $row_count=$row_count;
	} 
	sqlDisconnect($dbh);
	
	if($row_count==0){
		my $dbh = getConnection($host);
		my $query="select staging.fn_manage_ad_response_process_tasks(56);
					select staging.fn_refresh_daily_resolve_user_agent('fn_build_resolve_event_tracker_incremental_fact_by_master');
					select staging.fn_promote_daily_resolve_user_agent_evttracker_incremental();";
		sqlRunQuery($dbh,$query);	
		
		#Check
		my $row_count=0;
		my $query="select sum(row_count) as row_count from (
					select count(*) as row_count from evttracker.event_tracker_incremental_fact_app015_user_agent
					union all
					select count(*) as row_count from evttracker.event_tracker_incremental_fact_app016_user_agent
					union all
					select count(*) as row_count from evttracker.event_tracker_incremental_fact_app017_user_agent
					union all
					select count(*) as row_count from evttracker.event_tracker_incremental_fact_app018_user_agent
					union all
					select count(*) as row_count from evttracker.event_tracker_incremental_fact_app019_user_agent
					union all
					select count(*) as row_count from evttracker.event_tracker_incremental_fact_app020_user_agent
					union all
					select count(*) as row_count from evttracker.event_tracker_incremental_fact_app021_user_agent
					union all
					select count(*) as row_count from evttracker.event_tracker_incremental_fact_app024_user_agent
					union all
					select count(*) as row_count from evttracker.event_tracker_incremental_fact_app025_user_agent
					union all
					select count(*) as row_count from evttracker.event_tracker_incremental_fact_app026_user_agent
					union all
					select count(*) as row_count from evttracker.event_tracker_incremental_fact_app027_user_agent
					union all
					select count(*) as row_count from evttracker.event_tracker_incremental_fact_app12_user_agent
					union all
					select count(*) as row_count from evttracker.event_tracker_incremental_fact_app13_user_agent
					union all
					select count(*) as row_count from evttracker.event_tracker_incremental_fact_app14_user_agent
					union all
					select count(*) as row_count from evttracker.event_tracker_incremental_fact_app3_user_agent
					union all
					select count(*) as row_count from evttracker.event_tracker_incremental_fact_app4_user_agent
					union all
					select count(*) as row_count from evttracker.event_tracker_incremental_fact_app6_user_agent
					union all
					select count(*) as row_count from evttracker.event_tracker_incremental_fact_app8_user_agent
					union all
					select count(*) as row_count from evttracker.event_tracker_incremental_fact_app9_user_agent
					union all
					select count(*) as row_count from evttracker.event_tracker_incremental_fact_aws0_user_agent
					) a";
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute();
		$query_handle->bind_columns(undef, \$row_count);
		while($query_handle->fetch()) {
			$row_count=$row_count;
		} 
		sqlDisconnect($dbh);
		if($row_count==0){
			note("** resolveMissingUserAgentAndEvent is completed!!!");
		}else{
			note("!!!!!!! resolveMissingUserAgentAndEvent Faile -- Event unresolve count = $row_count.\n** Re resolve after 60s");
			sleep(60);
			resolveMissingUserAgentAndEvent();		
		}
		
	}else{
		note("!!!!!!! resolveMissingUserAgentAndEvent Faile -- Adcel unresolve count = $row_count.\n** Re resolve after 60s");
		sleep(60);
		resolveMissingUserAgentAndEvent();
	}
}

sub copyIndayData{
	runParam(32);
	checkParam(32,19);
	promoteParam("staging.fn_promote_daily_copy_ad_responses()");
	
	runParam(57);
	checkParam(57,20);
	promoteParam("staging.fn_promote_daily_copy_event_tracker_incremental()");
	
}

sub runDailyFilter{
	runParam(58);
	checkParam(58,107);
	promoteParam("staging.fn_promote_daily_cumulative_event_tracker_per_server()");
}

sub runDailyFacts{
	runParam(59);
	checkParam(59,6);
	promoteParam("staging.fn_promote_daily_cumulative_event_tracker_incremental()");
}

sub runFinalReports{
	runParam(25);
	checkParam(25,17);
	promoteParam("staging.fn_promote_daily_event_tracker_report()");
}
sub transferFinalReportsToMasterHost{
	##note("* Tranfer data to Master host : $master_host");
	##my $comand="cd /opt/temp/autoscripts/transformer/dw6 && ./event_transfer.sh $host $master_host $master_report_host $report_date";
	##system($comand);
	transferUpdatedDim();
	##note("* Build Daily evnt maps olap");
	##my $dbh = getConnection($master_host);
	##my $query="select staging.fn_build_daily_event_maps_olap($report_date_sk,-100,\'PS\')";
	##sqlRunQuery($dbh,$query);
	##sqlDisconnect($dbh);
	##note("* fn_delete_event_esc_char($report_date)...");
	##fn_delete_event_esc_char();
	##note("* Tranfer data From Master host: $master_host to Master report host : $master_report_host");
	##my $comand="cd /opt/temp/autoscripts/transformer/dw6 && ./event_transfer_back.sh $host $master_host $master_report_host $report_date";
	##system($comand);
}

sub fn_delete_event_esc_char{
	note("** Delete on $master_host");
	my $dbh = getConnection($master_host);
	my $query="select staging.fn_delete_event_esc_char(\'$report_date\')";
	sqlRunQuery($dbh,$query);
	sqlDisconnect($dbh);
}

sub transferEventAggForOlap{
		my @aggTableDw10=();
		push(@aggTableDw10,"evttracker.daily_event_maps_olap*");
		push(@aggTableDw10,"evttracker.daily_event_maps_olap_min");
		##push(@aggTableDw10,"evttracker.daily_event_maps*");
		##push(@aggTableDw10,"evttracker.daily_trane_stats*");
		##copyAggDataToMasterReport($report_date,@aggTableDw10);
}
sub transferUpdatedDim{
	my $comand="ssh dw6 \'cd /u11/incoming/transfer_dim_dw3_dw6 && java -jar -Xmx2048m DIM_DW3_DW6.jar dim\'";
	system($comand);
}

sub copyAggDataToMasterReport{
	my ($date_copy,@aggTableDw10)=@_;
	foreach $tableName(@aggTableDw10){
		my $callFunction='';
		if(index($tableName,'*')>=0){			
			$tableName=~s/\*//g;
			print "* Transfer $tableName with partition mode\n";
			$callFunction="cd /opt/temp/autoscripts/transformer/ && perl mainWP.pl daily $master_host $master_report_host $tableName $date_copy event_tracker_auto";
		}else{
			##my $callFunction ="cd /opt/temp/daily_agg_program/;java -jar DAILY_AGG_DW3_DW0.jar daily $table $date";
			$callFunction="cd /opt/temp/autoscripts/transformer/ && perl main.pl daily $master_host $master_report_host $tableName $date_copy event_tracker_auto";
			
		}
		system($callFunction);
	}
}

