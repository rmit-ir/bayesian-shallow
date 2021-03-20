for round in round1 
do
    Rscript fig-model1.R $round
    Rscript fig-model2.R $round
    Rscript fig-model3.R $round
done

rm -f *.aux *.log
