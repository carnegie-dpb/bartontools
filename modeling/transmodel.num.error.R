##
## return the error metric for modeling a direct target, for nlm usage with numerical rhocnp.R
##
## assumes no nuclear loss of TF (gamman=0)

source("rhocnps.R")
source("errorMetric.R")

## the transcription model to be minimized
transmodel.num.error = function(p, fitType, turnOff, rhoc0, rhon0, nu, gamman, gammae, rhop0, etap, gammap, dataTimes, dataValues) {

  ## twoparam: fit rhop0, etap
  if (fitType=="twoparam") {
    rhop0 = p[1]
    etap = p[2]
  }

  ## threeparam: fit rhop0, etap, gammap
  if (fitType=="threeparam") {
    rhop0 = p[1]
    etap = p[2]
    gammap = p[3]
  }

  ## turnoff: threeparam plus turnOff
  if (fitType=="turnoff") {
    rhop0 = p[1]
    etap = p[2]
    gammap = p[3]
    turnOff = p[4]
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

  ## calculation interval
  t = (0:200)/100

  ## solve the model
  model = rhocnps(turnOff=turnOff, t=t, rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman,gammae=gammae, rhop0=rhop0,etap=etap,gammap=gammap, rhos0=0,etas=0,gammas=0)
  
  ## return error metric using interpolation
  fitValues = approx(t, model$rhop, dataTimes)
  return(errorMetric(fitValues$y,dataValues))
  
}
