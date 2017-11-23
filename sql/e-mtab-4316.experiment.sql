--
-- Add a row to the experiments table for the e-mtab-4316 rice experiment
--

-- schema          | character varying | not null
-- title           | character varying | not null
-- description     | character varying | 
-- notes           | character varying | 
-- geoseries       | character varying | 
-- geodataset      | character varying | 
-- pmid            | integer           | 
-- expressionlabel | character varying | 
-- contributors    | character varying | 
-- publicdata      | boolean           | not null default false
-- assay           | character varying | 
-- annotation      | character varying | 
-- genus           | character varying | 
-- species         | character varying |

INSERT INTO experiments VALUES (
       'e-mtab-4316',
       'Transcription profiling by high throughput sequencing of rice dexamethasone-inducible OSH1 overexpressor before and after dexamethasone treatment',
       'In flowering plants, knotted1-like homeobox (KNOX) transcription factors play crucial roles in establishment and maintenance of the shoot apical meristem (SAM), from which aerial organs such as leaves, stems and flowers initiate. We report that a rice (Oryza Sativa) KNOX gene Oryza sativa homeobox1 (OSH1) represses the brassinosteroid (BR) phytohormone pathway through activation of BR catabolism genes. Inducible overexpression of OSH1 caused brassinosteroid insensitivity, whereas loss-of-function showed a BR-overproduction phenotype. Genome-wide identification of loci bound and regulated by OSH1 revealed hormonal and transcriptional regulation as the major function of OSH1. Among these targets, BR catabolism genes CYP734A2, CYP734A4 and CYP734A6 were rapidly up-regulated by OSH1-induction. Furthermore, RNAi knockdown plants of CYP734A genes arrested growth of the SAM and mimicked some osh1 phenotypes. Thus, we suggest that local control of BR levels by KNOX genes is a key regulatory step in SAM function.',
       null,
       null,
       null,
       25194027,
       'FPKM',
       'Tsuda K, Kurata N, Ohyanagi H, Hake S',
       true,
       'RNA-seq',
       'IRGSP-1.0',
       'Oryza',
       'sativa'
       );
