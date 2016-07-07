##
## Model the Yoshikawa, Robertson and Hache data with the ODE import model
##

source("rhon.R")

## parameters

yosh = read.table("yoshikawa-Dex.txt")
yosh$time = yosh$time/60

robertson = read.table("robertson-gr.txt")
robertson$time = robertson$time/60

hache = read.table("hache.txt")
hache$time = hache$time/60

rhoc0 = c(87.6, 89.2, 87.2, 92.0, 83.2)
rhon0 = c(5.4, 2.1, 12.6, 7.0, 16.7)
nu = c(12.1, 72.2, 4.53, 6.92, 5.51)

plot(robertson$time, robertson$Dex1uM, pch=19, cex=1.5, xlim=c(0,2), ylim=c(0,100), ylab="nuclear GR fraction (%)", xlab="time after DEX application (h)", main="", col="blue")

points(hache$time, hache$Dex1uM, pch=15, cex=1.5, col="red")

points(yosh$time, yosh$Dex1nM, pch=4, cex=1.5, col="darkgreen")
points(yosh$time, yosh$Dex10nM, pch=1, cex=1.5, col="darkgreen")
points(yosh$time, yosh$Dex100nM, pch=2, cex=1.5, col="darkgreen")
points(yosh$time, yosh$Dex1uM,  pch=5, cex=1.5, col="darkgreen")

## calculation interval
t = (0:200)/100

## numerical solution
rhon1 = rhon(rhoc0=rhoc0[1], rhon0=rhon0[1], nu=nu[1], t=t/2)
rhon2 = rhon(rhoc0=rhoc0[2], rhon0=rhon0[2], nu=nu[2], t=t)
rhon3 = rhon(rhoc0=rhoc0[3], rhon0=rhon0[3], nu=nu[3], t=t)
rhon4 = rhon(rhoc0=rhoc0[4], rhon0=rhon0[4], nu=nu[4], t=t)
rhon5 = rhon(rhoc0=rhoc0[5], rhon0=rhon0[5], nu=nu[5], t=t)

## plot 'em
lines(t/2, rhon1, lty=1, lwd=1.5, col="blue")

lines(t, rhon2, lty=1, lwd=1.5, col="red")

lines(t, rhon3, lty=3, lwd=1.5, col="darkgreen")
lines(t, rhon4, lty=4, lwd=1.5, col="darkgreen")
lines(t, rhon5, lty=6, lwd=1.5, col="darkgreen")

legend(max(t), 0, xjust=1, yjust=0, pch=c(NA,19,15,5,2,1,4), col=c("","blue","red","darkgreen","darkgreen","darkgreen","darkgreen"), lty=c(0,1,1,3,4,6,0), pt.cex=1.5, lwd=1.5,
       c(
         expression(paste("               DEX","  ",nu," ",(h^-1))),
         expression("Rob.       1 \u{B5}M   12.1"),
         expression("Hach\u{E9}    1 \u{B5}M   72.2"),
         expression("Yosh.      1 \u{B5}M     4.5"),
         expression("Yosh.  100 nM     6.9"),
         expression("Yosh.    10 nM     5.5"),
         expression("Yosh.      1 nM")
         )
       )

## get sum squared deviations, show it on graph

## sumsq1 = 0
## sumsq2 = 0
## sumsq3 = 0
## sumsq4 = 0
## for (i in 1:length(yosh$time)) {
##   sumsq1 = sumsq1 + (approx(t,rhon1,yosh$time[i])$y - yosh$Dex1nM[i])^2
##   sumsq2 = sumsq2 + (approx(t,rhon2,yosh$time[i])$y - yosh$Dex10nM[i])^2
##   sumsq3 = sumsq3 + (approx(t,rhon3,yosh$time[i])$y - yosh$Dex100nM[i])^2
##   sumsq4 = sumsq4 + (approx(t,rhon4,yosh$time[i])$y - yosh$Dex1uM[i])^2
## }

## text(2, 5, paste("Dex1nM: gammaeff=",gammaeff[1], "sumsq=",signif(sumsq1,4)), col="red", pos=2)
## text(2, 10, paste("Dex10nM: gammaeff=",gammaeff[2],"sumsq=",signif(sumsq2,4)), col="green", pos=2)
## text(2, 15, paste("Dex100nM: gammaeff=",gammaeff[3],"sumsq=",signif(sumsq3,4)), col="blue", pos=2)
## text(2, 20, paste("Dex1uM: gammaeff=",gammaeff[4],"sumsq=",signif(sumsq4,4)), col="orange", pos=2)
## text(2, 0, paste("Total sumsq=",signif(sumsq1+sumsq2+sumsq3+sumsq4,4)), col="black", pos=2)

