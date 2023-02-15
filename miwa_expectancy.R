# install.packages("mvtnorm")

Expectancyfunc <- function (Validity, PredLowerCut, PredUpperCut, CritLowerCut, CritUpperCut)
{
  library(mvtnorm)
  n <- 1000
  mean <- c(0,0)
  
  lower <- c(PredLowerCut, CritLowerCut)
  upper <- c(PredUpperCut, CritUpperCut)
  corr <- diag(2)
  corr[lower.tri(corr)] <- Validity
  corr[upper.tri(corr)] <- Validity
  
  jtprob <- pmvnorm(lower, upper, mean, corr, algorithm = Miwa(steps = 128))
  
  jtprobOutput <- paste("Joint Probability: ", jtprob, sep="")
  print(jtprobOutput)
  
  xprob <- pnorm(PredUpperCut, mean=0, sd=1)-pnorm(PredLowerCut, mean=0, sd=1)
  xprobOutput <- paste("Predictor Probability: ", xprob, sep="")
  print(xprobOutput)
  
  expectancy <-
    paste(round(100*jtprob/xprob,1), "%", sep="")
 print(expectancy) 
}

# Expectancyfunc(0.545, 1, Inf, 0.67, Inf)
