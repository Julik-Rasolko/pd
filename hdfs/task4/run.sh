#!/usr/bin/env bash

node=$(hdfs fsck -blockId $1 | grep -E -o "mipt-node.*/default" | tail -1 | head -c -9)
loc=$(sudo -u hdfsuser ssh hdfsuser@${node} find /dfs -name $1)
echo "${node}:${loc}"

