require "utils.pl";

main();

sub main{
	#Check 14 file logs
	#my $time=getTime();
	#sendMail($mailTo,$DailyMailTitle,"Dear all,<p />Daily process start at $time US time.<p />Thanks,<br />Auto send mail.");
	#my $error=check14SU();
	$error=0;
	if($error == 0){
		#run param1;
##		runParam(1);
		#writelog("Run function param 1");
##		checkStep2();
		#run param6;
		runParam(6);
		#writelog("Run function param 6");
		checkParam(6,7);
		#run promote
		runParam(-1);
##		sleep(60);
		#run param6;
##		runParam(6);
		#writelog("Run function param 6");
##		checkParam(6,7);
		#run promote
##		runParam(-1);
		
		#writelog("Promoted daily report");
		printTime("Stop daily report with no error");
		#writelog("Stop daily report with no error");
		# make a line in daily log csv
		#getLog();
		#sendMail($mailTo,$DailyMailTitle,"Dear all,<p />Daily report Network traffic has finished with no error.<p />Process detail:<p/>$log<p />ETL load time: $v_ELT_time<br />Staging load count: $v_staging_load_count<br />Fact table load count: $v_fact_table_load_count.<p />Thanks,<br />Auto send mail.");
				
	}else{
		printTime("Stop with error");
		sendMail($mailTo,$DailyMailTitle,"Dear all,<p />Daily report Network traffic is stop with error.<p />Thanks,<br />\-\-\-send by auto mail.");
	}
	
}


