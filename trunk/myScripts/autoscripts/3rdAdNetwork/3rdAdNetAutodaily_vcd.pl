require "utils.pl";

$date=yesterday();
$date2=yesterday2();
$log="";
$mailTile="[Creative Direct][$date]-[Daily process status][3rd AdNetwork]";
#register sub process to control.daily_process_status table.
register_process($process_date,$group_process_name,79,'08:00:00','08:10:00');
main();


sub main{
	#Check log files
	my $error=checkSU(1,'220',$mailTile);
	my $time=getTime();
	sendMail("Dear all,<p />$time# Creative Direct Log files Extracting completed. Begin start param 79.<p />Thanks,<br />send by auto mail.",$mailTile);
	writelog("Creative Direct Log files Extracting completed");	
	if($error == 0){
		#run param 79;
		printTime("Run param 79");
		writelog("Run function param 79 - Creative Direct");	
		runParam(79);		
		checkParam(79,1);		
		runPGFuntion('staging.fn_promote_daily_vcd_report');
		writelog("Daily Creative Direct process promoted.");	
		
		#transfer data to dw0
		#rollBackTransfer_7day('adnetwork.daily_cg_performance','');		
		$time=getTime();
		sendMail("Dear all,<p />$time# Daily Creative Direct 3rd AdNetwork report promoted. The process are completed with no error.<p />Thanks,<br />send by auto mail.",$mailTile);
		writelog("Daily Creative Direct Process finished");	
	}else{
		printTime("Stop with error");
		sendMail("Dear all,<p />Daily 3rd AdNetwork report $date is stop with error.<p />Thanks,<br />send by auto mail.");
	}

}



