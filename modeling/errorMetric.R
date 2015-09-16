##
## returns the error metric used for transmodel fits
##

errorMetric = function(fitValues, dataValues) {
  ## error metric is variance scaled by data^2 (we're minimizing variance, but a quantity comparable between different data)
  numer = 0
  denom = 0
  for (i in 1:length(dataValues)) {
    numer = numer + (dataValues[i]-fitValues[i])^2
    denom = denom + dataValues[i]^2
  }
  return(numer/denom)
}
