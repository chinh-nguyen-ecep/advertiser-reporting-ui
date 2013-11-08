require "utils.pl";

$date=yesterday();
$date2=yesterday2();
$log="";
$mailTile="[Superpages][$date]-[Daily process status][3rd AdNetwork]";
#register sub process to control.daily_process_status table.
register_process($process_date,$group_process_name,39,'8:00:00','8:15:00');
main();


sub main{
	#Check log files
	my $error=checkSU(1,'49',$mailTile);
	my $time=getTime();
	sendMail("Dear all,<p />$time# Superpages Log files Extracting completed. Begin start param 39.<p />Thanks,<br />send by auto mail.",$mailTile);
	writelog("Superpages Log files Extracting completed");	
	if($error == 0){
		#run param22;
		printTime("Run param 39");
		writelog("Run function param 39 - Superpages");	
		runParam(39);
		
		checkParam(39,1);
		
		runPGFuntion('staging.fn_promote_daily_superpages_performance_report');
		writelog("Daily Superpages process promoted.");	
		#transfer data to dw0
		rollBackTransfer_7day('adnetwork.daily_sp_blue_performance','');
		rollBackTransfer_7day('adnetwork.daily_sp_performance','');
		$time=getTime();
		sendMail("Dear all,<p />$time# Daily Superpages 3rd AdNetwork report promoted. The process are completed with no error.<p />Thanks,<br />send by auto mail.",$mailTile);
		writelog("Daily Superpages Process finished");	
	}else{
		printTime("Stop with error");
		sendMail("Dear all,<p />Daily 3rd AdNetwork report $date is stop with error.<p />Thanks,<br />send by auto mail.");
	}

}



