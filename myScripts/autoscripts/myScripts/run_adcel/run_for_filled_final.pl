
my $app_server=$ARGV[0];
	runPostgresComand("select fn_refresh_daily_cumulative_ad_response(\'fn_build_ad_response_fact_stats_filled\')");
sub runPostgresComand{
	my $comand=shift;
	print "# $comand\n";
	system('su - postgres -c "/usr/bin/psql -d warehouse -c \"'.$comand.'\""');
}