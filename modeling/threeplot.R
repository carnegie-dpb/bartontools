##
## plot three genes and fits
##

source("~/R/getTimes.R")
source("~/R/getExpression.R")
source("rhon.R")
source("rhop.R")

condition = "GR-REV"

times2012 = getTimes(schema="bl2012", condition=condition)/60
times2013 = getTimes(schema="bl2013", condition=condition)/60

## chosen gene data
gene = c("At4g37790","At5g06710","At5g43810")
geneName = c("HAT22","HAT14","ZLL")

rhop02012 = c(128.42,33.58,190.98)
etap2012 = c(14100,0.0956,0.0779)*rhop02012
gammap2012 = c(75300,0.676,0.0507)

rhop02013 = c(6.57,1.04,2.96)
etap2013 = c(3.39,0.388,0.0488)*rhop02013
gammap2013 = c(38.3,0.956,0.185)

## expression data
expr2012 = c(
  getExpression(schema="bl2012", condition=condition, gene=gene[1]),
  getExpression(schema="bl2012", condition=condition, gene=gene[2]),
  getExpression(schema="bl2012", condition=condition, gene=gene[3])
  )
dim(expr2012) = c(length(times2012),3)

expr2013 = c(
  getExpression(schema="bl2013", condition=condition, gene=gene[1]),
  getExpression(schema="bl2013", condition=condition, gene=gene[2]),
  getExpression(schema="bl2013", condition=condition, gene=gene[3])
  )
dim(expr2013) = c(length(times2013),3)

## static fit parameters
rhon0 = 1
rhoc0 = 20
nu = 10
gamman = 1.5
t = (0:200)/100

oldpar = par(mfrow=c(3,1), mar=c(3.5,3.5,0.5,0.5), mgp=c(2,1,0))


## TF concentration on top plot
plot(t, rhon(rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman,t=t), type="l", xlab="", ylab="model GR-TF concentration", log="y", lty=1)

text(0, 10^par()$usr[4], pos=1, "(a)", cex=1.5)

text(par()$xaxp[2], 1.00*par()$yaxp[2], bquote(rho[c0]==.(round(rhoc0,1))), pos=2, cex=1.5)
text(par()$xaxp[2], 0.794*par()$yaxp[2], bquote(rho[n0]==.(round(rhon0,1))), pos=2, cex=1.5)
text(par()$xaxp[2], 0.631*par()$yaxp[2], bquote(nu==.(signif(nu,3))), pos=2, cex=1.5)
text(par()$xaxp[2], 0.501*par()$yaxp[2], bquote(gamma[n]==.(signif(gamman,3))), pos=2, cex=1.5)

## 2012 on next plot
plot(t, rhop(rhoc0=rhoc0,nu=nu,gamman=gamman,rhop0=rhop02012[1],etap=etap2012[1],gammap=gammap2012[1],t=t), log="y", lty=2, type="l", xlab="", ylab="intensity, model target concentration",
     ylim=c(min(expr2012),max(expr2012)))
points(times2012, expr2012[,1], pch=0, cex=1.5)
for (i in 2:3) {
lines(t, rhop(rhoc0=rhoc0, nu=nu, gamman=gamman, rhop0=rhop02012[i], etap=etap2012[i], gammap=gammap2012[i], t=t), lty=i+1)
points(times2012, expr2012[,i], pch=i-1, cex=1.5)
}
text(0, 10^par()$usr[4], pos=1, "(b)", cex=1.5)
legend(1.9, min(expr2012), xjust=1, yjust=0, paste(condition,":",geneName), lty=2:4, pch=0:2, cex=1.5)

## 2013 on last plot
plot(t, rhop(rhoc0=rhoc0,nu=nu,gamman=gamman,rhop0=rhop02013[1],etap=etap2013[1],gammap=gammap2013[1],t=t), log="y", lty=2, type="l", xlab="time (h)", ylab="FPKM, model target concentration",
     ylim=c(min(expr2013),max(expr2013)))
points(times2013, expr2013[,1], pch=0, cex=1.5)
for (i in 2:3) {
lines(t, rhop(rhoc0=rhoc0, nu=nu, gamman=gamman, rhop0=rhop02013[i], etap=etap2013[i], gammap=gammap2013[i], t=t), lty=i+1)
points(times2013, expr2013[,i], pch=i-1, cex=1.5)
}
text(0, 10^par()$usr[4], pos=1, "(c)", cex=1.5)
legend(1.9, min(expr2013), xjust=1, yjust=0, paste(condition,":",geneName), lty=2:4, pch=0:2, cex=1.5)

par(oldpar)




