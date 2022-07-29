#!/usr/bin/env bash

hdfs fsck $1 -files -blocks -locations | grep -E -o "[[:digit:]]{1} block" | head -c 1

