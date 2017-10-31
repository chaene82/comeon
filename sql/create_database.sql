--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.8
-- Dumped by pg_dump version 9.5.8

-- Started on 2017-10-31 20:57:18 CET

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE tennis;
--
-- TOC entry 2256 (class 1262 OID 57863)
-- Name: tennis; Type: DATABASE; Schema: -; Owner: tennis
--

CREATE DATABASE tennis WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';


ALTER DATABASE tennis OWNER TO tennis;

\connect tennis

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 7 (class 2615 OID 57976)
-- Name: surebot; Type: SCHEMA; Schema: -; Owner: tennis
--

CREATE SCHEMA surebot;


ALTER SCHEMA surebot OWNER TO tennis;

--
-- TOC entry 1 (class 3079 OID 12395)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2259 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 182 (class 1259 OID 57864)
-- Name: tbl_bettyp; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_bettyp (
    bettyp_id integer NOT NULL,
    bettyp_name character(50)
);


ALTER TABLE tbl_bettyp OWNER TO tennis;

--
-- TOC entry 183 (class 1259 OID 57867)
-- Name: tbl_bettyp_bettyp_id_seq; Type: SEQUENCE; Schema: public; Owner: tennis
--

CREATE SEQUENCE tbl_bettyp_bettyp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbl_bettyp_bettyp_id_seq OWNER TO tennis;

--
-- TOC entry 2260 (class 0 OID 0)
-- Dependencies: 183
-- Name: tbl_bettyp_bettyp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_bettyp_bettyp_id_seq OWNED BY tbl_bettyp.bettyp_id;


--
-- TOC entry 184 (class 1259 OID 57869)
-- Name: tbl_bookie; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_bookie (
    bookie_id integer NOT NULL,
    bookie_name character(10),
    bookie_account_name character varying(200),
    bookie_api_endpoint character varying(255),
    bookie_api_key character varying(200),
    bookie_type character varying(20),
    bookie_commision numeric,
    bookie_passwd character varying(20)
);


ALTER TABLE tbl_bookie OWNER TO tennis;

--
-- TOC entry 185 (class 1259 OID 57875)
-- Name: tbl_bookie_bookie_id_seq; Type: SEQUENCE; Schema: public; Owner: tennis
--

CREATE SEQUENCE tbl_bookie_bookie_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbl_bookie_bookie_id_seq OWNER TO tennis;

--
-- TOC entry 2261 (class 0 OID 0)
-- Dependencies: 185
-- Name: tbl_bookie_bookie_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_bookie_bookie_id_seq OWNED BY tbl_bookie.bookie_id;


--
-- TOC entry 199 (class 1259 OID 57974)
-- Name: tbl_event_event_id_seq; Type: SEQUENCE; Schema: public; Owner: tennis
--

CREATE SEQUENCE tbl_event_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbl_event_event_id_seq OWNER TO tennis;

--
-- TOC entry 198 (class 1259 OID 57958)
-- Name: tbl_events; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_events (
    event_id integer DEFAULT nextval('tbl_event_event_id_seq'::regclass) NOT NULL,
    betbtc_event_id bigint,
    pinnacle_event_id bigint,
    betfair_event_id numeric,
    "StartDate" date,
    "Home_player_id" bigint,
    home_player_name character varying(100),
    away_player_id bigint,
    away_player_name character varying(100),
    "Live" integer,
    "LastUpdate" timestamp with time zone,
    "StartDateTime" timestamp with time zone
);


ALTER TABLE tbl_events OWNER TO tennis;

--
-- TOC entry 200 (class 1259 OID 57977)
-- Name: tbl_events_event_id_seq; Type: SEQUENCE; Schema: public; Owner: tennis
--

CREATE SEQUENCE tbl_events_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbl_events_event_id_seq OWNER TO tennis;

--
-- TOC entry 2262 (class 0 OID 0)
-- Dependencies: 200
-- Name: tbl_events_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_events_event_id_seq OWNED BY tbl_events.event_id;


--
-- TOC entry 186 (class 1259 OID 57877)
-- Name: tbl_match; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_match (
    match_id integer NOT NULL,
    tournament_id integer NOT NULL,
    "MatchDate" date,
    "time" character varying(10),
    surface character varying(20),
    player1_id integer NOT NULL,
    player2_id integer NOT NULL,
    winner integer,
    score character(20),
    player1_set1 double precision,
    player2_set1 double precision,
    player1_set2 double precision,
    player2_set2 double precision,
    player1_set3 double precision,
    player2_set3 double precision,
    player1_set4 double precision,
    player2_set4 double precision,
    player1_set5 double precision,
    player2_set5 double precision,
    te_link character varying(100),
    update timestamp with time zone
);


ALTER TABLE tbl_match OWNER TO tennis;

--
-- TOC entry 187 (class 1259 OID 57880)
-- Name: tbl_match_match_id_seq; Type: SEQUENCE; Schema: public; Owner: tennis
--

CREATE SEQUENCE tbl_match_match_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbl_match_match_id_seq OWNER TO tennis;

--
-- TOC entry 2263 (class 0 OID 0)
-- Dependencies: 187
-- Name: tbl_match_match_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_match_match_id_seq OWNED BY tbl_match.match_id;


--
-- TOC entry 188 (class 1259 OID 57882)
-- Name: tbl_odds; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_odds (
    odds_id integer NOT NULL,
    event_id bigint NOT NULL,
    match_id bigint,
    bettyp_id integer NOT NULL,
    bookie_id integer NOT NULL,
    way integer NOT NULL,
    backlay integer NOT NULL,
    odds_update timestamp without time zone,
    odds double precision
);


ALTER TABLE tbl_odds OWNER TO tennis;

--
-- TOC entry 189 (class 1259 OID 57885)
-- Name: tbl_odds_odds_id_seq; Type: SEQUENCE; Schema: public; Owner: tennis
--

CREATE SEQUENCE tbl_odds_odds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbl_odds_odds_id_seq OWNER TO tennis;

--
-- TOC entry 2264 (class 0 OID 0)
-- Dependencies: 189
-- Name: tbl_odds_odds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_odds_odds_id_seq OWNED BY tbl_odds.odds_id;


--
-- TOC entry 190 (class 1259 OID 57890)
-- Name: tbl_rating; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_rating (
    rating_id integer NOT NULL,
    player_id integer NOT NULL,
    "FromDate" date NOT NULL,
    "ToDate" date NOT NULL,
    "SW1YALL" double precision,
    "SW3MALL" double precision,
    "SW1MALL" double precision,
    "SW1YG" double precision,
    "SW1YH" double precision,
    "SW1YC" double precision,
    "ATP" integer
);


ALTER TABLE tbl_rating OWNER TO tennis;

--
-- TOC entry 191 (class 1259 OID 57893)
-- Name: tbl_rating_rating_id_seq; Type: SEQUENCE; Schema: public; Owner: tennis
--

CREATE SEQUENCE tbl_rating_rating_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbl_rating_rating_id_seq OWNER TO tennis;

--
-- TOC entry 2265 (class 0 OID 0)
-- Dependencies: 191
-- Name: tbl_rating_rating_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_rating_rating_id_seq OWNED BY tbl_rating.rating_id;


--
-- TOC entry 192 (class 1259 OID 57895)
-- Name: tbl_sackmann_match; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_sackmann_match (
    index bigint,
    tourney_id text,
    tourney_name text,
    surface text,
    draw_size bigint,
    tourney_level text,
    tourney_date bigint,
    match_num bigint,
    winner_id bigint,
    winner_seed double precision,
    winner_entry text,
    winner_name text,
    winner_hand text,
    winner_ht double precision,
    winner_ioc text,
    winner_age double precision,
    winner_rank double precision,
    winner_rank_points double precision,
    loser_id bigint,
    loser_seed double precision,
    loser_entry text,
    loser_name text,
    loser_hand text,
    loser_ht double precision,
    loser_ioc text,
    loser_age double precision,
    loser_rank double precision,
    loser_rank_points double precision,
    score text,
    best_of bigint,
    round text,
    minutes double precision,
    w_ace double precision,
    w_df double precision,
    w_svpt double precision,
    "w_1stIn" double precision,
    "w_1stWon" double precision,
    "w_2ndWon" double precision,
    "w_SvGms" double precision,
    "w_bpSaved" double precision,
    "w_bpFaced" double precision,
    l_ace double precision,
    l_df double precision,
    l_svpt double precision,
    "l_1stIn" double precision,
    "l_1stWon" double precision,
    "l_2ndWon" double precision,
    "l_SvGms" double precision,
    "l_bpSaved" double precision,
    "l_bpFaced" double precision
);


ALTER TABLE tbl_sackmann_match OWNER TO tennis;

--
-- TOC entry 193 (class 1259 OID 57901)
-- Name: tbl_sackmann_players; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_sackmann_players (
    index bigint,
    id bigint,
    firstname text,
    lastname text,
    plays text,
    dob bigint,
    "IOC" text,
    update timestamp without time zone
);


ALTER TABLE tbl_sackmann_players OWNER TO tennis;

--
-- TOC entry 194 (class 1259 OID 57907)
-- Name: tbl_te_matchlist; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_te_matchlist (
    index bigint,
    "MatchDate" timestamp without time zone,
    away text,
    away_link text,
    away_odds double precision,
    away_result double precision,
    away_score_1 double precision,
    away_score_2 double precision,
    away_score_3 double precision,
    away_score_4 double precision,
    away_score_5 double precision,
    home text,
    home_link text,
    home_odds double precision,
    home_result double precision,
    home_score_1 double precision,
    home_score_2 double precision,
    home_score_3 double precision,
    home_score_4 double precision,
    home_score_5 double precision,
    match_link text,
    "time" text,
    tournament text,
    tournament_link text,
    update timestamp without time zone
);


ALTER TABLE tbl_te_matchlist OWNER TO tennis;

--
-- TOC entry 195 (class 1259 OID 57913)
-- Name: tbl_te_player; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_te_player (
    index bigint,
    etl_date timestamp without time zone,
    player_country text,
    player_dob text,
    player_name text,
    player_plays text,
    player_sex text,
    player_url text,
    update timestamp without time zone
);


ALTER TABLE tbl_te_player OWNER TO tennis;

--
-- TOC entry 196 (class 1259 OID 57922)
-- Name: tbl_tournament; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_tournament (
    tournament_id integer NOT NULL,
    name character(100),
    location character(100),
    category character(50),
    pin_league_id integer,
    te_link character varying(199)
);


ALTER TABLE tbl_tournament OWNER TO tennis;

--
-- TOC entry 197 (class 1259 OID 57925)
-- Name: tbl_tournament_tournament_id_seq; Type: SEQUENCE; Schema: public; Owner: tennis
--

CREATE SEQUENCE tbl_tournament_tournament_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbl_tournament_tournament_id_seq OWNER TO tennis;

--
-- TOC entry 2266 (class 0 OID 0)
-- Dependencies: 197
-- Name: tbl_tournament_tournament_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_tournament_tournament_id_seq OWNED BY tbl_tournament.tournament_id;


SET search_path = surebot, pg_catalog;

--
-- TOC entry 201 (class 1259 OID 57979)
-- Name: tbl_events; Type: TABLE; Schema: surebot; Owner: tennis
--

CREATE TABLE tbl_events (
    event_id bigint NOT NULL,
    betbtc_event_id bigint,
    pinnacle_event_id bigint,
    betfair_event_id numeric,
    "StartDate" timestamp with time zone,
    "Home_player_id" bigint,
    home_player_name character varying(100),
    away_player_id bigint,
    away_player_name character varying(100),
    "Live" integer,
    "LastUpdate" timestamp with time zone
);


ALTER TABLE tbl_events OWNER TO tennis;

SET search_path = public, pg_catalog;

--
-- TOC entry 2085 (class 2604 OID 57968)
-- Name: bettyp_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_bettyp ALTER COLUMN bettyp_id SET DEFAULT nextval('tbl_bettyp_bettyp_id_seq'::regclass);


--
-- TOC entry 2086 (class 2604 OID 57969)
-- Name: bookie_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_bookie ALTER COLUMN bookie_id SET DEFAULT nextval('tbl_bookie_bookie_id_seq'::regclass);


--
-- TOC entry 2087 (class 2604 OID 57970)
-- Name: match_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_match ALTER COLUMN match_id SET DEFAULT nextval('tbl_match_match_id_seq'::regclass);


--
-- TOC entry 2088 (class 2604 OID 57990)
-- Name: odds_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_odds ALTER COLUMN odds_id SET DEFAULT nextval('tbl_odds_odds_id_seq'::regclass);


--
-- TOC entry 2089 (class 2604 OID 57972)
-- Name: rating_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_rating ALTER COLUMN rating_id SET DEFAULT nextval('tbl_rating_rating_id_seq'::regclass);


--
-- TOC entry 2090 (class 2604 OID 57973)
-- Name: tournament_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_tournament ALTER COLUMN tournament_id SET DEFAULT nextval('tbl_tournament_tournament_id_seq'::regclass);


--
-- TOC entry 2232 (class 0 OID 57864)
-- Dependencies: 182
-- Data for Name: tbl_bettyp; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_bettyp (bettyp_id, bettyp_name) FROM stdin;
\.


--
-- TOC entry 2267 (class 0 OID 0)
-- Dependencies: 183
-- Name: tbl_bettyp_bettyp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tennis
--

SELECT pg_catalog.setval('tbl_bettyp_bettyp_id_seq', 1, false);


--
-- TOC entry 2234 (class 0 OID 57869)
-- Dependencies: 184
-- Data for Name: tbl_bookie; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_bookie (bookie_id, bookie_name, bookie_account_name, bookie_api_endpoint, bookie_api_key, bookie_type, bookie_commision, bookie_passwd) FROM stdin;
\.


--
-- TOC entry 2268 (class 0 OID 0)
-- Dependencies: 185
-- Name: tbl_bookie_bookie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tennis
--

SELECT pg_catalog.setval('tbl_bookie_bookie_id_seq', 1, true);


--
-- TOC entry 2269 (class 0 OID 0)
-- Dependencies: 199
-- Name: tbl_event_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tennis
--

SELECT pg_catalog.setval('tbl_event_event_id_seq', 250, true);


--
-- TOC entry 2248 (class 0 OID 57958)
-- Dependencies: 198
-- Data for Name: tbl_events; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_events (event_id, betbtc_event_id, pinnacle_event_id, betfair_event_id, "StartDate", "Home_player_id", home_player_name, away_player_id, away_player_name, "Live", "LastUpdate", "StartDateTime") FROM stdin;
5	480592	\N	1.136266558	2017-10-31	\N	Norrie/Paul	\N	Chaplin/Libietis	\N	2017-10-31 20:23:25.730013+01	2017-10-31 20:15:00+01
6	480601	\N	1.136271139	2017-10-31	\N	Berlocq/Kestelboim	\N	Balazs/Behar	\N	2017-10-31 20:23:25.730013+01	2017-10-31 20:18:00+01
8	481195	\N	1.136278218	2017-11-01	\N	Banes/Van Peperzeel	\N	Polmans/Statham	\N	2017-10-31 20:23:25.730013+01	2017-11-01 05:30:00+01
9	\N	781251320	\N	2017-11-01	\N	R Klaasen / R Ram	\N	F Lopez / M Lopez	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
10	\N	781251322	\N	2017-11-01	\N	S Gonzalez / J Peralta	\N	J-J Rojer / H Tecau	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
11	\N	781251323	\N	2017-11-01	\N	D Schwartzman / F Verdasco	\N	I Dodig / M Granollers	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
12	\N	781498695	\N	2017-11-01	\N	H Kontinen / J Peers	\N	N Monroe / J Sock	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
13	\N	781542797	\N	2017-11-01	\N	J S Cabal / R Farah	\N	P-H Herbert / N Mahut	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
14	\N	781556486	\N	2017-11-01	\N	R Gasquet / L Pouille	\N	L Kubot / M Melo	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
15	\N	781573297	\N	2017-11-01	\N	B Bryan / M Bryan	\N	J Benneteau / E Roger-Vasselin	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
16	\N	748129668	\N	2017-07-30	\N	Ryan Haviland Game 9 of Set 1	\N	Trey Yates Game 9 of Set 1	1	2017-10-31 20:24:10.390842+01	2017-07-30 16:10:46+02
17	\N	748122980	\N	2017-07-30	\N	Ryan Haviland To Win Set 1	\N	Trey Yates To Win Set 1	1	2017-10-31 20:24:10.390842+01	2017-07-30 16:10:46+02
18	\N	748122958	\N	2017-07-30	\N	Ryan Haviland To Win Set 2	\N	Trey Yates To Win Set 2	1	2017-10-31 20:24:10.390842+01	2017-07-30 16:10:46+02
19	\N	748126924	\N	2017-07-30	\N	Ryan Haviland Game 6 of Set 1	\N	Trey Yates Game 6 of Set 1	1	2017-10-31 20:24:10.390842+01	2017-07-30 16:10:46+02
20	\N	748127585	\N	2017-07-30	\N	Ryan Haviland Game 8 of Set 1	\N	Trey Yates Game 8 of Set 1	1	2017-10-31 20:24:10.390842+01	2017-07-30 16:10:46+02
21	\N	748127222	\N	2017-07-30	\N	Ryan Haviland Game 7 of Set 1	\N	Trey Yates Game 7 of Set 1	1	2017-10-31 20:24:10.390842+01	2017-07-30 16:10:46+02
22	\N	748130443	\N	2017-07-30	\N	Ryan Haviland Game 10 of Set 1	\N	Trey Yates Game 10 of Set 1	1	2017-10-31 20:24:10.390842+01	2017-07-30 16:10:46+02
23	\N	698657478	\N	2017-03-01	\N	A Barty / C Dellacqua	\N	M Irigoyen / P Kania	0	2017-10-31 20:24:10.390842+01	2017-03-01 08:00:00+01
24	\N	781125278	\N	2017-10-31	\N	Francesca Di Lorenzo	\N	Bibiane Schoofs	0	2017-10-31 20:24:10.390842+01	2017-10-31 17:45:00+01
25	\N	781125334	\N	2017-10-31	\N	Maria Sanchez	\N	Patty Schnyder	0	2017-10-31 20:24:10.390842+01	2017-10-31 17:00:00+01
26	\N	781125234	\N	2017-10-31	\N	Greta Arn	\N	Jovana Jaksic	0	2017-10-31 20:24:10.390842+01	2017-10-31 17:45:00+01
27	\N	781125281	\N	2017-10-31	\N	Amra Sadikovic	\N	Katherine Sebov	0	2017-10-31 20:24:10.390842+01	2017-10-31 17:45:00+01
28	\N	781331013	\N	2017-10-31	\N	Bianca Vanessa Andreescu	\N	Safiya Carrington	0	2017-10-31 20:24:10.390842+01	2017-10-31 17:00:00+01
29	\N	781331046	\N	2017-10-31	\N	Petra Januskova	\N	Elena Bovina	0	2017-10-31 20:24:10.390842+01	2017-10-31 21:00:00+01
30	\N	781129898	\N	2017-11-01	\N	Olga Ianchuk	\N	Irina Ramialison	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
31	\N	781129895	\N	2017-11-01	\N	Lesley Kerkhove	\N	Anastasia Frolova	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
32	\N	781129933	\N	2017-11-01	\N	Alice Rame	\N	Conny Perrin	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
33	\N	781128230	\N	2017-10-31	\N	Chloe Paquet	\N	Jesika Maleckova	0	2017-10-31 20:24:10.390842+01	2017-10-31 19:00:00+01
34	\N	781130018	\N	2017-11-01	\N	Alina Silich	\N	Jana Cepelova	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
7	479359	779919424	1.136219938	2017-10-31	\N	Sasi Kumar Mukund	\N	John Millman	0	2017-10-31 20:24:10.390842+01	2017-11-01 00:00:00+01
36	\N	737867067	\N	2017-06-19	\N	Donald Young	\N	Nick Kyrgios	1	2017-10-31 20:24:10.390842+01	2017-06-19 17:00:00+02
37	\N	775332397	\N	2017-10-17	\N	E Mertens / D Schuurs	\N	N Dzalamidze / X Knoll	0	2017-10-31 20:24:10.390842+01	2017-10-17 11:00:00+02
38	\N	775332650	\N	2017-10-17	\N	M Buzarnescu / O Kalashnikova	\N	S Aoyama / Z Yang	0	2017-10-31 20:24:10.390842+01	2017-10-17 11:00:00+02
39	\N	682422212	\N	2017-01-12	\N	Aliaksandra Sasnovich Game 8 of Set 3	\N	Paula Cristina Goncalves Game 8 of Set 3	1	2017-10-31 20:24:10.390842+01	2017-01-13 00:40:00+01
40	\N	682421658	\N	2017-01-12	\N	Aliaksandra Sasnovich Game 7 of Set 3	\N	Paula Cristina Goncalves Game 7 of Set 3	1	2017-10-31 20:24:10.390842+01	2017-01-13 00:40:00+01
42	\N	781062006	\N	2017-10-31	\N	Juan Pablo Ficovich	\N	Gerald Melzer	0	2017-10-31 20:24:10.390842+01	2017-10-31 22:00:00+01
44	\N	781062008	\N	2017-10-31	\N	Dimitar Kuzmanov	\N	Nicolas Kicker	0	2017-10-31 20:24:10.390842+01	2017-10-31 22:00:00+01
45	\N	780541521	\N	2017-10-31	\N	Gastao Elias	\N	Jozef Kovalik	0	2017-10-31 20:24:10.390842+01	2017-11-01 00:00:00+01
46	\N	780541516	\N	2017-11-01	\N	Victor Estrella Burgos	\N	Emilio Gomez	0	2017-10-31 20:24:10.390842+01	2017-11-01 02:00:00+01
48	\N	781540226	\N	2017-10-31	\N	Guido Andreozzi	\N	Roberto Carballes Baena	1	2017-10-31 20:24:10.390842+01	2017-10-31 18:30:00+01
47	\N	781541625	\N	2017-10-31	\N	Joao Domingues	\N	Goncalo Oliveira	1	2017-10-31 20:24:10.390842+01	2017-10-31 18:30:00+01
41	\N	781561413	\N	2017-10-31	\N	Gonzalo Lama	\N	Juan Pablo Varillas	1	2017-10-31 20:24:10.390842+01	2017-10-31 20:00:00+01
52	\N	781563345	\N	2017-10-31	\N	Gonzalo Lama To Win Set 1	\N	Juan Pablo Varillas To Win Set 1	1	2017-10-31 20:24:10.390842+01	2017-10-31 20:00:00+01
53	\N	781563369	\N	2017-10-31	\N	Gonzalo Lama To Win Set 2	\N	Juan Pablo Varillas To Win Set 2	1	2017-10-31 20:24:10.390842+01	2017-10-31 20:00:00+01
54	\N	781569810	\N	2017-10-31	\N	Joao Domingues Game 7 of Set 3	\N	Goncalo Oliveira Game 7 of Set 3	1	2017-10-31 20:24:10.390842+01	2017-10-31 18:30:00+01
55	\N	781570787	\N	2017-10-31	\N	Gonzalo Lama Game 9 of Set 1	\N	Juan Pablo Varillas Game 9 of Set 1	1	2017-10-31 20:24:10.390842+01	2017-10-31 20:00:00+01
56	\N	781571075	\N	2017-10-31	\N	Guido Andreozzi Game 5 of Set 3	\N	Roberto Carballes Baena Game 5 of Set 3	1	2017-10-31 20:24:10.390842+01	2017-10-31 18:30:00+01
57	\N	781572451	\N	2017-10-31	\N	Gonzalo Lama Game 10 of Set 1	\N	Juan Pablo Varillas Game 10 of Set 1	1	2017-10-31 20:24:10.390842+01	2017-10-31 20:00:00+01
43	\N	781572857	\N	2017-10-31	\N	Andrea Collarini	\N	Martin Cuevas	1	2017-10-31 20:24:10.390842+01	2017-10-31 20:30:00+01
59	\N	781572867	\N	2017-10-31	\N	Joao Domingues Game 8 of Set 3	\N	Goncalo Oliveira Game 8 of Set 3	1	2017-10-31 20:24:10.390842+01	2017-10-31 18:30:00+01
60	\N	781573230	\N	2017-10-31	\N	Guido Andreozzi Game 6 of Set 3	\N	Roberto Carballes Baena Game 6 of Set 3	1	2017-10-31 20:24:10.390842+01	2017-10-31 18:30:00+01
61	\N	781573347	\N	2017-10-31	\N	Andrea Collarini Game 2 of Set 1	\N	Martin Cuevas Game 2 of Set 1	1	2017-10-31 20:24:10.390842+01	2017-10-31 20:30:00+01
62	\N	781573348	\N	2017-10-31	\N	Andrea Collarini To Win Set 1	\N	Martin Cuevas To Win Set 1	1	2017-10-31 20:24:10.390842+01	2017-10-31 20:30:00+01
63	\N	781573352	\N	2017-10-31	\N	Andrea Collarini To Win Set 2	\N	Martin Cuevas To Win Set 2	1	2017-10-31 20:24:10.390842+01	2017-10-31 20:30:00+01
64	\N	781573353	\N	2017-10-31	\N	Andrea Collarini Game 3 of Set 1	\N	Martin Cuevas Game 3 of Set 1	1	2017-10-31 20:24:10.390842+01	2017-10-31 20:30:00+01
65	\N	781573386	\N	2017-10-31	\N	Joao Domingues Game 9 of Set 3	\N	Goncalo Oliveira Game 9 of Set 3	1	2017-10-31 20:24:10.390842+01	2017-10-31 18:30:00+01
66	\N	781573482	\N	2017-10-31	\N	Gonzalo Lama Game 11 of Set 1	\N	Juan Pablo Varillas Game 11 of Set 1	1	2017-10-31 20:24:10.390842+01	2017-10-31 20:00:00+01
67	\N	781574252	\N	2017-10-31	\N	Guido Andreozzi Game 7 of Set 3	\N	Roberto Carballes Baena Game 7 of Set 3	1	2017-10-31 20:24:10.390842+01	2017-10-31 18:30:00+01
68	\N	781574762	\N	2017-10-31	\N	Gonzalo Lama Game 12 of Set 1	\N	Juan Pablo Varillas Game 12 of Set 1	1	2017-10-31 20:24:10.390842+01	2017-10-31 20:00:00+01
69	\N	781574845	\N	2017-10-31	\N	Andrea Collarini Game 4 of Set 1	\N	Martin Cuevas Game 4 of Set 1	1	2017-10-31 20:24:10.390842+01	2017-10-31 20:30:00+01
70	\N	781575365	\N	2017-10-31	\N	Guido Andreozzi Game 8 of Set 3	\N	Roberto Carballes Baena Game 8 of Set 3	1	2017-10-31 20:24:10.390842+01	2017-10-31 18:30:00+01
71	\N	781575409	\N	2017-10-31	\N	Joao Domingues Game 10 of Set 3	\N	Goncalo Oliveira Game 10 of Set 3	1	2017-10-31 20:24:10.390842+01	2017-10-31 18:30:00+01
72	\N	781575502	\N	2017-10-31	\N	Gonzalo Lama Game 13 of Set 1	\N	Juan Pablo Varillas Game 13 of Set 1	1	2017-10-31 20:24:10.390842+01	2017-10-31 20:00:00+01
73	\N	781576445	\N	2017-10-31	\N	Andrea Collarini Game 5 of Set 1	\N	Martin Cuevas Game 5 of Set 1	1	2017-10-31 20:24:10.390842+01	2017-10-31 20:30:00+01
74	\N	781576526	\N	2017-10-31	\N	Joao Domingues Game 11 of Set 3	\N	Goncalo Oliveira Game 11 of Set 3	1	2017-10-31 20:24:10.390842+01	2017-10-31 18:30:00+01
75	\N	781577250	\N	2017-10-31	\N	Andrea Collarini Game 6 of Set 1	\N	Martin Cuevas Game 6 of Set 1	1	2017-10-31 20:24:10.390842+01	2017-10-31 20:30:00+01
76	\N	781577260	\N	2017-10-31	\N	Guido Andreozzi Game 9 of Set 3	\N	Roberto Carballes Baena Game 9 of Set 3	1	2017-10-31 20:24:10.390842+01	2017-10-31 18:30:00+01
77	\N	781124857	\N	2017-10-31	\N	Olivia Tjandramulia	\N	Kimberly Birrell	0	2017-10-31 20:24:10.390842+01	2017-10-31 23:05:00+01
78	\N	781123806	\N	2017-11-01	\N	Jennifer Elie	\N	Isabelle Wallace	0	2017-10-31 20:24:10.390842+01	2017-11-01 01:05:00+01
79	\N	781124876	\N	2017-11-01	\N	Olivia Rogowska	\N	Mai Minokoshi	0	2017-10-31 20:24:10.390842+01	2017-11-01 01:05:00+01
80	\N	781124938	\N	2017-11-01	\N	Tammi Patterson	\N	Lizette Cabrera	0	2017-10-31 20:24:10.390842+01	2017-11-01 01:50:00+01
81	\N	781124930	\N	2017-10-31	\N	Sara Tomic	\N	Julia Glushko	0	2017-10-31 20:24:10.390842+01	2017-11-01 00:00:00+01
82	\N	781124865	\N	2017-10-31	\N	Astra Sharma	\N	Tamara Zidansek	0	2017-10-31 20:24:10.390842+01	2017-11-01 00:00:00+01
83	\N	781124902	\N	2017-10-31	\N	Ellen Perez	\N	Asia Muhammad	0	2017-10-31 20:24:10.390842+01	2017-11-01 00:00:00+01
84	\N	781124922	\N	2017-10-31	\N	Erika Sema	\N	Naiktha Bains	0	2017-10-31 20:24:10.390842+01	2017-10-31 23:05:00+01
85	\N	781124884	\N	2017-11-01	\N	Alize Lim	\N	Zoe Hives	0	2017-10-31 20:24:10.390842+01	2017-11-01 01:50:00+01
86	\N	781423005	\N	2017-10-31	\N	Arina Rodionova	\N	Priscilla Hon	0	2017-10-31 20:24:10.390842+01	2017-11-01 00:00:00+01
87	\N	781423133	\N	2017-11-01	\N	Ramu Ueda	\N	Alison Bai	0	2017-10-31 20:24:10.390842+01	2017-11-01 01:50:00+01
88	\N	781423440	\N	2017-10-31	\N	Kaylah Mcphee	\N	Maddison Inglis	0	2017-10-31 20:24:10.390842+01	2017-10-31 23:05:00+01
89	\N	781423508	\N	2017-10-31	\N	Destanee Aiava	\N	Masa Jovanovic	0	2017-10-31 20:24:10.390842+01	2017-10-31 23:05:00+01
90	\N	780538333	\N	2017-11-01	\N	Stefan Kozlov	\N	Thai-Son Kwiatkowski	0	2017-10-31 20:24:10.390842+01	2017-11-01 01:00:00+01
91	\N	780538339	\N	2017-10-31	\N	Denis Kudla	\N	JC Aragone	0	2017-10-31 20:24:10.390842+01	2017-10-31 23:00:00+01
92	\N	781321301	\N	2017-10-31	\N	Neil Pauffley	\N	Ruan Roelofse	0	2017-10-31 20:24:10.390842+01	2017-10-31 23:00:00+01
94	\N	781321304	\N	2017-11-01	\N	Liam Broady	\N	Jared Hiltzik	0	2017-10-31 20:24:10.390842+01	2017-11-01 01:00:00+01
93	\N	781549794	\N	2017-10-31	\N	Bjorn Fratangelo	\N	Frederik Nielsen	1	2017-10-31 20:24:10.390842+01	2017-10-31 19:15:00+01
97	\N	781552137	\N	2017-10-31	\N	Bjorn Fratangelo To Win Set 2	\N	Frederik Nielsen To Win Set 2	1	2017-10-31 20:24:10.390842+01	2017-10-31 19:15:00+01
95	\N	781565245	\N	2017-10-31	\N	Edward Corrie	\N	Filip Peliwo	1	2017-10-31 20:24:10.390842+01	2017-10-31 21:00:00+01
99	\N	781565483	\N	2017-10-31	\N	Edward Corrie To Win Set 2	\N	Filip Peliwo To Win Set 2	1	2017-10-31 20:24:10.390842+01	2017-10-31 21:00:00+01
100	\N	781573324	\N	2017-10-31	\N	Bjorn Fratangelo Game 9 of Set 2	\N	Frederik Nielsen Game 9 of Set 2	1	2017-10-31 20:24:10.390842+01	2017-10-31 19:15:00+01
101	\N	781574166	\N	2017-10-31	\N	Bjorn Fratangelo Game 10 of Set 2	\N	Frederik Nielsen Game 10 of Set 2	1	2017-10-31 20:24:10.390842+01	2017-10-31 19:15:00+01
102	\N	781574778	\N	2017-10-31	\N	Bjorn Fratangelo Game 11 of Set 2	\N	Frederik Nielsen Game 11 of Set 2	1	2017-10-31 20:24:10.390842+01	2017-10-31 19:15:00+01
103	\N	781575803	\N	2017-10-31	\N	Bjorn Fratangelo Game 12 of Set 2	\N	Frederik Nielsen Game 12 of Set 2	1	2017-10-31 20:24:10.390842+01	2017-10-31 19:15:00+01
104	\N	781576781	\N	2017-10-31	\N	Bjorn Fratangelo Game 13 of Set 2	\N	Frederik Nielsen Game 13 of Set 2	1	2017-10-31 20:24:10.390842+01	2017-10-31 19:15:00+01
105	\N	781577049	\N	2017-10-31	\N	Edward Corrie Game 1 of Set 2	\N	Filip Peliwo Game 1 of Set 2	1	2017-10-31 20:24:10.390842+01	2017-10-31 21:00:00+01
106	\N	781577050	\N	2017-10-31	\N	Edward Corrie Game 2 of Set 2	\N	Filip Peliwo Game 2 of Set 2	1	2017-10-31 20:24:10.390842+01	2017-10-31 21:00:00+01
107	\N	684072620	\N	2017-01-17	\N	Omar Jasika Game 10 of Set 1	\N	David Ferrer Game 10 of Set 1	1	2017-10-31 20:24:10.390842+01	2017-01-17 08:30:00+01
108	\N	780541528	\N	2017-11-01	\N	Lukas Lacko	\N	Corentin Moutet	0	2017-10-31 20:24:10.390842+01	2017-11-01 11:00:00+01
109	\N	780541530	\N	2017-11-01	\N	Felix Auger Alliassime	\N	Jerzy Janowicz	0	2017-10-31 20:24:10.390842+01	2017-11-01 11:00:00+01
110	\N	781540973	\N	2017-10-31	\N	Mathias Bourgue	\N	Maximilian Marterer	1	2017-10-31 20:24:10.390842+01	2017-10-31 19:00:00+01
112	\N	781573875	\N	2017-10-31	\N	Mathias Bourgue Game 6 of Set 3	\N	Maximilian Marterer Game 6 of Set 3	1	2017-10-31 20:24:10.390842+01	2017-10-31 19:00:00+01
113	\N	781574471	\N	2017-10-31	\N	Mathias Bourgue Game 7 of Set 3	\N	Maximilian Marterer Game 7 of Set 3	1	2017-10-31 20:24:10.390842+01	2017-10-31 19:00:00+01
114	\N	781576003	\N	2017-10-31	\N	Mathias Bourgue Game 8 of Set 3	\N	Maximilian Marterer Game 8 of Set 3	1	2017-10-31 20:24:10.390842+01	2017-10-31 19:00:00+01
115	\N	781576639	\N	2017-10-31	\N	Mathias Bourgue Game 9 of Set 3	\N	Maximilian Marterer Game 9 of Set 3	1	2017-10-31 20:24:10.390842+01	2017-10-31 19:00:00+01
116	\N	781577320	\N	2017-10-31	\N	Mathias Bourgue Game 10 of Set 3	\N	Maximilian Marterer Game 10 of Set 3	1	2017-10-31 20:24:10.390842+01	2017-10-31 19:00:00+01
117	\N	754104456	\N	2017-08-19	\N	Julia Elbaba Game 1 of Set 2	\N	Kurumi Nara Game 1 of Set 2	1	2017-10-31 20:24:10.390842+01	2017-08-19 18:00:00+02
118	\N	713525349	\N	2017-04-13	\N	R Haase / G Smits	\N	T Berdych / R Bopanna	0	2017-10-31 20:24:10.390842+01	2017-04-13 08:28:00+02
119	\N	683762536	\N	2017-01-16	\N	Stefanie Voegele Game 9 of Set 2	\N	Kurumi Nara Game 9 of Set 2	1	2017-10-31 20:24:10.390842+01	2017-01-16 06:00:00+01
120	\N	781184966	\N	2017-10-31	\N	Dominic Thiem	\N	Peter Gojowczyk	0	2017-10-31 20:24:10.390842+01	2017-10-31 21:30:00+01
121	\N	781184967	\N	2017-11-01	\N	Alexander Zverev	\N	Robin Haase	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
122	\N	781185055	\N	2017-11-01	\N	Alexander Zverev (+1.5 Sets)	\N	Robin Haase (-1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
123	\N	781185074	\N	2017-11-01	\N	Alexander Zverev (-1.5 Sets)	\N	Robin Haase (+1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
124	\N	781185082	\N	2017-10-31	\N	Dominic Thiem (+1.5 Sets)	\N	Peter Gojowczyk (-1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-10-31 21:30:00+01
125	\N	781185100	\N	2017-10-31	\N	Dominic Thiem (-1.5 Sets)	\N	Peter Gojowczyk (+1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-10-31 21:30:00+01
127	\N	781190209	\N	2017-10-31	\N	Nicolas Mahut (+1.5 Sets)	\N	Pablo Carreno-Busta (-1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-10-31 20:00:00+01
128	\N	781190222	\N	2017-10-31	\N	Nicolas Mahut (-1.5 Sets)	\N	Pablo Carreno-Busta (+1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-10-31 20:00:00+01
129	\N	781201104	\N	2017-11-01	\N	Rafael Nadal	\N	Hyeon Chung	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
130	\N	781207585	\N	2017-11-01	\N	Roberto Bautista Agut	\N	Jeremy Chardy	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
131	\N	781211755	\N	2017-11-01	\N	Roberto Bautista Agut (+1.5 Sets)	\N	Jeremy Chardy (-1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
132	\N	781211767	\N	2017-11-01	\N	Roberto Bautista Agut (-1.5 Sets)	\N	Jeremy Chardy (+1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
126	\N	781561265	\N	2017-10-31	\N	Nicolas Mahut	\N	Pablo Carreno-Busta	1	2017-10-31 20:24:10.390842+01	2017-10-31 20:00:00+01
133	\N	781211773	\N	2017-11-01	\N	Rafael Nadal (+1.5 Sets)	\N	Hyeon Chung (-1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
134	\N	781211787	\N	2017-11-01	\N	Rafael Nadal (-1.5 Sets)	\N	Hyeon Chung (+1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
135	\N	781283570	\N	2017-11-01	\N	Richard Gasquet	\N	Grigor Dimitrov	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
136	\N	781319289	\N	2017-11-01	\N	Julien Benneteau	\N	Jo-Wilfried Tsonga	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
137	\N	781326981	\N	2017-11-01	\N	Richard Gasquet (+1.5 Sets)	\N	Grigor Dimitrov (-1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
138	\N	781326997	\N	2017-11-01	\N	Richard Gasquet (-1.5 Sets)	\N	Grigor Dimitrov (+1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
139	\N	781327097	\N	2017-11-01	\N	Julien Benneteau (+1.5 Sets)	\N	Jo-Wilfried Tsonga (-1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
140	\N	781327115	\N	2017-11-01	\N	Julien Benneteau (-1.5 Sets)	\N	Jo-Wilfried Tsonga (+1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
141	\N	781455860	\N	2017-11-01	\N	John Isner	\N	Diego Sebastian Schwartzman	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
142	\N	781470314	\N	2017-11-01	\N	John Isner (+1.5 Sets)	\N	Diego Sebastian Schwartzman (-1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
143	\N	781470323	\N	2017-11-01	\N	John Isner (-1.5 Sets)	\N	Diego Sebastian Schwartzman (+1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
144	\N	781473979	\N	2017-11-01	\N	Jack Sock	\N	Kyle Edmund	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
145	\N	781474864	\N	2017-11-01	\N	Jack Sock (+1.5 Sets)	\N	Kyle Edmund (-1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
146	\N	781474882	\N	2017-11-01	\N	Jack Sock (-1.5 Sets)	\N	Kyle Edmund (+1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
147	\N	781477747	\N	2017-11-01	\N	Joao Sousa	\N	Juan Martin Del Potro	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
148	\N	781477751	\N	2017-11-01	\N	Pablo Cuevas	\N	Albert Ramos-Vinolas	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
149	\N	781479804	\N	2017-11-01	\N	Joao Sousa (+1.5 Sets)	\N	Juan Martin Del Potro (-1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
150	\N	781479815	\N	2017-11-01	\N	Joao Sousa (-1.5 Sets)	\N	Juan Martin Del Potro (+1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
151	\N	781479826	\N	2017-11-01	\N	Pablo Cuevas (+1.5 Sets)	\N	Albert Ramos-Vinolas (-1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
152	\N	781479857	\N	2017-11-01	\N	Pablo Cuevas (-1.5 Sets)	\N	Albert Ramos-Vinolas (+1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
153	\N	781498676	\N	2017-11-01	\N	Borna Coric	\N	Marin Cilic	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
154	\N	781503851	\N	2017-11-01	\N	Borna Coric (+1.5 Sets)	\N	Marin Cilic (-1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
155	\N	781503874	\N	2017-11-01	\N	Borna Coric (-1.5 Sets)	\N	Marin Cilic (+1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
156	\N	781504351	\N	2017-11-01	\N	Feliciano Lopez	\N	Lucas Pouille	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
157	\N	781504641	\N	2017-11-01	\N	Feliciano Lopez (+1.5 Sets)	\N	Lucas Pouille (-1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
158	\N	781504650	\N	2017-11-01	\N	Feliciano Lopez (-1.5 Sets)	\N	Lucas Pouille (+1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
159	\N	781533812	\N	2017-11-01	\N	Fernando Verdasco	\N	Kevin Anderson	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
160	\N	781535693	\N	2017-11-01	\N	David Goffin	\N	Adrian Mannarino	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
161	\N	781547317	\N	2017-11-01	\N	David Goffin (+1.5 Sets)	\N	Adrian Mannarino (-1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
162	\N	781547342	\N	2017-11-01	\N	David Goffin (-1.5 Sets)	\N	Adrian Mannarino (+1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
163	\N	781547385	\N	2017-11-01	\N	Fernando Verdasco (+1.5 Sets)	\N	Kevin Anderson (-1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
164	\N	781547560	\N	2017-11-01	\N	Fernando Verdasco (-1.5 Sets)	\N	Kevin Anderson (+1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
166	\N	781565153	\N	2017-10-31	\N	Nicolas Mahut To Win Set 1	\N	Pablo Carreno-Busta To Win Set 1	1	2017-10-31 20:24:10.390842+01	2017-10-31 20:00:00+01
167	\N	781565155	\N	2017-10-31	\N	Nicolas Mahut To Win Set 2	\N	Pablo Carreno-Busta To Win Set 2	1	2017-10-31 20:24:10.390842+01	2017-10-31 20:00:00+01
168	\N	781570853	\N	2017-10-31	\N	Nicolas Mahut Game 6 of Set 1	\N	Pablo Carreno-Busta Game 6 of Set 1	1	2017-10-31 20:24:10.390842+01	2017-10-31 20:00:00+01
169	\N	781571634	\N	2017-10-31	\N	Nicolas Mahut Game 7 of Set 1	\N	Pablo Carreno-Busta Game 7 of Set 1	1	2017-10-31 20:24:10.390842+01	2017-10-31 20:00:00+01
170	\N	781574190	\N	2017-10-31	\N	Nicolas Mahut Game 8 of Set 1	\N	Pablo Carreno-Busta Game 8 of Set 1	1	2017-10-31 20:24:10.390842+01	2017-10-31 20:00:00+01
171	\N	781576206	\N	2017-10-31	\N	Nicolas Mahut Game 9 of Set 1	\N	Pablo Carreno-Busta Game 9 of Set 1	1	2017-10-31 20:24:10.390842+01	2017-10-31 20:00:00+01
172	\N	781576954	\N	2017-10-31	\N	Nicolas Mahut Game 10 of Set 1	\N	Pablo Carreno-Busta Game 10 of Set 1	1	2017-10-31 20:24:10.390842+01	2017-10-31 20:00:00+01
173	\N	781189865	\N	2017-11-01	\N	Anastasia Pavlyuchenkova	\N	Ashleigh Barty	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
174	\N	781189869	\N	2017-11-02	\N	Angelique Kerber	\N	Ashleigh Barty	0	2017-10-31 20:24:10.390842+01	2017-11-02 03:00:00+01
175	\N	781189870	\N	2017-11-02	\N	Kristina Mladenovic	\N	Julia Goerges	0	2017-10-31 20:24:10.390842+01	2017-11-02 03:00:00+01
176	\N	781189873	\N	2017-11-02	\N	Coco Vandeweghe	\N	Elena Vesnina	0	2017-10-31 20:24:10.390842+01	2017-11-02 03:00:00+01
177	\N	781193647	\N	2017-11-01	\N	Kristina Mladenovic	\N	Magdalena Rybarikova	0	2017-10-31 20:24:10.390842+01	2017-11-01 08:00:00+01
178	\N	781193648	\N	2017-11-02	\N	Elena Vesnina	\N	Shuai Peng	0	2017-10-31 20:24:10.390842+01	2017-11-02 03:00:00+01
179	\N	781193656	\N	2017-11-02	\N	Anastasija Sevastova	\N	Barbora Strycova	0	2017-10-31 20:24:10.390842+01	2017-11-02 03:00:00+01
180	\N	781425341	\N	2017-11-01	\N	Sloane Stephens	\N	Anastasija Sevastova	0	2017-10-31 20:24:10.390842+01	2017-11-01 12:00:00+01
181	\N	781474583	\N	2017-11-01	\N	Anastasia Pavlyuchenkova (+1.5 Sets)	\N	Ashleigh Barty (-1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
182	\N	781474599	\N	2017-11-01	\N	Anastasia Pavlyuchenkova (-1.5 Sets)	\N	Ashleigh Barty (+1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
183	\N	781474608	\N	2017-11-01	\N	Kristina Mladenovic (+1.5 Sets)	\N	Magdalena Rybarikova (-1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 08:00:00+01
184	\N	781474623	\N	2017-11-01	\N	Kristina Mladenovic (-1.5 Sets)	\N	Magdalena Rybarikova (+1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 08:00:00+01
185	\N	781474632	\N	2017-11-01	\N	Sloane Stephens (+1.5 Sets)	\N	Anastasija Sevastova (-1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 12:00:00+01
186	\N	781474645	\N	2017-11-01	\N	Sloane Stephens (-1.5 Sets)	\N	Anastasija Sevastova (+1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-01 12:00:00+01
187	\N	781524319	\N	2017-11-02	\N	Coco Vandeweghe (+1.5 Sets)	\N	Elena Vesnina (-1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-02 03:00:00+01
188	\N	781524324	\N	2017-11-02	\N	Coco Vandeweghe (-1.5 Sets)	\N	Elena Vesnina (+1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-02 03:00:00+01
189	\N	781524332	\N	2017-11-02	\N	Kristina Mladenovic (+1.5 Sets)	\N	Julia Goerges (-1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-02 03:00:00+01
190	\N	781524340	\N	2017-11-02	\N	Kristina Mladenovic (-1.5 Sets)	\N	Julia Goerges (+1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-02 03:00:00+01
191	\N	781524416	\N	2017-11-02	\N	Angelique Kerber (+1.5 Sets)	\N	Ashleigh Barty (-1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-02 03:00:00+01
192	\N	781524422	\N	2017-11-02	\N	Angelique Kerber (-1.5 Sets)	\N	Ashleigh Barty (+1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-02 03:00:00+01
193	\N	781524428	\N	2017-11-02	\N	Elena Vesnina (+1.5 Sets)	\N	Shuai Peng (-1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-02 03:00:00+01
194	\N	781524432	\N	2017-11-02	\N	Elena Vesnina (-1.5 Sets)	\N	Shuai Peng (+1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-02 03:00:00+01
195	\N	781524440	\N	2017-11-02	\N	Anastasija Sevastova (+1.5 Sets)	\N	Barbora Strycova (-1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-02 03:00:00+01
196	\N	781524452	\N	2017-11-02	\N	Anastasija Sevastova (-1.5 Sets)	\N	Barbora Strycova (+1.5 Sets)	0	2017-10-31 20:24:10.390842+01	2017-11-02 03:00:00+01
197	\N	781558804	\N	2017-11-01	\N	A Rosolska / A Smith	\N	J-J Lu / S Zhang	0	2017-10-31 20:24:10.390842+01	2017-11-01 13:30:00+01
198	\N	781236185	\N	2017-11-01	\N	Bernarda Pera	\N	Audrey Albie	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
199	\N	781237376	\N	2017-11-01	\N	Karolina Muchova	\N	Diana Marcinkevica	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
200	\N	781565200	\N	2017-11-01	\N	Kaia Kanepi	\N	Mari Osaka	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
201	\N	781565240	\N	2017-11-01	\N	Elena Gabriela Ruse	\N	Anna Blinkova	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
202	\N	781565446	\N	2017-11-01	\N	Salma Djoubri	\N	Richel Hogenkamp	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
203	\N	781238582	\N	2017-11-01	\N	Nina Potocnik	\N	Julia Grabher	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
204	\N	781238628	\N	2017-11-01	\N	Agnes Bukta	\N	Vivien Juhaszova	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
205	\N	781238837	\N	2017-11-01	\N	Polina Leykina	\N	Jessica Pieri	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
206	\N	781239065	\N	2017-11-01	\N	Cindy Burger	\N	Irina Maria Bara	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
207	\N	781331907	\N	2017-10-31	\N	Elena Bogdan	\N	Catalina Pella	0	2017-10-31 20:24:10.390842+01	2017-10-31 15:30:00+01
208	\N	781382792	\N	2017-11-01	\N	Paula Ormaechea	\N	Ganna Poznikhirenko	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
209	\N	781382826	\N	2017-11-01	\N	Chantal Skamlova	\N	Marie Benoit	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
210	\N	781382980	\N	2017-11-01	\N	Anastasiya Vasylyeva	\N	Cristina Dinu	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
211	\N	781383035	\N	2017-11-01	\N	Martina Caregaro	\N	Valeria Solovyeva	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
212	\N	781383090	\N	2017-11-01	\N	Sara Cakarevic	\N	Cristina Ene	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
213	\N	781298198	\N	2017-11-01	\N	Casper Ruud	\N	Facundo Bagnis	0	2017-10-31 20:24:10.390842+01	2017-11-01 16:00:00+01
214	\N	781348718	\N	2017-11-01	\N	Hugo Dellien	\N	Carlos Berlocq	0	2017-10-31 20:24:10.390842+01	2017-11-01 16:00:00+01
215	\N	781558275	\N	2017-11-01	\N	Blaz Rola	\N	Roberto Quiroz	0	2017-10-31 20:24:10.390842+01	2017-11-01 16:00:00+01
216	\N	781319291	\N	2017-11-01	\N	Brayden Schnur	\N	Tommy Paul	0	2017-10-31 20:24:10.390842+01	2017-11-01 15:00:00+01
217	\N	781552415	\N	2017-11-01	\N	Christopher Eubanks	\N	Michael Mmoh	0	2017-10-31 20:24:10.390842+01	2017-11-01 15:00:00+01
218	\N	781562250	\N	2017-11-01	\N	Tennys Sandgren	\N	Filip Horansky	0	2017-10-31 20:24:10.390842+01	2017-11-01 15:00:00+01
219	\N	781342813	\N	2017-11-01	\N	Nicole Gibbs	\N	Grace Min	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
220	\N	781342895	\N	2017-10-31	\N	Danielle Rose Collins	\N	Sachia Vickery	0	2017-10-31 20:24:10.390842+01	2017-10-31 16:45:00+01
221	\N	781343274	\N	2017-11-01	\N	Danielle Lao	\N	Cagla Buyukakcay	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
222	\N	781345208	\N	2017-11-01	\N	Sesil Karatantcheva	\N	Julia Boserup	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
223	\N	781345319	\N	2017-11-01	\N	Kayla Day	\N	Victoria Duval	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
224	\N	781345398	\N	2017-10-31	\N	Allie Kiick	\N	Jessica Pegula	0	2017-10-31 20:24:10.390842+01	2017-10-31 17:30:00+01
225	\N	781345490	\N	2017-10-31	\N	Irina Falconi	\N	Hanna Chang	0	2017-10-31 20:24:10.390842+01	2017-10-31 17:30:00+01
226	\N	781345561	\N	2017-10-31	\N	Sophie Chang	\N	Louisa Chirico	0	2017-10-31 20:24:10.390842+01	2017-10-31 17:30:00+01
227	\N	781345633	\N	2017-10-31	\N	Stefanie Voegele	\N	Taylor Townsend	0	2017-10-31 20:24:10.390842+01	2017-10-31 17:30:00+01
228	\N	781359695	\N	2017-11-01	\N	Sebastian Fanselow	\N	Alex Bolt	0	2017-10-31 20:24:10.390842+01	2017-11-01 05:30:00+01
229	\N	781369380	\N	2017-11-01	\N	Omar Jasika	\N	Jason Kubler	0	2017-10-31 20:24:10.390842+01	2017-11-01 04:00:00+01
230	\N	781395004	\N	2017-11-02	\N	Andrew Harris	\N	Alexander Sarkissian	0	2017-10-31 20:24:10.390842+01	2017-11-02 01:00:00+01
231	\N	781398810	\N	2017-11-01	\N	Maverick Banes	\N	Taro Daniel	0	2017-10-31 20:24:10.390842+01	2017-11-01 03:30:00+01
232	\N	781411611	\N	2017-11-02	\N	Blake Ellis	\N	Evan King	0	2017-10-31 20:24:10.390842+01	2017-11-02 01:00:00+01
233	\N	781411612	\N	2017-11-01	\N	Gavin Van Peperzeel	\N	Luke Saville	0	2017-10-31 20:24:10.390842+01	2017-11-01 01:30:00+01
234	\N	781420372	\N	2017-11-02	\N	Matthew Ebden	\N	Jose Statham	0	2017-10-31 20:24:10.390842+01	2017-11-02 01:00:00+01
235	\N	781392329	\N	2017-11-02	\N	Soon Woo Kwon	\N	Peter Polansky	0	2017-10-31 20:24:10.390842+01	2017-11-02 03:00:00+01
236	\N	781407510	\N	2017-11-02	\N	Jason Jung	\N	Akira Santillan	0	2017-10-31 20:24:10.390842+01	2017-11-02 03:00:00+01
237	\N	781409940	\N	2017-11-02	\N	Stephane Robert	\N	Blaz Kavcic	0	2017-10-31 20:24:10.390842+01	2017-11-02 03:00:00+01
238	\N	781411610	\N	2017-11-02	\N	Hubert Hurkacz	\N	Mohamed Safwat	0	2017-10-31 20:24:10.390842+01	2017-11-02 03:00:00+01
239	\N	781414715	\N	2017-11-02	\N	Austin Krajicek	\N	Duck Hee Lee	0	2017-10-31 20:24:10.390842+01	2017-11-02 03:00:00+01
240	\N	781418489	\N	2017-11-02	\N	Yibing Wu	\N	Zhe Li	0	2017-10-31 20:24:10.390842+01	2017-11-02 03:00:00+01
241	\N	781426770	\N	2017-11-02	\N	Radu Albot	\N	Danilo Petrovic	0	2017-10-31 20:24:10.390842+01	2017-11-02 03:00:00+01
242	\N	781431747	\N	2017-11-02	\N	Mikhail Youzhny	\N	Prajnesh Gunneswaran	0	2017-10-31 20:24:10.390842+01	2017-11-02 03:00:00+01
243	\N	781566529	\N	2017-11-01	\N	Panna Udvardy	\N	Daniela Vismane	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
244	\N	781566567	\N	2017-11-01	\N	Olga Danilovic	\N	Paula Badosa Gibert	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
245	\N	781566751	\N	2017-11-01	\N	Marta Lesniak	\N	Paula Arias Manjon	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
246	\N	781566781	\N	2017-11-01	\N	Anastasia Zarycka	\N	Misa Eguchi	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
247	\N	781566821	\N	2017-11-01	\N	Miriam Bianca Bulgaru	\N	Marta Paigina	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
248	\N	781567062	\N	2017-11-01	\N	Laura Pigossi	\N	Georgina Garcia-Perez	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
249	\N	781567122	\N	2017-11-01	\N	Melanie Stokke	\N	Nicoleta-Catalina Dascalu	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
250	\N	781567664	\N	2017-11-01	\N	Rebeka Masarova	\N	Maria-Teresa Torro-Flor	0	2017-10-31 20:24:10.390842+01	2017-11-01 10:00:00+01
\.


--
-- TOC entry 2270 (class 0 OID 0)
-- Dependencies: 200
-- Name: tbl_events_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tennis
--

SELECT pg_catalog.setval('tbl_events_event_id_seq', 6251, true);


--
-- TOC entry 2236 (class 0 OID 57877)
-- Dependencies: 186
-- Data for Name: tbl_match; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_match (match_id, tournament_id, "MatchDate", "time", surface, player1_id, player2_id, winner, score, player1_set1, player2_set1, player1_set2, player2_set2, player1_set3, player2_set3, player1_set4, player2_set4, player1_set5, player2_set5, te_link, update) FROM stdin;
\.


--
-- TOC entry 2271 (class 0 OID 0)
-- Dependencies: 187
-- Name: tbl_match_match_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tennis
--

SELECT pg_catalog.setval('tbl_match_match_id_seq', 1, false);


--
-- TOC entry 2238 (class 0 OID 57882)
-- Dependencies: 188
-- Data for Name: tbl_odds; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_odds (odds_id, event_id, match_id, bettyp_id, bookie_id, way, backlay, odds_update, odds) FROM stdin;
3721	7	\N	1	1	1	1	2017-10-31 20:50:56.190378	14.7400000000000002
3723	7	\N	1	1	2	1	2017-10-31 20:50:56.190378	1.02000000000000002
3728	7	\N	1	2	1	1	2017-10-31 20:50:56.209908	14
3729	7	\N	1	2	1	2	2017-10-31 20:50:56.209908	26
3730	7	\N	1	2	2	1	2017-10-31 20:50:56.209908	1.03000000000000003
3731	7	\N	1	2	2	2	2017-10-31 20:50:56.209908	1.08000000000000007
\.


--
-- TOC entry 2272 (class 0 OID 0)
-- Dependencies: 189
-- Name: tbl_odds_odds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tennis
--

SELECT pg_catalog.setval('tbl_odds_odds_id_seq', 3731, true);


--
-- TOC entry 2240 (class 0 OID 57890)
-- Dependencies: 190
-- Data for Name: tbl_rating; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_rating (rating_id, player_id, "FromDate", "ToDate", "SW1YALL", "SW3MALL", "SW1MALL", "SW1YG", "SW1YH", "SW1YC", "ATP") FROM stdin;
\.


--
-- TOC entry 2273 (class 0 OID 0)
-- Dependencies: 191
-- Name: tbl_rating_rating_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tennis
--

SELECT pg_catalog.setval('tbl_rating_rating_id_seq', 1, false);


--
-- TOC entry 2242 (class 0 OID 57895)
-- Dependencies: 192
-- Data for Name: tbl_sackmann_match; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_sackmann_match (index, tourney_id, tourney_name, surface, draw_size, tourney_level, tourney_date, match_num, winner_id, winner_seed, winner_entry, winner_name, winner_hand, winner_ht, winner_ioc, winner_age, winner_rank, winner_rank_points, loser_id, loser_seed, loser_entry, loser_name, loser_hand, loser_ht, loser_ioc, loser_age, loser_rank, loser_rank_points, score, best_of, round, minutes, w_ace, w_df, w_svpt, "w_1stIn", "w_1stWon", "w_2ndWon", "w_SvGms", "w_bpSaved", "w_bpFaced", l_ace, l_df, l_svpt, "l_1stIn", "l_1stWon", "l_2ndWon", "l_SvGms", "l_bpSaved", "l_bpFaced") FROM stdin;
\.


--
-- TOC entry 2243 (class 0 OID 57901)
-- Dependencies: 193
-- Data for Name: tbl_sackmann_players; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_sackmann_players (index, id, firstname, lastname, plays, dob, "IOC", update) FROM stdin;
\.


--
-- TOC entry 2244 (class 0 OID 57907)
-- Dependencies: 194
-- Data for Name: tbl_te_matchlist; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_te_matchlist (index, "MatchDate", away, away_link, away_odds, away_result, away_score_1, away_score_2, away_score_3, away_score_4, away_score_5, home, home_link, home_odds, home_result, home_score_1, home_score_2, home_score_3, home_score_4, home_score_5, match_link, "time", tournament, tournament_link, update) FROM stdin;
\.


--
-- TOC entry 2245 (class 0 OID 57913)
-- Dependencies: 195
-- Data for Name: tbl_te_player; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_te_player (index, etl_date, player_country, player_dob, player_name, player_plays, player_sex, player_url, update) FROM stdin;
\.


--
-- TOC entry 2246 (class 0 OID 57922)
-- Dependencies: 196
-- Data for Name: tbl_tournament; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_tournament (tournament_id, name, location, category, pin_league_id, te_link) FROM stdin;
\.


--
-- TOC entry 2274 (class 0 OID 0)
-- Dependencies: 197
-- Name: tbl_tournament_tournament_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tennis
--

SELECT pg_catalog.setval('tbl_tournament_tournament_id_seq', 1, false);


SET search_path = surebot, pg_catalog;

--
-- TOC entry 2251 (class 0 OID 57979)
-- Dependencies: 201
-- Data for Name: tbl_events; Type: TABLE DATA; Schema: surebot; Owner: tennis
--

COPY tbl_events (event_id, betbtc_event_id, pinnacle_event_id, betfair_event_id, "StartDate", "Home_player_id", home_player_name, away_player_id, away_player_name, "Live", "LastUpdate") FROM stdin;
\.


SET search_path = public, pg_catalog;

--
-- TOC entry 2113 (class 2606 OID 57967)
-- Name: match; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_events
    ADD CONSTRAINT match UNIQUE ("StartDate", home_player_name, away_player_name);


--
-- TOC entry 2101 (class 2606 OID 58000)
-- Name: odds_unique; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_odds
    ADD CONSTRAINT odds_unique UNIQUE (event_id, bettyp_id, way, backlay, bookie_id);


--
-- TOC entry 2093 (class 2606 OID 57934)
-- Name: tbl_bettyp_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_bettyp
    ADD CONSTRAINT tbl_bettyp_pk PRIMARY KEY (bettyp_id);


--
-- TOC entry 2095 (class 2606 OID 57936)
-- Name: tbl_bookie_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_bookie
    ADD CONSTRAINT tbl_bookie_pk PRIMARY KEY (bookie_id);


--
-- TOC entry 2115 (class 2606 OID 57965)
-- Name: tbl_events_pkey; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_events
    ADD CONSTRAINT tbl_events_pkey PRIMARY KEY (event_id);


--
-- TOC entry 2097 (class 2606 OID 57938)
-- Name: tbl_match_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_match
    ADD CONSTRAINT tbl_match_pk PRIMARY KEY (match_id);


--
-- TOC entry 2103 (class 2606 OID 57940)
-- Name: tbl_odds_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_odds
    ADD CONSTRAINT tbl_odds_pk PRIMARY KEY (odds_id);


--
-- TOC entry 2105 (class 2606 OID 57942)
-- Name: tbl_rating_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_rating
    ADD CONSTRAINT tbl_rating_pk PRIMARY KEY (rating_id);


--
-- TOC entry 2111 (class 2606 OID 57944)
-- Name: tbl_tournament_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_tournament
    ADD CONSTRAINT tbl_tournament_pk PRIMARY KEY (tournament_id);


--
-- TOC entry 2099 (class 2606 OID 57946)
-- Name: unique; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_match
    ADD CONSTRAINT "unique" UNIQUE ("MatchDate", player1_id, player2_id);


SET search_path = surebot, pg_catalog;

--
-- TOC entry 2117 (class 2606 OID 57988)
-- Name: pk; Type: CONSTRAINT; Schema: surebot; Owner: tennis
--

ALTER TABLE ONLY tbl_events
    ADD CONSTRAINT pk PRIMARY KEY (event_id);


SET search_path = public, pg_catalog;

--
-- TOC entry 2106 (class 1259 OID 57947)
-- Name: ix_tbl_sackmann_match_index; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX ix_tbl_sackmann_match_index ON tbl_sackmann_match USING btree (index);


--
-- TOC entry 2107 (class 1259 OID 57948)
-- Name: ix_tbl_sackmann_players_index; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX ix_tbl_sackmann_players_index ON tbl_sackmann_players USING btree (index);


--
-- TOC entry 2108 (class 1259 OID 57949)
-- Name: ix_tbl_te_matchlist_index; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX ix_tbl_te_matchlist_index ON tbl_te_matchlist USING btree (index);


--
-- TOC entry 2109 (class 1259 OID 57950)
-- Name: ix_tbl_te_player_index; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX ix_tbl_te_player_index ON tbl_te_player USING btree (index);


--
-- TOC entry 2258 (class 0 OID 0)
-- Dependencies: 8
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2017-10-31 20:57:18 CET

--
-- PostgreSQL database dump complete
--

