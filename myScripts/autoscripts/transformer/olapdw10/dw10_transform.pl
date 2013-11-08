my $rootFD='/opt/temp/autoscripts/transformer';
my $daily_agg_table="daily_agg_table.txt";
my $dim_table="dim_table.txt";
my @aggTable=();
my @dimTable=();

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

#load dim table from file
open (CHECKBOOK, "< $dim_table") || die "couldn't open the file!";

while ($record = <CHECKBOOK>) {
  $record=~s/[\x0A\x0D]//g;
  if(index($record,'#')>=0){
  
  }else{
	  push(@dimTable,$record);
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
if(@ARGV>=1){
	if($mode eq 'daily'){
		checkDailyAgg($ARGV[1]);
	}elsif($mode eq 'daily_range'){
		checkDailyRangeAgg($ARGV[1],$ARGV[2]);	
	}elsif($mode eq 'dim_no_dt_expire'){
		transferDimDaily();	
	}
}else{
	print "perl dw10_transform.pl daily 2012-02-01\n";
	print "perl dw10_transform.pl daily_range 2012-09-01 2012-09-02\n";
	print "perl dw10_transform.pl dim_no_dt_expire\n";
}

sub transferDimDaily{
	my $i=0;
	foreach $table(@dimTable){
		$i++;
		print "* $i $table\n";
		$callFunction="su - file_xfer -c \"cd $rootFD && perl main.pl dim_no_dt_expire dw3 dw10 $table dw10_transform\"";
		system($callFunction);
	}	
}
sub checkDailyAgg{
	my $from="dw3";
	my $to="dw10";
	my $date=shift;
	my $dbh_from=getConnection($from);	
	my $dbh_to=getConnection($to);
	my $query="";
	my $query_handle="";
	my $countOnSource=1;
	my $countOnTarget=2;
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
		##$query_handle = $dbh_from->prepare($query);
		##$query_handle->execute("$date");
		##$query_handle->bind_columns(undef, \$count,\$dt_lastchange);
		##while($query_handle->fetch()) {	
		##	$countOnSource=$count;
		##	$dt_lastchange_dw3=$dt_lastchange;
		##}


		#query on dw0
		##$query_handle = $dbh_to->prepare($query);
		##$query_handle->execute("$date");
		##$query_handle->bind_columns(undef, \$count,\$dt_lastchange);
		##while($query_handle->fetch()) {	
		##	$countOnTarget=$count;
		##	$dt_lastchange_dw0=$dt_lastchange;
		##}
		##print "$from: $countOnSource\t$to: $countOnTarget\n";
		if($countOnSource>0){
			if($countOnTarget!=$countOnSource){
				print "\n**Transfer data to $to\n";
				if(index($table,'*')>=0){
					$table=~s/\*//g;
					print "**Transfer with partition mode\n";
					$callFunction="su - file_xfer -c \"cd $rootFD && perl mainWP.pl daily dw3 dw10 $table $date dw10_transform\"";
					system($callFunction);
				}else{
					$callFunction="su - file_xfer -c \"cd $rootFD && perl main.pl daily dw3 dw10 $table $date dw10_transform\"";
					system($callFunction);
				}
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

sub checkDailyRangeAgg{
	my $from="dw3";
	my $to="dw10";
	my $date=shift;
	my $end_date=shift;
	my $dbh_from=getConnection($from);	
	my $dbh_to=getConnection($to);
	my $query="";
	my $query_handle="";
	my $countOnSource=1;
	my $countOnTarget=2;
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
		##$query_handle = $dbh_from->prepare($query);
		##$query_handle->execute("$date");
		##$query_handle->bind_columns(undef, \$count,\$dt_lastchange);
		##while($query_handle->fetch()) {	
		##	$countOnSource=$count;
		##	$dt_lastchange_dw3=$dt_lastchange;
		##}


		#query on dw0
		##$query_handle = $dbh_to->prepare($query);
		##$query_handle->execute("$date");
		##$query_handle->bind_columns(undef, \$count,\$dt_lastchange);
		##while($query_handle->fetch()) {	
		##	$countOnTarget=$count;
		##	$dt_lastchange_dw0=$dt_lastchange;
		##}

		##print "$from: $countOnSource\t$to: $countOnTarget\n";
		if($countOnSource>0){
			if($countOnTarget!=$countOnSource){
				print "\n**Transfer data to $to\n";
				if(index($table,'*')>=0){
					$table=~s/\*//g;
					print "**Transfer with partition mode\n";
					$callFunction="su - file_xfer -c \"cd $rootFD && perl mainWP.pl daily_range dw3 dw10 $table $date $end_date dw10_transform\"";
					system($callFunction);
				}else{
					$callFunction="su - file_xfer -c \"cd $rootFD && perl main.pl daily_range dw3 dw10 $table $date $end_date dw10_transform\"";
					system($callFunction);
				}
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
print "Total table transfered: $transfer\n$list_table_transfer\nTotal table updated: $update\n";