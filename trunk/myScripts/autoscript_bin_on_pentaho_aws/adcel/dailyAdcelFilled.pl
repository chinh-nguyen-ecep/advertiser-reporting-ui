use Switch;
$host="localhost";
require "../auto_utils.pl";

main();

sub main{
	registerToEtlStatusPage();
	checkFileLoading('12');
	runParam(5,0);
	checkParam(5);
	promote(5);
}

sub registerToEtlStatusPage{
	note("*Registe to ETL process page...");
	my $group_process_name="AdCel";	#the name of group process to register to daily process status table
	register_process($today_date,$group_process_name,5,'01:35:00','09:00:00');
	my ($sec,$min,$hour,$day,$month,$yr19,$WeekDay, $DayOfYear, $IsDST) =   localtime(time);
	if($WeekDay==0){
		
	};	
}
sub promote{
	my $param=shift;
	note("*Promote parameter: $param");
	switch($param) {
	  case 5 {		
		promoteParam("staging.fn_promote_daily_filled_report()");
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

