--
-- create the fowler1.samples table
--

SET search_path TO fowler1;

DROP TABLE samples;
CREATE TABLE samples () INHERITS (public.samples);

INSERT INTO samples  VALUES ('FC192_s_1', 1, 'Seedling', false, NULL, NULL, 0);
INSERT INTO samples  VALUES ('FC216_s_4', 2, 'Seedling', false, NULL, NULL, 1);
INSERT INTO samples  VALUES ('FC216_s_5', 3, 'Seedling', false, NULL, NULL, 2);

INSERT INTO samples  VALUES ('FC159_s_1', 4, 'EmbryoSac', false, NULL, NULL, 0);
INSERT INTO samples  VALUES ('FC159_s_2', 5, 'EmbryoSac', false, NULL, NULL, 1);
INSERT INTO samples  VALUES ('FC162_s_4', 6, 'EmbryoSac', false, NULL, NULL, 2);

INSERT INTO samples  VALUES ('FC162_s_5', 7, 'Ovule', false, NULL, NULL, 0);
INSERT INTO samples  VALUES ('FC213_s_5', 8, 'Ovule', false, NULL, NULL, 1);
INSERT INTO samples  VALUES ('FC213_s_6', 9, 'Ovule', false, NULL, NULL, 2);

INSERT INTO samples  VALUES ('FC216_s_2', 10, 'Pollen', false, NULL, NULL, 0);
INSERT INTO samples  VALUES ('FC216_s_3', 11, 'Pollen', false, NULL, NULL, 1);
INSERT INTO samples  VALUES ('FC224_s_1', 12, 'Pollen', false, NULL, NULL, 2);
