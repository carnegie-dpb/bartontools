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

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: limmatimeresults; Type: TABLE; Schema: public; Owner: sam
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


ALTER TABLE public.limmatimeresults OWNER TO sam;

--
-- PostgreSQL database dump complete
--

