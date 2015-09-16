##
## Solve the system of three equations in the ABA-CYP707-HAT22 system
##

require("deSolve")

abasolver = function(
    gamma_aba = 1.0,
    gamma_cyp = 1.0,
    gamma_hat = 1.0,
    eta1 = -1.0,
    eta2 = +2.0,
    eta3 = +1.0,
    eta4 = -1.0,
    D0 = 1.0,
    D1 = 2.0,
    hatThresh = 3.0
    ) {


    ## initial conditions from steady-state solution
    rho_aba0 = D0/(gamma_aba - eta1*eta2/gamma_cyp - eta1*eta3*eta4/(gamma_cyp*gamma_hat))
    rho_hat0 = eta3/gamma_hat*rho_aba0
    rho_cyp0 = (eta2*rho_aba0 + eta4*rho_hat0)/gamma_cyp

    ## initial conditions, steady-state with D0
    state = c(
        rho_aba = rho_aba0,
        rho_cyp = rho_cyp0,
        rho_hat = rho_hat0
        )

    ## drought ABA-drive function
    D = function(t) {
        if (t>0) {
            return(D1)
        } else {
            return(D0)
        }
    }

    ## eta3 HAT22 turn-off function
    eta3t = function(t) {
        if (tOff==0) return(eta3);
        if (t>tOff) {
            return(0)
        } else {
            return(eta3)
        }
    }
    
    ## model parameters with no HAT22 turn-off
    tOff = 0
    parameters = c(
        gamma_aba = gamma_aba,
        gamma_cyp = gamma_cyp,
        gamma_hat = gamma_hat,
        eta1 = eta1,
        eta2 = eta2,
        eta3 = eta3,
        eta4 = eta4,
        D0 = D0,
        D1 = D1,
        tOff = tOff
    )

    ## define the derivatives function
    ABA = function(t, state, parameters) {
        with(as.list(c(state, parameters)),{
            ## rate of change
            drho_aba = D(t) - gamma_aba*rho_aba + eta1*rho_cyp
            drho_cyp =      - gamma_cyp*rho_cyp + eta2*rho_aba + eta4*rho_hat
            drho_hat =      - gamma_hat*rho_hat + eta3t(t)*rho_aba 
            ## return the rate of change
            list(c(drho_aba, drho_cyp, drho_hat))
        })  # end with(as.list ...
    }
    
    ## integrate the model equations over several hours with tOff=0 to determine if/when HAT22 exceeds hatThresh
    times = seq(-5, 20, by = 0.01)
    parameters["tOff"] = 0.0
    out = ode(y=state, times=times, func=ABA, parms=parameters)

    ## check if HAT22 has exceeded hatThresh and, if so, rerun with tOff at that time
    hatMax = max(out[,"rho_hat"]/out[1,"rho_hat"])
    if (hatMax>hatThresh) {
        tOff = min(out[out[,"rho_hat"]/out[1,"rho_hat"]>hatThresh,"time"])
        parameters["tOff"] = tOff
        out = ode(y=state, times=times, func=ABA, parms=parameters)
    }

    ## plot
    plot(out[,"time"], out[,"rho_aba"]/out[1,"rho_aba"], type="l", xlab="time", ylab="relative level", ylim=c(0,5))
    lines(out[,"time"], out[,"rho_cyp"]/out[1,"rho_cyp"], col="green")
    lines(out[,"time"], out[,"rho_hat"]/out[1,"rho_hat"], col="red")

    legend(x=10, y=5, col=c("black","green", "red"), legend=c("ABA", "CYP707", "HAT22"), lty=1)

}

