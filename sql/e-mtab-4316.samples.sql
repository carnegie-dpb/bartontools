--
-- create the samples table for the rice e-mtab-4316 experiment
--

-- label         | character varying | not null
-- num           | integer           | not null
-- condition     | character varying | not null
-- control       | boolean           | not null default false
-- time          | integer           | 
-- comment       | character varying | 
-- replicate     | integer           | 
-- internalscale | double precision  | not null default 1.0

-- DRR019486.genes.fpkm_tracking        WT.0.1          1
-- DRR019494.genes.fpkm_tracking        WT.0.2          2
-- DRR019487.genes.fpkm_tracking        WT.3.1          3
-- DRR019495.genes.fpkm_tracking        WT.3.2          4
-- DRR019488.genes.fpkm_tracking        WT.6.1          5
-- DRR019496.genes.fpkm_tracking        WT.6.2          6
-- DRR019489.genes.fpkm_tracking        WT.24.1         7
-- DRR019497.genes.fpkm_tracking        WT.24.2         8

-- DRR019482.genes.fpkm_tracking        OSH1.0.1        9
-- DRR019490.genes.fpkm_tracking        OSH1.0.2        10
-- DRR019483.genes.fpkm_tracking        OSH1.3.1        11
-- DRR019491.genes.fpkm_tracking        OSH1.3.2        12
-- DRR019484.genes.fpkm_tracking        OSH1.6.1        13
-- DRR019492.genes.fpkm_tracking        OSH1.6.2        14
-- DRR019485.genes.fpkm_tracking        OSH1.24.1       15
-- DRR019493.genes.fpkm_tracking        OSH1.24.2       16

SET search_path TO "e-mtab-4316";

DROP TABLE samples;
CREATE TABLE samples () INHERITS (public.samples);

INSERT INTO samples VALUES ('DRR019486', 1, 'WT', true, 0, '', 1, 1.0);
INSERT INTO samples VALUES ('DRR019494', 2, 'WT', true, 0, '', 2, 1.0);
INSERT INTO samples VALUES ('DRR019487', 3, 'WT', true, 3, '', 1, 1.0);
INSERT INTO samples VALUES ('DRR019495', 4, 'WT', true, 3, '', 2, 1.0);
INSERT INTO samples VALUES ('DRR019488', 5, 'WT', true, 6, '', 1, 1.0);
INSERT INTO samples VALUES ('DRR019496', 6, 'WT', true, 6, '', 2, 1.0);
INSERT INTO samples VALUES ('DRR019489', 7, 'WT', true, 24, '', 1, 1.0);
INSERT INTO samples VALUES ('DRR019497', 8, 'WT', true, 24, '', 2, 1.0);

INSERT INTO samples VALUES ('DRR019482',  9, 'OSH1-GR', false, 0, '', 1, 1.0);
INSERT INTO samples VALUES ('DRR019490', 10, 'OSH1-GR', false, 0, '', 2, 1.0);
INSERT INTO samples VALUES ('DRR019483', 11, 'OSH1-GR', false, 3, '', 1, 1.0);
INSERT INTO samples VALUES ('DRR019491', 12, 'OSH1-GR', false, 3, '', 2, 1.0);
INSERT INTO samples VALUES ('DRR019484', 13, 'OSH1-GR', false, 6, '', 1, 1.0);
INSERT INTO samples VALUES ('DRR019492', 14, 'OSH1-GR', false, 6, '', 2, 1.0);
INSERT INTO samples VALUES ('DRR019485', 15, 'OSH1-GR', false, 24, '', 1, 1.0);
INSERT INTO samples VALUES ('DRR019493', 16, 'OSH1-GR', false, 24, '', 2, 1.0);

