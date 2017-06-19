library(RPostgreSQL)
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="postgres", dbname='dataexpo')
dbListConnections(drv)

dbListTables(con)
dbListFields(con, "location_table")

# dbGetQuery returns a data.frame which can be used directly
meas <- dbGetQuery(con, "select * from location_table")
head(meas)
class(meas)
rm(meas)

# dbSendQuery returns a PostgreSQLResult
measures <- dbSendQuery(con, "select * from location_table")
dbGetStatement(measures)

# The default number of records to retrieve is 500 per fetch
while (!dbHasCompleted(measures)) {
  chunk <- fetch(measures, n=50)
  print(nrow(chunk))
}
class(measures)
dbClearResult(measures)

# n=-1 fetches all the remaining records
# dbFetch(measures, n=-1)

dbDisconnect(con)
dbUnloadDriver(drv)
rm(con, drv)
