##
## use nlm to find the best fit to a given set of parameter guesses and a given time,data series
##
## set nuFixed=TRUE to hold nu fixed, i.e. not be a fitted parameter

source("~/R/getExpression.R")
source("~/R/getTimes.R")

source("transmodel.R")
source("transmodel.error.R")

transmodel.fit = function(
    fitType="threeparam", turnOff=0,
    rhoc0=19, rhon0=1, nu=10, gamman=0, rhop0, etap, gammap=1,
    schema="bl2013", gene="At5g47370", condition="GR-REV",
    dataTimes, dataValues, dataLabel=NA,
    plotBars=FALSE,  doPlot=TRUE
) {

    ## get time (in hours) and expression arrays for the given schema and gene ID from the database
    if (!hasArg(dataTimes)) {
        dataTimes = getTimes(schema, condition)
        if (max(dataTimes)>60) dataTimes = dataTimes/60
        dataValues = getExpression(schema, condition, toupper(gene))
        if (is.na(dataLabel)) dataLabel = paste(toupper(schema)," ",condition,":",gene,sep="")
    }
    
    ## estimate rhop0 from minimum t data points
    tMin = min(dataTimes)
    if (!hasArg(rhop0)) {
        rhop0 = mean(dataValues[dataTimes==tMin])
    }
    rhop0input = rhop0

    ## estimate etap from rhop0, assume up-regulated
    if (!hasArg(etap)) etap = 0.1*rhop0

    if (fitType=="oneparam") {

        ## fix etap and gammap, just adjust rhop0 (offset)
        fit = try(nlm(p=c(rhop0), f=transmodel.error, gradtol=1e-5, iterlim=1000, fitType=fitType, turnOff=turnOff,
            rhoc0=rhoc0,nu=nu,gamman=gamman, etap=etap, gammap=gammap, dataTimes=dataTimes, dataValues=dataValues))
        if (class(fit)=="try-error") return(NULL)
        ## new params from fit
        rhop0 = fit$estimate[1]
        
    } else if (fitType=="twoparam2") {
        
        ## two-param fit with rhop0 fixed, typically mean of t=0 points set above
        fit = try(nlm(p=c(etap,gammap), f=transmodel.error, gradtol=1e-5, iterlim=1000, fitType=fitType, turnOff=turnOff,
            rhoc0=rhoc0,nu=nu,gamman=gamman, rhop0=rhop0, dataTimes=dataTimes, dataValues=dataValues))
        if (class(fit)=="try-error") return(NULL)
        if (fit$code==4 || fit$code==5) {
            ## try again with failed fit params
            fit = try(nlm(p=fit$estimate, f=transmodel.error, gradtol=1e-5, iterlim=1000, fitType=fitType, turnOff=turnOff, rhoc0=rhoc0, nu=nu, gamman=gamman, rhop0=rhop0, dataTimes=dataTimes, dataValues=dataValues))
            if (class(fit)=="try-error") return(NULL)
        }
        ## new params from fit
        etap = fit$estimate[1]
        gammap = fit$estimate[2]
        
    } else {

        ## two-param fit with gammap fixed; used to refine rhop0 and etap estimates below as well
        fit = try(nlm(p=c(rhop0,etap), f=transmodel.error, gradtol=1e-5, iterlim=1000, fitType="twoparam1", turnOff=0,
            rhoc0=rhoc0, nu=nu, gamman=gamman, gammap=gammap, dataTimes=dataTimes, dataValues=dataValues))
        if (class(fit)=="try-error") return(NULL)
        rhop0 = fit$estimate[1]
        etap = fit$estimate[2]
        
    }

    if (fitType=="fourparam1") {

        ## fourparam1: fit gamman, rhop0, etap, gammap
        fit = try(nlm(p=c(gamman,rhop0,etap,gammap), f=transmodel.error, gradtol=1e-5, iterlim=1000, fitType=fitType, turnOff=turnOff,
            rhoc0=rhoc0, nu=nu, dataTimes=dataTimes, dataValues=dataValues))
        if (class(fit)=="try-error") return(NULL)
        if (fit$code==4 || fit$code==5) {
            ## try again with failed fit params
            fit = try(nlm(p=fit$estimate, f=transmodel.error, gradtol=1e-5, iterlim=1000, fitType=fitType, turnOff=turnOff, rhoc0=rhoc0, nu=nu, dataTimes=dataTimes, dataValues=dataValues))
            if (class(fit)=="try-error") return(NULL)
        }
        ## new params from fit
        gamman = fit$estimate[1]
        rhop0 = fit$estimate[2]
        etap = fit$estimate[3]
        gammap = fit$estimate[4]
        
    } else if (fitType=="fourparam2") {

        ## fourparam2: fit nu, rhop0, etap, gammap
        fit = try(nlm(p=c(nu,rhop0,etap,gammap), f=transmodel.error, gradtol=1e-5, iterlim=1000, fitType=fitType, turnOff=turnOff,
            rhoc0=rhoc0, gamman=gamman, dataTimes=dataTimes, dataValues=dataValues))
        if (class(fit)=="try-error") return(NULL)
        if (fit$code==4 || fit$code==5) {
            ## try again with failed fit params
            fit = try(nlm(p=fit$estimate, f=transmodel.error, gradtol=1e-5, iterlim=1000, fitType=fitType, rhoc0=rhoc0, gamman=gamman, dataTimes=dataTimes, dataValues=dataValues))
            if (class(fit)=="try-error") return(NULL)
        }
        ## new params from fit
        nu = fit$estimate[1]
        rhop0 = fit$estimate[2]
        etap = fit$estimate[3]
        gammap = fit$estimate[4]
        
    } else if (fitType=="threeparam") {
        
        ## threeparam: fit rhop0, etap, gammap
        fit = try(nlm(p=c(rhop0,etap,gammap), f=transmodel.error, gradtol=1e-5, iterlim=1000, fitType=fitType, turnOff=turnOff,
            rhoc0=rhoc0, nu=nu, gamman=gamman, dataTimes=dataTimes, dataValues=dataValues))
        if (class(fit)=="try-error") return(NULL)
        if (fit$code==4 || fit$code==5) {
            ## try again with failed fit params
            fit = try(nlm(p=fit$estimate, f=transmodel.error, gradtol=1e-5, iterlim=1000, fitType=fitType, turnOff=turnOff, rhoc0=rhoc0, nu=nu, gamman=gamman, dataTimes=dataTimes, dataValues=dataValues))
            if (class(fit)=="try-error") return(NULL)
        }
        rhop0 = fit$estimate[1]
        etap = fit$estimate[2]
        gammap = fit$estimate[3]

        if (fit$code==4 || fit$code==5 || rhop0<0 || gammap>10) {
            ## bail on three-parameter fit, use input rhop0
            rhop0 = rhop0input
            ## fix etap and gammap guesses if needed
            if (gammap>10) {
                gammap = 1
                etap = 0.1*rhop0
            }
            fit = try(nlm(p=c(etap,gammap), f=transmodel.error, gradtol=1e-5, iterlim=1000, fitType="twoparam2", turnOff=turnOff, rhoc0=rhoc0, nu=nu, gamman=gamman, rhop0=rhop0, dataTimes=dataTimes, dataValues=dataValues))
            if (class(fit)=="try-error") return(NULL)
            etap = fit$estimate[1]
            gammap = fit$estimate[2]

            print(paste("bailout: rhop0,etap,gammap=",rhop0,etap,gammap))

        }    
    }

    ## get R-squared and error metric
    fitValues = rhop(t=dataTimes, turnOff=turnOff, rhoc0=rhoc0,nu=nu,gamman=gamman, rhop0=rhop0,etap=etap,gammap=gammap)
    R2 = Rsquared(fitValues,dataValues)
    fit$R2 = R2
    
    ## plot it
    if (doPlot) {
        transmodel(turnOff=turnOff, rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman, rhop0=rhop0,etap=etap,gammap=gammap, dataTimes=dataTimes,dataValues=dataValues,dataLabel=dataLabel, plotBars=plotBars)
    }

    ## return fit in case we want it
    return(fit)

}

