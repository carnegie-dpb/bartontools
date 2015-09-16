##
## runs a batch of transmodel.fit runs for the input data in a dataframe (t, gene1, gene2, etc.) for a fixed value of nu
## returns the geometric mean of R-squared from all fits (need comparable quantity between fits)
##

source("rhop.R")
source("Rsquared.R")
source("transmodel.fit.R")

transmodel.batch = function(DF, nu=8) {

  sumR2 = 0
  N = length(DF) - 1
  dataTimes = DF[,1]
  for (i in 1:N) {
    dataValues = DF[,i+1]
    fit = transmodel.fit(nu=nu, nuFixed=TRUE, dataTimes=dataTimes, dataValues=dataValues)
    ## params from fit
    rhoc0 = 19
    gamman = 0
    rhop0 = fit$estimate[1]
    etap = fit$estimate[2]
    gammap = fit$estimate[3]
    ## get R-squared
    fitValues = dataTimes
    for (i in 1:length(dataTimes)) {
      fitValues[i] = rhop(rhoc0, nu, gamman, rhop0, etap, gammap, dataTimes[i])
    }
    sumR2 = sumR2 + Rsquared(fitValues,dataValues)
  }

  return(sumR2/N)

}
    
