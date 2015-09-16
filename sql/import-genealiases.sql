--
-- import genealiases from a TAIR10 gene_aliases file
--

DELETE FROM genealiases;
COPY genealiases (locusname,symbol,fullname) FROM '/home/sam/genomes/TAIR10/gene_aliases_20140331.txt' WITH CSV HEADER DELIMITER AS '	';
