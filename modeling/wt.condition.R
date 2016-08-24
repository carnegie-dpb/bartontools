##
## plot out the WT versus condition points for the transgene
##

source("~/R/getTimes.R")
source("~/R/getExpression.R")

wt.condition = function(schema="bl2013", condition="GR-REV") {

  if (condition=="GR-AS2") transgene = "AS2"
  if (condition=="GR-KAN") transgene = "KAN"
  if (condition=="GR-REV") transgene = "REV"
  if (condition=="GR-STM") transgene = "STM"
  
  cond.times = getTimes(schema=schema, condition=condition)/60
  cond.expr = getExpression(schema=schema, condition=condition, gene=transgene)
  
  wt.times = getTimes(schema=schema, condition="WT")/60
  wt.expr = getExpression(schema=schema, condition="WT", gene=transgene)
  
  plot(wt.times, wt.expr, xlab="time (h)", ylab="expression (FPKM)", log="y", ylim=c(min(wt.expr),max(cond.expr)), pch=1, cex=1.2)
  points(cond.times, cond.expr, pch=0, cex=1.2)
  
  lines(c(0,2), c(mean(wt.expr),mean(wt.expr)), lty=2, lwd=1.5)
  lines(c(0,2), c(mean(cond.expr),mean(cond.expr)), lty=2, lwd=1.5)

##  legend(2, 10^mean(par()$usr[3:4]), xjust=1, yjust=1, pch=c(1,0), c(paste("WT:",transgene,sep=""),paste(condition,":",transgene,sep="")), cex=1.2)

  text(1.5, mean(wt.expr)*1.2, pos=3, bquote(paste("WT",":",italic(.(transgene)),sep="")), cex=1.2)
  text(1.5, mean(cond.expr)*1.2, pos=3, bquote(paste(.(condition),":",italic(.(transgene)),sep="")), cex=1.2)
  
  text(1.5, mean(wt.expr), pos=3, paste("mean =",round(mean(wt.expr),1),"sd =",round(sd(wt.expr),1)), cex=1.0)
  text(1.5, mean(cond.expr), pos=3, paste("mean =",round(mean(cond.expr),1),"sd =",round(sd(cond.expr),1)), cex=1.0)

  text(1.5, mean(wt.expr)*0.8, pos=3, "ANOVA p=0.28")
  text(1.5, mean(cond.expr)*0.8, pos=3, "ANOVA p=0.83")
  
}
