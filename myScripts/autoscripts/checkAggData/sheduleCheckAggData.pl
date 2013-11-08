$repeat="y";
while($repeat eq "y"){
	sleep(50);
	my ($sec,$min,$hour,$day,$month,$yr19,$WeekDay, $DayOfYear, $IsDST) =   localtime(time);
	$month++;
	$yr19+=1900;
	$date="$day-$month-$yr19";
	if($hour==5 && $min==10 ){
		sleep(120);
		print "\n -------------Auto start daily report $date------------\n";
		system("perl checkEventTrackerAggData.pl &");
	}
	if($hour==7 && $min==10 ){
		sleep(120);
		print "\n -------------Auto start daily report $date------------\n";
		system("perl checkAggData.pl > monitor/$date.txt 2> errors/$date.error.txt &");
		
	}
	if($hour==7 && $min==20 ){
		sleep(120);
		print "\n -------------Auto start daily report $date------------\n";
		system("perl checkAdCelAggData.pl &");
		
	}
	if($hour==7 && $min==30 ){
		sleep(120);
		print "\n -------------Auto start daily report $date------------\n";
		system("perl checkDBCLKAggData.pl &");
		
	}
	if($hour==7 && $min==40 ){
		sleep(120);
		print "\n -------------Auto start daily report $date------------\n";
		system("perl check3RDAggData.pl &");
		
	}

	if($hour==14 && $min==10 ){
		sleep(120);
		print "\n -------------Auto start daily report $date------------\n";
		system("perl checkNetworkTrafficAggData.pl &");
		
	}
}
