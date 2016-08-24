##
## solve linear transcription model for a direct target using numerical integration
##

source("rhocn.R")

translocation.num = function(rhoc0=99, rhon0=1, nu=12.1, gammae=0.146, gamman=0, dataTimes, dataValues) {

  ## time points
  t = (0:200)/100

  ## integrate the equations
  model = rhocn(rhoc0, rhon0, nu, gammae, gamman, t)

  ## plot
  plot(model$t, model$rhoc, type="l", col="black", xlab="time (h)", ylab="cytoplasmic, nuclear GR fraction (%)", ylim=c(0,100))
  lines(model$t, model$rhon, col="blue")

  text(par()$xaxp[2], 0.65*par()$yaxp[2], bquote(rho[c0]==.(round(rhoc0,1))), pos=2, col="black")
  text(par()$xaxp[2], 0.60*par()$yaxp[2], bquote(rho[n0]==.(round(rhon0,1))), pos=2, col="blue")
  text(par()$xaxp[2], 0.55*par()$yaxp[2], bquote(nu==.(signif(nu,3))), pos=2, col="blue")
  text(par()$xaxp[2], 0.50*par()$yaxp[2], bquote(gamma[e]==.(signif(gammae,3))), pos=2, col="blue")
  text(par()$xaxp[2], 0.45*par()$yaxp[2], bquote(gamma[n]==.(signif(gamman,3))), pos=2, col="blue")

  ## overplot data points
  if (hasArg(dataTimes) && hasArg(dataValues)) {
    points(dataTimes, dataValues, pch=19, col="blue")
    R2numer = 0
    R2denom = 0
    dataMean = mean(dataValues)
    for (i in 1:length(dataTimes)) {
      rhonHere = approx(model$t, model$rhon, dataTimes[i])
      R2numer = R2numer + (dataValues[i]-rhonHere$y)^2
      R2denom = R2denom + (dataValues[i]-dataMean)^2
    }
    R2 = 1 - R2numer/R2denom
    print(paste("Rsquared",R2))
    if (hasArg(dataLabel)) {
      legend(max(t), 0.1*par()$yaxp[2], dataLabel, xjust=1, pch=19, col="blue")
    }
    text(par()$xaxp[2], 0.30*par()$yaxp[2], bquote(fit:R^2==.(signif(R2,2))), pos=2)
  }


}
