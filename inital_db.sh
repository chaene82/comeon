#!/bin/bash

psql -h localhost -p 5433 -U postgres -f sql/create_database.sql
psql -h localhost -p 5433 -U postgres -f sql/tbl_bookie.sql
