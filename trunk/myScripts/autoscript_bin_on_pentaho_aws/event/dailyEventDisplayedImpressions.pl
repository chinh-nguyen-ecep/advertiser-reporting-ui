use Switch;
$host="localhost";
require "../auto_utils.pl";

main();

sub main{
	note("*Daily Event Display Impression Process");
	registerToEtlStatusPage();
	checkFileLoading('5');
	runParam(12,0);
	checkParam(12);
	promote(12);
}

sub registerToEtlStatusPage{
	note("*Registe to ETL process page...");
	my $group_process_name="Event Tracker";	#the name of group process to register to daily process status table
	register_process($today_date,$group_process_name,12,'01:35:00','09:00:00');
	my ($sec,$min,$hour,$day,$month,$yr19,$WeekDay, $DayOfYear, $IsDST) =   localtime(time);
	if($WeekDay==0){
		
	};	
}
sub promote{
	my $param=shift;
	note("*Promote parameter: $param");
	switch($param) {
	  case 12 {		
		promoteParam("staging.fn_promote_daily_displayed_impressions_report()");		
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

