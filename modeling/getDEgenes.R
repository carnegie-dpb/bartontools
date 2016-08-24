##
## return a data frame containing  genes exhibit significant DE for the given schema and condition, based on limma or Cuffdiff q values
##

source("~/R/getAllIDs.R")
source("~/R/getExpression.R")
source("~/R/getSymbol.R")
source("~/R/getLimmaTimeResults.R")
source("~/R/getCuffdiffTimeResults.R")

getDEgenes = function(schema="gse70796", condition="WT", qmax=0.05, logFCmin=0.5) {

    microarray = "gse30703"
    rnaseq = "gse70796"

    genes = getAllIDs(schema)

    df = data.frame(check.rows=T,
                    gene=character(), symbol=character(), WT.mean=numeric(), WT.sd=numeric(),
                    logFC.30=numeric(),logFC.60=numeric(),logFC.120=numeric(),
                    p.30=numeric(),p.60=numeric(),p.120=numeric(),
                    q.30=numeric(),q.60=numeric(),q.120=numeric()
                    )

    for (i in 1:length(genes)) {

        if (schema==microarray) {
            res = getLimmaTimeResults(schema=schema, condition=condition, gene=genes[i])
        } else if (schema==rnaseq) {
            res = getCuffdiffTimeResults(schema=schema, condition=condition, gene=genes[i])
        }
        
        if (!is.null(res) && length(res$p_value)==3) {

            WT = getExpression(schema=schema, condition="WT", gene=genes[i])
            WT.mean = mean(WT)
            WT.sd = sd(WT)

            if ((res$q_value[1]<qmax && abs(res$logfc[1])>logFCmin) | (res$q_value[2]<qmax && abs(res$logfc[2])>logFCmin) | (res$q_value[3]<qmax && abs(res$logfc[3])>logFCmin)) {
            
                symbol = getSymbol(genes[i])
                df = rbind(df,
                           data.frame(
                               gene=genes[i], symbol=symbol, WT.mean=WT.mean, WT.sd=WT.sd,
                               logFC.30=res$logfc[1], logFC.60=res$logfc[2], logFC.120=res$logfc[3],
                               p.30=res$p_value[1], p.60=res$p_value[2], p.120=res$p_value[3],
                               q.30=res$q_value[1], q.60=res$q_value[2], q.120=res$q_value[3]
                           )
                           )
                print(paste(genes[i],round(res$logfc[1],1),round(res$q_value[1],4),round(res$logfc[2],1),round(res$q_value[2],4),round(res$logfc[3],1),round(res$q_value[3],4)))

            }

        }

    }

    return(df)

}

