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
				<td class="logo"><a href="/index.jsp"><img class="logo" src="/images/carnegie-dpb.png" alt="Carnegie Institution for Science - Plant Biology" /></a></td>
				<td class="heading">
					<span class="title">Barton Lab Web Tools</span>
				</td>
			</tr>
		</table>

		<h1>Getting Matched Reads from a BED File</h1>
		
		<p>
			The main tool is <a href="http://bedtools.readthedocs.org/en/latest/">bedtools</a>, which provides a number of utilities for parsing BED files.
		</p>
		
		<ol class="workflow">
			<li>Download the TAIR10 genome GFF file from TAIR: <a href="ftp://ftp.arabidopsis.org/home/tair/Genes/TAIR10_genome_release/TAIR10_gff3/TAIR10_GFF3_genes.gff">TAIR10_GFF3_genes.gff</a>.</li>
			<li><b>bedtools coverage -a inputfile.bed -b TAIR10_GFF3_genes.gff > outputfile.txt</b></li>
		</ol>
		
		<p>
			The tab-delimited output file will have contain each line from TAIR10_GFF3_genes.gff along with four extra numbers from bedtools coverage:
		</p>
		<ol>
			<li>The number of features in A that overlapped (by at least one base pair) the B interval.</li>
			<li>The number of bases in B that had non-zero coverage from features in A.</li>
			<li>The length of the entry in B.</li>
			<li>The fraction of bases in B that had non-zero coverage from features in A.</li>
		</ol>
		<p>
			The first of these represents expression, although a single base pair overlap is probably not enough to qualify as a fully matched read (I'll update this as I learn more about mapping reads, this is very simplistic.)
		</p>
		<p>
			An the output lines look like this for a given gene:
		</p>
		<pre>
Chr1    TAIR10  chromosome      1       30427671        .       .       .       ID=Chr1;Name=Chr1       1258785 7531197 30427671        0.2475114
Chr1    TAIR10  gene    16774865        16777247        .       -       .       ID=AT1G44110;Note=protein_coding_gene;Name=AT1G44110    68      1265    2383    0.5308435
Chr1    TAIR10  mRNA    16774865        16777247        .       -       .       ID=AT1G44110.1;Parent=AT1G44110;Name=AT1G44110.1;Index=1        68      1265    2383    0.5308435
Chr1    TAIR10  five_prime_UTR  16777183        16777247        .       -       .       Parent=AT1G44110.1      2       36      65      0.5538462
Chr1    TAIR10  exon    16776994        16777247        .       -       .       Parent=AT1G44110.1      7       209     254     0.8228347
		</pre>
		<p>
			The line of interest for this gene is the one with "gene" in the third column, the others are ignored. The gene ID is given in column 9 and the overlap counts in column 10.
			I wrote a parser to load all of the coverage files for an experiment and then run through them line by line (all files are identical in format since they mirror the TAIR genome file),
			writing out the gene ID and counts for all samples, one row per gene. This counts matrix file can then be loaded into
			R for <a href="workflow-deseq2.jsp">DESeq2</a>, <a href="workflow-edger.jsp">edgeR</a> or any other expression analysis. I usually use DESeq2 normalization and DE analysis.
		</p>

<%@ include file="footer.jhtml" %>
