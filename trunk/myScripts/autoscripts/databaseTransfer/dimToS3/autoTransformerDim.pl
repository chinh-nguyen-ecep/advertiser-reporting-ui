use DBI;
use Date::Pcalc qw(:all);
use POSIX qw(strftime);
use DBIx::AutoReconnect;

$rootFD='/opt/temp/autoscripts/transformer/dimToS3';
$binfd="/opt/temp/autoscripts/bin";
$path_export="/home/postgres/transformer_export_files";
$path_import="/home/postgres/transformer_import_files";
$transformer_host='dw10';
$host_dim='dw3';
$today_date='';
my @configRow=();

main();

sub main{
	getDate();
	checkDim();
	loadDim();
	exportDim();
	print "Upload Dim to S3\n";
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
	my $userName='sample_admin';
	my $pass='sample_admin';	
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
		$userName='slony';
		$pass='slony';
	}
	if($host_name eq 'dw2' && $port == '5433'){
		$userName='Mlogin';
		$pass='07130089';
	}
         
	
	if($host_name eq 'dataMart'){
		$conn=getConnectionWIP();
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
	my $isCompleted=0;
	while($isCompleted==0){
		my $dbh = getConnection($host_dim);
		my $query="SELECT MIN(current_up_to) as min_current_up_to, COUNT ( * ) as count_dim,(CASE WHEN MIN(current_up_to)<now()::date THEN 0 ELSE 1 END) as completed,now()::date as todaydate
				FROM control.data_current_up_to_date WHERE table_name IN(
				'ad_network_dim'
				,'adm_advertiser_dim'
				,'adm_channel_dim'
				,'adm_creative_dim'
				,'adm_dim_adsizes'
				,'adm_dim_advertisers'
				,'adm_dim_creatives'
				,'adm_dim_flights'
				,'adm_dim_orders'
				,'adm_dim_organizations'
				,'adm_dim_platforms'
				,'adm_dim_portals'
				,'adm_dim_properties'
				,'adm_dim_propertygroups'
				,'adm_dim_publishers'
				,'adm_flight_dim'
				,'adm_network_dim'
				,'adm_order_dim'
				,'adm_organization_dim'
				,'adm_placement_dim'
				,'adm_portal_dim'
				,'adm_publisher_dim'
				,'adm_website_dim'
				,'content_category_dim'
				,'dc_ad_dim'
				,'dc_order_dim'
				,'dc_site_dim'
				,'dfp_dim_ad_units'
				,'dfp_dim_creatives'
				,'dfp_dim_line_items'
				,'dfp_dim_orders'
				,'dfp_dim_placements'
				,'partner_dim'
				,'partner_module_dim'
				,'point_of_interest_dim'
				,'portal_dim'
				,'revenue_share_dim'
				,'store_location_dim'
				,'event_dim'
				)";
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
	my $path="listDim.txt";
	#load daily agg table from file
	open (CHECKBOOK, "< $path") || die "couldn't open the file!";

	while ($record = <CHECKBOOK>) {
	  $record=~s/[\x0A\x0D]//g;
	  if(index($record,'#')>=0){	  
	  }else{
		  push(@configRow,$record);
	  }
	}
	close(CHECKBOOK);
}
#############################################################################
###############  Export Dim to Transformer ##################################
#############################################################################
sub exportDim{
	my $i=0;
	foreach $rowConfig(@configRow){
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
		my $export_file_name=$file_name.".".$today_date.".csv";
		##my $export_file_name=$file_name.".csv";
		$export_file_name=~s/\-/\_/g;
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
}
