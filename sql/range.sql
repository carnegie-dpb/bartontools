CREATE OR REPLACE FUNCTION _final_range(float8[])
   RETURNS float8 AS
$$
   SELECT MAX(val) - MIN(val)
   FROM unnest($1) val;
$$
LANGUAGE 'sql' IMMUTABLE;
 
-- Add aggregate
CREATE AGGREGATE range(float8) (
  SFUNC=array_append, --Function to call for each row. Just builds the array
  STYPE=float8[],
  FINALFUNC=_final_range, --Function to call after everything has been added to array
  INITCOND='{}' --Initialize an empty array when starting
);
