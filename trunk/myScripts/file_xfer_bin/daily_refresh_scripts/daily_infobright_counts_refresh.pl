use DBI;
use Date::Pcalc qw(:all);
use POSIX qw(strftime);
use DBIx::AutoReconnect;

$master_host="dw3";
$slaver="dw0";
$today_date; # report date 2012-07-04
$report_date='';
$report_date_sk='';
$binfd='/home/file_xfer/bin/daily_refresh_scripts';

check();


sub check{	
	getDateSk();
	my $dbh_master = getConnection($master_host);
	my $dbh_slaver = getConnection($slaver);
	my $query="SELECT MAX(dt_lastchange) FROM adsops.daily_infobright_counts WHERE is_active=true";
	
	my $dt_lastchange_master='';
	my $dt_lastchange_slaver='';
	
	# dt_lastchange from master
	my $query_handle = $dbh_master->prepare($query);	
	$query_handle->execute() ;
	$query_handle->bind_columns(undef, \$dt_lastchange_master);
	$query_handle->fetch();
	#dt_lastchange from slaver
	my $query_handle = $dbh_slaver->prepare($query);	
	$query_handle->execute() ;
	$query_handle->bind_columns(undef, \$dt_lastchange_slaver);
	$query_handle->fetch();
	#close connection
	my $rv = $dbh_master->disconnect;
	my $rv = $dbh_slaver->disconnect;
	
	if($dt_lastchange_master ne $dt_lastchange_slaver){	
		print "dt_lastchange_master: $dt_lastchange_master\ndt_lastchange_slaver: $dt_lastchange_slaver\n";
		updateFromMaster();
	}else{
		print "loop!\n";
	}	
	
	sleep(600);
	check();
}

sub updateFromMaster{
	my $cmd="cd /home/file_xfer/bin/databaseTransferFlowerMode/ && perl transfer.pl date_range dw3 dw0,dw6,dw10 adsops.daily_infobright_counts $report_date $today_date";
	my @error=runCMD($cmd);
	if(@error>0){
		updateFromMaster();
	}
}

sub getDateSk{
	my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
	$month++;
	$yr19+=1900;
	if($day<10){
		$day="0$day";
	}
	if($month<10){
		$month="0$month";
	}
	$today_date="$yr19-$month-$day";

	print "*Get report date_sk!\n";
	my $dbh = getConnection($master_host);
	my $query='SELECT date_sk-2 as report_date_sk_key,full_date-2 as full_date FROM refer.date_dim WHERE full_date=?';
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute($today_date) or die $DBI::errstr;
	$query_handle->bind_columns(undef, \$report_date_sk,\$report_date);
	$query_handle->fetch();	
	my $rv = $dbh->disconnect;
	print "**Report date_sk=$report_date_sk\n**Report date=$report_date\n";
}

sub getConnection{
	my $host=shift;
	my @values = split(':', $host);
	my $host_name='';
	my $port='5432';
	my $database="warehouse";
	my $userName="autoscript";
	my $pass="ECEP-2009";	
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
sub runCMD{
	my $cmd=shift;
	$cmd="$cmd >$binfd/lastTransferDailyInfobrightCounts.log 2>$binfd/$$.error";
	print $cmd."\n";
	system($cmd);
	my @error=`cat $binfd/$$.error`;	
	return @error;
}




