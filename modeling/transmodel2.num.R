##
## plot linear transcription model for a primary target and secondary target
##

source("rhocnps.R")
source("Rsquared.R")
source("errorMetric.R")

transmodel2.num = function(turnOff, rhoc0=18,rhon0=1,nu=10,gamman=0,gammae=0, rhop0,etap,gammap, rhos0,etas,gammas, dataTimes,data1Values,data1Label,data2Values,data2Label, plotBars=FALSE) {

  ## calculation interval
  t = seq(from=0, to=2, by=0.01)
  
  ## numerical model
  model = rhocnps(turnOff=turnOff, rhoc0=rhoc0,rhon0=rhon0,nu=nu,gammae=gammae,gamman=gamman, rhop0=rhop0,etap=etap,gammap=gammap, rhos0=rhos0,etas=etas,gammas=gammas, t=t)

  ## plot primary transcript concentration
  if (hasArg(data1Values)) {
    ## normalize to data t=0 values if exist
	#    d1base = mean(data1Values[dataTimes==0])
    #	 d2base = mean(data2Values[dataTimes==0])
	d1base=1
	d2base=1
    plot(t, model$rhop/d1base, type="l", xlab="time (h)", ylab="nuclear concentration (lines), expression (points)", lty=1, col="blue", log="y",
         ylim=c(0.1, max(data1Values/d1base,data2Values/d2base,model$rhop/d1base,model$rhos/d2base)))
  } else {
    plot(t, model$rhop, type="l", xlab="time (h)", ylab="nuclear concentration (arb)", ylim=c(0.1,max(model$rhop,model$rhos)), lty=1, log="y", col="blue")
  }

  ## secondary transcript concentration
  lines(t, model$rhos/d2base, lty=1, col="red")

  ## compare primary with provided data
  R2p = 0
  if (hasArg(dataTimes) & hasArg(data1Values)) {
    if (plotBars) {
      ## plot mean and error bars
      for (ti in unique(dataTimes)) {
        y = mean(data1Values[dataTimes==ti])
        sd = sd(data1Values[dataTimes==ti])
        points(ti, y/d1base, pch=21, cex=1.2, col="blue", bg="blue")
        segments(ti, (y-sd)/d1base, ti, (y+sd)/d1base, col="blue")
      }
    } else {
      ## plot points
      points(dataTimes, data1Values/d1base, pch=21, cex=1.2, col="blue", bg="blue")
    }
    ## get R-squared and error metric
    fitValues = approx(t, model$rhop, dataTimes)
    R2p = Rsquared(fitValues$y,data1Values)
    error = errorMetric(fitValues$y,data1Values)
    print(paste("Primary: error=",signif(error,6),"R2=",signif(R2p,6)))
  }

  ## compare secondary with provided data
  R2s = 0
  if (hasArg(dataTimes) & hasArg(data2Values)) {
    if (plotBars) {
      ## plot mean and error bars
      for (ti in unique(dataTimes)) {
        y = mean(data2Values[dataTimes==ti])
        sd = sd(data2Values[dataTimes==ti])
        points(ti, y/d2base, pch=22, cex=1.2, col="red", bg="red")
        segments(ti, (y-sd)/d2base, ti, (y+sd)/d2base, col="red")
      }
    } else {
      ## plot points
      points(dataTimes, data2Values/d2base, pch=22, cex=1.2, col="red", bg="red")
    }
    ## get R-squared and error metric
    fitValues = approx(t, model$rhos, dataTimes)
    R2s = Rsquared(fitValues$y,data2Values)
    error = errorMetric(fitValues$y,data2Values)
    print(paste("Secondary: error=",signif(error,6),"R2=",signif(R2s,6)))
  }

  ## plot GR-TF on right axis
  par(new=TRUE)
  plot(t, model$rhon, type="l", lty=1, axes=FALSE, xlab=NA, ylab=NA, ylim=c(1,max(model$rhon)), log="y")
  axis(side=4)
  par(new=FALSE)

  text(0.8*par()$xaxp[2], 0.95*par()$usr[4], bquote(rho[c0]==.(round(rhoc0,1))), pos=4, col="black")
  text(0.8*par()$xaxp[2], 0.90*par()$usr[4], bquote(rho[n0]==.(round(rhon0,1))), pos=4, col="black")
  text(0.8*par()$xaxp[2], 0.85*par()$usr[4], bquote(paste(nu==.(signif(nu,3))," ",h^-1)), pos=4, col="black")
  text(0.8*par()$xaxp[2], 0.80*par()$usr[4], bquote(paste(gamma[n]==.(signif(gamman,3))," ",h^-1)), pos=4, col="black")

  text(0.8*par()$xaxp[2], 0.75*par()$usr[4], bquote(rho[p0]==.(round(rhop0,1))), pos=4, col="blue")
  text(0.8*par()$xaxp[2], 0.70*par()$usr[4], bquote(paste(eta[p]==.(signif(etap,3))," ",h^-1)), pos=4, col="blue")
  text(0.8*par()$xaxp[2], 0.65*par()$usr[4], bquote(paste(gamma[p]==.(signif(gammap,3))," ",h^-1)), pos=4, col="blue")
  text(0.8*par()$xaxp[2], 0.60*par()$usr[4], bquote(r^2==.(round(R2p,2))), pos=4, col="blue")

  text(0.8*par()$xaxp[2], 0.55*par()$usr[4], bquote(rho[s0]==.(round(rhos0,1))), pos=4, col="red")
  text(0.8*par()$xaxp[2], 0.50*par()$usr[4], bquote(paste(eta[s]==.(signif(etas,3))," ",h^-1)), pos=4, col="red")
  text(0.8*par()$xaxp[2], 0.45*par()$usr[4], bquote(paste(gamma[s]==.(signif(gammas,3))," ",h^-1)), pos=4, col="red")
  text(0.8*par()$xaxp[2], 0.40*par()$usr[4], bquote(r^2==.(round(R2s,2))), pos=4, col="red")


  ## annotation using right axis
  if (hasArg(data1Label) & hasArg(data2Label)) {
    legend(0.2, par()$yaxp[1], xjust=0, yjust=0, pch=c(21,22), col=c("blue","red"), pt.bg=c("blue","red"), c(data1Label,data2Label))
  }
  
  legend(par()$xaxp[2], par()$yaxp[1], xjust=1, yjust=0, lty=1, col=c("black","blue","red"),
         c(
           expression(paste(rho[n], "  (right scale)")),
           expression(rho[p]),
           expression(rho[s])
           )
         )

}
