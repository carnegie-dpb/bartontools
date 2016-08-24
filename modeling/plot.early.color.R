##
## plot an example early turnOff gene
##

plot.early = function() {

    rhoc0 = 25
    rhon0 = 1
    nu = 10

    condition = "GR-REV"
    gene = "HAT4"

    gse30703.t = getTimes(schema="gse30703",condition=condition)/60
    gse70796.t = getTimes(schema="gse70796",condition=condition)/60

    gse30703 = getExpression(schema="gse30703",condition=condition,gene=gene)
    gse70796 = getExpression(schema="gse70796",condition=condition,gene=gene)

    gse30703.base = mean(gse30703[gse30703.t==0])
    gse70796.base = mean(gse70796[gse70796.t==0])

    gse30703.fit = transmodel.fit(schema="gse30703",condition=condition,gene=gene,turnOff=0.5, doPlot=F)
    gse70796.fit = transmodel.fit(schema="gse70796",condition=condition,gene=gene,turnOff=0.5, doPlot=F)

    gse30703.rhop0 = gse30703.fit$estimate[1]
    gse30703.etap = gse30703.fit$estimate[2]
    gse30703.gammap = gse30703.fit$estimate[3]

    gse70796.rhop0 = gse70796.fit$estimate[1]
    gse70796.etap = gse70796.fit$estimate[2]
    gse70796.gammap = gse70796.fit$estimate[3]

    t = 0:200/100
    gse30703.model = rhop(rhoc=rhoc0,nu=nu, t=t, rhop0=gse30703.rhop0, etap=gse30703.etap, gammap=gse30703.gammap, turnOff=0.5)
    gse70796.model = rhop(rhoc=rhoc0,nu=nu, t=t, rhop0=gse70796.rhop0, etap=gse70796.etap, gammap=gse70796.gammap, turnOff=0.5)

    plot(t, gse30703.model/gse30703.base, type="l", xlim=c(0,2), log="y", xlab="time (h)", ylab="relative expression", ylim=c(.8,4), col="blue")
    plot.bars(gse30703.t, gse30703/gse30703.base, over=T, pch=19, cex=1.5, bg="blue", col="blue")

    lines(t, gse70796.model/gse70796.base, col="red")
    plot.bars(gse70796.t, gse70796/gse70796.base, over=T, pch=19, cex=1.5, bg="red", col="red")

    ## redo first points to cover bars
    points(t, gse70796.model/gse30703.base, pch=19, cex=1.5, bg="blue", col="blue")
    

    legend(2, 4, xjust=1, yjust=1, pch=19, pt.cex=1.5, col=c("blue","red"), cex=1.2,
           c(
               expression(paste("microarray: ",gamma[p]==0.71," ",h^-1," (",r^2==0.84,"0)")),
               expression(paste("RNA-seq:   ",gamma[p]==0.45," ",h^-1," (",r^2==0.83,")"))
           )
           )

    text(2, .9, expression(paste("GR-REV:",italic("HB-2"))), pos=2, cex=1.5)


}
