# load SparkR
if (nchar(Sys.getenv("SPARK_HOME")) < 1) {
  Sys.setenv(SPARK_HOME = "/opt/spark")
  }
library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))

# start the SparkR session
sparkR.session(master = "local")
# sparkR.session(master = "spark://master:7077",
#                sparkConfig = list(spark.driver.memory = '2g'),
#                sparkJars = "/opt/postgresql-42.2.2.jar")

faithful_sdf <- as.DataFrame(faithful)

head(faithful_sdf)

meas_sdf <- read.jdbc("jdbc:postgresql://postgres/dataexpo?user=rstudio",
                      tableName = "measure_table")
head(meas_sdf)

# stop the SparkR session
sparkR.session.stop()

