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

CREATE OR REPLACE FUNCTION array_max(double precision[])
       RETURNS double precision AS $$
       SELECT max(v) FROM unnest($1) g(v)
       $$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION array_min(double precision[])
       RETURNS double precision AS $$
       SELECT min(v) FROM unnest($1) g(v)
       $$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION array_range(double precision[])
       RETURNS double precision AS $$
       SELECT max(v)-min(v) FROM unnest($1) g(v)
       $$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION array_mode(text[])
       RETURNS text AS $$
       SELECT v FROM unnest($1) g(v) GROUP BY 1 ORDER BY COUNT(1) DESC, 1 LIMIT 1
       $$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION array_mode(integer[])
       RETURNS integer AS $$
       SELECT v FROM unnest($1) g(v) GROUP BY 1 ORDER BY COUNT(1) DESC, 1 LIMIT 1
       $$ LANGUAGE sql;





