# this script will auto build monthly agg of "ba" reports.
# input: p_date_sk_start,p_date_sk_end,year_week
# note: must run the script use file_xfer user.
require "../../bin/dw_utils.pl";
my $host='dw3';
my $p_start_date_sk=0;
my $p_start_date='';
my $p_end_date_sk=0;
my $p_end_date='';
my $year_week='';
my $process_id=-100;
my $status='PS';
my $transferToHost='dw10';

my $is_available='non';

main();

sub main{
        getMonthSk();
		checkAggIsVailable();
        runAgg();
        transferFinalData();
}
sub getMonthSk{
        note("*Get year_week");
        my $dbh = getConnection($host);
        my $query="SELECT a.date_sk-1 as end_date_sk,full_date-1 as end_date,a.date_sk-7 as start_date_sk ,a.full_date-7 as start_date, b.year_week_monday
					FROM refer.date_dim a
					LEFT JOIN (SELECT date_sk,year_week_monday FROM refer.date_dim WHERE full_date=now()::date-1)b ON b.date_sk=a.date_sk-1
					WHERE a.full_date=now()::date";
        my $query_handle = $dbh->prepare($query);
        $query_handle->execute();
        $query_handle->bind_columns(undef, \$p_end_date_sk,\$p_end_date,\$p_start_date_sk,\$p_start_date,\$year_week);
		$query_handle->fetch();
        sqlDisconnect($dbh);
        note("**year_week = $year_week\n**Start_date_sk = $p_start_date_sk\n**End_date_sk = $p_end_date_sk\n**Start date = $p_start_date\n**End date = $p_end_date");
}
sub checkAggIsVailable{
		while($is_available eq 'non'){
			my $dbh = getConnection($host);
			my $query="SELECT 'available' FROM adm.ba_daily_flight WHERE full_date=now()::date-1 GROUP BY full_date";
			my $query_handle = $dbh->prepare($query);
			$query_handle->execute();
			$query_handle->bind_columns(undef, \$is_available);
			$query_handle->fetch();
			sqlDisconnect($dbh);	
			if($is_available eq 'non'){
				note( 'Data is not available');
				sleep(5);
			}else{
				note( 'Data is available');
			}
			
		}

}
sub runAgg{
        note("*Run agg");
        #monthly_agg_adm_data_feed
	        runPostgresComand("select adsops.fn_build_weekly_new_booked($p_start_date_sk ,$p_end_date_sk, 0, 'PS')");
		runPostgresComand("select adsops.fn_build_weekly_agg_advance_digital($p_start_date_sk ,$p_end_date_sk, 0, 'PS')");
		runPostgresComand("select adsops.fn_build_weekly_agg_flight_missing_vendor($p_start_date_sk ,$p_end_date_sk, 0, 'PS')");
		
		# Weekly publisher performance report
		runPostgresComand("select adsops.fn_build_daily_agg_publisher_performance($p_end_date_sk-6, 0, 'PS')");
		runPostgresComand("select adsops.fn_build_daily_agg_publisher_performance($p_end_date_sk-5, 0, 'PS')");
		runPostgresComand("select adsops.fn_build_daily_agg_publisher_performance($p_end_date_sk-4, 0, 'PS')");
		runPostgresComand("select adsops.fn_build_daily_agg_publisher_performance($p_end_date_sk-3, 0, 'PS')");
		runPostgresComand("select adsops.fn_build_daily_agg_publisher_performance($p_end_date_sk-2, 0, 'PS')");
		runPostgresComand("select adsops.fn_build_daily_agg_publisher_performance($p_end_date_sk-1, 0, 'PS')");
		runPostgresComand("select adsops.fn_build_daily_agg_publisher_performance($p_end_date_sk, 0, 'PS')");
        ##runPostgresComand("select staging.fn_ba_monthly_agg_adm_data_feed($p_date_sk_start,$p_date_sk_end,$year_week,'PS')");
        ##runPostgresComand("update  adm.monthly_agg_adm_data_feed set is_active=true where month_since_2005=$year_week");

}

sub transferFinalData{
        note("*Transfer final data to reporting");
		# adsops.weekly_new_booked
		my $comand=" cd /opt/temp/autoscripts/transformer/;perl main.pl table $host $transferToHost adsops.weekly_new_booked";
		system($comand);
		# adsops.weekly_agg_advance_digital
		my $comand=" cd /opt/temp/autoscripts/transformer/;perl main.pl table $host $transferToHost adsops.weekly_agg_advance_digital";
		system($comand);
		# adsops.weekly_agg_flight_missing_vendor
		my $comand=" cd /opt/temp/autoscripts/transformer/;perl main.pl table $host $transferToHost adsops.weekly_agg_flight_missing_vendor";
		system($comand);
		# weekly publisher performance report 
		my $comand=" cd /opt/temp/autoscripts/transformer/;perl main.pl table $host $transferToHost adsops.weekly_agg_publisher_performance_national_engagement";
		system($comand);
		my $comand=" cd /opt/temp/autoscripts/transformer/;perl main.pl table $host $transferToHost adsops.weekly_agg_publisher_performance_national_non_engagement";
		system($comand);
		my $comand=" cd /opt/temp/autoscripts/transformer/;perl main.pl table $host $transferToHost adsops.weekly_agg_publisher_performance_remnant";
		system($comand);
}
sub runPostgresComand{
        #my $comand=shift;
        #print "# $comand\n";
        #system('su - postgres -c "/usr/bin/psql -d warehouse -c \"'.$comand.'\""');
        my $dbh = getConnection($host);
        my $query=shift;
        print "-- $query\n";
        sqlRunQuery($dbh,$query);
        sqlDisconnect($dbh);
}

