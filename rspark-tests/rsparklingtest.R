# load sparklyr
if (nchar(Sys.getenv("SPARK_HOME")) < 1) {
  Sys.setenv(SPARK_HOME = "/opt/spark")
}

# if ("h2o" %in% search()) { detach("h2o", unload = TRUE) }
# if (isNamespaceLoaded("h2o")){ unloadNamespace("h2o") }
# remove.packages("h2o")
# install.packages("h2o", type = "source", 
#                 repos = "http://h2o-release.s3.amazonaws.com/h2o/rel-tverberg/2/R")

options(rsparkling.sparklingwater.version = "2.0.3")

library(sparklyr)
library(rsparkling)
library(h2o)
library(dplyr)

h2o.init()

# start the sparklyr session
sc <- spark_connect(master = "local")

mtcars_tbl <- copy_to(sc, mtcars, "mtcars")
mtcars_tbl

as_h2o_frame(sc, mtcars_tbl, strict_version_check = FALSE)

# stop the SparkR session
spark_disconnect(sc)
