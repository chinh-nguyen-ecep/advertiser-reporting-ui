$repeat="y";
while($repeat eq "y"){
	sleep(50);
	my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
	$month++;
	$yr19+=1900;
	$date="$day-$month-$yr19";
	if($hour==4 && $min==1){
		sleep(120);
		print "\n Auto start  daily report\n";
		system("perl dbclkAutodaily.pl > monitor/dailylog.$date.txt 2> errors/dailylog.$date.txt &");
	}
}
