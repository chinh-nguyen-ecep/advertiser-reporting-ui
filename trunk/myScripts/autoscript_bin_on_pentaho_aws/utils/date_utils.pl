sub yesterday{
my $Dd=-1;
my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
$month++;
$yr19+=1900;
      ($year1,$month1,$day1) = Add_Delta_Days($yr19,$month,$day,$Dd);
	  if($day1<10){
		$day1="0$day1";
	  }
	  if($month1<10){
		$month1="0$month1";
	  }
	  %hash=('year' => $year1,'month' => $month1, 'day' => $day1);
	  return %hash;
}
#input db = -1 or -2 or -3 ...
sub getDate{
my $Dd=shift;
my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
$month++;
$yr19+=1900;
      ($year1,$month1,$day1) = Add_Delta_Days($yr19,$month,$day,$Dd);
	  if($day1<10){
		$day1="0$day1";
	  }
	  if($month1<10){
		$month1="0$month1";
	  }
	  %hash=('year' => $year1,'month' => $month1, 'day' => $day1);
	  return %hash;
}
sub currentDate{
$Dd=0;
my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
$month++;
$yr19+=1900;
      ($year1,$month1,$day1) = Add_Delta_Days($yr19,$month,$day,$Dd);
	  if($day1<10){
		$day1="0$day1";
	  }
	  if($month1<10){
		$month1="0$month1";
	  }
	  %hash=('year' => $year1,'month' => $month1, 'day' => $day1);
	  $datet= "$year1\_$month1\_$day1";
	  #2011_08_01
	  return %hash;
}
sub getTime{
	my $result='';
	my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
	$month++;
	$yr19+=1900;
	$result="$yr19-$month-$day $hour:$min:$sec";
	return $result;
}
return 1;
exit;