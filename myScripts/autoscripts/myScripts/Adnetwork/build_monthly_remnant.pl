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
	note('perl build_monthly_remnant.pl $month');
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
	#ba_monthly_wh_performance 
	note("*Run agg");
	#ba_monthly_adsense_dbclk_channel
	##runPostgresComand("delete from billing.ba_monthly_adsense_dbclk_channel where month_since_2005=$month_sk");
	##runPostgresComand("select billing.fn_build_ba_monthly_adsense_dbclk_channel($month_sk, $p_date_sk_start,$process_id, 'PS', 45)");
	##runPostgresComand("update billing.ba_monthly_adsense_dbclk_channel set is_active=true where month_since_2005=$month_sk");

	#ba_monthly_cg_performance
	runPostgresComand("delete from billing.ba_monthly_cg_performance where month_since_2005=$month_sk");
	runPostgresComand("select billing.fn_build_ba_monthly_cg_performance_v2($month_sk,$month_sk,'PS',45)");
	runPostgresComand("update  billing.ba_monthly_cg_performance set is_active=true where month_since_2005=$month_sk");

	runPostgresComand("delete from billing.ba_monthly_cg_mobile_performance where month_since_2005=$month_sk");
	runPostgresComand("select billing.fn_build_ba_monthly_cg_mobile_performance_v2($month_sk,$month_sk,'PS',45)");
	runPostgresComand("update  billing.ba_monthly_cg_mobile_performance set is_active=true where month_since_2005=$month_sk");
	
	#ba_monthly_wh_performance 
	#INSERT INTO  billing.fn_build_fact_wh_monthly_sum(month_sk,requests,filled,clicked,fillpercent,ctr,ecpm,revenue) VALUES(92,0,0,0,0,0,0,45008.43);
	#UPDATE billing.fn_build_fact_wh_monthly_sum SET month_sk=92 , revenue=45,008.43;
	runPostgresComand("delete from billing.ba_monthly_wh_performance where month_since_2005=$month_sk");
#	runPostgresComand("select staging.fn_ba_monthly_wh_sum_performance($p_date_sk_start,$p_date_sk_end,$month_sk,'PS',45)");
	runPostgresComand("select billing.fn_build_ba_monthly_wh_daily_performance_v2($month_sk,$month_sk,'PS',45)");
	runPostgresComand("update  billing.ba_monthly_wh_performance set is_active=true where month_since_2005=$month_sk");	
	
	#ba_monthly_sp_blue_performance
	runPostgresComand("delete from billing.ba_monthly_sp_blue_performance where month_since_2005=$month_sk");
	runPostgresComand("select billing.fn_build_ba_monthly_sp_blue_performance_v2($month_sk,$month_sk,'PS',45)");
	runPostgresComand("update  billing.ba_monthly_sp_blue_performance set is_active=true where month_since_2005=$month_sk");	
	
	#ba_monthly_yp_sb_performance v3
	runPostgresComand("delete from billing.ba_monthly_yp_sb_performance where month_since_2005=$month_sk");
	runPostgresComand("select billing.fn_build_ba_monthly_yp_sb_performance_v3($month_sk,$month_sk,'PS',45)");
	runPostgresComand("update  billing.ba_monthly_yp_sb_performance set is_active=true where month_since_2005=$month_sk");	

	#ba_monthly_yp_no_performance v3
	runPostgresComand("delete from billing.ba_monthly_yp_no_performance where month_since_2005=$month_sk");
	runPostgresComand("select billing.fn_build_ba_monthly_yp_no_performance_v3($month_sk,$month_sk,'PS',45)");
	runPostgresComand("update  billing.ba_monthly_yp_no_performance set is_active=true where month_since_2005=$month_sk");

	#ba_monthly_yp_performance
	runPostgresComand("delete from billing.ba_monthly_yp_performance where month_since_2005=$month_sk");
	runPostgresComand("select billing.fn_build_ba_monthly_yp_performance($p_date_sk_start,$p_date_sk_end,$month_sk,'PS',45)");
	runPostgresComand("update  billing.ba_monthly_yp_performance set is_active=true where month_since_2005=$month_sk");

	#ba_monthly_it_performance
	runPostgresComand("delete from billing.ba_monthly_it_performance where month_since_2005=$month_sk");
	runPostgresComand("select billing.fn_build_ba_monthly_it_performance($p_date_sk_start,$p_date_sk_end,$month_sk,'PS',45)");
	runPostgresComand("update  billing.ba_monthly_it_performance set is_active=true where month_since_2005=$month_sk");	
	
	#ba_monthly_jt_performance
	runPostgresComand("delete from billing.ba_monthly_jt_performance where month_since_2005=$month_sk");
	runPostgresComand("select billing.fn_build_ba_monthly_jt_performance($p_date_sk_start,$p_date_sk_end,$month_sk,'PS',45)");
	runPostgresComand("update  billing.ba_monthly_jt_performance set is_active=true where month_since_2005=$month_sk");	
	
	#ba_monthly_mm_performance
	runPostgresComand("delete from billing.ba_monthly_mm_performance where month_since_2005=$month_sk");
	runPostgresComand("select billing.fn_build_ba_monthly_mm_performance($p_date_sk_start,$p_date_sk_end,$month_sk,'PS',45)");
	runPostgresComand("update  billing.ba_monthly_mm_performance set is_active=true where month_since_2005=$month_sk");	
	
	#ba_monthly_mx_performance
	runPostgresComand("delete from billing.ba_monthly_mx_performance where month_since_2005=$month_sk");
	runPostgresComand("select billing.fn_build_ba_monthly_mx_performance_v2($month_sk,$month_sk,'PS',45)");
	runPostgresComand("update  billing.ba_monthly_mx_performance set is_active=true where month_since_2005=$month_sk");	

	#ba_monthly_kt_performance
	runPostgresComand("delete from billing.ba_monthly_kt_performance where month_since_2005=$month_sk");
	runPostgresComand("select billing.fn_build_ba_monthly_kt_performance($p_date_sk_start,$p_date_sk_end,$month_sk,'PS',45)");
	runPostgresComand("update  billing.ba_monthly_kt_performance set is_active=true where month_since_2005=$month_sk");	

	#ba_monthly_adnetwork_summary
	runPostgresComand("delete from billing.ba_monthly_adnetwork_summary where month_since_2005=$month_sk");
	runPostgresComand("select billing.fn_build_ba_monthly_adnetwork_summary($p_date_sk_start,$p_date_sk_end,$month_sk,'PS',45)");
	runPostgresComand("update billing.ba_monthly_adnetwork_summary set is_active=true where month_since_2005=$month_sk");
	
	#ba_monthly_publisher_revenue_v51
	runPostgresComand("select billing.fn_build_ba_monthly_publisher_revenue_v51($month_sk,$process_id,'PS')");
	runPostgresComand("update billing.ba_monthly_publisher_revenue_v5 set is_active=true where month_since_2005=$month_sk");
	#Billing Monthly VLM Revenue Summary
	
	runPostgresComand("select billing.fn_build_ba_monthly_vlm_revenue_v51($month_sk,$process_id,'PS')");
	runPostgresComand("update billing.ba_monthly_vlm_revenue_v5 set is_active=true where month_since_2005=$month_sk");	
	
	#advance digital
	runPostgresComand("select billing.fn_build_ba_monthly_advance_digital($month_sk,$process_id,'PS')");
	runPostgresComand("update billing.ba_monthly_advance_digital set is_active=true where month_since_2005=$month_sk");
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
