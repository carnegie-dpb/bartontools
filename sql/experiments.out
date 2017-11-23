--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.10
-- Dumped by pg_dump version 9.5.10

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: experiments; Type: TABLE; Schema: public; Owner: sam
--

CREATE TABLE experiments (
    schema character varying NOT NULL,
    title character varying NOT NULL,
    description character varying,
    notes character varying,
    geoseries character varying,
    geodataset character varying,
    pmid integer,
    expressionlabel character varying,
    contributors character varying,
    publicdata boolean DEFAULT false NOT NULL,
    assay character varying,
    annotation character varying,
    genus character varying,
    species character varying
);


ALTER TABLE experiments OWNER TO sam;

--
-- Data for Name: experiments; Type: TABLE DATA; Schema: public; Owner: sam
--

COPY experiments (schema, title, description, notes, geoseries, geodataset, pmid, expressionlabel, contributors, publicdata, assay, annotation, genus, species) FROM stdin;
gse607	Arabidopsis thaliana leaf, stem and flower tissues	Leaves were harvested 15 days post germination, stems and flowers were harvested 29 days post germination. Assay is Affymetrix ATH1.	\N	GSE607	GDS416	15178800	GEO Expression	Osborne E, Somerville C	t	Microarray	TAIR10	Arabidopsis	thaliana
gse5629	AtGenExpress: Developmental series (seedlings and whole plants)	\N	\N	GSE5629	\N	\N	GEO Expression	Weigel D, Lohmann J, Schmid M, Townsend H, Emmerson Z, Schildknecht B	t	Microarray	TAIR10	Arabidopsis	thaliana
gse5630	AtGenExpress: Developmental series (leaves)	\N	\N	GSE5630	\N	\N	GEO Expression	Weigel D, Lohmann J, Schmid M, Townsend H, Emmerson Z, Schildknecht B	t	Microarray	TAIR10	Arabidopsis	thaliana
gse5631	AtGenExpress: Developmental series (roots)	\N	\N	GSE5631	\N	\N	GEO Expression	Weigel D, Lohmann J, Schmid M, Townsend H, Emmerson Z, Schildknecht B	t	Microarray	TAIR10	Arabidopsis	thaliana
gse5632	AtGenExpress: Developmental series (flowers and pollen)	\N	\N	GSE5632	\N	\N	GEO Expression	Weigel D, Lohmann J, Schmid M, Townsend H, Emmerson Z, Schildknecht B	t	Microarray	TAIR10	Arabidopsis	thaliana
gse70100	Identification of mRNAs Regulated in Response to Transcriptional Activation of the Arabidopsis Abscisic Acid Insensitive Growth 1 (AIG1) Transcription Factor cDNA	Estrogen applied to WT (Col) and ESTHAT22 seedlings and expression measured at 0, 60 and 120 minutes after estrogen application.	All reps are bio reps. Expression values are geometric/median normalized FPKM values from Tophat/Cufflinks reads and mappings.	\N	\N	\N	FPKM	Kathy Barton, Sam Hokin	f	RNA-seq	TAIR10	Arabidopsis	thaliana
gse22982	High resolution temporal profiling of gene expression during Arabidopsis leaf development (senescence process)	Leaf senescence is an essential developmental process that involves altered regulation of thousands of genes and changes in many metabolic and signaling pathways resulting in massive physiological and structural changes in the leaf. The regulation of senescence is complex and although several senescence regulatory genes have been identified and characterized there is little information on how these individual regulators function globally in the control of the process. In this paper we use microarray analysis to obtain a high-resolution time course profile of gene expression during development of a single leaf over a three week period from just before full expansion to senescence. The multiple time points enable the use of highly informative clustering tools to reveal distinct time points at which signaling and metabolic pathways change during senescence. Analysis of motif enrichment in co-regulated gene clusters identifies clear groups of transcription factors active at different stages of leaf development and senescence.	A novel experimental design strategy (A Mead et al, in preparation), based on the principle of the “loop design”, was developed to enable efficient extraction of information about key sample comparisons using a two-colour hybridisation experimental system. With 88 distinct samples (four biological replicates at each of 22 time points) to be compared, the experimental design included 176 two-colour microarray slides, allowing four technical replicates of each sample to be observed. Half of the slides were devoted to assessment of changes in gene expression between time points, using a simple loop design to link 11 samples from either the 7h time points or the 14h time points across the 11 sampling days, directly comparing samples collected on adjacent sampling days (i.e. 19 DAS with 21 DAS, 27 DAS with 29 DAS, etc.), and directly comparing the samples collected at 39 DAS with those collected at 19 DAS. Four separate loops were constructed for the 7h time points and for the 14h time points, using the arbitrary biological replicate labelling to identify the samples to be included in each loop. The remaining slides provided assessment of differences between the 7h and 14h samples and between the arbitrarily labelled biological replicates, with some further assessment of changes between sampling days. All direct comparisons (pairs of samples hybridised together on a slide) were between 7h and 14h samples collected on adjacent sampling days (i.e. 19 DAS with 21 DAS, etc.), including comparisons between samples collected at 39 DAS and at 19 DAS, and different arbitrarily labelled biological replicates.  These 88 comparisons formed a single loop connecting all 88 treatments, therefore ensuring that the design was fully connected (allowing each sample to be compared with every other sample).	GSE22982	\N	21447789	intensity	Emily,,Breeze Ellizabeth,,Harrison Stuart,,McHattie Linda,,Hughes Richard,,Hickman Claire,,Hill Steven,,Kiddle Youn-sung,,Kim Christopher,,Penfold Dafyd,,Jenkins Cunjin,,Zhang Karl,,Morris Carol,,Jenner Stephen,,Jackson Brian,,Thomas Alex,,Tabrett Roxane,,Legaie Jonathan,D,Moore David,L,Wild Sascha,,Ott David,,Rand Jim,,Beynon Katherine,,Denby Andrew,,Mead Vicky,,Buchanan-Wollaston 	t	Microarray	TAIR10	Arabidopsis	thaliana
gse5633	AtGenExpress: Developmental series (shoots and stems)	\N	\N	GSE5633	\N	\N	GEO Expression	Weigel D, Lohmann J, Schmid M, Townsend H, Emmerson Z, Schildknecht B	t	Microarray	TAIR10	Arabidopsis	thaliana
gse5634	AtGenExpress: Developmental series (siliques and seeds)	\N	\N	GSE5634	\N	\N	GEO Expression	Weigel D, Lohmann J, Schmid M, Townsend H, Emmerson Z, Schildknecht B	t	Microarray	TAIR10	Arabidopsis	thaliana
gse34241	RNA-seq-based analysis of the pathogen-induced defense transcriptome in Arabidopsis	Four samples (M1DPI, M6DPI, F1DPI and F6DPI; M=mock treated; F=Fusarium oxysporum infected; DPI=day post inoculation) were sequenced to identify pathogen responsive genes in each time point. Each sample was sequenced once, i.e. without biological replicate.	\N	GSE34241	\N	23107761	DESeq-normalized counts	Zhu Q, Wang M, Stephen S	t	RNA-seq	TAIR10	Arabidopsis	thaliana
gse57953	Direct roles of SPEECHLESS in the specification of stomatal self-renewing cells [RNA-seq]	RNA-Seq profiles of inducible SPCH and wild-type Arabidopsis thaliana upon induction	Lineage-specific stem cells are critical for the production and maintenance of specific cell types and tissues in multicellular organisms. In higher plants, the initiation and proliferation of stomatal stem cells is controlled by the basic helix-loop-helix transcription factor SPEECHLESS (SPCH). The stomatal stem cells and SPCH, which represent an innovation in seed plants, allow flexibility in the production of stomata, but how SPCH generates these stem cells is unclear. Here, we developed a highly sensitive chromatin immunoprecipitation (ChIP) assay and profiled the cell-type specific genome-wide targets of Arabidopsis SPCH in vivo. We found that SPCH directly controls key and novel regulators that drive cell fate and asymmetric cell divisions and enhances responsiveness to cell-cell communication. Our results provide molecular insights on how a master transcription factor generates an adult stem cell lineage that contributes to the success of land plants.	GSE57953	\N	25190717	FPKM	Davies KA, Chang J, Lau OS, Bergmann DC	t	RNA-seq	TAIR10	Arabidopsis	thaliana
gse30702	Expression data from Arabidopsis GR-REVOLUTA and KANADI1-GR transgenic seedlings (GSE30703); plus GR-AS2 transgenic seedlings	Dexamethazone applied to WT, GR-AS2, GR0-KAN and GR-AS2 seedlings and expression measured at 0, 30, 60 and 120 minutes after Dex application.	ATH1 array mapped to genome using ath1121501	\N	\N	\N	RMA-normalized intensity	Barton MK, Reinhart B, Hokin S	f	Microarray	TAIR10	Arabidopsis	thaliana
gse43858	Patterns of Population Epigenomic Diversity in Arabidopsis thaliana (RNA-Seq)	RNA-seq from naturally-occurring Arabidopsis accessions	\N	GSE43858	\N	23467092	Scaled FPKM	Schmitz RJ, Schultz MD, Ecker JR	t	RNA-seq	TAIR10	Arabidopsis	thaliana
gse12715	ABA and ethylene signaling crosstalk	Our current study showed that the ABA and ethylene signal transduction pathways function in parallel and have antagonistic interaction during seed germination and early seedling growth. To further address the possible mechanism by which these two hormones crosstalk, microarray analysis was performed. By microarray analysis we found that an ACC oxidase (ACO) was significantly up-regulated in the aba2 mutant, whereas the 9-CIS-EPOXYCAROTENOID DIOXYGENASE (NCED3) gene in ein2, and both the ABSCISIC ACID INSENSITIVE1 (ABI1) and cytochrome P450, family 707, subfamily A, polypeptide 2 (CYP707A2) genes in etr1-1 were up- and down-regulated, respectively. These data further suggest that ABA and ethylene may control the hormonal biosynthesis, catabolism or signaling of each other to enhance their antagonistic effects upon seed germination and early seedling growth.	Cold pre-treated seeds of wild type (Col), aba2 (or gin1-3), etr1-1, and ein2-1, were grown on 1% sucrose agar plates for 12 to 14 days. Total RNAs were extracted from which 10 μg aliquots were used for cDNA synthesis, labeling by in vitro transcription followed by fragmentation according to the GeneChip Expression Analysis Technical Manual rev5, Affymetrix. Eleven μg of each labeled samples was hybridized to an ATH1 GeneChip at 45oC for 16.5 hours. The washing and staining steps were performed using a Fluidic Station-450 and the ATH1 slides were scanned using the Affymetrix GeneChip Scanner 7G. Subsequent data processing and analysis was performed using the Affymetrix Microarray Suit Software version 5.0. Two independent sets of microarray analyses were performed in this study. The wild type in this study was used as a control.	GSE12715	\N	19513806	intensity	Wan-Hsing,,Cheng Ming-Hau,,Chiang San-Gwang,,Hwang Pei-Chi,,Lin 	t	Microarray	TAIR10	Arabidopsis	thaliana
atgenexpress	AtGenExpress: Developmental series (all samples)	All six AtGenExpress Dev series experiments combined	\N	\N	\N	\N	GEO Expression	Weigel D, Lohmann J, Schmid M, Townsend H, Emmerson Z, Schildknecht B	t	Microarray	TAIR10	Arabidopsis	thaliana
fowler1	Fowler Lab MGP_1st_RawRNAseqData	80-bp PE RNA-seq data from Fowler lab on seedling, pollen, ovule and embryo sac	\N	\N	\N	\N	FPKM	John Fowler, Caity Smythe, Sam Hokin	t	RNA-seq	AGPv3.30	Zea	maize
grtiny	GR-TINY Experiment	Dexamethazone induction of GR-TINY (Col-0) expression, data at 0, 30, 60 min. Other samples imported from GSE70790.	\N	\N	\N	\N	Norm. FPKM	Kathy Barton, Sam Hokin	f	RNA-seq	TAIR10	Arabidopsis	thaliana
gse70796	Transcription targets of ASYMMETRIC LEAVES 2 (AS2), KANADI1 (KAN1), REVOLUTA (REV) and SHOOT MERISTEMLESS (STM) genes	Dexamethazone applied to WT, GR-AS2, GR-KAN and GR-STM seedlings and expression measured at 0, 30, 60 and 120 minutes after Dex application.	All reps are bio reps. Expression values are geometric normalized FPKM values from Tophat/Cufflinks reads and mappings.	\N	\N	\N	FPKM	Kathy Barton, Sam Hokin	f	RNA-seq	TAIR10	Arabidopsis	thaliana
e-mtab-4316	Transcription profiling by high throughput sequencing of rice dexamethasone-inducible OSH1 overexpressor before and after dexamethasone treatment	In flowering plants, knotted1-like homeobox (KNOX) transcription factors play crucial roles in establishment and maintenance of the shoot apical meristem (SAM), from which aerial organs such as leaves, stems and flowers initiate. We report that a rice (Oryza Sativa) KNOX gene Oryza sativa homeobox1 (OSH1) represses the brassinosteroid (BR) phytohormone pathway through activation of BR catabolism genes. Inducible overexpression of OSH1 caused brassinosteroid insensitivity, whereas loss-of-function showed a BR-overproduction phenotype. Genome-wide identification of loci bound and regulated by OSH1 revealed hormonal and transcriptional regulation as the major function of OSH1. Among these targets, BR catabolism genes CYP734A2, CYP734A4 and CYP734A6 were rapidly up-regulated by OSH1-induction. Furthermore, RNAi knockdown plants of CYP734A genes arrested growth of the SAM and mimicked some osh1 phenotypes. Thus, we suggest that local control of BR levels by KNOX genes is a key regulatory step in SAM function.	\N	\N	\N	25194027	FPKM	Tsuda K, Kurata N, Ohyanagi H, Hake S	t	RNA-seq	IRGSP-1.0	Oryza	sativa
\.


--
-- Name: experiments_pkey; Type: CONSTRAINT; Schema: public; Owner: sam
--

ALTER TABLE ONLY experiments
    ADD CONSTRAINT experiments_pkey PRIMARY KEY (schema);


--
-- PostgreSQL database dump complete
--

