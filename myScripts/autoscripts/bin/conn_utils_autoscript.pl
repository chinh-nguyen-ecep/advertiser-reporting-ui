use DBI;
use Date::Pcalc qw(:all);
use DBIx::AutoReconnect;
$host="dw3";
$dbname="warehouse";
$usename="autoscript";
$pwd="ECEP-2009";
$port="5432";

sub getConnection{
	my $host=shift;
	my @values = split(':', $host);
	my $host_name='';
	my $port='5432';
	my $database='warehouse';
	my $userName=$usename;
	my $pass=$pwd;	
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

sub getConnectionAutoScript{
	my $host=shift;
	my $conn='';
	if($host eq 'dw3'){
		$conn=getConnectionAutoScriptDw3();
	}elsif($host eq 'dw2'){
		$conn=getConnectionAutoScriptDw2();
	}elsif($host eq 'dw4'){
		$conn=getConnectionAutoScriptDw4();
	}elsif($host eq 'dw5'){
		$conn=getConnectionAutoScriptDw5();
	}elsif($host eq 'dw6'){
		$conn=getConnectionAutoScriptDw6();
	}elsif($host eq 'dw0'){
		$conn=getConnectionAutoScriptDw0();
	}elsif($host eq 'dw10'){
		$conn=getConnectionAutoScriptDw10();
	}
	return $conn;
}
sub getConnectionAutoScriptDw2{
	my $conn=null;
	#$conn=DBI->connect("dbi:PgPP:dbname=$dbname;host=$host;$port", $usename, $pwd,{RaiseError => 1}) or die "Unable to connect: $DBI::errstr\n";
	$conn=DBIx::AutoReconnect-> connect(
           "dbi:PgPP:dbname=warehouse;host=dw2;5432",
           $usename,
           $pwd,
           {
                PrintError => 0,
                ReconnectTimeout => 60,
                ReconnectFailure => sub { warn "oops dw2 !" },
				ReconnectMaxTries => 30
           },
     );
	return $conn;
}
sub getConnectionAutoScriptDw3{
	my $conn=null;
	#$conn=DBI->connect("dbi:PgPP:dbname=$dbname;host=$host;$port", $usename, $pwd,{RaiseError => 1}) or die "Unable to connect: $DBI::errstr\n";
	$conn=DBIx::AutoReconnect-> connect(
           "dbi:PgPP:dbname=warehouse;host=dw3;5432",
           $usename,
           $pwd,
           {
                PrintError => 0,
                ReconnectTimeout => 60,
                ReconnectFailure => sub { warn "oops dw3 !" },
				ReconnectMaxTries => 30
           },
     );
	return $conn;
}
sub getConnectionAutoScriptDw4{
	my $conn=null;
	#$conn=DBI->connect("dbi:PgPP:dbname=$dbname;host=$host;$port", $usename, $pwd,{RaiseError => 1}) or die "Unable to connect: $DBI::errstr\n";
	$conn=DBIx::AutoReconnect-> connect(
           "dbi:PgPP:dbname=warehouse;host=dw4;5432",
           $usename,
           $pwd,
           {
                PrintError => 0,
                ReconnectTimeout => 60,
                ReconnectFailure => sub { warn "oops dw4 !" },
				ReconnectMaxTries => 30
           },
     );
	return $conn;
}
sub getConnectionAutoScriptDw5{
	my $conn=null;
	#$conn=DBI->connect("dbi:PgPP:dbname=$dbname;host=$host;$port", $usename, $pwd,{RaiseError => 1}) or die "Unable to connect: $DBI::errstr\n";
	$conn=DBIx::AutoReconnect-> connect(
           "dbi:PgPP:dbname=warehouse;host=dw5;5432",
           $usename,
           $pwd,
           {
                PrintError => 0,
                ReconnectTimeout => 60,
                ReconnectFailure => sub { warn "oops dw5 !" },
				ReconnectMaxTries => 30
           },
     );
	return $conn;
}
sub getConnectionAutoScriptDw6{
	my $conn=null;
	#$conn=DBI->connect("dbi:PgPP:dbname=$dbname;host=$host;$port", $usename, $pwd,{RaiseError => 1}) or die "Unable to connect: $DBI::errstr\n";
	$conn=DBIx::AutoReconnect-> connect(
           "dbi:PgPP:dbname=warehouse;host=dw6;5432",
           $usename,
           $pwd,
           {
                PrintError => 0,
                ReconnectTimeout => 60,
                ReconnectFailure => sub { warn "oops dw6 !" },
				ReconnectMaxTries => 30
           },
     );
	return $conn;
}
sub getConnectionAutoScriptDw10{
	my $conn=null;
	#$conn=DBI->connect("dbi:PgPP:dbname=$dbname;host=$host;$port", $usename, $pwd,{RaiseError => 1}) or die "Unable to connect: $DBI::errstr\n";
	$conn=DBIx::AutoReconnect-> connect(
           "dbi:PgPP:dbname=warehouse;host=dw10;5432",
           $usename,
           $pwd,
           {
                PrintError => 0,
                ReconnectTimeout => 60,
                ReconnectFailure => sub { warn "oops dw10 !" },
				ReconnectMaxTries => 30
           },
     );
	return $conn;
}

sub getConnectionAutoScriptDw0{
	my $conn=null;
	#$conn=DBI->connect("dbi:PgPP:dbname=$dbname;host=$host;$port", $usename, $pwd,{RaiseError => 1}) or die "Unable to connect: $DBI::errstr\n";
	$conn=DBIx::AutoReconnect-> connect(
           "dbi:PgPP:dbname=$dbname;host=dw0;$port",
           $usename,
           $pwd,
           {
                PrintError => 0,
                ReconnectTimeout => 60,
                ReconnectFailure => sub { warn "oops dw0 !" },
				ReconnectMaxTries => 30
           },
     );
	return $conn;
}

return 1;
exit;