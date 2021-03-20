source("../../R/compute_cis.R", chdir=TRUE)
library(brms)
library(stringr);
library(ggplot2);
library(dplyr);
library(ggridges)
library(cowplot)

args = commandArgs(trailingOnly=TRUE)
alpha <- as.numeric(args[1])

load(paste0("../../R/risk_comps/filt_", alpha, ".Rdata"))

filt_point <- aggregate(urisk ~ system, filt_agg, FUN="mean")

fences_lower <- filt_agg %>% group_by(system) %>% summarise(lower = as.numeric(quantile(urisk, probs=(.025))))
fences_upper <- filt_agg %>% group_by(system) %>% summarise(upper = as.numeric(quantile(urisk, probs=(.975))))
fences <- merge(fences_lower, fences_upper)
fences <- fences %>% mutate(urisk=0)

filt_point <- filt_point %>% mutate(rank = dense_rank(urisk))
filt_wins_agg <- merge(filt_wins_agg, filt_point, by.x="system", by.y="system")
filt_losses_agg <- merge(filt_losses_agg, filt_point, by.x="system", by.y="system")
filt_agg <- merge(filt_agg, filt_point, by.x="system", by.y="system")
fences <- merge(fences, filt_point, by.x="system", by.y="system")

filt_point$system <- str_trunc(filt_point$system, 10, "right")
filt_wins_agg$system <- str_trunc(filt_wins_agg$system, 10, "right")
filt_losses_agg$system <- str_trunc(filt_losses_agg$system, 10, "right")

filt_agg$system <- str_trunc(filt_agg$system, 10, "right")
fences$system <- str_trunc(fences$system, 10, "right")

p <- ggplot(filt_point[filt_point$rank < 5,], aes(y=reorder(system, -urisk.x))) 
p <- p + geom_vline(aes(xintercept=0), color="#7570b3")
p <- p + geom_density_ridges(data=filt_wins_agg[filt_wins_agg$rank < 5,], aes(x=urisk.x), fill="#91bfdb", scale=0.8, alpha=0.5) 
p <- p + geom_density_ridges(data=filt_losses_agg[filt_losses_agg$rank < 5,], aes(x=urisk.x), fill="#fc8d59", scale=0.8, alpha=0.5) 
p <- p + geom_density_ridges(data=filt_agg[filt_agg$rank < 5,], aes(x=urisk.x), fill="#ffffbf", scale=0.8, alpha=0.75)
p <- p + geom_errorbarh(data=fences[fences$rank < 5,], aes(xmin=lower, xmax=upper))
p <- p + xlab("Omitted for Brevity")
p <- p + coord_cartesian(xlim=c(-0.6, 1.25))
p <- p + theme(legend.position="none")

p <- p + theme(legend.background = element_blank(), 
               legend.key=element_blank())
p <- p + theme(axis.text.y = element_text(size = 10), axis.title.y=element_blank()) # changes axis labels
p <- p + theme(axis.ticks.x = element_blank(), axis.text.x=element_blank(), axis.title.x=element_text(size=7)) # changes axis labels
p <- p + theme(axis.line.x=element_blank())

p2 <- ggplot(filt_point[filt_point$rank > 35,], aes(y=reorder(system, -urisk.x))) 
p2 <- p2 + geom_vline(aes(xintercept=0), color="#7570b3")
p2 <- p2 + geom_density_ridges(data=filt_wins_agg[filt_wins_agg$rank > 35,], aes(x=urisk.x), fill="#91bfdb", scale=0.8, alpha=0.5) 
p2 <- p2 + geom_density_ridges(data=filt_losses_agg[filt_losses_agg$rank > 35,], aes(x=urisk.x), fill="#fc8d59", scale=0.8, alpha=0.5) 
p2 <- p2 + geom_density_ridges(data=filt_agg[filt_agg$rank > 35,], aes(x=urisk.x), fill="#ffffbf", scale=0.8, alpha=0.75)
p2 <- p2 + geom_errorbarh(data=fences[fences$rank > 35,], aes(xmin=lower, xmax=upper))
p2 <- p2 + xlab("Bayesian PPD URisk")
p2 <- p2 + coord_cartesian(xlim=c(-0.6, 1.25))
p2 <- p2 + theme(legend.position="none")
p2 <- p2 + theme(legend.background = element_blank(), 
               legend.key=element_blank())
p2 <- p2 + theme(axis.text.y = element_text(size = 10), axis.title.y=element_blank()) # changes axis labels

p <- plot_grid(p, p2, align = "v", nrow = 2, rel_heights = c(0.45, 0.55))
ggsave(p, file=paste0("s-round1-risk", alpha, ".pdf"), width=3, height=2)
