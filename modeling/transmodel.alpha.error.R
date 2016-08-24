##
## return the error metric for modeling a direct target, for nlm usage
##
## assumes no nuclear loss of TF (gamman=0)

source("rhon.R")
source("rhop.R")
source("errorMetric.R")

## the transcription model to be minimized
transmodel.alpha.error = function(p, rhon0=0, rhoc0=0, rhop0=0, nu=0, gammap=0, dataTimes, dataValues) {

  ## leave gamman=0 always
  gamman = 0
    
  ## varied parameters for minimization
  if (nu==0 && gammap==0) {
    ## full three-parameter fit
    nu = p[1]
    alphap = p[2]
    gammap = p[3]
  } else if (nu==0) {
    ## two-parameter fit with gammap=nu along fit
    nu = p[1]
    alphap = p[2]
    gammap = nu
  } else if (gammap==0) {
    ## two-parameter fit with nu fixed
    alphap = p[1]
    gammap = p[2]
  } else {
    # hold both nu and gammap fixed
    alphap = p[1]
  }

  ## get etap from alphap, etc.
  etap = alphap*gammap*rhop0/rhoc0

  ## return error metric
  fitValues = dataTimes
  for (i in 1:length(dataTimes)) {
    fitValues[i] = rhop(rhoc0, nu, gamman, rhop0, etap, gammap, dataTimes[i])
  }
  return(errorMetric(fitValues,dataValues))

}
