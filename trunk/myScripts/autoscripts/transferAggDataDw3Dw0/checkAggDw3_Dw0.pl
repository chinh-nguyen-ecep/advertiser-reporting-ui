require "../bin/dw_utils.pl";
require "config.pl";

my @aggTable=();
my @aggTableMonthly=();

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

#load monhtly agg table from file
open (CHECKBOOK, "< $monthly_agg_table") || die "couldn't open the file!";

while ($record = <CHECKBOOK>) {
  $record=~s/[\x0A\x0D]//g;
  if(index($record,'#')>=0){
  
  }else{
	  push(@aggTableMonthly,$record);
  }

}
close(CHECKBOOK);

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
if(@ARGV>=2){
	$mode=$ARGV[0];
	if($mode eq 'daily') {$date=$ARGV[1];}
	if($mode eq 'daily_range') {$start_date=$ARGV[1];$end_date=$ARGV[2];}
	if($mode eq 'monthly') {$month=$ARGV[1];}
	if($mode eq 'table'){$table_mode=1;$table_name=$ARGV[3];$start_date=$ARGV[1];$end_date=$ARGV[2];}
}else{
	print "perl checkAggDw3_Dw0 daily 2012-03-27\n";
	print "perl checkAggDw3_Dw0 daily_range 2012-02-01 2012-02-10\n";
	print "perl checkAggDw3_Dw0 monthly 2012-Feb\n";
	print "perl checkAggDw3_Dw0 table 2012-02-01 2012-02-10 adnetwork.daily_adnetwork_summary\n";
	print "perl checkAggDw3_Dw0 atable adnetwork.daily_adnetwork_summary\n";
	exit;
}

if($mode eq 'daily'){
	checkDaily($date);
}
elsif($mode eq 'daily_range'){
	checkDailyRange($start_date,$end_date);	
}
elsif($mode eq 'table'){
	my @date_array=getDateArray($start_date,$end_date);	
	foreach $the_date(@date_array){
		checkDaily($the_date);
	}
	
}
elsif($mode eq 'atable'){
	my $table=$ARGV[1];
	my $callFunction ="su - file_xfer -c \"cd /opt/temp/autoscripts/transformer/ && perl main.pl table $from_host $destination_host $table\"";
	system($callFunction);
	
}
elsif($mode eq 'monthly'){
	checkMonthly($month);
}else{
	print "perl checkAggDw3_Dw0 daily 2012-03-27\n
	perl checkAggDw3_Dw0 daily_range 2012-02-01 2012-02-10\n
	perl checkAggDw3_Dw0 monthly 2012-Feb\n
	perl checkAggDw3_Dw0 table 2012-02-01 2012-02-10 adnetwork.daily_adnetwork_summary\n";
	exit;
}

sub checkDaily{
	my $date=shift;
	my $query="";
	my $query_handle="";
	my $countOnDw3=0;
	my $countOnDw0=0;
	my $dt_lastchange_dw3='';
	my $dt_lastchange_dw0='';
	my $i=0;
	if($table_mode==1){
		@aggTable=();
		push(@aggTable,$table_name);
	}
	foreach $table(@aggTable){
		my $dbh_dw3=getConnection($from_host);	
		my $dbh_dw0=getConnection($destination_host);
		$i++;
		my $error=0;
		if($table_mode==1){
			print "#$date: $table\t";
		}else{
			print "#Table $i: $table\t";
		}
		
		$query="SELECT COUNT(1) as count,(max(dt_lastchange)) as dt_lastchange FROM $table WHERE full_date=? AND is_active=true";
		#query on dw3
		$query_handle = $dbh_dw3->prepare($query);
		$query_handle->execute("$date");
		$query_handle->bind_columns(undef, \$count,\$dt_lastchange);
		while($query_handle->fetch()) {	
			$countOnDw3=$count;
			$dt_lastchange_dw3=$dt_lastchange;
		}

		#query on $destination_host
		$query_handle = $dbh_dw0->prepare($query);
		$query_handle->execute("$date");
		$query_handle->bind_columns(undef, \$count,\$dt_lastchange);
		while($query_handle->fetch()) {	
			$countOnDw0=$count;
			$dt_lastchange_dw0=$dt_lastchange;
		}

		print "$from_host: $countOnDw3\t$destination_host: $countOnDw0\n";
		if($countOnDw3>0){
			
			if($countOnDw0!=$countOnDw3){
				print "*Transfer data to $destination_host\n";
				transferDaily($table,$date,$countOnDw3,$dt_lastchange_dw3);
				$transfer++;
				$list_table_transfer=$list_table_transfer."$table\t$from_host: $countOnDw3\t$destination_host: $countOnDw0\n";
			}elsif($dt_lastchange_dw3 ne $dt_lastchange_dw0){
				print "*Update data to $destination_host\n";
				transferDaily($table,$date,$countOnDw3,$dt_lastchange_dw3);
				$update++;
				$list_table_update=$list_table_update."$table\t$from_host: $dt_lastchange_dw3\t$destination_host: $dt_lastchange_dw0\n";
			}
		}
	#disconnect database
	my $rv = $dbh_dw3->disconnect;
	$rv = $dbh_dw0->disconnect;		
	sleep(5);
	}
}
sub checkDailyRange{
	my $date=shift;
	my $end_date=shift;
	my $query="";
	my $query_handle="";
	my $countOnDw3=0;
	my $countOnDw0=0;
	my $dt_lastchange_dw3='';
	my $dt_lastchange_dw0='';
	my $i=0;
	if($table_mode==1){
		@aggTable=();
		push(@aggTable,$table_name);
	}
	foreach $table(@aggTable){
		my $dbh_dw3=getConnection($from_host);	
		my $dbh_dw0=getConnection($destination_host);
		$i++;
		my $error=0;
		if($table_mode==1){
			print "#$date: $table\t";
		}else{
			print "#Table $i: $table\t";
		}
		
		$query="SELECT COUNT(1) as count,(max(dt_lastchange)) as dt_lastchange FROM $table WHERE full_date BETWEEN ? AND ? AND is_active=true";
		#query on dw3
		$query_handle = $dbh_dw3->prepare($query);
		$query_handle->execute("$date","$end_date");
		$query_handle->bind_columns(undef, \$count,\$dt_lastchange);
		while($query_handle->fetch()) {	
			$countOnDw3=$count;
			$dt_lastchange_dw3=$dt_lastchange;
		}

		#query on $destination_host
		$query_handle = $dbh_dw0->prepare($query);
		$query_handle->execute("$date","$end_date");
		$query_handle->bind_columns(undef, \$count,\$dt_lastchange);
		while($query_handle->fetch()) {	
			$countOnDw0=$count;
			$dt_lastchange_dw0=$dt_lastchange;
		}

		print "$from_host: $countOnDw3\t$destination_host: $countOnDw0\n";
		if($countOnDw3>0){
			
			if($countOnDw0!=$countOnDw3){
				print "*Transfer data to $destination_host\n";
				transferDailyRange($table,$date,$end_date);
				$transfer++;
				$list_table_transfer=$list_table_transfer."$table\t$from_host: $countOnDw3\t$destination_host: $countOnDw0\n";
			}elsif($dt_lastchange_dw3 ne $dt_lastchange_dw0){
				print "*Update data to $destination_host\n";
				transferDailyRange($table,$date,$end_date);
				$update++;
				$list_table_update=$list_table_update."$table\t$from_host: $dt_lastchange_dw3\t$destination_host: $dt_lastchange_dw0\n";
			}
		}
	#disconnect database
	my $rv = $dbh_dw3->disconnect;
	$rv = $dbh_dw0->disconnect;		
	sleep(5);
	}
}
sub checkMonthly{
	my $month=shift;
	my $dbh_dw3=getConnection($from_host);	
	my $dbh_dw0=getConnection($destination_host);
	my $query="";
	my $query_handle="";
	my $countOnDw3=0;
	my $countOnDw0=0;
	my $dt_lastchange_dw3='';
	my $dt_lastchange_dw0='';
	my $i=0;
	foreach $table(@aggTableMonthly){
		$i++;
		print "#Table $i: $table\t";
		$query="SELECT COUNT(1) as count,(max(dt_lastchange)) as dt_lastchange FROM $table WHERE calendar_year_month=? AND is_active=true";
		#query on $from_host
		$query_handle = $dbh_dw3->prepare($query);
		$query_handle->execute($month);
		$query_handle->bind_columns(undef, \$count,\$dt_lastchange);
		while($query_handle->fetch()) {	
			$countOnDw3=$count;
			$dt_lastchange_dw3=$dt_lastchange;
		}
		#query on $destination_host
		$query_handle = $dbh_dw0->prepare($query);
		$query_handle->execute($month);
		$query_handle->bind_columns(undef, \$count,\$dt_lastchange);
		while($query_handle->fetch()) {	
			$countOnDw0=$count;
			$dt_lastchange_dw0=$dt_lastchange;
		}
		print "$from_host: $countOnDw3\t$destination_host: $countOnDw0\n";
		if($countOnDw3>0){
			
			if($countOnDw0!=$countOnDw3){
				print "*Transfer data to $destination_host\n";
				transferMonthly($table,$month);
				$transfer++;
				$list_table_transfer=$list_table_transfer."$table\t$from_host: $countOnDw3\t$destination_host: $countOnDw0\n";
			}elsif($dt_lastchange_dw3 ne $dt_lastchange_dw0){
				print "*Update data to $destination_host\n";
				transferMonthly($table,$month);
				$update++;
				$list_table_update=$list_table_update."$table\t$from_host: $dt_lastchange_dw3\t$destination_host: $dt_lastchange_dw0\n";
			}
		}
	}
	#disconnect database
	my $rv = $dbh_dw3->disconnect;
	$rv = $dbh_dw0->disconnect;
}

sub transferDaily{
	my $table=shift;
	my $date=shift;
	my $source_row_count=shift;
	my $source_dt_lastchange=shift;
	my $callFunction="";
	if(index($table,'*')>=0){
		$table=~s/\*//g;
		print "* Transfer $table with partition mode\n";
		$callFunction="cd /opt/temp/autoscripts/transformer/ && perl mainWP.pl daily $from_host $destination_host $table $date checkAddDw3_Dw0";
	}else{
		##my $callFunction ="cd /opt/temp/daily_agg_program/;java -jar DAILY_AGG_DW3_DW0.jar daily $table $date";
		$callFunction="cd /opt/temp/autoscripts/transformer/ && perl main.pl daily $from_host $destination_host $table $date checkAddDw3_Dw0";
		
	}
	system($callFunction);
}

sub transferDailyRange{
	my $table=shift;
	my $date=shift;
	my $end_date=shift;
	my $callFunction="";
	if(index($table,'*')>=0){
		$table=~s/\*//g;
		print "* Transfer $table with partition mode\n";
		$callFunction="cd /opt/temp/autoscripts/transformer/ && perl mainWP.pl daily_range $from_host $destination_host $table $date $end_date checkAddDw3_Dw0";
	}else{
		##my $callFunction ="cd /opt/temp/daily_agg_program/;java -jar DAILY_AGG_DW3_DW0.jar daily $table $date";
		$callFunction="cd /opt/temp/autoscripts/transformer/ && perl main.pl daily_range $from_host $destination_host $table $date $end_date checkAddDw3_Dw0";
		
	}
	system($callFunction);
}


sub transferMonthly{
	my $table=shift;
	my $month=shift;
	##my $callFunction ="cd /opt/temp/daily_agg_program/;java -jar MONTHLY_AGG_DW3_DW0.jar monthly $table \"$month\"";
	my $callFunction="cd /opt/temp/autoscripts/transformer/ && perl main.pl monthly $from_host $destination_host $table \"$month\" checkAddDw3_Dw0";
	if(index($table,'*')>=0){
		$table=~s/\*//g;
		print "* Transfer $table with partition mode\n";
		$callFunction="cd /opt/temp/autoscripts/transformer/ && perl mainWP.pl monthly $from_host $destination_host $table \"$month\" checkAddDw3_Dw0";
	}
	##print $callFunction."\n";
	system($callFunction);
}

print "\n**************************************************\nTotal table transfered: $transfer\n$list_table_transfer"."Total table updated: $update\n$list_table_update";
