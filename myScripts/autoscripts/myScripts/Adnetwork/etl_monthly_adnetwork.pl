require "../../bin/dw_utils.pl";
my $host='dw3';

sub runPostgresComand{
	#my $comand=shift;
	#print "# $comand\n";
	#system('su - postgres -c "/usr/bin/psql -d warehouse -c \"'.$comand.'\""');	
	my $dbh = getConnection($host);
	my $query=shift;
	print "# $query\n";
	sqlRunQuery($dbh,$query);
	sqlDisconnect($dbh);
}


runPostgresComand("select staging.fn_refresh_adnetwork_monthly_performance_fact_data()");
runPostgresComand("select staging.fn_monthly_3rd_party_performance_fact_load()");

runPostgresComand("select staging.fn_refresh_adnetwork_monthly_performance_fact_data()");
runPostgresComand("select staging.fn_monthly_3rd_party_performance_fact_load()");

runPostgresComand("select staging.fn_refresh_adnetwork_monthly_performance_fact_data()");
runPostgresComand("select staging.fn_monthly_3rd_party_performance_fact_load()");

runPostgresComand("select staging.fn_refresh_adnetwork_monthly_performance_fact_data()");
runPostgresComand("select staging.fn_monthly_3rd_party_performance_fact_load()");

runPostgresComand("select staging.fn_refresh_adnetwork_monthly_performance_fact_data()");
runPostgresComand("select staging.fn_monthly_3rd_party_performance_fact_load()");

runPostgresComand("select staging.fn_refresh_adnetwork_monthly_performance_fact_data()");
runPostgresComand("select staging.fn_monthly_3rd_party_performance_fact_load()");

runPostgresComand("select staging.fn_refresh_adnetwork_monthly_performance_fact_data()");
runPostgresComand("select staging.fn_monthly_3rd_party_performance_fact_load()");

runPostgresComand("select staging.fn_refresh_adnetwork_monthly_performance_fact_data()");
runPostgresComand("select staging.fn_monthly_3rd_party_performance_fact_load()");

runPostgresComand("select staging.fn_refresh_adnetwork_monthly_performance_fact_data()");
runPostgresComand("select staging.fn_monthly_3rd_party_performance_fact_load()");

runPostgresComand("select staging.fn_refresh_adnetwork_monthly_performance_fact_data()");
runPostgresComand("select staging.fn_monthly_3rd_party_performance_fact_load()");

runPostgresComand("select staging.fn_refresh_adnetwork_monthly_performance_fact_data()");
runPostgresComand("select staging.fn_monthly_3rd_party_performance_fact_load()");

runPostgresComand("select staging.fn_refresh_adnetwork_monthly_performance_fact_data()");
runPostgresComand("select staging.fn_monthly_3rd_party_performance_fact_load()");

runPostgresComand("select staging.fn_refresh_adnetwork_monthly_performance_fact_data()");
runPostgresComand("select staging.fn_monthly_3rd_party_performance_fact_load()");

runPostgresComand("select staging.fn_refresh_adnetwork_monthly_performance_fact_data()");
runPostgresComand("select staging.fn_monthly_3rd_party_performance_fact_load()");

runPostgresComand("select staging.fn_refresh_adnetwork_monthly_performance_fact_data()");
runPostgresComand("select staging.fn_monthly_3rd_party_performance_fact_load()");

runPostgresComand("select staging.fn_refresh_adnetwork_monthly_performance_fact_data()");
runPostgresComand("select staging.fn_monthly_3rd_party_performance_fact_load()");

runPostgresComand("select staging.fn_refresh_adnetwork_monthly_performance_fact_data()");
runPostgresComand("select staging.fn_monthly_3rd_party_performance_fact_load()");

runPostgresComand("select staging.fn_refresh_adnetwork_monthly_performance_fact_data()");
runPostgresComand("select staging.fn_monthly_3rd_party_performance_fact_load()");

runPostgresComand("select staging.fn_refresh_adnetwork_monthly_performance_fact_data()");
runPostgresComand("select staging.fn_monthly_3rd_party_performance_fact_load()");

runPostgresComand("select staging.fn_refresh_adnetwork_monthly_performance_fact_data()");
runPostgresComand("select staging.fn_monthly_3rd_party_performance_fact_load()");





