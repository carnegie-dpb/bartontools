##
## plot linear transcription model for a primary target and secondary target
##

source("rhocnps.R")
source("Rsquared.R")
source("errorMetric.R")

transmodels.num = function(rhoc0,rhon0,nu,gamman,gammae, rhop0,etap,gammap, rhos0,etas,gammas, turnOff, dataTimes, data2Values,data2Label, plotBars=FALSE) {

  ## calculation interval
  t = seq(from=0, to=2, by=0.01)
  
  ## numerical model
  model = rhocnps(rhoc0,rhon0,nu,gammae,gamman, rhop0,etap,gammap, rhos0,etas,gammas, t, turnOff)

  ## primary transcript
  plot(t, model$rhop, type="l", xlab="time (h)", ylab="nuclear concentration (arb)", ylim=c(0,max(model$rhop,model$rhos)), lty=2, col="blue")

  ## secondary transcript concentration
  lines(t, model$rhos, lty=3, col="red")

  ## compare secondary with provided data
  R2s = 0
  if (hasArg(dataTimes) & hasArg(data2Values)) {
    if (plotBars) {
      ## plot mean and error bars
      for (ti in unique(dataTimes)) {
        y = mean(data2Values[dataTimes==ti])
        sd = sd(data2Values[dataTimes==ti])
        points(ti, y, pch=22, cex=1.2, col="red", bg="red")
        segments(ti, (y-sd), ti, (y+sd), col="red")
      }
    } else {
      ## plot points
      points(dataTimes, data2Values, pch=22, cex=1.2, col="red", bg="red")
    }
    ## get R-squared and error metric
    fitValues = approx(t, model$rhos, dataTimes)
    R2s = Rsquared(fitValues$y,data2Values)
    error = errorMetric(fitValues$y,data2Values)
    print(paste("Secondary: error=",signif(error,6),"R2=",signif(R2s,6)))
  }

  ## plot GR-TF on right axis
  par(new=TRUE)
  plot(t, model$rhon, type="l", lty=1, axes=FALSE, xlab=NA, ylab=NA, ylim=c(0,max(model$rhon)))
  axis(side=4)
  par(new=FALSE)
  
  text(0.8*par()$xaxp[2], 0.95*par()$usr[4], bquote(rho[c0]==.(round(rhoc0,1))), pos=4, col="black")
  text(0.8*par()$xaxp[2], 0.90*par()$usr[4], bquote(rho[n0]==.(round(rhon0,1))), pos=4, col="black")
  text(0.8*par()$xaxp[2], 0.85*par()$usr[4], bquote(paste(nu==.(signif(nu,3))," ",h^-1)), pos=4, col="black")
  text(0.8*par()$xaxp[2], 0.80*par()$usr[4], bquote(paste(gamma[n]==.(signif(gamman,3))," ",h^-1)), pos=4, col="black")

  text(0.8*par()$xaxp[2], 0.75*par()$usr[4], bquote(rho[p0]==.(round(rhop0,1))), pos=4, col="blue")
  text(0.8*par()$xaxp[2], 0.70*par()$usr[4], bquote(paste(eta[p]==.(signif(etap,3))," ",h^-1)), pos=4, col="blue")
  text(0.8*par()$xaxp[2], 0.65*par()$usr[4], bquote(paste(gamma[p]==.(signif(gammap,3))," ",h^-1)), pos=4, col="blue")
  
  text(0.8*par()$xaxp[2], 0.55*par()$usr[4], bquote(rho[s0]==.(round(rhos0,1))), pos=4, col="red")
  text(0.8*par()$xaxp[2], 0.50*par()$usr[4], bquote(paste(eta[s]==.(signif(etas,3))," ",h^-1)), pos=4, col="red")
  text(0.8*par()$xaxp[2], 0.45*par()$usr[4], bquote(paste(gamma[s]==.(signif(gammas,3))," ",h^-1)), pos=4, col="red")
  text(0.8*par()$xaxp[2], 0.40*par()$usr[4], bquote(r^2==.(round(R2s,2))), pos=4, col="red")


  ## ## annotation using right axis
  ## if (hasArg(hasArg(data2Label)) {
  ##   legend(0.2, par()$yaxp[1], xjust=0, yjust=0, pch=21, col="red", pt.bg="red", c(data2Label))
  ## }
      
  ##     legend(par()$xaxp[2], par()$yaxp[1], xjust=1, yjust=0, lty=1:3,
  ##            c(
  ##              expression(paste(rho[n], "  (right scale)")),
  ##          expression(rho[p]),
  ##          expression(rho[s])
  ##          )
  ##        )

}
