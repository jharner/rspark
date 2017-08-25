library(SparkR)

# start the SparkR session
sparkR.session(master = "local")

str(mtcars)
mtcars2 <- mtcars[c("mpg", "cyl")]
write.csv(mtcars2, "mtcars2.csv", col.names = FALSE)

# not working yet
sql("CREATE TABLE IF NOT EXISTS mtcars2 (car STRING, mpg DECIMAL(4, 1), cyl INT) row format delimited by ','")
sql("LOAD DATA LOCAL INPATH 'mtcars2.csv' OVERWRITE INTO TABLE mtcars2")
query <- sql("FROM mtcars SELECT mpg")

# stop the SparkR session
sparkR.session.stop()
