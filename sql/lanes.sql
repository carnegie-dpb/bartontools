--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: lanes; Type: TABLE; Schema: public; Owner: sam; Tablespace: 
--

CREATE TABLE lanes (
    label character varying NOT NULL,
    num integer NOT NULL,
    condition character varying NOT NULL,
    control boolean DEFAULT false NOT NULL,
    "time" double precision
);


ALTER TABLE public.lanes OWNER TO sam;

--
-- Name: lanes_num_seq; Type: SEQUENCE; Schema: public; Owner: sam
--

CREATE SEQUENCE lanes_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lanes_num_seq OWNER TO sam;

--
-- Name: lanes_num_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sam
--

ALTER SEQUENCE lanes_num_seq OWNED BY lanes.num;


--
-- Name: num; Type: DEFAULT; Schema: public; Owner: sam
--

ALTER TABLE ONLY lanes ALTER COLUMN num SET DEFAULT nextval('lanes_num_seq'::regclass);


--
-- Data for Name: lanes; Type: TABLE DATA; Schema: public; Owner: sam
--

COPY lanes (label, num, condition, control, "time") FROM stdin;
Ot7911	1	Col	t	0
Ot7912	2	Col	t	0
Ot7913	3	Col	t	0
Ot8691	4	Col	t	0
Ot8692	5	Col	t	0
Ot8693	6	Col	t	0
Ot7914	7	Col	t	30
Ot7915	8	Col	t	30
Ot7916	9	Col	t	30
OtA0255	10	Col	t	30
OtA0256	11	Col	t	30
Ot8696	12	Col	t	30
Ot7917	13	Col	t	60
Ot7918	14	Col	t	60
Ot7919	15	Col	t	60
Ot8697	16	Col	t	60
Ot8698	17	Col	t	60
Ot8699	18	Col	t	60
Ot7920	19	Col	t	120
Ot7921	20	Col	t	120
Ot7922	21	Col	t	120
OtA0257	22	Col	t	120
OtA0258	23	Col	t	120
OtA0259	24	Col	t	120
Ot7923	25	AS2	f	0
Ot7924	26	AS2	f	0
Ot7925	27	AS2	f	0
Ot7926	28	AS2	f	30
Ot7927	29	AS2	f	30
Ot7928	30	AS2	f	30
Ot7929	31	AS2	f	60
Ot7930	32	AS2	f	60
Ot7931	33	AS2	f	60
Ot7932	34	AS2	f	120
Ot7933	35	AS2	f	120
Ot7934	36	AS2	f	120
Ot7935	37	STM	f	0
Ot7936	38	STM	f	0
Ot7937	39	STM	f	0
Ot7938	40	STM	f	30
Ot7939	41	STM	f	30
Ot7940	42	STM	f	30
Ot7941	43	STM	f	60
Ot7942	44	STM	f	60
Ot7943	45	STM	f	60
Ot7944	46	STM	f	120
Ot7945	47	STM	f	120
Ot7946	48	STM	f	120
Ot7947	49	Rev	f	0
Ot7948	50	Rev	f	0
Ot7949	51	Rev	f	0
Ot7950	52	Rev	f	30
Ot7951	53	Rev	f	30
Ot7952	54	Rev	f	60
Ot7953	55	Rev	f	60
Ot7954	56	Rev	f	60
Ot7955	57	Rev	f	120
Ot7956	58	Rev	f	120
Ot7957	59	Rev	f	120
Ot7958	60	Kan	f	0
Ot7959	61	Kan	f	0
Ot7960	62	Kan	f	0
Ot7961	63	Kan	f	30
Ot7962	64	Kan	f	30
Ot7963	65	Kan	f	30
Ot7964	66	Kan	f	60
Ot7965	67	Kan	f	60
Ot7966	68	Kan	f	60
Ot7967	69	Kan	f	120
Ot7968	70	Kan	f	120
Ot7969	71	Kan	f	120
\.


--
-- Name: lanes_num_seq; Type: SEQUENCE SET; Schema: public; Owner: sam
--

SELECT pg_catalog.setval('lanes_num_seq', 66, true);


--
-- Name: lanes_pkey; Type: CONSTRAINT; Schema: public; Owner: sam; Tablespace: 
--

ALTER TABLE ONLY lanes
    ADD CONSTRAINT lanes_pkey PRIMARY KEY (label);


--
-- PostgreSQL database dump complete
--

