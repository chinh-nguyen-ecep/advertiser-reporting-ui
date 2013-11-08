require "utils.pl";

my $date=yesterday();
my $sendNoticeEmail=0;
my $emailNoticeTitle="[Notification!][Network traffic report][May be late today][$date]";
my $emailAvailableTitle="[Notification!][Network traffic report][Available][$date]";
my $mailto="dw-vndev\@ecepvn.org,chinh.nguyen\@ecepvn.org";
my $contentTitle="Agg data for Network traffic report on dw1 on date: $date ";
my $resultHTML="";
my $aggDataZeroCountRows=0;

my @aggTableDw1=();
#register agg table
push(@aggTableDw1,"dw.daily_agg_ap_module_breakdown");
push(@aggTableDw1,"dw.daily_agg_group_act_all");
push(@aggTableDw1,"dw.daily_agg_group_portal_act_all");
push(@aggTableDw1,"dw.daily_agg_network_act_all");
push(@aggTableDw1,"dw.daily_agg_partner_act_all");
push(@aggTableDw1,"dw.daily_agg_partner_act_cont_mod_type");
push(@aggTableDw1,"dw.daily_agg_partner_act_content_category");
push(@aggTableDw1,"dw.daily_agg_partner_act_content_module");
push(@aggTableDw1,"dw.daily_agg_partner_act_date");
push(@aggTableDw1,"dw.daily_agg_partner_act_day_of_week");
push(@aggTableDw1,"dw.daily_agg_partner_act_device");
push(@aggTableDw1,"dw.daily_agg_partner_act_hour");
push(@aggTableDw1,"dw.daily_agg_partner_act_portal");
push(@aggTableDw1,"dw.daily_agg_portal_act_all");
push(@aggTableDw1,"dw.daily_agg_site_traffic");
push(@aggTableDw1,"dw.daily_agg_site_traffic_historical");

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
	my $dbh = getConnectionDw1();
	foreach $table(@aggTableDw1){
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
		print "Rechecked agg data\n";
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
		my $dbh = getConnectionDw1();
		foreach $table(@aggTableDw1){
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




