source("../../R/compute_cis.R", chdir=TRUE)
library(brms)
library(stringr);
library(ggplot2);
library(dplyr);
library(cowplot)

args = commandArgs(trailingOnly=TRUE)
dataset <- args[1]
load(paste0("../../R/", dataset, "_model1.Rdata"))
system_cis <- compute_all_system_cis(model) 

system_cis$names <- str_trunc(system_cis$names, 10, "right")
system_cis <- system_cis %>% mutate(rank = dense_rank(desc(Q50)))

p <- ggplot(system_cis[system_cis$rank < 10,], aes(y=reorder(names, Q50)))
p <- p + geom_vline(aes(xintercept=0), color="#7570b3")
p <- p + geom_errorbarh(aes(xmin=`Q2.5`, xmax=`Q97.5`))
p <- p + geom_point(aes(x=`Q50`), size=1.5, shape=21, 
                    color="black", fill="#4daf4a")
p <- p + coord_cartesian()
p <- p + theme(legend.position="none")
p <- p + xlab("Omitted for Brevity")
p <- p + coord_cartesian(xlim=c(-0.35, 0.35))
p <- p + theme(legend.background = element_blank(), 
               legend.key=element_blank())
p <- p + theme(axis.ticks.x = element_blank(), axis.text.x=element_blank(), axis.title.x=element_text(size=7)) # changes axis labels
p <- p + theme(axis.line.x=element_blank())
p <- p + theme(axis.text.y = element_text(size = 10), axis.title.y=element_blank()) # changes axis labels

p2 <- ggplot(system_cis[system_cis$rank > 30,], aes(y=reorder(names, Q50)))
p2 <- p2 + geom_vline(aes(xintercept=0), color="#7570b3")
p2 <- p2 + geom_errorbarh(aes(xmin=`Q2.5`, xmax=`Q97.5`))
p2 <- p2 + geom_point(aes(x=`Q50`), size=1.5, shape=21, 
                    color="black", fill="#4daf4a")
p2 <- p2 + coord_cartesian()
p2 <- p2 + theme(legend.position="none")
p2 <- p2 + xlab("$\\alpha_i$ Estimate")
p2 <- p2 + coord_cartesian(xlim=c(-0.35, 0.35))
p2 <- p2 + theme(legend.background = element_blank(), 
               legend.key=element_blank())
p2 <- p2 + theme(axis.text.y = element_text(size = 10), axis.title.y=element_blank()) # changes axis labels

p <- plot_grid(p, p2, align = "v", nrow = 2, rel_heights = c(0.4, 0.6))
ggsave(p, file="s-bayesian-systems-round1-model1.pdf", width=2, height=3) 
