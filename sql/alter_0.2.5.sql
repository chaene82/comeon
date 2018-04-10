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

CREATE SEQUENCE public.tbl_ta_events_event_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.tbl_ta_events_event_id_seq
    OWNER TO tennis;
	
	
-- Table: public.tbl_ta_events

-- DROP TABLE public.tbl_ta_events;

CREATE TABLE public.tbl_ta_events
(
    ta_event_id bigint NOT NULL DEFAULT nextval('tbl_ta_events_event_id_seq'::regclass),
    event_id bigint,
    home_player_id bigint,
    home_player_proba numeric,
    away_player_id bigint,
    away_player_proba numeric,
    ta_tournament character varying COLLATE pg_catalog."default",
	CONSTRAINT event_id UNIQUE (event_id),
    CONSTRAINT tbl_ta_events_pkey PRIMARY KEY (ta_event_id)


)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.tbl_ta_events
    OWNER to postgres;	
	
ALTER TABLE public.tbl_ta_events
    ADD COLUMN update timestamp with time zone;	