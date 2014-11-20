require "../bin/dw3_utils.pl";
%h_report_date=dw3_yesterday();
%h_process_date=dw3_currentDate();
$process_date=$h_process_date{'year'}.'-'.$h_process_date{'month'}.'-'.$h_process_date{'day'};	#the date run process
$report_date=$h_report_date{'year'}.'_'.$h_report_date{'month'}.'_'.$h_report_date{'day'};	#the report date

$group_process_name="ADM-DFP";	#the name of group process to register to daily process status table

$locatefd="/opt/temp/autoscripts/double_click";	#the location content this script
$logFile="$locatefd/logs/ADM-DFP.$report_date.txt";	#the location cotent log file
my $emailErrorTitle="[Error!][Daily ADM-DFP report][$report_date]";	#the email title used when send a mail error 
my $emailAvailableTitle="[Notification!][Daily ADM-DFP report][$report_date]";	#the email title used when send a mail
my $mailto="tho.hoang\@ecepvn.org,ops\@ecepvn.org";	#List mail addresses
my @aggTableDw3=();
my $master_host='dw3';
my $master_report_host='dw10';
#register sub process to control.daily_process_status table.
register_process($process_date,$group_process_name,69,'07:10:00','09:15:00');
register_process($process_date,$group_process_name,33,'07:10:00','09:15:00');
register_process($process_date,$group_process_name,70,'07:10:00','09:15:00');


main();

sub main{

	#Check file logs
	my $error=checkSU();
	checkDim();
	##$error=0;
	if($error == 0){
		my $time=getTime();
		dw3_sendMail($mailto,$emailAvailableTitle,"Dear all,<p />$time# Files extract completed.<p />Thanks,<br />\-\-\-send by auto mail.");
		#run param 69;
		runParam(69);		
		dw3_writelog($logFile,"Run function param 69");		
		#check param 69
		checkParam(69,6);	
		#promote adm data feed		
		promote(69);
		#run param 33
		runParam(33);		
		#run param 70
		runParam(70);		
		dw3_writelog($logFile,"Run function param 70");		
		#check param 70
		checkParam(70,5);	
		#promote adm data feed		
		promote(70);
		
		dw3_sendMail($mailto,$emailAvailableTitle,"Dear all,<p />Daily ADM-DFP $report_date has finished with no error.<p />Process detail:<p/>$log<p />Thanks,<br />\-\-\-send by auto mail.");
		dw3_writelog($logFile,"Process finished");
	}else{
		printTime("Stop with error");
		dw3_sendMail($mailto,$emailErrorTitle,"Dear all,<p />Daily report $report_date is stop with error.<p />Thanks,<br />\-\-\-send by auto mail.");
	}

}

#
# This function will check file log.
#
sub checkSU{
	my $sendalertmail=0;
	my $repeat="y";
	my $totalFiles=0;
	my $listLogFileName="";
	my $sentmail="";
	while($repeat eq "y"){
		my $SU=0;
		my $finish=fasle;
		my $error=0;
		my $dbh="";
		my $query="";
		my $query_handle="";
		#Create connection
		my $dbh = getConnection();		   
		
		#get total file
		while($totalFiles<1){
			
			#Cretae String query		
			my $query=" select count (*) AS Total_Files from control.data_file where file_name like ?;";
			my $query_handle = $dbh->prepare($query);
			$query_handle->execute("%dfp_fct_line_items_$report_date%");
			$query_handle->bind_columns(undef,\$Total_Files);
			
			# LOOP THROUGH RESULTS
			while($query_handle->fetch()) {
			   $totalFiles=	$Total_Files;	   
			} 
			if($totalFiles==0){
				printTime("No file!");
			}
			if($totalFiles<1){
				sleep(300);
			}
		}
		
		#Check process status
		
		#Checking extraction status
		$query="SELECT file_name,file_status,staging_load_count,fact_table_load_count FROM control.data_file where file_name like ?;";
		$query_handle = $dbh->prepare($query);
		$query_handle->execute("%dfp_fct_line_items_$report_date%");
		$query_handle->bind_columns(undef, \$file_name,\$file_status,\$staging_load_count,\$fact_table_load_count);
		while($query_handle->fetch()) {		   
		   if($file_status eq 'SU' && $staging_load_count>0 && $fact_table_load_count>0){
				$SU++;
		   }elsif ($file_status eq 'SU'){
				if($staging_load_count==0 || $fact_table_load_count==0){
					$error++;
					my $errorfile=$file_name;
					#send mail error					
					if(index($sentmail,$errorfile)==-1){
						dw3_sendMail($mailto,$emailErrorTitle,"Dear all,<p />Extract log files is error at $errorfile file. Load count = 0.<p />Thanks,<br />-\-\- send by automail.");
						$sentmail=$sentmail.",$errorfile";
					}	
				}				
		   }elsif($file_status eq 'EF'){
				$error++;
				my $errorfile=$file_name;
					#send mail error					
					if(index($sentmail,$errorfile)==-1){
						dw3_sendMail($mailto,$emailErrorTitle,"Dear all,<p />Extract log files is error at $errorfile file. File status is EF<p />Thanks,<br />-\-\- send by automail.");
						$sentmail=$sentmail.",$errorfile";
					}					
		   }	   
		} 
		printTime("Total files: $totalFiles \t SU : $SU \t Error: $error");
		#gui mail dau tien bao bat dau chay auto daily. Chi gui mail nay 1 lan khi bat dau chay
		if($sendalertmail==0){
			$sendalertmail++;
			
			if($SU!=$totalFiles){
			dw3_sendMail($mailto,$emailAvailableTitle,
			"Dear all,<p />
			Daily ADM-DFP report $report_date on dw3 begin start with total files today is $totalFiles and now Su files is $SU file.<p />
			<p />Thanks,<br />\-\-\-send by auto mail.");
			}else{
			dw3_sendMail($mailto,$emailAvailableTitle,
			"Dear all,<p />
			Daily ADM-DFP report $report_date on dw3 begin start with total files today is $totalFiles and now Su files is $SU file.<p />Thanks,<br />\-\-\-send by auto mail.");
			};
		}
		
		#disconnect database
		my $rv = $dbh->disconnect;
		#Check process status
		if($SU==$totalFiles && $error==0){
			$finish=true;
		}elsif($SU<$totalFiles && $error==0){
			printTime("Process is runing");
		}elsif($error>0){
			printTime("Process error with these file: $sentmail");
		}else{
			printTime("xxxx");
		}
		
		printTime("Checked");
		#Check MAIN LOOP
		if($finish eq true){
			$repeat="n";
			dw3_writelog($logFile,"Extract $totalFiles file finished");
		}else{
			#Stop script in 15 min
			sleep(300);
		};		
	}
	return $error;
}

sub checkDim{
	my $numOfDim=16;
	my $countDim=0;
	while($countDim<$numOfDim){
		my $dbh = getConnection();
		my $query="SELECT MIN(current_up_to) as min_current_up_to, COUNT ( * ) as count_dim
				FROM control.data_current_up_to_date
				WHERE table_name IN (
				'adm_dim_adsizes'
				,'adm_dim_organizations'
				,'adm_dim_publishers'
				,'adm_dim_advertisers'
				,'adm_dim_propertygroups'
				,'adm_dim_platforms'
				,'adm_dim_portals'
				,'adm_dim_properties'
				,'adm_dim_orders'
				,'adm_dim_flights'
				,'adm_dim_creatives'
				,'dfp_dim_placements'
				,'dfp_dim_ad_units'
				,'dfp_dim_line_items'
				,'dfp_dim_creatives'
				,'dfp_dim_orders'
				)";
		my $query_handle = $dbh->prepare($query);
		$query_handle->execute();
		$query_handle->bind_columns(undef, \$min_current_up_to,\$count_dim);		
		
		# LOOP THROUGH RESULTS
		while($query_handle->fetch()) {
		   $countDim=$count_dim;
		}
		
		if($countDim<$numOfDim){
			dw3_writelog($logFile,"One or more dimension tables is missing from control.data_current_up_to_date.\n");
			
			$query="select table_name, current_up_to from control.data_current_up_to_date
					where table_name in (
					'adm_dim_adsizes'
					,'adm_dim_organizations'
					,'adm_dim_publishers'
					,'adm_dim_advertisers'
					,'adm_dim_propertygroups'
					,'adm_dim_platforms'
					,'adm_dim_portals'
					,'adm_dim_properties'
					,'adm_dim_orders'
					,'adm_dim_flights'
					,'adm_dim_creatives'
					,'dfp_dim_placements'
					,'dfp_dim_ad_units'
					,'dfp_dim_line_items'
					,'dfp_dim_creatives'
					,'dfp_dim_orders'
					)";
			$query_handle = $dbh->prepare($query);
			$query_handle->execute();
			$query_handle->bind_columns(undef, \$table_name,\$current_up_to);		
			
			my $mailMessage="<table border=1 cellpadding=0>
			<thead>
				<tr>
				<th width=130>Table name</th>
				<th width=300>Current up to</th>
				</tr>
			</thead>
			<tbody>";
			
			# LOOP THROUGH RESULTS
			while($query_handle->fetch()) {
			   $mailMessage=$mailMessage."<tr><td>$table_name</td><td>$current_up_to</td></tr>";
			}
			$mailMessage=$mailMessage."</tbody></table>";
			#send note maill
			sendDimMail("One or more dimension tables is missing from control.data_current_up_to_date",$mailMessage);
			my $rv = $dbh->disconnect;
			sleep(300);
		}else{
			my $rv = $dbh->disconnect;
		}		
	}	
}


sub sendDimMail{
#$mailaddress="chinh.nguyen\@ecepvn.org,binh.nguyen\@ecepvn.org,song.nguyen\@ecepvn.org,tho.hoang\@ecepvn.org";
my $mailaddress="dw-vndev\@ecepvn.org";
my $title=shift;
my $content=shift;

my $callFunction = "java -jar $binfd/mail.jar \"$mailaddress\" \"$title\" \"$content\"";
system($callFunction);
}

sub promote{
	my $param=shift;
	print "promoting $param \n";
	if($param==69){
		runPGFuntion('staging.fn_promote_daily_adm_dfp_report');
		dw3_writelog($logFile,"Promoted daily adm dfp report");
		#tranfer data to dw0
		#@aggTableDw3=();
		#push(@aggTableDw3,"adsops.daily_agg_delivery_advertiser");
		#copyAggDataToDw0($report_date,@aggTableDw3);
	}elsif($param==70){
		runPGFuntion('staging.fn_promote_daily_adm_dfp_network_revenue');
		dw3_writelog($logFile,"Promoted daily adm dfp network revenue");
		transferAdsopsAggregate();
	}
}

sub transferAdsopsAggregate{
	#
	%h_report_date1=dw3_yesterday();
	%h_report_date7=dw3_getDate(-7);
	$report_date1=$h_report_date1{'year'}.'-'.$h_report_date1{'month'}.'-'.$h_report_date1{'day'};	#the report date 2012-02-02
	$report_date7=$h_report_date7{'year'}.'-'.$h_report_date7{'month'}.'-'.$h_report_date7{'day'};	#the report date 2012-02-02		

	#tranfer data to dw10
	system("cd /home/file_xfer/bin/databaseTransferFlowerMode/ && perl transferNoTracking.pl daily $master_host dw0,dw10,dw6 adsops.daily_agg_low_rate $report_date1");
	system("cd /home/file_xfer/bin/databaseTransferFlowerMode/ && perl transferNoTracking.pl daily $master_host dw0,dw10,dw6 adsops.daily_agg_local_zero_delivered_v1 $report_date1");
	system("cd /home/file_xfer/bin/databaseTransferFlowerMode/ && perl transferNoTracking.pl date_range $master_host dw0,dw10,dw6 adsops.daily_agg_delivery_advertiser_beta $report_date7 $report_date1");	

	system("cd /opt/temp/autoscripts/transformer && perl main.pl table $master_host $master_report_host adsops.daily_agg_io_line_item_report_map_stag admDfpAutodaily.pl");
	system("cd /opt/temp/autoscripts/transformer && perl main.pl table $master_host $master_report_host adsops.daily_agg_national_delivery_watch admDfpAutodaily.pl");
}


