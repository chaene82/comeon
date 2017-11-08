--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.5
-- Dumped by pg_dump version 9.6.5

-- Started on 2017-11-08 12:00:37

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
-- TOC entry 2233 (class 1262 OID 16749)
-- Name: tennis; Type: DATABASE; Schema: -; Owner: tennis
--

CREATE DATABASE tennis ;


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
-- TOC entry 2236 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 207 (class 1259 OID 16921)
-- Name: tbl_balance_balance_id_seq; Type: SEQUENCE; Schema: public; Owner: tennis
--

CREATE SEQUENCE tbl_balance_balance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;


ALTER TABLE tbl_balance_balance_id_seq OWNER TO tennis;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 206 (class 1259 OID 16913)
-- Name: tbl_balance; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_balance (
    balance_id bigint DEFAULT nextval('tbl_balance_balance_id_seq'::regclass) NOT NULL,
    bookie_id integer,
    date timestamp with time zone,
    total_balance numeric,
    free_balance numeric,
    blocked_balance numeric,
    total_balance_eur numeric
);


ALTER TABLE tbl_balance OWNER TO tennis;

--
-- TOC entry 185 (class 1259 OID 16751)
-- Name: tbl_bettyp; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_bettyp (
    bettyp_id integer NOT NULL,
    bettyp_name character(50)
);


ALTER TABLE tbl_bettyp OWNER TO tennis;

--
-- TOC entry 186 (class 1259 OID 16754)
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
-- TOC entry 2237 (class 0 OID 0)
-- Dependencies: 186
-- Name: tbl_bettyp_bettyp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_bettyp_bettyp_id_seq OWNED BY tbl_bettyp.bettyp_id;


--
-- TOC entry 187 (class 1259 OID 16756)
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
    bookie_passwd character varying(20),
    min_balance numeric,
    max_balance numeric
);


ALTER TABLE tbl_bookie OWNER TO tennis;

--
-- TOC entry 188 (class 1259 OID 16762)
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
-- TOC entry 2238 (class 0 OID 0)
-- Dependencies: 188
-- Name: tbl_bookie_bookie_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_bookie_bookie_id_seq OWNED BY tbl_bookie.bookie_id;


--
-- TOC entry 189 (class 1259 OID 16764)
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
-- TOC entry 190 (class 1259 OID 16766)
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
-- TOC entry 191 (class 1259 OID 16773)
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
-- TOC entry 2239 (class 0 OID 0)
-- Dependencies: 191
-- Name: tbl_events_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_events_event_id_seq OWNED BY tbl_events.event_id;


--
-- TOC entry 192 (class 1259 OID 16775)
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
-- TOC entry 193 (class 1259 OID 16778)
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
-- TOC entry 2240 (class 0 OID 0)
-- Dependencies: 193
-- Name: tbl_match_match_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_match_match_id_seq OWNED BY tbl_match.match_id;


--
-- TOC entry 194 (class 1259 OID 16780)
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
-- TOC entry 195 (class 1259 OID 16783)
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
-- TOC entry 2241 (class 0 OID 0)
-- Dependencies: 195
-- Name: tbl_odds_odds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_odds_odds_id_seq OWNED BY tbl_odds.odds_id;


--
-- TOC entry 196 (class 1259 OID 16785)
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
-- TOC entry 197 (class 1259 OID 16788)
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
-- TOC entry 2242 (class 0 OID 0)
-- Dependencies: 197
-- Name: tbl_rating_rating_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_rating_rating_id_seq OWNED BY tbl_rating.rating_id;


--
-- TOC entry 198 (class 1259 OID 16790)
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
-- TOC entry 199 (class 1259 OID 16796)
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
-- TOC entry 204 (class 1259 OID 16870)
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
-- TOC entry 205 (class 1259 OID 16886)
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
    update timestamp with time zone,
    theoretical_winnings numeric,
    surebet_typ integer
);


ALTER TABLE tbl_surebet OWNER TO tennis;

--
-- TOC entry 200 (class 1259 OID 16802)
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
-- TOC entry 201 (class 1259 OID 16808)
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
-- TOC entry 202 (class 1259 OID 16814)
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
-- TOC entry 203 (class 1259 OID 16817)
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
-- TOC entry 2243 (class 0 OID 0)
-- Dependencies: 203
-- Name: tbl_tournament_tournament_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_tournament_tournament_id_seq OWNED BY tbl_tournament.tournament_id;


--
-- TOC entry 2075 (class 2604 OID 16825)
-- Name: tbl_bettyp bettyp_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_bettyp ALTER COLUMN bettyp_id SET DEFAULT nextval('tbl_bettyp_bettyp_id_seq'::regclass);


--
-- TOC entry 2076 (class 2604 OID 16826)
-- Name: tbl_bookie bookie_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_bookie ALTER COLUMN bookie_id SET DEFAULT nextval('tbl_bookie_bookie_id_seq'::regclass);


--
-- TOC entry 2078 (class 2604 OID 16827)
-- Name: tbl_match match_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_match ALTER COLUMN match_id SET DEFAULT nextval('tbl_match_match_id_seq'::regclass);


--
-- TOC entry 2079 (class 2604 OID 16828)
-- Name: tbl_odds odds_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_odds ALTER COLUMN odds_id SET DEFAULT nextval('tbl_odds_odds_id_seq'::regclass);


--
-- TOC entry 2080 (class 2604 OID 16829)
-- Name: tbl_rating rating_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_rating ALTER COLUMN rating_id SET DEFAULT nextval('tbl_rating_rating_id_seq'::regclass);


--
-- TOC entry 2081 (class 2604 OID 16830)
-- Name: tbl_tournament tournament_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_tournament ALTER COLUMN tournament_id SET DEFAULT nextval('tbl_tournament_tournament_id_seq'::regclass);


--
-- TOC entry 2089 (class 2606 OID 16833)
-- Name: tbl_events match; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_events
    ADD CONSTRAINT match UNIQUE ("StartDate", home_player_name, away_player_name);


--
-- TOC entry 2097 (class 2606 OID 16835)
-- Name: tbl_odds odds_unique; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_odds
    ADD CONSTRAINT odds_unique UNIQUE (event_id, bettyp_id, way, backlay, bookie_id);


--
-- TOC entry 2111 (class 2606 OID 16926)
-- Name: tbl_balance tbl_balance_pkey; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_balance
    ADD CONSTRAINT tbl_balance_pkey PRIMARY KEY (balance_id);


--
-- TOC entry 2085 (class 2606 OID 16837)
-- Name: tbl_bettyp tbl_bettyp_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_bettyp
    ADD CONSTRAINT tbl_bettyp_pk PRIMARY KEY (bettyp_id);


--
-- TOC entry 2087 (class 2606 OID 16839)
-- Name: tbl_bookie tbl_bookie_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_bookie
    ADD CONSTRAINT tbl_bookie_pk PRIMARY KEY (bookie_id);


--
-- TOC entry 2091 (class 2606 OID 16841)
-- Name: tbl_events tbl_events_pkey; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_events
    ADD CONSTRAINT tbl_events_pkey PRIMARY KEY (event_id);


--
-- TOC entry 2093 (class 2606 OID 16843)
-- Name: tbl_match tbl_match_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_match
    ADD CONSTRAINT tbl_match_pk PRIMARY KEY (match_id);


--
-- TOC entry 2099 (class 2606 OID 16845)
-- Name: tbl_odds tbl_odds_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_odds
    ADD CONSTRAINT tbl_odds_pk PRIMARY KEY (odds_id);


--
-- TOC entry 2101 (class 2606 OID 16847)
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
-- TOC entry 2107 (class 2606 OID 16849)
-- Name: tbl_tournament tbl_tournament_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_tournament
    ADD CONSTRAINT tbl_tournament_pk PRIMARY KEY (tournament_id);


--
-- TOC entry 2095 (class 2606 OID 16851)
-- Name: tbl_match unique; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_match
    ADD CONSTRAINT "unique" UNIQUE ("MatchDate", player1_id, player2_id);


--
-- TOC entry 2102 (class 1259 OID 16854)
-- Name: ix_tbl_sackmann_match_index; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX ix_tbl_sackmann_match_index ON tbl_sackmann_match USING btree (index);


--
-- TOC entry 2103 (class 1259 OID 16855)
-- Name: ix_tbl_sackmann_players_index; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX ix_tbl_sackmann_players_index ON tbl_sackmann_players USING btree (index);


--
-- TOC entry 2104 (class 1259 OID 16856)
-- Name: ix_tbl_te_matchlist_index; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX ix_tbl_te_matchlist_index ON tbl_te_matchlist USING btree (index);


--
-- TOC entry 2105 (class 1259 OID 16857)
-- Name: ix_tbl_te_player_index; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX ix_tbl_te_player_index ON tbl_te_player USING btree (index);


--
-- TOC entry 2235 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2017-11-08 12:00:37

--
-- PostgreSQL database dump complete
--

