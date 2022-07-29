На вход скрипту подается имя файла, на выходе нужно получить первые 10 байт этого файла (hadoop fs -cat / head, tail и hdfs dfs -cat.. использовать нельзя)

	$ ./run.sh /data/access_logs/big_log/access.log.2015-12-10
	41.190.60.
