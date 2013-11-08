require "../bin/dw3_utils.pl";
require "config.pl";
%h_report_date=dw3_yesterday();
%h_process_date=dw3_currentDate();
$process_date=$h_process_date{'year'}.'-'.$h_process_date{'month'}.'-'.$h_process_date{'day'};	#the date run process
$report_date=$h_report_date{'year'}.'_'.$h_report_date{'month'}.'_'.$h_report_date{'day'};	#the report date

$group_process_name="Double Click";	#the name of group process to register to daily process status table

$locatefd="/opt/temp/autoscripts/double_click";	#the location content this script
$logFile="$locatefd/logs/$report_date.txt";	#the location cotent log file
my $emailErrorTitle="[Error!][Daily Double Click report][$report_date]";	#the email title used when send a mail error 
my $emailAvailableTitle="[Notification!][Daily Double Click report][$report_date]";	#the email title used when send a mail
my $mailto="tho.hoang\@ecepvn.org,ops\@ecepvn.org";	#List mail addresses
my @aggTableDw3=();


#system("cd /opt/temp/autoscripts/transformer && perl main.pl daily $master_host $master_report_host adsops.daily_agg_delivery_advertiser $report_date dbclkAutodaily.pl");	
#transferAllData();	
main();


sub main{
	#register sub process to control.daily_process_status table.
	register_process($process_date,$group_process_name,15,'09:40:00','08:00:00');
	register_process($process_date,$group_process_name,19,'07:10:00','09:15:00');
	register_process($process_date,$group_process_name,14,'07:10:00','09:20:00');
	#Check file logs
	my $error=checkSU();
	checkDim();
	if($error == 0){
		my $time=getTime();
		dw3_sendMail($mailto,$emailAvailableTitle,"Dear all,<p />$time# Files extract completed.<p />Thanks,<br />\-\-\-send by auto mail.");
		#run param15;
		runParam(15);		
		dw3_writelog($logFile,"Run function param 15");		
		#check param15
		checkParam(15,10);	
		#promote adm data feed		
		promote(15);
		
		#run param20 fn_promote_monthly_doubleclick_forecast;
		#runParam(20);
		#dw3_writelog($logFile,"Run function param 20");		
		#check param20
		#checkParam(20,1);	
		#promote adm data feed
		#runParam(-20);
		#dw3_writelog($logFile,"Promote monthly doubleclick forecast report");
		
		#transfer adm data feed to datamart
		runParam(19);
		dw3_writelog($logFile,"transfer adm data feed to datamart");
		
		#run param14;
		runParam(14);
		dw3_writelog($logFile,"Run function param 14");
				
		#check param14
		checkParam(14,13);
		promote(14);
		
		#transfer all data of adm and double click to dw0
		transferAllData();
		
		dw3_sendMail($mailto,$emailAvailableTitle,"Dear all,<p />Daily double click $report_date has finished with no error.<p />Process detail:<p/>$log<p />Thanks,<br />\-\-\-send by auto mail.");
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
			$query_handle->execute("%Site_Campaign_$report_date%");
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
		$query="SELECT file_name,file_status,staging_load_count,fact_table_load_count FROM control.data_file WHERE file_name LIKE ? or file_name like ? or file_name like ?";
		$query_handle = $dbh->prepare($query);
		$query_handle->execute("%Site_Campaign_$report_date%","%Site_Device_$report_date%","%Site_Order_Forecast_$report_date%");
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
			Daily Double click report $report_date on dw3 begin start with total files today is $totalFiles and now Su files is $SU file.<p />
			<p />Thanks,<br />\-\-\-send by auto mail.");
			}else{
			dw3_sendMail($mailto,$emailAvailableTitle,
			"Dear all,<p />
			Daily Double click report $report_date on dw3 begin start with total files today is $totalFiles and now Su files is $SU file.<p />Thanks,<br />\-\-\-send by auto mail.");
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
	my $numOfDim=10;
	my $countDim=0;
	while($countDim<$numOfDim){
		my $dbh = getConnection();
		my $query="SELECT MIN(current_up_to) as min_current_up_to, COUNT ( * ) as count_dim
				FROM control.data_current_up_to_date
				WHERE table_name IN (
				'dc_site_dim'
				,'dc_order_dim'
				,'adm_website_dim'
				,'adm_creative_dim'
				,'adm_publisher_dim'
				,'adm_placement_dim'
				,'adm_advertiser_dim'
				,'adm_flight_dim'
				,'adm_organization_dim'
				,'adm_order_dim'
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
					where table_name in ('adm_advertiser_dim'
					,'adm_creative_dim'
					,'adm_flight_dim'
					,'adm_order_dim'
					,'adm_organization_dim'
					,'adm_placement_dim'
					,'adm_publisher_dim'
					,'adm_website_dim'
					,'dc_order_dim'
					,'dc_site_dim'
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
	if($param==14){
		#promote daily cumulative
		runParam(-14);
		dw3_writelog($logFile,"Promoted daily double click report");
		
	}elsif($param=15){
		runParam(-15);
		dw3_writelog($logFile,"Promoted daily adm data feed report");
		#tranfer data to dw0
		system("cd /opt/temp/autoscripts/transformer && perl main.pl daily $master_host $master_report_host adsops.daily_agg_delivery_advertiser $report_date dbclkAutodaily.pl");		
	}elsif($param=19){
	}elsif($param=33){
	}
}

sub transferAllData{
	system("cd /opt/temp/autoscripts/transformer && perl main.pl daily $master_host $master_report_host adm.daily_network_fct_request $report_date dbclkAutodaily.pl");	
	system("cd /opt/temp/autoscripts/transformer && perl main.pl daily $master_host $master_report_host adm.daily_network_fct_channel $report_date dbclkAutodaily.pl");	
	system("cd /opt/temp/autoscripts/transformer && perl main.pl daily $master_host $master_report_host adm.daily_agg_network_performance $report_date dbclkAutodaily.pl");	
	system("cd /opt/temp/autoscripts/transformer && perl main.pl daily $master_host $master_report_host adm.daily_agg_order_flight $report_date dbclkAutodaily.pl");	
	system("cd /opt/temp/autoscripts/transformer && perl main.pl daily $master_host $master_report_host adm.daily_agg_revenue_by_order_yesterday $report_date dbclkAutodaily.pl");	
	system("cd /opt/temp/autoscripts/transformer && perl main.pl daily $master_host $master_report_host adm.daily_network_fct_performance $report_date dbclkAutodaily.pl");	
	system("cd /opt/temp/autoscripts/transformer && perl main.pl daily $master_host $master_report_host adm.daily_network_fct_performance_by_portal $report_date dbclkAutodaily.pl");	
	system("cd /opt/temp/autoscripts/transformer && perl main.pl daily $master_host $master_report_host adm.daily_agg_revenue_by_publisher $report_date dbclkAutodaily.pl");	
	system("cd /opt/temp/autoscripts/transformer && perl main.pl daily $master_host $master_report_host adm.daily_agg_order_atc $report_date dbclkAutodaily.pl");	
	system("cd /opt/temp/autoscripts/transformer && perl main.pl daily $master_host $master_report_host adm.daily_agg_revenue_by_order $report_date dbclkAutodaily.pl");	
	system("cd /opt/temp/autoscripts/transformer && perl main.pl daily $master_host $master_report_host adm.daily_agg_publisher_website_partner $report_date dbclkAutodaily.pl");	
	system("cd /opt/temp/autoscripts/transformer && perl main.pl daily $master_host $master_report_host adm.daily_agg_local_revenue $report_date dbclkAutodaily.pl");	
	system("cd /opt/temp/autoscripts/transformer && perl main.pl daily $master_host $master_report_host adm.daily_agg_order_placement_creative_flight $report_date dbclkAutodaily.pl");	
	system("cd /opt/temp/autoscripts/transformer && perl main.pl daily $master_host $master_report_host adm.daily_agg_adm_data_feed $report_date dbclkAutodaily.pl");	
	system("cd /opt/temp/autoscripts/transformer && perl main.pl daily $master_host $master_report_host dbclk.daily_agg_site_campaign_day $report_date dbclkAutodaily.pl");	
	system("cd /opt/temp/autoscripts/transformer && perl main.pl daily $master_host $master_report_host dbclk.daily_agg_site_day $report_date dbclkAutodaily.pl");	
	system("cd /opt/temp/autoscripts/transformer && perl main.pl daily $master_host $master_report_host dbclk.daily_agg_site_order $report_date dbclkAutodaily.pl");	
	system("cd /opt/temp/autoscripts/transformer && perl main.pl daily $master_host $master_report_host dbclk.daily_agg_publishers_day $report_date dbclkAutodaily.pl");	

}
