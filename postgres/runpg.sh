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

if [ ! -d "${PGDATA}/base" ]; then
	echo "$PGDATA does not exist. creating database."
	${appdir}/initdb -D $PGDATA
	${appdir}/pg_ctl -o "-p ${tmpport}" -D $PGDATA start
	#need to wait for it to start
	sleep 3;
	psql -p ${tmpport} --command "CREATE USER rstudio createdb"
	createdb -p ${tmpport} -O rstudio rstudio
	psql -p ${tmpport} --command "CREATE USER hive"
	createdb -p ${tmpport} -O hive hive
	createdb -p ${tmpport} -O rstudio dataexpo
	createdb -p ${tmpport} -O rstudio testdb

	psql -p ${tmpport} -U rstudio dataexpo </opt/dataexpo.sql >/dev/null
	#just to be sure, as there were problems accessing this once
	psql -p ${tmpport} --command "GRANT ALL PRIVILEGES ON DATABASE dataexpo TO rstudio"
	service postgresql stop
	cd /usr/share/postgresql/${pgversion}
fi


/usr/bin/pg_ctlcluster ${pgversion} main start --foreground
