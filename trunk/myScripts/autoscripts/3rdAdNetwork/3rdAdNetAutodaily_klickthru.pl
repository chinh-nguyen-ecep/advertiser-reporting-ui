require "utils.pl";

$date=yesterday();
$date2=yesterday2();
$log="";
$mailTile="[Klickthru][$date]-[Daily process status][3rd AdNetwork]";
#register sub process to control.daily_process_status table.
register_process($process_date,$group_process_name,61,'04:00:00','08:15:00');
main();


sub main{
	#Check log files
	my $error=checkSU(1,'104',$mailTile);
	my $time=getTime();
	sendMail("Dear all,<p />$time# Klickthru Log files Extracting completed. Begin start param 61.<p />Thanks,<br />send by auto mail.",$mailTile);
	writelog("Klickthru Log files Extracting completed");	
	if($error == 0){
		#run param22;
		printTime("Run param 61");
		writelog("Run function param 61 - Klickthru");	
		runParam(61);
		
		checkParam(61,1);
		
		runPGFuntion('staging.fn_promote_daily_klickthru_performance_report');
		writelog("Daily Klickthru process promoted.");	
		#transfer data to dw0
		rollBackTransfer_7day('adnetwork.daily_kt_performance','');
		$time=getTime();
		sendMail("Dear all,<p />$time# Daily Klickthru 3rd AdNetwork report promoted. The process are completed with no error.<p />Thanks,<br />send by auto mail.",$mailTile);
		writelog("Daily Klickthru Process finished");	
	}else{
		printTime("Stop with error");
		sendMail("Dear all,<p />Daily 3rd AdNetwork report $date is stop with error.<p />Thanks,<br />send by auto mail.");
	}

}



