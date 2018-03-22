#!/bin/sh

export PATH=/usr/lib/postgresql/9.6/bin:$PATH
initdb -D /opt/pg-data
pg_ctl -D /opt/pg-data start
sleep 10
psql --command "create user rstudio createdb"
psql --command "create user hive"
createdb -O rstudio rstudio
createdb -O hive hive
createdb -O rstudio dataexpo
createdb -O rstudio testdb
psql -U rstudio dataexpo < /opt/dataexpo.sql  > /dev/null
service postgresql stop

