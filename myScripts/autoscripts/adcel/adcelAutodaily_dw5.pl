require "../bin/dw_utils.pl";

$today_date; # report date 2012-07-04
$report_date_sk='';
$host='dw5';
$master_host='dw4';
$param50ProcessID=0;
$param32ProcessID=0;
$param50ProcessIDonDw4=0;

if(@ARGV==1 && $ARGV[0]=='--help'){
	print "perl adcelAutodaily_dw5.pl\n";
}elsif(@ARGV==0){
	getDateSk();
	#tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app027_inday_stats_01');
	main();	
}else{
	print "perl adcelAutodaily_dw5.pl\n";
}
sub main{
	
	
	#register sub process to control.daily_process_status table.
	my $group_process_name="Adcel";	#the name of group process to register to daily process status table
	register_process($today_date,$group_process_name,32,'01:00:00','01:30:00');
	register_process($today_date,$group_process_name,50,'01:35:00','09:00:00');
	
	runParam32();
	checkParam32();
	checkIsCanStart();
	runParam50();
	checkToTransferDailyStatsToDW4();
	checkToTransferDailyFilledToDW4();
	checkToTransferDailyUnfilledToDW4();
	checkParam50();
	tranferDimFromDw3ToDw5();
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
	my $query='SELECT date_sk-1 as report_date_sk_key FROM refer.date_dim WHERE full_date=?';
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($today_date) ;
	$query_handle->bind_columns(undef, \$report_date_sk_key);
	while($query_handle->fetch()){	
			$report_date_sk=$report_date_sk_key;
	}
	my $rv = $dbh->disconnect;
	print "**Report date_sk=$report_date_sk\n";
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
		print "**The param 32 on dw5 is completed!...\n**Check param 50 on dw4...\n";
		sleep(2);
		#Check process 50 on dw4
		my $dbh = getConnection('dw4');
		my $query='SELECT process_id FROM control.process WHERE process_config_id=50 AND dt_process_queued::date=?';
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute($today_date) ;
		$query_handle->bind_columns(undef, \$process_id);
		while($query_handle->fetch()) {	
			if($process_id>0){
				$param50ProcessIDonDw4=$process_id;
			}
		}
		my $rv = $dbh->disconnect;
		if($param50ProcessIDonDw4==0){
			print "**The param 50 on dw4 is not runing. So we can't start param 50!\nRecheck after 60s!...\n";
			sleep(60);
			checkIsCanStart();	
		}else{
			print "**Param 50 on dw4 is runing with processID=$param50ProcessIDonDw4\n";
			print "**We can start process 50 now!...\n";
			sleep(2);
		}
	}

}

sub runParam50{
	print "*Run param 50 on dw5!\n";
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
		print "**Run param 50 with process ID=$param50ProcessID\n";
		sleep(2);
	}

}

sub runParam32{
	print "*Run param 32 on dw5!\n";
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
		print "**Run param 32 with process ID=$param32ProcessID\n";
		sleep(2);
		my $query="UPDATE control.process_concurrent_trans
		SET is_complete = true, dt_lastchange = current_timestamp
		WHERE process_id=? AND concurrent_trans_name in (
		'fn_build_ad_response_fact_copy_app3-adcel',
		'fn_build_ad_response_fact_copy_app4-adcel',
		'fn_build_ad_response_fact_copy_app6-adcel',
		'fn_build_ad_response_fact_copy_app8-adcel',
		'fn_build_ad_response_fact_copy_app9-adcel',
		'fn_build_ad_response_fact_copy_app018-adcel',
		'fn_build_ad_response_fact_copy_app019-adcel',
		'fn_build_ad_response_fact_copy_app021-adcel',
		'fn_build_ad_response_fact_copy_app024-adcel'
		);";
		my $dbh = getConnection($host);
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute($param32ProcessID) ;	
		my $rv = $dbh->disconnect;
	}
}

sub checkToTransferDailyStatsToDW4{
	print "*Check Daily Stats 01!\n";
	sleep(2);
	my $subProcessCountTrue=0;
	my $completeCounTrue=10;
	my $dbh = getConnection($host);
	my $query="
	SELECT COUNT(*) as count FROM control.process_concurrent_trans
	WHERE concurrent_trans_name IN (
	'fn_build_ad_response_fact_stats_01_app027-adcel',
	'fn_build_ad_response_fact_stats_01_app026-adcel',
	'fn_build_ad_response_fact_stats_01_app025-adcel',
	'fn_build_ad_response_fact_stats_01_app020-adcel',
	'fn_build_ad_response_fact_stats_01_app017-adcel',
	'fn_build_ad_response_fact_stats_01_app016-adcel',
	'fn_build_ad_response_fact_stats_01_app015-adcel',
	'fn_build_ad_response_fact_stats_01_app12-adcel',
	'fn_build_ad_response_fact_stats_01_app13-adcel',
	'fn_build_ad_response_fact_stats_01_app14-adcel')
	AND process_id=?
	AND is_complete=true
	";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($param50ProcessID) ;	
	$query_handle->bind_columns(undef, \$count);
	while($query_handle->fetch()) {	
		$subProcessCountTrue=$count;
	}
	my $rv = $dbh->disconnect;
	if($subProcessCountTrue<$completeCounTrue){
		print "**Dw5 Daily stats_01 complete count true = $subProcessCountTrue. Recheck after 60s\n";
		sleep(60);
		checkToTransferDailyStatsToDW4();
	}else{
		print "**Dw5 Daily stats_01 is completed. Tranfert data to dw4...\n";
		sleep(2);
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app027_inday_stats_01');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app026_inday_stats_01');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app025_inday_stats_01');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app020_inday_stats_01');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app017_inday_stats_01');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app016_inday_stats_01');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app015_inday_stats_01');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app14_inday_stats_01');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app13_inday_stats_01');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app12_inday_stats_01');

		print "**Update status on Dw4...\n";
		sleep(2);
		my $dbh = getConnection('dw4');
		my $query="
		UPDATE control.process_concurrent_trans
		SET is_complete = true, dt_lastchange = current_timestamp
		WHERE process_id=? AND concurrent_trans_name in (
		\'fn_build_ad_response_fact_stats_01_app027-adcel\',
		\'fn_build_ad_response_fact_stats_01_app026-adcel\',
		\'fn_build_ad_response_fact_stats_01_app025-adcel\',
		\'fn_build_ad_response_fact_stats_01_app020-adcel\',
		\'fn_build_ad_response_fact_stats_01_app017-adcel\',
		\'fn_build_ad_response_fact_stats_01_app016-adcel\',
		\'fn_build_ad_response_fact_stats_01_app015-adcel\',
		\'fn_build_ad_response_fact_stats_01_app12-adcel\',
		\'fn_build_ad_response_fact_stats_01_app13-adcel\',
		\'fn_build_ad_response_fact_stats_01_app14-adcel\'
		)
		";
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute($param50ProcessIDonDw4) ;	
		print $query_handle."\n";
		my $rv = $dbh->disconnect;
	}

}

sub checkToTransferDailyFilledToDW4{
	print "*Check Daily Filled!\n";
	sleep(2);
	my $subProcessCountTrue=0;
	my $completeCounTrue=20;
	my $dbh = getConnection($host);
	my $query="
	SELECT COUNT(*) as count FROM control.process_concurrent_trans
	WHERE concurrent_trans_name IN (
	\'fn_build_ad_response_fact_filled_filter_app027-adcel\',
	\'fn_build_ad_response_fact_filled_filter_app026-adcel\',
	\'fn_build_ad_response_fact_filled_filter_app025-adcel\',
	\'fn_build_ad_response_fact_filled_filter_app020-adcel\',
	\'fn_build_ad_response_fact_filled_filter_app017-adcel\',
	\'fn_build_ad_response_fact_filled_filter_app016-adcel\',
	\'fn_build_ad_response_fact_filled_filter_app015-adcel\',
	\'fn_build_ad_response_fact_filled_filter_app12-adcel\',
	\'fn_build_ad_response_fact_filled_filter_app13-adcel\',
	\'fn_build_ad_response_fact_filled_filter_app14-adcel\',
	\'fn_build_ad_response_fact_filled_location_app027-adcel\',
	\'fn_build_ad_response_fact_filled_location_app026-adcel\',
	\'fn_build_ad_response_fact_filled_location_app025-adcel\',
	\'fn_build_ad_response_fact_filled_location_app020-adcel\',
	\'fn_build_ad_response_fact_filled_location_app017-adcel\',
	\'fn_build_ad_response_fact_filled_location_app016-adcel\',
	\'fn_build_ad_response_fact_filled_location_app015-adcel\',
	\'fn_build_ad_response_fact_filled_location_app12-adcel\',
	\'fn_build_ad_response_fact_filled_location_app13-adcel\',
	\'fn_build_ad_response_fact_filled_location_app14-adcel\'
	)
	AND process_id=?
	AND is_complete=true
	";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($param50ProcessID) ;	
	$query_handle->bind_columns(undef, \$count);
	while($query_handle->fetch()) {	
		$subProcessCountTrue=$count;
	}
	my $rv = $dbh->disconnect;
	if($subProcessCountTrue<$completeCounTrue){
		print "**Dw5 Daily Filled complete count true = $subProcessCountTrue. Recheck after 60s\n";
		sleep(60);
		checkToTransferDailyFilledToDW4();
	}else{
		print "**Dw5 Daily Filled is completed. Tranfert filled data to dw4...\n";
		sleep(2);
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app027_inday_filled_location');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app026_inday_filled_location');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app025_inday_filled_location');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app020_inday_filled_location');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app017_inday_filled_location');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app016_inday_filled_location');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app015_inday_filled_location');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app14_inday_filled_location');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app13_inday_filled_location');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app12_inday_filled_location');

		print "*Update status on Dw4...\n";
		sleep(2);
		my $dbh = getConnection('dw4');
		my $query="
		UPDATE control.process_concurrent_trans
		SET is_complete = true, dt_lastchange = current_timestamp
		WHERE process_id=? AND concurrent_trans_name in (
		\'fn_build_ad_response_fact_filled_filter_app027-adcel\',
		\'fn_build_ad_response_fact_filled_filter_app026-adcel\',
		\'fn_build_ad_response_fact_filled_filter_app025-adcel\',
		\'fn_build_ad_response_fact_filled_filter_app020-adcel\',
		\'fn_build_ad_response_fact_filled_filter_app017-adcel\',
		\'fn_build_ad_response_fact_filled_filter_app016-adcel\',
		\'fn_build_ad_response_fact_filled_filter_app015-adcel\',
		\'fn_build_ad_response_fact_filled_filter_app12-adcel\',
		\'fn_build_ad_response_fact_filled_filter_app13-adcel\',
		\'fn_build_ad_response_fact_filled_filter_app14-adcel\',
		\'fn_build_ad_response_fact_filled_location_app027-adcel\',
		\'fn_build_ad_response_fact_filled_location_app026-adcel\',
		\'fn_build_ad_response_fact_filled_location_app025-adcel\',
		\'fn_build_ad_response_fact_filled_location_app020-adcel\',
		\'fn_build_ad_response_fact_filled_location_app017-adcel\',
		\'fn_build_ad_response_fact_filled_location_app016-adcel\',
		\'fn_build_ad_response_fact_filled_location_app015-adcel\',
		\'fn_build_ad_response_fact_filled_location_app12-adcel\',
		\'fn_build_ad_response_fact_filled_location_app13-adcel\',
		\'fn_build_ad_response_fact_filled_location_app14-adcel\'
		)
		";
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute($param50ProcessIDonDw4) ;	
		my $rv = $dbh->disconnect;	
	}

}

sub checkToTransferDailyUnfilledToDW4{
	print "*Check Daily Unfilled!\n";
	sleep(2);
	my $subProcessCountTrue=0;
	my $completeCounTrue=30;
	my $dbh = getConnection($host);
	my $query="
	SELECT COUNT(*) as count FROM control.process_concurrent_trans
	WHERE concurrent_trans_name IN (
	\'fn_build_ad_response_fact_unfilled_copy_app027-adcel\',
	\'fn_build_ad_response_fact_unfilled_copy_app026-adcel\',
	\'fn_build_ad_response_fact_unfilled_copy_app025-adcel\',
	\'fn_build_ad_response_fact_unfilled_copy_app020-adcel\',
	\'fn_build_ad_response_fact_unfilled_copy_app017-adcel\',
	\'fn_build_ad_response_fact_unfilled_copy_app016-adcel\',
	\'fn_build_ad_response_fact_unfilled_copy_app015-adcel\',
	\'fn_build_ad_response_fact_unfilled_copy_app12-adcel\',
	\'fn_build_ad_response_fact_unfilled_copy_app13-adcel\',
	\'fn_build_ad_response_fact_unfilled_copy_app14-adcel\',
	\'fn_build_ad_response_fact_unfilled_filter_app027-adcel\',
	\'fn_build_ad_response_fact_unfilled_filter_app026-adcel\',
	\'fn_build_ad_response_fact_unfilled_filter_app025-adcel\',
	\'fn_build_ad_response_fact_unfilled_filter_app020-adcel\',
	\'fn_build_ad_response_fact_unfilled_filter_app017-adcel\',
	\'fn_build_ad_response_fact_unfilled_filter_app016-adcel\',
	\'fn_build_ad_response_fact_unfilled_filter_app015-adcel\',
	\'fn_build_ad_response_fact_unfilled_filter_app12-adcel\',
	\'fn_build_ad_response_fact_unfilled_filter_app13-adcel\',
	\'fn_build_ad_response_fact_unfilled_filter_app14-adcel\',
	\'fn_build_ad_response_fact_unfilled_location_app027-adcel\',
	\'fn_build_ad_response_fact_unfilled_location_app026-adcel\',
	\'fn_build_ad_response_fact_unfilled_location_app025-adcel\',
	\'fn_build_ad_response_fact_unfilled_location_app020-adcel\',
	\'fn_build_ad_response_fact_unfilled_location_app017-adcel\',
	\'fn_build_ad_response_fact_unfilled_location_app016-adcel\',
	\'fn_build_ad_response_fact_unfilled_location_app015-adcel\',
	\'fn_build_ad_response_fact_unfilled_location_app12-adcel\',
	\'fn_build_ad_response_fact_unfilled_location_app13-adcel\',
	\'fn_build_ad_response_fact_unfilled_location_app14-adcel\'
	)
	AND process_id=?
	AND is_complete=true
	";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($param50ProcessID) ;	
	$query_handle->bind_columns(undef, \$count);
	while($query_handle->fetch()) {	
		$subProcessCountTrue=$count;
	}
	my $rv = $dbh->disconnect;
	if($subProcessCountTrue<$completeCounTrue){
		print "**Dw5 Daily Unfilled complete count true = $subProcessCountTrue. Recheck after 60s\n";
		sleep(60);
		checkToTransferDailyUnfilledToDW4();
	}else{
		print "**Dw5 Daily Unfilled is completed. Tranfert unfilled data to dw4...\n";
		sleep(2);
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app027_inday_unfilled_location');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app026_inday_unfilled_location');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app025_inday_unfilled_location');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app020_inday_unfilled_location');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app017_inday_unfilled_location');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app016_inday_unfilled_location');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app015_inday_unfilled_location');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app14_inday_unfilled_location');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app13_inday_unfilled_location');
		tranferFactTableFromDw5ToDw4('adstraffic.ad_response_fact_app12_inday_unfilled_location');

		print "*Update status on Dw4...\n";
		sleep(2);
		my $dbh = getConnection('dw4');
		my $query="
		UPDATE control.process_concurrent_trans
		SET is_complete = true, dt_lastchange = current_timestamp
		WHERE process_id=? AND concurrent_trans_name in (
		\'fn_build_ad_response_fact_unfilled_copy_app027-adcel\',
		\'fn_build_ad_response_fact_unfilled_copy_app026-adcel\',
		\'fn_build_ad_response_fact_unfilled_copy_app025-adcel\',
		\'fn_build_ad_response_fact_unfilled_copy_app020-adcel\',
		\'fn_build_ad_response_fact_unfilled_copy_app017-adcel\',
		\'fn_build_ad_response_fact_unfilled_copy_app016-adcel\',
		\'fn_build_ad_response_fact_unfilled_copy_app015-adcel\',
		\'fn_build_ad_response_fact_unfilled_copy_app12-adcel\',
		\'fn_build_ad_response_fact_unfilled_copy_app13-adcel\',
		\'fn_build_ad_response_fact_unfilled_copy_app14-adcel\',
		\'fn_build_ad_response_fact_unfilled_filter_app027-adcel\',
		\'fn_build_ad_response_fact_unfilled_filter_app026-adcel\',
		\'fn_build_ad_response_fact_unfilled_filter_app025-adcel\',
		\'fn_build_ad_response_fact_unfilled_filter_app020-adcel\',
		\'fn_build_ad_response_fact_unfilled_filter_app017-adcel\',
		\'fn_build_ad_response_fact_unfilled_filter_app016-adcel\',
		\'fn_build_ad_response_fact_unfilled_filter_app015-adcel\',
		\'fn_build_ad_response_fact_unfilled_filter_app12-adcel\',
		\'fn_build_ad_response_fact_unfilled_filter_app13-adcel\',
		\'fn_build_ad_response_fact_unfilled_filter_app14-adcel\',
		\'fn_build_ad_response_fact_unfilled_location_app027-adcel\',
		\'fn_build_ad_response_fact_unfilled_location_app026-adcel\',
		\'fn_build_ad_response_fact_unfilled_location_app025-adcel\',
		\'fn_build_ad_response_fact_unfilled_location_app020-adcel\',
		\'fn_build_ad_response_fact_unfilled_location_app017-adcel\',
		\'fn_build_ad_response_fact_unfilled_location_app016-adcel\',
		\'fn_build_ad_response_fact_unfilled_location_app015-adcel\',
		\'fn_build_ad_response_fact_unfilled_location_app12-adcel\',
		\'fn_build_ad_response_fact_unfilled_location_app13-adcel\',
		\'fn_build_ad_response_fact_unfilled_location_app14-adcel\'
		)
		";
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute($param50ProcessIDonDw4) ;	
		print $query_handle."\n";
		my $rv = $dbh->disconnect;	
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
		my $dbh = getConnection($host);
		my $query='SELECT process_status FROM control.process WHERE process_config_id=50 AND dt_process_queued::date=?';
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
			checkParam50();
		}else{
			print "**Param 50 is promoted!\n";	
			sleep(2);
		}

	}
}

sub checkParam32{
	print "*Check to promote param 32!\n";
	sleep(5);
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
		print "**Param 32 is completed. Promote param 32...\n";
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
			print "**Param 32 is promoted!\n";	
		}

	}
}

sub tranferDimFromDw3ToDw5{
	print "* Transfer dim from dw3 to dw5\n";
	sleep(2);
	my $comand="ssh dw5 \'cd /u11/temp/dim_daily_dw3_dw5/ && java -jar -Xmx2048m DIM_DW3_DW5.jar dim\'";
	system($comand);
}
sub tranferFactTableFromDw5ToDw4{
	my $factTableName=shift;
	my $tack=shift;
	
	print "*Transfer fact table: $factTableName...\n";
	#Truncate fact table by date before run tranfer script
	print "*Truncate fact table before run tranfer script...\n";
	my $dbh = getConnection($master_host);	
	my $query="TRUNCATE $factTableName";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute() ;
	my $rv = $dbh->disconnect;
	#Run transfer script to transfer factTable
	print "*Begining transfer...";
	my $comand="cd /opt/temp/autoscripts/transformer && perl mainF.pl table $host $master_host $factTableName";
	system($comand);
	#verify transfer completed
	print "*Verify transfer fact table: $factTableName...\n";
	my $isTransfered=0;
	my $row_count=0;
	my $dbh = getConnection($master_host);	
	my $query="SELECT COUNT(1) as row_count FROM $factTableName";
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
		$tack++;
		if($tack>3){
			print "*Stransfer fact table: $factTableName fasle over $tack times . Please stop script and check account to run this script is file_xfer\n";
			sleep(99999999);
		}
		
		print "*Stransfer fact table: $factTableName fasle. Restranfer after 2s\n";
		sleep(2);

		tranferFactTableFromDw5ToDw4($factTableName,$tack);
	}else{
		print "*Stransfer fact table: $factTableName $row_count Ok\n";
	}
}
