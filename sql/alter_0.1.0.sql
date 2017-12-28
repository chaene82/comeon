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

ALTER TABLE public.tbl_odds
    ALTER COLUMN betbtc_max_stake TYPE numeric ;
	
ALTER TABLE public.tbl_odds
    RENAME betbtc_max_stake TO max_stake;	
	

	

ALTER TABLE public.tbl_offer
    ADD COLUMN bookie_bet_id bigint;

ALTER TABLE public.tbl_offer
    ADD COLUMN hedge_stakes numeric;

ALTER TABLE public.tbl_offer
    ADD COLUMN hedge_odds numeric;