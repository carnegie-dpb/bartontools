<!DOCTYPE html>
<html>
    <head>
	<title>Carnegie Insitution for Science DPB - Barton Lab Web Tools - RMA normalization workflow</title>
	<meta http-equiv="content-type" content="text/html;charset=UTF-8" />
	<meta name="description" content="Workflow for two-way ANOVA analysis of differential expression" />
	<link rel="stylesheet" type="text/css" href="root.css" />
	<link rel="stylesheet" type="text/css" href="root-print.css" media="print" />
    </head>
    <body>
	
	<table class="header" cellspacing="0">
	    <tr>
		<td class="logo"><a href="index.jsp"><img class="logo" src="images/carnegie-dpb.png" alt="Carnegie Institution for Science - Plant Biology" /></a></td>
		<td class="heading">
		    <span class="title">Barton Lab Web Tools</span>
		</td>
	    </tr>
	</table>

	<h1>RMA Normalization Workflow</h1>

	<ol class="workflow">
	    <li>Place .CEL files in R working directory. Fire up R.</li>
	    <li><b>library("affy"); library("arrayQualityMetrics"); library("limma");</b></li>
	    <li><b>abatch &#8592; ReadAffy();</b> reads all .CEL files into an AffyBatch object.</li>
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
	</ol>

	<p>
	    The <a href="http://www.ncbi.nlm.nih.gov/pubmed/18055602">Stephen Wenkel, et al.</a> data has only one sample per condition, so statistical differential expression analysis cannot be obtained. The
	    normalized expression values can be compared with heat maps, etc.
	</p>

        <%@ include file="footer.jhtml" %>
