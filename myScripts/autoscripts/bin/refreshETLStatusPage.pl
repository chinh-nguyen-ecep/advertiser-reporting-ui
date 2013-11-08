require "conn_utils_autoscript.pl";
require "date_utils.pl";
require "sql_utils.pl";
require "log_utils.pl";

		
my $dbh = getConnectionAutoScript('dw3');
sqlRunPGFuntion('staging.fn_refresh_daily_process_status()',$dbh);
sqlDisconnect($dbh);

my $dbh = getConnectionAutoScript('dw4');
sqlRunPGFuntion('staging.fn_refresh_daily_process_status()',$dbh);
sqlDisconnect($dbh);

my $dbh = getConnectionAutoScript('dw5');
sqlRunPGFuntion('staging.fn_refresh_daily_process_status()',$dbh);
sqlDisconnect($dbh);

my $dbh = getConnectionAutoScript('dw6');
sqlRunPGFuntion('staging.fn_refresh_daily_process_status()',$dbh);
sqlDisconnect($dbh);