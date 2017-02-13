<!DOCTYPE html>
<html>
    <head>
	<title>Carnegie Insitution for Science DPB - Barton Lab Web Tools - Cuffdiff workflow</title>
	<meta http-equiv="content-type" content="text/html;charset=UTF-8" />
	<meta name="description" content="Workflow for Cuffdiff analysis of differential expression" />
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

	<h1>Cuffdiff Normalization and Differential Expression Workflow</h1>
	
	<ol class="workflow">
	    <li>
		<b>Tophat2</b> is run against each sample FASTQ file using the TAIR10 genome and the following options: --library-type fr-unstranded --b2-sensitive --transcriptome-only  --no-novel-juncs.
		This generates a BAM file of accepted hits.
	    </li>
	    <li>
		<b>Cufflinks</b> is run against each output BAM file to generate FPKM expression values in GTF files.
		The FPKM data is geometric-median normalized for display of FPKM values and for use in other downstream analysis,
		such as correlation and modeling.
	    </li>
	    <li>
		<b>Cuffmerge</b> is run against the Cufflinks GTF files, merging all samples for each condition (WT, GR-AS2, GR-REV, GR-STM, etc.); output is merged.[condition].gtf.
	    </li>
	    <li>
		<b>Cuffdiff</b> is run in time-series mode for each condition using merged.[condition].gtf and sample BAM files grouped by time. (Default geometric-median normalization was used.) The result is
		differential expression data for each condition, locus and t>0 time compared to t=0: value_0, value_t, logFC, t-stat, p-value, q-value.
	    </li>
	    <li>
		The resulting Cuffdiff output is loaded into the PostgreSQL database for realtime search and display in the Barton Lab web application.
	    </li>
	</ol>

        <%@ include file="footer.jhtml" %>
