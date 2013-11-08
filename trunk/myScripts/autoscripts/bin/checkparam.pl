use DBI;
use Date::Pcalc qw(:all);
use DBIx::AutoReconnect;
$repeat="y";
$host="dw1";
$dbname="warehouse";
$usename="song";
$pwd="secep-2010";
$port="5432";

$schema="staging";


if($ARGV[0] eq 'dw3'){
	$host='dw3';
	$schema="control";
}

print "$host - $schema - $ARGV[0] \n";

checkParam($ARGV[1],$ARGV[2]);


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
		$query="SELECT process_id,process_status  FROM $schema.process
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
			  FROM $schema.process_concurrent_trans
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
			printTime("No process runing");
			$finish=true;
		}
		#disconnect database	
		my $rv = $dbh->disconnect;
		printTime("Checked");
		#Check MAIN LOOP
		if($finish eq true){
			$repeat = "n";
			printTime("Param $process_id_config finished");
		}else{
			sleep(300);
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
<STDIN>
