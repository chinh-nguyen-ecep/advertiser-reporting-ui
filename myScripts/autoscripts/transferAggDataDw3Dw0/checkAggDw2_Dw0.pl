require "../bin/dw3_utils.pl";


my $daily_agg_table="daily_agg_table.txt";
my $monthly_agg_table="monthly_agg_table.txt";

my @aggTable=();
my @aggTableMonthly=();

#load daily agg table from file
open (CHECKBOOK, "< $daily_agg_table") || die "couldn't open the file!";

while ($record = <CHECKBOOK>) {
  $record=~s/[\x0A\x0D]//g;
  push(@aggTable,$record);
}
close(CHECKBOOK);

#load monhtly agg table from file
open (CHECKBOOK, "< $monthly_agg_table") || die "couldn't open the file!";

while ($record = <CHECKBOOK>) {
  $record=~s/[\x0A\x0D]//g;
  push(@aggTableMonthly,$record);
}
close(CHECKBOOK);


my $mode='';
my $date='';
my $month='';
my $start_date='';
my $end_date='';
my $update=0;
my $transfer=0;
if(@ARGV>=2){
	$mode=$ARGV[0];
	if($mode eq 'daily') {$date=$ARGV[1];}
	if($mode eq 'daily_range') {$start_date=$ARGV[1];$end_date=$ARGV[2];}
	if($mode eq 'monthly') {$month=$ARGV[1];}
}else{
	print "perl checkAggDw2_Dw0 daily 2012-03-27\nperl checkAggDw2_Dw0 daily_range 2012-02-01 2012-02-10\nperl checkAggDw2_Dw0 monthly 2012-Feb\n";
	exit;
}

if($mode eq 'daily'){
	my $dbh_dw2=getConnectionDw2();	
	my $dbh_dw0=getConnectionDw0();
	my $query="";
	my $query_handle="";
	my $countOnDw2=0;
	my $countOnDw0=0;
	my $dt_lastchange_dw2='';
	my $dt_lastchange_dw0='';
	my $i=0;
	foreach $table(@aggTable){
		$i++;
		print "#Table $i: $table\t";
		$query="SELECT COUNT(*) as count,(max(dt_lastchange)) as dt_lastchange FROM $table WHERE full_date=? AND is_active=true";
		#query on Dw2
		$query_handle = $dbh_dw2->prepare($query);
		$query_handle->execute("$date");
		$query_handle->bind_columns(undef, \$count,\$dt_lastchange);
		while($query_handle->fetch()) {	
			$countOnDw2=$count;
			$dt_lastchange_dw2=$dt_lastchange;
		}
		#query on dw0
		$query_handle = $dbh_dw0->prepare($query);
		$query_handle->execute("$date");
		$query_handle->bind_columns(undef, \$count,\$dt_lastchange);
		while($query_handle->fetch()) {	
			$countOnDw0=$count;
			$dt_lastchange_dw0=$dt_lastchange;
		}
		print "Dw2: $countOnDw2\tDw0: $countOnDw0\n";
		if($countOnDw0<$countOnDw2){
			print "*Transfer data to dw0\n";
			my $callFunction ="cd /opt/temp/daily_agg_program_dw2_dw0/;java -jar DAILY_AGG_DW2_DW0.jar daily $table $date";
			system($callFunction);
			$transfer++;
		}elsif($dt_lastchange_dw2 ne $dt_lastchange_dw0){
			print "*Update data to dw0\n";
			my $callFunction ="cd /opt/temp/daily_agg_program_dw2_dw0/;java -jar DAILY_AGG_DW2_DW0.jar daily $table $date";
			system($callFunction);
			$update++;
		}
	}
	#disconnect database
	my $rv = $dbh_dw2->disconnect;
	$rv = $dbh_dw0->disconnect;
}
elsif($mode eq 'monthly'){
	my $dbh_dw2=getConnectionDw2();	
	my $dbh_dw0=getConnectionDw0();
	my $query="";
	my $query_handle="";
	my $countOnDw2=0;
	my $countOnDw0=0;
	my $i=0;
	foreach $table(@aggTableMonthly){
		$i++;
		print "#Table $i: $table -------------------------------------------------------------\n";
		$query="SELECT COUNT(*) as count FROM $table WHERE calendar_year_month=? AND is_active=true";
		#query on Dw2
		$query_handle = $dbh_dw2->prepare($query);
		$query_handle->execute("$month");
		$query_handle->bind_columns(undef, \$count);
		while($query_handle->fetch()) {	
			$countOnDw2=$count;
		}
		#query on dw0
		$query_handle = $dbh_dw0->prepare($query);
		$query_handle->execute("$month");
		$query_handle->bind_columns(undef, \$count);
		while($query_handle->fetch()) {	
			$countOnDw0=$count;
		}
		print "Dw2: $countOnDw2\tDw0: $countOnDw0\n";
		if($countOnDw0!=$countOnDw2){
			print "Continous(y/n): ";
			my $isNext='';
			chomp($isNext=<>);
			if($isNext eq 'n'){
				last;
			}
		}
	}
	#disconnect database
	my $rv = $dbh_dw2->disconnect;
	$rv = $dbh_dw0->disconnect;
}

elsif($mode eq 'daily_range'){

	my $query="";
	my $query_handle="";
	my $countOnDw2=0;
	my $countOnDw0=0;
	my $dt_lastchange_dw2='';
	my $dt_lastchange_dw0='';	
	my @date_array=getDateArray($start_date,$end_date);
	
	foreach $the_date(@date_array){
		print "***Check on $the_date\n";
		sleep(5);
		my $i=0;
		my $dbh_dw2=getConnectionDw2();	
		my $dbh_dw0=getConnectionDw0();
		foreach $table(@aggTable){
			$i++;
			print "#Table $i: $table\t";
			$query="SELECT COUNT(*) as count,(max(dt_lastchange)) as dt_lastchange FROM $table WHERE full_date=? AND is_active=true";
			#query on Dw2
			$query_handle = $dbh_dw2->prepare($query);
			$query_handle->execute("$the_date");
			$query_handle->bind_columns(undef, \$count,\$dt_lastchange);
			while($query_handle->fetch()) {	
				$countOnDw2=$count;
				$dt_lastchange_dw2=$dt_lastchange;
			}
			#query on dw0
			$query_handle = $dbh_dw0->prepare($query);
			$query_handle->execute("$the_date");
			$query_handle->bind_columns(undef, \$count,\$dt_lastchange);
			while($query_handle->fetch()) {	
				$countOnDw0=$count;
				$dt_lastchange_dw0=$dt_lastchange;
			}
			print "Dw2: $countOnDw2\tDw0: $countOnDw0\n";
			if($countOnDw0!=$countOnDw2){
				print "*Transfer data to dw0\n";
				my $callFunction ="cd /opt/temp/daily_agg_program_dw2_dw0/;java -jar DAILY_AGG_DW2_DW0.jar daily $table $the_date";
				system($callFunction);
				$transfer++;
			}elsif($dt_lastchange_dw2 ne $dt_lastchange_dw0){
				print "*Update data to dw0\n";
				my $callFunction ="cd /opt/temp/daily_agg_program_dw2_dw0/;java -jar DAILY_AGG_DW2_DW0.jar daily $table $the_date";
				system($callFunction);
				$update++;
			}
		}
	#disconnect database
	my $rv = $dbh_dw2->disconnect;
	$rv = $dbh_dw0->disconnect;
	}
	
}else{
	print "perl checkAggDw2_Dw0 daily 2012-03-27\nperl checkAggDw2_Dw0 daily_range 2012-02-01 2012-02-10\nperl checkAggDw2_Dw0 monthly 2012-Feb\n";
	exit;
}

print "Total table transfered: $transfer\nTotal table updated: $update\n";
