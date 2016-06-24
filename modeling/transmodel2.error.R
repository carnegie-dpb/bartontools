##
## return the error metric for modeling an indirect target, given parameters for the TF and primary target
##

source("rhon.R")
source("rhop.R")
source("rhos.R")

transmodel2.error = function(p, rhoc0,nu, etap,gammap, dataTimes, data2Values) {

  ## secondary target fit parameters
  rhos0 = p[1]
  etas = p[2]
  gammas = p[3]

  ## return error metric
  fitValues = rhos(t=dataTimes, rhoc0=rhoc0,nu=nu, etap=etap,gammap=gammap, rhos0=rhos0,etas=etas,gammas=gammas)

  return(errorMetric(fitValues,data2Values))

}
