## extract the highest r^2 values and mean of p values when below threshold

extract.best = function(df.compare) {

  df.best = data.frame(check.rows=T,
    gene=character(), logFC.group=character(), R2.group=character(),
    p=numeric(),R2=numeric(),logFC=numeric()
    )

  for (i in 1:dim(df.compare)[1]) {

    df = df.compare[i,]

    ## use geometric mean for p
    p = mean(c(df$p.30,df$p.60,df$p.120))

    if (p<0.005) {
    
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
      
      df.best = rbind(df.best, data.frame(gene=rownames(df), logFC.group=logFC.group, R2.group=R2.group, p=p, logFC=logFC, R2=R2))

      print(paste(rownames(df), logFC.group, R2.group, p, logFC, R2))
      
    }

  }

  rownames(df.best) = df.best$gene
  df.best$gene = NULL

  return(df.best)

}

