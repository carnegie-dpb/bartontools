## custom plot of ZPR1 to show long-time saturation

plot.ZPR1 = function() {

    ## experimental data
    logFC = c(0,2.09,3.29,3.71)

    times = getTimes(schema="gse30703",condition="GR-REV")/60
    ZPR1 = getExpression(schema="gse30703",condition="GR-REV",gene="ZPR1")

    logFCinf = 4.56
    kappa = 190

    t = 0:600/100

    rhoc0 = 25
    rhon0 = 1
    nu = 10
    
    rhop0 = 59.2
    etap = 45.0
    gammap = 0.84
    r2 = 0.96
    
    rhop = rhop(t=t, rhoc0=rhoc0, nu=nu, rhop0=rhop0, etap=etap, gammap=gammap)

    plot(t, log2(rhop/rhop0), type="l", xlab="time (h)", ylab=expression(paste(log[2],"(relative values)")), ylim=c(-0.5,5))

    points(c(0,0.5,1,2), logFC, pch=21, cex=1.5, bg="lightgray")

    lines(c(0,max(t)), c(logFCinf,logFCinf), lty=2)

    points(times, log2(ZPR1/rhop0), pch=3, cex=1.5)

    y0 = par()$usr[3]
    y1 = par()$usr[4]
    ydelta = y1-y0

    text(max(t), y1-0.20*ydelta, pos=2, expression(paste("GR-REV:",italic("ZPR1"))), cex=1.2)
    legend(max(t), y1-0.25*ydelta, xjust=1, yjust=1, pch=c(3,21,NA), pt.cex=c(1.5,1.5), pt.bg="lightgray", lty=c(NA,NA,1), cex=1.2,
           c(
               "microarray intensity (RMA)",
               "microarray logFC (limma)",
               "model fit"
           )
           )

    
    text(max(t)*0.8, logFCinf+0.03*ydelta, pos=4, bquote(logFC[infinity]==.(logFCinf)), cex=1.2)
    text(0.1, 0, pos=4, bquote(paste(kappa==.(kappa)," ",h^-2)), cex=1.2)

    text(max(t)*0.8, y0+0.40*ydelta, pos=4, bquote(rho[p0]==.(round(rhop0,1))), cex=1.2)
    text(max(t)*0.8, y0+0.33*ydelta, pos=4, bquote(paste(eta[p]==.(round(etap,2))," ",h^-1)), cex=1.2)
    text(max(t)*0.8, y0+0.26*ydelta, pos=4, bquote(paste(gamma[p]==.(round(gammap,2))," ",h^-1)), cex=1.2)
    text(max(t)*0.8, y0+0.19*ydelta, pos=4, bquote(r^2==.(round(r2,2))), cex=1.2)

}
