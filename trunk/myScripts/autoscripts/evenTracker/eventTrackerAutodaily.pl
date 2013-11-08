require "../bin/dw3_utils.pl";

%h_report_date=dw3_yesterday();
%h_process_date=dw3_currentDate();
$process_date=$h_process_date{'year'}.'-'.$h_process_date{'month'}.'-'.$h_process_date{'day'};	#the date run process
$report_date=$h_report_date{'year'}.'-'.$h_report_date{'month'}.'-'.$h_report_date{'day'};	#the report date

$group_process_name="Event Tracker";	#the name of group process to register to daily process status table


$locatefd="/opt/temp/autoscripts/evenTracker";	#the location content this script
$logFile="$locatefd/logs/$report_date.txt";	#the location cotent log file
my $emailErrorTitle="[Error!][Daily Event tracker report][$report_date]";	#the email title used when send a mail error 
my $emailAvailableTitle="[Notification!][Daily Event tracker report][$report_date]";	#the email title used when send a mail
my $mailto="tho.hoang\@ecepvn.org,ops\@ecepvn.org";	#List mail addresses
my @aggTableDw3=();
#register sub process to control.daily_process_status table.
#register_process($process_date,$group_process_name,46,'04:50:00','09:50:00');

register_process($process_date,$group_process_name,56,'10:00:00','10:40:00');
register_process($process_date,$group_process_name,57,'10:00:00','10:40:00');
register_process($process_date,$group_process_name,58,'10:00:00','10:40:00');
register_process($process_date,$group_process_name,25,'10:00:00','10:40:00');
#if monday we will call param
my ($sec,$min,$hour,$day,$month,$yr19,$WeekDay, $DayOfYear, $IsDST) =   localtime(time);
if($WeekDay==1){
	#register_process($process_date,$group_process_name,26,'10:50:00','13:00:00');
};		


main();

sub main{

	#Check file logs
	my $error=checkSU();
	dw3_writelog($logFile,"Extract $totalFiles file finished");
	if($error == 0){
		my $time=getTime();
		dw3_sendMail($mailto,$emailAvailableTitle,"Dear all,<p />$time# Files extract completed.<p />Thanks,<br />\-\-\-send by auto mail.");
		
		#run param 46 daily resolve user agent event tracker
		#runParam(46);
		#dw3_writelog($logFile,"Run function param 46");		
		#checkParam(46,1);
		#promote(46);
		
		
		#run param25;
		runParam(25);
		dw3_writelog($logFile,"Run function param 25");
		checkParam(25,8);	
		promote(25);
		
		dw3_sendMail($mailto,$emailAvailableTitle,"Dear all,<p />Daily Event tracker $report_date has finished with no error.<p />Process detail:<p/>$log<p />Thanks,<br />\-\-\-send by auto mail.");
		#if monday we will call param 26
		my ($sec,$min,$hour,$day,$month,$yr19,$WeekDay, $DayOfYear, $IsDST) =   localtime(time);
		if($WeekDay==1){
			##runParam(26);
			##checkParam(26,3);
			##promote(26);
		};	

		#transfer agg data of Event to dw0
		transferAllData();
		
		dw3_writelog($logFile,"Process finished");
	}else{
		printTime("Stop with error");
		dw3_sendMail($mailto,$emailAvailableTitle,"Dear all,<p />Daily report $report_date is stop with error.<p />Thanks,<br />\-\-\-send by auto mail.");
	}

}

#
# This function will check file log.
#
sub checkSU{
	my $sendalertmail=0;
	my $repeat="y";
	my $totalFiles=0;
	my $listLogFileName="";
	my $sentmail="";
	while($repeat eq "y"){
		my $SU=0;
		my $finish=fasle;
		my $error=0;
		my $dbh="";
		my $query="";
		my $query_handle="";
		#Create connection
		$dbh = getConnection();		   
		
		#get list name of log files
		#Cretae String query	

		$query="SELECT file_name FROM control.data_file where file_name LIKE ? AND file_timestamp::date=?;";
		$query_handle = $dbh->prepare($query);
		$query_handle->execute('%event-tracker-incremental%',$report_date);
		$query_handle->bind_columns(undef,\$file_name);
		
		# LOOP THROUGH RESULTS
		while($query_handle->fetch()) {
		   $listLogFileName=$listLogFileName.$file_name."<br/>";	   
		} 
		
		#GET Total File
		while($totalFiles==0){
			$query="SELECT COUNT(*) as total_files_out FROM control.data_file where file_name LIKE ? AND file_timestamp::date=?;";
			$query_handle = $dbh->prepare($query);
			$query_handle->execute('%event-tracker-incremental%',$report_date);
			$query_handle->bind_columns(undef,\$total_files_out);
			
			# LOOP THROUGH RESULTS
			while($query_handle->fetch()) {
			   $totalFiles=$total_files_out;
			}
			if($totalFiles==0){
				print 'Total file == 0 \n';
				sleep(300);
			}
		}
	
		#Check process status
		
		#Checking extraction status
		$query="SELECT file_name,file_status,staging_load_count,fact_table_load_count FROM control.data_file WHERE file_name LIKE ? AND file_timestamp::date=?;";
		$query_handle = $dbh->prepare($query);
		$query_handle->execute('%event-tracker-incremental%',$report_date);
		$query_handle->bind_columns(undef, \$file_name,\$file_status,\$staging_load_count,\$fact_table_load_count);
		while($query_handle->fetch()) {	
			print "$file_name\t$file_status\n";
		   if($file_status eq 'SU' && $staging_load_count>0 && $fact_table_load_count>0){
				$SU++;
		   }elsif ($file_status eq 'SU'){
				if($staging_load_count==0 || $fact_table_load_count==0){
					$error++;
					my $errorfile=$file_name;
					#send mail error					
					if(index($sentmail,$errorfile)==-1){
						dw3_sendMail($mailto,$emailErrorTitle,"Dear all,<p />Extract log files is error at $errorfile file. Load count = 0.<p />Thanks,<br />-\-\- send by automail.");
						$sentmail=$sentmail.",$errorfile";
					}	
				}				
		   }elsif($file_status eq 'EF'){
				$error++;
				my $errorfile=$file_name;
					#send mail error					
					if(index($sentmail,$errorfile)==-1){
						dw3_sendMail($mailto,$emailErrorTitle,"Dear all,<p />Extract log files is error at $errorfile file. File status is EF<p />Thanks,<br />-\-\- send by automail.");
						$sentmail=$sentmail.",$errorfile";
					}					
		   }	   
		} 
		printTime("Total files: $totalFiles \t SU : $SU \t Error: $error");
		#gui mail dau tien bao bat dau chay auto daily. Chi gui mail nay 1 lan khi bat dau chay
		if($sendalertmail==0){
			$sendalertmail++;
			
			if($SU!=$totalFiles){
			dw3_sendMail($mailto,$emailAvailableTitle,
			"Dear all,<p />
			Daily Event tracker report $report_date on dw3 begin start with total files today is $totalFiles and now Su files is $SU file.<p />
			List file:<br />
			$listLogFileName
			<p />Thanks,<br />\-\-\-send by auto mail.");
			}else{
			dw3_sendMail($mailto,$emailAvailableTitle,
			"Dear all,<p />
			Daily Event tracker report $report_date on dw3 begin start with total files today is $totalFiles and now Su files is $SU file.<p />Thanks,<br />\-\-\-send by auto mail.");
			};
		}
		
		#disconnect database
		my $rv = $dbh->disconnect;
		#Check process status
		if($SU==$totalFiles && $error==0){
			$finish=true;
		}elsif($SU<$totalFiles && $error==0){
			printTime("Process is runing");
		}elsif($error>0){
			printTime("Process error with these file: $sentmail");
		}else{
			printTime("xxxx");
		}
		
		printTime("Checked");
		#Check MAIN LOOP
		if($finish eq true){
			$repeat="n";
			printTime("Extract finished");

		}else{
			#Stop script in 15 min
			sleep(300);
		};		
	}
	return $error;
}

sub promote{
	my $param=shift;
	print "promoting $param\n";
	if($param==25){
		runParam(-25);
		dw3_writelog($logFile,"Promoted daily event tracker report");
	}
	if($param==26){			
		runParam(-26);
		dw3_sendMail($mailto,$emailAvailableTitle,"Dear all,<p />30 day rolling Event tracker $report_date was promoted.<p />Thanks,<br />\-\-\-send by auto mail.");
	}
	if($param==46){	
		runPGFuntion("staging.fn_promote_daily_resolve_user_agent_event_tracker");
	}
}
sub transferAllData{
	@aggTableDw3=();
	push(@aggTableDw3,"evttracker.daily_event_stats_by_hour");
	push(@aggTableDw3,"evttracker.daily_event_stats_adnet");
	push(@aggTableDw3,"evttracker.daily_event_by_distance");
	push(@aggTableDw3,"evttracker.daily_event_dma_by_hour");
	push(@aggTableDw3,"evttracker.daily_event_stats");
	push(@aggTableDw3,"evttracker.daily_event_dma");
	push(@aggTableDw3,"evttracker.daily_event_x_value_report");
	push(@aggTableDw3,"evttracker.daily_event_x_value_by_hour");
	push(@aggTableDw3,"evttracker.daily_event_download");
	push(@aggTableDw3,"evttracker.daily_event_x_value");
	copyAggDataToDw0($report_date,@aggTableDw3);
}
