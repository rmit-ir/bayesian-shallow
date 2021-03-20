for round in round1 
do
    Rscript fig-risk.R 1
    Rscript fig-risk.R 2
done

rm -f *.aux *.log
