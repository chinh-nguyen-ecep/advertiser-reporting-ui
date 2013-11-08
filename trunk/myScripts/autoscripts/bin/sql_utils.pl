sub sqlRunPGFuntion{
	#input is a function ex: staging.fn_refresh_daily_process_status()
	my $name=shift;
	my $dbh=shift;
	my $query="SELECT $name";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	#$callFunction = "cd $binfd;java -jar dw3_runparam.jar -1000 $name";
	#system($callFunction);
}

sub sqlTest{
	my $dbh=shift;
	my $query="select relname from pg_stat_user_tables ORDER BY relname LIMIT 10 ;";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	$query_handle->bind_columns(undef, \$relname);		
		# LOOP THROUGH RESULTS
		while($query_handle->fetch()) {
		   print "Table: $relname\n";
		} 
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
return 1;
exit;