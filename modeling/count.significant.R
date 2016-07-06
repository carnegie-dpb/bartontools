## given an input array of genes, count the number that do and don't have significant DE time results for the given schema, condition
##
## hardcoded to query limmatimeresults for bl2012, cuffdifftimeresults for bl2013

source("~/R/getLimmaTimeResults.R")
source("~/R/getCuffdiffTimeResults.R")

count.significant = function(schema, condition, genes) {

  qThresh = 0.05
  
  nSig = 0
  nInsig = 0

  for (i in 1:length(genes)) {
    if (schema=="bl2012") {
      res = getLimmaTimeResults(schema=schema, condition=condition, gene=genes[i])
    } else if (schema=="bl2013") {
      res = getCuffdiffTimeResults(schema=schema, condition=condition, gene=genes[i])
    }
    isSig = FALSE
    if (!is.null(res)) {
      for (j in 1:length(res$q_value)) {
        if (res$q_value[j]<qThresh) isSig = TRUE
      }
    }
    if (isSig) {
      nSig = nSig + 1
    } else {
      nInsig = nInsig + 1
    }
    print(paste(genes[i],isSig), quote=F)
  }

  return(data.frame(nSig=nSig,nInsig=nInsig))
  
}
