<!DOCTYPE html>
<html>
	<head>
		<title>Carnegie Insitution for Science DPB - Barton Lab Web Tools - ANOVA workflow</title>
		<meta http-equiv="content-type" content="text/html;charset=UTF-8" />
		<meta name="description" content="Workflow for two-way ANOVA analysis of differential expression" />
		<link rel="stylesheet" type="text/css" href="/root.css" />
		<link rel="stylesheet" type="text/css" href="/root-print.css" media="print" />
	</head>
	<body>

		<table class="header" cellspacing="0">
			<tr>
				<td class="logo"><a href="/index.jsp"><img class="logo" src="/images/PB_CISLogo_2c_RGB.png" alt="Carnegie Institution for Science - Plant Biology" /></a></td>
				<td class="heading">
					<span class="title">Barton Lab Web Tools</span>
				</td>
			</tr>
		</table>
		
		<h1>Two-way ANOVA Workflow</h1>

		<p>
			Two-way (condition and time) ANOVA is conducted using the core R routines <b>lm</b> and <b>anova</b>.
		</p>

		<ol class="workflow">
			<li><b>geneID &#8592; row.names(normalizedFPKM)</b> extracts the gene IDs from the Cufflinks geometric-median-normalized FPKM dataframe (see Cuffdiff workflow).</li>
			<li><b>sampleID &#8592; row.names(design)</b> extracts the sample numbers from the experiment design.</li>
			<li>
				For each gene:
				<ol>
					<li><b>df &#8592; data.frame( condition=character(), time=character(), counts=integer() );</b> creates an empty dataframe to hold this gene's condition/time data.</li>
					<li>For each sample:
						<ol>
							<li><b>row &#8592; cbind(design[sampleID[j],],normalizedFPKM[geneID[i],sampleID[j]]);</b> creates a row for the linear fits.</li>
							<li><b>colnames(row)[3] &#8592; "counts";</b> labels the columns.</li>
							<li><b>df &#8592; rbind(df, row);</b> places the row into the dataframe.</li>
						</ol>
					</li>
					<li><b>geneLM &#8592; lm(counts ~ condition + time + condition*time, data=df);</b> performs the linear fits to condition, time and condition+time.</li>
					<li><b>geneANOVA &#8592; anova(geneLM);</b> performs the ANOVA on the linear fits.</li>
					<li>
						The ANOVA result for this gene can now be output to a database, file, etc.
						<ul>
							<li>geneAnova["condition","Df"]</li>
							<li>geneAnova["condition","Mean Sq"]</li>
							<li>geneAnova["condition","F value"]</li>
							<li>geneAnova["condition","Pr(>F)"]</li>
							<li>geneAnova["time","Df"]</li>
							<li>geneAnova["time","Mean Sq"]</li>
							<li>geneAnova["time","F value"]</li>
							<li>geneAnova["time","Pr(>F)"]</li>
							<li>geneAnova["condition:time","Df"]</li>
							<li>geneAnova["condition:time","Mean Sq"]</li>
							<li>geneAnova["condition:time","F value"]</li>
							<li>geneAnova["condition:time","Pr(>F)"]</li>
							<li>geneAnova["Residuals","Df"]</li>
							<li>geneAnova["Residuals","Mean Sq"]</li>
						</ul>
					</li>
				</ol>
			</li>
		</ol>

		<p>
			The above workflow performs ANOVA across all conditions. The process can be repeated restricting the samples to those within particular conditions, such as WT and GR-AS2.
		</p>

		<pre>
##
## Runs two-way ANOVA on the supplied expression data, one gene at a time
##
## Requires dataframes expr and samples, with samples rows = expr columns; also need array of conditions to be included in analysis
##
## set takeLog2=TRUE to take log2(values+1) before ANOVA

anova.twoway = function(expr, samples, conditions, takeLog2=FALSE) {

  ## factors have to be strings! (at least by default)
  samples$time = as.character(samples$time)

  geneID = rownames(expr)

  laneID = vector()
  for (i in 1:length(conditions)) {
    laneID = c(laneID, rownames(samples[samples$condition==conditions[i],]))
  }
  print(laneID)

  ## store results in a data frame
  anovaResult = data.frame(
    condition_df=integer(), condition_meansq=double(), condition_f=double(), condition_p=double(),
    time_df=integer(), time_meansq=double(), time_f=double(), time_p=double(),
    condition_time_df=integer(), condition_time_meansq=double(), condition_time_f=double(), condition_time_p=double(),
    residuals_df=integer(), residuals_meansq=double(),
    check.names=TRUE
    )

  ## count every 100 genes, give completion estimate
  t0 = proc.time()[3]
  tStart = proc.time()[3]

  ## crank out ANOVA across times and conditions for each gene
  for (i in 1:length(geneID)) {
  
    if ((i %% 100)==0) {
      tEnd = proc.time()[3]
      duration = tEnd - tStart
      estimate = (length(geneID)-i)/100*duration/60
      elapsed = (tEnd-t0)/60
      print(paste("=== Elapsed time:",round(elapsed),"minutes; Estimated completion in",round(estimate),"minutes"), quote=FALSE)
      tStart = tEnd
    }
  
    df = data.frame( condition=character(), time=character(), expr=double(), check.names=TRUE )
  
    for (j in 1:length(laneID)) {
      if (takeLog2) {
        ## take log2(value+1)
        row = cbind( samples[laneID[j],], log2(expr[geneID[i],laneID[j]]+1) )
      } else {
        ## straight-up values (could already be log2 transformed, of course)
        row = cbind( samples[laneID[j],], expr[geneID[i],laneID[j]] )
      }
      colnames(row)[4] = "expr"
      df = rbind(df, row)
    }

    ## want first condition to be first factor, treated as "intercept"
    df$condition = factor(df$condition, levels=conditions)

    ## establish time as factor as well (not sure if this is needed)
    df$time = factor(df$time, levels=unique(samples$time))

    ## do LM + ANOVA separately
    geneLM = lm(expr ~ condition*time, data=df)
    geneAnova = anova(geneLM)

    if (!is.nan(geneAnova["condition","Pr(>F)"])) {
      
      anovaResult[geneID[i],] = cbind(
                    
                    geneAnova["condition","Df"],
                    geneAnova["condition","Mean Sq"],
                    geneAnova["condition","F value"],
                    geneAnova["condition","Pr(>F)"],
                    
                    geneAnova["time","Df"],
                    geneAnova["time","Mean Sq"],
                    geneAnova["time","F value"],
                    geneAnova["time","Pr(>F)"],
                    
                    geneAnova["condition:time","Df"],
                    geneAnova["condition:time","Mean Sq"],
                    geneAnova["condition:time","F value"],
                    geneAnova["condition:time","Pr(>F)"],
                    
                    geneAnova["Residuals","Df"],
                    geneAnova["Residuals","Mean Sq"]
                    )
      
    }
  
  }

  ## add BH-adjusted p values
  print("=== Adding q values", quote=FALSE);
  anovaResult$condition_q = p.adjust(anovaResult$condition_p, method="BH")
  anovaResult$time_q = p.adjust(anovaResult$time_p, method="BH")
  anovaResult$condition_time_q = p.adjust(anovaResult$condition_time_p, method="BH")

  return(anovaResult)

}
		</pre

<%@ include file="footer.jhtml" %>
