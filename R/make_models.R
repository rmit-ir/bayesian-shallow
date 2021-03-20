source("compute_cis.R")

dataset <- "round1"

# Different models no risk
##
date()
print("Gaussian")
model <- compute_bayesian_model(paste0("../data/", dataset, "_data.csv"), 
                                paste0("../data/", dataset, "_pooled.csv"), 
                                FALSE, 1)
save(model, file=paste0(dataset, "_model1.Rdata"))
date()

print("Zero-One Inflated Beta")
model2 <- compute_bayesian_model(paste0("../data/", dataset, "_data.csv"), 
                                paste0("../data/", dataset, "_pooled.csv"), 
                                FALSE, 2)
save(model2, file=paste0(dataset, "_model2.Rdata"))

print(date())
print("Zero-One Inflated Beta Per-Document")
model3 <- compute_bayesian_model(paste0("../data/", dataset, "_rbpgain.csv"), 
                                paste0("../data/", dataset, "_pooled.csv"), 
                                FALSE, 3)
save(model3, file=paste0(dataset, "_model3.Rdata"))
