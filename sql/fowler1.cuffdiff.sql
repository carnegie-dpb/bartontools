--
-- load Fowler Lab MGP_1st_RawRNAseqData Cuffdiff expression data and DE results into expression and cuffdiffresults tables
-- Note: samples table must be loaded so we can order the values correctly, and samples.replicate must match genes.read_group_tracking
-- Note: use expression.probe_set_id for read_group_tracking.tracking_id and gene_exp_diff.gene_id
--

--------------------------
-- SET THE SCHEMA HERE! --
--------------------------

SET search_path TO fowler1;

--------------------------
-- LOAD NORMALIZED EXPR --
--------------------------

DROP TABLE read_group_tracking;
CREATE TEMP TABLE read_group_tracking (
       tracking_id         character varying NOT NULL,
       condition           character varying NOT NULL,
       replicate           integer NOT NULL,
       raw_frags           double precision,
       internal_scaled_frags	double precision,
       external_scaled_frags	double precision,
       fpkm                     double precision,
       effective_length	        char(1),
       status                   character varying
);

COPY read_group_tracking FROM '/mnt/data/MGP/Fowler_Lab/MGP_1st_RawRNAseqData/Cuffdiff/genes.read_group_tracking' WITH CSV HEADER DELIMITER AS '	';

-- some clean up

DELETE FROM read_group_tracking WHERE tracking_id IS NULL;
CREATE INDEX read_group_tracking_idx ON read_group_tracking(tracking_id,replicate);

-- create our target table, load the IDs, drop not null constraints so we can slowly fill it

DROP TABLE expression;
CREATE TABLE expression () INHERITS (public.expression);
ALTER TABLE expression ALTER COLUMN values DROP NOT NULL;

-- instantiate the rows - these are tracking IDs like XLOC_000508, not gene IDs!

INSERT INTO expression (probe_set_id) SELECT DISTINCT tracking_id FROM read_group_tracking;

-- update the table data column by data column using array(), being sure to order by replicate to get the array values in the correct order

UPDATE expression SET values=array(
       SELECT fpkm FROM read_group_tracking,samples
       WHERE read_group_tracking.tracking_id=expression.probe_set_id
       AND read_group_tracking.condition=samples.condition
       AND read_group_tracking.replicate=samples.replicate
       ORDER BY samples.num
       );

-- restore NOT NULL

ALTER TABLE expression ALTER COLUMN values SET NOT NULL;


--------------------------
-- LOAD DIFF EXPR DATA ---
--------------------------

DROP TABLE gene_exp_diff;
CREATE TEMP TABLE gene_exp_diff (
       test_id    varchar,
       gene_id    varchar,
       gene       varchar,
       locus      varchar,
       sample_1   varchar,
       sample_2	  varchar,
       status     varchar,
       value_1    double precision,
       value_2    double precision,
       logfc     double precision,
       test_stat  double precision,
       p_value    double precision,
       q_value	  double precision,
       significant varchar
);


COPY gene_exp_diff FROM '/mnt/data/MGP/Fowler_Lab/MGP_1st_RawRNAseqData/Cuffdiff/gene_exp.diff' WITH CSV HEADER DELIMITER AS '	';

-- update expression table with id = gene from here; speeds things up massively to create a table with unique gene_id
DROP TABLE exprupdate;
CREATE TEMP TABLE exprupdate (
       gene_id    varchar UNIQUE NOT NULL,
       gene       varchar
);
INSERT INTO exprupdate SELECT DISTINCT gene_id,gene FROM gene_exp_diff;
UPDATE expression SET id=(SELECT gene FROM exprupdate WHERE exprupdate.gene_id=expression.probe_set_id);

-- load the cuffdiffresults table

DROP TABLE cuffdiffresults;
CREATE TABLE cuffdiffresults () INHERITS (public.cuffdiffresults);

INSERT INTO cuffdiffresults SELECT test_id,gene,gene,locus,sample_1,sample_2,status,value_1,value_2,logfc,test_stat,p_value,q_value,significant FROM gene_exp_diff WHERE status='OK';
