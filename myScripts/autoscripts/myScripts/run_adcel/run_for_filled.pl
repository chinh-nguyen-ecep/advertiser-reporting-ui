
my $app_server=$ARGV[0];
	runPostgresComand("select fn_refresh_daily_cumulative_ad_response_per_server(\'fn_build_ad_response_fact_filled_filter_$app_server-adcel\')");
	runPostgresComand("select fn_refresh_daily_cumulative_ad_response_per_server(\'fn_build_ad_response_fact_filled_location_$app_server-adcel\')");
sub runPostgresComand{
	my $comand=shift;
	print "# $comand\n";
	system('su - postgres -c "/usr/bin/psql -d warehouse -c \"'.$comand.'\""');
}