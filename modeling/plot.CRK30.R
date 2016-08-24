##
## custom plot of GR-KAN:CRK30 to show long-time saturation for a down-regulated gene
##

plot.CRK30 = function() {

    ## experimental data
    logFC = c(0,-0.72,-1.93,-2.51)

    times = getTimes(schema="gse70796",condition="GR-KAN")/60
    CRK30 = getExpression(schema="gse70796",condition="GR-KAN",gene="CRK30")

    logFCinf = -3.01
    kappa = -15.2
    
    t = 0:600/100

    rhoc0 = 25
    rhon0 = 1
    nu = 10

    rhop0 =  8.95
    etap =  -0.542
    gammap = 1.73
    r2 = 0.85
    
    rhop = rhop(t=t, rhoc0=rhoc0, nu=nu, rhop0=rhop0, etap=etap, gammap=gammap)

    ## plots

    plot(t, log2(rhop/rhop0), type="l", xlab="time after DEX application (h)", ylab=expression(paste(log[2],"(relative values)")), ylim=c(-3.5,+0.5))
    
    points(c(0,0.5,1,2), logFC, pch=19, cex=2, col="red")

    lines(c(0,max(t)), c(logFCinf,logFCinf), lty=2)

    points(times, log2(CRK30/rhop0), pch=3, cex=2, col="blue")

    y0 = par()$usr[3]
    y1 = par()$usr[4]
    ydelta = y1-y0

    text(max(t), y1-0.05*ydelta, pos=2, expression(paste("GR-KAN:",italic("CRK30"))), cex=1.2)
    legend(max(t), y1-0.10*ydelta, xjust=1, yjust=1, pch=c(3,19,NA), pt.cex=2, lty=c(NA,NA,1), cex=1.2, col=c("blue","red","black"),
           c(
               "RNA-seq FPKM",
               "RNA-seq logFC (Cuffdiff)",
               "model fit"
           )
           )

    text(max(t)*0.8, logFCinf+0.03*ydelta, pos=4, bquote(logFC[infinity]==.(logFCinf)), cex=1.2)
    text(0.1, 0, pos=4, bquote(paste(kappa==.(kappa)," ",h^-2)), cex=1.2)

    text(max(t)*0.8, y0+0.57*ydelta, pos=4, bquote(rho[p0]==.(round(rhop0,1))), cex=1.2)
    text(max(t)*0.8, y0+0.50*ydelta, pos=4, bquote(paste(eta[p]==.(round(etap,2)),h^-1)), cex=1.2)
    text(max(t)*0.8, y0+0.43*ydelta, pos=4, bquote(paste(gamma[p]==.(round(gammap,2)),h^-1)), cex=1.2)
    text(max(t)*0.8, y0+0.36*ydelta, pos=4, bquote(r^2==.(round(r2,2))), cex=1.2)

}
