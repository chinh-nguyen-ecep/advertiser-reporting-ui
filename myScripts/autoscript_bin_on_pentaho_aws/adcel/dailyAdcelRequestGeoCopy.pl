use Switch;
$host="localhost";
require "../auto_utils.pl";

main();

sub main{
	registerToEtlStatusPage();
	checkFileLoading('11');
	runParam(6,0);
	checkParam(6);
	promote(6);
	checkToRunGeo();
	runParam(7,0);
	checkParam(7);
	promote(7);
	runParam(8,0);
	checkParam(8);
	promote(8);
}

sub registerToEtlStatusPage{
	note("*Registe to ETL process page...");
	my $group_process_name="AdCel";	#the name of group process to register to daily process status table
	register_process($today_date,$group_process_name,6,'01:35:00','09:00:00');
	register_process($today_date,$group_process_name,7,'01:35:00','09:00:00');
	register_process($today_date,$group_process_name,8,'01:35:00','09:00:00');
	my ($sec,$min,$hour,$day,$month,$yr19,$WeekDay, $DayOfYear, $IsDST) =   localtime(time);
	if($WeekDay==0){
		
	};	
}
sub promote{
	my $param=shift;
	note("*Promote parameter: $param");
	switch($param) {
	  case 6 {		
		promoteParam("staging.fn_promote_daily_requests_report()");
		break;}	 
	  case 7 {		
		promoteParam("staging.fn_promote_daily_geo_report()");
		break;}	
	  case 8 {		
		promoteParam("staging.fn_promote_daily_copy_ad_responses()");
		break;}			
	};
	#check is promote
	my $isPromote=isPromoted($param,$host);
	if($isPromote==0){
	note("Can not promote parameter: $param . Romote again after 10s!");
		sleep(10);
		promote($param);
	}else{
		printTime("Completed!");
	}
}

sub checkToRunGeo{
	note("*Check to call Geo script...");
	my $count=0;
	my $dbh=getConnection($host);
	my $query="SELECT count(1) FROM control.process_checkpoint WHERE process_config_id IN (3,4,5,6) and last_key = ?";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($report_date_sk);
	$query_handle->bind_columns(undef, \$count);
	$query_handle->fetch();
	sqlDisconnect($dbh);
	if($count<4){
		note("Recheck after 60s!");
		sleep(60);
		checkToRunGeo();
	}else{
		note("Start Geo!");		
	}
}



