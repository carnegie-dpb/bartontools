--
-- coerce individual time-wise FPKM tables into the single timewise expression table with vector data in time order
--
-- CUFF.n records in genes.fpkm_tracking must be identified from their transcript in isoforms.fpkm_tracking on a file-by-file basis.
--
-- tracking_id          class_code nearest_ref_id gene_id   gene_short_name tss_id locus                length coverage FPKM    FPKM_conf_lo FPKM_conf_hi FPKM_status
-- CUFF.1960	        -	   -              CUFF.1960 -               -	   12:24818069-24820116	-      -	0.36638	0	     2.17456	  OK
-- OS12T0592300-00	-	   -	          CUFF.1960 -               -      12:24818069-24820116	1132   0.443741	0.36638	0.155477     0.577282     OK
-- EPlOSAT00000024646   -	   -	          CUFF.1960 -	            -      12:24818659-24818705	46     0        0       0            1.79492      OK
--
-- Use the OS*T* record, since the EPlOSSAT record represents a non-coding nRNA.

--------------------------
-- SET THE SCHEMA HERE! --
--------------------------

SET search_path TO "e-mtab-4316";

DROP TABLE genes_fpkm;
CREATE TEMP TABLE genes_fpkm (
       tracking_id         character varying	NOT NULL,
       class_code	   character varying,
       nearest_ref_id	   character varying,
       gene_id             character varying,
       gene_short_name	   character varying,
       tss_id              character varying,
       locus               character varying,
       "length"            character varying,
       coverage            character varying,
       fpkm                double precision,
       fpkm_conf_lo        double precision,
       fpkm_conf_hi        double precision,
       fpkm_status         character varying
);
CREATE INDEX genes_fpkm_gene_id ON genes_fpkm(gene_id);

DROP TABLE isoforms_fpkm;
CREATE TEMP TABLE isoforms_fpkm (
       tracking_id         character varying	NOT NULL,
       class_code	   character varying,
       nearest_ref_id	   character varying,
       gene_id             character varying,
       gene_short_name	   character varying,
       tss_id              character varying,
       locus               character varying,
       "length"            character varying,
       coverage            character varying,
       fpkm                double precision,
       fpkm_conf_lo        double precision,
       fpkm_conf_hi        double precision,
       fpkm_status         character varying
);
CREATE INDEX isoforms_fpkm_gene_id ON isoforms_fpkm(gene_id);

DROP TABLE all_fpkm;
CREATE TEMP TABLE all_fpkm (
       tracking_id         character varying	NOT NULL,
       class_code	   character varying,
       nearest_ref_id	   character varying,
       gene_id             character varying,
       gene_short_name	   character varying,
       tss_id              character varying,
       locus               character varying,
       "length"            character varying,
       coverage            character varying,
       fpkm                double precision,
       fpkm_conf_lo        double precision,
       fpkm_conf_hi        double precision,
       fpkm_status         character varying,
       num                 integer
);
CREATE INDEX all_fpkm_tracking_id ON all_fpkm(tracking_id);

-- DRR019486.genes.fpkm_tracking        WT.0.1          1
DELETE FROM genes_fpkm;
DELETE FROM isoforms_fpkm;
COPY genes_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019486.genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
COPY isoforms_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019486.isoforms.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE genes_fpkm SET tracking_id=(SELECT substring(tracking_id,1,12) FROM isoforms_fpkm WHERE gene_id=genes_fpkm.gene_id ORDER BY tracking_id DESC LIMIT 1) WHERE gene_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'E%';
UPDATE genes_fpkm SET tracking_id = replace(tracking_id,'T','G');
INSERT INTO all_fpkm SELECT *,1 FROM genes_fpkm;

-- DRR019494.genes.fpkm_tracking        WT.0.2          2
DELETE FROM genes_fpkm;
DELETE FROM isoforms_fpkm;
COPY genes_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019494.genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
COPY isoforms_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019494.isoforms.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE genes_fpkm SET tracking_id=(SELECT substring(tracking_id,1,12) FROM isoforms_fpkm WHERE gene_id=genes_fpkm.gene_id ORDER BY tracking_id DESC LIMIT 1) WHERE gene_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'E%';
UPDATE genes_fpkm SET tracking_id = replace(tracking_id,'T','G');
INSERT INTO all_fpkm SELECT *,2 FROM genes_fpkm;

-- DRR019487.genes.fpkm_tracking        WT.3.1          3
DELETE FROM genes_fpkm;
DELETE FROM isoforms_fpkm;
COPY genes_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019487.genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
COPY isoforms_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019487.isoforms.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE genes_fpkm SET tracking_id=(SELECT substring(tracking_id,1,12) FROM isoforms_fpkm WHERE gene_id=genes_fpkm.gene_id ORDER BY tracking_id DESC LIMIT 1) WHERE gene_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'E%';
UPDATE genes_fpkm SET tracking_id = replace(tracking_id,'T','G');
INSERT INTO all_fpkm SELECT *,3 FROM genes_fpkm;

-- DRR019495.genes.fpkm_tracking        WT.3.2          4
DELETE FROM genes_fpkm;
DELETE FROM isoforms_fpkm;
COPY genes_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019495.genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
COPY isoforms_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019495.isoforms.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE genes_fpkm SET tracking_id=(SELECT substring(tracking_id,1,12) FROM isoforms_fpkm WHERE gene_id=genes_fpkm.gene_id ORDER BY tracking_id DESC LIMIT 1) WHERE gene_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'E%';
UPDATE genes_fpkm SET tracking_id = replace(tracking_id,'T','G');
INSERT INTO all_fpkm SELECT *,4 FROM genes_fpkm;

-- DRR019488.genes.fpkm_tracking        WT.6.1          5
DELETE FROM genes_fpkm;
DELETE FROM isoforms_fpkm;
COPY genes_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019488.genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
COPY isoforms_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019488.isoforms.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE genes_fpkm SET tracking_id=(SELECT substring(tracking_id,1,12) FROM isoforms_fpkm WHERE gene_id=genes_fpkm.gene_id ORDER BY tracking_id DESC LIMIT 1) WHERE gene_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'E%';
UPDATE genes_fpkm SET tracking_id = replace(tracking_id,'T','G');
INSERT INTO all_fpkm SELECT *,5 FROM genes_fpkm;

-- DRR019496.genes.fpkm_tracking        WT.6.2          6
DELETE FROM genes_fpkm;
DELETE FROM isoforms_fpkm;
COPY genes_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019496.genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
COPY isoforms_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019496.isoforms.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE genes_fpkm SET tracking_id=(SELECT substring(tracking_id,1,12) FROM isoforms_fpkm WHERE gene_id=genes_fpkm.gene_id ORDER BY tracking_id DESC LIMIT 1) WHERE gene_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'E%';
UPDATE genes_fpkm SET tracking_id = replace(tracking_id,'T','G');
INSERT INTO all_fpkm SELECT *,6 FROM genes_fpkm;

-- DRR019489.genes.fpkm_tracking        WT.24.1         7
DELETE FROM genes_fpkm;
DELETE FROM isoforms_fpkm;
COPY genes_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019489.genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
COPY isoforms_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019489.isoforms.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE genes_fpkm SET tracking_id=(SELECT substring(tracking_id,1,12) FROM isoforms_fpkm WHERE gene_id=genes_fpkm.gene_id ORDER BY tracking_id DESC LIMIT 1) WHERE gene_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'E%';
UPDATE genes_fpkm SET tracking_id = replace(tracking_id,'T','G');
INSERT INTO all_fpkm SELECT *,7 FROM genes_fpkm;

-- DRR019497.genes.fpkm_tracking        WT.24.2         8
DELETE FROM genes_fpkm;
DELETE FROM isoforms_fpkm;
COPY genes_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019497.genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
COPY isoforms_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019497.isoforms.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE genes_fpkm SET tracking_id=(SELECT substring(tracking_id,1,12) FROM isoforms_fpkm WHERE gene_id=genes_fpkm.gene_id ORDER BY tracking_id DESC LIMIT 1) WHERE gene_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'E%';
UPDATE genes_fpkm SET tracking_id = replace(tracking_id,'T','G');
INSERT INTO all_fpkm SELECT *,8 FROM genes_fpkm;

-- DRR019482.genes.fpkm_tracking        OSH1.0.1        9
DELETE FROM genes_fpkm;
DELETE FROM isoforms_fpkm;
COPY genes_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019482.genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
COPY isoforms_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019482.isoforms.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE genes_fpkm SET tracking_id=(SELECT substring(tracking_id,1,12) FROM isoforms_fpkm WHERE gene_id=genes_fpkm.gene_id ORDER BY tracking_id DESC LIMIT 1) WHERE gene_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'E%';
UPDATE genes_fpkm SET tracking_id = replace(tracking_id,'T','G');
INSERT INTO all_fpkm SELECT *,9 FROM genes_fpkm;

-- DRR019490.genes.fpkm_tracking        OSH1.0.2        10
DELETE FROM genes_fpkm;
DELETE FROM isoforms_fpkm;
COPY genes_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019490.genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
COPY isoforms_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019490.isoforms.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE genes_fpkm SET tracking_id=(SELECT substring(tracking_id,1,12) FROM isoforms_fpkm WHERE gene_id=genes_fpkm.gene_id ORDER BY tracking_id DESC LIMIT 1) WHERE gene_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'E%';
UPDATE genes_fpkm SET tracking_id = replace(tracking_id,'T','G');
INSERT INTO all_fpkm SELECT *,10 FROM genes_fpkm;

-- DRR019483.genes.fpkm_tracking        OSH1.3.1        11
DELETE FROM genes_fpkm;
DELETE FROM isoforms_fpkm;
COPY genes_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019483.genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
COPY isoforms_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019483.isoforms.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE genes_fpkm SET tracking_id=(SELECT substring(tracking_id,1,12) FROM isoforms_fpkm WHERE gene_id=genes_fpkm.gene_id ORDER BY tracking_id DESC LIMIT 1) WHERE gene_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'E%';
UPDATE genes_fpkm SET tracking_id = replace(tracking_id,'T','G');
INSERT INTO all_fpkm SELECT *,11 FROM genes_fpkm;

-- DRR019491.genes.fpkm_tracking        OSH1.3.2        12
DELETE FROM genes_fpkm;
DELETE FROM isoforms_fpkm;
COPY genes_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019491.genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
COPY isoforms_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019491.isoforms.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE genes_fpkm SET tracking_id=(SELECT substring(tracking_id,1,12) FROM isoforms_fpkm WHERE gene_id=genes_fpkm.gene_id ORDER BY tracking_id DESC LIMIT 1) WHERE gene_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'E%';
UPDATE genes_fpkm SET tracking_id = replace(tracking_id,'T','G');
INSERT INTO all_fpkm SELECT *,12 FROM genes_fpkm;

-- DRR019484.genes.fpkm_tracking        OSH1.6.1        13
DELETE FROM genes_fpkm;
DELETE FROM isoforms_fpkm;
COPY genes_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019484.genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
COPY isoforms_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019484.isoforms.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE genes_fpkm SET tracking_id=(SELECT substring(tracking_id,1,12) FROM isoforms_fpkm WHERE gene_id=genes_fpkm.gene_id ORDER BY tracking_id DESC LIMIT 1) WHERE gene_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'E%';
UPDATE genes_fpkm SET tracking_id = replace(tracking_id,'T','G');
INSERT INTO all_fpkm SELECT *,13 FROM genes_fpkm;

-- DRR019492.genes.fpkm_tracking        OSH1.6.2        14
DELETE FROM genes_fpkm;
DELETE FROM isoforms_fpkm;
COPY genes_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019492.genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
COPY isoforms_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019492.isoforms.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE genes_fpkm SET tracking_id=(SELECT substring(tracking_id,1,12) FROM isoforms_fpkm WHERE gene_id=genes_fpkm.gene_id ORDER BY tracking_id DESC LIMIT 1) WHERE gene_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'E%';
UPDATE genes_fpkm SET tracking_id = replace(tracking_id,'T','G');
INSERT INTO all_fpkm SELECT *,14 FROM genes_fpkm;

-- DRR019485.genes.fpkm_tracking        OSH1.24.1       15
DELETE FROM genes_fpkm;
DELETE FROM isoforms_fpkm;
COPY genes_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019485.genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
COPY isoforms_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019485.isoforms.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE genes_fpkm SET tracking_id=(SELECT substring(tracking_id,1,12) FROM isoforms_fpkm WHERE gene_id=genes_fpkm.gene_id ORDER BY tracking_id DESC LIMIT 1) WHERE gene_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'E%';
UPDATE genes_fpkm SET tracking_id = replace(tracking_id,'T','G');
INSERT INTO all_fpkm SELECT *,15 FROM genes_fpkm;

-- DRR019493.genes.fpkm_tracking        OSH1.24.2       16
DELETE FROM genes_fpkm;
DELETE FROM isoforms_fpkm;
COPY genes_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019493.genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
COPY isoforms_fpkm (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cufflinks/DRR019493.isoforms.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE genes_fpkm SET tracking_id=(SELECT substring(tracking_id,1,12) FROM isoforms_fpkm WHERE gene_id=genes_fpkm.gene_id ORDER BY tracking_id DESC LIMIT 1) WHERE gene_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'CUFF.%';
DELETE FROM genes_fpkm WHERE tracking_id LIKE 'E%';
UPDATE genes_fpkm SET tracking_id = replace(tracking_id,'T','G');
INSERT INTO all_fpkm SELECT *,16 FROM genes_fpkm;

-- create our target table, load the IDs, drop not null constraints so we can slowly fill it
DROP TABLE expression;
CREATE TABLE expression () INHERITS (public.expression);
ALTER TABLE expression ALTER COLUMN values DROP NOT NULL;

-- instantiate the rows
INSERT INTO expression (id) SELECT DISTINCT tracking_id FROM all_fpkm;

-- update the table data column by data column using array(), being sure to order by num to get the array values in the correct order
UPDATE expression SET values=array(SELECT fpkm FROM all_fpkm WHERE all_fpkm.tracking_id=expression.id ORDER BY num);

-- restore NOT NULL
ALTER TABLE expression ALTER COLUMN values SET NOT NULL;
