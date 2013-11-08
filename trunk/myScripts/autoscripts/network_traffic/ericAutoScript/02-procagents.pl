#!/usr/bin/perl -w
#
# procagents.pl
#
# Processes mobile user agents.
#
# $Id$
#

use strict;
use DBI;

my $dwhost = 'localhost';
my $dwuser = 'ejohnst';
my $port=5433;
my $dwh;

my $i = 0;
my $sth;

# Forward declarations for recursion.
sub stripuplink($$$$);
sub stripnovarra($$$$);


# Detect and strip Unwired Planet UP.Link components.
#
# Takes & returns:
#  - 0 if no up.link gateway; 1 if gateway; -1 if error.
#  - gateway version, if known; otherwise undef.
#  - cleansed agent.
#  - reason for failure, otherwise undef.
#
# Processes things recursively; only returns the last
# UP.Link values.
#
sub stripuplink($$$$)
{
	my $rc = $_[0];
	my $inver = $_[1];
	my $ua = $_[2];
	my $errmsg = $_[3];
	my $ver;

	if ($ua !~ /\s*up\.link/) {
		return ($rc, $inver, $ua, $errmsg);
	}

	# We require a version to accompany up.link.
	#
	# up.link/6.31.20.0
	# up.link/6.31.20.06.3.1.20.06.3.1.20.0
	# up.link/4.2.3.5c
	#
	if (($ver) = ($ua =~ /\s*up\.link\/([^\s,]+)/)) {
		my $newver;

		# Magically pull out duplicates.
		while (($newver) = ($ver =~ /^((\d+\.)+\d+)(?=\1+)/)) {
			$ver = $newver;
		}

		# Check that it's a reasonable version.
		if ($ver !~ /^(\d+\.){3,4}\d+[a-z]?$/ &&
		    $ver !~ /^1\.[01]$/ &&
		    $ver !~ /^5\.1\.1a$/) {
			return (-1, undef, $ua, "unrecognized up.link version $ver");
		}

		$ua =~ s/\s*up\.link\/([^\s,]+)//;

	} else {
		return (-1, undef, $ua, 'no version for up.link');
	}

	return (stripuplink(1, $ver, $ua, undef));
}


# Detect and strip Novarra Vision proxy.
#
# Takes & returns:
#  - 0 if no novarra proxy; 1 if proxy; -1 if error.
#  - proxy version, if known; otherwise undef.
#  - cleansed agent.
#  - reason for failure, otherwise undef.
#
# Processes things recursively; only returns the last
# Novarra values.
#
sub stripnovarra($$$$)
{
	my $rc = $_[0];
	my $inver = $_[1];
	my $ua = $_[2];
	my $errmsg = $_[3];
	my $ver;

	if ($ua !~ /\s*novarra-vision/) {
		return ($rc, $inver, $ua, $errmsg);
	}

	# We require a version to accompany proxy.
	#
	# novarra-vision/7.3
	# novarra-vision/unknown
	#
	if (($ver) = ($ua =~ /\s*novarra-vision\/([^\s,\)]+)/)) {

		# Check that it's a reasonable version.
		if ($ver !~ /^\d+\.\d+$/ && $ver !~ /^unknown$/) {
			return (-1, undef, $ua, "unrecognized novarra version $ver");
		}

		if ($ver =~ /^unknown$/) { $ver = 'n/a'; }
		$ua =~ s/\s*novarra-vision\/([^\s,\)]+)//;

	} else {
		return (-1, undef, $ua, 'no version for novarra');
	}

	return (stripnovarra(1, $ver, $ua, undef));
}


# Detect and strip YesWAP proxy.
#
# Takes:
#  - agent
#
# Returns:
#  - 0 if no YesWAP proxy; 1 if proxy; -1 if error.
#  - cleansed agent.
#  - reason for failure, otherwise undef.
#
sub stripyeswap($)
{
	my $ua = $_[0];

	if ($ua =~ /\(yeswap mobile phone proxy\)/) {
		$ua =~ s/\s*\(yeswap mobile phone proxy\)//;
		return (1, $ua, undef);
	}
	return (0, $ua, undef);
}


# Detect and strip translators.
#
# Takes:
#  - agent
#
# Returns:
#  - 0 if no translator proxy; 1 if translator; -1 if error.
#  - translator.
#  - cleansed agent.
#  - reason for failure, otherwise undef.
#
sub striptranslate($)
{
	my $ua = $_[0];

	# ,gzip(gfe) (via translate.google.com)
	#
	if ($ua =~ /\(via translate.google.com\)/) {
		$ua =~ s/(,gzip\(gfe\))*\s*\(via translate.google.com\)//;
		return (1, 'Google', $ua, undef);
	}

	# (via babelfish.yahoo.com)
	#
	if ($ua =~ /\(via babelfish.yahoo.com\)/) {
		$ua =~ s/\s*\(via babelfish.yahoo.com\)//;
		return (1, 'Yahoo!', $ua, undef);
	}

	return (0, undef, $ua, undef);
}


# Detect and strip MIDP and CLDC information.
#
# Takes:
#  - agent
#
# Returns:
#  - 0 if no info; 1 if ok; -1 if error.
#  - MIDP version.
#  - CLDC version.
#  - cleansed agent.
#  - reason for failure, otherwise undef.
#
sub stripmidp($)
{
	my $ua = $_[0];
	my $midp;
	my $cldc;

	if ($ua !~ /midp/ && $ua !~ /cldc/) {
		return (0, undef, undef, $ua, undef);
	}

	# ; profile/midp-2.0 configuration/cldc-1.1
	# profile/midp2.0 configuration/cldc1.0
	# profile/midp-2.0configuration/cldc-1.1

	if (($midp, $cldc) = ($ua =~ /profile\/midp-?([\d\.]+)\s?configuration\/cldc-?([\d\.]+)/)) {
		$ua =~ s/;?\s*profile\/midp-?[\d\.]+\s?configuration\/cldc-?[\d\.]+//;
		return (1, $midp, $cldc, $ua, undef);
	}

	# midp-2.0/cldc-1.1
	# /midp2.0/cldc1.1

	if (($midp, $cldc) = ($ua =~ /midp-?([\d\.]+)\/cldc-?([\d\.]+)/)) {
		$ua =~ s/\s*\/?midp-?[\d\.]+\/cldc-?[\d\.]+//;
		return (1, $midp, $cldc, $ua, undef);
	}

	# midp-2.0 configuration/cldc-1.1
	# midp/2.0 configuration/cldc-1.1

	if (($midp, $cldc) = ($ua =~ /midp[-\/]([\d\.]+) configuration\/cldc-([\d\.]+)/)) {
		$ua =~ s/\s*midp[-\/][\d\.]+ configuration\/cldc-[\d\.]+//;
		return (1, $midp, $cldc, $ua, undef);
	}

	# profile\\midp-2.0 configuration\\cldc-1.1
	# profile\midp-2.0 configuration\cldc-1.1
	# profilemidp-2.0 configurationcldc-1.1

	if (($midp, $cldc) = ($ua =~ /profile\\*midp-([\d\.]+) configuration\\*cldc-([\d\.]+)/)) {
		$ua =~ s/\s*profile\\*midp-[\d\.]+ configuration\\*cldc-[\d\.]+//;
		return (1, $midp, $cldc, $ua, undef);
	}

	# j2me/midp;

	if ($ua =~ /j2me\/midp;/) {
		return (0, undef, undef, $ua, undef);
	}

	return (-1, undef, undef, $ua, 'unrecognized midp or cldc');
}


# Identify client applications.
#
# Takes:
#  - agent
#
# Returns:
#  - 0 if not a client; 1 if client; -1 if error.
#  - client application.
#  - client version.
#  - device vendor.
#  - device model.
#  - device name.
#  - os.
#  - platform.
#  - cleansed agent.
#  - reason for failure, otherwise undef.
#
# When device/platform info should be available in the remaining user
# agent, we don't set it.
#
sub identclient($)
{
	my $ua = $_[0];
	my $app;
	my $ver;
	my $rc = 0;
	my $is_iphone = 0;
	my $is_bb = 0;
	my $is_android = 0;

	# com.nokia.apnews.widget:1.0:<user agent>

	if (($ver) = ($ua =~ /^com\.nokia\.apnews\.widget:([\d\.]+):/)) {
		$ua =~ s/^com\.nokia\.apnews\.widget:[\d\.]+://;
		return (1, 'AP Mobile Nokia Web-Runtime Widget', $ver, undef, undef, undef, undef, undef, $ua, undef);

	# app:cp news 2.0

	} elsif (($ver) = ($ua =~ /^app:cp news ([\d\.]+)$/)) {
		$ua =~ s/^app:cp news [\d\.]+$//;
		$app = 'CP Mobile iPhone Application';
		$is_iphone = 1;

	# cp%20news/2.0 <user agent>
	# cp%20news2.0 <user agent>

	} elsif (($ver) = ($ua =~ /^cp%20news\/?([\d\.]+)\s+/)) {
		$ua =~ s/^cp%20news\/?[\d\.]+\s+//;
		$app = 'CP Mobile iPhone Application';
		$is_iphone = 1;
	}

	if ($is_iphone) {
		return (1, $app, $ver, 'Apple, Inc.', 'iPhone/iPod Touch', 'iPhone/iPod Touch', 'iPhone OS', 'iPhone', $ua, undef);
	}

	if ($is_bb) {
		return (1, $app, $ver, 'RIM', 'BlackBerry', 'n/a', 'BlackBerry', 'BlackBerry', $ua, undef);
	}

	if ($is_android) {
		return (1, $app, $ver, 'n/a', 'n/a', 'n/a', 'Android', 'n/a', $ua, undef);
	}

	return (0, undef, undef, undef, undef, undef, undef, undef, $ua, undef);
}


# Identify Opera browsers.
# http://my.opera.com/community/openweb/idopera/
#
# Takes:
#  - id, agent
#
# Returns:
#  - 0 if not a client; 1 if client; -1 if error.
#  - client application.
#  - client version.
#  - device vendor.
#  - device model.
#  - device name.
#  - os.
#  - platform.
#  - cleansed agent.
#  - reason for failure, otherwise undef.
#
# When device/platform info should be available in the remaining user
# agent, we don't set it.
#
sub identopera($$)
{
	my $id = $_[0];
	my $ua = $_[1];

	my $brsr;
	my $bver;
	my $frame;
	my $fver;
	my $platform;
	my $lang;
	my $manuf;
	my $type;

	if ($ua !~ /opera/) {
		return 0;
	}

	# opera/9.50 (j2me/midp; opera mini/4.0.10031/280; u; es)
	# opera/9.50 (j2me/midp; opera mini/4.0.10031/286; u; en)
	#
	# Evidently, it's opera mini/<browser version>/<server version>.
	# We'll ignore server version.

	if (($fver, $bver, $lang) = ($ua =~ /^opera\/([\d\.]+) \(j2me\/midp; opera mini\/([\d\.]+)\/\d+; u; (\w{2})\)$/)) {
		$brsr = 'Opera Mini';
		$frame = 'Opera';
		$platform = 'J2ME';
		$manuf = 'Unknown';
		$type = 'Unknown Mobile';

	# opera/9.60 (j2me/midp; opera mini/4.0.10031/432; u; en) presto/2.2.0
	# opera/9.60 (j2me/midp; opera mini/4.0.10031/432; u; fi) presto/2.2.0
	#
	# Presto is the layout engine.  Since the framework (Opera) version is probably
	# more important, we'll ignore it for now.

	} elsif (($fver, $bver, $lang) = ($ua =~ /^opera\/([\d\.]+) \(j2me\/midp; opera mini\/([\d\.]+)\/\d+; u; (\w{2})\) presto\/[\d\.]+$/)) {
		$brsr = 'Opera Mini';
		$frame = 'Opera';
		$platform = 'J2ME';
		$manuf = 'Unknown';
		$type = 'Unknown Mobile';

	# opera/9.80 (j2me/midp; opera mini/5.0.19376/23.411; u; en) presto/2.5.25 version/10.54

	} elsif (($fver, $bver, $lang) = ($ua =~ /^opera\/([\d\.]+) \(j2me\/midp; opera mini\/([\d\.]+)\/[\d\.]+; u; (\w{2})\) presto\/[\d\.]+ version\/[\d\.]+$/)) {
		$brsr = 'Opera Mini';
		$frame = 'Opera';
		$platform = 'J2ME';
		$manuf = 'Unknown';
		$type = 'Unknown Mobile';

	# opera/8.01 (j2me/midp; opera mini/2.0.5741/1724; en; u; ssr)
	# opera/8.01 (j2me/midp; opera mini/2.0.5741/1724; es; u; ssr)

	} elsif (($fver, $bver, $lang) = ($ua =~ /^opera\/([\d\.]+) \(j2me\/midp; opera mini\/([\d\.]+)\/\d+; (\w{2}); u; ssr\)$/)) {
		$brsr = 'Opera Mini';
		$frame = 'Opera';
		$platform = 'J2ME';
		$manuf = 'Unknown';
		$type = 'Unknown Mobile';

	# opera/9.80 (j2me/midp; opera mini; u; en) presto/2.2.0
	# opera/9.80 (j2me/midp; opera mini; u; en) presto/2.4.15

	} elsif (($fver, $lang) = ($ua =~ /^opera\/([\d\.]+) \(j2me\/midp; opera mini; u; (\w{2})\) presto\/[\d\.]+$/)) {
		$brsr = 'Opera Mini';
		$frame = 'Opera';
		$platform = 'J2ME';
		$manuf = 'Unknown';
		$type = 'Unknown Mobile';

	# opera/9.80 (j2me/midp; opera mini/5.0.3521/18.674; u; nl) presto/2.4.15
	# opera/9.80 (j2me/midp; opera mini/5.0.3521/18.678; u; en) presto/2.4.15

	} elsif (($fver, $bver, $lang) = ($ua =~ /^opera\/([\d\.]+) \(j2me\/midp; opera mini\/([\d\.]+)\/[\d\.]+; u; (\w{2})\) presto\/[\d\.]+$/)) {
		$brsr = 'Opera Mini';
		$frame = 'Opera';
		$platform = 'J2ME';
		$manuf = 'Unknown';
		$type = 'Unknown Mobile';

	# opera/9.80 (iphone; opera mini/5.0.019802/886; u; en) presto/2.4.15

	} elsif (($fver, $bver, $lang) = ($ua =~ /^opera\/([\d\.]+) \(iphone; opera mini\/([\d\.]+)\/[\d\.]+; u; (\w{2})\) presto\/[\d\.]+$/)) {
		$brsr = 'Opera Mini';
		$frame = 'Opera';
		$platform = 'iOS';
		$manuf = 'Apple, Inc.';
		$type = 'iPhone/iPod';

	# opera/9.80 (iphone; opera mini/5.0.019802/24.743; u; en) presto/2.5.25 version/10.54

	} elsif (($fver, $bver, $lang) = ($ua =~ /^opera\/([\d\.]+) \(iphone; opera mini\/([\d\.]+)\/[\d\.]+; u; (\w{2})\) presto\/[\d\.]+ version\/[\d\.]+$/)) {
		$brsr = 'Opera Mini';
		$frame = 'Opera';
		$platform = 'iOS';
		$manuf = 'Apple, Inc.';
		$type = 'iPhone/iPod';

	# opera/9.80 (android; opera mini/5.0.18302/18.684; u; en) presto/2.4.15

	} elsif (($fver, $bver, $lang) = ($ua =~ /^opera\/([\d\.]+) \(android; opera mini\/([\d\.]+)\/[\d\.]+; u; (\w{2})\) presto\/[\d\.]+$/)) {
		$brsr = 'Opera Mini';
		$frame = 'Opera';
		$platform = 'Android';
		$manuf = 'Unknown';
		$type = 'Android';

	# opera/9.80 (android; opera mini/5.1.22460/23.390; u; en) presto/2.5.25 version/10.54

	} elsif (($fver, $bver, $lang) = ($ua =~ /^opera\/([\d\.]+) \(android; opera mini\/([\d\.]+)\/[\d\.]+; u; (\w{2})\) presto\/[\d\.]+ version\/[\d\.]+$/)) {
		$brsr = 'Opera Mini';
		$frame = 'Opera';
		$platform = 'Android';
		$manuf = 'Unknown';
		$type = 'Android';

	# opera/9.80 (blackberry; opera mini/5.0.18832/18.684; u; en) presto/2.4.15

	} elsif (($fver, $bver, $lang) = ($ua =~ /^opera\/([\d\.]+) \(blackberry; opera mini\/([\d\.]+)\/[\d\.]+; u; (\w{2})\) presto\/[\d\.]+$/)) {
		$brsr = 'Opera Mini';
		$frame = 'Opera';
		$platform = 'BlackBerry';
		$manuf = 'RIM';
		$type = 'BlackBerry';

	# opera/9.80 (blackberry; opera mini/5.0.19692/23.405; u; en) presto/2.5.25 version/10.54

	} elsif (($fver, $bver, $lang) = ($ua =~ /^opera\/([\d\.]+) \(blackberry; opera mini\/([\d\.]+)\/[\d\.]+; u; (\w{2})\) presto\/[\d\.]+ version\/[\d\.]+$/)) {
		$brsr = 'Opera Mini';
		$frame = 'Opera';
		$platform = 'BlackBerry';
		$manuf = 'RIM';
		$type = 'BlackBerry';

	} else {
		$brsr = '';
	}

	if ($brsr =~ 'Opera Mini') {
		print "UPDATE user_agent_dim SET device_type = '".$type."', device_manufacturer = '".
		    $manuf."', organic = 't', auto_generated = 'f' WHERE auto_generated = 't' AND ".
		    "device_type = 'Unallocated' AND user_agent_sk = ".$id.";\n";
		return 1;
	} else {
		#print "$ua\n";
		return 0;
	}

}


# Identify WebOS (Palm) browsers.
#
# Takes:
#  - id, agent
#
# Returns:
#  - 0 if not a client; 1 if client; -1 if error.
#  - client application.
#  - client version.
#  - device vendor.
#  - device model.
#  - device name.
#  - os.
#  - platform.
#  - cleansed agent.
#  - reason for failure, otherwise undef.
#
# When device/platform info should be available in the remaining user
# agent, we don't set it.
#
sub identwebos($$)
{
	my $id = $_[0];
	my $ua = $_[1];

	my $brsr;
	my $bver;
	my $frame;
	my $fver;
	my $platform;
	my $lang;
	my $manuf;
	my $type;

	if ($ua !~ /webos/) {
		return 0;
	}

	# mozilla/5.0 (webos/1.4.1.1; u; en-us) applewebkit/532.2 (khtml, like gecko) version/1.0 safari/532.2 pixi/1.1

	if (($lang) = ($ua =~ /^mozilla\/5\.0 \(webos\/[\d\.]+; u; (\w{2})-(\w{2})\) applewebkit\/[\d\.]+ \(khtml, like gecko\) version\/[\d\.]+ safari\/[\d\.]+ pixi\/[\d\.]+$/)) {
		$brsr = 'Safari';
		$frame = 'WebKit';
		$platform = 'WebOS';
		$manuf = 'Palm';
		$type = 'Smartphone';

	} elsif (($lang) = ($ua =~ /^mozilla\/5\.0 \(webos\/[\d\.]+; u; (\w{2})-(\w{2})\) applewebkit\/[\d\.]+ \(khtml, like gecko\) version\/[\d\.]+ safari\/[\d\.]+ pre\/[\d\.]+$/)) {
		$brsr = 'Safari';
		$frame = 'WebKit';
		$platform = 'WebOS';
		$manuf = 'Palm';
		$type = 'Smartphone';

	} else {
		$brsr = '';
	}

	if ($brsr =~ 'Safari') {
		print "UPDATE user_agent_dim SET device_type = '".$type."', device_manufacturer = '".
		    $manuf."', organic = 't', auto_generated = 'f' WHERE auto_generated = 't' AND ".
		    "device_type = 'Unallocated' AND user_agent_sk = ".$id.";\n";
		return 1;
	} else {
		#print "$ua\n";
		return 0;
	}
}


# Identify iPhone browsers.
#
# Takes:
#  - id, agent
#
# Returns:
#  - 0 if not a client; 1 if client; -1 if error.
#  - client application.
#  - client version.
#  - device vendor.
#  - device model.
#  - device name.
#  - os.
#  - platform.
#  - cleansed agent.
#  - reason for failure, otherwise undef.
#
# When device/platform info should be available in the remaining user
# agent, we don't set it.
#
sub identiphone($$)
{
	my $id = $_[0];
	my $ua = $_[1];

	my $brsr;
	my $bver;
	my $frame;
	my $fver;
	my $platform;
	my $lang;
	my $manuf;
	my $type;

	if ($ua !~ /iphone/ && $ua !~ /ipad/) {
		return 0;
	}

	# mozilla/5.0 (ipod; u; cpu iphone os 3_1_3 like mac os x; fr-fr) applewebkit/528.18 (khtml, like gecko) mobile/7e18

	if (($lang) = ($ua =~ /^mozilla\/5\.0 \(ipod; u; cpu iphone os [\d_]+ like mac os x; (\w{2})-\w{2}\) applewebkit\/[\d\.]+ \(khtml, like gecko\) mobile\/[\da-g]+$/)) {
		$brsr = 'Safari';
		$frame = 'WebKit';
		$platform = 'iPhone OS';
		$manuf = 'Apple, Inc.';
		$type = 'iPhone/iPod';

	} elsif (($lang) = ($ua =~ /^mozilla\/5\.0 \(iphone; u; cpu iphone os [\d_]+ like mac os x; (\w{2})-\w{2}\) applewebkit\/[\d\.]+ \(khtml, like gecko\) mobile\/[\da-g]+$/)) {
		$brsr = 'Safari';
		$frame = 'WebKit';
		$platform = 'iPhone OS';
		$manuf = 'Apple, Inc.';
		$type = 'iPhone/iPod';

	# mozilla/5.0 (ipad; u; cpu iphone os 3_2 like mac os x; en-us) applewebkit/531.21.10 (khtml, like gecko) version/4.0.4 mobile/7b313 safari/531.21.10

	} elsif (($lang) = ($ua =~ /^mozilla\/5\.0 \(ipad; u; cpu iphone os [\d_]+ like mac os x; (\w{2})-\w{2}\) applewebkit\/[\d\.]+ \(khtml, like gecko\) version\/[\d\.]+ mobile\/[\da-g]+ safari\/[\d\.]+$/)) {
		$brsr = 'Safari';
		$frame = 'WebKit';
		$platform = 'iPhone OS';
		$manuf = 'Apple, Inc.';
		$type = 'iPad';

	# mozilla/5.0 (ipad; u; cpu os 3_2_1 like mac os x; en-us) applewebkit/531.21.10 (khtml, like gecko) version/4.0.4 mobile/7b405 safari/531.21.10

	} elsif (($lang) = ($ua =~ /^mozilla\/5\.0 \(ipad; u; cpu os [\d_]+ like mac os x; (\w{2})-\w{2}\) applewebkit\/[\d\.]+ \(khtml, like gecko\) version\/[\d\.]+ mobile\/[\da-g]+ safari\/[\d\.]+$/)) {
		$brsr = 'Safari';
		$frame = 'WebKit';
		$platform = 'iPhone OS';
		$manuf = 'Apple, Inc.';
		$type = 'iPad';

	# mozilla/5.0 (ipad; u; cpu os 3_2_2 like mac os x; en-us) applewebkit/531.21.10 (khtml, like gecko) mobile/7b500

	} elsif (($lang) = ($ua =~ /^mozilla\/5\.0 \(ipad; u; cpu os [\d_]+ like mac os x; (\w{2})-\w{2}\) applewebkit\/[\d\.]+ \(khtml, like gecko\) mobile\/[\da-g]+$/)) {
		$brsr = 'Safari';
		$frame = 'WebKit';
		$platform = 'iPhone OS';
		$manuf = 'Apple, Inc.';
		$type = 'iPad';

	} elsif (($lang) = ($ua =~ /^mozilla\/5\.0 \(iphone; u; cpu iphone os [\d_]+ like mac os x; (\w{2})-\w{2}\) applewebkit\/[\d\.]+ \(khtml, like gecko\) version\/[\d\.]+ mobile\/[\da-g]+ safari\/[\d\.]+$/)) {
		$brsr = 'Safari';
		$frame = 'WebKit';
		$platform = 'iPhone OS';
		$manuf = 'Apple, Inc.';
		$type = 'iPhone/iPod';

	} elsif (($lang) = ($ua =~ /^mozilla\/5\.0 \(ipod; u; cpu iphone os [\d_]+ like mac os x; (\w{2})-\w{2}\) applewebkit\/[\d\.]+ \(khtml, like gecko\) version\/[\d\.]+ mobile\/[\da-g]+ safari\/[\d\.]+$/)) {
		$brsr = 'Safari';
		$frame = 'WebKit';
		$platform = 'iPhone OS';
		$manuf = 'Apple, Inc.';
		$type = 'iPhone/iPod';

	} else {
		$brsr = '';
	}

	if ($brsr =~ 'Safari') {
		print "UPDATE user_agent_dim SET device_type = '".$type."', device_manufacturer = '".
		    $manuf."', organic = 't', auto_generated = 'f' WHERE auto_generated = 't' AND ".
		    "device_type = 'Unallocated' AND user_agent_sk = ".$id.";\n";
		return 1;
	} else {
		#print "$ua\n";
		return 0;
	}
}


# Identify Maemo browsers.
#
# Takes:
#  - id, agent
#
# Returns:
#  - 0 if not a client; 1 if client; -1 if error.
#  - client application.
#  - client version.
#  - device vendor.
#  - device model.
#  - device name.
#  - os.
#  - platform.
#  - cleansed agent.
#  - reason for failure, otherwise undef.
#
# When device/platform info should be available in the remaining user
# agent, we don't set it.
#
sub identmaemo($$)
{
	my $id = $_[0];
	my $ua = $_[1];

	my $brsr;
	my $bver;
	my $frame;
	my $fver;
	my $platform;
	my $lang;
	my $manuf;
	my $type;

	if ($ua !~ /maemo/) {
		return 0;
	}

	# mozilla/5.0 (x11; u; linux armv7l; en-us; rv:1.9.2b6pre) gecko/20100318 firefox/3.5 maemo browser 1.7.4.8 rx-51 n900
	# mozilla/5.0 (x11; u; linux armv7l; it-it; rv:1.9.2b6pre) gecko/20100318 firefox/3.5 maemo browser 1.7.4.8 rx-51 n900

	if (($lang) = ($ua =~ /^mozilla\/5\.0 \(x11; u; linux armv7l; (\w{2})-\w{2}\; rv:[\d\.ab]+pre\) gecko\/\d+ firefox\/[\d\.]+ maemo browser [\d\.]+ rx\-51 n900$/)) {
		$brsr = 'Firefox';
		$frame = 'Gecko';
		$platform = 'Maemo';
		$manuf = 'Nokia';
		$type = 'Maemo';

	} else {
		$brsr = '';
	}

	if ($brsr =~ 'Firefox') {
		print "UPDATE user_agent_dim SET device_type = '".$type."', device_manufacturer = '".
		    $manuf."', organic = 't', auto_generated = 'f' WHERE auto_generated = 't' AND ".
		    "device_type = 'Unallocated' AND user_agent_sk = ".$id.";\n";
		return 1;
	} else {
		#print "$ua\n";
		return 0;
	}
}


# Identify Android browsers.
#
# Takes:
#  - id, agent
#
# Returns:
#  - 0 if not a client; 1 if client; -1 if error.
#  - client application.
#  - client version.
#  - device vendor.
#  - device model.
#  - device name.
#  - os.
#  - platform.
#  - cleansed agent.
#  - reason for failure, otherwise undef.
#
# When device/platform info should be available in the remaining user
# agent, we don't set it.
#
sub identandroid($$)
{
	my $id = $_[0];
	my $ua = $_[1];

	my $brsr;
	my $bver;
	my $frame;
	my $fver;
	my $platform;
	my $lang;
	my $country;
	my $model;
	my $model2;
	my $build;
	my $manuf = '';
	my $uamanuf = '';
	my $type;


	if ($ua !~ /android/) {
		return 0;
	}

	# mozilla/5.0 (linux; u; android 2.2; en-us; nexus one build/frf50) applewebkit/533.1 (khtml, like gecko) version/4.0 mobile safari/533.1

	if (($fver, $lang, $country, $model, $build) = ($ua =~ /^mozilla\/5\.0 \(linux; u; android (.+?); (\w{2})-(\w{2}); (.+?) build\/([\d\._\-a-z]+?)\) applewebkit\/[\d\.\+]+\s?\(khtml, like gecko\) version\/[\d\.]+ mobile safari\/[\d\.]+$/)) {
		if ($fver ne '1.0.15' && $fver ne '1.5' && $fver ne '1.6' && $fver ne '2.0' && $fver ne '2.0.1' && $fver ne '2.1' && $fver ne '2.1-update1' && $fver ne '2.1-update2' && $fver ne '2.2' && $fver ne '2.1-fresh' && $fver ne '2.2.1' && $fver ne '2.3' && $fver ne '2.3.1' && $fver ne '2.4' && $fver ne '2.2-update1' && $fver ne '2.3.2' && $fver ne '2.2.2' && $fver ne '2.3.3' && $fver ne '2.3.4' && $fver ne '2.3.5' && $fver ne '2.3.6' && $fver ne '2.3.7' && $fver ne '3.0.1' && $fver ne '3.2' && $fver ne '4.0.1' && $fver ne '4.1') {
			print STDERR "error: unknown android version (".$fver.")\n";
			return 0;
		}

		$brsr = 'Safari';
		$frame = 'WebKit';
		$platform = 'Android';
		$type = 'Android';

		if ($model =~ /htc/ || $model eq 'hero200' || $model eq 'sprint apa7373kt' || $model eq 'sprint apa9292kt' || $model eq 't-mobile mytouch 3g' || $model eq 'desire_a8181' || $model eq 't-mobile g1' || $model eq 'a6277' || $model eq 'pc36100' || $model eq 'nexus one' || $model eq 'adr6300' || $model eq 't-mobile g2' || $model eq 'mytouch4g' || $model eq 'adr6400l' || $model eq 'usccadr6275us carrier id 45' || $model eq 'adr6400l 4g' || $model eq 'adr6225' || $model eq 'pcdadr6350' || $model eq 'sprint apx515ckt' || $model eq 'sensation_4g') {
			$manuf = 'HTC';

		} elsif ($model =~ /motorola/ || $model eq 'mb501' || $model eq 'devour' || $model eq 'opus one' || $model eq 'droidx' || $model eq 'droid' || $model eq 'droid2' || $model eq 'a854' || $model eq 'mb502' || $model eq 'mb300' || $model eq 'droid2 global' || $model eq 'droid pro' || $model eq 'mb860' || $model eq 'mb525' || $model eq 'xoom' || $model eq 'droidx' || $model eq 'droid3' || $model eq 'droid bionic 4g' || $model eq 'droid x2' || $model eq 'droid2 global') {
			$manuf = 'Motorola';

		} elsif ($model eq 'gt-i9000' || $model eq 't-mobile_espresso' || $model eq 'sgh-t959' || $model eq 'samsung-sgh-i897/i897ucje1' || $model eq 'behold2' || $model eq 'gt-i5700' || $model eq 'shw-m110s' || $model eq 'sch-r880' || $model eq 'samsung-sgh-i897/i897ucjf6' || $model eq 'sph-m910' || $model eq 'sch-i500' || $model eq 'sph-d700' || $model eq 'samsung-sgh-i897/i897ucjh7' || $model eq 'samsung-sgh-i897/i897ucji6' || $model eq 'gt-i9000m' || $model eq 'gt-i5801' || $model eq 'gt-i5800' || $model eq 'sch-i800' || $model eq 'gt-p1000' || $model eq 'sph-m920' || $model eq 'samsung-sgh-i896' || $model eq 'sgh-t849' || $model eq 'sph-p100' || $model eq 'samsung-sgh-i897/i897uckb1' || $model eq 'sgh-t959v' || $model eq 'sch-i510 4g' || $model eq 'sph-d710' || $model eq 'gt-i9100' || $model eq 'samsung-sgh-i897' || $model eq 'samsung-sgh-i997' || $model eq 'sph-m820' || $model eq 'nexus s 4g') {
			$manuf = 'Samsung';

		} elsif ($model eq 'sonyericssonx10i' || $model eq 'sonyericssonx10a' || $model eq 'sonyericssonso-01b') {
			$manuf = 'SonyEricsson';

		} elsif ($model eq 'ally' || $model eq 'ls670' || $model eq 'vortex' || $model eq 'lg-p509' || $model eq 'vm670' || $model eq 'lg-ms690') {
			$manuf = 'LG Group';

		} elsif ($model eq 'liquid') {
			$manuf = 'Acer';

		} elsif ($model eq 'archos5' || $model eq 'a70hb') {
			$manuf = 'Archos';

		} elsif ($model eq 'zio') {
			$manuf = 'Kyocera';

		} elsif ($model eq 'm860' || $model eq 'huawei-m860') {
			$manuf = 'Huawei';

		} elsif ($model eq 'cbw blaze') {
			$manuf = 'Commtiva';
		}

	# mozilla/5.0 (linux; u; android 2.2; en-us; droid2 build/vzw) applewebkit/533.1 (khtml, like gecko) version/4.0 mobile safari/533.1 480x854 motorola droid2

	} elsif (($fver, $lang, $country, $model, $build, $uamanuf, $model2) = ($ua =~ /^mozilla\/5\.0 \(linux; u; android (.+?); (\w{2})-(\w{2}); (.+?) build\/([\da-z]+?)\) applewebkit\/[\d\.\+]+ \(khtml, like gecko\) version\/[\d\.]+ mobile safari\/[\d\.]+ \d{3}x\d{3} (.+?) (.+?)$/)) {
		if ($fver ne '1.0.15' && $fver ne '1.5' && $fver ne '1.6' && $fver ne '2.0' && $fver ne '2.0.1' && $fver ne '2.1' && $fver ne '2.1-update1' && $fver ne '2.1-update2' && $fver ne '2.2' && $fver ne '2.1-fresh' && $fver ne '2.2.1') {
			return 0;
		}

		if ($build !~ /^[\da-z]+$/) {
			return 0;
		}

		$brsr = 'Safari';
		$frame = 'WebKit';
		$platform = 'Android';
		$type = 'Android';

		if ($model eq $model2 && ($model =~ /motorola/ || $model eq 'mb501' || $model eq 'devour' || $model eq 'opus one' || $model eq 'droidx' || $model eq 'droid' || $model eq 'droid2' || $model eq 'droid pro')) {
			$manuf = 'Motorola';
		}

	} else {
		$brsr = '';
	}

	if ($brsr =~ 'Safari' && length($manuf)) {
		print "UPDATE user_agent_dim SET device_type = '".$type."', device_manufacturer = '".
		    $manuf."', organic = 't', auto_generated = 'f' WHERE auto_generated = 't' AND ".
		    "device_type = 'Unallocated' AND user_agent_sk = ".$id.";\n";
		return 1;
	} else {
		#print "$ua\n";
		return 0;
	}
}


# Identify BlackBerry browsers.
#
# Takes:
#  - id, agent
#
# Returns:
#  - 0 if not a client; 1 if client; -1 if error.
#  - client application.
#  - client version.
#  - device vendor.
#  - device model.
#  - device name.
#  - os.
#  - platform.
#  - cleansed agent.
#  - reason for failure, otherwise undef.
#
# When device/platform info should be available in the remaining user
# agent, we don't set it.
#
sub identbb($$)
{
	my $id = $_[0];
	my $ua = $_[1];

	my $brsr;
	my $bver;
	my $frame;
	my $fver;
	my $platform;
	my $lang;
	my $manuf;
	my $type;

	if ($ua !~ /blackberry/) {
		return 0;
	}

	# blackberry8830/4.5.0.186 profile/midp-2.0 configuration/cldc-1.1 vendorid/105

	if (($lang) = ($ua =~ /^blackberry\d{4}[ifm]?\/[\d\.]+ vendorid\/\d+$/)) {
		$brsr = 'BlackBerry';
		$frame = 'BlackBerry';
		$platform = 'BlackBerry';
		$manuf = 'RIM';
		$type = 'BlackBerry';

	# mozilla/5.0 (blackberry; u; blackberry 9800; en-us) applewebkit/534.1+ (khtml, like gecko) version/6.0.0.141 mobile safari/534.1+

	} elsif (($lang) = ($ua =~ /^mozilla\/5\.0 \(blackberry; u; blackberry \d+; (\w{2})-\w{2}\) applewebkit\/[\d\.\+]+ \(khtml, like gecko\) version\/[\d\.]+ mobile safari\/[\d\.\+]+$/)) {
		$brsr = 'Safari';
		$frame = 'WebKit';
		$platform = 'BlackBerry';
		$manuf = 'RIM';
		$type = 'BlackBerry';

	} else {
		$platform = '';
	}

	if ($platform =~ 'BlackBerry') {
		print "UPDATE user_agent_dim SET device_type = '".$type."', device_manufacturer = '".
		    $manuf."', organic = 't', auto_generated = 'f' WHERE auto_generated = 't' AND ".
		    "device_type = 'Unallocated' AND user_agent_sk = ".$id.";\n";
		return 1;
	} else {
		#print "$ua\n";
		return 0;
	}
}


# Connect to the database.
#
$dwh = DBI->connect("DBI:Pg:dbname=warehouse;host=$dwhost;port=$port", $dwuser, 'blade2earth',
    {AutoCommit => 0}) || die "Cannot connect to data warehouse!";


$sth = $dwh->prepare('SELECT user_agent_sk, user_agent_name, '.
    'device_manufacturer, device_type, organic FROM user_agent_dim '.
    "WHERE user_agent_sk > 0 AND (lower(user_agent_name) LIKE '%opera%' OR lower(user_agent_name) LIKE '%webos%' OR lower(user_agent_name) LIKE '%iphone%' OR lower(user_agent_name) LIKE '%ipad%' OR lower(user_agent_name) LIKE '%maemo%' OR lower(user_agent_name) LIKE '%android%' OR lower(user_agent_name) LIKE '%blackberry%') ".
    "AND auto_generated = 't' AND device_type = 'Unallocated'") ||
    die 'Cannot prepare: ' . $dwh->errstr;

$sth->execute || die 'Cannot execute: '.$sth->errstr;


while (my @row = $sth->fetchrow) {
	my $id;
	my $ua;

	my $rc;
	my $ver;
	my $errmsg;
	my $tmp;

	my $is_mobile = 0;

	my $is_gatewayed = 0;
	my $gateway;
	my $gateway_version;

	my $is_proxied = 0;
	my $proxy;
	my $proxy_version;

	my $is_translated = 0;
	my $translator;

	my $is_apiclient = 0;
	my $apiclient;
	my $apiclient_version;

	my $midp_version;
	my $cldc_version;

	my $device_vendor;
	my $device_model;
	my $device_name;

	my $os;
	my $platform;

	$id = $row[0];

	# Normalize to all lowercase.
	$ua = lc($row[1]);

	# For some reason, a lot of agents seem to have "user-agent: "
	# prepended.  Get rid of it.

	$ua =~ s/^user-agent: //;


	# First, we'll take care of gateways, proxys, and translators.
	# These can tell us some useful info about the agent, such as
	# whether it's a mobile device.  Also, stripping the strings they
	# tack on simplifies our identification task.

	# UP.Link gateway.
	# Implies mobile.
	#
	($rc, $ver, $ua, $errmsg) = stripuplink(0, undef, $ua, undef);
	if ($rc == -1) {
		print STDERR "error: $errmsg ($ua)\n";
		next;
	} elsif ($rc == 1) {
		$is_mobile = 1;
		$is_gatewayed = 1;
		$gateway = 'UP.Link';
		$gateway_version = $ver;
	}
	
	# Novarra Vision proxy.
	# Implies mobile.
	#
	($rc, $ver, $ua, $errmsg) = stripnovarra(0, undef, $ua, undef);
	if ($rc == -1) {
		print STDERR "error: $errmsg ($ua)\n";
		next;
	} elsif ($rc == 1) {
		$is_mobile = 1;
		$is_proxied = 1;
		$proxy = 'Novarra Vision';
		$proxy_version = $ver;
	}

	# YesWAP proxy.
	# Implies mobile.
	#
	($rc, $ua, $errmsg) = stripyeswap($ua);
	if ($rc == -1) {
		print STDERR "error: $errmsg ($ua)\n";
		next;
	} elsif ($rc == 1) {
		if ($is_proxied) {
			$errmsg = 'multiple proxies!';
		} else {
			$is_mobile = 1;
			$is_proxied = 1;
			$proxy = 'YesWAP';
			$proxy_version = 'n/a';
		}
	}

	# Translators.
	#
	($rc, $tmp, $ua, $errmsg) = striptranslate($ua);
	if ($rc == -1) {
		print STDERR "error: $errmsg ($ua)\n";
		next;
	} elsif ($rc == 1) {
		$is_translated = 1;
		$translator = $tmp;
	}


	# Identify mobile client applications.
	#
	#($rc, $apiclient, $apiclient_version, $device_vendor, $device_model,
	#    $device_name, $os, $platform, $ua, $errmsg) = identclient($ua);
	#if ($rc == -1) {
	#	#print "error: $errmsg ($ua)\n";
	#} elsif ($rc == 1) {
	#	$is_mobile = 1;
	#	$is_apiclient = 1;
	#	#print STDERR "client $apiclient, version $apiclient_version ($platform)\n";
	#}


	# Now, pull out MIDP and CLDC information.
	# http://java.sun.com/products/midp/
	# http://en.wikipedia.org/wiki/MIDP
	#
	# Implies mobile; not sure about phone.
	#
	($rc, $midp_version, $cldc_version, $ua, $errmsg) = stripmidp($ua);
	if ($rc == -1) {
		print STDERR "error: $errmsg ($ua)\n";
		next;
	} elsif ($rc == 1) {
		$is_mobile = 1;
	}


	# OK, now let's start the process of identifying actual devices.

	# Opera.
	if (identopera($id, $ua) == 1) {
		print "-- ".$ua."\n";

	} elsif (identwebos($id, $ua) == 1) {
		print "-- ".$ua."\n";

	} elsif (identiphone($id, $ua) == 1) {
		print "-- ".$ua."\n";

	} elsif (identmaemo($id, $ua) == 1) {
		print "-- ".$ua."\n";

	} elsif (identandroid($id, $ua) == 1) {
		print "-- ".$ua."\n";

	} elsif (identbb($id, $ua) == 1) {
		print "-- ".$ua."\n";
	}


	#print "$ua\n";

	$i++;
}

$sth->finish;

print STDERR "found $i agents\n";

$dwh->disconnect();
