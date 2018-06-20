--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.5
-- Dumped by pg_dump version 9.6.5

-- Started on 2018-06-06 11:58:22

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
-- TOC entry 2388 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 2 (class 3079 OID 25618)
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- TOC entry 2389 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


SET search_path = public, pg_catalog;

--
-- TOC entry 198 (class 1259 OID 16921)
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
-- TOC entry 197 (class 1259 OID 16913)
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
-- TOC entry 2390 (class 0 OID 0)
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
    bookie_name character(20),
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
-- TOC entry 2391 (class 0 OID 0)
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
-- TOC entry 215 (class 1259 OID 25692)
-- Name: tbl_event_player_id_seq; Type: SEQUENCE; Schema: public; Owner: tennis
--

CREATE SEQUENCE tbl_event_player_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbl_event_player_id_seq OWNER TO tennis;

--
-- TOC entry 214 (class 1259 OID 25684)
-- Name: tbl_event_player; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE tbl_event_player (
    event_player_id bigint DEFAULT nextval('tbl_event_player_id_seq'::regclass) NOT NULL,
    pin_player_name character varying(100),
    betbtc_player_name character varying(100),
    matchbook_player_name character varying(100),
    betdaq_player_name character varying(100),
    betfair_player_name character varying(100)
);


ALTER TABLE tbl_event_player OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 25569)
-- Name: tbl_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE tbl_events (
    event_id integer DEFAULT nextval('tbl_event_event_id_seq'::regclass) NOT NULL,
    betbtc_event_id bigint,
    pinnacle_event_id bigint,
    betfair_event_id numeric,
    "StartDate" date,
    home_player_id bigint,
    home_player_name character varying(100),
    away_player_id bigint,
    away_player_name character varying(100),
    "Live" integer,
    "LastUpdate" timestamp with time zone,
    "StartDateTime" timestamp with time zone,
    pinnacle_league_id bigint,
    matchbook_event_id bigint,
    betdaq_event_id bigint
);


ALTER TABLE tbl_events OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 16951)
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
-- TOC entry 201 (class 1259 OID 16953)
-- Name: tbl_match; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_match (
    match_id integer DEFAULT nextval('tbl_match_match_id_seq'::regclass) NOT NULL,
    tournament_id integer,
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
    update timestamp with time zone,
    "MatchDateYearWeek" integer,
    sm_tourney_level character varying(10),
    player1_seed numeric,
    player1_entry character varying(10),
    player2_seed numeric,
    player2_entry character varying(10),
    player1_age numeric,
    player2_age numeric,
    sm_player1_rank numeric,
    sm_player1_rank_point numeric,
    sm_player2_rank numeric,
    sm_player2_rank_point numeric,
    best_of integer,
    round character varying(10),
    minutes numeric,
    player1_ace numeric,
    player1_df numeric,
    player1_svpt numeric,
    player1_1st_in numeric,
    player1_1st_won numeric,
    player1_2nd_won numeric,
    player1_sv_games numeric,
    player1_bp_saved numeric,
    player1_bp_faced numeric,
    player2_ace numeric,
    player2_df numeric,
    player2_svpt numeric,
    player2_1st_in numeric,
    player2_1st_won numeric,
    player2_2nd_won numeric,
    player2_sv_games numeric,
    player2_bp_saved numeric,
    player2_bp_faced numeric,
    player1_odds numeric,
    player2_odds numeric,
    number_of_set double precision,
    number_of_games double precision,
    player1_fair_odds numeric,
    player2_fair_odds numeric,
    player1_proba numeric,
    player2_proba numeric,
    player1_pin_odds numeric,
    player2_pin_odds numeric
);


ALTER TABLE tbl_match OWNER TO tennis;

--
-- TOC entry 191 (class 1259 OID 16780)
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
    odds double precision,
    pin_line_id bigint,
    max_stake numeric
);


ALTER TABLE tbl_odds OWNER TO tennis;

--
-- TOC entry 192 (class 1259 OID 16783)
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
-- TOC entry 2392 (class 0 OID 0)
-- Dependencies: 192
-- Name: tbl_odds_odds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_odds_odds_id_seq OWNED BY tbl_odds.odds_id;


--
-- TOC entry 211 (class 1259 OID 25499)
-- Name: tbl_offer_offer_id_seq; Type: SEQUENCE; Schema: public; Owner: tennis
--

CREATE SEQUENCE tbl_offer_offer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999
    CACHE 1;


ALTER TABLE tbl_offer_offer_id_seq OWNER TO tennis;

--
-- TOC entry 212 (class 1259 OID 25510)
-- Name: tbl_offer; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_offer (
    offer_id bigint DEFAULT nextval('tbl_offer_offer_id_seq'::regclass) NOT NULL,
    odds_id bigint,
    hedge_odds_id bigint,
    order_id bigint,
    odds numeric,
    turnover_eur numeric,
    turnover_local numeric,
    currency character varying(3),
    betdate timestamp with time zone,
    matchdate timestamp with time zone,
    status integer,
    update timestamp with time zone,
    bookie_bet_id bigint,
    hedge_stakes numeric,
    hedge_odds numeric
);


ALTER TABLE tbl_offer OWNER TO tennis;

--
-- TOC entry 203 (class 1259 OID 16975)
-- Name: tbl_orderbook_order_id_seq; Type: SEQUENCE; Schema: public; Owner: tennis
--

CREATE SEQUENCE tbl_orderbook_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbl_orderbook_order_id_seq OWNER TO tennis;

--
-- TOC entry 202 (class 1259 OID 16965)
-- Name: tbl_orderbook; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_orderbook (
    order_id bigint DEFAULT nextval('tbl_orderbook_order_id_seq'::regclass) NOT NULL,
    product_id integer,
    offer_id bigint,
    odds_id bigint,
    bookie_id integer,
    bookie_bet_id bigint,
    backlay_id integer,
    bettype_id integer,
    way integer,
    odds numeric,
    eff_odds numeric,
    turnover_eur numeric,
    turnover_local numeric,
    "Currency" character varying(3),
    betdate timestamp with time zone,
    bet_settlement_date timestamp with time zone,
    status integer,
    winnings_local numeric,
    commission numeric,
    net_winnings_local numeric,
    surebet_id bigint,
    test integer,
    update timestamp with time zone,
    winnings_eur numeric,
    net_winnings_eur numeric
);


ALTER TABLE tbl_orderbook OWNER TO tennis;

--
-- TOC entry 204 (class 1259 OID 17115)
-- Name: tbl_player_player_id_seq; Type: SEQUENCE; Schema: public; Owner: tennis
--

CREATE SEQUENCE tbl_player_player_id_seq
    START WITH 76727
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbl_player_player_id_seq OWNER TO tennis;

--
-- TOC entry 218 (class 1259 OID 34954)
-- Name: tbl_player; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_player (
    player_id integer DEFAULT nextval('tbl_player_player_id_seq'::regclass) NOT NULL,
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
-- TOC entry 199 (class 1259 OID 16934)
-- Name: tbl_product; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_product (
    product_id integer NOT NULL,
    product_name character varying(100),
    product_type character varying(50),
    start_date timestamp with time zone
);


ALTER TABLE tbl_product OWNER TO tennis;

--
-- TOC entry 219 (class 1259 OID 36750)
-- Name: tbl_rating; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_rating (
    player_id integer,
    from_date timestamp without time zone,
    to_date timestamp without time zone,
    atp_points double precision,
    atp_rank bigint,
    sw1yg double precision,
    sw1yh double precision,
    sw1yc double precision,
    sw1yall double precision,
    sw3mall double precision,
    sw1mall double precision
);


ALTER TABLE tbl_rating OWNER TO tennis;

--
-- TOC entry 206 (class 1259 OID 17437)
-- Name: tbl_sackmann_match; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_sackmann_match (
    index bigint,
    tourney_id text,
    tourney_name text,
    surface text,
    draw_size double precision,
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
-- TOC entry 205 (class 1259 OID 17430)
-- Name: tbl_sackmann_players; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_sackmann_players (
    index bigint,
    id integer,
    firstname text,
    lastname text,
    plays text,
    dob integer,
    "IOC" text,
    update timestamp without time zone
);


ALTER TABLE tbl_sackmann_players OWNER TO tennis;

--
-- TOC entry 195 (class 1259 OID 16870)
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
-- TOC entry 196 (class 1259 OID 16886)
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
-- TOC entry 224 (class 1259 OID 59289)
-- Name: tbl_ta_events_event_id_seq; Type: SEQUENCE; Schema: public; Owner: tennis
--

CREATE SEQUENCE tbl_ta_events_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbl_ta_events_event_id_seq OWNER TO tennis;

--
-- TOC entry 225 (class 1259 OID 59291)
-- Name: tbl_ta_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE tbl_ta_events (
    ta_event_id bigint DEFAULT nextval('tbl_ta_events_event_id_seq'::regclass) NOT NULL,
    event_id bigint,
    home_player_id bigint,
    home_player_proba numeric,
    away_player_id bigint,
    away_player_proba numeric,
    ta_tournament character varying,
    update timestamp with time zone
);


ALTER TABLE tbl_ta_events OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 59597)
-- Name: tbl_ta_proba; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_ta_proba (
    away_player_name text,
    away_player_proba double precision,
    home_player_name text,
    home_player_proba double precision,
    tournament text
);


ALTER TABLE tbl_ta_proba OWNER TO tennis;

--
-- TOC entry 220 (class 1259 OID 50941)
-- Name: tbl_te_matchdetails; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_te_matchdetails (
    index bigint,
    match_link text,
    surface text
);


ALTER TABLE tbl_te_matchdetails OWNER TO tennis;

--
-- TOC entry 223 (class 1259 OID 59237)
-- Name: tbl_te_matchlist; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_te_matchlist (
    "MatchDate" timestamp without time zone,
    away text,
    away_link text,
    away_odds double precision,
    away_result bigint,
    away_score_1 bigint,
    away_score_2 bigint,
    away_score_3 double precision,
    away_score_4 double precision,
    away_score_5 double precision,
    home text,
    home_link text,
    home_odds double precision,
    home_result bigint,
    home_score_1 bigint,
    home_score_2 bigint,
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
-- TOC entry 222 (class 1259 OID 59175)
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
-- TOC entry 221 (class 1259 OID 50948)
-- Name: tbl_te_ranking; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_te_ranking (
    index bigint,
    "StartDate" timestamp without time zone,
    player text,
    player_link text,
    points text,
    rank integer
);


ALTER TABLE tbl_te_ranking OWNER TO tennis;

--
-- TOC entry 193 (class 1259 OID 16814)
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
-- TOC entry 194 (class 1259 OID 16817)
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
-- TOC entry 2393 (class 0 OID 0)
-- Dependencies: 194
-- Name: tbl_tournament_tournament_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tennis
--

ALTER SEQUENCE tbl_tournament_tournament_id_seq OWNED BY tbl_tournament.tournament_id;


--
-- TOC entry 228 (class 1259 OID 59458)
-- Name: tbl_ttt_events_event_id_seq; Type: SEQUENCE; Schema: public; Owner: tennis
--

CREATE SEQUENCE tbl_ttt_events_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tbl_ttt_events_event_id_seq OWNER TO tennis;

--
-- TOC entry 229 (class 1259 OID 59478)
-- Name: tbl_ttt_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE tbl_ttt_events (
    ttt_event_id bigint DEFAULT nextval('tbl_ttt_events_event_id_seq'::regclass) NOT NULL,
    event_id bigint,
    home_player_id bigint,
    home_player_name character varying,
    away_player_id bigint,
    away_player_name character varying,
    winner_player_id bigint,
    winner_name character varying,
    winner_proba numeric,
    way integer,
    ttt_tournament character varying,
    update timestamp with time zone
);


ALTER TABLE tbl_ttt_events OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 59603)
-- Name: tbl_ttt_picks; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE tbl_ttt_picks (
    at_odd text,
    bet_value text,
    event text,
    level text,
    match text,
    matchdatetime text,
    win_proba text,
    winner text
);


ALTER TABLE tbl_ttt_picks OWNER TO tennis;

--
-- TOC entry 210 (class 1259 OID 25483)
-- Name: temp_ranking_SW1MALL; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE "temp_ranking_SW1MALL" (
    index bigint,
    "Player" bigint,
    "SW1MALL" double precision,
    "FromDate" timestamp without time zone,
    "ToDate" timestamp without time zone
);


ALTER TABLE "temp_ranking_SW1MALL" OWNER TO tennis;

--
-- TOC entry 216 (class 1259 OID 34913)
-- Name: temp_ranking_SW1YALL; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "temp_ranking_SW1YALL" (
    index bigint,
    "Player" bigint,
    "SW1YALL" double precision,
    "FromDate" timestamp without time zone,
    "ToDate" timestamp without time zone
);


ALTER TABLE "temp_ranking_SW1YALL" OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 25474)
-- Name: temp_ranking_SW1YC; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE "temp_ranking_SW1YC" (
    index bigint,
    "Player" double precision,
    "SW1YC" double precision,
    "FromDate" timestamp without time zone,
    "ToDate" timestamp without time zone
);


ALTER TABLE "temp_ranking_SW1YC" OWNER TO tennis;

--
-- TOC entry 208 (class 1259 OID 25470)
-- Name: temp_ranking_SW1YG; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE "temp_ranking_SW1YG" (
    index bigint,
    "Player" double precision,
    "SW1YG" double precision,
    "FromDate" timestamp without time zone,
    "ToDate" timestamp without time zone
);


ALTER TABLE "temp_ranking_SW1YG" OWNER TO tennis;

--
-- TOC entry 207 (class 1259 OID 25466)
-- Name: temp_ranking_SW1YH; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE "temp_ranking_SW1YH" (
    index bigint,
    "Player" double precision,
    "SW1YH" double precision,
    "FromDate" timestamp without time zone,
    "ToDate" timestamp without time zone
);


ALTER TABLE "temp_ranking_SW1YH" OWNER TO tennis;

--
-- TOC entry 217 (class 1259 OID 34917)
-- Name: temp_ranking_SW3MALL; Type: TABLE; Schema: public; Owner: tennis
--

CREATE TABLE "temp_ranking_SW3MALL" (
    index bigint,
    "Player" bigint,
    "SW3MALL" double precision,
    "FromDate" timestamp without time zone,
    "ToDate" timestamp without time zone
);


ALTER TABLE "temp_ranking_SW3MALL" OWNER TO tennis;

--
-- TOC entry 233 (class 1259 OID 59609)
-- Name: v_orderbook; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW v_orderbook AS
 SELECT ob.order_id,
    ob.product_id,
    ob.offer_id,
    ob.odds_id,
    ob.bookie_id,
    ob.bookie_bet_id,
    ob.backlay_id,
    ob.bettype_id,
    ob.way,
    ob.odds,
    ob.eff_odds,
    ob.turnover_eur,
    ob.turnover_local,
    (ob.winnings_eur - ob.turnover_eur) AS return,
    ob."Currency",
    ob.betdate,
    ob.bet_settlement_date,
    ob.status,
    ob.winnings_local,
    ob.commission,
    ob.net_winnings_local,
    ob.surebet_id,
    ob.test,
    ob.winnings_eur,
    ob.net_winnings_eur,
    e."StartDateTime",
    hp.pin_player_name AS home_player_name,
    ap.pin_player_name AS away_player_name,
        CASE
            WHEN (ob.way = 1) THEN hp.pin_player_name
            ELSE ap.pin_player_name
        END AS bet_on_player_name,
    tae.ta_event_id,
    tae.event_id,
    tae.home_player_id,
    tae.home_player_proba,
    tae.away_player_id,
    tae.away_player_proba,
        CASE
            WHEN ((tae.ta_tournament)::text ~~ '%ATP%'::text) THEN 'atp'::text
            WHEN ((tae.ta_tournament)::text ~~ '%Men%'::text) THEN 'atp'::text
            WHEN ((tae.ta_tournament)::text ~~ '%Challenger%'::text) THEN 'challenger'::text
            WHEN ((tae.ta_tournament)::text ~~ '%WTA%'::text) THEN 'wta'::text
            ELSE 'wta'::text
        END AS tournament_cat,
        CASE
            WHEN (tae.ta_tournament IS NOT NULL) THEN tae.ta_tournament
            ELSE ttt.ttt_tournament
        END AS ta_tournament,
    tae.update
   FROM ((((((tbl_orderbook ob
     JOIN tbl_odds o USING (odds_id))
     JOIN tbl_events e USING (event_id))
     JOIN tbl_event_player hp ON ((e.home_player_id = hp.event_player_id)))
     JOIN tbl_event_player ap ON ((e.away_player_id = ap.event_player_id)))
     LEFT JOIN tbl_ta_events tae USING (event_id))
     LEFT JOIN tbl_ttt_events ttt USING (event_id))
  WHERE (ob.product_id = ANY (ARRAY[5, 7, 8]));


ALTER TABLE v_orderbook OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 59357)
-- Name: v_ta_betbtc_next_events; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW v_ta_betbtc_next_events WITH (security_barrier='false') AS
 SELECT e.event_id,
    e."StartDateTime",
    e.home_player_id,
    h.pin_player_name AS home_player_name,
    ta.home_player_proba,
    oh.odds AS home_odds,
    oh.odds_id AS home_odds_id,
    e.away_player_id,
    a.pin_player_name AS away_player_name,
    ta.away_player_proba,
    oa.odds AS away_odds,
    oa.odds_id AS away_odds_id
   FROM (((((tbl_events e
     JOIN tbl_event_player h ON ((e.home_player_id = h.event_player_id)))
     JOIN tbl_event_player a ON ((e.away_player_id = a.event_player_id)))
     JOIN tbl_ta_events ta ON ((e.event_id = ta.event_id)))
     JOIN tbl_odds oh ON ((e.event_id = oh.event_id)))
     JOIN tbl_odds oa ON ((e.event_id = oa.event_id)))
  WHERE ((e."StartDateTime" >= now()) AND (e."StartDateTime" <= (now() + '02:00:00'::interval)) AND (oh.bookie_id = 2) AND (oh.way = 1) AND (oh.backlay = 1) AND (oa.bookie_id = 2) AND (oa.way = 2) AND (oa.backlay = 1) AND (NOT ((ta.ta_tournament)::text ~~ '%Challenger%'::text)) AND (NOT (oh.odds_id IN ( SELECT tbl_orderbook.odds_id
           FROM tbl_orderbook))) AND (NOT (oa.odds_id IN ( SELECT tbl_orderbook.odds_id
           FROM tbl_orderbook))));


ALTER TABLE v_ta_betbtc_next_events OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 59338)
-- Name: v_ta_next_events; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW v_ta_next_events WITH (security_barrier='false') AS
 SELECT e.event_id,
    e."StartDateTime",
    e.home_player_id,
    h.pin_player_name AS home_player_name,
    ta.home_player_proba,
    oh.odds AS home_odds,
    oh.odds_id AS home_odds_id,
    e.away_player_id,
    a.pin_player_name AS away_player_name,
    ta.away_player_proba,
    oa.odds AS away_odds,
    oa.odds_id AS away_odds_id
   FROM (((((tbl_events e
     JOIN tbl_event_player h ON ((e.home_player_id = h.event_player_id)))
     JOIN tbl_event_player a ON ((e.away_player_id = a.event_player_id)))
     JOIN tbl_ta_events ta ON ((e.event_id = ta.event_id)))
     JOIN tbl_odds oh ON ((e.event_id = oh.event_id)))
     JOIN tbl_odds oa ON ((e.event_id = oa.event_id)))
  WHERE ((e."StartDateTime" >= now()) AND (e."StartDateTime" <= (now() + '02:00:00'::interval)) AND (oh.bookie_id = 1) AND (oh.way = 1) AND (oa.bookie_id = 1) AND (oa.way = 2) AND (NOT ((ta.ta_tournament)::text ~~ '%Challenger%'::text)) AND (NOT (oh.odds_id IN ( SELECT tbl_orderbook.odds_id
           FROM tbl_orderbook
          WHERE (tbl_orderbook.product_id = 5)))) AND (NOT (oa.odds_id IN ( SELECT tbl_orderbook.odds_id
           FROM tbl_orderbook
          WHERE (tbl_orderbook.product_id = 5)))));


ALTER TABLE v_ta_next_events OWNER TO postgres;

--
-- TOC entry 2394 (class 0 OID 0)
-- Dependencies: 226
-- Name: VIEW v_ta_next_events; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW v_ta_next_events IS 'next ';


--
-- TOC entry 230 (class 1259 OID 59495)
-- Name: v_ttt_next_events; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW v_ttt_next_events AS
 SELECT e.event_id,
    e."StartDateTime",
    p.pin_player_name AS winner_player_name,
    ttt.winner_player_id,
    ttt.winner_proba,
    o.odds AS winner_odds,
    o.odds_id AS winner_odds_id
   FROM (((tbl_events e
     JOIN tbl_ttt_events ttt ON ((e.event_id = ttt.event_id)))
     JOIN tbl_event_player p ON ((ttt.winner_player_id = p.event_player_id)))
     JOIN tbl_odds o ON (((e.event_id = o.event_id) AND (ttt.way = o.way))))
  WHERE ((e."StartDateTime" >= now()) AND (e."StartDateTime" <= (now() + '48:00:00'::interval)) AND (o.bookie_id = 1) AND (NOT (o.odds_id IN ( SELECT tbl_orderbook.odds_id
           FROM tbl_orderbook
          WHERE (tbl_orderbook.product_id = 7)))));


ALTER TABLE v_ttt_next_events OWNER TO postgres;

--
-- TOC entry 2190 (class 2604 OID 16825)
-- Name: tbl_bettyp bettyp_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_bettyp ALTER COLUMN bettyp_id SET DEFAULT nextval('tbl_bettyp_bettyp_id_seq'::regclass);


--
-- TOC entry 2191 (class 2604 OID 16826)
-- Name: tbl_bookie bookie_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_bookie ALTER COLUMN bookie_id SET DEFAULT nextval('tbl_bookie_bookie_id_seq'::regclass);


--
-- TOC entry 2192 (class 2604 OID 16828)
-- Name: tbl_odds odds_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_odds ALTER COLUMN odds_id SET DEFAULT nextval('tbl_odds_odds_id_seq'::regclass);


--
-- TOC entry 2193 (class 2604 OID 16830)
-- Name: tbl_tournament tournament_id; Type: DEFAULT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_tournament ALTER COLUMN tournament_id SET DEFAULT nextval('tbl_tournament_tournament_id_seq'::regclass);


--
-- TOC entry 2254 (class 2606 OID 59301)
-- Name: tbl_ta_events event_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tbl_ta_events
    ADD CONSTRAINT event_id UNIQUE (event_id);


--
-- TOC entry 2238 (class 2606 OID 25891)
-- Name: tbl_events match; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tbl_events
    ADD CONSTRAINT match UNIQUE ("StartDate", home_player_id, away_player_id);


--
-- TOC entry 2209 (class 2606 OID 16835)
-- Name: tbl_odds odds_unique; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_odds
    ADD CONSTRAINT odds_unique UNIQUE (event_id, bettyp_id, way, backlay, bookie_id);


--
-- TOC entry 2217 (class 2606 OID 16926)
-- Name: tbl_balance tbl_balance_pkey; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_balance
    ADD CONSTRAINT tbl_balance_pkey PRIMARY KEY (balance_id);


--
-- TOC entry 2205 (class 2606 OID 16837)
-- Name: tbl_bettyp tbl_bettyp_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_bettyp
    ADD CONSTRAINT tbl_bettyp_pk PRIMARY KEY (bettyp_id);


--
-- TOC entry 2207 (class 2606 OID 16839)
-- Name: tbl_bookie tbl_bookie_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_bookie
    ADD CONSTRAINT tbl_bookie_pk PRIMARY KEY (bookie_id);


--
-- TOC entry 2243 (class 2606 OID 25691)
-- Name: tbl_event_player tbl_event_player_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tbl_event_player
    ADD CONSTRAINT tbl_event_player_pkey PRIMARY KEY (event_player_id);


--
-- TOC entry 2240 (class 2606 OID 25577)
-- Name: tbl_events tbl_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tbl_events
    ADD CONSTRAINT tbl_events_pkey PRIMARY KEY (event_id);


--
-- TOC entry 2224 (class 2606 OID 16961)
-- Name: tbl_match tbl_match_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_match
    ADD CONSTRAINT tbl_match_pk PRIMARY KEY (match_id);


--
-- TOC entry 2211 (class 2606 OID 16845)
-- Name: tbl_odds tbl_odds_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_odds
    ADD CONSTRAINT tbl_odds_pk PRIMARY KEY (odds_id);


--
-- TOC entry 2236 (class 2606 OID 25518)
-- Name: tbl_offer tbl_offer_pkey; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_offer
    ADD CONSTRAINT tbl_offer_pkey PRIMARY KEY (offer_id);


--
-- TOC entry 2228 (class 2606 OID 16972)
-- Name: tbl_orderbook tbl_orderbook_pkey; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_orderbook
    ADD CONSTRAINT tbl_orderbook_pkey PRIMARY KEY (order_id);


--
-- TOC entry 2219 (class 2606 OID 16938)
-- Name: tbl_product tbl_product_pkey; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_product
    ADD CONSTRAINT tbl_product_pkey PRIMARY KEY (product_id);


--
-- TOC entry 2215 (class 2606 OID 16894)
-- Name: tbl_surebet tbl_surebet_pkey; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_surebet
    ADD CONSTRAINT tbl_surebet_pkey PRIMARY KEY (surebet_id);


--
-- TOC entry 2256 (class 2606 OID 59299)
-- Name: tbl_ta_events tbl_ta_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tbl_ta_events
    ADD CONSTRAINT tbl_ta_events_pkey PRIMARY KEY (ta_event_id);


--
-- TOC entry 2213 (class 2606 OID 16849)
-- Name: tbl_tournament tbl_tournament_pk; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_tournament
    ADD CONSTRAINT tbl_tournament_pk PRIMARY KEY (tournament_id);


--
-- TOC entry 2258 (class 2606 OID 59486)
-- Name: tbl_ttt_events tbl_ttt_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tbl_ttt_events
    ADD CONSTRAINT tbl_ttt_events_pkey PRIMARY KEY (ttt_event_id);


--
-- TOC entry 2260 (class 2606 OID 59488)
-- Name: tbl_ttt_events ttt_event_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tbl_ttt_events
    ADD CONSTRAINT ttt_event_id UNIQUE (event_id);


--
-- TOC entry 2226 (class 2606 OID 16963)
-- Name: tbl_match unique; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_match
    ADD CONSTRAINT "unique" UNIQUE ("MatchDate", player1_id, player2_id);


--
-- TOC entry 2249 (class 2606 OID 34962)
-- Name: tbl_player unique_te_link; Type: CONSTRAINT; Schema: public; Owner: tennis
--

ALTER TABLE ONLY tbl_player
    ADD CONSTRAINT unique_te_link UNIQUE (te_link);


--
-- TOC entry 2220 (class 1259 OID 50609)
-- Name: idx_te_link; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX idx_te_link ON tbl_match USING btree (te_link);


--
-- TOC entry 2230 (class 1259 OID 17443)
-- Name: ix_tbl_sackmann_match_index; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX ix_tbl_sackmann_match_index ON tbl_sackmann_match USING btree (index);


--
-- TOC entry 2229 (class 1259 OID 17436)
-- Name: ix_tbl_sackmann_players_index; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX ix_tbl_sackmann_players_index ON tbl_sackmann_players USING btree (index);


--
-- TOC entry 2250 (class 1259 OID 50947)
-- Name: ix_tbl_te_matchdetails_index; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX ix_tbl_te_matchdetails_index ON tbl_te_matchdetails USING btree (index);


--
-- TOC entry 2252 (class 1259 OID 59181)
-- Name: ix_tbl_te_player_index; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX ix_tbl_te_player_index ON tbl_te_player USING btree (index);


--
-- TOC entry 2251 (class 1259 OID 50954)
-- Name: ix_tbl_te_ranking_index; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX ix_tbl_te_ranking_index ON tbl_te_ranking USING btree (index);


--
-- TOC entry 2234 (class 1259 OID 25486)
-- Name: ix_temp_ranking_SW1MALL_index; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX "ix_temp_ranking_SW1MALL_index" ON "temp_ranking_SW1MALL" USING btree (index);


--
-- TOC entry 2244 (class 1259 OID 34916)
-- Name: ix_temp_ranking_SW1YALL_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ix_temp_ranking_SW1YALL_index" ON "temp_ranking_SW1YALL" USING btree (index);


--
-- TOC entry 2233 (class 1259 OID 25477)
-- Name: ix_temp_ranking_SW1YC_index; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX "ix_temp_ranking_SW1YC_index" ON "temp_ranking_SW1YC" USING btree (index);


--
-- TOC entry 2232 (class 1259 OID 25473)
-- Name: ix_temp_ranking_SW1YG_index; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX "ix_temp_ranking_SW1YG_index" ON "temp_ranking_SW1YG" USING btree (index);


--
-- TOC entry 2231 (class 1259 OID 25469)
-- Name: ix_temp_ranking_SW1YH_index; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX "ix_temp_ranking_SW1YH_index" ON "temp_ranking_SW1YH" USING btree (index);


--
-- TOC entry 2245 (class 1259 OID 34920)
-- Name: ix_temp_ranking_SW3MALL_index; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX "ix_temp_ranking_SW3MALL_index" ON "temp_ranking_SW3MALL" USING btree (index);


--
-- TOC entry 2241 (class 1259 OID 25695)
-- Name: pin_player; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pin_player ON tbl_event_player USING hash (pin_player_name varchar_pattern_ops);


--
-- TOC entry 2221 (class 1259 OID 17227)
-- Name: pk_match_id; Type: INDEX; Schema: public; Owner: tennis
--

CREATE UNIQUE INDEX pk_match_id ON tbl_match USING btree (match_id);


--
-- TOC entry 2246 (class 1259 OID 34963)
-- Name: pk_player_id; Type: INDEX; Schema: public; Owner: tennis
--

CREATE UNIQUE INDEX pk_player_id ON tbl_player USING btree (player_id);


--
-- TOC entry 2222 (class 1259 OID 17229)
-- Name: player_week; Type: INDEX; Schema: public; Owner: tennis
--

CREATE INDEX player_week ON tbl_match USING btree (player1_id, player2_id, "MatchDateYearWeek");


--
-- TOC entry 2247 (class 1259 OID 34964)
-- Name: te_link; Type: INDEX; Schema: public; Owner: tennis
--

CREATE UNIQUE INDEX te_link ON tbl_player USING btree (te_link);


-- Completed on 2018-06-06 11:58:23

--
-- PostgreSQL database dump complete
--

