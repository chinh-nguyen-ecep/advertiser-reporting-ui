# this script will auto build monthly agg of "ba" reports.
# input: p_date_sk_start,p_date_sk_end,month_sk
# note: must run the script use file_xfer user.
require "../../bin/dw_utils.pl";
my $host='dw3';
my $month=''; #2012-Jan,2012-Oct
my $p_date_sk_start=0;
my $p_date_sk_end=0;
my $month_sk=0;
my $process_id=-100;
my $status='PS';

my ($month)=@ARGV;
if(@ARGV==1){
        main();
}else{
        note('perl build_monthly_local.pl $month');
}

sub main{
        getMonthSk();
        runAgg();
        transferFinalData();
}
sub getMonthSk{
        note("*Get month_sk");
        my $dbh = getConnection($host);
        my $query="SELECT month_sk,date_sk_start,date_sk_end FROM refer.month_dim WHERE calendar_year_month=\'$month\'";
        my $query_handle = $dbh->prepare($query);
        $query_handle->execute();
        $query_handle->bind_columns(undef, \$month_sk,\$date_sk_start,\$date_sk_end);
        while($query_handle->fetch()) {
                $month_sk=$month_sk;
                $process_id=$month_sk;
                $p_date_sk_start=$date_sk_start;
                $p_date_sk_end=$date_sk_end;
        }
        sqlDisconnect($dbh);
        note("**Month_sk=$month_sk\n**Start_date_sk=$p_date_sk_start\n**End_date_sk=$p_date_sk_end");
}
sub runAgg{
        note("*Run agg");
        #monthly_agg_adm_data_feed
        ##runPostgresComand("delete from adm.monthly_agg_adm_data_feed where month_since_2005=$month_sk");
        ##runPostgresComand("select staging.fn_ba_monthly_agg_adm_data_feed($p_date_sk_start,$p_date_sk_end,$month_sk,'PS')");
        ##runPostgresComand("update  adm.monthly_agg_adm_data_feed set is_active=true where month_since_2005=$month_sk");

        runPostgresComand("delete from adm.monthly_agg_adm_data_feed_v2 where month_since_2005=$month_sk");
        runPostgresComand("select staging.fn_ba_monthly_agg_adm_data_feed_v2($p_date_sk_start,$p_date_sk_end,$month_sk,'PS')");
        runPostgresComand("update adm.monthly_agg_adm_data_feed_v2 set is_active=true where month_since_2005=$month_sk");

        ##runPostgresComand("select staging.fn_build_monthly_agg_adm_dbclk_revenue($month_sk,$month_sk,'PS')");
        ##runPostgresComand("update adm.monthly_agg_adm_dbclk_revenue set is_active=true where month_since_2005=$month_sk");

        runPostgresComand("select staging.fn_build_monthly_agg_adm_dbclk_revenue_v4($month_sk,$month_sk,'PS')");
        runPostgresComand("update adm.monthly_agg_adm_dbclk_revenue_v4 set is_active=true where month_since_2005=$month_sk");

        #build monthly local revenue summary
        ##runPostgresComand("select staging.fn_build_ba_monthly_local_revenue($p_date_sk_start,$p_date_sk_end,$month_sk,'PS')");
        ##runPostgresComand("update adm.ba_monthly_local_revenue set is_active=true where month_since_2005=$month_sk");
                #version 3
        ##runPostgresComand("select staging.fn_build_ba_monthly_local_revenue_v3($month_sk,$month_sk,'PS')");
        ##runPostgresComand("update adm.ba_monthly_local_revenue_v3 set is_active=true where month_since_2005=$month_sk");
                #version 4
        ##runPostgresComand("select staging.fn_build_ba_monthly_local_revenue_v4($month_sk,$month_sk,'PS')");
        ##runPostgresComand("update adm.ba_monthly_local_revenue_v4 set is_active=true where month_since_2005=$month_sk");
                #version 5
        runPostgresComand("select billing.fn_build_ba_monthly_local_revenue_v51($month_sk,$month_sk,'PS')");
        runPostgresComand("update billing.ba_monthly_local_revenue_v5 set is_active=true where month_since_2005=$month_sk");
        #build monthly national revenue summary
        ##runPostgresComand("select staging.fn_build_ba_monthly_national_revenue($p_date_sk_start,$p_date_sk_end,$month_sk,'PS')");
        ##runPostgresComand("update adm.ba_monthly_national_revenue set is_active=true where month_since_2005=$month_sk");

        ##runPostgresComand("select staging.fn_build_ba_monthly_national_revenue_v2($p_date_sk_start,$p_date_sk_end,$month_sk,'PS')");
        ##runPostgresComand("update adm.ba_monthly_national_revenue_v2 set is_active=true where month_since_2005=$month_sk");

        ##runPostgresComand("select staging.fn_build_ba_monthly_national_revenue_v3($month_sk,$month_sk,'PS')");
        ##runPostgresComand("update adm.ba_monthly_national_revenue_v3 set is_active=true where month_since_2005=$month_sk");

        ##runPostgresComand("select staging.fn_build_ba_monthly_national_revenue_v4($month_sk,$month_sk,'PS')");
        ##runPostgresComand("update adm.ba_monthly_national_revenue_v4 set is_active=true where month_since_2005=$month_sk");
                #version 5
        runPostgresComand("select billing.fn_build_ba_monthly_national_revenue_v5($month_sk,$month_sk,'PS')");
        runPostgresComand("update billing.ba_monthly_national_revenue_v5 set is_active=true where month_since_2005=$month_sk");

        ##runPostgresComand("SELECT staging.fn_build_monthly_agg_delivery_adnetwork_publisher_beta($month_sk,$month_sk,'PS')");
        ##runPostgresComand("UPDATE adsops.monthly_agg_delivery_adnetwork_publisher_beta SET is_active=true WHERE month_since_2005=$month_sk");

        ##runPostgresComand("SELECT staging.fn_build_monthly_agg_delivery_publisher_property_beta($month_sk,$month_sk,'PS')");
        ##runPostgresComand("UPDATE adsops.monthly_agg_delivery_publisher_property_beta SET is_active=true WHERE month_since_2005=$month_sk");

        runPostgresComand("SELECT staging.fn_build_monthly_agg_delivery_adnetwork_publisher_v3($month_sk,$month_sk,'PS')");
        runPostgresComand("UPDATE adsops.monthly_agg_delivery_adnetwork_publisher_v3 SET is_active=true WHERE month_since_2005=$month_sk");

        runPostgresComand("SELECT staging.fn_build_monthly_agg_delivery_publisher_property_v3($month_sk,$month_sk,'PS')");
        runPostgresComand("UPDATE adsops.monthly_agg_delivery_publisher_property_v3 SET is_active=true WHERE month_since_2005=$month_sk");
}

sub transferFinalData{
        note("*Transfer final data to reporting");
                my $comand="cd /opt/temp/autoscripts/transferAggDataDw3Dw0;perl checkAggDw3_Dw0.pl monthly $month";
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
