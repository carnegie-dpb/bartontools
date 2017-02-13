--
-- Cook some array functions
--

CREATE OR REPLACE FUNCTION array_avg(double precision[])
       RETURNS double precision AS $$
       SELECT avg(v) FROM unnest($1) g(v)
       $$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION array_variance(double precision[])
       RETURNS double precision AS $$
       SELECT variance(v) FROM unnest($1) g(v)
       $$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION array_median(double precision[])
       RETURNS double precision AS $$
       SELECT median(v) FROM unnest($1) g(v)
       $$ LANGUAGE sql;




