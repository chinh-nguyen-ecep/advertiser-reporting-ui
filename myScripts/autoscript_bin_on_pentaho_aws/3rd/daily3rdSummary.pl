use Switch;
$host="localhost";
require "../auto_utils.pl";

main();

sub main{
	registerToEtlStatusPage();
	##checkFileLoading('27');
	runParam(27,0);
	checkParam(27);
	promote(27);
	
	runParam(28,0);
	checkParam(28);
	promote(28);
	
	runParam(35,0);
	checkParam(35);
	promote(35);
	
	runParam(40,0);
	checkParam(40);
	promote(40);
}

sub registerToEtlStatusPage{
	note("*Registe to ETL process page...");
	my $group_process_name="3rdAdnetwork";	#the name of group process to register to daily process status table
	register_process($today_date,$group_process_name,27,'01:35:00','09:00:00');
	register_process($today_date,$group_process_name,28,'01:35:00','09:00:00');
	register_process($today_date,$group_process_name,35,'01:35:00','09:00:00');
	register_process($today_date,$group_process_name,40,'01:35:00','09:00:00');
	my ($sec,$min,$hour,$day,$month,$yr19,$WeekDay, $DayOfYear, $IsDST) =   localtime(time);
	if($WeekDay==0){
		
	};	
}
sub promote{
	my $param=shift;
	note("*Promote parameter: $param");
	switch($param) {
	  case 27 {		
		promoteParam("staging.fn_promote_daily_adnetwork_performance_report()");		
		break;}	
	  case 28 {		
		promoteParam("staging.fn_promote_daily_adnetwork_summary_report()");		
		break;}	
	  case 35 {		
		promoteParam("staging.fn_promote_daily_adnetwork_requests_report()");		
		break;}	
	  case 40 {		
		promoteParam("staging.fn_promote_daily_delivery_report()");		
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

