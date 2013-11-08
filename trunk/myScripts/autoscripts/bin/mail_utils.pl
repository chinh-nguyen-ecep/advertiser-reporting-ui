sub mail_sendMail{
my $mailaddress=shift;
my $title=shift;
my $content=shift;
my $callFunction = "cd $binfd;java -jar mail.jar \"smtp.gmail.com\" 587 \"dataman\@ecepvn.org\" \"D\@taman1\" \"$mailaddress\" \"$title\" \"$content\" &";
system($callFunction);
}

sub mail_sendMail_fromVerve{
my $mailaddress=shift;
my $title=shift;
my $content=shift;
my $callFunction = "cd $binfd;java -jar mail.jar \"smtp.gmail.com\" 587 \"dataman\@vervewireless.com\" \"D\@taman1\" \"$mailaddress\" \"$title\" \"$content\" &";
system($callFunction);
}
return 1;
exit;