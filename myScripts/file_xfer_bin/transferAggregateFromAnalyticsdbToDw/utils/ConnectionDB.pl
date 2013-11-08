
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
	
	if($host_name eq 'dw2' && $port == '5433'){
		$userName='Mlogin';
		$pass='07130089';
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

return 1;
exit;