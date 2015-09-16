--
-- create a big table containing all of the normalized counts for all the lanes
--

CREATE TABLE normalizedcounts (
	id	varchar		PRIMARY KEY,

-- Col
	Ot7911 	float8,
	Ot7912	float8, 
	Ot7913  float8,
	Ot8691	float8,
	Ot8692	float8,
	Ot8693	float8,

	Ot7914	float8,
	Ot7915	float8,
	Ot7916	float8,
	OtA0255 float8,
	OtA0256 float8,
	Ot8696	float8,

	Ot7917	float8,
	Ot7918	float8,
	Ot7919	float8,
	Ot8697	float8,
	Ot8698	float8,
	Ot8699	float8,

	Ot7920	float8,
	Ot7921	float8,
	Ot7922	float8,
	OtA0257 float8,
	OtA0258 float8,
	OtA0259 float8,

-- AS2
	Ot7923	float8,
	Ot7924	float8,
	Ot7925	float8,

	Ot7926	float8,
	Ot7927	float8,
	Ot7928	float8,

	Ot7929	float8,
	Ot7930	float8,
	Ot7931	float8,

	Ot7932	float8,
	Ot7933	float8,
	Ot7934	float8,

-- STM
	Ot7935	float8,
	Ot7936	float8,
	Ot7937	float8,

	Ot7938	float8,
	Ot7939	float8,
	Ot7940	float8,

	Ot7941	float8,
	Ot7942	float8,
	Ot7943	float8,

	Ot7944	float8,
	Ot7945	float8,
	Ot7946	float8,

-- Rev
	Ot7947	float8,
	Ot7948	float8,
	Ot7949	float8,

	Ot7950	float8,
	Ot7951	float8,

	Ot7952	float8,
	Ot7953	float8,
	Ot7954	float8,

	Ot7955	float8,
	Ot7956	float8,
	Ot7957	float8,

-- Kan
	Ot7958	float8,
	Ot7959	float8,
	Ot7960	float8,

	Ot7961	float8,
	Ot7962	float8,
	Ot7963	float8,

	Ot7964	float8,
	Ot7965	float8,
	Ot7966	float8,

	Ot7967	float8,
	Ot7968	float8,
	Ot7969	float8
);

COPY normalizedcounts FROM '/home/sam/bio/RNA-Seq/normalizedCounts.txt' WITH DELIMITER ' ';
