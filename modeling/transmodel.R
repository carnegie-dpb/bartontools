##
## plot linear transcription model for a direct target in one condition
##

source("rhoc.R")
source("rhon.R")
source("rhop.R")

source("Rsquared.R")
source("errorMetric.R")

transmodel = function(turnOff=0, rhon0, rhoc0, nu, rhop0, etap, gammap, dataTimes, dataValues, dataLabel=NA, plotBars=FALSE) {

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
    rhon_t = rhon(t=t, rhoc0=rhoc0,rhon0=rhon0,nu=nu)
    
    ## transcript concentration
    rhop_t = rhop(t=t, turnOff=turnOff, rhoc0=rhoc0,nu=nu, rhop0=rhop0,etap=etap,gammap=gammap)
    
    ## plot transcript concentration
    if (hasArg(dataValues)) {
        ymin = min(dataValues,rhop_t)
        ymax = max(dataValues,rhop_t)
        plot(t, rhop_t, type="l", xlab="time (h)", ylab="model concentration (lines), mRNA level (points)", col="red", ylim=c(0,ymax))
    } else {
        ymin = min(rhop_t)
        ymax = max(rhop_t)
        plot(t, rhop_t, type="l", xlab="time (h)", ylab="nuclear concentration", col="red", ylim=c(0,ymax))
    }

    ## metrics for display
    logFCinf = log2(1 + etap/gammap*rhoc0/rhop0)
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
        fitValues = rhop(t=dataTimes, turnOff=turnOff, rhoc0=rhoc0,nu=nu, rhop0=rhop0,etap=etap,gammap=gammap)
        R2 = Rsquared(fitValues,dataValues)
        error = errorMetric(fitValues,dataValues)
    }

    ## plot TF concentrations on right axis, this axis used for annotation
    par(new=TRUE)
    plot(t, rhon_t, type="l", col="blue", axes=FALSE, xlab=NA, ylab=NA, ylim=c(0,max(rhon_t)))
        
    ## lines(t, rhoc_t, col="blue")
    axis(side=4) 
    par(new=FALSE)

    ## annotation using right axis so stuff always in same place for given rhoc0

    ## LOG
    step = 1.12^(par()$usr[4]-par()$usr[3])
    maxRight = 10^par()$usr[4]/step
    xtext = par()$usr[2]*0.95
    ylegend = 10^par()$usr[3]*sqrt(step)

    ## LIN
    step = par()$usr[4]*0.045
    maxRight = par()$usr[4]*0.7
    xtext = par()$usr[2]*0.85
    ylegend = 0

    if (hasArg(dataLabel) & !is.na(dataLabel)) {
        legend(max(t), ylegend, xjust=1, yjust=0, lty=c(1,1,0), pch=c(-1,-1,19), col=c("blue","red","red"),
               c(
                   expression(paste(rho[n]," (right axis)")),
                   expression(paste(rho[p])),
                   dataLabel
                   )
               )
    } else {
        legend(max(t), ylegend, xjust=0, yjust=0, lty=1, col=c("blue","red"),
               c(
                   expression(paste(rho[n],"  (right axis)")),
                   expression(rho[p])
                   )
               )
    }

    text(xtext, maxRight-step*1, bquote(rho[c0]==.(round(rhoc0,1))), pos=3, col="blue")
    text(xtext, maxRight-step*2, bquote(rho[n0]==.(round(rhon0,1))), pos=3, col="blue")
##    text(xtext, maxRight-step*3, bquote(gamma[e]==0), pos=3, col="blue")
##    text(xtext, maxRight-step*4, bquote(gamma[n]==0), pos=3, col="blue")
    text(xtext, maxRight-step*3, bquote(paste(nu==.(signif(nu,3))," ",h^-1)), pos=3, col="blue")

    text(xtext, maxRight-step*5, bquote(rho[p0]==.(signif(rhop0,3))), pos=3, col="red")
    text(xtext, maxRight-step*6, bquote(paste(eta[p]==.(signif(etap,3))," ",h^-1)), pos=3, col="red")
    text(xtext, maxRight-step*7, bquote(paste(gamma[p]==.(round(gammap,2))," ",h^-1)), pos=3, col="red")

    ## flag suspect fits
    if (etap*(rhon0+rhoc0)/abs(rhop0)<1 || etap*(rhon0+rhoc0)/abs(rhop0)>100) {
        text(xtext, maxRight-step*6, "?", pos=4, col="red")
    }
    if (gammap<0.1 || gammap>10) {
        text(xtext, maxRight-step*7, "?", pos=4, col="red")
    }
    if (hasArg(dataTimes) & hasArg(dataValues)) {
        text(xtext, maxRight-step*9, bquote(paste(kappa==.(signif(kappa,3))," ",h^-2)), pos=3, col="black")
        text(xtext, maxRight-step*10, bquote(logFC(inf)==.(round(logFCinf,2))), pos=3, col="black")
        text(xtext, maxRight-step*11, bquote(r^2==.(round(R2,2))), pos=3, col="black")
    }

}
