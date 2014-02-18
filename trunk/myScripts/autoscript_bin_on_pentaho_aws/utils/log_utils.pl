sub log_writelog{
	my $file=shift;
	my $text=shift;
	my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
	$month++;
	$yr19+=1900;
	my $date="$day-$month-$yr19";
	open (FILEHANDEL,">>$file") or die ("Canot open file");
	print FILEHANDEL "$date $hour:$min:$sec # ".$text."\n";
	close FILEHANDEL;
}
sub printTime{
	my $text=shift;
	my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
	$month++;
	$yr19+=1900;
	print "$day-$month-$yr19 $hour:$min:$sec # $text\n";
}

sub note{
	my $text=shift;
	print $text."\n";
	sleep(1);
}
return 1;
exit;