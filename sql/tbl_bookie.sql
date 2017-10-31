--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.5
-- Dumped by pg_dump version 9.6.5

-- Started on 2017-10-31 15:34:04

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- TOC entry 2154 (class 0 OID 16574)
-- Dependencies: 200
-- Data for Name: tbl_bookie; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO tbl_bookie (bookie_id, bookie_name, bookie_account_name, bookie_api_endpoint, bookie_api_key, bookie_type, bookie_commision, bookie_passwd) VALUES (1, 'pinnacle  ', 'CH983245', 'n/a', NULL, 'bookie', 0, NULL);
INSERT INTO tbl_bookie (bookie_id, bookie_name, bookie_account_name, bookie_api_endpoint, bookie_api_key, bookie_type, bookie_commision, bookie_passwd) VALUES (2, 'betbtc    ', 'chrhae', 'http://www.betbtc.co/api', 'b3195c15c9d444a484b2f149f5eff732', 'market', 0.04, NULL);
INSERT INTO tbl_bookie (bookie_id, bookie_name, bookie_account_name, bookie_api_endpoint, bookie_api_key, bookie_type, bookie_commision, bookie_passwd) VALUES (4, 'betfair   ', NULL, NULL, NULL, NULL, 0.05, NULL);
INSERT INTO tbl_bookie (bookie_id, bookie_name, bookie_account_name, bookie_api_endpoint, bookie_api_key, bookie_type, bookie_commision, bookie_passwd) VALUES (3, 'betdaq    ', NULL, NULL, NULL, NULL, 0.02, NULL);
INSERT INTO tbl_bookie (bookie_id, bookie_name, bookie_account_name, bookie_api_endpoint, bookie_api_key, bookie_type, bookie_commision, bookie_passwd) VALUES (5, 'matchbook ', NULL, NULL, NULL, NULL, NULL, NULL);


--
-- TOC entry 2160 (class 0 OID 0)
-- Dependencies: 199
-- Name: tbl_bookie_bookie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('tbl_bookie_bookie_id_seq', 1, true);


-- Completed on 2017-10-31 15:34:04

--
-- PostgreSQL database dump complete
--

