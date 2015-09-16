## given an input array of genes, generate E, M, L fits as well as pulling the E, M, L DE data values and place them into a big-ass data frame
##
## hardcoded to query limmatimeresults for bl2012, cuffdifftimeresults for bl2013

source("../R/getLimmaTimeResults.R")
source("../R/getCuffdiffTimeResults.R")
source("transmodel.fit.R")

compare.fits = function(schema, condition, genes) {

  df = data.frame(check.rows=T,
    gene=character(), logFC.group=character(), R2.group=character(),
    R2.E=numeric(),R2.M=numeric(),R2.L=numeric(),
    logFC.30=numeric(),logFC.60=numeric(),logFC.120=numeric(),
    p.30=numeric(),p.60=numeric(),p.120=numeric()
    )

  for (i in 1:length(genes)) {
    
    if (schema=="bl2012") {
      res = getLimmaTimeResults(schema=schema, condition=condition, gene=genes[i])
    } else if (schema=="bl2013") {
      res = getCuffdiffTimeResults(schema=schema, condition=condition, gene=genes[i])
    }
    
    if (!is.null(res) && length(res$p_value)==3) {

      if (res$logfc[1]>res$logfc[2] && res$logfc[1]>res$logfc[3]) {
        logFC.group = "E"
      } else if (res$logfc[2]>res$logfc[1] && res$logfc[2]>res$logfc[3]) {
        logFC.group = "M"
      } else {
        logFC.group = "L"
      }

      fit.E = transmodel.fit(schema=schema, condition=condition, gene=genes[i], turnOff=0.5, doPlot=F)
      fit.M = transmodel.fit(schema=schema, condition=condition, gene=genes[i], turnOff=1.0, doPlot=F)
      fit.L = transmodel.fit(schema=schema, condition=condition, gene=genes[i], turnOff=0,   doPlot=F)

      if ( !is.null(fit.E) && !is.null(fit.M) && !is.null(fit.L) && !is.na(fit.E$R2) && !is.na(fit.M$R2) && !is.na(fit.L$R2) ) {

        if (fit.E$R2>fit.M$R2 && fit.E$R2>fit.L$R2) {
          R2.group = "E"
        } else if (fit.M$R2>fit.E$R2 && fit.M$R2>fit.L$R2) {
          R2.group = "M"
        } else {
          R2.group = "L"
        }
        
        if (!is.null(fit.E) && !is.null(fit.M) && !is.null(fit.L)) {
          df = rbind(df,
            data.frame(gene=genes[i], logFC.group=logFC.group, R2.group=R2.group,
                       R2.E=fit.E$R2, R2.M=fit.M$R2, R2.L=fit.L$R2,
                       logFC.30=res$logfc[1], logFC.60=res$logfc[2], logFC.120=res$logfc[3],
                       p.30=res$p_value[1], p.60=res$p_value[2], p.120=res$p_value[3])
            )
          print(quote=F, paste(
                  genes[i], logFC.group, R2.group,
                  round(fit.E$R2,2), round(fit.M$R2,2), round(fit.L$R2,2),
                  round(res$logfc[1],2), round(res$logfc[2],2), round(res$logfc[3],2),
                  round(res$p_value[1],2), round(res$p_value[2],2), round(res$p_value[3],2)
                  )
                )
        }
        
      }
      
    }

  }
    
  return(df)
  
}
