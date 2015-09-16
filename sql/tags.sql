--
-- associate genes with user-input tags
--

CREATE TABLE genetags (
	modelname	varchar	NOT NULL REFERENCES tair10,
	tag		varchar	NOT NULL
);

CREATE UNIQUE INDEX genetags_unique ON genetags(modelname,tag);

