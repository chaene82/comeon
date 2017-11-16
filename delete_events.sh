#!/bin/bash

psql -h vbox0002 -U postgres -f /home/ubuntu/comeon/sql/delete_unmatched_events.sql
