#crontab example
#/usr/bin/psql -d warehouse -c "\i $dir/00-classify-bots.sql" > /dev/null 2>&1
my $port=5433;
my $dir='/opt/temp/autoscripts/network_traffic/ericAutoScript';
my $tmp_dir='/home/song/tmp';
my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
$month++;
$yr19+=1900;
	  if($day<10){
		$day="0$day";
	  }
	  if($month<10){
		$month="0$month";
	  }
my $date= "$yr19$month$day";

#Run script 00

my $time=getTime();
print "$time # Run 00-classify-bots.sql\n";
my $cm="su - postgres -c \"/usr/bin/psql -p $port -d warehouse -c \\\"\\i $dir/00-classify-bots.sql\\\"\" ";
print $cm."\n";
##system($cm);

#Run script 01

$time=getTime();
print "$time #Run 01-client-agents.sh\n";
$cm="$dir/01-client-agents.sh morose-skunking > $tmp_dir/client-agents_".$date.".sql";
print $cm."\n";
##system($cm);

$cm="su - postgres -c \"/usr/bin/psql -p $port -d warehouse -c \\\"\\i $tmp_dir/client-agents_".$date.".sql\\\"\" ";
print $cm."\n";
##system($cm);

#Run script 02

$time=getTime();
print "$time #Run 02-procagents.pl\n";
$cm="$dir/02-procagents.pl > $tmp_dir/procagent_".$date.".sql";
print $cm."\n";
##system($cm);
$cm="su - postgres -c \"/usr/bin/psql -p $port -d warehouse -c \\\"\\i $tmp_dir/procagent_".$date.".sql\\\"\"";
print $cm."\n";
##system($cm);

#Run script 03

$time=getTime();
print "$time#Run 03-agent_uniques.sql\n";
$cm="su - postgres -c \"/usr/bin/psql -p $port -d warehouse -c \\\"alter table emj_agent_uniques rename to emj_agent_uniques_bk".$date."\\\"\"";
print $cm."\n";
##system($cm);
$cm="su - postgres -c \"/usr/bin/psql -p $port -d warehouse -c \\\"\\i $dir/03-agent_uniques.sql\\\"\"";
print $cm."\n";
##system($cm);

#Run script 04

$time=getTime();
print "$time #Run 04-uniques_query.sql\n";
$cm="su - postgres -c \"/usr/bin/psql -p $port -d warehouse -c \\\"\\i $dir/04-uniques_query.sql\\\" > $tmp_dir/uniques_query_".$date.".txt\"";
print $cm."\n";
##system($cm);

#Run script Unique_UserAgent
$time=getTime();
print "$time#Run Unique_UserAgent\n";
$cm="su - postgres -c \"/usr/bin/psql -p $port -d warehouse -c \\\"SELECT pv.user_agent_sk as ua_sk, ua.user_agent_name, views, uniques, uniques::float / views as ratio FROM staging.emj_agent_uniques pv INNER JOIN dw.user_agent_dim ua ON pv.user_agent_sk = ua.user_agent_sk WHERE ua.organic = \'f\' and ua.auto_generated = \'t\' AND views > 25000 ORDER BY views desc\\\" > $tmp_dir/Unique_UserAgent_".$date.".txt\"";
print $cm."\n";
##system($cm);



sub getTime{
	my $result='';
	my ($sec,$min,$hour,$day,$month,$yr19,@rest) =   localtime(time);
	$month++;
	$yr19+=1900;
	$result="$yr19-$month-$day $hour:$min:$sec";
	return $result;
}

