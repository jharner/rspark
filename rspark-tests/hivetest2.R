library("RJDBC")
library("DBI")
library("rJava")

drv <- JDBC("org.apache.hive.jdbc.HiveDriver", "/opt/hive/jdbc/hive-jdbc-2.1.1-standalone.jar", identifier.quote = "'")

conn = dbConnect(drv
                 , "jdbc:hive2://hive:10000/rstudio"
                 , "rstudio", "")

databases <- dbGetQuery(conn, "show databases")
databases

tables <- dbGetQuery(conn, "show tables")
tables

test1 <- dbGetQuery(conn, "describe test1")
test1

Sys.time()
ukcrimesum <- dbGetQuery(conn, "select * from test1")
Sys.time()
dim(ukcrimesum)
