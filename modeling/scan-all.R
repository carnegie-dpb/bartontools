##
## scan ALL genes to assemble a dataframe of fit parameters
##

source("transmodel.fit.R")
source("Rsquared.R")
source("rhop.R")

source("../R/getAllIDs.R")

scanall = function(schema,condition) {

  rhon0=1
  rhoc0=20
  nu=10
  gamman=0.760

  R2threshold = 0.60

  ## get an array of all gene ids
  ids = getAllIDs(schema)

  fits = data.frame(id=character(),rhop0=numeric(),etap=numeric(),gammap=numeric(),minimum=numeric(),R2=numeric(), check.rows=T)
  dataTimes = getTimes(schema=schema, condition=condition)/60
  
  ## loop over all, doing fit
  for (i in 1:length(ids)) {
    dataValues = getExpression(schema=schema, condition=condition, gene=ids[i])
    fit = transmodel.fit(doPlot=F,schema=schema,condition=condition,rhon0=rhon0,rhoc0=rhoc0,nu=nu,gamman=gamman, dataTimes=dataTimes, dataValues=dataValues)
    if (fit$code==4) {
      print(paste(ids[i],"ITERATION LIMIT EXCEEDED"))
    } else if (fit$code==5) {
      print(paste(ids[i],"MAXIMUM STEP SIZE EXCEEDED FIVE CONSECUTIVE TIMES"))
    } else {
      rhop0 = fit$estimate[1]
      etap = fit$estimate[2]
      gammap = fit$estimate[3]
      ## get R-squared and error metric
      fitValues = dataTimes
      for (j in 1:length(fitValues)) {
        fitValues[j] = rhop(rhoc0, rhon0, nu, gamman, rhop0, etap, gammap, dataTimes[j])
      }
      R2 = Rsquared(fitValues,dataValues)
      if (R2>R2threshold) {
        print(paste(ids[i],fit$minimum,R2))
        fits = rbind(fits, data.frame(id=ids[i],rhop0=rhop0,etap=etap,gammap=gammap,minimum=fit$minimum,R2=R2))
      }
    }
  }

## move id to rowname
rownames(fits)=fits$id
fits$id = NULL
