##
## use nlm to find the best fit to a given set of parameter guesses and a given time,data series
##
## this version uses NUMERICAL solution of the equations
##
## set nuFixed=TRUE to hold nu fixed, i.e. not be a fitted parameter

source("~/R/getExpression.R")
source("~/R/getTimes.R")

source("transmodels.num.error.R")
source("transmodels.num.R")

transmodels.num.fit = function(
  rhon0=1,rhoc0=20,nu=10,gamman=0.825,gammae=0, rhop0=0,etap=0,gammap=0, rhos0=0,etas=0,gammas=0,
  turnOff=0,
  schema, condition, gene2,
  plotBars=FALSE,  doPlot=TRUE
  ) {

  ## get time (in hours) and expression arrays for the given schema and gene ID from the database
  dataTimes = getTimes(schema, condition)/60
  data2Values = getExpression(schema, condition, toupper(gene2))
    
  ## estimate rhos0, etas
  if (!hasArg(rhos0)) rhos0 = mean(data2Values[dataTimes==0])
  if (!hasArg(etas) && data2Values[4]>data2Values[1]) {
    etas = 0.1*rhos0
  } else {
    etas = -0.1*rhos0
  }

  ## do secondary target minimization
  fit = nlm(p=c(etap,gammap,rhos0,etas), f=transmodels.num.error, gradtol=1e-5, turnOff=turnOff, rhon0=rhon0, rhoc0=rhoc0, nu=nu, gamman=gamman, gammae=gammae, rhop0=rhop0, gammas=gammas,
    dataTimes=dataTimes, dataValues=data2Values)
  if (fit$code==4 || fit$code==5) {
    print(fit)
    ## try again with failed fit params
    fit = nlm(p=c(fit$estimate[1],fit$estimate[2],fit$estimate[3],fit$estimate[4]), f=transmodels.num.error, gradtol=1e-5, turnOff=turnOff, rhon0=rhon0, rhoc0=rhoc0, nu=nu, gamman=gamman,
      gammae=gammae, rhop0=rhop0, gammas=gammas,
      dataTimes=dataTimes, dataValues=data2Values)
  }
  ## new params from fit
  etap = fit$estimate[1]
  gammap = fit$estimate[2]
  rhos0 = fit$estimate[3]
  etas = fit$estimate[4]

  ## plot it
  if (doPlot) {
    transmodels.num(rhon0=rhon0,rhoc0=rhoc0,nu=nu,gamman=gamman,gammae=gammae, rhop0=rhop0,etap=etap,gammap=gammap, rhos0=rhos0,etas=etas,gammas=gammas,
                    turnOff=turnOff,
                    data2Label=paste(toupper(schema)," ",condition,":",gene2,sep=""),
                    dataTimes=dataTimes, data2Values=data2Values, plotBars=plotBars)
  }

  ## return fit in case we want it
  return(fit)

}

