##
## fit nuclear import to a given GR nuclear concentration time course; gamman=0.
##

source("translocation.R")
source("translocation.error.R")

translocation.fit = function(rhoc0, rhon0, nu, gamman, dataTimes, dataValues, dataLabel) {

    ## estimate rhoc0 from data if missing
    if (!hasArg(rhoc0)) rhoc0 = max(dataValues) - rhon0
    
    ## hold rhon0 constant since given by controls
    fit = nlm(iterlim=1000, p=c(rhoc0,nu,gamman), rhon0=rhon0, f=translocation.error, dataTimes=dataTimes, dataValues=dataValues)
    rhoc0 = fit$estimate[1]
    nu = fit$estimate[2]
    gamman = fit$estimate[3]
    
    ## plot it
    translocation(rhoc0=rhoc0, rhon0=rhon0, nu=nu, gamman=gamman, dataTimes=dataTimes, dataValues=dataValues, dataLabel=dataLabel)

    ## return fit
    return(fit)

}


