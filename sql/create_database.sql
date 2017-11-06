--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.5
-- Dumped by pg_dump version 9.6.5

-- Started on 2017-11-02 10:00:51

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE tennis;
--
-- TOC entry 2253 (class 1262 OID 16749)
-- Name: tennis; Type: DATABASE; Schema: -; Owner: tennis
--

CREATE DATABASE tennis WITH TEMPLATE = template0 ENCODING = 'UTF8' ;


ALTER DATABASE tennis OWNER TO tennis;

\connect tennis

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 16750)
-- Name: surebot; Type: SCHEMA; Schema: -; Owner: tennis
--

CREATE SCHEMA surebot;


ALTER SCHEMA surebot OWNER TO tennis;

--
-- TOC entry 1 (class 3079 OID 12387)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2256 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 186 (class 1259 OID 16751)
-- Name: tbl_bettyp; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_bettyp (
    bettyp_id integer NOT NULL,
    bettyp_name character(50)
);


ALTER TABLE tbl_bettyp OWNER TO tennis;

--
-- TOC entry 187 (class 1259 OID 16754)
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
-- TOC entry 2257 (class 0 OID 0)
-- Dependencies: 187
-- Name: tbl_bettyp_bettyp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_bettyp_bettyp_id_seq OWNED BY tbl_bettyp.bettyp_id;


--
-- TOC entry 188 (class 1259 OID 16756)
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
-- TOC entry 189 (class 1259 OID 16762)
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
-- TOC entry 2258 (class 0 OID 0)
-- Dependencies: 189
-- Name: tbl_bookie_bookie_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_bookie_bookie_id_seq OWNED BY tbl_bookie.bookie_id;


--
-- TOC entry 190 (class 1259 OID 16764)
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
-- TOC entry 191 (class 1259 OID 16766)
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
-- TOC entry 192 (class 1259 OID 16773)
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
-- TOC entry 2259 (class 0 OID 0)
-- Dependencies: 192
-- Name: tbl_events_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_events_event_id_seq OWNED BY tbl_events.event_id;


--
-- TOC entry 193 (class 1259 OID 16775)
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
-- TOC entry 194 (class 1259 OID 16778)
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
-- TOC entry 2260 (class 0 OID 0)
-- Dependencies: 194
-- Name: tbl_match_match_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_match_match_id_seq OWNED BY tbl_match.match_id;


--
-- TOC entry 195 (class 1259 OID 16780)
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
-- TOC entry 196 (class 1259 OID 16783)
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
-- TOC entry 2261 (class 0 OID 0)
-- Dependencies: 196
-- Name: tbl_odds_odds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_odds_odds_id_seq OWNED BY tbl_odds.odds_id;


--
-- TOC entry 197 (class 1259 OID 16785)
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
-- TOC entry 198 (class 1259 OID 16788)
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
-- TOC entry 2262 (class 0 OID 0)
-- Dependencies: 198
-- Name: tbl_rating_rating_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_rating_rating_id_seq OWNED BY tbl_rating.rating_id;


--
-- TOC entry 199 (class 1259 OID 16790)
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
-- TOC entry 200 (class 1259 OID 16796)
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
-- TOC entry 206 (class 1259 OID 16870)
-- Name: tbl_surebet_surebet_id; Type: SEQUENCE; Schema: public; Owner: tennis
--

CREATE SEQUENCE tbl_surebet_surebet_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbl_surebet_surebet_id OWNER TO tennis;

--
-- TOC entry 207 (class 1259 OID 16886)
-- Name: tbl_surebet; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_surebet (
    away_bookie_id bigint,
    away_odds numeric,
    event_id bigint,
    home_bookie_id bigint,
    home_odds numeric,
    max_profit numeric,
    min_profit numeric,
    surebet_id bigint DEFAULT nextval('tbl_surebet_surebet_id'::regclass) NOT NULL,
    status integer,
    update time without time zone
);


ALTER TABLE tbl_surebet OWNER TO tennis;

--
-- TOC entry 201 (class 1259 OID 16802)
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
-- TOC entry 202 (class 1259 OID 16808)
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
-- TOC entry 203 (class 1259 OID 16814)
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
-- TOC entry 204 (class 1259 OID 16817)
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
-- TOC entry 2263 (class 0 OID 0)
-- Dependencies: 204
-- Name: tbl_tournament_tournament_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_tournament_tournament_id_seq OWNED BY tbl_tournament.tournament_id;


SET search_path = surebot, pg_catalog;

--
-- TOC entry 205 (class 1259 OID 16819)
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
-- TOC entry 2074 (class 2604 OID 16825)
-- Name: tbl_bettyp bettyp_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_bettyp ALTER COLUMN bettyp_id SET DEFAULT nextval('tbl_bettyp_bettyp_id_seq'::regclass);


--
-- TOC entry 2075 (class 2604 OID 16826)
-- Name: tbl_bookie bookie_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_bookie ALTER COLUMN bookie_id SET DEFAULT nextval('tbl_bookie_bookie_id_seq'::regclass);


--
-- TOC entry 2077 (class 2604 OID 16827)
-- Name: tbl_match match_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_match ALTER COLUMN match_id SET DEFAULT nextval('tbl_match_match_id_seq'::regclass);


--
-- TOC entry 2078 (class 2604 OID 16828)
-- Name: tbl_odds odds_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_odds ALTER COLUMN odds_id SET DEFAULT nextval('tbl_odds_odds_id_seq'::regclass);


--
-- TOC entry 2079 (class 2604 OID 16829)
-- Name: tbl_rating rating_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_rating ALTER COLUMN rating_id SET DEFAULT nextval('tbl_rating_rating_id_seq'::regclass);


--
-- TOC entry 2080 (class 2604 OID 16830)
-- Name: tbl_tournament tournament_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_tournament ALTER COLUMN tournament_id SET DEFAULT nextval('tbl_tournament_tournament_id_seq'::regclass);


--
-- TOC entry 2227 (class 0 OID 16751)
-- Dependencies: 186
-- Data for Name: tbl_bettyp; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_bettyp (bettyp_id, bettyp_name) FROM stdin;
\.


--
-- TOC entry 2264 (class 0 OID 0)
-- Dependencies: 187
-- Name: tbl_bettyp_bettyp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tennis
--

SELECT pg_catalog.setval('tbl_bettyp_bettyp_id_seq', 1, false);


--
-- TOC entry 2229 (class 0 OID 16756)
-- Dependencies: 188
-- Data for Name: tbl_bookie; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_bookie (bookie_id, bookie_name, bookie_account_name, bookie_api_endpoint, bookie_api_key, bookie_type, bookie_commision, bookie_passwd) FROM stdin;
\.


--
-- TOC entry 2265 (class 0 OID 0)
-- Dependencies: 189
-- Name: tbl_bookie_bookie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tennis
--

SELECT pg_catalog.setval('tbl_bookie_bookie_id_seq', 1, true);


--
-- TOC entry 2266 (class 0 OID 0)
-- Dependencies: 190
-- Name: tbl_event_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tennis
--

SELECT pg_catalog.setval('tbl_event_event_id_seq', 4963, true);


--
-- TOC entry 2232 (class 0 OID 16766)
-- Dependencies: 191
-- Data for Name: tbl_events; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_events (event_id, betbtc_event_id, pinnacle_event_id, betfair_event_id, "StartDate", "Home_player_id", home_player_name, away_player_id, away_player_name, "Live", "LastUpdate", "StartDateTime") FROM stdin;
318	481980	\N	1.136317316	2017-11-01	\N	I Falconi	\N	H Chang	\N	2017-11-01 16:23:32.01024+01	2017-11-01 17:35:00+01
289	482836	\N	1.136356236	2017-11-01	\N	A Luisi	\N	G Di Nicola	\N	2017-11-01 12:17:11.971725+01	2017-11-01 14:35:00+01
275	482847	\N	1.136356224	2017-11-01	\N	M Caregaro	\N	V Solovyeva	\N	2017-11-01 12:17:11.971725+01	2017-11-01 13:05:00+01
254	479676	\N	1.136229784	2017-11-01	\N	Felix Auger-Aliassime	\N	Jerzy Janowicz	\N	2017-11-01 10:55:06.447068+01	2017-11-01 11:00:00+01
295	480388	\N	1.136257071	2017-11-01	\N	Krawietz/Olivetti	\N	Bury/Siljestrom	\N	2017-11-01 15:21:11.355254+01	2017-11-01 15:00:00+01
287	482646	\N	1.136346146	2017-11-01	\N	B Pera	\N	A Albie	\N	2017-11-01 12:17:11.971725+01	2017-11-01 14:35:00+01
277	482845	\N	1.136356220	2017-11-01	\N	A Bukta	\N	V Juhaszova	\N	2017-11-01 12:17:11.971725+01	2017-11-01 13:05:00+01
298	482852	\N	1.136356226	2017-11-01	\N	J Ponchet	\N	V Rodriguez	\N	2017-11-01 12:17:11.971725+01	2017-11-01 15:05:00+01
306	482865	\N	1.136356263	2017-11-01	\N	S Karatantcheva	\N	J Boserup	\N	2017-11-01 16:23:32.01024+01	2017-11-01 16:05:00+01
278	482844	\N	1.136356229	2017-11-01	\N	P Ormaechea	\N	G Poznikhirenko	\N	2017-11-01 12:17:11.971725+01	2017-11-01 13:05:00+01
304	482866	\N	1.136356265	2017-11-01	\N	Y Lysa	\N	A Anisimova	\N	2017-11-01 16:23:32.01024+01	2017-11-01 16:05:00+01
309	482554	781588783	1.136345940	2017-11-01	\N	Bjorn Fratangelo	\N	Tim Smyczek	0	2017-11-01 16:23:32.613736+01	2017-11-01 17:00:00+01
292	482839	\N	1.136356237	2017-11-01	\N	F Gil	\N	F Bertuccioli	\N	2017-11-01 12:17:11.971725+01	2017-11-01 14:35:00+01
260	482832	\N	1.136356118	2017-11-01	\N	P Udvardy	\N	D Vismane	\N	2017-11-01 10:55:06.447068+01	2017-11-01 11:05:00+01
261	482569	\N	1.136346138	2017-11-01	\N	O Ianchuk	\N	I Ramialison	\N	2017-11-01 10:55:06.447068+01	2017-11-01 11:35:00+01
262	482568	\N	1.136346136	2017-11-01	\N	A Rame	\N	C Perrin	\N	2017-11-01 10:55:06.447068+01	2017-11-01 11:35:00+01
284	482835	\N	1.136356243	2017-11-01	\N	M Miceli	\N	T Brkic	\N	2017-11-01 12:17:11.971725+01	2017-11-01 14:35:00+01
301	482842	\N	1.136356238	2017-11-01	\N	L Sonego	\N	C Summaria	\N	2017-11-01 15:37:38.442825+01	2017-11-01 16:05:00+01
307	481776	781319289	1.136311280	2017-11-01	\N	Julien Benneteau	\N	Jo-Wilfried Tsonga	0	2017-11-01 16:23:32.613736+01	2017-11-01 16:30:00+01
310	481615	\N	1.136292317	2017-11-01	\N	Schwartzman/Verdasco	\N	Dodig/Granollers	\N	2017-11-01 16:23:32.01024+01	2017-11-01 17:00:00+01
322	481610	\N	1.136297734	2017-11-01	\N	Klaasen/Ram	\N	Lopez/Lopez	\N	2017-11-01 16:23:32.01024+01	2017-11-01 19:00:00+01
264	482829	\N	1.136356117	2017-11-01	\N	O Danilovic	\N	P Badosa Gibert	\N	2017-11-01 10:55:06.447068+01	2017-11-01 12:05:00+01
266	482192	781737447	1.136325936	2017-11-01	\N	Sebastian Ofner	\N	Aldin Setkic	0	2017-11-01 12:17:12.469497+01	2017-11-01 13:00:00+01
268	482290	781809405	1.136330076	2017-11-01	\N	Ruben Bemelmans	\N	Luca Vanni	1	2017-11-01 15:06:55.631982+01	2017-11-01 13:00:00+01
280	482849	\N	1.136356221	2017-11-01	\N	C Burger	\N	I Bara	\N	2017-11-01 12:17:11.971725+01	2017-11-01 13:05:00+01
281	482830	\N	1.136356113	2017-11-01	\N	L Pigossi	\N	G Garcia Perez	\N	2017-11-01 12:17:11.971725+01	2017-11-01 13:35:00+01
276	482846	\N	1.136356231	2017-11-01	\N	S Cakarevic	\N	C Ene	\N	2017-11-01 12:17:11.971725+01	2017-11-01 13:05:00+01
273	482848	\N	1.136356227	2017-11-01	\N	P Leykina	\N	J Pieri	\N	2017-11-01 12:17:11.971725+01	2017-11-01 13:05:00+01
282	482069	\N	1.136319289	2017-11-01	\N	Rosolska/Smith	\N	Lu/Zhang	\N	2017-11-01 12:17:11.971725+01	2017-11-01 14:00:00+01
319	481977	\N	1.136317314	2017-11-01	\N	S Voegele	\N	T Townsend	\N	2017-11-01 16:23:32.01024+01	2017-11-01 17:35:00+01
312	481525	781861232	1.136292111	2017-11-01	\N	Mirza Basic	\N	Alexander Bublik	1	2017-11-01 16:23:32.613736+01	2017-11-01 17:00:00+01
297	482540	\N	1.136344417	2017-11-01	\N	Murray/Soares	\N	Harrison/Venus	\N	2017-11-01 15:21:11.355254+01	2017-11-01 15:00:00+01
270	482566	\N	1.136346140	2017-11-01	\N	L Kerkhove	\N	A Frolova	\N	2017-11-01 12:17:11.971725+01	2017-11-01 13:05:00+01
296	482279	781477747	1.136327785	2017-11-01	\N	Joao Sousa	\N	Juan Martin Del Potro	0	2017-11-01 16:23:32.613736+01	2017-11-01 15:00:00+01
271	482567	\N	1.136346139	2017-11-01	\N	A Silich	\N	J Cepelova	\N	2017-11-01 12:17:11.971725+01	2017-11-01 13:05:00+01
274	482828	\N	1.136356119	2017-11-01	\N	R Masarova	\N	M Torro-Flor	\N	2017-11-01 12:17:11.971725+01	2017-11-01 13:05:00+01
279	482843	\N	1.136356222	2017-11-01	\N	C Skamlova	\N	M Benoit	\N	2017-11-01 12:17:11.971725+01	2017-11-01 13:05:00+01
290	482837	\N	1.136356244	2017-11-01	\N	M Zekic	\N	A Zucca	\N	2017-11-01 12:17:11.971725+01	2017-11-01 14:35:00+01
293	482840	\N	1.136356239	2017-11-01	\N	M Loccisano	\N	F Gaio	\N	2017-11-01 12:17:11.971725+01	2017-11-01 14:35:00+01
291	482838	\N	1.136356245	2017-11-01	\N	P Torebko	\N	A Vavassori	\N	2017-11-01 12:17:11.971725+01	2017-11-01 14:35:00+01
299	482851	\N	1.136356223	2017-11-01	\N	A Li	\N	P Schnyder	\N	2017-11-01 12:17:11.971725+01	2017-11-01 15:05:00+01
263	482056	781425341	1.136319356	2017-11-01	\N	Sloane Stephens	\N	Anastasija Sevastova	0	2017-11-01 12:17:12.469497+01	2017-11-01 12:00:00+01
321	482854	\N	1.136356228	2017-11-01	\N	K Sebov	\N	E Bovina	\N	2017-11-01 16:23:32.01024+01	2017-11-01 18:05:00+01
308	482853	\N	1.136356230	2017-11-01	\N	M Honcova	\N	R Yurovsky	\N	2017-11-01 16:23:32.01024+01	2017-11-01 16:35:00+01
315	482485	\N	1.136332498	2017-11-01	\N	Cabal/Farah	\N	Herbert/Mahut	\N	2017-11-01 16:23:32.01024+01	2017-11-01 17:30:00+01
288	482841	\N	1.136356246	2017-11-01	\N	V Antonescu	\N	O Giacalone	\N	2017-11-01 12:17:11.971725+01	2017-11-01 14:35:00+01
286	482645	\N	1.136346148	2017-11-01	\N	K Muchova	\N	D Marcinkevica	\N	2017-11-01 12:17:11.971725+01	2017-11-01 14:35:00+01
311	480582	\N	1.136266612	2017-11-01	\N	Hach Verdugo/Novikov	\N	Bambridge/O'Hare	\N	2017-11-01 16:23:32.01024+01	2017-11-01 17:00:00+01
303	482868	\N	1.136356264	2017-11-01	\N	S Kenin	\N	A Rodgers	\N	2017-11-01 16:23:32.01024+01	2017-11-01 16:05:00+01
320	482295	781738695	1.136327741	2017-11-01	\N	Alex De Minaur	\N	Tommy Robredo	0	2017-11-01 16:23:32.613736+01	2017-11-01 18:00:00+01
283	481334	781839968	1.136281083	2017-11-01	\N	Rafael Nadal	\N	Hyeon Chung	1	2017-11-01 16:23:32.613736+01	2017-11-01 14:30:00+01
305	482647	\N	1.136346150	2017-11-01	\N	K Kanepi	\N	M Osaka	\N	2017-11-01 15:37:38.442825+01	2017-11-01 16:05:00+01
317	482864	\N	1.136356262	2017-11-01	\N	R Peterson	\N	C Whoriskey	\N	2017-11-01 16:23:32.01024+01	2017-11-01 17:35:00+01
302	482869	\N	1.136356260	2017-11-01	\N	K Day	\N	V Duval	\N	2017-11-01 16:23:32.01024+01	2017-11-01 16:05:00+01
313	480404	\N	1.136257093	2017-11-01	\N	Bemelmans/Molchanov	\N	Begemann/Puetz	\N	2017-11-01 16:23:32.01024+01	2017-11-01 17:00:00+01
316	482867	\N	1.136356259	2017-11-01	\N	D Lao	\N	C Buyukakcay	\N	2017-11-01 16:23:32.01024+01	2017-11-01 17:35:00+01
253	482188	\N	1.136325797	2017-11-01	\N	John Isner	\N	Diego Schwartzman	\N	2017-11-01 10:55:06.447068+01	2017-11-01 11:00:00+01
272	482831	\N	1.136356114	2017-11-01	\N	M Bulgaru	\N	M Paigina	\N	2017-11-01 12:17:11.971725+01	2017-11-01 13:05:00+01
269	482375	781828865	1.136331896	2017-11-01	\N	Fernando Verdasco	\N	Kevin Anderson	1	2017-11-01 16:23:32.613736+01	2017-11-01 13:00:00+01
314	482184	781473979	1.136326466	2017-11-01	\N	Jack Sock	\N	Kyle Edmund	0	2017-11-01 16:23:32.613736+01	2017-11-01 17:00:00+01
300	482648	\N	1.136346154	2017-11-01	\N	E Ruse	\N	A Blinkova	\N	2017-11-01 15:37:38.442825+01	2017-11-01 16:05:00+01
257	482834	\N	1.136356112	2017-11-01	\N	A Zarycka	\N	M Eguchi	\N	2017-11-01 10:55:06.447068+01	2017-11-01 11:05:00+01
267	482282	781807924	1.136327797	2017-11-01	\N	Pablo Cuevas	\N	Albert Ramos-Vinolas	1	2017-11-01 15:21:11.576534+01	2017-11-01 13:00:00+01
252	481619	\N	1.136292160	2017-11-01	\N	Gonzalez/Peralta	\N	Rojer/Tecau	\N	2017-11-01 10:55:06.447068+01	2017-11-01 11:00:00+01
258	482833	\N	1.136356115	2017-11-01	\N	M Lesniak	\N	P Arias Manjon	\N	2017-11-01 10:55:06.447068+01	2017-11-01 11:05:00+01
259	482827	\N	1.136356116	2017-11-01	\N	M Stokke	\N	N Dascalu	\N	2017-11-01 10:55:06.447068+01	2017-11-01 11:05:00+01
285	482850	\N	1.136356225	2017-11-01	\N	N Potocnik	\N	J Grabher	\N	2017-11-01 12:17:11.971725+01	2017-11-01 14:35:00+01
4752	\N	781980707	\N	2017-11-02	\N	John Isner	\N	Grigor Dimitrov	0	2017-11-02 09:19:12.300425+01	2017-11-02 15:00:00+01
384	\N	748122980	\N	2017-07-30	\N	Ryan Haviland To Win Set 1	\N	Trey Yates To Win Set 1	1	2017-11-02 09:19:12.300425+01	2017-07-30 16:10:46+02
364	482286	\N	1.136330120	2017-11-02	\N	Kontinen/Peers	\N	Monroe/Sock	\N	2017-11-02 09:19:12.151315+01	2017-11-02 10:00:00+01
371	482639	\N	1.136352766	2017-11-02	\N	Andreozzi/Gonzalez	\N	Rola/Romboli	\N	2017-11-01 16:23:32.01024+01	2017-11-02 17:00:00+01
353	482044	\N	1.136317534	2017-11-02	\N	Austin Krajicek	\N	Duckhee Lee	\N	2017-11-01 16:23:32.01024+01	2017-11-02 04:30:00+01
358	481953	781407510	1.136317212	2017-11-02	\N	Jason Jung	\N	Akira Santillan	0	2017-11-01 16:23:32.613736+01	2017-11-02 06:00:00+01
338	480585	\N	1.136266621	2017-11-01	\N	Martinez/Santanna	\N	Kudla/Thomas	\N	2017-11-01 16:23:32.01024+01	2017-11-01 21:00:00+01
329	482564	781603246	1.136345896	2017-11-01	\N	Gonzalo Lama	\N	Guido Andreozzi	0	2017-11-01 16:23:32.613736+01	2017-11-01 19:00:00+01
357	482911	\N	1.136356432	2017-11-02	\N	Gabashvili/Hurkacz	\N	Balaji/Vardhan	\N	2017-11-01 16:23:32.01024+01	2017-11-02 06:00:00+01
369	482623	781678966	1.136351506	2017-11-02	\N	Cameron Norrie	\N	Ruan Roelofse	0	2017-11-02 09:19:12.300425+01	2017-11-02 16:00:00+01
373	482643	\N	1.136352762	2017-11-02	\N	Arneodo/Cecchinato	\N	Arevalo/Reyes-Varela	\N	2017-11-01 16:23:32.01024+01	2017-11-02 17:00:00+01
355	482039	\N	1.136319446	2017-11-02	\N	Bolt/Mousley	\N	Kubler/Mitchell	\N	2017-11-01 16:23:32.01024+01	2017-11-02 04:30:00+01
341	480570	\N	1.136266610	2017-11-01	\N	Lammons/Lawson	\N	Peliwo/Schnur	\N	2017-11-01 16:23:32.01024+01	2017-11-01 23:00:00+01
389	\N	748130443	\N	2017-07-30	\N	Ryan Haviland Game 10 of Set 1	\N	Trey Yates Game 10 of Set 1	1	2017-11-02 09:19:12.300425+01	2017-07-30 16:10:46+02
387	\N	748127585	\N	2017-07-30	\N	Ryan Haviland Game 8 of Set 1	\N	Trey Yates Game 8 of Set 1	1	2017-11-02 09:19:12.300425+01	2017-07-30 16:10:46+02
386	\N	748126924	\N	2017-07-30	\N	Ryan Haviland Game 6 of Set 1	\N	Trey Yates Game 6 of Set 1	1	2017-11-02 09:19:12.300425+01	2017-07-30 16:10:46+02
326	482546	\N	1.136344389	2017-11-01	\N	Skupski/Skupski	\N	Satschko/Weissborn	\N	2017-11-01 16:23:32.01024+01	2017-11-01 19:00:00+01
334	482497	781562250	1.136342135	2017-11-01	\N	Tennys Sandgren	\N	Filip Horansky	0	2017-11-01 16:23:32.613736+01	2017-11-01 21:00:00+01
342	482634	781671701	1.136351419	2017-11-01	\N	Martin Cuevas	\N	Gerald Melzer	0	2017-11-01 16:23:32.613736+01	2017-11-01 23:00:00+01
327	482493	\N	1.136332340	2017-11-01	\N	Brown/Marterer	\N	Arends/Jebavy	\N	2017-11-01 16:23:32.01024+01	2017-11-01 19:00:00+01
374	482711	\N	1.136352783	2017-11-02	\N	Domingues/Souza	\N	Balazs/Behar	\N	2017-11-02 09:19:12.151315+01	2017-11-02 17:00:00+01
368	482699	781707368	1.136352997	2017-11-02	\N	Stefan Kozlov	\N	Liam Broady	0	2017-11-02 09:19:12.300425+01	2017-11-02 16:00:00+01
361	482543	781603255	1.136346084	2017-11-02	\N	Filip Krajinovic	\N	Nicolas Mahut	0	2017-11-02 09:19:12.300425+01	2017-11-02 10:00:00+01
352	482049	781418489	1.136317586	2017-11-02	\N	Yibing Wu	\N	Zhe Li	0	2017-11-01 16:23:32.613736+01	2017-11-02 03:00:00+01
349	482507	781558275	1.136342091	2017-11-02	\N	Blaz Rola	\N	Roberto Quiroz	0	2017-11-01 16:23:32.613736+01	2017-11-02 02:00:00+01
379	\N	781542797	\N	2017-11-01	\N	J S Cabal / R Farah	\N	P-H Herbert / N Mahut	0	2017-11-01 16:23:32.613736+01	2017-11-01 17:30:00+01
375	\N	781251320	\N	2017-11-01	\N	R Klaasen / R Ram	\N	F Lopez / M Lopez	0	2017-11-01 16:23:32.613736+01	2017-11-01 16:20:00+01
328	482558	781597930	1.136345984	2017-11-01	\N	Filip Peliwo	\N	Henri Laaksonen	0	2017-11-01 16:23:32.613736+01	2017-11-01 19:00:00+01
330	482863	\N	1.136356258	2017-11-01	\N	A Kratzer	\N	A Schmiedlova	\N	2017-11-01 16:23:32.01024+01	2017-11-01 19:05:00+01
347	481829	\N	1.136313360	2017-11-02	\N	Roelofse/Salisbury	\N	Kwiatkowski/Ritschard	\N	2017-11-01 16:23:32.01024+01	2017-11-02 01:30:00+01
363	482481	\N	1.136338794	2017-11-02	\N	Gasquet/Pouille	\N	Kubot/Melo	\N	2017-11-02 09:19:12.151315+01	2017-11-02 10:00:00+01
360	482861	\N	1.136356232	2017-11-02	\N	Wu/Wu	\N	Cerretani/Matsui	\N	2017-11-01 16:23:32.01024+01	2017-11-02 08:00:00+01
350	481962	781411610	1.136317317	2017-11-02	\N	Hubert Hurkacz	\N	Mohamed Safwat	0	2017-11-01 16:23:32.613736+01	2017-11-02 03:00:00+01
339	482627	\N	1.136352702	2017-11-01	\N	Jose Hernandez-Fernande	\N	Nicolas Kicker	\N	2017-11-01 16:23:32.01024+01	2017-11-01 21:00:00+01
378	\N	781498695	\N	2017-11-02	\N	H Kontinen / J Peers	\N	N Monroe / J Sock	0	2017-11-02 09:19:12.300425+01	2017-11-02 10:00:00+01
372	482707	\N	1.136352937	2017-11-02	\N	Dellien/Zeballos	\N	Cuevas/Estrella Burgos	\N	2017-11-01 16:23:32.01024+01	2017-11-02 17:00:00+01
383	\N	748129668	\N	2017-07-30	\N	Ryan Haviland Game 9 of Set 1	\N	Trey Yates Game 9 of Set 1	1	2017-11-02 09:19:12.300425+01	2017-07-30 16:10:46+02
356	482111	\N	1.136321309	2017-11-02	\N	M Youzhny	\N	Prajnesh Gunneswaran	\N	2017-11-01 16:23:32.01024+01	2017-11-02 04:30:00+01
388	\N	748127222	\N	2017-07-30	\N	Ryan Haviland Game 7 of Set 1	\N	Trey Yates Game 7 of Set 1	1	2017-11-02 09:19:12.300425+01	2017-07-30 16:10:46+02
366	482383	\N	1.136331360	2017-11-02	\N	Bryan/Bryan	\N	Benneteau/Roger-Vasseli	\N	2017-11-02 09:19:12.151315+01	2017-11-02 10:00:00+01
354	481957	781409940	1.136317361	2017-11-02	\N	Stephane Robert	\N	Blaz Kavcic	0	2017-11-01 16:23:32.613736+01	2017-11-02 04:30:00+01
333	482379	781535693	1.136331884	2017-11-01	\N	David Goffin	\N	Adrian Mannarino	0	2017-11-01 16:23:32.613736+01	2017-11-01 20:30:00+01
359	482052	781426770	1.136319450	2017-11-02	\N	Radu Albot	\N	Danilo Petrovic	0	2017-11-01 16:23:32.613736+01	2017-11-02 06:00:00+01
343	480575	\N	1.136266559	2017-11-01	\N	Paes/Raja	\N	Eubanks/Mcdonald	\N	2017-11-01 16:23:32.01024+01	2017-11-01 23:30:00+01
335	480566	\N	1.136266627	2017-11-01	\N	Broady/Fratangelo	\N	Giron/Smyczek	\N	2017-11-01 16:23:32.01024+01	2017-11-01 21:00:00+01
323	481779	781319291	1.136313169	2017-11-01	\N	Brayden Schnur	\N	Tommy Paul	0	2017-11-01 16:23:32.613736+01	2017-11-01 19:00:00+01
336	482821	781714263	1.136353275	2017-11-01	\N	Gastao Elias	\N	Joao Domingues	0	2017-11-01 16:23:32.613736+01	2017-11-01 21:00:00+01
365	482491	781738696	1.136332444	2017-11-02	\N	Matthias Bachinger	\N	Dustin Brown	0	2017-11-02 09:19:12.300425+01	2017-11-02 10:00:00+01
344	481929	781395004	1.136317093	2017-11-01	\N	Andrew Harris	\N	Alexander Sarkissian	0	2017-11-01 16:23:32.613736+01	2017-11-02 00:00:00+01
370	482701	781692862	1.136352787	2017-11-02	\N	Denis Kudla	\N	Ernesto Escobedo	0	2017-11-02 09:19:12.300425+01	2017-11-02 16:00:00+01
331	482870	\N	1.136356261	2017-11-01	\N	N Gibbs	\N	G Min	\N	2017-11-01 16:23:32.01024+01	2017-11-01 19:05:00+01
380	\N	781556486	\N	2017-11-02	\N	R Gasquet / L Pouille	\N	L Kubot / M Melo	0	2017-11-02 09:19:12.300425+01	2017-11-02 10:00:00+01
385	\N	748122958	\N	2017-07-30	\N	Ryan Haviland To Win Set 2	\N	Trey Yates To Win Set 2	1	2017-11-02 09:19:12.300425+01	2017-07-30 16:10:46+02
340	481859	781348718	1.136313811	2017-11-01	\N	Hugo Dellien	\N	Carlos Berlocq	0	2017-11-01 16:23:32.613736+01	2017-11-01 21:00:00+01
390	\N	698657478	\N	2017-03-01	\N	A Barty / C Dellacqua	\N	M Irigoyen / P Kania	0	2017-11-02 09:19:12.300425+01	2017-03-01 08:00:00+01
376	\N	781251322	\N	2017-11-01	\N	S Gonzalez / J Peralta	\N	J-J Rojer / H Tecau	0	2017-11-01 12:17:12.469497+01	2017-11-01 11:00:00+01
382	\N	781589953	\N	2017-11-01	\N	J Murray / B Soares	\N	R Harrison / M Venus	0	2017-11-01 16:23:32.613736+01	2017-11-01 13:40:00+01
332	481772	781283570	1.136310027	2017-11-01	\N	Richard Gasquet	\N	Grigor Dimitrov	0	2017-11-01 16:23:32.613736+01	2017-11-01 19:30:00+01
367	482501	781552415	1.136338798	2017-11-02	\N	Christopher Eubanks	\N	Michael Mmoh	0	2017-11-02 09:19:12.300425+01	2017-11-02 16:00:00+01
377	\N	781251323	\N	2017-11-01	\N	D Schwartzman / F Verdasco	\N	I Dodig / M Granollers	0	2017-11-01 16:23:32.613736+01	2017-11-01 15:00:00+01
458	\N	781474645	\N	2017-11-01	\N	Sloane Stephens (-1.5 Sets)	\N	Anastasija Sevastova (+1.5 Sets)	0	2017-11-01 15:37:39.078491+01	2017-11-01 12:00:00+01
432	\N	781479857	\N	2017-11-01	\N	Pablo Cuevas (-1.5 Sets)	\N	Albert Ramos-Vinolas (+1.5 Sets)	0	2017-11-01 15:37:39.078491+01	2017-11-01 13:00:00+01
444	\N	781547560	\N	2017-11-01	\N	Fernando Verdasco (-1.5 Sets)	\N	Kevin Anderson (+1.5 Sets)	0	2017-11-01 16:23:32.613736+01	2017-11-01 13:00:00+01
413	\N	781211773	\N	2017-11-01	\N	Rafael Nadal (+1.5 Sets)	\N	Hyeon Chung (-1.5 Sets)	0	2017-11-01 16:23:32.613736+01	2017-11-01 15:00:00+01
404	\N	713525349	\N	2017-04-13	\N	R Haase / G Smits	\N	T Berdych / R Bopanna	0	2017-11-02 09:19:12.300425+01	2017-04-13 08:28:00+02
397	\N	775332650	\N	2017-10-17	\N	M Buzarnescu / O Kalashnikova	\N	S Aoyama / Z Yang	0	2017-11-02 09:19:12.300425+01	2017-10-17 11:00:00+02
402	\N	781788197	\N	2017-11-01	\N	Felix Auger Alliassime	\N	Jerzy Janowicz	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:00:00+01
457	\N	781474632	\N	2017-11-01	\N	Sloane Stephens (+1.5 Sets)	\N	Anastasija Sevastova (-1.5 Sets)	0	2017-11-01 15:37:39.078491+01	2017-11-01 12:00:00+01
459	\N	781524319	\N	2017-11-02	\N	Coco Vandeweghe (+1.5 Sets)	\N	Elena Vesnina (-1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-02 03:00:00+01
337	481520	781207585	1.136291101	2017-11-01	\N	Roberto Bautista Agut	\N	Jeremy Chardy	0	2017-11-01 16:23:32.613736+01	2017-11-01 21:00:00+01
448	\N	781189873	\N	2017-11-02	\N	Coco Vandeweghe	\N	Elena Vesnina	0	2017-11-02 09:19:12.300425+01	2017-11-02 03:00:00+01
446	\N	782170099	\N	2017-11-02	\N	Angelique Kerber	\N	Ashleigh Barty	1	2017-11-02 09:19:12.300425+01	2017-11-02 03:00:00+01
400	\N	684072620	\N	2017-01-17	\N	Omar Jasika Game 10 of Set 1	\N	David Ferrer Game 10 of Set 1	1	2017-11-02 09:19:12.300425+01	2017-01-17 08:30:00+01
460	\N	781524324	\N	2017-11-02	\N	Coco Vandeweghe (-1.5 Sets)	\N	Elena Vesnina (+1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-02 03:00:00+01
421	\N	781785413	\N	2017-11-01	\N	John Isner	\N	Diego Sebastian Schwartzman	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:00:00+01
394	\N	781130018	\N	2017-11-01	\N	Alina Silich	\N	Jana Cepelova	0	2017-11-01 16:07:41.044699+01	2017-11-01 12:15:00+01
403	\N	754104456	\N	2017-08-19	\N	Julia Elbaba Game 1 of Set 2	\N	Kurumi Nara Game 1 of Set 2	1	2017-11-02 09:19:12.300425+01	2017-08-19 18:00:00+02
414	\N	781211787	\N	2017-11-01	\N	Rafael Nadal (-1.5 Sets)	\N	Hyeon Chung (+1.5 Sets)	0	2017-11-01 16:23:32.613736+01	2017-11-01 15:00:00+01
417	\N	781326981	\N	2017-11-01	\N	Richard Gasquet (+1.5 Sets)	\N	Grigor Dimitrov (-1.5 Sets)	0	2017-11-01 16:23:32.613736+01	2017-11-01 19:30:00+01
407	\N	781185055	\N	2017-11-01	\N	Alexander Zverev (+1.5 Sets)	\N	Robin Haase (-1.5 Sets)	0	2017-11-01 12:17:12.469497+01	2017-11-01 11:00:00+01
418	\N	781326997	\N	2017-11-01	\N	Richard Gasquet (-1.5 Sets)	\N	Grigor Dimitrov (+1.5 Sets)	0	2017-11-01 16:23:32.613736+01	2017-11-01 19:30:00+01
419	\N	781327097	\N	2017-11-01	\N	Julien Benneteau (+1.5 Sets)	\N	Jo-Wilfried Tsonga (-1.5 Sets)	0	2017-11-01 16:23:32.613736+01	2017-11-01 17:00:00+01
420	\N	781327115	\N	2017-11-01	\N	Julien Benneteau (-1.5 Sets)	\N	Jo-Wilfried Tsonga (+1.5 Sets)	0	2017-11-01 16:23:32.613736+01	2017-11-01 17:00:00+01
265	482391	781504351	1.136330418	2017-11-01	\N	Feliciano Lopez	\N	Lucas Pouille	0	2017-11-01 12:17:12.469497+01	2017-11-01 12:30:00+01
443	\N	781547385	\N	2017-11-01	\N	Fernando Verdasco (+1.5 Sets)	\N	Kevin Anderson (-1.5 Sets)	0	2017-11-01 16:23:32.613736+01	2017-11-01 13:00:00+01
434	\N	781503851	\N	2017-11-01	\N	Borna Coric (+1.5 Sets)	\N	Marin Cilic (-1.5 Sets)	0	2017-11-01 16:23:32.613736+01	2017-11-01 19:00:00+01
453	\N	781474583	\N	2017-11-01	\N	Anastasia Pavlyuchenkova (+1.5 Sets)	\N	Ashleigh Barty (-1.5 Sets)	0	2017-11-01 12:17:12.469497+01	2017-11-01 10:45:00+01
426	\N	781474882	\N	2017-11-01	\N	Jack Sock (-1.5 Sets)	\N	Kyle Edmund (+1.5 Sets)	0	2017-11-01 16:23:32.613736+01	2017-11-01 17:00:00+01
429	\N	781479804	\N	2017-11-01	\N	Joao Sousa (+1.5 Sets)	\N	Juan Martin Del Potro (-1.5 Sets)	0	2017-11-01 16:23:32.613736+01	2017-11-01 15:00:00+01
430	\N	781479815	\N	2017-11-01	\N	Joao Sousa (-1.5 Sets)	\N	Juan Martin Del Potro (+1.5 Sets)	0	2017-11-01 16:23:32.613736+01	2017-11-01 15:00:00+01
325	482387	781498676	1.136330367	2017-11-01	\N	Borna Coric	\N	Marin Cilic	0	2017-11-01 16:23:32.613736+01	2017-11-01 19:00:00+01
412	\N	781211767	\N	2017-11-01	\N	Roberto Bautista Agut (-1.5 Sets)	\N	Jeremy Chardy (+1.5 Sets)	0	2017-11-01 16:23:32.613736+01	2017-11-01 21:00:00+01
447	\N	781189870	\N	2017-11-02	\N	Kristina Mladenovic	\N	Julia Goerges	0	2017-11-01 10:55:06.740077+01	2017-11-02 03:00:00+01
391	\N	781129898	\N	2017-11-01	\N	Olga Ianchuk	\N	Irina Ramialison	0	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
450	\N	781193648	\N	2017-11-02	\N	Elena Vesnina	\N	Shuai Peng	0	2017-11-01 10:55:06.740077+01	2017-11-02 03:00:00+01
451	\N	781193656	\N	2017-11-02	\N	Anastasija Sevastova	\N	Barbora Strycova	0	2017-11-02 09:19:12.300425+01	2017-11-02 03:00:00+01
454	\N	781474599	\N	2017-11-01	\N	Anastasia Pavlyuchenkova (-1.5 Sets)	\N	Ashleigh Barty (+1.5 Sets)	0	2017-11-01 12:17:12.469497+01	2017-11-01 10:45:00+01
435	\N	781503874	\N	2017-11-01	\N	Borna Coric (-1.5 Sets)	\N	Marin Cilic (+1.5 Sets)	0	2017-11-01 16:23:32.613736+01	2017-11-01 19:00:00+01
455	\N	781474608	\N	2017-11-01	\N	Kristina Mladenovic (+1.5 Sets)	\N	Magdalena Rybarikova (-1.5 Sets)	0	2017-11-01 10:55:06.740077+01	2017-11-01 08:30:00+01
456	\N	781474623	\N	2017-11-01	\N	Kristina Mladenovic (-1.5 Sets)	\N	Magdalena Rybarikova (+1.5 Sets)	0	2017-11-01 10:55:06.740077+01	2017-11-01 08:30:00+01
441	\N	781547317	\N	2017-11-01	\N	David Goffin (+1.5 Sets)	\N	Adrian Mannarino (-1.5 Sets)	0	2017-11-01 16:23:32.613736+01	2017-11-01 21:30:00+01
442	\N	781547342	\N	2017-11-01	\N	David Goffin (-1.5 Sets)	\N	Adrian Mannarino (+1.5 Sets)	0	2017-11-01 16:23:32.613736+01	2017-11-01 21:30:00+01
437	\N	781504641	\N	2017-11-01	\N	Feliciano Lopez (+1.5 Sets)	\N	Lucas Pouille (-1.5 Sets)	0	2017-11-01 15:37:39.078491+01	2017-11-01 13:00:00+01
445	\N	781787493	\N	2017-11-01	\N	Anastasia Pavlyuchenkova	\N	Ashleigh Barty	1	2017-11-01 12:17:12.469497+01	2017-11-01 10:45:00+01
461	\N	781524332	\N	2017-11-02	\N	Kristina Mladenovic (+1.5 Sets)	\N	Julia Goerges (-1.5 Sets)	0	2017-11-01 10:55:06.740077+01	2017-11-02 03:00:00+01
462	\N	781524340	\N	2017-11-02	\N	Kristina Mladenovic (-1.5 Sets)	\N	Julia Goerges (+1.5 Sets)	0	2017-11-01 10:55:06.740077+01	2017-11-02 03:00:00+01
395	\N	737867067	\N	2017-06-19	\N	Donald Young	\N	Nick Kyrgios	1	2017-11-02 09:19:12.300425+01	2017-06-19 17:00:00+02
393	\N	781129933	\N	2017-11-01	\N	Alice Rame	\N	Conny Perrin	0	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
392	\N	781129895	\N	2017-11-01	\N	Lesley Kerkhove	\N	Anastasia Frolova	0	2017-11-01 16:23:32.613736+01	2017-11-01 12:15:00+01
396	\N	775332397	\N	2017-10-17	\N	E Mertens / D Schuurs	\N	N Dzalamidze / X Knoll	0	2017-11-02 09:19:12.300425+01	2017-10-17 11:00:00+02
256	479712	781788134	1.136229252	2017-11-01	\N	Lukas Lacko	\N	Corentin Moutet	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:00:00+01
408	\N	781185074	\N	2017-11-01	\N	Alexander Zverev (-1.5 Sets)	\N	Robin Haase (+1.5 Sets)	0	2017-11-01 12:17:12.469497+01	2017-11-01 11:00:00+01
398	\N	682422212	\N	2017-01-12	\N	Aliaksandra Sasnovich Game 8 of Set 3	\N	Paula Cristina Goncalves Game 8 of Set 3	1	2017-11-02 09:19:12.300425+01	2017-01-13 00:40:00+01
399	\N	682421658	\N	2017-01-12	\N	Aliaksandra Sasnovich Game 7 of Set 3	\N	Paula Cristina Goncalves Game 7 of Set 3	1	2017-11-02 09:19:12.300425+01	2017-01-13 00:40:00+01
431	\N	781479826	\N	2017-11-01	\N	Pablo Cuevas (+1.5 Sets)	\N	Albert Ramos-Vinolas (-1.5 Sets)	0	2017-11-01 15:37:39.078491+01	2017-11-01 13:00:00+01
438	\N	781504650	\N	2017-11-01	\N	Feliciano Lopez (-1.5 Sets)	\N	Lucas Pouille (+1.5 Sets)	0	2017-11-01 15:37:39.078491+01	2017-11-01 13:00:00+01
542	\N	781679886	\N	2017-11-01	\N	Jessika Ponchet	\N	Victoria Rodriguez	0	2017-11-01 16:23:32.613736+01	2017-11-01 15:05:00+01
486	\N	781382792	\N	2017-11-01	\N	Paula Ormaechea	\N	Ganna Poznikhirenko	0	2017-11-01 16:23:32.613736+01	2017-11-01 13:00:00+01
538	\N	781623894	\N	2017-11-02	\N	Filip Krajinovic (+1.5 Sets)	\N	Nicolas Mahut (-1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-02 10:00:00+01
470	\N	781779304	\N	2017-11-01	\N	Kristina Mladenovic Game 7 of Set 3	\N	Magdalena Rybarikova Game 7 of Set 3	1	2017-11-01 10:29:53.987897+01	2017-11-01 08:30:00+01
471	\N	781779801	\N	2017-11-01	\N	Kristina Mladenovic Game 8 of Set 3	\N	Magdalena Rybarikova Game 8 of Set 3	1	2017-11-01 10:29:53.987897+01	2017-11-01 08:30:00+01
539	\N	781623918	\N	2017-11-02	\N	Filip Krajinovic (-1.5 Sets)	\N	Nicolas Mahut (+1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-02 10:00:00+01
483	\N	781238628	\N	2017-11-01	\N	Agnes Bukta	\N	Vivien Juhaszova	0	2017-11-01 16:07:41.044699+01	2017-11-01 13:00:00+01
487	\N	781382826	\N	2017-11-01	\N	Chantal Skamlova	\N	Marie Benoit	0	2017-11-01 16:23:32.613736+01	2017-11-01 13:00:00+01
484	\N	781238837	\N	2017-11-01	\N	Polina Leykina	\N	Jessica Pieri	0	2017-11-01 15:37:39.078491+01	2017-11-01 13:00:00+01
485	\N	781239065	\N	2017-11-01	\N	Cindy Burger	\N	Irina Maria Bara	0	2017-11-01 15:37:39.078491+01	2017-11-01 13:00:00+01
489	\N	781383035	\N	2017-11-01	\N	Martina Caregaro	\N	Valeria Solovyeva	0	2017-11-01 16:23:32.613736+01	2017-11-01 13:00:00+01
490	\N	781383090	\N	2017-11-01	\N	Sara Cakarevic	\N	Cristina Ene	0	2017-11-01 16:23:32.613736+01	2017-11-01 13:00:00+01
488	\N	781382980	\N	2017-11-01	\N	Anastasiya Vasylyeva	\N	Cristina Dinu	0	2017-11-01 15:37:39.078491+01	2017-11-01 13:00:00+01
496	\N	781689050	\N	2017-11-01	\N	Jose Hernandez-Fernandez	\N	Nicolas Kicker	0	2017-11-01 16:23:32.613736+01	2017-11-01 21:00:00+01
507	\N	781342813	\N	2017-11-01	\N	Nicole Gibbs	\N	Grace Min	0	2017-11-01 16:23:32.613736+01	2017-11-01 17:35:00+01
508	\N	781343274	\N	2017-11-01	\N	Danielle Lao	\N	Cagla Buyukakcay	0	2017-11-01 16:23:32.613736+01	2017-11-01 16:50:00+01
509	\N	781345208	\N	2017-11-01	\N	Sesil Karatantcheva	\N	Julia Boserup	0	2017-11-01 16:23:32.613736+01	2017-11-01 16:05:00+01
510	\N	781345319	\N	2017-11-01	\N	Kayla Day	\N	Victoria Duval	0	2017-11-01 16:23:32.613736+01	2017-11-01 16:05:00+01
511	\N	781345490	\N	2017-11-01	\N	Irina Falconi	\N	Hanna Chang	0	2017-11-01 16:23:32.613736+01	2017-11-01 17:30:00+01
512	\N	781345633	\N	2017-11-01	\N	Stefanie Voegele	\N	Taylor Townsend	0	2017-11-01 16:23:32.613736+01	2017-11-01 16:50:00+01
513	\N	781737000	\N	2017-11-01	\N	Ashley Kratzer	\N	Anna Karolina Schmiedlova	0	2017-11-01 16:23:32.613736+01	2017-11-01 17:35:00+01
514	\N	781737077	\N	2017-11-01	\N	Sofia Kenin	\N	Amanda Rodgers	0	2017-11-01 16:23:32.613736+01	2017-11-01 16:05:00+01
515	\N	781737440	\N	2017-11-01	\N	Yuliya Lysa	\N	Amanda Anisimova	0	2017-11-01 16:23:32.613736+01	2017-11-01 16:05:00+01
516	\N	781737514	\N	2017-11-01	\N	Rebecca Peterson	\N	Caitlin Whoriskey	0	2017-11-01 16:23:32.613736+01	2017-11-01 16:50:00+01
520	\N	781714261	\N	2017-11-02	\N	Marc Polmans	\N	Benjamin Mitchell	0	2017-11-01 16:23:32.613736+01	2017-11-02 01:00:00+01
525	\N	781414715	\N	2017-11-02	\N	Austin Krajicek	\N	Duck Hee Lee	0	2017-11-01 16:23:32.613736+01	2017-11-02 03:00:00+01
528	\N	781431747	\N	2017-11-02	\N	Mikhail Youzhny	\N	Prajnesh Gunneswaran	0	2017-11-01 16:23:32.613736+01	2017-11-02 03:00:00+01
534	\N	781567062	\N	2017-11-01	\N	Laura Pigossi	\N	Georgina Garcia-Perez	0	2017-11-01 16:23:32.613736+01	2017-11-01 13:30:00+01
543	\N	781679945	\N	2017-11-02	\N	Valeria Savinykh	\N	Ysaline Bonaventure	0	2017-11-02 09:19:12.300425+01	2017-11-02 10:00:00+01
544	\N	781679986	\N	2017-11-02	\N	Carol Zhao	\N	Tamaryn Hendler	0	2017-11-02 09:19:12.300425+01	2017-11-02 10:00:00+01
529	\N	781566529	\N	2017-11-01	\N	Panna Udvardy	\N	Daniela Vismane	0	2017-11-01 12:17:12.469497+01	2017-11-01 11:00:00+01
517	\N	781395004	\N	2017-11-02	\N	Andrew Harris	\N	Alexander Sarkissian	0	2017-11-01 10:55:06.740077+01	2017-11-02 01:00:00+01
518	\N	781411611	\N	2017-11-02	\N	Blake Ellis	\N	Evan King	0	2017-11-01 10:55:06.740077+01	2017-11-02 01:00:00+01
530	\N	781566567	\N	2017-11-01	\N	Olga Danilovic	\N	Paula Badosa Gibert	0	2017-11-01 12:17:12.469497+01	2017-11-01 11:00:00+01
531	\N	781566751	\N	2017-11-01	\N	Marta Lesniak	\N	Paula Arias Manjon	0	2017-11-01 12:17:12.469497+01	2017-11-01 11:00:00+01
532	\N	781566781	\N	2017-11-01	\N	Anastasia Zarycka	\N	Misa Eguchi	0	2017-11-01 12:17:12.469497+01	2017-11-01 11:00:00+01
541	\N	781679833	\N	2017-11-01	\N	Michaela Honcova	\N	Ronit Yurovsky	0	2017-11-01 16:23:32.613736+01	2017-11-01 15:50:00+01
535	\N	781567122	\N	2017-11-01	\N	Melanie Stokke	\N	Nicoleta-Catalina Dascalu	0	2017-11-01 12:17:12.469497+01	2017-11-01 11:00:00+01
546	\N	781720247	\N	2017-11-02	\N	Bianca Vanessa Andreescu	\N	Kimberley Zimmermann	0	2017-11-02 09:19:12.300425+01	2017-11-02 10:00:00+01
547	\N	781720452	\N	2017-11-02	\N	Greta Arn	\N	Francesca Di Lorenzo	0	2017-11-02 09:19:12.300425+01	2017-11-02 10:00:00+01
545	\N	781686181	\N	2017-11-01	\N	Ann Li	\N	Patty Schnyder	0	2017-11-01 16:23:32.613736+01	2017-11-01 15:05:00+01
463	\N	781524416	\N	2017-11-02	\N	Angelique Kerber (+1.5 Sets)	\N	Ashleigh Barty (-1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-02 03:00:00+01
548	\N	781738620	\N	2017-11-01	\N	Katherine Sebov	\N	Elena Bovina	0	2017-11-01 16:23:32.613736+01	2017-11-01 17:35:00+01
549	\N	781717407	\N	2017-11-01	\N	Destanee Aiava	\N	Belinda Woolcock	0	2017-11-01 16:23:32.613736+01	2017-11-02 00:05:00+01
550	\N	781734893	\N	2017-11-02	\N	Erika Sema	\N	Julia Glushko	0	2017-11-01 16:23:32.613736+01	2017-11-02 03:05:00+01
551	\N	781739971	\N	2017-11-02	\N	Olivia Tjandramulia	\N	Tamara Zidansek	0	2017-11-01 16:23:32.613736+01	2017-11-02 03:05:00+01
552	\N	781771521	\N	2017-11-02	\N	Arina Rodionova	\N	Alison Bai	0	2017-11-01 16:23:32.613736+01	2017-11-02 03:05:00+01
464	\N	781524422	\N	2017-11-02	\N	Angelique Kerber (-1.5 Sets)	\N	Ashleigh Barty (+1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-02 03:00:00+01
480	\N	781565446	\N	2017-11-02	\N	Salma Djoubri	\N	Richel Hogenkamp	0	2017-11-02 09:19:12.300425+01	2017-11-02 10:00:00+01
481	\N	781677813	\N	2017-11-02	\N	Alexandra Dulgheru	\N	Jesika Maleckova	0	2017-11-02 09:19:12.300425+01	2017-11-02 10:00:00+01
475	\N	781558804	\N	2017-11-01	\N	A Rosolska / A Smith	\N	J-J Lu / S Zhang	0	2017-11-01 16:23:32.613736+01	2017-11-01 13:30:00+01
477	\N	781237376	\N	2017-11-01	\N	Karolina Muchova	\N	Diana Marcinkevica	0	2017-11-01 16:23:32.613736+01	2017-11-01 13:00:00+01
476	\N	781236185	\N	2017-11-01	\N	Bernarda Pera	\N	Audrey Albie	0	2017-11-01 16:07:41.044699+01	2017-11-01 13:00:00+01
478	\N	781565200	\N	2017-11-01	\N	Kaia Kanepi	\N	Mari Osaka	0	2017-11-01 16:23:32.613736+01	2017-11-01 13:45:00+01
479	\N	781565240	\N	2017-11-01	\N	Elena Gabriela Ruse	\N	Anna Blinkova	0	2017-11-01 16:23:32.613736+01	2017-11-01 13:45:00+01
482	\N	781238582	\N	2017-11-01	\N	Nina Potocnik	\N	Julia Grabher	0	2017-11-01 16:23:32.613736+01	2017-11-01 13:45:00+01
533	\N	781566821	\N	2017-11-01	\N	Miriam Bianca Bulgaru	\N	Marta Paigina	0	2017-11-01 16:07:41.044699+01	2017-11-01 13:00:00+01
536	\N	781567664	\N	2017-11-01	\N	Rebeka Masarova	\N	Maria-Teresa Torro-Flor	0	2017-11-01 16:23:32.613736+01	2017-11-01 13:00:00+01
474	\N	781781242	\N	2017-11-01	\N	Kristina Mladenovic Game 11 of Set 3	\N	Magdalena Rybarikova Game 11 of Set 3	1	2017-11-01 10:55:06.740077+01	2017-11-01 08:30:00+01
472	\N	781780230	\N	2017-11-01	\N	Kristina Mladenovic Game 9 of Set 3	\N	Magdalena Rybarikova Game 9 of Set 3	1	2017-11-01 10:42:24.23209+01	2017-11-01 08:30:00+01
473	\N	781780882	\N	2017-11-01	\N	Kristina Mladenovic Game 10 of Set 3	\N	Magdalena Rybarikova Game 10 of Set 3	1	2017-11-01 10:42:24.23209+01	2017-11-01 08:30:00+01
540	\N	781678970	\N	2017-11-02	\N	Polona Hercog	\N	Tena Lukas	0	2017-11-02 09:19:12.300425+01	2017-11-02 10:00:00+01
449	\N	781763836	\N	2017-11-01	\N	Kristina Mladenovic	\N	Magdalena Rybarikova	1	2017-11-01 10:55:06.740077+01	2017-11-01 08:30:00+01
2987	\N	781193648	\N	2017-11-03	\N	Elena Vesnina	\N	Shuai Peng	0	2017-11-02 09:19:12.300425+01	2017-11-03 03:00:00+01
2916	\N	781789109	\N	2017-11-01	\N	Felix Auger Alliassime To Win Set 2	\N	Jerzy Janowicz To Win Set 2	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
2917	\N	781800398	\N	2017-11-01	\N	Lukas Lacko Game 1 of Set 3	\N	Corentin Moutet Game 1 of Set 3	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
467	\N	781524440	\N	2017-11-02	\N	Anastasija Sevastova (+1.5 Sets)	\N	Barbora Strycova (-1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-02 03:00:00+01
468	\N	781524452	\N	2017-11-02	\N	Anastasija Sevastova (-1.5 Sets)	\N	Barbora Strycova (+1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-02 03:00:00+01
2918	\N	781800401	\N	2017-11-01	\N	Lukas Lacko Game 2 of Set 3	\N	Corentin Moutet Game 2 of Set 3	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
2919	\N	781800783	\N	2017-11-01	\N	Felix Auger Alliassime Game 1 of Set 2	\N	Jerzy Janowicz Game 1 of Set 2	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
411	\N	781211755	\N	2017-11-01	\N	Roberto Bautista Agut (+1.5 Sets)	\N	Jeremy Chardy (-1.5 Sets)	0	2017-11-01 16:23:32.613736+01	2017-11-01 21:00:00+01
2867	482942	\N	1.136359599	2017-11-02	\N	Ghedin/Shyla	\N	Li/Polansky	\N	2017-11-02 08:39:12.946077+01	2017-11-02 08:00:00+01
351	481938	781392329	1.136315461	2017-11-02	\N	Soon Woo Kwon	\N	Peter Polansky	0	2017-11-01 16:23:32.613736+01	2017-11-02 03:00:00+01
2920	\N	781800785	\N	2017-11-01	\N	Felix Auger Alliassime Game 2 of Set 2	\N	Jerzy Janowicz Game 2 of Set 2	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
2921	\N	781800845	\N	2017-11-01	\N	Lukas Lacko Game 3 of Set 3	\N	Corentin Moutet Game 3 of Set 3	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
2922	\N	781801176	\N	2017-11-01	\N	Felix Auger Alliassime Game 3 of Set 2	\N	Jerzy Janowicz Game 3 of Set 2	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
2923	\N	781801411	\N	2017-11-01	\N	Felix Auger Alliassime Game 4 of Set 2	\N	Jerzy Janowicz Game 4 of Set 2	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
465	\N	781524428	\N	2017-11-02	\N	Elena Vesnina (+1.5 Sets)	\N	Shuai Peng (-1.5 Sets)	0	2017-11-01 10:55:06.740077+01	2017-11-02 03:00:00+01
2924	\N	781801484	\N	2017-11-01	\N	Lukas Lacko Game 4 of Set 3	\N	Corentin Moutet Game 4 of Set 3	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
2925	\N	781801937	\N	2017-11-01	\N	Lukas Lacko Game 5 of Set 3	\N	Corentin Moutet Game 5 of Set 3	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
2926	\N	781801980	\N	2017-11-01	\N	Felix Auger Alliassime Game 5 of Set 2	\N	Jerzy Janowicz Game 5 of Set 2	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
466	\N	781524432	\N	2017-11-02	\N	Elena Vesnina (-1.5 Sets)	\N	Shuai Peng (+1.5 Sets)	0	2017-11-01 10:55:06.740077+01	2017-11-02 03:00:00+01
381	\N	781573297	\N	2017-11-02	\N	B Bryan / M Bryan	\N	J Benneteau / E Roger-Vasselin	0	2017-11-02 09:19:12.300425+01	2017-11-02 10:00:00+01
553	\N	781771559	\N	2017-11-02	\N	Kaylah Mcphee	\N	Jennifer Elie	0	2017-11-01 16:23:32.613736+01	2017-11-02 01:05:00+01
1733	\N	781781979	\N	2017-11-01	\N	Kristina Mladenovic Game 12 of Set 3	\N	Magdalena Rybarikova Game 12 of Set 3	1	2017-11-01 10:55:06.740077+01	2017-11-01 08:30:00+01
1734	\N	781783140	\N	2017-11-01	\N	Kristina Mladenovic Game 13 of Set 3	\N	Magdalena Rybarikova Game 13 of Set 3	1	2017-11-01 10:55:06.740077+01	2017-11-01 08:30:00+01
2878	482948	\N	1.136359095	2017-11-02	\N	Olaru/Savchuk	\N	Duan/Han	\N	2017-11-02 09:19:12.151315+01	2017-11-02 14:00:00+01
425	\N	781474864	\N	2017-11-01	\N	Jack Sock (+1.5 Sets)	\N	Kyle Edmund (-1.5 Sets)	0	2017-11-01 16:23:32.613736+01	2017-11-01 17:00:00+01
554	\N	781771696	\N	2017-11-01	\N	Abigail Tere-Apisah	\N	Ellen Perez	0	2017-11-01 16:23:32.613736+01	2017-11-02 00:50:00+01
557	\N	781735291	\N	2017-11-02	\N	Jessica Pegula	\N	Kristie Ahn	0	2017-11-02 09:19:12.300425+01	2017-11-02 16:00:00+01
556	\N	781735235	\N	2017-11-02	\N	Jamie Loeb	\N	Danielle Rose Collins	0	2017-11-02 09:19:12.300425+01	2017-11-02 16:00:00+01
345	482826	781739907	1.136355998	2017-11-01	\N	Victor Estrella Burgos	\N	Marcelo Arevalo	0	2017-11-01 16:23:32.613736+01	2017-11-02 00:00:00+01
362	482552	781738697	1.136345702	2017-11-02	\N	Simone Bolelli	\N	Maximilian Marterer	0	2017-11-02 09:19:12.300425+01	2017-11-02 10:00:00+01
555	\N	781771916	\N	2017-11-02	\N	Alexandra Bozovic	\N	Lizette Cabrera	0	2017-11-01 16:23:32.613736+01	2017-11-02 03:05:00+01
564	\N	781744231	\N	2017-11-03	\N	Omar Jasika	\N	Taro Daniel	0	2017-11-02 09:19:12.300425+01	2017-11-03 01:00:00+01
405	\N	683762536	\N	2017-01-16	\N	Stefanie Voegele Game 9 of Set 2	\N	Kurumi Nara Game 9 of Set 2	1	2017-11-02 09:19:12.300425+01	2017-01-16 06:00:00+01
294	480400	\N	1.136257075	2017-11-01	\N	Brunstrom/Nys	\N	Pel/Sijsling	\N	2017-11-01 12:17:11.971725+01	2017-11-01 15:00:00+01
422	\N	781470314	\N	2017-11-01	\N	John Isner (+1.5 Sets)	\N	Diego Sebastian Schwartzman (-1.5 Sets)	0	2017-11-01 12:17:12.469497+01	2017-11-01 11:00:00+01
423	\N	781470323	\N	2017-11-01	\N	John Isner (-1.5 Sets)	\N	Diego Sebastian Schwartzman (+1.5 Sets)	0	2017-11-01 12:17:12.469497+01	2017-11-01 11:00:00+01
565	\N	781762068	\N	2017-11-03	\N	Alex Bolt	\N	Gavin Van Peperzeel	0	2017-11-02 09:19:12.300425+01	2017-11-03 01:00:00+01
255	481282	781784376	1.136280206	2017-11-01	\N	Alexander Zverev	\N	Robin Haase	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:00:00+01
2972	\N	781788787	\N	2017-11-01	\N	John Isner To Win Set 2	\N	Diego Sebastian Schwartzman To Win Set 2	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
2973	\N	781789075	\N	2017-11-01	\N	Alexander Zverev To Win Set 2	\N	Robin Haase To Win Set 2	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
2974	\N	781798203	\N	2017-11-01	\N	Alexander Zverev Game 5 of Set 2	\N	Robin Haase Game 5 of Set 2	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
2975	\N	781799157	\N	2017-11-01	\N	Alexander Zverev Game 6 of Set 2	\N	Robin Haase Game 6 of Set 2	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
2976	\N	781799740	\N	2017-11-01	\N	John Isner Game 2 of Set 2	\N	D. Sebastian Schwartzman Game 2 of Set 2	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
2977	\N	781800256	\N	2017-11-01	\N	John Isner Game 3 of Set 2	\N	D. Sebastian Schwartzman Game 3 of Set 2	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
2978	\N	781800521	\N	2017-11-01	\N	Alexander Zverev Game 7 of Set 2	\N	Robin Haase Game 7 of Set 2	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
2979	\N	781800755	\N	2017-11-01	\N	John Isner Game 4 of Set 2	\N	D. Sebastian Schwartzman Game 4 of Set 2	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
2980	\N	781801200	\N	2017-11-01	\N	John Isner Game 5 of Set 2	\N	D. Sebastian Schwartzman Game 5 of Set 2	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
2985	\N	781189870	\N	2017-11-03	\N	Kristina Mladenovic	\N	Julia Goerges	0	2017-11-02 09:19:12.300425+01	2017-11-03 03:00:00+01
2981	\N	781801366	\N	2017-11-01	\N	Alexander Zverev Game 8 of Set 2	\N	Robin Haase Game 8 of Set 2	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
251	482065	\N	1.136319344	2017-11-01	\N	Anastasia Pavlyuchenkov	\N	Ashleigh Barty	\N	2017-11-01 10:55:06.447068+01	2017-11-01 10:30:00+01
2982	\N	781801899	\N	2017-11-01	\N	Alexander Zverev Game 9 of Set 2	\N	Robin Haase Game 9 of Set 2	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
3005	\N	781789868	\N	2017-11-01	\N	Anastasia Pavlyuchenkova To Win Set 2	\N	Ashleigh Barty To Win Set 2	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
3006	\N	781797938	\N	2017-11-01	\N	Anastasia Pavlyuchenkova Game 2 of Set 2	\N	Ashleigh Barty Game 2 of Set 2	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
3007	\N	781798464	\N	2017-11-01	\N	Anastasia Pavlyuchenkova Game 3 of Set 2	\N	Ashleigh Barty Game 3 of Set 2	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
3008	\N	781800060	\N	2017-11-01	\N	Anastasia Pavlyuchenkova Game 4 of Set 2	\N	Ashleigh Barty Game 4 of Set 2	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
3009	\N	781801006	\N	2017-11-01	\N	Anastasia Pavlyuchenkova Game 5 of Set 2	\N	Ashleigh Barty Game 5 of Set 2	1	2017-11-01 12:17:12.469497+01	2017-11-01 11:30:00+01
3256	\N	781848040	\N	2017-11-01	\N	Fernando Verdasco Game 3 of Set 2	\N	Kevin Anderson Game 3 of Set 2	1	2017-11-01 15:20:48.113529+01	2017-11-01 14:30:00+01
3258	\N	781848681	\N	2017-11-01	\N	Rafael Nadal Game 6 of Set 1	\N	Hyeon Chung Game 6 of Set 1	1	2017-11-01 15:20:48.113529+01	2017-11-01 15:00:00+01
3249	\N	781844423	\N	2017-11-01	\N	Rafael Nadal Game 3 of Set 1	\N	Hyeon Chung Game 3 of Set 1	1	2017-11-01 15:06:55.631982+01	2017-11-01 15:00:00+01
3251	\N	781845600	\N	2017-11-01	\N	Rafael Nadal Game 4 of Set 1	\N	Hyeon Chung Game 4 of Set 1	1	2017-11-01 15:06:55.631982+01	2017-11-01 15:00:00+01
3252	\N	781846397	\N	2017-11-01	\N	Pablo Cuevas Game 3 of Set 3	\N	Albert Ramos-Vinolas Game 3 of Set 3	1	2017-11-01 15:06:55.631982+01	2017-11-01 13:00:00+01
3253	\N	781846468	\N	2017-11-01	\N	Rafael Nadal Game 5 of Set 1	\N	Hyeon Chung Game 5 of Set 1	1	2017-11-01 15:06:55.631982+01	2017-11-01 15:00:00+01
3254	\N	781847242	\N	2017-11-01	\N	Fernando Verdasco Game 1 of Set 2	\N	Kevin Anderson Game 1 of Set 2	1	2017-11-01 15:06:55.631982+01	2017-11-01 14:30:00+01
3255	\N	781847257	\N	2017-11-01	\N	Fernando Verdasco Game 2 of Set 2	\N	Kevin Anderson Game 2 of Set 2	1	2017-11-01 15:06:55.631982+01	2017-11-01 14:30:00+01
3257	\N	781848047	\N	2017-11-01	\N	Pablo Cuevas Game 4 of Set 3	\N	Albert Ramos-Vinolas Game 4 of Set 3	1	2017-11-01 15:06:55.631982+01	2017-11-01 13:00:00+01
3259	\N	781849826	\N	2017-11-01	\N	Pablo Cuevas Game 5 of Set 3	\N	Albert Ramos-Vinolas Game 5 of Set 3	1	2017-11-01 15:06:55.631982+01	2017-11-01 13:00:00+01
324	481792	781298198	1.136310506	2017-11-01	\N	Casper Ruud	\N	Facundo Bagnis	0	2017-11-01 16:23:32.613736+01	2017-11-01 19:00:00+01
3248	\N	781844420	\N	2017-11-01	\N	Rafael Nadal To Win Set 1	\N	Hyeon Chung To Win Set 1	1	2017-11-01 15:37:39.078491+01	2017-11-01 15:00:00+01
3280	\N	781841114	\N	2017-11-03	\N	Sloane Stephens	\N	Barbora Strycova	0	2017-11-02 09:19:12.300425+01	2017-11-03 03:00:00+01
3001	\N	781524432	\N	2017-11-03	\N	Elena Vesnina (-1.5 Sets)	\N	Shuai Peng (+1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-03 03:00:00+01
3528	\N	781851088	\N	2017-11-01	\N	Pablo Cuevas Game 7 of Set 3	\N	Albert Ramos-Vinolas Game 7 of Set 3	1	2017-11-01 15:21:11.576534+01	2017-11-01 13:00:00+01
3529	\N	781851116	\N	2017-11-01	\N	Fernando Verdasco Game 5 of Set 2	\N	Kevin Anderson Game 5 of Set 2	1	2017-11-01 15:21:11.576534+01	2017-11-01 14:30:00+01
3530	\N	781852453	\N	2017-11-01	\N	Rafael Nadal Game 8 of Set 1	\N	Hyeon Chung Game 8 of Set 1	1	2017-11-01 15:21:11.576534+01	2017-11-01 15:00:00+01
3367	\N	781844630	\N	2017-11-01	\N	Ruben Bemelmans Game 4 of Set 3	\N	Luca Vanni Game 4 of Set 3	1	2017-11-01 15:06:55.631982+01	2017-11-01 13:00:00+01
3368	\N	781847745	\N	2017-11-01	\N	Ruben Bemelmans Game 5 of Set 3	\N	Luca Vanni Game 5 of Set 3	1	2017-11-01 15:06:55.631982+01	2017-11-01 13:00:00+01
3369	\N	781848927	\N	2017-11-01	\N	Ruben Bemelmans Game 6 of Set 3	\N	Luca Vanni Game 6 of Set 3	1	2017-11-01 15:06:55.631982+01	2017-11-01 13:00:00+01
3370	\N	781850234	\N	2017-11-01	\N	Ruben Bemelmans Game 7 of Set 3	\N	Luca Vanni Game 7 of Set 3	1	2017-11-01 15:06:55.631982+01	2017-11-01 13:00:00+01
3371	\N	781850864	\N	2017-11-01	\N	Ruben Bemelmans Game 8 of Set 3	\N	Luca Vanni Game 8 of Set 3	1	2017-11-01 15:06:55.631982+01	2017-11-01 13:00:00+01
3250	\N	781844422	\N	2017-11-01	\N	Rafael Nadal To Win Set 2	\N	Hyeon Chung To Win Set 2	1	2017-11-01 16:23:32.613736+01	2017-11-01 15:00:00+01
346	481945	781411611	1.136317406	2017-11-01	\N	Blake Ellis	\N	Evan King	0	2017-11-01 16:23:32.613736+01	2017-11-02 00:00:00+01
3000	\N	781524428	\N	2017-11-03	\N	Elena Vesnina (+1.5 Sets)	\N	Shuai Peng (-1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-03 03:00:00+01
3168	483034	781808944	1.136371032	2017-11-02	\N	Igor Sijsling	\N	Jerzy Janowicz	0	2017-11-02 09:19:12.300425+01	2017-11-02 10:00:00+01
3260	\N	781850494	\N	2017-11-01	\N	Fernando Verdasco Game 4 of Set 2	\N	Kevin Anderson Game 4 of Set 2	1	2017-11-01 15:21:11.576534+01	2017-11-01 14:30:00+01
3531	\N	781852524	\N	2017-11-01	\N	Pablo Cuevas Game 8 of Set 3	\N	Albert Ramos-Vinolas Game 8 of Set 3	1	2017-11-01 15:21:11.576534+01	2017-11-01 13:00:00+01
3532	\N	781853172	\N	2017-11-01	\N	Fernando Verdasco Game 6 of Set 2	\N	Kevin Anderson Game 6 of Set 2	1	2017-11-01 15:21:11.576534+01	2017-11-01 14:30:00+01
3533	\N	781853181	\N	2017-11-01	\N	Rafael Nadal Game 9 of Set 1	\N	Hyeon Chung Game 9 of Set 1	1	2017-11-01 15:21:11.576534+01	2017-11-01 15:00:00+01
348	482040	781420372	1.136317642	2017-11-02	\N	Matthew Ebden	\N	Jose Statham	0	2017-11-01 16:23:32.613736+01	2017-11-02 01:30:00+01
2997	\N	781524340	\N	2017-11-03	\N	Kristina Mladenovic (-1.5 Sets)	\N	Julia Goerges (+1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-03 03:00:00+01
3175	483040	781808947	1.136369726	2017-11-02	\N	Corentin Moutet	\N	Yann Marti	0	2017-11-02 09:19:12.300425+01	2017-11-02 10:00:00+01
3246	\N	781838330	\N	2017-11-01	\N	Fernando Verdasco To Win Set 2	\N	Kevin Anderson To Win Set 2	1	2017-11-01 15:37:39.078491+01	2017-11-01 14:30:00+01
3261	\N	781850539	\N	2017-11-01	\N	Rafael Nadal Game 7 of Set 1	\N	Hyeon Chung Game 7 of Set 1	1	2017-11-01 15:21:11.576534+01	2017-11-01 15:00:00+01
3262	\N	781850717	\N	2017-11-01	\N	Pablo Cuevas Game 6 of Set 3	\N	Albert Ramos-Vinolas Game 6 of Set 3	1	2017-11-01 15:21:11.576534+01	2017-11-01 13:00:00+01
3534	\N	781853180	\N	2017-11-01	\N	Pablo Cuevas Game 9 of Set 3	\N	Albert Ramos-Vinolas Game 9 of Set 3	1	2017-11-01 15:21:11.576534+01	2017-11-01 13:00:00+01
3536	\N	781854105	\N	2017-11-01	\N	Rafael Nadal Game 10 of Set 1	\N	Hyeon Chung Game 10 of Set 1	1	2017-11-01 15:37:39.078491+01	2017-11-01 15:00:00+01
3535	\N	781853976	\N	2017-11-01	\N	Fernando Verdasco Game 7 of Set 2	\N	Kevin Anderson Game 7 of Set 2	1	2017-11-01 15:21:11.576534+01	2017-11-01 14:30:00+01
3537	\N	781854201	\N	2017-11-01	\N	Pablo Cuevas Game 10 of Set 3	\N	Albert Ramos-Vinolas Game 10 of Set 3	1	2017-11-01 15:21:11.576534+01	2017-11-01 13:00:00+01
2996	\N	781524332	\N	2017-11-03	\N	Kristina Mladenovic (+1.5 Sets)	\N	Julia Goerges (-1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-03 03:00:00+01
4296	\N	781859393	\N	2017-11-01	\N	Rafael Nadal Game 2 of Set 2	\N	Hyeon Chung Game 2 of Set 2	1	2017-11-01 16:07:41.044699+01	2017-11-01 15:00:00+01
4297	\N	781860044	\N	2017-11-01	\N	Rafael Nadal Game 3 of Set 2	\N	Hyeon Chung Game 3 of Set 2	1	2017-11-01 16:07:41.044699+01	2017-11-01 15:00:00+01
4054	\N	781854838	\N	2017-11-01	\N	Rafael Nadal Game 11 of Set 1	\N	Hyeon Chung Game 11 of Set 1	1	2017-11-01 15:37:39.078491+01	2017-11-01 15:00:00+01
4055	\N	781855600	\N	2017-11-01	\N	Fernando Verdasco Game 8 of Set 2	\N	Kevin Anderson Game 8 of Set 2	1	2017-11-01 15:37:39.078491+01	2017-11-01 14:30:00+01
4056	\N	781856789	\N	2017-11-01	\N	Fernando Verdasco Game 9 of Set 2	\N	Kevin Anderson Game 9 of Set 2	1	2017-11-01 15:37:39.078491+01	2017-11-01 14:30:00+01
4057	\N	781857014	\N	2017-11-01	\N	Rafael Nadal Game 12 of Set 1	\N	Hyeon Chung Game 12 of Set 1	1	2017-11-01 15:37:39.078491+01	2017-11-01 15:00:00+01
4058	\N	781857668	\N	2017-11-01	\N	Fernando Verdasco Game 10 of Set 2	\N	Kevin Anderson Game 10 of Set 2	1	2017-11-01 15:37:39.078491+01	2017-11-01 14:30:00+01
4059	\N	781857698	\N	2017-11-01	\N	Rafael Nadal Game 13 of Set 1	\N	Hyeon Chung Game 13 of Set 1	1	2017-11-01 15:37:39.078491+01	2017-11-01 15:00:00+01
4060	\N	781858044	\N	2017-11-01	\N	Fernando Verdasco Game 11 of Set 2	\N	Kevin Anderson Game 11 of Set 2	1	2017-11-01 15:37:39.078491+01	2017-11-01 14:30:00+01
4061	\N	781858920	\N	2017-11-01	\N	Fernando Verdasco Game 12 of Set 2	\N	Kevin Anderson Game 12 of Set 2	1	2017-11-01 15:37:39.078491+01	2017-11-01 14:30:00+01
4298	\N	781861019	\N	2017-11-01	\N	Rafael Nadal Game 4 of Set 2	\N	Hyeon Chung Game 4 of Set 2	1	2017-11-01 16:07:41.044699+01	2017-11-01 15:00:00+01
4299	\N	781861478	\N	2017-11-01	\N	Fernando Verdasco Game 4 of Set 3	\N	Kevin Anderson Game 4 of Set 3	1	2017-11-01 16:07:41.044699+01	2017-11-01 14:30:00+01
4300	\N	781861950	\N	2017-11-01	\N	Rafael Nadal Game 5 of Set 2	\N	Hyeon Chung Game 5 of Set 2	1	2017-11-01 16:07:41.044699+01	2017-11-01 15:00:00+01
4301	\N	781862495	\N	2017-11-01	\N	Fernando Verdasco Game 5 of Set 3	\N	Kevin Anderson Game 5 of Set 3	1	2017-11-01 16:07:41.044699+01	2017-11-01 14:30:00+01
4303	\N	781864544	\N	2017-11-01	\N	Fernando Verdasco Game 6 of Set 3	\N	Kevin Anderson Game 6 of Set 3	1	2017-11-01 16:07:41.044699+01	2017-11-01 14:30:00+01
4304	\N	781867177	\N	2017-11-01	\N	Fernando Verdasco Game 7 of Set 3	\N	Kevin Anderson Game 7 of Set 3	1	2017-11-01 16:07:41.044699+01	2017-11-01 14:30:00+01
4406	\N	781862632	\N	2017-11-01	\N	Mirza Basic Game 5 of Set 1	\N	Alexander Bublik Game 5 of Set 1	1	2017-11-01 16:07:41.044699+01	2017-11-01 15:46:02+01
4407	\N	781864731	\N	2017-11-01	\N	Mirza Basic Game 6 of Set 1	\N	Alexander Bublik Game 6 of Set 1	1	2017-11-01 16:07:41.044699+01	2017-11-01 15:46:02+01
4408	\N	781866945	\N	2017-11-01	\N	Mirza Basic Game 7 of Set 1	\N	Alexander Bublik Game 7 of Set 1	1	2017-11-01 16:07:41.044699+01	2017-11-01 15:46:02+01
4409	\N	781867737	\N	2017-11-01	\N	Mirza Basic Game 8 of Set 1	\N	Alexander Bublik Game 8 of Set 1	1	2017-11-01 16:07:41.044699+01	2017-11-01 15:46:02+01
4302	\N	781863936	\N	2017-11-01	\N	Rafael Nadal Game 6 of Set 2	\N	Hyeon Chung Game 6 of Set 2	1	2017-11-01 16:23:32.613736+01	2017-11-01 15:00:00+01
4305	\N	781867931	\N	2017-11-01	\N	Fernando Verdasco Game 8 of Set 3	\N	Kevin Anderson Game 8 of Set 3	1	2017-11-01 16:23:32.613736+01	2017-11-01 14:30:00+01
4549	\N	781868565	\N	2017-11-01	\N	Fernando Verdasco Game 9 of Set 3	\N	Kevin Anderson Game 9 of Set 3	1	2017-11-01 16:23:32.613736+01	2017-11-01 14:30:00+01
4550	\N	781868602	\N	2017-11-01	\N	Rafael Nadal Game 7 of Set 2	\N	Hyeon Chung Game 7 of Set 2	1	2017-11-01 16:23:32.613736+01	2017-11-01 15:00:00+01
4551	\N	781869752	\N	2017-11-01	\N	Rafael Nadal Game 8 of Set 2	\N	Hyeon Chung Game 8 of Set 2	1	2017-11-01 16:23:32.613736+01	2017-11-01 15:00:00+01
4552	\N	781869755	\N	2017-11-01	\N	Fernando Verdasco Game 10 of Set 3	\N	Kevin Anderson Game 10 of Set 3	1	2017-11-01 16:23:32.613736+01	2017-11-01 14:30:00+01
4553	\N	781870327	\N	2017-11-01	\N	Fernando Verdasco Game 11 of Set 3	\N	Kevin Anderson Game 11 of Set 3	1	2017-11-01 16:23:32.613736+01	2017-11-01 14:30:00+01
4554	\N	781870739	\N	2017-11-01	\N	Rafael Nadal Game 9 of Set 2	\N	Hyeon Chung Game 9 of Set 2	1	2017-11-01 16:23:32.613736+01	2017-11-01 15:00:00+01
4555	\N	781872177	\N	2017-11-01	\N	Rafael Nadal Game 10 of Set 2	\N	Hyeon Chung Game 10 of Set 2	1	2017-11-01 16:23:32.613736+01	2017-11-01 15:00:00+01
4404	\N	781861238	\N	2017-11-01	\N	Mirza Basic To Win Set 1	\N	Alexander Bublik To Win Set 1	1	2017-11-01 16:23:32.613736+01	2017-11-01 15:46:02+01
4405	\N	781861243	\N	2017-11-01	\N	Mirza Basic To Win Set 2	\N	Alexander Bublik To Win Set 2	1	2017-11-01 16:23:32.613736+01	2017-11-01 15:46:02+01
4410	\N	781868088	\N	2017-11-01	\N	Mirza Basic Game 9 of Set 1	\N	Alexander Bublik Game 9 of Set 1	1	2017-11-01 16:23:32.613736+01	2017-11-01 15:46:02+01
4654	\N	781868908	\N	2017-11-01	\N	Mirza Basic Game 10 of Set 1	\N	Alexander Bublik Game 10 of Set 1	1	2017-11-01 16:23:32.613736+01	2017-11-01 15:46:02+01
4655	\N	781870527	\N	2017-11-01	\N	Mirza Basic Game 11 of Set 1	\N	Alexander Bublik Game 11 of Set 1	1	2017-11-01 16:23:32.613736+01	2017-11-01 15:46:02+01
4656	\N	781871800	\N	2017-11-01	\N	Mirza Basic Game 12 of Set 1	\N	Alexander Bublik Game 12 of Set 1	1	2017-11-01 16:23:32.613736+01	2017-11-01 15:46:02+01
4657	\N	781872206	\N	2017-11-01	\N	Mirza Basic Game 13 of Set 1	\N	Alexander Bublik Game 13 of Set 1	1	2017-11-01 16:23:32.613736+01	2017-11-01 15:46:02+01
4724	\N	782171290	\N	2017-11-02	\N	Angelique Kerber To Win Set 1	\N	Ashleigh Barty To Win Set 1	1	2017-11-02 08:39:13.077386+01	2017-11-02 08:30:00+01
4726	\N	782173305	\N	2017-11-02	\N	Angelique Kerber Game 7 of Set 1	\N	Ashleigh Barty Game 7 of Set 1	1	2017-11-02 08:39:13.077386+01	2017-11-02 08:30:00+01
4727	\N	782173746	\N	2017-11-02	\N	Angelique Kerber Game 8 of Set 1	\N	Ashleigh Barty Game 8 of Set 1	1	2017-11-02 08:39:13.077386+01	2017-11-02 08:30:00+01
4728	\N	782174534	\N	2017-11-02	\N	Angelique Kerber Game 9 of Set 1	\N	Ashleigh Barty Game 9 of Set 1	1	2017-11-02 08:39:13.077386+01	2017-11-02 08:30:00+01
4729	\N	782175232	\N	2017-11-02	\N	Angelique Kerber Game 10 of Set 1	\N	Ashleigh Barty Game 10 of Set 1	1	2017-11-02 08:39:13.077386+01	2017-11-02 08:30:00+01
4730	\N	782175545	\N	2017-11-02	\N	Angelique Kerber Game 11 of Set 1	\N	Ashleigh Barty Game 11 of Set 1	1	2017-11-02 08:39:13.077386+01	2017-11-02 08:30:00+01
4668	483428	\N	1.136374972	2017-11-02	\N	Brunstrom/Nys	\N	Bury/Siljestrom	\N	2017-11-02 09:19:12.151315+01	2017-11-02 15:30:00+01
4679	482699	\N	1.136352997	2017-11-03	\N	Stefan Kozlov	\N	Liam Broady	\N	2017-11-02 09:19:12.151315+01	2017-11-03 01:00:00+01
4687	\N	782160517	\N	2017-11-03	\N	J Murray / B Soares	\N	P-H Herbert / N Mahut	0	2017-11-02 09:19:12.300425+01	2017-11-03 10:00:00+01
4676	483418	781879108	1.136374805	2017-11-02	\N	Rafael Nadal	\N	Pablo Cuevas	0	2017-11-02 09:19:12.300425+01	2017-11-02 19:30:00+01
4745	\N	781906648	\N	2017-11-02	\N	Robin Haase	\N	Juan Martin Del Potro	0	2017-11-02 09:19:12.300425+01	2017-11-02 11:00:00+01
4680	482639	\N	1.136352766	2017-11-03	\N	Andreozzi/Gonzalez	\N	Rola/Romboli	\N	2017-11-02 09:19:12.151315+01	2017-11-03 01:00:00+01
4681	482643	\N	1.136352762	2017-11-03	\N	Arneodo/Cecchinato	\N	Arevalo/Reyes-Varela	\N	2017-11-02 09:19:12.151315+01	2017-11-03 01:30:00+01
4682	482707	\N	1.136352937	2017-11-03	\N	Dellien/Zeballos	\N	Cuevas/Estrella Burgos	\N	2017-11-02 09:19:12.151315+01	2017-11-03 01:30:00+01
4721	\N	781940535	\N	2017-11-03	\N	Sloane Stephens (+1.5 Sets)	\N	Barbora Strycova (-1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-03 03:00:00+01
4722	\N	781940541	\N	2017-11-03	\N	Sloane Stephens (-1.5 Sets)	\N	Barbora Strycova (+1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-03 03:00:00+01
4725	\N	782171292	\N	2017-11-02	\N	Angelique Kerber To Win Set 2	\N	Ashleigh Barty To Win Set 2	1	2017-11-02 09:19:12.300425+01	2017-11-02 08:30:00+01
4731	\N	781976035	\N	2017-11-02	\N	I R Olaru / O Savchuk	\N	Y Y Duan / X Han	0	2017-11-02 09:19:12.300425+01	2017-11-02 13:30:00+01
4734	\N	781885675	\N	2017-11-02	\N	Conny Perrin	\N	Jana Cepelova	0	2017-11-02 09:19:12.300425+01	2017-11-02 13:15:00+01
4735	\N	781886951	\N	2017-11-02	\N	Lesley Kerkhove	\N	Olga Ianchuk	0	2017-11-02 09:19:12.300425+01	2017-11-02 12:30:00+01
4663	483414	781879106	1.136374976	2017-11-02	\N	Dominic Thiem	\N	Fernando Verdasco	0	2017-11-02 09:19:12.300425+01	2017-11-02 12:30:00+01
4746	\N	781908867	\N	2017-11-02	\N	Dominic Thiem (+1.5 Sets)	\N	Fernando Verdasco (-1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-02 13:00:00+01
4747	\N	781908875	\N	2017-11-02	\N	Dominic Thiem (-1.5 Sets)	\N	Fernando Verdasco (+1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-02 13:00:00+01
4748	\N	781908892	\N	2017-11-02	\N	Rafael Nadal (-1.5 Sets)	\N	Pablo Cuevas (+1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-02 19:30:00+01
4749	\N	781908897	\N	2017-11-02	\N	Robin Haase (+1.5 Sets)	\N	Juan Martin Del Potro (-1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-02 11:00:00+01
4750	\N	781908907	\N	2017-11-02	\N	Robin Haase (-1.5 Sets)	\N	Juan Martin Del Potro (+1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-02 11:00:00+01
4683	483422	782169692	1.136375657	2017-11-03	\N	Sebastian Ofner	\N	Mirza Basic	0	2017-11-02 09:19:12.300425+01	2017-11-03 10:00:00+01
4877	\N	782179348	\N	2017-11-02	\N	Angelique Kerber Game 8 of Set 2	\N	Ashleigh Barty Game 8 of Set 2	1	2017-11-02 09:19:12.300425+01	2017-11-02 08:30:00+01
4878	\N	782179589	\N	2017-11-02	\N	Angelique Kerber Game 9 of Set 2	\N	Ashleigh Barty Game 9 of Set 2	1	2017-11-02 09:19:12.300425+01	2017-11-02 08:30:00+01
4879	\N	782179996	\N	2017-11-02	\N	Angelique Kerber Game 10 of Set 2	\N	Ashleigh Barty Game 10 of Set 2	1	2017-11-02 09:19:12.300425+01	2017-11-02 08:30:00+01
4880	\N	782180325	\N	2017-11-02	\N	Angelique Kerber Game 11 of Set 2	\N	Ashleigh Barty Game 11 of Set 2	1	2017-11-02 09:19:12.300425+01	2017-11-02 08:30:00+01
4751	\N	781980681	\N	2017-11-02	\N	Jack Sock	\N	Lucas Pouille	0	2017-11-02 09:19:12.300425+01	2017-11-02 17:00:00+01
4753	\N	781981203	\N	2017-11-02	\N	Jack Sock (+1.5 Sets)	\N	Lucas Pouille (-1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-02 17:00:00+01
4754	\N	781981214	\N	2017-11-02	\N	Jack Sock (-1.5 Sets)	\N	Lucas Pouille (+1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-02 17:00:00+01
4755	\N	781981252	\N	2017-11-02	\N	John Isner (+1.5 Sets)	\N	Grigor Dimitrov (-1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-02 15:00:00+01
4756	\N	781981270	\N	2017-11-02	\N	John Isner (-1.5 Sets)	\N	Grigor Dimitrov (+1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-02 15:00:00+01
4757	\N	782042887	\N	2017-11-02	\N	David Goffin	\N	Julien Benneteau	0	2017-11-02 09:19:12.300425+01	2017-11-02 17:00:00+01
4758	\N	782045340	\N	2017-11-02	\N	Roberto Bautista Agut	\N	Marin Cilic	0	2017-11-02 09:19:12.300425+01	2017-11-02 21:30:00+01
4759	\N	782055762	\N	2017-11-02	\N	David Goffin (-1.5 Sets)	\N	Julien Benneteau (+1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-02 17:00:00+01
4760	\N	782055783	\N	2017-11-02	\N	Roberto Bautista Agut (+1.5 Sets)	\N	Marin Cilic (-1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-02 21:30:00+01
4761	\N	782055795	\N	2017-11-02	\N	Roberto Bautista Agut (-1.5 Sets)	\N	Marin Cilic (+1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-02 21:30:00+01
4762	\N	782055748	\N	2017-11-02	\N	David Goffin (+1.5 Sets)	\N	Julien Benneteau (-1.5 Sets)	0	2017-11-02 09:19:12.300425+01	2017-11-02 17:00:00+01
4764	\N	781925829	\N	2017-11-02	\N	Elisabetta Cocciaretto	\N	Ganna Poznikhirenko	0	2017-11-02 09:19:12.300425+01	2017-11-02 13:00:00+01
4765	\N	781925870	\N	2017-11-02	\N	Marie Benoit	\N	Amina Anshba	0	2017-11-02 09:19:12.300425+01	2017-11-02 13:00:00+01
4766	\N	781925980	\N	2017-11-02	\N	Vivien Juhaszova	\N	Cristina Dinu	0	2017-11-02 09:19:12.300425+01	2017-11-02 13:00:00+01
4767	\N	781926066	\N	2017-11-02	\N	Camilla Scala	\N	Polina Leykina	0	2017-11-02 09:19:12.300425+01	2017-11-02 13:00:00+01
4768	\N	781926154	\N	2017-11-02	\N	Giulia Gatto Monticone	\N	Valeria Solovyeva	0	2017-11-02 09:19:12.300425+01	2017-11-02 13:00:00+01
4769	\N	781926227	\N	2017-11-02	\N	Sara Cakarevic	\N	Cindy Burger	0	2017-11-02 09:19:12.300425+01	2017-11-02 13:00:00+01
4770	\N	781987399	\N	2017-11-02	\N	Catalina Pella	\N	Nina Potocnik	0	2017-11-02 09:19:12.300425+01	2017-11-02 13:00:00+01
4777	\N	781989073	\N	2017-11-02	\N	Sofia Kenin	\N	Amanda Anisimova	0	2017-11-02 09:19:12.300425+01	2017-11-02 18:05:00+01
4778	\N	781989315	\N	2017-11-02	\N	Victoria Duval	\N	Elitsa Kostova	0	2017-11-02 09:19:12.300425+01	2017-11-02 16:05:00+01
4779	\N	782119721	\N	2017-11-02	\N	Nicole Gibbs	\N	Ashley Kratzer	0	2017-11-02 09:19:12.300425+01	2017-11-02 18:20:00+01
4780	\N	782119999	\N	2017-11-02	\N	Cagla Buyukakcay	\N	Sesil Karatantcheva	0	2017-11-02 09:19:12.300425+01	2017-11-02 17:05:00+01
4781	\N	782120182	\N	2017-11-02	\N	Irina Falconi	\N	Rebecca Peterson	0	2017-11-02 09:19:12.300425+01	2017-11-02 18:05:00+01
4782	\N	782120286	\N	2017-11-02	\N	Sophie Chang	\N	Taylor Townsend	0	2017-11-02 09:19:12.300425+01	2017-11-02 17:35:00+01
4789	\N	782109898	\N	2017-11-03	\N	Matthew Ebden	\N	Blake Ellis	0	2017-11-02 09:19:12.300425+01	2017-11-03 03:00:00+01
4790	\N	782115671	\N	2017-11-03	\N	Alexander Sarkissian	\N	Marc Polmans	0	2017-11-02 09:19:12.300425+01	2017-11-03 03:00:00+01
4791	\N	781884859	\N	2017-11-02	\N	Panna Udvardy	\N	Olga Danilovic	0	2017-11-02 09:19:12.300425+01	2017-11-02 12:30:00+01
4792	\N	781884960	\N	2017-11-02	\N	Marta Lesniak	\N	Anastasia Zarycka	0	2017-11-02 09:19:12.300425+01	2017-11-02 11:00:00+01
4793	\N	781927093	\N	2017-11-02	\N	Marta Paigina	\N	Georgina Garcia-Perez	0	2017-11-02 09:19:12.300425+01	2017-11-02 13:00:00+01
4794	\N	781927171	\N	2017-11-02	\N	Nicoleta-Catalina Dascalu	\N	Rebeka Masarova	0	2017-11-02 09:19:12.300425+01	2017-11-02 11:00:00+01
4795	\N	781926505	\N	2017-11-03	\N	Michaela Honcova	\N	Jessika Ponchet	0	2017-11-02 09:19:12.300425+01	2017-11-03 10:00:00+01
4796	\N	781988843	\N	2017-11-03	\N	Elena Bovina	\N	Patty Schnyder	0	2017-11-02 09:19:12.300425+01	2017-11-03 10:00:00+01
4797	\N	781975358	\N	2017-11-03	\N	Tim Smyczek	\N	Henri Laaksonen	0	2017-11-02 09:19:12.300425+01	2017-11-03 15:00:00+01
4798	\N	782030166	\N	2017-11-03	\N	Tennys Sandgren	\N	Brayden Schnur	0	2017-11-02 09:19:12.300425+01	2017-11-03 15:00:00+01
4799	\N	781984638	\N	2017-11-03	\N	Kaia Kanepi	\N	Anna Blinkova	0	2017-11-02 09:19:12.300425+01	2017-11-03 10:00:00+01
4800	\N	781984729	\N	2017-11-03	\N	Bernarda Pera	\N	Diana Marcinkevica	0	2017-11-02 09:19:12.300425+01	2017-11-03 10:00:00+01
4801	\N	782038048	\N	2017-11-02	\N	Facundo Bagnis	\N	Nicolas Kicker	0	2017-11-02 09:19:12.300425+01	2017-11-03 00:00:00+01
4802	\N	782040795	\N	2017-11-02	\N	Gastao Elias	\N	Guido Andreozzi	0	2017-11-02 09:19:12.300425+01	2017-11-02 21:00:00+01
4803	\N	782074616	\N	2017-11-02	\N	Marcelo Arevalo	\N	Hugo Dellien	0	2017-11-02 09:19:12.300425+01	2017-11-03 00:00:00+01
4804	\N	782127256	\N	2017-11-03	\N	Roberto Quiroz	\N	Gerald Melzer	0	2017-11-02 09:19:12.300425+01	2017-11-03 02:00:00+01
4805	\N	782159064	\N	2017-11-03	\N	Yibing Wu	\N	Blaz Kavcic	0	2017-11-02 09:19:12.300425+01	2017-11-03 03:00:00+01
4806	\N	782159065	\N	2017-11-03	\N	Hubert Hurkacz	\N	Soon Woo Kwon	0	2017-11-02 09:19:12.300425+01	2017-11-03 03:00:00+01
4807	\N	782164463	\N	2017-11-03	\N	Mikhail Youzhny	\N	Austin Krajicek	0	2017-11-02 09:19:12.300425+01	2017-11-03 03:00:00+01
4958	\N	782176161	\N	2017-11-03	\N	Radu Albot	\N	Jason Jung	0	2017-11-02 09:19:12.300425+01	2017-11-03 03:00:00+01
4808	\N	782168847	\N	2017-11-03	\N	Alison Bai	\N	Kaylah Mcphee	0	2017-11-02 09:19:12.300425+01	2017-11-03 01:00:00+01
4809	\N	782169062	\N	2017-11-03	\N	Destanee Aiava	\N	Tamara Zidansek	0	2017-11-02 09:19:12.300425+01	2017-11-03 01:00:00+01
4810	\N	782169109	\N	2017-11-03	\N	Olivia Rogowska	\N	Abigail Tere-Apisah	0	2017-11-02 09:19:12.300425+01	2017-11-03 01:00:00+01
4811	\N	782169132	\N	2017-11-03	\N	Julia Glushko	\N	Lizette Cabrera	0	2017-11-02 09:19:12.300425+01	2017-11-03 01:00:00+01
\.


--
-- TOC entry 2267 (class 0 OID 0)
-- Dependencies: 192
-- Name: tbl_events_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tennis
--

SELECT pg_catalog.setval('tbl_events_event_id_seq', 6251, true);


--
-- TOC entry 2234 (class 0 OID 16775)
-- Dependencies: 193
-- Data for Name: tbl_match; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_match (match_id, tournament_id, "MatchDate", "time", surface, player1_id, player2_id, winner, score, player1_set1, player2_set1, player1_set2, player2_set2, player1_set3, player2_set3, player1_set4, player2_set4, player1_set5, player2_set5, te_link, update) FROM stdin;
\.


--
-- TOC entry 2268 (class 0 OID 0)
-- Dependencies: 194
-- Name: tbl_match_match_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tennis
--

SELECT pg_catalog.setval('tbl_match_match_id_seq', 1, false);


--
-- TOC entry 2236 (class 0 OID 16780)
-- Dependencies: 195
-- Data for Name: tbl_odds; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_odds (odds_id, event_id, match_id, bettyp_id, bookie_id, way, backlay, odds_update, odds) FROM stdin;
3796	323	\N	1	1	1	1	2017-11-01 16:23:57.723091	2.3500000000000001
3789	354	\N	1	1	2	1	2017-11-01 16:23:57.717049	1.4950000000000001
3751	320	\N	1	1	2	1	2017-11-01 16:23:57.683775	1.8999999999999999
3755	263	\N	1	1	2	1	2017-11-01 10:42:54.085407	2.1299999999999999
3733	269	\N	1	1	2	1	2017-11-01 12:17:16.447408	1.6990000000000001
3773	329	\N	1	1	2	1	2017-11-01 16:23:57.690968	1.4339999999999999
3756	369	\N	1	1	1	1	2017-11-02 09:19:22.117088	1.105
3754	263	\N	1	1	1	1	2017-11-01 10:42:54.085407	1.8
3746	266	\N	1	1	1	1	2017-11-01 12:17:16.449413	1.625
3749	267	\N	1	1	2	1	2017-11-01 12:17:16.464453	1.8129999999999999
3806	337	\N	1	1	1	1	2017-11-01 16:23:57.744056	1.4159999999999999
3752	314	\N	1	1	1	1	2017-11-01 16:23:57.685751	1.952
3739	283	\N	1	1	2	1	2017-11-01 12:17:16.457434	8.6699999999999999
3786	361	\N	1	1	1	1	2017-11-02 09:19:22.154499	1.694
3787	361	\N	1	1	2	1	2017-11-02 09:19:22.154499	2.3300000000000001
3809	325	\N	1	1	2	1	2017-11-01 16:23:57.747567	1.3069999999999999
3743	296	\N	1	1	2	1	2017-11-01 12:17:16.443397	1.1319999999999999
3785	358	\N	1	1	2	1	2017-11-01 16:23:57.688962	1.429
3770	359	\N	1	1	1	1	2017-11-01 16:23:57.72106	1.355
3732	269	\N	1	1	1	1	2017-11-01 12:17:16.447408	2.29
3763	349	\N	1	1	2	1	2017-11-01 16:23:57.707018	3.6699999999999999
3774	368	\N	1	1	1	1	2017-11-02 09:19:22.151489	1.833
3741	309	\N	1	1	2	1	2017-11-01 16:23:57.627951	1.806
3745	307	\N	1	1	2	1	2017-11-01 16:23:57.678226	1.333
3784	358	\N	1	1	1	1	2017-11-01 16:23:57.688962	2.8700000000000001
3813	345	\N	1	1	2	1	2017-11-01 16:23:57.75982	2.4500000000000002
3808	325	\N	1	1	1	1	2017-11-01 16:23:57.747567	3.8500000000000001
3798	332	\N	1	1	1	1	2017-11-01 16:23:57.741548	2.46
3790	334	\N	1	1	1	1	2017-11-01 16:23:57.694995	1.111
3777	370	\N	1	1	2	1	2017-11-02 09:19:22.160078	1.952
3795	348	\N	1	1	2	1	2017-11-01 16:23:57.767852	4.4800000000000004
3760	333	\N	1	1	1	1	2017-11-01 16:23:57.719055	1.454
3761	333	\N	1	1	2	1	2017-11-01 16:23:57.719055	2.9700000000000002
3766	340	\N	1	1	1	1	2017-11-01 16:23:57.73854	2.7799999999999998
3797	323	\N	1	1	2	1	2017-11-01 16:23:57.723091	1.6060000000000001
3762	349	\N	1	1	1	1	2017-11-01 16:23:57.707018	1.2889999999999999
3772	329	\N	1	1	1	1	2017-11-01 16:23:57.690968	2.8500000000000001
3800	324	\N	1	1	1	1	2017-11-01 16:23:57.761827	2.0699999999999998
3791	334	\N	1	1	2	1	2017-11-01 16:23:57.694995	6.7699999999999996
3779	328	\N	1	1	2	1	2017-11-01 16:23:57.709023	1.2210000000000001
3804	265	\N	1	1	1	1	2017-11-01 12:17:16.524007	2.7599999999999998
3769	365	\N	1	1	2	1	2017-11-02 09:19:22.157995	1.99
3771	359	\N	1	1	2	1	2017-11-01 16:23:57.72106	3.2200000000000002
3793	367	\N	1	1	2	1	2017-11-02 09:19:22.163661	1.3700000000000001
3799	332	\N	1	1	2	1	2017-11-01 16:23:57.741548	1.617
3820	268	\N	1	2	1	1	2017-11-01 12:17:16.541261	1.3600000000000001
3788	354	\N	1	1	1	1	2017-11-01 16:23:57.717049	2.6400000000000001
3792	367	\N	1	1	1	1	2017-11-02 09:19:22.163661	3.1499999999999999
3765	336	\N	1	1	2	1	2017-11-01 16:23:57.728082	3.27
3767	340	\N	1	1	2	1	2017-11-01 16:23:57.73854	1.454
3814	351	\N	1	1	1	1	2017-11-01 16:23:57.753802	1.99
3815	351	\N	1	1	2	1	2017-11-01 16:23:57.753802	1.833
3778	328	\N	1	1	1	1	2017-11-01 16:23:57.709023	4.3700000000000001
3768	365	\N	1	1	1	1	2017-11-02 09:19:22.157995	1.833
3807	337	\N	1	1	2	1	2017-11-01 16:23:57.744056	3.1400000000000001
3794	348	\N	1	1	1	1	2017-11-01 16:23:57.767852	1.212
3812	345	\N	1	1	1	1	2017-11-01 16:23:57.75982	1.5640000000000001
3780	342	\N	1	1	1	1	2017-11-01 16:23:57.696986	6.0499999999999998
3783	352	\N	1	1	2	1	2017-11-01 16:23:57.705011	2.6400000000000001
3776	370	\N	1	1	1	1	2017-11-02 09:19:22.160078	1.869
3781	342	\N	1	1	2	1	2017-11-01 16:23:57.696986	1.133
3759	350	\N	1	1	2	1	2017-11-01 16:23:57.712033	2.0699999999999998
3758	350	\N	1	1	1	1	2017-11-01 16:23:57.712033	1.7689999999999999
3824	312	\N	1	2	1	1	2017-11-01 16:23:58.583805	NaN
3803	256	\N	1	1	2	1	2017-11-01 10:42:54.267504	2.1299999999999999
3753	314	\N	1	1	2	1	2017-11-01 16:23:57.685751	1.952
3757	369	\N	1	1	2	1	2017-11-02 09:19:22.117088	7
3802	256	\N	1	1	1	1	2017-11-01 10:42:54.267504	1.7290000000000001
3744	307	\N	1	1	1	1	2017-11-01 16:23:57.678226	3.6400000000000001
3810	255	\N	1	1	1	1	2017-11-01 10:42:54.272519	1.2350000000000001
3736	312	\N	1	1	1	1	2017-11-01 16:23:57.680735	1.9430000000000001
3805	265	\N	1	1	2	1	2017-11-01 12:17:16.524007	1.51
3750	320	\N	1	1	1	1	2017-11-01 16:23:57.683775	1.917
3818	269	\N	1	2	2	1	2017-11-01 12:17:17.570074	1.7
3811	255	\N	1	1	2	1	2017-11-01 10:42:54.272519	4.6500000000000004
3821	268	\N	1	2	1	2	2017-11-01 12:17:16.541261	1.3999999999999999
3822	268	\N	1	2	2	1	2017-11-01 12:17:16.541261	3.6000000000000001
3823	268	\N	1	2	2	2	2017-11-01 12:17:16.541261	3.7000000000000002
3782	352	\N	1	1	1	1	2017-11-01 16:23:57.705011	1.4950000000000001
3819	269	\N	1	2	2	2	2017-11-01 12:17:17.570074	1.73
3828	283	\N	1	2	1	1	2017-11-01 12:17:19.351647	1.1100000000000001
3734	268	\N	1	1	1	1	2017-11-01 12:17:16.417325	1.3839999999999999
3748	267	\N	1	1	1	1	2017-11-01 12:17:16.464453	2.1099999999999999
3735	268	\N	1	1	2	1	2017-11-01 12:17:16.417325	3.0699999999999998
3742	296	\N	1	1	1	1	2017-11-01 12:17:16.443397	7.0499999999999998
3747	266	\N	1	1	2	1	2017-11-01 12:17:16.449413	2.3100000000000001
3816	269	\N	1	2	1	1	2017-11-01 12:17:17.570074	2.3599999999999999
3855	320	\N	1	2	2	2	2017-11-01 16:23:59.029425	NaN
3837	296	\N	1	2	1	2	2017-11-01 12:17:16.892161	1.1699999999999999
3893	359	\N	1	2	1	2	2017-11-01 16:24:05.405404	NaN
3914	342	\N	1	2	2	1	2017-11-01 16:24:01.569279	NaN
3836	296	\N	1	2	1	1	2017-11-01 12:17:16.892161	1.1399999999999999
3861	263	\N	1	2	1	2	2017-11-01 10:42:55.479816	1.8300000000000001
3862	263	\N	1	2	2	1	2017-11-01 10:42:55.479816	2.2000000000000002
3863	263	\N	1	2	2	2	2017-11-01 10:42:55.479816	2.2799999999999998
3845	266	\N	1	2	1	2	2017-11-01 12:17:17.933973	1.75
3900	368	\N	1	2	1	1	2017-11-02 09:19:22.604048	NaN
3895	359	\N	1	2	2	2	2017-11-01 16:24:05.405404	NaN
3871	350	\N	1	2	2	2	2017-11-01 16:24:03.861633	NaN
3860	263	\N	1	2	1	1	2017-11-01 10:42:55.479816	1.79
3846	266	\N	1	2	2	1	2017-11-01 12:17:17.933973	2.3399999999999999
3847	266	\N	1	2	2	2	2017-11-01 12:17:17.933973	2.52
3842	307	\N	1	2	2	1	2017-11-01 16:23:58.191213	NaN
3849	267	\N	1	2	1	2	2017-11-01 12:17:20.046842	1.8600000000000001
3850	267	\N	1	2	2	1	2017-11-01 12:17:20.046842	2.1400000000000001
3851	267	\N	1	2	2	2	2017-11-01 12:17:20.046842	2.2000000000000002
3904	370	\N	1	2	1	1	2017-11-02 09:19:23.70495	NaN
3866	369	\N	1	2	2	1	2017-11-02 09:19:22.182456	7
3867	369	\N	1	2	2	2	2017-11-02 09:19:22.182456	11
3830	283	\N	1	2	2	1	2017-11-01 12:17:19.351647	9
3831	283	\N	1	2	2	2	2017-11-01 12:17:19.351647	9.1999999999999993
3899	329	\N	1	2	2	2	2017-11-01 16:24:00.44165	NaN
3859	314	\N	1	2	2	2	2017-11-01 16:23:59.504138	2.1800000000000002
3857	314	\N	1	2	1	2	2017-11-01 16:23:59.504138	2.2599999999999998
3834	309	\N	1	2	2	1	2017-11-01 16:23:57.777313	NaN
3838	296	\N	1	2	2	1	2017-11-01 12:17:16.892161	7.2000000000000002
3844	266	\N	1	2	1	1	2017-11-01 12:17:17.933973	1.6599999999999999
3885	340	\N	1	2	1	2	2017-11-01 16:24:07.663551	NaN
3892	359	\N	1	2	1	1	2017-11-01 16:24:05.405404	NaN
3879	349	\N	1	2	2	2	2017-11-01 16:24:03.081207	NaN
3832	309	\N	1	2	1	1	2017-11-01 16:23:57.777313	NaN
3876	349	\N	1	2	1	1	2017-11-01 16:24:03.081207	NaN
3908	328	\N	1	2	1	1	2017-11-01 16:24:03.483058	NaN
3833	309	\N	1	2	1	2	2017-11-01 16:23:57.777313	NaN
3872	333	\N	1	2	1	1	2017-11-01 16:24:04.963942	1.46
3920	358	\N	1	2	1	1	2017-11-01 16:24:00.040707	NaN
3848	267	\N	1	2	1	1	2017-11-01 12:17:20.046842	1.8300000000000001
3883	336	\N	1	2	2	2	2017-11-01 16:24:06.60678	3.6000000000000001
3864	369	\N	1	2	1	1	2017-11-02 09:19:22.182456	1.0900000000000001
3869	350	\N	1	2	1	2	2017-11-01 16:24:03.861633	NaN
3880	336	\N	1	2	1	1	2017-11-01 16:24:06.60678	1.3700000000000001
3889	365	\N	1	2	1	2	2017-11-02 09:19:23.364889	NaN
3896	329	\N	1	2	1	1	2017-11-01 16:24:00.44165	NaN
3887	340	\N	1	2	2	2	2017-11-01 16:24:07.663551	NaN
3873	333	\N	1	2	1	2	2017-11-01 16:24:04.963942	1.49
3902	368	\N	1	2	2	1	2017-11-02 09:19:22.604048	NaN
3884	340	\N	1	2	1	1	2017-11-01 16:24:07.663551	NaN
3840	307	\N	1	2	1	1	2017-11-01 16:23:58.191213	NaN
3856	314	\N	1	2	1	1	2017-11-01 16:23:59.504138	1.8
3921	358	\N	1	2	1	2	2017-11-01 16:24:00.040707	NaN
3925	361	\N	1	2	1	2	2017-11-02 09:19:22.972915	1.71
3906	370	\N	1	2	2	1	2017-11-02 09:19:23.70495	NaN
3853	320	\N	1	2	1	2	2017-11-01 16:23:59.029425	NaN
3890	365	\N	1	2	2	1	2017-11-02 09:19:23.364889	NaN
3891	365	\N	1	2	2	2	2017-11-02 09:19:23.364889	NaN
3835	309	\N	1	2	2	2	2017-11-01 16:23:57.777313	NaN
3910	328	\N	1	2	2	1	2017-11-01 16:24:03.483058	NaN
3858	314	\N	1	2	2	1	2017-11-01 16:23:59.504138	1.76
3912	342	\N	1	2	1	1	2017-11-01 16:24:01.569279	NaN
3881	336	\N	1	2	1	2	2017-11-01 16:24:06.60678	1.4399999999999999
3898	329	\N	1	2	2	1	2017-11-01 16:24:00.44165	NaN
3868	350	\N	1	2	1	1	2017-11-01 16:24:03.861633	NaN
3903	368	\N	1	2	2	2	2017-11-02 09:19:22.604048	NaN
3911	328	\N	1	2	2	2	2017-11-01 16:24:03.483058	NaN
3870	350	\N	1	2	2	1	2017-11-01 16:24:03.861633	NaN
3874	333	\N	1	2	2	1	2017-11-01 16:24:04.963942	3.0499999999999998
3875	333	\N	1	2	2	2	2017-11-01 16:24:04.963942	3.2000000000000002
3894	359	\N	1	2	2	1	2017-11-01 16:24:05.405404	NaN
3841	307	\N	1	2	1	2	2017-11-01 16:23:58.191213	NaN
3907	370	\N	1	2	2	2	2017-11-02 09:19:23.70495	NaN
3888	365	\N	1	2	1	1	2017-11-02 09:19:23.364889	NaN
3901	368	\N	1	2	1	2	2017-11-02 09:19:22.604048	NaN
3905	370	\N	1	2	1	2	2017-11-02 09:19:23.70495	NaN
3886	340	\N	1	2	2	1	2017-11-01 16:24:07.663551	NaN
3843	307	\N	1	2	2	2	2017-11-01 16:23:58.191213	NaN
3923	358	\N	1	2	2	2	2017-11-01 16:24:00.040707	NaN
3924	361	\N	1	2	1	1	2017-11-02 09:19:22.972915	1.6699999999999999
3865	369	\N	1	2	1	2	2017-11-02 09:19:22.182456	1.1699999999999999
3913	342	\N	1	2	1	2	2017-11-01 16:24:01.569279	NaN
3922	358	\N	1	2	2	1	2017-11-01 16:24:00.040707	NaN
3854	320	\N	1	2	2	1	2017-11-01 16:23:59.029425	NaN
3916	352	\N	1	2	1	1	2017-11-01 16:24:02.710063	NaN
3917	352	\N	1	2	1	2	2017-11-01 16:24:02.710063	NaN
3918	352	\N	1	2	2	1	2017-11-01 16:24:02.710063	NaN
3919	352	\N	1	2	2	2	2017-11-01 16:24:02.710063	NaN
3977	345	\N	1	2	1	2	2017-11-01 16:24:10.762605	NaN
3764	336	\N	1	1	1	1	2017-11-01 16:23:57.728082	1.3480000000000001
5530	346	\N	1	1	1	1	2017-11-01 16:23:57.764836	5.79
3978	345	\N	1	2	2	1	2017-11-01 16:24:10.762605	NaN
5697	346	\N	1	2	2	2	2017-11-01 16:24:12.195388	1.23
5531	346	\N	1	1	2	1	2017-11-01 16:23:57.764836	1.1419999999999999
3738	283	\N	1	1	1	1	2017-11-01 12:17:16.457434	1.1000000000000001
3825	312	\N	1	2	1	2	2017-11-01 16:23:58.583805	NaN
3852	320	\N	1	2	1	1	2017-11-01 16:23:59.029425	NaN
3968	325	\N	1	2	1	1	2017-11-01 16:24:08.835758	4.2000000000000002
3942	348	\N	1	2	2	1	2017-11-01 16:24:12.742792	4.2999999999999998
3943	348	\N	1	2	2	2	2017-11-01 16:24:12.742792	5.5999999999999996
3967	337	\N	1	2	2	2	2017-11-01 16:24:08.435433	3.3500000000000001
3827	312	\N	1	2	2	2	2017-11-01 16:23:58.583805	NaN
3897	329	\N	1	2	1	2	2017-11-01 16:24:00.44165	NaN
3948	332	\N	1	2	1	1	2017-11-01 16:24:08.058679	2.54
3960	265	\N	1	2	1	1	2017-11-01 12:17:28.78147	2.8199999999999998
3961	265	\N	1	2	1	2	2017-11-01 12:17:28.78147	2.9199999999999999
3949	332	\N	1	2	1	2	2017-11-01 16:24:08.058679	2.6200000000000001
3965	337	\N	1	2	1	2	2017-11-01 16:24:08.435433	1.45
3962	265	\N	1	2	2	1	2017-11-01 12:17:28.78147	1.52
3839	296	\N	1	2	2	2	2017-11-01 12:17:16.892161	7.5999999999999996
5629	344	\N	1	2	2	2	2017-11-01 16:24:07.314919	1.9399999999999999
3909	328	\N	1	2	1	2	2017-11-01 16:24:03.483058	NaN
3956	256	\N	1	2	1	1	2017-11-01 10:43:11.784175	1.8400000000000001
3957	256	\N	1	2	1	2	2017-11-01 10:43:11.784175	1.9199999999999999
3829	283	\N	1	2	1	2	2017-11-01 12:17:19.351647	1.1399999999999999
5626	344	\N	1	2	1	1	2017-11-01 16:24:07.314919	2.0600000000000001
3938	367	\N	1	2	2	1	2017-11-02 09:19:24.065553	NaN
3972	255	\N	1	2	1	1	2017-11-01 10:43:12.54193	1.26
3973	255	\N	1	2	1	2	2017-11-01 10:43:12.54193	1.29
3974	255	\N	1	2	2	1	2017-11-01 10:43:12.54193	4.5999999999999996
3975	255	\N	1	2	2	2	2017-11-01 10:43:12.54193	4.7999999999999998
3964	337	\N	1	2	1	1	2017-11-01 16:24:08.435433	1.4199999999999999
3929	354	\N	1	2	1	2	2017-11-01 16:24:04.599524	NaN
3801	324	\N	1	1	2	1	2017-11-01 16:23:57.761827	1.7689999999999999
3878	349	\N	1	2	2	1	2017-11-01 16:24:03.081207	NaN
3984	362	\N	1	2	1	1	2017-11-02 09:19:24.428509	2.1600000000000001
3958	256	\N	1	2	2	1	2017-11-01 10:43:11.784175	2.0800000000000001
3959	256	\N	1	2	2	2	2017-11-01 10:43:11.784175	2.2000000000000002
3971	325	\N	1	2	2	2	2017-11-01 16:24:08.835758	1.3300000000000001
3936	367	\N	1	2	1	1	2017-11-02 09:19:24.065553	NaN
3939	367	\N	1	2	2	2	2017-11-02 09:19:24.065553	NaN
3934	334	\N	1	2	2	1	2017-11-01 16:24:01.167398	NaN
3931	354	\N	1	2	2	2	2017-11-01 16:24:04.599524	NaN
3951	332	\N	1	2	2	2	2017-11-01 16:24:08.058679	1.6499999999999999
3985	362	\N	1	2	1	2	2017-11-02 09:19:24.428509	2.3999999999999999
3935	334	\N	1	2	2	2	2017-11-01 16:24:01.167398	NaN
3932	334	\N	1	2	1	1	2017-11-01 16:24:01.167398	NaN
5498	344	\N	1	1	1	1	2017-11-01 16:23:57.736033	2.1099999999999999
3986	362	\N	1	2	2	1	2017-11-02 09:19:24.428509	1.71
3970	325	\N	1	2	2	1	2017-11-01 16:24:08.835758	1.3
3933	334	\N	1	2	1	2	2017-11-01 16:24:01.167398	NaN
3937	367	\N	1	2	1	2	2017-11-02 09:19:24.065553	NaN
5628	344	\N	1	2	2	1	2017-11-01 16:24:07.314919	1.74
3826	312	\N	1	2	2	1	2017-11-01 16:23:58.583805	NaN
3928	354	\N	1	2	1	1	2017-11-01 16:24:04.599524	NaN
5627	344	\N	1	2	1	2	2017-11-01 16:24:07.314919	2.3399999999999999
3969	325	\N	1	2	1	2	2017-11-01 16:24:08.835758	4.2999999999999998
3981	351	\N	1	2	1	2	2017-11-01 16:24:09.225066	2.2999999999999998
3944	323	\N	1	2	1	1	2017-11-01 16:24:05.781081	NaN
3882	336	\N	1	2	2	1	2017-11-01 16:24:06.60678	3.25
3940	348	\N	1	2	1	1	2017-11-01 16:24:12.742792	1.21
3976	345	\N	1	2	1	1	2017-11-01 16:24:10.762605	NaN
3987	362	\N	1	2	2	2	2017-11-02 09:19:24.428509	1.8500000000000001
3775	368	\N	1	1	2	1	2017-11-02 09:19:22.151489	1.99
3963	265	\N	1	2	2	2	2017-11-01 12:17:28.78147	1.55
3979	345	\N	1	2	2	2	2017-11-01 16:24:10.762605	NaN
5694	346	\N	1	2	1	1	2017-11-01 16:24:12.195388	5.7000000000000002
3980	351	\N	1	2	1	1	2017-11-01 16:24:09.225066	2.0800000000000001
3952	324	\N	1	2	1	1	2017-11-01 16:24:11.791668	1.8899999999999999
3953	324	\N	1	2	1	2	2017-11-01 16:24:11.791668	2.3599999999999999
5695	346	\N	1	2	1	2	2017-11-01 16:24:12.195388	6.5999999999999996
5696	346	\N	1	2	2	1	2017-11-01 16:24:12.195388	1.1699999999999999
3950	332	\N	1	2	2	1	2017-11-01 16:24:08.058679	1.6200000000000001
3966	337	\N	1	2	2	1	2017-11-01 16:24:08.435433	3.25
3941	348	\N	1	2	1	2	2017-11-01 16:24:12.742792	1.3
3982	351	\N	1	2	2	1	2017-11-01 16:24:09.225066	1.78
3817	269	\N	1	2	1	2	2017-11-01 12:17:17.570074	2.4199999999999999
5499	344	\N	1	1	2	1	2017-11-01 16:23:57.736033	1.74
3877	349	\N	1	2	1	2	2017-11-01 16:24:03.081207	NaN
3983	351	\N	1	2	2	2	2017-11-01 16:24:09.225066	1.9199999999999999
3740	309	\N	1	1	1	1	2017-11-01 16:23:57.627951	2.02
3954	324	\N	1	2	2	1	2017-11-01 16:24:11.791668	1.6799999999999999
3930	354	\N	1	2	2	1	2017-11-01 16:24:04.599524	NaN
3955	324	\N	1	2	2	2	2017-11-01 16:24:11.791668	2.1000000000000001
3926	361	\N	1	2	2	1	2017-11-02 09:19:22.972915	2.4199999999999999
3927	361	\N	1	2	2	2	2017-11-02 09:19:22.972915	2.5
7917	4676	\N	1	2	1	2	2017-11-02 09:19:25.519316	1.0800000000000001
7918	4676	\N	1	2	2	1	2017-11-02 09:19:25.519316	16
7919	4676	\N	1	2	2	2	2017-11-02 09:19:25.519316	16.5
3737	312	\N	1	1	2	1	2017-11-01 16:23:57.680735	1.917
7912	4663	\N	1	2	1	1	2017-11-02 09:19:25.904583	1.74
7913	4663	\N	1	2	1	2	2017-11-02 09:19:25.904583	1.78
7914	4663	\N	1	2	2	1	2017-11-02 09:19:25.904583	2.2799999999999998
7915	4663	\N	1	2	2	2	2017-11-02 09:19:25.904583	2.3599999999999999
7920	4683	\N	1	2	1	1	2017-11-02 09:19:26.249123	NaN
7921	4683	\N	1	2	1	2	2017-11-02 09:19:26.249123	NaN
3915	342	\N	1	2	2	2	2017-11-01 16:24:01.569279	NaN
3945	323	\N	1	2	1	2	2017-11-01 16:24:05.781081	NaN
3946	323	\N	1	2	2	1	2017-11-01 16:24:05.781081	NaN
3947	323	\N	1	2	2	2	2017-11-01 16:24:05.781081	NaN
7922	4683	\N	1	2	2	1	2017-11-02 09:19:26.249123	NaN
7923	4683	\N	1	2	2	2	2017-11-02 09:19:26.249123	NaN
6910	362	\N	1	1	1	1	2017-11-02 09:19:22.166173	2.1099999999999999
6911	362	\N	1	1	2	1	2017-11-02 09:19:22.166173	1.74
6918	3168	\N	1	1	1	1	2017-11-02 09:19:22.168679	3.3599999999999999
6919	3168	\N	1	1	2	1	2017-11-02 09:19:22.168679	1.333
6920	3175	\N	1	1	1	1	2017-11-02 09:19:22.171687	1.2
6921	3175	\N	1	1	2	1	2017-11-02 09:19:22.171687	4.6699999999999999
7872	4676	\N	1	1	1	1	2017-11-02 09:19:22.173983	1.0489999999999999
7873	4676	\N	1	1	2	1	2017-11-02 09:19:22.173983	14.9
7870	4663	\N	1	1	1	1	2017-11-02 09:19:22.176378	1.7290000000000001
7871	4663	\N	1	1	2	1	2017-11-02 09:19:22.176378	2.2599999999999998
7874	4683	\N	1	1	1	1	2017-11-02 09:19:22.178837	2.1000000000000001
7875	4683	\N	1	1	2	1	2017-11-02 09:19:22.178837	1.7509999999999999
5910	3168	\N	1	2	1	1	2017-11-02 09:19:24.785809	NaN
5911	3168	\N	1	2	1	2	2017-11-02 09:19:24.785809	NaN
5912	3168	\N	1	2	2	1	2017-11-02 09:19:24.785809	NaN
5913	3168	\N	1	2	2	2	2017-11-02 09:19:24.785809	NaN
5914	3175	\N	1	2	1	1	2017-11-02 09:19:25.144824	NaN
5915	3175	\N	1	2	1	2	2017-11-02 09:19:25.144824	NaN
5916	3175	\N	1	2	2	1	2017-11-02 09:19:25.144824	NaN
5917	3175	\N	1	2	2	2	2017-11-02 09:19:25.144824	NaN
7916	4676	\N	1	2	1	1	2017-11-02 09:19:25.519316	1.05
\.


--
-- TOC entry 2269 (class 0 OID 0)
-- Dependencies: 196
-- Name: tbl_odds_odds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tennis
--

SELECT pg_catalog.setval('tbl_odds_odds_id_seq', 7995, true);


--
-- TOC entry 2238 (class 0 OID 16785)
-- Dependencies: 197
-- Data for Name: tbl_rating; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_rating (rating_id, player_id, "FromDate", "ToDate", "SW1YALL", "SW3MALL", "SW1MALL", "SW1YG", "SW1YH", "SW1YC", "ATP") FROM stdin;
\.


--
-- TOC entry 2270 (class 0 OID 0)
-- Dependencies: 198
-- Name: tbl_rating_rating_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tennis
--

SELECT pg_catalog.setval('tbl_rating_rating_id_seq', 1, false);


--
-- TOC entry 2240 (class 0 OID 16790)
-- Dependencies: 199
-- Data for Name: tbl_sackmann_match; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_sackmann_match (index, tourney_id, tourney_name, surface, draw_size, tourney_level, tourney_date, match_num, winner_id, winner_seed, winner_entry, winner_name, winner_hand, winner_ht, winner_ioc, winner_age, winner_rank, winner_rank_points, loser_id, loser_seed, loser_entry, loser_name, loser_hand, loser_ht, loser_ioc, loser_age, loser_rank, loser_rank_points, score, best_of, round, minutes, w_ace, w_df, w_svpt, "w_1stIn", "w_1stWon", "w_2ndWon", "w_SvGms", "w_bpSaved", "w_bpFaced", l_ace, l_df, l_svpt, "l_1stIn", "l_1stWon", "l_2ndWon", "l_SvGms", "l_bpSaved", "l_bpFaced") FROM stdin;
\.


--
-- TOC entry 2241 (class 0 OID 16796)
-- Dependencies: 200
-- Data for Name: tbl_sackmann_players; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_sackmann_players (index, id, firstname, lastname, plays, dob, "IOC", update) FROM stdin;
\.


--
-- TOC entry 2248 (class 0 OID 16886)
-- Dependencies: 207
-- Data for Name: tbl_surebet; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_surebet (away_bookie_id, away_odds, event_id, home_bookie_id, home_odds, max_profit, min_profit, surebet_id, status, update) FROM stdin;
1	7.0	369	1	1.105	0.03	0.0	7	1	09:59:14.437556
1	2.26	4663	1	1.729	0.01	0.0	8	1	09:59:15.833168
\.


--
-- TOC entry 2271 (class 0 OID 0)
-- Dependencies: 206
-- Name: tbl_surebet_surebet_id; Type: SEQUENCE SET; Schema: public; Owner: tennis
--

SELECT pg_catalog.setval('tbl_surebet_surebet_id', 8, true);


--
-- TOC entry 2242 (class 0 OID 16802)
-- Dependencies: 201
-- Data for Name: tbl_te_matchlist; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_te_matchlist (index, "MatchDate", away, away_link, away_odds, away_result, away_score_1, away_score_2, away_score_3, away_score_4, away_score_5, home, home_link, home_odds, home_result, home_score_1, home_score_2, home_score_3, home_score_4, home_score_5, match_link, "time", tournament, tournament_link, update) FROM stdin;
\.


--
-- TOC entry 2243 (class 0 OID 16808)
-- Dependencies: 202
-- Data for Name: tbl_te_player; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_te_player (index, etl_date, player_country, player_dob, player_name, player_plays, player_sex, player_url, update) FROM stdin;
\.


--
-- TOC entry 2244 (class 0 OID 16814)
-- Dependencies: 203
-- Data for Name: tbl_tournament; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_tournament (tournament_id, name, location, category, pin_league_id, te_link) FROM stdin;
\.


--
-- TOC entry 2272 (class 0 OID 0)
-- Dependencies: 204
-- Name: tbl_tournament_tournament_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tennis
--

SELECT pg_catalog.setval('tbl_tournament_tournament_id_seq', 1, false);


SET search_path = surebot, pg_catalog;

--
-- TOC entry 2246 (class 0 OID 16819)
-- Dependencies: 205
-- Data for Name: tbl_events; Type: TABLE DATA; Schema: surebot; Owner: tennis
--

COPY tbl_events (event_id, betbtc_event_id, pinnacle_event_id, betfair_event_id, "StartDate", "Home_player_id", home_player_name, away_player_id, away_player_name, "Live", "LastUpdate") FROM stdin;
\.


SET search_path = public, pg_catalog;

--
-- TOC entry 2087 (class 2606 OID 16833)
-- Name: tbl_events match; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_events
    ADD CONSTRAINT match UNIQUE ("StartDate", home_player_name, away_player_name);


--
-- TOC entry 2095 (class 2606 OID 16835)
-- Name: tbl_odds odds_unique; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_odds
    ADD CONSTRAINT odds_unique UNIQUE (event_id, bettyp_id, way, backlay, bookie_id);


--
-- TOC entry 2083 (class 2606 OID 16837)
-- Name: tbl_bettyp tbl_bettyp_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_bettyp
    ADD CONSTRAINT tbl_bettyp_pk PRIMARY KEY (bettyp_id);


--
-- TOC entry 2085 (class 2606 OID 16839)
-- Name: tbl_bookie tbl_bookie_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_bookie
    ADD CONSTRAINT tbl_bookie_pk PRIMARY KEY (bookie_id);


--
-- TOC entry 2089 (class 2606 OID 16841)
-- Name: tbl_events tbl_events_pkey; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_events
    ADD CONSTRAINT tbl_events_pkey PRIMARY KEY (event_id);


--
-- TOC entry 2091 (class 2606 OID 16843)
-- Name: tbl_match tbl_match_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_match
    ADD CONSTRAINT tbl_match_pk PRIMARY KEY (match_id);


--
-- TOC entry 2097 (class 2606 OID 16845)
-- Name: tbl_odds tbl_odds_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_odds
    ADD CONSTRAINT tbl_odds_pk PRIMARY KEY (odds_id);


--
-- TOC entry 2099 (class 2606 OID 16847)
-- Name: tbl_rating tbl_rating_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_rating
    ADD CONSTRAINT tbl_rating_pk PRIMARY KEY (rating_id);


--
-- TOC entry 2109 (class 2606 OID 16894)
-- Name: tbl_surebet tbl_surebet_pkey; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_surebet
    ADD CONSTRAINT tbl_surebet_pkey PRIMARY KEY (surebet_id);


--
-- TOC entry 2105 (class 2606 OID 16849)
-- Name: tbl_tournament tbl_tournament_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_tournament
    ADD CONSTRAINT tbl_tournament_pk PRIMARY KEY (tournament_id);


--
-- TOC entry 2093 (class 2606 OID 16851)
-- Name: tbl_match unique; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_match
    ADD CONSTRAINT "unique" UNIQUE ("MatchDate", player1_id, player2_id);


SET search_path = surebot, pg_catalog;

--
-- TOC entry 2107 (class 2606 OID 16853)
-- Name: tbl_events pk; Type: CONSTRAINT; Schema: surebot; Owner: tennis
--

ALTER TABLE ONLY tbl_events
    ADD CONSTRAINT pk PRIMARY KEY (event_id);


SET search_path = public, pg_catalog;

--
-- TOC entry 2100 (class 1259 OID 16854)
-- Name: ix_tbl_sackmann_match_index; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX ix_tbl_sackmann_match_index ON tbl_sackmann_match USING btree (index);


--
-- TOC entry 2101 (class 1259 OID 16855)
-- Name: ix_tbl_sackmann_players_index; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX ix_tbl_sackmann_players_index ON tbl_sackmann_players USING btree (index);


--
-- TOC entry 2102 (class 1259 OID 16856)
-- Name: ix_tbl_te_matchlist_index; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX ix_tbl_te_matchlist_index ON tbl_te_matchlist USING btree (index);


--
-- TOC entry 2103 (class 1259 OID 16857)
-- Name: ix_tbl_te_player_index; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX ix_tbl_te_player_index ON tbl_te_player USING btree (index);


--
-- TOC entry 2255 (class 0 OID 0)
-- Dependencies: 7
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2017-11-02 10:00:51

--
-- PostgreSQL database dump complete
--

