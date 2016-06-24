--
-- Fowler Lab MGP_1st_RawRNAseqData analysis
--

CREATE schema fowler1;

INSERT INTO experiments (
schema,title,description,notes,geoseries,geodataset,pmid,
expressionlabel,contributors,publicdata,assay,annotation,genus,species
) VALUES (
'fowler1', 'Fowler Lab MGP_1st_RawRNAseqData', '80-bp PE RNA-seq data from Fowler lab on seedling, pollen, ovule and embryo sac', NULL, NULL, NULL, NULL,
'FPKM', 'John Fowler, Caity Smythe, Sam Hokin', true, 'RNA-seq', 'AGPv3.30', 'Zea', 'maize'
);
