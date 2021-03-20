# Bayesian System Inference On Shallow Pools

This repository reproduces the results for the ECIR 2021 publication "Bayesian System Inference On Shallow Pools" by Rodger Benham, Alistair Moffat, and J. Shane Culpepper. If this code is adapted or used in your work, please consider citing the paper:

```latex
@inproceedings{benhambsi,  
  title={Bayesian System Inference On Shallow Pools},
  author={R. Benham and A. Moffat and J. S. Culpepper},
  booktitle={Proc. ECIR},
  year={2021},
  note={To Appear}
}
```

The code is adapted from the [SIGIR 2020 repo](https://github.com/rmit-ir/bayesian-risk) on Bayesian risk, but is trimmed down to only use `brms` and remove the need to support `rstanarm` as well. The code has been refactored to become a minimum working example that replicates the figures in the paper.

## Installing Dependencies

This codebase is written in R (tested with R 4.0.2). To install the R packages, run `./install.sh`. If all of the required packages are already installed, it will output "Required packages already installed". Please note the readme documentation in the [SIGIR 2020 repo](https://github.com/rmit-ir/bayesian-risk) on Bayesian risk if you are installing on Red Hat Linux, if all the MCMC simulations are stalling you may need to recompile `brms` and/or `rstan` with `-fno-fast-math` in your `~/.R/Makevars`.

## Details

Run `./make_graphs.sh` in the root directory of the project to generate the figures from start to finish (this will take several hours to finish, particularly the risk part). The current codebase assumes 12 cores are available on the machine; if you have more or less CPUs than this please consider editing line 9 of `./R/compute_cis.R` and the number of systems to generate risk adjusted values for concurrently in the file `./R/risk_comps/doit.sh`. We also assume at least ~2.5GB of space is available.

The `./make_graphs.sh` process is broken into these parts:

1. Generating the model fits using MCMC for each of the three statistical distributions explored in the paper (Gaussian / Zero-One Inflated Beta (ZOiB) / ZOiB Rank)
2. Generating draws from the predictive posterior distribution using `add_predicted_draws` in `./R/risk_comps/gen_wdraws.R` 
3. Computing the URisk transformation on a per-system level on these generated draws against a `bm25_baseline`
4. Merging all of these computations using `build_dataset.R` into `filt_1.Rdata` for no risk applied and `filt_2.Rdata` for losses counting as two-fold.
5. Generating all of the figures in the `./figs/` folder.