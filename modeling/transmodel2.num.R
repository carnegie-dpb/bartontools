##
## plot linear transcription model for a primary target and secondary target
##

source("rhocnps.R")
source("Rsquared.R")
source("errorMetric.R")

transmodel2.num = function(turnOff, rhoc0,rhon0,nu, rhop0,etap,gammap, rhos0,etas,gammas, dataTimes,data1Values,data1Label,data2Values,data2Label, plotBars=FALSE) {

    ## calculation interval
    t = seq(from=0, to=2, by=0.01)
    
    ## numerical model
    model = rhocnps(turnOff=turnOff, rhoc0=rhoc0,rhon0=rhon0,nu=nu, gamman=0, gammae=0, rhop0=rhop0,etap=etap,gammap=gammap, rhos0=rhos0,etas=etas,gammas=gammas, t=t)

    ## plot primary transcript concentration
    if (hasArg(data1Values)) {
        plot(t, model$rhop, type="l", xlab="time after DEX application (h)", ylab="nuclear concentration (lines), expression (points)", lty=1, lwd=2, col="red", log="y",
             ylim=c(min(data1Values,data2Values,model$rhop,model$rhos), max(data1Values,data2Values,model$rhop,model$rhos)))
    } else {
        plot(t, model$rhop, type="l", xlab="time after DEX application (h)", ylab="nuclear concentration (arb)", ylim=c(0,max(model$rhop,model$rhos)), lty=1, lwd=2, col="red")
    }

    ## secondary transcript concentration
    lines(t, model$rhos, lty=1, lwd=2, col="darkgreen")

    ## compare primary with provided data
    R2p = 0
    if (hasArg(dataTimes) && hasArg(data1Values)) {
        if (plotBars) {
            ## plot mean and error bars
            for (ti in unique(dataTimes)) {
                y = mean(data1Values[dataTimes==ti])
                sd = sd(data1Values[dataTimes==ti])
                points(ti, y, pch=19, cex=1.2, col="red", bg="red")
                segments(ti, (y-sd), ti, (y+sd), col="red")
            }
        } else {
            ## plot points
            points(dataTimes, data1Values, pch=19, cex=1.2, col="red", bg="red")
        }
        ## get R-squared and error metric
        fitValues = approx(t, model$rhop, dataTimes)
        R2p = Rsquared(fitValues$y,data1Values)
        error = errorMetric(fitValues$y,data1Values)
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
                points(ti, y, pch=19, cex=1.2, col="darkgreen", bg="darkgreen")
                segments(ti, (y-sd), ti, (y+sd), col="darkgreen")
            }
        } else {
            ## plot points
            points(dataTimes, data2Values, pch=19, cex=1.2, col="darkgreen", bg="darkgreen")
        }
        ## get R-squared and error metric
        fitValues = approx(t, model$rhos, dataTimes)
        R2s = Rsquared(fitValues$y,data2Values)
        error = errorMetric(fitValues$y,data2Values)
        print(paste("Secondary: error=",signif(error,6),"R2=",signif(R2s,6)))
    }
    
    ## plot GR-TF on right axis
    par(new=TRUE)
    plot(t, model$rhon, type="l", lty=1, lwd=2, axes=FALSE, xlab=NA, ylab=NA, ylim=c(0,max(model$rhon)), col="blue")
    axis(side=4)
    par(new=FALSE)

    ## annotation using right axis
    maxRight = 0.95*max(model$rhon)
    step = 0.05*max(model$rhon)
    xtext = 0.8*max(t)

    text(xtext, maxRight, bquote(rho[c0]==.(round(rhoc0,1))), pos=4, col="blue")
    text(xtext, maxRight-1*step, bquote(rho[n0]==.(round(rhon0,1))), pos=4, col="blue")
    text(xtext, maxRight-2*step, bquote(paste(nu==.(signif(nu,3))," ",h^-1)), pos=4, col="blue")
    text(xtext, maxRight-3*step, bquote(gamma[n]==0), pos=4, col="blue")
    text(xtext, maxRight-4*step, bquote(gamma[e]==0), pos=4, col="blue")

    text(xtext, maxRight-8*step, bquote(rho[p0]==.(round(rhop0,1))), pos=4, col="red")
    text(xtext, maxRight-9*step, bquote(paste(eta[p]==.(signif(etap,3))," ",h^-1)), pos=4, col="red")
    text(xtext, maxRight-10*step, bquote(paste(gamma[p]==.(signif(gammap,3))," ",h^-1)), pos=4, col="red")
    text(xtext, maxRight-11*step, bquote(r^2==.(round(R2p,2))), pos=4, col="red")

    text(xtext, maxRight-13*step, bquote(rho[s0]==.(round(rhos0,1))), pos=4, col="darkgreen")
    text(xtext, maxRight-14*step, bquote(paste(eta[s]==.(signif(etas,3))," ",h^-1)), pos=4, col="darkgreen")
    text(xtext, maxRight-15*step, bquote(paste(gamma[s]==.(signif(gammas,3))," ",h^-1)), pos=4, col="darkgreen")
    text(xtext, maxRight-16*step, bquote(r^2==.(round(R2s,2))), pos=4, col="darkgreen")


    if (hasArg(data1Label) && hasArg(data2Label)) {
        legend(x=max(t)*0.6, maxRight*0.25, xjust=1, yjust=0, lty=c(0,0,1,1,1), lwd=2, pch=c(19,19,-1,-1,-1), cex=1, pt.cex=1.2,
               col=c("red","darkgreen","black","red","darkgreen"),
               c(
                   data1Label,
                   data2Label,
                   expression(paste(rho[n],"  ","(right scale, linear)")),
                   expression(paste(rho[p],"  ","(left scale, log)")),
                   expression(paste(rho[s],"  ","(left scale, log)"))
               )
               )
    } else {
        legend(x=max(t)*0.75, y=maxRight*0.25, xjust=1, yjust=0, lty=1, lwd=2, col=c("blue","red","darkgreen"),
               c(
                   expression(paste(rho[n], "  (right scale)")),
                   expression(rho[p]),
                   expression(rho[s])
               )
               )
    }

}
