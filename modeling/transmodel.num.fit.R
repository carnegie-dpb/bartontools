##
## use nlm to find the best fit to a given set of parameter guesses and a given time,data series
##
## this version uses NUMERICAL solution of the equations
##
## set nuFixed=TRUE to hold nu fixed, i.e. not be a fitted parameter

source("~/R/getExpression.R")
source("~/R/getTimes.R")

source("transmodel.error.R")
source("transmodel.num.R")
source("transmodel.num.error.R")

transmodel.num.fit = function(schema="gse70796", gene="At5g47370", condition="GR-REV",
                              turnOff=0,
                              rhoc0=25, rhon0=1, nu=10, gamman=0, gammae=0,
                              rhop0=1, etap=1, gammap=4,
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

    ## run a three-param analytic fit to refine rhop0, etap and gammap estimates
    fit = nlm(p=c(rhop0,etap,gammap), f=transmodel.error, gradtol=1e-5, fitTerms="rhop0.etap.gammap", turnOff=turnOff,
              rhoc0=rhoc0, rhon0=rhon0, nu=nu, dataTimes=dataTimes, dataValues=dataValues)
    if (fit$code==4 || fit$code==5) {
        ## try again with failed fit params
        fit = nlm(p=fit$estimate, f=transmodel.num.error, gradtol=1e-5, fitTerms=fitTerms, turnOff=turnOff,
                  rhoc0=rhoc0, rhon0=rhon0, nu=nu, dataTimes=dataTimes, dataValues=dataValues)
    }
    ## new primary params from fit
    rhop0 = fit$estimate[1]
    etap = fit$estimate[2]
    gammap = fit$estimate[3]

    ## now numerically fit rhop0, etap, gammap
    fit = nlm(p=c(rhop0,etap,gammap), f=transmodel.num.error, gradtol=1e-5, fitTerms="rhop0.etap.gammap", turnOff=turnOff,
              rhoc0=rhoc0, rhon0=rhon0, nu=nu, gamman=gamman, gammae=gammae, dataTimes=dataTimes, dataValues=dataValues)
    if (fit$code==4 || fit$code==5) {
        ## try again with failed fit params
        fit = nlm(p=fit$estimate, f=transmodel.num.error, gradtol=1e-5, fitTerms=fitTerms,
                  rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman,gammae=gammae, dataTimes=dataTimes, dataValues=dataValues)
    }
    ## new params from fit
    rhop0 = fit$estimate[1]
    etap = fit$estimate[2]
    gammap = fit$estimate[3]
    
    ## plot it
    if (doPlot) {
        transmodel.num(turnOff=turnOff,
                       rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman,gammae=gammae,
                       rhop0=rhop0,etap=etap,gammap=gammap,
                       dataTimes=dataTimes, dataValues=dataValues, dataLabel=dataLabel, plotBars=plotBars)
    }

    ## return fit in case we want it
    return(fit)

}

