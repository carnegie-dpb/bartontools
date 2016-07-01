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

    
    gse30703.fit = transmodel.fit(schema="gse30703", condition=condition, gene=gene, turnOff=0.5, doPlot=F)
    gse70796.fit = transmodel.fit(schema="gse70796", condition=condition, gene=gene, turnOff=0.5, doPlot=F)

    gse30703.rhop0 = gse30703.fit$estimate[1]
    gse30703.etap = gse30703.fit$estimate[2]
    gse30703.gammap = gse30703.fit$estimate[3]

    gse70796.rhop0 = gse70796.fit$estimate[1]
    gse70796.etap = gse70796.fit$estimate[2]
    gse70796.gammap = gse70796.fit$estimate[3]

    print(paste("gse30703: rhop0=",gse30703.rhop0," etap=",gse30703.etap," gammap=",gse30703.gammap))
    print(paste("gse70796: rhop0=",gse70796.rhop0," etap=",gse70796.etap," gammap=",gse70796.gammap))


    t = 0:200/100
    gse30703.model = rhop(rhoc=rhoc0,nu=nu, t=t, rhop0=gse30703.rhop0, etap=gse30703.etap, gammap=gse30703.gammap, turnOff=0.5)
    gse70796.model = rhop(rhoc=rhoc0,nu=nu, t=t, rhop0=gse70796.rhop0, etap=gse70796.etap, gammap=gse70796.gammap, turnOff=0.5)

    plot(t, gse30703.model/gse30703.base, type="l", xlim=c(0,2), log="y", xlab="time (h)", ylab="relative expression", ylim=c(.8,4))
    plot.bars(gse30703.t, gse30703/gse30703.base, over=T, pch=21, cex=1.5, bg="grey")

    lines(t, gse70796.model/gse70796.base)
    plot.bars(gse70796.t, gse70796/gse70796.base, over=T, pch=22, cex=1.5, bg="grey")

    legend(2.05, 4, xjust=1, yjust=1, pch=21:22, pt.cex=1.5, pt.bg="grey", cex=1.2,
           c(
               expression(paste("microarray: ",gamma[p]==2.04," ",h^-1," (",r^2==0.9,"0)")),
               expression(paste("RNA-seq:   ",gamma[p]==0.95," ",h^-1," (",r^2==0.84,")"))
           )
           )

    text(2, .9, expression(paste("GR-REV:",italic("HAT4"))), pos=2, cex=1.5)


}
