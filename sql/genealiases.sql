--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: genealiases; Type: TABLE; Schema: public; Owner: sam; Tablespace: 
--

CREATE TABLE genealiases (
    locusname character varying NOT NULL,
    symbol character varying NOT NULL,
    fullname character varying
);


ALTER TABLE genealiases OWNER TO sam;

--
-- Data for Name: genealiases; Type: TABLE DATA; Schema: public; Owner: sam
--

COPY genealiases (locusname, symbol, fullname) FROM stdin;
\.


--
-- Name: genealiases_locus; Type: INDEX; Schema: public; Owner: sam; Tablespace: 
--

CREATE INDEX genealiases_locus ON genealiases USING btree (locusname);


--
-- Name: genealiases_symbol; Type: INDEX; Schema: public; Owner: sam; Tablespace: 
--

CREATE INDEX genealiases_symbol ON genealiases USING btree (symbol);


--
-- PostgreSQL database dump complete
--

