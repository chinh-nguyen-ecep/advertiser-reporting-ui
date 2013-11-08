use DBI;
use DBIx::AutoReconnect;
use Date::Pcalc qw(:all);
#version 2 add dailylog csv
#Version 3 count file log not is 14
$host="dw5";
$dbname="warehouse";
$usename="chinh";
$pwd="verve-2010";
$port="5433";
$month_log='';
$year_log='';
$date=yesterday();
$date2='';
$log="";
$sentmail="";
$sentmailIgnoeList="";
$v_ELT_time='';
$v_staging_load_count='';
$v_fact_table_load_count='';

$binfd="/opt/temp/autoscripts/bin";
$locatefd="/opt/temp/autoscripts/network_traffic";

$mailTo="chinh.nguyen\@ecepvn.org,ops\@ecepvn.org";
$mailErrorTo="chinh.nguyen\@ecepvn.org,ops\@ecepvn.org,dw-vndev\@ecepvn.org";
$DailyMailTitle="[Daily report][Network traffic][$date]";
$DailyMailErrorTitle="[Notification!][Network traffic][error][$date]";
$WeeklyMailTitle="[Weekly report][Network traffic][$date]";
$MonthlyMailTitle="[Monthly report][Network traffic][$date]";

#with lines in ignoreList, notification about error files will be ignore.
@ignoreListMark=();

push(@ignoreListMark,"event-tracker_access_log");

#
# This function will check 14 file log.
#
sub check14SU{
	my $repeat="y";
	my $countfile=14;
	#get count file
	#Create connection
	my $dbh = getConnection();		   
	#Cretae String query
	my $query="SELECT COUNT(file_name) as total FROM staging.data_file WHERE file_name like ?";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute("%$date%");
	$query_handle->bind_columns(undef, \$total);
		
	# LOOP THROUGH RESULTS
	while($query_handle->fetch()) {
		$countfile=$total;
	} 
	my $rv = $dbh->disconnect;
	while($repeat eq "y"){
		my $SU=0;
		my $finish=fasle;
		my $error=0;
		my $dbh="";
		my $query="";	
		my $query_handle="";
		printTime("Check $countfile log files");
		#Create connection
		$dbh = getConnection();		   
		#Cretae String query
		$query="SELECT file_name,file_status,staging_load_count,dt_file_extracted ,fact_table_load_count
		FROM staging.data_file  WHERE file_name like ?";
		$query_handle = $dbh->prepare($query);
		$query_handle->execute("%$date%");
		$query_handle->bind_columns(undef, \$file_name,\$file_status,\$staging_load_count,\$dt_file_extracted,\$fact_table_load_count);
		
		# LOOP THROUGH RESULTS
		while($query_handle->fetch()) {
		   print "$file_name\t$file_status\t$staging_load_count\t$fact_table_load_count\n";
		   if($file_status eq 'SU' && $staging_load_count>0 && $fact_table_load_count>0){
				$SU++;
		   }elsif ($file_status eq 'SU'){
				if($staging_load_count==0 || $fact_table_load_count==0){
					
					my $errorfile=$file_name;
					my $isIgnore=isInIgnoreList($file_name);
					if($isIgnore==0){
						$error++;
						#send mail error					
						if(index($sentmail,$errorfile)==-1){
							sendMail($mailErrorTo,$DailyMailErrorTitle,"Dear all,<p />Extract log file is error at $errorfile file. Load count = 0.<p />Thanks,<br />Auto send mail.");
							$sentmail=$sentmail.",$errorfile";
						}
					}else{
						#send mail error ignore list
						$SU++;
						print "$errorfile in ignore list\n";
						if(index($sentmailIgnoeList,$errorfile)==-1){
							sendMail("chinh.nguyen\@ecepvn.org","[Notification!][Network traffic][errorIgnore][$date]","Dear Chinh,<p />Extract log file is error at $errorfile file. Load count = 0.<p />Thanks,<br />Auto send mail.");
							$sentmailIgnoeList=$sentmailIgnoeList.",$errorfile";
						}
						
					}
						
				}				
		   }elsif($file_status eq 'EF'){
				$error++;
				my $errorfile=$file_name;
					#send mail error					
					if(index($sentmail,$errorfile)==-1){
						sendMail($mailErrorTo,$DailyMailErrorTitle,"Dear all,<p />Extract log file is error at $errorfile file. File status is EF<p />Thanks,<br />Auto send mail.");
						$sentmail=$sentmail.",$errorfile";
					}					
		   }
		} 
		printTime("SU : $SU \t Error: $error"); 
		#disconnect database
		my $rv = $dbh->disconnect;
		#Check process status
		if($SU>=$countfile && $error==0){
			$finish=true;
		}elsif($SU<$countfile && $error==0){
			printTime("Process is runing");
		}elsif($error>0){
			printTime("Process error");
		}else{
			printTime("xxxx");
		}
		
		printTime("Checked");
		#Check MAIN LOOP
		if($finish eq true){
			$repeat="n";
			printTime("Extract finished");
			writelog("Extract $countfile file finished");
			my $time=getTime();
			sendMail($mailTo,$DailyMailTitle,"Dear all,<p />Extract log files finished at $time US time.<p />Thanks,<br />Auto send mail.");
		}else{
			#Stop script in 15 min
			sleep(600);
		}
		
	}
	return $error;
}
#
# This function will check Step2 .
#
sub checkStep2{
	my $repeat='y';
	while($repeat eq 'y'){
		my $dbh='';
		my $query='';
		my $query_handle='';
		my $PS=0;
		my $finish=fasle;
		printTime("Begin Check Step2");
		#Create connection
		$dbh = getConnection();	
		#Cretae String query
		$query="SELECT process_id,process_status,dt_process_queued,dt_lastchange  FROM staging.process
		  WHERE process_status <> 'SU' AND process_config_id =1";
		$query_handle = $dbh->prepare($query);
		$query_handle->execute();
		$query_handle->bind_columns(undef, \$process_id,\$process_status,\$dt_process_queued,\$dt_lastchange);

		# LOOP THROUGH RESULTS
		while($query_handle->fetch()) {
		   print "$process_id\t$process_status\t$dt_process_queued\t$dt_lastchange\n";
		   $PS++;
		} 
		#Check how many process with process_config_id = 1. IF $PS =  1 , process is runing.
		if($PS==0){
			$finish=true;		
		}else{
			printTime("Process is runing");
		}
		#disconnect database		
		my $rv = $dbh->disconnect;	
		printTime("Checked");
		#Check MAIN LOOP
		if($finish eq true){
			$repeat = 'n';
			printTime("Step 2 finished");
			writelog("Finished Step2");
			my $time=getTime();
			sendMail($mailTo,$DailyMailTitle,"Dear all,<p />Run param 1 finished at $time US time.<p />Thanks,<br />Auto send mail.");
		}else{
			sleep(600);
		}
	}
}

sub getConnection{
	my $conn=null;
	#$conn=DBI->connect("dbi:PgPP:dbname=$dbname;host=$host;$port", $usename, $pwd,{RaiseError => 1}) or die "Unable to connect: $DBI::errstr\n";
	$conn=DBIx::AutoReconnect-> connect(
           "dbi:PgPP:dbname=$dbname;host=$host;$port",
           $usename,
           $pwd,
           {
                PrintError => 0,
                ReconnectTimeout => 60,
                ReconnectFailure => sub { warn "oops!" },
				ReconnectMaxTries => 100
           },
     );
	return $conn;
}
sub printTime{
	my $text=shift;
	my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
	$month++;
	$yr19+=1900;
	print "$day-$month-$yr19 $hour:$min:$sec # $text\n";
}
sub writelog{
	my $text=shift;
	my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
	open (FILEHANDEL,">>$locatefd/logs/$date.txt") or die ("Canot open file");
	print FILEHANDEL "$hour:$min:$sec # ".$text."\n";
	close FILEHANDEL;
	$log=$log."$hour:$min:$sec # $text <br />"
}

sub yesterday{
$Dd=-1;
my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
$month++;
$yr19+=1900;
      ($year1,$month1,$day1) = Add_Delta_Days($yr19,$month,$day,$Dd);
	  if($day1<10){
		$day1="0$day1";
	  }
	  if($month1<10){
		$month1="0$month1";
	  }
	  $datet= "$year1-$month1-$day1";
	  $month_log=$month1;
	  $year_log=$year1;
	  return $datet;
}
sub sendMail{
$mailaddress=shift;
$title=shift;
$content=shift;

$callFunction = "cd $binfd;java -jar mail.jar \"smtp.gmail.com\" 587 \"dataman\@ecepvn.org\" \"D\@taman1\" \"$mailaddress\" \"$title\" \"$content\"";

system($callFunction);
}

sub getLog{
	#Create connection
		$dbh = getConnection();		   
		#Cretae String query
		$query="SELECT COUNT(file_name) as totalfiles,MAX(dt_process_loaded)-MIN(dt_file_queued) as time,SUM(staging_load_count)  as staging_load_count, SUM(fact_table_load_count) as fact_table_load_count       
			FROM data_file WHERE file_name like ? AND file_status = 'SU'
			GROUP BY file_status";
		$query_handle = $dbh->prepare($query);
		$query_handle->execute("%$date%");
		$query_handle->bind_columns(undef,\$totalfiles,\$time,\$staging_load_count,\$fact_table_load_count);
		
		while($query_handle->fetch()) {
			my $lost=$staging_load_count-$fact_table_load_count;
			my $temp ="$date,$totalfiles,\/home\/file_xfer\/logs\/done,\'$time\',$staging_load_count,$fact_table_load_count";
			print $temp;
			writelog2($temp);
			$v_ELT_time=$time;
			$v_staging_load_count=$staging_load_count;
			$v_fact_table_load_count=$fact_table_load_count;
		}
		my $rv = $dbh->disconnect;
}

sub writelog2{
	my $text=shift;
	my $logfile="$locatefd/logs/dailylog_".$year_log."_".$month_log.".csv";
	if (-e "$logfile") {			
		open (FILEHANDEL,">>:utf8","$logfile") or die ("Canot open file $logfile");
		print FILEHANDEL $text."\n";
		close FILEHANDEL;
	}else {
		open (FILEHANDEL,">:utf8","$logfile") or die ("Canot oen file $logfile");
		print FILEHANDEL "Date,Total_file,Archive dir,ETL_time,Staging_load_count,Fact_table_load_count\n";
		close FILEHANDEL;
		open (FILEHANDEL,">>$logfile") or die ("Canot oen file");
		print FILEHANDEL $text."\n";
		close FILEHANDEL;
	}
}

sub getTime{
	my $result='';
	my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
	$month++;
	$yr19+=1900;
	$result="$yr19-$month-$day $hour:$min:$sec";
	return $result;
}

sub isInIgnoreList{
	my $logName=shift;
	my $result=0;
	foreach $temp(@ignoreListMark){
		my $index= index($logName,$temp);
		if($index>-1){
			$result=1;
		}
	}
	return $result;
}

sub checkParam{
	my $repeat='y';
	my $process_id_config=shift;
	my $count_true=shift;
	while($repeat eq 'y'){
		my $dbh='';
		my $query='';
		my $query_handle='';
		my $PS=0;
		my $finish=fasle;
		my $error=0;
		my $processId=0;
		
		my $query2='';
		my $query_handle2='';
		my $count=0;
		printTime("Check Param $process_id_config");
		#Create connection
		$dbh = getConnection();
		#Cretae String query
		$query="SELECT process_id,process_status  FROM staging.process
		  WHERE process_status <> 'SU' AND process_config_id =$process_id_config";
		$query_handle = $dbh->prepare($query);
		$query_handle->execute();
		$query_handle->bind_columns(undef, \$process_id,\$process_status);		
		
		# LOOP THROUGH RESULTS
		while($query_handle->fetch()) {
		   print "$process_id\t$process_status\n";
		   $processId=$process_id;
		   $PS++;
		} 
		#Check how many process with process_config_id = 1. IF $PS =  6 , process is runing. But not finish
		if($PS==1){
		#check process_concurrent_tran with $processId. If all 7 true, process finish
			$query2="SELECT process_id, concurrent_trans_name, is_complete, dt_lastchange
			  FROM staging.process_concurrent_trans
			  WHERE process_id = ?";
			$query_handle2 = $dbh->prepare($query2);
			$query_handle2->execute($processId);
			$query_handle2->bind_columns(undef, \$process_id,\$concurrent_trans_name,\$is_complete,\$dt_lastchange);
			
			# LOOP THROUGH RESULTS
			while($query_handle2->fetch()) {
			   print "$process_id\t$concurrent_trans_name\t$is_complete\n";
			   if($is_complete eq 1){
				$count++;
			   }
			}
			if($count == $count_true){
			$finish=true;
			}elsif($count < $count_true){
				printTime("process is runing");
			}
		}elsif($PS==0){
			printTime("No process runing");
			#runParam($process_id_config);
			$finish=true;
		}
		#disconnect database	
		my $rv = $dbh->disconnect;
		printTime("Checked");
		#Check MAIN LOOP
		if($finish eq true){
			$repeat = "n";
			printTime("Param $process_id_config finished");
			writelog("Param $process_id_config finished");
		}else{
			sleep(300);
		}
	}
}

sub runParam{
	my $param=shift;
	$callFunction = "cd $binfd;java -jar nettraffic.jar $param";
	system($callFunction);
}

return 1;
exit;
