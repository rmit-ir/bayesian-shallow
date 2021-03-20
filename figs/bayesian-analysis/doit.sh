for round in round1 
do
    Rscript fig-bayesian-gaussian.R $round
    Rscript fig-bayesian-model2.R $round
    Rscript fig-bayesian-model3.R $round
done
