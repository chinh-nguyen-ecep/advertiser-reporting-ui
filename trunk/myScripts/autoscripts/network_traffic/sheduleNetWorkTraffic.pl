$repeat="y";
while($repeat eq "y"){
	sleep(50);
	my ($sec,$min,$hour,$day,$month,$yr19,$WeekDay, $DayOfYear, $IsDST) =   localtime(time);
	$month++;
	$yr19+=1900;
	$date="$day-$month-$yr19";
	if($hour==6 && $min==0 ){
		sleep(120);
		print "\n -------------Auto start daily report $date------------\n";
		if($WeekDay==1){
			system("perl autoweekly.pl > monitor\/weeklylog.$date.txt 2> errors\/weeklylog.$date.txt &");
		}else{
			system("perl autodaily.pl > monitor\/dailylog.$date.txt 2> errors\/dailylog.$date.txt &");
		}
	}
}
