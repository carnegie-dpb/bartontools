##
## scan over candidate genes to assemble a dataframe of fit parameters
##

source("transmodel.fit.R")
source("Rsquared.R")
source("rhop.R")

source("../R/getTimes.R")
source("../R/getExpression.R")
source("../R/getSymbol.R")

scan.candidates = function(schema, condition, txtTable, rhon0=1, rhoc0=19, nu=10, gamman=0) {

  ## threshold for saving candidates
  R2min = 0.60
  
  ## load the candidates
  ids = as.vector(read.table(txtTable)$V1)

  ## loop over candidates, doing fit to three turnOff choices, saving if one exceeds R2min
  fits = data.frame(id=character(),symbol=character(), check.rows=T,
    rhop0=numeric(),etap=numeric(),gammap=numeric(),R2=numeric(), 
    rhop0.0.5=numeric(),etap.0.5=numeric(),gammap.0.5=numeric(),R2.0.5=numeric(), 
    rhop0.1.0=numeric(),etap.1.0=numeric(),gammap.1.0=numeric(),R2.1.0=numeric()
    )
  dataTimes = getTimes(schema=schema, condition=condition)/60
  for (i in 1:length(ids)) {
    ## expression values
    dataValues = getExpression(schema=schema, condition=condition, gene=ids[i])
    ## fits
    fit = transmodel.fit(turnOff=0.0, doPlot=F,schema=schema,condition=condition, rhon0=rhon0,rhoc0=rhoc0,nu=nu,gamman=gamman, dataTimes=dataTimes, dataValues=dataValues)
    fit.0.5 = transmodel.fit(turnOff=0.5, doPlot=F,schema=schema,condition=condition, rhon0=rhon0,rhoc0=rhoc0,nu=nu,gamman=gamman, dataTimes=dataTimes, dataValues=dataValues)
    fit.1.0 = transmodel.fit(turnOff=1.0, doPlot=F,schema=schema,condition=condition, rhon0=rhon0,rhoc0=rhoc0,nu=nu,gamman=gamman, dataTimes=dataTimes, dataValues=dataValues)
    ## save if one fit is significant
    R2 = 0
    R2.0.5 = 0
    R2.1.0 = 0
    save = FALSE
    if (fit$code!=4 && fit$code!=5) {
      fitValues = rhop(t=dataTimes, turnOff=0.0, rhoc0=rhoc0, nu=nu, gamman=gamman, rhop0=fit$estimate[1], etap=fit$estimate[2], gammap=fit$estimate[3])
      R2 = Rsquared(fitValues,dataValues)
      if (R2>R2min) save = TRUE
    }
    if (fit.0.5$code!=4 && fit.0.5$code!=5) {
      fitValues = rhop(t=dataTimes, turnOff=0.5, rhoc0=rhoc0, nu=nu, gamman=gamman, rhop0=fit.0.5$estimate[1], etap=fit.0.5$estimate[2], gammap=fit.0.5$estimate[3])
      R2.0.5 = Rsquared(fitValues,dataValues)
      if (R2.0.5>R2min) save = TRUE
    }
    if (fit.1.0$code!=4 && fit.1.0$code!=5) {
      fitValues = rhop(t=dataTimes, turnOff=1.0, rhoc0=rhoc0, nu=nu, gamman=gamman, rhop0=fit.1.0$estimate[1], etap=fit.1.0$estimate[2], gammap=fit.1.0$estimate[3])
      R2.1.0 = Rsquared(fitValues,dataValues)
      if (R2.1.0>R2min) save = TRUE
    }
    if (save) {
      symbol = getSymbol(ids[i])
      if (is.null(symbol)) symbol = ""
      print(paste(ids[i],symbol,R2,R2.0.5,R2.1.0))
      fits = rbind(fits, data.frame(id=ids[i],symbol=symbol,
        rhop0=fit$estimate[1], etap=fit$estimate[2], gammap=fit$estimate[3], R2=R2,
        rhop0.0.5=fit.0.5$estimate[1], etap.0.5=fit.0.5$estimate[2], gammap.0.5=fit.0.5$estimate[3], R2.0.5=R2.0.5,
        rhop0.1.0=fit.1.0$estimate[1], etap.1.0=fit.1.0$estimate[2], gammap.1.0=fit.1.0$estimate[3], R2.1.0=R2.1.0
        ))
    }
  }

  ## move id over to row name
  rownames(fits) = fits$id
  fits$id = NULL
  
  return(fits)

}
