##
## scan ALL genes to assemble a dataframe of fit parameters, choosing best fit from three turnOff groups
##

source("transmodel.fit.R")
source("Rsquared.R")
source("rhop.R")

source("../R/getExpression.R")
source("../R/getAllIDs.R")

scanall = function(schema,condition) {

  rhon0 = 1
  rhoc0 = 19
  nu = 10
  gamman = 0

  ## get an array of all gene ids
  ids = getAllIDs(schema)

  fits = data.frame(id=character(),group=character(),rhop0=numeric(),etap=numeric(),gammap=numeric(),minimum=numeric(),R2=numeric(), check.rows=T)
  dataTimes = getTimes(schema=schema, condition=condition)/60
  
  ## loop over all, doing fit
  for (i in 1:length(ids)) {
    dataValues = getExpression(schema=schema, condition=condition, gene=ids[i])
    fit.E = transmodel.fit(turnOff=0.5,doPlot=F,schema=schema,condition=condition,rhoc0=rhoc0,nu=nu,gamman=gamman, dataTimes=dataTimes,dataValues=dataValues)
    fit.M = transmodel.fit(turnOff=1.0,doPlot=F,schema=schema,condition=condition,rhoc0=rhoc0,nu=nu,gamman=gamman, dataTimes=dataTimes,dataValues=dataValues)
    fit.L = transmodel.fit(turnOff=0  ,doPlot=F,schema=schema,condition=condition,rhoc0=rhoc0,nu=nu,gamman=gamman, dataTimes=dataTimes,dataValues=dataValues)
    if (!is.null(fit.E) && !is.null(fit.M) && !is.null(fit.L)) {
      fitValues.E = rhop(turnOff=0.5, t=dataTimes, rhoc0=rhoc0, nu=nu, gamman=gamman, rhop0=fit.E$estimate[1], etap=fit.E$estimate[2], gammap=fit.E$estimate[3])
      fitValues.M = rhop(turnOff=1.0, t=dataTimes, rhoc0=rhoc0, nu=nu, gamman=gamman, rhop0=fit.M$estimate[1], etap=fit.M$estimate[2], gammap=fit.M$estimate[3])
      fitValues.L = rhop(turnOff=0,   t=dataTimes, rhoc0=rhoc0, nu=nu, gamman=gamman, rhop0=fit.L$estimate[1], etap=fit.L$estimate[2], gammap=fit.L$estimate[3])
      R2.L = Rsquared(fitValues.L,dataValues)
      R2.E = Rsquared(fitValues.E,dataValues)
      R2.M = Rsquared(fitValues.M,dataValues)
      if (R2.E>R2.M && R2.E>R2.L) {
        if (R2.E>0.60) {
          mark = "*"
        } else {
          mark = ""
        }
        print(paste(ids[i], "E", round(R2.E,2), mark), quote=F)
        fits = rbind(fits, data.frame(id=ids[i],group="E",rhop0=fit.E$estimate[1],etap=fit.E$estimate[2],gammap=fit.E$estimate[3],minimum=fit.E$minimum,R2=R2.E))
      } else if (R2.M>R2.E && R2.M>R2.L) {
        if (R2.M>0.60) {
          mark = "*"
        } else {
          mark = ""
        }
        print(paste(ids[i], "M", round(R2.M,2), mark), quote=F)
        fits = rbind(fits, data.frame(id=ids[i],group="M",rhop0=fit.M$estimate[1],etap=fit.M$estimate[2],gammap=fit.M$estimate[3],minimum=fit.M$minimum,R2=R2.M))
      } else {
        if (R2.L>0.60) {
          mark = "*"
        } else {
          mark = ""
        }
        print(paste(ids[i], "L", round(R2.L,2), mark), quote=F)
        fits = rbind(fits, data.frame(id=ids[i],group="L",rhop0=fit.L$estimate[1],etap=fit.L$estimate[2],gammap=fit.L$estimate[3],minimum=fit.L$minimum,R2=R2.L))
      }
    }
  }

  ## move id to rowname
  rownames(fits)=fits$id
  fits$id = NULL

  return(fits)

}
