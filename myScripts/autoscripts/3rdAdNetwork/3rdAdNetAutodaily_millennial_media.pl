require "utils.pl";

$date=yesterday();
$date2=yesterday2();
$log="";
$mailTile="[Millennial media][$date]-[Daily process status][3rd AdNetwork]";
#register sub process to control.daily_process_status table.
register_process($process_date,$group_process_name,40,'04:00:00','08:15:00');
main();


sub main{
	#Check log files
	my $error=checkSU(1,'41',$mailTile);
	my $time=getTime();
	sendMail("Dear all,<p />$time# Millennial media Log files Extracting completed. Begin start param 40.<p />Thanks,<br />send by auto mail.",$mailTile);
	writelog("Millennial media Log files Extracting completed");	
	if($error == 0){
		#run param22;
		printTime("Run param 40");
		writelog("Run function param 40 - Millennial media");	
		runParam(40);
		
		checkParam(40,1);
		
		runPGFuntion('staging.fn_promote_daily_millennial_media_performance_report');
		writelog("Daily Millennial media process promoted.");	
		#transfer data to dw0
		rollBackTransfer_7day('adnetwork.daily_mm_performance','');
		$time=getTime();
		sendMail("Dear all,<p />$time# Daily Millennial media 3rd AdNetwork report promoted. The process are completed with no error.<p />Thanks,<br />send by auto mail.",$mailTile);
		writelog("Daily Millennial media Process finished");	
	}else{
		printTime("Stop with error");
		sendMail("Dear all,<p />Daily 3rd AdNetwork report $date is stop with error.<p />Thanks,<br />send by auto mail.");
	}

}



