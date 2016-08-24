##
## return a data frame containing DEX-responsive genes for the given schema
## a gene is DEX responsive if it exhibits significant DE for all conditions including WT
##

source("~/R/getAllIDs.R")
source("~/R/getExpression.R")
source("~/R/getSymbol.R")
source("~/R/getLimmaTimeResults.R")
source("~/R/getCuffdiffTimeResults.R")

getDEXgenes = function(schema="gse70796", qmax=0.05, logFCmin=0.5) {

    microarray = "gse30703"
    rnaseq = "gse70796"

    genes = getAllIDs(schema)

    df = data.frame(check.rows=T,
                    gene=character(), symbol=character(), WT.mean=numeric(), WT.sd=numeric(),
                    logFC.max=numeric(),p.min=numeric(),q.min=numeric()
                    )

    for (i in 1:length(genes)) {

        print(genes[i])
        
        dexer = FALSE
        
        if (schema==microarray) {
            res.WT = getLimmaTimeResults(schema=schema, condition="WT", gene=genes[i])
            res.AS2 = getLimmaTimeResults(schema=schema, condition="GR-AS2", gene=genes[i])
            res.KAN = getLimmaTimeResults(schema=schema, condition="GR-KAN", gene=genes[i])
            res.REV = getLimmaTimeResults(schema=schema, condition="GR-REV", gene=genes[i])
            dexer =
                (!is.null(res.WT) && length(res.WT$p_value)==3) &&
                (!is.null(res.AS2) && length(res.AS2$p_value)==3) &&
                (!is.null(res.KAN) && length(res.KAN$p_value)==3) &&
                (!is.null(res.REV) && length(res.REV$p_value)==3) &&
                ((res.WT$q_value[1]<qmax && abs(res.WT$logfc[1])>logFCmin) | (res.WT$q_value[2]<qmax && abs(res.WT$logfc[2])>logFCmin) | (res.WT$q_value[3]<qmax && abs(res.WT$logfc[3])>logFCmin)) &&
                ((res.AS2$q_value[1]<qmax && abs(res.AS2$logfc[1])>logFCmin) | (res.AS2$q_value[2]<qmax && abs(res.AS2$logfc[2])>logFCmin) | (res.AS2$q_value[3]<qmax && abs(res.AS2$logfc[3])>logFCmin)) &&
                ((res.KAN$q_value[1]<qmax && abs(res.KAN$logfc[1])>logFCmin) | (res.KAN$q_value[2]<qmax && abs(res.KAN$logfc[2])>logFCmin) | (res.KAN$q_value[3]<qmax && abs(res.KAN$logfc[3])>logFCmin)) &&
                ((res.REV$q_value[1]<qmax && abs(res.REV$logfc[1])>logFCmin) | (res.REV$q_value[2]<qmax && abs(res.REV$logfc[2])>logFCmin) | (res.REV$q_value[3]<qmax && abs(res.REV$logfc[3])>logFCmin))
            logFC.max = max(c(res.WT$logfc,res.AS2$logfc,res.KAN$logfc,res.REV$logfc))
            p.min = min(c(res.WT$p_value,res.AS2$p_value,res.KAN$p_value,res.REV$p_value))
            q.min = min(c(res.WT$q_value,res.AS2$q_value,res.KAN$q_value,res.REV$q_value))
        } else if (schema==rnaseq) {
            res.WT = getCuffdiffTimeResults(schema=schema, condition="WT", gene=genes[i])
            res.AS2 = getCuffdiffTimeResults(schema=schema, condition="AS2", gene=genes[i])
            res.KAN = getCuffdiffTimeResults(schema=schema, condition="KAN", gene=genes[i])
            res.REV = getCuffdiffTimeResults(schema=schema, condition="REV", gene=genes[i])
            res.STM = getCuffdiffTimeResults(schema=schema, condition="STM", gene=genes[i])
            dexer =
                (!is.null(res.WT) && length(res.WT$p_value)==3) &&
                (!is.null(res.AS2) && length(res.AS2$p_value)==3) &&
                (!is.null(res.KAN) && length(res.KAN$p_value)==3) &&
                (!is.null(res.REV) && length(res.REV$p_value)==3) &&
                (!is.null(res.STM) && length(res.STM$p_value)==3) &&
                ((res.WT$q_value[1]<qmax && abs(res.WT$logfc[1])>logFCmin) | (res.WT$q_value[2]<qmax && abs(res.WT$logfc[2])>logFCmin) | (res.WT$q_value[3]<qmax && abs(res.WT$logfc[3])>logFCmin)) &&
                ((res.AS2$q_value[1]<qmax && abs(res.AS2$logfc[1])>logFCmin) | (res.AS2$q_value[2]<qmax && abs(res.AS2$logfc[2])>logFCmin) | (res.AS2$q_value[3]<qmax && abs(res.AS2$logfc[3])>logFCmin)) &&
                ((res.KAN$q_value[1]<qmax && abs(res.KAN$logfc[1])>logFCmin) | (res.KAN$q_value[2]<qmax && abs(res.KAN$logfc[2])>logFCmin) | (res.KAN$q_value[3]<qmax && abs(res.KAN$logfc[3])>logFCmin)) &&
                ((res.REV$q_value[1]<qmax && abs(res.REV$logfc[1])>logFCmin) | (res.REV$q_value[2]<qmax && abs(res.REV$logfc[2])>logFCmin) | (res.REV$q_value[3]<qmax && abs(res.REV$logfc[3])>logFCmin)) &&
                ((res.STM$q_value[1]<qmax && abs(res.STM$logfc[1])>logFCmin) | (res.STM$q_value[2]<qmax && abs(res.STM$logfc[2])>logFCmin) | (res.STM$q_value[3]<qmax && abs(res.STM$logfc[3])>logFCmin))
            logFC.max = max(c(res.WT$logfc,res.AS2$logfc,res.KAN$logfc,res.REV$logfc,res.STM$logfc))
            p.min = min(c(res.WT$p_value,res.AS2$p_value,res.KAN$p_value,res.REV$p_value,res.STM$p_value))
            q.min = min(c(res.WT$q_value,res.AS2$q_value,res.KAN$q_value,res.REV$q_value,res.STM$q_value))
        }

        
        if (dexer) {

            WT = getExpression(schema=schema, condition="WT", gene=genes[i])
            WT.mean = mean(WT)
            WT.sd = sd(WT)
            symbol = getSymbol(genes[i])
            df = rbind(df,
                       data.frame(
                           gene=genes[i], symbol=symbol, WT.mean=WT.mean, WT.sd=WT.sd,
                           logFC.max=logFC.max, p.min=p.min, q.min=q.min
                       )
                       )
            print(paste(genes[i],symbol,round(logFC.max,1),round(p.min,4),round(q.min,4)))
            
        }

    }

    return(df)

}

