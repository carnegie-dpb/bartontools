##
## scan over candidate genes to assemble a dataframe of primary/secondary fit parameters
##

source("transmodel.fit.R")
source("transmodel2.fit.R")
source("Rsquared.R")
source("rhop.R")
source("rhos.R")

source("~/R/getTimes.R")
source("~/R/getExpression.R")
source("~/R/getSymbol.R")

scan2.candidates = function(schema, condition, txtTable, rhon0=1, rhoc0=19, nu=10, gamman=0, gene2) {

  ## load the candidates
  ids = as.vector(read.table(txtTable)$V1)

  ## loop over candidates, doing fit to three turnOff choices, saving if one exceeds R2min
  fits = data.frame(id=character(),symbol=character(), check.rows=T,
    rhop0=numeric(),etap=numeric(),gammap=numeric(),R2p=numeric(),code1=numeric(),
    rhos0=numeric(),etas=numeric(),gammas=numeric(),R2s=numeric(),code2=numeric()
    )

  ## secondary expression values
  dataTimes = getTimes(schema=schema, condition=condition)/60
  data2Values = getExpression(schema=schema, condition=condition, gene=gene2)
  
  for (i in 1:length(ids)) {
    ## primary expression values
    data1Values = getExpression(schema=schema, condition=condition, gene=ids[i])
    ## primary fit
    fit1 = try(transmodel.fit(doPlot=F,schema=schema,condition=condition, rhon0=rhon0,rhoc0=rhoc0,nu=nu,gamman=gamman, dataTimes=dataTimes, dataValues=data1Values))
    if (class(fit1)!="try-error") {
      rhop0 = fit1$estimate[1]
      etap = fit1$estimate[2]
      gammap = fit1$estimate[3]
      code1 = fit1$code
      ## secondary fit
      fit2 = try(transmodel2.fit(doPlot=F,schema=schema,condition=condition, rhon0=rhon0,rhoc0=rhoc0,nu=nu,gamman=gamman, dataTimes=dataTimes, data1Values=data1Values, data2Values=data2Values))
      if (class(fit2)!="try-error") {
        rhos0=fit2$estimate[1]
        etas=fit2$estimate[2]
        gammas=fit2$estimate[3]
        code2 = fit2$code
        ## get R2 values
        fit1Values = rhop(t=dataTimes, rhoc0=rhoc0,nu=nu,gamman=gamman, rhop0=rhop0,etap=etap,gammap=gammap)
        fit2Values = rhos(t=dataTimes, rhoc0=rhoc0,nu=nu,gamman=gamman,             etap=etap,gammap=gammap, rhos0=rhos0,etas=etas,gammas=gammas)
        R2p = Rsquared(fit1Values,data1Values)
        R2s = Rsquared(fit2Values,data2Values)
        symbol = getSymbol(ids[i])
        if (is.null(symbol)) symbol = ""
        fits = rbind( fits, data.frame(id=ids[i],symbol=symbol, rhop0=rhop0,etap=etap,gammap=gammap,R2p=R2p,code1=code1, rhos0=rhos0,etas=etas,gammas=gammas,R2s=R2s,code2=code2) )
        print(paste(ids[i],symbol,R2p,R2s))
      }
    }
  }

  ## move id over to row name
  rownames(fits) = fits$id
  fits$id = NULL
  
  return(fits)

}
