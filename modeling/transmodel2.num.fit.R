##
## use nlm to find the best fit to a given set of parameter guesses and a given time,data series
##
## this version uses NUMERICAL solution of the equations

source("~/R/getExpression.R")
source("~/R/getTimes.R")

source("transmodel.error.R")
source("transmodel2.num.R")
source("transmodel2.num.error.R")

transmodel2.num.fit = function(rhon0=1, rhoc0=25, nu=10, 
                               rhop0=1, etap=1, gammap=4,
                               rhos0=1, etas=1, gammas=4,
                               schema, condition, gene1, gene2,
                               turnOff=0,
                               plotBars=FALSE,  doPlot=TRUE
                               ) {
    
    ## get time (in hours) and expression arrays for the given schema and gene ID from the database
    dataTimes = getTimes(schema, condition)/60
    data1Values = getExpression(schema, condition, toupper(gene1))
    data2Values = getExpression(schema, condition, toupper(gene2))
    
    ## fit primary target using transmodel.fit with three-parameter fit, no initial guesses
    fitp = transmodel.fit(fitTerms="rhop0.etap.gammap", turnOff=turnOff, rhoc0=rhoc0, rhon0=rhon0, nu=nu, dataTimes=dataTimes, dataValues=data1Values, doPlot=FALSE)
    rhop0 = fitp$estimate[1]
    etap = fitp$estimate[2]
    gammap = fitp$estimate[3]

    ## estimate rhos0
    if (!hasArg(rhos0)) rhos0 = mean(data2Values[dataTimes==0])

    ## standard three-parameter fit
    fits = nlm(p=c(rhos0,etas,gammas), f=transmodel2.num.error, gradtol=1e-5, fitTerms="rhos0.etas.gammas", turnOff=turnOff,
               rhoc0=rhoc0, rhon0=rhon0, nu=nu, rhop0=rhop0, etap=etap, gammap=gammap, dataTimes=dataTimes, dataValues=data2Values)
    if (fits$code==4 || fits$code==5) {
        ## try again with failed fit params
        fits = nlm(p=fits$estimate, f=transmodel2.num.error, gradtol=1e-5, fitTerms="rhos0.etas.gammas", turnOff=turnOff,
                   rhoc0=rhoc0, rhon0=rhon0, nu=nu, rhop0=rhop0, etap=etap, gammap=gammap, dataTimes=dataTimes, dataValues=data2Values)
    }
    ## new params from fit
    rhos0 = fits$estimate[1]
    etas = fits$estimate[2]
    gammas = fits$estimate[3]
        
    ## plot it
    if (doPlot) {
        transmodel2.num(turnOff=turnOff,
                        rhoc0=rhoc0,rhon0=rhon0,nu=nu, rhop0=rhop0,etap=etap,gammap=gammap, rhos0=rhos0,etas=etas,gammas=gammas,
                        data1Label=paste(toupper(schema)," ",condition,":",gene1,sep=""), data2Label=paste(toupper(schema)," ",condition,":",gene2,sep=""),
                        dataTimes=dataTimes, data1Values=data1Values, data2Values=data2Values, plotBars=plotBars)
    }

    ## return fits in case we want it
    return(fits)

}

