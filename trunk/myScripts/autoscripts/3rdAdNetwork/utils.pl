require "../bin/dw3_utils.pl";
require "config.pl";

sub writelog{
	my $text=shift;
	my $logFile="logs/$date.txt";
	dw3_writelog($logFile,$text);
}

sub yesterday{
	%h_report_date=dw3_yesterday();
	my $datet=$h_report_date{'year'}.'-'.$h_report_date{'month'}.'-'.$h_report_date{'day'};
	return $datet;
}

sub yesterday2{
	%h_report_date=dw3_yesterday();
	my $datet=$h_report_date{'year'}.'_'.$h_report_date{'month'}.'_'.$h_report_date{'day'};
	return $datet;
}
sub sendMail{
#$mailaddress="chinh.nguyen\@ecepvn.org,binh.nguyen\@ecepvn.org,song.nguyen\@ecepvn.org,tho.hoang\@ecepvn.org";
#my $mailaddress="chinh.nguyen\@ecepvn.org";
my $mailaddress="chinh.nguyen\@ecepvn.org,tho.hoang\@ecepvn.org,son.tran\@ecepvn.org";
my $content=shift;
my $mailTile=shift;
dw3_sendMail($mailaddress,$mailTile,$content);
}

#
# This function will check file log.
#
sub checkSU{
	my $sendalertmail=0;
	my $repeat="y";
	my $totalFiles=shift;
	my $file_config_id=shift;
	my $mail_title=shift;
	my $sentmail="";
	while($repeat eq "y"){
	print $date."\n";
		my $SU=0;
		my $finish=fasle;
		my $error=0;
		my $dbh="";
		my $query="";
		my $query_handle="";
		#Create connection
		$dbh = getConnection();	   
		#Checking extraction status
		#$query="SELECT file_name,file_status,staging_load_count,fact_table_load_count FROM control.data_file WHERE data_file_config_id IN (39,40,41,43,44,49,50,47,48,52,53) AND file_timestamp::date=? order by data_file_config_id ";
		$query="SELECT file_name,file_status,staging_load_count,fact_table_load_count FROM control.data_file WHERE data_file_config_id IN ($file_config_id) AND file_timestamp::date=? order by data_file_config_id ";
		$query_handle = $dbh->prepare($query);
		$query_handle->execute("$date2");
		$query_handle->bind_columns(undef, \$file_name,\$file_status,\$staging_load_count,\$fact_table_load_count);
		my $i=0;
		while($query_handle->fetch()) {	
			$i++;
			print "$i - $file_name\t$file_status\t$staging_load_count\t$fact_table_load_count\n";
		   if($file_status eq 'SU' && $staging_load_count>0 && $fact_table_load_count>0){
				$SU++;
		   }elsif ($file_status eq 'SU'){
				if($staging_load_count==0 || $fact_table_load_count==0){
					$error++;
					my $errorfile=$file_name;
					#send mail error					
					if(index($sentmail,$errorfile)==-1){
						sendMail("Dear all,<p />Extract log files is error at $errorfile file. Load count = 0.<p />Thanks,<br />-\-\- send by automail.",$mail_title);
						$sentmail=$sentmail.",$errorfile";
					}	
				}				
		   }elsif($file_status eq 'EF'){
				$error++;
				my $errorfile=$file_name;
					#send mail error					
					if(index($sentmail,$errorfile)==-1){
						sendMail("Dear all,<p />Extract log files is error at $errorfile file. File status is EF.<p />Thanks,<br />-\-\- send by automail.",$mail_title);
						$sentmail=$sentmail.",$errorfile";
					}					
		   }	   
		} 
		printTime("Total files: $totalFiles \t SU : $SU \t Error: $error");
		#gui mail dau tien bao bat dau chay auto daily. Chi gui mail nay 1 lan khi bat dau chay
		if($sendalertmail==0){
			$sendalertmail++;
			sendMail("Dear all,<p />
			Daily Process $date on $main_host begin start with total files is $totalFiles and now Su files is $SU file.<p />Thanks,<br />send by auto mail.",$mail_title);
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
			writelog("Extract $totalFiles file finished");
		}else{
			#Stop script in 15 min
			sleep(60);
		}
		
	}
	return $error;
}
#Transfer data with partition input table name startdate enddate
sub rollBackTransfer_table_wp{
	my $table_name=shift;
	my $report_date7=shift;
	my $report_date1=shift;
	print "Transfer $table_name\t$report_date7\t$report_date1\n";
	system("cd /opt/temp/autoscripts/transformer/ && perl mainWP.pl daily_range $main_host $transfer_to_host $table_name $report_date7 $report_date1 utils_3rdAdNetwork");
}
#Transfer data no partition
sub rollBackTransfer_table{
	my $table_name=shift;
	my $report_date7=shift;
	my $report_date1=shift;
	print "Transfer $table_name\t$report_date7\t$report_date1\n";
	# system("cd /opt/temp/autoscripts/transformer/ && perl main.pl daily_range $main_host $transfer_to_host $table_name $report_date7 $report_date1 utils_3rdAdNetwork");
	system("cd /home/file_xfer/bin/databaseTransferFlowerMode/ && perl transferNoTracking.pl date_range $main_host $transfer_to_host_new $table_name $report_date7 $report_date1");
}

sub rollBackTransfer_7day{
	my $table=shift;
	my $mode=shift;
	%h_report_date1=dw3_yesterday();
	%h_report_date7=dw3_getDate(-7);
	$report_date1=$h_report_date1{'year'}.'-'.$h_report_date1{'month'}.'-'.$h_report_date1{'day'};	#the report date 2012-02-02
	$report_date7=$h_report_date7{'year'}.'-'.$h_report_date7{'month'}.'-'.$h_report_date7{'day'};	#the report date 2012-02-02
	
	if($mode eq 'wp'){
		rollBackTransfer_table_wp($table,$report_date7,$report_date1);
	}else{
		rollBackTransfer_table($table,$report_date7,$report_date1);
	}
}


return 1;
exit;