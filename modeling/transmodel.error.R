##
## return the error metric for modeling a direct target, for nlm usage
##
## assumes no nuclear loss of TF (gamman=0)

source("rhop.R")
source("errorMetric.R")

## the transcription model to be minimized
transmodel.error = function(p, fitTerms, turnOff, rhoc0,rhon0,nu, rhop0,etap,gammap, dataTimes, dataValues) {

    ## allowable parameter ranges
    gammapMax = 8.0
    
    ## rhop0: fit rhop0 only
    if (fitTerms=="rhop0") {
        rhop0 = p[1]
    }
    
    ## rhop0.etap: fit rhop0, etap
    if (fitTerms=="rhop0.etap") {
        rhop0 = p[1]
        etap = p[2]
    }

    ## etap.gammap: fit etap, gammap
    if (fitTerms=="etap.gammap") {
        etap = p[1]
        gammap = p[2]
    }

    ## rhop0.etap.gammap: fit rhop0, etap, gammap
    if (fitTerms=="rhop0.etap.gammap") {
        rhop0 = p[1]
        etap = p[2]
        gammap = p[3]
    }

    ## nu.rhop0.etap.gammap: fit nu, rhop0, etap, gammap
    if (fitTerms=="nu.rhop0.etap.gammap") {
        nu = p[1]
        rhop0 = p[2]
        etap = p[3]
        gammap = p[4]
    }

    ## set fit=0 if parameters out of bounds
    if (gammap>gammapMax) {
        fitValues = dataTimes*0
    } else {
        fitValues = rhop(t=dataTimes, rhoc0=rhoc0, rhon0=rhon0, nu=nu, rhop0=rhop0, etap=etap, gammap=gammap, turnOff=turnOff)
    }

    ## return error metric
    return(errorMetric(fitValues,dataValues))

}
