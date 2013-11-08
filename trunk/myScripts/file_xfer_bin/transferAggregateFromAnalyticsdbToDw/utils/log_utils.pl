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

sub sendMail{
#$mailaddress="chinh.nguyen\@ecepvn.org,binh.nguyen\@ecepvn.org,song.nguyen\@ecepvn.org,tho.hoang\@ecepvn.org";
my $mailaddress=shift;
my $title=shift;
my $content=shift;
my $callFunction = "cd $binfd/utils;java -jar mail.jar \"smtp.gmail.com\" 587 \"chinh.nguyen\@ecepvn.org\" \"verve-2013\" \"$mailaddress\" \"$title\" \"$content\" &";
system($callFunction);
}

return 1;
exit;