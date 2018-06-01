<!DOCTYPE html>
<html>
    <head>
	<title>Carnegie Insitution for Science DPB - Barton Lab Web Tools - Tuxedo Suite workflow</title>
	<meta http-equiv="content-type" content="text/html;charset=UTF-8" />
	<meta name="description" content="Workflow for Tuxedo Suite analysis of expression and differential expression" />
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

	<h1>Tuxedo Suite (Tophat, Cufflinks, Cuffdiff) Expression Normalization and Differential Expression Workflow</h1>
	
	<ol class="workflow">
	    <li>
		<b>Tophat2</b> is run against each sample FASTQ file using the denoted genome and the following options: <br/>
                <code>--library-type fr-unstranded --b2-sensitive --transcriptome-only  --no-novel-juncs</code> <br/>
		This generates a BAM file of accepted hits.
	    </li>
	    <li>
		<b>Cufflinks</b> is run against each output BAM file to generate FPKM expression values in the files <code>isoforms.fpkm_tracking, genes.fpkm_tracking and transcripts.gtf</code>.
                The gene expression values  from <code>genes.fpkm_tracking</code> are normalized across all samples using "geometric" normalization from the DESeq2 R package; this is also the normalization
                used by Cuffdiff, but in that case it is only across samples within a condition.
	    </li>
	    <li>
		<b>Cuffdiff</b> is run against the BAM files for each condition (all times), using geometric-median normalization (the Cuffdiff default) within each condition group.
                The result is differential expression data for each condition, locus and t>0 time compared to t=0 in the files <code>gene_exp.diff</code>.
            </li>
	</ol>

        <%@ include file="footer.jhtml" %>
