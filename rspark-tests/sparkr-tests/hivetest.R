library(rJava)
library(DBI)
library(RJDBC)

.jinit(classpath = Sys.getenv("CLASSPATH"))
drv <- JDBC("org.apache.hive.jdbc.HiveDriver",
            classPath = "/opt/hive/jdbc/hive-jdbc-2.1.1-standalone.jar",
            identifier.quote = "'")
Sys.sleep(5)
con <- dbConnect(drv, "jdbc:hive2://hive:10000/rstudio", "rstudio", "")

dbSendUpdate(con, "drop table if exists test1 PURGE")
dbSendUpdate(con, "create table test1 (a int, b string)")
dbSendUpdate(con, "insert into test1 (a,b) values (1, 'foo')")
dbSendUpdate(con, "insert into test1 (a,b) values (2, 'bar')")

databases <- dbGetQuery(con, "show databases")
databases

tables <- dbGetQuery(con, "show tables")
tables

test1 <- dbGetQuery(con, "describe test1")
test1

query1 <- dbGetQuery(con, "select * from test1")
query1
dim(query1)

# dbWriteTable(con, "mtcars", mtcars[1:10, ])
# dbReadTable(con, "mtcars")

dbDisconnect(con)
dbUnloadDriver(drv)
rm(con, drv)


