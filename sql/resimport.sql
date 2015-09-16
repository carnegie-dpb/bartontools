--
-- import the residuals files from DESeq analysis
--

DROP TABLE rescombinedcolas2;
CREATE TABLE rescombinedcolas2 (
	id		varchar	PRIMARY KEY,
	basemean	float8,
	basemeana	float8,
	basemeanb	float8,
	foldchange	float8,
	log2foldchange	float8,
	pval		float8,
	padj		float8
);
COPY rescombinedcolas2 FROM '/home/sam/bio/RNA-Seq/resCombined.Col.AS2.txt' WITH DELIMITER ' ';
UPDATE rescombinedcolas2 SET id=substring(id from 2 for 9);

DROP TABLE rescombinedcolstm;
CREATE TABLE rescombinedcolstm (
	id		varchar	PRIMARY KEY,
	basemean	float8,
	basemeana	float8,
	basemeanb	float8,
	foldchange	float8,
	log2foldchange	float8,
	pval		float8,
	padj		float8
);
COPY rescombinedcolstm FROM '/home/sam/bio/RNA-Seq/resCombined.Col.STM.txt' WITH DELIMITER ' ';
UPDATE rescombinedcolstm SET id=substring(id from 2 for 9);

DROP TABLE rescombinedcolrev;
CREATE TABLE rescombinedcolrev (
	id		varchar	PRIMARY KEY,
	basemean	float8,
	basemeana	float8,
	basemeanb	float8,
	foldchange	float8,
	log2foldchange	float8,
	pval		float8,
	padj		float8
);
COPY rescombinedcolrev FROM '/home/sam/bio/RNA-Seq/resCombined.Col.Rev.txt' WITH DELIMITER ' ';
UPDATE rescombinedcolrev SET id=substring(id from 2 for 9);

DROP TABLE rescombinedcolkan;
CREATE TABLE rescombinedcolkan (
	id		varchar	PRIMARY KEY,
	basemean	float8,
	basemeana	float8,
	basemeanb	float8,
	foldchange	float8,
	log2foldchange	float8,
	pval		float8,
	padj		float8
);
COPY rescombinedcolkan FROM '/home/sam/bio/RNA-Seq/resCombined.Col.Kan.txt' WITH DELIMITER ' ';
UPDATE rescombinedcolkan SET id=substring(id from 2 for 9);
