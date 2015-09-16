##
## use nlm to find the best fit to a given set of parameter guesses and a given time,data series
##
## this version uses NUMERICAL solution of the equations

source("~/R/getExpression.R")
source("~/R/getTimes.R")

source("transmodel.error.R")
source("transmodel2.num.R")
source("transmodel2.num.error.R")

transmodel2.num.fit = function(
    fitType="threeparam", turnOff=0,
    rhon0=1,rhoc0=19,nu=10,gamman=0,
    rhos0, etas, gammas=1,
    schema, condition, gene1, gene2,
    plotBars=FALSE,  doPlot=TRUE
    ) {
    
    ## get time (in hours) and expression arrays for the given schema and gene ID from the database
    dataTimes = getTimes(schema, condition)/60
    data1Values = getExpression(schema, condition, toupper(gene1))
    data2Values = getExpression(schema, condition, toupper(gene2))
    
    ## fit primary target using transmodel.fit with three-parameter fit, no initial guesses
    fitp = transmodel.fit(fitType="threeparam", turnOff=turnOff, rhoc0=rhoc0, rhon0=rhon0, nu=nu, gamman=gamman, dataTimes=dataTimes, dataValues=data1Values, doPlot=FALSE)
    if (length(fitp$estimate)==3) {
        rhop0 = fitp$estimate[1]
        etap = fitp$estimate[2]
        gammap = fitp$estimate[3]
    } else {
        rhop0 = mean(data1Values[dataTimes==0])
        etap = fitp$estimate[1]
        gammap = fitp$estimate[2]
    }

    ## estimate rhos0, etas
    if (!hasArg(rhos0)) rhos0 = mean(data2Values[dataTimes==0])
    if (!hasArg(etas) && data2Values[4]>data2Values[1]) {
        etas = 0.1*rhos0
    } else {
        etas = -0.1*rhos0
    }

    ## standard three-parameter fit
    if (fitType=="threeparam") {
        fits = nlm(p=c(rhos0,etas,gammas), f=transmodel2.num.error, gradtol=1e-5, fitType=fitType, turnOff=turnOff,
            rhoc0=rhoc0, rhon0=rhon0,nu=nu,gamman=gamman, rhop0=rhop0,etap=etap,gammap=gammap, dataTimes=dataTimes, dataValues=data2Values)
        if (fits$code==4 || fits$code==5) {
            ## try again with failed fit params
            fits = nlm(p=fits$estimate, f=transmodel2.num.error, gradtol=1e-5, fitType=fitType, turnOff=turnOff, rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman,
                rhop0=rhop0,etap=etap,gammap=gammap, dataTimes=dataTimes, dataValues=data2Values)
        }
        ## new params from fit
        rhos0 = fits$estimate[1]
        etas = fits$estimate[2]
        gammas = fits$estimate[3]
        ## if (fits$code==4 || fits$code==5 || rhos0<0 || gammas>10) {
        ##     ## bail on three-parameter fit, use fixed rhos0
        ##     rhos0 = mean(data2Values[dataTimes==0])
        ##     ## fix etas and gammas guesses if needed
        ##     if (gammas>10) {
        ##         gammas = 1
        ##         if (data2Values[4]>data2Values[1]) {
        ##             etas = 0.1*rhos0
        ##         } else {
        ##             etas = -0.1*rhos0
        ##         }
        ##     }
        ##     fits = nlm(p=c(etas,gammas), f=transmodel2.num.error, gradtol=1e-5, fitType="twoparam", turnOff=turnOff, rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman,
        ##         rhop0=rhop0,etap=etap,gammap=gammap, rhos0=rhos0, dataTimes=dataTimes, dataValues=data2Values)
        ##     etas = fits$estimate[1]
        ##     gammas = fits$estimate[2]
        ## }    
    }

    ## two-parameter fit holding gammas constant (typically zero)
    if (fitType=="twoparam") {
        fits = nlm(p=c(rhos0,etas), f=transmodel2.num.error, gradtol=1e-5, fitType=fitType, turnOff=turnOff, rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman,
            rhop0=rhop0,etap=etap,gammap=gammap, gammas=gammas, dataTimes=dataTimes, dataValues=data2Values)
        if (fits$code==4 || fits$code==5) {
            print(fits)
            ## try again with failed fit params
            fits = nlm(p=fit$estimate, f=transmodel2.num.error, gradtol=1e-5, fitType=fitType, turnOff=turnOff, rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman,
                rhop0=rhop0,etap=etap,gammap=gammap, gammas=gammas, dataTimes=dataTimes, dataValues=data2Values)
        }
        ## new params from fit
        rhos0 = fits$estimate[1]
        etas = fits$estimate[2]
    }
        
    ## plot it
    if (doPlot) {
        transmodel2.num(turnOff=turnOff,
                        rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman, rhop0=rhop0,etap=etap,gammap=gammap, rhos0=rhos0,etas=etas,gammas=gammas,
                        data1Label=paste(toupper(schema)," ",condition,":",gene1,sep=""), data2Label=paste(toupper(schema)," ",condition,":",gene2,sep=""),
                        dataTimes=dataTimes, data1Values=data1Values, data2Values=data2Values, plotBars=plotBars)
    }

    ## return fits in case we want it
    return(fits)

}

