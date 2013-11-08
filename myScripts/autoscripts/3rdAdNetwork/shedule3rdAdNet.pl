$repeat="y";
while($repeat eq "y"){
	sleep(50);
	my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
	$month++;
	$yr19+=1900;
	$date="$day-$month-$yr19";
	if($hour==3 && $min==1){
		sleep(120);
		print "\n$date# Auto start  daily report\n";
		
		system("perl 3rdAdNetAutodaily_jumptap.pl &");
		system("perl 3rdAdNetAutodaily_where.pl &");
		system("perl 3rdAdNetAutodaily_marchex.pl &");
		system("perl 3rdAdNetAutodaily_yellowpages.pl &");
		system("perl 3rdAdNetAutodaily_superpages.pl &");
		system("perl 3rdAdNetAutodaily_millennial_media.pl &");
		system("perl 3rdAdNetAutodaily_city_grid.pl &");
		system("perl 3rdAdNetAutodaily_itunes.pl &");
		system("perl 3rdAdNetAutodaily_adsense_dbclk_channel.pl &");
	}
	if($hour==7 && $min==0){
		sleep(80);
		system("perl 3rdAdNetAutodaily.pl &");
	}
	
}
