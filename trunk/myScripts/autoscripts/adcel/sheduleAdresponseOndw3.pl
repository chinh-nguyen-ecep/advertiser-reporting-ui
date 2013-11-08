$repeat="y";
while($repeat eq "y"){
	sleep(50);
	my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
	$month++;
	$yr19+=1900;
	$date="$day-$month-$yr19";
	if($hour==0 && $min==30){
		sleep(120);
		print "\n$date# Auto start  daily report\n";
		system("perl adcelAutodaily.pl > monitor\/dailylog.$date.txt 2> errors\/dailylogerror.$date.txt &");
	}
}
