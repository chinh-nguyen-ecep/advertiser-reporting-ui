
my $app_server=$ARGV[0];
	runPostgresComand("select fn_refresh_daily_cumulative_ad_response_per_server(\'fn_build_ad_response_fact_agg_inday_stats_unfilled\')");
	runPostgresComand("select fn_refresh_daily_cumulative_ad_response(\'fn_build_ad_response_fact_stats_unfilled\')");
sub runPostgresComand{
	my $comand=shift;
	print "# $comand\n";
	system('su - postgres -c "/usr/bin/psql -d warehouse -c \"'.$comand.'\""');
}