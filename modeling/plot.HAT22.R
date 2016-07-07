##
## custom plot of HAT22 to show how it would look without turn-off
##

plot.HAT22 = function() {

    ## experimental data
    logFC = c(0,1.53,0.32,0.06)

    times = getTimes(schema="gse30703", condition="GR-REV")/60
    expr = getExpression(schema="gse30703", condition="GR-REV", gene="HAT22")

    t=0:600/100
    
    rhoc0 = 25
    rhon0 = 1
    nu = 10

    rhop0=182
    etap=69.6
    gammap=4.11
                      
    logFCinf = 1.73
    kappa = 95.5
    r2=0.96
                      
    rhop = rhop(t=t, rhoc0=rhoc0, nu=nu, rhop0=rhop0,etap=etap,gammap=gammap, turnOff=0.5)

    rhop.asymptote = rhop(t=t, rhoc0=rhoc0, nu=nu, rhop0=rhop0,etap=etap,gammap=gammap, turnOff=0)

    ## plot

    plot(t, log2(rhop/rhop0), type="l", xlab="time after DEX application (h)", ylab=expression(paste(log[2],"(relative values)")), ylim=c(-0.5,2))
    lines(t[60:120], log2(rhop.asymptote[60:120]/rhop0), lty=3)
    
    points(c(0,0.5,1,2), logFC, pch=19, cex=2, col="red")

    lines(c(0,max(t)), c(logFCinf,logFCinf), lty=2)

    points(times, log2(expr/rhop0), pch=3, cex=2, col="blue")

    y0 = par()$usr[3]
    y1 = par()$usr[4]
    ydelta = y1-y0

    text(max(t), y1-0.20*ydelta, pos=2, expression(paste("GR-REV:",italic(HAT22))), cex=1.2)
    legend(max(t), y1-0.25*ydelta, xjust=1, yjust=1, pch=c(3,19,NA), pt.cex=2, lty=c(NA,NA,1), cex=1.2, col=c("blue","red","black"),
           c(
               "microarray intensity (RMA)",
               "microarray logFC (limma)",
               "model fit"
               )
           )

    text(max(t)*0.7, logFCinf+0.03*ydelta, pos=4, bquote(logFC[infinity]==.(logFCinf)), cex=1.2)
    text(0.1, 0, pos=4, bquote(paste(kappa==.(kappa)," ",h^-2)), cex=1.2)

    text(max(t)*0.8, y0+0.40*ydelta, pos=4, bquote(rho[p0]==.(round(rhop0,1))), cex=1.2)
    text(max(t)*0.8, y0+0.33*ydelta, pos=4, bquote(paste(eta[p]==.(round(etap,2)),h^-1)), cex=1.2)
    text(max(t)*0.8, y0+0.26*ydelta, pos=4, bquote(paste(gamma[p]==.(round(gammap,2)),h^-1)), cex=1.2)
    text(max(t)*0.8, y0+0.17*ydelta, pos=4, bquote(r^2==.(round(r2,2))), cex=1.2)
    
}
