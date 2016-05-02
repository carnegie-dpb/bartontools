--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: atgenexpress; Type: SCHEMA; Schema: -; Owner: sam
--

CREATE SCHEMA atgenexpress;


ALTER SCHEMA atgenexpress OWNER TO sam;

--
-- Name: bl2014coller; Type: SCHEMA; Schema: -; Owner: sam
--

CREATE SCHEMA bl2014coller;


ALTER SCHEMA bl2014coller OWNER TO sam;

--
-- Name: bl2014hat22c; Type: SCHEMA; Schema: -; Owner: sam
--

CREATE SCHEMA bl2014hat22c;


ALTER SCHEMA bl2014hat22c OWNER TO sam;

--
-- Name: bl2014trk11; Type: SCHEMA; Schema: -; Owner: sam
--

CREATE SCHEMA bl2014trk11;


ALTER SCHEMA bl2014trk11 OWNER TO sam;

--
-- Name: gse12715; Type: SCHEMA; Schema: -; Owner: sam
--

CREATE SCHEMA gse12715;


ALTER SCHEMA gse12715 OWNER TO sam;

--
-- Name: gse15613; Type: SCHEMA; Schema: -; Owner: sam
--

CREATE SCHEMA gse15613;


ALTER SCHEMA gse15613 OWNER TO sam;

--
-- Name: gse22982; Type: SCHEMA; Schema: -; Owner: sam
--

CREATE SCHEMA gse22982;


ALTER SCHEMA gse22982 OWNER TO sam;

--
-- Name: gse30703; Type: SCHEMA; Schema: -; Owner: sam
--

CREATE SCHEMA gse30703;


ALTER SCHEMA gse30703 OWNER TO sam;

--
-- Name: gse34241; Type: SCHEMA; Schema: -; Owner: sam
--

CREATE SCHEMA gse34241;


ALTER SCHEMA gse34241 OWNER TO sam;

--
-- Name: gse43858; Type: SCHEMA; Schema: -; Owner: sam
--

CREATE SCHEMA gse43858;


ALTER SCHEMA gse43858 OWNER TO sam;

--
-- Name: gse4917; Type: SCHEMA; Schema: -; Owner: sam
--

CREATE SCHEMA gse4917;


ALTER SCHEMA gse4917 OWNER TO sam;

--
-- Name: gse5629; Type: SCHEMA; Schema: -; Owner: sam
--

CREATE SCHEMA gse5629;


ALTER SCHEMA gse5629 OWNER TO sam;

--
-- Name: gse5630; Type: SCHEMA; Schema: -; Owner: sam
--

CREATE SCHEMA gse5630;


ALTER SCHEMA gse5630 OWNER TO sam;

--
-- Name: gse5631; Type: SCHEMA; Schema: -; Owner: sam
--

CREATE SCHEMA gse5631;


ALTER SCHEMA gse5631 OWNER TO sam;

--
-- Name: gse5632; Type: SCHEMA; Schema: -; Owner: sam
--

CREATE SCHEMA gse5632;


ALTER SCHEMA gse5632 OWNER TO sam;

--
-- Name: gse5633; Type: SCHEMA; Schema: -; Owner: sam
--

CREATE SCHEMA gse5633;


ALTER SCHEMA gse5633 OWNER TO sam;

--
-- Name: gse5634; Type: SCHEMA; Schema: -; Owner: sam
--

CREATE SCHEMA gse5634;


ALTER SCHEMA gse5634 OWNER TO sam;

--
-- Name: gse57953; Type: SCHEMA; Schema: -; Owner: sam
--

CREATE SCHEMA gse57953;


ALTER SCHEMA gse57953 OWNER TO sam;

--
-- Name: gse607; Type: SCHEMA; Schema: -; Owner: sam
--

CREATE SCHEMA gse607;


ALTER SCHEMA gse607 OWNER TO sam;

--
-- Name: gse70100; Type: SCHEMA; Schema: -; Owner: sam
--

CREATE SCHEMA gse70100;


ALTER SCHEMA gse70100 OWNER TO sam;

--
-- Name: gse70796; Type: SCHEMA; Schema: -; Owner: sam
--

CREATE SCHEMA gse70796;


ALTER SCHEMA gse70796 OWNER TO sam;

--
-- Name: tair10; Type: SCHEMA; Schema: -; Owner: sam
--

CREATE SCHEMA tair10;


ALTER SCHEMA tair10 OWNER TO sam;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: _final_median(anyarray); Type: FUNCTION; Schema: public; Owner: sam
--

CREATE FUNCTION _final_median(anyarray) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $_$ 
  WITH q AS
  (
     SELECT val
     FROM unnest($1) val
     WHERE VAL IS NOT NULL
     ORDER BY 1
  ),
  cnt AS
  (
    SELECT COUNT(*) AS c FROM q
  )
  SELECT AVG(val)::float8
  FROM 
  (
    SELECT val FROM q
    LIMIT  2 - MOD((SELECT c FROM cnt), 2)
    OFFSET GREATEST(CEIL((SELECT c FROM cnt) / 2.0) - 1,0)  
  ) q2;
$_$;


ALTER FUNCTION public._final_median(anyarray) OWNER TO sam;

--
-- Name: array_avg(double precision[]); Type: FUNCTION; Schema: public; Owner: sam
--

CREATE FUNCTION array_avg(double precision[]) RETURNS double precision
    LANGUAGE sql
    AS $_$
SELECT avg(v) FROM unnest($1) g(v)
$_$;


ALTER FUNCTION public.array_avg(double precision[]) OWNER TO sam;

--
-- Name: median(anyelement); Type: AGGREGATE; Schema: public; Owner: sam
--

CREATE AGGREGATE median(anyelement) (
    SFUNC = array_append,
    STYPE = anyarray,
    INITCOND = '{}',
    FINALFUNC = _final_median
);


ALTER AGGREGATE public.median(anyelement) OWNER TO sam;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: expression; Type: TABLE; Schema: public; Owner: sam; Tablespace: 
--

CREATE TABLE expression (
    id character varying,
    "values" double precision[] NOT NULL,
    probe_set_id character varying
);


ALTER TABLE expression OWNER TO sam;

SET search_path = atgenexpress, pg_catalog;

--
-- Name: expression; Type: TABLE; Schema: atgenexpress; Owner: sam; Tablespace: 
--

CREATE TABLE expression (
)
INHERITS (public.expression);


ALTER TABLE expression OWNER TO sam;

SET search_path = public, pg_catalog;

--
-- Name: samples; Type: TABLE; Schema: public; Owner: sam; Tablespace: 
--

CREATE TABLE samples (
    label character varying NOT NULL,
    num integer NOT NULL,
    condition character varying NOT NULL,
    control boolean DEFAULT false NOT NULL,
    "time" integer,
    comment character varying
);


ALTER TABLE samples OWNER TO sam;

SET search_path = atgenexpress, pg_catalog;

--
-- Name: samples; Type: TABLE; Schema: atgenexpress; Owner: sam; Tablespace: 
--

CREATE TABLE samples (
)
INHERITS (public.samples);


ALTER TABLE samples OWNER TO sam;

SET search_path = public, pg_catalog;

--
-- Name: cuffdifftimeresults; Type: TABLE; Schema: public; Owner: sam; Tablespace: 
--

CREATE TABLE cuffdifftimeresults (
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


ALTER TABLE cuffdifftimeresults OWNER TO sam;

SET search_path = bl2014coller, pg_catalog;

--
-- Name: cuffdifftimeresults; Type: TABLE; Schema: bl2014coller; Owner: sam; Tablespace: 
--

CREATE TABLE cuffdifftimeresults (
)
INHERITS (public.cuffdifftimeresults);


ALTER TABLE cuffdifftimeresults OWNER TO sam;

SET search_path = public, pg_catalog;

--
-- Name: anovaresults; Type: TABLE; Schema: public; Owner: sam; Tablespace: 
--

CREATE TABLE anovaresults (
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


ALTER TABLE anovaresults OWNER TO sam;

SET search_path = bl2014hat22c, pg_catalog;

--
-- Name: anovaresults; Type: TABLE; Schema: bl2014hat22c; Owner: sam; Tablespace: 
--

CREATE TABLE anovaresults (
)
INHERITS (public.anovaresults);


ALTER TABLE anovaresults OWNER TO sam;

--
-- Name: cuffdifftimeresults; Type: TABLE; Schema: bl2014hat22c; Owner: sam; Tablespace: 
--

CREATE TABLE cuffdifftimeresults (
)
INHERITS (public.cuffdifftimeresults);


ALTER TABLE cuffdifftimeresults OWNER TO sam;

--
-- Name: expression; Type: TABLE; Schema: bl2014hat22c; Owner: sam; Tablespace: 
--

CREATE TABLE expression (
)
INHERITS (public.expression);


ALTER TABLE expression OWNER TO sam;

--
-- Name: samples; Type: TABLE; Schema: bl2014hat22c; Owner: sam; Tablespace: 
--

CREATE TABLE samples (
)
INHERITS (public.samples);


ALTER TABLE samples OWNER TO sam;

SET search_path = bl2014trk11, pg_catalog;

--
-- Name: anovaresults; Type: TABLE; Schema: bl2014trk11; Owner: sam; Tablespace: 
--

CREATE TABLE anovaresults (
)
INHERITS (public.anovaresults);


ALTER TABLE anovaresults OWNER TO sam;

--
-- Name: cuffdifftimeresults; Type: TABLE; Schema: bl2014trk11; Owner: sam; Tablespace: 
--

CREATE TABLE cuffdifftimeresults (
)
INHERITS (public.cuffdifftimeresults);


ALTER TABLE cuffdifftimeresults OWNER TO sam;

--
-- Name: expression; Type: TABLE; Schema: bl2014trk11; Owner: sam; Tablespace: 
--

CREATE TABLE expression (
)
INHERITS (public.expression);


ALTER TABLE expression OWNER TO sam;

--
-- Name: samples; Type: TABLE; Schema: bl2014trk11; Owner: sam; Tablespace: 
--

CREATE TABLE samples (
)
INHERITS (public.samples);


ALTER TABLE samples OWNER TO sam;

SET search_path = gse12715, pg_catalog;

--
-- Name: expression; Type: TABLE; Schema: gse12715; Owner: sam; Tablespace: 
--

CREATE TABLE expression (
)
INHERITS (public.expression);


ALTER TABLE expression OWNER TO sam;

--
-- Name: samples; Type: TABLE; Schema: gse12715; Owner: sam; Tablespace: 
--

CREATE TABLE samples (
)
INHERITS (public.samples);


ALTER TABLE samples OWNER TO sam;

SET search_path = gse15613, pg_catalog;

--
-- Name: expression; Type: TABLE; Schema: gse15613; Owner: sam; Tablespace: 
--

CREATE TABLE expression (
)
INHERITS (public.expression);
ALTER TABLE ONLY expression ALTER COLUMN id SET NOT NULL;


ALTER TABLE expression OWNER TO sam;

--
-- Name: samples; Type: TABLE; Schema: gse15613; Owner: sam; Tablespace: 
--

CREATE TABLE samples (
)
INHERITS (public.samples);


ALTER TABLE samples OWNER TO sam;

SET search_path = gse22982, pg_catalog;

--
-- Name: expression; Type: TABLE; Schema: gse22982; Owner: sam; Tablespace: 
--

CREATE TABLE expression (
)
INHERITS (public.expression);
ALTER TABLE ONLY expression ALTER COLUMN id SET NOT NULL;


ALTER TABLE expression OWNER TO sam;

--
-- Name: samples; Type: TABLE; Schema: gse22982; Owner: sam; Tablespace: 
--

CREATE TABLE samples (
)
INHERITS (public.samples);


ALTER TABLE samples OWNER TO sam;

SET search_path = gse30703, pg_catalog;

--
-- Name: anovaresults; Type: TABLE; Schema: gse30703; Owner: sam; Tablespace: 
--

CREATE TABLE anovaresults (
)
INHERITS (public.anovaresults);
ALTER TABLE ONLY anovaresults ALTER COLUMN condition_p_adj SET NOT NULL;
ALTER TABLE ONLY anovaresults ALTER COLUMN condition_time_p_adj SET NOT NULL;


ALTER TABLE anovaresults OWNER TO sam;

SET search_path = public, pg_catalog;

--
-- Name: descores; Type: TABLE; Schema: public; Owner: sam; Tablespace: 
--

CREATE TABLE descores (
    id character varying NOT NULL,
    score character varying NOT NULL
);


ALTER TABLE descores OWNER TO sam;

SET search_path = gse30703, pg_catalog;

--
-- Name: descores; Type: TABLE; Schema: gse30703; Owner: sam; Tablespace: 
--

CREATE TABLE descores (
)
INHERITS (public.descores);


ALTER TABLE descores OWNER TO sam;

--
-- Name: expression; Type: TABLE; Schema: gse30703; Owner: sam; Tablespace: 
--

CREATE TABLE expression (
)
INHERITS (public.expression);


ALTER TABLE expression OWNER TO sam;

SET search_path = public, pg_catalog;

--
-- Name: limmaresults; Type: TABLE; Schema: public; Owner: sam; Tablespace: 
--

CREATE TABLE limmaresults (
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


ALTER TABLE limmaresults OWNER TO sam;

SET search_path = gse30703, pg_catalog;

--
-- Name: limmaresults; Type: TABLE; Schema: gse30703; Owner: sam; Tablespace: 
--

CREATE TABLE limmaresults (
)
INHERITS (public.limmaresults);


ALTER TABLE limmaresults OWNER TO sam;

SET search_path = public, pg_catalog;

--
-- Name: limmatimeresults; Type: TABLE; Schema: public; Owner: sam; Tablespace: 
--

CREATE TABLE limmatimeresults (
    probe_set_id character varying NOT NULL,
    id character varying NOT NULL,
    condition character varying NOT NULL,
    logfc double precision[] NOT NULL,
    aveexpr double precision[] NOT NULL,
    t double precision[] NOT NULL,
    p_value double precision[] NOT NULL,
    q_value double precision[] NOT NULL,
    b double precision[] NOT NULL
);


ALTER TABLE limmatimeresults OWNER TO sam;

SET search_path = gse30703, pg_catalog;

--
-- Name: limmatimeresults; Type: TABLE; Schema: gse30703; Owner: sam; Tablespace: 
--

CREATE TABLE limmatimeresults (
)
INHERITS (public.limmatimeresults);


ALTER TABLE limmatimeresults OWNER TO sam;

--
-- Name: samples; Type: TABLE; Schema: gse30703; Owner: sam; Tablespace: 
--

CREATE TABLE samples (
)
INHERITS (public.samples);


ALTER TABLE samples OWNER TO sam;

SET search_path = gse34241, pg_catalog;

--
-- Name: expression; Type: TABLE; Schema: gse34241; Owner: sam; Tablespace: 
--

CREATE TABLE expression (
)
INHERITS (public.expression);


ALTER TABLE expression OWNER TO sam;

--
-- Name: samples; Type: TABLE; Schema: gse34241; Owner: sam; Tablespace: 
--

CREATE TABLE samples (
)
INHERITS (public.samples);


ALTER TABLE samples OWNER TO sam;

SET search_path = gse43858, pg_catalog;

--
-- Name: expression; Type: TABLE; Schema: gse43858; Owner: sam; Tablespace: 
--

CREATE TABLE expression (
)
INHERITS (public.expression);


ALTER TABLE expression OWNER TO sam;

--
-- Name: samples; Type: TABLE; Schema: gse43858; Owner: sam; Tablespace: 
--

CREATE TABLE samples (
)
INHERITS (public.samples);


ALTER TABLE samples OWNER TO sam;

SET search_path = gse4917, pg_catalog;

--
-- Name: expression; Type: TABLE; Schema: gse4917; Owner: sam; Tablespace: 
--

CREATE TABLE expression (
)
INHERITS (public.expression);
ALTER TABLE ONLY expression ALTER COLUMN id SET NOT NULL;


ALTER TABLE expression OWNER TO sam;

--
-- Name: limmatimeresults; Type: TABLE; Schema: gse4917; Owner: sam; Tablespace: 
--

CREATE TABLE limmatimeresults (
)
INHERITS (public.limmatimeresults);


ALTER TABLE limmatimeresults OWNER TO sam;

--
-- Name: samples; Type: TABLE; Schema: gse4917; Owner: sam; Tablespace: 
--

CREATE TABLE samples (
)
INHERITS (public.samples);


ALTER TABLE samples OWNER TO sam;

SET search_path = gse5629, pg_catalog;

--
-- Name: expression; Type: TABLE; Schema: gse5629; Owner: sam; Tablespace: 
--

CREATE TABLE expression (
)
INHERITS (public.expression);


ALTER TABLE expression OWNER TO sam;

--
-- Name: samples; Type: TABLE; Schema: gse5629; Owner: sam; Tablespace: 
--

CREATE TABLE samples (
)
INHERITS (public.samples);


ALTER TABLE samples OWNER TO sam;

SET search_path = gse5630, pg_catalog;

--
-- Name: expression; Type: TABLE; Schema: gse5630; Owner: sam; Tablespace: 
--

CREATE TABLE expression (
)
INHERITS (public.expression);


ALTER TABLE expression OWNER TO sam;

--
-- Name: samples; Type: TABLE; Schema: gse5630; Owner: sam; Tablespace: 
--

CREATE TABLE samples (
)
INHERITS (public.samples);


ALTER TABLE samples OWNER TO sam;

SET search_path = gse5631, pg_catalog;

--
-- Name: expression; Type: TABLE; Schema: gse5631; Owner: sam; Tablespace: 
--

CREATE TABLE expression (
)
INHERITS (public.expression);


ALTER TABLE expression OWNER TO sam;

--
-- Name: samples; Type: TABLE; Schema: gse5631; Owner: sam; Tablespace: 
--

CREATE TABLE samples (
)
INHERITS (public.samples);


ALTER TABLE samples OWNER TO sam;

SET search_path = gse5632, pg_catalog;

--
-- Name: expression; Type: TABLE; Schema: gse5632; Owner: sam; Tablespace: 
--

CREATE TABLE expression (
)
INHERITS (public.expression);


ALTER TABLE expression OWNER TO sam;

--
-- Name: samples; Type: TABLE; Schema: gse5632; Owner: sam; Tablespace: 
--

CREATE TABLE samples (
)
INHERITS (public.samples);


ALTER TABLE samples OWNER TO sam;

SET search_path = gse5633, pg_catalog;

--
-- Name: expression; Type: TABLE; Schema: gse5633; Owner: sam; Tablespace: 
--

CREATE TABLE expression (
)
INHERITS (public.expression);


ALTER TABLE expression OWNER TO sam;

--
-- Name: samples; Type: TABLE; Schema: gse5633; Owner: sam; Tablespace: 
--

CREATE TABLE samples (
)
INHERITS (public.samples);


ALTER TABLE samples OWNER TO sam;

SET search_path = gse5634, pg_catalog;

--
-- Name: expression; Type: TABLE; Schema: gse5634; Owner: sam; Tablespace: 
--

CREATE TABLE expression (
)
INHERITS (public.expression);


ALTER TABLE expression OWNER TO sam;

--
-- Name: samples; Type: TABLE; Schema: gse5634; Owner: sam; Tablespace: 
--

CREATE TABLE samples (
)
INHERITS (public.samples);


ALTER TABLE samples OWNER TO sam;

SET search_path = gse57953, pg_catalog;

--
-- Name: cuffdifftimeresults; Type: TABLE; Schema: gse57953; Owner: sam; Tablespace: 
--

CREATE TABLE cuffdifftimeresults (
)
INHERITS (public.cuffdifftimeresults);


ALTER TABLE cuffdifftimeresults OWNER TO sam;

--
-- Name: descores; Type: TABLE; Schema: gse57953; Owner: sam; Tablespace: 
--

CREATE TABLE descores (
)
INHERITS (public.descores);


ALTER TABLE descores OWNER TO sam;

--
-- Name: expression; Type: TABLE; Schema: gse57953; Owner: sam; Tablespace: 
--

CREATE TABLE expression (
)
INHERITS (public.expression);


ALTER TABLE expression OWNER TO sam;

--
-- Name: samples; Type: TABLE; Schema: gse57953; Owner: sam; Tablespace: 
--

CREATE TABLE samples (
)
INHERITS (public.samples);


ALTER TABLE samples OWNER TO sam;

SET search_path = gse607, pg_catalog;

--
-- Name: expression; Type: TABLE; Schema: gse607; Owner: sam; Tablespace: 
--

CREATE TABLE expression (
)
INHERITS (public.expression);


ALTER TABLE expression OWNER TO sam;

--
-- Name: samples; Type: TABLE; Schema: gse607; Owner: sam; Tablespace: 
--

CREATE TABLE samples (
)
INHERITS (public.samples);


ALTER TABLE samples OWNER TO sam;

SET search_path = gse70100, pg_catalog;

--
-- Name: anovaresults; Type: TABLE; Schema: gse70100; Owner: sam; Tablespace: 
--

CREATE TABLE anovaresults (
)
INHERITS (public.anovaresults);


ALTER TABLE anovaresults OWNER TO sam;

--
-- Name: cuffdifftimeresults; Type: TABLE; Schema: gse70100; Owner: sam; Tablespace: 
--

CREATE TABLE cuffdifftimeresults (
)
INHERITS (public.cuffdifftimeresults);


ALTER TABLE cuffdifftimeresults OWNER TO sam;

--
-- Name: expression; Type: TABLE; Schema: gse70100; Owner: sam; Tablespace: 
--

CREATE TABLE expression (
)
INHERITS (public.expression);


ALTER TABLE expression OWNER TO sam;

--
-- Name: samples; Type: TABLE; Schema: gse70100; Owner: sam; Tablespace: 
--

CREATE TABLE samples (
)
INHERITS (public.samples);


ALTER TABLE samples OWNER TO sam;

SET search_path = gse70796, pg_catalog;

--
-- Name: anovaresults; Type: TABLE; Schema: gse70796; Owner: sam; Tablespace: 
--

CREATE TABLE anovaresults (
)
INHERITS (public.anovaresults);
ALTER TABLE ONLY anovaresults ALTER COLUMN condition_p_adj SET NOT NULL;
ALTER TABLE ONLY anovaresults ALTER COLUMN condition_time_p_adj SET NOT NULL;


ALTER TABLE anovaresults OWNER TO sam;

SET search_path = public, pg_catalog;

--
-- Name: cuffdiffresults; Type: TABLE; Schema: public; Owner: sam; Tablespace: 
--

CREATE TABLE cuffdiffresults (
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


ALTER TABLE cuffdiffresults OWNER TO sam;

SET search_path = gse70796, pg_catalog;

--
-- Name: cuffdiffresults; Type: TABLE; Schema: gse70796; Owner: sam; Tablespace: 
--

CREATE TABLE cuffdiffresults (
)
INHERITS (public.cuffdiffresults);


ALTER TABLE cuffdiffresults OWNER TO sam;

--
-- Name: cuffdifftimeresults; Type: TABLE; Schema: gse70796; Owner: sam; Tablespace: 
--

CREATE TABLE cuffdifftimeresults (
)
INHERITS (public.cuffdifftimeresults);


ALTER TABLE cuffdifftimeresults OWNER TO sam;

--
-- Name: descores; Type: TABLE; Schema: gse70796; Owner: sam; Tablespace: 
--

CREATE TABLE descores (
)
INHERITS (public.descores);


ALTER TABLE descores OWNER TO sam;

SET search_path = public, pg_catalog;

--
-- Name: expfitresults; Type: TABLE; Schema: public; Owner: sam; Tablespace: 
--

CREATE TABLE expfitresults (
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


ALTER TABLE expfitresults OWNER TO sam;

SET search_path = gse70796, pg_catalog;

--
-- Name: expfitresults; Type: TABLE; Schema: gse70796; Owner: sam; Tablespace: 
--

CREATE TABLE expfitresults (
)
INHERITS (public.expfitresults);


ALTER TABLE expfitresults OWNER TO sam;

--
-- Name: expression; Type: TABLE; Schema: gse70796; Owner: sam; Tablespace: 
--

CREATE TABLE expression (
)
INHERITS (public.expression);


ALTER TABLE expression OWNER TO sam;

--
-- Name: samples; Type: TABLE; Schema: gse70796; Owner: sam; Tablespace: 
--

CREATE TABLE samples (
)
INHERITS (public.samples);


ALTER TABLE samples OWNER TO sam;

SET search_path = public, pg_catalog;

--
-- Name: affxannot; Type: TABLE; Schema: public; Owner: sam; Tablespace: 
--

CREATE TABLE affxannot (
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


ALTER TABLE affxannot OWNER TO sam;

--
-- Name: degexpresults; Type: TABLE; Schema: public; Owner: sam; Tablespace: 
--

CREATE TABLE degexpresults (
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


ALTER TABLE degexpresults OWNER TO sam;

--
-- Name: deseq2results; Type: TABLE; Schema: public; Owner: sam; Tablespace: 
--

CREATE TABLE deseq2results (
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


ALTER TABLE deseq2results OWNER TO sam;

--
-- Name: deseq2timeresults; Type: TABLE; Schema: public; Owner: sam; Tablespace: 
--

CREATE TABLE deseq2timeresults (
    id character varying NOT NULL,
    condition character varying NOT NULL,
    basemean double precision[] NOT NULL,
    logfc double precision[] NOT NULL,
    logfcse double precision[] NOT NULL,
    stat double precision[] NOT NULL,
    pval double precision[] NOT NULL,
    padj double precision[] NOT NULL
);


ALTER TABLE deseq2timeresults OWNER TO sam;

--
-- Name: edgerresults; Type: TABLE; Schema: public; Owner: sam; Tablespace: 
--

CREATE TABLE edgerresults (
    id character varying NOT NULL,
    basecondition character varying NOT NULL,
    decondition character varying NOT NULL,
    logfc double precision NOT NULL,
    logcpm double precision NOT NULL,
    pval double precision NOT NULL,
    fdr double precision NOT NULL
);


ALTER TABLE edgerresults OWNER TO sam;

--
-- Name: edgertimeresults; Type: TABLE; Schema: public; Owner: sam; Tablespace: 
--

CREATE TABLE edgertimeresults (
    id character varying NOT NULL,
    basecondition character varying NOT NULL,
    decondition character varying NOT NULL,
    logfc double precision[] NOT NULL,
    logcpm double precision[] NOT NULL,
    lr double precision[] NOT NULL,
    pval double precision[] NOT NULL,
    fdr double precision[] NOT NULL
);


ALTER TABLE edgertimeresults OWNER TO sam;

--
-- Name: experiments; Type: TABLE; Schema: public; Owner: sam; Tablespace: 
--

CREATE TABLE experiments (
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


ALTER TABLE experiments OWNER TO sam;

--
-- Name: genealiases; Type: TABLE; Schema: public; Owner: sam; Tablespace: 
--

CREATE TABLE genealiases (
    id character varying NOT NULL,
    name character varying NOT NULL,
    fullname character varying,
    genus character varying NOT NULL,
    species character varying NOT NULL
);


ALTER TABLE genealiases OWNER TO sam;

--
-- Name: genes; Type: TABLE; Schema: public; Owner: sam; Tablespace: 
--

CREATE TABLE genes (
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


ALTER TABLE genes OWNER TO sam;

--
-- Name: genetags; Type: TABLE; Schema: public; Owner: sam; Tablespace: 
--

CREATE TABLE genetags (
    id character varying NOT NULL,
    tag character varying NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE genetags OWNER TO sam;

--
-- Name: users; Type: TABLE; Schema: public; Owner: sam; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL,
    confirmationkey character varying,
    timecreated timestamp(0) without time zone DEFAULT now() NOT NULL
);


ALTER TABLE users OWNER TO sam;

--
-- Name: users_experiments; Type: TABLE; Schema: public; Owner: sam; Tablespace: 
--

CREATE TABLE users_experiments (
    user_id integer NOT NULL,
    schema character varying NOT NULL,
    admin boolean DEFAULT false NOT NULL
);


ALTER TABLE users_experiments OWNER TO sam;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: sam
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_seq OWNER TO sam;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sam
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


SET search_path = tair10, pg_catalog;

--
-- Name: annotation; Type: TABLE; Schema: tair10; Owner: sam; Tablespace: 
--

CREATE TABLE annotation (
    modelname character varying NOT NULL,
    type character varying,
    shortdescription character varying,
    curatorsummary character varying,
    computationaldescription character varying
);


ALTER TABLE annotation OWNER TO sam;

SET search_path = atgenexpress, pg_catalog;

--
-- Name: control; Type: DEFAULT; Schema: atgenexpress; Owner: sam
--

ALTER TABLE ONLY samples ALTER COLUMN control SET DEFAULT false;


SET search_path = bl2014hat22c, pg_catalog;

--
-- Name: control; Type: DEFAULT; Schema: bl2014hat22c; Owner: sam
--

ALTER TABLE ONLY samples ALTER COLUMN control SET DEFAULT false;


SET search_path = bl2014trk11, pg_catalog;

--
-- Name: control; Type: DEFAULT; Schema: bl2014trk11; Owner: sam
--

ALTER TABLE ONLY samples ALTER COLUMN control SET DEFAULT false;


SET search_path = gse12715, pg_catalog;

--
-- Name: control; Type: DEFAULT; Schema: gse12715; Owner: sam
--

ALTER TABLE ONLY samples ALTER COLUMN control SET DEFAULT false;


SET search_path = gse15613, pg_catalog;

--
-- Name: control; Type: DEFAULT; Schema: gse15613; Owner: sam
--

ALTER TABLE ONLY samples ALTER COLUMN control SET DEFAULT false;


SET search_path = gse22982, pg_catalog;

--
-- Name: control; Type: DEFAULT; Schema: gse22982; Owner: sam
--

ALTER TABLE ONLY samples ALTER COLUMN control SET DEFAULT false;


SET search_path = gse30703, pg_catalog;

--
-- Name: control; Type: DEFAULT; Schema: gse30703; Owner: sam
--

ALTER TABLE ONLY samples ALTER COLUMN control SET DEFAULT false;


SET search_path = gse34241, pg_catalog;

--
-- Name: control; Type: DEFAULT; Schema: gse34241; Owner: sam
--

ALTER TABLE ONLY samples ALTER COLUMN control SET DEFAULT false;


SET search_path = gse43858, pg_catalog;

--
-- Name: control; Type: DEFAULT; Schema: gse43858; Owner: sam
--

ALTER TABLE ONLY samples ALTER COLUMN control SET DEFAULT false;


SET search_path = gse4917, pg_catalog;

--
-- Name: control; Type: DEFAULT; Schema: gse4917; Owner: sam
--

ALTER TABLE ONLY samples ALTER COLUMN control SET DEFAULT false;


SET search_path = gse5629, pg_catalog;

--
-- Name: control; Type: DEFAULT; Schema: gse5629; Owner: sam
--

ALTER TABLE ONLY samples ALTER COLUMN control SET DEFAULT false;


SET search_path = gse5630, pg_catalog;

--
-- Name: control; Type: DEFAULT; Schema: gse5630; Owner: sam
--

ALTER TABLE ONLY samples ALTER COLUMN control SET DEFAULT false;


SET search_path = gse5631, pg_catalog;

--
-- Name: control; Type: DEFAULT; Schema: gse5631; Owner: sam
--

ALTER TABLE ONLY samples ALTER COLUMN control SET DEFAULT false;


SET search_path = gse5632, pg_catalog;

--
-- Name: control; Type: DEFAULT; Schema: gse5632; Owner: sam
--

ALTER TABLE ONLY samples ALTER COLUMN control SET DEFAULT false;


SET search_path = gse5633, pg_catalog;

--
-- Name: control; Type: DEFAULT; Schema: gse5633; Owner: sam
--

ALTER TABLE ONLY samples ALTER COLUMN control SET DEFAULT false;


SET search_path = gse5634, pg_catalog;

--
-- Name: control; Type: DEFAULT; Schema: gse5634; Owner: sam
--

ALTER TABLE ONLY samples ALTER COLUMN control SET DEFAULT false;


SET search_path = gse57953, pg_catalog;

--
-- Name: control; Type: DEFAULT; Schema: gse57953; Owner: sam
--

ALTER TABLE ONLY samples ALTER COLUMN control SET DEFAULT false;


SET search_path = gse607, pg_catalog;

--
-- Name: control; Type: DEFAULT; Schema: gse607; Owner: sam
--

ALTER TABLE ONLY samples ALTER COLUMN control SET DEFAULT false;


SET search_path = gse70100, pg_catalog;

--
-- Name: control; Type: DEFAULT; Schema: gse70100; Owner: sam
--

ALTER TABLE ONLY samples ALTER COLUMN control SET DEFAULT false;


SET search_path = gse70796, pg_catalog;

--
-- Name: control; Type: DEFAULT; Schema: gse70796; Owner: sam
--

ALTER TABLE ONLY samples ALTER COLUMN control SET DEFAULT false;


SET search_path = public, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: sam
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


SET search_path = gse15613, pg_catalog;

--
-- Name: expression_pkey; Type: CONSTRAINT; Schema: gse15613; Owner: sam; Tablespace: 
--

ALTER TABLE ONLY expression
    ADD CONSTRAINT expression_pkey PRIMARY KEY (id);


SET search_path = gse22982, pg_catalog;

--
-- Name: id_pkey; Type: CONSTRAINT; Schema: gse22982; Owner: sam; Tablespace: 
--

ALTER TABLE ONLY expression
    ADD CONSTRAINT id_pkey UNIQUE (id);


SET search_path = gse30703, pg_catalog;

--
-- Name: samples_num_key; Type: CONSTRAINT; Schema: gse30703; Owner: sam; Tablespace: 
--

ALTER TABLE ONLY samples
    ADD CONSTRAINT samples_num_key UNIQUE (num);


--
-- Name: samples_pkey; Type: CONSTRAINT; Schema: gse30703; Owner: sam; Tablespace: 
--

ALTER TABLE ONLY samples
    ADD CONSTRAINT samples_pkey PRIMARY KEY (label);


SET search_path = gse4917, pg_catalog;

--
-- Name: expression_pkey; Type: CONSTRAINT; Schema: gse4917; Owner: sam; Tablespace: 
--

ALTER TABLE ONLY expression
    ADD CONSTRAINT expression_pkey PRIMARY KEY (id);


SET search_path = public, pg_catalog;

--
-- Name: affxannot_pkey; Type: CONSTRAINT; Schema: public; Owner: sam; Tablespace: 
--

ALTER TABLE ONLY affxannot
    ADD CONSTRAINT affxannot_pkey PRIMARY KEY (probe_set_id);


--
-- Name: cuffdiffresults_pkey; Type: CONSTRAINT; Schema: public; Owner: sam; Tablespace: 
--

ALTER TABLE ONLY cuffdiffresults
    ADD CONSTRAINT cuffdiffresults_pkey PRIMARY KEY (test_id);


--
-- Name: descores_pkey; Type: CONSTRAINT; Schema: public; Owner: sam; Tablespace: 
--

ALTER TABLE ONLY descores
    ADD CONSTRAINT descores_pkey PRIMARY KEY (id);


--
-- Name: experiments_pkey; Type: CONSTRAINT; Schema: public; Owner: sam; Tablespace: 
--

ALTER TABLE ONLY experiments
    ADD CONSTRAINT experiments_pkey PRIMARY KEY (schema);


--
-- Name: genes_pkey; Type: CONSTRAINT; Schema: public; Owner: sam; Tablespace: 
--

ALTER TABLE ONLY genes
    ADD CONSTRAINT genes_pkey PRIMARY KEY (id);


--
-- Name: users_email_key; Type: CONSTRAINT; Schema: public; Owner: sam; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: sam; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


SET search_path = tair10, pg_catalog;

--
-- Name: annotation_pkey; Type: CONSTRAINT; Schema: tair10; Owner: sam; Tablespace: 
--

ALTER TABLE ONLY annotation
    ADD CONSTRAINT annotation_pkey PRIMARY KEY (modelname);


SET search_path = bl2014coller, pg_catalog;

--
-- Name: cuffdifftimeresults_idx; Type: INDEX; Schema: bl2014coller; Owner: sam; Tablespace: 
--

CREATE INDEX cuffdifftimeresults_idx ON cuffdifftimeresults USING btree (id, condition);


SET search_path = bl2014hat22c, pg_catalog;

--
-- Name: cuffdifftimeresults_idx; Type: INDEX; Schema: bl2014hat22c; Owner: sam; Tablespace: 
--

CREATE INDEX cuffdifftimeresults_idx ON cuffdifftimeresults USING btree (id, condition);


--
-- Name: expression_id; Type: INDEX; Schema: bl2014hat22c; Owner: sam; Tablespace: 
--

CREATE UNIQUE INDEX expression_id ON expression USING btree (id);


SET search_path = bl2014trk11, pg_catalog;

--
-- Name: cuffdifftimeresults_idx; Type: INDEX; Schema: bl2014trk11; Owner: sam; Tablespace: 
--

CREATE INDEX cuffdifftimeresults_idx ON cuffdifftimeresults USING btree (id, condition);


--
-- Name: expression_id; Type: INDEX; Schema: bl2014trk11; Owner: sam; Tablespace: 
--

CREATE UNIQUE INDEX expression_id ON expression USING btree (id);


SET search_path = gse30703, pg_catalog;

--
-- Name: anovaresults_conditions; Type: INDEX; Schema: gse30703; Owner: sam; Tablespace: 
--

CREATE INDEX anovaresults_conditions ON anovaresults USING btree (conditions);


--
-- Name: anovaresults_id_conditions; Type: INDEX; Schema: gse30703; Owner: sam; Tablespace: 
--

CREATE INDEX anovaresults_id_conditions ON anovaresults USING btree (id, conditions);


--
-- Name: descores_id; Type: INDEX; Schema: gse30703; Owner: sam; Tablespace: 
--

CREATE INDEX descores_id ON descores USING btree (id);


--
-- Name: descores_score; Type: INDEX; Schema: gse30703; Owner: sam; Tablespace: 
--

CREATE INDEX descores_score ON descores USING btree (score);


--
-- Name: limmaresults_condition; Type: INDEX; Schema: gse30703; Owner: sam; Tablespace: 
--

CREATE INDEX limmaresults_condition ON limmaresults USING btree (basecondition, decondition);


--
-- Name: limmaresults_unique; Type: INDEX; Schema: gse30703; Owner: sam; Tablespace: 
--

CREATE UNIQUE INDEX limmaresults_unique ON limmaresults USING btree (id, basecondition, decondition);


--
-- Name: limmatimeresults_condition; Type: INDEX; Schema: gse30703; Owner: sam; Tablespace: 
--

CREATE INDEX limmatimeresults_condition ON limmatimeresults USING btree (condition);


--
-- Name: limmatimeresults_idx; Type: INDEX; Schema: gse30703; Owner: sam; Tablespace: 
--

CREATE UNIQUE INDEX limmatimeresults_idx ON limmatimeresults USING btree (probe_set_id, condition);


--
-- Name: limmatimeresults_probe_set_id; Type: INDEX; Schema: gse30703; Owner: sam; Tablespace: 
--

CREATE INDEX limmatimeresults_probe_set_id ON limmatimeresults USING btree (probe_set_id);


--
-- Name: limmatimeresults_unique; Type: INDEX; Schema: gse30703; Owner: sam; Tablespace: 
--

CREATE UNIQUE INDEX limmatimeresults_unique ON limmatimeresults USING btree (id, condition);


SET search_path = gse43858, pg_catalog;

--
-- Name: expression_id; Type: INDEX; Schema: gse43858; Owner: sam; Tablespace: 
--

CREATE UNIQUE INDEX expression_id ON expression USING btree (id);


SET search_path = gse4917, pg_catalog;

--
-- Name: expression_probe_set_id; Type: INDEX; Schema: gse4917; Owner: sam; Tablespace: 
--

CREATE UNIQUE INDEX expression_probe_set_id ON expression USING btree (probe_set_id);


--
-- Name: limmatimeresults_condition; Type: INDEX; Schema: gse4917; Owner: sam; Tablespace: 
--

CREATE INDEX limmatimeresults_condition ON limmatimeresults USING btree (condition);


--
-- Name: limmatimeresults_probe_set_id; Type: INDEX; Schema: gse4917; Owner: sam; Tablespace: 
--

CREATE INDEX limmatimeresults_probe_set_id ON limmatimeresults USING btree (probe_set_id);


SET search_path = gse57953, pg_catalog;

--
-- Name: cuffdifftimeresults_condition; Type: INDEX; Schema: gse57953; Owner: sam; Tablespace: 
--

CREATE INDEX cuffdifftimeresults_condition ON cuffdifftimeresults USING btree (condition);


--
-- Name: cuffdifftimeresults_idx; Type: INDEX; Schema: gse57953; Owner: sam; Tablespace: 
--

CREATE INDEX cuffdifftimeresults_idx ON cuffdifftimeresults USING btree (id, condition);


--
-- Name: cuffdifftimeresults_unique; Type: INDEX; Schema: gse57953; Owner: sam; Tablespace: 
--

CREATE UNIQUE INDEX cuffdifftimeresults_unique ON cuffdifftimeresults USING btree (id, condition);


--
-- Name: descores_id; Type: INDEX; Schema: gse57953; Owner: sam; Tablespace: 
--

CREATE INDEX descores_id ON descores USING btree (id);


--
-- Name: descores_score; Type: INDEX; Schema: gse57953; Owner: sam; Tablespace: 
--

CREATE INDEX descores_score ON descores USING btree (score);


SET search_path = gse70100, pg_catalog;

--
-- Name: cuffdifftimeresults_condition; Type: INDEX; Schema: gse70100; Owner: sam; Tablespace: 
--

CREATE INDEX cuffdifftimeresults_condition ON cuffdifftimeresults USING btree (condition);


--
-- Name: cuffdifftimeresults_idx; Type: INDEX; Schema: gse70100; Owner: sam; Tablespace: 
--

CREATE INDEX cuffdifftimeresults_idx ON cuffdifftimeresults USING btree (id, condition);


--
-- Name: cuffdifftimeresults_unique; Type: INDEX; Schema: gse70100; Owner: sam; Tablespace: 
--

CREATE UNIQUE INDEX cuffdifftimeresults_unique ON cuffdifftimeresults USING btree (id, condition);


--
-- Name: expression_id; Type: INDEX; Schema: gse70100; Owner: sam; Tablespace: 
--

CREATE UNIQUE INDEX expression_id ON expression USING btree (id);


SET search_path = gse70796, pg_catalog;

--
-- Name: anovaresults_conditions; Type: INDEX; Schema: gse70796; Owner: sam; Tablespace: 
--

CREATE INDEX anovaresults_conditions ON anovaresults USING btree (conditions);


--
-- Name: anovaresults_id; Type: INDEX; Schema: gse70796; Owner: sam; Tablespace: 
--

CREATE INDEX anovaresults_id ON anovaresults USING btree (id);


--
-- Name: anovaresults_unique; Type: INDEX; Schema: gse70796; Owner: sam; Tablespace: 
--

CREATE UNIQUE INDEX anovaresults_unique ON anovaresults USING btree (id, conditions);


--
-- Name: cuffdiffresults_conditions; Type: INDEX; Schema: gse70796; Owner: sam; Tablespace: 
--

CREATE INDEX cuffdiffresults_conditions ON cuffdiffresults USING btree (sample_1, sample_2);


--
-- Name: cuffdiffresults_id; Type: INDEX; Schema: gse70796; Owner: sam; Tablespace: 
--

CREATE INDEX cuffdiffresults_id ON cuffdiffresults USING btree (id);


--
-- Name: cuffdifftimeresults_condition; Type: INDEX; Schema: gse70796; Owner: sam; Tablespace: 
--

CREATE INDEX cuffdifftimeresults_condition ON cuffdifftimeresults USING btree (condition);


--
-- Name: cuffdifftimeresults_idx; Type: INDEX; Schema: gse70796; Owner: sam; Tablespace: 
--

CREATE INDEX cuffdifftimeresults_idx ON cuffdifftimeresults USING btree (id, condition);


--
-- Name: cuffdifftimeresults_unique; Type: INDEX; Schema: gse70796; Owner: sam; Tablespace: 
--

CREATE UNIQUE INDEX cuffdifftimeresults_unique ON cuffdifftimeresults USING btree (id, condition);


--
-- Name: descores_id; Type: INDEX; Schema: gse70796; Owner: sam; Tablespace: 
--

CREATE INDEX descores_id ON descores USING btree (id);


--
-- Name: descores_score; Type: INDEX; Schema: gse70796; Owner: sam; Tablespace: 
--

CREATE INDEX descores_score ON descores USING btree (score);


--
-- Name: expfitresults_condition; Type: INDEX; Schema: gse70796; Owner: sam; Tablespace: 
--

CREATE INDEX expfitresults_condition ON expfitresults USING btree (condition);


--
-- Name: expfitresults_id; Type: INDEX; Schema: gse70796; Owner: sam; Tablespace: 
--

CREATE INDEX expfitresults_id ON expfitresults USING btree (id);


--
-- Name: expfitresults_unique; Type: INDEX; Schema: gse70796; Owner: sam; Tablespace: 
--

CREATE UNIQUE INDEX expfitresults_unique ON expfitresults USING btree (id, condition);


--
-- Name: expression_id; Type: INDEX; Schema: gse70796; Owner: sam; Tablespace: 
--

CREATE UNIQUE INDEX expression_id ON expression USING btree (id);


--
-- Name: samples_condition; Type: INDEX; Schema: gse70796; Owner: sam; Tablespace: 
--

CREATE INDEX samples_condition ON samples USING btree (condition);


--
-- Name: samples_unique; Type: INDEX; Schema: gse70796; Owner: sam; Tablespace: 
--

CREATE UNIQUE INDEX samples_unique ON samples USING btree (label);


SET search_path = public, pg_catalog;

--
-- Name: cuffdifftimeresults_idx; Type: INDEX; Schema: public; Owner: sam; Tablespace: 
--

CREATE INDEX cuffdifftimeresults_idx ON cuffdifftimeresults USING btree (id, condition);


--
-- Name: degexp_condition; Type: INDEX; Schema: public; Owner: sam; Tablespace: 
--

CREATE INDEX degexp_condition ON degexpresults USING btree (basecondition, decondition);


--
-- Name: degexp_unique; Type: INDEX; Schema: public; Owner: sam; Tablespace: 
--

CREATE UNIQUE INDEX degexp_unique ON degexpresults USING btree (id, basecondition, decondition);


--
-- Name: deseq2timeresults_condition; Type: INDEX; Schema: public; Owner: sam; Tablespace: 
--

CREATE INDEX deseq2timeresults_condition ON deseq2timeresults USING btree (condition);


--
-- Name: deseq2timeresults_unique; Type: INDEX; Schema: public; Owner: sam; Tablespace: 
--

CREATE UNIQUE INDEX deseq2timeresults_unique ON deseq2timeresults USING btree (id, condition);


--
-- Name: genealiases_id; Type: INDEX; Schema: public; Owner: sam; Tablespace: 
--

CREATE INDEX genealiases_id ON genealiases USING btree (id);


--
-- Name: genealiases_name; Type: INDEX; Schema: public; Owner: sam; Tablespace: 
--

CREATE INDEX genealiases_name ON genealiases USING btree (name, genus, species);


--
-- Name: genes_name; Type: INDEX; Schema: public; Owner: sam; Tablespace: 
--

CREATE INDEX genes_name ON genes USING btree (genus, species, name);


--
-- Name: genes_species; Type: INDEX; Schema: public; Owner: sam; Tablespace: 
--

CREATE INDEX genes_species ON genes USING btree (genus, species);


--
-- Name: genetags_unique; Type: INDEX; Schema: public; Owner: sam; Tablespace: 
--

CREATE INDEX genetags_unique ON genetags USING btree (id, tag, user_id);


--
-- Name: users_experiments_unique; Type: INDEX; Schema: public; Owner: sam; Tablespace: 
--

CREATE UNIQUE INDEX users_experiments_unique ON users_experiments USING btree (user_id, schema);


--
-- Name: genetags_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sam
--

ALTER TABLE ONLY genetags
    ADD CONSTRAINT genetags_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: users_experiments_schema_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sam
--

ALTER TABLE ONLY users_experiments
    ADD CONSTRAINT users_experiments_schema_fkey FOREIGN KEY (schema) REFERENCES experiments(schema);


--
-- Name: users_experiments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sam
--

ALTER TABLE ONLY users_experiments
    ADD CONSTRAINT users_experiments_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

