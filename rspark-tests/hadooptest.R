options(warn=-1)
library(rhdfs)
library(rmr2)

hdfs.init()

# list the directories and files in /tmp
hdfs.ls(path = "/user/rstudio")

# using mapreduce: note rmr2 has its own interface with hdfs
small.ints = to.dfs(1:100)

# a simpple map job (the key is null)
out.data <- mapreduce(
  input = small.ints,
  map = function(k, v) cbind(v, v^2))

out.data <- from.dfs(out.data)
str(out.data)
head(out.data$val)
