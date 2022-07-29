#!/usr/bin/env bash

curl -i -L "http://mipt-master.atp-fivt.org:50070/webhdfs/v1${1}?op=OPEN&length=10" | tail -c 10

