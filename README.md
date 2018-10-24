# Supported Hive UDFs
https://support.treasuredata.com/hc/en-us/articles/360001450768-Supported-Hive-UDFs
```sql
SELECT ... WHERE TD_TIME_RANGE(time, '2013-01-01 PDT')
SELECT ... WHERE TD_TIME_RANGE(time, '2013-01-01', NULL, 'PDT')
```

```sql
SELECT td_client_id AS USER,
td_global_id AS G_USER,
TD_IP_TO_LATITUDE(td_ip) AS lat,
TD_IP_TO_LONGITUDE(td_ip) AS lng,
TD_IP_TO_COUNTRY_NAME(td_ip) as country,
TD_IP_TO_CITY_NAME(td_ip) AS city,
TD_IP_TO_CONNECTION_TYPE(td_ip) AS con_type
FROM pageviews
WHERE
TD_TIME_RANGE(time, TD_DATE_TRUNC('day', TD_TIME_ADD(TD_SCHEDULED_TIME(), '-120d', 'JST'), 'JST'),
TD_DATE_TRUNC('day', TD_SCHEDULED_TIME(), 'JST'), 'JST')
AND td_browser != 'Googlebot'
ORDER BY time DESC
```

```sql
SELECT
-- host as ip,
DISTINCT element_at(TD_PARSE_AGENT(agent) , 'category' ) AS category,
agent
FROM www_access
```

```sql
-- TD_PARSE_AGENT
SELECT
TD_PARSE_AGENT(agent) AS parsed_agent,
element_at(TD_PARSE_AGENT(agent) , 'os' ) AS os,
element_at(TD_PARSE_AGENT(agent) , 'vendor' ) AS vendor,
element_at(TD_PARSE_AGENT(agent) , 'os_version' ) AS os_version, 
element_at(TD_PARSE_AGENT(agent) , 'browser' ) AS name,
element_at(TD_PARSE_AGENT(agent) , 'category' ) AS category, 
element_at(TD_PARSE_AGENT(agent) , 'version' ) AS version
FROM www_access
```

```sql
WITH b AS (
  SELECT time, host, method
  FROM www_access
)

SELECT
  b.time,
  u.time,
  b.host,
  COUNT(b.time) as cnt
FROM 
  nasdaq as u
  LEFT JOIN b ON u.time = b.time
-- WHERE
--   b.method = 'GET'
GROUP BY 
  b.time, u.time, b.host
ORDER BY
  cnt
```

```sql
SELECT ... WHERE TD_TIME_RANGE(time,
                               TD_TIME_ADD(TD_SCHEDULED_TIME(), '-1d'),
                               TD_SCHEDULED_TIME())
```

```sql
SELECT TD_TIME_FORMAT(time, 'yyyy-MM-dd HH:mm:ss z') ... FROM ...
SELECT TD_TIME_FORMAT(time, 'yyyy-MM-dd HH:mm:ss z', 'PST') ... FROM ...
SELECT TD_TIME_FORMAT(time, 'yyyy-MM-dd HH:mm:ss z', 'JST') ... FROM ...
```

```sql
SELECT TD_DATE_TRUNC('day', time) FROM tbl
SELECT TD_DATE_TRUNC('day', time, 'PST') FROM tbl
```

```sql
os, os_family, os_major, os_minor, ua, ua_family, ua_major, ua_minor, device

SELECT TD_PARSE_USER_AGENT(agent) AS agent FROM www_access
> {"user_agent": {"family": "IE", "major": "9", "minor": "0", "patch": ""}, "os": {"family": "Windows 7", "major": "", "minor": "", "patch": "", "patch_minor": ""}, "device": {"family": "Other"}}
SELECT TD_PARSE_USER_AGENT(agent, 'os') AS agent_os FROM www_access
> {"family": "Windows 7", "major": "", "minor": "", "patch": "", "patch_minor": ""}
SELECT TD_PARSE_USER_AGENT(agent, 'os_family') AS agent_os_family FROM www_access
> Windows 7
```

```sql
SELECT TD_PARSE_AGENT(agent) AS parsed_agent, agent FROM www_access
> {"os":"Windows 7","vendor":"Google","os_version":"NT 6.1","name":"Chrome","category":"pc","version":"16.0.912.77"},
Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.77 Safari/535.7
SELECT TD_PARSE_AGENT(agent)['os'] AS os FROM www_access
> Windows 7 => os from user-agent, or carrier name of mobile phones
SELECT TD_PARSE_AGENT(agent)['vendor'] AS vendor FROM www_access
> Google // => name of vendor
SELECT TD_PARSE_AGENT(agent)['os_version'] AS os_version FROM www_access
> NT 6.1 // => "NT 6.3" (for Windows), "10.8.3" (for OSX), "8.0.1" (for iOS), ....
SELECT TD_PARSE_AGENT(agent)['name'] AS name FROM www_access
> Chrome // => name of browser (or string like name of user-agent)
SELECT TD_PARSE_AGENT(agent)['category'] AS category FROM www_access
> pc // => "pc", "smartphone", "mobilephone", "appliance", "crawler", "misc", "unknown"
SELECT TD_PARSE_AGENT(agent)['version'] AS version FROM www_access
> 16.0.912.77 => version of browser, or terminal type name of mobile phones
```

