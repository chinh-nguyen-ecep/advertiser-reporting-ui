require "../bin/dw3_utils.pl";
%h_report_date=dw3_yesterday();
%h_process_date=dw3_currentDate();

my $process_date=$h_process_date{'year'}.'-'.$h_process_date{'month'}.'-'.$h_process_date{'day'};	#the date run process
my $report_date=$h_report_date{'year'}.'-'.$h_report_date{'month'}.'-'.$h_report_date{'day'};	#the report date

my $mode='';
#my $mailaddress="binh\@vervewireless.com,chinh.nguyen\@ecepvn.org,song.nguyen\@ecepvn.org,rptprodops\@vervewireless.com";
#my $mailaddress="binh\@vervewireless.com,Dw-vndev\@ecepvn.org";
#my $mailaddress="chinh.nguyen\@ecepvn.org";
my $mailaddress="chinh.nguyen\@ecepvn.org,song.nguyen\@ecepvn.org,phap.ta\@ecepvn.org";

if(@ARGV==1){
	$mode=$ARGV[0];
}elsif(@ARGV==2){
	$mode=$ARGV[0];
	$report_date=$ARGV[1];
}else{
	print "perl notifications_for_late_reports.pl adcel|remnant|adm_data_mart \n";
	exit;
}

if($mode eq 'adcel'){
	adcelNotification();
}elsif($mode eq 'remnant'){
	adNetworkNotification();
}elsif($mode eq 'adm_data_mart'){
	my $isLate=admNetworkDatamart('isLate');
	print "####$isLate\n";
	if($isLate==1){
		#we will watting for all process finish and send notification successful
		my $isOk=0;
		while($isOk==0){
			print "#Waiting for process isOk!\n";
			sleep(60);
			$isOk=admNetworkDatamart('isOk');
		}
		print "Send notification OK!\n";
	}
}elsif($mode eq 'test'){
			my $dbh = getConnectionDw0();
			$report_date="2012-06-08";
			#get total_net_revenue và total_paid_impresions trong adm.daily_fct_performance_channel
			$query="SELECT sum(a.revenue) as total_net_revenue,sum(a.impressions) as total_paid_impressions,b.\"name\" as network_name FROM adm.daily_network_fct_channel a,refer.adm_network_dim b
			WHERE a.full_date = ? AND a.is_active=true AND a.network_id IN (1,2,3) AND a.network_id=b.network_id GROUP BY a.network_id,network_name
			ORDER BY a.network_id";
			my $query_handle = $dbh->prepare($query);
			$query_handle->execute($report_date);
			$query_handle->bind_columns(undef, \$total_net_revenue,\$total_paid_impressions,\$network_name);
			while($query_handle->fetch()) {
				$content=$content."<p /> Total net revenue in $network_name: $total_net_revenue
				<br />Total paid impressions in $network_name: $total_paid_impressions";
			}
		
			my $rv = $dbh->disconnect;	
			
			#get revenue và impresions trong network.fct_performance_wip
			my $dbh = getConnectionWIP();

			$query="SELECT sum(revenue) as revenue,sum(impressions) as impressions FROM network.fct_performance_wip WHERE period=(SELECT period FROM dim_dates WHERE calendar_date=?)";
			my $query_handle = $dbh->prepare($query);
			$query_handle->execute($report_date);
			$query_handle->bind_columns(undef, \$revenue,\$impressions);
			while($query_handle->fetch()) {
				$content=$content."<p /> Total net revenue in fct_performance_wip: $revenue
				<br />Total paid impressions in fct_performance_wip: $impressions <p />";
				print $content."\n";
			}
			my $rv = $dbh->disconnect;	
}else{
	print "perl notifications_for_late_reports.pl adcel|remnant|adm_data_mart \n";
}


sub adcelNotification{
	my $title="[ADCEL Report]Late Notification -- $process_date";
	my $statsAvailable=0;
	my $unfilledAvalable=0;
	my $filledAvailable=0;
	
	#check agg table
	#Create connection to dw0
	my $dbh = getConnectionDw0();
	
	#Check Stats reports
	my $query="SELECT COUNT(*) as count  FROM adstraffic.daily_ad_serving_stats WHERE is_active=true AND full_date = '$report_date'";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	$query_handle->bind_columns(undef, \$count);		
	
	
	while($query_handle->fetch()) {
		if($count>0){$statsAvailable=1;}
	} 
	
	#Check Unfilled reports
	my $query="SELECT COUNT(*) as count  FROM adstraffic.daily_unfilled_stats WHERE is_active=true AND full_date = '$report_date'";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	$query_handle->bind_columns(undef, \$count);		
	
	
	while($query_handle->fetch()) {
		if($count>0){$unfilledAvalable=1;}
	} 
	
	#Check Filled reports
	my $query="SELECT COUNT(*) as count  FROM adstraffic.daily_filled_stats WHERE is_active=true AND full_date = '$report_date'";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	$query_handle->bind_columns(undef, \$count);		
	
	
	while($query_handle->fetch()) {
		if($count>0){$filledAvailable=1;}
	} 
	
	#disconnect database	
	my $rv = $dbh->disconnect;
		
	my $content="Today late reports,<p/>";
	if($statsAvailable==0){
		$content=$content."- Daily AdCel Statistics $report_date is not available.<br/>"
	}
	if($unfilledAvalable==0){
		$content=$content."- Unfilled Request Daily Summary $report_date are not available.<br/>"
	}
	if($filledAvailable==0){
		$content=$content."- Filled Request Daily Summary $report_date are not available.<br/>"
	}
	
	my $time=getTime();
	$content=$content."<p/>Status Check at: $time PST time<br/>Send by auto.";
	if($statsAvailable==1 && $unfilledAvalable==1 && $filledAvailable==1){
		# all reports are available
		print "OK\n";
	}else{
		print "#late!\n$content\n";
		dw3_sendMail($mailaddress,$title,$content);
		#dw3_sendMail_fromVerve($mailaddress,$title,$content);
	}
} 

sub admNetworkDatamart{
	my $checkType=shift;
	#my $date=$h_report_date{'month'}.$h_report_date{'day'}.$h_report_date{'year'};
	my $title="[ADM network datamart transfer] failed -- $process_date";
	my $time=getTime();
	my $content="ADM network transfer datamart failed.  Please contact ADM team.<p/>";
	my $status='';
	my $transfer_adm_dims_to_datamart='';
	my $transfer_network_fct_performance='';
	my $replace_network_fct_performance='';
	my $transfer_network_fct_performance_requests='';
	my $daily_adm_data_feed_available=0;
	my $isLate=0;
	
	my $dbh = getConnection();
		
	#Check transfer network fct performance to datamart
	my $query="SELECT process_status FROM control.process WHERE dt_process_queued::date = '$process_date' AND process_config_id=34";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	$query_handle->bind_columns(undef, \$process_status);	
	while($query_handle->fetch()) {
		$transfer_network_fct_performance=$process_status;
	} 	
		if($transfer_network_fct_performance eq ''){
			$content=$content."transfer network fct peformance to datamart: waiting<br/>";
			$isLate=1;
		}elsif($transfer_network_fct_performance eq 'PS'){
			$content=$content."transfer network fct peformance to datamart: processing<br/>";
			$isLate=1;
		}elsif($transfer_network_fct_performance eq 'SU'){
			$content=$content."transfer network fct peformance to datamart: completed<br/>";
		}
	
	#Check replace network fct performance on datamart
##	my $query="SELECT process_status FROM control.process WHERE dt_process_queued::date = '$process_date' AND process_config_id=48";
##	my $query_handle = $dbh->prepare($query);
##	$query_handle->execute();
##	$query_handle->bind_columns(undef, \$process_status);
##	while($query_handle->fetch()) {
##		$replace_network_fct_performance=$process_status;
##	} 
##		if($replace_network_fct_performance eq ''){
##			$content=$content."replace network fct peformance to datamart: waiting<br/>";
##			$isLate=1;
##		}elsif($replace_network_fct_performance eq 'PS'){
##			$content=$content."replace network fct peformance to datamart: processing<br/>";
##			$isLate=1;
##		}elsif($replace_network_fct_performance eq 'SU'){
##			$content=$content."replace network fct peformance to datamart: completed<br/>";
##		}
	
	#Check transfer network fct performance requests to datamart
##	my $query="SELECT process_status FROM control.process WHERE dt_process_queued::date = '$process_date' AND process_config_id=49";
##	my $query_handle = $dbh->prepare($query);
##	$query_handle->execute();
##	$query_handle->bind_columns(undef, \$process_status);
##	while($query_handle->fetch()) {
##		$transfer_network_fct_performance_requests=$process_status;
##	}
##		if($transfer_network_fct_performance_requests eq ''){
##			$content=$content."transfer network fct performance requests to datamart: waiting<br/>";
##			$isLate=1;
##		}elsif($transfer_network_fct_performance_requests eq 'PS'){
##			$content=$content."transfer network fct performance requests to datamart: processing<br/>";
##			$isLate=1;
##		}elsif($transfer_network_fct_performance_requests eq 'SU'){
##			$content=$content."transfer network fct performance requests to datamart: completed<br/>";
##		}
		
	#check adm_data_feed data available
	my $query="SELECT COUNT(*) as count  FROM adm.daily_agg_adm_data_feed WHERE is_active=true AND full_date = '$report_date'";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	$query_handle->bind_columns(undef, \$count);
	while($query_handle->fetch()) {
		if($count>0){
			$daily_adm_data_feed_available=1;
		}
	} 		

	#Check transfer adm data feed to datamart
	my $query="SELECT process_status FROM control.process WHERE dt_process_queued::date = '$process_date' AND process_config_id=19";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	$query_handle->bind_columns(undef, \$process_status);			
	while($query_handle->fetch()) {
		$status=$process_status;
	} 
		if($status eq ''){
			$content=$content."transfer adm data feed to datamart: waiting<br/>";
			$isLate=1;		
		}elsif($status eq 'PS'){
			$content=$content."transfer adm data feed to datamart: processing<br/>";
			$isLate=1;
		}elsif($status eq 'SU' && $daily_adm_data_feed_available==0){
			$content=$content."transfer adm data feed to datamart: Transfer sucessfull but count data = 0<br/>";
			$isLate=1;	
		}else{
			$content=$content."transfer adm data feed to datamart: completed<br/>";
		}
		
	#Check transfer adm dims to datamart
	my $query="SELECT process_status FROM control.process WHERE dt_process_queued::date = '$process_date' AND process_config_id=33";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	$query_handle->bind_columns(undef, \$process_status);			
	while($query_handle->fetch()) {
		$transfer_adm_dims_to_datamart=$process_status;
	} 
		if($transfer_adm_dims_to_datamart eq ''){
			$content=$content."transfer adm dims to datamart: waiting<br/>";
			$isLate=1;		
		}elsif($transfer_adm_dims_to_datamart eq 'PS'){
			$content=$content."transfer adm dims to datamart: processing<br/>";
			$isLate=1;
		}elsif($transfer_adm_dims_to_datamart eq 'SU'){
			$content=$content."transfer adm dims datamart: completed<br/>";
		}
	#disconnect database	
	my $rv = $dbh->disconnect;
	
	my $time=getTime();
	$content=$content."<p/>Status updated at: $time PST time<br/>Send by auto.";
	
	print "#Check type: $checkType\n";
	if($checkType eq 'isOk'){	
		if($isLate==0){
			$title="[ADM network datamart transfer] Successful -- $process_date";
			$content="Remnant networks are transfered to datamart:<p/>";
			#Load remnant network transfered to datamart
			my $dbh = getConnection();
			my $query="SELECT a.process_config_id,b.process_config_description FROM control.process a
						LEFT JOIN control.process_configuration b ON b.process_config_id=a.process_config_id
						WHERE a.process_config_id IN (43,39,40,42,35,37,36,38,41)
						AND a.process_status=?
						AND a.dt_process_queued::date=?
						AND a.dt_process_completed < (SELECT dt_process_queued FROM control.process WHERE process_config_id=28 AND dt_process_queued::date=?)
						GROUP BY a.process_config_id,b.process_config_description
						ORDER BY process_config_id";
			my $query_handle = $dbh->prepare($query);
			$query_handle->execute('SU',$process_date,$process_date);
			$query_handle->bind_columns(undef, \$process_config_id,\$process_config_description);
			while($query_handle->fetch()) {
				if($process_config_id==43){
					$content=$content."- AdSense DBCLK Channel<br/>";
				}
				if($process_config_id==39){
					$content=$content."- Superpages Prpoxy/Blue<br/>";
				}
				if($process_config_id==40){
					$content=$content."- Millennial Media<br/>";
				}
				if($process_config_id==42){
					$content=$content."- iTunes<br/>";
				}
				if($process_config_id==35){
					$content=$content."- JumpTap<br/>";
				}
				if($process_config_id==37){
					$content=$content."- Marchex/Marchex Proxy<br/>";
				}
				if($process_config_id==36){
					$content=$content."- Where/Where HTML<br/>";
				}
				if($process_config_id==38){
					$content=$content."- AT&T Static Banner Yellowpages <br/>";
					$content=$content."- AT&T static no logo <br/>";
					$content=$content."- AT&T Yellowpages <br/>";
				}
				if($process_config_id==41){
					$content=$content."- City Grid/City Grid Proxy <br/>";
				}
			} 
			
			#get total_net_revenue và total_paid_impresions trong adm.daily_fct_performance_channel
			$query="SELECT sum(a.revenue) as total_net_revenue,sum(a.impressions) as total_paid_impressions,b.\"name\" as network_name FROM adm.daily_network_fct_channel a,refer.adm_network_dim b
			WHERE a.full_date = ? AND a.is_active=true AND a.network_id IN (1,2,3) AND a.network_id=b.network_id GROUP BY a.network_id,network_name
			ORDER BY a.network_id";
			my $query_handle = $dbh->prepare($query);
			$query_handle->execute($report_date);
			$query_handle->bind_columns(undef, \$total_net_revenue,\$total_paid_impressions,\$network_name);
			while($query_handle->fetch()) {
				$content=$content."<p /> Total net revenue in $network_name: $total_net_revenue
				<br />Total paid impressions in $network_name: $total_paid_impressions";
			}
		
			my $rv = $dbh->disconnect;	
			
			#get revenue và impresions trong network.fct_performance_wip
			my $dbh = getConnectionWIP();

			$query="SELECT sum(revenue) as revenue,sum(impressions) as impressions FROM network.fct_performance_wip WHERE period=(SELECT period FROM dim_dates WHERE calendar_date=?)";
			my $query_handle = $dbh->prepare($query);
			$query_handle->execute($report_date);
			$query_handle->bind_columns(undef, \$revenue,\$impressions);
			while($query_handle->fetch()) {
				$content=$content."<p /> Total net revenue in fct_performance_wip: $revenue
				<br />Total paid impressions in fct_performance_wip: $impressions";
			}
			my $rv = $dbh->disconnect;
			
			$content=$content."<p/>ADM network transfer redo attempt: successful<p/>Status updated at: $time PST time<br/>Send by auto.";
			print $content."\n";
			dw3_sendMail($mailaddress,$title,$content);
			return 1;
		}else{
			print "no Ok\n";
			return 0;
		}
	}
	if($checkType eq 'isLate'){
		if($isLate==1){
			print "#late!\n$content\n";
			dw3_sendMail($mailaddress,$title,$content);
			return 1;
		}else{
			print "no Late\n";
			return 0;
		}
	}
}

sub adNetworkNotification{
	#my $date=$h_report_date{'month'}.$h_report_date{'day'}.$h_report_date{'year'};
	my $time=getTime();
	my $title="[Remnant Missing data] Revenue Perfomance -- $process_date";
	my $content="Missing Revenue Performance Report,<p/>Missing Revenue Performance report from following Ad networks:<p/>";
	
	my $cg_available=0;
	my $mx_available=0;
	my $jt_available=0;
	my $kt_available=0;
	my $it_available=0;
	my $wh_available=0;
	my $adsense_dbclk_channel_available=0;
	my $yp_sb_available=0;
	my $yp_available=0;
	my $yp_no_available=0;
	my $sp_blue_available=0;
	my $mm_available=0;
	
	my $late=0;
	
	#Create connection to dw0
	my $dbh = getConnectionDw0();
	
	#City Grid/City Grid Proxy (20,29)
	my $query="SELECT COUNT(*) as count  FROM adnetwork.daily_cg_performance WHERE is_active=true AND full_date = '$report_date'";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	$query_handle->bind_columns(undef, \$count);
	while($query_handle->fetch()) {
		if($count>0){$cg_available=1;}
	} 
	#check it is active
	my $is_active=checkAdnetworkIsActive(20);
	my $is_active2=checkAdnetworkIsActive(29);
	if($is_active == 0 && $is_active2==0){
		$is_active=0;
	}else{
		$is_active=1;
	}
	if($cg_available==0 && $is_active==1){
		$content=$content."- City Grid/City Grid Proxy (20,29)<br/>";
		$late=1;
	}
	#Marchex/Marchex Proxy (21,28)
	my $query="SELECT COUNT(*) as count  FROM adnetwork.daily_mx_performance WHERE is_active=true AND full_date = '$report_date'";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	$query_handle->bind_columns(undef, \$count);
	while($query_handle->fetch()) {
		if($count>0){$mx_available=1;}
	}
	#check it is active
	my $is_active=checkAdnetworkIsActive(21);
	my $is_active2=checkAdnetworkIsActive(28);
	if($is_active == 0 && $is_active2==0){
		$is_active=0;
	}else{
		$is_active=1;
	}
	if($mx_available==0 && $is_active==1){
		$content=$content."- Marchex/Marchex Proxy (21,28)<br/>";
		$late=1;
	}
	#JumpTap (11)
	my $query="SELECT COUNT(*) as count  FROM adnetwork.daily_jt_performance WHERE is_active=true AND full_date = '$report_date'";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	$query_handle->bind_columns(undef, \$count);
	while($query_handle->fetch()) {
		if($count>0){$jt_available=1;}
	}
	#check it is active
	my $is_active=checkAdnetworkIsActive(11);
	if($jt_available==0 && $is_active==1){
		$content=$content."- JumpTap (11)<br/>";
		$late=1;
	}
	#KlickThru (35)
	my $query="SELECT COUNT(*) as count  FROM adnetwork.daily_kt_performance WHERE is_active=true AND full_date = '$report_date'";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	$query_handle->bind_columns(undef, \$count);
	while($query_handle->fetch()) {
		if($count>0){$kt_available=1;}
	}
	#check it is active
	my $is_active=checkAdnetworkIsActive(35);
	if($kt_available==0 && $is_active==1){
		$content=$content."- KlickThru (35)<br/>";
		$late=1;
	}
	#iTunes (-102)
	my $query="SELECT COUNT(*) as count  FROM adnetwork.daily_it_performance WHERE is_active=true AND full_date = '$report_date'";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	$query_handle->bind_columns(undef, \$count);
	while($query_handle->fetch()) {
		if($count>0){$it_available=1;}
	}
	if($it_available==0){
		$content=$content."- iTunes (-102)<br/>";
		$late=1;
	}
	#Where/Where HTML (23,25)
	my $query="SELECT COUNT(*) as count  FROM adnetwork.daily_wh_performance WHERE is_active=true AND full_date = '$report_date'";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	$query_handle->bind_columns(undef, \$count);
	while($query_handle->fetch()) {
		if($count>0){$wh_available=1;}
	}
	#check it is active
	my $is_active=checkAdnetworkIsActive(23);
	my $is_active2=checkAdnetworkIsActive(25);
	if($is_active == 0 && $is_active2==0){
		$is_active=0;
	}else{
		$is_active=1;
	}
	if($wh_available==0 && $is_active==1){
		$content=$content."- Where/Where HTML (23,25)<br/>";
		$late=1;
	}
	#AdSense DBCLK Channel (-101)
	my $query="SELECT COUNT(*) as count  FROM adnetwork.daily_adsense_dbclk_channel WHERE is_active=true AND full_date = '$report_date'";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	$query_handle->bind_columns(undef, \$count);
	while($query_handle->fetch()) {
		if($count>0){$adsense_dbclk_channel_available=1;}
	}
	##hard code no send it
	$adsense_dbclk_channel_available=1;
	if($adsense_dbclk_channel_available==0){
		$content=$content."- AdSense DBCLK Channel (-101)<br/>";
		$late=1;
	}
	#AT&T Static Banner Yellowpages (32)
	my $query="SELECT COUNT(*) as count  FROM adnetwork.daily_yp_sb_performance WHERE is_active=true AND full_date = '$report_date'";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	$query_handle->bind_columns(undef, \$count);
	while($query_handle->fetch()) {
		if($count>0){$yp_sb_available=1;}
	}
	#check it is active
	my $is_active=checkAdnetworkIsActive(32);	
	if($yp_sb_available==0 && $is_active==1){
		$content=$content."- AT&T Static Banner Yellowpages (32)<br/>";
		$late=1;
	}
	#AT&T Yellowpages (27)
	my $query="SELECT COUNT(*) as count  FROM adnetwork.daily_yp_performance WHERE is_active=true AND full_date = '$report_date'";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	$query_handle->bind_columns(undef, \$count);
	while($query_handle->fetch()) {
		if($count>0){$yp_available=1;}
	}
	#check it is active
	my $is_active=checkAdnetworkIsActive(27);
	if($yp_available==0 && $is_active==1){
		$content=$content."- AT&T Yellowpages (27)<br/>";
		$late=1;
	}
	#AT&T No Logo(Yellowpages)(33)
	my $query="SELECT COUNT(*) as count  FROM adnetwork.daily_yp_no_performance WHERE is_active=true AND full_date = '$report_date'";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	$query_handle->bind_columns(undef, \$count);
	while($query_handle->fetch()) {
		if($count>0){$yp_no_available=1;}
	}
	#check it is active
	my $is_active=checkAdnetworkIsActive(33);
	if($yp_no_available==0 && $is_active==1){
		$content=$content."- AT&T No Logo(Yellowpages)(33)<br/>";
		$late=1;
	}
	#Superpages Prpoxy/Blue (30,26)
	my $query="SELECT COUNT(*) as count  FROM adnetwork.daily_sp_blue_performance WHERE is_active=true AND full_date = '$report_date'";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	$query_handle->bind_columns(undef, \$count);
	while($query_handle->fetch()) {
		if($count>0){$sp_blue_available=1;}
	}
	#check it is active
	my $is_active=checkAdnetworkIsActive(30);
	my $is_active2=checkAdnetworkIsActive(26);
	if($is_active == 0 && $is_active2==0){
		$is_active=0;
	}else{
		$is_active=1;
	}
	if($sp_blue_available==0 && $is_active==1){
		$content=$content."- Superpages Prpoxy/Blue (30,26)<br/>";
		$late=1;
	}
	#Millennial Media (4)
	my $query="SELECT COUNT(*) as count  FROM adnetwork.daily_mm_performance WHERE is_active=true AND full_date = '$report_date'";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	$query_handle->bind_columns(undef, \$count);
	while($query_handle->fetch()) {
		if($count>0){$mm_available=1;}
	}
	#check it is active
	my $is_active=checkAdnetworkIsActive(4);
	if($mm_available==0 && $is_active==1){
		$content=$content."- Millennial Media (4)<br/>";
		$late=1;
	}
	#disconnect database	
	my $rv = $dbh->disconnect;			
	
	$content=$content."<p/>Status Check at: $time PST time<br/>Send by auto.";
	if($late==1){
		print "#late!\n$content\n";
		dw3_sendMail($mailaddress,$title,$content);
	}else{
		print "OK\n";
	}
}

sub checkAdnetworkIsActive{
	my $result=0;
	my $ad_network_id=shift;
	#Create connection to dw0
	my $dbh = getConnection();
	my $query="SELECT is_active FROM refer.ad_network_dim WHERE dt_expire='9999-12-31' AND ad_network_id= $ad_network_id";
	my $query_handle = $dbh->prepare($query);
	$query_handle->execute();
	$query_handle->bind_columns(undef, \$is_active);
	while($query_handle->fetch()) {
		$result=$is_active;
	} 	
	#disconnect database	
	my $rv = $dbh->disconnect;	
	return $result;
}