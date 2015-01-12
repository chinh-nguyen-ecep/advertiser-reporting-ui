use Switch;
require "utils.pl";

%h_process_date=dw3_currentDate();
$process_date=$h_process_date{'year'}.'-'.$h_process_date{'month'}.'-'.$h_process_date{'day'};	#the date run process
my @aggTableDw3=();
$date=yesterday();
$date2=yesterday2();
$log="";
$mailTile="[Daily report][3rd AdNetwork][$date] ";
##rollBackTransferRemnant();
##rollBackTransferDelivery();
##rollBackTransferPublisherProperty();
##my $comand="cd /opt/temp/autoscripts/transferAggDataDw3Dw0;perl checkAggDw3_Dw0.pl monthly \"30 day\" &";
##system($comand);
##@aggTableDw3=();
##push(@aggTableDw3,"adm.daily_network_fct_request");
##push(@aggTableDw3,"adm.daily_network_fct_channel");
##copyAggDataToDw0($date,@aggTableDw3);

main();

sub main{
	#register sub process to control.daily_process_status table.
	register_process($process_date,$group_process_name,22,'07:10:00','07:40:00');
	register_process($process_date,$group_process_name,28,'07:50:00','09:00:00');
	register_process($process_date,$group_process_name,84,'11:00:00','09:15:00');
	register_process($process_date,$group_process_name,53,'11:00:00','09:15:00');
	register_process($process_date,$group_process_name,54,'11:00:00','09:15:00');
	register_process($process_date,$group_process_name,48,'11:30:00','09:20:00');
	register_process($process_date,$group_process_name,47,'11:30:00','19:00:00');
	register_process($process_date,$group_process_name,68,'11:50:00','19:00:00');
	register_process($process_date,$group_process_name,49,'19:10:00','9:15:00');
	register_process($process_date,$group_process_name,23,'19:10:00','22:00:00');
	register_process($process_date,$group_process_name,29,'22:00:00','23:00:00');
	#Check 14 file logs
	my $error=0;
	#my $error=checkSU(11,'39,40,41,43,44,49,50,47,48,52,53',$mailTile);
	my $time=getTime();
	sendMail("Dear all,<p />$time# Begin start param 22.<p />Thanks,<br />send by auto mail.",$mailTile);
	writelog("All Log files Extracting completed. Begin start param 22");
	if($error == 0){
		#run param22;
		writelog("Run function param 22");
		runParam(22);
		checkParam(22,6);
		promote(22);
		
		#run param 28
		writelog("Run param 28");
		system("cd ../notifications_for_late_reports/;perl notifications_for_late_reports.pl remnant > monitor/dailylog.remnant.$process_date.txt 2> errors/dailylog.remnant.$process_date.txt &");		
		runParam(28);
		checkParam(28,4);				
		promote(28);

		# Check param 70 from admDFP before continue
		checkParam(70,5);	

		#run param 84
		writelog("Run param 84");
		runParam(84);
		checkParam(84,3);				
		promote(84);
		#run param 34 transfer data to network data mark
		##writelog("Run param 34");	
		##runParam(34);
		writelog("Run param 53");	
		runParam(53);
		writelog("Run param 54");	
		runParam(54);
		#run param 48 
		writelog("Run param 48");	
		runParam(48);
		writelog("Run param 47");	
		runParam(47);
		checkParam(47,3);
		promote(47);
		
		#run param 49
		writelog("Run param 49");	
		runParam(49);#not check SU
		
		#run param 68 Delivery report
		writelog("Run param 68");	
		runParam(68);
		#transfer for param 47
		rollBackTransferPublisherProperty();
		#---------
		checkParam(68,1);
		promote(68);
		
		#run param 23
		writelog("Run param 23");	
		runParam(23);
		checkParam(23,6);
		promote(23);
		
		#run param 29
		writelog("Run param 29");	
		runParam(29);
		checkParam(29,2);
		promote(29);
		
		#Insert subscription process to transfer to Dw12 AWS
		transferToAWS();
		
		$time=getTime();
		sendMail("Dear all,<p />$time# Daily 3rd AdNetwork report promoted. The process are completed with no error.<p />Thanks,<br />send by auto mail.",$mailTile);
		writelog("Main Process finished");	
		
	}else{
		printTime("Stop with error");
		sendMail("Dear all,<p />Daily 3rd AdNetwork report $date is stop with error.<p />Thanks,<br />send by auto mail.");
	}

}

sub promote{
	my $param=shift;
	print "promoting $param\n";
	switch($param) {
	  case 22 {
		runPGFuntion("staging.fn_promote_daily_3rd_network_performance_report");		
		break;}
	  case 23 {
	  	runPGFuntion("staging.fn_promote_monthly_3rd_network_performance_report");	
		break;}
	  case 28 {
	  	runPGFuntion("staging.fn_promote_daily_3rd_network_summary_report");	
		rollBackTransferRemnant();
		break;}
	  case 29 {
		runPGFuntion("staging.fn_promote_monthly_3rd_network_summary_report");
		#transfer 30 day rolling report
		my $comand="cd /opt/temp/autoscripts/transferAggDataDw3Dw0;perl checkAggDw3_Dw0.pl monthly \"30 day\" &";
		system($comand);
		break;}
	  case 34 {
	  	@aggTableDw3=();
		push(@aggTableDw3,"adm.daily_network_fct_request");
		push(@aggTableDw3,"adm.daily_network_fct_channel");
		copyAggDataToDw0($date,@aggTableDw3);
		break;}
	  case 47 {
	  	runPGFuntion("staging.fn_promote_daily_3rd_network_requests_report");		
		break;}
	  case 48 {		break;}
	  case 49 {		break;}
	  case 68 {		
		runPGFuntion('staging.fn_promote_daily_delivery_report');
		rollBackTransferDelivery();
	  	break;}
	  case 84 {		
		runPGFuntion('staging.fn_promote_daily_fct_network_revenue');
	  	break;}
	};
	
}


sub rollBackTransferRemnant{
		%h_report_date1=dw3_yesterday();
		%h_report_date7=dw3_getDate(-7);
		$report_date1=$h_report_date1{'year'}.'-'.$h_report_date1{'month'}.'-'.$h_report_date1{'day'};	#the report date 2012-02-02
		$report_date7=$h_report_date7{'year'}.'-'.$h_report_date7{'month'}.'-'.$h_report_date7{'day'};	#the report date 2012-02-02
		##rollBackTransfer_table_wp('adm.daily_agg_network_performance',$report_date7,$report_date1);
		##rollBackTransfer_table('adm.daily_network_fct_request',$report_date7,$report_date1);
		##rollBackTransfer_table('adm.daily_network_fct_channel',$report_date7,$report_date1);
		##rollBackTransfer_table('adnetwork.daily_adnetwork_summary',$report_date7,$report_date1);
		

		##checkEstimateTableToTransfer('adnetwork.daily_cg_performance');
		##checkEstimateTableToTransfer('adnetwork.daily_jt_performance');

		##checkEstimateTableToTransfer('adnetwork.daily_mm_performance');
		checkEstimateTableToTransfer('adnetwork.daily_mx_performance');
		checkEstimateTableToTransfer('adnetwork.daily_sp_blue_performance');

		checkEstimateTableToTransfer('adnetwork.daily_yp_no_performance');

		checkEstimateTableToTransfer('adnetwork.daily_yp_sb_performance');
		checkEstimateTableToTransfer('adnetwork.daily_am_performance');
}

sub rollBackTransferDelivery{
		%h_report_date1=dw3_yesterday();
		%h_report_date7=dw3_getDate(-7);
		$report_date1=$h_report_date1{'year'}.'-'.$h_report_date1{'month'}.'-'.$h_report_date1{'day'};	#the report date 2012-02-02
		$report_date7=$h_report_date7{'year'}.'-'.$h_report_date7{'month'}.'-'.$h_report_date7{'day'};	#the report date 2012-02-02
		
		##rollBackTransfer_table('adsops.daily_agg_delivery_adnetwork_publisher',$report_date7,$report_date1);
		##rollBackTransfer_table('adsops.daily_agg_delivery_publisher_property',$report_date7,$report_date1);	
		##rollBackTransfer_table_wp('adsops.daily_agg_delivery_adnetwork_publisher_beta',$report_date7,$report_date1);
		##rollBackTransfer_table_wp('adsops.daily_agg_delivery_publisher_property_beta',$report_date7,$report_date1);	
		rollBackTransfer_table('adsops.daily_agg_delivery_adnetwork_publisher_v3',$report_date7,$report_date1);
		rollBackTransfer_table('adsops.daily_agg_delivery_publisher_property_v3',$report_date7,$report_date1);
		##rollBackTransfer_table_wp('adm.daily_agg_network_revenue',$report_date7,$report_date1);
		rollBackTransfer_table_wp('adm.daily_agg_network_revenue_by_publisher',$report_date7,$report_date1);	
		rollBackTransfer_table('adm.daily_agg_network_revenue_min',$report_date7,$report_date1);
		
		##system("cd /opt/temp/autoscripts/transformer/ && perl main.pl daily_range dw3 pentaho.ecepvn.org:analyticsdb adsops.daily_agg_delivery_adnetwork_publisher_beta $report_date7 $report_date1 3rdAdNetAutodaily &");
		##system("cd /opt/temp/autoscripts/transformer/ && perl main.pl daily_range dw3 pentaho.ecepvn.org:analyticsdb adsops.daily_agg_delivery_publisher_property_beta $report_date7 $report_date1 3rdAdNetAutodaily &");
}

sub rollBackTransferPublisherProperty{
		%h_report_date1=dw3_yesterday();
		%h_report_date7=dw3_getDate(-7);
		$report_date1=$h_report_date1{'year'}.'-'.$h_report_date1{'month'}.'-'.$h_report_date1{'day'};	#the report date 2012-02-02
		$report_date7=$h_report_date7{'year'}.'-'.$h_report_date7{'month'}.'-'.$h_report_date7{'day'};	#the report date 2012-02-02
		
		rollBackTransfer_table('adm.daily_network_fct_request_beta',$report_date7,$report_date1);

		rollBackTransfer_table('adsops.daily_agg_verve_ads_by_remnant',$report_date7,$report_date1);
		rollBackTransfer_table('adm.daily_agg_api_revenue_by_partner_v4',$report_date7,$report_date1);
		rollBackTransfer_table('adm.daily_agg_api_revenue_by_partner_v5',$report_date7,$report_date1);
		##rollBackTransfer_table('adsops.daily_agg_delivery_advertiser_beta',$report_date7,$report_date1);
		##rollBackTransfer_table('adm.daily_agg_revenue_statistics',$report_date7,$report_date1);
		rollBackTransfer_table('adm.ba_daily_flight',$report_date7,$report_date1);
		rollBackTransfer_table('adm.ba_daily_flight_min',$report_date7,$report_date1);
		rollBackTransfer_table('adm.ba_daily_flight_exception',$report_date7,$report_date1);
		##rollBackTransfer_table('adm.daily_agg_api_revenue_by_partner_v3',$report_date7,$report_date1);
		##system("cd /opt/temp/autoscripts/transformer/ && perl main.pl daily_range dw3 pentaho.ecepvn.org:analyticsdb adm.daily_agg_fct_overview_revenue_beta $report_date7 $report_date1 3rdAdNetAutodaily &");
		##system("cd /opt/temp/autoscripts/transformer/ && perl main.pl daily_range dw3 dw10:analyticsdb adm.daily_agg_fct_overview_revenue_beta $report_date7 $report_date1 3rdAdNetAutodaily &");

}

sub checkEstimateTableToTransfer{	
	my $tableName=shift;
	my $result=0;
	my $is_estimated=0;
	print "* Check estimate $tableName date $date...\n";	
	my $dbh = getConnection();	  
	my $query="SELECT is_estimated FROM $tableName WHERE full_date=? AND is_active=true GROUP BY is_estimated";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute("$date");	
	$query_handle->bind_columns(undef, \$is_estimated);
	
	while($query_handle->fetch()) {	
		$is_estimated=$is_estimated;
	}
	my $rv = $dbh->disconnect;
	if($is_estimated==1){
		print "** Today $tableName is estimated. Transfer this table...\n";
		%h_report_date1=dw3_yesterday();
		%h_report_date7=dw3_getDate(-7);
		$report_date1=$h_report_date1{'year'}.'-'.$h_report_date1{'month'}.'-'.$h_report_date1{'day'};	#the report date 2012-02-02
		$report_date7=$h_report_date7{'year'}.'-'.$h_report_date7{'month'}.'-'.$h_report_date7{'day'};	#the report date 2012-02-02		
		rollBackTransfer_table($tableName,$report_date1,$report_date1);	
	}else{
		print "$tableName has been have data today...\n";
	}
}

sub transferToAWS{
	my $subscription_key=0;
	my $subscription_name=0;
	%h_report_date2=dw3_getDate(-2);
	%h_report_date7=dw3_getDate(-7);
	$report_date2=$h_report_date2{'year'}.'-'.$h_report_date2{'month'}.'-'.$h_report_date2{'day'};	#the report date 2012-02-02
	$report_date7=$h_report_date7{'year'}.'-'.$h_report_date7{'month'}.'-'.$h_report_date7{'day'};	#the report date 2012-02-02		
	
	print "* Transfer to AWS $report_date7 $process_date...\n";	
	my $dbh = getConnectionDw10();	  
	my $query="SELECT subscription_key,subscription_name FROM control.spctl_pub_customer_subscription WHERE subscription_name IN ('Daily Backup AIS To AWS','Daily Backup AIS To AWS 7days')";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();	
	$query_handle->bind_columns(undef, \$subscription_key, \$subscription_name);
	while($query_handle->fetch()) {	
		my $query2="";
		if($subscription_name eq 'Daily Backup AIS To AWS'){
			$query2="SELECT * FROM CONTROL.fn_spctl_insert_subscription_to_process($subscription_key, 'start_date=$report_date2&end_date=$process_date', true)";
		}
		if($subscription_name eq 'Daily Backup AIS To AWS 7days'){
			$query2="SELECT * FROM CONTROL.fn_spctl_insert_subscription_to_process($subscription_key, 'start_date=$report_date7&end_date=$process_date', true)";
		}
		my $query_handle2 = $dbh->prepare($query2);
		$query_handle2->execute();	
	}
	my $rv = $dbh->disconnect;
}






