##
## dot plot the fit comparison between limma/Cuffdiff p values and model r^2
##
## df = data frame fit numbers from compare.fits.R
## p05 is the q=0.05 value of p for early,middle,late sets

plot.compare.fits = function(df, p05) {

    ymin = 1e-8

    earlies = df$logFC.group=="E" & df$R2.E>0
    middles = df$logFC.group=="M" & df$R2.M>0
    lates   = df$logFC.group=="L" & df$R2.L>0
    
    plot(df$R2.E[earlies], df$p.30[earlies], log="y", ylim=c(ymin,1), pch=19, cex=0.2, col="red",
         xlab=bquote(paste("model fit coefficient of determination ",r^2)), ylab="p-value"
         )
    points(df$R2.M[middles], df$p.60[middles], pch=19, cex=0.2, col="darkgreen")
    points(df$R2.L[lates], df$p.120[lates], pch=19, cex=0.2, col="blue")

    legend(x=0, y=ymin*5, yjust=0, legend=c("Group E","Group M", "Group L"), text.col=c("red","darkgreen","blue"), col=c("red","darkgreen","blue"), pch=19)

    lines(c(0,1), c(p05[1],p05[1]), col="red", lwd=2)
    lines(c(0,1), c(p05[2],p05[2]), col="darkgreen", lwd=2)
    lines(c(0,1), c(p05[3],p05[3]), col="blue", lwd=2)

    lines(c(0.6,0.6), c(ymin,1), col="black", lty="dashed", lwd=2)


    ## count those with r^2>0.6 that have p above/below q=0.05 lines
    n60.early = length(df$R2.E[earlies & df$R2.E>0.6])
    n60.middle = length(df$R2.M[middles & df$R2.M>0.6])
    n60.late = length(df$R2.L[lates & df$R2.L>0.6])

    n60.early.q05 = length(df$R2.E[earlies & df$R2.E>0.6 & df$q.30<0.05])
    n60.middle.q05 = length(df$R2.M[middles & df$R2.M>0.6 & df$q.60<0.05])
    n60.late.q05 = length(df$R2.L[lates & df$R2.L>0.6 & df$q.120<0.05])

    n60.early.q05.frac = n60.early.q05/n60.early
    n60.middle.q05.frac = n60.middle.q05/n60.middle
    n60.late.q05.frac = n60.late.q05/n60.late

    rect(c(0.65,0.77,0.89), 0.015, c(0.75,0.86,0.98), 0.045, col="white", border=NA)
    text(x=c(0.70,0.82,0.94), y=0.025, col=c("red","darkgreen","blue"), cex=1.5, font=1,
         labels=c(
             paste(bquote(.(round((1-n60.early.q05.frac)*100,0))),"%", sep=""),
             paste(bquote(.(round((1-n60.middle.q05.frac)*100,0))),"%", sep=""),
             paste(bquote(.(round((1-n60.late.q05.frac)*100,0))),"%", sep="")
             )
         )

    rect(c(0.65,0.77,0.89), 0.0015, c(0.75,0.86,0.98), 0.0040, col="white", border=NA)
    text(x=c(0.70,0.82,0.94), y=0.0025, col=c("red","darkgreen","blue"), cex=1.5, font=1,
         labels=c(
             paste(bquote(.(round(n60.early.q05.frac*100,0))),"%", sep=""),
             paste(bquote(.(round(n60.middle.q05.frac*100,0))),"%", sep=""),
             paste(bquote(.(round(n60.late.q05.frac*100,0))),"%", sep="")
             )
         )


    ## count those with q<0.05 that have r^2 above/below 0.6
    n05.early = length(df$q.30[earlies & df$q.30<0.05])
    n05.middle = length(df$q.60[middles & df$q.60<0.05])
    n05.late = length(df$q.120[lates & df$q.120<0.05])
    
    n05.early.r60 = length(df$q.30[earlies & df$q.30<0.05 & df$R2.E>0.6])
    n05.middle.r60 = length(df$q.60[middles & df$q.60<0.05 & df$R2.M>0.6])
    n05.late.r60 = length(df$q.120[lates & df$q.120<0.05 & df$R2.L>0.6])

    n05.early.r60.frac = n05.early.r60/n05.early
    n05.middle.r60.frac = n05.middle.r60/n05.middle
    n05.late.r60.frac = n05.late.r60/n05.late


    rect(c(0.65,0.77,0.89), ymin*0.6, c(0.75,0.86,0.98), ymin*1.6, col="white", border=NA)

    text(x=c(0.70,0.82,0.94), y=ymin, col=c("red","darkgreen","blue"), cex=1.5, font=1,
         labels=c(
             paste(bquote(.(round(n05.early.r60.frac*100,0))),"%", sep=""),
             paste(bquote(.(round(n05.middle.r60.frac*100,0))),"%", sep=""),
             paste(bquote(.(round(n05.late.r60.frac*100,0))),"%", sep="")
         )
         )

    
    text(x=c(0.27,0.39,0.51), y=ymin, col=c("red","darkgreen","blue"), cex=1.5, font=1,
         labels=c(
             paste(bquote(.(round((1-n05.early.r60.frac)*100,0))),"%", sep=""),
             paste(bquote(.(round((1-n05.middle.r60.frac)*100,0))),"%", sep=""),
             paste(bquote(.(round((1-n05.late.r60.frac)*100,0))),"%", sep="")
         )
         )

}

    
