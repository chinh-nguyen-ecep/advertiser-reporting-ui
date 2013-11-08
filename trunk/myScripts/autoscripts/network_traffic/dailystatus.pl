use DBI;
use DBIx::AutoReconnect;
use Date::Pcalc qw(:all);
#version 2 add dailylog csv
#Version 3 count file log not is 14
$host="dw1";
$dbname="warehouse";
$usename="song";
$pwd="secep-2010";
$port="5432";
$month_log='';
$year_log='';
$date=yesterday();
$date2='';
$log="";
$sentmail="";
$v_ELT_time='';
$v_staging_load_count='';
$v_fact_table_load_count='';


	#get date input
	#print "Nhap ngay kiem tra: ";
	#chomp($date=<>);
	#print "repeat date: ";
	#chomp($date2=<>);
	#if($date eq $date2){
	#	main();
	#}else{
	#print "Wrong date\n";
	#}
#print "The date is: $date(y/n): ";
#chomp($enter=<>);
$enter="y";
if($enter eq "y"){
	main();
}else{
	print "Nhap ngay kiem tra: ";
	chomp($date=<>);
	print "repeat date: ";
	chomp($date2=<>);
	if($date eq $date2){
		main();
	}else{
	print "Wrong date\n";
	}
}

sub main{
	#Check 14 file logs
	my $error=check14SU();
	if($error == 0){
		checkStep2();
		printTime("Run function param 6");
		checkStep3();
		printTime("Stop daily report with no error");
	}else{
		
	}
	
}

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
					$error++;
					my $errorfile=$file_name;
					#send mail error					
					if(index($sentmail,$errorfile)==-1){
						#sendMail("Daily report $date error","Dear all,<p />Extract log file is error at $errorfile file. Load count = 0.<p />Thanks,<br />Auto send mail.");
						$sentmail=$sentmail.",$errorfile";
					}	
				}				
		   }elsif($file_status eq 'EF'){
				$error++;
				my $errorfile=$file_name;
					#send mail error					
					if(index($sentmail,$errorfile)==-1){
						#sendMail("Daily report $date error","Dear all,<p />Extract log file is error at $errorfile file. File status is EF<p />Thanks,<br />Auto send mail.");
						$sentmail=$sentmail.",$errorfile";
					}					
		   }
		} 
		printTime("SU : $SU \t Error: $error"); 
		#disconnect database
		my $rv = $dbh->disconnect;
		#Check process status
		if($SU==$countfile && $error==0){
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
		}else{
			sleep(600);
		}
	}
}
#
# This function will check Step3 .
#
sub checkStep3{
	my $repeat='y';
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
		printTime("Check Step 3");
		#Create connection
		$dbh = getConnection();	
		#Cretae String query
		$query="SELECT process_id,process_status  FROM staging.process
		  WHERE process_status <> 'SU' AND process_config_id =6";
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
			if($count == 7){
			$finish=true;
			}elsif($count < 7){
				printTime("process is runing");
			}
		}elsif($PS==0){
			printTime("No process runing");
			$finish=true;
		}
		#disconnect database	
		my $rv = $dbh->disconnect;
		printTime("Checked");
		#Check MAIN LOOP
		if($finish eq true){
			$repeat = "n";
			printTime("Step 3 finished");
			writelog("Finished Step 3");
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
$mailaddress="chinh.nguyen\@ecepvn.org,binh.nguyen\@ecepvn.org,song.nguyen\@ecepvn.org,tho.hoang\@ecepvn.org,thang.nguyen\@ecepvn.org,phanleson\@gmail.com, dailymail\@ecepvn.org";
$title=shift;
$content=shift;

}

sub getLog{
	
}

sub writelog2{
	
}
