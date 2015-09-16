##
## use nlm to find the best fit to a given set of parameter guesses and a given time,data series
##
## this version uses NUMERICAL solution of the equations
##
## set nuFixed=TRUE to hold nu fixed, i.e. not be a fitted parameter

source("../R/getExpression.R")
source("../R/getTimes.R")

source("transmodel.num.R")
source("transmodel.num.error.R")

transmodel.num.fit = function(schema="bl2013", gene="At5g47370", condition="GR-REV",
  fitType="threeparam", turnOff=0,
  rhoc0=20,rhon0=1,nu=10,gamman=0,gammae=0, rhop0=0,etap=0,gammap=0,
  dataTimes, dataValues, dataLabel=NA, plotBars=FALSE,  doPlot=TRUE
  ) {

  ## get time (in hours) and expression arrays for the given schema and gene ID from the database
  if (!hasArg(dataTimes)) {
    dataTimes = getTimes(schema, condition)/60
    dataValues = getExpression(schema, condition, toupper(gene))
    if (is.na(dataLabel)) dataLabel = paste(toupper(schema)," ",condition,":",gene,sep="")
  }
  ## estimate rhop0 from t=0 data points
  if (rhop0==0) rhop0 = mean(dataValues[dataTimes==0])

  ## estimate etap from rhop0
  if (etap==0) etap = 0.1*rhop0

  ## run a two-param analytic fit to refine rhop0 and etap estimates
  fit = nlm(p=c(rhop0,etap), f=transmodel.error, gradtol=1e-5, fitType="twoparam", turnOff=turnOff,
    rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman, gammap=gammap, dataTimes=dataTimes,dataValues=dataValues)
  rhop0 = fit$estimate[1]
  etap = fit$estimate[2]

  ## threeparam: fit rhop0, etap, gammap
  if (fitType=="threeparam") {
    fit = nlm(p=c(rhop0,etap,gammap), f=transmodel.num.error, gradtol=1e-5, fitType=fitType, turnOff=turnOff,
      rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman,gammae=gammae, dataTimes=dataTimes, dataValues=dataValues)
    if (fit$code==4 || fit$code==5) {
      ## try again with failed fit params
      fit = nlm(p=fit$estimate, f=transmodel.num.error, gradtol=1e-5, fitType=fitType, turnOff=turnOff,
        rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman,gammae=gammae, dataTimes=dataTimes, dataValues=dataValues)
    }
    ## new params from fit
    rhop0 = fit$estimate[1]
    etap = fit$estimate[2]
    gammap = fit$estimate[3]
  }

  ## turnoff: fit rhop0, etap, gammap, turnOff
  if (fitType=="turnoff") {
    fit = nlm(p=c(rhop0,etap,gammap,turnOff), f=transmodel.num.error, gradtol=1e-5, fitType=fitType,
      rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman,gammae=gammae, dataTimes=dataTimes, dataValues=dataValues)
    if (fit$code==4 || fit$code==5) {
      ## try again with failed fit params
      fit = nlm(p=fit$estimate, f=transmodel.num.error, gradtol=1e-5, fitType=fitType,
        rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman,gammae=gammae, dataTimes=dataTimes, dataValues=dataValues)
    }
    ## new params from fit
    rhop0 = fit$estimate[1]
    etap = fit$estimate[2]
    gammap = fit$estimate[3]
    turnOff = fit$estimate[4]
  }
  
  ## fourparam1: fit gamman, rhop0, etap, gammap
  if (fitType=="fourparam1") {
    fit = nlm(p=c(gamman,rhop0,etap,gammap), f=transmodel.num.error, gradtol=1e-5, fitType=fitType, turnOff=turnOff, 
      rhoc0=rhoc0,rhon0=rhon0,nu=nu,gammae=gammae, dataTimes=dataTimes, dataValues=dataValues)
    if (fit$code==4 || fit$code==5) {
      ## try again with failed fit params
      fit = nlm(p=fit$estimate, f=transmodel.num.error, gradtol=1e-5, fitType=fitType, turnOff=turnOff, 
        rhoc0=rhoc0,rhon0=rhon0,nu=nu,gammae=gammae, dataTimes=dataTimes, dataValues=dataValues)
    }
    ## new params from fit
    gamman = fit$estimate[1]
    rhop0 = fit$estimate[2]
    etap = fit$estimate[3]
    gammap = fit$estimate[4]
  }
    
  ## fourparam2: fit nu, rhop0, etap, gammap
  if (fitType=="fourparam2") {
    fit = nlm(p=c(nu,rhop0,etap,gammap), f=transmodel.num.error, gradtol=1e-5, fitType=fitType, turnOff=turnOff,
      rhoc0=rhoc0,rhon0=rhon0,gamman=gamman,gammae=gammae, dataTimes=dataTimes, dataValues=dataValues)
    if (fit$code==4 || fit$code==5) {
      ## try again with failed fit params
    fit = nlm(p=fit$estimate, f=transmodel.num.error, gradtol=1e-5, fitType=fitType, turnOff=turnOff,
      rhoc0=rhoc0,rhon0=rhon0,gamman=gamman,gammae=gammae, dataTimes=dataTimes, dataValues=dataValues)
    }
    ## new params from fit
    nu = fit$estimate[1]
    rhop0 = fit$estimate[2]
    etap = fit$estimate[3]
    gammap = fit$estimate[4]
  }

  ## plot it
  if (doPlot) {
    transmodel.num(turnOff=turnOff, rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman,gammae=gammae, rhop0=rhop0,etap=etap,gammap=gammap,
                   dataTimes=dataTimes, dataValues=dataValues, dataLabel=dataLabel, plotBars=plotBars)
  }

  ## return fit in case we want it
  return(fit)

}

