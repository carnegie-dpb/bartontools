<!DOCTYPE html>
<html>
	<head>
		<title>Carnegie Insitution for Science DPB - Barton Lab Web Tools - BED workflow</title>
		<meta http-equiv="content-type" content="text/html;charset=UTF-8" />
		<meta name="description" content="Workflow for getting matched reads from a BED file" />
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

		<h1>edgeR Normalization and Differential Expression Workflow</h1>

		<ol class="workflow">
			<li><b>library("edgeR");</b></li>
			<li>
				Create a dataframe <b>counts</b> of read counts, one column for each "tag" (sample), one row for each gene.<br/>
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
			<li>
				<b>calcNormFactors(counts, method="TMM")</b> generates the scale factors for normalizing counts, which is the expression value used here.
				The default method is TMM, one can also use "RLE" which is the DESeq2 method, "upperquartile" or "none".
				This is only for generating expression for use in the tools here; DE measurement does normalization internally.
			</li>
			<li><b>group &#8592; c(1,1,1,1,1,1,1,1,2,2,2,2,2,2,...);</b> lists the "tag" number denoting condition/treatment for each sample, 1=control/WT.</li>
			<li><b>dge &#8592; DGEList(counts=counts, group=group);</b> creates a DGEList.</li>
			<li><b>dge &#8592; calcNormFactors(dge);</b> creates the sample-wise normalization factors.</li>
			<li><b>dge &#8592; estimateCommonDisp(dge, verbose=TRUE);</b> estimates the common dispersion values DISP and BCV.</li>
			<li>
				<b>dge &#8592; estimateTagwiseDisp(dge, trend="movingave");</b> estimates the tag-wise dispersion; "loess" trend method is consistent with DESeq2, "movingave" is edgeR default.
				<ul>
					<li><b>plotBCV(dge, cex=0.4);</b> shows a plot of the dispersions.</li>
				</ul>
			</li>
			<li><b>et.WT.AS2 &#8592; exactTest(dge, pair=c(1,2));</b> calculates the exact-test between tags 1 and 2 (WT and GR-AS2), etc.</li>
			<li><b>et.WT.AS2$table$PAdj &#8592; p.adjust(et.WT.AS2$table$PValue, method="BH");</b> stores Benjamini-Hochberg adjusted p values in <b>et$table</b>.</li>
			<li>Some initial analysis:
				<ul>
					<li><b>de.WT.AS2 &#8592; decideTestsDGE(et.WT.AS2, p=0.05, adjust="BH");</b> selects the up-, down- and non-differentially expressed genes using Benjamini-Hochberg adjustment of the p values.</li>
					<li><b>plotSmear(et.WT.AS2, de.tags=rownames(dge)[as.logical(de.WT.AS2)]);</b> highlights the top-DE genes on an MA plot.</li>
				</ul>
			</li>
		</ol>

		<p>
			The <b>et.*$table</b> dataframes can be written to files for import into a database, etc.
		</p>

<%@ include file="footer.jhtml" %>
