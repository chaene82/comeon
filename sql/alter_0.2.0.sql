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

ALTER TABLE public.tbl_events
    RENAME "Home_player_id" TO home_player_id;
	
	
CREATE TABLE public.tbl_event_player
(
    event_player_id bigint NOT NULL,
    pin_player_name character varying(100),
    betbtc_player_name character varying(100),
    matchbook_player_name character varying(100),
    betdaq_player_name character varying(100),
    betfair_player_name character varying(100),
    PRIMARY KEY (event_player_id)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE public.tbl_event_player
    OWNER to postgres;	
	
CREATE SEQUENCE public.tbl_event_player_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.tbl_event_player_id_seq
    OWNER TO tennis;	

ALTER TABLE public.tbl_event_player
    ALTER COLUMN event_player_id SET DEFAULT nextval('tbl_event_player_id_seq'::regclass);	
	
CREATE INDEX pin_player
    ON public.tbl_event_player USING hash
    (pin_player_name varchar_pattern_ops)
    TABLESPACE pg_default;	
	
	
ALTER TABLE public.tbl_match
    ADD COLUMN player1_fair_odds numeric;

ALTER TABLE public.tbl_match
    ADD COLUMN player2_fair_odds numeric;

ALTER TABLE public.tbl_match
    ADD COLUMN player1_proba numeric;

ALTER TABLE public.tbl_match
    ADD COLUMN player2_proba numeric;	
	
ALTER TABLE public.tbl_events
	DROP CONSTRAINT match;

	
ALTER TABLE public.tbl_events
    ADD CONSTRAINT match UNIQUE ("StartDate", home_player_id, away_player_id);