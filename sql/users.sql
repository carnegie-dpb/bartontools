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
-- Name: users; Type: TABLE; Schema: public; Owner: sam; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL
);


ALTER TABLE users OWNER TO sam;

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


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: sam
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: sam
--

COPY users (id, email, password) FROM stdin;
1	shokin@carnegiescience.edu	xenon5416
2	kbarton@stanford.edu	arabidopsis89
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sam
--

SELECT pg_catalog.setval('users_id_seq', 2, true);


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


--
-- PostgreSQL database dump complete
--

