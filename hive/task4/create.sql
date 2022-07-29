ADD JAR /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;
ADD FILE ./streaming.sh;
USE rasolkoju;

SELECT TRANSFORM(domain_ip, request_time, http_request, page_size, http_code, info) USING './streaming.sh'
FROM Logs LIMIT 10;

