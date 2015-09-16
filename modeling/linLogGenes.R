##
## scan through all the genes with expression and fit a linear line to the log2 values, saving those with low p
##

library("RPostgreSQL")

source("~/R/getAllIDs.R")
source("~/R/getTimes.R")
source("~/R/getExpression.R")
source("~/R/getName.R")

linLogGenes = function(schema) {

    ids = getAllIDs(schema)
    times = getTimes(schema)
    winners = {}

    for (i in 1:length(ids)) {

        values = log2(getExpression(schema=schema, gene=ids[i]))
        lm.out = lm(values~times, data.frame(times,values))
        coeffs = coef(summary(lm.out))
        intercept = coeffs[1]
        slope = coeffs[2]
        p = coeffs[8]

        if (p<1e-6 && slope>0.1) {
            name = getName(ids[i])
            winners = c(winners,name)
            plot(times, values, main=paste(ids[i],name,signif(p,3)), xlab="days", ylab="log2(expression)", ylim=c(5,20))
            lines(times, intercept+slope*times)
        }

    }

    return(winners)
        
}
