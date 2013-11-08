require "utils.pl";

$date=yesterday();
$date2=yesterday2();
$log="";
$mailTile="[Marchex][$date]-[Daily process status][3rd AdNetwork]";
#register sub process to control.daily_process_status table.
register_process($process_date,$group_process_name,37,'04:00:00','08:15:00');
main();


sub main{
	#Check log files
	my $error=checkSU(1,'43',$mailTile);
	my $time=getTime();
	sendMail("Dear all,<p />$time# Marchex Log files Extracting completed. Begin start param 37.<p />Thanks,<br />send by auto mail.",$mailTile);
	writelog("Marchex Log files Extracting completed");	
	if($error == 0){
		#run param22;
		printTime("Run param 37");
		writelog("Run function param 37 - Marchex");	
		runParam(37);
		
		checkParam(37,1);
		
		runPGFuntion('staging.fn_promote_daily_marchex_performance_report');
		writelog("Daily Marchex process promoted.");	
		#transfer data to dw0
		rollBackTransfer_7day('adnetwork.daily_mx_performance','');
		$time=getTime();
		sendMail("Dear all,<p />$time# Daily Marchex 3rd AdNetwork report promoted. The process are completed with no error.<p />Thanks,<br />send by auto mail.",$mailTile);
		writelog("Daily Marchex Process finished");	
	}else{
		printTime("Stop with error");
		sendMail("Dear all,<p />Daily 3rd AdNetwork report $date is stop with error.<p />Thanks,<br />send by auto mail.");
	}

}



