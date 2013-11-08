require "../bin/dw_utils.pl";

$today_date; # report date 2012-07-04
$report_date='';
$report_date_sk='';
$host='dw4';
$param50ProcessID=0;
$param13ProcessID=0;
if(@ARGV==1 && $ARGV[0]=='--help'){
	print "perl adcelAutodaily_firstJob.pl\n";
}elsif(@ARGV==0){
	main();
}else{
	print "perl adcelAutodaily_firstJob.pl\n";
}

sub main{
	getDateSk();
	#register sub process to control.daily_process_status table.
	my $group_process_name="Adcel";	#the name of group process to register to daily process status table
	register_process($today_date,$group_process_name,31,'00:40:00','00:50:00');
	$host='dw5';
	register_process($today_date,$group_process_name,31,'00:40:00','00:50:00');
	$host='dw4';
#	checkAdcelFiles();
	truncateData();
	resolveMissingUserAgent();
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

	print "*Get report date_sk!\n";
	my $dbh = getConnection('dw3');
	my $query='SELECT date_sk-1 as report_date_sk_key,full_date-1 as full_date FROM refer.date_dim WHERE full_date=?';
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($today_date) or die $DBI::errstr;
	$query_handle->bind_columns(undef, \$report_date_sk_key,\$full_date);
	while($query_handle->fetch()){	
			$report_date_sk=$report_date_sk_key;
			$report_date=$full_date;
	}
	my $rv = $dbh->disconnect;
	print "**Report date_sk=$report_date_sk\n**Report date=$report_date\n";
}

sub checkAdcelFiles{
	note("*Check Adcel files!");
	my $date=$report_date;
	$date=~s/-//g;
	my $total_file_dw4=0;
	my $loaded_file_dw4=0;
	my $fail_file_dw4=0;
	my $total_file_dw5=0;
	my $loaded_file_dw5=0;
	my $fail_file_dw5=0;	
	my $query="select b.total as total_file, count(*) as loaded_file, c.fail as fail_file
	from control.data_file 
	,(select count(*) as total from control.data_file where file_name like ?) b
	,(select count(*) as fail from control.data_file where file_name like ? and file_status='EF') c
	where file_name like ? and file_status='SU'
	group by b.total,c.fail";
	#On dw4
	my $dbh = getConnection('dw4');
	$query_handle = $dbh->prepare($query);
	$query_handle->execute("%ad_response\.$date%","%ad_response\.$date%","%ad_response\.$date%");
	$query_handle->bind_columns(undef, \$total_file,\$loaded_file,\$fail_file);
	while($query_handle->fetch()) {
		$total_file_dw4=$total_file;
		$loaded_file_dw4=$loaded_file;
		$fail_file_dw4=$fail_file;
	}
	print "**Total file on dw4: $total_file_dw4 \t Loaded: $loaded_file_dw4 \t Fail: $fail_file_dw4\n";
	my $rv = $dbh->disconnect;

	#On dw5
	my $dbh = getConnection('dw5');
	$query_handle = $dbh->prepare($query);
	$query_handle->execute("%ad_response\.$date%","%ad_response\.$date%","%ad_response\.$date%");
	$query_handle->bind_columns(undef, \$total_file,\$loaded_file,\$fail_file);
	while($query_handle->fetch()) {
		$total_file_dw5=$total_file;
		$loaded_file_dw5=$loaded_file;
		$fail_file_dw5=$fail_file;
	}
	print "**Total file on dw5: $total_file_dw5 \t Loaded: $loaded_file_dw5 \t Fail: $fail_file_dw5\n";
	my $rv = $dbh->disconnect;
	
	if($total_file_dw4==$loaded_file_dw4 && $total_file_dw4>0 && $fail_file_dw4==0 && $total_file_dw5==$loaded_file_dw5 && $total_file_dw5>0 && $fail_file_dw5==0 && $total_file_dw4==$total_file_dw5){
		note("**Adcel files loading is completed with total file= $total_file");
	}else{
		note("**Adcel files loading is not completed.\n**Recheck after 60s");
		sleep(60);
		checkAdcelFiles();
	}	
}


sub truncateData{
	print "*Truncate data!\n";
	print "**Truncate data on dw3...\n";
	my $dbh = getConnection('dw3');
	my $query="
	truncate adstraffic.dw4_ad_response_fact_app015_user_agent;
	truncate adstraffic.dw4_ad_response_fact_app016_user_agent;
	truncate adstraffic.dw4_ad_response_fact_app017_user_agent;
	truncate adstraffic.dw4_ad_response_fact_app018_user_agent;
	truncate adstraffic.dw4_ad_response_fact_app019_user_agent;
	truncate adstraffic.dw4_ad_response_fact_app020_user_agent;
	truncate adstraffic.dw4_ad_response_fact_app021_user_agent;
	truncate adstraffic.dw4_ad_response_fact_app024_user_agent;
	truncate adstraffic.dw4_ad_response_fact_app025_user_agent;
	truncate adstraffic.dw4_ad_response_fact_app026_user_agent;
	truncate adstraffic.dw4_ad_response_fact_app027_user_agent;
	truncate adstraffic.dw4_ad_response_fact_app12_user_agent;
	truncate adstraffic.dw4_ad_response_fact_app13_user_agent;
	truncate adstraffic.dw4_ad_response_fact_app14_user_agent;
	truncate adstraffic.dw4_ad_response_fact_app3_user_agent;
	truncate adstraffic.dw4_ad_response_fact_app4_user_agent;
	truncate adstraffic.dw4_ad_response_fact_app6_user_agent;
	truncate adstraffic.dw4_ad_response_fact_app8_user_agent;
	truncate adstraffic.dw4_ad_response_fact_app9_user_agent;
	truncate adstraffic.dw5_ad_response_fact_app015_user_agent;
	truncate adstraffic.dw5_ad_response_fact_app016_user_agent;
	truncate adstraffic.dw5_ad_response_fact_app017_user_agent;
	truncate adstraffic.dw5_ad_response_fact_app018_user_agent;
	truncate adstraffic.dw5_ad_response_fact_app019_user_agent;
	truncate adstraffic.dw5_ad_response_fact_app020_user_agent;
	truncate adstraffic.dw5_ad_response_fact_app021_user_agent;
	truncate adstraffic.dw5_ad_response_fact_app024_user_agent;
	truncate adstraffic.dw5_ad_response_fact_app025_user_agent;
	truncate adstraffic.dw5_ad_response_fact_app026_user_agent;
	truncate adstraffic.dw5_ad_response_fact_app027_user_agent;
	truncate adstraffic.dw5_ad_response_fact_app12_user_agent;
	truncate adstraffic.dw5_ad_response_fact_app13_user_agent;
	truncate adstraffic.dw5_ad_response_fact_app14_user_agent;
	truncate adstraffic.dw5_ad_response_fact_app3_user_agent;
	truncate adstraffic.dw5_ad_response_fact_app4_user_agent;
	truncate adstraffic.dw5_ad_response_fact_app6_user_agent;
	truncate adstraffic.dw5_ad_response_fact_app8_user_agent;
	truncate adstraffic.dw5_ad_response_fact_app9_user_agent;
	";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute() or die $DBI::errstr;
	my $rv = $dbh->disconnect;
	# Truncate on dw4
	print "**Truncate data on dw4...\n";
	my $dbh = getConnection('dw4');
	my $query="
	truncate adstraffic.ad_response_fact_app3_inday;
	truncate adstraffic.ad_response_fact_app4_inday;
	truncate adstraffic.ad_response_fact_app6_inday;
	truncate adstraffic.ad_response_fact_app8_inday;
	truncate adstraffic.ad_response_fact_app9_inday;
	truncate adstraffic.ad_response_fact_app12_inday;
	truncate adstraffic.ad_response_fact_app13_inday;
	truncate adstraffic.ad_response_fact_app14_inday;
	truncate adstraffic.ad_response_fact_app015_inday;
	truncate adstraffic.ad_response_fact_app016_inday;
	truncate adstraffic.ad_response_fact_app017_inday;
	truncate adstraffic.ad_response_fact_app018_inday;
	truncate adstraffic.ad_response_fact_app019_inday;
	truncate adstraffic.ad_response_fact_app020_inday;
	truncate adstraffic.ad_response_fact_app021_inday;
	truncate adstraffic.ad_response_fact_app024_inday;
	truncate adstraffic.ad_response_fact_app025_inday;
	truncate adstraffic.ad_response_fact_app026_inday;
	truncate adstraffic.ad_response_fact_app027_inday;
	truncate adstraffic.ad_response_fact_app027_inday_unfilled_location;
	truncate adstraffic.ad_response_fact_app026_inday_unfilled_location;
	truncate adstraffic.ad_response_fact_app025_inday_unfilled_location;
	truncate adstraffic.ad_response_fact_app020_inday_unfilled_location;
	truncate adstraffic.ad_response_fact_app017_inday_unfilled_location;
	truncate adstraffic.ad_response_fact_app016_inday_unfilled_location;
	truncate adstraffic.ad_response_fact_app015_inday_unfilled_location;
	truncate adstraffic.ad_response_fact_app12_inday_unfilled_location;
	truncate adstraffic.ad_response_fact_app13_inday_unfilled_location;
	truncate adstraffic.ad_response_fact_app14_inday_unfilled_location;
	truncate adstraffic.ad_response_fact_app027_inday_filled_location;
	truncate adstraffic.ad_response_fact_app026_inday_filled_location;
	truncate adstraffic.ad_response_fact_app025_inday_filled_location;
	truncate adstraffic.ad_response_fact_app020_inday_filled_location;
	truncate adstraffic.ad_response_fact_app017_inday_filled_location;
	truncate adstraffic.ad_response_fact_app016_inday_filled_location;
	truncate adstraffic.ad_response_fact_app015_inday_filled_location;
	truncate adstraffic.ad_response_fact_app12_inday_filled_location;
	truncate adstraffic.ad_response_fact_app13_inday_filled_location;
	truncate adstraffic.ad_response_fact_app14_inday_filled_location;
	truncate adstraffic.ad_response_fact_app027_inday_filled;
	truncate adstraffic.ad_response_fact_app026_inday_filled;
	truncate adstraffic.ad_response_fact_app025_inday_filled;
	truncate adstraffic.ad_response_fact_app020_inday_filled;
	truncate adstraffic.ad_response_fact_app017_inday_filled;
	truncate adstraffic.ad_response_fact_app016_inday_filled;
	truncate adstraffic.ad_response_fact_app015_inday_filled;
	truncate adstraffic.ad_response_fact_app12_inday_filled;
	truncate adstraffic.ad_response_fact_app13_inday_filled;
	truncate adstraffic.ad_response_fact_app14_inday_filled;
	truncate adstraffic.ad_response_fact_app027_inday_stats_01;
	truncate adstraffic.ad_response_fact_app026_inday_stats_01;
	truncate adstraffic.ad_response_fact_app025_inday_stats_01;
	truncate adstraffic.ad_response_fact_app020_inday_stats_01;
	truncate adstraffic.ad_response_fact_app017_inday_stats_01;
	truncate adstraffic.ad_response_fact_app016_inday_stats_01;
	truncate adstraffic.ad_response_fact_app015_inday_stats_01;
	truncate adstraffic.ad_response_fact_app12_inday_stats_01;
	truncate adstraffic.ad_response_fact_app13_inday_stats_01;
	truncate adstraffic.ad_response_fact_app14_inday_stats_01;
	";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute() or die $DBI::errstr;
	my $rv = $dbh->disconnect;
	
	print "**Truncate data on dw5...\n";
	my $dbh = getConnection('dw5');
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute() or die $DBI::errstr;
	my $rv = $dbh->disconnect;
}

sub resolveMissingUserAgent{
	print "*RESOLVE MISSING USER AGENT............................\n";
	sleep(5);
	
	print "**Transfer missing user agent from dw4 to master server dw3...\n";
	sleep(5);
	my $comand="ssh dw4 \'cd /u11/temp/daily_user_agent/ && java -jar USER_AGENT_DW3_DW4.jar usergent $report_date\'";
	system($comand);

	
	print "**Transfer missing user agent from dw5 to master server dw3...\n";
	sleep(5);
	my $comand="ssh dw5 \'cd /u11/temp/dim_daily_dw3_dw5/ && java -jar USER_AGENT_DW3_DW5.jar usergent $report_date\'";
	system($comand);

	
	print "**Insert new user agent on master server...\n";
	sleep(5);
	my $dbh = getConnection('dw3');
	my $query="
	select staging.fn_build_resolve_ad_response_fact_user_agent_dw4(1,1,'PS');
	select staging.fn_build_resolve_ad_response_fact_user_agent_dw5(1,1,'PS');
	";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute() or die $DBI::errstr;
	my $rv = $dbh->disconnect;
	
	print "**Transfer new user agent to ETL server dw4...\n";
	sleep(5);
	my $comand="ssh dw4 \'cd /u11/temp/daily_dim_temp/ && java -jar Tranfer_User_Agent_Data.jar tranfer\'";
	system($comand);	
	
	print "**Transfer new user agent to ETL server dw5...\n";
	sleep(5);
	my $comand="ssh dw5 \'cd /u11/temp/dim_daily_dw3_dw5/ && java -jar Tranfer_User_Agent_Data.jar tranfer\'";
	system($comand);	
	
	print "**Resolve missing user agent on ETL server dw4...\n";
	sleep(5);
	my $dbh = getConnection('dw4');
	my $query="
	select staging.fn_manage_ad_response_process_tasks(31);
	select staging.fn_refresh_daily_resolve_user_agent('fn_build_resolve_adcel_user_agent_by_master');
	select staging.fn_promote_daily_resolve_user_agent();
	";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute() or die $DBI::errstr;
	my $rv = $dbh->disconnect;
	
	print "**Resolve missing user agent on ETL server dw5...\n";
	sleep(5);
	my $dbh = getConnection('dw5');
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute() or die $DBI::errstr;
	my $rv = $dbh->disconnect;
	
	# Check on Dw4 to run param 32
	my $row_count_dw4=0;
	my $row_count_dw5=0;
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
	#On dw4
	my $dbh = getConnection('dw4');
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	$query_handle->bind_columns(undef, \$row_count);		

	while($query_handle->fetch()) {
	   $row_count_dw4=$row_count;
	} 
	my $rv = $dbh->disconnect;
	
	#On dw5
	my $dbh = getConnection('dw5');
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	$query_handle->bind_columns(undef, \$row_count);		

	while($query_handle->fetch()) {
	   $row_count_dw5=$row_count;
	} 
	my $rv = $dbh->disconnect;
	
	if($row_count_dw4 > 0 || $row_count_dw5 >0){
		#resolveMissingUserAgent();
		print "***** Please check again!\n";
	}else{
		system("perl adcelAutodaily_dw4.pl >monitor/$today_date.dw4.log 2>errors/$today_date.dw4.error &");
		system("perl adcelAutodaily_dw5.pl >monitor/$today_date.dw5.log 2>errors/$today_date.dw5.error &");
	}
	

	
}
