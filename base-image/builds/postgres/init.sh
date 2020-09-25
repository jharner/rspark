#!/bin/sh

export PATH=/usr/lib/postgresql/12/bin:$PATH
initdb -D /opt/pg-data
pg_ctl -D /opt/pg-data start
sleep 10
psql --command "create user rstudio createdb"
psql --command "create user hive"
createdb -O rstudio rstudio
createdb -O hive hive
createdb -O rstudio dataexpo
createdb -O rstudio testdb
createdb -O rstudio nycflights13
psql -U rstudio dataexpo < /opt/dataexpo.sql  > /dev/null
gunzip -c /opt/nycflights13.sql.gz | psql -U rstudio nycflights13 > /dev/null
service postgresql stop

