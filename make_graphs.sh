#!/usr/bin/env bash
set -e

cd R

# compute bayesian models
#echo "Making models"
#Rscript --no-save make_models.R 

echo "Doing risk comps"
cd risk_comps
./doit.sh

echo "Generating figures"
# back to root dir
cd ../../

# generate all the figures
cd figs/bayesian-analysis
./doit.sh

cd ../bayesian-draws
./doit.sh

cd ../bayesian-risk
./doit.sh
