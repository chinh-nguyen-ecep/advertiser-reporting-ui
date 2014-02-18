	#####################################################
	#Script implement this library must content $host####
	#####################################################
	use DBI;
	use Date::Pcalc qw(:all);
	use DBIx::AutoReconnect;
	$binfd="/home/autoscript/bin/dailyAggregateAutoScripts";
	$sentmail="";
	$log="";

	$today_date='';
	$today_date_sk='';
	$report_date='';
	$report_date_sk=0;
	$report_date_rollback_7='';
	$report_date_rollback_7_sk=0;


	require "$binfd/config.pl";
	require "$binfd/utils/ConnectionDB.pl";
	require "$binfd/utils/date_utils.pl";
	require "$binfd/utils/sql_utils.pl";
	require "$binfd/utils/log_utils.pl";

	init();

	sub getReportDate{
		note("*Get report date...");
		my $dbh = getConnection($host);
		my $query=" SELECT 
						min(full_date) as report_date_rollback_7 ,min(date_sk) as report_date_rollback_7_sk,
						max(full_date) as report_date,max(date_sk) as report_date_sk 
					FROM 
						refer.date_dim 
					WHERE 
						full_date BETWEEN now()::date-7 AND now()::date-1
		";
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute();
		$query_handle->bind_columns(undef, \$report_date_rollback_7,\$report_date_rollback_7_sk, \$report_date,\$report_date_sk);
		$query_handle->fetch();	

		my $query=" SELECT 
						full_date as today_date ,date_sk as today_date_sk					
					FROM 
						refer.date_dim 
					WHERE 
						full_date = now()::date
		";
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute();
		$query_handle->bind_columns(undef, \$today_date,\$today_date_sk);
		$query_handle->fetch();
		sqlDisconnect($dbh);
		note("Today date: $today_date");
		note("Today date sk: $today_date_sk");
		note("Report date: $report_date");
		note("Report date sk: $report_date_sk");
		note("Report date roll back 7 day: $report_date_rollback_7");
		note("Report date roll back 7 day sk: $report_date_rollback_7_sk");
	}

	sub runParam{
		my $param=shift;
		my $period = shift;
		my $dbh = getConnection($host);
		my ($process_id,$process_status);
		sqlRunPGFuntion("staging.fn_manage_report_process_tasks($param,$period)",$dbh);
		sqlDisconnect($dbh);
		#check to make sure the param is runing
		my $isRuning='no';
		while($isRuning eq 'no'){
			#Create connection
			my $dbh = getConnection($host);
			#Cretae String query
			my $query="SELECT process_id,process_status  FROM control.process
			  WHERE process_status = 'PS' AND process_config_id =$param AND dt_process_queued::date=?";
			my $query_handle = $dbh->prepare($query);
			$query_handle->execute($today_date);
			$query_handle->bind_columns(undef, \$process_id,\$process_status);		
			
			# LOOP THROUGH RESULTS
			while($query_handle->fetch()) {
				$isRuning='yes';
			} 
			#disconnect database	
			sqlDisconnect($dbh);
			if($isRuning eq 'no'){
				#recall the param
				sleep(30);
				print "recall param $param\n";
				runParam($param,$period);
			}else{
				note("Process param $param has been runing with ID $process_id");
			}
		}
	}

	sub checkParam{
		my $repeat='y';
		my $process_id_config=shift;
		my $total_count=0;
		my $count_true=0;
		my $process_id=0;
		my $process_status='PS';

		note("*Check Param $process_id_config run in $today_date ");
		#Create connection
		my $dbh = getConnection($host);
		#Get process id
		my $query="SELECT process_id,process_status  FROM control.process
		  WHERE process_config_id =$process_id_config AND dt_process_queued::date=? ORDER BY process_id desc LIMIT 1";
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute($today_date);
		$query_handle->bind_columns(undef, \$process_id,\$process_status);		
		$query_handle->fetch();
		sqlDisconnect($dbh);
		if($process_id>0 && $process_status eq 'PS'){
			note("Process id: $process_id");
			my $dbh = getConnection($host);
			# Get total trans of process
			my $query="SELECT COUNT(1) as  total_count FROM control.process_concurrent_trans
						WHERE  process_id = $process_id";	
			my $query_handle = $dbh->prepare($query);					
			$query_handle->execute();
			$query_handle->bind_columns(undef, \$total_count);		
			$query_handle->fetch();
			# Get total count of trans with status is_complete=TRUE of process
			my $query="SELECT COUNT(1) as  count_true FROM control.process_concurrent_trans
						WHERE  process_id = $process_id AND is_complete=TRUE";	
			my $query_handle = $dbh->prepare($query);							
			$query_handle->execute();
			$query_handle->bind_columns(undef, \$count_true);		
			$query_handle->fetch();			
			sqlDisconnect($dbh);
			note("Total Trans: $total_count");
			note("Total Trans Completed: $count_true");
			if($total_count!=$count_true){
				sleep(60);
				checkParam($process_id_config);
			}else{
				printTime("Process completed!");		
			}
		}elsif($process_id>0 && $process_status eq 'SU'){
			printTime("Process completed before checking!");	
		}else{
			while(1){
				note("*** No process runing. Please check process by hand....");
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

	# is promote. isPromote(44,dw3)
	sub isPromoted{
		my $param=shift;
		my $server=shift;
		my $result=0;
		my $process_status='null';
		#Create connection
		my $dbh=getConnection($server);

		#Cretae String query
		my $query="SELECT process_status FROM control.process WHERE process_config_id =$param AND dt_process_queued::date=? ORDER BY process_id desc LIMIT 1";
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute($today_date);
		$query_handle->bind_columns(undef, \$process_status);		
		$query_handle->fetch();
		sqlDisconnect($dbh);
		if($process_status eq 'PS'){
			$result=0;
		}else{
			$result=1;
		}
		return $result;
	}

	sub promoteParam{
		my $function=shift;
		my $dbh = getConnection($host);
		sqlRunPGFuntion("$function",$dbh);
		note("Call function: $function");
		sqlDisconnect($dbh);
	}

	sub checkFileLoading{
		note("*Check file loading...");
		my $dbh=getConnection($host);
		my $total_files=0;
		my $loaded_file=0;
		my $loaded_file_ok=0;
		my $loaded_fail=1;
		my $waiting=1;
		my $recheck=1;
		my $data_file_config_id=shift;
		note("Data file config id: $data_file_config_id");
		my $query=" SELECT count(1) as total_files, b.loaded_file as loaded_file, d.loaded_file_ok as loaded_file_ok, c.loaded_fail as loaded_fail, count(1) - b.loaded_file as waiting
					FROM control.data_file 
					,(SELECT count(1) as loaded_file FROM control.data_file WHERE data_file_config_id IN ($data_file_config_id) and file_timestamp::date = ? and file_status = 'SU') b
					,(SELECT count(1) as loaded_fail FROM control.data_file WHERE data_file_config_id IN ($data_file_config_id) and file_timestamp::date = ? and file_status = 'EF') c
					,(SELECT count(1) as loaded_file_ok FROM control.data_file WHERE data_file_config_id IN ($data_file_config_id) and file_timestamp::date = ? and file_status = 'SU' and staging_load_count > 0) d
					WHERE data_file_config_id IN ($data_file_config_id) and file_timestamp::date = ?
					GROUP BY b.loaded_file, c.loaded_fail, d.loaded_file_ok";
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute($report_date,$report_date,$report_date,$report_date);
		$query_handle->bind_columns(undef, \$total_files,\$loaded_file,\$loaded_file_ok, \$loaded_fail,\$waiting);
		$query_handle->fetch();					
		sqlDisconnect($dbh);
		if($total_files>0 && $total_files==$loaded_file && $loaded_fail==0 && $waiting==0 && $loaded_file_ok>0){
			$recheck=0;
		}
		
		if($recheck==1){
			note("Total file: $total_files\nLoaded files: $loaded_file\nLoaded filesok: $loaded_file_ok\nLoaded fail: $loaded_fail\nWaiting: $waiting\nRecheck after 60s!");
			my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
			if($hour==23 && $min>50){
				die "Process time out!\n";
			}
			sleep(60);
			checkFileLoading($data_file_config_id);
		}else{
			note("Total file: $total_files");
			printTime("Loading file completed!");
		}	

	}

	sub sendMail{
	#$mailaddress="chinh.nguyen\@ecepvn.org,binh.nguyen\@ecepvn.org,song.nguyen\@ecepvn.org,tho.hoang\@ecepvn.org";
	my $mailaddress=shift;
	my $title=shift;
	my $content=shift;
	my $callFunction = "cd $binfd/utils;java -jar mail.jar \"smtp.gmail.com\" 587 \"chinh.nguyen\@ecepvn.org\" \"verve-2013\" \"$mailaddress\" \"$title\" \"$content\" &";
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

	sub init{
		note("*Init the autoscript...");
		note("Aggregate process run on: $host");
		getReportDate();
	}
	return 1;
	exit;
