use DBI;
use Date::Pcalc qw(:all);
use DBIx::AutoReconnect;

$binfd="/opt/temp/autoscripts/bin";
$sentmail="";
$log="";

sub getConnection{
	my $host=shift;
	my $conn='';
	if($host eq 'dw3'){
		$conn=getConnectionDw3();
	}elsif($host eq 'dw2'){
		$conn=getConnectionDw2();
	}elsif($host eq 'dw0'){
		$conn=getConnectionDw0();
	}elsif($host eq 'dw4'){
		$conn=getConnectionDw4();
	}elsif($host eq 'dw5'){
		$conn=getConnectionDw5();
	}
	return $conn;
}

sub getConnectionDw5{
	my $conn=null;
	#$conn=DBI->connect("dbi:PgPP:dbname=$dbname;host=$host;$port", $usename, $pwd,{RaiseError => 1}) or die "Unable to connect: $DBI::errstr\n";
	$conn=DBIx::AutoReconnect-> connect(
           "dbi:PgPP:dbname=warehouse;host=dw5;5432",
           "sample_admin",
           "sample_admin",
           {
                PrintError => 0,
                ReconnectTimeout => 60,
                ReconnectFailure => sub { warn "oops dw5 !" },
				ReconnectMaxTries => 100
           },
     );
	return $conn;
}

sub getConnectionDw4{
	my $conn=null;
	#$conn=DBI->connect("dbi:PgPP:dbname=$dbname;host=$host;$port", $usename, $pwd,{RaiseError => 1}) or die "Unable to connect: $DBI::errstr\n";
	$conn=DBIx::AutoReconnect-> connect(
           "dbi:PgPP:dbname=warehouse;host=dw4;5432",
           "sample_admin",
           "sample_admin",
           {
                PrintError => 0,
                ReconnectTimeout => 60,
                ReconnectFailure => sub { warn "oops dw4 !" },
				ReconnectMaxTries => 100
           },
     );
	return $conn;
}
sub getConnectionDw3{
	my $conn=null;
	#$conn=DBI->connect("dbi:PgPP:dbname=$dbname;host=$host;$port", $usename, $pwd,{RaiseError => 1}) or die "Unable to connect: $DBI::errstr\n";
	$conn=DBIx::AutoReconnect-> connect(
           "dbi:PgPP:dbname=warehouse;host=dw3;5432",
           "sample_admin",
           "sample_admin",
           {
                PrintError => 0,
                ReconnectTimeout => 60,
                ReconnectFailure => sub { warn "oops dw3 !" },
				ReconnectMaxTries => 100
           },
     );
	return $conn;
}
sub getConnectionDw2{
	my $conn=null;
	#$conn=DBI->connect("dbi:PgPP:dbname=$dbname;host=$host;$port", $usename, $pwd,{RaiseError => 1}) or die "Unable to connect: $DBI::errstr\n";
	$conn=DBIx::AutoReconnect-> connect(
           "dbi:PgPP:dbname=warehouse;host=dw2;5432",
           "sample_admin",
           "sample_admin",
           {
                PrintError => 0,
                ReconnectTimeout => 60,
                ReconnectFailure => sub { warn "oops dw2 !" },
				ReconnectMaxTries => 100
           },
     );
	return $conn;
}
sub getConnectionDw0{
	my $conn=null;
	#$conn=DBI->connect("dbi:PgPP:dbname=$dbname;host=$host;$port", $usename, $pwd,{RaiseError => 1}) or die "Unable to connect: $DBI::errstr\n";
	$conn=DBIx::AutoReconnect-> connect(
           "dbi:PgPP:dbname=warehouse;host=dw0;5432",
           "slony",
           "slony",
           {
                PrintError => 0,
                ReconnectTimeout => 60,
                ReconnectFailure => sub { warn "oops dw0 !" },
				ReconnectMaxTries => 100
           },
     );
	return $conn;
}

return 1;
exit;