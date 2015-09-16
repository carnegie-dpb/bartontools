--
-- store "score" string across conditions and times per gene
--

CREATE TABLE public.descores (
	   id	 varchar  PRIMARY KEY,
	   score varchar  NOT NULL
);


CREATE TABLE gse70796.descores () INHERITS (public.descores);
	   
CREATE INDEX descores_score ON gse70796.descores (score);
