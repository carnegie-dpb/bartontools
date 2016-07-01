##
## use nlm to find the best fit to a given set of parameter guesses and a given time,data series
##

source("~/R/getTimes.R")
source("~/R/getExpression.R")

source("transmodel.fit.R")

source("transmodel2.R")
source("transmodel2.error.R")

transmodel2.fit = function(
                           schema="gse70796", condition="GR-REV", gene1="At5g03995", gene2="At5g44574",
                           rhon0=1, rhoc0=25, nu=10, rhop0=1, etap=1, gammap=2.5, rhos0=1, etas=1, gammas=2.5,
                           dataTimes, data1Values, data2Values, 
                           data1Label=NA, data2Label=NA, plotBars=FALSE, doPlot=TRUE
                           ) {
    
    ## get time (in hours) and expression arrays for the given schema and gene IDs
    if (!hasArg(dataTimes)) {
        dataTimes = getTimes(schema, condition)
        if (max(dataTimes)>50) dataTimes = dataTimes/60
        data1Values = getExpression(schema, condition, toupper(gene1))
        data2Values = getExpression(schema, condition, toupper(gene2))
        if (is.na(data1Label)) data1Label = paste(condition,gene1,sep=":")
        if (is.na(data2Label)) data2Label = paste(condition,gene2,sep=":")
    }
    
    ## do minimization of primary transcript params
    fit1 = transmodel.fit(turnOff=0, rhoc0=rhoc0,nu=nu,  dataTimes=dataTimes, dataValues=data1Values, doPlot=FALSE)
    ## new params from fit
    rhop0 = fit1$estimate[1]
    etap = fit1$estimate[2]
    gammap = fit1$estimate[3]

    if (fit1$code==4) print("*** fit1 ITERATION LIMIT EXCEEDED ***")
    if (fit1$code==5) print("*** fit1 MAXIMUM STEP SIZE EXCEEDED FIVE CONSECUTIVE TIMES ***")

    ## do minimization of secondary transcript params
    fit2 = nlm(p=c(rhos0,etas,gammas), rhoc0=rhoc0,nu=nu, etap=etap,gammap=gammap, f=transmodel2.error, gradtol=1e-5, iterlim=1000, dataTimes=dataTimes, data2Values=data2Values)
    ## new params from fit
    rhos0 = fit2$estimate[1]
    etas = fit2$estimate[2]
    gammas = fit2$estimate[3]

    if (fit2$code==4) print("*** fit2 ITERATION LIMIT EXCEEDED ***")
    if (fit2$code==5) print("*** fit2 MAXIMUM STEP SIZE EXCEEDED FIVE CONSECUTIVE TIMES ***")

    ## plot it
    if (doPlot) {
        transmodel2(turnOff=0,
                    rhoc0=rhoc0, rhon0=rhon0, nu=nu,
                    rhop0=rhop0, etap=etap, gammap=gammap,
                    rhos0=rhos0, etas=etas, gammas=gammas,
                    dataTimes=dataTimes, data1Values=data1Values,data1Label=data1Label, data2Values=data2Values,data2Label=data2Label, plotBars=plotBars)
    }

    return(fit2)

}

