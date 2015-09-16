DROP TABLE finalsupp_kan_down;

CREATE TABLE finalsupp_kan_down (

agi				varchar,
probe_set_id			varchar,
rank				int,

corr_pval_time_genotype		double precision,
corr_pval_time			double precision,
corr_pval_genotype		double precision,

transcript_level_0		double precision,
transcript_level_30		double precision,
transcript_level_60		double precision,

max_fold_change			double precision,

target_description		varchar,
gene_title			varchar

);


COPY finalsupp_kan_down FROM '/home/sam/bio/data/FinalSuppTable4.csv' WITH CSV;


