--
-- make genetags more generic, not related to TAIR10, use Gene.addTag instead of specific versions
--

ALTER TABLE genetags RENAME modelname TO id;
ALTER TABLE genetags DROP CONSTRAINT genetags_modelname_fkey;
UPDATE genetags SET id=substring(id FOR 9);
