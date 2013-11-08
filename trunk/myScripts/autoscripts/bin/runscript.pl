require "dw3_utils.pl";

my $date='2012-03-25';
my @aggTableDw3=();
push(@aggTableDw3,"adm.daily_agg_adm_data_feed");
push(@aggTableDw3,"adm.daily_agg_order_atc");
push(@aggTableDw3,"adm.daily_agg_order_placement_creative_flight");
push(@aggTableDw3,"adm.daily_agg_publisher_website_partner");
push(@aggTableDw3,"adm.daily_agg_revenue_by_order");

#copyAggDataToDw0($date,@aggTableDw3);

#test send mail
my $emailErrorTitle="[Error!][Daily Event tracker report][$report_date]";	#the email title used when send a mail error 
my $emailAvailableTitle="test mail";	#the email title used when send a mail
my $mailto="chinh.nguyen\@ecepvn.org";	#List mail addresses
dw3_sendMail($mailto,$emailAvailableTitle,"Dear all,<p />Daily report $report_date is stop with error.<p />Thanks,<br />\-\-\-send by auto mail.");
