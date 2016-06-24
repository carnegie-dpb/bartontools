<!DOCTYPE html>
<html>
	<head>
		<title>Carnegie Insitution for Science DPB - Barton Lab Web Tools - DESeq2 workflow</title>
		<meta http-equiv="content-type" content="text/html;charset=UTF-8" />
		<meta name="description" content="Workflow for two-way ANOVA analysis of differential expression" />
		<link rel="stylesheet" type="text/css" href="/root.css" />
		<link rel="stylesheet" type="text/css" href="/root-print.css" media="print" />
	</head>
	<body>
		
		<table class="header" cellspacing="0">
			<tr>
				<td class="logo"><a href="/index.jsp"><img class="logo" src="/images/carnegie-dpb.png" alt="Carnegie Institution for Science - Plant Biology" /></a></td>
				<td class="heading">
					<span class="title">Barton Lab Web Tools</span>
				</td>
			</tr>
		</table>

		<h1>DESeq2 Normalization and Differential Expression Workflow</h1>

		<ol class="workflow">
			<li><b>library("DESeq2");</b></li>
			<li>
				Create a dataframe <b>counts</b> of read counts, one column for each sample, one row for each gene.<br/>
				<table class="data" cellspacing="0">
					<tr>
						<td></td>
						<td>WT.1</td><td>WT.2</td><td>WT.3</td><td>COND1.1</td><td>COND1.2</td><td>COND2.1</td><td>COND2.2</td><td>...</td>
					</tr>
					<tr>
						<td>AT1G01010</td>
						<td>311</td><td>119</td><td>181</td><td>125</td><td>110</td><td>77</td><td>179</td><td>...</td>
					</tr>
					<tr>
						<td>...</td>
						<td>...</td><td>...</td><td>...</td><td>...</td><td>...</td><td>...</td><td>...</td><td>...</td>
					</tr>
				</table>
			</li>
			<li><b>prunedCounts &#8592; counts[apply(counts,1,min)>0,];</b> creates a dataframe containing genes with at least one count for every sample.</li>
			<li>
				Create a dataframe <b>colData</b> listing the condition (treatment) for each sample, along with its number:<br/>
				<table class="data" cellspacing="0">
					<tr><td></td><td>condition</td></tr>
					<tr><td>1</td><td>WT</td></tr>
					<tr><td>2</td><td>WT</td></tr>
					<tr><td>3</td><td>WT</td></tr>
					<tr><td>4</td><td>COND1</td></tr>
					<tr><td>5</td><td>COND1</td></tr>
					<tr><td>6</td><td>COND2</td></tr>
					<tr><td>7</td><td>COND2</td></tr>
					<tr><td>...</td><td>...</td></tr>
				</table>
			</li>
			<li><b>dds &#8592; DESeqDataSetFromMatrix(countData=prunedCounts, colData=colData, design=~condition);</b> creates a DESeqDataSet.</li>
			<li><b>colData(dds)$condition &#8592; factor(colData(dds)$condition, levels=c("WT","COND1","COND2",...));</b> (WT or control must be the first element to define the base for differential expression.)</li>
			<li><b>dds &#8592; DESeq(dds);</b> performs the core DE analysis, including normalization.</li>
			<li>
				<b>counts(dds, normalized=TRUE);</b> provides the normalized counts, which can be analyzed with boxplots or histograms:
				<ul>
					<li><b>boxplot(log1p(counts(dds, normalized=TRUE)));</b></li>
				</ul>
			</li>
			<li><b>resultsNames(dds);</b> shows the names of the DE results; will be "condition_COND1_vs_WT", etc. in this example.</li>
			<li>Analysis: <b>plotMA(dds, "condition_COND1_vs_WT", pvalCutoff=0.05);</b> shows an MA-plot highlighting the p&lt;0.05 DE genes.</li>
			<li><b>res.WT.COND1 &#8592; results(dds, "condition_COND1_vs_WT");</b> extracts the DE for the given treatment over control.</li>
		</ol>

		<p>
			The results dataframes can now be written to files for import into a database, etc.
		</p>

<%@ include file="footer.jhtml" %>
