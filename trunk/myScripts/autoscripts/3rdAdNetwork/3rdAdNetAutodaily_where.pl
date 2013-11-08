require "utils.pl";

$date=yesterday();
$date2=yesterday2();
$log="";
$mailTile="[Where][$date]-[Daily process status][3rd AdNetwork]";
#register sub process to control.daily_process_status table.
register_process($process_date,$group_process_name,36,'03:00:00','08:15:00');

main();


sub main{
	#Check log files
	my $error=checkSU(1,'170',$mailTile);
	my $time=getTime();
	sendMail("Dear all,<p />$time# Where Log files Extracting completed. Begin start param 36.<p />Thanks,<br />send by auto mail.",$mailTile);
	writelog("Where Log files Extracting completed");	
	if($error == 0){
		#run param22;
		printTime("Run param 36");
		writelog("Run function param 36 - Where");	
		runParam(36);
		
		checkParam(36,1);
		
		runPGFuntion('staging.fn_promote_daily_where_performance_report');
		writelog("Daily Where process promoted.");	
		#transfer data to dw0
		rollBackTransfer_7day('adnetwork.daily_wh_performance','');
		$time=getTime();
		sendMail("Dear all,<p />$time# Daily where 3rd AdNetwork report promoted. The process are completed with no error.<p />Thanks,<br />send by auto mail.",$mailTile);
		writelog("Daily Where Process finished");	
	}else{
		printTime("Stop with error");
		sendMail("Dear all,<p />Daily 3rd AdNetwork report $date is stop with error.<p />Thanks,<br />send by auto mail.");
	}

}



