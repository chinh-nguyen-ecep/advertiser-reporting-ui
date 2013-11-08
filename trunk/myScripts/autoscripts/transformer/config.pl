$rootFD='/opt/temp/autoscripts/transformer';
$binfd="/opt/temp/autoscripts/bin";
$path_export="/home/postgres/transformer_export_files";
$export_count=0;
$path_import="/home/postgres/transformer_import_files";
$import_count=0;
$mode='daily';
$transfer_by='human';
$process_id=0;
$transformer_host='dw10';
@backup_host_array=("dw0","dw6");
#@backup_host_array=("dw0");
$time_tmp = strftime( q/%Y%m%dT%H%M%S/, localtime ) . ( gettimeofday )[1] . q/00000/, 0, 20;
$backup_mode=1;
$default_database='warehouse';
$defaul_userName='import_export_script';
$defaul_pass='verve-2013';

return 1;
