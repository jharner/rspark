#!/bin/bash

PGDATA="/opt/pg-data"
pgversion="9.4"
appdir=/usr/lib/postgresql/${pgversion}/bin/
#when setting up the database, we need to not allow external connections 
# that assume everything is setup. We do this by running the server with
# a non-standard port during setup.
tmpport=5431

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

${appdir}/pg_ctl -o "-p ${tmpport}" -D $PGDATA start
sleep 3;
psql -p ${tmpport} -U rstudio dataexpo </opt/dataexpo.sql >/dev/null
#just to be sure, as there were problems accessing this once
psql -p ${tmpport} --command "GRANT ALL PRIVILEGES ON DATABASE dataexpo TO rstudio"
service postgresql stop
sleep 3;
cd /usr/share/postgresql/${pgversion}



/usr/bin/pg_ctlcluster ${pgversion} main start --foreground
