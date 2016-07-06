##
## plot out some example genes
##

source("~/R/getExpression.R")
source("~/R/getTimes.R")
source("transmodel.fit.R")
source("sampleAverage.R")

example.genes = function(schema1="bl2013",condition1="GR-REV",gene1="At5g03995", schema2="bl2013",condition2="GR-REV",gene2="At5g47370", rhon0=1,rhoc0=26,nu=10,gamman=1, doFit=TRUE) {

  t1 = getTimes(schema1, condition1)
  t2 = getTimes(schema2, condition2)
  
  tl = c(0,30,60,120)
  
  expr1 = getExpression(schema1, condition1, gene1)
  expr2 = getExpression(schema2, condition2, gene2)

  oldpar = par(mar=c(4, 4, 0.5, 1), mgp=c(2.5,1,0))

  if (doFit) {

    ## plot data
    plot(t1/60, expr1, xlab="time (h)", ylab="expression, nuclear concentration", ylim=c(0,max(expr1,expr2)), pch=0, cex=1.2)
    points(t2/60, expr2, pch=1, cex=1.2)

    ## do the fit
    t = (0:200)/100
    fit1 = transmodel.fit(schema=schema1,condition=condition1,gene=gene1,nu=nu,gamman=gamman,doPlot=FALSE)
    rhop10 = fit1$estimate[1]
    etap1 = fit1$estimate[2]
    gammap1 = fit1$estimate[3]
    fit2 = transmodel.fit(schema=schema2,condition=condition2,gene=gene2,nu=nu,gamman=gamman,doPlot=FALSE)
    rhop20 = fit2$estimate[1]
    etap2 = fit2$estimate[2]
    gammap2 = fit2$estimate[3]
    
    rhop1 = rhop(rhoc0, nu, gamman, rhop10, etap1, gammap1, t)
    rhop2 = rhop(rhoc0, nu, gamman, rhop20, etap2, gammap2, t)
    
    lines(t, rhop1, lty=2)
    lines(t, rhop2, lty=3)
    
    legend(1.0, 0.5, xjust=0, yjust=0, pch=c(NA,NA,NA,0,1), lty=c(NA,2,3,NA,NA), cex=1.1,
           c(
             expression(paste("       ",eta[p],"      ",gamma[p])),
             bquote(paste(rho[p],"  ",.(signif(etap1,3)),"   ",.(signif(gammap1,3)))),
             bquote(paste(rho[p],"  ",.(signif(etap2,3)),"   ",.(signif(gammap2,3)))),
             paste(condition1,":",gene1,sep=""),
             paste(condition2,":",gene2,sep="")
             )
           )
    
    text(0.6, 0.20*par()$yaxp[2], pos=4, cex=1.1, bquote(rho[c0]==.(rhoc0)))
    text(0.6, 0.15*par()$yaxp[2], pos=4, cex=1.1, bquote(rho[n0]==.(rhon0)))
    text(0.6, 0.10*par()$yaxp[2], pos=4, cex=1.1, bquote(paste(nu==.(nu),h^-1)))
    text(0.6, 0.05*par()$yaxp[2], pos=4, cex=1.1, bquote(paste(gamma[n]==.(gamman),h^-1)))

  } else {

    ## plot data
    plot(t1/60, expr1, xlab="time (h)", ylab="expression", ylim=c(min(expr1,expr2),max(expr1,expr2)), log="y", pch=0, cex=1.2)
    points(t2/60, expr2, pch=1, cex=1.2)

    ## draw lines between sample averages
    avg1 = sampleAverage(expr1, t1)
    avg2 = sampleAverage(expr2, t2)
    lines(c(0,30,60,120)/60, avg1, lty=2)
    lines(c(0,30,60,120)/60, avg2, lty=2)

    legend(1.1, min(expr1,expr2), xjust=0, yjust=0, pch=c(0,1), cex=1.1,
           c(
             paste(condition1,":",gene1,sep=""),
             paste(condition2,":",gene2,sep="")
             )
           )

  }

  par(oldpar)

}


