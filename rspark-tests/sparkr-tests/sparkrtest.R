# load SparkR
if (nchar(Sys.getenv("SPARK_HOME")) < 1) {
  Sys.setenv(SPARK_HOME = "/opt/spark")
  }
library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))

# start the SparkR session
sparkR.session(master = "local",
               sparkConfig = list(spark.driver.memory = '4g'))

df <- as.DataFrame(faithful)
head(df)

# stop the SparkR session
sparkR.session.stop()

