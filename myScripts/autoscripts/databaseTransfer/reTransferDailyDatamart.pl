@tables=();
push(@tables,'adm.daily_agg_network_revenue');
push(@tables,'adm.daily_agg_network_revenue_min');
push(@tables,'adm.daily_agg_api_revenue_by_partner');
push(@tables,'adm.daily_network_fct_request_beta');
push(@tables,'adsops.daily_agg_delivery_advertiser_beta');
push(@tables,'adm.daily_agg_revenue_statistics');
push(@tables,'adsops.daily_agg_delivery_adnetwork_publisher_beta');
push(@tables,'adsops.daily_agg_delivery_publisher_property_beta');

$date='';
$from='';
$to='';

if(@ARGV==3){
	$from=$ARGV[0];
	$to=$ARGV[1];
	$date=$ARGV[2];
	my $i=0;
	foreach $table(@tables){
		$i++;
		print("$i. Transfer table $table...\n");
		sleep(2);
		my $comand="perl main.pl daily $from $to $table $date TransferDailyDatamart.pl";
		system($comand);
	}
}else{
	print("perl TransferDailyDatamart.pl dw3 dw0 2013-03-01\n");
}
