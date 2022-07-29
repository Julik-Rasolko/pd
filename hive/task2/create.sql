ADD JAR /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;
ADD JAR /opt/cloudera/parcels/CDH/lib/hive/lib/hive-serde.jar;

USE rasolkoju;

SELECT info, count(request_time) AS cnt
FROM Logs GROUP BY info ORDER BY cnt DESC;
