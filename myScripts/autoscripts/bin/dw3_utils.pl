use DBI;
use Date::Pcalc qw(:all);
use DBIx::AutoReconnect;
$host="dw3";
$transfer_to_host='dw10';
$transfer_to_list_hosts='dw10,dw6,dw0';
$dbname="warehouse";
$usename="autoscript";
$pwd="ECEP-2009";
$port="5432";
$binfd="/opt/temp/autoscripts/bin";
$sentmail="";
$log="";
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
		$query="SELECT process_id,process_status  FROM control.process
		  WHERE dt_process_queued::date=now()::date AND process_config_id =$process_id_config";
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
			printTime("No process...");
			#runParam($process_id_config);
			#$finish=true;
		}
		#disconnect database	
		my $rv = $dbh->disconnect;
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
		$dbh = getConnection();
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
		my $rv = $dbh->disconnect;
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
#default it is connect to $host
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
	        ReconnectFailure => sub { warn "oops $host !" },
				ReconnectMaxTries => 100
	   },
     );
	return $conn;
}
sub getConnectionDw3{
	my $conn=null;
	#$conn=DBI->connect("dbi:PgPP:dbname=$dbname;host=$host;$port", $usename, $pwd,{RaiseError => 1}) or die "Unable to connect: $DBI::errstr\n";
	$conn=DBIx::AutoReconnect-> connect(
	   "dbi:PgPP:dbname=warehouse;host=dw3;5432",
	   $usename,
	   $pwd,
	   {
	        PrintError => 0,
	        ReconnectTimeout => 60,
	        ReconnectFailure => sub { warn "oops dw3 !" },
				ReconnectMaxTries => 100
	   },
     );
	return $conn;
}
sub getConnectionDw2{
	my $conn=null;
	#$conn=DBI->connect("dbi:PgPP:dbname=$dbname;host=$host;$port", $usename, $pwd,{RaiseError => 1}) or die "Unable to connect: $DBI::errstr\n";
	$conn=DBIx::AutoReconnect-> connect(
	   "dbi:PgPP:dbname=warehouse;host=dw2;5432",
	   $usename,
	   $pwd,
	   {
	        PrintError => 0,
	        ReconnectTimeout => 60,
	        ReconnectFailure => sub { warn "oops dw2 !" },
				ReconnectMaxTries => 100
	   },
     );
	return $conn;
}

sub getConnectionDw4{
	my $conn=null;
	#$conn=DBI->connect("dbi:PgPP:dbname=$dbname;host=$host;$port", $usename, $pwd,{RaiseError => 1}) or die "Unable to connect: $DBI::errstr\n";
	$conn=DBIx::AutoReconnect-> connect(
	   "dbi:PgPP:dbname=warehouse;host=dw4;5432",
	   $usename,
	   $pwd,
	   {
	        PrintError => 0,
	        ReconnectTimeout => 60,
	        ReconnectFailure => sub { warn "oops dw4 !" },
				ReconnectMaxTries => 100
	   },
     );
	return $conn;
}
sub getConnectionDw5{
	my $conn=null;
	#$conn=DBI->connect("dbi:PgPP:dbname=$dbname;host=$host;$port", $usename, $pwd,{RaiseError => 1}) or die "Unable to connect: $DBI::errstr\n";
	$conn=DBIx::AutoReconnect-> connect(
	   "dbi:PgPP:dbname=warehouse;host=dw5;5432",
	   $usename,
	   $pwd,
	   {
	        PrintError => 0,
	        ReconnectTimeout => 60,
	        ReconnectFailure => sub { warn "oops dw5 !" },
				ReconnectMaxTries => 100
	   },
     );
	return $conn;
}
sub getConnectionDw6{
	my $conn=null;
	#$conn=DBI->connect("dbi:PgPP:dbname=$dbname;host=$host;$port", $usename, $pwd,{RaiseError => 1}) or die "Unable to connect: $DBI::errstr\n";
	$conn=DBIx::AutoReconnect-> connect(
	   "dbi:PgPP:dbname=warehouse;host=dw6;5432",
	   $usename,
	   $pwd,
	   {
	        PrintError => 0,
	        ReconnectTimeout => 60,
	        ReconnectFailure => sub { warn "oops dw6 !" },
				ReconnectMaxTries => 100
	   },
     );
	return $conn;
}
sub getConnectionDw10{
	my $conn=null;
	#$conn=DBI->connect("dbi:PgPP:dbname=$dbname;host=$host;$port", $usename, $pwd,{RaiseError => 1}) or die "Unable to connect: $DBI::errstr\n";
	$conn=DBIx::AutoReconnect-> connect(
	   "dbi:PgPP:dbname=warehouse;host=dw10;5432",
	   $usename,
	   $pwd,
	   {
	        PrintError => 0,
	        ReconnectTimeout => 60,
	        ReconnectFailure => sub { warn "oops dw10 !" },
				ReconnectMaxTries => 100
	   },
     );
	return $conn;
}
sub getConnectionDw0{
	my $conn=null;
	#$conn=DBI->connect("dbi:PgPP:dbname=$dbname;host=$host;$port", $usename, $pwd,{RaiseError => 1}) or die "Unable to connect: $DBI::errstr\n";
	$conn=DBIx::AutoReconnect-> connect(
	   "dbi:PgPP:dbname=$dbname;host=localhost;$port",
	   "pentaho",
	   $pwd,
	   {
	        PrintError => 0,
	        ReconnectTimeout => 60,
	        ReconnectFailure => sub { warn "oops dw0 !" },
				ReconnectMaxTries => 100
	   },
     );
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

sub printTime{
	my $text=shift;
	my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
	$month++;
	$yr19+=1900;
	print "$day-$month-$yr19 $hour:$min:$sec # $text\n";
}
sub dw3_writelog{
	my $file=shift;
	my $text=shift;
	my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
	$month++;
	$yr19+=1900;
	my $date="$day-$month-$yr19";
	open (FILEHANDEL,">>$file") or die ("Canot open file");
	print FILEHANDEL "$date $hour:$min:$sec # ".$text."\n";
	close FILEHANDEL;
	$log=$log."$hour:$min:$sec # ".$text."\n";
}

sub dw3_yesterday{
my $Dd=-1;
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
	  %hash=('year' => $year1,'month' => $month1, 'day' => $day1);
	  return %hash;
}
#input db = -1 or -2 or -3 ...
sub dw3_getDate{
my $Dd=shift;
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
	  %hash=('year' => $year1,'month' => $month1, 'day' => $day1);
	  return %hash;
}
sub dw3_currentDate{
$Dd=0;
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
	  %hash=('year' => $year1,'month' => $month1, 'day' => $day1);
	  $datet= "$year1\_$month1\_$day1";
	  #2011_08_01
	  return %hash;
}
sub runParam{
	my $param=shift;
	printTime("Call param $param !");
	my $callFunction = "cd $binfd;java -jar dw3_runparam.jar $param";
	system($callFunction);
	#check to make sure the param is runing
	my $isRuning='no';
	if($param<0) {
		$isRuning='yes';
		return 1;
	};
	while($isRuning eq 'no'){
		#Create connection
		my $dbh = getConnection();
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
		my $rv = $dbh->disconnect;
		if($isRuning eq 'no'){
			#recall the param
			sleep(30);
			my $callFunction = "cd $binfd;java -jar dw3_runparam.jar $param";
			system($callFunction);
			print "recall param $param\n";
		}
	}
}
sub dw3_sendMail{
my $mailaddress=shift;
my $title=shift;
my $content=shift;
my $callFunction = "cd $binfd;java -jar mail.jar \"smtp.gmail.com\" 587 \"dataman\@ecepvn.org\" \"D\@taman1\" \"$mailaddress\" \"$title\" \"$content\" &";
system($callFunction);
}

sub dw3_sendMail_fromVerve{
my $mailaddress=shift;
my $title=shift;
my $content=shift;
my $callFunction = "cd $binfd;java -jar mail.jar \"smtp.gmail.com\" 587 \"dataman\@vervewireless.com\" \"D\@taman1\" \"$mailaddress\" \"$title\" \"$content\" &";
system($callFunction);
}

sub getTime{
	my $result='';
	my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
	$month++;
	$yr19+=1900;
	$result="$yr19-$month-$day $hour:$min:$sec";
	return $result;
}

sub runPGFuntion{
	my $name=shift;
	$callFunction = "cd $binfd;java -jar dw3_runparam.jar -1000 $name";
	system($callFunction);
}

sub runPGFuntion2{
	my $name=shift;
	$callFunction = "cd $binfd;java -jar dw3_runparam.jar -2000 \"$name\" &";
	system($callFunction);
}

sub register_process{
	my $full_date=shift;#2012-02-02
	my $group_process_name=shift;
	my $process_config_id=shift;
	my $e_start_time=shift;# 00:00:00
	my $e_completion_time=shift;# 00:00:00

	my $dbh = getConnection();		   

	#del old record
	my $query="DELETE FROM control.daily_process_status WHERE full_date=? AND process_config_id=?";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($full_date,$process_config_id);

	$query="INSERT INTO control.daily_process_status(full_date, group_process_name, process_config_id, process_status,e_star_time,e_completion_time) VALUES (?, ?, ?, ?, ?, ?)";
	$query_handle = $dbh->prepare($query);
	$query_handle->execute($full_date,$group_process_name,$process_config_id,'Waiting',$e_start_time,$e_completion_time);
	my $rv = $dbh->disconnect;	
}

sub copyAggDataToDw0{
	my ($date_copy,@aggTableDw3)=@_;
	foreach $tableName(@aggTableDw3){
		my $callFunction='';
		if(index($tableName,'*')>=0){			
			$tableName=~s/\*//g;
			print "* Transfer $tableName with partition mode\n";
			$callFunction="su - file_xfer -c \"cd /opt/temp/autoscripts/transformer/ && perl mainWP.pl daily $host $transfer_to_host $tableName $date_copy dw3_util\"";
		}else{
			##my $callFunction ="cd /opt/temp/daily_agg_program/;java -jar DAILY_AGG_DW3_DW0.jar daily $table $date";
			$callFunction="su - file_xfer -c \"cd /opt/temp/autoscripts/transformer/ && perl main.pl daily $host $transfer_to_host $tableName $date_copy dw3_util\"";
		
		}
		system($callFunction);
	}
}

sub copyAggDataToDw10{
	my ($date_copy,@aggTableDw10)=@_;
	foreach $tableName(@aggTableDw10){
		my $callFunction='';
		if(index($tableName,'*')>=0){			
			$tableName=~s/\*//g;
			print "* Transfer $tableName with partition mode\n";
			$callFunction="su - file_xfer -c \"cd /opt/temp/autoscripts/transformer/ && perl mainWP.pl daily $host dw10 $tableName $date_copy dw3_util\"";
		}else{
			##my $callFunction ="cd /opt/temp/daily_agg_program/;java -jar DAILY_AGG_DW3_DW0.jar daily $table $date";
			$callFunction="su - file_xfer -c \"cd /opt/temp/autoscripts/transformer/ && perl main.pl daily $host dw10 $tableName $date_copy dw3_util \"";
		
		}
		system($callFunction);
	}
}

sub copyAggDataDw2ToDw0{
	my ($date_copy,@aggTableDw2)=@_;

	foreach $tableName(@aggTableDw2){
		my $callFunction ="cd /opt/temp/daily_agg_program_dw2_dw0/;java -jar DAILY_AGG_DW2_DW0.jar daily $tableName $date_copy";
		system($callFunction);
	}
}

# is promote. isPromote(44,$host)
sub isPromoted{
	my $param=shift;
	my $server=shift;
	my $result=0;
	#Create connection
	my $dbh='null';
	if($server eq $host) {
		$dbh = getConnection();
	}elsif($server eq 'dw3') {
		$dbh = getConnectionDw3();
	}elsif($server eq 'dw0') {
		$dbh = getConnectionDw0();
	}elsif($server eq 'dw2') {
		$dbh = getConnectionDw2();
	}elsif($server eq 'dw4') {
		$dbh = getConnectionDw4();
	}elsif($server eq 'dw5') {
		$dbh = getConnectionDw5();
	}elsif($server eq 'dw6') {
		$dbh = getConnectionDw6();
	}elsif($dbh eq 'null') {
		return 0;
	}
	#Cretae String query
	my $query="SELECT COUNT(*) as count FROM (SELECT * FROM control.process WHERE process_status <> 'SU' AND process_config_id =$param LIMIT 1) a";
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
	my $rv = $dbh->disconnect;
	return $result;
}
#check param is promoted
sub checkPromoted{
	my $param=shift;
	printTime("Check promote param $param !");
	sleep(5);
	if(isPromoted($param,$host)==0){
		printTime("Param $param hasn't been promoted!");
		dw3_sendMail("chinh.nguyen\@ecepvn.org,tho.hoang\@ecepvn.org","Param $param promote fail","Please promote this param $param by hand!");
		sleep(60);
		checkPromoted($param)
	}else{
		printTime("Param $param has been promoted!");		
	}
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
