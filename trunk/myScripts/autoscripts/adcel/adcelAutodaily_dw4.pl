require "../bin/dw_utils.pl";

$today_date; # report date 2012-07-04
$report_date='';
$report_date_sk='';
$host='dw4';
$master_host='dw3';
$param50ProcessID=0;
$param32ProcessID=0;
$param13ProcessID=0;
if(@ARGV==1 && $ARGV[0]=='--help'){
	print "perl adcelAutodaily_dw4.pl\n";
}elsif(@ARGV==0){
	getDateSk();
	#tranferFactTableFromDw4ToDw3('adstraffic.ad_response_fact_stats_01');	
	main();	
}else{
	print "perl adcelAutodaily_dw4.pl\n";
}
sub main{	
	#register sub process to control.daily_process_status table.
	my $group_process_name="Adcel";	#the name of group process to register to daily process status table
	register_process($today_date,$group_process_name,32,'01:00:00','01:30:00');
	register_process($today_date,$group_process_name,50,'01:35:00','09:00:00');
	register_process($today_date,$group_process_name,13,'01:35:00','05:30:00');
	
	runParam32();
	checkParam32();
	checkIsCanStart();
	runParam50();
	runParam13();
	checkToTransferDailyStatsToDW3();
	updateCheckPoint();
	updateCheckPoint_forecast();
        checkToTransferDailyFilledToDW3();
	checkToTransferDailyUnfilledToDW3();
	#checkToTransferDailyFilledToDW3();
	checkToTransferDailyTrxidsToDW3();
        tranferDimFromDw3ToDw4();
	checkToTransferDailyForecastToDW3();
	checkParam50();
	checkParam13();
	transferDailyAdcelStats();
	#tranferDimFromDw3ToDw4();
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
	print "*Today is $today_date\n";
	
	print "*Get report date_sk!\n";
	sleep(2);
	my $dbh = getConnection('dw3');
	my $query='SELECT date_sk-1 as report_date_sk_key,full_date-1 as full_date FROM refer.date_dim WHERE full_date=?';
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($today_date) ;
	$query_handle->bind_columns(undef, \$report_date_sk_key,\$full_date);
	while($query_handle->fetch()){	
			$report_date_sk=$report_date_sk_key;
			$report_date=$full_date;
	}
	my $rv = $dbh->disconnect;
	print "**Report date_sk=$report_date_sk\n**Report date=$report_date\n";
	sleep(2);
}

sub checkIsCanStart{
	print "*Check the status to know we can start process or not!\n";
	sleep(2);
	my $isCanStart=0;
	my $dbh = getConnection($host);
	my $query='SELECT process_id,process_status FROM control.process WHERE process_config_id=32 AND dt_process_queued::date=?';
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($today_date) ;
	$query_handle->bind_columns(undef, \$process_id,\$process_status);
	while($query_handle->fetch()) {	
		if($process_id>0 && $process_status eq 'SU'){
			$isCanStart=$process_id;
		}
	}
	my $rv = $dbh->disconnect;
	if($isCanStart==0){
		print "**The param 32 is not finished or is not run. So we can't start param 50!\n**Recheck after 60s!...\n";
		sleep(60);
		checkIsCanStart();
	}else{
		printTime( "**We can start process 50 now!...");
		sleep(2);
	}

}

sub runParam50{
	print "*Run param 50 on dw4!\n";
	sleep(2);
	my $dbh = getConnection($host);
	my $query='SELECT staging.fn_manage_ad_response_process_tasks(50);';
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute() ;
	#get param 50 process ID
	my $query='SELECT process_id FROM control.process WHERE process_config_id=50 AND dt_process_queued::date=?';
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($today_date) ;
	$query_handle->bind_columns(undef, \$process_id);
	while($query_handle->fetch()) {	
		if($process_id>0){
			$param50ProcessID=$process_id;
		}
	}
	my $rv = $dbh->disconnect;
	if($param50ProcessID==0){
		print "**I checked but param 50 don't run. So re-run param 50 after 30s!\n";
		sleep(30);
		runParam50();
	}else{
		printTime("**Run param 50 with process ID=$param50ProcessID");	
		sleep(2);
	}

}
sub runParam32{
	print "*Run param 32 on dw4!\n";
	sleep(2);
	my $dbh = getConnection($host);
	my $query='SELECT staging.fn_manage_ad_response_process_tasks(32);';
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute() ;
	#get param 32 process ID
	my $query='SELECT process_id FROM control.process WHERE process_config_id=32 AND dt_process_queued::date=?';
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($today_date) ;
	$query_handle->bind_columns(undef, \$process_id);
	while($query_handle->fetch()) {	
		if($process_id>0){
			$param32ProcessID=$process_id;
		}
	}
	my $rv = $dbh->disconnect;
	if($param32ProcessID==0){
		print "**I checked but param 32 don't run. So re-run param 32 after 30s!\n";
		sleep(30);
		runParam32();
	}else{
		printTime("**Run param 32 with process ID=$param32ProcessID");
		sleep(2);
		my $query="UPDATE control.process_concurrent_trans
		SET is_complete = true, dt_lastchange = current_timestamp
		WHERE process_id=? AND concurrent_trans_name in (
		'fn_build_ad_response_fact_copy_app027-adcel',
		'fn_build_ad_response_fact_copy_app026-adcel',
		'fn_build_ad_response_fact_copy_app025-adcel',
		'fn_build_ad_response_fact_copy_app020-adcel',
		'fn_build_ad_response_fact_copy_app017-adcel',
		'fn_build_ad_response_fact_copy_app016-adcel',
		'fn_build_ad_response_fact_copy_app015-adcel',
		'fn_build_ad_response_fact_copy_app12-adcel',
		'fn_build_ad_response_fact_copy_app13-adcel',
		'fn_build_ad_response_fact_copy_app14-adcel'
		);";
		my $dbh = getConnection($host);
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute($param32ProcessID) ;	
		my $rv = $dbh->disconnect;		
	}
}

sub runParam13{
	print "*Run param 13 on dw4!\n";
	sleep(2);
	my $dbh = getConnection($host);
	my $query='SELECT staging.fn_manage_ad_response_process_tasks(13);';
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute() ;
	#get param 13 process ID
	my $query='SELECT process_id FROM control.process WHERE process_config_id=13 AND dt_process_queued::date=?';
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($today_date) ;
	$query_handle->bind_columns(undef, \$process_id);
	while($query_handle->fetch()) {	
		if($process_id>0){
			$param13ProcessID=$process_id;
		}
	}
	my $rv = $dbh->disconnect;
	if($param13ProcessID==0){
		print "**I checked but param 13 don't run. So re-run param 13 after 30s!\n";
		sleep(30);
		runParam13();
	}else{
		printTime("**Run param 13 with process ID=$param13ProcessID");
		sleep(2);
	}

}

sub checkToTransferDailyStatsToDW3{
	print "*Check Daily Stats 01!\n";
	sleep(2);
	my $subProcessCountTrue=0;
	my $completeCounTrue=1;
	my $dbh = getConnection($host);
	my $query="
	SELECT COUNT(*) as count FROM control.process_concurrent_trans
	WHERE concurrent_trans_name IN (
	\'fn_build_ad_response_fact_stats_01\'
	)
	AND process_id=?
	AND is_complete=true
	";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($param13ProcessID) ;	
	$query_handle->bind_columns(undef, \$count);
	while($query_handle->fetch()) {	
		$subProcessCountTrue=$count;
	}
	my $rv = $dbh->disconnect;
	if($subProcessCountTrue<$completeCounTrue){
		print "**Dw4 Daily stats_01 complete count true = $subProcessCountTrue. Recheck after 60s\n";
		sleep(60);
		checkToTransferDailyStatsToDW3();
	}else{
		printTime("**Dw4 Daily stats_01 is completed. Tranfert data to dw3...");
		sleep(2);
		tranferFactTableFromDw4ToDw3('adstraffic.ad_response_fact_stats_01');
	}

}

sub checkToTransferDailyFilledToDW3{
	print "*Check Daily Filled!\n";
	sleep(2);
	my $subProcessCountTrue=0;
	my $completeCounTrue=1;
	my $dbh = getConnection($host);
	my $query="
	SELECT COUNT(*) as count FROM control.process_concurrent_trans
	WHERE concurrent_trans_name IN (
	\'fn_build_ad_response_fact_stats_filled\'
	)
	AND process_id=?
	AND is_complete=true
	";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($param13ProcessID) ;	
	$query_handle->bind_columns(undef, \$count);
	while($query_handle->fetch()) {	
		$subProcessCountTrue=$count;
	}
	my $rv = $dbh->disconnect;
	if($subProcessCountTrue<$completeCounTrue){
		print "**Dw4 Daily Filled complete count true = $subProcessCountTrue. Recheck after 60s\n";
		sleep(60);
		checkToTransferDailyFilledToDW3();
	}else{
		printTime("**Dw4 Daily Filled is completed. Tranfert filled data to dw3...");
		sleep(2);
		tranferFactTableFromDw4ToDw3('adstraffic.ad_response_fact_stats_filled');	
	}

}

sub checkToTransferDailyUnfilledToDW3{
	print "*Check Daily Unfilled!\n";
	sleep(2);
	my $subProcessCountTrue=0;
	my $completeCounTrue=1;
	my $dbh = getConnection($host);
	my $query="
	SELECT COUNT(*) as count FROM control.process_concurrent_trans
	WHERE concurrent_trans_name IN (
	\'fn_build_ad_response_fact_stats_unfilled\'
	)
	AND process_id=?
	AND is_complete=true
	";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($param13ProcessID) ;	
	$query_handle->bind_columns(undef, \$count);
	while($query_handle->fetch()) {	
		$subProcessCountTrue=$count;
	}
	my $rv = $dbh->disconnect;
	if($subProcessCountTrue<$completeCounTrue){
		print "**Dw4 Daily Unfilled complete count true = $subProcessCountTrue. Recheck after 60s\n";
		sleep(60);
		checkToTransferDailyUnfilledToDW3();
	}else{
		printTime("**Dw4 Daily Unfilled is completed. Tranfert unfilled data to dw3...");
		sleep(2);
		tranferFactTableFromDw4ToDw3('adstraffic.ad_response_fact_stats_unfilled');	
	}


}

sub checkToTransferDailyTrxidsToDW3{
	print "*Check Daily Trxids!\n";
	sleep(2);
	my $subProcessCountTrue=0;
	my $completeCounTrue=1;
	my $dbh = getConnection($host);
	my $query="
	SELECT COUNT(*) as count FROM control.process_concurrent_trans
	WHERE concurrent_trans_name IN (
	\'fn_build_ad_response_fact_stats_trxids\'
	)
	AND process_id=?
	AND is_complete=true
	";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($param13ProcessID) ;	
	$query_handle->bind_columns(undef, \$count);
	while($query_handle->fetch()) {	
		$subProcessCountTrue=$count;
	}
	my $rv = $dbh->disconnect;
	if($subProcessCountTrue<$completeCounTrue){
		print "**Dw4 Daily Trxids complete count true = $subProcessCountTrue. Recheck after 60s\n";
		sleep(60);
		checkToTransferDailyTrxidsToDW3();
	}else{
		printTime("**Dw4 Daily Trxids is completed. Tranfert trxids data to dw3...");
		sleep(2);
		tranferFactTableFromDw4ToDw3('adstraffic.ad_response_fact_stats_trxids');	
	}


}

sub checkToTransferDailyForecastToDW3{
	print "*Check Daily Forecast!\n";
	sleep(2);
	my $subProcessCountTrue=0;
	my $completeCounTrue=1;
	my $dbh = getConnection($host);
	my $query="
	SELECT COUNT(*) as count FROM control.process_concurrent_trans
	WHERE concurrent_trans_name IN (
	\'fn_build_ad_response_fact_stats_forecast\'
	)
	AND process_id=?
	AND is_complete=true
	";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($param13ProcessID) ;	
	$query_handle->bind_columns(undef, \$count);
	while($query_handle->fetch()) {	
		$subProcessCountTrue=$count;
	}
	my $rv = $dbh->disconnect;
	if($subProcessCountTrue<$completeCounTrue){
		print "**Dw4 Daily Forecast complete count true = $subProcessCountTrue. Recheck after 60s\n";
		sleep(60);
		checkToTransferDailyForecastToDW3();
	}else{
		printTime("**Dw4 Daily Forecast is completed. Tranfert forecast data to dw3...");
		sleep(2);
		tranferFactTableFromDw4ToDw3('adstraffic.ad_response_fact_stats_forecast');	
	}


}

sub checkParam50{
	print "*Check to promote param 50!\n";
	sleep(2);
	my $subCountTrue=0;
	my $completeCountTrue=120;
	my $dbh = getConnection($host);
	my $query='SELECT COUNT(*) as count FROM control.process_concurrent_trans WHERE is_complete = true AND process_id=?';
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($param50ProcessID) ;
	$query_handle->bind_columns(undef, \$count);
	while($query_handle->fetch()) {	
		$subCountTrue=$count;
	}
	my $rv = $dbh->disconnect;	
	if($subCountTrue<$completeCountTrue){
		print "**Param 50 is not completed. Recheck after 60s\n";
		sleep(60);
		checkParam50();
	}else{
		print "**Param 50 is completed. Promote param 50\n";
		sleep(2);
		my $dbh = getConnection($host);
		my $query='select staging.fn_promote_daily_cumulative_ad_response_per_server()';
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute() ;
		my $rv = $dbh->disconnect;

		print "**Check to make sure Param is promoted...\n";
		sleep(2);
		my $dbh = getConnection($host);
		my $query='SELECT process_status FROM control.process WHERE process_config_id=50 AND dt_process_queued::date=? AND process_id=?';
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute($today_date,$param50ProcessID) ;
		$query_handle->bind_columns(undef, \$process_status);
		my $the_status='PS';
		while($query_handle->fetch()) {	
			$the_status=$process_status;
		}	
		my $rv = $dbh->disconnect;
		
		if($the_status ne 'SU'){
			print "**Check to make sure Param is promoted but promoted failed. Re-promote after 5s...\n";
			sleep(5);
			checkParam50();
		}else{
			printTime("**Param 50 is promoted!");		
			sleep(2);			
		}
	}
}

sub checkParam32{
	print "*Check to promote param 32!\n";
	sleep(2);
	my $subCountTrue=0;
	my $completeCountTrue=19;
	my $dbh = getConnection($host);
	my $query='SELECT COUNT(*) as count FROM control.process_concurrent_trans WHERE is_complete = true AND process_id=?';
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($param32ProcessID) ;
	$query_handle->bind_columns(undef, \$count);
	while($query_handle->fetch()) {	
		$subCountTrue=$count;
		print "*********** $subCountTrue \n";
	}
	my $rv = $dbh->disconnect;	
	if($subCountTrue<$completeCountTrue){
		print "**Param 32 is not completed. Recheck after 60s\n";
		sleep(60);
		checkParam32();
	}else{
		print "**Param 32 is completed. Promote param 32\n";
		sleep(2);
		my $dbh = getConnection($host);
		my $query='select staging.fn_promote_daily_copy_ad_responses()';
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute() ;
		my $rv = $dbh->disconnect;

		print "**Check to make sure Param is promoted...\n";
		sleep(2);
		my $dbh = getConnection($host);
		my $query='SELECT process_status FROM control.process WHERE process_config_id=32 AND dt_process_queued::date=?';
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute($today_date) ;
		$query_handle->bind_columns(undef, \$process_status);
		my $the_status='PS';
		while($query_handle->fetch()) {	
			$the_status=$process_status;
		}	
		my $rv = $dbh->disconnect;
		
		if($the_status ne 'SU'){
			print "**Check to make sure Param is promoted but promoted failed. Re-promote after 5s...\n";
			sleep(5);
			checkParam32();
		}else{
			printTime("**Param 32 is promoted!");	
			sleep(2);
		}

	}
}

sub checkParam13{
	print "*Check to promote param 13!\n";
	sleep(2);
	my $subCountTrue=0;
	my $completeCountTrue=6;
	my $dbh = getConnection($host);
	my $query='SELECT COUNT(*) as count FROM control.process_concurrent_trans WHERE is_complete = true AND process_id=?';
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($param13ProcessID) ;
	$query_handle->bind_columns(undef, \$count);
	while($query_handle->fetch()) {	
		$subCountTrue=$count;
	}
	my $rv = $dbh->disconnect;	
	if($subCountTrue<$completeCountTrue){
		print "**Param 13 is not completed. Recheck after 60s\n";
		sleep(60);
		checkParam13();
	}else{
		print "**Param 13 is completed. Promote param 13\n";
		sleep(2);
		my $dbh = getConnection($host);
		my $query='select staging.fn_promote_daily_cumulative_ad_response()';
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute() ;
		my $rv = $dbh->disconnect;

		print "**Check to make sure Param is promoted...\n";
		sleep(2);
		my $dbh = getConnection($host);
		my $query='SELECT process_status FROM control.process WHERE process_config_id=13 AND dt_process_queued::date=? AND process_id=?';
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute($today_date,$param13ProcessID) ;
		$query_handle->bind_columns(undef, \$process_status);
		my $the_status='PS';
		while($query_handle->fetch()) {	
			$the_status=$process_status;
		}	
		my $rv = $dbh->disconnect;
		
		if($the_status ne 'SU'){
			print "**Check to make sure Param is promoted but promoted failed. Re-promote after 5s...\n";
			sleep(5);
			checkParam13();
		}else{
			printTime("**Param 13 is promoted!");	
			sleep(2);			
		}
	
	}
}

sub updateCheckPoint{
	print "Update process_checkpoint of para 31 on Dw3\n...";
	sleep(2);
	my $dbh = getConnection('dw3');
	my $query='UPDATE control.process_checkpoint set last_key = ? where process_config_id = 31;';
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($report_date_sk) ;
	my $rv = $dbh->disconnect;
	
}

sub updateCheckPoint_forecast{
	print "Update process_checkpoint_forecast of para 13 on Dw3\n...";
	my $dbh = getConnection('dw3');
	my $query='UPDATE control.process_checkpoint set last_key = 7556 where process_config_id IN(11,16,66);';
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute() ;
	my $rv = $dbh->disconnect;
}

sub transferDailyAdcelStats{
	printTime("*Transfer adstraffic.daily_adcel_stats $report_date_sk");
	sleep(2);
	my $comand="cd /opt/temp/autoscripts/transformer && perl main.pl daily_fact dw4 dw3 adstraffic.daily_adcel_stats $report_date_sk adcelAutodaily_dw4.pl";
	system($comand);
	print "*Transfer adstraffic.daily_adcel_stats $report_date\n";
	sleep(2);
	my $comand="cd /opt/temp/autoscripts/transformer && perl mainWP.pl daily dw3 dw10 adstraffic.daily_adcel_stats $report_date adcelAutodaily_dw4.pl";
	system($comand);

}

sub tranferDimFromDw3ToDw4{
	printTime("* Transfer dim from dw3 to dw4");
	sleep(2);
	my $comand="ssh dw4 \'cd /u11/temp/daily_dim_temp/ && java -jar -Xmx2048m DIM_DW3_DW4.jar dim\' &";
	system($comand);
}
sub tranferFactTableFromDw4ToDw3{
	my $factTableName=shift;
	my $tack=shift;
	
	printTime("*Transfer fact table: $factTableName...");
	#Delete fact table by date before run tranfer script
		##print "*Delete fact table by date before run tranfer script...\n";
		##my $dbh = getConnection($master_host);	
		##my $query="DELETE FROM $factTableName WHERE eastern_date_sk=$report_date_sk";
		##print "* DELETE FROM $factTableName WHERE eastern_date_sk=$report_date_sk\n";
		##my $query_handle = $dbh->prepare($query);
		##$query_handle->execute() ;
		##my $rv = $dbh->disconnect;
	#Run transfer script to transfer factTable
	print "*Begining transfer...\n";
	my $comand="cd /opt/temp/autoscripts/transformer && perl mainF.pl daily_fact $host $master_host $factTableName $report_date_sk adcelAutodaily_dw4.pl";
	system($comand);
	#verify transfer completed
	print "*Verify transfer fact table: $factTableName...\n";
	my $isTransfered=0;
	my $row_count=0;
	my $dbh = getConnection($master_host);	
	my $query="SELECT COUNT(1) as row_count FROM $factTableName WHERE eastern_date_sk=$report_date_sk";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute() ;
	$query_handle->bind_columns(undef, \$row_count);
	while($query_handle->fetch()) {	
		if($row_count>0){
			$isTransfered=1;
		}else{
			$isTransfered=0;
		}
	}
	my $rv = $dbh->disconnect;
	
	if($isTransfered==0){
		print "*Stransfer fact table: $factTableName fasle. Restranfer after 2s\n";
		sleep(2);
		$tack++;
		if($tack>3){
			print "*Stransfer fact table: $factTableName fasle over $tack times . Please stop script and check account to run this script is file_xfer\n";
			sleep(99999999);
		}
		tranferFactTableFromDw4ToDw3($factTableName,$tack);
	}else{
		printTime("*Stransfer fact table: $factTableName $row_count Ok");
	}
}