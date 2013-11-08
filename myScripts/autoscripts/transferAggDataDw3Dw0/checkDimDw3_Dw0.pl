require "../bin/dw3_utils.pl";
$from_host='dw3'; 
$destination_host='dw0';
my $dim_tables="dim_tables.txt";

my @dimTables=();


#load daily agg table from file
open (CHECKBOOK, "< $dim_tables") || die "couldn't open the file!";

while ($record = <CHECKBOOK>) {
  $record=~s/[\x0A\x0D]//g;
   if(index($record,'#')>=0){
  
  }else{
	  push(@dimTables,$record);
  }
  
}
close(CHECKBOOK);


my $mode='';
my $update=0;
my $transfer=0;
my $list_table_transfer='';
if(@ARGV==1){
	$mode=$ARGV[0];
}else{
	print "perl checkDimDw3_Dw0 check\nperl checkDimDw3_Dw0 refresh\n";
	exit;
}


	my $dbh_dw3=getConnection();	
	my $dbh_dw0=getConnectionDw0();
	my $query="";
	my $query_handle="";
	my $countOnDw3=0;
	my $countOnDw0=0;
	my $dt_lastchange_dw3='';
	my $dt_lastchange_dw0='';
	my $i=0;
	foreach $table(@dimTables){
		$i++;
		print "#Table $i: $table\t";
		$query="SELECT COUNT(*) as count FROM $table";
		#query on dw3
		$query_handle = $dbh_dw3->prepare($query);
		$query_handle->execute();
		$query_handle->bind_columns(undef, \$count);
		while($query_handle->fetch()) {	
			$countOnDw3=$count;
		}
		#query on dw0
		$query_handle = $dbh_dw0->prepare($query);
		$query_handle->execute();
		$query_handle->bind_columns(undef, \$count);
		while($query_handle->fetch()) {	
			$countOnDw0=$count;
		}
		print "Dw3: $countOnDw3\tDw0: $countOnDw0\n";
		if($countOnDw0!=$countOnDw3 && $mode eq 'refresh'){
			print "*Transfer dim data to dw0\n";
			my $callFunction ='su - file_xfer -c "cd /opt/temp/autoscripts/transformer/ && perl main.pl dim_no_dt_expire '."$from_host $destination_host $table".' checkDimDw3_Dw0"';
			system($callFunction);
			$transfer++;
			$list_table_transfer=$list_table_transfer.$table."\n";
		}
	}
	#disconnect database
	my $rv = $dbh_dw3->disconnect;
	$rv = $dbh_dw0->disconnect;


print "Total table transfered: $transfer\n$list_table_transfer\nTotal table updated: $update\n";
