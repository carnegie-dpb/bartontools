##
## return the error metric for modeling a secondary target, for nlm usage with numerical rhocnp.R
##
## assumes no nuclear loss of TF (gamman=0)

source("rhocnps.R")
source("errorMetric.R")

## the transcription model to be minimized
transmodels.num.error = function(p, rhon0,rhoc0,nu,gamman,gammae, rhop0,etap,gammap, gammas, dataTimes, dataValues, turnOff) {

  ## four-parameter fit with rhop0 fixed and gammas fixed
  etap = p[1]
  gammap = p[2]
  rhos0 = p[3]
  etas = p[4]

  ## calculation interval
  t = (0:200)/100

  ## solve the model
  model = rhocnps(rhoc0,rhon0,nu,gammae,gamman, rhop0,etap,gammap, rhos0,etas,gammas, t, turnOff)
  
  ## return error metric using interpolation
  fitValues = approx(t, model$rhos, dataTimes)
  return(errorMetric(fitValues$y,dataValues))
  
}
