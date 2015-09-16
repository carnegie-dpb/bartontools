##
## use nlm to find the best fit to a given set of parameter guesses and a given time,data series
##

source("../R/getExpression.R")
source("../R/getTimes.R")

source("transmodel.alpha.R")
source("transmodel.alpha.error.R")

transmodel.alpha.fit = function(rhon0=0, rhoc0=0, rhop0=0, nu=10, alphap=1, gammap=3, schema="bl2013", geneID="AT3G52770", condition="GR-REV", plotBars=FALSE, dataLabel=NA) {

  ## set gammap=nu if not given, as initial guess
  if (gammap==0) gammap = nu

  ## get time (in hours) and expression arrays for the given schema and gene ID
  dataTimes = getTimes(schema, condition)/60
  dataValues = getExpression(schema, condition, toupper(geneID))
  if (is.na(dataLabel)) dataLabel = paste(condition,geneID,sep=":")

  ## set rhop0 = mean of t=0 data points, fixed in alpha model
  if (rhop0==0) rhop0 = mean(dataValues[dataTimes==0])
  
  ## do minimization
  fit = nlm(p=c(alphap,gammap), rhon0=rhon0, rhoc0=rhoc0, rhop0=rhop0, nu=nu, f=transmodel.alpha.error, gradtol=1e-5, dataTimes=dataTimes, dataValues=dataValues)

  ## new params from fit
  alphap = fit$estimate[1]
  gammap = fit$estimate[2]

  ## warnings
  if (fit$code==4) print("*** ITERATION LIMIT EXCEEDED ***")
  if (fit$code==5) print("*** MAXIMUM STEP SIZE EXCEEDED FIVE CONSECUTIVE TIMES ***")
        
  ## plot it
  transmodel.alpha(rhon0=rhon0, rhoc0=rhoc0, rhop0=rhop0, nu=nu, alphap=alphap, gammap=gammap, dataTimes=dataTimes, dataValues=dataValues, dataLabel=dataLabel, plotBars=plotBars)

  ## return fit in case we want it
  return(fit)

}

