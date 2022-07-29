ADD JAR /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;
ADD JAR /opt/cloudera/parcels/CDH/lib/hive/lib/hive-serde.jar;

USE rasolkoju;

SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.dynamic.partition=true;
SET hive.exec.max.dynamic.partitions=300;
SET hive.exec.max.dynamic.partitions.pernode=300;


DROP TABLE IF EXISTS Tmp;
CREATE EXTERNAL TABLE Tmp(
	domain_ip STRING, 
	request_time INT, 
	http_request STRING, 
	page_size SMALLINT,
	http_code SMALLINT, 
	info STRING)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES ("input.regex" = '^(\\S*)\\t{3}(\\d{8})\\S*\\s(\\S+)\\s(\\d+)\\s(\\d+)\\s(\\S+).*$')
STORED AS TEXTFILE
LOCATION '/data/user_logs/user_logs_M/';


DROP TABLE IF EXISTS Logs;

CREATE EXTERNAL TABLE Logs (
	domain_ip STRING, 
	http_request STRING, 
	page_size SMALLINT, 
	http_code SMALLINT, 
	info STRING)
PARTITIONED BY (request_time INT)
STORED AS TEXTFILE;

INSERT OVERWRITE TABLE Logs PARTITION (request_time)
SELECT domain_ip, http_request, page_size, http_code, info, request_time from Tmp;

SELECT * FROM Logs LIMIT 10;


DROP TABLE IF EXISTS Users;

CREATE EXTERNAL TABLE Users (	
	ip STRING, 
	browser STRING, 
	gender STRING, 
	age TINYINT)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES ("input.regex" = '^(\\S+)\\s(\\S+)\\s(\\S+)\\s(\\S+).*$')
STORED AS TEXTFILE
LOCATION '/data/user_logs/user_data_M/';

SELECT * FROM Users LIMIT 10;


DROP TABLE IF EXISTS IPRegions;

CREATE EXTERNAL TABLE IPRegions (
	ip STRING, 
	region STRING)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES ("input.regex" = '^(\\S+)\\s(\\S+).*$')
STORED AS TEXTFILE
LOCATION '/data/user_logs/ip_data_M/';

SELECT * FROM IPRegions LIMIT 10;


DROP TABLE IF EXISTS Subnets;

CREATE EXTERNAL TABLE Subnets (
	ip STRING, 
	subnet STRING)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES ("input.regex" = '^(\\S+)\\s(\\S+).*$')
STORED AS TEXTFILE
LOCATION '/data/subnets/variant1';

SELECT * FROM Subnets LIMIT 10;
