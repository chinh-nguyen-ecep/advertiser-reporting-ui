#!/bin/sh
#
# CREATE TABLE t_partner_location (
#	partner_id	integer,
#	group_name	varchar,
#	partner_name	varchar,
#	city		varchar,
#	stateabbr	varchar,
#	zipcode		varchar,
#	dmacode		smallint,
#	dmaname		varchar,
#	uniques		integer,
#	views		integer
# );
#

if [ -z $1 ]; then
    echo "Call with month (e.g., 2010-Jul) to run." >&2
    exit 1
fi

echo "Truncating table..." >&2
psql -qd warehouse -p 5433 <<EOSQL
TRUNCATE TABLE t_partner_location;
EOSQL

echo "Loading partners..." >&2
echo "(enter password for vrvuser@vrvdetails)" >&2

mysql -u vrvuser -h dbread -p -NB vrvdetails <<EOSQL | \
  psql -c "COPY t_partner_location(partner_id, group_name, partner_name, city, stateabbr, zipcode) FROM stdin" \
  -d warehouse
SELECT p.id, ae2.name, p.name, l.city, l.state, l.zip
FROM partner p
JOIN administrative_entity ae1 ON p.id = ae1.partner_id
JOIN administrative_entity ae2 ON ae1.parent_id = ae2.id
JOIN location l ON p.id = l.partner_id
WHERE p.dtdeleted IS NULL AND l.type = 99;
EOSQL

echo "Updating partner DMAs and traffic..." >&2
psql -qd warehouse -p 5433 <<EOSQL
UPDATE t_partner_location a SET dmacode = b.dmacode, dmaname = b.dmaname
FROM t_dma_dim b
WHERE a.zipcode = b.zipcode;

UPDATE t_partner_location a SET uniques = b.unique_view_count, views = b.page_view_count
FROM monthly_agg_partner_act_all b
WHERE a.partner_id = b.partner_id AND b.organic = 't' AND b.is_active = 't' AND b.calendar_year_month = '$1';

DELETE FROM dw.monthly_agg_partner_dma_sumary
WHERE calendar_year_month='$1';
 
INSERT INTO dw.monthly_agg_partner_dma_sumary(
            calendar_year_month, partner_id, group_name, partner_name, city, 
            stateabbr, zipcode, dmacode, dmaname, uniques, views, 
            is_active, process_id)
SELECT '$1',partner_id, group_name, partner_name, city, stateabbr, zipcode, 
       dmacode, dmaname, uniques, views,true,0
FROM t_partner_location

EOSQL

echo "Spitting out results..." >&2
psql -d warehouse -p 5433 -A -c "SELECT * FROM t_partner_location"
