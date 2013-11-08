require "utils.pl";

main();

sub main{
	my $error=0;	
	if($error == 0){
		#run weekly report
		$time=getTime();
		sendMail($mailTo,$WeeklyMailTitle,	"Dear all,<p />	$time# Weekly report process begin start.<p />Thanks,<br /> \-\-\- send by auto mail.");
		printTime("Weekly report start run");
		writelog("Weekly report start run");
		#run param 4
		runParam(4);
		printTime("Param 4 is runing");
		writelog("Param 4 is runing");
		$time=getTime();
		sendMail($mailTo,$WeeklyMailTitle,	"Dear all,<p />	$time# Param 4 is runing.<p />Thanks,<br /> \-\-\- send by auto mail.");
		
		#check param 4 status
		checkParam(4,8);
		$time=getTime();
		sendMail($mailTo,$WeeklyMailTitle,	"Dear all,<p />	$time# Run Param 4 finished. Please promote param 4.<p />Thanks,<br /> \-\-\- send by auto mail.");
		#promote param4
		runParam(-4);
		#Param 4 complete and send mail to Chinh,Tho,Song
		$time=getTime();
		sendMail($mailTo,$WeeklyMailTitle,"Dear all,<p />$time# Weekly report has finished and promoted.<p />	Thanks,<br /> \-\-\- send by auto mail.");
		
		#run param 5 after 30 min
		runParam(5);
		printTime("Param 5 is runing");
		writelog("Param 5 is runing");
		$time=getTime();
		sendMail($mailTo,$WeeklyMailTitle,	"Dear all,<p />	$time# Param 5 is runing.<p />Thanks,<br /> \-\-\- send by auto mail.");
		#check param 5 status
		checkParam(5,1);
		$time=getTime();
		sendMail($mailTo,$WeeklyMailTitle,	"Dear all,<p />	$time# Run Param 5 finished.<p />Thanks,<br /> \-\-\- send by auto mail.");
		#Param 5 complete and run promote param 5
		runParam(-5);
		sendMail($mailTo,$WeeklyMailTitle,"Dear all,<p />Param 5 is promoted.<p />Thanks,<br />Auto send mail.");
	}else{
		printTime("Stop with error");
	}
	
}


