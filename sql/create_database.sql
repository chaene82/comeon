--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.5
-- Dumped by pg_dump version 9.6.5

-- Started on 2017-10-31 16:05:20

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
-- TOC entry 2227 (class 1262 OID 16648)
-- Name: tennis; Type: DATABASE; Schema: -; Owner: tennis
--

CREATE DATABASE tennis WITH TEMPLATE = template0 ;


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
-- TOC entry 1 (class 3079 OID 12387)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2230 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 195 (class 1259 OID 16708)
-- Name: tbl_bettyp; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_bettyp (
    bettyp_id integer NOT NULL,
    bettyp_name character(50)
);


ALTER TABLE tbl_bettyp OWNER TO tennis;

--
-- TOC entry 196 (class 1259 OID 16711)
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
-- TOC entry 2231 (class 0 OID 0)
-- Dependencies: 196
-- Name: tbl_bettyp_bettyp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_bettyp_bettyp_id_seq OWNED BY tbl_bettyp.bettyp_id;


--
-- TOC entry 197 (class 1259 OID 16714)
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
-- TOC entry 198 (class 1259 OID 16720)
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
-- TOC entry 2232 (class 0 OID 0)
-- Dependencies: 198
-- Name: tbl_bookie_bookie_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_bookie_bookie_id_seq OWNED BY tbl_bookie.bookie_id;


--
-- TOC entry 185 (class 1259 OID 16649)
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
-- TOC entry 186 (class 1259 OID 16652)
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
-- TOC entry 2233 (class 0 OID 0)
-- Dependencies: 186
-- Name: tbl_match_match_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_match_match_id_seq OWNED BY tbl_match.match_id;


--
-- TOC entry 199 (class 1259 OID 16722)
-- Name: tbl_odds; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_odds (
    odds_id integer NOT NULL,
    event_id bigint NOT NULL,
    match_id bigint NOT NULL,
    bettyp_id integer NOT NULL,
    bookie_id integer NOT NULL,
    way integer NOT NULL,
    backlay integer NOT NULL,
    odds_update timestamp without time zone,
    odds double precision
);


ALTER TABLE tbl_odds OWNER TO tennis;

--
-- TOC entry 200 (class 1259 OID 16725)
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
-- TOC entry 2234 (class 0 OID 0)
-- Dependencies: 200
-- Name: tbl_odds_odds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_odds_odds_id_seq OWNED BY tbl_odds.odds_id;


--
-- TOC entry 187 (class 1259 OID 16654)
-- Name: tbl_player; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_player (
    player_id integer NOT NULL,
    firstname character(50),
    lastname character(50),
    name_long character varying(200),
    name_short character varying(100),
    plays character(50),
    country character(50),
    dayofbirth date,
    "ITF_ID" integer,
    te_link character varying(200),
    update timestamp with time zone,
    sackmann_id integer,
    "IOC" character varying(20)
);


ALTER TABLE tbl_player OWNER TO tennis;

--
-- TOC entry 188 (class 1259 OID 16660)
-- Name: tbl_player_player_id_seq; Type: SEQUENCE; Schema: public; Owner: tennis
--

CREATE SEQUENCE tbl_player_player_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbl_player_player_id_seq OWNER TO tennis;

--
-- TOC entry 2235 (class 0 OID 0)
-- Dependencies: 188
-- Name: tbl_player_player_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_player_player_id_seq OWNED BY tbl_player.player_id;


--
-- TOC entry 201 (class 1259 OID 16727)
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
-- TOC entry 202 (class 1259 OID 16730)
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
-- TOC entry 2236 (class 0 OID 0)
-- Dependencies: 202
-- Name: tbl_rating_rating_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_rating_rating_id_seq OWNED BY tbl_rating.rating_id;


--
-- TOC entry 189 (class 1259 OID 16662)
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
-- TOC entry 190 (class 1259 OID 16668)
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
-- TOC entry 191 (class 1259 OID 16674)
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
-- TOC entry 192 (class 1259 OID 16680)
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
-- TOC entry 193 (class 1259 OID 16686)
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
-- TOC entry 194 (class 1259 OID 16689)
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
-- TOC entry 2237 (class 0 OID 0)
-- Dependencies: 194
-- Name: tbl_tournament_tournament_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_tournament_tournament_id_seq OWNED BY tbl_tournament.tournament_id;


--
-- TOC entry 2062 (class 2604 OID 16732)
-- Name: tbl_bettyp bettyp_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_bettyp ALTER COLUMN bettyp_id SET DEFAULT nextval('tbl_bettyp_bettyp_id_seq'::regclass);


--
-- TOC entry 2063 (class 2604 OID 16733)
-- Name: tbl_bookie bookie_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_bookie ALTER COLUMN bookie_id SET DEFAULT nextval('tbl_bookie_bookie_id_seq'::regclass);


--
-- TOC entry 2059 (class 2604 OID 16734)
-- Name: tbl_match match_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_match ALTER COLUMN match_id SET DEFAULT nextval('tbl_match_match_id_seq'::regclass);


--
-- TOC entry 2064 (class 2604 OID 16735)
-- Name: tbl_odds odds_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_odds ALTER COLUMN odds_id SET DEFAULT nextval('tbl_odds_odds_id_seq'::regclass);


--
-- TOC entry 2060 (class 2604 OID 16736)
-- Name: tbl_player player_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_player ALTER COLUMN player_id SET DEFAULT nextval('tbl_player_player_id_seq'::regclass);


--
-- TOC entry 2065 (class 2604 OID 16737)
-- Name: tbl_rating rating_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_rating ALTER COLUMN rating_id SET DEFAULT nextval('tbl_rating_rating_id_seq'::regclass);


--
-- TOC entry 2061 (class 2604 OID 16738)
-- Name: tbl_tournament tournament_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_tournament ALTER COLUMN tournament_id SET DEFAULT nextval('tbl_tournament_tournament_id_seq'::regclass);


--
-- TOC entry 2215 (class 0 OID 16708)
-- Dependencies: 195
-- Data for Name: tbl_bettyp; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_bettyp (bettyp_id, bettyp_name) FROM stdin;
\.


--
-- TOC entry 2238 (class 0 OID 0)
-- Dependencies: 196
-- Name: tbl_bettyp_bettyp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tennis
--

SELECT pg_catalog.setval('tbl_bettyp_bettyp_id_seq', 1, false);


--
-- TOC entry 2217 (class 0 OID 16714)
-- Dependencies: 197
-- Data for Name: tbl_bookie; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_bookie (bookie_id, bookie_name, bookie_account_name, bookie_api_endpoint, bookie_api_key, bookie_type, bookie_commision, bookie_passwd) FROM stdin;
\.


--
-- TOC entry 2239 (class 0 OID 0)
-- Dependencies: 198
-- Name: tbl_bookie_bookie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tennis
--

SELECT pg_catalog.setval('tbl_bookie_bookie_id_seq', 1, true);


--
-- TOC entry 2205 (class 0 OID 16649)
-- Dependencies: 185
-- Data for Name: tbl_match; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_match (match_id, tournament_id, "MatchDate", "time", surface, player1_id, player2_id, winner, score, player1_set1, player2_set1, player1_set2, player2_set2, player1_set3, player2_set3, player1_set4, player2_set4, player1_set5, player2_set5, te_link, update) FROM stdin;
\.


--
-- TOC entry 2240 (class 0 OID 0)
-- Dependencies: 186
-- Name: tbl_match_match_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tennis
--

SELECT pg_catalog.setval('tbl_match_match_id_seq', 1, false);


--
-- TOC entry 2219 (class 0 OID 16722)
-- Dependencies: 199
-- Data for Name: tbl_odds; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_odds (odds_id, event_id, match_id, bettyp_id, bookie_id, way, backlay, odds_update, odds) FROM stdin;
\.


--
-- TOC entry 2241 (class 0 OID 0)
-- Dependencies: 200
-- Name: tbl_odds_odds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tennis
--

SELECT pg_catalog.setval('tbl_odds_odds_id_seq', 1, false);


--
-- TOC entry 2207 (class 0 OID 16654)
-- Dependencies: 187
-- Data for Name: tbl_player; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_player (player_id, firstname, lastname, name_long, name_short, plays, country, dayofbirth, "ITF_ID", te_link, update, sackmann_id, "IOC") FROM stdin;
\.


--
-- TOC entry 2242 (class 0 OID 0)
-- Dependencies: 188
-- Name: tbl_player_player_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tennis
--

SELECT pg_catalog.setval('tbl_player_player_id_seq', 1, false);


--
-- TOC entry 2221 (class 0 OID 16727)
-- Dependencies: 201
-- Data for Name: tbl_rating; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_rating (rating_id, player_id, "FromDate", "ToDate", "SW1YALL", "SW3MALL", "SW1MALL", "SW1YG", "SW1YH", "SW1YC", "ATP") FROM stdin;
\.


--
-- TOC entry 2243 (class 0 OID 0)
-- Dependencies: 202
-- Name: tbl_rating_rating_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tennis
--

SELECT pg_catalog.setval('tbl_rating_rating_id_seq', 1, false);


--
-- TOC entry 2209 (class 0 OID 16662)
-- Dependencies: 189
-- Data for Name: tbl_sackmann_match; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_sackmann_match (index, tourney_id, tourney_name, surface, draw_size, tourney_level, tourney_date, match_num, winner_id, winner_seed, winner_entry, winner_name, winner_hand, winner_ht, winner_ioc, winner_age, winner_rank, winner_rank_points, loser_id, loser_seed, loser_entry, loser_name, loser_hand, loser_ht, loser_ioc, loser_age, loser_rank, loser_rank_points, score, best_of, round, minutes, w_ace, w_df, w_svpt, "w_1stIn", "w_1stWon", "w_2ndWon", "w_SvGms", "w_bpSaved", "w_bpFaced", l_ace, l_df, l_svpt, "l_1stIn", "l_1stWon", "l_2ndWon", "l_SvGms", "l_bpSaved", "l_bpFaced") FROM stdin;
\.


--
-- TOC entry 2210 (class 0 OID 16668)
-- Dependencies: 190
-- Data for Name: tbl_sackmann_players; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_sackmann_players (index, id, firstname, lastname, plays, dob, "IOC", update) FROM stdin;
\.


--
-- TOC entry 2211 (class 0 OID 16674)
-- Dependencies: 191
-- Data for Name: tbl_te_matchlist; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_te_matchlist (index, "MatchDate", away, away_link, away_odds, away_result, away_score_1, away_score_2, away_score_3, away_score_4, away_score_5, home, home_link, home_odds, home_result, home_score_1, home_score_2, home_score_3, home_score_4, home_score_5, match_link, "time", tournament, tournament_link, update) FROM stdin;
\.


--
-- TOC entry 2212 (class 0 OID 16680)
-- Dependencies: 192
-- Data for Name: tbl_te_player; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_te_player (index, etl_date, player_country, player_dob, player_name, player_plays, player_sex, player_url, update) FROM stdin;
\.


--
-- TOC entry 2213 (class 0 OID 16686)
-- Dependencies: 193
-- Data for Name: tbl_tournament; Type: TABLE DATA; Schema: public; Owner: tennis
--

COPY tbl_tournament (tournament_id, name, location, category, pin_league_id, te_link) FROM stdin;
\.


--
-- TOC entry 2244 (class 0 OID 0)
-- Dependencies: 194
-- Name: tbl_tournament_tournament_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tennis
--

SELECT pg_catalog.setval('tbl_tournament_tournament_id_seq', 1, false);


--
-- TOC entry 2081 (class 2606 OID 16740)
-- Name: tbl_bettyp tbl_bettyp_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_bettyp
    ADD CONSTRAINT tbl_bettyp_pk PRIMARY KEY (bettyp_id);


--
-- TOC entry 2083 (class 2606 OID 16742)
-- Name: tbl_bookie tbl_bookie_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_bookie
    ADD CONSTRAINT tbl_bookie_pk PRIMARY KEY (bookie_id);


--
-- TOC entry 2067 (class 2606 OID 16695)
-- Name: tbl_match tbl_match_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_match
    ADD CONSTRAINT tbl_match_pk PRIMARY KEY (match_id);


--
-- TOC entry 2085 (class 2606 OID 16744)
-- Name: tbl_odds tbl_odds_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_odds
    ADD CONSTRAINT tbl_odds_pk PRIMARY KEY (odds_id);


--
-- TOC entry 2071 (class 2606 OID 16697)
-- Name: tbl_player tbl_player_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_player
    ADD CONSTRAINT tbl_player_pk PRIMARY KEY (player_id);


--
-- TOC entry 2087 (class 2606 OID 16746)
-- Name: tbl_rating tbl_rating_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_rating
    ADD CONSTRAINT tbl_rating_pk PRIMARY KEY (rating_id);


--
-- TOC entry 2079 (class 2606 OID 16699)
-- Name: tbl_tournament tbl_tournament_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_tournament
    ADD CONSTRAINT tbl_tournament_pk PRIMARY KEY (tournament_id);


--
-- TOC entry 2073 (class 2606 OID 16701)
-- Name: tbl_player te_link; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_player
    ADD CONSTRAINT te_link UNIQUE (te_link);


--
-- TOC entry 2069 (class 2606 OID 16703)
-- Name: tbl_match unique; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_match
    ADD CONSTRAINT "unique" UNIQUE ("MatchDate", player1_id, player2_id);


--
-- TOC entry 2074 (class 1259 OID 16704)
-- Name: ix_tbl_sackmann_match_index; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX ix_tbl_sackmann_match_index ON tbl_sackmann_match USING btree (index);


--
-- TOC entry 2075 (class 1259 OID 16705)
-- Name: ix_tbl_sackmann_players_index; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX ix_tbl_sackmann_players_index ON tbl_sackmann_players USING btree (index);


--
-- TOC entry 2076 (class 1259 OID 16706)
-- Name: ix_tbl_te_matchlist_index; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX ix_tbl_te_matchlist_index ON tbl_te_matchlist USING btree (index);


--
-- TOC entry 2077 (class 1259 OID 16707)
-- Name: ix_tbl_te_player_index; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX ix_tbl_te_player_index ON tbl_te_player USING btree (index);


--
-- TOC entry 2229 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2017-10-31 16:05:20

--
-- PostgreSQL database dump complete
--

