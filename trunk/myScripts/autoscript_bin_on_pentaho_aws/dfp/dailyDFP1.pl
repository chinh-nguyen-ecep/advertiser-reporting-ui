use Switch;
$host="localhost";
require "../auto_utils.pl";

main();

sub main{
	registerToEtlStatusPage();
	checkFileLoading('24');
	runParam(29,0);
	checkParam(29);
	promote(29);
	runParam(32,0);
	checkParam(32);
	promote(32);
}

sub registerToEtlStatusPage{
	note("*Registe to ETL process page...");
	my $group_process_name="Double Click";	#the name of group process to register to daily process status table
	register_process($today_date,$group_process_name,29,'01:35:00','09:00:00');
	register_process($today_date,$group_process_name,32,'01:35:00','09:00:00');
	my ($sec,$min,$hour,$day,$month,$yr19,$WeekDay, $DayOfYear, $IsDST) =   localtime(time);
	if($WeekDay==0){
		
	};	
}
sub promote{
	my $param=shift;
	note("*Promote parameter: $param");
	switch($param) {
	  case 29 {		
		promoteParam("staging.fn_promote_daily_adm_dfp_10_revenue()");		
		break;}	
	  case 32 {		
		promoteParam("staging.fn_promote_daily_adm_dfp_10_network_revenue()");		
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

