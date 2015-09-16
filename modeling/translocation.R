##
## simple model of GR translocation with nu=nuclear import rate, gamman = nuclear loss rate
##

source("rhoc.R")
source("rhon.R")
source("Rsquared.R")

translocation = function(rhoc0, rhon0, nu, gamman, dataTimes, dataValues, dataLabel) {

  ## calculation interval
  t = seq(from=0, to=max(dataTimes), by=0.01)
  
  ## cytoplasmic GR concentration in absolute units
  rhoc_t = rhoc(rhoc0, nu, t)
  
  ## nuclear GR concentration in absolute units
  rhon_t = rhon(rhoc0, rhon0, nu, gamman, t)

  ## GR concentration
  ymin = min(dataValues, rhon_t)
  ymin = max(ymin, 1)
  ymax = max(dataValues, rhon_t)
  plot(t, rhon_t, type="l", xlab="t (h)", ylab="Nuclear GR Concentration", col="black", ylim=c(ymin,ymax), log="y")

  ## overplot data points
  maxRight = max(rhon_t,dataValues)
  xlegend = max(t)*0.95
  ylegend = ymin*1.1
  step = exp(log(ymax/ymin)/20)
  if (hasArg(dataTimes) & hasArg(dataValues)) {
      points(dataTimes, dataValues, pch=19, col="blue")
      fitValues = dataTimes
      for (i in 1:length(dataTimes)) {
          fitValues[i] = rhon(rhoc0, rhon0, nu, gamman, dataTimes[i])
      }
      R2 = Rsquared(fitValues,dataValues)
      text(xlegend, maxRight/step^5, bquote(r^2==.(signif(R2,2))), pos=2)
      print(paste("Rsquared",R2))
      if (hasArg(dataLabel)) {
          legend(xlegend, ylegend, dataLabel, xjust=1, yjust=0, pch=19, col="blue")
      }
  }

  text(xlegend, maxRight/step^0, bquote(rho[c0]==.(signif(rhoc0,2))), pos=2)
  text(xlegend, maxRight/step^1, bquote(rho[n0]==.(signif(rhon0,2))), pos=2)
  text(xlegend, maxRight/step^2, bquote(nu==.(signif(nu,2))), pos=2)
  text(xlegend, maxRight/step^3, bquote(gamma[n]==.(signif(gamman,2))), pos=2)


}
