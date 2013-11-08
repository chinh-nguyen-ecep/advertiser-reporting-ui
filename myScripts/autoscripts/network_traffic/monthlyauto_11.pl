require "utils.pl";

main();
sub main{
		#print "Are you sure? (y/n): ";
		#chomp($enter=<>);
		my $enter='y';
		if($enter eq 'y'){
			my $time=getTime();
			sendMail($mailTo,$MonthlyMailTitle,
			"Dear all,<p />
			$time# Process monthly report begin start.<p />
			Thanks,<br />\-\-\- send by automail.");
			#Run param2
			printTime("Run Param 2");
			runParam(2);
			#Check param2 status
			checkParam(2,8);			
			#promote param 2
			runParam(-4);
			#Param2 finish then send mail to request promote			
			sendMail($mailErrorTo,$MonthlyMailTitle,
			"Dear all,<p />
			fn_manage_process_tasks_with_paramater(2) has finished and promoted. Monthly report is available on jasper.<p />
			And now fn_manage_process_tasks_with_paramater(3) is runing.<p />
			Thanks,<br />\-\-\- send by automail.");
			#Run param 3
			printTime("Run Param 3");
			runParam(3);
			#Check param3 status
			checkParam(3,1);
			printTime("Run Param 3 has finished");			
			#Param3 finish then promote monthly traffic
			runParam(-5);
			#send mail
			sendMail($mailTo,$MonthlyMailTitle,
			"Dear all,<p />
			fn_manage_process_tasks_with_paramater(3) has finished. And monthly traffic report was promoted auto.<p />
			Impression inventory loading fn_manage_process_tasks_with_paramater(7) is runing.<p />
			Thanks,<br />\-\-\- send by automail.");
			
			#Run param7 Impression inventory loading
			printTime("Run Param 7");	
			runParam(7);
			#check param7 status
			checkParam(7,3);
			printTime("Run Param 7 has finished");	
			#promote param 7
			runParam(-7);
			#send mail
			sendMail("chinh.nguyen\@ecepvn.org,tho.nguyen\@ecepvn.org",$MonthlyMailTitle,"Dear a.Tho,<p />
			Impression inventory loading has finished. And monthly impression inventory was promoted auto.<p />
			Thanks,<br />\-\-\- send by automail.");
		}else{
		
		}
	
	}