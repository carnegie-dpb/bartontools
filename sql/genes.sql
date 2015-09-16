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
-- Name: genes; Type: TABLE; Schema: public; Owner: sam; Tablespace: 
--

CREATE TABLE genes (
	"seqid" character varying NOT NULL,
	"source" character varying NOT NULL,
	"type" character varying NOT NULL,
	"start" integer NOT NULL,
	"end" integer NOT NULL,
	score character varying NOT NULL,
	strand char NOT NULL,
	phase char NOT NULL,
    id character varying NOT NULL,
    "name" character varying NOT NULL,
    biotype character varying,
    description character varying,
    version integer,
    genus character varying,
    species character varying
);


ALTER TABLE genes OWNER TO sam;

--
-- Name: genes_pkey; Type: CONSTRAINT; Schema: public; Owner: sam; Tablespace: 
--

ALTER TABLE ONLY genes
    ADD CONSTRAINT genes_pkey PRIMARY KEY (id);


--
-- Name: genes_name; Type: INDEX; Schema: public; Owner: sam; Tablespace: 
--

CREATE INDEX genes_name ON genes USING btree (genus,species,name);


--
-- PostgreSQL database dump complete
--

