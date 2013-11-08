require "conn_utils_autoscript.pl";
require "date_utils.pl";
require "sql_utils.pl";

print "Get connect on dw0!...\n";
my $dbh = getConnectionAutoScript('dw0');
print $dbh."\n";
my $rv = $dbh->disconnect;

print "Get connect on dw2!...\n";
my $dbh = getConnectionAutoScript('dw2');
print $dbh."\n";
my $rv = $dbh->disconnect;


print "Get connect on dw3!...\n";
my $dbh = getConnectionAutoScript('dw3');
print $dbh."\n";
my $rv = $dbh->disconnect;


print "Get connect on dw4!...\n";
my $dbh = getConnectionAutoScript('dw4');
print $dbh."\n";
my $rv = $dbh->disconnect;


print "Get connect on dw5!...\n";
my $dbh = getConnectionAutoScript('dw5');
print $dbh."\n";
my $rv = $dbh->disconnect;

print "Get connect on dw6!...\n";
my $dbh = getConnectionAutoScript('dw6');
print $dbh."\n";
my $rv = $dbh->disconnect;

print "#################### test date_utils.pl #####################\n";
	my %dateArrayToday=currentDate();
	my %dateArrayOneDayAgo=getDate(-1);
	my %dateArraySevenDayAgo=getDate(-7);
	
	$today=$dateArrayToday{'year'}.'-'.$dateArrayToday{'month'}.'-'.$dateArrayToday{'day'};
	$yesterday=$dateArrayOneDayAgo{'year'}.'-'.$dateArrayOneDayAgo{'month'}.'-'.$dateArrayOneDayAgo{'day'};
	$sevenDayAgo=$dateArraySevenDayAgo{'year'}.'-'.$dateArraySevenDayAgo{'month'}.'-'.$dateArraySevenDayAgo{'day'};
	print "today: $today\n";
	print "yesterday: $yesterday\n";
	print "sevenDayAgo: $sevenDayAgo\n";
	
print "############ test sql_utils.pl ##############3\n";
my $dbh = getConnectionAutoScript('dw3');
sqlRunPGFuntion('staging.fn_refresh_daily_process_status()',$dbh);
sqlTest($dbh);
sqlDisconnect($dbh);

my $dbh = getConnectionAutoScript('dw2');
sqlRunPGFuntion('staging.fn_refresh_daily_process_status()',$dbh);
sqlTest($dbh);
sqlDisconnect($dbh);

my $dbh = getConnectionAutoScript('dw4');
sqlRunPGFuntion('staging.fn_refresh_daily_process_status()',$dbh);
sqlTest($dbh);
sqlDisconnect($dbh);

my $dbh = getConnectionAutoScript('dw5');
sqlRunPGFuntion('staging.fn_refresh_daily_process_status()',$dbh);
sqlTest($dbh);
sqlDisconnect($dbh);

my $dbh = getConnectionAutoScript('dw6');
sqlRunPGFuntion('staging.fn_refresh_daily_process_status()',$dbh);
sqlTest($dbh);
sqlDisconnect($dbh);


	
	
	