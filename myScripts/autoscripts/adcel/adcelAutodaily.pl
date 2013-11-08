use Switch;
require "../bin/dw_utils.pl";
require "config.pl";

printTime('Adcel auto script .............');
print "Host: $host \nMaster hots: $master_host \nMaster report host: $master_report_host \n";

getDateSk();
main();

sub main{
		#Get date param
		
		#register sub process to control.daily_process_status table.
		$group_process_name="Adcel";	#the name of group process to register to daily process status table
		register_process($today_date,$group_process_name,10,'01:35:00','09:00:00');
		register_process($today_date,$group_process_name,44,'01:35:00','09:00:00');
		register_process($today_date,$group_process_name,51,'01:35:00','09:00:00');
		register_process($today_date,$group_process_name,52,'01:35:00','09:00:00');
		register_process($today_date,$group_process_name,55,'01:35:00','09:00:00');
		my ($sec,$min,$hour,$day,$month,$yr19,$WeekDay, $DayOfYear, $IsDST) =   localtime(time);
		if($WeekDay==0){
				register_process($today_date,$group_process_name,16,'09:00:00','18:00:00');
				register_process($today_date,$group_process_name,66,'09:00:00','18:00:00');
				register_process($today_date,$group_process_name,11,'09:00:00','19:00:00');
				register_process($today_date,$group_process_name,67,'19:00:00','22:00:00');
				register_process($today_date,$group_process_name,18,'20:00:00','22:00:00');
				
		};
		
		runParam(10);
		#run param44;
		runParam(44);
		#run param51;
		runParam(51);
		#run param52;
		runParam(52);
		#run param55;
		runParam(55);
		
		checkParam(10,3);
		promote(10);
		
		checkParam(44,5);
		promote(44);
		
		checkParam(51,5);
		promote(51);	
		
		checkParam(52,3);
		promote(52);

		checkParam(55,1);
		promote(55);
		
		#if monday we will call param 16,11,18
		my ($sec,$min,$hour,$day,$month,$yr19,$WeekDay, $DayOfYear, $IsDST) =   localtime(time);
		if($WeekDay==0){
			#30 day rolling
			runParam(16);	
			runParam(66);		
			runParam(11);
			
			checkParam(66,1);
			promote(66);
			
			runParam(67);
			
			checkParam(16,1);
			promote(16);
			
			runParam(18);			
			checkParam(11,4);
			promote(11);	

		};		
		
		#Tranfer Olap data to dw10
		sleep(10);
		##transferOlapDataToDw10();		
		sendMail($mailto,$emailAvailableTitle,
					"Dear all,<p />
					$time# Daily process completed successful.<p />Thanks,<br />\-\-\-send by auto mail.");		
	
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
sub promote{
	my $param=shift;
	print "promoting $param\n";
	switch($param) {
	  case 10 {		
		promoteParam("staging.fn_promote_daily_ad_response_report()");
		break;}
	  case 11 {
		promoteParam("staging.fn_promote_monthly_ad_response_report()");
		break;}
	  case 13 {
		promoteParam("staging.fn_promote_daily_cumulative_ad_response()");
		break;}
	  case 16 {
		promoteParam("staging.fn_promote_monthly_forecast_report()");
		break;}
	  case 31 {
		promoteParam("staging.fn_promote_daily_resolve_user_agent()");
		break;}
	  case 32 {
		promoteParam("staging.fn_promote_daily_copy_ad_responses()");
		break;}
	  case 44 {	
		promoteParam("staging.fn_promote_daily_unfilled_report()");
		break;}
	  case 50 {		
		promoteParam("staging.fn_promote_daily_cumulative_ad_response_per_server()");
		break;}
	  case 51 {		
		promoteParam("staging.fn_promote_daily_filled_report()");
		break;}
	  case 52 {				
		promoteParam("staging.fn_promote_daily_requests_report()");
		break;}
	  case 55 {		
		promoteParam('staging.fn_promote_daily_geo_report()');
		break;}
	  case 66 {		
		promoteParam('staging.fn_promote_monthly_forecast_adm_report()');
		break;}
	};
	#check is promote
	my $isPromote=isPromoted($param,$master_host);
	if($isPromote==0){
		sleep(10);
		promote($param);
	}else{
		#transfer data
			switch($param) {
			  case 10 {						
				copyAggDataToMasterReportHost("adstraffic.daily_ad_serving_stats",'wp');
				copyAggDataToMasterReportHost("adstraffic.daily_ad_serving_stats_by_device");
				copyAggDataToMasterReportHost("adstraffic.daily_ad_serving_stats_by_content_category");
				break;}
			  case 11 {
				#transfer 30 day rolling report
				my $comand="cd /opt/temp/autoscripts/transferAggDataDw3Dw0;perl checkAggDw3_Dw0.pl monthly \"30 day\" &";
				system($comand);
				break;}
			  case 13 {
				copyAggDataToMasterReportHost("adstraffic.daily_adcel_stats");
				break;}
			  case 44 {	
				copyAggDataToMasterReportHost("adstraffic.daily_olap_unfilled_by_portal");
				copyAggDataToMasterReportHost("adstraffic.daily_unfilled_stats",'wp');
				copyAggDataToMasterReportHost("adstraffic.daily_unfilled_stats_by_dma");
				copyAggDataToMasterReportHost("adstraffic.daily_unfilled_stats_by_device");
				copyAggDataToMasterReportHost("adstraffic.daily_unfilled_stats_by_content_category");
				break;}
			  case 51 {		
				copyAggDataToMasterReportHost("adstraffic.daily_filled_stats");
				copyAggDataToMasterReportHost("adstraffic.daily_filled_stats_by_dma");
				copyAggDataToMasterReportHost("adstraffic.daily_filled_stats_by_device");
				copyAggDataToMasterReportHost("adstraffic.daily_filled_stats_by_content_category");
				copyAggDataToMasterReportHost("adstraffic.daily_filled_stats_by_content_category");
				copyAggDataToMasterReportHost("adstraffic.daily_olap_filled_by_portal",'wp');
				break;}
			  case 55 {	
				copyAggDataToMasterReportHost("adstraffic.daily_geo_quality");
				copyAggDataToMasterReportHost("adstraffic.daily_olap_trxids_by_content_category");
				copyAggDataToMasterReportHost("adstraffic.daily_olap_trxids_by_device");
				copyAggDataToMasterReportHost("adstraffic.daily_olap_trxids_by_portal",'wp');
				break;}
			};
	}
}
sub transferOlapDataToDw10{			
		system("cd /opt/temp/autoscripts/transformer && perl mainWP.pl daily $master_host dw10 adstraffic.daily_olap_filled_by_portal $report_date $transfer_by &");
		system("cd /opt/temp/autoscripts/transformer && perl mainWP.pl daily $master_host dw10 adstraffic.daily_olap_trxids_by_portal $report_date $transfer_by &");
		system("cd /opt/temp/autoscripts/transformer && perl mainWP.pl daily $master_host dw10 adstraffic.daily_unfilled_stats $report_date $transfer_by &");
		system("cd /opt/temp/autoscripts/transformer && perl mainWP.pl daily $master_host dw10 adstraffic.daily_ad_serving_stats $report_date $transfer_by &");
}

sub copyAggDataToMasterReportHost{
	my $table=shift;
	my $mode=shift;
	if($mode =='wp'){
		system("cd /opt/temp/autoscripts/transformer && perl mainWP.pl daily $master_host $master_report_host $table $report_date $transfer_by");
	}else{
		system("cd /opt/temp/autoscripts/transformer && perl main.pl daily $master_host $master_report_host $table $report_date $transfer_by");
	}	
}


