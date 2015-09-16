--
-- identify the tables that contain DESeq data and name the condition associated with them
--

CREATE TABLE deseqtables (
	tablename	varchar	UNIQUE NOT NULL,
	condition	varchar	UNIQUE NOT NULL
);

INSERT INTO deseqtables VALUES ('rescombinedcolas2', 'AS2 (all)');
INSERT INTO deseqtables VALUES ('rescombinedcolkan', 'Kan (all)');
INSERT INTO deseqtables VALUES ('rescombinedcolrev', 'Rev (all)');
INSERT INTO deseqtables VALUES ('rescombinedcolstm', 'STM (all)');
