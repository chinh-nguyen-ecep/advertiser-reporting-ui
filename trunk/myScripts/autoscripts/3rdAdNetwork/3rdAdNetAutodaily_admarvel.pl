require "utils.pl";

$date=yesterday();
$date2=yesterday2();
$log="";
$mailTile="[AdMarvel][$date]-[Daily process status][3rd AdNetwork]";
#register sub process to control.daily_process_status table.
register_process($process_date,$group_process_name,76,'04:00:00','08:15:00');
main();


sub main{
	#Check log files
	my $error=checkSU(1,'212',$mailTile);
	my $time=getTime();
	sendMail("Dear all,<p />$time# AdMarvel Log files Extracting completed. Begin start param 76.<p />Thanks,<br />send by auto mail.",$mailTile);
	writelog("AdMarvel Log files Extracting completed");	
	if($error == 0){
		#run param 76;
		printTime("Run param 76");
		writelog("Run function param 76 - AdMarvel");	
		runParam(76);
		
		checkParam(76,1);
		
		runPGFuntion('staging.fn_promote_daily_admarvel_performance_report');
		writelog("Daily AdMarvel process promoted.");	
		#transfer data to dw0
		rollBackTransfer_7day('adnetwork.daily_am_performance','');
		$time=getTime();
		sendMail("Dear all,<p />$time# Daily AdMarvel 3rd AdNetwork report promoted. The process are completed with no error.<p />Thanks,<br />send by auto mail.",$mailTile);
		writelog("Daily AdMarvel Process finished");	
	}else{
		printTime("Stop with error");
		sendMail("Dear all,<p />Daily 3rd AdNetwork report $date is stop with error.<p />Thanks,<br />send by auto mail.");
	}

}




