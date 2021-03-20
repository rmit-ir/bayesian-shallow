require(brms)
require(reshape2)
require(dplyr)
require(data.table)
require(tidybayes)

args = commandArgs(trailingOnly=TRUE)
system_name <- args[1]
setDTthreads(1)

print("loading draws")
load("wdraws.Rdata")
print("setting up for inplace db")
setDT(wdraws)
print("setting key")
setkey(wdraws, system, topic, .draw)

urisk_1 <- matrix(NA, nrow=30, ncol=72000) 
urisk_2 <- matrix(NA, nrow=30, ncol=72000) 

print("computing scores")
for (dr in 1:72000) { 
    if (dr %% 200 == 0) {
        print(dr)
    }
    for (to in 1:30) { 
        exp <- wdraws[.(system_name, to, dr)]$.prediction 
        baseline <- wdraws[.("bm25_baseline", to, dr)]$.prediction 

        if (exp > baseline) {
            urisk_1[to, dr] <- -1 * (exp - baseline)
            urisk_2[to, dr] <- -1 * (exp - baseline)
        }
        else {
            urisk_1[to, dr] <- -1 * (1 * (exp - baseline))
            urisk_2[to, dr] <- -1 * (2 * (exp - baseline))
        }
    } 
}

urisk_1_df <- reshape2::melt(urisk_1, c("topic", "draw"), value.name = "urisk")
urisk_1_df <- urisk_1_df %>% mutate(system = system_name) %>% mutate(alpha = 1)

urisk_2_df <- reshape2::melt(urisk_2, c("topic", "draw"), value.name = "urisk")
urisk_2_df <- urisk_2_df %>% mutate(system = system_name) %>% mutate(alpha = 2)

result <- data.frame(system = character(), alpha = numeric(), topic = numeric(), draw = numeric(), urisk = numeric())
result <- rbind(result, urisk_1_df, urisk_2_df)

save(result, file=paste0("./systems/", system_name, ".Rdata"))
