require "../bin/dw3_utils.pl";
require "config.pl";
%h_report_date=dw3_yesterday();
%h_process_date=dw3_currentDate();
$process_date=$h_process_date{'year'}.'-'.$h_process_date{'month'}.'-'.$h_process_date{'day'};	#the date run process
$report_date=$h_report_date{'year'}.'_'.$h_report_date{'month'}.'_'.$h_report_date{'day'};	#the report date
$report_date2=$h_report_date{'year'}.'-'.$h_report_date{'month'}.'-'.$h_report_date{'day'};	#the report date 2---

$group_process_name="RTB";	#the name of group process to register to daily process status table

$locatefd="/opt/temp/autoscripts/rtb";	#the location content this script
$logFile="$locatefd/logs/$report_date.txt";	#the location cotent log file
my $emailErrorTitle="[Error!][Daily RTB report][$report_date]";	#the email title used when send a mail error 
my $emailAvailableTitle="[Notification!][Daily RTB report][$report_date]";	#the email title used when send a mail
my $mailto="tho.hoang\@ecepvn.org,ops\@ecepvn.org";	#List mail addresses
my @aggTableDw3=();

main();


sub main{
	#register sub process to control.daily_process_status table.
	register_process($process_date,$group_process_name,78,'05:00:00','06:00:00');
	#Check file logs
	my $error=checkSU();
	if($error == 0){
		my $time=getTime();
		dw3_sendMail($mailto,$emailAvailableTitle,"Dear all,<p />$time# Files extract completed.<p />Thanks,<br />\-\-\-send by auto mail.");
		#run param 78;
		runParam(78);		
		dw3_writelog($logFile,"Run function param 78");		
		#check param 78
		checkParam(78,6);	
		#promote 
		promote(78);
		
	
			
		#transfer all data of adm and double click to dw0
		transferAllData();
		
		dw3_sendMail($mailto,$emailAvailableTitle,"Dear all,<p />Daily RTB $report_date has finished with no error.<p />Process detail:<p/>$log<p />Thanks,<br />\-\-\-send by auto mail.");
		dw3_writelog($logFile,"Process finished");
	}else{
		printTime("Stop with error");
		dw3_sendMail($mailto,$emailErrorTitle,"Dear all,<p />Daily report $report_date is stop with error.<p />Thanks,<br />\-\-\-send by auto mail.");
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
		my $dbh = getConnection();		   
		
		#get total file
		my $totalFileTrue=5; 
		while($totalFiles<$totalFileTrue){
			
			#Cretae String query		
			my $query=" select count (*) AS Total_Files from control.data_file WHERE data_file_config_id IN (152, 206, 209, 210, 211) AND file_timestamp::date=?;";
			my $query_handle = $dbh->prepare($query);
			$query_handle->execute($report_date2);
			$query_handle->bind_columns(undef,\$Total_Files);
			
			# LOOP THROUGH RESULTS
			while($query_handle->fetch()) {
			   $totalFiles=	$Total_Files;	   
			} 
			if($totalFiles==0){
				printTime("No file!");
			}
			if($totalFiles<$totalFileTrue){
				sleep(300);
			}
		}		
		
		#Check process status
		
		#Checking extraction status
		$query="SELECT file_name,file_status,staging_load_count,fact_table_load_count FROM control.data_file WHERE data_file_config_id IN (152, 206, 209, 210, 211) AND file_timestamp::date=?";
		$query_handle = $dbh->prepare($query);
		$query_handle->execute($report_date2);
		$query_handle->bind_columns(undef, \$file_name,\$file_status,\$staging_load_count,\$fact_table_load_count);
		while($query_handle->fetch()) {		   
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
			Daily RTB report $report_date on dw3 begin start with total files today is $totalFiles and now Su files is $SU file.<p />
			<p />Thanks,<br />\-\-\-send by auto mail.");
			}else{
			dw3_sendMail($mailto,$emailAvailableTitle,
			"Dear all,<p />
			Daily RTB report $report_date on dw3 begin start with total files today is $totalFiles and now Su files is $SU file.<p />Thanks,<br />\-\-\-send by auto mail.");
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
			dw3_writelog($logFile,"Extract $totalFiles file finished");
		}else{
			#Stop script in 15 min
			sleep(300);
		};		
	}
	return $error;
}

sub promote{
	my $param=shift;
	print "promoting $param \n";
	if($param==78){
		#promote daily cumulative
		runPGFuntion("staging.fn_promote_daily_rtb_report");
		dw3_writelog($logFile,"Promoted daily rtb report");
	}
}

sub transferAllData{
	system("cd /opt/temp/autoscripts/transformer && perl main.pl daily $master_host $master_report_host rtb.daily_agg_exchanger_cost_analysis_v1 $report_date rtbAutoDaily.pl");	
	system("cd /opt/temp/autoscripts/transformer && perl main.pl daily $master_host $master_report_host rtb.daily_agg_delivery_publisher_property_flight $report_date rtbAutoDaily.pl");	
	system("cd /opt/temp/autoscripts/transformer && perl main.pl daily $master_host $master_report_host rtb.daily_agg_delivery_rtb_flight $report_date rtbAutoDaily.pl");	
}
