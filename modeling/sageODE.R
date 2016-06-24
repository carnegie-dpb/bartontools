##
## Solutions to the gamma_n = 0 version of the ODEs by Sage
##

rhocSage = function(t=0:1000/500, rhoc0=10, nu=10) {
    return(exp(-nu*t)*rhoc0)
}

rhonSage = function(t=0:1000/500, rhoc0=10, nu=10, rhon0=1) {
    return(-exp(-nu*t)*rhoc0 + rhoc0 + rhon0)
}

rhopSage = function(t=0:1000/500, rhoc0=10, nu=10, rhon0=1, rhop0=1, etap=2, gammap=3) {
    return(-etap*exp(-nu*t)*rhoc0/(gammap - nu) + etap*(rhoc0 + rhon0)/gammap - (etap*gammap*rhon0 - gammap^2*rhop0 - (etap*(rhoc0 + rhon0) - gammap*rhop0)*nu)*exp(-gammap*t)/(gammap^2 - gammap*nu))
}

rhosSage = function(t=0:1000/500, rhoc0=10, nu=10, rhon0=1, rhop0=1, etap=2, gammap=3, rhos0=1, etas=2, gammas=3) {
    return(-etap*etas*exp(-nu*t)*rhoc0/(gammap*gammas - (gammap + gammas)*nu + nu^2) + etap*etas*(rhoc0 + rhon0)/(gammap*gammas) + (etap*etas*gammap*rhon0 - etas*gammap^2*rhop0 - (etap*etas*(rhoc0 + rhon0) - etas*gammap*rhop0)*nu)*exp(-gammap*t)/(gammap^3 - gammap^2*gammas - (gammap^2 - gammap*gammas)*nu) - (etap*etas*gammas*rhon0 + gammas^3*rhos0 - (etas*rhop0 + gammap*rhos0)*gammas^2 - (etap*etas*(rhoc0 + rhon0) + gammas^2*rhos0 - (etas*rhop0 + gammap*rhos0)*gammas)*nu)*exp(-gammas*t)/(gammap*gammas^2 - gammas^3 - (gammap*gammas - gammas^2)*nu))
}
