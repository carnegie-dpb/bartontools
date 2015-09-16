##
## overplot a modeled turn-off time course along with the appropriate expression data
##

source("rhop.R")

source("../R/getTimes.R")
source("../R/getExpression.R")
source("../R/plot.bars.R")

rhoc0 = 19
rhon0 = 1
nu = 10
gamman = 0

t.12 = getTimes(schema="bl2012",condition="GR-REV")/60
t.13 = getTimes(schema="bl2013",condition="GR-REV")/60

expr.12 = getExpression(schema="bl2012",condition="GR-REV",gene="At4g16780")
expr.13 = getExpression(schema="bl2013",condition="GR-REV",gene="At4g16780")

t = 0:200/100

rhop0.12 = 138.356340
etap.12 = 57.399539
gammap.12 = 2.041664

rhop0.13 = 5.649396
etap.13 = 1.626734 
gammap.13 = 0.952082

turnoff.12 = rhop(rhoc0=rhoc0,nu=nu,,gamman=gamman,t=t,  rhop0=rhop0.12,etap=etap.12,gammap=gammap.12, turnOff=0.5)
turnoff.13 = rhop(rhoc0=rhoc0,nu=nu,gamman=gamman,t=t,  rhop0=rhop0.13,etap=etap.13,gammap=gammap.13, turnOff=0.5)

steady.12 = rhop(rhoc0=rhoc0,nu=nu,gamman=gamman,t=t,  rhop0=rhop0.12,etap=etap.12,gammap=gammap.12, turnOff=0)
steady.13 = rhop(rhoc0=rhoc0,nu=nu,gamman=gamman,t=t,  rhop0=rhop0.13,etap=etap.13,gammap=gammap.13, turnOff=0)

plot(t, turnoff.12/mean(expr.12[1:3]), type="l", xlim=c(0,2), ylim=c(.8,6), log="y", xlab="time (h)", ylab="relative expression")
lines(t, turnoff.13/mean(expr.13[1:3]))

lines(t, steady.12/mean(expr.12[1:3]), lty=2)
lines(t, steady.13/mean(expr.13[1:3]), lty=2)

plot.bars(t.12, expr.12/mean(expr.12[1:3]), over=T, pch=21, bg="white", cex=1.2)
plot.bars(t.13, expr.13/mean(expr.13[1:3]), over=T, pch=22, bg="white", cex=1.2)

legend(2, .8, xjust=1, yjust=0, pch=c(21,22), pt.bg=c("white","white"), cex=1.2,
       c(
         expression(paste("GR-REV:",italic("HB-2")," microarray")),
         expression(paste("GR-REV:",italic("HB-2")," RNA-seq"))
         )
       )

text(1.2, 2.1, pos=4, expression(paste(gamma[p]==0.95," ",h^-1,"  ",r^2==0.84)))
text(1.2, 1.2, pos=4, expression(paste(gamma[p]==2.04," ",h^-1,"  ",r^2==0.90)))

text(2, 10^(0.80*par()$usr[4]), bquote(rho[c0]==.(round(rhoc0,1))), pos=2, cex=1.0)
text(2, 10^(0.75*par()$usr[4]), bquote(rho[n0]==.(round(rhon0,1))), pos=2, cex=1.0)
text(2, 10^(0.70*par()$usr[4]), bquote(paste(nu==.(signif(nu,3))," ",h^-1)), pos=2, cex=1.0)
text(2, 10^(0.65*par()$usr[4]), bquote(paste(gamma[n]==.(signif(gamman,3))," ",h^-1)), pos=2, cex=1.0)


