<!DOCTYPE html>
<html>
	<head>
		<title>Carnegie Insitution for Science DPB - Barton Lab Web Tools - RMA/limma workflow</title>
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

		<h1>RMA Normalization / limma Differential Expression Workflow</h1>

		<ol class="workflow">
			<li>Place .CEL files in R working directory. Fire up R.</li>
			<li><b>library("affy"); library("arrayQualityMetrics"); library("limma");</b></li>
			<li><b>abatch &#8592; ReadAffy();</b> automatically reads all .CEL files into an AffyBatch object.</li>
			<li>
				Initial analysis &ndash; look for bad samples:
				<ul>
					<li><b>boxplot(abatch);</b></li>
					<li><b>hist(abatch);</b></li>
					<li><b>arrayQualityMetrics(abatch, outdir="quality.abatch", reporttitle="Raw AffyBatch Quality Report", force=TRUE);</b> generates an HTML quality analysis report in the indicated directory.</li>
				</ul>
			</li>
			<li><b>rma &#8592; rma(abatch);</b> performs convolution background correction; quantile normalization; median polish summarization.</li>
			<li>
				Look at samples post-normalization: should have same histograms, boxplots:
				<ul>
					<li><b>boxplot(rma);</b></li>
					<li><b>hist(rma);</b></li>
					<li><b>arrayQualityMetrics(rma, outdir="quality.rma", reporttitle="RMA-Normalized ExpressionSet Quality Report", force=TRUE);</b></li>
				</ul>
			</li>
			<li>
				Create a design matrix for limma differential expression analysis, one row for each sample. (Flag two conditions for DE, one condition on the base samples, usually the control samples.)<br/>
				<table class="data" cellspacing="0">
					<tr>
						<td align="center"></td>
						<td align="center">WT</td>
						<td align="center">COND1vsWT</td>
						<td align="center">COND2vsWT</td>
						<td align="center">COND3vsWT</td>
					</tr>
					<tr>
						<td align="center">1</td>
						<td align="center">1</td>
						<td align="center">0</td>
						<td align="center">0</td>
						<td align="center">0</td>
					</tr>
					<tr>
						<td align="center">2</td>
						<td align="center">1</td>
						<td align="center">1</td>
						<td align="center">0</td>
						<td align="center">0</td>
					</tr>
					<tr>
						<td align="center">3</td>
						<td align="center">1</td>
						<td align="center">0</td>
						<td align="center">1</td>
						<td align="center">0</td>
					</tr>
					<tr>
						<td align="center">4</td>
						<td align="center">1</td>
						<td align="center">0</td>
						<td align="center">0</td>
						<td align="center">1</td>
					</tr>
				</table>
			</li>
			<li><b>fit  &#8592; lmFit(rma, design);</b></li>
			<li><b>fit2 &#8592; eBayes(fit);</b></li>
			<li>
				Look at DE results:
				<ul>
					<li><b>volcanoplot(fit2, coef="COND1vsWT", highlight=15);</b> shows log-odds of DE with top 15 DE genes highlighted.</li>
				</ul>
			</li>
			<li>
				Output top N (up to all 22810) DE results for further use (use Benjamini-Hochberg adjustment of p values):
				<ul>
					<li><b>res.COND1.WT <- topTable(fit2, adjust.method="BH", number=22810, coef="COND1vsWT");</b>
						<li><b>res.COND2.WT <- topTable(fit2, adjust.method="BH", number=22810, coef="COND2vsWT");</b>
							<li><b>res.COND3.WT <- topTable(fit2, adjust.method="BH", number=22810, coef="COND3vsWT");</b>
				</ul>
							</li>
		</ol>

<%@ include file="footer.jhtml" %>
