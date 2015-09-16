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
-- Name: users_experiments; Type: TABLE; Schema: public; Owner: sam; Tablespace: 
--

CREATE TABLE users_experiments (
    user_id integer NOT NULL,
    schema character varying NOT NULL,
    admin boolean DEFAULT false NOT NULL
);


ALTER TABLE users_experiments OWNER TO sam;

--
-- Data for Name: users_experiments; Type: TABLE DATA; Schema: public; Owner: sam
--

COPY users_experiments (user_id, schema, admin) FROM stdin;
1	bl2014hat22	t
2	bl2014hat22	f
1	bl2012	t
1	bl2013	t
2	bl2013	f
2	bl2012	f
\.


--
-- Name: users_experiments_unique; Type: INDEX; Schema: public; Owner: sam; Tablespace: 
--

CREATE UNIQUE INDEX users_experiments_unique ON users_experiments USING btree (user_id, schema);


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
-- PostgreSQL database dump complete
--

