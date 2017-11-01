#!/bin/bash

psql -h vbox0002 -U postgres -f sql/create_database.sql
psql -h vbox0002 -U postgres -f sql/tbl_bookie.sql