use DBI;
use Date::Pcalc qw(:all);
use POSIX qw(strftime);
use DBIx::AutoReconnect;

$rootFD='/home/file_xfer/outgoing/dim_to_s3';
$binfd="/opt/temp/autoscripts/bin";
$path_export="/home/postgres/transformer_export_files";
$path_import="/home/postgres/transformer_import_files";
$transformer_host='dw10';
$host_dim='dw3';
$today_date='';
my @configRow1=();
my @configRow2=();
my @configRow3=();

main();

sub main{
	getDate();
	loadDim();
	#dim1
	checkDim(@configRow1);
	exportDim(@configRow1);
	print "Upload Dim 1 to S3\n";
	uploadToS3();
	#dim2
	checkDim(@configRow2);
	exportDim(@configRow2);
	print "Upload Dim 2 to S3\n";
	uploadToS3();
	#dim3
	checkDim(@configRow3);
	exportDim(@configRow3);
	print "Upload Dim 3 to S3\n";
	uploadToS3();
}

#############################################################################
###############  Get Connection Code ########################################
#############################################################################
sub getConnection{
	my $host=shift;
	my @values = split(':', $host);
	my $host_name='';
	my $port='5432';
	my $database='warehouse';
	my $userName='import_export_script';
	my $pass='verve-2013';	
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
	
	if($host_name eq 'dw0'){
		$userName='import_export_script';
		$pass='verve-2013';
	}
	if($host_name eq 'dw2' && $port == '5433'){
		$userName='import_export_script';
		$pass='verve-2013';
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


#############################################################################
###############  Check DIM ################################################
#############################################################################
sub getDate{
	my $dbh = getConnection($host_dim);
	my $query="SELECT MAX(current_up_to)::date as date FROM control.data_current_up_to_date";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	$query_handle->bind_columns(undef,\$date);		
	
	# LOOP THROUGH RESULTS
	while($query_handle->fetch()) {
	   $today_date=$date;
	}
	print "Transfer Dim of date $today_date\n";
	my $rv = $dbh->disconnect;
}
sub checkDim{
	my @arrayDim=@_;
	my $isCompleted=0;
	my $arrayDimToString='';
	my $i=0;
	foreach $rowConfig(@arrayDim){	
		my @info = split(/\|/, $rowConfig);
		my $dim_name= @info[0];
		$dim_name=~ s/refer\.//g;
		my $path= @info[1];
		if($i>0){$arrayDimToString=$arrayDimToString.',';}
		$arrayDimToString=$arrayDimToString."'".$dim_name."'";
		$i++;
	}
	print "Checking dim: ".$arrayDimToString."\n";
	while($isCompleted==0){
		my $dbh = getConnection($host_dim);
		my $query="SELECT MIN(current_up_to) as min_current_up_to, COUNT ( * ) as count_dim,(CASE WHEN MIN(current_up_to)<now()::date THEN 0 ELSE 1 END) as completed,now()::date as todaydate FROM control.data_current_up_to_date WHERE table_name IN($arrayDimToString)";
		print $query."\n";
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute();
		$query_handle->bind_columns(undef, \$min_current_up_to,\$count_dim,\$completed,\$todaydate);		
		
		# LOOP THROUGH RESULTS
		while($query_handle->fetch()) {
		   $isCompleted=$completed;
		   ##$today_date=$todaydate;
		}
		my $rv = $dbh->disconnect;
		if($isCompleted==0){			
			print "**Checking Dim!\n";
			sleep(60);
		}else{
			print "**Dim loaded completed!\n";
			sleep(2);
		}		
	}	
}
#############################################################################
###############  Load DIM From Config File ##################################
#############################################################################
sub loadDim{
	#Load dim 1
	my $path="listDim1.txt";
	#load daily agg table from file
	open (CHECKBOOK, "< $path") || die "couldn't open the file!";

	while ($record = <CHECKBOOK>) {
	  $record=~s/[\x0A\x0D]//g;
	  if(index($record,'#')>=0){	  
	  }else{
		  push(@configRow1,$record);
	  }
	}
	close(CHECKBOOK);
	#Load dim 2
	my $path="listDim2.txt";
	#load daily agg table from file
	open (CHECKBOOK, "< $path") || die "couldn't open the file!";

	while ($record = <CHECKBOOK>) {
	  $record=~s/[\x0A\x0D]//g;
	  if(index($record,'#')>=0){	  
	  }else{
		  push(@configRow2,$record);
	  }
	}
	close(CHECKBOOK);
	#Load dim 3
	my $path="listDim3.txt";
	#load daily agg table from file
	open (CHECKBOOK, "< $path") || die "couldn't open the file!";

	while ($record = <CHECKBOOK>) {
	  $record=~s/[\x0A\x0D]//g;
	  if(index($record,'#')>=0){	  
	  }else{
		  push(@configRow3,$record);
	  }
	}
	close(CHECKBOOK);
}
#############################################################################
###############  Export Dim to Transformer ##################################
#############################################################################
sub exportDim{
	my @arrayDim=@_;
	my $i=0;
	foreach $rowConfig(@arrayDim){
		$i++;
		my @info = split(/\|/, $rowConfig);
		my $dim_name= @info[0];
		my $path= @info[1];
		print "$i. $dim_name \t $path\n";
		export_table($host_dim,$transformer_host,$dim_name,'',$dim_name,$path);
	}
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
	my $path=shift;
	my $dbh = getConnection($host);
	
	my @values = split(':', $host);
	$host=$values[0];
	my @values = split(':', $to_host);
	$to_host=$values[0];
	print "\n**************************************************\n Transfer $table_name FROM $host To $to_host \n**************************************************\n";
	
	if($dbh ne ''){
		my $query='';
		my $query_export_count='';
		
		##my $export_file_name=$file_name.".csv";
		
		#------------------------------
		# Get current update value from 
		my @temp_dim_table_name=split('\.', $table_name);		
		my $current_up_to_date='';
		$query="SELECT  to_char(current_up_to, 'YYYY-MM-DD_HH24_MI_SS') FROM control.data_current_up_to_date WHERE table_name='$temp_dim_table_name[1]'";
		print "$query\n";
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute() ;
		$query_handle->bind_columns(undef, \$current_up_to_date);
		$query_handle->fetch();
		
		if($current_up_to_date eq ''){
			$current_up_to_date='9999-12-31_00_00_00';
		};
		print "Current_up_to_date: $current_up_to_date\n";
		#-----------------------------
		my $export_file_name=$file_name.".".$today_date.".$current_up_to_date.csv";
		$export_file_name=~s/\-/\_/g;
		$export_file_name=~s/\ /\_/g;
		
		if($where eq ''){
			$query="COPY (SELECT * FROM $table_name) TO '$path_export/$export_file_name' WITH DELIMITER '|'";
			$query_export_count="SELECT COUNT(*) as count FROM $table_name ";
		}else{
			$query="COPY (SELECT * FROM $table_name WHERE $where) TO '$path_export/$export_file_name' WITH DELIMITER '|'";
			$query_export_count="SELECT COUNT(*) as count FROM $table_name WHERE $where";
		}
		print "*Exporting data to $export_file_name ...\n";
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute() or warn 'xxxx';
		$query_handle->finish();
		#get export count
		##print "*Verify export count...\n";
		##my $query_handle = $dbh->prepare($query_export_count);
		##$query_handle->execute() or warn 'xxxx';
		##$query_handle->bind_columns(undef, \$count);
		##while($query_handle->fetch()) {	
		##	$export_count=$count;
		##}
		#disconnect to server
		my $rv = $dbh->disconnect;
		##print "*Exported: $export_count\n*Copy export file to transformer.\n";
		#copy export file to local dw0
		my $comand="scp $host:$path_export/$export_file_name $rootFD/incoming/dim/$path";
		system($comand);
		my $comand_replace_special_character="/usr/bin/perl -p -i -e 's/([\x80-\xFF])//g' $rootFD/incoming/dim/$path/$export_file_name";
		system($comand_replace_special_character);
		#Remove file transfer on source
		print "*Remove the transfer file on $host...\n";
		my $comand="ssh $host 'rm -r $path_export/$export_file_name'";
		system($comand);
		#print "*Export file from $host is located at $path_export/$export_file_name\n";
	}else{
	
	}
}
#############################################################################
###############  Upload to S3 ###############################################
#############################################################################
sub uploadToS3{
	my $comand="java -jar S3Uploader.jar verve-dw incoming";
	system($comand);
	my $command = 'find incoming/ -name *.csv -exec rm {} \;';
	system($command);
}

