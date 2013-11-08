use DBI;
use Date::Pcalc qw(:all);
use DBIx::AutoReconnect;
$binfd="/home/file_xfer/bin/transferAggregateFromAnalyticsdbToDw";
$binfdTransferScript="/home/file_xfer/bin/databaseTransferFlowerMode";
$df_host="localhost";
$df_dbname="analyticsdb";
$df_usename="autoscript";
$df_pwd="ECEP-2009";
$df_port="5432";

$error_email_address="chinh.nguyen\@ecepvn.org";
$error_email_title="Transfer from Analyticsdb failed!";

$today_date='';
$today_date_sk='';
$report_date='';
$report_date_sk=0;
$report_date_rollback_7='';
$report_date_rollback_7_sk=0;

$current_date='';
@tables=();
@transfered=();

$host=$df_host;
$master_data_source='dw10:analyticsdb';

$table_list_file_name='listTables.txt';
$transfered_file_name='transfered.txt';
$transfered_failed_file_name='transferFailed.txt';
require "$binfd/utils/ConnectionDB.pl";
require "$binfd/utils/date_utils.pl";
require "$binfd/utils/sql_utils.pl";
require "$binfd/utils/log_utils.pl";

$init=@ARGV[0];
	loadCurrentDate();
	if($init eq 'init'){
		note("Backup transfered log!");
		my $backupFile_name="$current_date.$transfered_file_name";		
		$cmd="cp $transfered_file_name logs/$backupFile_name ; echo '' > $transfered_file_name";
		print "cmd: $cmd \n";
		system($cmd);
		note("Backup transfered Failed log!");
		my $backupFile_name="$current_date.$transfered_failed_file_name";		
		$cmd="cp $transfered_failed_file_name logs/$backupFile_name ; echo '' > $transfered_failed_file_name";
		print "cmd: $cmd \n";
		system($cmd);
		
		note("Backup process log!");
		$cmd="cp process.log logs/process.$current_date.log ; echo '' > process.log";
		print "cmd: $cmd \n";
		system($cmd);
		reloadListTableTransfered();
	}else{
		reloadListTableTransfered();
	}

while(1){
	init();
	note("Current date: $current_date");
	if($current_date ne $today_date){
		note("Backup transfered log!");
		my $backupFile_name="$current_date.$transfered_file_name";		
		$cmd="cp $transfered_file_name logs/$backupFile_name ; echo '' > $transfered_file_name";
		print "cmd: $cmd \n";
		system($cmd);
		
		note("Backup transfered Failed log!");
		my $backupFile_name="$current_date.$transfered_failed_file_name";		
		$cmd="cp $transfered_failed_file_name logs/$backupFile_name ; echo '' > $transfered_failed_file_name";
		print "cmd: $cmd \n";
		system($cmd);	
		
		note("Backup process log!");
		$cmd="cp process.log logs/process.$current_date.log ; echo '' > process.log";
		print "cmd: $cmd \n";
		system($cmd);	
		
		reloadListTableTransfered();
		$current_date=$today_date;
		
		note("Set current date to file!");
		$cmd=`echo '$today_date' > current_date.txt`;
	}	
	main();
}


sub init{
	note("*Init the autoscript...");
	note("Aggregate process run on: $host");
	getReportDate();
}

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
	print "Today date: $today_date \n";
	print "Today date sk: $today_date_sk \n";
	print "Report date: $report_date \n";
	print "Report date sk: $report_date_sk \n";
	print "Report date roll back 7 day: $report_date_rollback_7 \n";
	print "Report date roll back 7 day sk: $report_date_rollback_7_sk \n";
}
sub reloadListTableTransfered{
	note("*Reload list table to transfer:");
	@tables=();
	@transfered=();
	#Load list tables
	my $path=$table_list_file_name;
	#load daily agg table from file
	open (CHECKBOOK, "< $path") || die "couldn't open the file!";
	while ($record = <CHECKBOOK>) {
	  $record=~s/[\x0A\x0D]//g;
	  if(index($record,'#')>=0 || $record eq ""){	  
	  }else{
		  push(@tables,$record);
		  print "- $record\n";
	  }
	}
	close(CHECKBOOK);
	#Load list tables
	my $path=$transfered_file_name;
	#load daily agg table from file
	open (CHECKBOOK, "< $path") || die "couldn't open the file!";
	while ($record = <CHECKBOOK>) {
	  $record=~s/[\x0A\x0D]//g;
	  if(index($record,'#')>=0 || $record eq ""){	  
	  }else{
		  my @tempArray=split('\|',$record);
		  my $table=$tempArray[0];
		  push(@transfered,$table);
		  print "- Transfered: $table\n";
	  }
	}
	close(CHECKBOOK);
}
sub main{
	printTime("Main process");	
	my @resetArray=();
	foreach $table(@tables){
		my $file_status='';
		my $file_name='';
		my $query="SELECT file_name,file_status FROM control.data_file WHERE file_name LIKE '%$table%$report_date%' AND dt_file_queued::date='$today_date'";
		my $dbh=getConnection($host);
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute();
		$query_handle->bind_columns(undef, \$file_name, \$file_status);		
		$query_handle->fetch();
		sqlDisconnect($dbh);
		my $isTransfered=checkIsTransfered($table);
		printTime("Table: $table ");		
		if($file_status eq 'SU' && $isTransfered==0){
			my $mode='daily';
			@arrayString=split('\.',$file_name);
			$mode=$arrayString[0];
			transfer($mode,$table);
			
		}elsif($file_status eq 'SU' && $isTransfered==1){			
			print "Transfered!\n";
		}elsif($file_status eq ''){
			print "Transfer to $df_host:$df_dbname is not yet!\n";
			push (@resetArray,$table);
		}else{
			push (@resetArray,$table);
		}			
	}
	@tables=();
	@tables=@resetArray;
	sleep(300);
}

sub transfer{
	my $mode=shift;
	my $table=shift;
	print "==================================\nTransfer table $table with mode $mode $report_date\n";
	my $transferMode='daily';
	my $cmd;
	my $countError;
	my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
	$month++;
	$yr19+=1900;
	my $date_time="$yr19-$month-$day $hour:$min:$sec";
	my @error=();
	if($mode eq 'date_range'){
		my @error=runCMD("cd $binfdTransferScript;perl transferNoTracking.pl date_range $master_data_source dw3,dw0,dw10,dw4,dw6 $table $report_date_rollback_7 $report_date");		
		if(@error==0){		
			$cmd=`echo '$table|$mode|$report_date_rollback_7|$report_date|$date_time'>>$transfered_file_name`;
			push (@transfered,$table);		
		}else{
			note("** Transfer Error: @error");
			$cmd=`echo '$table|$mode|$report_date_rollback_7|$report_date|$date_time'>>$transfered_failed_file_name`;
			sendMail($error_email_address,$error_email_title,"Dear All,<p/> The Transfering table <b>$table</b> - <b/>$mode</b> - <b/>$report_date</b> to Dw3 is failed!<p/>Auto send by autoscript.");
		}		
	}elsif($mode eq 'daily'){
		my @error=runCMD("cd $binfdTransferScript;perl transferNoTracking.pl daily $master_data_source dw3,dw0,dw10,dw4,dw6 $table $report_date");		
		if(@error==0){		
			$cmd=`echo '$table|$mode|$report_date|$date_time'>>$transfered_file_name`;
			push (@transfered,$table);			
		}else{
			note("** Transfer Error: @error");
			$cmd=`echo '$table|$mode|$report_date|$date_time'>>$transfered_failed_file_name`;
			sendMail($error_email_address,$error_email_title,"Dear All,<p/> The Transfering table <b>$table</b> - <b/>$mode</b> - <b/>$report_date</b> to Dw3 is failed!<p/>Auto send by autoscript.");
		}
	}	


}

sub checkIsTransfered{
	my $table=shift;
	my $result=0;
	foreach $_table(@transfered){
		if($table eq $_table){
			$result=1;
		}
	}
	return $result;
}

sub loadCurrentDate{
	note("*Loading current date");
	@array=`cat current_date.txt`;
	$current_date=$array[0];
	$current_date=~s/\n//g;
	print "Current date: $current_date\n";
}

sub runCMD{
	my $cmd=shift;
	$cmd="$cmd 2>$binfd/logs/runCmd.error";
	print $cmd."\n";
	system($cmd);
	my @error=`cat $binfd/logs/runCmd.error`;	
	return @error;
}

