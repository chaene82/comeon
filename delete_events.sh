#!/bin/bash

psql -h vbox0002 -U postgres -f sql/delete_unmatched_events.sql
