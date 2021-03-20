require(brms)
require(reshape2)
require(dplyr)
require(data.table)
require(tidybayes)

setDTthreads(1)

dataset <- 'round1'
d <- read.csv(paste0("../../data/", dataset, "_data.csv"), header=T)
pooled <- read.csv(paste0("../../data/", dataset, "_pooled.csv"), header=T) %>% filter(pooled == 1)
dpooled <- d[d$system %in% pooled$system,]

load(paste0("../", dataset, "_model2.Rdata"))

print("making draws")
wdraws <- (dpooled %>% add_predicted_draws(model2))
save(wdraws, file="wdraws.Rdata")
