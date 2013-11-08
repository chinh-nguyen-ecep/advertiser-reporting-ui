-- Google

UPDATE user_agent_dim SET device_manufacturer = 'Google', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%googlebot%';
UPDATE user_agent_dim SET device_manufacturer = 'Google', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%gsa-crawler%';
UPDATE user_agent_dim SET device_manufacturer = 'Google', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%feedfetcher-google%';
UPDATE user_agent_dim SET device_manufacturer = 'Google', device_type = 'Other Inorganic', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%appengine-google%';
UPDATE user_agent_dim SET device_manufacturer = 'Google', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%http://www.google.com/bot.html%';

-- Yahoo!

UPDATE user_agent_dim SET device_manufacturer = 'Yahoo!', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%yahooseeker%';
UPDATE user_agent_dim SET device_manufacturer = 'Yahoo!', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%yahoofeedseeker%';
UPDATE user_agent_dim SET device_manufacturer = 'Yahoo!', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%yahoo!%slurp%';
UPDATE user_agent_dim SET device_manufacturer = 'Yahoo!', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%http://help.yahoo.co.jp/%';
UPDATE user_agent_dim SET device_manufacturer = 'Yahoo!', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%yahoo!%searchmonkey%';
UPDATE user_agent_dim SET device_manufacturer = 'Yahoo!', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%yahoo-newscrawler%';
UPDATE user_agent_dim SET device_manufacturer = 'Yahoo!', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%yahoo-mmcrawler%';
UPDATE user_agent_dim SET device_manufacturer = 'Yahoo!', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%yahoocachesystem%';

-- Nutch (Kinda broad, but there are many variations.)

UPDATE user_agent_dim SET device_manufacturer = 'Nutch', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%nutch%';

-- Microsoft

UPDATE user_agent_dim SET device_manufacturer = 'Microsoft', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%msiecrawler%';
UPDATE user_agent_dim SET device_manufacturer = 'Microsoft', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%msnbot%';
UPDATE user_agent_dim SET device_manufacturer = 'Microsoft', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%msrbot%';
UPDATE user_agent_dim SET device_manufacturer = 'Microsoft', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%bingbot%';
UPDATE user_agent_dim SET device_manufacturer = 'Microsoft', device_type = 'Other Inorganic', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%microsoft url control%';

-- Baidu

UPDATE user_agent_dim SET device_manufacturer = 'Baidu', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%baiduspider%';
UPDATE user_agent_dim SET device_manufacturer = 'Baidu', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%baiduimagespider%';

-- FAST

UPDATE user_agent_dim SET device_manufacturer = 'FAST', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%fast enterprise crawler%';
UPDATE user_agent_dim SET device_manufacturer = 'FAST', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%fast crawler%';

-- Heritrix

UPDATE user_agent_dim SET device_manufacturer = 'Heritrix (Internet Archive)', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%heritrix%';

-- JumpTap

UPDATE user_agent_dim SET device_manufacturer = 'JumpTap', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%jumpbot%';

-- Mowser

UPDATE user_agent_dim SET device_manufacturer = 'Mowser', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%mowser%';

-- YaCy

UPDATE user_agent_dim SET device_manufacturer = 'YaCy', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%yacybot%';
UPDATE user_agent_dim SET device_manufacturer = 'YaCy', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%www.yacy.net%';

-- Ask Jeeves

UPDATE user_agent_dim SET device_manufacturer = 'Ask Jeeves', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%ask jeeves%';

-- Alexa Internet

UPDATE user_agent_dim SET device_manufacturer = 'Alexa Internet', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%ia_archiver%';

-- iSilo

UPDATE user_agent_dim SET device_manufacturer = 'iSilo', device_type = 'Other Inorganic', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%isilox%';

-- Twitter

UPDATE user_agent_dim SET device_manufacturer = 'Twitter', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND (lower(user_agent_name) like '%twitterbot%' OR lower(user_agent_name) like '%tweetmemebot%');

-- Taptu

UPDATE user_agent_dim SET device_manufacturer = 'Taptu', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%taptu-downloader%';

-- Monitoring

UPDATE user_agent_dim SET device_manufacturer = 'WebSitePulse', device_type = 'Monitoring', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%websitepulse%';

-- Other, misc bots

UPDATE user_agent_dim SET device_manufacturer = 'Other Search Crawler', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND (lower(user_agent_name) LIKE '%njuicebot%' OR lower(user_agent_name) LIKE '%netwatch agent%' OR lower(user_agent_name) LIKE '%mj12bot%' OR lower(user_agent_name) LIKE '%ytndemo%' OR lower(user_agent_name) LIKE '%discobot%' OR lower(user_agent_name) LIKE '%orkashbot%' OR lower(user_agent_name) LIKE '%speedy spider%' OR lower(user_agent_name) LIKE '%spbot%' OR lower(user_agent_name) LIKE '%www.itah.com%' OR lower(user_agent_name) LIKE '%expertmaker habitat%' OR lower(user_agent_name) LIKE '%universalfeedparser%' OR lower(user_agent_name) LIKE '%justsignal%' OR lower(user_agent_name) LIKE '%thingfetcher%' OR lower(user_agent_name) LIKE '%entitycubebot%' OR lower(user_agent_name) LIKE '%http://knowmore.com/bots%' OR lower(user_agent_name) LIKE '%skygrid/mobile%' OR lower(user_agent_name) LIKE '%yandexbot%');

UPDATE user_agent_dim SET device_manufacturer = 'Other Search Crawler', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND (lower(user_agent_name) LIKE '%labs.topsy.com%');

UPDATE user_agent_dim SET device_manufacturer = 'Other Search Crawler', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND (lower(user_agent_name) LIKE '%sosospider%');

UPDATE user_agent_dim SET device_manufacturer = 'Other Search Crawler', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND (lower(user_agent_name) LIKE '%ahrefsbot%');

UPDATE user_agent_dim SET device_manufacturer = 'Other Search Crawler', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND (lower(user_agent_name) LIKE '%netseer%crawler%');

UPDATE user_agent_dim SET device_manufacturer = 'Other Search Crawler', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND (lower(user_agent_name) LIKE '%ezooms.bot%');

UPDATE user_agent_dim SET device_manufacturer = 'Other Search Crawler', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND (lower(user_agent_name) LIKE '%mandelbrot%');

UPDATE user_agent_dim SET device_manufacturer = 'Other Search Crawler', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND (lower(user_agent_name) LIKE '%unwindfetchor%');

UPDATE user_agent_dim SET device_manufacturer = 'Other Search Crawler', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND (lower(user_agent_name) LIKE '%paperlibot%');

UPDATE user_agent_dim SET device_manufacturer = 'Other Search Crawler', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND (lower(user_agent_name) LIKE '%summify%');

UPDATE user_agent_dim SET device_manufacturer = 'Other Search Crawler', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND (lower(user_agent_name) LIKE '%percbotspider%');

UPDATE user_agent_dim SET device_manufacturer = 'Other Search Crawler', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND (lower(user_agent_name) LIKE '%knowaboutbot%');

UPDATE user_agent_dim SET device_manufacturer = 'Other Search Crawler', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND (lower(user_agent_name) LIKE '%unisterbot%');

UPDATE user_agent_dim SET device_manufacturer = 'Other Search Crawler', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND (lower(user_agent_name) LIKE '%stumbleupon%');

UPDATE user_agent_dim SET device_manufacturer = 'Other Search Crawler', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND (lower(user_agent_name) LIKE '%findlinks%');

UPDATE user_agent_dim SET device_manufacturer = 'Other Search Crawler', device_type = 'Search Crawler', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND (lower(user_agent_name) LIKE '%eqentia-bot%');

-- Other, misc inorganics

UPDATE user_agent_dim SET device_manufacturer = 'Unknown', device_type = 'Other Inorganic', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like 'java/%';
UPDATE user_agent_dim SET device_manufacturer = 'Unknown', device_type = 'Other Inorganic', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%libcurl%';
UPDATE user_agent_dim SET device_manufacturer = 'Unknown', device_type = 'Other Inorganic', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like '%libwww-perl%';
UPDATE user_agent_dim SET device_manufacturer = 'Unknown', device_type = 'Other Inorganic', auto_generated = 'f', organic = 'f' WHERE auto_generated = 't' AND device_type = 'Unallocated' AND lower(user_agent_name) like 'wget%';

