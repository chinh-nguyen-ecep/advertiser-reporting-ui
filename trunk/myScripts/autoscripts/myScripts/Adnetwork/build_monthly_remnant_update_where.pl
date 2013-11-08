# this script will auto build monthly agg of "ba" reports.
# input: p_date_sk_start,p_date_sk_end,month_sk
# note: must run the script use file_xfer user.
require "../../bin/dw_utils.pl";
my $host='dw3';
my $month=$ARGV[0]; #2012-Jan,2012-Oct 
my $where_revenue=$ARGV[1]; #12342.04

my $p_date_sk_start=0;
my $p_date_sk_end=0;
my $month_sk=0;
my $process_id=-100;
my $status='PS';

my ($month,$requests,$filled,$clicked,$where_revenue,$fillpercent,$ctr,$ecpm,$data_file_id)=@ARGV;
if(@ARGV==9){
	main();
}else{
	note('perl build_monthly_remnant_update_where.pl $month $requests $filled $clicked $where_revenue $fillpercent $ctr $ecpm $data_file_id');
}

sub main{
	getMonthSk();
	updateWhereData();
	updateSummaryData();
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
sub updateWhereData{
	#ba_monthly_wh_performance 
	note("*Update Where revenue with new value = $where_revenue");
	runPostgresComand("DELETE FROM adnetwork.fact_wh_monthly_sum WHERE month_sk=$month_sk");
	runPostgresComand("INSERT INTO adnetwork.fact_wh_monthly_sum(month_sk,requests,filled,clicked,fillpercent,ctr,ecpm,revenue) 
	VALUES($month_sk,$requests,$filled,$clicked,$fillpercent,$ctr,$ecpm,$where_revenue)");
	runPostgresComand("delete from adnetwork.ba_monthly_wh_performance where month_since_2005=$month_sk");
	runPostgresComand("select staging.fn_ba_monthly_wh_sum_performance_v2($month_sk,$month_sk,'PS',45)");
	runPostgresComand("update adnetwork.ba_monthly_wh_performance set is_active=true where month_since_2005=$month_sk");
}

sub updateSummaryData{
	#ba_monthly_adnetwork_summary
	note("*Update revenue summary");
	runPostgresComand("delete from adnetwork.ba_monthly_adnetwork_summary where month_since_2005=$month_sk");
	runPostgresComand("select staging.fn_ba_monthly_adnetwork_summary($p_date_sk_start,$p_date_sk_end,$month_sk,'PS',45)");
	runPostgresComand("update adnetwork.ba_monthly_adnetwork_summary set is_active=true where month_since_2005=$month_sk");	
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
	print "# $query\n";
	sqlRunQuery($dbh,$query);
	sqlDisconnect($dbh);
}