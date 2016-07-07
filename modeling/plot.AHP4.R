## plot the various transmodel2 fits for At5g28300 and AHP4


source("transmodel.fit.R")
source("transmodel2.fit.R")
source("rhop.R")
source("rhos.R")

source("~/R/getExpression.R")
source("~/R/getTimes.R")
source("~/R/plot.bars.R")

plot.AHP4 = function(schema, condition, ylim) {

    if (schema=="gse30703") {
        assay = "microarray"
        units = "CEL intensity"
    }
    if (schema=="gse70796") {
        assay = "RNA-seq"
        units = "FPKM"
    }
    
    pri = c("CRK22", "JKD", "At5g28300")
    prisymbols = c("CRK22", "JKD", "GT2L")
    sec = "AHP4"

    rhoc0 = 25
    rhon0 = 1
    nu = 10

    tdata = getTimes(schema=schema, condition=condition)/60
    pri1data = getExpression(schema=schema,condition=condition,gene=pri[1])
    pri2data = getExpression(schema=schema,condition=condition,gene=pri[2])
    pri3data = getExpression(schema=schema,condition=condition,gene=pri[3])
    secdata = getExpression(schema=schema,condition=condition,gene=sec)

    fitp1 = transmodel.fit(doPlot=F, rhoc0=rhoc0,nu=nu, schema=schema, condition=condition, gene=pri[1])
    fitp2 = transmodel.fit(doPlot=F, rhoc0=rhoc0,nu=nu, schema=schema, condition=condition, gene=pri[2])
    fitp3 = transmodel.fit(doPlot=F, rhoc0=rhoc0,nu=nu, schema=schema, condition=condition, gene=pri[3])

    fits1 = transmodel2.fit(doPlot=F, rhoc0=rhoc0,nu=nu, schema=schema, condition=condition, gene1=pri[1], gene2=sec)
    fits2 = transmodel2.fit(doPlot=F, rhoc0=rhoc0,nu=nu, schema=schema, condition=condition, gene1=pri[2], gene2=sec)
    fits3 = transmodel2.fit(doPlot=F, rhoc0=rhoc0,nu=nu, schema=schema, condition=condition, gene1=pri[3], gene2=sec)

    rhop0 =  c(fitp1$estimate[1],fitp2$estimate[1],fitp3$estimate[1])
    etap =   c(fitp1$estimate[2],fitp2$estimate[2],fitp3$estimate[2])
    gammap = c(fitp1$estimate[3],fitp2$estimate[3],fitp3$estimate[3])

    rhos0 =  c(fits1$estimate[1],fits2$estimate[1],fits3$estimate[1])
    etas =   c(fits1$estimate[2],fits2$estimate[2],fits3$estimate[2])
    gammas = c(fits1$estimate[3],fits2$estimate[3],fits3$estimate[3])

    t = 0:200/100

    rhop1 = rhop(t=t, rhoc0=rhoc0,nu=nu, rhop0=rhop0[1], etap=etap[1], gammap=gammap[1])
    rhop2 = rhop(t=t, rhoc0=rhoc0,nu=nu, rhop0=rhop0[2], etap=etap[2], gammap=gammap[2])
    rhop3 = rhop(t=t, rhoc0=rhoc0,nu=nu, rhop0=rhop0[3], etap=etap[3], gammap=gammap[3])
    
    rhos1 = rhos(t=t, rhoc0=rhoc0,nu=nu, etap=etap[1],gammap=gammap[1], rhos0=rhos0[1],etas=etas[1],gammas=gammas[1])
    rhos2 = rhos(t=t, rhoc0=rhoc0,nu=nu, etap=etap[2],gammap=gammap[2], rhos0=rhos0[2],etas=etas[2],gammas=gammas[2])
    rhos3 = rhos(t=t, rhoc0=rhoc0,nu=nu, etap=etap[3],gammap=gammap[3], rhos0=rhos0[3],etas=etas[3],gammas=gammas[3])

    ## commence plots!

    plot(t,  rhop1, type="l", log="y", ylim=ylim, xlab="time after DEX application (h)", ylab=paste(units,", model nuclear concentration",sep=""), lty=1, lwd=2, col="red")
    lines(t, rhop2, col="red", lty=1, lwd=2)
    lines(t, rhop3, col="red", lty=1, lwd=2)

    plot.bars(tdata, pri1data, over=T, col="red", bg="red", pch=21, cex=1.5)
    plot.bars(tdata, pri2data, over=T, col="red", bg="red", pch=22, cex=1.5)
    plot.bars(tdata, pri3data, over=T, col="red", bg="red", pch=23, cex=1.5)

    lines(t, rhos1, col="darkgreen", lty=1, lwd=2)
    lines(t, rhos2, col="darkgreen", lty=1, lwd=2)
    lines(t, rhos3, col="darkgreen", lty=1, lwd=2)

    plot.bars(tdata, secdata, over=T, col="darkgreen", bg="darkgreen", pch=24, cex=1.5)


    legend(0, ylim[1], yjust=0, pch=21:24, lty=1, pt.cex=1.5, col=c("red","red","red","darkgreen"), pt.bg=c("red","red","red","darkgreen"),
           c(
               as.expression(bquote(paste(.(prisymbols[1])," ",gamma[p]==.(round(gammap[1],1))," ",eta[s]==.(round(etas[1],1))," ",gamma[s]==.(round(gammas[1],1))))),
               as.expression(bquote(paste(.(prisymbols[2]),"      ",gamma[p]==.(round(gammap[2],1))," ",eta[s]==.(round(etas[2],1))," ",gamma[s]==.(round(gammas[2],1))))),
               as.expression(bquote(paste(.(prisymbols[3]),"    ",gamma[p]==.(round(gammap[3],1))," ",eta[s]==.(round(etas[3],1))," ",gamma[s]==.(round(gammas[3],1))))),
               sec
           )
           )


}
