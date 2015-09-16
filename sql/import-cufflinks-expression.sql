--
-- coerce individual time-wise FPKM tables into the single timewise expression table with vector data in time order
--

--------------------------
-- SET THE SCHEMA HERE! --
--------------------------

SET search_path TO gse57953;

DROP TABLE bigstack;
CREATE TEMP TABLE bigstack (
       tracking_id		   character varying	NOT NULL,
       class_code		   character varying,
       nearest_ref_id	   character varying,
       gene_id			   character varying,
       gene_short_name	   character varying,
       tss_id			   character varying,
       locus			   character varying,
       length			   character varying,
       coverage			   character varying,
       fpkm				   double precision,
       fpkm_conf_lo		   double precision,
       fpkm_conf_hi		   double precision,
       fpkm_status		   character varying,
	   num				   integer
);

-- expression
-- id           | character varying  | 
-- values       | double precision[] | not null
-- probe_set_id | character varying  | 

-- load in all the data

-- Col (WT control)
-- ESTpro:SPCH1-4A-YFP


COPY bigstack (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status) FROM '/home/sam/GEO/GSE57953/Cufflinks/SRR1298719/genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE bigstack SET num=1 WHERE num IS NULL;

COPY bigstack (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status) FROM '/home/sam/GEO/GSE57953/Cufflinks/SRR1298720/genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE bigstack SET num=2 WHERE num IS NULL;

COPY bigstack (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status) FROM '/home/sam/GEO/GSE57953/Cufflinks/SRR1298721/genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE bigstack SET num=3 WHERE num IS NULL;

COPY bigstack (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status) FROM '/home/sam/GEO/GSE57953/Cufflinks/SRR1298722/genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE bigstack SET num=4 WHERE num IS NULL;

COPY bigstack (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status) FROM '/home/sam/GEO/GSE57953/Cufflinks/SRR1298723/genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE bigstack SET num=5 WHERE num IS NULL;

COPY bigstack (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status) FROM '/home/sam/GEO/GSE57953/Cufflinks/SRR1298724/genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE bigstack SET num=6 WHERE num IS NULL;

COPY bigstack (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status) FROM '/home/sam/GEO/GSE57953/Cufflinks/SRR1298725/genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE bigstack SET num=7 WHERE num IS NULL;

COPY bigstack (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status) FROM '/home/sam/GEO/GSE57953/Cufflinks/SRR1298726/genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE bigstack SET num=8 WHERE num IS NULL;

COPY bigstack (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status) FROM '/home/sam/GEO/GSE57953/Cufflinks/SRR1298727/genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE bigstack SET num=9 WHERE num IS NULL;

COPY bigstack (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status) FROM '/home/sam/GEO/GSE57953/Cufflinks/SRR1298728/genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE bigstack SET num=10 WHERE num IS NULL;

COPY bigstack (tracking_id,class_code,nearest_ref_id,gene_id,gene_short_name,tss_id,locus,length,coverage,fpkm,fpkm_conf_lo,fpkm_conf_hi,fpkm_status) FROM '/home/sam/GEO/GSE57953/Cufflinks/SRR1298729/genes.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';
UPDATE bigstack SET num=11 WHERE num IS NULL;


-- some clean up

DELETE FROM bigstack WHERE tracking_id IS NULL;

CREATE INDEX bigstack_idx ON bigstack(tracking_id,num);

-- create our target table, load the IDs, drop not null constraints so we can slowly fill it

DROP TABLE expression;
CREATE TABLE expression () INHERITS (public.expression);
ALTER TABLE expression ALTER COLUMN values DROP NOT NULL;

-- instantiate the rows

INSERT INTO expression (id) SELECT DISTINCT tracking_id FROM bigstack;

-- update the table data column by data column using array(), being sure to order by num to get the array values in the correct order

UPDATE expression SET values=array(SELECT fpkm FROM bigstack WHERE bigstack.tracking_id=expression.id ORDER BY num);

-- restore NOT NULL

ALTER TABLE expression ALTER COLUMN values SET NOT NULL;
