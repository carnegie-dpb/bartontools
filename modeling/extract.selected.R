## extract the r^2 values and p values from a compare.fits data frame where at least ONE p value is below threshold with a logFC above 0.5
## (this should exclude WT genes, but oh well)
##
## this version only selects genes for which ALL p values are significant

extract.selected = function(df.compare) {

  df.out = data.frame(check.rows=T,
    gene=character(), logFC.group=character(), R2.group=character(),
    logFC=numeric(), p=numeric(), R2=numeric()
    )

  ## these are determined from looking at q(p)

  ## bl2012: q<0.05
  ## p.30.max = 0.00513
  ## p.60.max = 0.00621
  ## p.120.max = 0.00369

  ## bl2013: q<0.05
  p.30.max = 0.00105
  p.60.max = 0.00105
  p.120.max = 0.00105

  logFCmin = 0.5

  for (i in 1:dim(df.compare)[1]) {

    df = df.compare[i,]
    
    if ((df$p.30<p.30.max && abs(df$logFC.30)>logFCmin) || (df$p.60<p.60.max && abs(df$logFC.60)>logFCmin) || (df$p.120<p.120.max && abs(df$logFC.120)>logFCmin)) {

      ## use min p
      p = min(c(df$p.30,df$p.60,df$p.120))

      if (df$logFC.30>df$logFC.60 && df$logFC.30>df$logFC.120) {
        logFC.group = "E"
        logFC = df$logFC.30
      } else if (df$logFC.60>df$logFC.30 && df$logFC.60>df$logFC.120) {
        logFC.group = "M"
        logFC = df$logFC.60
      } else {
        logFC.group = "L"
        logFC = df$logFC.120
      }

      ## use best-fit R2
      if (df$R2.E>df$R2.M && df$R2.E>df$R2.L) {
        R2.group = "E"
        R2 = df$R2.E
      } else if (df$R2.M>df$R2.E && df$R2.M>df$R2.L) {
        R2.group = "M"
        R2 = df$R2.M
      } else {
        R2.group = "L"
        R2 = df$R2.L
      }

      df.out = rbind(df.out, data.frame(gene=rownames(df), logFC.group=logFC.group, R2.group=R2.group, p=p, logFC=logFC, R2=R2))

      print(paste(rownames(df), logFC.group, R2.group, p, logFC, R2))

    }
    
  }

  rownames(df.out) = df.out$gene
  df.out$gene = NULL
  
  return(df.out)

}

