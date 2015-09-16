--
-- add fields imported from Ensembl to be populated by EnsemblData
--

ALTER TABLE finalsupp_kan_down ADD COLUMN transcript_id		  integer;
ALTER TABLE finalsupp_kan_down ADD COLUMN gene_id                 integer;
ALTER TABLE finalsupp_kan_down ADD COLUMN analysis_id             integer;
ALTER TABLE finalsupp_kan_down ADD COLUMN seq_region_id           integer;
ALTER TABLE finalsupp_kan_down ADD COLUMN seq_region_start        integer;
ALTER TABLE finalsupp_kan_down ADD COLUMN seq_region_end          integer;
ALTER TABLE finalsupp_kan_down ADD COLUMN seq_region_strand       integer;
ALTER TABLE finalsupp_kan_down ADD COLUMN display_xref_id         integer;
ALTER TABLE finalsupp_kan_down ADD COLUMN biotype                 varchar;
ALTER TABLE finalsupp_kan_down ADD COLUMN status                  varchar;
ALTER TABLE finalsupp_kan_down ADD COLUMN description             varchar;
ALTER TABLE finalsupp_kan_down ADD COLUMN is_current              boolean;
ALTER TABLE finalsupp_kan_down ADD COLUMN canonical_translation_id integer;
ALTER TABLE finalsupp_kan_down ADD COLUMN stable_id               varchar;
ALTER TABLE finalsupp_kan_down ADD COLUMN version                 integer;
ALTER TABLE finalsupp_kan_down ADD COLUMN created_date            timestamp(0);
ALTER TABLE finalsupp_kan_down ADD COLUMN modified_date           timestamp(0);
