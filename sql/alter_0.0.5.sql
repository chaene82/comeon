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

-- DROP TABLE public.tbl_offer;

CREATE TABLE public.tbl_offer
(
    offer_id bigint NOT NULL default nextval('tbl_odds_odds_id_seq'::regclass),
    odds_id bigint,
    hedge_odds_id bigint,
    order_id bigint,
    odds numeric,
    turnover_eur numeric,
    turnover_local numeric,
    currency character varying(3) COLLATE pg_catalog."default",
    betdate timestamp with time zone,
    matchdate timestamp with time zone,
    status integer,
    update timestamp with time zone,
    CONSTRAINT tbl_offer_pkey PRIMARY KEY (offer_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.tbl_offer
    OWNER to tennis;
	

CREATE SEQUENCE public.tbl_offer_offer_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 99999999
    CACHE 1;

ALTER SEQUENCE public.tbl_offer_offer_id_seq
    OWNER TO tennis;
	

	

