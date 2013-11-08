require "utils.pl";

my $date=yesterday();
my $sendNoticeEmail=0;
my $emailNoticeTitle="[Notification!][3rd party report][May be late today][$date]";
my $emailAvailableTitle="[Notification!][3rd party report][Available][$date]";
my $mailto="dw-vndev\@ecepvn.org,chinh.nguyen\@ecepvn.org";
my $contentTitle="Agg data for 3rd report on dw3 on date: $date ";
my $resultHTML="";
my $aggDataZeroCountRows=0;
my @aggTableDw3=();
#register agg table
push(@aggTableDw3,"adnetwork.daily_mm_performance");
push(@aggTableDw3,"adnetwork.daily_jt_performance");
#push(@aggTableDw3,"adnetwork.daily_ga_performance");
push(@aggTableDw3,"adnetwork.daily_wh_performance");
push(@aggTableDw3,"adnetwork.daily_mx_performance");
push(@aggTableDw3,"adnetwork.daily_adsense_dbclk_channel");
push(@aggTableDw3,"adnetwork.daily_cg_performance");
push(@aggTableDw3,"adnetwork.daily_it_performance");
#push(@aggTableDw3,"adnetwork.daily_sp_performance");
push(@aggTableDw3,"adnetwork.daily_sp_blue_performance");
push(@aggTableDw3,"adnetwork.daily_yp_performance");
# Check how many agg table with data count rows = 0.
	my $time=getTime();
	$resultHTML="Report time: $time<p />";
	$resultHTML=$resultHTML."<h1>$contentTitle</h1></p>";
	$resultHTML=$resultHTML."<table border=1 cellpadding=0>
	<thead>
		<tr>
		<th width=130>Count data rows</th>
		<th width=300>Agg table</th>
		<th width=300>Reporting</th>
		</tr>
	</thead>
	<tbody>";
	#Create connection
	my $dbh = getConnectionDw3();
	foreach $table(@aggTableDw3){
		my $query="SELECT count(full_date) as rows FROM $table WHERE is_active=true AND full_date='$date'";

		my $query_handle = $dbh->prepare($query);
		$query_handle->execute();
		$query_handle->bind_columns(undef, \$rows);
		# LOOP THROUGH RESULTS
		while($query_handle->fetch()) {
		  my $reporting=getReportName($table);
		  if($rows==0){
			$aggDataZeroCountRows++;
		  }
		  $resultHTML=$resultHTML."<tr><td>$rows</td><td>$table</td><td>$reporting</td></tr>";
		} 

	}
	#disconnect database		
	my $rv = $dbh->disconnect;
	$resultHTML=$resultHTML."</tbody></table>";

if($aggDataZeroCountRows>0){
sendMail($mailto,$emailNoticeTitle,"$resultHTML.<p />Thanks,<br />Auto send mail.");
	while($aggDataZeroCountRows>0){
		$aggDataZeroCountRows=0;
		$resultHTML="";
		
		# Get html result and check datazerocountrow
		$time=getTime();
		$resultHTML="Report time: $time<p />";
		$resultHTML=$resultHTML."<h1>$contentTitle</h1></p>";
		$resultHTML=$resultHTML."<table border=1 cellpadding=0>
		<thead>
			<tr>
			<th width=130>Count data rows</th>
			<th width=300>Agg table</th>
			<th width=300>Reporting</th>
			</tr>
		</thead>
		<tbody>";
		#Create connection
		my $dbh = getConnectionDw3();
		foreach $table(@aggTableDw3){
			my $query="SELECT count(full_date) as rows FROM $table WHERE is_active=true AND full_date='$date'";			
			my $query_handle = $dbh->prepare($query);
			$query_handle->execute();
			$query_handle->bind_columns(undef, \$rows);
			# LOOP THROUGH RESULTS
			while($query_handle->fetch()) {
			  my $reporting=getReportName($table);
			  if($rows==0){
				$aggDataZeroCountRows++;
			  }
			  $resultHTML=$resultHTML."<tr><td>$rows</td><td>$table</td><td>$reporting</td></tr>";
			} 
		}
		#disconnect database		
		my $rv = $dbh->disconnect;
		$resultHTML=$resultHTML."</tbody></table>";
		# end check and get html result.
		
		if($aggDataZeroCountRows==0){
			#send notice mail to notice data is available.
			sendMail($mailto,$emailAvailableTitle,"$resultHTML.<p />Thanks,<br />Auto send mail.");
		}else{
			sleep(3600);
		}
	}
}else{
	#send notice mail to notice data is available.
	sendMail($mailto,$emailAvailableTitle,"$resultHTML.<p />Thanks,<br />Auto send mail.");
}






