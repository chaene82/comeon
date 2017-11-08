--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.5
-- Dumped by pg_dump version 9.6.5

-- Started on 2017-11-08 11:58:05

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- TOC entry 2182 (class 0 OID 16756)
-- Dependencies: 187
-- Data for Name: tbl_bookie; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_bookie (bookie_id, bookie_name, bookie_account_name, bookie_api_endpoint, bookie_api_key, bookie_type, bookie_commision, bookie_passwd, min_balance, max_balance) FROM stdin;
4	betfair   	\N	\N	\N	\N	0.05	\N	\N	\N
3	betdaq    	\N	\N	\N	\N	0.02	\N	\N	\N
5	matchbook 	\N	\N	\N	\N	\N	\N	\N	\N
2	betbtc    	chrhae	http://www.betbtc.co/api	b3195c15c9d444a484b2f149f5eff732	market	0.04	\N	0.5	2
1	pinnacle  	CH983245	n/a	\N	bookie	0	\N	1000	5000
\.


--
-- TOC entry 2188 (class 0 OID 0)
-- Dependencies: 188
-- Name: tbl_bookie_bookie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tennis
--

SELECT pg_catalog.setval('tbl_bookie_bookie_id_seq', 1, true);


-- Completed on 2017-11-08 11:58:05

--
-- PostgreSQL database dump complete
--

