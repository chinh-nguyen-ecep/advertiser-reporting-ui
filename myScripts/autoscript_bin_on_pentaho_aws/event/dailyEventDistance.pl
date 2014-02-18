use Switch;
$host="localhost";
require "../auto_utils.pl";

main();

sub main{
	note("*Daily Event by Distance Process");
	registerToEtlStatusPage();
	checkFileLoading('9');
	runParam(10,0);
	checkParam(10);
	promote(10);
}

sub registerToEtlStatusPage{
	note("*Registe to ETL process page...");
	my $group_process_name="Event Tracker";	#the name of group process to register to daily process status table
	register_process($today_date,$group_process_name,10,'01:35:00','09:00:00');
	my ($sec,$min,$hour,$day,$month,$yr19,$WeekDay, $DayOfYear, $IsDST) =   localtime(time);
	if($WeekDay==0){
		
	};	
}
sub promote{
	my $param=shift;
	note("*Promote parameter: $param");
	switch($param) {
	  case 10 {		
		promoteParam("staging.fn_promote_daily_event_distance_report()");		
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

