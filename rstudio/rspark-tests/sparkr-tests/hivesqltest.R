library(SparkR)

# start the SparkR session
sparkR.session(master = "local", appName = "SparkR", sparkHome = Sys.getenv("SPARK_HOME"),
               sparkConfig = list(), enableHiveSupport = TRUE)

library(readr)
str(mtcars)
mtcars2 <- mtcars[c("mpg", "cyl")]
write_csv(mtcars2, "mtcars2.csv", col_names = FALSE)

# not working yet
sql("CREATE TABLE IF NOT EXISTS mtcars2 
    (car STRING, mpg DECIMAL(4, 1), cyl INT) row format delimited by ',' 
    USING hive")
sql("LOAD DATA LOCAL INPATH '~/mtcars2.csv' OVERWRITE INTO TABLE mtcars2")
query <- sql("FROM mtcars SELECT mpg")

# stop the SparkR session
sparkR.session.stop()
