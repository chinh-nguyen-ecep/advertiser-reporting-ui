use Switch;
$host="localhost";
require "../auto_utils.pl";

main();

sub main{
	registerToEtlStatusPage();
	checkFileLoading('19');
	runParam(19,0);
	checkParam(19);
	promote(19);
}

sub registerToEtlStatusPage{
	note("*Registe to ETL process page...");
	my $group_process_name="3rdAdnetwork";	#the name of group process to register to daily process status table
	register_process($today_date,$group_process_name,19,'01:35:00','09:00:00');
	my ($sec,$min,$hour,$day,$month,$yr19,$WeekDay, $DayOfYear, $IsDST) =   localtime(time);
	if($WeekDay==0){
		
	};	
}
sub promote{
	my $param=shift;
	note("*Promote parameter: $param");
	switch($param) {
	  case 19 {		
		promoteParam("staging.fn_promote_daily_city_grid_mobile_performance_report()");		
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

