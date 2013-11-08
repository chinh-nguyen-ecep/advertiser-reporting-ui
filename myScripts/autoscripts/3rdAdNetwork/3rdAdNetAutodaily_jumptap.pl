require "utils.pl";

$date=yesterday();
$date2=yesterday2();

$mailTile="[Jumptap][$date]-[Daily process status][3rd AdNetwork]";

#register sub process to control.daily_process_status table.
register_process($process_date,$group_process_name,35,'04:00:00','08:15:00');

main();


sub main{
	#Check 14 file logs
	my $error=checkSU(1,'39',$mailTile);
	my $time=getTime();
	sendMail("Dear all,<p />$time# Jumtap Log files Extracting completed. Begin start param 35.<p />Thanks,<br />send by auto mail.",$mailTile);
	writelog("Jumtap Log files Extracting completed");	
	if($error == 0){
		#run param22;
		printTime("Run param 35");
		writelog("Run function param 35 - jumtap");	
		runParam(35);
		#update_process_status($process_date,35,'Processing');
		checkParam(35,1);
		#update_process_status($process_date,35,'Promoting');
		runPGFuntion('staging.fn_promote_daily_jumptap_performance_report');
		#update_process_status($process_date,35,'Completed');
		writelog("Daily Jumtap process promoted.");	
		#transfer data to dw0
		rollBackTransfer_7day('adnetwork.daily_jt_performance','');
		$time=getTime();
		sendMail("Dear all,<p />$time# Daily Jumtap 3rd AdNetwork report promoted. The process are completed with no error.<p />Thanks,<br />send by auto mail.",$mailTile);
		writelog("Daily Jumtap Process finished");	
	}else{
		printTime("Stop with error");
		sendMail("Dear all,<p />Daily 3rd AdNetwork report $date is stop with error.<p />Thanks,<br />send by auto mail.");
	}

}



