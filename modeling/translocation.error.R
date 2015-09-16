##
## simple model of GR translocation with nu=nuclear import rate, gamman = nuclear loss rate
##

source("rhon.R")
source("errorMetric.R")

translocation.error = function(p, rhon0, dataTimes, dataValues) {
    
    ## fit parameters
    rhoc0 = p[1]
    nu = p[2]
    gamman = p[3]
    
    ## error metric
    fitValues = dataTimes
    for (i in 1:length(dataTimes)) {
        fitValues[i] = rhon(rhoc0=rhoc0, rhon0=rhon0, nu=nu, gamman=gamman, dataTimes[i])
    }

    error = errorMetric(fitValues,dataValues)

    ## steer away from negative rhon0 by cranking up error
    if (rhon0<0) error = error*10
    
    return(error)

}
