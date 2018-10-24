# Presto Performance Tuning
* https://support.treasuredata.com/hc/en-us/articles/360001450908-Presto-Performance-Tuning
* https://support.treasuredata.com/hc/ja/sections/360000302547-%E3%83%91%E3%83%95%E3%82%A9%E3%83%BC%E3%83%9E%E3%83%B3%E3%82%B9%E3%83%81%E3%83%A5%E3%83%BC%E3%83%8B%E3%83%B3%E3%82%B0Tips

```sql
# The last 7 days
[GOOD]: SELECT ... WHERE TD_INTERVAL(time, '-7d')
```

```sql
[GOOD]: SELECT GROUP BY uid, gender
[BAD]:  SELECT GROUP BY gender, uid
```

```sql
SELECT count(distinct id) FROM my_table

SELECT approx_distinct(id) FROM my_table

SELECT
  approx_distinct(user_id)
FROM
  access
WHERE
  TD_TIME_RANGE(time,
    TD_TIME_ADD(TD_SCHEDULED_TIME(), '-1d', 'PDT'),
    TD_SCHEDULED_TIME())
```

```sql
SELECT
  ...
FROM
  access
WHERE
  method LIKE '%GET%' OR
  method LIKE '%POST%' OR
  method LIKE '%PUT%' OR
  method LIKE '%DELETE%'
  

SELECT
  ...
FROM
  access
WHERE
  regexp_like(method, 'GET|POST|PUT|DELETE')
```

```sql
WITH tbl1 AS (SELECT a, MAX(b) AS b, MIN(c) AS c FROM tbl GROUP BY a),
     tbl2 AS (SELECT a, AVG(d) AS d FROM another_tbl GROUP BY a)
SELECT tbl1.*, tbl2.* FROM tbl1 JOIN tbl2 ON tbl1.a = tbl2.a
```


