$main_host='dw3';
$transfer_to_host='dw10';
%h_process_date=dw3_currentDate();
$process_date=$h_process_date{'year'}.'-'.$h_process_date{'month'}.'-'.$h_process_date{'day'};	#the date run process
$group_process_name="3rdAdnetwork";	#the name of group process to register to daily process status table

return 1;
exit;