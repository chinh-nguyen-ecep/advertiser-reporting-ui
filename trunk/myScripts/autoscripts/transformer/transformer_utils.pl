use DBI;
use Date::Pcalc qw(:all);
use POSIX qw(strftime);
use DBIx::AutoReconnect;
use IPC::System::Simple qw(
    capture capturex system systemx run runx $EXITVAL EXIT_ANY
  );
require "config.pl";

$timeout=10800;

if(@ARGV>=2){
	$mode=$ARGV[0];
	if($mode eq 'daily'){
		transfer_daily(@ARGV);
	}elsif($mode eq 'daily_fact'){
		transfer_daily_fact(@ARGV);
	}elsif($mode eq 'daily_range'){
		transfer_daily_range(@ARGV);	
	}elsif($mode eq 'monthly'){
		transfer_monthly(@ARGV);
	}elsif($mode eq 'table'){
		transfer_all_table(@ARGV);
	}elsif($mode eq 'table2'){
		transfer_all_table2(@ARGV);
	}elsif($mode eq 'dim_no_dt_expire'){
		transfer_dim_no_dt_expire(@ARGV);
	}elsif($mode eq 'dim'){
		transferDimFromConfigFile(@ARGV);
	}elsif($mode eq 'allTableByMonth'){
		all_table_porting_by_month(@ARGV);
	}elsif($mode eq 'allTableByDateRange'){
		all_table_porting_by_daterange(@ARGV);
	}elsif($mode eq 'test'){
		my $dbh=getConnection("dw2");
		my $rv = $dbh->disconnect;
	}
	
}else{
	print "perl main.pl/mainWP.pl daily dw3 dw5 adnetwork.daily_mx_performance 2012-05-01\n";
	print "perl main.pl/mainWP.pl daily_range dw3 dw5 adnetwork.daily_mx_performance 2012-05-01 2012-05-10\n";
	print "perl main.pl/mainWP.pl daily_fact dw3 dw5 adnetwork.daily_mx_performance 2615(date_sk)\n";
	print "perl main.pl/mainWP.pl monthly dw3 dw5 adnetwork.daily_mx_performance 2012-Mar\n";
	print "perl main.pl/mainWP.pl table dw3 dw5 adnetwork.daily_mx_performance\n";
	print "perl main.pl/mainWP.pl table2 dw3 dw5 adnetwork.daily_mx_performance adm.daily_mx_performance\n";
	print "perl main.pl/mainWP.pl dim_no_dt_expire dw3 dw10 refer.dim_table_content_dt_expire\n";
	print "perl main.pl/mainWP.pl dim dw3 dw10\n";
	print "perl main.pl/mainWP.pl allTableByMonth dw3 dw10 2012-Nov\n";
	print "perl main.pl/mainWP.pl allTableByDateRange dw3 dw10 2012-05-01 2012-05-02\n";
	print "perl main.pl table dw2:warehouse:5433 dw10:warehouse_networktraffic dw.daily_agg_group_act_all\n";
	print "perl main.pl table dw2:warehouse:5433 dw10 dw.daily_agg_group_act_all\n";
}

sub transfer_daily{
	my ($mode,$from,$to,$table_name,$date,$transfer_by_input)=@_;
	$transfer_by=$transfer_by_input;
	my $pid;
	eval {
			local $SIG{'ALRM'} = sub { die "timed out\n" };
			alarm($timeout);
			$pid = fork;		
			if ($pid == 0) {
				## your scripts
				export_table($from,$to,$table_name,"full_date='$date' AND is_active=true","$from.$table_name");
				import_table($to,$table_name,"full_date='$date' AND is_active=true","$from.$table_name");
				if($export_count>0 && $import_count>0 && $export_count!=$import_count){
					print "***Export count $export_count and Import count $import_count do not match\n i will retransfer!\n";
					transfer_daily(@ARGV);
				}else{
					if($to eq $transformer_host && $backup_mode==1){
						print "\n*****************************************\n Transfer to backup server of $transformer_host \n*****************************************\n";
						foreach $host_bk(@backup_host_array){
							print "# Backup To $host_bk ######################\n";
							sleep(5);
							my $comand='';
							if($export_type eq 'Partition'){
								$comand="cd $rootFD && perl mainWP.pl daily $transformer_host $host_bk $table_name $date $transfer_by > /dev/null 2>&1 & ";					
							}else{
								$comand="cd $rootFD && perl main.pl daily $transformer_host $host_bk $table_name $date $transfer_by > /dev/null 2>&1 &";
							}
								system($comand);
								##system("ps aux|grep \"$comand\"");
						}
					}
				}
				## end your scripts
			}
			else {
					wait;
			}
			alarm(0);
	};
	if ($@) {
			if ($@ eq "timed out\n") {					
					kill(9,$pid);
					note("The process $pid timed out\n");  
			}
			else {
					print "something else went boom\n";
			}
	}
	else {
			##print "I didn't time out\n";
	}
}

sub transfer_daily_range{
	my ($mode,$from,$to,$table_name,$date,$end_date,$transfer_by_input)=@_;
	$transfer_by=$transfer_by_input;
	my $pid;
	eval {
			local $SIG{'ALRM'} = sub { die "timed out\n" };
			alarm($timeout);
			$pid = fork;		
			if ($pid == 0) {
				## your scripts
				export_table($from,$to,$table_name,"full_date BETWEEN '$date'::date AND '$end_date'::date AND is_active=true","$from.$table_name");
				import_table($to,$table_name,"full_date BETWEEN '$date'::date AND '$end_date'::date AND is_active=true","$from.$table_name");
				if($export_count>0  && $export_count!=$import_count){
					print "***Export count $export_count and Import count $import_count do not match\n i will retransfer!\n";
					$export_count=0;
					$import_count=0;
					transfer_daily_range(@ARGV);
				}else{
					if($to eq $transformer_host && $backup_mode==1){
						print "\n*****************************************\n Transfer to backup server of $transformer_host \n*****************************************\n";
						foreach $host_bk(@backup_host_array){
							print "# Backup To $host_bk ######################\n";
							sleep(5);
							if($export_type eq 'Partition'){
								system("cd $rootFD && perl mainWP.pl daily_range $transformer_host $host_bk $table_name $date $end_date $transfer_by > /dev/null 2>&1 & ");
							}else{
								system("cd $rootFD && perl main.pl daily_range $transformer_host $host_bk $table_name $date $end_date $transfer_by > /dev/null 2>&1 &");
							}				
						}
					}	
				}
				## end your scripts
			}
			else {
					wait;
			}
			alarm(0);
	};
	if ($@) {
			if ($@ eq "timed out\n") {					
					kill(9,$pid);
					note("The process $pid timed out\n");  
			}
			else {
					print "something else went boom\n";
			}
	}
	else {
			##print "I didn't time out\n";
	}
}

sub transfer_daily_fact{
	my ($mode,$from,$to,$table_name,$eastern_date_sk,$transfer_by_input)=@_;
	$transfer_by=$transfer_by_input;
	export_table($from,$to,$table_name,"eastern_date_sk='$eastern_date_sk'","$from.$table_name");
	import_table($to,$table_name,"eastern_date_sk='$eastern_date_sk'","$from.$table_name");	
	if($export_count>0 && $import_count>0 && $export_count!=$import_count){
		print "***Export count $export_count and Import count $import_count do not match\n i will retransfer!\n";
		transfer_daily_fact(@ARGV);
	}
}

sub transfer_all_table{
	my ($mode,$from,$to,$table_name,$transfer_by_input)=@_;
	$transfer_by=$transfer_by_input;
	export_table($from,$to,$table_name,"","$from.$table_name");
	import_table($to,$table_name,"","$from.$table_name");
	if($export_count>0 && $import_count>0 && $export_count!=$import_count){
		print "***Export count $export_count and Import count $import_count do not match\n i will retransfer!\n";
		transfer_all_table(@ARGV);
	}else{
		if($to eq $transformer_host && $backup_mode==1){
			print "\n*****************************************\n Transfer to backup server of $transformer_host \n*****************************************\n";
			foreach $host_bk(@backup_host_array){
				print "# Backup To $host_bk ######################\n";
				$ARGV[1]=$transformer_host;
				$ARGV[2]=$host_bk;
				transfer_all_table(@ARGV);			
			}
		}	
	}	
}

sub transfer_all_table2{
	my ($mode,$from,$to,$table_name,$table_name2,$transfer_by_input)=@_;
	$transfer_by=$transfer_by_input;
	export_table($from,$to,$table_name,"","$from.$table_name");
	import_table($to,$table_name2,"","$from.$table_name");
	if($export_count>0 && $import_count>0 && $export_count!=$import_count){
		print "***Export count $export_count and Import count $import_count do not match\n i will retransfer!\n";
		transfer_all_table2(@ARGV);
	}	
}

sub transfer_monthly{
	my ($mode,$from,$to,$table_name,$month,$transfer_by_input)=@_;
	$transfer_by=$transfer_by_input;
	export_table($from,$to,$table_name,"calendar_year_month='$month' AND is_active=true","$from.$table_name");
	import_table($to,$table_name,"calendar_year_month='$month' AND is_active=true","$from.$table_name");
	if($export_count>0 && $import_count>0 && $export_count!=$import_count){
		print "***Export count $export_count and Import count $import_count do not match\n i will retrasnfer!\n";
		transfer_monthly(@ARGV);
	}else{
		if($to eq $transformer_host && $backup_mode==1){
			print "\n*****************************************\n Transfer to backup server of $transformer_host \n*****************************************\n";
			foreach $host_bk(@backup_host_array){
				print "# Backup To $host_bk ######################\n";
				sleep(5);
				if($export_type eq 'Partition'){
					system("cd $rootFD && perl mainWP.pl monthly $transformer_host $host_bk $table_name \"$month\" $transfer_by > /dev/null 2>&1 & ");
				}else{
					system("cd $rootFD && perl main.pl monthly $transformer_host $host_bk $table_name \"$month\" $transfer_by > /dev/null 2>&1 & ");
				}
			}
		}	
	}			
}

sub transfer_dim_no_dt_expire{
	my ($mode,$from,$to,$table_name,$transfer_by_input)=@_;
	$transfer_by=$transfer_by_input;
	my $timeout=600;
	my $pid;
	eval {
			local $SIG{'ALRM'} = sub { die "timed out\n" };
			alarm($timeout);
			$pid = fork;		
			if ($pid == 0) {
				## your scripts
				export_table($from,$to,$table_name,"dt_expire='9999-12-31'","$from.$table_name");
				import_table($to,$table_name,"","$from.$table_name");
				if($export_count>0 && $import_count>0 && $export_count!=$import_count){
					print "***Export count $export_count and Import count $import_count do not match\n i will retrasnfer!\n";
					transfer_dim_no_dt_expire(@ARGV);
				}else{
					if($to eq $transformer_host && $backup_mode==1){
						print "*****************\n Transfer to backup server of $transformer_host \n*****************\n";
						foreach $host_bk(@backup_host_array){
							print "# Backup To $host_bk ######################\n";
							sleep(5);
							system("cd $rootFD && perl main.pl dim_no_dt_expire $transformer_host $host_bk $table_name $transfer_by > /dev/null 2>&1 &");
						}
					}
				}
				## end your scripts
			}
			else {
					wait;
			}
			alarm(0);
	};
	if ($@) {
			if ($@ eq "timed out\n") {					
					kill(9,$pid);
					note("The process $pid timed out\n");  
			}
			else {
					print "something else went boom\n";
			}
	}
	else {
			##print "I didn't time out\n";
	}	
}

sub all_table_porting_by_month{
	my ($mode,$from,$to,$month,$transfer_by_input)=@_;
	$transfer_by=$transfer_by_input;
	my @aggTable=();
	#load daily agg table from file
	my $agg_table="monthly_agg_table.txt";
	open (CHECKBOOK, "< $agg_table") || die "couldn't open the file!";

	while ($record = <CHECKBOOK>) {
	  $record=~s/[\x0A\x0D]//g;
	  if(index($record,'#')>=0){
	  
	  }else{
		  push(@aggTable,$record);
	  }

	}
	close(CHECKBOOK);
	my $i=0;
	foreach $table(@aggTable){
		$i++;
		print "################################\n$i. $table $month \n################################\n";
		sleep(10);
		my $callFunction ="cd $rootFD;perl main.pl monthly $from $to $table $month $transfer_by_input";
		system($callFunction);
		#transfer_monthly($mode,$from,$to,$table,$month,$transfer_by);
	}
}


sub all_table_porting_by_daterange{
	my ($mode,$from,$to,$start_date,$end_date,$transfer_by_input)=@_;
	$transfer_by=$transfer_by_input;
	my @aggTable=();
	#load daily agg table from file
	my $agg_table="daily_agg_table.txt";
	open (CHECKBOOK, "< $agg_table") || die "couldn't open the file!";

	while ($record = <CHECKBOOK>) {
	  $record=~s/[\x0A\x0D]//g;
	  if(index($record,'#')>=0){
	  
	  }else{
		  push(@aggTable,$record);
	  }

	}
	close(CHECKBOOK);
	my $i=0;
	foreach $table(@aggTable){
		$i++;
		print "################################\n$i. $table $start_date to $end_date \n################################\n";
		sleep(10);
		my $callFunction ="cd $rootFD;perl main.pl daily_range $from $to $table $start_date $end_date $transfer_by_input";
		system($callFunction);
		#transfer_monthly($mode,$from,$to,$table,$month,$transfer_by);
	}
}

sub transferDimFromConfigFile{
	my ($mode,$from,$to,$transfer_by_input)=@_;
	$transfer_by=$transfer_by_input;
	my @dimTable=();
	#load daily agg table from file
	my $dim_table="dim_table.txt";
	open (CHECKBOOK, "< $dim_table") || die "couldn't open the file $dim_table!";

	while ($record = <CHECKBOOK>) {
	  $record=~s/[\x0A\x0D]//g;
	  if(index($record,'#')>=0){
	  
	  }else{
		  push(@dimTable,$record);
	  }

	}
	close(CHECKBOOK);
	my $i=0;
	foreach $table(@dimTable){
		$i++;		
		print "* $i $table\n";
		$callFunction="cd $rootFD && perl mainF.pl dim_no_dt_expire $from $to $table $transfer_by";
		system($callFunction);
		#verifi dim
		my $row_count=0;
		my $tack=0;
		my $sleepTime=5;
		while($row_count==0){
			$tack++;
			my $dbh = getConnection($to);
			my $query="SELECT COUNT(1) as row_count FROM $table";
			my $query_handle = $dbh->prepare($query);
			$query_handle->execute() ;
			$query_handle->bind_columns(undef, \$row_count);
			while($query_handle->fetch()) {	
				$row_count=$row_count;
			}
			my $rv = $dbh->disconnect;
			
			if($row_count==0){
				if($tack>3){
					$sleepTime=$sleepTime+10;				
				}
				print "*Trasnfer false. Restranfer after $sleepTime seconds\n";
				sleep($sleepTime);
				$callFunction="cd $rootFD && perl mainF.pl dim_no_dt_expire $from $to $table $transfer_by";
				system($callFunction);				
				
			}else{
				#print "*Stransfer fact table: $factTableName $row_count Ok\n";
			}		
		}
	}	
}
#############################################################################
###############  Get Connection Code ########################################
#############################################################################
sub getConnection{
	my $host=shift;
	my @values = split(':', $host);
	my $host_name='';
	my $port='5432';
	my $database=$default_database;
	my $userName=$defaul_userName;
	my $pass=$defaul_pass;	
	my $conn='';	
	
	# Process input param
	if(@values==1){
		$host_name=$host;
	}elsif(@values==2){
		$host_name=$values[0];
		$database=$values[1];
	}elsif(@values==3){
		$host_name=$values[0];
		$database=$values[1];
		$port=$values[2];
	}
	
	if($host_name eq 'dw2' && $port == '5433'){
		$userName='Mlogin';
		$pass='07130089';
	}
         
	
	if($host_name eq 'dataMart'){
		$conn=getConnectionWIP();
	}elsif($host_name eq 'pentaho.ecepvn.org'){
		$conn=DBI->connect("dbi:PgPP:dbname=$database;host=$host_name;$port", $userName, $pass,{RaiseError => 1}) or die "Unable to connect: penatho.ecepvn.org $database $port \n $DBI::errstr\n";
	}else{
		$conn=DBIx::AutoReconnect-> connect(
           "dbi:PgPP:dbname=$database;host=$host_name;$port",
           $userName,
           $pass,
           {
                PrintError => 0,
                ReconnectTimeout => 60,
                ReconnectFailure => sub { warn "oops $host_name $port $database!" },
				ReconnectMaxTries => 100
           },
		);
	}
	return $conn;
}

sub getConnectionDw1{
	my $conn=null;
	#$conn=DBI->connect("dbi:PgPP:dbname=$dbname;host=$host;$port", $usename, $pwd,{RaiseError => 1}) or die "Unable to connect: $DBI::errstr\n";
	$conn=DBIx::AutoReconnect-> connect(
           "dbi:PgPP:dbname=warehouse;host=dw1;5432",
           "phap",
           "07130089",
           {
                PrintError => 0,
                ReconnectTimeout => 60,
                ReconnectFailure => sub { warn "oops dw1 !" },
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


sub getInfobrightConnection{
	my $host=shift;
	my $conn=null;
	##$conn=DBI->connect("dbi:mysql:dbname=warehouse;host=dw2;5029", "pentaho", "ECEP-2009",{RaiseError => 1}) or die "Unable to connect: $DBI::errstr\n";
	$conn=DBIx::AutoReconnect-> connect(
           "dbi:mysql:dbname=warehouse;host=$host;5029",
           "pentaho",
           "ECEP-2009",
           {
                PrintError => 0,
                ReconnectTimeout => 60,
                ReconnectFailure => sub { warn "oops $host getInfobrightConnection !" },
				ReconnectMaxTries => 100
           },
     );
	return $conn;	
}

#############################################################################
###############  registration Transfer Process ##############################
#############################################################################

sub registrationTransfer{
	my $host=shift;
	my $table_name=shift;
	my $where=shift;
	my $to_host=shift;
	my $dbh = getConnection($transformer_host);
	my $query="INSERT INTO control.transfer_process_log(from_host, table_name, conditions,to_host,transfer_type,transfer_by) 
	VALUES (?, ?, ? , ?, ?,?) returning process_id";
	my $query_handle = $dbh->prepare($query);	
	if($transfer_by eq ''){$transfer_by='human'};
	print "*Transfer by: $transfer_by\n";
	$query_handle->execute($host,$table_name,$where,$to_host,$export_type,$transfer_by);
	my $value_rec = $query_handle->fetchrow_hashref();
	$process_id=$$value_rec{'process_id'};
	#print "process_id= ".$process_id."\n";
	my $rv = $dbh->disconnect;
}

sub updateStopProcess{
	my $export_count=shift;
	my $import_count=shift;
	my $process_id=shift;
	my $dbh = getConnection($transformer_host);
	my $query="UPDATE control.transfer_process_log SET export_count= ?,end_time= now()::timestamp,import_count=?,is_complete=true WHERE process_id=?";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($export_count,$import_count,$process_id);
	my $rv = $dbh->disconnect;
}

sub updateProcessStatus{
	my $status=shift;
	my $process_id=shift;
	my $dbh = getConnection($transformer_host);
	my $query="UPDATE control.transfer_process_log SET end_time= now()::timestamp,status=? WHERE process_id=?";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($status,$process_id);
	my $rv = $dbh->disconnect;
}

sub runPGFuntion{
	my $name=shift;
	$callFunction = "cd $binfd;java -jar dw3_runparam.jar -1000 $name &";
	system($callFunction);
}

sub runPGFuntion2{
	my $name=shift;
	$callFunction = "cd $binfd;java -jar dw3_runparam.jar -2000 \"$name\" &";
	system($callFunction);
}

#############################################################################
###############  Export code ################################################
#############################################################################
sub export_table{
	my $host=shift;
	my $to_host=shift;
	my $table_name=shift;
	my $where=shift;
	my $file_name=shift;
	my $dbh = getConnection($host);
	my $input_host=$host;
	my $input_to_host=$to_host;
	my @values = split(':', $host);
	$host=$values[0];
	my @values = split(':', $to_host);
	$to_host=$values[0];
	print "\n**************************************************\n ";
	note("Transfer $table_name FROM $input_host To $input_to_host");
	print "**************************************************\n";
	registrationTransfer($input_host,$table_name,$where,$input_to_host);
	print "*Start process with ID: $process_id\n";	
	
	if($dbh ne ''){
		my $query='';
		my $query_export_count='';
		my $export_file_name=$file_name."_".$time_tmp.".csv";
		if($where eq ''){
			$query="COPY (SELECT * FROM $table_name) TO '$path_export/$export_file_name' WITH DELIMITER '|'";
			$query_export_count="SELECT COUNT(1) as count FROM $table_name ";
		}else{
			$query="COPY (SELECT * FROM $table_name WHERE $where) TO '$path_export/$export_file_name' WITH DELIMITER '|'";
			$query_export_count="SELECT COUNT(1) as count FROM $table_name WHERE $where";
		}
		print "*Exporting data to $export_file_name ...\n";
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute() or warn 'xxxx';
		$query_handle->finish();
		#get export count
		if($dontCountRows==0){
			print "*Verify export count...\n";
			my $query_handle = $dbh->prepare($query_export_count);
			$query_handle->execute() or warn 'xxxx';
			$query_handle->bind_columns(undef, \$count);
			while($query_handle->fetch()) {	
				$export_count=$count;
			}	
			print "*Exported: $export_count\n";
		}else{
			print "*Verify export count off...\n";
		}

		#disconnect to server
		my $rv = $dbh->disconnect;
		print "*Copy export file to transformer.\n";
		#copy export file to local dw0
		my $comand="scp $host:$path_export/$export_file_name $path_import";
		system($comand);
		#Remove file transfer on source
		print "*Remove the transfer file on $host...\n";
		my $comand="ssh $host 'rm -r $path_export/$export_file_name'";
		system($comand);
		#print "*Export file from $host is located at $path_export/$export_file_name\n";
	}else{
	
	}
}
#############################################################################
###############  Import code ################################################
#############################################################################
sub import_table{
	my $host=shift;
	my $connectionHost=$host;
	my $table_name=shift;
	my $where=shift;
	my $file_name=shift;
	
	my @values = split(':', $host);
	$host=$values[0];
	#Copy export file to remote host
	my $export_file_name=$file_name."_".$time_tmp.".csv";
	print "*Begin Importing process...\n*Copy export file to $host\n";
	my $comand="scp $path_import/$export_file_name $host:$path_import/";
	#print $comand."\n";
	runSshComand($comand);
	#Remove file transfer on transformer **********************************
	if($host eq $transformer_host){
	
	}else{
		print "*Remove the transfer file on transformer $transformer_host...\n";
		my $comand="rm -r $path_import/$export_file_name";
		runSshComand($comand);		
	}
	#get connecting to host	
	my $dbh = '';
	if($export_type eq "Infobright"){
		$dbh = getInfobrightConnection($connectionHost);
	}else{
		$dbh = getConnection($connectionHost);
	}	
	if($dbh ne ''){
		my $query='';
		my $query_import_count='';		
		if($where eq ''){
			$query="TRUNCATE TABLE $table_name";
			$query_import_count="SELECT COUNT(1) as count FROM $table_name";
		}else{
			$query="DELETE FROM $table_name WHERE $where";
			$query_import_count="SELECT COUNT(1) as count FROM $table_name WHERE $where";
		}

		#Del old data before import *****************************
		print "*Delete old data on $host\n";
			if($export_type eq "Infobright"){
				##$query="SET SQL_LOG_BIN = 0;DELETE FROM $table_name WHERE $where;";	
					my $query_handle = $dbh->prepare("SET SQL_LOG_BIN = 0");
					$query_handle->execute() or warn 'xxxx';
			}
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute() or warn 'xxxx';
		my $rv = $dbh->disconnect;
		#end delete old data
		
		#import file to database**************************************
			if($export_type eq "Infobright"){
				$dbh = getInfobrightConnection($connectionHost);
			}else{
				$dbh = getConnection($connectionHost);
			}	
		my $import_file_name=$file_name."_".$time_tmp.".csv";
		if($export_type eq 'Normal'){			
			#import data			
			print "*Importing $import_file_name ...! $export_type mode\n";
			$query="COPY $table_name FROM '$path_import/$import_file_name' WITH DELIMITER '|' ";
			my $query_handle = $dbh->prepare($query);
			$query_handle->execute() or warn 'xxxx';		
		}elsif($export_type eq 'Partition'){
			#import data to tmp table		
			
			my $tmp_table_name="tranformer_table_tmp"."_$time_tmp";
			$tmp_table_name=~ s/\./_/g;			
			print "*Importing $import_file_name ...! $export_type mode\n";
			#create tmp table
			$query="CREATE TABLE $tmp_table_name (LIKE $table_name) ; 
			COPY $tmp_table_name FROM '$path_import/$import_file_name' WITH DELIMITER '|' ;";
			my $query_handle = $dbh->prepare($query);
			$query_handle->execute() ;
			#Copy data from tmp table to main table
			$query="INSERT INTO $table_name SELECT * FROM $tmp_table_name;";
			my $query_handle = $dbh->prepare($query);
			$query_handle->execute() ;
			#DROP tmp table
			$query="DROP TABLE $tmp_table_name;";
			my $query_handle = $dbh->prepare($query);
			$query_handle->execute() ;
		}elsif($export_type eq 'Infobright'){
			print "*Importing $import_file_name ...! $export_type mode\n";
			$query="LOAD DATA INFILE '$path_import/$import_file_name' INTO TABLE $table_name FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n';";
			##print $query."\n";
			my $query_handle = $dbh->prepare($query);
			$query_handle->execute() ;
		}
		my $rv = $dbh->disconnect;
		# end import file to database
		
		#Verify import count**************************************
			if($export_type eq "Infobright"){
				$dbh = getInfobrightConnection($connectionHost);
			}else{
				$dbh = getConnection($connectionHost);
			}	
		if($dontCountRows==0){
			print "*Verify import count...\n";
			#get import count
			my $query_handle = $dbh->prepare($query_import_count);
			$query_handle->execute() or warn 'xxxx';
			$query_handle->bind_columns(undef, \$count);
			while($query_handle->fetch()) {	
				$import_count=$count;
			}
			print "*Imported: $import_count\n*Finished!\n";		
		}else{
			print "*Verify import count off...\n";
		}
		my $rv = $dbh->disconnect;
		#End verify import count
		
		#Remove file transfer on target ***************************************
		print "*Remove the transfer file on $host...\n";
		my $comand="ssh $host 'rm -r $path_import/$import_file_name'";
		runSshComand($comand);
		updateStopProcess($export_count,$import_count,$process_id);
		note("Transfer completed!");		
	}else{
	
	}	
}

sub runSshComand{
	my $comand=shift;
	eval { 				
		run($comand);		
	};	
	if ($@) {
		note("loop ssh to server. Re connect after 5s..........");
		sleep(5);
		runSshComand($comand);
	}
}


sub note{
	my $text=shift;
	my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
	$month++;
	$yr19+=1900;
	print "# $day-$month-$yr19 $hour:$min:$sec : $text\n";
}


return 1;