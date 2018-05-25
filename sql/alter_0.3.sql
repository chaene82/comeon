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

\connect tennis


CREATE SEQUENCE public.tbl_ttt_events_event_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.tbl_ttt_events_event_id_seq
    OWNER TO tennis;

CREATE TABLE public.tbl_ttt_events
(
    ttt_event_id bigint NOT NULL DEFAULT nextval('tbl_ttt_events_event_id_seq'::regclass),
    event_id bigint,
    home_player_id bigint,
    home_player_name varchar,
    away_player_id bigint,
    away_player_name varchar,
    winner_player_id bigint, 
    winner_name varchar,
    winner_proba numeric,
    ttt_tournament character varying COLLATE pg_catalog."default",
    update timestamp with time zone,
    CONSTRAINT tbl_ttt_events_pkey PRIMARY KEY (ttt_event_id),
    CONSTRAINT ttt_event_id UNIQUE (event_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.tbl_ta_events
    OWNER to tennis

CREATE OR REPLACE VIEW public.v_ta_next_events
    WITH (security_barrier=false)
    AS
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
   FROM tbl_events e
     JOIN tbl_event_player h ON e.home_player_id = h.event_player_id
     JOIN tbl_event_player a ON e.away_player_id = a.event_player_id
     JOIN tbl_ta_events ta ON e.event_id = ta.event_id
     JOIN tbl_odds oh ON e.event_id = oh.event_id
     JOIN tbl_odds oa ON e.event_id = oa.event_id
  WHERE e."StartDateTime" >= now() AND e."StartDateTime" <= (now() + '02:00:00'::interval) AND oh.bookie_id = 1 AND oh.way = 1 AND oa.bookie_id = 1 AND oa.way = 2 AND NOT ta.ta_tournament::text ~~ '%Challenger%'::text AND NOT (oh.odds_id IN ( SELECT tbl_orderbook.odds_id 
           FROM tbl_orderbook WHERE product_id = 5)) AND NOT (oa.odds_id IN ( SELECT tbl_orderbook.odds_id
           FROM tbl_orderbook WHERE product_id = 5));

CREATE OR REPLACE VIEW public.v_ttt_next_events AS
SELECT e.event_id,
    e."StartDateTime",
    e.home_player_id,
    p.pin_player_name AS home_player_name,
    ttt.winner_player_id,
    ttt.winner_proba,
    o.odds AS winner_odds,
    o.odds_id AS winner_odds_id
   FROM tbl_events e
     JOIN tbl_ttt_events ttt ON e.event_id = ttt.event_id
     JOIN tbl_event_player p ON ttt.winner_player_id = p.event_player_id
     JOIN tbl_odds o ON (e.event_id = o.event_id and ttt.way = o.way)
  WHERE e."StartDateTime" >= now() AND e."StartDateTime" <= (now() + '02:00:00'::interval) AND o.bookie_id = 1 AND NOT (o.odds_id IN ( SELECT tbl_orderbook.odds_id
           FROM tbl_orderbook
          WHERE tbl_orderbook.product_id = 7));
          	

