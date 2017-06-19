library("RJDBC")
.jinit(classpath = Sys.getenv("CLASSPATH"))
drv <- JDBC("org.apache.hive.jdbc.HiveDriver", "/opt/hive/jdbc/hive-jdbc-2.1.1-standalone.jar", identifier.quote = "'")
con <- dbConnect(drv, "jdbc:hive2://hive:10000/rstudio", "rstudio", "")

dbSendUpdate(con, "drop table if exists test1 PURGE")
dbSendUpdate(con, "create table test1 (a int, b string)")
dbSendUpdate(con, "insert into test1 (a,b) values (1, 'foo')")
dbSendUpdate(con, "insert into test1 (a,b) values (2, 'bar')")

print(dbReadTable(con, "test1"))
