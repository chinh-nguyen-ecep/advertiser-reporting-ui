$host='dw3';
$master_host='dw3';
$master_report_host='dw10';
$today_date; # report date 2012-07-04
$report_date='';
$report_date_sk='';
$transfer_by='adcelAutoDaily.pl';

$locatefd="/opt/temp/autoscripts/adcel";	#the location content this script
$logFile="$locatefd/logs/$report_date.txt";	#the location cotent log file
$emailErrorTitle="[Error!][Daily Adcel report][$report_date]";	#the email title used when send a mail error 
$emailAvailableTitle="[Notification!][Daily Adcel report][$report_date]";	#the email title used when send a mail
$mailto="tho.hoang\@ecepvn.org,ops\@ecepvn.org";	#List mail 


return 1;
exit;