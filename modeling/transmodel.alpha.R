##
## plot linear transcription model for a direct target in one condition
## this version plots the normalized concentration/expression for a given t=0 value and net gain alphap
##
## GR-AS2: rhon0=3.3 rhoc0=148.2
## GR-KAN: rhon0=2.7 rhoc0=224.9
## GR-REV: rhon0=3.8 rhoc0= 98.0
## GR-STM: rhon0=3.3 rhoc0=148.2

source("rhon.R")
source("rhop.R")
source("Rsquared.R")
source("errorMetric.R")

transmodel.alpha = function(rhon0=1, rhoc0=26, nu=10, gamman=0, rhop0=0, alphap=1, gammap=3, dataTimes, dataValues, dataLabel=NA, plotBars=FALSE) {

  ## set rhop0 = average of t=0 data points
  if (rhop0==0 && hasArg(dataValues)) rhop0 = mean(dataValues[dataTimes==0])

  ## get etap from alphap
  etap = alphap*gammap*rhop0/rhoc0

  ## calculation interval
  if (hasArg(dataTimes)) {
    t = seq(from=0, to=max(dataTimes), by=0.01)
  } else {
    t = seq(from=0, to=2, by=0.01)
  }
  
  ## TF concentration
  rhon_t = rhon(rhoc0, rhon0, nu, gamman, t)

  ## transcript concentration
  rhop_t = rhop(rhoc0, nu, gamman, rhop0, etap, gammap, t)

  oldpar = par(mar=c(4, 4, 0.5, 3), mgp=c(2.5,1,0))

  ## plot transcript concentration
  if (hasArg(dataValues)) {
    plot(t, rhop_t/rhop0, type="l", xlab="time (h)", ylab="nuclear concentration (lines), expression (points)", col="red", ylim=c(1,max(dataValues/rhop0)), log="y")
  } else {
    plot(t, rhop_t/rhop0, type="l", xlab="time (h)", ylab="nuclear concentration", col="red", ylim=c(1,max(rhop_t)), log="y")
  }

  ## compare with provided data
  if (hasArg(dataTimes) & hasArg(dataValues)) {
    if (plotBars) {
      ## plot mean and error bars
      for (ti in unique(dataTimes)) {
        y = mean(dataValues[dataTimes==ti])
        sd = sd(dataValues[dataTimes==ti])
        points(ti, y/rhop0, pch=19, col="red")
        segments(ti, (y-sd)/rhop0, ti, (y+sd), col="red")
      }
    } else {
      ## plot each point
      points(dataTimes, dataValues/rhop0, pch=19, col="red")
    }
    ## get R-squared and error metric
    fitValues = dataTimes
    for (i in 1:length(dataTimes)) {
      fitValues[i] = rhop(rhoc0, nu, gamman, rhop0, etap, gammap, dataTimes[i])
    }
    R2 = Rsquared(fitValues,dataValues)
    error = errorMetric(fitValues,dataValues)
    print(paste("error=",signif(error,6),"R2=",signif(R2,6)))
    ## calculate logFC of the data
    dataMean = mean(dataValues)
    dataMeanTmin = 0
    dataMeanTmax = 0
    nTmin = 0
    nTmax = 0
    for (i in 1:length(dataTimes)) {
      if (dataTimes[i]==min(dataTimes)) {
        nTmin = nTmin + 1
        dataMeanTmin = dataMeanTmin + dataValues[i]
      } else if (dataTimes[i]==max(dataTimes)) {
        nTmax = nTmax + 1
        dataMeanTmax = dataMeanTmax + dataValues[i]
      }        
    }
    dataMeanTmin = dataMeanTmin/nTmin
    dataMeanTmax = dataMeanTmax/nTmax
    logFCData = log2(dataMeanTmax/dataMeanTmin)
  }

  ## compute model logFC over full time range
  if (rhop_t[1]>0) {
    logFCModel = log2(rhop_t[length(rhop_t)]/rhop_t[1])
  } else {
    logFCModel = NA
  }

  ## plot TF concentration on right axis, this axis used for annotation
  par(new=TRUE)
  plot(t, rhon_t/rhon0, type="l", col="blue", axes=FALSE, xlab=NA, ylab=NA, ylim=c(1,max(rhon_t)), log="y")
  axis(side=4) 
  par(new=FALSE)

  ## annotation using right axis so stuff always in same place for given rhoc0
  if (!is.na(logFCModel) & logFCModel<0) {
    legendX = par()$xaxp[2]
    legendXjust = 1
  } else {
    legendX = par()$xaxp[1]
    legendXjust = 0
  }
  if (hasArg(dataLabel) & !is.na(dataLabel)) {
    legend(legendX, 0.95*par()$yaxp[2], xjust=legendXjust, yjust=1, c("GR-TF (right axis)","Primary Target",dataLabel), lty=c(1,1,0), pch=c(-1,-1,19), col=c("blue","red","red"))
  } else {
    legend(legendX, 0.95*par()$yaxp[2], xjust=legendXjust, yjust=1, c("GR-TF (right axis)","Primary Target"), lty=1, col=c("blue","red"))
  }

  text(par()$xaxp[2], 0.65*par()$yaxp[2], bquote(rho[c0]==.(round(rhoc0,1))), pos=2, col="blue")
  text(par()$xaxp[2], 0.60*par()$yaxp[2], bquote(rho[n0]==.(round(rhon0,1))), pos=2, col="blue")
  text(par()$xaxp[2], 0.55*par()$yaxp[2], bquote(nu==.(signif(nu,3))), pos=2, col="blue")
  
  text(par()$xaxp[2], 0.45*par()$yaxp[2], bquote(rho[p0]==.(round(rhop0,1))), pos=2, col="black")
  text(par()$xaxp[2], 0.40*par()$yaxp[2], bquote(alpha[p]==.(signif(alphap,3))), pos=2, col="red")
  text(par()$xaxp[2], 0.35*par()$yaxp[2], bquote(gamma[p]==.(signif(gammap,3))), pos=2, col="red")

  if (hasArg(dataTimes) & hasArg(dataValues)) {
    text(par()$xaxp[2], 0.20*par()$yaxp[2], paste("logFC(data)=",signif(logFCData,3)), pos=2, col="black")
    text(par()$xaxp[2], 0.05*par()$yaxp[2], bquote(fit:R^2==.(round(R2,2))), pos=2, col="black")
  }
  if (!is.na(logFCModel)) {
    text(par()$xaxp[2], 0.15*par()$yaxp[2], paste("logFC(model)=",signif(logFCModel,3)), pos=2, col="black")
  }

  par(oldpar)
  
}
