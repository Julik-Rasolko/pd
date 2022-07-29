#!/usr/bin/env bash

hdfs fsck $1 -files -blocks -locations | grep -E -o 'DatanodeInfoWithStorage\[[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}' | head -1 | grep -E -o '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}'



