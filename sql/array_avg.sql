--
-- function to return average of an array
--

CREATE OR REPLACE FUNCTION array_avg(double precision[])
RETURNS double precision AS $$
SELECT avg(v) FROM unnest($1) g(v)
$$ LANGUAGE sql;
