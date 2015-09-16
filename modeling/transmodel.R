##
## plot linear transcription model for a direct target in one condition
##

source("rhoc.R")
source("rhon.R")
source("rhop.R")
source("Rsquared.R")
source("errorMetric.R")

transmodel = function(turnOff=0, rhon0, rhoc0, nu, gamman, rhop0, etap, gammap, dataTimes, dataValues, dataLabel=NA, plotBars=FALSE) {

    ## set rhop0 = mean of minimum time points
    if (!hasArg(rhop0) && hasArg(dataValues) & hasArg(dataTimes)) {
        tMin = min(dataTimes)
        rhop0 = mean(dataValues[dataTimes==tMin])
    }

    ## calculation interval
    if (hasArg(dataTimes)) {
        t = seq(0, max(dataTimes), by=0.01)
    } else {
        t = seq(0, 2, by=0.01)
    }

    ## cytoplasmic GR-TF concentration
    rhoc_t = rhoc(t=t, rhoc0=rhoc0, nu=nu)
    
    ## nuclear GR-TF concentration
    rhon_t = rhon(t=t, rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman)
    
    ## transcript concentration
    rhop_t = rhop(t=t, turnOff=turnOff, rhoc0=rhoc0,nu=nu,gamman=gamman, rhop0=rhop0,etap=etap,gammap=gammap)
    
    ## plot transcript concentration
    if (hasArg(dataValues)) {
        ymin = min(dataValues,rhop_t)
        ymax = max(dataValues,rhop_t)
        plot(t, rhop_t, type="l", xlab="time (h)", ylab="nuclear concentration (lines), expression (points)", col="red", ylim=c(ymin,ymax), log="y")
    } else {
        ymin = min(rhop_t)
        ymax = max(rhop_t)
        plot(t, rhop_t, type="l", xlab="time (h)", ylab="nuclear concentration", col="red", ylim=c(ymin,ymax), log="y")
    }

    ## metrics for display
    logFCinf = log2(1 + rhoc0/rhop0*etap/gammap)
    kappa = nu*etap*rhoc0/rhop0

    ## compare with provided data
    if (hasArg(dataTimes) & hasArg(dataValues)) {
        if (plotBars) {
            ## plot mean and error bars
            for (ti in unique(dataTimes)) {
                y = mean(dataValues[dataTimes==ti])
                sd = sd(dataValues[dataTimes==ti])
                points(ti, y, pch=19, col="red")
                segments(ti, (y-sd), ti, (y+sd), col="red")
            }
        } else {
            ## plot each point
            points(dataTimes, dataValues, pch=19, col="red")
        }
        ## get R-squared and error metric
        fitValues = rhop(t=dataTimes, turnOff=turnOff, rhoc0=rhoc0,nu=nu,gamman=gamman, rhop0=rhop0,etap=etap,gammap=gammap)
        R2 = Rsquared(fitValues,dataValues)
        error = errorMetric(fitValues,dataValues)
    }

    ## plot TF concentrations on right axis, this axis used for annotation
    par(new=TRUE)
    maxRight = max(rhon_t)
    plot(t, rhon_t, type="l", col="blue", axes=FALSE, xlab=NA, ylab=NA, ylim=c(1,maxRight), log="y")
    ## lines(t, rhoc_t, col="blue")
    axis(side=4) 
    par(new=FALSE)

    ## annotation using right axis so stuff always in same place for given rhoc0
    xlegend = par()$usr[2]*0.95
    ylegend = par()$yaxp[1]
    step = 1.3
    if (hasArg(dataLabel) & !is.na(dataLabel)) {
        legend(xlegend, ylegend, xjust=1, yjust=0, lty=c(1,1,0), pch=c(-1,-1,19), col=c("blue","red","red"),
               c(
                   expression(paste(rho[n]," (right axis)")),
                   expression(paste(rho[p])),
                   dataLabel
                   )
               )
    } else {
        legend(xlegend, ylegend, xjust=0, yjust=0, lty=1, col=c("blue","red"),
               c(
                   expression(paste(rho[n],"  (right axis)")),
                   expression(rho[p])
                   )
               )
    }

    text(xlegend, maxRight/step^1, bquote(rho[c0]==.(round(rhoc0,1))), pos=2, col="blue")
    text(xlegend, maxRight/step^2, bquote(rho[n0]==.(round(rhon0,1))), pos=2, col="blue")
    text(xlegend, maxRight/step^3, bquote(nu==.(signif(nu,3))), pos=2, col="blue")
    text(xlegend, maxRight/step^4, bquote(gamma[n]==.(signif(gamman,3))), pos=2, col="blue")

    text(xlegend, maxRight/step^6, bquote(rho[p0]==.(round(rhop0,3))), pos=2, col="red")
    text(xlegend, maxRight/step^7, bquote(eta[p]==.(signif(etap,3))), pos=2, col="red")
    text(xlegend, maxRight/step^8, bquote(gamma[p]==.(signif(gammap,3))), pos=2, col="red")

    if (hasArg(dataTimes) & hasArg(dataValues)) {
        text(xlegend, maxRight/step^10, bquote(r^2==.(round(R2,2))), pos=2, col="black")
        text(xlegend, maxRight/step^11, bquote(logFC(inf)==.(round(logFCinf,2))), pos=2, col="black")
        text(xlegend, maxRight/step^12, bquote(kappa==.(signif(kappa,3))), pos=2, col="black")
    }

}
