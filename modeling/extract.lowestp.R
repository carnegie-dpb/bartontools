## extract the highest r^2 value and lowest p value (and corresponding logFC) from a compare.fits data frame

extract.lowestp = function(df.compare) {

  df.out = data.frame(check.rows=T,
    gene=character(), p.group=character(), R2.group=character(),
    logFC=numeric(), p=numeric(), R2=numeric()
    )

  for (i in 1:dim(df.compare)[1]) {

    df = df.compare[i,]
    
    if (df$p.30<df$p.60 && df$p.30<df$p.120) {
      p.group = "E"
      p = df$p.30
      logFC = df$logFC.30
    } else if (df$p.60<df$p.30 && df$p.60<df$p.120) {
      p.group = "M"
      p = df$p.60
      logFC = df$logFC.60
    } else {
      p.group = "L"
      p = df$p.120
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

    df.out = rbind(df.out, data.frame(gene=rownames(df), p.group=p.group, R2.group=R2.group, p=p, logFC=logFC, R2=R2))

    if (i%%100==0) {
      print(paste(rownames(df), p.group, R2.group, p, logFC, R2))
    }
    
  }

  rownames(df.out) = df.out$gene
  df.out$gene = NULL
  
  return(df.out)

}

