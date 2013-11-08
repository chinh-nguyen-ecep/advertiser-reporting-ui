use DBI;
use Date::Pcalc qw(:all);
use DBIx::AutoReconnect;


my $mode=$ARGV[0];
my $year=$ARGV[1];
my $start_date_sk=0;
my $end_date_sk=0;
my $main_table='';
my $TABLESPACE='';
my $host='';

my $OWNER='warehouse_dbo';
my $Group='dataman';

if(@ARGV==0){
	print "perl createPartion.pl week 2012 2565 2578 adm.daily_agg_network_performance adm_tablespace dw0 \n";
	print "perl createPartion.pl month 2012 adm.daily_agg_network_performance adm_tablespace dw0 \n";
	print "perl createPartion.pl drop_week 2012 2565 2578 adm.daily_agg_network_performance adm_tablespace dw0 \n";
	print "perl createPartion.pl drop_month 2012 adm.daily_agg_network_performance adm_tablespace dw0 \n";
}elsif(@ARGV==7){
	$start_date_sk=$ARGV[2];
	$end_date_sk=$ARGV[3];
	$main_table=$ARGV[4];
	$TABLESPACE=$ARGV[5];
	$host=$ARGV[6];
	if($mode eq 'week'){
		weekPartion();
	}elsif($mode eq 'drop_week'){
		dropPartion();
	}
}elsif(@ARGV==5){
	$main_table=$ARGV[2];
	$TABLESPACE=$ARGV[3];
	$host=$ARGV[4];
	if($mode eq 'month'){
		monthPartion();
	}elsif($mode eq 'drop_month'){
		dropMonthPartion();
	}
}else{
	print "ooppppp...";
}

sub weekPartion{
	my $dbh=getConnection($host);
	my $query='SELECT min(date_sk) as min
				,max(date_sk) as max
				,year_week_monday
				FROM refer.date_dim 
				WHERE calendar_year=?
				AND date_sk BETWEEN ? AND ?
				GROUP BY year_week_monday
				ORDER BY year_week_monday';
				
	my $query_handle = $dbh->prepare($query);
		$query_handle->execute($year,$start_date_sk,$end_date_sk);
		$query_handle->bind_columns(undef, \$min,\$max,\$year_week_monday);
		while($query_handle->fetch()) {
				$year_week_monday=~s/-/_/g;
				my @arrayTemp=split('\.', $main_table);
				my $main_table_name=$arrayTemp[1];
				my $PartitionTableName=$main_table."_y".$year_week_monday;
				$PartitionTableName=lc($PartitionTableName);
				my $CONSTRAINT=$main_table."_check_y".$year_week_monday;
				$CONSTRAINT=~ s/\.//g;
				$CONSTRAINT= lc($CONSTRAINT);
				
				my $RULE_name=$main_table_name."_insert_y".$year_week_monday;
				$RULE_name=~ s/\.//g;
				$RULE_name= lc($RULE_name);
				
			      my $query2="CREATE TABLE $PartitionTableName
							(
							  CONSTRAINT $CONSTRAINT
							  CHECK (eastern_date_sk >= $min AND eastern_date_sk <= $max)
							)
							INHERITS ($main_table)
							WITH (
							  OIDS=FALSE
							)TABLESPACE $TABLESPACE";
					my $query_handle2 = $dbh->prepare($query2);
					$query_handle2->execute();
					
					$query2="ALTER TABLE $PartitionTableName OWNER TO $OWNER;
					GRANT ALL ON TABLE $PartitionTableName TO $OWNER;
					GRANT SELECT ON TABLE $PartitionTableName TO $Group";
					$query_handle2 = $dbh->prepare($query2);
					$query_handle2->execute();
					#create Rule
					
					$query2="CREATE OR REPLACE RULE $RULE_name AS
							ON INSERT TO $main_table
							WHERE new.eastern_date_sk >= $min AND new.eastern_date_sk <= $max DO INSTEAD  INSERT INTO $PartitionTableName
							VALUES (new.*)";
					
					$query_handle2 = $dbh->prepare($query2);
					$query_handle2->execute();
					#create index
					
					$query2="CREATE INDEX $main_table_name"."_date_sk ON $PartitionTableName (eastern_date_sk);";
					$query2 =lc($query2);
					$query_handle2 = $dbh->prepare($query2);
					$query_handle2->execute();
					
					print "$PartitionTableName -- Done\n";
			};
	my $rv = $dbh->disconnect;
}

sub monthPartion{
	my $dbh=getConnection($host);
	my $query='SELECT date_sk_start as min
				,date_sk_end as max
				,calendar_year_month
				FROM refer.month_dim
				WHERE calendar_year_month LIKE ?
				ORDER BY date_sk_start';
				
	my $query_handle = $dbh->prepare($query);
		$query_handle->execute("%$year%");
		$query_handle->bind_columns(undef, \$min,\$max,\$calendar_year_month);
		while($query_handle->fetch()) {
				$calendar_year_month=~s/-/_/g;
				my @arrayTemp=split('\.', $main_table);
				my $main_table_name=$arrayTemp[1];
				my $PartitionTableName=$main_table."_".$calendar_year_month;
				$PartitionTableName=lc($PartitionTableName);
				my $CONSTRAINT=$main_table_name."_check_".$calendar_year_month;
				$CONSTRAINT=~ s/\./_/g;
				$CONSTRAINT= lc($CONSTRAINT);
				
				my $RULE_name=$main_table_name."_insert_".$calendar_year_month;
				$RULE_name=~ s/\./_/g;
				$RULE_name= lc($RULE_name);
				
			      my $query2="CREATE TABLE $PartitionTableName
							(
							  CONSTRAINT $CONSTRAINT
							  CHECK (eastern_date_sk >= $min AND eastern_date_sk <= $max)
							)
							INHERITS ($main_table)
							WITH (
							  OIDS=FALSE
							)TABLESPACE $TABLESPACE";
					my $query_handle2 = $dbh->prepare($query2);
					$query_handle2->execute();
					
					$query2="ALTER TABLE $PartitionTableName OWNER TO $OWNER;
					GRANT ALL ON TABLE $PartitionTableName TO $OWNER;
					GRANT SELECT ON TABLE $PartitionTableName TO $Group";
					$query_handle2 = $dbh->prepare($query2);
					$query_handle2->execute();
					#create Rule
					
					$query2="CREATE OR REPLACE RULE $RULE_name AS
							ON INSERT TO $main_table
							WHERE new.eastern_date_sk >= $min AND new.eastern_date_sk <= $max DO INSTEAD  INSERT INTO $PartitionTableName
							VALUES (new.*)";
					
					$query_handle2 = $dbh->prepare($query2);
					$query_handle2->execute();
					#create index
					my $INDEX_name=$main_table_name."_idx_".$calendar_year_month;
					$INDEX_name=~ s/\./_/g;
					$INDEX_name= lc($INDEX_name);
					$query2="CREATE INDEX $INDEX_name"."_date_sk ON $PartitionTableName (eastern_date_sk);";
					
					$query2 =lc($query2);
					$query_handle2 = $dbh->prepare($query2);
					$query_handle2->execute();
					
					print "$PartitionTableName -- Done\n";
			};
	my $rv = $dbh->disconnect;
}

sub dropMonthPartion{
	my $dbh=getConnection($host);
	my $query='SELECT date_sk_start as min
				,date_sk_end as max
				,calendar_year_month
				FROM refer.month_dim
				WHERE calendar_year_month LIKE ?
				ORDER BY date_sk_start';
				
	my $query_handle = $dbh->prepare($query);
		$query_handle->execute("%$year%");
		$query_handle->bind_columns(undef, \$min,\$max,\$calendar_year_month);
		while($query_handle->fetch()) {
				$calendar_year_month=~s/-/_/g;
				my $PartitionTableName=$main_table."_".$calendar_year_month;
				$PartitionTableName=lc($PartitionTableName);
				my $CONSTRAINT=$main_table."_check_".$calendar_year_month;
				$CONSTRAINT=~ s/\./_/g;
				$CONSTRAINT= lc($CONSTRAINT);
				
				my $RULE_name=$main_table."_insert_".$calendar_year_month;
				$RULE_name=~ s/\./_/g;
				$RULE_name= lc($RULE_name);
				
			    my $query2="DROP TABLE $PartitionTableName cascade";
				my $query_handle2 = $dbh->prepare($query2);
				$query_handle2->execute();				
				print "Drop partition: $PartitionTableName -- Done\n";
			};
	my $rv = $dbh->disconnect;
}

sub dropPartion{
	print "*** Droping week partition\n";
	my $dbh=getConnection($host);
	my $query='SELECT min(date_sk) as min
				,max(date_sk) as max
				,year_week_monday
				FROM refer.date_dim 
				WHERE calendar_year=?
				AND date_sk BETWEEN ? AND ?
				GROUP BY year_week_monday
				ORDER BY year_week_monday';
				
	my $query_handle = $dbh->prepare($query);
		$query_handle->execute($year,$start_date_sk,$end_date_sk);
		$query_handle->bind_columns(undef, \$min,\$max,\$year_week_monday);
		while($query_handle->fetch()) {
				$year_week_monday=~s/-/_/g;
				my $PartitionTableName=$main_table."_y".$year_week_monday;
				$PartitionTableName=lc($PartitionTableName);
			    my $query2="drop table $PartitionTableName cascade";
				$query_handle2 = $dbh->prepare($query2);
				$query_handle2->execute();
				print "Drop table $PartitionTableName -- Done\n";
		}
	my $rv = $dbh->disconnect;
}



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
	}elsif($host eq 'dw10'){
		$conn=getConnectionDw10();
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

sub getConnectionDw10{
	my $conn=null;
	#$conn=DBI->connect("dbi:PgPP:dbname=$dbname;host=$host;$port", $usename, $pwd,{RaiseError => 1}) or die "Unable to connect: $DBI::errstr\n";
	$conn=DBIx::AutoReconnect-> connect(
           "dbi:PgPP:dbname=warehouse;host=dw10;5432",
           "sample_admin",
           "sample_admin",
           {
                PrintError => 0,
                ReconnectTimeout => 60,
                ReconnectFailure => sub { warn "oops dw10 !" },
				ReconnectMaxTries => 100
           },
     );
	return $conn;
}