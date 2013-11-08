my ($month)=@ARGV;

system("perl build_monthly_local.pl $month > monitor/$month.local.text 2>monitor/$month.local.error.text");
system("perl build_monthly_remnant.pl $month > monitor/$month.remnant.text 2>monitor/$month.remnant.error.text");