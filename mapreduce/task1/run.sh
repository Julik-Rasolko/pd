#!/usr/bin/env bash

NUM_REDUCERS=5
OUT_DIR="result"

hdfs dfs -rm -r -skipTrash $OUT_DIR* > /dev/null 

yarn jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
        -D mapreduce.job.name="mapreduce_task_1" \
        -D mapreduce.job.reduces=${NUM_REDUCERS} \
        -files mapper.py,reducer.py \
        -mapper "python3 ./mapper.py" \
        -reducer "python3 ./reducer.py" \
        -input /data/ids \
        -output $OUT_DIR > /dev/null

for i in `seq 0 $((NUM_REDUCERS-1))`
do
        hdfs dfs -cat ${OUT_DIR}/part-0000$i | head
done

