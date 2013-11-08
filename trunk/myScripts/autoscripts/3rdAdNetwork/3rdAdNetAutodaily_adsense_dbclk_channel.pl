require "utils.pl";

$date=yesterday();
$date2=yesterday2();
$log="";
$mailTile="[Adsense dbclk channel][$date]-[Daily process status][3rd AdNetwork]";
#register sub process to control.daily_process_status table.
register_process($process_date,$group_process_name,43,'06:00:00','08:15:00');

main();


sub main{
	#Check log files
	my $error=checkSU(2,'47,48',$mailTile);
	my $time=getTime();
	sendMail("Dear all,<p />$time# Adsense dbclk channel Log files Extracting completed. Begin start param 43.<p />Thanks,<br />send by auto mail.",$mailTile);
	writelog("Adsense dbclk channel Log files Extracting completed");	
	if($error == 0){
		#run param 43;
		printTime("Run param 43");
		writelog("Run function param 43 - Adsense dbclk channel");	
		runParam(43);
		checkParam(43,1);
		runPGFuntion('staging.fn_promote_daily_adsense_dbclk_channel_performance_report');
		#transfer data to dw0
		rollBackTransfer_7day('adnetwork.daily_adsense_dbclk_channel','');		
		writelog("Daily Adsense dbclk channel process promoted.");			
		$time=getTime();
		sendMail("Dear all,<p />$time# Daily Adsense dbclk channel 3rd AdNetwork report promoted. The process are completed with no error.<p />Thanks,<br />send by auto mail.",$mailTile);
		writelog("Daily Adsense dbclk channel Process finished");	
	}else{
		printTime("Stop with error");
		sendMail("Dear all,<p />Daily 3rd AdNetwork report $date is stop with error.<p />Thanks,<br />send by auto mail.");
	}

}



