require "utils.pl";

$date=yesterday();
$date2=yesterday2();
$log="";
$mailTile="[City grid][$date]-[Daily process status][3rd AdNetwork]";
#register sub process to control.daily_process_status table.
register_process($process_date,$group_process_name,41,'08:00:00','08:10:00');
main();


sub main{
	#Check log files
	my $error=checkSU(1,'53,126',$mailTile);
	my $time=getTime();
	sendMail("Dear all,<p />$time# City grid Log files Extracting completed. Begin start param 41.<p />Thanks,<br />send by auto mail.",$mailTile);
	writelog("City grid Log files Extracting completed");	
	if($error == 0){
		#run param 41;
		printTime("Run param 41");
		writelog("Run function param 41 - City grid");	
		runParam(41);		
		checkParam(41,1);		
		runPGFuntion('staging.fn_promote_daily_city_grid_performance_report');
		writelog("Daily City grid process promoted.");	
		
		#transfer data to dw0
		rollBackTransfer_7day('adnetwork.daily_cg_performance','');		
		$time=getTime();
		sendMail("Dear all,<p />$time# Daily City grid 3rd AdNetwork report promoted. The process are completed with no error.<p />Thanks,<br />send by auto mail.",$mailTile);
		writelog("Daily City grid Process finished");	
	}else{
		printTime("Stop with error");
		sendMail("Dear all,<p />Daily 3rd AdNetwork report $date is stop with error.<p />Thanks,<br />send by auto mail.");
	}

}



