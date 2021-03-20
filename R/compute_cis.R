require(brms)
require(rstan)
require(stringr)
require(dplyr)

# file_path, which contains system and topic scores
compute_bayesian_model <- function(file_path, pooled_path, strict, simtype, baseline, alpha) {
    chains <- 12
    cores <- 12
    iter <- 12000
    adapt_delta <- 0.9 #0.9999
    model <- NULL

    if (simtype == 1) {
	    model <- .run_mcmc(file_path, pooled_path, chains, cores, iter, adapt_delta, score ~ (1 | topic) + (1 | system), gaussian)
    } else if (simtype == 2) {
	    model <- .run_mcmc(file_path, pooled_path, chains, cores, iter, adapt_delta, score ~ (1 | topic) + (1 | system), zero_one_inflated_beta)
    } else if (simtype == 3) {
	    model <- .run_mcmc(file_path, pooled_path, chains, cores, iter, adapt_delta, score ~ rank + (1 | topic) + (1 | system), zero_inflated_beta)
    }

    return(model)
}

compute_all_system_cis <- function(modelfit) {
    # compute 95% intervals
    table <- as.data.frame(posterior_summary(modelfit, probs=c(.025, .5, .975)))
    table$names <- rownames(table)

    # remove metadata around system values
    allsystems <- .remove_param_metadata(table, "system")

    # subset only the systems we care about
    subsetsystems <- 
        allsystems %>% 
        select("names", "Q2.5", "Q50", "Q97.5")

    return(subsetsystems)
}

.remove_param_metadata <- function(table, effect) {
    adjusted_table <- table %>% filter(str_detect(names, paste0("r_", effect, "\\[")))
    regex1 <- paste0("r_", effect, "\\[")
    regex2 <- paste0(",Intercept\\]")
    adjusted_table <- adjusted_table %>% 
        mutate(names = str_replace(names, regex1, "")) %>% 
        mutate(names = str_replace(names, regex2, "")) 
    return(adjusted_table)
}

.run_mcmc <- function(file_path, pooled_path, chains, cores, iter, adapt_delta, formula, family) {
    d <- read.csv(file_path, header=T)
    pool <- read.csv(pooled_path, header=T) %>% filter(pooled == 1)

    d <- d[d$system %in% pool$system,]

    rgen <- brm(data=d, family=family, formula,
	chains=chains, cores=cores, iter=iter, control=list(adapt_delta=adapt_delta))

    return(rgen)
}
