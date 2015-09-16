##
## killer plot for Kathy's grant aim
##

source("../R/getExpression.R")
source("../R/getTimes.R")
source("../R/plot.bars.R")

source("rhon.R")
source("rhop.R")

rhoc0 = 20
rhon0 = 1
nu = 10
gamman = 0.825

schema = "bl2012"
condition = "GR-REV"

gene1 = "HB-2"
gene2 = "TAA1"
gene3 = "AHP4"

times = getTimes(schema, condition)/60

expr1 = getExpression(schema, condition, gene1)
expr2 = getExpression(schema, condition, gene2)
expr3 = getExpression(schema, condition, gene3)

t = (0:200)/100

rhop1a = rhop(turnOff=0.1, rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman, rhop0=138.4, etap=879, gammap=2.04, t=t)
rhop1b = rhop(turnOff=0.2, rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman, rhop0=138.4, etap=271, gammap=2.04, t=t)
rhop1c = rhop(turnOff=0.3, rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman, rhop0=138.4, etap=140, gammap=2.04, t=t)
rhop1d = rhop(turnOff=0.4, rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman, rhop0=138.4, etap=88.2, gammap=2.04, t=t)
rhop1e = rhop(turnOff=0.5, rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman, rhop0=138.4, etap=61.7, gammap=2.04, t=t)

rhop2 = rhop(turnOff=0, rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman, rhop0=133.376, etap=39.494, gammap=2.136, t=t)
rhop3 = rhop(turnOff=0, rhoc0=rhoc0,rhon0=rhon0,nu=nu,gamman=gamman, rhop0=29.736, etap=1.633, gammap=-0.848, t=t)


plot.bars(times, expr1, pch=21, over=F, cex=1.2, col="red", bg="red",
          log="y", ylim=c(1,1000), xlab="time (h)", ylab="expression (microarray); modeled nuclear concentrations")
plot.bars(times, expr2, pch=21, over=T, cex=1.2, col="blue", bg="blue")
plot.bars(times, expr3, pch=21, over=T, cex=1.2, col="green", bg="green")

lines(t, rhop1a, col="red", lty=2)
lines(t, rhop1b, col="red", lty=2)
lines(t, rhop1c, col="red", lty=2)
lines(t, rhop1d, col="red", lty=2)
lines(t, rhop1e, col="red", lty=2)
lines(t, rhop2, col="blue")
lines(t, rhop3, col="green")
lines(t, rhon(rhoc0=rhoc0, rhon0=rhon0, nu=nu, gamman=gamman, t=t))

legend(1, 1, yjust=0, pch=c(NA,21,21,21), lty=c(1,NA,NA,NA), cex=1.2, col=c("black","red","blue","green"), pt.bg=c(NA,"red","blue","green"), c("GR-REV (nucleus)",gene1,gene2,gene3))

