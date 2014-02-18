use Switch;
$host="localhost";
require "../auto_utils.pl";

main();

sub main{
	registerToEtlStatusPage();
	checkFileLoading('23');
	runParam(33,0);
	checkParam(33);
	promote(33);
	runParam(34,0);
	checkParam(34);
	promote(34);
}

sub registerToEtlStatusPage{
	note("*Registe to ETL process page...");
	my $group_process_name="ADM-DFP";	#the name of group process to register to daily process status table
	register_process($today_date,$group_process_name,33,'01:35:00','09:00:00');
	register_process($today_date,$group_process_name,34,'01:35:00','09:00:00');
	my ($sec,$min,$hour,$day,$month,$yr19,$WeekDay, $DayOfYear, $IsDST) =   localtime(time);
	if($WeekDay==0){
		
	};	
}
sub promote{
	my $param=shift;
	note("*Promote parameter: $param");
	switch($param) {
	  case 33 {		
		promoteParam("staging.fn_promote_daily_adm_dfp_20_revenue()");		
		break;}	
	  case 34 {		
		promoteParam("staging.fn_promote_daily_adm_dfp_20_network_revenue()");		
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

