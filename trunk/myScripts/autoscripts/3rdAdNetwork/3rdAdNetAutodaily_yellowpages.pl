require "utils.pl";

$date=yesterday();
$date2=yesterday2();
$log="";
$mailTile="[Yellowpages][$date]-[Daily process status][3rd AdNetwork]";
#register sub process to control.daily_process_status table.
register_process($process_date,$group_process_name,38,'04:00:00','08:15:00');
main();


sub main{
	#Check log files
	my $error=checkSU(1,'50',$mailTile);
	my $time=getTime();
	sendMail("Dear all,<p />$time# Yellowpages Log files Extracting completed. Begin start param 38.<p />Thanks,<br />send by auto mail.",$mailTile);
	writelog("Yellowpages Log files Extracting completed");	
	if($error == 0){
		#run param22;
		printTime("Run param 38");
		writelog("Run function param 38 - Yellowpages");	
		runParam(38);
		
		checkParam(38,3);
		
		runPGFuntion('staging.fn_promote_daily_yellowpages_performance_report');
		writelog("Daily Yellowpages process promoted.");	
		#transfer data to dw0
		rollBackTransfer_7day('adnetwork.daily_yp_sb_performance','');
		rollBackTransfer_7day('adnetwork.daily_yp_no_performance','');
		$time=getTime();
		sendMail("Dear all,<p />$time# Daily Yellowpages 3rd AdNetwork report promoted. The process are completed with no error.<p />Thanks,<br />send by auto mail.",$mailTile);
		writelog("Daily Yellowpages Process finished");	
	}else{
		printTime("Stop with error");
		sendMail("Dear all,<p />Daily 3rd AdNetwork report $date is stop with error.<p />Thanks,<br />send by auto mail.");
	}

}



