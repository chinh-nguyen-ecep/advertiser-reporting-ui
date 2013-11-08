require "conn_utils_autoscript.pl";
require "date_utils.pl";
require "sql_utils.pl";
require "log_utils.pl";

my $logFileLocate="logs/schedule.log";
my $minBeforeRunComand=-1;
my $minAfterRunComand=-2;
my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
my $today='';
my $yesterday='';
my $sevenDayAgo='';
my $repeat="y";
while($repeat eq "y"){

	my %dateArrayToday=currentDate();
	my %dateArrayOneDayAgo=getDate(-1);
	my %dateArraySevenDayAgo=getDate(-7);
	
	$today=$dateArrayToday{'year'}.'-'.$dateArrayToday{'month'}.'-'.$dateArrayToday{'day'};
	$yesterday=$dateArrayOneDayAgo{'year'}.'-'.$dateArrayOneDayAgo{'month'}.'-'.$dateArrayOneDayAgo{'day'};
	$sevenDayAgo=$dateArraySevenDayAgo{'year'}.'-'.$dateArraySevenDayAgo{'month'}.'-'.$dateArraySevenDayAgo{'day'};
	
	($sec,$min,$hour) =   localtime(time);
	$minBeforeRunComand=$min;
	if($minBeforeRunComand!=$minAfterRunComand){
		print "$hour:$min:$sec # i am go!\n";
		# Enter your script here
		runFromConfig();		
##		system("perl refreshETLStatusPage.pl &");
	}else{
		print "$hour:$min:$sec # oop!\n";
	}

	($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
	$minAfterRunComand=$min;
	sleep(7);
}

# This function will run comand at the time with Hour and Min
# INPUT:
# 	hourIn: Int // 0->24
# 	minIn: Int // 0->60
# 	comand: Text
#
sub runComandDailyAtTheTime{
	my $hourIn=shift;
	my $minIn=shift;
	my $comand=shift;

	my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
	if($hour==$hourIn && $min==$minIn){
		log_writelog($logFileLocate,$comand);
		system($comand);
	}	
	
}

# This function will run comand at the time with Hour and Min and Day
# INPUT:
# 	day: Int // 0->6
# 	hourIn: Int // 0->24
# 	minIn: Int // 0->60
# 	comand: Text
#
sub runComandWeeklyAtTheTime{
	my $day_in=shift;
	my $hourIn=shift;
	my $minIn=shift;
	my $comand=shift;

	my ($sec,$min,$hour,$day,$month,$yr19,$WeekDay, $DayOfYear, $IsDST) =   localtime(time);
	if($WeekDay==$day_in && $hour==$hourIn && $min==$minIn){
		log_writelog($logFileLocate,$comand);
		system($comand);
	}	
}

#
#
#
sub runFromConfig{
	#load daily agg table from file
	my $file="daily_schedule.config";
	open (CHECKBOOK, "< $file") || die "couldn't open the file!";
	while ($record = <CHECKBOOK>) {
	  $record=~s/[\x0A\x0D]//g;
	  if(index($record,'#')>=0){
	  }else{
	  	  my @values = split(',', $record);
		  my $check=$values[0];
		  if($check eq 'daily'){
			my $hour=$values[1];
			my $min=$values[2];
			my $comand=$values[3];
			$comand=str_replace('$today',$today,$comand);
			print "d $hour:$min ".$comand."\n";
			runComandDailyAtTheTime($hour,$min,$comand);
		  }elsif($check eq 'weekly'){
			my $day_in=$values[1];
			my $hour=$values[2];
			my $min=$values[3];
			my $comand=$values[4];
			$comand=str_replace('$today',$today,$comand);
			print "w $day_in - $hour:$min ".$comand."\n";
		  runComandWeeklyAtTheTime($day_in,$hour,$min,$comand);
		  }
	  }  
	}
	close(CHECKBOOK);
}

#Replace a string without using RegExp.
sub str_replace {
	my $replace_this = shift;
	my $with_this  = shift; 
	my $string   = shift;
	
	my $length = length($string);
	my $target = length($replace_this);
	
	for(my $i=0; $i<$length - $target + 1; $i++) {
		if(substr($string,$i,$target) eq $replace_this) {
			$string = substr($string,0,$i) . $with_this . substr($string,$i+$target);
			#return $string; #Comment this if you what a global replace
		}
	}
	return $string;
}
