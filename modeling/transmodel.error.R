##
## return the error metric for modeling a direct target, for nlm usage
##
## assumes no nuclear loss of TF (gamman=0)

source("rhop.R")
source("errorMetric.R")

## the transcription model to be minimized
transmodel.error = function(p, fitType, turnOff, rhoc0,nu,gamman, rhop0,etap,gammap, dataTimes, dataValues) {

  ## oneparam: fit rhop0 only
  if (fitType=="oneparam") {
    rhop0 = p[1]
  }
  
  ## twoparam1: fit rhop0, etap
  if (fitType=="twoparam1") {
    rhop0 = p[1]
    etap = p[2]
  }

  ## twoparam2: fit etap, gammap
  if (fitType=="twoparam2") {
    etap = p[1]
    gammap = p[2]
  }

  ## threeparam: fit rhop0, etap, gammap
  if (fitType=="threeparam") {
    rhop0 = p[1]
    etap = p[2]
    gammap = p[3]
  }

  ## fourparam1: fit gamman, rhop0, etap, gammap
  if (fitType=="fourparam1") {
    gamman = p[1]
    rhop0 = p[2]
    etap = p[3]
    gammap = p[4]
  }
  
  ## fourparam2: fit nu, rhop0, etap, gammap
  if (fitType=="fourparam2") {
    nu = p[1]
    rhop0 = p[2]
    etap = p[3]
    gammap = p[4]
  }

  ## return error metric
  fitValues = rhop(turnOff=turnOff, t=dataTimes, rhoc0=rhoc0, nu=nu, gamman=gamman, rhop0=rhop0, etap=etap, gammap=gammap)

  return(errorMetric(fitValues,dataValues))

}
