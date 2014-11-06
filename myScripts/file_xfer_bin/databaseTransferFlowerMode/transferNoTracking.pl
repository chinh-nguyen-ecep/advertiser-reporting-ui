use DBI;
use Date::Pcalc qw(:all);
use POSIX qw(strftime);
use DBIx::AutoReconnect;
use Digest::MD5;
$binfd="/home/file_xfer/bin/databaseTransferFlowerMode";
$export_dir_temp="/opt/temp";
$time_tmp = strftime( q/%Y%m%dT%H%M%S/, localtime ) . ( gettimeofday )[1] . q/00000/, 0, 20;

$df_host="localhost";
$df_dbname="warehouse";
$df_usename="import_export_script";
$df_pwd="verve-2013";
$df_port="5432";

$export_file_name='';
@trackingServer=();
### Input processing ############
if(@ARGV<4){
	print "Wrong transfer input!\n";
	print "Syntax comand: perl transfer.pl [mode] [from] [to] [table name] [transfer info]\n";
	print "[mode]: daily OR date_range OR monthly OR weekly\n";
	print "[from]: example: dw0 OR dw10 OR dw3 OR dw4 OR dw5 OR dw6\n";
	print "[to]:  example: dw0 OR dw10,dw3 (transfer to many server at same time)\n";
	print "[table name]:  example: adstraffic.daily_ad_serving_stats \n";
	print "[transfer info]:  example: 2013-07-01 OR 2013-07-01 2013-07-02 OR 2013-Jul OR 2013-W21\n";
	die;
}

$transferMode=@ARGV[0];
$transferFrom=@ARGV[1];
$transferTo=@ARGV[2];
$transferTable=@ARGV[3];

@values=split(':', $transferFrom);
$exportHostName=$values[0];
$database=$values[1];
if($database eq ''){
	$database=$df_dbname;
}


$report_date='';
$start_date='';
$end_date='';
$calendar_year_month='';
$year_week='';
$export_file_size=0;
$process_id_in_log=0;
if($transferMode eq 'daily'){
	$report_date=@ARGV[4];
	if($report_date == null || $report_date eq ''){
		die 'Can not get report date from input';
	}
}elsif($transferMode eq 'date_range'){
	$start_date=@ARGV[4];
	$end_date=@ARGV[5];
	if($start_date == null || $end_date == null || $end_date eq '' || $start_date eq ''){
		die 'Can not get date range from input';
	}
}elsif($transferMode eq 'monthly'){
	$calendar_year_month=@ARGV[4];
	if($calendar_year_month == null || $calendar_year_month eq ''){
		die 'Can not get month from input';
	}
}elsif($transferMode eq 'weekly'){
	$year_week=@ARGV[4];
	if($year_week == null || $year_week eq ''){
		die 'Can not get year week from input';
	}
}else{
	die 'Can not get transfer mode';
}
# Perl trim function to remove whitespace from the start and end of the string
sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}
sub runShellComand{
	my $query=shift;	
	$query=trim($query);
	my @cmd=`$query 2>$$.log`;
	my @error=`cat $$.log`;
	system("rm -rf $$.log");
	my %result=(
		'stout' => \@cmd,
		'erout' => \@error
	);
	return %result;
}
main();

### Utils #######################

sub getConnection{
	my $host=shift;
	my @values = split(':', $host);
	my $host_name='';
	my $port=$df_port;
	my $database=$df_dbname;
	my $userName=$df_usename;
	my $pass=$df_pwd;	
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

	return $conn;
}
sub sqlDisconnect{
	my $dbh=shift;
	my $rv = $dbh->disconnect;
}
sub sqlRunQuery{
	my $dbh=shift;
	my $query=shift;
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	return $query_handle;
}
sub printTime{
	my $text=shift;
	my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
	$month++;
	$yr19+=1900;
	print "$day-$month-$yr19 $hour:$min:$sec # $text\n";
}

sub note{
	my $text=shift;
	print $text."\n";
	sleep(1);
}

sub sendMail{
#$mailaddress="chinh.nguyen\@ecepvn.org,binh.nguyen\@ecepvn.org,song.nguyen\@ecepvn.org,tho.hoang\@ecepvn.org";
my $mailaddress=shift;
   $mailaddress="chinh.nguyen\@ecepvn.org,ops\@ecepvn.org";
my $title=shift;
my $content=shift;
my $callFunction = "cd $binfd/utils;java -jar mail.jar \"smtp.gmail.com\" 587 \"chinh.nguyen\@ecepvn.org\" \"verve-2013\" \"$mailaddress\" \"$title\" \"$content\" &";
system($callFunction);
}
sub md5sum{
  my $file = shift;
  my $digest = "";
  eval{
    open(FILE, $file) or die "Can't find file $file\n";
    my $ctx = Digest::MD5->new;
    $ctx->addfile(*FILE);
    $digest = $ctx->hexdigest;
    close(FILE);
  };
  if($@){
    print $@;
    return "";
  }
  return $digest;
}

sub registrationTransfer{
	my $host=$transferFrom;
	my $table_name=$transferTable;
	my $where="$transferMode|$report_date $start_date $end_date $calendar_year_month $year_week";
	my $to_host=$transferTo;
	my $dbh = getConnection('localhost');
	my $query="INSERT INTO control.transfer_process_log(from_host, table_name, conditions,to_host,transfer_type,transfer_by,status) 
	VALUES (?, ?, ? , ?, ?,?,'ER') returning process_id";
	my $query_handle = $dbh->prepare($query);	
	$query_handle->execute($host,$table_name,$where,$to_host,'Normal','Transfer in Flower Method');
	my $value_rec = $query_handle->fetchrow_hashref();
	$process_id_in_log=$$value_rec{'process_id'};
	#print "process_id= ".$process_id."\n";
	my $rv = $dbh->disconnect;
}
sub updateStopProcess{
	my $export_count=$export_file_size;
	my $import_count=0;
	my $process_id=$process_id_in_log;
	my $dbh = getConnection('localhost');
	my $query="UPDATE control.transfer_process_log SET export_count= ?,end_time= now()::timestamp,import_count=?,is_complete=true ,status='SU' WHERE process_id=?";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($export_count,$import_count,$process_id);
	my $rv = $dbh->disconnect;
}

sub updateProcessStatus{
	my $status=shift;
	my $process_id=$process_id_in_log;
	my $dbh = getConnection('localhost');
	my $query="UPDATE control.transfer_process_log SET end_time= now()::timestamp,status=? WHERE process_id=?";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($status,$process_id);
	my $rv = $dbh->disconnect;
}
### Main code ###########################################
sub main{
	registrationTransfer();
	printTime("Processing Transfer Aggregate Data ...");
	note("Transfer mode: $transferMode \nFrom: $transferFrom \nDatabase: $database\nTo: $transferTo\nTable: $transferTable\nDate: $report_date\nDate range: $start_date - $end_date\nMonth: $calendar_year_month\nWeek: $year_week\n-------------------------------");
	export();
	updateProcessStatus('TR');
	transferExportFileToCenter();
	transferExportFileToClient();
	##trackingImportProcess();
	updateStopProcess();
}
### Export code #########################################
sub export{	
	printTime("Data exporting...");
	$export_file_name="$transferMode.$transferTable.export_date.md5.$time_tmp.$exportHostName.$database.csv";
	my $export_file_name_final=$export_file_name;
	my $export_table_name=$transferTable;
	my $exportQuery="";
	if($transferMode eq 'daily'){
		$exportQuery="COPY (SELECT * FROM $export_table_name WHERE full_date='$report_date' AND is_active=true) TO '$export_dir_temp/$export_file_name' WITH DELIMITER '|'";
		$export_file_name_final=~ s/export_date/$report_date/g; 		
	}elsif($transferMode eq 'date_range'){
		$exportQuery="COPY (SELECT * FROM $export_table_name WHERE full_date BETWEEN '$start_date' AND '$end_date' AND is_active=true) TO '$export_dir_temp/$export_file_name' WITH DELIMITER '|'";
		$export_file_name_final=~ s/export_date/$start_date\.$end_date/g; 	
	}elsif($transferMode eq 'monthly'){
		$exportQuery="COPY (SELECT * FROM $export_table_name WHERE calendar_year_month='$calendar_year_month' AND is_active=true) TO '$export_dir_temp/$export_file_name' WITH DELIMITER '|'";
		$export_file_name_final=~ s/export_date/$calendar_year_month/g; 	
	}elsif($transferMode eq 'weekly'){
		$exportQuery="COPY (SELECT * FROM $export_table_name WHERE year_week='$year_week' AND is_active=true) TO '$export_dir_temp/$export_file_name' WITH DELIMITER '|'";
		$export_file_name_final=~ s/export_date/$year_week/g; 	
	}
	my $dbh = getConnection($transferFrom);
	sqlRunQuery($dbh,$exportQuery);
	sqlDisconnect($dbh);
		
		#Get md5 check sum
		my $md5value='';
		%resultCMD=runShellComand("ssh $exportHostName md5sum $export_dir_temp/$export_file_name");
		@cmd=@{$resultCMD{'stout'}};
		@error=@{$resultCMD{'erout'}};
		if(@error==0){
			@values=split('\ ',$cmd[0]);
			$md5value=$values[0];
			$export_file_name_final=~ s/md5/$md5value/g; #Set md5 value to file name
			
			##Change export file name to final
			%resultCMD=runShellComand("ssh $exportHostName mv $export_dir_temp/$export_file_name $export_dir_temp/$export_file_name_final");
			@cmd=@{$resultCMD{'stout'}};
			@error=@{$resultCMD{'erout'}};
			if(@error>0){				
				die @error;
			}else{
				note("\tExported file:\t$export_file_name");
				$export_file_name=$export_file_name_final;	
				#Zip export file
				note("\tZipping export file ...");
				%resultCMD=runShellComand("ssh $exportHostName 'cd $export_dir_temp && zip -r $export_file_name_final.zip $export_file_name_final'");
				@cmd=@{$resultCMD{'stout'}};
				@error=@{$resultCMD{'erout'}};	
				#Remove export file unzip
				%resultCMD=runShellComand("ssh $exportHostName 'rm -rf $export_dir_temp/$export_file_name'");
				@cmd=@{$resultCMD{'stout'}};
				@error=@{$resultCMD{'erout'}};	
				
				$export_file_name=$export_file_name_final.".zip";	
				%resultCMD=runShellComand("ssh $exportHostName du -k $export_dir_temp/$export_file_name");
				@cmd=@{$resultCMD{'stout'}};
				@error=@{$resultCMD{'erout'}};
				@values=split('\t',$cmd[0]);
				$file_size=$values[0];
				note("\tExport file:\t$export_file_name");
				note("\tExported file size:\t$file_size K");	
				$export_file_size=$file_size;
				if($export_file_size<5){
						sendMail("chinh.nguyen\@ecepvn.org","Export file is zero","Export host: $exportHostName<br/>File name: $export_file_name<br/>File size: $file_size<p/>perl main.pl daily dw10:analyticsdb dw10 $export_table_name $report_date missData<br/>perl main.pl daily dw10:analyticsdb dw3 $export_table_name $report_date missData");
				}
			}
		}else{
			printTime("Export failed!");
			die @error;
		}

}
### Transfer export file from source server to center ###########
sub transferExportFileToCenter{
	printTime("Transfer export file from $exportHostName to center!");	
	# Copy export file to center
	%resultCMD=runShellComand("scp $exportHostName:$export_dir_temp/$export_file_name $binfd/export_files");
	@cmd=@{$resultCMD{'stout'}};
	@error=@{$resultCMD{'erout'}};
	if(@error>0){
		note("Transfer export file from $exportHostName got error. Retransfer after 60' ");
		sleep(60);
		transferExportFileToCenter();
	}else{
		#Delete export file on source server
		%resultCMD=runShellComand("ssh $exportHostName rm -rf $export_dir_temp/$export_file_name");
		@cmd=@{$resultCMD{'stout'}};
		@error=@{$resultCMD{'erout'}};
		printTime("Transfer export file from $exportHostName to center completed!");
	}
}
## Transfer export file from center to client ####
sub transferExportFileToClient{
	printTime("Transfer export file to client....");	
	my @values=split(',',$transferTo);
	foreach my $server(@values){		
		my @values2=split('\:',$server);
		my $hostNameClient=$values2[0];
		my $importToDatabase=$values2[1];
		
		if($importToDatabase eq ''){
			$importToDatabase=$df_dbname;
		}		
		
		note("\tTransfer to client: $hostNameClient \n\tDatabase: $importToDatabase");
		#Check import module on client configured!
		#On import client must be config import module first. If no we can not use this script to transfer aggregate data.
		my $data_file_config_id=0;
		my $query="SELECT data_file_config_id FROM control.data_file_configuration WHERE data_file_config_name='Aggregate Data File' AND data_file_config_description='Aggregate Data File' ORDER BY data_file_config_id desc LIMIT 1";
		my $dbh = getConnection("$hostNameClient:$importToDatabase");
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute();
		$query_handle->bind_columns(undef, \$data_file_config_id);
		$query_handle->fetch();
		sqlDisconnect($dbh);		
		
		if($data_file_config_id==0){
			note("Can not transfer aggregate data to $server. Check import module config....");
			sendMail("chinh.nguyen\@ecepvn.org","Can not transfer aggregate data to $server","Export host: $exportHostName<br/>File name: $export_file_name<br/>File size: $file_size<p/>");
		}else{
			#load config file on client
			my $import_dir="";
			my $query="SELECT import_dir FROM control.data_file_configuration WHERE data_file_config_id=$data_file_config_id";
			my $dbh = getConnection("$hostNameClient:$importToDatabase");
			my $query_handle = $dbh->prepare($query);
			$query_handle->execute();
			$query_handle->bind_columns(undef, \$import_dir);
			$query_handle->fetch();
			sqlDisconnect($dbh);
			note("\tData file config id: $data_file_config_id \n\tImport to: $import_dir");
			push(@trackingServer,$server);
			transferExportFileToClientItem($hostNameClient,$importToDatabase,$import_dir,$data_file_config_id);
		}
		
	}
	#remove export on center
	%resultCMD=runShellComand("rm -rf $binfd/export_files/$export_file_name");
	@cmd=@{$resultCMD{'stout'}};
	@error=@{$resultCMD{'erout'}};		
}
sub transferExportFileToClientItem{
	my $clientServer=shift;
	my $database=shift;
	my $import_dir=shift;
	my $data_file_config_id=shift;
	%resultCMD=runShellComand("scp $binfd/export_files/$export_file_name $clientServer:$import_dir");
	@cmd=@{$resultCMD{'stout'}};
	@error=@{$resultCMD{'erout'}};	
	if(@error>0){
		printTime("Transfer file to $clientServer:$import_dir faile. Retransfer after 60' ");
		sleep(60);
		transferExportFileToClientItem($clientServer,$database,$import_dir,$data_file_config_id);
	}else{
		#Insert record to data file
			my $query="INSERT INTO control.data_file(file_name,server_name,file_timestamp,data_file_config_id,file_status,dt_file_queued)
VALUES ('$export_file_name','$exportHostName',now()::timestamp without time zone,$data_file_config_id,'ER',now()::timestamp without time zone);";
			my $dbh = getConnection("$clientServer:$database");
			my $query_handle = $dbh->prepare($query);
			$query_handle->execute();
			sqlDisconnect($dbh);		
	}
}
### Tracking code ##################
sub trackingImportProcess{
	my $completed=0;
	while($completed==0){
	printTime("Tracking....");
		$completed=1;
		foreach my $server(@trackingServer){
			my $file_status='';
			my $query="SELECT file_status FROM control.data_file WHERE file_name='$export_file_name'";
			my $dbh = getConnection($server);
			my $query_handle = $dbh->prepare($query);
			$query_handle->execute();
			$query_handle->bind_columns(undef, \$file_status);
			$query_handle->fetch();
			sqlDisconnect($dbh);
			print "\tServer: $server\t$file_status\n";
			if($file_status ne 'SU'){
				$completed=0;
			}
		}
		if($completed==0){
			sleep(60);
		}
	}
	printTime("All import process are completed\n------------------------------------------------");
}

