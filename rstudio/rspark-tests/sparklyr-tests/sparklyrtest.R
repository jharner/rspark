# load sparklyr
if (nchar(Sys.getenv("HADOOP_HOME")) < 1) {
  Sys.setenv(HADOOP_HOME = "/opt/hadoop")
}
if (nchar(Sys.getenv("SPARK_HOME")) < 1) {
  Sys.setenv(SPARK_HOME = "/opt/spark")
}
library(sparklyr)
library(dplyr)

# start the sparklyr session
# sc <- spark_connect(master = "local")
master <- "local"
sc <- spark_connect(master, spark_home = Sys.getenv("SPARK_HOME"),
                    method = c("shell"), app_name = "sparklyr",
                    version = NULL, hadoop_version = NULL,
                    config = spark_config(),
                    extensions = sparklyr::registered_extensions())

faithful_tbl <- copy_to(sc, faithful, "faithful")
src_tbls(sc)

# stop the SparkR session
spark_disconnect(sc)
