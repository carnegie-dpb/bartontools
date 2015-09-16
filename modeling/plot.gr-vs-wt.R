##
## plot out the WT versus condition points for the transgene
##

source("../R/getTimes.R")
source("../R/getExpression.R")

condition = "GR-REV"
tg = "REV"

bl2012.tg.times = getTimes(schema="bl2012", condition=condition)/60
bl2013.tg.times = getTimes(schema="bl2013", condition=condition)/60

bl2012.tg = getExpression(schema="bl2012", condition=condition, gene=tg)
bl2013.tg = getExpression(schema="bl2013", condition=condition, gene=tg)

bl2012.wt.times = getTimes(schema="bl2012", condition="WT")/60
bl2013.wt.times = getTimes(schema="bl2013", condition="WT")/60

bl2012.wt = getExpression(schema="bl2012", condition="WT", gene=tg)
bl2013.wt = getExpression(schema="bl2013", condition="WT", gene=tg)

  
plot(bl2012.wt.times, bl2012.wt, xlab="time (h)", ylab="expression (FPKM, intensity)", log="y", ylim=c(1,10000), pch=21, cex=1.2)
points(bl2012.tg.times, bl2012.tg, pch=22, cex=1.2)

lines(c(0,2), c(mean(bl2012.wt),mean(bl2012.wt)), lty=2, lwd=1.5)
lines(c(0,2), c(mean(bl2012.tg),mean(bl2012.tg)), lty=2, lwd=1.5)

points(bl2013.wt.times, bl2013.wt, pch=21, bg="grey", cex=1.2)
points(bl2013.tg.times, bl2013.tg, pch=22, bg="grey", cex=1.2)

lines(c(0,2), c(mean(bl2013.wt),mean(bl2013.wt)), lty=2, lwd=1.5)
lines(c(0,2), c(mean(bl2013.tg),mean(bl2013.tg)), lty=2, lwd=1.5)


legend(0, 3000, xjust=0, yjust=1, pch=c(22,21), cex=1.2,
       c(
         expression(paste("GR-REV:",italic("REV"),sep="")),
         expression(paste("WT:",italic("REV"),sep=""))
         )
       )

text(0.65, 1700, pos=4, "open = microarray")
text(0.65, 1200, pos=4, "filled = RNA-seq")

## text(1.5, mean(bl2012.wt)*1.2, pos=3, bquote(paste("WT",":",italic(.(tg)),sep="")), cex=1.2)
## text(1.5, mean(bl2012.tg)*1.2, pos=3, bquote(paste(.(condition),":",italic(.(tg)),sep="")), cex=1.2)

## text(1.5, mean(bl2012.wt), pos=3, paste("mean =",round(mean(bl2012.wt),1),"sd =",round(sd(bl2012.wt),1)), cex=1.0)
## text(1.5, mean(bl2012.tg), pos=3, paste("mean =",round(mean(bl2012.tg),1),"sd =",round(sd(bl2012.tg),1)), cex=1.0)

text(1.5, mean(bl2012.wt), pos=3, "ANOVA q=0.17")
text(1.5, mean(bl2012.tg), pos=3, "ANOVA q=0.23")

text(1.5, mean(bl2013.wt), pos=3, "ANOVA q=0.91")
text(1.5, mean(bl2013.tg), pos=3, "ANOVA q=0.97")


