require "utils.pl";

$date=yesterday();
$date2=yesterday2();
$log="";
$mailTile="[Itunes][$date]-[Daily process status][3rd AdNetwork]";
#register sub process to control.daily_process_status table.
register_process($process_date,$group_process_name,42,'05:00:00','08:15:00');
main();


sub main{
	#Check log files
	my $error=checkSU(1,'52',$mailTile);
	my $time=getTime();
	sendMail("Dear all,<p />$time# Itunes Log files Extracting completed. Begin start param 42.<p />Thanks,<br />send by auto mail.",$mailTile);
	writelog("Itunes Log files Extracting completed");	
	if($error == 0){
		#run param 42;
		printTime("Run param 42");
		writelog("Run function param 42 - Itunes");	
		runParam(42);
		
		checkParam(42,1);
		
		runPGFuntion('staging.fn_promote_daily_itunes_performance_report');
		writelog("Daily Itunes process promoted.");	
		#transfer data to dw0
		rollBackTransfer_7day('adnetwork.daily_it_performance','');
		$time=getTime();
		sendMail("Dear all,<p />$time# Daily Itunes 3rd AdNetwork report promoted. The process are completed with no error.<p />Thanks,<br />send by auto mail.",$mailTile);
		writelog("Daily Itunes Process finished");	
	}else{
		printTime("Stop with error");
		sendMail("Dear all,<p />Daily 3rd AdNetwork report $date is stop with error.<p />Thanks,<br />send by auto mail.");
	}

}



