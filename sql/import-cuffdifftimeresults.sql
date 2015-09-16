--
-- coerce individual time-wise DE tables into the single timewise results table with vector data in time order
--

--------------------------
-- SET THE SCHEMA HERE! --
--------------------------

SET search_path TO gse57953;

-- isoforms table used to get gene IDs; FPKM doesn't matter

DROP TABLE isoforms_fpkm_tracking;
CREATE TEMP TABLE isoforms_fpkm_tracking (
       tracking_id	   varchar	 PRIMARY KEY,
       class_code	   varchar,
       nearest_ref_id  varchar,
       gene_id		   varchar,
       gene_short_name varchar,
       tss_id		   varchar,
       locus		   varchar,
       "length"		   int,
       coverage	  	   varchar,
       s0_fpkm		   double precision,
       s0_conf_lo	   double precision,
       s0_conf_hi	   double precision,
       s0_status	   varchar,
       s6_fpkm		   double precision,
       s6_conf_lo	   double precision,
       s6_conf_hi	   double precision,
       s6_status	   varchar,
       s8_fpkm		   double precision,
       s8_conf_lo	   double precision,
       s8_conf_hi	   double precision,
       s8_status	   varchar
);
CREATE INDEX isoforms_fpkm_tracking_gene_id ON isoforms_fpkm_tracking(gene_id);
COPY isoforms_fpkm_tracking FROM '/home/sam/GEO/GSE57953/Cuffdiff/ESTpro/isoforms.fpkm_tracking' WITH CSV HEADER DELIMITER AS '	';

-- load gene_exp.diff DE data into a big stacked table

DROP TABLE bigstack;
CREATE TEMP TABLE bigstack (
       test_id	  		   character varying	NOT NULL,
       id			       character varying	NOT NULL,
       gene			       character varying,
       locus			   character varying,
       sample_1			   character varying,
       sample_2			   character varying,
       status			   character varying,
       value_1			   double precision,
       value_2			   double precision,
       logfc			   double precision,
       test_stat		   double precision,
       p_value			   double precision,
       q_value			   double precision,
       significant		   character varying,
       t			       integer
);

-- make a unique index in case one of the copies below is redundant

CREATE UNIQUE INDEX bigstack_unique ON bigstack(id,sample_1,sample_2,t);

-- load in all the data

COPY bigstack (test_id,id,gene,locus,sample_1,sample_2,status,value_1,value_2,logfc,test_stat,p_value,q_value,significant) FROM '/home/sam/GEO/GSE57953/Cuffdiff/WT.0-6.gene_exp.diff' WITH CSV HEADER DELIMITER AS '	';
UPDATE bigstack SET sample_1='WT.0',sample_2='Col (WT control)',t=6 WHERE t IS NULL;

COPY bigstack (test_id,id,gene,locus,sample_1,sample_2,status,value_1,value_2,logfc,test_stat,p_value,q_value,significant) FROM '/home/sam/GEO/GSE57953/Cuffdiff/WT.0-8.gene_exp.diff' WITH CSV HEADER DELIMITER AS '	';
UPDATE bigstack SET sample_1='WT.0',sample_2='Col (WT control)',t=8 WHERE t IS NULL;


COPY bigstack (test_id,id,gene,locus,sample_1,sample_2,status,value_1,value_2,logfc,test_stat,p_value,q_value,significant) FROM '/home/sam/GEO/GSE57953/Cuffdiff/ESTpro.0-6.gene_exp.diff' WITH CSV HEADER DELIMITER AS '	';
UPDATE bigstack SET sample_1='ESTpro:SPCH1-4A-YFP.0',sample_2='ESTpro:SPCH1-4A-YFP',t=6 WHERE t IS NULL;

COPY bigstack (test_id,id,gene,locus,sample_1,sample_2,status,value_1,value_2,logfc,test_stat,p_value,q_value,significant) FROM '/home/sam/GEO/GSE57953/Cuffdiff/ESTpro.0-8.gene_exp.diff' WITH CSV HEADER DELIMITER AS '	';
UPDATE bigstack SET sample_1='ESTpro:SPCH1-4A-YFP.0',sample_2='ESTpro:SPCH1-4A-YFP',t=8 WHERE t IS NULL;

-- some clean up

DELETE FROM bigstack WHERE test_id IS NULL;

CREATE INDEX bigstack_idx ON bigstack(id,sample_2,t);

-- create our target table, load the IDs, drop not null constraints so we can slowly fill it

DROP TABLE cuffdifftimeresults;
CREATE TABLE cuffdifftimeresults () INHERITS (public.cuffdifftimeresults);

-- instantiate the rows

INSERT INTO cuffdifftimeresults (test_id,id,condition) SELECT DISTINCT test_id,id,sample_2 FROM bigstack;

-- create some indexes to speed up the updates

CREATE INDEX cuffdifftimeresults_idx ON cuffdifftimeresults(id,condition);

-- update the table data column by data column using array(), being sure to order by time to get the array values in the correct order

UPDATE cuffdifftimeresults SET locus=(SELECT DISTINCT locus FROM bigstack WHERE bigstack.id=cuffdifftimeresults.id AND bigstack.sample_2=cuffdifftimeresults.condition);
UPDATE cuffdifftimeresults SET gene=(SELECT DISTINCT gene FROM bigstack WHERE bigstack.id=cuffdifftimeresults.id AND bigstack.sample_2=cuffdifftimeresults.condition);
UPDATE cuffdifftimeresults SET status=array(SELECT status FROM bigstack WHERE bigstack.id=cuffdifftimeresults.id AND bigstack.sample_2=cuffdifftimeresults.condition ORDER BY t);
UPDATE cuffdifftimeresults SET value_1=array(SELECT value_1 FROM bigstack WHERE bigstack.id=cuffdifftimeresults.id AND bigstack.sample_2=cuffdifftimeresults.condition ORDER BY t);
UPDATE cuffdifftimeresults SET value_2=array(SELECT value_2 FROM bigstack WHERE bigstack.id=cuffdifftimeresults.id AND bigstack.sample_2=cuffdifftimeresults.condition ORDER BY t);
UPDATE cuffdifftimeresults SET logfc=array(SELECT logfc FROM bigstack WHERE bigstack.id=cuffdifftimeresults.id AND bigstack.sample_2=cuffdifftimeresults.condition ORDER BY t);
UPDATE cuffdifftimeresults SET test_stat=array(SELECT test_stat FROM bigstack WHERE bigstack.id=cuffdifftimeresults.id AND bigstack.sample_2=cuffdifftimeresults.condition ORDER BY t);
UPDATE cuffdifftimeresults SET p_value=array(SELECT p_value FROM bigstack WHERE bigstack.id=cuffdifftimeresults.id AND bigstack.sample_2=cuffdifftimeresults.condition ORDER BY t);
UPDATE cuffdifftimeresults SET q_value=array(SELECT q_value FROM bigstack WHERE bigstack.id=cuffdifftimeresults.id AND bigstack.sample_2=cuffdifftimeresults.condition ORDER BY t);
UPDATE cuffdifftimeresults SET significant=array(SELECT significant FROM bigstack WHERE bigstack.id=cuffdifftimeresults.id AND bigstack.sample_2=cuffdifftimeresults.condition ORDER BY t);

-- indexes
CREATE UNIQUE INDEX cuffdifftimeresults_unique ON cuffdifftimeresults(id,condition);
CREATE INDEX cuffdifftimeresults_condition ON cuffdifftimeresults(condition);

-- now update with the proper gene IDs from an isoforms table
UPDATE cuffdifftimeresults SET id=(SELECT substring(nearest_ref_id FROM 1 FOR 9) FROM isoforms_fpkm_tracking WHERE nearest_ref_id IS NOT NULL AND isoforms_fpkm_tracking.gene_id=cuffdifftimeresults.test_id LIMIT 1);



