use Switch;
$host="localhost";
require "../auto_utils.pl";

main();

sub main{
	note("*Daily Event DMA Process");
	registerToEtlStatusPage();
	checkFileLoading('6');
	runParam(11,0);
	checkParam(11);
	promote(11);
	checkToRunCopy();
	runParam(15,0);
	checkParam(15);
	promote(15);	
}

sub registerToEtlStatusPage{
	note("*Registe to ETL process page...");
	my $group_process_name="Event Tracker";	#the name of group process to register to daily process status table
	register_process($today_date,$group_process_name,11,'01:35:00','09:00:00');
	register_process($today_date,$group_process_name,15,'01:35:00','09:00:00');
	my ($sec,$min,$hour,$day,$month,$yr19,$WeekDay, $DayOfYear, $IsDST) =   localtime(time);
	if($WeekDay==0){
		
	};	
}
sub promote{
	my $param=shift;
	note("*Promote parameter: $param");
	switch($param) {
	  case 11 {		
		promoteParam("staging.fn_promote_daily_event_dma_report()");		
		break;}	  
	  case 15 {		
		promoteParam("staging.fn_promote_daily_copy_event_tracker()");		
		break;}	  
		};
	my $isPromote=isPromoted($param,$host);
	if($isPromote==0){
		note("Can not promote parameter: $param . Romote again after 10s!");
		sleep(10);
		promote($param);
	}else{
		printTime("Completed!");
	}
}

sub checkToRunCopy{
	note("*Check to call Copy script...");
	my $count=0;
	my $dbh=getConnection($host);
	my $query="SELECT count(1) FROM control.process_checkpoint WHERE process_config_id IN (11,12) and last_key = ?";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($report_date_sk);
	$query_handle->bind_columns(undef, \$count);
	$query_handle->fetch();
	sqlDisconnect($dbh);
	if($count<5){
		note("Recheck after 60s!");
		sleep(60);
		checkToRunCopy();
	}else{
		note("Start Copy!");		
	}
}

