require "../bin/dw3_utils.pl";

my $rootFD='/opt/temp/autoscripts/transformer';
my $repeat="y";

while($repeat eq "y"){
	my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
	%h_report_date1=dw3_yesterday();
	%h_report_date2=dw3_getDate(-2);
	%h_report_date3=dw3_getDate(-3);
	%h_report_date4=dw3_getDate(-4);
	%h_report_date5=dw3_getDate(-5);
	%h_report_date6=dw3_getDate(-6);
	%h_report_date7=dw3_getDate(-7);
	%h_process_date=dw3_currentDate();
	$process_date=$h_process_date{'year'}.'-'.$h_process_date{'month'}.'-'.$h_process_date{'day'};	#the date run process
	
	$report_date1=$h_report_date1{'year'}.'-'.$h_report_date1{'month'}.'-'.$h_report_date1{'day'};	#the report date 2012-02-02
	$report_date2=$h_report_date2{'year'}.'-'.$h_report_date2{'month'}.'-'.$h_report_date2{'day'};	#the report date 2012-02-02
	$report_date3=$h_report_date3{'year'}.'-'.$h_report_date3{'month'}.'-'.$h_report_date3{'day'};	#the report date 2012-02-02-02
	$report_date4=$h_report_date4{'year'}.'-'.$h_report_date4{'month'}.'-'.$h_report_date4{'day'};	#the report date 2012-02-02
	$report_date5=$h_report_date5{'year'}.'-'.$h_report_date5{'month'}.'-'.$h_report_date5{'day'};	#the report date 2012-02-02
	$report_date6=$h_report_date6{'year'}.'-'.$h_report_date6{'month'}.'-'.$h_report_date6{'day'};	#the report date 2012-02-02
	$report_date7=$h_report_date7{'year'}.'-'.$h_report_date7{'month'}.'-'.$h_report_date7{'day'};	#the report date 2012-02-02
	
	##if($hour%2==0 && $hour>=4 && $min==5){
		##system("perl checkAggDw3_Dw0.pl daily $report_date1 > monitor/transferdata.$report_date1.txt 2> error/error.txt &");
		##sleep(30);
	##}
	if($hour==22 && $min==59){
		sleep(30);
		##system("perl checkAggDw3_Dw0.pl daily_range $report_date7 $report_date1 > monitor/transferdata.$report_date7.$report_date1.txt 2> error/error.txt &");
		
		##system("cd $rootFD/olapdw10/ && perl dw10_transform.pl daily  $report_date1 > monitor/transferdata.Olapdw10.$report_date1.txt 2> error/error.olapdw10.txt &");
		##system("cd $rootFD/olapdw10/ && perl dw10_transform.pl dim_no_dt_expire > monitor/transferdata.Olapdw10.dim.$process_date.txt 2> error/error.olapdw10.dim.txt &");
		system("su - file_xfer -c \"cd $rootFD && perl main.pl dim dw3 dw0\"");
		system("su - file_xfer -c \"cd $rootFD && perl main.pl dim dw3 dw10:analyticsdb\"");
		system("su - file_xfer -c \"cd $rootFD && perl main.pl dim dw3 pentaho.ecepvn.org:analyticsdb\"");
	}
	sleep(50);
}

