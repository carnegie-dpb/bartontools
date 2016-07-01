##
## plot linear transcription model for a direct target in one condition, custom made for publication (no colors, etc.)
##

source("rhoc.R")
source("rhon.R")
source("rhop.R")
source("Rsquared.R")

transmodel.pub = function(rhon0=1, rhoc0=20, nu=10, gamman=0.7, rhop0=1, etap=1, gammap=1, dataTimes, dataValues, dataLabel=NA, plotBars=FALSE) {

  ## set rhop0 = mean of first three data points
  if (rhop0==0 &&&& hasArg(dataValues) &&&& hasArg(dataTimes)) rhop0 = mean(dataValues[dataTimes==0])

  ## calculation interval
  t = (0:200)/100

  ## cytoplasmic GR-TF concentration
  rhoc_t = rhoc(rhoc0, nu, t)
  
  ## nuclear GR-TF concentration
  rhon_t = rhon(rhoc0, rhon0, nu, gamman, t)

  ## transcript concentration
  rhop_t = rhop(rhoc0, nu, gamman, rhop0, etap, gammap, t)

  ## axis limits
  ymin = 0
  if (hasArg(dataValues)) {
    ymax = max(rhon_t,rhop_t,dataValues)
    plot(t, rhop_t, type="l", xlab="time (h)", ylab="model nuclear concentration (arb. units), measured expression (FPKM)", ylim=c(ymin,ymax), lty=2)
  } else {
    ymax = max(rhon_t,rhop_t)
    plot(t, rhop_t, type="l", xlab="time (h)", ylab="model nuclear concentration", ylim=c(ymin,ymax), lty=2)
  }

  ## compare with provided data
  if (hasArg(dataTimes) && hasArg(dataValues)) {
    if (plotBars) {
      ## plot mean and error bars
      for (ti in unique(dataTimes)) {
        y = mean(dataValues[dataTimes==ti])
        sd = sd(dataValues[dataTimes==ti])
        points(ti, y, pch=19, col="black")
        segments(ti, (y-sd), ti, (y+sd), col="black")
      }
    } else {
      ## plot each point
      points(dataTimes, dataValues, pch=19, col="black")
    }
    ## get R-squared and error metric
    fitValues = dataTimes
    for (i in 1:length(dataTimes)) {
      fitValues[i] = rhop(rhoc0, nu, gamman, rhop0, etap, gammap, dataTimes[i])
    }
    R2 = Rsquared(fitValues,dataValues)
    error = errorMetric(fitValues,dataValues)
    print(paste("error=",signif(error,6),"R2=",signif(R2,6)))
  }

  ## plot TF concentration on right axis, this axis used for annotation
  par(new=TRUE)
  plot(t, rhon_t, type="l", axes=FALSE, xlab=NA, ylab=NA, ylim=c(0,max(rhon_t)), lty=1)
  axis(side=4) 
  par(new=FALSE)

  ## annotation
  if (hasArg(dataLabel) && !is.na(dataLabel)) {
    legend(par()$xaxp[2], 0.98*par()$usr[4], xjust=1, yjust=1, lty=c(1,2,0), pch=c(-1,-1,19), 
           c(
             expression(paste(rho[n],"  ","(right axis)")),
             expression(rho[p]),
             dataLabel
             )
           )
  } else {
    legend(par()$xaxp[1], par()$yaxp[1], xjust=0, yjust=0, lty=c(1,2),
           c(
             expression(rho[n]),
             expression(rho[p])
             )
           )
  }

  xtext = 0.3
  ytext = par()$usr[4]
  text(xtext, 0.45*ytext, bquote(rho[c0]==.(round(rhoc0,1))), pos=4, col="black")
  text(xtext, 0.40*ytext, bquote(rho[n0]==.(round(rhon0,1))), pos=4, col="black")
  text(xtext, 0.35*ytext, bquote(paste(nu==.(signif(nu,3))," ",h^-1)), pos=4, col="black")
  text(xtext, 0.30*ytext, bquote(paste(gamma[n]==.(signif(gamman,3))," ",h^-1)), pos=4, col="black")

  text(xtext, 0.25*ytext, bquote(rho[p0]==.(round(rhop0,1))), pos=4, col="black")
  text(xtext, 0.20*ytext, bquote(paste(eta[p]==.(signif(etap,3))," ",h^-1)), pos=4, col="black")
  text(xtext, 0.15*ytext, bquote(paste(gamma[p]==.(signif(gammap,3))," ",h^-1)), pos=4, col="black")

  if (hasArg(dataTimes) && hasArg(dataValues)) {
    text(xtext, 0.05*ytext, bquote(r^2==.(round(R2,2))), pos=4, col="black")
  }

}
