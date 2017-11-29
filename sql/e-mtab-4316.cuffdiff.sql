--
-- coerce individual time-wise DE tables into the single timewise results table with vector data in time order
--
--
-- test_id      gene_id     gene         locus               sample_1 sample_2 status  value_1 value_2 log2(fold_change) test_stat  p_value q_value    significant
-- XLOC_083356	XLOC_083356 OS09G0509700 9:19783523-19786772 OSH1-0   OSH1-3   OK      2.83037 7.73337 1.45011           5.29445    5e-05   0.00248386 yes

--  Table "public.cuffdifftimeresults"
--    Column    |        Type         | Modifiers 
-- -------------+---------------------+-----------
--  test_id     | character varying   | not null
--  id          | character varying   | not null
--  gene        | character varying   | 
--  locus       | character varying   | 
--  condition   | character varying   | 
--  value_1     | double precision[]  | 
--  value_2     | double precision[]  | 
--  logfc       | double precision[]  | 
--  test_stat   | double precision[]  | 
--  p_value     | double precision[]  | 
--  q_value     | double precision[]  | 
--  status      | character varying[] | 
--  significant | character varying[] |

--------------------------
-- SET THE SCHEMA HERE! --
--------------------------
SET search_path TO "e-mtab-4316";

-- gene_exp.diff DE data is loaded into a table, we'll update with the times and delete the conditions we don't want
DROP TABLE gene_exp;
CREATE TEMP TABLE gene_exp (
       test_id	  		   character varying	NOT NULL,
       id			   character varying	NOT NULL,
       gene			   character varying,
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
       t			   integer
);
CREATE UNIQUE INDEX gene_exp_unique ON gene_exp(id,sample_1,sample_2,t);
CREATE INDEX gene_exp_idx ON gene_exp(id,sample_2,t);

-- load the Cuffdiff data
COPY gene_exp (test_id,id,gene,locus,sample_1,sample_2,status,value_1,value_2,logfc,test_stat,p_value,q_value,significant)
     FROM '/home/shokin/BartonLab/E-MTAB-4316/Cuffdiff/gene_exp.diff' WITH CSV HEADER DELIMITER AS '	';

-- remove unwanted conditions
DELETE FROM gene_exp WHERE sample_1 LIKE 'OSH1-%' AND sample_2 LIKE 'WT-%';
DELETE FROM gene_exp WHERE sample_1 LIKE 'WT-%' AND sample_2 LIKE 'OSH1-%';
DELETE FROM gene_exp WHERE sample_1!='OSH1-0' AND sample_1!='WT-0';

-- add in the time values
UPDATE gene_exp SET t=3 WHERE sample_2 LIKE '%-3';
UPDATE gene_exp SET t=6 WHERE sample_2 LIKE '%-6';
UPDATE gene_exp SET t=24 WHERE sample_2 LIKE '%-24';

-- create our target table
DROP TABLE cuffdifftimeresults;
CREATE TABLE cuffdifftimeresults () INHERITS (public.cuffdifftimeresults);
CREATE UNIQUE INDEX cuffdifftimeresults_unique ON cuffdifftimeresults(test_id,condition);
CREATE INDEX cuffdifftimeresults_idx ON cuffdifftimeresults(id,condition);
CREATE INDEX cuffdifftimeresults_condition ON cuffdifftimeresults(condition);

-- instantiate the rows with genes and sample_1 values
INSERT INTO cuffdifftimeresults (test_id,id,condition) SELECT DISTINCT test_id,id,sample_1 FROM gene_exp;

-- update the table data column by data column using array(), being sure to order by time to get the array values in the correct order
UPDATE cuffdifftimeresults SET locus=(SELECT DISTINCT locus FROM gene_exp WHERE gene_exp.id=cuffdifftimeresults.id AND gene_exp.sample_1=cuffdifftimeresults.condition);
UPDATE cuffdifftimeresults SET gene=(SELECT DISTINCT gene FROM gene_exp WHERE gene_exp.id=cuffdifftimeresults.id AND gene_exp.sample_1=cuffdifftimeresults.condition);
UPDATE cuffdifftimeresults SET status=array(SELECT status FROM gene_exp WHERE gene_exp.id=cuffdifftimeresults.id AND gene_exp.sample_1=cuffdifftimeresults.condition ORDER BY t);
UPDATE cuffdifftimeresults SET value_1=array(SELECT value_1 FROM gene_exp WHERE gene_exp.id=cuffdifftimeresults.id AND gene_exp.sample_1=cuffdifftimeresults.condition ORDER BY t);
UPDATE cuffdifftimeresults SET value_2=array(SELECT value_2 FROM gene_exp WHERE gene_exp.id=cuffdifftimeresults.id AND gene_exp.sample_1=cuffdifftimeresults.condition ORDER BY t);
UPDATE cuffdifftimeresults SET logfc=array(SELECT logfc FROM gene_exp WHERE gene_exp.id=cuffdifftimeresults.id AND gene_exp.sample_1=cuffdifftimeresults.condition ORDER BY t);
UPDATE cuffdifftimeresults SET test_stat=array(SELECT test_stat FROM gene_exp WHERE gene_exp.id=cuffdifftimeresults.id AND gene_exp.sample_1=cuffdifftimeresults.condition ORDER BY t);
UPDATE cuffdifftimeresults SET p_value=array(SELECT p_value FROM gene_exp WHERE gene_exp.id=cuffdifftimeresults.id AND gene_exp.sample_1=cuffdifftimeresults.condition ORDER BY t);
UPDATE cuffdifftimeresults SET q_value=array(SELECT q_value FROM gene_exp WHERE gene_exp.id=cuffdifftimeresults.id AND gene_exp.sample_1=cuffdifftimeresults.condition ORDER BY t);
UPDATE cuffdifftimeresults SET significant=array(SELECT significant FROM gene_exp WHERE gene_exp.id=cuffdifftimeresults.id AND gene_exp.sample_1=cuffdifftimeresults.condition ORDER BY t);

-- rename the conditions
UPDATE cuffdifftimeresults SET condition='OSH1-GR' WHERE condition='OSH1-0';
UPDATE cuffdifftimeresults SET condition='WT' WHERE condition='WT-0';

-- -- get rid of genes that are not in our public.genes table (loaded from the GFF)
-- DELETE FROM cuffdifftimeresults WHERE gene NOT IN (
--        SELECT id FROM public.genes WHERE genus='Oryza' AND species='sativa'
--        UNION
--        SELECT name FROM public.genes WHERE genus='Oryza' AND species='sativa'
--        );

-- update IDs with gene IDs where gene is an ID
UPDATE cuffdifftimeresults SET id=gene WHERE gene LIKE 'OS%';

-- clean out stuff we don't want
DELETE FROM cuffdifftimeresults WHERE status[1]!='OK' OR status[2]!='OK' OR status[2]!='OK';
DELETE FROM cuffdifftimeresults WHERE id LIKE 'E%';

-- update IDs from genes table where gene is a gene name
-- UPDATE cuffdifftimeresults SET id=(SELECT id FROM public.genes WHERE name=gene AND genus='Oryza' AND species='sativa' LIMIT 1) WHERE gene NOT LIKE 'OS%';




