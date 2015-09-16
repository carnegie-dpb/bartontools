##
## numerically solve linear transcription model for a direct target in one condition
##

source("../R/getExpression.R")
source("../R/getTimes.R")

source("rhocnps.R")
source("Rsquared.R")
source("errorMetric.R")

transmodel.num = function(turnOff, rhoc0, rhon0, nu, gammae, gamman, rhop0, etap, gammap, dataTimes, dataValues, dataLabel=NA, plotBars=FALSE) {

  ## set rhop0 = mean of first three data points
  if (rhop0==0) rhop0 = mean(dataValues[1:3])

  ## calculation interval
  t = (0:200)/100

  ## solve the model
  model = rhocnps(turnOff=turnOff, t=t, rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman,gammae=gammae, rhop0=rhop0,etap=etap,gammap=gammap, rhos0=0,etas=0,gammas=0)

  ## plot transcript concentration
  plot(model$t, model$rhop, type="l", xlab="time (h)", ylab="nuclear concentration (lines), expression (points)", col="red", ylim=c(0,max(dataValues)))

  ## compare with provided data
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
  fitValues = dataTimes
  for (i in 1:length(dataTimes)) {
    fitValues[i] = approx(model$t, model$rhop, dataTimes[i])$y
  }
  R2 = Rsquared(fitValues,dataValues)
  error = errorMetric(fitValues,dataValues)
  print(paste("error=",signif(error,6),"R2=",signif(R2,6)))

  ## plot TF concentration on right axis, this axis used for annotation
  par(new=TRUE)
  plot(model$t, model$rhon, type="l", col="blue", axes=FALSE, xlab=NA, ylab=NA, ylim=c(0,max(model$rhon)))
  axis(side=4) 
  par(new=FALSE)

  ## annotation using right axis so stuff always in same place for given rhoc0
  legend(par()$xaxp[1], par()$yaxp[1], xjust=0, yjust=0, lty=c(1,1,0), pch=c(-1,-1,19), col=c("blue","red","red"),
         c(
           expression(paste(rho[n],"  (right axis)")),
           expression(rho[p]),
           dataLabel
           )
         )

  text(par()$xaxp[2], 1.00*par()$yaxp[2], bquote(rho[c0]==.(round(rhoc0,1))), pos=2, col="blue")
  text(par()$xaxp[2], 0.95*par()$yaxp[2], bquote(rho[n0]==.(round(rhon0,1))), pos=2, col="blue")
  text(par()$xaxp[2], 0.90*par()$yaxp[2], bquote(nu==.(signif(nu,3))), pos=2, col="blue")
  text(par()$xaxp[2], 0.85*par()$yaxp[2], bquote(gamma[e]==.(signif(gammae,3))), pos=2, col="blue")
  text(par()$xaxp[2], 0.80*par()$yaxp[2], bquote(gamma[n]==.(signif(gamman,3))), pos=2, col="blue")

  text(par()$xaxp[2], 0.75*par()$yaxp[2], bquote(rho[p0]==.(round(rhop0,1))), pos=2, col="red")
  text(par()$xaxp[2], 0.70*par()$yaxp[2], bquote(eta[p]==.(signif(etap,3))), pos=2, col="red")
  text(par()$xaxp[2], 0.65*par()$yaxp[2], bquote(gamma[p]==.(signif(gammap,3))), pos=2, col="red")

  text(par()$xaxp[2], 0.60*par()$yaxp[2], bquote(r^2==.(round(R2,2))), pos=2, col="black")
  
}
