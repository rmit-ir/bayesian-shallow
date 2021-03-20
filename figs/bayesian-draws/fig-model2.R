source("../../R/compute_cis.R", chdir=TRUE)
library(brms)
library(stringr);
library(ggplot2);
library(dplyr);
library(bayesplot)

args = commandArgs(trailingOnly=TRUE)

dataset <- args[1]
load(paste0("../../R/", dataset, "_model2.Rdata"))
p <- pp_check(model2, nsamples = 100)
p <- p + theme(legend.position="none")

p <- p + theme(panel.spacing=unit(1, "lines"))
p <- p + xlab("RBP $\\phi = 0.5$")
p <- p + ylab("Density")
p <- p + yaxis_text(TRUE)
p <- p + yaxis_ticks(TRUE)
p <- p + coord_cartesian(xlim = c(0, 1), ylim = c(0, 2))
p <- p + theme(legend.background = element_blank(), 
               legend.key=element_blank())
p <- p + theme(axis.text = element_text(size = 11), axis.title.x=element_blank(), axis.title.y=element_blank()) # changes axis labels

ggsave(p, file="s-round1-model2.pdf", width=3, height=1)
