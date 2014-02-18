use Switch;
$host="localhost";
require "../auto_utils.pl";

main();

sub main{
	registerToEtlStatusPage();
	checkFileLoading('20');
	runParam(24,0);
	checkParam(24);
	promote(24);
}

sub registerToEtlStatusPage{
	note("*Registe to ETL process page...");
	my $group_process_name="3rdAdnetwork";	#the name of group process to register to daily process status table
	register_process($today_date,$group_process_name,24,'01:35:00','09:00:00');
	my ($sec,$min,$hour,$day,$month,$yr19,$WeekDay, $DayOfYear, $IsDST) =   localtime(time);
	if($WeekDay==0){
		
	};	
}
sub promote{
	my $param=shift;
	note("*Promote parameter: $param");
	switch($param) {
	  case 24 {		
		promoteParam("staging.fn_promote_daily_klickthru_performance_report()");		
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

