##
## return the error metric for modeling a secondary target, for nlm usage with numerical rhocnp.R
##
## assumes no nuclear loss of TF (gamman=0)

source("rhos.num.R")
source("errorMetric.R")

## the transcription model to be minimized
transmodel2.num.error = function(p, fitTerms, turnOff, rhoc0,rhon0,nu, rhop0,etap,gammap, rhos0,etas,gammas, dataTimes, dataValues) {

    ## standard three-parameter fit
    if (fitTerms=="rhos0.etas.gammas") {
        rhos0 = p[1]
        etas = p[2]
        gammas = p[3]
    }

    ## two-parameter fit with rhos0 fixed
    if (fitTerms=="etas.gammas") {
        etas = p[1]
        gammas = p[2]
    }

    ## calculation interval
    t = (0:200)/100

    ## solve rhos
    rhos = rhos.num(turnOff=turnOff, rhoc0=rhoc0,rhon0=rhon0,nu=nu, rhop0=rhop0,etap=etap,gammap=gammap, rhos0=rhos0,etas=etas,gammas=gammas, t=t)
    
    ## return error metric using interpolation
    fitValues = approx(t, rhos, dataTimes)
    return(errorMetric(fitValues$y,dataValues))
    
}
