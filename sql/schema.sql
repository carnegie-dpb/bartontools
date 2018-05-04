--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.12
-- Dumped by pg_dump version 9.5.12

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: atgenexpress; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA atgenexpress;


ALTER SCHEMA atgenexpress OWNER TO bartonlab;

--
-- Name: bl2014coller; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA bl2014coller;


ALTER SCHEMA bl2014coller OWNER TO bartonlab;

--
-- Name: bl2014hat22c; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA bl2014hat22c;


ALTER SCHEMA bl2014hat22c OWNER TO bartonlab;

--
-- Name: bl2014trk11; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA bl2014trk11;


ALTER SCHEMA bl2014trk11 OWNER TO bartonlab;

--
-- Name: e-mtab-4316; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA "e-mtab-4316";


ALTER SCHEMA "e-mtab-4316" OWNER TO bartonlab;

--
-- Name: e-mtab-6123; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA "e-mtab-6123";


ALTER SCHEMA "e-mtab-6123" OWNER TO bartonlab;

--
-- Name: fowler1; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA fowler1;


ALTER SCHEMA fowler1 OWNER TO bartonlab;

--
-- Name: grtiny; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA grtiny;


ALTER SCHEMA grtiny OWNER TO bartonlab;

--
-- Name: gse12715; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA gse12715;


ALTER SCHEMA gse12715 OWNER TO bartonlab;

--
-- Name: gse15613; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA gse15613;


ALTER SCHEMA gse15613 OWNER TO bartonlab;

--
-- Name: gse22982; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA gse22982;


ALTER SCHEMA gse22982 OWNER TO bartonlab;

--
-- Name: gse30702; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA gse30702;


ALTER SCHEMA gse30702 OWNER TO bartonlab;

--
-- Name: gse34241; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA gse34241;


ALTER SCHEMA gse34241 OWNER TO bartonlab;

--
-- Name: gse43858; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA gse43858;


ALTER SCHEMA gse43858 OWNER TO bartonlab;

--
-- Name: gse4917; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA gse4917;


ALTER SCHEMA gse4917 OWNER TO bartonlab;

--
-- Name: gse5629; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA gse5629;


ALTER SCHEMA gse5629 OWNER TO bartonlab;

--
-- Name: gse5630; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA gse5630;


ALTER SCHEMA gse5630 OWNER TO bartonlab;

--
-- Name: gse5631; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA gse5631;


ALTER SCHEMA gse5631 OWNER TO bartonlab;

--
-- Name: gse5632; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA gse5632;


ALTER SCHEMA gse5632 OWNER TO bartonlab;

--
-- Name: gse5633; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA gse5633;


ALTER SCHEMA gse5633 OWNER TO bartonlab;

--
-- Name: gse5634; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA gse5634;


ALTER SCHEMA gse5634 OWNER TO bartonlab;

--
-- Name: gse57953; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA gse57953;


ALTER SCHEMA gse57953 OWNER TO bartonlab;

--
-- Name: gse607; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA gse607;


ALTER SCHEMA gse607 OWNER TO bartonlab;

--
-- Name: gse70100; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA gse70100;


ALTER SCHEMA gse70100 OWNER TO bartonlab;

--
-- Name: gse70796; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA gse70796;


ALTER SCHEMA gse70796 OWNER TO bartonlab;

--
-- Name: nasc592; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA nasc592;


ALTER SCHEMA nasc592 OWNER TO bartonlab;

--
-- Name: tair10; Type: SCHEMA; Schema: -; Owner: bartonlab
--

CREATE SCHEMA tair10;


ALTER SCHEMA tair10 OWNER TO bartonlab;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: array_avg(double precision[]); Type: FUNCTION; Schema: public; Owner: bartonlab
--

CREATE FUNCTION public.array_avg(double precision[]) RETURNS double precision
    LANGUAGE sql
    AS $_$
       SELECT avg(v) FROM unnest($1) g(v)
       $_$;


ALTER FUNCTION public.array_avg(double precision[]) OWNER TO bartonlab;

--
-- Name: array_max(double precision[]); Type: FUNCTION; Schema: public; Owner: bartonlab
--

CREATE FUNCTION public.array_max(double precision[]) RETURNS double precision
    LANGUAGE sql
    AS $_$
       SELECT max(v) FROM unnest($1) g(v)
       $_$;


ALTER FUNCTION public.array_max(double precision[]) OWNER TO bartonlab;

--
-- Name: array_median(double precision[]); Type: FUNCTION; Schema: public; Owner: bartonlab
--

CREATE FUNCTION public.array_median(double precision[]) RETURNS double precision
    LANGUAGE sql
    AS $_$
   SELECT avg(v) FROM (
     SELECT v
     FROM unnest($1) v
     ORDER BY 1
     LIMIT  2 - mod(array_upper($1, 1), 2)
     OFFSET ceil(array_upper($1, 1) / 2.0) - 1
     ) sub;
     $_$;


ALTER FUNCTION public.array_median(double precision[]) OWNER TO bartonlab;

--
-- Name: array_min(double precision[]); Type: FUNCTION; Schema: public; Owner: bartonlab
--

CREATE FUNCTION public.array_min(double precision[]) RETURNS double precision
    LANGUAGE sql
    AS $_$
       SELECT min(v) FROM unnest($1) g(v)
       $_$;


ALTER FUNCTION public.array_min(double precision[]) OWNER TO bartonlab;

--
-- Name: array_mode(integer[]); Type: FUNCTION; Schema: public; Owner: bartonlab
--

CREATE FUNCTION public.array_mode(integer[]) RETURNS integer
    LANGUAGE sql
    AS $_$
       SELECT v FROM unnest($1) g(v) GROUP BY 1 ORDER BY COUNT(1) DESC, 1 LIMIT 1
       $_$;


ALTER FUNCTION public.array_mode(integer[]) OWNER TO bartonlab;

--
-- Name: array_mode(text[]); Type: FUNCTION; Schema: public; Owner: bartonlab
--

CREATE FUNCTION public.array_mode(text[]) RETURNS text
    LANGUAGE sql
    AS $_$
       SELECT v FROM unnest($1) g(v) GROUP BY 1 ORDER BY COUNT(1) DESC, 1 LIMIT 1
       $_$;


ALTER FUNCTION public.array_mode(text[]) OWNER TO bartonlab;

--
-- Name: array_range(double precision[]); Type: FUNCTION; Schema: public; Owner: bartonlab
--

CREATE FUNCTION public.array_range(double precision[]) RETURNS double precision
    LANGUAGE sql
    AS $_$
       SELECT max(v)-min(v) FROM unnest($1) g(v)
       $_$;


ALTER FUNCTION public.array_range(double precision[]) OWNER TO bartonlab;

--
-- Name: array_variance(double precision[]); Type: FUNCTION; Schema: public; Owner: bartonlab
--

CREATE FUNCTION public.array_variance(double precision[]) RETURNS double precision
    LANGUAGE sql
    AS $_$
       SELECT variance(v) FROM unnest($1) g(v)
       $_$;


ALTER FUNCTION public.array_variance(double precision[]) OWNER TO bartonlab;

--
-- Name: median(double precision); Type: AGGREGATE; Schema: public; Owner: bartonlab
--

CREATE AGGREGATE public.median(double precision) (
    SFUNC = array_append,
    STYPE = double precision[],
    INITCOND = '{}',
    FINALFUNC = public.array_median
);


ALTER AGGREGATE public.median(double precision) OWNER TO bartonlab;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: expression; Type: TABLE; Schema: public; Owner: bartonlab
--

CREATE TABLE public.expression (
    id character varying,
    "values" double precision[] NOT NULL,
    probe_set_id character varying
);


ALTER TABLE public.expression OWNER TO bartonlab;

--
-- Name: expression; Type: TABLE; Schema: atgenexpress; Owner: bartonlab
--

CREATE TABLE atgenexpress.expression (
)
INHERITS (public.expression);


ALTER TABLE atgenexpress.expression OWNER TO bartonlab;

--
-- Name: samples; Type: TABLE; Schema: public; Owner: bartonlab
--

CREATE TABLE public.samples (
    label character varying NOT NULL,
    num integer NOT NULL,
    condition character varying NOT NULL,
    control boolean DEFAULT false NOT NULL,
    "time" integer,
    comment character varying,
    replicate integer,
    internalscale double precision DEFAULT 1.0 NOT NULL
);


ALTER TABLE public.samples OWNER TO bartonlab;

--
-- Name: samples; Type: TABLE; Schema: atgenexpress; Owner: bartonlab
--

CREATE TABLE atgenexpress.samples (
)
INHERITS (public.samples);


ALTER TABLE atgenexpress.samples OWNER TO bartonlab;

--
-- Name: cuffdifftimeresults; Type: TABLE; Schema: public; Owner: bartonlab
--

CREATE TABLE public.cuffdifftimeresults (
    test_id character varying NOT NULL,
    id character varying NOT NULL,
    gene character varying,
    locus character varying,
    condition character varying,
    value_1 double precision[],
    value_2 double precision[],
    logfc double precision[],
    test_stat double precision[],
    p_value double precision[],
    q_value double precision[],
    status character varying[],
    significant character varying[]
);


ALTER TABLE public.cuffdifftimeresults OWNER TO bartonlab;

--
-- Name: cuffdifftimeresults; Type: TABLE; Schema: bl2014coller; Owner: bartonlab
--

CREATE TABLE bl2014coller.cuffdifftimeresults (
)
INHERITS (public.cuffdifftimeresults);


ALTER TABLE bl2014coller.cuffdifftimeresults OWNER TO bartonlab;

--
-- Name: anovaresults; Type: TABLE; Schema: public; Owner: bartonlab
--

CREATE TABLE public.anovaresults (
    id character varying,
    conditions character varying,
    condition_df integer NOT NULL,
    condition_meansq double precision NOT NULL,
    condition_f double precision NOT NULL,
    condition_p double precision NOT NULL,
    time_df integer NOT NULL,
    time_meansq double precision NOT NULL,
    time_f double precision NOT NULL,
    time_p double precision NOT NULL,
    condition_time_df integer NOT NULL,
    condition_time_meansq double precision NOT NULL,
    condition_time_f double precision NOT NULL,
    condition_time_p double precision NOT NULL,
    residuals_df integer NOT NULL,
    residuals_meansq double precision NOT NULL,
    condition_p_adj double precision,
    time_p_adj double precision,
    condition_time_p_adj double precision,
    probe_set_id character varying
);


ALTER TABLE public.anovaresults OWNER TO bartonlab;

--
-- Name: anovaresults; Type: TABLE; Schema: bl2014hat22c; Owner: bartonlab
--

CREATE TABLE bl2014hat22c.anovaresults (
)
INHERITS (public.anovaresults);


ALTER TABLE bl2014hat22c.anovaresults OWNER TO bartonlab;

--
-- Name: cuffdifftimeresults; Type: TABLE; Schema: bl2014hat22c; Owner: bartonlab
--

CREATE TABLE bl2014hat22c.cuffdifftimeresults (
)
INHERITS (public.cuffdifftimeresults);


ALTER TABLE bl2014hat22c.cuffdifftimeresults OWNER TO bartonlab;

--
-- Name: expression; Type: TABLE; Schema: bl2014hat22c; Owner: bartonlab
--

CREATE TABLE bl2014hat22c.expression (
)
INHERITS (public.expression);


ALTER TABLE bl2014hat22c.expression OWNER TO bartonlab;

--
-- Name: samples; Type: TABLE; Schema: bl2014hat22c; Owner: bartonlab
--

CREATE TABLE bl2014hat22c.samples (
)
INHERITS (public.samples);


ALTER TABLE bl2014hat22c.samples OWNER TO bartonlab;

--
-- Name: anovaresults; Type: TABLE; Schema: bl2014trk11; Owner: bartonlab
--

CREATE TABLE bl2014trk11.anovaresults (
)
INHERITS (public.anovaresults);


ALTER TABLE bl2014trk11.anovaresults OWNER TO bartonlab;

--
-- Name: cuffdifftimeresults; Type: TABLE; Schema: bl2014trk11; Owner: bartonlab
--

CREATE TABLE bl2014trk11.cuffdifftimeresults (
)
INHERITS (public.cuffdifftimeresults);


ALTER TABLE bl2014trk11.cuffdifftimeresults OWNER TO bartonlab;

--
-- Name: expression; Type: TABLE; Schema: bl2014trk11; Owner: bartonlab
--

CREATE TABLE bl2014trk11.expression (
)
INHERITS (public.expression);


ALTER TABLE bl2014trk11.expression OWNER TO bartonlab;

--
-- Name: samples; Type: TABLE; Schema: bl2014trk11; Owner: bartonlab
--

CREATE TABLE bl2014trk11.samples (
)
INHERITS (public.samples);


ALTER TABLE bl2014trk11.samples OWNER TO bartonlab;

--
-- Name: cuffdifftimeresults; Type: TABLE; Schema: e-mtab-4316; Owner: bartonlab
--

CREATE TABLE "e-mtab-4316".cuffdifftimeresults (
)
INHERITS (public.cuffdifftimeresults);


ALTER TABLE "e-mtab-4316".cuffdifftimeresults OWNER TO bartonlab;

--
-- Name: expression; Type: TABLE; Schema: e-mtab-4316; Owner: bartonlab
--

CREATE TABLE "e-mtab-4316".expression (
)
INHERITS (public.expression);


ALTER TABLE "e-mtab-4316".expression OWNER TO bartonlab;

--
-- Name: samples; Type: TABLE; Schema: e-mtab-4316; Owner: bartonlab
--

CREATE TABLE "e-mtab-4316".samples (
)
INHERITS (public.samples);


ALTER TABLE "e-mtab-4316".samples OWNER TO bartonlab;

--
-- Name: expression; Type: TABLE; Schema: e-mtab-6123; Owner: bartonlab
--

CREATE TABLE "e-mtab-6123".expression (
)
INHERITS (public.expression);


ALTER TABLE "e-mtab-6123".expression OWNER TO bartonlab;

--
-- Name: limmaresults; Type: TABLE; Schema: public; Owner: bartonlab
--

CREATE TABLE public.limmaresults (
    probe_set_id character varying NOT NULL,
    logfc double precision,
    aveexpr double precision,
    t double precision,
    pvalue double precision,
    adjpvalue double precision,
    b double precision,
    id character varying,
    decondition character varying,
    basecondition character varying
);


ALTER TABLE public.limmaresults OWNER TO bartonlab;

--
-- Name: limmaresults; Type: TABLE; Schema: e-mtab-6123; Owner: bartonlab
--

CREATE TABLE "e-mtab-6123".limmaresults (
)
INHERITS (public.limmaresults);


ALTER TABLE "e-mtab-6123".limmaresults OWNER TO bartonlab;

--
-- Name: samples; Type: TABLE; Schema: e-mtab-6123; Owner: bartonlab
--

CREATE TABLE "e-mtab-6123".samples (
)
INHERITS (public.samples);


ALTER TABLE "e-mtab-6123".samples OWNER TO bartonlab;

--
-- Name: cuffdiffresults; Type: TABLE; Schema: public; Owner: bartonlab
--

CREATE TABLE public.cuffdiffresults (
    test_id character varying NOT NULL,
    id character varying NOT NULL,
    gene character varying,
    locus character varying,
    sample_1 character varying,
    sample_2 character varying,
    status character varying,
    value_1 double precision,
    value_2 double precision,
    logfc double precision,
    test_stat double precision,
    p_value double precision,
    q_value double precision,
    significant character varying
);


ALTER TABLE public.cuffdiffresults OWNER TO bartonlab;

--
-- Name: cuffdiffresults; Type: TABLE; Schema: fowler1; Owner: bartonlab
--

CREATE TABLE fowler1.cuffdiffresults (
)
INHERITS (public.cuffdiffresults);


ALTER TABLE fowler1.cuffdiffresults OWNER TO bartonlab;

--
-- Name: expression; Type: TABLE; Schema: fowler1; Owner: bartonlab
--

CREATE TABLE fowler1.expression (
)
INHERITS (public.expression);


ALTER TABLE fowler1.expression OWNER TO bartonlab;

--
-- Name: samples; Type: TABLE; Schema: fowler1; Owner: bartonlab
--

CREATE TABLE fowler1.samples (
)
INHERITS (public.samples);


ALTER TABLE fowler1.samples OWNER TO bartonlab;

--
-- Name: anovaresults; Type: TABLE; Schema: grtiny; Owner: bartonlab
--

CREATE TABLE grtiny.anovaresults (
)
INHERITS (public.anovaresults);


ALTER TABLE grtiny.anovaresults OWNER TO bartonlab;

--
-- Name: cuffdifftimeresults; Type: TABLE; Schema: grtiny; Owner: bartonlab
--

CREATE TABLE grtiny.cuffdifftimeresults (
)
INHERITS (public.cuffdifftimeresults);


ALTER TABLE grtiny.cuffdifftimeresults OWNER TO bartonlab;

--
-- Name: expression; Type: TABLE; Schema: grtiny; Owner: bartonlab
--

CREATE TABLE grtiny.expression (
)
INHERITS (public.expression);


ALTER TABLE grtiny.expression OWNER TO bartonlab;

--
-- Name: samples; Type: TABLE; Schema: grtiny; Owner: bartonlab
--

CREATE TABLE grtiny.samples (
)
INHERITS (public.samples);


ALTER TABLE grtiny.samples OWNER TO bartonlab;

--
-- Name: expression; Type: TABLE; Schema: gse12715; Owner: bartonlab
--

CREATE TABLE gse12715.expression (
)
INHERITS (public.expression);


ALTER TABLE gse12715.expression OWNER TO bartonlab;

--
-- Name: samples; Type: TABLE; Schema: gse12715; Owner: bartonlab
--

CREATE TABLE gse12715.samples (
)
INHERITS (public.samples);


ALTER TABLE gse12715.samples OWNER TO bartonlab;

--
-- Name: expression; Type: TABLE; Schema: gse15613; Owner: bartonlab
--

CREATE TABLE gse15613.expression (
)
INHERITS (public.expression);
ALTER TABLE ONLY gse15613.expression ALTER COLUMN id SET NOT NULL;


ALTER TABLE gse15613.expression OWNER TO bartonlab;

--
-- Name: samples; Type: TABLE; Schema: gse15613; Owner: bartonlab
--

CREATE TABLE gse15613.samples (
)
INHERITS (public.samples);


ALTER TABLE gse15613.samples OWNER TO bartonlab;

--
-- Name: expression; Type: TABLE; Schema: gse22982; Owner: bartonlab
--

CREATE TABLE gse22982.expression (
)
INHERITS (public.expression);
ALTER TABLE ONLY gse22982.expression ALTER COLUMN id SET NOT NULL;


ALTER TABLE gse22982.expression OWNER TO bartonlab;

--
-- Name: samples; Type: TABLE; Schema: gse22982; Owner: bartonlab
--

CREATE TABLE gse22982.samples (
)
INHERITS (public.samples);


ALTER TABLE gse22982.samples OWNER TO bartonlab;

--
-- Name: anovaresults; Type: TABLE; Schema: gse30702; Owner: bartonlab
--

CREATE TABLE gse30702.anovaresults (
)
INHERITS (public.anovaresults);


ALTER TABLE gse30702.anovaresults OWNER TO bartonlab;

--
-- Name: expression; Type: TABLE; Schema: gse30702; Owner: bartonlab
--

CREATE TABLE gse30702.expression (
)
INHERITS (public.expression);


ALTER TABLE gse30702.expression OWNER TO bartonlab;

--
-- Name: limmaresults; Type: TABLE; Schema: gse30702; Owner: bartonlab
--

CREATE TABLE gse30702.limmaresults (
)
INHERITS (public.limmaresults);


ALTER TABLE gse30702.limmaresults OWNER TO bartonlab;

--
-- Name: limmatimeresults; Type: TABLE; Schema: public; Owner: bartonlab
--

CREATE TABLE public.limmatimeresults (
    probe_set_id character varying NOT NULL,
    id character varying NOT NULL,
    condition character varying NOT NULL,
    t double precision[] NOT NULL,
    logfc double precision[] NOT NULL,
    aveexpr double precision[] NOT NULL,
    p_value double precision[] NOT NULL,
    q_value double precision[] NOT NULL,
    b double precision[] NOT NULL
);


ALTER TABLE public.limmatimeresults OWNER TO bartonlab;

--
-- Name: limmatimeresults; Type: TABLE; Schema: gse30702; Owner: bartonlab
--

CREATE TABLE gse30702.limmatimeresults (
)
INHERITS (public.limmatimeresults);


ALTER TABLE gse30702.limmatimeresults OWNER TO bartonlab;

--
-- Name: samples; Type: TABLE; Schema: gse30702; Owner: bartonlab
--

CREATE TABLE gse30702.samples (
)
INHERITS (public.samples);


ALTER TABLE gse30702.samples OWNER TO bartonlab;

--
-- Name: expression; Type: TABLE; Schema: gse34241; Owner: bartonlab
--

CREATE TABLE gse34241.expression (
)
INHERITS (public.expression);


ALTER TABLE gse34241.expression OWNER TO bartonlab;

--
-- Name: samples; Type: TABLE; Schema: gse34241; Owner: bartonlab
--

CREATE TABLE gse34241.samples (
)
INHERITS (public.samples);


ALTER TABLE gse34241.samples OWNER TO bartonlab;

--
-- Name: expression; Type: TABLE; Schema: gse43858; Owner: bartonlab
--

CREATE TABLE gse43858.expression (
)
INHERITS (public.expression);


ALTER TABLE gse43858.expression OWNER TO bartonlab;

--
-- Name: samples; Type: TABLE; Schema: gse43858; Owner: bartonlab
--

CREATE TABLE gse43858.samples (
)
INHERITS (public.samples);


ALTER TABLE gse43858.samples OWNER TO bartonlab;

--
-- Name: expression; Type: TABLE; Schema: gse4917; Owner: bartonlab
--

CREATE TABLE gse4917.expression (
)
INHERITS (public.expression);
ALTER TABLE ONLY gse4917.expression ALTER COLUMN id SET NOT NULL;


ALTER TABLE gse4917.expression OWNER TO bartonlab;

--
-- Name: samples; Type: TABLE; Schema: gse4917; Owner: bartonlab
--

CREATE TABLE gse4917.samples (
)
INHERITS (public.samples);


ALTER TABLE gse4917.samples OWNER TO bartonlab;

--
-- Name: expression; Type: TABLE; Schema: gse5629; Owner: bartonlab
--

CREATE TABLE gse5629.expression (
)
INHERITS (public.expression);


ALTER TABLE gse5629.expression OWNER TO bartonlab;

--
-- Name: samples; Type: TABLE; Schema: gse5629; Owner: bartonlab
--

CREATE TABLE gse5629.samples (
)
INHERITS (public.samples);


ALTER TABLE gse5629.samples OWNER TO bartonlab;

--
-- Name: expression; Type: TABLE; Schema: gse5630; Owner: bartonlab
--

CREATE TABLE gse5630.expression (
)
INHERITS (public.expression);


ALTER TABLE gse5630.expression OWNER TO bartonlab;

--
-- Name: samples; Type: TABLE; Schema: gse5630; Owner: bartonlab
--

CREATE TABLE gse5630.samples (
)
INHERITS (public.samples);


ALTER TABLE gse5630.samples OWNER TO bartonlab;

--
-- Name: expression; Type: TABLE; Schema: gse5631; Owner: bartonlab
--

CREATE TABLE gse5631.expression (
)
INHERITS (public.expression);


ALTER TABLE gse5631.expression OWNER TO bartonlab;

--
-- Name: samples; Type: TABLE; Schema: gse5631; Owner: bartonlab
--

CREATE TABLE gse5631.samples (
)
INHERITS (public.samples);


ALTER TABLE gse5631.samples OWNER TO bartonlab;

--
-- Name: expression; Type: TABLE; Schema: gse5632; Owner: bartonlab
--

CREATE TABLE gse5632.expression (
)
INHERITS (public.expression);


ALTER TABLE gse5632.expression OWNER TO bartonlab;

--
-- Name: samples; Type: TABLE; Schema: gse5632; Owner: bartonlab
--

CREATE TABLE gse5632.samples (
)
INHERITS (public.samples);


ALTER TABLE gse5632.samples OWNER TO bartonlab;

--
-- Name: expression; Type: TABLE; Schema: gse5633; Owner: bartonlab
--

CREATE TABLE gse5633.expression (
)
INHERITS (public.expression);


ALTER TABLE gse5633.expression OWNER TO bartonlab;

--
-- Name: samples; Type: TABLE; Schema: gse5633; Owner: bartonlab
--

CREATE TABLE gse5633.samples (
)
INHERITS (public.samples);


ALTER TABLE gse5633.samples OWNER TO bartonlab;

--
-- Name: expression; Type: TABLE; Schema: gse5634; Owner: bartonlab
--

CREATE TABLE gse5634.expression (
)
INHERITS (public.expression);


ALTER TABLE gse5634.expression OWNER TO bartonlab;

--
-- Name: samples; Type: TABLE; Schema: gse5634; Owner: bartonlab
--

CREATE TABLE gse5634.samples (
)
INHERITS (public.samples);


ALTER TABLE gse5634.samples OWNER TO bartonlab;

--
-- Name: cuffdifftimeresults; Type: TABLE; Schema: gse57953; Owner: bartonlab
--

CREATE TABLE gse57953.cuffdifftimeresults (
)
INHERITS (public.cuffdifftimeresults);


ALTER TABLE gse57953.cuffdifftimeresults OWNER TO bartonlab;

--
-- Name: descores; Type: TABLE; Schema: public; Owner: bartonlab
--

CREATE TABLE public.descores (
    id character varying NOT NULL,
    score character varying NOT NULL
);


ALTER TABLE public.descores OWNER TO bartonlab;

--
-- Name: descores; Type: TABLE; Schema: gse57953; Owner: bartonlab
--

CREATE TABLE gse57953.descores (
)
INHERITS (public.descores);


ALTER TABLE gse57953.descores OWNER TO bartonlab;

--
-- Name: expression; Type: TABLE; Schema: gse57953; Owner: bartonlab
--

CREATE TABLE gse57953.expression (
)
INHERITS (public.expression);


ALTER TABLE gse57953.expression OWNER TO bartonlab;

--
-- Name: samples; Type: TABLE; Schema: gse57953; Owner: bartonlab
--

CREATE TABLE gse57953.samples (
)
INHERITS (public.samples);


ALTER TABLE gse57953.samples OWNER TO bartonlab;

--
-- Name: expression; Type: TABLE; Schema: gse607; Owner: bartonlab
--

CREATE TABLE gse607.expression (
)
INHERITS (public.expression);


ALTER TABLE gse607.expression OWNER TO bartonlab;

--
-- Name: limmaresults; Type: TABLE; Schema: gse607; Owner: bartonlab
--

CREATE TABLE gse607.limmaresults (
)
INHERITS (public.limmaresults);


ALTER TABLE gse607.limmaresults OWNER TO bartonlab;

--
-- Name: samples; Type: TABLE; Schema: gse607; Owner: bartonlab
--

CREATE TABLE gse607.samples (
)
INHERITS (public.samples);


ALTER TABLE gse607.samples OWNER TO bartonlab;

--
-- Name: anovaresults; Type: TABLE; Schema: gse70100; Owner: bartonlab
--

CREATE TABLE gse70100.anovaresults (
)
INHERITS (public.anovaresults);


ALTER TABLE gse70100.anovaresults OWNER TO bartonlab;

--
-- Name: cuffdifftimeresults; Type: TABLE; Schema: gse70100; Owner: bartonlab
--

CREATE TABLE gse70100.cuffdifftimeresults (
)
INHERITS (public.cuffdifftimeresults);


ALTER TABLE gse70100.cuffdifftimeresults OWNER TO bartonlab;

--
-- Name: expression; Type: TABLE; Schema: gse70100; Owner: bartonlab
--

CREATE TABLE gse70100.expression (
)
INHERITS (public.expression);


ALTER TABLE gse70100.expression OWNER TO bartonlab;

--
-- Name: samples; Type: TABLE; Schema: gse70100; Owner: bartonlab
--

CREATE TABLE gse70100.samples (
)
INHERITS (public.samples);


ALTER TABLE gse70100.samples OWNER TO bartonlab;

--
-- Name: anovaresults; Type: TABLE; Schema: gse70796; Owner: bartonlab
--

CREATE TABLE gse70796.anovaresults (
)
INHERITS (public.anovaresults);
ALTER TABLE ONLY gse70796.anovaresults ALTER COLUMN condition_p_adj SET NOT NULL;
ALTER TABLE ONLY gse70796.anovaresults ALTER COLUMN condition_time_p_adj SET NOT NULL;


ALTER TABLE gse70796.anovaresults OWNER TO bartonlab;

--
-- Name: cuffdiffresults; Type: TABLE; Schema: gse70796; Owner: bartonlab
--

CREATE TABLE gse70796.cuffdiffresults (
)
INHERITS (public.cuffdiffresults);


ALTER TABLE gse70796.cuffdiffresults OWNER TO bartonlab;

--
-- Name: cuffdifftimeresults; Type: TABLE; Schema: gse70796; Owner: bartonlab
--

CREATE TABLE gse70796.cuffdifftimeresults (
)
INHERITS (public.cuffdifftimeresults);


ALTER TABLE gse70796.cuffdifftimeresults OWNER TO bartonlab;

--
-- Name: descores; Type: TABLE; Schema: gse70796; Owner: bartonlab
--

CREATE TABLE gse70796.descores (
)
INHERITS (public.descores);


ALTER TABLE gse70796.descores OWNER TO bartonlab;

--
-- Name: expfitresults; Type: TABLE; Schema: public; Owner: bartonlab
--

CREATE TABLE public.expfitresults (
    id character varying NOT NULL,
    condition character varying NOT NULL,
    s0_est double precision NOT NULL,
    s0_se double precision NOT NULL,
    s0_t double precision NOT NULL,
    s0_pr double precision NOT NULL,
    gamma_est double precision NOT NULL,
    gamma_se double precision NOT NULL,
    gamma_t double precision NOT NULL,
    gamma_pr double precision NOT NULL
);


ALTER TABLE public.expfitresults OWNER TO bartonlab;

--
-- Name: expfitresults; Type: TABLE; Schema: gse70796; Owner: bartonlab
--

CREATE TABLE gse70796.expfitresults (
)
INHERITS (public.expfitresults);


ALTER TABLE gse70796.expfitresults OWNER TO bartonlab;

--
-- Name: expression; Type: TABLE; Schema: gse70796; Owner: bartonlab
--

CREATE TABLE gse70796.expression (
)
INHERITS (public.expression);


ALTER TABLE gse70796.expression OWNER TO bartonlab;

--
-- Name: samples; Type: TABLE; Schema: gse70796; Owner: bartonlab
--

CREATE TABLE gse70796.samples (
)
INHERITS (public.samples);


ALTER TABLE gse70796.samples OWNER TO bartonlab;

--
-- Name: expression; Type: TABLE; Schema: nasc592; Owner: bartonlab
--

CREATE TABLE nasc592.expression (
)
INHERITS (public.expression);


ALTER TABLE nasc592.expression OWNER TO bartonlab;

--
-- Name: limmaresults; Type: TABLE; Schema: nasc592; Owner: bartonlab
--

CREATE TABLE nasc592.limmaresults (
)
INHERITS (public.limmaresults);


ALTER TABLE nasc592.limmaresults OWNER TO bartonlab;

--
-- Name: samples; Type: TABLE; Schema: nasc592; Owner: bartonlab
--

CREATE TABLE nasc592.samples (
)
INHERITS (public.samples);


ALTER TABLE nasc592.samples OWNER TO bartonlab;

--
-- Name: affxannot; Type: TABLE; Schema: public; Owner: bartonlab
--

CREATE TABLE public.affxannot (
    probe_set_id character varying NOT NULL,
    transcript_id character varying,
    target_description character varying,
    representative_public_id character varying,
    unigene_id character varying,
    alignments character varying,
    gene_title character varying,
    gene_symbol character varying,
    ensembl character varying,
    entrez_gene character varying,
    swissprot character varying,
    refseq_protein_id character varying,
    agi character varying,
    gene_ontology_biological_process character varying,
    gene_ontology_cellular_component character varying,
    gene_ontology_molecular_function character varying,
    interpro character varying,
    annotation_transcript_cluster character varying,
    transcript_assignments character varying,
    annotation_notes character varying
);


ALTER TABLE public.affxannot OWNER TO bartonlab;

--
-- Name: degexpresults; Type: TABLE; Schema: public; Owner: bartonlab
--

CREATE TABLE public.degexpresults (
    id character varying NOT NULL,
    basecondition character varying,
    decondition character varying,
    basemean double precision,
    demean double precision,
    logfc double precision,
    logfcnorm double precision,
    pvalue double precision,
    q_benjamini double precision,
    q_storey double precision,
    significant boolean
);


ALTER TABLE public.degexpresults OWNER TO bartonlab;

--
-- Name: deseq2results; Type: TABLE; Schema: public; Owner: bartonlab
--

CREATE TABLE public.deseq2results (
    id character varying NOT NULL,
    basecondition character varying NOT NULL,
    decondition character varying NOT NULL,
    basemean double precision,
    logfc double precision,
    logfcse double precision,
    stat double precision,
    pval double precision,
    padj double precision
);


ALTER TABLE public.deseq2results OWNER TO bartonlab;

--
-- Name: deseq2timeresults; Type: TABLE; Schema: public; Owner: bartonlab
--

CREATE TABLE public.deseq2timeresults (
    id character varying NOT NULL,
    condition character varying NOT NULL,
    basemean double precision[] NOT NULL,
    logfc double precision[] NOT NULL,
    logfcse double precision[] NOT NULL,
    stat double precision[] NOT NULL,
    pval double precision[] NOT NULL,
    padj double precision[] NOT NULL
);


ALTER TABLE public.deseq2timeresults OWNER TO bartonlab;

--
-- Name: edgerresults; Type: TABLE; Schema: public; Owner: bartonlab
--

CREATE TABLE public.edgerresults (
    id character varying NOT NULL,
    basecondition character varying NOT NULL,
    decondition character varying NOT NULL,
    logfc double precision NOT NULL,
    logcpm double precision NOT NULL,
    pval double precision NOT NULL,
    fdr double precision NOT NULL
);


ALTER TABLE public.edgerresults OWNER TO bartonlab;

--
-- Name: edgertimeresults; Type: TABLE; Schema: public; Owner: bartonlab
--

CREATE TABLE public.edgertimeresults (
    id character varying NOT NULL,
    basecondition character varying NOT NULL,
    decondition character varying NOT NULL,
    logfc double precision[] NOT NULL,
    logcpm double precision[] NOT NULL,
    lr double precision[] NOT NULL,
    pval double precision[] NOT NULL,
    fdr double precision[] NOT NULL
);


ALTER TABLE public.edgertimeresults OWNER TO bartonlab;

--
-- Name: experiments; Type: TABLE; Schema: public; Owner: bartonlab
--

CREATE TABLE public.experiments (
    schema character varying NOT NULL,
    title character varying NOT NULL,
    description character varying,
    notes character varying,
    geoseries character varying,
    geodataset character varying,
    pmid integer,
    expressionlabel character varying,
    contributors character varying,
    publicdata boolean DEFAULT false NOT NULL,
    assay character varying,
    annotation character varying,
    genus character varying,
    species character varying
);


ALTER TABLE public.experiments OWNER TO bartonlab;

--
-- Name: genealiases; Type: TABLE; Schema: public; Owner: bartonlab
--

CREATE TABLE public.genealiases (
    id character varying NOT NULL,
    name character varying NOT NULL,
    fullname character varying,
    genus character varying NOT NULL,
    species character varying NOT NULL
);


ALTER TABLE public.genealiases OWNER TO bartonlab;

--
-- Name: genes; Type: TABLE; Schema: public; Owner: bartonlab
--

CREATE TABLE public.genes (
    seqid character varying NOT NULL,
    source character varying NOT NULL,
    type character varying NOT NULL,
    start integer NOT NULL,
    "end" integer NOT NULL,
    strand character(1) NOT NULL,
    id character varying NOT NULL,
    name character varying NOT NULL,
    biotype character varying NOT NULL,
    description character varying,
    version integer,
    genus character varying NOT NULL,
    species character varying NOT NULL
);


ALTER TABLE public.genes OWNER TO bartonlab;

--
-- Name: genetags; Type: TABLE; Schema: public; Owner: bartonlab
--

CREATE TABLE public.genetags (
    id character varying NOT NULL,
    tag character varying NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.genetags OWNER TO bartonlab;

--
-- Name: users; Type: TABLE; Schema: public; Owner: bartonlab
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL,
    confirmationkey character varying,
    timecreated timestamp(0) without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users OWNER TO bartonlab;

--
-- Name: users_experiments; Type: TABLE; Schema: public; Owner: bartonlab
--

CREATE TABLE public.users_experiments (
    user_id integer NOT NULL,
    schema character varying NOT NULL,
    admin boolean DEFAULT false NOT NULL
);


ALTER TABLE public.users_experiments OWNER TO bartonlab;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: bartonlab
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO bartonlab;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bartonlab
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: annotation; Type: TABLE; Schema: tair10; Owner: bartonlab
--

CREATE TABLE tair10.annotation (
    modelname character varying NOT NULL,
    type character varying,
    shortdescription character varying,
    curatorsummary character varying,
    computationaldescription character varying
);


ALTER TABLE tair10.annotation OWNER TO bartonlab;

--
-- Name: control; Type: DEFAULT; Schema: atgenexpress; Owner: bartonlab
--

ALTER TABLE ONLY atgenexpress.samples ALTER COLUMN control SET DEFAULT false;


--
-- Name: internalscale; Type: DEFAULT; Schema: atgenexpress; Owner: bartonlab
--

ALTER TABLE ONLY atgenexpress.samples ALTER COLUMN internalscale SET DEFAULT 1.0;


--
-- Name: control; Type: DEFAULT; Schema: bl2014hat22c; Owner: bartonlab
--

ALTER TABLE ONLY bl2014hat22c.samples ALTER COLUMN control SET DEFAULT false;


--
-- Name: internalscale; Type: DEFAULT; Schema: bl2014hat22c; Owner: bartonlab
--

ALTER TABLE ONLY bl2014hat22c.samples ALTER COLUMN internalscale SET DEFAULT 1.0;


--
-- Name: control; Type: DEFAULT; Schema: bl2014trk11; Owner: bartonlab
--

ALTER TABLE ONLY bl2014trk11.samples ALTER COLUMN control SET DEFAULT false;


--
-- Name: internalscale; Type: DEFAULT; Schema: bl2014trk11; Owner: bartonlab
--

ALTER TABLE ONLY bl2014trk11.samples ALTER COLUMN internalscale SET DEFAULT 1.0;


--
-- Name: control; Type: DEFAULT; Schema: e-mtab-4316; Owner: bartonlab
--

ALTER TABLE ONLY "e-mtab-4316".samples ALTER COLUMN control SET DEFAULT false;


--
-- Name: internalscale; Type: DEFAULT; Schema: e-mtab-4316; Owner: bartonlab
--

ALTER TABLE ONLY "e-mtab-4316".samples ALTER COLUMN internalscale SET DEFAULT 1.0;


--
-- Name: control; Type: DEFAULT; Schema: e-mtab-6123; Owner: bartonlab
--

ALTER TABLE ONLY "e-mtab-6123".samples ALTER COLUMN control SET DEFAULT false;


--
-- Name: internalscale; Type: DEFAULT; Schema: e-mtab-6123; Owner: bartonlab
--

ALTER TABLE ONLY "e-mtab-6123".samples ALTER COLUMN internalscale SET DEFAULT 1.0;


--
-- Name: control; Type: DEFAULT; Schema: fowler1; Owner: bartonlab
--

ALTER TABLE ONLY fowler1.samples ALTER COLUMN control SET DEFAULT false;


--
-- Name: internalscale; Type: DEFAULT; Schema: fowler1; Owner: bartonlab
--

ALTER TABLE ONLY fowler1.samples ALTER COLUMN internalscale SET DEFAULT 1.0;


--
-- Name: control; Type: DEFAULT; Schema: grtiny; Owner: bartonlab
--

ALTER TABLE ONLY grtiny.samples ALTER COLUMN control SET DEFAULT false;


--
-- Name: internalscale; Type: DEFAULT; Schema: grtiny; Owner: bartonlab
--

ALTER TABLE ONLY grtiny.samples ALTER COLUMN internalscale SET DEFAULT 1.0;


--
-- Name: control; Type: DEFAULT; Schema: gse12715; Owner: bartonlab
--

ALTER TABLE ONLY gse12715.samples ALTER COLUMN control SET DEFAULT false;


--
-- Name: internalscale; Type: DEFAULT; Schema: gse12715; Owner: bartonlab
--

ALTER TABLE ONLY gse12715.samples ALTER COLUMN internalscale SET DEFAULT 1.0;


--
-- Name: control; Type: DEFAULT; Schema: gse15613; Owner: bartonlab
--

ALTER TABLE ONLY gse15613.samples ALTER COLUMN control SET DEFAULT false;


--
-- Name: internalscale; Type: DEFAULT; Schema: gse15613; Owner: bartonlab
--

ALTER TABLE ONLY gse15613.samples ALTER COLUMN internalscale SET DEFAULT 1.0;


--
-- Name: control; Type: DEFAULT; Schema: gse22982; Owner: bartonlab
--

ALTER TABLE ONLY gse22982.samples ALTER COLUMN control SET DEFAULT false;


--
-- Name: internalscale; Type: DEFAULT; Schema: gse22982; Owner: bartonlab
--

ALTER TABLE ONLY gse22982.samples ALTER COLUMN internalscale SET DEFAULT 1.0;


--
-- Name: control; Type: DEFAULT; Schema: gse30702; Owner: bartonlab
--

ALTER TABLE ONLY gse30702.samples ALTER COLUMN control SET DEFAULT false;


--
-- Name: internalscale; Type: DEFAULT; Schema: gse30702; Owner: bartonlab
--

ALTER TABLE ONLY gse30702.samples ALTER COLUMN internalscale SET DEFAULT 1.0;


--
-- Name: control; Type: DEFAULT; Schema: gse34241; Owner: bartonlab
--

ALTER TABLE ONLY gse34241.samples ALTER COLUMN control SET DEFAULT false;


--
-- Name: internalscale; Type: DEFAULT; Schema: gse34241; Owner: bartonlab
--

ALTER TABLE ONLY gse34241.samples ALTER COLUMN internalscale SET DEFAULT 1.0;


--
-- Name: control; Type: DEFAULT; Schema: gse43858; Owner: bartonlab
--

ALTER TABLE ONLY gse43858.samples ALTER COLUMN control SET DEFAULT false;


--
-- Name: internalscale; Type: DEFAULT; Schema: gse43858; Owner: bartonlab
--

ALTER TABLE ONLY gse43858.samples ALTER COLUMN internalscale SET DEFAULT 1.0;


--
-- Name: control; Type: DEFAULT; Schema: gse4917; Owner: bartonlab
--

ALTER TABLE ONLY gse4917.samples ALTER COLUMN control SET DEFAULT false;


--
-- Name: internalscale; Type: DEFAULT; Schema: gse4917; Owner: bartonlab
--

ALTER TABLE ONLY gse4917.samples ALTER COLUMN internalscale SET DEFAULT 1.0;


--
-- Name: control; Type: DEFAULT; Schema: gse5629; Owner: bartonlab
--

ALTER TABLE ONLY gse5629.samples ALTER COLUMN control SET DEFAULT false;


--
-- Name: internalscale; Type: DEFAULT; Schema: gse5629; Owner: bartonlab
--

ALTER TABLE ONLY gse5629.samples ALTER COLUMN internalscale SET DEFAULT 1.0;


--
-- Name: control; Type: DEFAULT; Schema: gse5630; Owner: bartonlab
--

ALTER TABLE ONLY gse5630.samples ALTER COLUMN control SET DEFAULT false;


--
-- Name: internalscale; Type: DEFAULT; Schema: gse5630; Owner: bartonlab
--

ALTER TABLE ONLY gse5630.samples ALTER COLUMN internalscale SET DEFAULT 1.0;


--
-- Name: control; Type: DEFAULT; Schema: gse5631; Owner: bartonlab
--

ALTER TABLE ONLY gse5631.samples ALTER COLUMN control SET DEFAULT false;


--
-- Name: internalscale; Type: DEFAULT; Schema: gse5631; Owner: bartonlab
--

ALTER TABLE ONLY gse5631.samples ALTER COLUMN internalscale SET DEFAULT 1.0;


--
-- Name: control; Type: DEFAULT; Schema: gse5632; Owner: bartonlab
--

ALTER TABLE ONLY gse5632.samples ALTER COLUMN control SET DEFAULT false;


--
-- Name: internalscale; Type: DEFAULT; Schema: gse5632; Owner: bartonlab
--

ALTER TABLE ONLY gse5632.samples ALTER COLUMN internalscale SET DEFAULT 1.0;


--
-- Name: control; Type: DEFAULT; Schema: gse5633; Owner: bartonlab
--

ALTER TABLE ONLY gse5633.samples ALTER COLUMN control SET DEFAULT false;


--
-- Name: internalscale; Type: DEFAULT; Schema: gse5633; Owner: bartonlab
--

ALTER TABLE ONLY gse5633.samples ALTER COLUMN internalscale SET DEFAULT 1.0;


--
-- Name: control; Type: DEFAULT; Schema: gse5634; Owner: bartonlab
--

ALTER TABLE ONLY gse5634.samples ALTER COLUMN control SET DEFAULT false;


--
-- Name: internalscale; Type: DEFAULT; Schema: gse5634; Owner: bartonlab
--

ALTER TABLE ONLY gse5634.samples ALTER COLUMN internalscale SET DEFAULT 1.0;


--
-- Name: control; Type: DEFAULT; Schema: gse57953; Owner: bartonlab
--

ALTER TABLE ONLY gse57953.samples ALTER COLUMN control SET DEFAULT false;


--
-- Name: internalscale; Type: DEFAULT; Schema: gse57953; Owner: bartonlab
--

ALTER TABLE ONLY gse57953.samples ALTER COLUMN internalscale SET DEFAULT 1.0;


--
-- Name: control; Type: DEFAULT; Schema: gse607; Owner: bartonlab
--

ALTER TABLE ONLY gse607.samples ALTER COLUMN control SET DEFAULT false;


--
-- Name: internalscale; Type: DEFAULT; Schema: gse607; Owner: bartonlab
--

ALTER TABLE ONLY gse607.samples ALTER COLUMN internalscale SET DEFAULT 1.0;


--
-- Name: control; Type: DEFAULT; Schema: gse70100; Owner: bartonlab
--

ALTER TABLE ONLY gse70100.samples ALTER COLUMN control SET DEFAULT false;


--
-- Name: internalscale; Type: DEFAULT; Schema: gse70100; Owner: bartonlab
--

ALTER TABLE ONLY gse70100.samples ALTER COLUMN internalscale SET DEFAULT 1.0;


--
-- Name: control; Type: DEFAULT; Schema: gse70796; Owner: bartonlab
--

ALTER TABLE ONLY gse70796.samples ALTER COLUMN control SET DEFAULT false;


--
-- Name: internalscale; Type: DEFAULT; Schema: gse70796; Owner: bartonlab
--

ALTER TABLE ONLY gse70796.samples ALTER COLUMN internalscale SET DEFAULT 1.0;


--
-- Name: control; Type: DEFAULT; Schema: nasc592; Owner: bartonlab
--

ALTER TABLE ONLY nasc592.samples ALTER COLUMN control SET DEFAULT false;


--
-- Name: internalscale; Type: DEFAULT; Schema: nasc592; Owner: bartonlab
--

ALTER TABLE ONLY nasc592.samples ALTER COLUMN internalscale SET DEFAULT 1.0;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: bartonlab
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: expression_pkey; Type: CONSTRAINT; Schema: gse15613; Owner: bartonlab
--

ALTER TABLE ONLY gse15613.expression
    ADD CONSTRAINT expression_pkey PRIMARY KEY (id);


--
-- Name: id_pkey; Type: CONSTRAINT; Schema: gse22982; Owner: bartonlab
--

ALTER TABLE ONLY gse22982.expression
    ADD CONSTRAINT id_pkey UNIQUE (id);


--
-- Name: expression_pkey; Type: CONSTRAINT; Schema: gse4917; Owner: bartonlab
--

ALTER TABLE ONLY gse4917.expression
    ADD CONSTRAINT expression_pkey PRIMARY KEY (id);


--
-- Name: affxannot_pkey; Type: CONSTRAINT; Schema: public; Owner: bartonlab
--

ALTER TABLE ONLY public.affxannot
    ADD CONSTRAINT affxannot_pkey PRIMARY KEY (probe_set_id);


--
-- Name: cuffdiffresults_pkey; Type: CONSTRAINT; Schema: public; Owner: bartonlab
--

ALTER TABLE ONLY public.cuffdiffresults
    ADD CONSTRAINT cuffdiffresults_pkey PRIMARY KEY (test_id);


--
-- Name: descores_pkey; Type: CONSTRAINT; Schema: public; Owner: bartonlab
--

ALTER TABLE ONLY public.descores
    ADD CONSTRAINT descores_pkey PRIMARY KEY (id);


--
-- Name: experiments_pkey; Type: CONSTRAINT; Schema: public; Owner: bartonlab
--

ALTER TABLE ONLY public.experiments
    ADD CONSTRAINT experiments_pkey PRIMARY KEY (schema);


--
-- Name: genes_pkey; Type: CONSTRAINT; Schema: public; Owner: bartonlab
--

ALTER TABLE ONLY public.genes
    ADD CONSTRAINT genes_pkey PRIMARY KEY (id);


--
-- Name: users_email_key; Type: CONSTRAINT; Schema: public; Owner: bartonlab
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: bartonlab
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: annotation_pkey; Type: CONSTRAINT; Schema: tair10; Owner: bartonlab
--

ALTER TABLE ONLY tair10.annotation
    ADD CONSTRAINT annotation_pkey PRIMARY KEY (modelname);


--
-- Name: cuffdifftimeresults_idx; Type: INDEX; Schema: bl2014coller; Owner: bartonlab
--

CREATE INDEX cuffdifftimeresults_idx ON bl2014coller.cuffdifftimeresults USING btree (id, condition);


--
-- Name: cuffdifftimeresults_idx; Type: INDEX; Schema: bl2014hat22c; Owner: bartonlab
--

CREATE INDEX cuffdifftimeresults_idx ON bl2014hat22c.cuffdifftimeresults USING btree (id, condition);


--
-- Name: expression_id; Type: INDEX; Schema: bl2014hat22c; Owner: bartonlab
--

CREATE UNIQUE INDEX expression_id ON bl2014hat22c.expression USING btree (id);


--
-- Name: cuffdifftimeresults_idx; Type: INDEX; Schema: bl2014trk11; Owner: bartonlab
--

CREATE INDEX cuffdifftimeresults_idx ON bl2014trk11.cuffdifftimeresults USING btree (id, condition);


--
-- Name: expression_id; Type: INDEX; Schema: bl2014trk11; Owner: bartonlab
--

CREATE UNIQUE INDEX expression_id ON bl2014trk11.expression USING btree (id);


--
-- Name: cuffdifftimeresults_condition; Type: INDEX; Schema: e-mtab-4316; Owner: bartonlab
--

CREATE INDEX cuffdifftimeresults_condition ON "e-mtab-4316".cuffdifftimeresults USING btree (condition);


--
-- Name: cuffdifftimeresults_idx; Type: INDEX; Schema: e-mtab-4316; Owner: bartonlab
--

CREATE INDEX cuffdifftimeresults_idx ON "e-mtab-4316".cuffdifftimeresults USING btree (id, condition);


--
-- Name: cuffdifftimeresults_unique; Type: INDEX; Schema: e-mtab-4316; Owner: bartonlab
--

CREATE UNIQUE INDEX cuffdifftimeresults_unique ON "e-mtab-4316".cuffdifftimeresults USING btree (test_id, condition);


--
-- Name: cuffdifftimeresults_condition; Type: INDEX; Schema: grtiny; Owner: bartonlab
--

CREATE INDEX cuffdifftimeresults_condition ON grtiny.cuffdifftimeresults USING btree (condition);


--
-- Name: cuffdifftimeresults_unique; Type: INDEX; Schema: grtiny; Owner: bartonlab
--

CREATE UNIQUE INDEX cuffdifftimeresults_unique ON grtiny.cuffdifftimeresults USING btree (id, condition);


--
-- Name: limmatimeresults_idx; Type: INDEX; Schema: gse30702; Owner: bartonlab
--

CREATE INDEX limmatimeresults_idx ON gse30702.limmatimeresults USING btree (condition);


--
-- Name: limmatimeresults_unique; Type: INDEX; Schema: gse30702; Owner: bartonlab
--

CREATE UNIQUE INDEX limmatimeresults_unique ON gse30702.limmatimeresults USING btree (id, condition);


--
-- Name: expression_id; Type: INDEX; Schema: gse43858; Owner: bartonlab
--

CREATE UNIQUE INDEX expression_id ON gse43858.expression USING btree (id);


--
-- Name: expression_probe_set_id; Type: INDEX; Schema: gse4917; Owner: bartonlab
--

CREATE UNIQUE INDEX expression_probe_set_id ON gse4917.expression USING btree (probe_set_id);


--
-- Name: cuffdifftimeresults_condition; Type: INDEX; Schema: gse57953; Owner: bartonlab
--

CREATE INDEX cuffdifftimeresults_condition ON gse57953.cuffdifftimeresults USING btree (condition);


--
-- Name: cuffdifftimeresults_idx; Type: INDEX; Schema: gse57953; Owner: bartonlab
--

CREATE INDEX cuffdifftimeresults_idx ON gse57953.cuffdifftimeresults USING btree (id, condition);


--
-- Name: cuffdifftimeresults_unique; Type: INDEX; Schema: gse57953; Owner: bartonlab
--

CREATE UNIQUE INDEX cuffdifftimeresults_unique ON gse57953.cuffdifftimeresults USING btree (id, condition);


--
-- Name: descores_id; Type: INDEX; Schema: gse57953; Owner: bartonlab
--

CREATE INDEX descores_id ON gse57953.descores USING btree (id);


--
-- Name: descores_score; Type: INDEX; Schema: gse57953; Owner: bartonlab
--

CREATE INDEX descores_score ON gse57953.descores USING btree (score);


--
-- Name: cuffdifftimeresults_condition; Type: INDEX; Schema: gse70100; Owner: bartonlab
--

CREATE INDEX cuffdifftimeresults_condition ON gse70100.cuffdifftimeresults USING btree (condition);


--
-- Name: cuffdifftimeresults_idx; Type: INDEX; Schema: gse70100; Owner: bartonlab
--

CREATE INDEX cuffdifftimeresults_idx ON gse70100.cuffdifftimeresults USING btree (id, condition);


--
-- Name: cuffdifftimeresults_unique; Type: INDEX; Schema: gse70100; Owner: bartonlab
--

CREATE UNIQUE INDEX cuffdifftimeresults_unique ON gse70100.cuffdifftimeresults USING btree (id, condition);


--
-- Name: expression_id; Type: INDEX; Schema: gse70100; Owner: bartonlab
--

CREATE UNIQUE INDEX expression_id ON gse70100.expression USING btree (id);


--
-- Name: anovaresults_conditions; Type: INDEX; Schema: gse70796; Owner: bartonlab
--

CREATE INDEX anovaresults_conditions ON gse70796.anovaresults USING btree (conditions);


--
-- Name: anovaresults_id; Type: INDEX; Schema: gse70796; Owner: bartonlab
--

CREATE INDEX anovaresults_id ON gse70796.anovaresults USING btree (id);


--
-- Name: anovaresults_unique; Type: INDEX; Schema: gse70796; Owner: bartonlab
--

CREATE UNIQUE INDEX anovaresults_unique ON gse70796.anovaresults USING btree (id, conditions);


--
-- Name: cuffdiffresults_conditions; Type: INDEX; Schema: gse70796; Owner: bartonlab
--

CREATE INDEX cuffdiffresults_conditions ON gse70796.cuffdiffresults USING btree (sample_1, sample_2);


--
-- Name: cuffdiffresults_id; Type: INDEX; Schema: gse70796; Owner: bartonlab
--

CREATE INDEX cuffdiffresults_id ON gse70796.cuffdiffresults USING btree (id);


--
-- Name: cuffdifftimeresults_condition; Type: INDEX; Schema: gse70796; Owner: bartonlab
--

CREATE INDEX cuffdifftimeresults_condition ON gse70796.cuffdifftimeresults USING btree (condition);


--
-- Name: cuffdifftimeresults_idx; Type: INDEX; Schema: gse70796; Owner: bartonlab
--

CREATE INDEX cuffdifftimeresults_idx ON gse70796.cuffdifftimeresults USING btree (id, condition);


--
-- Name: cuffdifftimeresults_unique; Type: INDEX; Schema: gse70796; Owner: bartonlab
--

CREATE UNIQUE INDEX cuffdifftimeresults_unique ON gse70796.cuffdifftimeresults USING btree (id, condition);


--
-- Name: descores_id; Type: INDEX; Schema: gse70796; Owner: bartonlab
--

CREATE INDEX descores_id ON gse70796.descores USING btree (id);


--
-- Name: descores_score; Type: INDEX; Schema: gse70796; Owner: bartonlab
--

CREATE INDEX descores_score ON gse70796.descores USING btree (score);


--
-- Name: expfitresults_condition; Type: INDEX; Schema: gse70796; Owner: bartonlab
--

CREATE INDEX expfitresults_condition ON gse70796.expfitresults USING btree (condition);


--
-- Name: expfitresults_id; Type: INDEX; Schema: gse70796; Owner: bartonlab
--

CREATE INDEX expfitresults_id ON gse70796.expfitresults USING btree (id);


--
-- Name: expfitresults_unique; Type: INDEX; Schema: gse70796; Owner: bartonlab
--

CREATE UNIQUE INDEX expfitresults_unique ON gse70796.expfitresults USING btree (id, condition);


--
-- Name: expression_id; Type: INDEX; Schema: gse70796; Owner: bartonlab
--

CREATE UNIQUE INDEX expression_id ON gse70796.expression USING btree (id);


--
-- Name: samples_condition; Type: INDEX; Schema: gse70796; Owner: bartonlab
--

CREATE INDEX samples_condition ON gse70796.samples USING btree (condition);


--
-- Name: samples_unique; Type: INDEX; Schema: gse70796; Owner: bartonlab
--

CREATE UNIQUE INDEX samples_unique ON gse70796.samples USING btree (label);


--
-- Name: cuffdifftimeresults_idx; Type: INDEX; Schema: public; Owner: bartonlab
--

CREATE INDEX cuffdifftimeresults_idx ON public.cuffdifftimeresults USING btree (id, condition);


--
-- Name: degexp_condition; Type: INDEX; Schema: public; Owner: bartonlab
--

CREATE INDEX degexp_condition ON public.degexpresults USING btree (basecondition, decondition);


--
-- Name: degexp_unique; Type: INDEX; Schema: public; Owner: bartonlab
--

CREATE UNIQUE INDEX degexp_unique ON public.degexpresults USING btree (id, basecondition, decondition);


--
-- Name: deseq2timeresults_condition; Type: INDEX; Schema: public; Owner: bartonlab
--

CREATE INDEX deseq2timeresults_condition ON public.deseq2timeresults USING btree (condition);


--
-- Name: deseq2timeresults_unique; Type: INDEX; Schema: public; Owner: bartonlab
--

CREATE UNIQUE INDEX deseq2timeresults_unique ON public.deseq2timeresults USING btree (id, condition);


--
-- Name: genealiases_id; Type: INDEX; Schema: public; Owner: bartonlab
--

CREATE INDEX genealiases_id ON public.genealiases USING btree (id);


--
-- Name: genealiases_name; Type: INDEX; Schema: public; Owner: bartonlab
--

CREATE INDEX genealiases_name ON public.genealiases USING btree (name, genus, species);


--
-- Name: genes_name; Type: INDEX; Schema: public; Owner: bartonlab
--

CREATE INDEX genes_name ON public.genes USING btree (genus, species, name);


--
-- Name: genes_species; Type: INDEX; Schema: public; Owner: bartonlab
--

CREATE INDEX genes_species ON public.genes USING btree (genus, species);


--
-- Name: genetags_unique; Type: INDEX; Schema: public; Owner: bartonlab
--

CREATE INDEX genetags_unique ON public.genetags USING btree (id, tag, user_id);


--
-- Name: users_experiments_unique; Type: INDEX; Schema: public; Owner: bartonlab
--

CREATE UNIQUE INDEX users_experiments_unique ON public.users_experiments USING btree (user_id, schema);


--
-- Name: genetags_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bartonlab
--

ALTER TABLE ONLY public.genetags
    ADD CONSTRAINT genetags_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: users_experiments_schema_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bartonlab
--

ALTER TABLE ONLY public.users_experiments
    ADD CONSTRAINT users_experiments_schema_fkey FOREIGN KEY (schema) REFERENCES public.experiments(schema);


--
-- Name: users_experiments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bartonlab
--

ALTER TABLE ONLY public.users_experiments
    ADD CONSTRAINT users_experiments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

