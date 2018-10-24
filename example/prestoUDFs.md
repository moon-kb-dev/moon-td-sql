# Supported Presto and TD Functions
https://support.treasuredata.com/hc/en-us/articles/360001450828-Supported-Presto-UDFs
```sql
SELECT ... WHERE TD_TIME_RANGE(time, '2013-01-01 PDT')                 # OK
SELECT ... WHERE TD_TIME_RANGE(time, '2013-01-01', '2013-01-02','PDT') # OK
SELECT ... WHERE TD_TIME_RANGE(time, NULL, '2013-01-01', 'PDT')        # OK
SELECT ... WHERE TD_TIME_RANGE(time, '2013-01-01', NULL, 'PDT')        # OK
SELECT ... WHERE TD_TIME_RANGE(time, '2013-01-01', 'PDT')              # NG
```

```sql
# The last 7 days [2018-08-07 00:00:00, 2018-08-14 00:00:00)
SELECT  ... WHERE TD_INTERVAL(time, '-7d')
# The last week. Monday is the beginning of the week (ISO standard) [2018-08-05 00:00:00, 2018-08-13 00:00:00)
SELECT  ... WHERE TD_INTERVAL(time, '-1w')
# Today [2018-08-14 00:00:00, 2018-08-15 00:00:00)
SELECT  ... WHERE TD_INTERVAL(time, '1d')
# The last month [2018-07-01 00:00:00, 2018-08-01 00:00:00)
SELECT  ... WHERE TD_INTERVAL(time, '-1M')
# This month [2018-08-01 00:00:00, 2018-09-01 00:00:00)
SELECT  ... WHERE TD_INTERVAL(time, '1M')
# This year [2018-01-01 00:00:00, 2019-01-01 00:00:00)
SELECT  ... WHERE TD_INTERVAL(time, '1y')
# The last 15 minutes [2018-08-14 00:08:00, 2018-08-14 01:23:00)
SELECT  ... WHERE TD_INTERVAL(time, '-15m')
# The last 30 seconds [2018-08-14 01:23:15, 2018-08-14 01:23:45)
SELECT  ... WHERE TD_INTERVAL(time, '-30s')
# The last hour [2018-08-14 00:00:00, 2018-08-14 01:00:00)
SELECT  ... WHERE TD_INTERVAL(time, '-1h')
# From the last hour to now [2018-08-14 00:00:00, 2018-08-14 01:23:45)
SELECT  ... WHERE TD_INTERVAL(time, '-1h/now')
# The last hour since the beginning of today [2018-08-13 23:00:00, 2018-08-14 00:00:00)
SELECT  ... WHERE TD_INTERVAL(time, '-1h/0d')
# The last 7 days since 2015-12-25 [2015-12-18 00:00:00, 2015-12-25 00:00:00)
SELECT  ... WHERE TD_INTERVAL(time, '-7d/2015-12-25')
# The last 10 days since the beginning of the last month [2018-06-21 00:00:00, 2018-07-01 00:00:00)
SELECT  ... WHERE TD_INTERVAL(time, '-10d/-1M')
# The last 7 days in JST
SELECT  ... WHERE TD_INTERVAL(time, '-7d', 'JST')
```

```sql
SELECT ... WHERE TD_TIME_RANGE(time,
                               '2013-01-01',
                               TD_TIME_ADD('2013-01-01', '1d'))
```

```sql
os, os_family, os_major, os_minor, ua, ua_family, ua_major, ua_minor, device

SELECT TD_PARSE_USER_AGENT(agent) AS agent FROM www_access
> {user_agent: {family: "IE", major: "9", minor: "0", patch: null}, os: {family: "Windows 7", major: null, minor: null, patch: null, patch_minor: null}, device: {family: "Other"}}
SELECT TD_PARSE_USER_AGENT(agent, 'os') AS agent_os FROM www_access
> {family: "Windows 7", major: null, minor: null, patch: null, patch_minor: null}
SELECT TD_PARSE_USER_AGENT(agent, 'os_family') AS agent_os_family FROM www_access
> Windows 7
```

```sql
SELECT TD_PARSE_AGENT(agent) AS parsed_agent, agent FROM www_access
> {"os":"Windows 7","vendor":"Google","os_version":"NT 6.1","name":"Chrome","category":"pc","version":"16.0.912.77"},
Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.77 Safari/535.7

SELECT element_at(TD_PARSE_AGENT(agent), 'os') AS os FROM www_access
> Windows 7 => os from user-agent, or carrier name of mobile phones

SELECT element_at(TD_PARSE_AGENT(agent), 'vendor') AS vendor FROM www_access
> Google // => name of vendor

SELECT element_at(TD_PARSE_AGENT(agent), 'os_version') AS os_version FROM www_access
> NT 6.1 // => "NT 6.3" (for Windows), "10.8.3" (for OSX), "8.0.1" (for iOS), ....

SELECT element_at(TD_PARSE_AGENT(agent), 'name') AS name FROM www_access
> Chrome // => name of browser (or string like name of user-agent)

SELECT element_at(TD_PARSE_AGENT(agent), 'category') AS category FROM www_access
> pc // => "pc", "smartphone", "mobilephone", "appliance", "crawler", "misc", "unknown"

SELECT element_at(TD_PARSE_AGENT(agent), 'version') AS version FROM www_access
> 16.0.912.77 => version of browser, or terminal type name of mobile phones

SELECT TD_PARSE_AGENT(agent)['nonexistentkey'] FROM www_access
! The *query errors out* because the <tt>nonexistentkey</tt> key is not present
! in the map returned by <tt>TD_PARSE_AGENT(agent)</tt>.
```

