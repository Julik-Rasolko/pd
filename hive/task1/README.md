**Задача 1 (411)**. Создайте внешние (EXTERNAL) таблицы по исходным данным. В результате будет 4 таблицы: логи пользователей, данные ip адресов, данные пользователей и подсети. Из таблицы логов перенесите данные в другую таблицу, партицированную по датам – одна партиция на каждый день. На партиционированных таблицах и нужно будет выполнять запросы в следующих задачах.

Требуется, чтобы сериализация и десериализация данных осуществлялась с использованием регулярных выражений (см. `org.apache.hadoop.hive.contrib.serde2.RegexSerDe`, `org.apache.hadoop.hive.serde2.RegexSerDe`).

Проверить правильность создания таблиц с помощью простейших запросов (`SELECT * FROM <table> LIMIT 10`). Эти Select запросы нужно также добавлять в скрипт задачи.

**Дополнительные требования:**
1. Название вашей базы данных должно совпадать с логином на **GitLab.atp-fivt.org** (например, **ivchenkoon**). 
2. Не добавляйте код создания базы в GitLab-репозиторий т.к. базы для вас уже созданы и система тестирования не имеет прав на перезаписть этих баз.
3. Таблицы должны называться так:
    * Logs - партиционированная таблица с логами.
    * Users - таблица с информацией о пользователях.
    * IPRegions - таблица с IP и регионами.
    * Subnets - таблица с подсетями для 4-й и 6-й задач

*Пример результата:*
```
33.49.147.163	http://lenta.ru/4303000	1189	451	Chrome/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0)n	20140101
75.208.40.166	http://newsru.com/3330815	60	306	Safari/5.0 (Windows; U; MSIE 9.0; Windows NT 8.1; Trident/5.0; .NET4.0E; en-AU)n	20140101


## Исходные данные: 

### I. Логи пользователей.

Данные находятся в HDFS по адресу `/data/user_logs/*_M`. Они состоят из трёх частей, каждая из которых находится в своей поддиректории. Данные в каждой части отличаются количеством и типом колонок, разделенных знаками табуляции ('\t') или пробелами.

#### А. Логи запросов пользователей к новостным сообщениям (user_logs).
1. Ip-адрес, с которого пришел запрос (STRING),
2. Время запроса (TIMESTAMP или INT),
3. Пришедший с ip-адреса http-запрос (STRING),
4. Размер переданной клиенту страницы (SMALLINT),
5. Http-статус код (SMALLINT).
6. Информация о клиентском приложении, с которого осуществлялся запрос на сервер, в том числе, информация о браузере (STRING).

**Важно:** информация о браузере содержится в начале 6-ого поля лога (символы с нулевой позиции до позиции первого пробельного символа), содержание оставшейся части строки не определяет браузер пользователя. Разделитель между IP и временем запроса имеет 3 табуляции.

#### B. Информация о пользователях (user_data).
1. IP-адрес (STRING),
2. Браузер пользователя (STRING),
3. Пол (STRING) //male, female,
4. Возраст (TINYINT).

#### С. Информация о местонахождении IP адресов пользователей (ip_data).
1. IP-адрес (STRING),
2. Регион (STRING).

### II. Подсети

Данные находятся по адресу /data/subnets. В директории 3 датасета (/data/subnets/variant[1-3], выберите соответствующий для своего варианта), но все они имеют одинаковый формат.

1. IP-адрес (STRING),
2. Маска подсети (STRING).

Датасеты в каждой директории отличаются 1-м полем.
* 1-й вариант. В качестве 1-го поля дан адрес сети.
* 2-й вариант. Адрес произвольного хоста в сети.
* 3-й вариант. Широковещательный адрес (broadcast).

Семплы находятся в `/data/subnets_S`. Если в полных данных 5000 записей, то в семплах всего 20.
