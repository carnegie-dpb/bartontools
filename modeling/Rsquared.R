##
## return R-squared for a set of fit and data values
##

Rsquared = function(fitValues, dataValues) {
  numer = 0
  denom = 0
  dataMean = mean(dataValues)
  for (i in 1:length(dataValues)) {
    numer = numer + (dataValues[i]-fitValues[i])^2
    denom = denom + (dataValues[i]-dataMean)^2
  }
  return(1-numer/denom)
}
