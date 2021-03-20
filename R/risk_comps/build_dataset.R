Sys.setenv('R_MAX_VSIZE'=32000000000)
require(dplyr)

args = commandArgs(trailingOnly=TRUE)
a <- as.numeric(args[1])

files <- list.files(path="./systems", pattern="*.Rdata", full.names=TRUE, recursive=FALSE)

final <- data.frame(system = character(), alpha = numeric(), topic = numeric(), draw = numeric(), urisk = numeric())

# load all systems into memory
for (rfile in files) {
    load(rfile)

    final <- rbind(final, result)
}

save(final, file="final.Rdata")
load("final.Rdata")

filt <- final %>% filter(alpha == a)
rm(final)

filt_wins <- filt %>% filter(urisk < 0)
filt_losses <- filt %>% filter(urisk > 0)

filt_wins_agg <- aggregate(urisk ~ draw + system, data=filt_wins, FUN="mean")
filt_losses_agg <- aggregate(urisk ~ draw + system, data=filt_losses, FUN="mean")
filt_agg <- aggregate(urisk ~ draw + system, data=filt, FUN="mean")
save(filt_wins_agg, filt_losses_agg, filt_agg, file=paste0("filt_", a, ".Rdata"))
