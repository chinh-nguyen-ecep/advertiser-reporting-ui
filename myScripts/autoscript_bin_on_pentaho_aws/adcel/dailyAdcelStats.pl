use Switch;
$host="localhost";
require "../auto_utils.pl";

main();

sub main{
	registerToEtlStatusPage();
	checkFileLoading('1');
	runParam(3,0);
	checkParam(3);
	promote(3);
}

sub registerToEtlStatusPage{
	note("*Registe to ETL process page...");
	my $group_process_name="AdCel";	#the name of group process to register to daily process status table
	register_process($today_date,$group_process_name,3,'01:35:00','09:00:00');
	my ($sec,$min,$hour,$day,$month,$yr19,$WeekDay, $DayOfYear, $IsDST) =   localtime(time);
	if($WeekDay==0){
		
	};	
}
sub promote{
	my $param=shift;
	note("*Promote parameter: $param");
	switch($param) {
	  case 3 {		
		promoteParam("staging.fn_promote_daily_ad_response_report()");		
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

