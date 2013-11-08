my $start_date='20120801';
my $end_date='20120831';
my $month='082012';

print "Download City grid/ mobile\n";
sleep(5);
system("cd /home/file_xfer/incoming/citygrid_api && java -jar CityGridMonthlyDownload.jar citygrid &");
system("cd /home/file_xfer/incoming/citygrid/bin && perl citygridmobilemonthlyauto.pl &");

print "Download Jumptap\n";
sleep(5);
system("cd /home/file_xfer/incoming/jumptap/bin && java -jar Monthly_Jumptap_Client.jar $start_date $end_date &");

print "Download Klickthru\n";
sleep(5);
system("cd /home/file_xfer/incoming/klickthru && perl klickthru_monthly_auto.pl $month &");

print "Download Marchex\n";
sleep(5);
system("cd /home/file_xfer/incoming/marchex/bin && java -jar MonthlyMarchexClient.jar $start_date $end_date &");

print "Download Where\n";
sleep(5);
system("cd /home/file_xfer/incoming/where && java -jar Where_Monthly_Client.jar $start_date $end_date &");

