my $rootFD='/opt/temp/autoscripts/transformer';
my $daily_agg_table="daily_agg_table.txt";
my $daily_fact_table="daily_adcel_fact_table.txt";
my @aggTable=();
my @factTable=();

#load daily agg table from file
open (CHECKBOOK, "< $daily_agg_table") || die "couldn't open the file!";

while ($record = <CHECKBOOK>) {
  $record=~s/[\x0A\x0D]//g;
  if(index($record,'#')>=0){
  
  }else{
	  push(@aggTable,$record);
  }

}
close(CHECKBOOK);

#load daily fact table from file
open (CHECKBOOK, "< $daily_fact_table") || die "couldn't open the file!";

while ($record = <CHECKBOOK>) {
  $record=~s/[\x0A\x0D]//g;
  if(index($record,'#')>=0){
  
  }else{
	  push(@factTable,$record);
  }

}
close(CHECKBOOK);
require "../transformer_utils.pl";
my $mode='';
my $date='';
my $month='';
my $start_date='';
my $end_date='';
my $table_name='';
my $table_mode=0;
my $update=0;
my $transfer=0;
my $list_table_transfer='';
my $list_table_update='';

$mode=$ARGV[0];
if(@ARGV==4){
	if($mode eq 'daily'){
		checkDailyAgg($ARGV[1],$ARGV[2],$ARGV[3]);
	}elsif($mode eq 'daily_fact'){
		checkDailyFact($ARGV[1],$ARGV[2],$ARGV[3]);
	}elsif($mode eq 'monthly'){
		#checkDaily($ARGV[1],$ARGV[2],$ARGV[3]);
		
	}
}else{
	print "perl dw10_transform.pl daily dw3 dw10 2012-02-01\n";
	print "perl dw10_transform.pl daily_fact dw3 dw10 eastern_date_sk\n";
	print "perl dw10_transform.pl monthly dw3 dw10 2012-Mar\n";
}
sub checkDailyAgg{
	my $from=shift;
	my $to=shift;
	my $date=shift;
	my $dbh_from=getConnection($from);	
	my $dbh_to=getConnection($to);
	my $query="";
	my $query_handle="";
	my $countOnSource=0;
	my $countOnTarget=0;
	my $dt_lastchange_dw3='';
	my $dt_lastchange_dw0='';
	my $i=0;
	if($table_mode==1){
		@aggTable=();
		push(@aggTable,$table_name);
	}
	foreach $table(@aggTable){
		$i++;
		my $error=0;
		if($table_mode==1){
			print "#$date: $table\t";
		}else{
			print "#Table $i: $table\t";
		}
		
		$query="SELECT COUNT(*) as count,(max(dt_lastchange)) as dt_lastchange FROM $table WHERE full_date=? AND is_active=true";
		#query on dw3
		$query_handle = $dbh_from->prepare($query);
		$query_handle->execute("$date");
		$query_handle->bind_columns(undef, \$count,\$dt_lastchange);
		while($query_handle->fetch()) {	
			$countOnSource=$count;
			$dt_lastchange_dw3=$dt_lastchange;
		}


		#query on dw0
		$query_handle = $dbh_to->prepare($query);
		$query_handle->execute("$date");
		$query_handle->bind_columns(undef, \$count,\$dt_lastchange);
		while($query_handle->fetch()) {	
			$countOnTarget=$count;
			$dt_lastchange_dw0=$dt_lastchange;
		}

		print "$from: $countOnSource\t$to: $countOnTarget\n";
		if($countOnSource>0){
			if($countOnTarget!=$countOnSource){
				print "*Transfer data to $to\n";
				my $callFunction ="cd $rootFD;perl main.pl daily $from $to $table $date";
				system($callFunction);
				$transfer++;
				$list_table_transfer=$list_table_transfer."$table\t$from: $countOnSource\t$to: $countOnTarget\n";
			}elsif($dt_lastchange_dw3 ne $dt_lastchange_dw0){
				print "*Update data to $to\n";
				my $callFunction ="cd $rootFD;perl main.pl daily $from $to $table $date";
				system($callFunction);
				$update++;
				$list_table_update=$list_table_update."$table\t$from: $dt_lastchange_dw3\t$to: $dt_lastchange_dw0\n";
			}
		}		
	}
	#disconnect database
	my $rv = $dbh_from->disconnect;
	$rv = $dbh_to->disconnect;
}

sub checkDailyFact{
	my $from=shift;
	my $to=shift;
	my $eastern_date_sk=shift;
	my $dbh_from=getConnection($from);	
	my $dbh_to=getConnection($to);
	my $query="";
	my $query_handle="";
	my $countOnSource=0;
	my $countOnTarget=0;
	my $dt_lastchange_dw3='';
	my $dt_lastchange_dw0='';
	my $i=0;
	if($table_mode==1){
		@factTable=();
		push(@factTable,$table_name);
	}
	foreach $table(@factTable){
		$i++;
		my $error=0;
		if($table_mode==1){
			print "#$eastern_date_sk: $table\t";
		}else{
			print "#Table $i: $table\t";
		}
		
		$query="SELECT count(*) as count FROM $table WHERE eastern_date_sk=?";
		#query on dw3
		$query_handle = $dbh_from->prepare($query);
		$query_handle->execute("$eastern_date_sk");
		$query_handle->bind_columns(undef, \$count);
		while($query_handle->fetch()) {	
			$countOnSource=$count;
		}


		#query on Target
		$query_handle = $dbh_to->prepare($query);
		$query_handle->execute("$eastern_date_sk");
		$query_handle->bind_columns(undef, \$count);
		while($query_handle->fetch()) {	
			$countOnTarget=$count;
		}

		print "$from: $countOnSource\t$to: $countOnTarget\n";
		if($countOnSource>0){
			if($countOnTarget<$countOnSource){
				print "*Transfer data to $to\n";
				my $callFunction ="cd $rootFD;perl main.pl daily_fact $from $to $table $eastern_date_sk";
				system($callFunction);
				$transfer++;
				$list_table_transfer=$list_table_transfer."$table\t$from: $countOnSource\t$to: $countOnTarget\n";
			}else{
				print "*Row count from $from <= $to\n";
				$update++;
				$list_table_update=$list_table_update."$table\n";
			}
		}		
	}
	#disconnect database
	my $rv = $dbh_from->disconnect;
	$rv = $dbh_to->disconnect;
}
print "Total table transfered: $transfer\n$list_table_transfer\nTotal table updated: $update\n";