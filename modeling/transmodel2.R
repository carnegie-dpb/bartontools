##
## plot linear transcription model for a primary target and secondary target
##

source("rhon.R")
source("rhop.R")
source("rhos.R")
source("Rsquared.R")
source("errorMetric.R")

transmodel2 = function(turnOff, rhoc0,rhon0,nu, rhop0,etap,gammap, rhos0,etas,gammas, dataTimes,data1Values,data1Label,data2Values,data2Label, plotBars=FALSE) {

    ## calculation interval
    if (hasArg(dataTimes)) {
        t = seq(from=0, to=max(dataTimes), by=0.01)
    } else {
        t = seq(from=0, to=2, by=0.01)
    }
    
    ## TF concentration
    rhon_t = rhon(rhoc0=rhoc0, rhon0=rhon0, nu=nu, t=t)

    ## primary target concentration
    rhop_t = rhop(t=t, turnOff=turnOff, rhoc0=rhoc0,nu=nu, rhop0=rhop0,etap=etap,gammap=gammap)

    ## secondary target concentration
    rhos_t = rhos(t=t, rhoc0=rhoc0,nu=nu, etap=etap,gammap=gammap, rhos0=rhos0,etas=etas,gammas=gammas)

    ## plot primary transcript concentration
    if (hasArg(data1Values)) {
        ymax = max(data1Values,data2Values,rhop_t,rhos_t)
        plot(t, rhop_t, col="blue", type="l", xlab="time (h)", ylab="model concentration (lines), mRNA level (points)", lty=1, ylim=c(0,ymax))
    } else {
        ymax = max(rhop_t,rhos_t)
        plot(t, rhop_t, col="blue", type="l", xlab="time (h)", ylab="nuclear concentration (arb)", lty=1, ylim=c(0,ymax))
    }

    ## secondary transcript concentration
    lines(t, rhos_t, lty=1, col="red")

    ## compare primary with provided data
    R2p = 0
    if (hasArg(dataTimes) && hasArg(data1Values)) {
        if (plotBars) {
            ## plot mean and error bars
            for (ti in unique(dataTimes)) {
                y = mean(data1Values[dataTimes==ti])
                sd = sd(data1Values[dataTimes==ti])
                points(ti, y, pch=19, cex=1.2, col="blue")
                segments(ti, (y-sd), ti, (y+sd), col="blue")
            }
        } else {
            ## plot points
            points(dataTimes, data1Values, pch=19, cex=1.2, col="blue")
        }
        ## get R-squared and error metric
        fitValues = rhop(t=dataTimes, turnOff=turnOff, rhoc0=rhoc0,nu=nu, rhop0=rhop0,etap=etap,gammap=gammap)
        R2p = Rsquared(fitValues,data1Values)
        error = errorMetric(fitValues,data1Values)
        print(paste("Primary: error=",signif(error,6),"R2=",signif(R2p,6)))
    }

    ## compare secondary with provided data
    R2s = 0
    if (hasArg(dataTimes) && hasArg(data2Values)) {
        if (plotBars) {
            ## plot mean and error bars
            for (ti in unique(dataTimes)) {
                y = mean(data2Values[dataTimes==ti])
                sd = sd(data2Values[dataTimes==ti])
                points(ti, y, pch=19, cex=1.2, col="red")
                segments(ti, (y-sd), ti, (y+sd), col="red")
            }
        } else {
            ## plot points
            points(dataTimes, data2Values, pch=19, cex=1.2, col="red")
        }
        ## get R-squared and error metric
        fitValues = rhos(t=dataTimes, rhoc0=rhoc0,nu=nu, etap=etap,gammap=gammap, rhos0=rhos0,etas=etas,gammas=gammas)
        R2s = Rsquared(fitValues,data2Values)
        error = errorMetric(fitValues,data2Values)
        print(paste("Secondary: error=",signif(error,6),"R2=",signif(R2s,6)))
    }

    ## plot GR-TF on right axis
    par(new=TRUE)
    maxRight = max(rhon_t)*0.9
    plot(t, rhon_t, type="l", lty=1, axes=FALSE, xlab=NA, ylab=NA, ylim=c(0,max(rhon_t)))
    axis(side=4)
    par(new=FALSE)

    ## optional annotation using right axis
    xlegend = par()$usr[2]*0.95
    ylegend = par()$yaxp[1]
    if (hasArg(data1Label) && hasArg(data2Label)) {
        legend(xlegend, ylegend, xjust=1, yjust=0, lty=c(0,0,1,1,1), pch=c(19,19,-1,-1,-1), cex=1, pt.cex=1.2, col=c("blue","red","black","blue","red"), text.col=c("blue","red","black","blue","red"),
               c(
                   bquote(paste(.(data1Label))),
                   bquote(paste(.(data2Label))),
                   expression(paste(rho[n],"  (right scale)")),
                   expression(rho[p]),
                   expression(rho[s])
               )
               )
    } else {
        legend(xlegend, ylegend, xjust=1, yjust=0, lty=1:3,
               c(
                   expression(paste(rho[n], "  (right scale)")),
                   expression(rho[p]),
                   expression(rho[s])
               )
               )
    }

    step = max(rhon_t)*0.04

    text(xlegend, maxRight-step*0, bquote(rho[c0]==.(round(rhoc0,1))), pos=2, col="black")
    text(xlegend, maxRight-step*1, bquote(rho[n0]==.(round(rhon0,1))), pos=2, col="black")
    text(xlegend, maxRight-step*2, bquote(nu==.(signif(nu,3))), pos=2, col="black")

    text(xlegend, maxRight-step*4, bquote(rho[p0]==.(round(rhop0,1))), pos=2, col="blue")
    text(xlegend, maxRight-step*5, bquote(eta[p]==.(signif(etap,3))), pos=2, col="blue")
    text(xlegend, maxRight-step*6, bquote(gamma[p]==.(signif(gammap,3))), pos=2, col="blue")
    text(xlegend, maxRight-step*7, bquote(r^2==.(round(R2p,2))), pos=2, col="blue")

    text(xlegend, maxRight-step*9, bquote(rho[s0]==.(round(rhos0,1))), pos=2, col="red")
    text(xlegend, maxRight-step*10, bquote(eta[s]==.(signif(etas,3))), pos=2, col="red")
    text(xlegend, maxRight-step*11, bquote(gamma[s]==.(signif(gammas,3))), pos=2, col="red")
    text(xlegend, maxRight-step*12, bquote(r^2==.(round(R2s,2))), pos=2, col="red")




}
