#####################################################
#Script implement this library must content $host####
#####################################################
$binfd="/opt/temp/autoscripts/bin";
$sentmail="";
$log="";

require "$binfd/conn_utils_autoscript.pl";
require "$binfd/date_utils.pl";
require "$binfd/sql_utils.pl";
require "$binfd/log_utils.pl";
sub runParam{
	my $param=shift;
	my $dbh = getConnection($host);
	sqlRunPGFuntion("staging.fn_manage_ad_response_process_tasks($param)",$dbh);
	sqlDisconnect($dbh);
	#check to make sure the param is runing
	my $isRuning='no';
	while($isRuning eq 'no'){
		#Create connection
		my $dbh = getConnection($host);
		#Cretae String query
		my $query="SELECT process_id,process_status  FROM control.process
		  WHERE process_status <> 'SU' AND process_config_id =$param";
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute();
		$query_handle->bind_columns(undef, \$process_id,\$process_status);		
		
		# LOOP THROUGH RESULTS
		while($query_handle->fetch()) {
			print "Process param $param has been runing with ID $process_id\n";
			$isRuning='yes';
		} 
		#disconnect database	
		sqlDisconnect($dbh);
		if($isRuning eq 'no'){
			#recall the param
			sleep(30);
			print "recall param $param\n";
			my $dbh = getConnection($host);
			sqlRunPGFuntion("staging.fn_manage_ad_response_process_tasks($param)",$dbh);
			sqlDisconnect($dbh);
		}
	}
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
		$dbh = getConnection($host);
		#Cretae String query
		$query="SELECT process_id,process_status  FROM control.process
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
			  FROM control.process_concurrent_trans
			  WHERE process_id = ?";
			$query_handle2 = $dbh->prepare($query2);
			$query_handle2->execute($processId);
			$query_handle2->bind_columns(undef, \$process_id,\$concurrent_trans_name,\$is_complete,\$dt_lastchange);
			
			# LOOP THROUGH RESULTS
			while($query_handle2->fetch()) {
			   ##print "$process_id\t$concurrent_trans_name\t$is_complete\n";
			   if($is_complete eq 1){
				$count++;
			   }
			}
			if($count == $count_true){
			$finish=true;
			}elsif($count < $count_true){
				##printTime("process is runing");
			}
		}elsif($PS==0){
			printTime("No process...");
			#runParam($process_id_config);
			$finish=true;
		}
		#disconnect database	
		sqlDisconnect($dbh);
		##printTime("Checked");
		#Check MAIN LOOP
		if($finish eq true){
			$repeat = "n";
			printTime("Param $process_id_config finished");
		}else{
			sleep(120);
		}
	}
}
sub checkParam2{
	#check the process which don't has sub process
	my $repeat='y';
	my $process_id_config=shift;
	my $process_date=shift;#2012-02-29
	while($repeat eq 'y'){
		my $dbh='';
		my $query='';
		my $query_handle='';
		my $PS=0;
		my $finish=fasle;
		my $error=0;
		my $processId=0;
		my $processStatus='no';
		
		my $query2='';
		my $query_handle2='';
		my $count=0;
		printTime("Check Param $process_id_config");
		#Create connection
		$dbh = getConnection($host);
		#Cretae String query
		$query="SELECT process_id,process_status  FROM control.process
		  WHERE process_config_id=$process_id_config AND dt_process_queued::date=?";
		$query_handle = $dbh->prepare($query);
		$query_handle->execute($process_date);
		$query_handle->bind_columns(undef, \$process_id,\$process_status);		
		
		# LOOP THROUGH RESULTS
		while($query_handle->fetch()) {
		   $processId=$process_id;
		   $processStatus=$process_status;
		} 
		if($processStatus eq 'SU'){
			$finish=true;
		}elsif($processStatus eq 'no'){
			print "Process $process_id_config in day $process_date is not run!\n";
			runParam($process_id_config);
			#$finish=true;
		}else{
			print "$process_id_config|$processId|$processStatus!\n";
		}
		#disconnect database	
		sqlDisconnect($dbh);
		printTime("Checked");
		#Check MAIN LOOP
		if($finish eq true){
			$repeat = "n";
			printTime("Param $process_id_config finished");
		}else{
			sleep(120);
		}
	}
}
#default it is connect to dw3
sub getConnection{
	my $conn=null;
	my $host=shift;
	$conn=getConnection($host);
	return $conn;
}
sub getConnectionDw2{
	my $conn=getConnectionAutoScript('dw2');
	return $conn;
}
sub getConnectionDw0{
	my $conn=getConnectionAutoScript('dw0');
	return $conn;
}

sub getConnectionWIP{
	my $conn=null;
	#$conn=DBI->connect("dbi:PgPP:dbname=$dbname;host=$host;$port", $usename, $pwd,{RaiseError => 1}) or die "Unable to connect: $DBI::errstr\n";
	$conn=DBIx::AutoReconnect-> connect(
           "dbi:mysql:dbname=network;host=verve.calai8nkmpct.us-east-1.rds.amazonaws.com;3306",
           "etlrw",
           "h5X4qnx5",
           {
                PrintError => 0,
                ReconnectTimeout => 60,
                ReconnectFailure => sub { warn "oops Wip database !" },
				ReconnectMaxTries => 100
           },
     );
	return $conn;
}

sub register_process{
	my $full_date=shift;#2012-02-02
	my $group_process_name=shift;
	my $process_config_id=shift;
	my $e_start_time=shift;# 00:00:00
	my $e_completion_time=shift;# 00:00:00
	
	my $dbh = getConnection($host);		   
	
	#del old record
	my $query="DELETE FROM control.daily_process_status WHERE full_date=? AND process_config_id=?";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($full_date,$process_config_id);
	
	$query="INSERT INTO control.daily_process_status(full_date, group_process_name, process_config_id, process_status,e_star_time,e_completion_time) VALUES (?, ?, ?, ?, ?, ?)";
	$query_handle = $dbh->prepare($query);
	$query_handle->execute($full_date,$group_process_name,$process_config_id,'Waiting',$e_start_time,$e_completion_time);
	sqlDisconnect($dbh);
}

sub copyAggDataToDw0{
	my ($date_copy,@aggTableDw3)=@_;
	foreach $tableName(@aggTableDw3){
		my $callFunction ="su - file_xfer -c \"cd /opt/temp/autoscripts/transformer/ && perl main.pl daily $host dw0 $tableName $date_copy\" ";
		system($callFunction);
	}
}

sub copyAggDataToDw{
	my ($transfer_to,$date_copy,@aggTableDw3)=@_;
	my $callFunction='';
	foreach $tableName(@aggTableDw3){
		if(index($tableName,'*')>=0){
			$tableName=~s/\*//g;
			print "* Transfer $tableName with partition mode\n";
			$callFunction="su - file_xfer -c \"cd /opt/temp/autoscripts/transformer/ && perl mainWP.pl daily $host $transfer_to $tableName $date_copy dw_util\"";
		}else{
			$callFunction ="su - file_xfer -c \"cd /opt/temp/autoscripts/transformer/ && perl main.pl daily $host $transfer_to $tableName $date_copy dw_util\" ";
			
		}
		system($callFunction);		
	}
}

sub copyAggDataToDw2{
	my ($transfer_to,$transfer_by,$date_copy,@aggTableDw3)=@_;
	my $callFunction='';
	foreach $tableName(@aggTableDw3){
		if(index($tableName,'*')>=0){
			$tableName=~s/\*//g;
			print "* Transfer $tableName with partition mode\n";
			$callFunction="su - file_xfer -c \"cd /opt/temp/autoscripts/transformer/ && perl mainWP.pl daily $host $transfer_to $tableName $date_copy $transfer_by\"";
		}else{
			$callFunction ="su - file_xfer -c \"cd /opt/temp/autoscripts/transformer/ && perl main.pl daily $host $transfer_to $tableName $date_copy $transfer_by\" ";
			
		}
		system($callFunction);	
	}
}

# is promote. isPromote(44,dw3)
sub isPromoted{
	my $param=shift;
	my $server=shift;
	my $result=0;
	#Create connection
	my $dbh=getConnection($server);

	#Cretae String query
	my $query="SELECT COUNT(*) as count FROM control.process WHERE process_status <> 'SU' AND process_config_id =$param";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	$query_handle->bind_columns(undef, \$count);		
	
	# LOOP THROUGH RESULTS
	while($query_handle->fetch()) {
		if($count == 0){
			$result=1;
		}
	} 
	#disconnect database	
	sqlDisconnect($dbh);
	return $result;
}

sub promoteParam{
	my $function=shift;
	my $dbh = getConnection($host);
	sqlRunPGFuntion("$function",$dbh);
	sqlDisconnect($dbh);
}


sub writelog{
	my $text=shift;
	dw3_writelog($logFile,$text);
}

sub sendMail{
#$mailaddress="chinh.nguyen\@ecepvn.org,binh.nguyen\@ecepvn.org,song.nguyen\@ecepvn.org,tho.hoang\@ecepvn.org";
my $mailaddress=shift;
my $title=shift;
my $content=shift;
my $callFunction = "cd $binfd;java -jar mail.jar \"smtp.gmail.com\" 587 \"dataman\@ecepvn.org\" \"D\@taman1\" \"$mailaddress\" \"$title\" \"$content\" &";
system($callFunction);
}

#get date array input start date and end date with format yyyy-mm-dd
sub getDateArray{
	my $startDate = shift;
	my $endDate   = shift;

	my $leap = isLeap( ( split m{-}, $startDate )[ 0 ] );

	my @dates = ( $startDate );
	while( $startDate lt $endDate )
	{
		$startDate = incByOneDay( $startDate );
		push @dates, $startDate;
	}
	return @dates;
}

sub incByOneDay
{
    my $raDaysInMonth = [
       [ 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ],
       [ 0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ],
       ];

    my( $y, $m, $d ) = split m{-}, $_[ 0 ];
    $d ++;
    $d = 1, $m ++
       if $d > $raDaysInMonth->[ $leap ]->[ $m ];
    $m = 1, $y ++, $leap = isLeap( $y )
       if $m > 12;

    return sprintf q{%04d-%02d-%02d}, $y, $m, $d;
}

sub isLeap
{
    my $year = shift;
    return 0 if $year % 4;
    return 1 if $year % 100;
    return 1 unless $year % 400;
    return 0;
}

return 1;
exit;